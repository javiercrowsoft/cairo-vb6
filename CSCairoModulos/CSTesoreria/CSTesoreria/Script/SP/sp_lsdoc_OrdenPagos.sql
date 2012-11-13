/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_OrdenPagos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_OrdenPagos]
go

/*

sp_lsdoc_OrdenPagos

  7,
	'20030101',
	'20050101',
		'0',
		'0',
		'0',
		'0',
		'0',
		'2'

*/

create procedure sp_lsdoc_OrdenPagos (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@prov_id  varchar(255),
@@est_id	varchar(255),
@@ccos_id	varchar(255),
@@suc_id	varchar(255),
@@doc_id	varchar(255),
@@emp_id	varchar(255)
/*,
@@TABLA_ID9	varchar(255),
@@TABLA_ID-10 varchar(255),
@@TABLA_ID-11 varchar(255),
@@TABLA_ID-12 varchar(255),
@@TABLA_ID-13 varchar(255),
@@TABLA_ID-14 varchar(255),
@@TABLA_ID-15 varchar(255)*/

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prov_id int
declare @ccos_id int
declare @suc_id int
declare @est_id int
declare @cob_id int
declare @doc_id int
declare @emp_id int
/*declare @TABLA_ID9 int
declare @TABLA_ID-10 int
declare @TABLA_ID-11 int
declare @TABLA_ID-12 int
declare @TABLA_ID-13 int
declare @TABLA_ID-14 int
declare @TABLA_ID-15 int */

declare @ram_id_Proveedor int
declare @ram_id_CentroCosto int
declare @ram_id_Sucursal int
declare @ram_id_Estado int
declare @ram_id_Cobrador int
declare @ram_id_Documento int
declare @ram_id_CondicionPago int 
declare @ram_id_empresa int /* 
declare @RAM_ID_TABLA9 int
declare @RAM_ID_TABLA-10 int
declare @RAM_ID_TABLA-11 int
declare @RAM_ID_TABLA-12 int
declare @RAM_ID_TABLA-13 int
declare @RAM_ID_TABLA-14 int
declare @RAM_ID_TABLA-15 int */

declare @ClienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_CentroCosto out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out
/*
exec sp_ArbConvertId @@TABLA_ID9, @TABLA_ID9 out, @RAM_ID_TABLA9 out 
exec sp_ArbConvertId @@TABLA_ID-10, @TABLA_ID-10 out, @RAM_ID_TABLA-10 out
exec sp_ArbConvertId @@TABLA_ID-11, @TABLA_ID-11 out, @RAM_ID_TABLA-11 out
exec sp_ArbConvertId @@TABLA_ID-12, @TABLA_ID-12 out, @RAM_ID_TABLA-12 out
exec sp_ArbConvertId @@TABLA_ID-13, @TABLA_ID-13 out, @RAM_ID_TABLA-13 out
exec sp_ArbConvertId @@TABLA_ID-14, @TABLA_ID-14 out, @RAM_ID_TABLA-14 out
exec sp_ArbConvertId @@TABLA_ID-15, @TABLA_ID-15 out, @RAM_ID_TABLA-15 out */

exec sp_GetRptId @ClienteID out

if @ram_id_Proveedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Proveedor, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Proveedor, @ClienteID 
	end else 
		set @ram_id_Proveedor = 0
end

if @ram_id_CentroCosto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_CentroCosto, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_CentroCosto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_CentroCosto, @ClienteID 
	end else 
		set @ram_id_CentroCosto = 0
end

if @ram_id_Estado <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Estado, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Estado, @ClienteID 
	end else 
		set @ram_id_Estado = 0
end

if @ram_id_Sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Sucursal, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @ClienteID 
	end else 
		set @ram_id_Sucursal = 0
end

if @ram_id_Cobrador <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Cobrador, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Cobrador, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Cobrador, @ClienteID 
	end else 
		set @ram_id_Cobrador = 0
end

if @ram_id_Documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Documento, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Documento, @ClienteID 
	end else 
		set @ram_id_Documento = 0
end

if @ram_id_CondicionPago <> 0 begin

--	exec sp_ArbGetGroups @ram_id_CondicionPago, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_CondicionPago, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_CondicionPago, @ClienteID 
	end else 
		set @ram_id_CondicionPago = 0
end

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end

/*
if @RAM_ID_TABLA9 <> 0 begin

	exec sp_ArbGetGroups @RAM_ID_TABLA9, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @RAM_ID_TABLA9, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @RAM_ID_TABLA9, @ClienteID 
	end else 
		set @RAM_ID_TABLA9 = 0
end

if @RAM_ID_TABLA-10 <> 0 begin

	exec sp_ArbGetGroups @RAM_ID_TABLA-10, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @RAM_ID_TABLA-10, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @RAM_ID_TABLA-10, @ClienteID 
	end else 
		set @RAM_ID_TABLA-10 = 0
end

if @RAM_ID_TABLA-11 <> 0 begin

	exec sp_ArbGetGroups @RAM_ID_TABLA-11, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @RAM_ID_TABLA-11, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @RAM_ID_TABLA-11, @ClienteID 
	end else 
		set @RAM_ID_TABLA-11 = 0
end

if @RAM_ID_TABLA-12 <> 0 begin

	exec sp_ArbGetGroups @RAM_ID_TABLA-12, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @RAM_ID_TABLA-12, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @RAM_ID_TABLA-12, @ClienteID 
	end else 
		set @RAM_ID_TABLA-12 = 0
end

if @RAM_ID_TABLA-13 <> 0 begin

	exec sp_ArbGetGroups @RAM_ID_TABLA-13, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @RAM_ID_TABLA-13, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @RAM_ID_TABLA-13, @ClienteID 
	end else 
		set @RAM_ID_TABLA-13 = 0
end

if @RAM_ID_TABLA-14 <> 0 begin

	exec sp_ArbGetGroups @RAM_ID_TABLA-14, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @RAM_ID_TABLA-14, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @RAM_ID_TABLA-14, @ClienteID 
	end else 
		set @RAM_ID_TABLA-14 = 0
end

if @RAM_ID_TABLA-15 <> 0 begin

	exec sp_ArbGetGroups @RAM_ID_TABLA-15, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @RAM_ID_TABLA-15, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @RAM_ID_TABLA-15, @ClienteID 
	end else 
		set @RAM_ID_TABLA-15 = 0
end
 */
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
-- sp_columns OrdenPago


select 
			opg_id,
			''									  as [TypeTask],
			opg_numero            as [Número],
			opg_nrodoc						as [Comprobante],
	    prov_nombre           as [Proveedor],
      doc_nombre					  as [Documento],
	    est_nombre					  as [Estado],
			opg_fecha						  as [Fecha],
			opg_neto							as [Neto],
			opg_total							as [Total],
			opg_pendiente					as [Pendiente],
			case opg_firmado
				when 0 then 'No'
				else        'Si'
			end										as [Firmado],

	    ccos_nombre					  as [Centro de costo],
      suc_nombre					  as [Sucursal],
			emp_nombre            as [Empresa],

			OrdenPago.Creado,
			OrdenPago.Modificado,
			us_nombre             as [Modifico],
			opg_descrip						as [Observaciones]
from 
			OrdenPago 	 inner join documento  on OrdenPago.doc_id   = documento.doc_id
									 inner join empresa    on documento.emp_id   = empresa.emp_id
									 inner join estado     on OrdenPago.est_id   = estado.est_id
									 inner join sucursal   on OrdenPago.suc_id   = sucursal.suc_id
                   inner join Proveedor  on OrdenPago.prov_id  = Proveedor.prov_id
                   inner join usuario    on OrdenPago.modifico = usuario.us_id
                   left join CentroCosto on OrdenPago.ccos_id  = centrocosto.ccos_id
where 

				  @@Fini <= opg_fecha
			and	@@Ffin >= opg_fecha 		

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Proveedor.prov_id = @prov_id or @prov_id=0)
and   (Estado.est_id = @est_id or @est_id=0)
and   (Sucursal.suc_id = @suc_id or @suc_id=0)
and   (Documento.doc_id = @doc_id or @doc_id=0)
and   (CentroCosto.ccos_id = @ccos_id or @ccos_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0)

