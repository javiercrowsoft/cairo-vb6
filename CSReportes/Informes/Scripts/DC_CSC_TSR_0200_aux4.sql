/*---------------------------------------------------------------------
Nombre: Gastos por Rubro
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0200_aux4]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0200_aux4]

/*

*/

go
create procedure DC_CSC_TSR_0200_aux4 (

	@cue_id				int,
	@pr_id_inc		int,
	@pr_id_exc		int,
	@ccos_id_exc	int,

	@clienteID		int,
	@clienteID2		int,

	@ram_id_producto_inc 			int,
	@ram_id_producto_exc 			int,
	@ram_id_cuenta						int,
	@ram_id_centrocosto_exc		int,

	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@tipo     int

)as 

begin

set nocount on

		-- 2- Obtengo todos los costos por articulo de compra
		--
		
		insert into #t_costos(pr_id, cue_id, importe, mes)
		
			select 	null,--fci.pr_id, 
							null,
							sum(case fc.doct_id when 8 then -fci_neto else fci_neto end),
							convert(varchar(7),fc_fecha,111)
		
			from FacturaCompra fc inner join FacturaCompraItem fci on fc.fc_id = fci.fc_id
			where fc_fecha between @@Fini and @@Ffin
				and est_id <> 7
		
				and (fci.pr_id 	 =  @pr_id_inc 		or @pr_id_inc=0)
				and (fci.pr_id 	 <> @pr_id_exc 		or @pr_id_exc=0)
				and (fci.ccos_id <> @ccos_id_exc 	or @ccos_id_exc=0)
		    and   (
		    					(exists(select rptarb_hojaid 
		                      from rptArbolRamaHoja 
		                      where
		                           rptarb_cliente = @clienteID
		                      and  tbl_id = 30 
		                      and  rptarb_hojaid = fci.pr_id
		    							   ) 
		               )
		            or 
		    					 (@ram_id_producto_inc = 0)
		    			 )
		    and   (
		    					(not 
		               exists(select rptarb_hojaid 
		                      from rptArbolRamaHoja 
		                      where
		                           rptarb_cliente = @clienteID2
		                      and  tbl_id = 30 
		                      and  rptarb_hojaid = fci.pr_id
		    							   ) 
		               )
		            or 
		    					 (@ram_id_producto_exc = 0)
		    			 )

		    and   (
		    					(not 
		               exists(select rptarb_hojaid 
		                      from rptArbolRamaHoja 
		                      where
		                           rptarb_cliente = @clienteID
		                      and  tbl_id = 21
		                      and  rptarb_hojaid = fci.ccos_id
		    							   ) 
		               )
		            or 
		    					 (@ram_id_centrocosto_exc = 0)
		    			 )
		
			group by fci.pr_id, convert(varchar(7),fc_fecha,111)
		
			union all
		
			select 	null, 
							null, --perct.cue_id,
							sum(case fc.doct_id when 8 then -fcperc_importe else fcperc_importe end),
							convert(varchar(7),fc_fecha,111)
		
			from FacturaCompra fc inner join FacturaCompraPercepcion fcperc on fc.fc_id = fcperc.fc_id
														inner join Percepcion perc on fcperc.perc_id = perc.perc_id
													  inner join PercepcionTipo perct on perc.perct_id = perct.perct_id
			where fc_fecha between @@Fini and @@Ffin
				and est_id <> 7
		
			group by perct.cue_id, convert(varchar(7),fc_fecha,111)
		
			union all
		
			select 	null, 
							null,--fcot.cue_id,
							sum(case fc.doct_id when 8 then -(fcot_debe-fcot_haber) else (fcot_debe-fcot_haber) end),
							convert(varchar(7),fc_fecha,111)
		
			from FacturaCompra fc inner join FacturaCompraOtro fcot on fc.fc_id = fcot.fc_id
			where fc_fecha between @@Fini and @@Ffin
				and est_id <> 7
		
			group by fcot.cue_id, convert(varchar(7),fc_fecha,111)
		
			-- Cuentas de tipo egresos tocadas en Movimientos de fondos
			--
			union all
		
			select 	null,
							null,--mfi.cue_id_debe,
							sum(mfi_importe),
							convert(varchar(7),mf_fecha,111)
			from MovimientoFondo mf inner join MovimientoFondoItem mfi on mf.mf_id = mfi.mf_id
															inner join Cuenta cue on mfi.cue_id_debe = cue.cue_id
			where mf_fecha between @@Fini and @@Ffin
				and est_id <> 7
				and cue.cuec_id in (5		--Bienes de Uso
														,6	--Bienes de Cambio
														,7	--Cuentas Fiscales
														,8	--Acreedores por Compras
														,9	--Ingresos
														,10	--Egresos
														,12	--Costos de Mercaderia Vendida
														,13	--Otros
														,15	--Bienes de Uso
														,16	--Locaciones
														,17	--Servicios
														,18	--Bienes
														)
		
		-- Arboles
		and (mfi.cue_id_debe	= @cue_id or @cue_id=0)
		and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 17 and rptarb_hojaid = mfi.cue_id_debe)) or (@ram_id_cuenta = 0))
		
			group by mfi.cue_id_debe, convert(varchar(7),mf_fecha,111)
		
			-- Cuentas de tipo egresos tocadas en Movimientos de fondos
			--
			union all
		
			select 	null,
							null,--mfi.cue_id_haber,
							-sum(mfi_importe),
							convert(varchar(7),mf_fecha,111)
			from MovimientoFondo mf inner join MovimientoFondoItem mfi on mf.mf_id = mfi.mf_id
															inner join Cuenta cue on mfi.cue_id_haber = cue.cue_id
			where mf_fecha between @@Fini and @@Ffin
				and est_id <> 7
				and cue.cuec_id in (5		--Bienes de Uso
														,6	--Bienes de Cambio
														,7	--Cuentas Fiscales
														,8	--Acreedores por Compras
														,9	--Ingresos
														,10	--Egresos
														,12	--Costos de Mercaderia Vendida
														,13	--Otros
														,15	--Bienes de Uso
														,16	--Locaciones
														,17	--Servicios
														,18	--Bienes
														)
		
		-- Arboles
		and (mfi.cue_id_haber	= @cue_id or @cue_id=0)
		and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 17 and rptarb_hojaid = mfi.cue_id_haber)) or (@ram_id_cuenta = 0))
		
			group by mfi.cue_id_haber, convert(varchar(7),mf_fecha,111)

		update #t_costos set importe = importe*-1

		/*- ///////////////////////////////////////////////////////////////////////
		
					TABLA DE RESULTADOS
		
		/////////////////////////////////////////////////////////////////////// */
		exec DC_CSC_TSR_0200_aux3 @@Fini, @@Ffin, 3 /*gastos*/

end

GO