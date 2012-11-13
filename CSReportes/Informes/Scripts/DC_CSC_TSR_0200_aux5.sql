/*---------------------------------------------------------------------
Nombre: Gastos por Rubro
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0200_aux5]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0200_aux5]

/*

*/

go
create procedure DC_CSC_TSR_0200_aux5 (

	@pr_id_inc		int,
	@pr_id_exc		int,
	@pr_id_exc2		int,
	@clienteID		int,
	@clienteID2		int,
	@clienteID3		int,

	@ram_id_producto_inc 	int,
	@ram_id_producto_exc 	int,
	@ram_id_producto_exc2	int,
	@ram_id_cuenta				int,

	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@tipo     int

)as 

begin

set nocount on

		-- 2- Obtengo todos los costos por articulo de compra
		--
		
		insert into #t_costos(pr_id, cue_id, importe, mes)
		
			select 	fci.pr_id, 
							null,
							sum(case fc.doct_id when 8 then -fci_neto else fci_neto end),
							convert(varchar(7),fc_fecha,111)
		
			from FacturaCompra fc inner join FacturaCompraItem fci on fc.fc_id = fci.fc_id
			where fc_fecha between @@Fini and @@Ffin
				and est_id <> 7
		
				and (fci.pr_id =  @pr_id_inc or @pr_id_inc=0)
				and (fci.pr_id <> @pr_id_exc or @pr_id_exc=0)
				and (fci.pr_id <> @pr_id_exc2 or @pr_id_exc2=0)
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

				-- Ojo esto que viene aca abajo es bastante raro
				-- 
				-- Esto siginifica exclui los que te pido que excluyas
				-- pero no los que ya te pedi que incluyas
				--
				-- Ejemplo te pido los ids   23, 45, 89
				--
				--         y te pido que excluyas los ids 21, 22, '23', 42, '45', 18, '89'
				--
				-- Como ven estoy excluyendo lo que pedi
				--
				-- Pero el efecto deseado no es ese
				--
				-- Por esta razon el primer not exists solo toma encuenta
				-- los que no existen en el segundo subselect
				--

		    and   (		-- 1re subselect
		    					(not 
		               exists(select rptarb_hojaid 
		                      from rptArbolRamaHoja r
		                      where
		                           rptarb_cliente = @clienteID2
		                      and  tbl_id = 30 
		                      and  rptarb_hojaid = fci.pr_id

													-- 2do subselect
													and (not  
															 exists(select rptarb_hojaid 
								                      from rptArbolRamaHoja 
								                      where
								                           rptarb_cliente = @clienteID
								                      and  tbl_id = 30 
								                      and  rptarb_hojaid = fci.pr_id
																			and  rptarb_hojaid = r.rptarb_hojaid
								    							   ) 
									             or 
									    					 (@ram_id_producto_inc = 0)

															)
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
		                           rptarb_cliente = @clienteID3
		                      and  tbl_id = 30 
		                      and  rptarb_hojaid = fci.pr_id
		    							   ) 
		               )
		            or 
		    					 (@ram_id_producto_exc2 = 0)
		    			 )
		
			group by fci.pr_id, convert(varchar(7),fc_fecha,111)

/*		
			union all
		
			select 	null, 
							perct.cue_id,
							sum(fcperc_importe),
							convert(varchar(7),fc_fecha,111)
		
			from FacturaCompra fc inner join FacturaCompraPercepcion fcperc on fc.fc_id = fcperc.fc_id
														inner join Percepcion perc on fcperc.perc_id = perc.perc_id
													  inner join PercepcionTipo perct on perc.perct_id = perct.perct_id
			where fc_fecha between @@Fini and @@Ffin
				and est_id <> 7
		
			group by perct.cue_id, convert(varchar(7),fc_fecha,111)
		
			union all
		
			select 	null, 
							fcot.cue_id,
							sum(fcot_debe-fcot_haber),
							convert(varchar(7),fc_fecha,111)
		
			from FacturaCompra fc inner join FacturaCompraOtro fcot on fc.fc_id = fcot.fc_id
			where fc_fecha between @@Fini and @@Ffin
				and est_id <> 7
		
			group by fcot.cue_id, convert(varchar(7),fc_fecha,111)

*/

		update #t_costos set importe = importe*-1
		
		/*- ///////////////////////////////////////////////////////////////////////
		
					TABLA DE RESULTADOS
		
		/////////////////////////////////////////////////////////////////////// */
		exec DC_CSC_TSR_0200_aux3 @@Fini, @@Ffin, 2 /*compras*/

end

GO