if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_ImportacionesTemp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_ImportacionesTemp]
go

/*
select * from ImportacionTemp

sp_docImportacionTempget 47

sp_lsdoc_ImportacionesTemp

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

create procedure sp_lsdoc_ImportacionesTemp (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@prov_id  varchar(255),
@@est_id	varchar(255),
@@ccos_id	varchar(255),
@@suc_id	varchar(255),
@@doc_id	varchar(255),
@@cpg_id	varchar(255),
@@emp_id	varchar(255)
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
declare @ram_id_empresa int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_CentroCosto out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@cpg_id, @cpg_id out, @ram_id_CondicionPago out 
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out

exec sp_GetRptId @clienteID out

if @ram_id_Proveedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Proveedor, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Proveedor, @clienteID 
	end else 
		set @ram_id_Proveedor = 0
end

if @ram_id_CentroCosto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_CentroCosto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_CentroCosto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_CentroCosto, @clienteID 
	end else 
		set @ram_id_CentroCosto = 0
end

if @ram_id_Estado <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
	end else 
		set @ram_id_Estado = 0
end

if @ram_id_Sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
	end else 
		set @ram_id_Sucursal = 0
end

if @ram_id_Documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Documento, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Documento, @clienteID 
	end else 
		set @ram_id_Documento = 0
end

if @ram_id_CondicionPago <> 0 begin

--	exec sp_ArbGetGroups @ram_id_CondicionPago, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_CondicionPago, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_CondicionPago, @clienteID 
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
/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */
-- sp_columns ImportacionTemp


select 
			impt_id,
			''									  	as [TypeTask],
			impt_numero             as [Número],
			impt_nrodoc						  as [Comprobante],
			prov_nombre           	as [Proveedor],
      doc_nombre					  	as [Documento],
	    est_nombre					  	as [Estado],
			impt_fecha						  as [Fecha],
			impt_fechaentrega				as [Fecha de entrega],
			impt_neto								as [Neto],
			impt_ivari							as [IVA RI],
			impt_ivarni							as [IVA RNI],
			impt_subtotal						as [Subtotal],
			impt_total							as [Total],
			case impt_firmado
				when 0 then 'No'
				else        'Si'
			end										as [Firmado],
			
			impt_descuento1					as [% Desc. 1],
			impt_descuento2					as [% Desc. 2],
			impt_importedesc1				as [Desc. 1],
			impt_importedesc2				as [Desc. 2],

	    lp_nombre						as [Lista de Precios],
	    ld_nombre						as [Lista de descuentos],
	    cpg_nombre					as [Condicion de Pago],
	    ccos_nombre					as [Centro de costo],
      suc_nombre					as [Sucursal],
			emp_nombre          as [Empresa],

			ImportacionTemp.Creado,
			ImportacionTemp.Modificado,
			us_nombre             as [Modifico],
			impt_descrip						as [Observaciones]
from 
			ImportacionTemp  inner join documento     on ImportacionTemp.doc_id   = documento.doc_id
											 inner join empresa       on documento.emp_id         = empresa.emp_id
											 inner join estado        on ImportacionTemp.est_id   = estado.est_id
											 inner join sucursal      on ImportacionTemp.suc_id   = sucursal.suc_id
		                   inner join Proveedor     on ImportacionTemp.prov_id  = Proveedor.prov_id
		                   inner join usuario       on ImportacionTemp.modifico = usuario.us_id
		                   left join condicionpago  on ImportacionTemp.cpg_id   = condicionpago.cpg_id
		                   left join centrocosto    on ImportacionTemp.ccos_id  = centrocosto.ccos_id
		                   left join listaprecio    on ImportacionTemp.lp_id    = listaprecio.lp_id
		  								 left join listadescuento on ImportacionTemp.ld_id    = listadescuento.ld_id
where 

				  @@Fini <= impt_fecha
			and	@@Ffin >= impt_fecha 		

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
                  and  tbl_id = 28 -- tbl_id de Proyecto
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
                       rptarb_cliente = @clienteID
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
                       rptarb_cliente = @clienteID
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
                       rptarb_cliente = @clienteID
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
                  and  tbl_id = 1005 -- tbl_id de Proyecto
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
                  and  tbl_id = 1018 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Empresa.emp_id
							   ) 
           )
        or 
					 (@ram_id_empresa = 0)
			 )

	order by impt_fecha
go