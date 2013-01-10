if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionLabGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionLabGet]

/*

insert into aaba_inscripcionMail (aabainscm_id,aabainscm_nombre,aabainscm_fecha,modifico,aabainscm_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into aaba_inscripcionMailinscripcion values(4,1,18) 
select * from condicionpago

sp_web_InscripcionLabGet 13

sp_col inscripcion

*/

go
create procedure sp_web_InscripcionLabGet (
  @@insc_id int
)
as

begin

  set nocount on

  select   insc_id, 
          insc_numero, 
          insc_fecha,
          aabalab_nombre
  
  from aaarbaweb..inscripcion insc left join aaba_laboratorio l on insc.aabalab_id = l.aabalab_id

  where insc_id = @@insc_id
  
end

go
