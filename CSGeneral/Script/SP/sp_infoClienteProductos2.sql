if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClienteProductos2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClienteProductos2]

/*

sp_infoClienteProductos 1,1,34

*/

go
create procedure sp_infoClienteProductos2 (
	@@us_id         int,
	@@emp_id        int,
	@@cli_id        int,
	@@info_aux      varchar(255) = ''
)
as

begin

	set nocount on

	declare @fDesde datetime

	set @fDesde = dateadd(d,-180,getdate())

	select 	top 40

					fv.doct_id,
					fv.fv_id, 
					pr_nombreventa  as [Artículo],
					fv_fecha 				as Fecha,
					fv_nrodoc				as Comprobante,

					(case when fv.doct_id = 7 then -fvi_cantidad    else fvi_cantidad	 end) as Cantidad,
					(case when fv.doct_id = 7 then -fvi_precio      else fvi_precio    end) as Precio,
					(case when fv.doct_id = 7 then -fvi_importe     else fvi_importe   end) as Importe,
					(case when fv.doct_id = 7 then -fvi_pendiente 	else fvi_pendiente end) as Pendiente,

					emp_nombre      as Empresa,
					fvi_descrip     as Observaciones

	from FacturaVenta fv inner join FacturaVentaItem fvi  on fv.fv_id  = fvi.fv_id
											 inner join Producto pr           on fvi.pr_id = pr.pr_id
											 inner join Empresa emp           on fv.emp_id = emp.emp_id

	where cli_id = @@cli_id 
		and fv_fecha >= @fDesde
		and est_id <> 7

	union all

	select 	top 40

					pv.doct_id,
					pv.pv_id, 
					pr_nombreventa  as [Artículo],
					pv_fecha 				as Fecha,
					pv_nrodoc				as Comprobante,

					(case when pv.doct_id = 22 then -pvi_cantidad    else pvi_cantidad	end) as Cantidad,
					(case when pv.doct_id = 22 then -pvi_precio      else pvi_precio    end) as Precio,
					(case when pv.doct_id = 22 then -pvi_importe     else pvi_importe   end) as Importe,
					(case when pv.doct_id = 22 then -pvi_pendiente 	 else pvi_pendiente end) as Pendiente,

					emp_nombre      as Empresa,
					pvi_descrip     as Observaciones

	from PedidoVenta pv  inner join PedidoVentaItem pvi   on pv.pv_id  = pvi.pv_id
											 inner join Producto pr           on pvi.pr_id = pr.pr_id
											 inner join Empresa emp 					on pv.emp_id = emp.emp_id

	where cli_id = @@cli_id 
		and pv_fecha >= @fDesde
		and est_id <> 7

	union all

	select 	top 40

					rv.doct_id,
					rv.rv_id, 
					pr_nombreventa  	as [Artículo],
					rv_fecha 					as Fecha,
					rv_nrodoc					as Comprobante,

					(case when rv.doct_id = 24 then -rvi_cantidad    		else rvi_cantidad			end) as Cantidad,
					(case when rv.doct_id = 24 then -rvi_precio      		else rvi_precio    		end) as Precio,
					(case when rv.doct_id = 24 then -rvi_importe     		else rvi_importe   		end) as Importe,
					(case when rv.doct_id = 24 then -rvi_pendientefac 	else rvi_pendientefac end) as Pendiente,

					emp_nombre      	as Empresa,
					rvi_descrip       as Observaciones

	from RemitoVenta rv  inner join RemitoVentaItem rvi   on rv.rv_id  = rvi.rv_id
											 inner join Producto pr           on rvi.pr_id = pr.pr_id
											 inner join Empresa emp 					on rv.emp_id = emp.emp_id

	where cli_id = @@cli_id 
		and rv_fecha >= @fDesde
		and est_id <> 7

	order by pr_nombreventa, fv_fecha, fv.fv_id, emp_nombre

end
go