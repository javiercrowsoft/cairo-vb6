if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DespachoImpCalculoUpdateCosto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DespachoImpCalculoUpdateCosto]


-- sp_DespachoImpCalculoUpdateCosto 4

go
create procedure sp_DespachoImpCalculoUpdateCosto (

	@@dic_id int

)as 

begin

	set nocount on

	declare @rc_id int

	select @rc_id = rc_id from DespachoImpCalculo where dic_id = @@dic_id

	-- Tengo que obtener un porcentaje para cada posicion arancelaria
	--
	-- Los gastos generales se aplican a todas las posiciones arancelarias por
  -- igual
	--

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

	declare @gastos_generales_total		 decimal(18,6)
	declare @gastos_generales_producto decimal(18,6)
	declare @gastos_producto           decimal(18,6)

	select @gastos_generales_total = sum(dici_importe+dici_valor)
	from DespachoImpCalculoitem
	where dic_id = @@dic_id
		and dici_codigo in (@codigo_seguro,
												@codigo_embalaje,
												@codigo_flete,
												@codigo_sim,
												@codigo_honodesp,
												@codigo_gtogsan,
												@codigo_almacen,
												@codigo_acarreo,
												@codigo_gastos,
												@codigo_ley25413,
												@codigo_digital_doc,
												@codigo_gastosenvio,
												@codigo_gtopba
												)

	-- Recorro cada item del remito y obtengo el costo
	-- aplicando el porcentaje de gastos generales y el porcentaje
	-- de gastos propios del producto
	--

	declare @rci_id 				int
	declare @rci_precio 		decimal(18,6)
	declare @rci_cantidad 	decimal(18,6)
	declare @rc_neto 				decimal(18,6)
	declare @porc           decimal(18,6)
	declare @pr_id          int
	declare @poar_id				int
	declare @poar_total     decimal(18,6)
	declare @rci_neto_poar  decimal(18,6)
	declare @costo_producto decimal(18,6)
	declare @porc_poar      decimal(18,6)

	select @rc_neto = rc_neto from RemitoCompra where rc_id = @rc_id

	--////////////////////////////////////////////////////////////////////////
	--
	-- Tratamiento de Diferencias
	--
	-- Diferencia entre los derechos, estadisticas, iva y otras yerbas que calcula
	-- el sistema y lo que ingresa el usuario:
	--
	--   Estas diferencias se prorratean entre las posiciones arancelarias en funcion
	--   de su importancia dentro del remito
	--
	--///////////////////////////////////////////////////////////////////////

		declare @total_producto_x_usuario decimal(18,6)
	
		select @total_producto_x_usuario = sum(dici_importe+dici_valor)
		from DespachoImpCalculoItem
		where dic_id = @@dic_id
			and dici_codigo in (
														@codigo_derechos
														,@codigo_estadist
														,@codigo_gastosenvio
--														,@codigo_iva21,
--														,@codigo_iva3431_91,
--														,@codigo_gan3543_92,
--														,@codigo_igb
													)

		select @poar_total = sum(dicp_derechos
														+dicp_estadisticas
														-- +dicp_ganancias     -- (creo que este no va)
														+dicp_gastoenvio
														-- +dicp_igb           -- (creo que este no va)
														-- +dicp_iva           -- (creo que este no va)
														-- +dicp_iva3431			 -- (creo que este no va)
														)
		from DespachoImpCalculoPosicionArancel
		where dic_id = @@dic_id

		declare @dif_sistema_usuario decimal(18,6)

		select @dif_sistema_usuario = @total_producto_x_usuario - @poar_total

	--///////////////////////////////////////////////////////////////////////


	declare c_items insensitive cursor for 
		select 	rci_id, 
						rci_precio, 
						rci_cantidadaremitir,
						pr_id

		from RemitoCompraItem where rc_id = @rc_id

	open c_items

	fetch next from c_items into @rci_id, @rci_precio, @rci_cantidad, @pr_id
	while @@fetch_status=0
	begin

		-- Cada producto tiene un peso dentro del remito que esta dado
		-- por obtener producto de su cantidad por su precio y luego
		-- dividirlo por el neto del remito

		set @porc = (@rci_precio * @rci_cantidad) / @rc_neto

		set @gastos_generales_producto = @gastos_generales_total * @porc

		-- Obtengo el porcentaje que representa este item del remito
		-- dentro de la posicion arancelaria
		--

			-- Posicion arancelaria de este producto
			--
			select @poar_id = poar_id from Producto where pr_id = @pr_id
	
			-- Total de gastos asociados a la posicion arancelaria
			--
			select @poar_total = sum(dicp_derechos
															+dicp_estadisticas
															-- +dicp_ganancias     -- (creo que este no va)
															+dicp_gastoenvio
															-- +dicp_igb           -- (creo que este no va)
															-- +dicp_iva           -- (creo que este no va)
															-- +dicp_iva3431			 -- (creo que este no va)
															)
			from DespachoImpCalculoPosicionArancel
			where dic_id = @@dic_id
				and poar_id = @poar_id
	
			-- Neto de los items asociados a esta posicion arancelaria
			--
			select @rci_neto_poar = sum(rci_neto)
			from RemitoCompraItem rci inner join Producto pr on rci.pr_id = pr.pr_id
			where rc_id = @rc_id
				and poar_id = @poar_id

			-- Porcentaje que representa este item dentro de la posicion arancelaria
			--
			set @porc_poar = (@rci_precio * @rci_cantidad) / @rci_neto_poar
	
			-- Gastos que le corresponde a este item del remito
			--
			set @gastos_producto = (@poar_total * @porc_poar) + (@dif_sistema_usuario * @porc_poar)

		-- Finalmente obtengo el costo unitario que esta dado
		-- por el costo en origen mas todos los gastos generales
		-- y particulares del producto
		--
		set @costo_producto = 	@rci_precio 
													+ (@gastos_generales_producto / @rci_cantidad)
													+ (@gastos_producto / @rci_cantidad)

		update RemitoCompraItem set rci_costo = @costo_producto where rci_id = @rci_id

		fetch next from c_items into @rci_id, @rci_precio, @rci_cantidad, @pr_id
	end

	close c_items
	deallocate c_items

end
