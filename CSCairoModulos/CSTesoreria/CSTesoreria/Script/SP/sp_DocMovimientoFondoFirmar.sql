if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoFirmar]

go

/*

sp_DocMovimientoFondoFirmar 17,8

*/

create procedure sp_DocMovimientoFondoFirmar (
  @@mf_id int,
  @@us_id int
)
as

begin

  declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
  if exists(select mf_firmado from MovimientoFondo where mf_id = @@mf_id and mf_firmado <> 0)
  begin
    update MovimientoFondo set mf_firmado = 0 where mf_id = @@mf_id
    set @bFirmar = 1
  -- Sino lo firma
  end else begin
    update MovimientoFondo set mf_firmado = @@us_id where mf_id = @@mf_id
    set @bFirmar = 0
  end

  exec sp_DocMovimientoFondoSetEstado @@mf_id

  select MovimientoFondo.est_id,est_nombre 
  from MovimientoFondo inner join Estado on MovimientoFondo.est_id = Estado.est_id
  where mf_id = @@mf_id

  if @bFirmar <> 0   exec sp_HistoriaUpdate 18006, @@mf_id, @@us_id, 9
  else               exec sp_HistoriaUpdate 18006, @@mf_id, @@us_id, 10

end