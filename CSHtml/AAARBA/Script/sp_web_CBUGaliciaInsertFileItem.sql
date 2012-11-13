if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_CBUGaliciaInsertFileItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_CBUGaliciaInsertFileItem]

/*

insert into bgal_archivo (bgalarch_id,bgalarch_nombre,bgalarch_fecha,modifico,bgalarch_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into bgal_archivoinscripcion values(4,1,18) 
select * from condicionpago

sp_web_CBUGaliciaInsertFileItem 13

sp_col inscripcion

*/

go
create procedure sp_web_CBUGaliciaInsertFileItem (
	@@bgalarch_id		int,
  @@insc_id				int
)
as

begin

	set nocount on

	declare @bgalarchinsc_id int

	exec SP_DBGetNewId 'BGAL_ArchivoInscripcion', 'bgalarchinsc_id', @bgalarchinsc_id out, 0

	insert into bgal_archivoinscripcion (bgalarchinsc_id, bgalarch_id, insc_id)
                     values(@bgalarchinsc_id, @@bgalarch_id, @@insc_id)

end

go
