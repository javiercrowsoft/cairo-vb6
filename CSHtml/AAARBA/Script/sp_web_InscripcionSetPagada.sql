if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionSetPagada]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionSetPagada]

/*

insert into bgal_archivo (bgalarch_id,bgalarch_nombre,bgalarch_fecha,modifico,bgalarch_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into bgal_archivoinscripcion values(4,1,18) 
select * from condicionpago

sp_web_InscripcionSetPagada 13

sp_columns cuenta_corriente_asociados

*/

go
create procedure sp_web_InscripcionSetPagada (
	@@insc_id			int
)
as

begin

	set nocount on

	update aaarbaweb..inscripcion set aabainsc_pagada = 1 
	where insc_id = @@insc_id

	update aaarbaweb..inscripcion set est_id = 1008
  where insc_id = @@insc_id	
		and est_id <> 7 -- No esta anulada
		and est_id <> 5 -- No esta finalizada

end

go
