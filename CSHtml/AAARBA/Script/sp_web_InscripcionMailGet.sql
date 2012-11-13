if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionMailGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionMailGet]

/*

select * from inscripcion where insc_numero = 129

sp_web_InscripcionMailGet 1391

sp_col inscripcion

*/

go
create procedure sp_web_InscripcionMailGet (
	@@insc_id int
)
as

begin

	set nocount on

	declare @insc_id int

	select @insc_id = insc_id_padre from aaarbaweb..inscripcion where insc_id = @@insc_id

	if @insc_id is null set @insc_id = @@insc_id

	declare	@AABAinsc_info						tinyint
	declare @AABAinsc_lasra						tinyint
	declare @AABAinsc_aerea						tinyint
	declare @AABAinsc_acompannantes		smallint
	
	select @AABAinsc_info 					= sum (AABAinsc_info) 					from aaarbaweb..inscripcion where insc_id_padre = @insc_id or insc_id = @insc_id
	select @AABAinsc_lasra 					= sum (AABAinsc_lasra) 					from aaarbaweb..inscripcion where insc_id_padre = @insc_id or insc_id = @insc_id
	select @AABAinsc_aerea 					= sum (AABAinsc_aerea) 					from aaarbaweb..inscripcion where insc_id_padre = @insc_id or insc_id = @insc_id
	select @AABAinsc_acompannantes 	= sum (AABAinsc_acompannantes) 	from aaarbaweb..inscripcion where insc_id_padre = @insc_id or insc_id = @insc_id

	select 	insc_id, 
					insc_numero, 
					insc_fecha,
					insc_apellido, 
					insc_nombre, 
					insc_asociacion,
					insc_socio,
					insc_socioLASFAR,
					insc_documento,
					insc_tipodocumento,
					insc_email,
					@AABAinsc_info 						as AABAinsc_info,
					@AABAinsc_lasra						as AABAinsc_lasra,
					@AABAinsc_aerea   				as AABAinsc_aerea,
					@AABAinsc_acompannantes 	as AABAinsc_acompannantes
	
	from aaarbaweb..inscripcion insc 

	where insc_id = @insc_id
	
end

go
