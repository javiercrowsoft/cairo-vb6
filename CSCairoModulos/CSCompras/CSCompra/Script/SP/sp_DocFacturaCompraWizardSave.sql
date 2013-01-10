if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraWizardSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraWizardSave]

/*
  Proposito: - Agrupo todos los articulos por pr_id
             - Cargo las cuentas del producto y de la tasa impositiva


  select * from facturaCompraitemtmp

 sp_DocFacturaCompraWizardSave 124

*/

go
create procedure sp_DocFacturaCompraWizardSave (
  @@fcTMP_id       int
)
as

begin

  set nocount on

  -- Agrupo todos los articulos por pr_id  (Por ahora no esta listo)

  -- Cargo las cuentas del producto y de la tasa impositiva

  update FacturaCompraItemTMP set 
                              FacturaCompraItemTMP.cue_id            = IsNull(pcg.cue_id,cg.cue_id),
                              FacturaCompraItemTMP.cue_id_ivari     = tiri.cue_id,
                              FacturaCompraItemTMP.cue_id_ivarni     = tirni.cue_id

      from   Producto p, 
            TasaImpositiva tiri, 
            TasaImpositiva tirni,
            ProveedorCuentaGrupo pcg, 
            CuentaGrupo cg,
            FacturaCompraTMP t

      where 
            FacturaCompraItemTMP.fcTMP_id = @@fcTMP_id
        and FacturaCompraItemTMP.fcTMP_id = t.fcTMP_id

        and  FacturaCompraItemTMP.pr_id    = p.pr_id

        and p.ti_id_ivaricompra           = tiri.ti_id 
        and p.ti_id_ivarnicompra           = tirni.ti_id 

        and p.cueg_id_compra              = cg.cueg_id 
        and cg.cueg_id                    *= pcg.cueg_id 
        and t.prov_id                     *= pcg.prov_id

end