if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaFirmar]

go

/*

sp_DocFacturaVentaFirmar 17,8

*/

create procedure sp_DocFacturaVentaFirmar (
  @@fv_id int,
  @@us_id int
)
as

begin

  declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
  if exists(select fv_firmado from FacturaVenta where fv_id = @@fv_id and fv_firmado <> 0)
  begin

    if exists(select 1 from FacturaVenta where fv_id = @@fv_id and fv_cae <> '') begin

      raiserror ('@@ERROR_SP:No se puede des-firmar un documento que ya posee CAE.', 16, 1)
      return

    end

    update FacturaVenta set fv_firmado = 0 where fv_id = @@fv_id
    set @bFirmar = 1

  -- Sino lo firma
  end else begin

    update FacturaVenta set fv_firmado = @@us_id where fv_id = @@fv_id
    set @bFirmar = 0

  end

  exec sp_DocFacturaVentaSetEstado @@fv_id

  select FacturaVenta.est_id,est_nombre 
  from FacturaVenta inner join Estado on FacturaVenta.est_id = Estado.est_id
  where fv_id = @@fv_id

  if @bFirmar <> 0   exec sp_HistoriaUpdate 16001, @@fv_id, @@us_id, 9
  else               exec sp_HistoriaUpdate 16001, @@fv_id, @@us_id, 10

  if @bFirmar <> 0
    exec sp_FE_RequestCae @@fv_id

end