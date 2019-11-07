if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaWizardSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaWizardSave]

/*
  Proposito: - Agrupo todos los articulos por pr_id
             - Cargo las cuentas del producto y de la tasa impositiva


  select * from facturaventaitemtmp

 sp_DocFacturaVentaWizardSave 124

*/

go
create procedure sp_DocFacturaVentaWizardSave (
	@@fvTMP_id 			int
)
as

begin

	set nocount on

	-- Agrupo todos los articulos por pr_id	(Por ahora no esta listo)

	-- Cargo las cuentas del producto y de la tasa impositiva

	update FacturaVentaItemTMP set
															FacturaVentaItemTMP.cue_id  					= IsNull(ccg.cue_id,cg.cue_id),
															FacturaVentaItemTMP.cue_id_ivari 		  = tiri.cue_id,
															FacturaVentaItemTMP.cue_id_ivarni 		= tirni.cue_id

			from 	Producto p
						inner join TasaImpositiva tiri on p.ti_id_ivariventa = tiri.ti_id
						inner join TasaImpositiva tirni on p.ti_id_ivarniventa = tirni.ti_id
						inner join CuentaGrupo cg  on p.cueg_id_venta = cg.cueg_id
						left join ClienteCuentaGrupo ccg on cg.cueg_id = ccg.cueg_id
						left join FacturaVentaTMP t on t.cli_id = ccg.cli_id
			where
						FacturaVentaItemTMP.fvTMP_id 	= @@fvTMP_id
				and FacturaVentaItemTMP.fvTMP_id 	= t.fvTMP_id

				and	FacturaVentaItemTMP.pr_id = p.pr_id




end
