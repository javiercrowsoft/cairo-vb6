if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LpGetPrecioMarcado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LpGetPrecioMarcado]

go

create Procedure sp_LpGetPrecioMarcado(

	@@lpm_id				int,
	@@mon_id				int,
	@@precio        decimal(18,6) out
)
as

begin

	set nocount on

	declare @mon_default	tinyint
	declare @cotiz  			decimal(18,6)
	declare @cotiz2 			decimal(18,6)

	declare @saltos             decimal(18,6)
	declare @precio2            decimal(18,6)
	declare @lpm_base						decimal(18,6)
	declare @lpm_porcentaje			decimal(18,6)
	declare @lpm_salto					decimal(18,6)
	declare @lpm_decremento			decimal(18,6)
	declare @lpm_porcminimo			decimal(18,6)
	declare @lpm_porcmaximo			decimal(18,6)
	declare @lpm_montominimo		decimal(18,6)
	declare @mon_id_marcado			int
	declare @lpm_activo					tinyint

	declare @fecha  datetime
	set @fecha = getdate()

	select
					@lpm_base						= lpm_base,
					@lpm_porcentaje			= lpm_porcentaje,
					@lpm_salto					= lpm_salto,
					@lpm_decremento			= lpm_decremento,
					@lpm_porcminimo			= lpm_porcminimo,
					@lpm_porcmaximo			= lpm_porcmaximo,
					@lpm_montominimo		= lpm_montominimo,
					@mon_id_marcado			= mon_id,
					@lpm_activo					= activo

	from listapreciomarcado
	where lpm_id = @@lpm_id

	-- Solo operamos si hay salto
	--
	if @lpm_salto > 0 and @lpm_activo <> 0 begin

		--------------------------------------------------------------------------------
		-- Tratamiento de Monedas entre Listas
		--
		--
		-- Si la moneda de la lista es distinta
		-- a la del marcado de la base (es decir a la del precio)
		--
		if @@mon_id <> @mon_id_marcado begin

			-- Si la moneda de la lista es la moneda default
			--
			select @mon_default = mon_legal from moneda where mon_id = @@mon_id

			-- Voy a tener que pasar a pesos el precio
			-- de la base ya que encontre un precio en dolares u otra moneda
			-- distinta a pesos (obvio el ejemplo es pa Argentina che)
			--
			if @mon_default <> 0 begin

				-- Obtengo la cotizacion de la lista base
				--
				exec sp_monedaGetCotizacion @mon_id_marcado, @fecha, 0, @cotiz out

				-- Paso a Pesos el precio (sigo en argentino pue)
				--
				set @lpm_montominimo = @lpm_montominimo * @cotiz
				set @lpm_base				 = @lpm_base				* @cotiz

			-- Ahora bien si la moneda de la lista no es la moneda default 
      -- (pesos pa los argentinos {quien sabe por cuanto tiempo no :) })
			--
			end else begin

				-- Veamos si la lista base esta en pesos
				--
				select @mon_default = mon_legal from moneda where mon_id = @mon_id_marcado

				if @mon_default <> 0 begin

					-- Ok la base esta en pesos asi que obtengo la cotizacion de la lista
					-- para la que se me pidio el precio
					--
					exec sp_monedaGetCotizacion @@mon_id, @fecha, 0, @cotiz out

					-- Si hay cotizacion, divido el precio y guala, tengo
					-- el precio expresado en dolares o yerbas similares
					--
					if @cotiz <> 0 begin
								set @lpm_montominimo = @lpm_montominimo / @cotiz
								set @lpm_base				 = @lpm_base / @cotiz
					end
					else begin
								set @lpm_montominimo = 0 -- :( sin cotizacion no hay precio
								set @lpm_base 			 = 0
					end

				end else begin

					-- Ok, al chango se le ocurrio comprar en dolares y vender en reales
					-- entonces paso los dolares a pesos y luego los pesos a reales y listo
					--
					exec sp_monedaGetCotizacion @mon_id_marcado, @fecha, 0, @cotiz out
					exec sp_monedaGetCotizacion @@mon_id,        @fecha, 0, @cotiz2 out

					set @lpm_montominimo = @lpm_montominimo * @cotiz
					set @lpm_base				 = @lpm_base * @cotiz

					-- Si hay cotizacion, divido el precio y guala, tengo
					-- el precio expresado en dolares o yerbas similares
					--
					if @cotiz2 <> 0 begin 
								set @lpm_montominimo = @lpm_montominimo / @cotiz2
								set @lpm_base        = @lpm_base / @cotiz2
					end
					else begin
								set @lpm_montominimo = 0 -- :( sin cotizacion no hay precio
								set @lpm_base        = 0
					end
				end
			end
		end
		--
		-- FIN Tratamiento de Monedas entre Listas
		--------------------------------------------------------------------------------

		-- Obtenemos y aplicamos el porcentaje
		--
		set @saltos = (@@precio - @lpm_base) / @lpm_salto

		set @lpm_porcentaje = @lpm_porcentaje - (@lpm_decremento * @saltos)

		if @lpm_porcentaje < @lpm_porcminimo 
			set @lpm_porcentaje = @lpm_porcminimo

		set @precio2 = @@precio * (1+@lpm_porcentaje/100)

		-- Monto Minimo y Porcentaje Maximo
		--
		if (@precio2-@@precio) < @lpm_montominimo 
			set @precio2 = @@precio+@lpm_montominimo

		if (((@precio2 / @@precio)-1)*100) > @lpm_porcmaximo
			set @precio2 = @@precio * (1+@lpm_porcmaximo/100)

		-- Finalmente devolvemos el precio
		--
		set @@precio = @precio2

	end

end
GO