-- Script de Chequeo de Integridad de:

-- 1 - Control de documentos que mueven stock

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaStockValidateDocPPK]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaStockValidateDocPPK]

go

create procedure sp_AuditoriaStockValidateDocPPK (

	@@ppk_id       int,
	@@aud_id 			int

)
as

begin

  set nocount on

	declare @st_id1  int
	declare @st_id2  int
	declare @doct_id int

	select @st_id1 = st_id1, @st_id2 = st_id2, @doct_id = doct_id from ParteProdKit where ppk_id = @@ppk_id

	if @doct_id = 30 begin 

		exec sp_AuditoriaStockValidateDocPPK2 @@ppk_id, @@aud_id, @st_id1,0
		exec sp_AuditoriaStockValidateDocPPK2 @@ppk_id, @@aud_id, @st_id2,1

	end else begin

		exec sp_AuditoriaStockValidateDocPPK2 @@ppk_id, @@aud_id, @st_id2,0
		exec sp_AuditoriaStockValidateDocPPK2 @@ppk_id, @@aud_id, @st_id1,1

	end
end
go