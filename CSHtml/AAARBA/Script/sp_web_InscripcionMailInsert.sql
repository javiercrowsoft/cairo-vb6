if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionMailInsert]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionMailInsert]

/*

insert into aaba_inscripcionMail (aabainscm_id,aabainscm_nombre,aabainscm_fecha,modifico,aabainscm_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into aaba_inscripcionMailinscripcion values(4,1,18) 
select * from condicionpago

sp_web_InscripcionMailInsert 13

sp_col aaba_inscripcionmail

*/

go
create procedure sp_web_InscripcionMailInsert (
  @@insc_id int,
  @@mail    varchar(255),
  @@texto   varchar(255),
  @@us_id   int
)
as

begin

  set nocount on

  declare @aabainscm_id int

  exec SP_DBGetNewId 'AABA_InscripcionMail', 'aabainscm_id', @aabainscm_id out, 0

  insert into aaba_inscripcionMail (aabainscm_id, insc_id, AABAinscm_mail, AABAinscm_texto, modifico)
                              values(@aabainscm_id, @@insc_id, @@mail, @@texto, @@us_id)

  update aaarbaweb..inscripcion set est_id = 5 where insc_id = @@insc_id

  select @aabainscm_id
  
end

go
