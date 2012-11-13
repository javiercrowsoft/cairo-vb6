if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoEnvioFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoEnvioFirmar]

go

/*

PresupuestoEnvio                   reemplazar por el nombre del documento Ej. PedidoVenta
@@pree_id                     reemplazar por el id del documento ej pv_id  (incluir 2 arrobas (@@))
PresupuestoEnvio                 reemplazar por el nombre de la tabla ej PedidoVenta
pree_id                     reemplazar por el campo ID ej. pv_id
del presupuesto                  reemplazar por el texto de error ej. del pedido de venta
pree_firmado                reemplazar por el campo pv_firmado

sp_DocPresupuestoEnvioFirmar 17,8

*/

create procedure sp_DocPresupuestoEnvioFirmar (
	@@pree_id int,
  @@us_id int
)
as

begin

  -- Si esta firmado le quita la firma
	if exists(select pree_firmado from PresupuestoEnvio where pree_id = @@pree_id and pree_firmado <> 0)
		update PresupuestoEnvio set pree_firmado = 0 where pree_id = @@pree_id
	-- Sino lo firma
	else
		update PresupuestoEnvio set pree_firmado = @@us_id where pree_id = @@pree_id

	exec sp_DocPresupuestoEnvioSetEstado @@pree_id

	select PresupuestoEnvio.est_id,est_nombre 
	from PresupuestoEnvio inner join Estado on PresupuestoEnvio.est_id = Estado.est_id
	where pree_id = @@pree_id
end