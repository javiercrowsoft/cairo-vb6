if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVentaFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVentaFirmar]

go

/*

sp_DocPresupuestoVentaFirmar 17,8

*/

create procedure sp_DocPresupuestoVentaFirmar (
  @@prv_id int,
  @@us_id int
)
as

begin

  declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
  if exists(select prv_firmado from PresupuestoVenta where prv_id = @@prv_id and prv_firmado <> 0)
  begin
    update PresupuestoVenta set prv_firmado = 0 where prv_id = @@prv_id
    set @bFirmar = 1
  -- Sino lo firma
  end else begin
    update PresupuestoVenta set prv_firmado = @@us_id where prv_id = @@prv_id
    set @bFirmar = 0
  end

  exec sp_DocPresupuestoVentaSetEstado @@prv_id

  select PresupuestoVenta.est_id,est_nombre 
  from PresupuestoVenta inner join Estado on PresupuestoVenta.est_id = Estado.est_id
  where prv_id = @@prv_id

  if @bFirmar <> 0   exec sp_HistoriaUpdate 16004, @@prv_id, @@us_id, 9
  else               exec sp_HistoriaUpdate 16004, @@prv_id, @@us_id, 10

end