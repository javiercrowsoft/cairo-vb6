if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_StocksProveedor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_StocksProveedor]
go

/*
select * from StockProveedor

sp_docStockProveedorget 47

sp_lsdoc_StocksProveedor

  7,
  '20030101',
  '20050101',
    '0',
    '0',
    '0',
    '0'

*/

create procedure sp_lsdoc_StocksProveedor (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

@@prov_id  varchar(255),
@@suc_id  varchar(255),
@@doc_id  varchar(255),
@@emp_id  varchar(255)
)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prov_id int
declare @suc_id int
declare @doc_id int
declare @emp_id int

declare @ram_id_Proveedor int
declare @ram_id_Sucursal int
declare @ram_id_Documento int
declare @ram_id_Empresa int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out

exec sp_GetRptId @clienteID out

if @ram_id_Proveedor <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Proveedor, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Proveedor, @clienteID 
  end else 
    set @ram_id_Proveedor = 0
end

if @ram_id_Sucursal <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
  end else 
    set @ram_id_Sucursal = 0
end

if @ram_id_Documento <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Documento, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Documento, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Documento, @clienteID 
  end else 
    set @ram_id_Documento = 0
end

if @ram_id_empresa <> 0 begin

--  exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
  end else 
    set @ram_id_empresa = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
-- sp_columns StockProveedor


select 
      stprov_id,
      ''                    as [TypeTask],
      stprov_numero         as [Número],
      stprov_nrodoc          as [Comprobante],
      prov_nombre           as [Proveedor],
      doc_nombre            as [Documento],
      stprov_fecha          as [Fecha],

      suc_nombre            as [Sucursal],
      emp_nombre            as [Empresa],

      StockProveedor.Creado,
      StockProveedor.Modificado,
      us_nombre             as [Modifico],
      stprov_descrip        as [Observaciones]
from 
      StockProveedor inner join documento     on StockProveedor.doc_id   = documento.doc_id
                     inner join empresa       on documento.emp_id        = empresa.emp_id
                     inner join sucursal      on StockProveedor.suc_id   = sucursal.suc_id
                     inner join Proveedor     on StockProveedor.prov_id  = Proveedor.prov_id
                     inner join usuario       on StockProveedor.modifico = usuario.us_id
where 

          @@Fini <= stprov_fecha
      and  @@Ffin >= stprov_fecha     

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Proveedor.prov_id = @prov_id or @prov_id=0)
and   (Sucursal.suc_id = @suc_id or @suc_id=0)
and   (Documento.doc_id = @doc_id or @doc_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 29 
                  and  rptarb_hojaid = proveedor.prov_id
                 ) 
           )
        or 
           (@ram_id_Proveedor = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 
                  and  rptarb_hojaid = Sucursal.suc_id
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
                  and  tbl_id = 4001 
                  and  rptarb_hojaid = Documento.doc_id
                 ) 
           )
        or 
           (@ram_id_Documento = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = Empresa.emp_id
                 ) 
           )
        or 
           (@ram_id_empresa = 0)
       )

  order by stprov_fecha
go