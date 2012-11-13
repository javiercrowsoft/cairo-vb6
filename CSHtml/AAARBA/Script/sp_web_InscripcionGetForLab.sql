if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionGetForLab]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionGetForLab]

/*

insert into aaba_inscripcionMail (aabainscm_id,aabainscm_nombre,aabainscm_fecha,modifico,aabainscm_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into aaba_inscripcionMailinscripcion values(4,1,18) 
select * from condicionpago

sp_web_InscripcionGetForLab 0,10001,10400

sp_col inscripcion

*/

go
create procedure sp_web_InscripcionGetForLab (
	@@aabalab_id 		int,
	@@desde         varchar(30),
	@@hasta         varchar(30)
)
as

begin

	declare @desde int
	declare @hasta int

	if isnumeric(@@desde)<> 0 set @desde = convert(int,@@desde)
	if isnumeric(@@hasta)<> 0 set @hasta = convert(int,@@hasta)

	set nocount on

	select 	insc_id, 
					insc_numero, 
					insc_fecha,
					aabalab_nombre
	
	from aaarbaweb..inscripcion insc left join aaba_laboratorio l on insc.aabalab_id = l.aabalab_id

	where insc_numero between @desde and @hasta
		and (insc.aabalab_id = @@aabalab_id or @@aabalab_id = 0)
	
end

go
