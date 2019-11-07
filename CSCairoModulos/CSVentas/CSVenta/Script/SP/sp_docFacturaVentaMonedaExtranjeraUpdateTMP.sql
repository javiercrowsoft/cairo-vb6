alter procedure sp_docFacturaVentaMonedaExtranjeraUpdateTMP  (
	@@fvTMP_id int
)
as

begin

	set nocount on

	declare @mon_id int
  declare @cotizacion decimal(18,6)

	select @mon_id = doc.mon_id, @cotizacion = fv_cotizacion
  from FacturaVentaTMP fv inner join Documento doc on fv.doc_id = doc.doc_id
  where fvTMP_id = @@fvTMP_id

  if exists(select 1 from Moneda where mon_legal <> 0 and mon_id = @mon_id) return

	update FacturaVentaTMP
		set fv_total = round(fv_totalorigen,2) * fv_cotizacion,
        fv_neto = round(fv_netoorigen,2) * fv_cotizacion,
        fv_ivari = round(fv_ivariorigen,2) * fv_cotizacion
	where fvTMP_id = @@fvTMP_id


	update FacturaVentaItemTMP
		set fvi_importe = round(fvi_importeorigen,2) * @cotizacion,
        fvi_neto = round(fvi_netoorigen,2) * @cotizacion,
        fvi_precio = round(fvi_precioorigen,2) * @cotizacion,
        fvi_ivari = round(fvi_ivariorigen,2) * @cotizacion,
				fvi_internos = round(fvi_internosorigen,2) * @cotizacion

	where fvTMP_id = @@fvTMP_id

end
