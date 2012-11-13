if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_HistoriaUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_HistoriaUpdate]

--   /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%%'*/
--   exec sp_HistoriaUpdate tbl_id, _id, @@us_id, 0

go
create procedure sp_HistoriaUpdate (
  @@tbl_id          int,
  @@id              int,
  @@modifico        int,
  @@hst_operacion   tinyint,
  @@hst_descrip     varchar(7500) = ''
)
as
begin

  set nocount on

  if not exists(select * from usuario where us_id = @@modifico) return

  insert into Historia(tbl_id,id,modifico,hst_operacion,hst_descrip) 
                values(@@tbl_id,IsNull(@@id,0),@@modifico,@@hst_operacion,IsNull(@@hst_descrip,''))

end
go