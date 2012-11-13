/*---------------------------------------------------------------------
Nombre: Ingresos y Egresos 12 meses
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0220_aux6]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0220_aux6]

/*

*/

go
create procedure DC_CSC_TSR_0220_aux6 (

	@pr_id_inc		int,
	@pr_id_exc		int,
	@clienteID		int,
	@clienteID2		int,

	@ram_id_producto_inc 	int,
	@ram_id_producto_exc 	int,
	@ram_id_cuenta				int,

	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@tipo     int

)as 

begin

set nocount on

		-- - Obtengo todas las ventas
		--
		
		insert into #t_costos(pr_id, cue_id, importe, mes)
		
			select 	fvi.pr_id, 
							null,
							sum(case fv.doct_id when 7 then -fvi_importe else fvi_importe end),
							convert(varchar(7),fv_fecha,111)
		
			from FacturaVenta fv inner join FacturaVentaItem fvi on fv.fv_id = fvi.fv_id
			where fv_fecha between @@Fini and @@Ffin
				and est_id <> 7
		
				and (fvi.pr_id =  @pr_id_inc or @pr_id_inc=0)
				and (fvi.pr_id <> @pr_id_exc or @pr_id_exc=0)
		    and   (
		    					(exists(select rptarb_hojaid 
		                      from rptArbolRamaHoja 
		                      where
		                           rptarb_cliente = @clienteID
		                      and  tbl_id = 30 
		                      and  rptarb_hojaid = fvi.pr_id
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
		                      and  rptarb_hojaid = fvi.pr_id
		    							   ) 
		               )
		            or 
		    					 (@ram_id_producto_exc = 0)
		    			 )
		
			group by fvi.pr_id, convert(varchar(7),fv_fecha,111)
		
			union all
		
			select 	null, 
							perct.cue_id,
							sum(case fv.doct_id when 7 then -fvperc_importe else fvperc_importe end),
							convert(varchar(7),fv_fecha,111)
		
			from FacturaVenta fv inner join FacturaVentaPercepcion fvperc on fv.fv_id = fvperc.fv_id
													 inner join Percepcion perc on fvperc.perc_id = perc.perc_id
													 inner join PercepcionTipo perct on perc.perct_id = perct.perct_id
			where fv_fecha between @@Fini and @@Ffin
				and est_id <> 7
		
			group by perct.cue_id, convert(varchar(7),fv_fecha,111)
		
		/*- ///////////////////////////////////////////////////////////////////////
		
					TABLA DE RESULTADOS
		
		/////////////////////////////////////////////////////////////////////// */
		exec DC_CSC_TSR_0220_aux3 @@Fini, @@Ffin, 1 /*ventas*/

end

GO