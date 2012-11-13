if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraOrdenPagoSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraOrdenPagoSave]

/*

 sp_DocFacturaCompraOrdenPagoSave 124

*/

go
create procedure sp_DocFacturaCompraOrdenPagoSave (
	@@fc_id 				int,
	@@bSuccess			tinyint 			out,
	@@MsgError			varchar(5000)	out
)
as

begin

	set nocount on

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                          GENERACION AUTOMATICA DE ORDEN DE PAGO																										//
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
		declare @prov_id        int
		declare @opg_id         int
		declare @as_id 					int
		declare @suc_id					int
		declare @cpg_id 				int
		declare @ccos_id        int
		declare @lgj_id         int
		declare @modifico       int
		declare @fc_fechaVto		datetime
		declare @fc_fechaiva    datetime
		declare @fc_nrodoc      varchar(50)

		select
						@fc_fechaVto	= fc_fechaVto,
						@fc_fechaiva	= fc_fechaiva,
						@fc_nrodoc		= fc_nrodoc,

						@prov_id		= prov_id,
						@cpg_id			= cpg_id,
						@as_id      = as_id,
						@suc_id			= suc_id,
						@ccos_id		= ccos_id,
						@lgj_id			= lgj_id,
						@modifico		= modifico

		from FacturaCompra 
		where fc_id = @@fc_id


		if @ccos_id is null begin

			declare @min_ccos_id int
			declare @max_ccos_id int

			select 	@min_ccos_id = min(ccos_id), 
							@max_ccos_id = max(ccos_id) 
			from FacturaCompraItem where fc_id = @@fc_id and ccos_id is not null

			if @min_ccos_id = @max_ccos_id begin

				select @ccos_id = ccos_id from FacturaCompraItem where fc_id = @@fc_id and ccos_id is not null

			end

		end

		/*
				Si la condicion de pago de la factura es de tipo [Debito Automatico] o [Fondo Fijo]
        debo generar una orden de pago automaticamente.
				Para esto tengo que sacar de la condicion de pago el documento y la cuenta contable
        de los fondos pasando por la cuenta grupo asociada a dicha condicion de pago.
		*/
		declare @cpg_tipo 				tinyint
		declare @cueg_id_cpg  		int
		declare @doc_id_opg   		int
		declare @cpg_asientoXVto	tinyint

		select 	@cpg_tipo 				= cpg_tipo, 
						@cueg_id_cpg			= cueg_id, 
						@doc_id_opg				= doc_id, 
						@cpg_asientoXVto  = cpg_asientoXVto

		from CondicionPago 
		where cpg_id = @cpg_id

		declare @cue_id_cpg int

		select @cue_id_cpg = case 
														when provcueg.cue_id is not null then provcueg.cue_id
														else                                  cueg.cue_id
													end
		from CuentaGrupo cueg left join ProveedorCuentaGrupo provcueg on cueg.cueg_id = provcueg.cueg_id
		where cueg.cueg_id = @cueg_id_cpg

		if @cpg_tipo in (2,3) begin

			-- //////////////////////////////////////////////////////////////////////////
			--
			-- La cuenta del acreedor puede ser mas de una cuando
			-- se utilizan tipos de operaciones distintas en los renglones
			-- de una factura. Como esto es casi imposible que suceda
			-- no nos vamos a complicar programando este tipo de casos
			-- sino que controlamos que no se use mas de un tipo de operacion
			-- y si hay mas de una descartamos la factura informandole que
      -- no podra grabarla con la condicion este tipo de condicion de pago
			-- debera usar una condicion de pago normal y generar la op manualmente

			declare @to_count int
			select @to_count = count(distinct to_id) from FacturaCompraItem where fc_id = @@fc_id

			if @to_count > 1 begin
				set @@MsgError = '@@ERROR_SP:Las facturas con mas de un tipo de operación comercial no pueden utilizar esta condicion de pago. Seleccione una condicion de pago de tipo general y genere la Orden de Pago manualmente.'
				goto ControlError
			end

			-- //////////////////////////////////////////////////////////////////////////
	
			declare @opgTMP_id int
			exec sp_dbgetnewid 'OrdenPagoTMP', 'opgTMP_id', @opgTMP_id out, 0
			if @@error <> 0 goto ControlError

			declare @opg_fecha datetime
			declare @opg_total decimal(18,6)

			if @cpg_asientoXVto <> 0 begin

				set @opg_fecha = @fc_fechaVto

			end else begin

				set @opg_fecha = @fc_fechaiva

			end

			select @opg_total = sum(fcd_importe) from FacturaCompraDeuda where fc_id = @@fc_id

			insert into OrdenPagoTMP (
																opgTMP_id,
																opg_id,
																opg_numero,
																opg_nrodoc,
																opg_descrip,
																opg_fecha,
																opg_neto,
																opg_otros,
																opg_total,
																opg_pendiente,
																opg_cotizacion,
																opg_grabarAsiento,
																opg_firmado,
																est_id,
																suc_id,
																prov_id,
																doc_id,
																ccos_id,
																lgj_id,
																modifico
																) 
										values 		(						
																@opgTMP_id,
																0,
																0,
																'',
																'Generada automáticamente por factura ' + @fc_nrodoc,
																@opg_fecha,
																@opg_total,
																0,
																@opg_total,
																@opg_total,
																0,
																1,
																0,
																1,
																@suc_id,
																@prov_id,
																@doc_id_opg,
																@ccos_id,
																@lgj_id,
																@modifico
															)

			declare @opgiTMP_id int
			exec sp_dbgetnewid 'OrdenPagoItemTMP', 'opgiTMP_id', @opgiTMP_id out, 0
			if @@error <> 0 goto ControlError

			insert into OrdenPagoItemTMP (
																		opgTMP_id,
																		opgiTMP_id,
																		opgi_id,
																		opgi_orden,
																		opgi_otroTipo,
																		opgi_importe,
																		opgi_importeOrigen,
																		opgi_tipo,
																		ccos_id,
																		cue_id
																	)
													values	(
																		@opgTMP_id,
																		@opgiTMP_id,
																		0,				 --opgi_id
																		1,				 --opgi_orden
																		2, 				 --opgi_otroTipo
																		@opg_total, --opgi_importe
																		0, 				 --opgi_importeOrigen
																		2, 				 --opgi_tipo
																		@ccos_id,
																		@cue_id_cpg
																	)

			declare @cue_id_acreedor int

			-- Si ya genere el asiento obtengo la cuenta
			-- desde el asientoitem de tipo 2 (acreedor)
			--
			if @as_id is not null begin

				select @cue_id_acreedor = min(cue_id)
				from AsientoItem
				where as_id = @as_id
					and asi_tipo = 2

			-- Si aun no se grabo el asiento lo obtengo del
			-- grupo de cuentas
			--
			end else begin

				select @cue_id_acreedor = case
																		when provcueg.cue_id is not null then provcueg.cue_id
																		else                                  cueg.cue_id
																	end
				from documento doc inner join CuentaGrupo cueg on doc.cueg_id = cueg.cueg_id
													 left  join ProveedorCuentaGrupo provcueg on cueg.cueg_id = provcueg.cueg_id
				where doc.doc_id = @doc_id_opg

			end

			exec sp_dbgetnewid 'OrdenPagoItemTMP', 'opgiTMP_id', @opgiTMP_id out, 0
			if @@error <> 0 goto ControlError

			insert into OrdenPagoItemTMP (
																		opgTMP_id,
																		opgiTMP_id,
																		opgi_id,
																		opgi_orden,
																		opgi_otroTipo,
																		opgi_importe,
																		opgi_importeOrigen,
																		opgi_tipo,
																		ccos_id,
																		cue_id
																	)
													values	(
																		@opgTMP_id,
																		@opgiTMP_id,
																		0,				 --opgi_id
																		2,				 --opgi_orden
																		1, 				 --opgi_otroTipo
																		@opg_total, --opgi_importe
																		0, 				 --opgi_importeOrigen
																		5, 				 --opgi_tipo
																		@ccos_id,
																		@cue_id_acreedor
																	)

			declare @fcopgTMP_id  int
			declare @fcd_id				int 
			declare @fcd_importe	decimal(18,6)

			declare c_deuda_fc insensitive cursor for select fcd_id, fcd_importe from FacturaCompraDeuda where fc_id = @@fc_id

			open c_deuda_fc

			fetch next from c_deuda_fc into @fcd_id, @fcd_importe
			while @@fetch_status=0
			begin

				exec sp_dbgetnewid 'FacturaCompraOrdenPagoTMP', 'fcopgTMP_id', @fcopgTMP_id out, 0
				if @@error <> 0 goto ControlError
	
				insert into FacturaCompraOrdenPagoTMP(
																							opgTMP_id,
																							fcopgTMP_id,
																							fcopg_id,
																							fcopg_importe,
																							fcopg_importeOrigen,
																							fcopg_cotizacion,
																							fc_id,
																							fcd_id,
																							fcp_id,
																							opg_id
																						 )
																			values (
																							@opgTMP_id,
																							@fcopgTMP_id,
																							0,
																							@fcd_importe,
																							0,
																							0,
																							@@fc_id,
																							@fcd_id,
																							null,
																							0
																						 )

				fetch next from c_deuda_fc into @fcd_id, @fcd_importe
			end

			close c_deuda_fc
			deallocate c_deuda_fc

			exec sp_DocOrdenPagoSave 	@opgTMP_id,
															  0,--@@bSelect
															  @opg_id out,
															  @@bSuccess out,
																1,--@@bDontRaiseError
																@@MsgError out,
																@@fc_id
		
			if @@bSuccess <> 0 begin
	
				update OrdenPago set fc_id = @@fc_id where opg_id = @opg_id	
				update FacturaCompra set opg_id = @opg_id where fc_id = @@fc_id
	
			end else begin
	
				goto ControlError
	
			end

		end else begin

			set @@bSuccess = 1

		end

	return
ControlError:

	set @@MsgError = 'Ha ocurrido un error al guardar la orden de pago asociada a la factura de compra. sp_DocFacturaCompraOrdenPagoSave. ' + IsNull(@@MsgError,'')
	raiserror (@@MsgError, 16, 1)
	rollback transaction	

end