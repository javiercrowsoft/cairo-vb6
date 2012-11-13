if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EjercicioAperturaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EjercicioAperturaSave]

go
create procedure sp_EjercicioAperturaSave (

	@@us_id				int,
	@@ejc_id 			int

)as 
begin

	set nocount on

	declare @emp_id 			varchar(50)
	declare @cico_id			varchar(50)
	declare @fechaIni			datetime
	declare @doc_id   		int
	declare @ejc_nombre		varchar(255)
	declare @as_id 				int

	select 	@emp_id 		= emp_id,
					@cico_id 		= cico_id,
					@fechaIni 	= ejc_fechaIni,
					@doc_id			= doc_id,
					@ejc_nombre	= ejc_nombre,
					@as_id			= as_id_apertura

	from EjercicioContable

	where ejc_id = @@ejc_id

	declare @ejc_id_anterior int

	exec sp_EjercicioGetLast @emp_id, @cico_id, @fechaIni, @ejc_id_anterior out, 0

	if @ejc_id_anterior is null begin

		raiserror ('@@ERROR_SP:El primer ejercicio no posee asiento de apertura.', 16, 1)
		return

	end else begin

		declare @as_id_cp int
	
		select @as_id_cp = as_id_cierrepatrimonial 
		from EjercicioContable
		where ejc_id = @ejc_id_anterior

		if @as_id_cp is null begin

			raiserror ('@@ERROR_SP:El ejercicio anterior no esta cerrado.', 16, 1)
			return

		end else begin

			declare	@as_nrodoc  varchar (50) 
			declare @doct_id		int

			-- //////////////////////////////////////////////////////////////////////////////////
			--
			-- Talonario
			--
						declare @ta_id        int

						select @ta_id = ta_id, @doct_id = doct_id from Documento where doc_id = @doc_id

						declare @ta_propuesto tinyint
						declare @ta_tipo      smallint
				
						exec sp_talonarioGetPropuesto @doc_id, 0, @ta_propuesto out, 0, 0, @ta_id out, @ta_tipo out
						if @@error <> 0 goto ControlError
				
						declare @ta_nrodoc varchar(100)

						exec sp_talonarioGetNextNumber @ta_id, @ta_nrodoc out
						if @@error <> 0 goto ControlError

						-- Con esto evitamos que dos tomen el mismo número
						--
						exec sp_TalonarioSet @ta_id, @ta_nrodoc
						if @@error <> 0 goto ControlError

						set @as_nrodoc = @ta_nrodoc
	
			--
			-- Fin Talonario
			--
			-- //////////////////////////////////////////////////////////////////////////////////

			declare @asTMP_id int

			exec sp_dbgetnewid 'AsientoTMP','asTMP_id', @asTMP_id out, 0
			if @@error <> 0 goto ControlError
	
			insert into AsientoTMP( asTMP_id,
															as_id,
															as_numero,
															as_nrodoc,
															as_descrip,
															as_fecha,
															doc_id,
															doct_id,
															modifico
														)
 											values
														( @asTMP_id,
															0,
															0,
															@as_nrodoc,
															'Apertura del Ejercicio ' + @ejc_nombre,
															@fechaIni,
															@doc_id,
															@doct_id,
															@@us_id
														)

			declare @asiTMP_id int
			declare @asi_debe  decimal(18,6)
			declare @asi_haber decimal(18,6)
			declare @cue_id    int
			declare @asi_orden int
			declare @ccos_id   int

			set @asi_orden = 0

			declare c_items insensitive cursor for
				select cue_id, ccos_id, asi_debe, asi_haber 
				from AsientoItem
				where as_id = @as_id_cp
				order by asi_orden desc

			open c_items

																						-- Esta al reves adrede
			fetch next from c_items into @cue_id, @ccos_id, @asi_haber, @asi_debe
			while @@fetch_status=0
			begin

				set @asi_orden = @asi_orden + 1

				exec sp_dbgetnewid 'AsientoItemTMP','asiTMP_id', @asiTMP_id out, 0
				if @@error <> 0 goto ControlError

				insert into AsientoItemTMP (	asTMP_id,
																			asiTMP_id,
																			asi_id,
																			asi_orden,
																			asi_descrip,
																			asi_debe,
																			asi_haber,
																			asi_origen,
																			cue_id,
																			ccos_id
																		)
														values
																		(	@asTMP_id,
																			@asiTMP_id,
																			0,
																			@asi_orden,
																			'',
																			@asi_debe,
																			@asi_haber,
																			0,
																			@cue_id,
																			@ccos_id
																		)
																							-- Esta al reves adrede
				fetch next from c_items into @cue_id, @ccos_id, @asi_haber, @asi_debe

			end

			close c_items
			deallocate c_items

			begin tran

				if @as_id is not null begin 

					update EjercicioContable set as_id_apertura = null where ejc_id = @@ejc_id
					if @@error <> 0 goto ControlError

					exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
					if @@error <> 0 goto ControlError

				end
	
				exec sp_DocAsientoSave @asTMP_id, @as_id out, 0
				if @@error <> 0 goto ControlError
			
				update EjercicioContable set as_id_apertura = @as_id where ejc_id = @@ejc_id

			commit tran

			select @as_id

		end
	end

	return
ControlError:
                          
	raiserror ('Ha ocurrido un error al grabar el asiento de apertura. sp_EjercicioAperturaSave.', 16, 1)

	if @@trancount > 0

		rollback tran

end
GO