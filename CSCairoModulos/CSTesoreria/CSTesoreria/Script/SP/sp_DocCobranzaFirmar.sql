if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaFirmar]

go

/*

sp_DocCobranzaFirmar 17,8

*/

create procedure sp_DocCobranzaFirmar (
	@@cobz_id int,
  @@us_id int
)
as

begin

	declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
	if exists(select cobz_firmado from Cobranza where cobz_id = @@cobz_id and cobz_firmado <> 0)
	begin
		update Cobranza set cobz_firmado = 0 where cobz_id = @@cobz_id
		set @bFirmar = 1
	-- Sino lo firma
	end else begin
		update Cobranza set cobz_firmado = @@us_id where cobz_id = @@cobz_id
		set @bFirmar = 0
	end

	exec sp_DocCobranzaSetEstado @@cobz_id

	select Cobranza.est_id,est_nombre 
	from Cobranza inner join Estado on Cobranza.est_id = Estado.est_id
	where cobz_id = @@cobz_id

	if @bFirmar <> 0 	exec sp_HistoriaUpdate 18004, @@cobz_id, @@us_id, 9
	else           		exec sp_HistoriaUpdate 18004, @@cobz_id, @@us_id, 10

end