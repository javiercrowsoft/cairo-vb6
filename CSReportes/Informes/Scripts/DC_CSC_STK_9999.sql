/*---------------------------------------------------------------------
Nombre: Historia de movimientos de numeros de serie
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_9999]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_9999]

/*

 select * from TmpStringToTable

 DC_CSC_STK_9999 1,'', 'e10452,e10453,e10454,e10455,e10456,e10457,e10458,e10459'

 DC_CSC_STK_9999 1, '2739696'

*/

go
create procedure DC_CSC_STK_9999 (

  @@us_id          int,
  @@pr_id          varchar(5000) = 0,
  @@prns_codigo    varchar(5000) = '',
  @@depl_id        varchar(255)  = '0',
  @@soloenempresa  smallint = 0
)as 
begin
set nocount on

-- exec sp_docstockcachecreate

declare @pr_id       int
declare @prns_id     int
declare @depl_id     int

declare @ram_id_DepositoLogico int
declare @ram_id_Producto int
    
declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto out
exec sp_ArbConvertId @@depl_id, @depl_id out, @ram_id_DepositoLogico out

exec sp_GetRptId @clienteID out

if @ram_id_Producto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
  end else 
    set @ram_id_Producto = 0
end

if @ram_id_DepositoLogico <> 0 begin

--  exec sp_ArbGetGroups @ram_id_DepositoLogico, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_DepositoLogico, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_DepositoLogico, @clienteID 
  end else 
    set @ram_id_DepositoLogico = 0
end

----------------------------------------------------------------------------------------

if @@prns_codigo <> '' begin

  declare @codigo datetime set @codigo = getdate()
  declare @nro    varchar(255)
  declare @prefix varchar(255)


  if charindex('***',@@prns_codigo,1)<>0 begin

    declare @n int
    declare @i int

    declare @n1 int set @n1 = charindex('***',@@prns_codigo,1)
    declare @n2 int set @n2 = charindex('***',@@prns_codigo,@n1+3)

    set @prefix = substring(@@prns_codigo,1,@n1-1)

    set @i = substring(@@prns_codigo, 
                        @n1+3,
                        @n2-@n1-3)
    set @n = substring(@@prns_codigo, @n2+3,100)

    while @i < @n begin

      set @nro = @prefix + convert(varchar,@i)
  
      insert into TmpStringToTable (tmpstr2tbl_id, tmpstr2tbl_campo) values (@codigo, @nro)

      set @i = @i+1
    end    

  end else begin
    
    exec sp_strStringToTable @codigo, @@prns_codigo, ','

  end

  declare c_prns_pr insensitive cursor for 
    select distinct pr_id,prns_id from ProductoNumeroSerie 
    where prns_codigo in (select tmpstr2tbl_campo from TmpStringToTable where tmpstr2tbl_id = @codigo)
      -- Arboles
        and (pr_id = @pr_id or pr_id_kit = @pr_id or @pr_id = 0)
        and  (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 30
                        and  (rptarb_hojaid = pr_id or rptarb_hojaid = pr_id_kit)
                       ) 
                 )
              or 
                 (@ram_id_Producto = 0)
             )
  
  open c_prns_pr
  
  fetch next from c_prns_pr into @pr_id, @prns_id
  while @@fetch_status = 0
  begin
  
    exec sp_DocStockNroSerieValidate @pr_id, @prns_id
    fetch next from c_prns_pr into @pr_id, @prns_id
  end
  
  close c_prns_pr
  deallocate c_prns_pr
  
  declare c_prns_pr insensitive cursor for 
    select distinct prns_id from ProductoNumeroSerie 
    where prns_codigo in (select tmpstr2tbl_campo from TmpStringToTable where tmpstr2tbl_id = @codigo)
  
  open c_prns_pr
  
  fetch next from c_prns_pr into @prns_id
  while @@fetch_status = 0
  begin
  
    exec sp_StockNroSerieClienteProveedor @prns_id
    fetch next from c_prns_pr into @prns_id
  end
  
  close c_prns_pr
  deallocate c_prns_pr

  select 1, 'Se valido el Stock para los siguientes numeros de serie' as Resultado, ' '
  union
  select distinct 2, prns_codigo as Resultado, ' '
  from ProductoNumeroSerie 
  where prns_codigo in (select tmpstr2tbl_campo from TmpStringToTable where tmpstr2tbl_id = @codigo)
  union
  select 3, 'Y para los siguientes productos'  as Resultado, ' '
  union
  select distinct 4, pr_nombrecompra  as Resultado, ' '
  from ProductoNumeroSerie prns inner join Producto p on prns.pr_id = p.pr_id
  where prns_codigo in (select tmpstr2tbl_campo from TmpStringToTable where tmpstr2tbl_id = @codigo)
  order by 1

