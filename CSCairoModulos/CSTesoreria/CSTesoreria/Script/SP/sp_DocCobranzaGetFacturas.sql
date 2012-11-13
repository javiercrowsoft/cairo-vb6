if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaGetFacturas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaGetFacturas]

go

/*

select * from documentotipo

exec sp_DocCobranzaGetFacturas 6,0,0
exec sp_DocCobranzaGetFacturas 6,1,0
exec sp_DocCobranzaGetFacturas 6,0,1
exec sp_DocCobranzaGetFacturas 6,1,0

*/

create procedure sp_DocCobranzaGetFacturas (
  @@emp_id          int,
	@@cli_id 					int,
  @@bSoloVencidos 	tinyint = 1,
  @@bAgrupado 			tinyint = 0
)
as

begin

declare @doct_factura 		int set @doct_factura 		= 1
declare @doct_notadebito  int set @doct_notadebito  = 9

	if @@bAgrupado = 0 begin

		select 
					f.fv_id,
					fvd_id,
					d.doc_nombre,
					fv_numero,
          fv_nrodoc,
	        fv_fecha,
	        fv_total,
          case fv_cotizacion
						when 0 then   0 
            else	        fvd_pendiente / fv_cotizacion 
          end as fv_totalorigen,
	        fv_pendiente,
          fv_cotizacion,
					mon_nombre,
          f.mon_id,
          fv_descrip,
	        fvd_fecha,
	        fvd_pendiente
	
	  from FacturaVenta f inner join Documento d on f.doc_id = d.doc_id
												inner join FacturaVentaDeuda fd on f.fv_id = fd.fv_id
                        inner join Moneda m on f.mon_id = m.mon_id
		where 
						f.cli_id = @@cli_id
        and (fvd_fecha <= getdate() or @@bSoloVencidos = 0)
				and fvd_pendiente > 0
        and f.doct_id <> 7
        and d.emp_id = @@emp_id
		order by 

					fv_nrodoc,
					fv_fecha
	end
	else begin

		select 
	
					f.fv_id,
					0 as fvd_id,
					d.doc_nombre,
					fv_numero,
          fv_nrodoc,
	        fv_fecha,
	        fv_total,
	        fv_totalorigen,
	        fv_pendiente,
          fv_cotizacion,
					mon_nombre,
          f.mon_id,
          fv_descrip,
          min(fvd_fecha) as fvd_fecha,
					0 as fvd_pendiente
	
	  from FacturaVenta f inner join Documento d on f.doc_id = d.doc_id
												inner join FacturaVentaDeuda fd on f.fv_id = fd.fv_id
                        inner join Moneda m on f.mon_id = m.mon_id
		where 
						f.cli_id = @@cli_id
			and		(f.doct_id = @doct_factura or f.doct_id = @doct_notadebito)
      and 	f.doct_id <> 7
      and   fv_pendiente > 0
      and   d.emp_id = @@emp_id
		group by 

					f.fv_id,
					d.doc_nombre,
					fv_numero,
          fv_nrodoc,
	        fv_fecha,
	        fv_total,
	        fv_totalorigen,
	        fv_pendiente,
          fv_cotizacion,
					mon_nombre,
          f.mon_id,
          fv_descrip

		order by 

					fv_nrodoc,
					fv_fecha
	end
end
go