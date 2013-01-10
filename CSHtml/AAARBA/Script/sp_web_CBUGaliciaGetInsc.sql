if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_CBUGaliciaGetInsc]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_CBUGaliciaGetInsc]

/*

insert into bgal_archivo (bgalarch_id,bgalarch_nombre,bgalarch_fecha,modifico,bgalarch_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into bgal_archivoinscripcion values(4,1,18) 
select * from condicionpago

sp_web_CBUGaliciaGetInsc 13

sp_col inscripcion

*/

go
create procedure sp_web_CBUGaliciaGetInsc (
  @@insc_id int
)
as

begin

  set nocount on

  select   insc_id, 
          insc_numero, 
          insc_fecha,
          insc_apellido, 
          insc_nombre, 
          insc_asociacion,
          insc_socio,
          insc_socioLASFAR,
          insc_documento,
          insc_tipodocumento,
          AABAinsc_nroCBU
  
  from aaarbaweb..inscripcion insc 

  where insc_id = @@insc_id
  
end

go
