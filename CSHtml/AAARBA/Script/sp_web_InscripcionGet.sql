if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionGet]

/*

sp_web_InscripcionGet 19

*/

go
create procedure sp_web_InscripcionGet (
	@@insc_id	int
)
as

begin

	set nocount on

	select 
    insc_apellido,
		insc_nombre,
		insc_numero,
		insc_categoria,
		insc_socio,
		insc_socioLASFAR,
    insc_documento,
		insc_tipodocumento,
    insc_fecha,
		insc_email,
		insc_importe,
    insc_descrip,
		insc_direccion,
		insc_codPostal,
		insc_localidad,
		insc_telefono,
		insc_fax,
		insc_asociacion,
		insc_cuitCuil,
		catf_id,
		insc.pa_id,
		pa_nombre,
		insc.pro_id,
		pro_nombre,
		cpg_id,
		insc.est_id,
		est_nombre,
		cong_id,
		aabainsc_lasra,
	  aabainsc_aerea,
	  aabainsc_info,
		aabainsc_constanciaAfip,
		aabainsc_acompannantes,
		aabaasoc_id,
		insc.aabalab_id,
    aabalab_nombre,
		insc_id,
		insc_id_padre

	from aaarbaweb..Inscripcion insc  inner join pais pa 								on insc.pa_id 			= pa.pa_id
																		inner join estado est     				on insc.est_id  		= est.est_id
																		left  join provincia pro					on insc.pro_id			= pro.pro_id
																		left  join aaba_laboratorio lab		on insc.aabalab_id	= lab.aabalab_id

	where insc_id = @@insc_id

end

go
