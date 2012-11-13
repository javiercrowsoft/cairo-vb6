
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDespachoImpCalculoGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDespachoImpCalculoGetItems]

go


/*

sp_DocDespachoImpCalculoGetItems 0

*/

create procedure sp_DocDespachoImpCalculoGetItems (
@@dic_id int
)as 
begin

	set nocount on

	create table #t_spdocdespimp_aux (aux int)
	insert into #t_spdocdespimp_aux values(1)

	declare @codigo_ex_work 		int 	set @codigo_ex_work 		= 1
	declare @codigo_seguro  		int 	set @codigo_seguro  		= 2
	declare @codigo_embalaje    int 	set @codigo_embalaje 		= 3
	declare @codigo_totalfob  	int 	set @codigo_totalfob 		= -3
	declare @codigo_flete     	int 	set @codigo_flete 			= 4
	declare @codigo_totalcif  	int 	set @codigo_totalcif 		= -5
	declare @codigo_derechos  	int 	set @codigo_derechos 		= 6
	declare @codigo_estadist  	int 	set @codigo_estadist 		= 7
	declare @codigo_totalcifde  int 	set @codigo_totalcifde 	= -8
	declare @codigo_iva21       int 	set @codigo_iva21 	    = 9
	declare @codigo_iva3431_91  int 	set @codigo_iva3431_91 	= 10
	declare @codigo_gan3543_92  int 	set @codigo_gan3543_92  = 11
	declare @codigo_igb         int 	set @codigo_igb    	    = 12

	declare @codigo_gastosloc   int 	set @codigo_gastosloc		= -13
	declare @codigo_sim         int 	set @codigo_sim    	    = 14
	declare @codigo_honodesp    int 	set @codigo_honodesp    = 15
	declare @codigo_digital_doc int   set @codigo_digital_doc = 25
	declare @codigo_gastosenvio int   set @codigo_gastosenvio = 26
	declare @codigo_gtogsan     int 	set @codigo_gtogsan	    = 16
	declare @codigo_gtopba      int 	set @codigo_gtopba	    = 27
	declare @codigo_almacen     int 	set @codigo_almacen	    = 17
	declare @codigo_ley25413    int 	set @codigo_ley25413	  = 18
	declare @codigo_acarreo     int 	set @codigo_acarreo	    = 19
	declare @codigo_gastos      int 	set @codigo_gastos	    = 20
	declare @codigo_ivagastos   int 	set @codigo_ivagastos	  = 21

	declare @codigo_banco       int 	set @codigo_banco   	  = 22
	declare @codigo_sumaapagar  int 	set @codigo_sumaapagar	= -23
	declare @codigo_recuperoiva int 	set @codigo_recuperoiva	= -24

		select 
	
					abs(@codigo_ex_work)	as orden_id,
					100                   as orden_id2,
					dici_id,
					'Total Ex-Works' as name,
					@codigo_ex_work  as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc					
	
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_ex_work
	
	union

		select 
	
					abs(@codigo_seguro)		as orden_id,
					200                   as orden_id2,
					dici_id,
					'Seguro'       as name,
					@codigo_seguro as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc					
	
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_seguro

	union

		select 
	
					abs(@codigo_embalaje)	as orden_id,
					300                   as orden_id2,
					dici_id,
					'Embalaje'       as name,
					@codigo_embalaje as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_embalaje

	union

		select 
	
					abs(@codigo_totalfob)	as orden_id,
					400                   as orden_id2,
					dici_id,
					'Total FOB'      as name,
					@codigo_totalfob as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_totalfob

	union

		select 
	
					abs(@codigo_flete)		as orden_id,
					500                   as orden_id2,
					dici_id,
					'Flete'       as name,
					@codigo_flete as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_flete
	union

		select 
	
					abs(@codigo_totalcif)	as orden_id,
					600                   as orden_id2,
					dici_id,
					'Total CIF' as name,
					@codigo_totalcif as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_totalcif
	union

		select 
	
					abs(@codigo_derechos)	as orden_id,
					700                   as orden_id2,
					dici_id,
					'Derechos' as name,
					@codigo_derechos as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_derechos
	union

		select 
	
					abs(@codigo_estadist)	as orden_id,
					800                   as orden_id2,
					dici_id,
					'Estadistica' as name,
					@codigo_estadist as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_estadist
	union

		select 
	
					abs(@codigo_totalcifde)	as orden_id,
					900                    	as orden_id2,
					dici_id,
					'Total CIF+Derechos+Estadistica' as name,
					@codigo_totalcifde as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_totalcifde
	union

		select 
	
					abs(@codigo_iva21)		as orden_id,
					1000                  as orden_id2,
					dici_id,
					'IVA 21%' as name,
					@codigo_iva21 as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_iva21
	union

		select 
	
					abs(@codigo_iva3431_91)	as orden_id,
					1100                    as orden_id2,
					dici_id,
					'IVA 3431/91' as name,
					@codigo_iva3431_91 as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_iva3431_91
	union

		select 
	
					abs(@codigo_gan3543_92)	as orden_id,
					1200                    as orden_id2,
					dici_id,
					'Ganancias 3543/92' as name,
					@codigo_gan3543_92 as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_gan3543_92
	union

		select 
	
					abs(@codigo_igb)			as orden_id,
					1300                  as orden_id2,
					dici_id,
					'Ingresos Brutos' as name,
					@codigo_igb as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_igb
	union

		select 
	
					abs(@codigo_gastosloc)	as orden_id,
					1400                   	as orden_id2,
					dici_id,
					'Gastos Locales' as name,
					@codigo_gastosloc as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_gastosloc
	union

		select 
	
					abs(@codigo_sim)			as orden_id,
					1500                  as orden_id2,
					dici_id,
					'SIM' as name,
					@codigo_sim as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_sim
	union

		select 
	
					abs(@codigo_honodesp)	as orden_id,
					1600                  as orden_id2,
					dici_id,
					'Hon. Despachante' as name,
					@codigo_honodesp as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_honodesp
	union

		select 
	
					abs(@codigo_digital_doc)	as orden_id,
					1680                  		as orden_id2,
					dici_id,
					'Digitalización Documentos' as name,
					@codigo_digital_doc as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_digital_doc
	union

		select 
	
					abs(@codigo_gtogsan)	as orden_id,
					1700                  as orden_id2,
					dici_id,
					'Gastos Grales+Sanidad' as name,
					@codigo_gtogsan as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_gtogsan
	union

		select 
	
					abs(@codigo_gtopba)	  as orden_id,
					1790                  as orden_id2,
					dici_id,
					'Gastos Panalpina BA' as name,
					@codigo_gtopba as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_gtopba
	union

		select 
	
					abs(@codigo_almacen)	as orden_id,
					1800                  as orden_id2,
					dici_id,
					'Almacenaje + Removido' as name,
					@codigo_almacen as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_almacen
	union

		select 
	
					abs(@codigo_ley25413)	as orden_id,
					1900                  as orden_id2,
					dici_id,
					'LEY 25413' as name,
					@codigo_ley25413 as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_ley25413
	union

		select 
	
					abs(@codigo_acarreo)	as orden_id,
					2000                  as orden_id2,
					dici_id,
					'Acarreo' as name,
					@codigo_acarreo as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_acarreo
	union

		select 
	
					abs(@codigo_gastosenvio)	as orden_id,
					2090                  		as orden_id2,
					dici_id,
					'Gastos Envio' as name,
					@codigo_gastosenvio as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_gastosenvio
	union

		select 
	
					abs(@codigo_gastos)		as orden_id,
					2100                  as orden_id2,
					dici_id,
					'Gastos - Eventuales' as name,
					@codigo_gastos as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_gastos
	union

		select 
	
					abs(@codigo_ivagastos)	as orden_id,
					2500                  	as orden_id2,
					dici_id,
					'IVA sobre gastos' as name,
					@codigo_ivagastos as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_ivagastos
	union

		select 
	
					abs(@codigo_banco)		as orden_id,
					2600                  as orden_id2,
					dici_id,
					'Gastos Bancarios' as name,
					@codigo_banco as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_banco

	union

		select 
	
					abs(@codigo_sumaapagar)	as orden_id,
					2700                   	as orden_id2,
					dici_id,
					'Suma a pagar' as name,
					@codigo_sumaapagar as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_sumaapagar

	union

		select 

					abs(@codigo_recuperoiva)	as orden_id,
					2800                   		as orden_id2,
					dici_id,
					'Recupero IVA y Ganancias' as name,
					@codigo_recuperoiva as dici_codigo,
					dici_valor,
					dici_importe, 
					dici_porc
						
		from #t_spdocdespimp_aux t left join DespachoImpCalculoItem 
								on dic_id = @@dic_id and dici_codigo = @codigo_recuperoiva

	order by orden_id2
end
