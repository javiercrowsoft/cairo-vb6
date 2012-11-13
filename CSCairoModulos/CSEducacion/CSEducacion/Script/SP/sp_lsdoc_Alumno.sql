/*

sp_lsdoc_Alumno 1

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Alumno]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Alumno]

GO
create procedure sp_lsdoc_Alumno (

	@@alum_id int

)as 

set nocount on 

select 

				alum_id,							
  			''									    as [TypeTask],

				prs.prs_apellido 				as Apellido,
				prs.prs_nombre					as Nombre,

				alum_codigo							as Codigo,
				alum_legajo 						as Legajo,
				alum_fechaingreso				as [Fecha Ingreso],
				prsp.prs_apellido + ', ' + prsp.prs_nombre             
																as Profesor,

				prs.prs_telCasa         as [Tel Casa],
				prs.prs_telTrab      		as [Tel Trabajo],
				prs.prs_celular         as Celular,
				prs.prs_email         	as Email,

				prs.prs_calle + ' ' + prs.prs_callenumero + ' ' + case when prs.prs_codpostal <> '' then '('+prs.prs_codpostal+')' else '' end +  ' ' + prs.prs_localidad
																as Direccion,
				pro_nombre              as Provincia,
				pa_nombre               as Pais,

				us_nombre								as [Modifico],
				alum.creado							as [Creado],
				alum.modificado					as [Modificado],
				alum_descrip						as [Observaciones]

from 

			Alumno alum  inner join Persona prs  						on alum.prs_id 		= prs.prs_id
			             inner join Usuario   							on alum.modifico 	= Usuario.us_id
									 left  join Profesor prof						on alum.prof_id 	= prof.prof_id
									 left  join Persona prsp  					on prof.prs_id 		= prsp.prs_id
									 left  join Provincia pro           on prs.pro_id     = pro.pro_id
									 left  join Pais pa                 on prs.pa_id      = pa.pa_id
where 

				  alum.alum_id = @@alum_id

GO
