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

  update ManifiestoCarga set MUR_NroPedido = tmp.MUR_NroPedido 
  from ManifiestoCargaTMP tmp
  where ManifiestoCarga.mfc_id = @@mfc_id
    and tmp.mfcTMP_id          = @@mfcTMP_id

  update ManifiestoCargaItem set MUR_Partida = tmp.MUR_Partida
  from ManifiestoCargaItemTMP tmp
  where ManifiestoCargaItem.mfc_id  = @@mfc_id
    and ManifiestoCargaItem.mfci_id = tmp.mfci_id
    and tmp.mfcTMP_id               = @@mfcTMP_id

end
GO