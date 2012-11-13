if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioFirmar]

go

/*

OrdenServicio                   reemplazar por el nombre del documento Ej. PedidoVenta
@@os_id                     reemplazar por el id del documento ej pv_id  (incluir 2 arrobas (@@))
OrdenServicio                 reemplazar por el nombre de la tabla ej PedidoVenta
os_id                     reemplazar por el campo ID ej. pv_id
os_firmado                reemplazar por el campo pv_firmado

sp_DocOrdenServicioFirmar 17,8

*/

create procedure sp_DocOrdenServicioFirmar (
	@@os_id int,
  @@us_id int
)
as

begin

	declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
	if exists(select os_firmado from OrdenServicio where os_id = @@os_id and os_firmado <> 0)
	begin
		update OrdenServicio set os_firmado = 0 where os_id = @@os_id
		set @bFirmar = 1
	-- Sino lo firma
	end else begin
		update OrdenServicio set os_firmado = @@us_id where os_id = @@os_id
		set @bFirmar = 0
	end

	exec sp_DocOrdenServicioSetEstado @@os_id

	select OrdenServicio.est_id,est_nombre 
	from OrdenServicio inner join Estado on OrdenServicio.est_id = Estado.est_id
	where os_id = @@os_id

	if @bFirmar <> 0 	exec sp_HistoriaUpdate 28008, @@os_id, @@us_id, 9
	else           		exec sp_HistoriaUpdate 28008, @@os_id, @@us_id, 10

end