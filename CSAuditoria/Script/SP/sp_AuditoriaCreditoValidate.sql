-- Script de Chequeo de Integridad de:

-- 4 - Control de cache de credito

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaCreditoValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaCreditoValidate]

go

create procedure sp_AuditoriaCreditoValidate (

  @@aud_id       int,
  @@aud_fecha   datetime

)
as

begin

  set nocount on

--//////////////////////////////////////////////////////////////////////////////////////////////
--
--
--  CLIENTES
--
--
--//////////////////////////////////////////////////////////////////////////////////////////////


  -- Clientes
  --
  declare @cli_id int

  declare c_audi_vto insensitive cursor for 

      -- Factura de Venta
      --
      select distinct cli_id 
      from FacturaVenta fv
      where fv.modificado >= @@aud_fecha

    union
  
      -- Remito de Venta
      --
      select distinct cli_id 
      from RemitoVenta rv
      where rv.modificado >= @@aud_fecha

    union

      -- Pedido de Venta
      --
      select distinct cli_id 
      from PedidoVenta pv
      where pv.modificado >= @@aud_fecha

    union

      -- Cobranza
      --
      select distinct cli_id 
      from Cobranza cobz 
      where cobz.modificado >= @@aud_fecha

    union

      -- Manifiesto de Carga
      --
      select distinct cli_id 
      from ManifiestoCarga mfc 
      where mfc.modificado >= @@aud_fecha

    union

      -- Packing List
      --
      select distinct cli_id 
      from PackingList pklst 
      where pklst.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @cli_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaCreditoValidateCliente @cli_id, @@aud_id

    fetch next from c_audi_vto into @cli_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- Factura de Venta
  --
  declare @fv_id int

  declare c_audi_vto insensitive cursor for 

    select fv_id 
    from FacturaVenta fv
    where fv.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @fv_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaCreditoValidateDocFV @fv_id, @@aud_id

    fetch next from c_audi_vto into @fv_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- Remito de Venta
  --
  declare @rv_id int

  declare c_audi_vto insensitive cursor for 

    select rv_id 
    from RemitoVenta rv
    where rv.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @rv_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaCreditoValidateDocRV @rv_id, @@aud_id

    fetch next from c_audi_vto into @rv_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- Pedido de Venta
  --
  declare @pv_id int

  declare c_audi_vto insensitive cursor for 

    select pv_id 
    from PedidoVenta pv
    where pv.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @pv_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaCreditoValidateDocPV @pv_id, @@aud_id

    fetch next from c_audi_vto into @pv_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- Cobranza
  --
  declare @cobz_id int

  declare c_audi_vto insensitive cursor for 

    select cobz_id 
    from Cobranza cobz 
    where cobz.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @cobz_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaCreditoValidateDocCOBZ @cobz_id, @@aud_id

    fetch next from c_audi_vto into @cobz_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- ManifiestoCarga
  --
  declare @mfc_id int

  declare c_audi_vto insensitive cursor for 

    select mfc_id 
    from ManifiestoCarga mfc 
    where mfc.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @mfc_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaCreditoValidateDocMFC @mfc_id, @@aud_id

    fetch next from c_audi_vto into @mfc_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- PackingList
  --
  declare @pklst_id int

  declare c_audi_vto insensitive cursor for 

    select pklst_id 
    from PackingList pklst 
    where pklst.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @pklst_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaCreditoValidateDocPKLST @pklst_id, @@aud_id

    fetch next from c_audi_vto into @pklst_id
  end

  close c_audi_vto

  deallocate c_audi_vto


--//////////////////////////////////////////////////////////////////////////////////////////////
--
--
--  PROVEEDORES
--
--
--//////////////////////////////////////////////////////////////////////////////////////////////


  -- Proveedores
  --
  declare @prov_id int

  declare c_audi_vto insensitive cursor for 

      -- Factura de Compra
      --
      select distinct prov_id 
      from FacturaCompra fc
      where fc.modificado >= @@aud_fecha

    union
  
      -- Remito de Compra
      --
      select distinct prov_id 
      from RemitoCompra rc
      where rc.modificado >= @@aud_fecha

    union

      -- Orden de Compra
      --
      select distinct prov_id 
      from OrdenCompra oc
      where oc.modificado >= @@aud_fecha

    union

      -- Orden de Pago
      --
      select distinct prov_id 
      from OrdenPago opg 
      where opg.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @prov_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaCreditoValidateProveedor @prov_id, @@aud_id

    fetch next from c_audi_vto into @prov_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- Factura de Compra
  --
  declare @fc_id int

  declare c_audi_vto insensitive cursor for 

    select fc_id 
    from FacturaCompra fc 
    where fc.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @fc_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaCreditoValidateDocFC @fc_id, @@aud_id

    fetch next from c_audi_vto into @fc_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- Remito de Compra
  --
  declare @rc_id int

  declare c_audi_vto insensitive cursor for 

    select rc_id 
    from RemitoCompra rc 
    where rc.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @rc_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaCreditoValidateDocRC @rc_id, @@aud_id

    fetch next from c_audi_vto into @rc_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- Orden de Compra
  --
  declare @oc_id int

  declare c_audi_vto insensitive cursor for 

    select oc_id 
    from OrdenCompra oc 
    where oc.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @oc_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaCreditoValidateDocOC @oc_id, @@aud_id

    fetch next from c_audi_vto into @oc_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- Orden de Pago
  --
  declare @opg_id int

  declare c_audi_vto insensitive cursor for 

    select opg_id 
    from OrdenPago opg 
    where opg.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @opg_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaCreditoValidateDocOPG @opg_id, @@aud_id

    fetch next from c_audi_vto into @opg_id
  end

  close c_audi_vto

  deallocate c_audi_vto

ControlError:

end
GO