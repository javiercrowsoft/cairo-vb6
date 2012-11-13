-- Script de Chequeo de Integridad de:

-- 1 - Control de documentos que mueven stock

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaStockValidateDocRS]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaStockValidateDocRS]

go

create procedure sp_AuditoriaStockValidateDocRS (

	@@rs_id       int,
	@@aud_id 			int

)
as

begin

  set nocount on

	declare @st_id1 int
	declare @st_id2 int

	select @st_id1 = st_id1, @st_id2 = st_id2 from RecuentoStock where rs_id = @@rs_id

	exec sp_AuditoriaStockValidateDocRS2 @@rs_id, @@aud_id, @st_id1
	exec sp_AuditoriaStockValidateDocRS2 @@rs_id, @@aud_id, @st_id2
end
go