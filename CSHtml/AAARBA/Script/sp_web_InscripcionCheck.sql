if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionCheck]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionCheck]

/*


*/

go
create procedure sp_web_InscripcionCheck (
	@@insc_id			int,
	@@bSuccess    tinyint out,
  @@msg         varchar(255) out
)
as

begin

	declare @aabainsc_lasra		tinyint
	declare @aabainsc_aerea		tinyint
	declare @aabainsc_info		tinyint

	declare @aabainsc_lasra_max		tinyint
	declare @aabainsc_aerea_max		tinyint
	declare @aabainsc_info_max		tinyint

	set @aabainsc_lasra_max		=80
	set @aabainsc_aerea_max		=50
	set @aabainsc_info_max		=100

	select @aabainsc_lasra = count(*) from aaarbaweb..inscripcion where aabainsc_lasra <> 0 and insc_id <> IsNull(@@insc_id,0) and (aabainsc_pagada <> 0)
	select @aabainsc_aerea = count(*) from aaarbaweb..inscripcion where aabainsc_aerea <> 0 and insc_id <> IsNull(@@insc_id,0) and (aabainsc_pagada <> 0)
	select @aabainsc_info  = count(*) from aaarbaweb..inscripcion where aabainsc_info  <> 0 and insc_id <> IsNull(@@insc_id,0) and (aabainsc_pagada <> 0)

	set @@bSuccess = 0

	if @aabainsc_lasra >= @aabainsc_lasra_max begin
		set @@msg = '@@ERROR_SP:La cantidad de vacantes para el curso "Jornada Argentina-LASRA" es de '+convert(varchar,@aabainsc_lasra_max)+' y ya no hay vacantes'
		return
	end

	if @aabainsc_aerea >= @aabainsc_aerea_max begin
		set @@msg = '@@ERROR_SP:La cantidad de vacantes para el curso "Vía aérea: nuevos dispositivos" es de '+convert(varchar,@aabainsc_aerea_max)+' y ya no hay vacantes'
		return
	end

	if @aabainsc_info >= @aabainsc_info_max begin
		set @@msg = '@@ERROR_SP:La cantidad de vacantes para el curso "Informática para Anestesiólogos" es de '+convert(varchar,@aabainsc_info_max)+' y ya no hay vacantes'
		return
	end

	set @@bSuccess = 1

end