end else begin

  if @@pr_id <> '0' or @@depl_id <> '0' begin

    --///////////////////////////////////////////////////////////////////////////////////////////////////////////
    

      declare c_pr insensitive cursor for 
      select distinct pr_id from ProductoNumeroSerie prns
      -- Arboles
      where (pr_id = @pr_id or pr_id_kit = @pr_id or @pr_id = 0)
        and (depl_id = @depl_id or @depl_id=0)

        and  (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 30
                        and  (rptarb_hojaid = pr_id or rptarb_hojaid = pr_id_kit)
                       ) 
                 )
              or 
                 (@ram_id_Producto = 0)
             )
        
        and (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 11 
                        and  rptarb_hojaid = depl_id
                       ) 
                 )
              or 
                 (@ram_id_DepositoLogico = 0)
             )

        and (     @@soloenempresa = 0
              or  exists(
                          select prns_id
                          from StockItem 
                          where depl_id not in (-2,-3) 
                            and prns_id = prns.prns_id
                          group by prns_id 
                          having sum(sti_ingreso-sti_salida) <> 0
                        )
            )

      
      open c_pr
      
      fetch next from c_pr into @pr_id
      while @@fetch_status = 0
      begin
      
        exec sp_DocStockNroSerieValidate @pr_id
        fetch next from c_pr into @pr_id
      end
      
      close c_pr
      deallocate c_pr
      
      declare c_prns insensitive cursor for 
      select prns_id from ProductoNumeroSerie
      -- Arboles
      where (pr_id = @pr_id or pr_id_kit = @pr_id or @pr_id = 0)
        and (depl_id = @depl_id or @depl_id=0)

        and  (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 30
                        and  (rptarb_hojaid = pr_id or rptarb_hojaid = pr_id_kit)
                       ) 
                 )
              or 
                 (@ram_id_Producto = 0)
             )

        and (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 11 
                        and  rptarb_hojaid = depl_id
                       ) 
                 )
              or 
                 (@ram_id_DepositoLogico = 0)
             )
      
      open c_prns
      
      fetch next from c_prns into @prns_id
      while @@fetch_status = 0
      begin
      
        exec sp_StockNroSerieClienteProveedor @prns_id
        fetch next from c_prns into @prns_id
      end
      
      close c_prns
      deallocate c_prns
    
      select 1, '' as Tipo, 'Se valido el stock para los siguientes productos y depositos'  as Resultado, ' '
      union
      select pr_id, 'Producto' as Tipo, pr_nombrecompra  as Resultado, ' '
      from Producto
      where (pr_id = @pr_id or @pr_id = 0)
        and  (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 30
                        and  (rptarb_hojaid = pr_id)
                       ) 
                 )
              or 
                 (@ram_id_Producto = 0)
             )

      union all

      select depl_id, 'Deposito' as Tipo, depl_nombre as Resultado, ' '
      from DepositoLogico
      where (depl_id = @depl_id or @depl_id=0)
        and (
                (exists(select rptarb_hojaid 
                        from rptArbolRamaHoja 
                        where
                             rptarb_cliente = @clienteID
                        and  tbl_id = 11 
                        and  rptarb_hojaid = depl_id
                       ) 
                 )
              or 
                 (@ram_id_DepositoLogico = 0)
             )

      order by 1
    
    --///////////////////////////////////////////////////////////////////////////////////////////////////////////

  end else begin

    exec sp_DocStockNroSerieValidate
    exec sp_StockNroSerieClienteProveedor
  
    select 1, 'Se valido el Stock para todos los productos y todos los numeros de serie' as Resultado
  end
end


end
go