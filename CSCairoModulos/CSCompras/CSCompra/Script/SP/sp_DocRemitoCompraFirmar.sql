if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraFirmar]

go

/*

RemitoCompra                   reemplazar por el nombre del documento Ej. PedidoVenta
@@rc_id                     reemplazar por el id del documento ej pv_id  (incluir 2 arrobas (@@))
RemitoCompra                 reemplazar por el nombre de la tabla ej PedidoVenta
rc_id                     reemplazar por el campo ID ej. pv_id
rc_firmado                reemplazar por el campo pv_firmado

sp_DocRemitoCompraFirmar 17,8

*/

create procedure sp_DocRemitoCompraFirmar (
	@@rc_id int,
  @@us_id int
)
as

begin

	declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
	if exists(select rc_firmado from RemitoCompra where rc_id = @@rc_id and rc_firmado <> 0)
	begin
		update RemitoCompra set rc_firmado = 0 where rc_id = @@rc_id
		set @bFirmar = 1
	-- Sino lo firma
	end else begin
		update RemitoCompra set rc_firmado = @@us_id where rc_id = @@rc_id
		set @bFirmar = 0
	end

	exec sp_DocRemitoCompraSetEstado @@rc_id

	select RemitoCompra.est_id,est_nombre 
	from RemitoCompra inner join Estado on RemitoCompra.est_id = Estado.est_id
	where rc_id = @@rc_id

	if @bFirmar <> 0 	exec sp_HistoriaUpdate 17003, @@rc_id, @@us_id, 9
	else           		exec sp_HistoriaUpdate 17003, @@rc_id, @@us_id, 10

end