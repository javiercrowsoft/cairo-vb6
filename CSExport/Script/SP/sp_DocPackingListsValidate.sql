if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListsValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListsValidate]

/*

	exec	sp_DocPackingListsValidate

*/

go
create procedure sp_DocPackingListsValidate 
as

begin

	exec sp_DocPackingListsSetPendiente 
	exec sp_DocPackingListsSetEstado
end 

go