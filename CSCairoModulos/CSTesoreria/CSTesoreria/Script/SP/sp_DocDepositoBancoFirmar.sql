if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoBancoFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoBancoFirmar]

go

/*

sp_DocDepositoBancoFirmar 17,8

*/

create procedure sp_DocDepositoBancoFirmar (
	@@dbco_id int,
  @@us_id int
)
as

begin

	declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
	if exists(select dbco_firmado from DepositoBanco where dbco_id = @@dbco_id and dbco_firmado <> 0)
	begin
		update DepositoBanco set dbco_firmado = 0 where dbco_id = @@dbco_id
		set @bFirmar = 1
	-- Sino lo firma
	end else begin
		update DepositoBanco set dbco_firmado = @@us_id where dbco_id = @@dbco_id
		set @bFirmar = 0
	end

	exec sp_DocDepositoBancoSetEstado @@dbco_id

	select DepositoBanco.est_id,est_nombre 
	from DepositoBanco inner join Estado on DepositoBanco.est_id = Estado.est_id
	where dbco_id = @@dbco_id

	if @bFirmar <> 0 	exec sp_HistoriaUpdate 18007, @@dbco_id, @@us_id, 9
	else           		exec sp_HistoriaUpdate 18007, @@dbco_id, @@us_id, 10

end