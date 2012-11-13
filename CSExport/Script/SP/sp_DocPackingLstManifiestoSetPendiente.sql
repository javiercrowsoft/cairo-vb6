if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingLstManifiestoSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingLstManifiestoSetPendiente]

/*

 sp_DocPackingLstManifiestoSetPendiente 91

*/

GO
create procedure sp_DocPackingLstManifiestoSetPendiente (
	@@pklst_id 			int,
  @@bSuccess      tinyint = 0 out
)
as

begin

	set nocount on

	set @@bSuccess = 0

	declare @MsgError  varchar(5000) set @MsgError = ''

	-- Finalmente actualizo el pendiente de los Manifiestos
	--
	declare @mfc_id int

	declare c_ManifiestoPendiente insensitive cursor for 
		select distinct mfc_id 
		from ManifiestoPackingList mfcpklst inner join PackingListItem pklsti    on mfcpklst.pklsti_id = pklsti.pklsti_id
															          inner join ManifiestoCargaItem mfci  on mfcpklst.mfci_id   = mfci.mfci_id
		where pklst_id = @@pklst_id
	union
		select mfc_id from #ManifiestoPacking
	
	open c_ManifiestoPendiente
	fetch next from c_ManifiestoPendiente into @mfc_id
	while @@fetch_status = 0 begin
		-- Actualizo la deuda del Manifiesto
		exec sp_DocManifiestoCargaSetPendiente @mfc_id, @@bSuccess out

		-- Si fallo al guardar
		if IsNull(@@bSuccess,0) = 0 goto ControlError

		-- Estado
		exec sp_DocManifiestoCargaSetCredito @mfc_id
		exec sp_DocManifiestoCargaSetEstado @mfc_id

		fetch next from c_ManifiestoPendiente into @mfc_id
	end
	close c_ManifiestoPendiente
	deallocate c_ManifiestoPendiente

	set @@bSuccess = 1

	return
ControlError:

	set @MsgError = 'Ha ocurrido un error al actualizar el pendiente del manifiesto de carga. sp_DocPackingLstManifiestoSetPendiente. ' + IsNull(@MsgError,'')
	raiserror (@MsgError, 16, 1)

end

GO