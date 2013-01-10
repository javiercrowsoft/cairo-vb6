if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraUpdatePrecios]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraUpdatePrecios]

/*

 sp_DocOrdenCompraUpdatePrecios 93

*/

go
create procedure sp_DocOrdenCompraUpdatePrecios (
  @@oc_id int
)
as

begin

  set nocount on

  declare @rci_id      int
  declare @rc_id      int
  declare @precio      decimal(18,6)

  declare c_oci_precios insensitive cursor for

    select rci_id, oci_precio 
    from OrdenCompraItem oci inner join OrdenRemitoCompra ocrc on oci.oci_id = ocrc.oci_id
    where oc_id = @@oc_id

  open c_oci_precios

  fetch next from c_oci_precios into @rci_id, @precio
  while @@fetch_status=0
  begin

    update RemitoCompraItem set rci_precio     = @precio, 
                                rci_preciousr  = @precio, 
                                rci_neto       = @precio * rci_cantidad, 
                                rci_ivari     = @precio * (ti_porcentaje/100) * rci_cantidad,
                                rci_importe   = @precio * (1+ti_porcentaje/100) * rci_cantidad 
    from Producto p inner join TasaImpositiva t 
                      on     p.ti_id_ivaricompra = t.ti_id
                                              
    where rci_id = @rci_id
      and  p.pr_id = RemitoCompraItem.pr_id

    fetch next from c_oci_precios into @rci_id, @precio
  end

  close c_oci_precios
  deallocate c_oci_precios

  declare @neto decimal(18,6)
  declare @iva  decimal(18,6)

  declare c_oci_precios insensitive cursor for

    select distinct rci.rc_id
    from OrdenCompraItem oci inner join OrdenRemitoCompra ocrc on oci.oci_id  = ocrc.oci_id
                             inner join RemitoCompraItem rci   on ocrc.rci_id = rci.rci_id
    where oc_id = @@oc_id
  
  open c_oci_precios

  fetch next from c_oci_precios into @rc_id
  while @@fetch_status=0
  begin

    select @neto = sum(rci_neto), @iva = sum(rci_ivari) from RemitoCompraItem where rc_id = @rc_id

    update RemitoCompra set rc_neto     = @neto, 
                            rc_ivari     = @iva, 
                            rc_subtotal = @neto,
                            rc_total     = @neto + @iva
    where rc_id = @rc_id

    exec sp_DocRemitoCompraSetCredito @rc_id, 0

    fetch next from c_oci_precios into @rc_id
  end

  close c_oci_precios
  deallocate c_oci_precios


  --/////////////////////////////////////////////////////////////////////////////////////////////
  --
    update OrdenCompraItem  set oci_neto       = oci_precio * oci_cantidad, 
                                oci_ivari     = oci_precio * (ti_porcentaje/100) * oci_cantidad,
                                oci_importe   = oci_precio * (1+ti_porcentaje/100) * oci_cantidad 
    from Producto p inner join TasaImpositiva t 
                      on     p.ti_id_ivaricompra = t.ti_id
                                              
    where oc_id = @@oc_id
      and  p.pr_id = OrdenCompraItem.pr_id


  --/////////////////////////////////////////////////////////////////////////////////////////////
  --

  select @neto = sum(oci_neto), @iva = sum(oci_ivari) from OrdenCompraItem where oc_id = @@oc_id

  update OrdenCompra  set oc_neto     = @neto, 
                          oc_ivari     = @iva, 
                          oc_subtotal = @neto,
                          oc_total     = @neto + @iva
  where oc_id = @@oc_id

  exec sp_DocOrdenCompraSetCredito @@oc_id, 0

end