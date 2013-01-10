if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraFirmar]

go

/*

OrdenCompra                   reemplazar por el nombre del documento Ej. OrdenVenta
@@oc_id                     reemplazar por el id del documento ej pv_id  (incluir 2 arrobas (@@))
OrdenCompra                 reemplazar por el nombre de la tabla ej OrdenVenta
oc_id                     reemplazar por el campo ID ej. pv_id
oc_firmado                reemplazar por el campo pv_firmado

sp_DocOrdenCompraFirmar 17,8

*/

create procedure sp_DocOrdenCompraFirmar (
  @@oc_id int,
  @@us_id int
)
as

begin

  declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
  if exists(select oc_firmado from OrdenCompra where oc_id = @@oc_id and oc_firmado <> 0)
  begin
    update OrdenCompra set oc_firmado = 0 where oc_id = @@oc_id
    set @bFirmar = 1
  -- Sino lo firma
  end else begin
    update OrdenCompra set oc_firmado = @@us_id where oc_id = @@oc_id
    set @bFirmar = 0
  end

  exec sp_DocOrdenCompraSetEstado @@oc_id

  select OrdenCompra.est_id,est_nombre 
  from OrdenCompra inner join Estado on OrdenCompra.est_id = Estado.est_id
  where oc_id = @@oc_id

  if @bFirmar <> 0   exec sp_HistoriaUpdate 17004, @@oc_id, @@us_id, 9
  else               exec sp_HistoriaUpdate 17004, @@oc_id, @@us_id, 10

end