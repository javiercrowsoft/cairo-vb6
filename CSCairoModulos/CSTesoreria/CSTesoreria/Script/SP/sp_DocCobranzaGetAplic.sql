if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaGetAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaGetAplic]

go

/*

delete facturaventacobranza
delete facturaventapago

select * from cobranza

exec sp_DocCobranzaGetAplic 15

sp_columns FacturaVentaCobranza

*/
create procedure sp_DocCobranzaGetAplic (
  @@emp_id        int,
  @@cobz_id       int
)
as
begin

  declare @cli_id int

  select @cli_id = cli_id from Cobranza where cobz_id = @@cobz_id

  select fvcobz_id,
         fvcobz_importe,
         fvcobz_importeOrigen,
         fvcobz_cotizacion,
         fvd.fvd_id,
         fvp.fvp_id,
         fv.fv_id,
         fv_nrodoc,
         doc_nombre,
         fvd_fecha,
         fvd_pendiente,
         fvp_fecha,
         0 as orden

  from FacturaVentaCobranza fvc  inner join FacturaVenta fv on fvc.fv_id = fv.fv_id
                                 inner join Documento d     on fv.doc_id = d.doc_id
                                 left  join FacturaVentaDeuda fvd on fvc.fvd_id = fvd.fvd_id
                                 left  join FacturaVentaPago  fvp on fvc.fvp_id = fvp.fvp_id
  where fvc.cobz_id = @@cobz_id

  union 

  select 0 as fvcob_id,
         0 as fvcob_importe,
         0 as fvcobz_importeOrigen,
         fv_cotizacion as fvcobz_cotizacion,
         fvd_id,
         0 as fvp_id,
         fv.fv_id,
         fv_nrodoc,
         doc_nombre,
         fvd_fecha,
         fvd_pendiente,
         null as fvp_fecha,
         1    as orden

  from FacturaVenta fv inner join Documento d           on fv.doc_id = d.doc_id
                       inner join FacturaVentaDeuda fvd on fv.fv_id = fvd.fv_id

  where not exists (select fv_id from FacturaVentaCobranza where cobz_id = @@cobz_id and fv_id = fv.fv_id)

    and fv.est_id <> 7

    -- Empresa
    and d.emp_id = @@emp_id

    and fv.cli_id = @cli_id

    and fv.doct_id <> 7
    and Round(fv_pendiente,2) > 0

  order by orden,fv_nrodoc,fvd_fecha 

end

go