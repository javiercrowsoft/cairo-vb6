
/*---------------------------------------------------------------------
Nombre: Stock por artículo
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0055]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0055]

GO

/*
DC_CSC_STK_0055 
                      1,
                      '20200101',
                      '0',
                      '0',
                      '0',
                      '0'
select * from rama where ram_nombre like '%dvd%'
select pr_id,pr_nombrecompra from producto where pr_nombrecompra like '%lumen%'
select * from tabla where tbl_nombrefisico like '%produ%'
*/

create procedure DC_CSC_STK_0055 (

  @@us_id    int,
  @@Ffin      datetime,

@@pr_id         varchar(255),
@@depl_id       varchar(255),
@@depf_id        varchar(255),
@@suc_id        varchar(255), 
@@emp_id        varchar(255),
@@bStockCero    smallint

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id int
declare @depl_id int
declare @depf_id int
declare @suc_id int
declare @emp_id   int 

declare @ram_id_Producto int
declare @ram_id_DepositoLogico int
declare @ram_id_DepositoFisico int
declare @ram_id_Sucursal int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto out
exec sp_ArbConvertId @@depl_id, @depl_id out, @ram_id_DepositoLogico out
exec sp_ArbConvertId @@depf_id, @depf_id out, @ram_id_DepositoFisico out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

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

if @ram_id_DepositoFisico <> 0 begin

--  exec sp_ArbGetGroups @ram_id_DepositoFisico, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_DepositoFisico, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_DepositoFisico, @clienteID 
  end else 
    set @ram_id_DepositoFisico = 0
end

if @ram_id_Sucursal <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
  end else 
    set @ram_id_Sucursal = 0
end


if @ram_id_Empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
  end else 
    set @ram_id_Empresa = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 
        0,
        pr_nombrecompra           as [Articulo Compra],
        pr_nombreventa            as [Articulo Venta],
        pr_reposicion             as [Punto de Reposición],
        pr_stockminimo            as [Sotck Minimo],
        pr_stockmaximo            as [Stock Maximo],
        un_nombre                  as [Unidad],
        pr_codigo                         as [Codigo],
        sum(sti_ingreso)
        - sum(sti_salida)         as [Cantidad]
from

      Stock   inner join StockItem sti              on Stock.st_id     = sti.st_id
              inner join DepositoLogico d           on sti.depl_id     = d.depl_id  
              inner join Producto p                 on sti.pr_id       = p.pr_id
              inner join Unidad u                   on p.un_id_stock  = u.un_id
              inner join Documento doc              on stock.doc_id   = doc.doc_id

where 

          st_fecha <= @@Ffin 

-- TODO: Parametrizar

--      and (sti.pr_id_kit is null or sti.pr_id = sti.pr_id_kit)

-- Discrimino depositos internos
      and (d.depl_id <> -2 and d.depl_id <> -3)

-- WARNNING: Se considero que no es util filtrar por permisos de empresa a los usuarios
--           ya que en los casos de uso lo normal es que sin importar si el usuario puede
--           acceder a la empresa, debe ver las existencias de stock correctamente, y
--           y si filtramos por permisos no se toman en cuenta los movimientos de stock
--           generados en empresas donde el usuario no tiene acceso, pero que afectaron el
--           el deposito consultado por el usuario.
--
--       and (
--             exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
--           )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (p.pr_id = @pr_id or @pr_id=0)
and   (d.depl_id = @depl_id or @depl_id=0)
and   (d.depf_id = @depf_id or @depf_id=0)
and   (stock.suc_id = @suc_id or @suc_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0) 

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30 
                  and  rptarb_hojaid = sti.pr_id
                 ) 
           )
        or 
           (@ram_id_Producto = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 
                  and  rptarb_hojaid = sti.depl_id
                 ) 
           )
        or 
           (@ram_id_DepositoLogico = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 10 
                  and  rptarb_hojaid = d.depf_id
                 ) 
           )
        or 
           (@ram_id_DepositoFisico = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 
                  and  rptarb_hojaid = Stock.suc_id
                 ) 
           )
        or 
           (@ram_id_Sucursal = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = doc.emp_id
                 ) 
           )
        or 
           (@ram_id_Empresa = 0)
       )
group by     
        pr_nombrecompra,
        pr_nombreventa,
        pr_reposicion,
        pr_stockminimo,
        pr_stockmaximo,
        un_nombre,
        pr_codigo 

having

  abs(sum(sti_ingreso) - sum(sti_salida)) > 0.01 or  @@bStockCero <> 0

GO