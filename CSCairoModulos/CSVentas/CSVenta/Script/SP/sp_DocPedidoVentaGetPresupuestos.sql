if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaGetPresupuestos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaGetPresupuestos]

go

/*

update Presupuestoventa set prv_nrodoc = prv_numero
exec sp_DocPedidoVentaGetPresupuestos 1,6,2

*/

create procedure sp_DocPedidoVentaGetPresupuestos (
	@@emp_id					int,
	@@cli_id 					int,
  @@mon_id          int
)
as

begin

declare @doct_Presupuesto 		int set @doct_Presupuesto 		= 11

	select 

				prv.prv_id,
				d.doc_nombre,
				prv_numero,
        prv_nrodoc,
        prv_fecha,
        prv_total,
        prv_pendiente,
        prv_descrip

  from PresupuestoVenta prv inner join Documento d 	on prv.doc_id = d.doc_id
														inner join Moneda m 		on d.mon_id = m.mon_id
	where 
					prv.cli_id  = @@cli_id
    and   prv.est_id <> 7 -- Anulado
		and		prv.doct_id = @doct_Presupuesto
    and   d.mon_id 	 = @@mon_id
		and   d.emp_id   = @@emp_id
    and   exists(select prvi_id from PresupuestoVentaItem where prv_id = prv.prv_id and prvi_pendiente > 0)

	order by 

				prv_nrodoc,
				prv_fecha
end
go