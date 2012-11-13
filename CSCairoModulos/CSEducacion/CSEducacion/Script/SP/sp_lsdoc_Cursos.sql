/*

sp_lsdoc_Cursos 

										1,
										'20000101',
										'20100101',
										'20100101',
										'0',
										'0',
										'0'


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Cursos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Cursos]

GO
create procedure sp_lsdoc_Cursos (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@prof_id 			varchar(255),
@@mat_id				varchar(255),
@@alum_id				varchar(255)

)as 

set nocount on 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @prof_id 	int
declare @mat_id 	int
declare @alum_id 	int

declare @ram_id_profesor 	int
declare @ram_id_materia 	int
declare @ram_id_alumno  	int

declare @clienteID 		int
declare @IsRaiz    		tinyint

exec sp_ArbConvertId @@prof_id, @prof_id out, @ram_id_profesor out
exec sp_ArbConvertId @@mat_id, @mat_id out, @ram_id_materia out
exec sp_ArbConvertId @@alum_id, @alum_id out, @ram_id_alumno out

exec sp_GetRptId @clienteID out

if @ram_id_profesor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_profesor, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_profesor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_profesor, @clienteID 
	end else 
		set @ram_id_profesor = 0
end

if @ram_id_materia <> 0 begin

--	exec sp_ArbGetGroups @ram_id_materia, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_materia, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_materia, @clienteID 
	end else 
		set @ram_id_materia = 0
end

if @ram_id_alumno <> 0 begin

--	exec sp_ArbGetGroups @ram_id_alumno, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_alumno, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_alumno, @clienteID 
	end else 
		set @ram_id_alumno = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 

				cur_id,							
  			''									    as [TypeTask],

				cur_nombre							as Nombre,

				cur_codigo							as Codigo,

				mat_nombre              as Materia,

				prsp.prs_apellido + ', ' + prsp.prs_nombre             
																as Profesor,

				cur_desde               as Desde,
				cur_hasta               as Hasta,

				us_nombre								as [Modifico],
				cur.creado							as [Creado],
				cur.modificado					as [Modificado],
				cur_descrip							as [Observaciones]

from 

			Curso cur    inner join Usuario   							on cur.modifico 	= Usuario.us_id
									 left  join Profesor prof						on cur.prof_id 		= prof.prof_id
									 left  join Persona prsp  					on prof.prs_id 		= prsp.prs_id
									 left  join Materia mat             on cur.mat_id     = mat.mat_id
where 

				  cur_desde >= @@Fini
			and	cur_desde <= @@Ffin 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cur.prof_id 	= @prof_id or @prof_id=0)
and 	(cur.mat_id 	= @mat_id  or @mat_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 37003
                  and  rptarb_hojaid = cur.prof_id
							   ) 
           )
        or 
					 (@ram_id_profesor = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 37001
                  and  rptarb_hojaid = cur.mat_id
							   ) 
           )
        or 
					 (@ram_id_materia = 0)
			 )

and (			(@alum_id=0 and @ram_id_alumno=0)
			or	(exists(
									select * from CursoItem curi
									where curi.cur_id = cur.cur_id
										and (curi.alum_id = @alum_id or @alum_id=0)
										and   (
															(exists(select rptarb_hojaid 
										                  from rptArbolRamaHoja 
										                  where
										                       rptarb_cliente = @clienteID
										                  and  tbl_id = 37004
										                  and  rptarb_hojaid = curi.alum_id
																	   ) 
										           )
										        or 
															 (@ram_id_alumno= 0)
													 )
									)
					)
		)

GO