if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaFirmar]

go

/*

RemitoVenta                   reemplazar por el nombre del documento Ej. PedidoVenta
@@rv_id                     reemplazar por el id del documento ej pv_id  (incluir arrobas)
RemitoVenta                 reemplazar por el nombre de la tabla ej PedidoVenta
rv_id                     reemplazar por el campo ID ej. pv_id
del remito de venta                  reemplazar por el texto de error ej. del pedido de venta
rv_firmado                reemplazar por el campo pv_firmado

sp_DocRemitoVentaFirmar 17,8

*/

create procedure sp_DocRemitoVentaFirmar (
	@@rv_id int,
  @@us_id int
)
as

begin

	declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
	if exists(select rv_firmado from RemitoVenta where rv_id = @@rv_id and rv_firmado <> 0)
	begin
		update RemitoVenta set rv_firmado = 0 where rv_id = @@rv_id
		set @bFirmar = 1
	-- Sino lo firma
	end else begin
		update RemitoVenta set rv_firmado = @@us_id where rv_id = @@rv_id
		set @bFirmar = 0
	end

	exec sp_DocRemitoVentaSetEstado @@rv_id

	select RemitoVenta.est_id,est_nombre 
	from RemitoVenta inner join Estado on RemitoVenta.est_id = Estado.est_id
	where rv_id = @@rv_id

	if @bFirmar <> 0 	exec sp_HistoriaUpdate 16002, @@rv_id, @@us_id, 9
	else           		exec sp_HistoriaUpdate 16002, @@rv_id, @@us_id, 10

end