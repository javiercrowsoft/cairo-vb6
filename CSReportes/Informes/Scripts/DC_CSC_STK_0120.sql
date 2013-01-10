/*---------------------------------------------------------------------
Nombre: Historia de movimientos de numeros de serie
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0120]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0120]

go
create procedure DC_CSC_STK_0120 (

  @@us_id     int,
  @@pr_id     varchar(255),
  @@prns_id   varchar(255)

)as 
begin
set nocount on
/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id int
declare @prns_id int

declare @ram_id_producto int
declare @ram_id_productoserie int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_producto out
exec sp_ArbConvertId @@prns_id, @prns_id out, @ram_id_productoserie out

exec sp_GetRptId @clienteID out

if @ram_id_producto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
  end else 
    set @ram_id_producto = 0
end

if @ram_id_productoserie <> 0 begin

--  exec sp_ArbGetGroups @ram_id_productoserie, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_productoserie, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_productoserie, @clienteID 
  end else 
    set @ram_id_productoserie = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 

  p.pr_id,
  p.pr_nombrecompra    as [Nombre Venta],
  p.pr_nombreventa     as [Nombre Compra],
  prns_codigo          as [Nro Serie],
  prns_fechavto        as [Fecha Vto],
  d.depl_id            as [Deposito Actual],
  pk.pr_nombreventa    as [Usado en Kit],
  prns_descrip         as [Observaciones]

from 

-- Listado de tablas que corresponda  
ProductoNumeroSerie

where 


-- TODO:EMPRESA
          (
            exists(select * from EmpresaUsuario where emp_id = documento.emp_id and us_id = @@us_id) or (@@us_id = 1)
          )

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Producto.pr_id = @pr_id or @pr_id=0)
and   (ProductoNumeroSerie.prns_id = @prns_id or @prns_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30 -- tbl_id de Proyecto
                  and  rptarb_hojaid = MovimientoStockItem.pr_id
                 ) 
           )
        or 
           (@ram_id_producto = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1017 -- tbl_id de Proyecto
                  and  rptarb_hojaid = MovimientoStockItem.prns_id
                 ) 
           )
        or 
           (@ram_id_productoserie = 0)
       )
end
go