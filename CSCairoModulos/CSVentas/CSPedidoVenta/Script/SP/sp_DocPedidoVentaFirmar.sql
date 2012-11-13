if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaFirmar]

go

/*

sp_DocPedidoVentaFirmar 17,8

*/

create procedure sp_DocPedidoVentaFirmar (
	@@pv_id int,
  @@us_id int
)
as

begin

	declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
	if exists(select pv_firmado from PedidoVenta where pv_id = @@pv_id and pv_firmado <> 0)
	begin
		update PedidoVenta set pv_firmado = 0 where pv_id = @@pv_id
		set @bFirmar = 1
	-- Sino lo firma
	end else begin
		update PedidoVenta set pv_firmado = @@us_id where pv_id = @@pv_id
		set @bFirmar = 0
	end

	exec sp_DocPedidoVentaSetEstado @@pv_id

	select PedidoVenta.est_id,est_nombre 
	from PedidoVenta inner join Estado on PedidoVenta.est_id = Estado.est_id
	where pv_id = @@pv_id

	if @bFirmar <> 0 	exec sp_HistoriaUpdate 16003, @@pv_id, @@us_id, 9
	else           		exec sp_HistoriaUpdate 16003, @@pv_id, @@us_id, 10

end