if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_inscripcionUpdateDeuda]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_inscripcionUpdateDeuda]

/*

insert into bgal_archivo (bgalarch_id,bgalarch_nombre,bgalarch_fecha,modifico,bgalarch_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into bgal_archivoinscripcion values(4,1,18) 
select * from condicionpago

sp_web_inscripcionUpdateDeuda 13

sp_col inscripcion

*/

go
create procedure sp_web_inscripcionUpdateDeuda(
	@@insc_id 			int,
	@@deuda         int,
	@@what          tinyint
)
as

begin

	set nocount on

  declare @@csETC_Congreso tinyint
  declare @@csETC_LASRA    tinyint
  declare @@csETC_Aerea    tinyint
  declare @@csETC_Info     tinyint
	declare @@csETC_Acomp    tinyint

  set @@csETC_Congreso 	= 1
  set @@csETC_LASRA 		= 2
  set @@csETC_Aerea 		= 3
  set @@csETC_Info 			= 4
	set @@csETC_Acomp 		= 5

	if @@what = @@csETC_Congreso update aaarbaweb..inscripcion 
																		set AABAinsc_deuda = @@deuda
															 where insc_id = @@insc_id

	if @@what = @@csETC_LASRA    update aaarbaweb..inscripcion 
																		set AABAinsc_deudaLASRA = @@deuda
															 where insc_id = @@insc_id

	if @@what = @@csETC_Aerea    update aaarbaweb..inscripcion 
																		set AABAinsc_deudaAerea = @@deuda
															 where insc_id = @@insc_id

	if @@what = @@csETC_Info     update aaarbaweb..inscripcion 
																		set AABAinsc_deudaInfo = @@deuda
															 where insc_id = @@insc_id

	if @@what = @@csETC_Acomp    update aaarbaweb..inscripcion 
																		set AABAinsc_deudaAcomp = @@deuda
															 where insc_id = @@insc_id
end

go
