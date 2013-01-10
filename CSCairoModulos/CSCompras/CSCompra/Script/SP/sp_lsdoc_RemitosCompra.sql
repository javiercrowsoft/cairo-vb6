if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_RemitosCompra]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_RemitosCompra]
go

/*
select * from RemitoCompra

sp_docRemitoCompraget 47

sp_lsdoc_RemitosCompra

  7,
  '20030101',
  '20050101',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0',
    '0'

*/

create procedure sp_lsdoc_RemitosCompra (

  @@us_id    int,
  @@Fini      datetime,
  @@Ffin      datetime,

@@prov_id  varchar(255),
@@est_id  varchar(255),
@@ccos_id  varchar(255),
@@suc_id  varchar(255),
@@doc_id  varchar(255),
@@cpg_id  varchar(255),
@@emp_id  varchar(255)
)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prov_id int
declare @ccos_id int
declare @suc_id int
declare @est_id int
declare @doc_id int
declare @cpg_id int
declare @emp_id int

declare @ram_id_Proveedor int
declare @ram_id_CentroCosto int
declare @ram_id_Sucursal int
declare @ram_id_Estado int
declare @ram_id_Documento int
declare @ram_id_CondicionPago int 
declare @ram_id_Empresa int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_CentroCosto out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@cpg_id, @cpg_id out, @ram_id_CondicionPago out 
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

if @ram_id_CentroCosto <> 0 begin

--  exec sp_ArbGetGroups @ram_id_CentroCosto, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_CentroCosto, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_CentroCosto, @clienteID 
  end else 
    set @ram_id_CentroCosto = 0
end

if @ram_id_Estado <> 0 begin

--  exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
  end else 
    set @ram_id_Estado = 0
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

if @ram_id_CondicionPago <> 0 begin

--  exec sp_ArbGetGroups @ram_id_CondicionPago, @clienteID, @@us_id

  exec sp_ArbIsRaiz @ram_id_CondicionPago, @IsRaiz out
  if @IsRaiz = 0 begin
    exec sp_ArbGetAllHojas @ram_id_CondicionPago, @clienteID 
  end else 
    set @ram_id_CondicionPago = 0
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
-- sp_columns RemitoCompra


select 
      rc_id,
      ''                    as [TypeTask],
      rc_numero             as [Número],
      rc_nrodoc              as [Comprobante],
      prov_nombre           as [Proveedor],
      doc_nombre            as [Documento],
      est_nombre            as [Estado],
      rc_fecha              as [Fecha],
      rc_fechaentrega        as [Fecha de entrega],
      rc_neto                as [Neto],
      rc_ivari              as [IVA RI],
      rc_ivarni              as [IVA RNI],
      rc_subtotal            as [Subtotal],
      rc_total              as [Total],
      rc_pendiente          as [Pendiente],
      case rc_firmado
        when 0 then 'No'
        else        'Si'
      end                    as [Firmado],
      
      rc_descuento1          as [% Desc. 1],
      rc_descuento2          as [% Desc. 2],
      rc_importedesc1        as [Desc. 1],
      rc_importedesc2        as [Desc. 2],

      lp_nombre              as [Lista de Precios],
      ld_nombre              as [Lista de descuentos],
      cpg_nombre            as [Condicion de Pago],
      ccos_nombre            as [Centro de costo],
      suc_nombre            as [Sucursal],
      emp_nombre            as [Empresa],

      RemitoCompra.Creado,
      RemitoCompra.Modificado,
      us_nombre             as [Modifico],
      rc_descrip            as [Observaciones]
from 
      RemitoCompra inner join documento     on RemitoCompra.doc_id   = documento.doc_id
                   inner join empresa       on documento.emp_id      = empresa.emp_id
                   inner join estado        on RemitoCompra.est_id   = estado.est_id
                   inner join sucursal      on RemitoCompra.suc_id   = sucursal.suc_id
                   inner join Proveedor     on RemitoCompra.prov_id  = Proveedor.prov_id
                   inner join usuario       on RemitoCompra.modifico = usuario.us_id
                   left join condicionpago  on RemitoCompra.cpg_id   = condicionpago.cpg_id
                   left join centrocosto    on RemitoCompra.ccos_id  = centrocosto.ccos_id
                   left join listaprecio    on RemitoCompra.lp_id    = listaprecio.lp_id
                   left join listadescuento on RemitoCompra.ld_id    = listadescuento.ld_id
where 

          @@Fini <= rc_fecha
      and  @@Ffin >= rc_fecha     

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Proveedor.prov_id = @prov_id or @prov_id=0)
and   (Estado.est_id = @est_id or @est_id=0)
and   (Sucursal.suc_id = @suc_id or @suc_id=0)
and   (Documento.doc_id = @doc_id or @doc_id=0)
and   (CondicionPago.cpg_id = @cpg_id or @cpg_id=0) 
and   (CentroCosto.ccos_id = @ccos_id or @ccos_id=0)
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
                  and  tbl_id = 21 
                  and  rptarb_hojaid = CentroCosto.ccos_id
                 ) 
           )
        or 
           (@ram_id_CentroCosto = 0)
       )

and   (
          (exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4005 
                  and  rptarb_hojaid = Estado.est_id
                 ) 
           )
        or 
           (@ram_id_Estado = 0)
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
                  and  tbl_id = 1005 
                  and  rptarb_hojaid = CondicionPago.cpg_id
                 ) 
           )
        or 
           (@ram_id_CondicionPago = 0)
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

  order by rc_fecha
go