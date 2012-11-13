if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionUpdateEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionUpdateEstado]

/*

sp_web_InscripcionUpdateEstado 1475

*/

go
create procedure sp_web_InscripcionUpdateEstado (
	@@insc_id								int
)

as

begin


	-- Datos del pago
	declare @AABAinsc_chkAutoHono 					tinyint 
	declare @AABAinsc_fechaFormHono 				datetime
	declare @AABAinsc_fechaAltaHono 				datetime
	declare @AABAinsc_importeHono 					decimal(18, 6)
	declare @AABAinsc_fechaFormCBU 					datetime
	declare @AABAinsc_fechaAltaCBU 					datetime
	declare @AABAinsc_importeCBU 						decimal(18, 6)
	declare @AABAinsc_titularCBU 						varchar (255)
	declare @AABAinsc_tipoDocCBU 						tinyint
	declare @AABAinsc_nroDocCBU 						varchar (15)
	declare @AABAinsc_nroCBU 								varchar (50)
	declare @AABAinsc_tipoCuentaCBU 				tinyint
	declare @AABAinsc_nroCtaCBU 						varchar (50)
	declare @bco_id_CBU 										int
	declare @AABAinsc_sucursalCBU 					int
	declare @AABAinsc_fechaAltaTarjeta 			datetime
	declare @tjc_id 												int
	declare @AABAinsc_nroTarjeta 						varchar (30)
	declare @AABAinsc_fechaVtoTarjeta 	  	datetime
	declare @AABAinsc_codSegTarjeta 				varchar (50)
	declare @AABAinsc_titularTarjeta 				varchar (255)
	declare @AABAinsc_dirResumenTarjeta 		varchar (255)
	declare @AABAinsc_dirPedidoTarjeta 			varchar (255)
	declare @AABAinsc_telefonoTarjeta 			varchar (50)
	declare @AABAinsc_tipoDocTarjeta 				tinyint
	declare @AABAinsc_nroDocTarjeta 				varchar (15)
	declare @AABAinsc_autorizacionTarjeta		varchar (100)

	set nocount on

	select

														@AABAinsc_chkAutoHono					=AABAinsc_chkAutoHono,
														@AABAinsc_fechaFormHono		    =AABAinsc_fechaFormHono,
														@AABAinsc_fechaAltaHono		    =AABAinsc_fechaAltaHono,
														@AABAinsc_importeHono			    =AABAinsc_importeHono,
														@AABAinsc_fechaFormCBU			  =AABAinsc_fechaFormCBU,
														@AABAinsc_fechaAltaCBU			  =AABAinsc_fechaAltaCBU,
														@AABAinsc_importeCBU				  =AABAinsc_importeCBU,
														@AABAinsc_titularCBU				  =AABAinsc_titularCBU,
														@AABAinsc_tipoDocCBU				  =AABAinsc_tipoDocCBU,
														@AABAinsc_nroDocCBU				    =AABAinsc_nroDocCBU,
														@AABAinsc_nroCBU						  =AABAinsc_nroCBU,
														@AABAinsc_tipoCuentaCBU		    =AABAinsc_tipoCuentaCBU,
														@AABAinsc_nroCtaCBU				    =AABAinsc_nroCtaCBU,
														@bco_id_CBU										=bco_id_CBU,
														@AABAinsc_sucursalCBU			    =AABAinsc_sucursalCBU,
														@AABAinsc_fechaAltaTarjeta	  =AABAinsc_fechaAltaTarjeta,
														@tjc_id												=tjc_id,
														@AABAinsc_nroTarjeta				  =AABAinsc_nroTarjeta,
														@AABAinsc_fechaVtoTarjeta			=AABAinsc_fechaVtoTarjeta,
														@AABAinsc_codSegTarjeta				=AABAinsc_codSegTarjeta,
														@AABAinsc_titularTarjeta			=AABAinsc_titularTarjeta,
														@AABAinsc_dirResumenTarjeta		=AABAinsc_dirResumenTarjeta,
														@AABAinsc_dirPedidoTarjeta		=AABAinsc_dirPedidoTarjeta,
														@AABAinsc_telefonoTarjeta			=AABAinsc_telefonoTarjeta,
														@AABAinsc_tipoDocTarjeta			=AABAinsc_tipoDocTarjeta,
														@AABAinsc_nroDocTarjeta				=AABAinsc_nroDocTarjeta,
														@AABAinsc_autorizacionTarjeta	=AABAinsc_autorizacionTarjeta

		from aaarbaweb..Inscripcion

		where insc_id = @@insc_id

		-- Condiciones de pago
		--
		declare @c_pagoTarjeta						int			set @c_pagoTarjeta						= 8	-- ok
		declare @c_pagoHonorarios 				int     set @c_pagoHonorarios 				= 5	-- ok
		declare @c_pagoDeposito						int			set @c_pagoDeposito						= 2	-- ok
		declare @c_pagoCBU								int			set @c_pagoCBU								= 3	-- ok
		declare @c_pagoEfectivo						int			set @c_pagoEfectivo						= 1
		declare @c_pagoEfectivoSh        	int 		set	@c_pagoEfectivoSh					= 4
		declare @c_pagoEfectivoDolares		int			set	@c_pagoEfectivoDolares		= 6
		declare @c_pagoEfectivoShDolares 	int			set	@c_pagoEfectivoShDolares	= 7
		declare @c_pagoSinCargo          	int			set @c_pagoSinCargo						= 9
		declare @c_pagoInvitadoFarma     	int 		set @c_pagoInvitadoFarma			= 10

		declare @AABAinsc_pagoCBU 					decimal(18,6)
		declare @cpg_id 										int
		declare @est_id           					int
		declare @AABAinsc_informadoTarjeta  tinyint
		declare @aabainsc_pagada            tinyint

		select 	@est_id 										= est_id, 
						@cpg_id 										= cpg_id, 
						@AABAinsc_informadoTarjeta 	= AABAinsc_informadoTarjeta,
						@aabainsc_pagada 						= aabainsc_pagada

		from aaarbaweb..Inscripcion where insc_id = @@insc_id
										
		-- Pago por tarjeta
		--
		if @cpg_id = @c_pagoTarjeta begin 
										
			-- Si ya tengo el codigo de autorizacion
			--
			if @AABAinsc_autorizacionTarjeta <> '' begin
										
					-- si estado <> finalizado
					-- actualizo el estado a pendiente de envio de constancia 1008
					--
					if  @est_id <> 5 /*Finalizado*/ begin
										
						update aaarbaweb..Inscripcion set est_id = 1008	--Pendiente de envió constancia de inscripción  
						where insc_id = @@insc_id
					end
										
			end else begin
										
				-- Si falta algun dato y tesoreria aun no envio
				-- esta tarjeta a la empresa (Visa, American, etc.)
				--
				if (		@AABAinsc_fechaAltaTarjeta = '18991230'
						or	@tjc_id is null
						or  @AABAinsc_nroTarjeta = ''
						or  @AABAinsc_fechaVtoTarjeta = '18991230'
						or	@AABAinsc_codSegTarjeta = ''
						or	@AABAinsc_titularTarjeta = ''
						or	@AABAinsc_dirResumenTarjeta = ''
						--  or	@AABAinsc_dirPedidoTarjeta = ''
						or	@AABAinsc_telefonoTarjeta = ''
						or	@AABAinsc_tipoDocTarjeta = 0
						or	@AABAinsc_nroDocTarjeta = ''
					 )
						and @AABAinsc_informadoTarjeta = 0
				begin
														
					update aaarbaweb..Inscripcion set est_id = 1006	--Pendiente contrato Visa
					where insc_id = @@insc_id
									
				-- Finalmente si la tarjeta fue enviada y aun no tengo el codigo de autorizacion
				-- esta pendiente de acreditación por la empresa (Visa, American, etc.)
				--
				end else begin
										
						update aaarbaweb..Inscripcion set est_id = 1007	--Pendiente acreditación Visa
						where insc_id = @@insc_id
				end
			end
		end

		-- Pago por honorarios
		--
		if @cpg_id = @c_pagoHonorarios begin
								
			-- Si firmo el contrato
			--
			if @AABAinsc_chkAutoHono <> 0 begin
								
				-- Si estado <> finalizado
				--
				if  @est_id <> 5 /*Finalizado*/ begin

					-- Si esta pagada
					-- actualizo el estado a pendiente de envio de constancia 1008
					--
					if @aabainsc_pagada <> 0 begin
									
						update aaarbaweb..Inscripcion set est_id = 1008	--Pendiente de envió constancia de inscripción  
						where insc_id = @@insc_id

					end	else begin

						update aaarbaweb..Inscripcion set est_id = 1005	--Pendiente cobro
						where insc_id = @@insc_id
					end
				end
					
			-- Debe firmar el contrato de descuento por honorarios
			--
			end else begin
				update aaarbaweb..Inscripcion set est_id = 1001	--Pendiente de autorizacion descuento por honorarios
				where insc_id = @@insc_id
			end	
		end

		-- Pago por CBU
		--
		if @cpg_id = @c_pagoCBU begin

			select @AABAinsc_pagoCBU = AABAinsc_pagoCBU from aaarbaweb..Inscripcion where insc_id = @@insc_id
	
			-- Si ya la cobre
			--
			if @AABAinsc_pagoCBU = @AABAinsc_importeCBU begin

				-- Si estado <> finalizado
				-- actualizo el estado a pendiente de envio de constancia 1008
				--
				if  @est_id <> 5 /*Finalizado*/ begin
									
					update aaarbaweb..Inscripcion set est_id = 1008	--Pendiente de envió constancia de inscripción  
					where insc_id = @@insc_id
				end
				
			end else begin
				
				-- Si ya la envie al galicia
				--
				if exists(select * from BGAL_ArchivoInscripcion where insc_id = @@insc_id) begin

					update aaarbaweb..Inscripcion set est_id = 1004	--Pendiente notificación de cobro por diskette Galicia
					where insc_id = @@insc_id
				
				end else begin	
					-- Si no firmo el contrato
					--
					if 		@AABAinsc_fechaFormCBU = '18991230'
						or	@AABAinsc_fechaAltaCBU = '18991230'
						or	@AABAinsc_importeCBU	= 0
						or	@AABAinsc_titularCBU = ''
						or	@AABAinsc_tipoDocCBU = 0
						or	@AABAinsc_nroDocCBU = ''
						or	@AABAinsc_nroCBU = ''
						or	@AABAinsc_tipoCuentaCBU = 0 
						or	@AABAinsc_nroCtaCBU = ''
						or	@bco_id_CBU is null
						or	@AABAinsc_sucursalCBU = ''
					begin

						update aaarbaweb..Inscripcion set est_id = 1002	--Pendiente de contrato CBU
						where insc_id = @@insc_id

					end
				end
			end
		end

		-- Pago por boleta deposito personalizada galicia
		--
		if @cpg_id = @c_pagoDeposito begin

			declare @insc_importe decimal(18,6)

			select 
							@AABAinsc_pagoCBU = AABAinsc_pagoCBU, 
							@insc_importe 		= insc_importe 

			from aaarbaweb..Inscripcion where insc_id = @@insc_id

			-- Si ya la cobre
			--
			if @AABAinsc_pagoCBU = @insc_importe begin

				-- Si estado <> finalizado
				-- actualizo el estado a pendiente de envio de constancia 1008
				--
				if  @est_id <> 5 /*Finalizado*/ begin
									
					update aaarbaweb..Inscripcion set est_id = 1008	--Pendiente de envió constancia de inscripción  
					where insc_id = @@insc_id
				end
				
			end else begin

				update aaarbaweb..Inscripcion set est_id = 1004	--Pendiente notificación de cobro por diskette Galicia
				where insc_id = @@insc_id

			end
		end

		-- Pago por pago en efectivo tanto en pesos como en dolares
		--
		if @cpg_id = @c_pagoEfectivo or @cpg_id = @c_pagoEfectivoDolares begin

			-- Si estado <> finalizado
			-- actualizo el estado a pendiente de envio de constancia 1008
			--
			if  @est_id <> 5 /*Finalizado*/ begin

				if exists(select * from aaarbaweb..inscripcion where insc_id = @@insc_id and aabainsc_pagada <> 0) begin
								
					update aaarbaweb..Inscripcion set est_id = 1008	--Pendiente de envió constancia de inscripción  
					where insc_id = @@insc_id

				end else begin

					update aaarbaweb..Inscripcion set est_id = 1005	--Pendiente cobro  
					where insc_id = @@insc_id

				end
			end
		end

		-- Pago por boleta deposito personalizada galicia
		--
		if @cpg_id = @c_pagoEfectivoSh or @cpg_id = @c_pagoEfectivoShDolares begin

			-- Si estado <> finalizado
			-- actualizo el estado a pendiente de cobro 1005
			--
			if  @est_id <> 5 /*Finalizado*/ begin
				
				-- Estos son los unicos casos en los que no envio nunca la constancia de inscripcion ya que pagan
				-- en el congreso
				--
				update aaarbaweb..Inscripcion set est_id = 1005	--Pendiente cobro
				where insc_id = @@insc_id
			end
		end
end