/*
and   (TABLA_DEL_LISTADO9.TABLA_ID9 = @TABLA_ID9 or @TABLA_ID9=0)
and   (TABLA_DEL_LISTADO-10.TABLA_ID-10 = @TABLA_ID-10 or @TABLA_ID-10=0)
and   (TABLA_DEL_LISTADO-11.TABLA_ID-11 = @TABLA_ID-11 or @TABLA_ID-11=0)
and   (TABLA_DEL_LISTADO-12.TABLA_ID-12 = @TABLA_ID-12 or @TABLA_ID-12=0)
and   (TABLA_DEL_LISTADO-13.TABLA_ID-13 = @TABLA_ID-13 or @TABLA_ID-13=0)
and   (TABLA_DEL_LISTADO-14.TABLA_ID-14 = @TABLA_ID-14 or @TABLA_ID-14=0)
and   (TABLA_DEL_LISTADO-15.TABLA_ID-15 = @TABLA_ID-15 or @TABLA_ID-15=0) 
*/
-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = 29 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Proveedor.prov_id
							   ) 
           )
        or 
					 (@ram_id_Proveedor = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = 21 -- tbl_id de Proyecto
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
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = 4005 -- tbl_id de Proyecto
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
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = 1007 -- tbl_id de Proyecto
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
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = 4001 -- tbl_id de Proyecto
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
                  and  tbl_id = 1018 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Empresa.emp_id
							   ) 
           )
        or 
					 (@ram_id_empresa = 0)
			 )

/*
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = TBL_ID_TABLA9 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_DEL_LISTADO9.TABLA_ID9
							   ) 
           )
        or 
					 (@RAM_ID_TABLA9 = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = TBL_ID_TABLA-10 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_DEL_LISTADO-10.TABLA_ID-10
							   ) 
           )
        or 
					 (@RAM_ID_TABLA-10 = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = TBL_ID_TABLA-11 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_DEL_LISTADO-11.TABLA_ID-11
							   ) 
           )
        or 
					 (@RAM_ID_TABLA-11 = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = TBL_ID_TABLA-12 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_DEL_LISTADO-12.TABLA_ID-12
							   ) 
           )
        or 
					 (@RAM_ID_TABLA-12 = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = TBL_ID_TABLA-13 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_DEL_LISTADO-13.TABLA_ID-13
							   ) 
           )
        or 
					 (@RAM_ID_TABLA-13 = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = TBL_ID_TABLA-14 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_DEL_LISTADO-14.TABLA_ID-14
							   ) 
           )
        or 
					 (@RAM_ID_TABLA-14 = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_Cliente = @ClienteID
                  and  tbl_id = TBL_ID_TABLA-15 -- tbl_id de Proyecto
                  and  rptarb_hojaid = TABLA_DEL_LISTADO-15.TABLA_ID-15
							   ) 
           )
        or 
					 (@RAM_ID_TABLA-15 = 0)
			 ) */

	order by opg_fecha, opg_nrodoc
go