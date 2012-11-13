if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionGetForMail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionGetForMail]

/*

sp_web_InscripcionGetForMail 1,0,0,0,0

update inscripcion set est_id = 1008

*/

go
create procedure sp_web_InscripcionGetForMail (
	@@includeAll 					smallint,
	@@aabasoc_id 					int,
	@@aabasocl_id 				int,
	@@insc_tipodocumento	int,
  @@insc_documento			varchar(30),
	@@aabalab_id          int
)
as

begin

	set nocount on

	declare @insc_socio					varchar(255)
  declare @insc_sociolasfar		varchar(255)

	select @insc_socio       = aabasoc_codigo  from aaba_socio       where aabasoc_id  = @@aabasoc_id
	select @insc_sociolasfar = aabasocl_codigo from aaba_sociolasfar where aabasocl_id = @@aabasocl_id

	set @insc_socio       = isnull(@insc_socio,'')
	set @insc_sociolasfar = isnull(@insc_sociolasfar,'')

	select 	insc_id, 
					convert(int,insc_numero) as insc_numero, 
					insc_fecha,
					insc_apellido, 
					insc_nombre, 
					insc_asociacion,
					convert(int,insc_socio) as insc_socio,
					insc_socioLASFAR,
					insc_documento,
					insc_tipodocumento,
					insc_email,
					aabalab_nombre,
					0 as enviada
	
	from aaarbaweb..inscripcion insc left join aaba_laboratorio l on insc.aabalab_id = l.aabalab_id

	where not exists(select * from AABA_InscripcionMail where insc_id = insc.insc_id)
		and (est_id = 1008 or est_id = 5 or aabainsc_pagada <> 0)

		and (insc_socio       = @insc_socio or @insc_socio = '')
		and (insc_socioLASFAR = @insc_sociolasfar or @insc_sociolasfar = '')
		and (insc_tipodocumento = @@insc_tipodocumento or @@insc_documento = '0' or @@insc_documento = '')
		and (insc_documento     = @@insc_documento     or @@insc_documento = '0' or @@insc_documento = '')
		and (insc.aabalab_id 		= @@aabalab_id or @@aabalab_id = 0)

		and (insc_apellido <> 'ha informar por el laboratorio')

	union

	select 	insc_id, 
					convert(int,insc_numero) as insc_numero, 
					insc_fecha,
					insc_apellido, 
					insc_nombre, 
					insc_asociacion,
					convert(int,insc_socio) as insc_socio,
					insc_socioLASFAR,
					insc_documento,
					insc_tipodocumento,
					insc_email,
					aabalab_nombre,
					1 as enviada
	
	from aaarbaweb..inscripcion insc left join aaba_laboratorio l on insc.aabalab_id = l.aabalab_id

	where exists(select * from AABA_InscripcionMail where insc_id = insc.insc_id)
		and (est_id = 1008 or est_id = 5 or aabainsc_pagada <> 0)
		and @@includeAll <> 0

		and (insc_socio       = @insc_socio or @insc_socio = '')
		and (insc_socioLASFAR = @insc_sociolasfar or @insc_sociolasfar = '')
		and (insc_tipodocumento = @@insc_tipodocumento or @@insc_documento = 0)
		and (insc_documento     = @@insc_documento or @@insc_documento = 0)
		and (insc.aabalab_id 		= @@aabalab_id or @@aabalab_id = 0)

		and (insc_apellido <> 'ha informar por el laboratorio')

	order by convert(int,insc_numero),insc_fecha

end

go
