if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionGetAux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionGetAux]

/*

select * from aaarbaweb..inscripcion where aabainsc_aerea <> 0

sp_web_InscripcionGetAux '4376320',5,'','',0,0,0,null

sp_web_InscripcionGetAux '4376320',8,341,341,0,0,1,null

*/

go
create procedure sp_web_InscripcionGetAux (
	@@nroDoc    varchar(255),
	@@tipoDoc   tinyint,
  @@socio   	varchar(255),
  @@sociol   	varchar(255),
	@@chkAerea 	tinyint,
	@@chkInfo		tinyint,
	@@chkLasra	tinyint,
  @@insc_id   int
)
as

begin

	set nocount on

	declare @insc_id_padre 		int
	declare @insc_numero 			varchar(255)
	declare @error_message    varchar(5000)
	declare @success          tinyint

	set @error_message 	= ''
	set @success 				= 1

	if @@insc_id is not null begin
		select @insc_id_padre = insc_id_padre from aaarbaweb..inscripcion where insc_id = @@insc_id

	end else begin

		if @insc_id_padre is null begin
			select @insc_id_padre = insc_id from aaarbaweb..inscripcion 
			where (
								(			insc_documento 			= @@nroDoc 
									and	insc_tipodocumento	= @@tipoDoc 
								)
							or	(insc_socio				= @@socio 	and @@socio 	<> '')
							or	(insc_socioLASFAR	= @@sociol	and @@sociol 	<> '')
						)
					and
							insc_id_padre is null 
		end
	end

	if @insc_id_padre is not null begin

		exec sp_web_InscripcionGet @insc_id_padre

	end else begin

		-- Aproposito devuelvo un recordset vacio
		--
		select * from aaarbaweb..inscripcion where 1=2
	end
end

go
