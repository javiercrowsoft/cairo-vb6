if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocManifiestoCargaUpdateEx]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocManifiestoCargaUpdateEx]

/*

 exec sp_DocManifiestoCargaUpdateEx 2,1

*/

go
create procedure sp_DocManifiestoCargaUpdateEx (
  @@mfcTMP_id int,
  @@mfc_id    int
)
as

begin

  set nocount on

end
GO