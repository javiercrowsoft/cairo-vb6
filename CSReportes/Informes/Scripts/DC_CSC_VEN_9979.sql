/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de facturas de venta
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9979]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9979]

-- exec [DC_CSC_VEN_9979] 1,'0'

go
create procedure DC_CSC_VEN_9979 (

  @@us_id        int,

  @@pr_id       varchar(255),
  @@lp_id       varchar(255)

)as 
begin

  set nocount on

declare @pr_id  int
declare @lp_id  int

declare @ram_id_Producto   int
declare @ram_id_ListaPrecio  int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto   out
exec sp_ArbConvertId @@lp_id, @lp_id out, @ram_id_ListaPrecio   out

exec sp_GetRptId @clienteID out

if @ram_id_Producto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
  end else 
    set @ram_id_Producto = 0
end

if @ram_id_ListaPrecio <> 0 begin

--  exec sp_ArbGetGroups @ram_id_ListaPrecio, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_ListaPrecio, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_ListaPrecio, @clienteID 
  end else 
    set @ram_id_ListaPrecio = 0
end

  if @lp_id = 0 begin

    select 1 as dummy_id, 'Debe indicar una lista de precios. No puede seleccionar mas de una lista o dejar el campo vacio' as Info, '' as dummy_col
    return
  
  end else begin
    
    declare c_pr_to_update insensitive cursor for 
        select pr_id
        from Producto pr
        where (pr.pr_id = @pr_id or @pr_id  =0) 
          and ((exists(select rptarb_hojaid from rptArbolRamaHoja 
                        where rptarb_cliente = @clienteID  
                          and tbl_id = 30 
                          and rptarb_hojaid = pr.pr_id)) 
                        or (@ram_id_Producto = 0))
    
    open c_pr_to_update 

    declare @pr_id_to_update int
    
    fetch next from c_pr_to_update into @pr_id_to_update
    while @@fetch_status = 0
    begin
    
      exec sp_listaPrecioUpdateCache @lp_id, 0, @pr_id_to_update, 0
    
      fetch next from c_pr_to_update into @pr_id_to_update
    end
    
    close c_pr_to_update
    deallocate c_pr_to_update

      select pr.pr_id, pr_nombreventa as Articulo, lpp_precio as Precio, pr_descripventa as observaciones
      from Producto pr left join ListaPrecioPrecio lpp on pr.pr_id = lpp.pr_id
      where (pr.pr_id = @pr_id or @pr_id  =0) 
        and ((exists(select rptarb_hojaid from rptArbolRamaHoja 
                      where rptarb_cliente = @clienteID  
                        and tbl_id = 30 
                        and rptarb_hojaid = pr.pr_id)) 
                      or (@ram_id_Producto = 0))
  
  end

end
go
 