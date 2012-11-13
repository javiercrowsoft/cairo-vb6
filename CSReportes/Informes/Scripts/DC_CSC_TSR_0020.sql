-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Listado de cobranza agrupado por proveedor
---------------------------------------------------------------------*/
/*

DC_CSC_TSR_0020 7, 
								'20000101', 
								'20100101', 
								'0', 
								'0', 
								'0', 
								'0', 
								'0',0

select * from tabla

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0020]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0020]

go
create procedure DC_CSC_TSR_0020 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@prov_id varchar(255),
@@doc_id  varchar(255),
@@lgj_id	varchar(255),
@@suc_id	varchar(255),
@@est_id	varchar(255), -- TODO:EMPRESA
@@emp_id  varchar(255)
)as 

begin

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prov_id int
declare @doc_id int
declare @lgj_id int
declare @suc_id int
declare @est_id int
declare @emp_id   int -- TODO:EMPRESA

declare @ram_id_cliente int
declare @ram_id_documento int
declare @ram_id_legajo int
declare @ram_id_sucursal int
declare @ram_id_estado int
declare @ram_id_Empresa   int -- TODO:EMPRESA

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_cliente out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_documento out
exec sp_ArbConvertId @@lgj_id, @lgj_id out, @ram_id_legajo out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_sucursal out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_estado out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out -- TODO:EMPRESA

exec sp_GetRptId @clienteID out

if @ram_id_cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
	end else 
		set @ram_id_cliente = 0
end

if @ram_id_documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
	end else 
		set @ram_id_documento = 0
end

if @ram_id_legajo <> 0 begin

--	exec sp_ArbGetGroups @ram_id_legajo, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_legajo, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_legajo, @clienteID 
	end else 
		set @ram_id_legajo = 0
end

if @ram_id_sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_sucursal, @clienteID 
	end else 
		set @ram_id_sucursal = 0
end

if @ram_id_estado <> 0 begin

--	exec sp_ArbGetGroups @ram_id_estado, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_estado, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_estado, @clienteID 
	end else 
		set @ram_id_estado = 0
end

-- TODO:EMPRESA
if @ram_id_Empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

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

				opg_id              as comp_id,
				opg_fecha           as [Fecha],
				opg_numero          as [Numero],
				opg_nrodoc          as [Comprobante],
				prov_nombre         as [Proveedor],
				opg_total           as [Total],
				opg_pendiente       as [Pendiente],
				est_nombre          as [Estado],
        doc_nombre          as [Documento],
        emp_nombre          as [Empresa], -- TODO:EMPRESA
        suc_nombre          as [Sucursal],
        case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
        ccos_nombre         as [Centro de Costo],
				opg_descrip         as [Observaciones]

from 

	OrdenPago opg inner join Proveedor prov													on opg.prov_id 	 = prov.prov_id
                inner join Estado est                             on opg.est_id    = est.est_id
                inner join Documento doc                          on opg.doc_id    = doc.doc_id
                inner join Empresa                                on doc.emp_id    = Empresa.emp_id -- TODO:EMPRESA
                inner join Sucursal suc                           on opg.suc_id    = suc.suc_id
                left  join Legajo lgj                             on opg.lgj_id    = lgj.lgj_id
                left  join CentroCosto ccos                       on opg.ccos_id   = ccos.ccos_id
where 

				  @@Fini <= opg_fecha
			and	@@Ffin >= opg_fecha 		
-- TODO:EMPRESA
			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (prov.prov_id = @prov_id or @prov_id =0)
and   (doc.doc_id   = @doc_id or @doc_id   =0)
and   (lgj.lgj_id   = @lgj_id or @lgj_id   =0)
and   (suc.suc_id   = @suc_id or @suc_id   =0)
and   (est.est_id   = @est_id or @est_id   =0)
and   (Empresa.emp_id = @emp_id or @emp_id=0) -- TODO:EMPRESA

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 29 -- tbl_id de Proyecto
                  and  rptarb_hojaid = prov.prov_id
							   ) 
           )
        or 
					 (@ram_id_cliente = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4001 -- tbl_id de Proyecto
                  and  rptarb_hojaid = doc.doc_id
							   ) 
           )
        or 
					 (@ram_id_documento = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 15001 -- tbl_id de Proyecto
                  and  rptarb_hojaid = lgj.lgj_id
							   ) 
           )
        or 
					 (@ram_id_legajo = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 -- tbl_id de Proyecto
                  and  rptarb_hojaid = suc.suc_id
							   ) 
           )
        or 
					 (@ram_id_sucursal = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4005 -- tbl_id de Proyecto
                  and  rptarb_hojaid = est.est_id
							   ) 
           )
        or 
					 (@ram_id_estado = 0)
			 )
-- TODO:EMPRESA
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- select * from tabla where tbl_nombre = 'empresa'
                  and  rptarb_hojaid = doc.emp_id
							   ) 
           )
        or 
					 (@ram_id_Empresa = 0)
			 )
end

GO