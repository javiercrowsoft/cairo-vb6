if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoEnvioGetGastos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoEnvioGetGastos]

go

/*

sp_DocPresupuestoEnvioGetGastos 1

*/
create procedure sp_DocPresupuestoEnvioGetGastos (
  @@pree_id int
)
as

begin

  select   PresupuestoEnvioGasto.*, 
          pr_nombreventa, 
          tri.ti_porcentaje as iva_ri_porcentaje,
          trni.ti_porcentaje as iva_rni_porcentaje,
          ccos_nombre,
          trfg_importe,
          gto_nombre

  from   PresupuestoEnvioGasto
        inner join Producto               on PresupuestoEnvioGasto.pr_id = Producto.pr_id
        inner join Gasto                  on PresupuestoEnvioGasto.gto_id = Gasto.gto_id
        left join TarifaGasto             on PresupuestoEnvioGasto.trfg_id = TarifaGasto.trfg_id
        left join tasaimpositiva as tri    on producto.ti_id_ivariventa  = tri.ti_id
        left join tasaimpositiva as trni   on producto.ti_id_ivarniventa = trni.ti_id
        left join centrocosto as ccos     on PresupuestoEnvioGasto.ccos_id = ccos.ccos_id
  where 
      pree_id = @@pree_id

end