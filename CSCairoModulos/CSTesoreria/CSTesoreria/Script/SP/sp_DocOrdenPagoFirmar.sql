if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoFirmar]

go

/*

sp_DocOrdenPagoFirmar 17,8

*/

create procedure sp_DocOrdenPagoFirmar (
	@@opg_id int,
  @@us_id int
)
as

begin

	declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
	if exists(select opg_firmado from OrdenPago where opg_id = @@opg_id and opg_firmado <> 0)
	begin
		update OrdenPago set opg_firmado = 0 where opg_id = @@opg_id
		set @bFirmar = 1
	-- Sino lo firma
	end else begin
		update OrdenPago set opg_firmado = @@us_id where opg_id = @@opg_id
		set @bFirmar = 0
	end

	exec sp_DocOrdenPagoSetEstado @@opg_id

	select OrdenPago.est_id,est_nombre 
	from OrdenPago inner join Estado on OrdenPago.est_id = Estado.est_id
	where opg_id = @@opg_id


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                     HISTORIAL DE MODIFICACIONES                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @bFirmar <> 0 	exec sp_HistoriaUpdate 18005, @@opg_id, @@us_id, 9
	else           		exec sp_HistoriaUpdate 18005, @@opg_id, @@us_id, 10

end