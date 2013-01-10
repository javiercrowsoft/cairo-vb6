if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockCompensar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockCompensar]

GO

/*

Proposito: Compensar el stock de numeros de serie que se han movido desde
           un deposito donde no estaban y han quedado en -1.
           El sp detecta donde hay stock del numero de serie y lo mueve
           al deposito con faltante.

select * from rama where ram_nombre like '%cilbras%'
select pr_id,pr_nombrecompra from producto where pr_nombrecompra like '%ThinkPad G41-28814FU%'

select * from documento where doc_nombre like '%trans%'

sp_DocStockCompensar 
                      1,
                      '107',
                      35,
                      1,
                      '20051001',
                      1

*/

create procedure sp_DocStockCompensar (
  @@us_id            int,
  @@pr_id           varchar(255),
  @@doc_id          int,
  @@suc_id          int,
  @@st_fecha        datetime,
  @@noTransferir    smallint 
)as 

begin

set nocount on

declare @controlastock varchar(5000)

exec sp_Cfg_GetValor 'Stock-General','Tipo Control Stock',@controlastock out, 0

declare @pr_id int

declare @ram_id_Producto int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto out

exec sp_GetRptId @clienteID out

if @ram_id_Producto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
  end else 
    set @ram_id_Producto = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

  declare @prns_id           int
  declare @depl_id_origen   int
  declare @depl_id_destino   int

  create table #sp_DocStockCompensar (id                int,
                                      cantidad           decimal(18,6),
                                      pr_id             int,
                                      prns_id           int, 
                                      depl_id_origen     int, 
                                      depl_id_destino   int
                                      )

  create table #sp_DocStockCompensar_origen  (depl_id int)
  create table #sp_DocStockCompensar_destino (depl_id int)

  declare c_prns insensitive cursor 

  for

  select 
          prns_id, 
          pr.pr_id

  from ProductoNumeroSerie prns inner join Producto pr on prns.pr_id = pr.pr_id and pr_eskit = 0
  where 
          (prns.pr_id  = @pr_id or @pr_id = 0)
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 30 
                      and  rptarb_hojaid = prns.pr_id
                     ) 
               )
            or 
               (@ram_id_Producto = 0)
           )

    and  exists 
      (
        select sti1.depl_id 
        from StockItem sti1 inner join DepositoLogico depl on sti1.depl_id = depl.depl_id
        where 
              sti1.prns_id = prns.prns_id
          and sti1.depl_id not in (-2,-3)      
          and sti1.stik_id is null        
        group by sti1.depl_id
        having sum(sti_salida) <> (select sum(sti_ingreso)
                                   from StockItem sti2
                                   where sti2.prns_id = prns.prns_id
                                     and sti_ingreso <> 0
                                     and sti2.depl_id = sti1.depl_id
                                     and sti2.stik_id is null
                                   group by sti2.depl_id
                                   )
      )

   open c_prns

  declare @id int
  set @id=0

  fetch next from c_prns into @prns_id, @pr_id
  while @@fetch_status=0
  begin

    delete #sp_DocStockCompensar_origen
    delete #sp_DocStockCompensar_destino

    insert into #sp_DocStockCompensar_origen (depl_id) 
    select depl_id from StockItem where prns_id = @prns_id and depl_id not in (-2,-3) 
    group by depl_id having sum(sti_ingreso-sti_salida) > 0      
        
    insert into #sp_DocStockCompensar_destino (depl_id) 
    select depl_id from StockItem where prns_id = @prns_id and depl_id not in (-2,-3) 
    group by depl_id having sum(sti_ingreso-sti_salida) < 0

    while exists(select * from #sp_DocStockCompensar_origen)
    begin

      select top 1 @depl_id_origen  = depl_id from #sp_DocStockCompensar_origen
      select top 1 @depl_id_destino = depl_id from #sp_DocStockCompensar_destino

      delete #sp_DocStockCompensar_origen    where depl_id = @depl_id_origen
      delete #sp_DocStockCompensar_destino  where depl_id = @depl_id_destino

      set @id = @id +1

      if @depl_id_origen is not null and @depl_id_destino is not null begin
    
        insert into #sp_DocStockCompensar(id,  cantidad, pr_id,  prns_id,  depl_id_origen,  depl_id_destino)
                                  values (@id, 1,        @pr_id, @prns_id, @depl_id_origen, @depl_id_destino)
      end
    end

    fetch next from c_prns into @prns_id, @pr_id
  end

   close c_prns
  deallocate c_prns

  select   prns.pr_id,
          pr_nombrecompra    as Articulo,
          pr_codigo          as Codigo,
          prns_codigo        as [Numero de Serie],
          do.depl_nombre    as Origen,
          dd.depl_nombre    as Destino

  from #sp_DocStockCompensar st inner join ProductoNumeroSerie prns on st.prns_id         = prns.prns_id
                                inner join DepositoLogico do        on st.depl_id_origen   = do.depl_id
                                inner join DepositoLogico dd        on st.depl_id_destino  = dd.depl_id
                                inner join Producto pr              on prns.pr_id         = pr.pr_id
  order by Origen

  if @@noTransferir <> 0 goto Fin2

  exec sp_Cfg_SetValor 'Stock-General','Tipo Control Stock','2'

  declare c_compensar insensitive cursor for 
  select depl_id_origen, depl_id_destino
  from #sp_DocStockCompensar
  group by depl_id_origen, depl_id_destino

  declare @MsgError varchar(255)
  declare @bError   smallint

  open c_compensar

  fetch next from c_compensar into @depl_id_origen, @depl_id_destino
  while @@fetch_status=0
  begin

    while exists (select * from #sp_DocStockCompensar where depl_id_origen = @depl_id_origen)
    begin
  
      exec sp_DocStockCompensarSave 
                                      @@us_id,
                                      @depl_id_origen,
                                      @depl_id_destino,
                                      @@doc_id,
                                      @@suc_id,
                                      @@st_fecha,
                                      0,
                                      @bError out,
                                      @MsgError out
      if IsNull(@bError,0) <> 0 goto Validate

    end

    fetch next from c_compensar into @depl_id_origen, @depl_id_destino
  end

  goto fin
Validate:

  if @@trancount>0 rollback

  set @MsgError = '@@ERROR_SP:' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

Fin:

  exec sp_Cfg_SetValor 'Stock-General','Tipo Control Stock',@controlastock

  close c_compensar
  deallocate c_compensar

Fin2:

end

GO