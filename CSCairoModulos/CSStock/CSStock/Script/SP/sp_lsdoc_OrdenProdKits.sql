/*

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_OrdenProdKits]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_OrdenProdKits]
go

/*
select * from OrdenProdKit

sp_docOrdenProdKitget 47

sp_lsdoc_OrdenProdKits

  7,
	'20030101',
	'20050101',
		'0',
		'0',
		'0',
		'0'

*/

create procedure sp_lsdoc_OrdenProdKits (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@doc_id	varchar(255),
@@suc_id	varchar(255),
@@lgj_id	varchar(255),
@@emp_id	varchar(255)

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @lgj_id int
declare @suc_id int
declare @doc_id int
declare @emp_id int

declare @ram_id_Legajo int
declare @ram_id_Sucursal int
declare @ram_id_Documento int
declare @ram_id_empresa int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@lgj_id, @lgj_id out, @ram_id_Legajo out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_empresa out

exec sp_GetRptId @clienteID out

if @ram_id_Legajo <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Legajo, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Legajo, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Legajo, @clienteID 
	end else 
		set @ram_id_Legajo = 0
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
-- sp_columns OrdenProdKit

select 
			opk_id,
			''									  as [TypeTask],
			opk_numero            as [Número],
			opk_nrodoc						as [Comprobante],
      doc_nombre					  as [Documento],
			opk_fecha						  as [Fecha],
	    case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo],
      suc_nombre						as [Sucursal],
			emp_nombre            as [Empresa],

			OrdenProdKit.Creado,
			OrdenProdKit.Modificado,
			us_nombre             as [Modifico],
			opk_descrip						as [Observaciones]
from 
			OrdenProdKit        inner join Documento     on OrdenProdKit.doc_id   = Documento.doc_id
													inner join empresa       on documento.emp_id      = empresa.emp_id
													inner join Sucursal      on OrdenProdKit.suc_id   = Sucursal.suc_id
				                  inner join Usuario       on OrdenProdKit.modifico = Usuario.us_id
				                  left  join Legajo    		 on OrdenProdKit.lgj_id   = Legajo.lgj_id
where 

				  @@Fini <= opk_fecha
			and	@@Ffin >= opk_fecha 		

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Sucursal.suc_id = @suc_id or @suc_id=0)
and   (Documento.doc_id = @doc_id or @doc_id=0)
and   (Legajo.lgj_id = @lgj_id or @lgj_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 21 
                  and  rptarb_hojaid = Legajo.lgj_id
							   ) 
           )
        or 
					 (@ram_id_Legajo = 0)
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

	order by opk_fecha
go