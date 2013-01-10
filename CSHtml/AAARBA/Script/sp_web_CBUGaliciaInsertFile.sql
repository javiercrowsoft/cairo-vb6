if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_CBUGaliciaInsertFile]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_CBUGaliciaInsertFile]

/*

insert into bgal_archivo (bgalarch_id,bgalarch_nombre,bgalarch_fecha,modifico,bgalarch_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into bgal_archivoinscripcion values(4,1,18) 
select * from condicionpago

sp_web_CBUGaliciaInsertFile 13

sp_col inscripcion

*/

go
create procedure sp_web_CBUGaliciaInsertFile (
  @@archivo varchar(255),
  @@fecha   datetime,
  @@tipo    tinyint,
  @@us_id   int
)
as

begin

  set nocount on

  declare @bgalarch_id int

  exec SP_DBGetNewId 'BGAL_Archivo', 'bgalarch_id', @bgalarch_id out, 0

  insert into bgal_archivo (bgalarch_id, bgalarch_nombre, bgalarch_fecha, bgalarch_tipo, modifico)
                     values(@bgalarch_id, @@archivo, @@fecha, @@tipo, @@us_id)

  select @bgalarch_id
  
end

go
