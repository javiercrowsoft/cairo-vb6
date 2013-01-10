if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocLiquidacionFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocLiquidacionFirmar]

go

/*

sp_DocLiquidacionFirmar 17,8

*/

create procedure sp_DocLiquidacionFirmar (
  @@liq_id int,
  @@us_id int
)
as

begin

  declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
  if exists(select liq_firmado from Liquidacion where liq_id = @@liq_id and liq_firmado <> 0)
  begin
    update Liquidacion set liq_firmado = 0 where liq_id = @@liq_id
    set @bFirmar = 1
  -- Sino lo firma
  end else begin
    update Liquidacion set liq_firmado = @@us_id where liq_id = @@liq_id
    set @bFirmar = 0
  end

  exec sp_DocLiquidacionSetEstado @@liq_id

  select Liquidacion.est_id,est_nombre 
  from Liquidacion inner join Estado on Liquidacion.est_id = Estado.est_id
  where liq_id = @@liq_id

  if @bFirmar <> 0   exec sp_HistoriaUpdate 35012, @@liq_id, @@us_id, 9
  else               exec sp_HistoriaUpdate 35012, @@liq_id, @@us_id, 10

end