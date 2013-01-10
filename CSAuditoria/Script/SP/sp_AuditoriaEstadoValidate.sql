-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidate]

go

create procedure sp_AuditoriaEstadoValidate (

  @@aud_id       int,
  @@aud_fecha   datetime

)
as

begin

  set nocount on

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

    exec sp_AuditoriaEstadoValidateDocFV @fv_id, @@aud_id

    fetch next from c_audi_vto into @fv_id
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

    exec sp_AuditoriaEstadoValidateDocFC @fc_id, @@aud_id

    fetch next from c_audi_vto into @fc_id
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

    exec sp_AuditoriaEstadoValidateDocRV @rv_id, @@aud_id

    fetch next from c_audi_vto into @rv_id
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

    exec sp_AuditoriaEstadoValidateDocRC @rc_id, @@aud_id

    fetch next from c_audi_vto into @rc_id
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

    exec sp_AuditoriaEstadoValidateDocPV @pv_id, @@aud_id

    fetch next from c_audi_vto into @pv_id
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

    exec sp_AuditoriaEstadoValidateDocOC @oc_id, @@aud_id

    fetch next from c_audi_vto into @oc_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- Pedido de Compra
  --
  declare @pc_id int

  declare c_audi_vto insensitive cursor for 

    select pc_id 
    from PedidoCompra pc 
    where pc.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @pc_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaEstadoValidateDocPC @pc_id, @@aud_id

    fetch next from c_audi_vto into @pc_id
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

    exec sp_AuditoriaEstadoValidateDocOPG @opg_id, @@aud_id

    fetch next from c_audi_vto into @opg_id
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

    exec sp_AuditoriaEstadoValidateDocCOBZ @cobz_id, @@aud_id

    fetch next from c_audi_vto into @cobz_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- PresupuestoVenta
  --
  declare @prv_id int

  declare c_audi_vto insensitive cursor for 

    select prv_id 
    from PresupuestoVenta prv 
    where prv.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @prv_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaEstadoValidateDocPRV @prv_id, @@aud_id

    fetch next from c_audi_vto into @prv_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- DepositoBanco
  --
  declare @dbco_id int

  declare c_audi_vto insensitive cursor for 

    select dbco_id 
    from DepositoBanco dbco 
    where dbco.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @dbco_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaEstadoValidateDocDBCO @dbco_id, @@aud_id

    fetch next from c_audi_vto into @dbco_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- ResolucionCupon
  --
  declare @rcup_id int

  declare c_audi_vto insensitive cursor for 

    select rcup_id 
    from ResolucionCupon rcup 
    where rcup.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @rcup_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaEstadoValidateDocRCUP @rcup_id, @@aud_id

    fetch next from c_audi_vto into @rcup_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- CotizacionCompra
  --
  declare @cot_id int

  declare c_audi_vto insensitive cursor for 

    select cot_id 
    from CotizacionCompra cot 
    where cot.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @cot_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaEstadoValidateDocCOT @cot_id, @@aud_id

    fetch next from c_audi_vto into @cot_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- PresupuestoEnvio
  --
  declare @pree_id int

  declare c_audi_vto insensitive cursor for 

    select pree_id 
    from PresupuestoEnvio pree 
    where pree.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @pree_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaEstadoValidateDocPREE @pree_id, @@aud_id

    fetch next from c_audi_vto into @pree_id
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

    exec sp_AuditoriaEstadoValidateDocMFC @mfc_id, @@aud_id

    fetch next from c_audi_vto into @mfc_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- PresupuestoCompra
  --
  declare @prc_id int

  declare c_audi_vto insensitive cursor for 

    select prc_id 
    from PresupuestoCompra prc 
    where prc.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @prc_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaEstadoValidateDocPRC @prc_id, @@aud_id

    fetch next from c_audi_vto into @prc_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- MovimientoFondo
  --
  declare @mf_id int

  declare c_audi_vto insensitive cursor for 

    select mf_id 
    from MovimientoFondo mf 
    where mf.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @mf_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaEstadoValidateDocMF @mf_id, @@aud_id

    fetch next from c_audi_vto into @mf_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- DepositoCupon
  --
  declare @dcup_id int

  declare c_audi_vto insensitive cursor for 

    select dcup_id 
    from DepositoCupon dcup 
    where dcup.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @dcup_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaEstadoValidateDocDCUP @dcup_id, @@aud_id

    fetch next from c_audi_vto into @dcup_id
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

    exec sp_AuditoriaEstadoValidateDocPKLST @pklst_id, @@aud_id

    fetch next from c_audi_vto into @pklst_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- ImportacionTemp
  --
  declare @impt_id int

  declare c_audi_vto insensitive cursor for 

    select impt_id 
    from ImportacionTemp impt 
    where impt.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @impt_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaEstadoValidateDocIMPT @impt_id, @@aud_id

    fetch next from c_audi_vto into @impt_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- PermisoEmbarque
  --
  declare @pemb_id int

  declare c_audi_vto insensitive cursor for 

    select pemb_id 
    from PermisoEmbarque pemb 
    where pemb.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @pemb_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaEstadoValidateDocPEMB @pemb_id, @@aud_id

    fetch next from c_audi_vto into @pemb_id
  end

  close c_audi_vto

  deallocate c_audi_vto

ControlError:

end
GO