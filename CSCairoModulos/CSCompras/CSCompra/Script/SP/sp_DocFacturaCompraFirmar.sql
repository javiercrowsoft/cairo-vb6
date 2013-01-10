if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraFirmar]

go

/*

sp_DocFacturaCompraFirmar 17,8

*/

create procedure sp_DocFacturaCompraFirmar (
  @@fc_id int,
  @@us_id int
)
as

begin

  declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
  if exists(select fc_firmado from FacturaCompra where fc_id = @@fc_id and fc_firmado <> 0)
  begin
    update FacturaCompra set fc_firmado = 0 where fc_id = @@fc_id
    set @bFirmar = 1
  -- Sino lo firma
  end else begin
    update FacturaCompra set fc_firmado = @@us_id where fc_id = @@fc_id
    set @bFirmar = 0
  end

  exec sp_DocFacturaCompraSetEstado @@fc_id

  select FacturaCompra.est_id,est_nombre 
  from FacturaCompra inner join Estado on FacturaCompra.est_id = Estado.est_id
  where fc_id = @@fc_id

  if @bFirmar <> 0   exec sp_HistoriaUpdate 17001, @@fc_id, @@us_id, 9
  else               exec sp_HistoriaUpdate 17001, @@fc_id, @@us_id, 10

end