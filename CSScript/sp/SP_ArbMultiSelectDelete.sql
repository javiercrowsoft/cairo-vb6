if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbMultiSelectDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbMultiSelectDelete]

/*

*/

go
create procedure sp_ArbMultiSelectDelete 
as

begin

  set nocount on

  delete hoja where ram_id in(select ram_id from rama where ram_id_padre = ram_id and ram_id <> 0)
  delete rama where ram_id_padre = ram_id and ram_id <> 0

end