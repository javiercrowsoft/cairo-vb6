begin tran

declare @pr_id int, @ccos_id_compra int, @ccos_id_venta int, @cue_id_compra int, @cue_id_venta int

declare c_producto insensitive cursor for
	select pr.pr_id, ccos_id_compra, ccos_id_venta, cuegc.cue_id, cuegv.cue_id 
	from producto pr left join cuentagrupo cuegc on pr.cueg_id_compra = cuegc.cueg_id
									 left join cuentagrupo cuegv on pr.cueg_id_venta = cuegv.cueg_id

open c_producto

fetch next from c_producto into @pr_id, @ccos_id_compra, @ccos_id_venta, @cue_id_compra, @cue_id_venta
while @@fetch_status=0
begin

	if @ccos_id_compra is not null begin

		update FacturaCompraItem set ccos_id = @ccos_id_compra where pr_id = @pr_id and ccos_id is null
		update OrdenCompraItem   set ccos_id = @ccos_id_compra where pr_id = @pr_id and ccos_id is null
		update RemitoCompraItem  set ccos_id = @ccos_id_compra where pr_id = @pr_id and ccos_id is null

		update AsientoItem set ccos_id = @ccos_id_compra 
		where ccos_id is null
			and as_id in (select as_id 
										from FacturaCompra fc 
												inner join FacturaCompraItem fci 
													on fc.fc_id = fci.fc_id 
										where fci.pr_id = @pr_id
										)
	end


	if @ccos_id_venta is not null begin

		update FacturaVentaItem set ccos_id = @ccos_id_venta where pr_id = @pr_id and ccos_id is null
		update PedidoVentaItem  set ccos_id = @ccos_id_venta where pr_id = @pr_id and ccos_id is null
		update RemitoVentaItem  set ccos_id = @ccos_id_venta where pr_id = @pr_id and ccos_id is null

		update AsientoItem set ccos_id = @ccos_id_venta 
		where ccos_id is null
			and as_id in (select as_id 
										from FacturaVenta fv
												inner join FacturaVentaItem fvi 
													on fv.fv_id = fvi.fv_id 
										where fvi.pr_id = @pr_id
										)
	end

	fetch next from c_producto into @pr_id, @ccos_id_compra, @ccos_id_venta, @cue_id_compra, @cue_id_venta
end

close c_producto

deallocate c_producto

declare @opg_id int
declare @ccos_id int

declare c_opg insensitive cursor for

select opg_id, isnull(fc.ccos_id,fci.ccos_id)
from facturacompra fc inner join facturacompraitem fci on fc.fc_id = fci.fc_id
where opg_id is not null
and isnull(fc.ccos_id,fci.ccos_id) is not null

open c_opg

fetch next from c_opg into @opg_id, @ccos_id

while @@fetch_status=0
begin

	update AsientoItem set ccos_id = @ccos_id 
	where as_id in (select as_id from OrdenPago where opg_id = @opg_id)
	and ccos_id is null

	fetch next from c_opg into @opg_id, @ccos_id
end
close c_opg
deallocate c_opg

rollback tran