-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Listado de cobranza agrupado por cliente
---------------------------------------------------------------------*/
/*
DC_CSC_TSR_0015 7, 
								'20000101', 
								'20100101', 
								'0', 
								'0', 
								'0', 
								'0', 
								'0', 
								'0'
select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0015]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0015]

go
create procedure DC_CSC_TSR_0015 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@cli_id varchar(255),
@@doc_id varchar(255),
@@cob_id	varchar(255),
@@lgj_id	varchar(255),
@@suc_id	varchar(255),
@@est_id	varchar(255), -- TODO:EMPRESA
@@emp_id  varchar(255)
)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id int
declare @doc_id int
declare @cob_id int
declare @lgj_id int
declare @suc_id int
declare @est_id int
declare @emp_id   int -- TODO:EMPRESA

declare @ram_id_cliente int
declare @ram_id_documento int
declare @ram_id_cobrador int
declare @ram_id_legajo int
declare @ram_id_sucursal int
declare @ram_id_estado int
declare @ram_id_Empresa   int -- TODO:EMPRESA

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_cliente out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_documento out
exec sp_ArbConvertId @@cob_id, @cob_id out, @ram_id_cobrador out
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

if @ram_id_cobrador <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cobrador, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cobrador, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cobrador, @clienteID 
	end else 
		set @ram_id_cobrador = 0
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

				cobz_id              as comp_id,
				cobz_fecha           as [Fecha],
				cobz_nrodoc          as [Comprobante],
				cli_nombre           as [Cliente],
				cobz_total           as [Total],
				cobz_pendiente       as [Pendiente],
				est_nombre           as [Estado],
        emp_nombre           as [Empresa], -- TODO:EMPRESA
				cobz_descrip         as [Observaciones]

from 

	Cobranza cobz inner join Cliente cli 														on cobz.cli_id 		= cli.cli_id
                inner join Estado est                             on cobz.est_id    = est.est_id
                inner join Documento doc                          on cobz.doc_id    = doc.doc_id
                inner join Empresa                                on doc.emp_id     = Empresa.emp_id -- TODO:EMPRESA
                inner join Sucursal suc                           on cobz.suc_id    = suc.suc_id
                left  join Cobrador cob                           on cobz.cob_id    = cob.cob_id
                left  join Legajo lgj                             on cobz.lgj_id    = lgj.lgj_id
                left  join CentroCosto ccos                       on cobz.ccos_id   = ccos.ccos_id
where 

				  @@Fini <= cobz_fecha
			and	@@Ffin >= cobz_fecha 		

-- TODO:EMPRESA
			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
			and (
						exists(select * from UsuarioEmpresa where cli_id = cli.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)
					
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cli.cli_id = @cli_id or @cli_id=0)
and   (doc.doc_id = @doc_id or @doc_id=0)
and   (cob.cob_id = @cob_id or @cob_id=0)
and   (lgj.lgj_id = @lgj_id or @lgj_id=0)
and   (suc.suc_id = @suc_id or @suc_id=0)
and   (est.est_id = @est_id or @est_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0) -- TODO:EMPRESA

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 -- tbl_id de Proyecto
                  and  rptarb_hojaid = cli.cli_id
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
                  and  tbl_id = 25 -- tbl_id de Proyecto
                  and  rptarb_hojaid = cob.cob_id
							   ) 
           )
        or 
					 (@ram_id_cobrador = 0)
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

order by Cliente

end

GO