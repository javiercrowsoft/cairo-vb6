/*
  Facturas con mas de 30 dias de vencidas
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ALR_DC_CSC_STK_0010_M]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ALR_DC_CSC_STK_0010_M]
go

/*

  ALR_DC_CSC_STK_0010_M

  select * from alarmamailstock
 
*/

create procedure ALR_DC_CSC_STK_0010_M 

as 
begin

  set nocount on

  declare @alm_id int
  set @alm_id = 3

  declare @ultimo_aviso   datetime

  set @ultimo_aviso = dateadd(d,-1,getdate())

  declare @offset_inicio     int set @offset_inicio   = 10000000
  declare @offset_inicio_e   int set @offset_inicio_e = 11000000

  --////////////////////////////////////////////////////////////////////////////////

    declare @cfg_valor varchar(255)

    -- Tengo que validar segun lo que indique la configuracion de stock
    exec sp_Cfg_GetValor  'Stock-General',
                          'Tipo Control Stock',
                          @cfg_valor out,
                          0
    set @cfg_valor = IsNull(@cfg_valor,0)

    declare @bStockFisico tinyint

    if convert(int,@cfg_valor) = 4 set @bStockFisico = 1
    else                           set @bStockFisico = 0
  
  --////////////////////////////////////////////////////////////////////////////////

  create table #t_alr_dc_csc_stk_0010_stock (almr_id_mail  int not null,
                                              pr_id         int not null, 
                                              depl_id       int null, 
                                              depf_id       int null, 
                                              reposicion     decimal(18,2) not null default(0),
                                              stock         decimal(18,2) not null default(0), 
                                              pedidos        decimal(18,2) not null default(0))

  /*
    Por cada articulo con punto de reposicion > 0 voy a ver cuanto stock tiene
    y si esta por debajo del minimo lo agrego al mail de notificacion
  */

  declare c_productos insensitive cursor for 

      select   pr_id,
              pr_reposicion,
              null as depl_id,
              null as depf_id

      from Producto
      where pr_reposicion > 0

      union

      select  pr_id,
              prdepl_reposicion,
              depl_id,
              null as depf_id

      from ProductoDepositoLogico
      where  prdepl_reposicion > 0

      union

      select  pr_id,
              prdepf_reposicion,
              null as depl_id,
              depf_id

      from ProductoDepositoFisico
      where  prdepf_reposicion > 0

  declare @pr_id       int
  declare @reposicion decimal(18,6)
  declare @depl_id    int
  declare @depf_id    int

  declare @almr_id_mail     int
  declare @depf_id_logico   int
  declare @stock            decimal(18,6)
  declare @cantidad_pedida   decimal(18,6)

  open c_productos

  fetch next from c_productos into @pr_id, @reposicion, @depl_id, @depf_id
  while @@fetch_status=0
  begin

    set @cantidad_pedida = 0
    set @stock           = 0

    if isnull(@depl_id,0) <> 0 begin

      -- Obtengo el stock para este producto y deposito
      if @bStockFisico <> 0 begin
    
        select @depf_id_logico = depf_id from DepositoLogico where depl_id = @depl_id

        select @stock = sum(stc_cantidad) 
        from StockCache s
        where pr_id = @pr_id
          and  exists(select *
                      from DepositoLogico
                      where depf_id = @depf_id_logico
                        and depl_id = s.depl_id
                     )
  
      end else begin

        select @stock = sum(stc_cantidad) 
        from StockCache s
        where pr_id   = @pr_id
          and depl_id = @depl_id
      end

    end else begin

      if isnull(@depf_id,0) <> 0 begin

        select @stock = sum(stc_cantidad) 
        from StockCache s
        where pr_id = @pr_id
          and  exists(select *
                      from DepositoLogico
                      where depf_id = @depf_id
                        and depl_id = s.depl_id
                     )        

      end else begin

        select @stock = sum(stc_cantidad) 
        from StockCache s
        where pr_id   = @pr_id

      end

    end
  
    select @cantidad_pedida = sum(pvi_pendiente)
    from PedidoVentaItemStock
    where pr_id = @pr_id

    set @cantidad_pedida = isnull(@cantidad_pedida,0)

    -- Si es menor al punto de reposicion lo agrego a la tabla

    if @stock < @reposicion begin

      if @almr_id_mail is null begin

        exec sp_dbgetnewid2 'AlarmaMailStock','almr_id_mail',@offset_inicio, @offset_inicio_e, @almr_id_mail out, 0

      end

      insert into #t_alr_dc_csc_stk_0010_stock (almr_id_mail, pr_id, depl_id, depf_id, stock, reposicion, pedidos)
                                        values  (@almr_id_mail, @pr_id, @depl_id, @depf_id, @stock, @reposicion, @cantidad_pedida)

    end

    fetch next from c_productos into @pr_id, @reposicion, @depl_id, @depf_id
  end  
  close c_productos
  deallocate c_productos

  -- Voy a armar un unico mail con todos los articulos
  --
  create table #t_alr_dc_csc_stk_0010_stock_mail (mail text not null)

  insert into #t_alr_dc_csc_stk_0010_stock_mail values ('')

  declare @ptrval binary(16)
  declare @msg  varchar(1000)
  
  select @ptrval = textptr(mail) from #t_alr_dc_csc_stk_0010_stock_mail

  -- Creo un cursor con todos los articulos que estan por debajo del punto de reposicion
  --
  declare c_items insensitive cursor for

    select 
           'El producto ' + pr_nombrecompra
         + ' en ' + case when depl_nombre is not null then 'el deposito logico '+ depl_nombre 
                         when depf_nombre is not null then 'el deposito fisico '+ depf_nombre
                         else                              'la empesa'
                    end
         + ' posee un stock de ' + convert(varchar(255),stock)
         + ' y el punto de resposicion es ' + convert(varchar(255),reposicion)
         + ' y existen pedidos pendientes por ' + convert(varchar(255),pedidos) + ' (' + isnull(un_codigo,'') + ').'

                          as msg
          
    from #t_alr_dc_csc_stk_0010_stock t 
                  inner join producto pr            on t.pr_id     = pr.pr_id
                  left  join depositologico depl    on t.depl_id   = depl.depl_id
                  left  join depositofisico depf    on t.depf_id   = depf.depf_id
                  left  join unidad un              on pr.un_id_stock  = un.un_id
    where 
      not exists (select * 
                  from AlarmaMailResult a 
                        inner join alarmamailstock almst  
                            on   t.pr_id   = almst.pr_id
                            and isnull(t.depl_id,0) = isnull(almst.depl_id,0)
                            and isnull(t.depf_id,0) = isnull(almst.depf_id,0)
                            and almst.almst_fecha > @ultimo_aviso
                            and a.alm_id = @alm_id 
                            and a.almr_id_mail = almst.almr_id_mail
                  )

  open c_items

  fetch next from c_items into @msg  
  while @@fetch_status=0
  begin

    set @msg = @msg + char(10) + char(13)

    updatetext #t_alr_dc_csc_stk_0010_stock_mail.mail @ptrval null 0 @msg

    fetch next from c_items into @msg
  end

  close c_items
  deallocate c_items

  -- Registro que ya notifique estos productos
  --
  insert into alarmamailstock (almr_id_mail, almst_fecha, pr_id, depl_id, depf_id)
    select almr_id_mail, getdate(), pr_id, depl_id, depf_id
    from #t_alr_dc_csc_stk_0010_stock

  -- Obtengo la direccion de email
  --
  declare @mail_emailTo    varchar(1000)
  declare @mail_emailCc   varchar(1000)
  declare @mail_id        int
  
  select @mail_emailTo = alm_mails from AlarmaMail where alm_id = @alm_id

  if exists(select * from Mail where mail_codigo = @mail_emailTo) begin

    select  @mail_emailTo = mail_emailTo,
            @mail_emailCc = mail_emailCc,
            @mail_id      = mail_id
    from Mail
    where mail_codigo = @mail_emailTo

  end

  -- Devuelvo el email
  --
  select top 1 
        @almr_id_mail as almr_id_mail,
        @mail_id      as mail_id,
        null          as maili_id,
        @mail_emailTo as mail_emailTo,
        @mail_emailCc as mail_emailCc,
        'Artículos con stock por debajo del punto de reposición'          
                      as almr_subject,
        mail          as msg

  from   #t_alr_dc_csc_stk_0010_stock_mail
  where @almr_id_mail is not null

end

go