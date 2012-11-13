delete PedidoVentaItemStock where exists(select * from pedidoventa pv where pv.pv_id = PedidoVentaItemStock.pv_id and (pv.est_id = 5 or pv.est_id = 7))
delete PedidoVentaItemStock where exists(select * from producto pr where pr.pr_id = PedidoVentaItemStock.pr_id and pr_llevastock =0)
