SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoGetFacturasCairo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoGetFacturasCairo]
GO




/*

select * from documentotipo

exec sp_DocOrdenPagoGetFacturas 6,0,0
exec sp_DocOrdenPagoGetFacturas 6,1,0
exec sp_DocOrdenPagoGetFacturas 6,0,1
exec sp_DocOrdenPagoGetFacturas 6,1,0

*/

CREATE procedure sp_DocOrdenPagoGetFacturasCairo (
  @@emp_id            int,
	@@prov_id 					int,
  @@bSoloVencidos 	  tinyint = 1,
  @@bAgrupado 			  tinyint = 0
)
as

begin

declare @doct_factura 		int set @doct_factura 		= 1
declare @doct_notadebito  int set @doct_notadebito  = 9

	if @@bAgrupado = 0 begin

		select 
					f.fc_id,
					fcd_id,
					d.doc_nombre,
					fc_numero,
          fc_nrodoc,
	        fc_fecha,
	        fc_total,
          case fc_cotizacion
						when 0 then   0 
            else	        fcd_pendiente / fc_cotizacion 
          end as fc_totalorigen,
	        fc_pendiente,
          fc_cotizacion,
					mon_nombre,
          f.mon_id,
          fc_descrip,
	        fcd_fecha,
	        fcd_pendiente
	
	  from FacturaCompra f inner join Documento d on f.doc_id = d.doc_id
												inner join FacturaCompraDeuda fd on f.fc_id = fd.fc_id
                        inner join Moneda m on f.mon_id = m.mon_id
		where 
						f.prov_id = @@prov_id
        and (fcd_fecha <= getdate() or @@bSoloVencidos = 0)
				and fc_pendiente > 0
        and f.doct_id <> 8
        and d.emp_id = @@emp_id
		order by 

					fc_nrodoc,
					fc_fecha
	end
	else begin

		select 
	
					f.fc_id,
					0 as fcd_id,
					d.doc_nombre,
					fc_numero,
          fc_nrodoc,
	        fc_fecha,
	        fc_total,
	        fc_totalorigen,
	        fc_pendiente,
          fc_cotizacion,
					mon_nombre,
          f.mon_id,
          fc_descrip,
          min(fcd_fecha) as fcd_fecha,
					0 as fcd_pendiente
	
	  from FacturaCompra f inner join Documento d on f.doc_id = d.doc_id
												inner join FacturaCompraDeuda fd on f.fc_id = fd.fc_id
                        inner join Moneda m on f.mon_id = m.mon_id
		where 
						f.prov_id = @@prov_id
			and		(f.doct_id = @doct_factura or f.doct_id = @doct_notadebito)
			and 	fc_pendiente > 0
      and 	f.doct_id <> 8
      and   d.emp_id = @@emp_id
		group by 

					f.fc_id,
					d.doc_nombre,
					fc_numero,
          fc_nrodoc,
	        fc_fecha,
	        fc_total,
	        fc_totalorigen,
	        fc_pendiente,
          fc_cotizacion,
					mon_nombre,
          f.mon_id,
          fc_descrip

		order by 

					fc_nrodoc,
					fc_fecha
	end
end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



