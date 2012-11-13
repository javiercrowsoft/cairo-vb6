if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EjercicioCierreRSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EjercicioCierreRSave]

-- sp_EjercicioCierreRSave 1,1

go
create procedure sp_EjercicioCierreRSave (

	@@us_id					int,
	@@ejc_id 				int,
	@@bCentroCosto	smallint = 0

)as 
begin

	set nocount on

	declare @@emp_id 			varchar(50)
	declare @@cico_id			varchar(50)

	declare @emp_id 			int
	declare @cico_id			int

	declare @ram_id_empresa          int
	declare @ram_id_circuitocontable int

	declare @fechaIni			datetime
	declare @fechaFin			datetime
	declare @doc_id   		int
	declare @ejc_nombre		varchar(255)
	declare @as_id_ap			int
	declare @as_id_cr			int
	declare @as_id_cp			int
	declare @cue_id_resultado	int

	select 	@@emp_id 		= emp_id,
					@@cico_id 	= cico_id,
					@fechaIni 	= ejc_fechaIni,
					@fechaFin 	= ejc_fechaFin,
					@doc_id			= doc_id,
					@ejc_nombre	= ejc_nombre,
					@as_id_ap		= as_id_apertura,
					@as_id_cp		= as_id_cierrepatrimonial,
					@as_id_cr		= as_id_cierreresultados,
					@cue_id_resultado	= cue_id_resultado

	from EjercicioContable

	where ejc_id = @@ejc_id

	declare @clienteID 				int
	declare @IsRaiz    				tinyint

	exec sp_GetRptId @clienteID out

	exec sp_ArbConvertId @@emp_id,  		 @emp_id  out,  			@ram_id_empresa out
	exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 				@ram_id_circuitocontable out

	if @ram_id_empresa <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
		end else 
			set @ram_id_empresa = 0
	end
	
	if @ram_id_circuitocontable <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
		end else 
			set @ram_id_circuitocontable = 0
	end

	if @as_id_ap is null begin

		if exists(select * from EjercicioContable where emp_id = @emp_id and ejc_fechaFin <= @fechaIni)
		begin
			raiserror ('@@ERROR_SP:El ejercicio no esta abierto.', 16, 1)
			return
		end

	end 

	begin

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
														'Cierre de Resultados del Ejercicio ' + @ejc_nombre,
														@fechaFin,
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
		declare @saldo     decimal(18,6)

		set @asi_orden = 0

		set @cico_id = isnull(@cico_id,0)

		if @@bCentroCosto <> 0 begin

			declare c_items insensitive cursor for
	
				select asi.cue_id, 
							 asi.ccos_id,
							 sum(asi_debe-asi_haber)
	
				from AsientoItem asi inner join Asiento 	ast 	on asi.as_id 					= ast.as_id
		 												 inner join Documento	doc  	on ast.doc_id  				= doc.doc_id
														 inner join Cuenta    cue   on asi.cue_id         = cue.cue_id
	                         	 left  join Documento doccl	on ast.doc_id_cliente	= doccl.doc_id
	
				where (cuec_id = 9 or cuec_id = 10) /*Solo cuentas de resultado*/
					and as_fecha between @FechaIni and @FechaFin
					and asi.as_id <> isnull(@as_id_cr,0)
					and asi.as_id <> isnull(@as_id_cp,0)

					and (doc.emp_id = @emp_id or @emp_id	=0)
					and (isnull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id	=0)

					and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1018 and rptarb_hojaid = doc.emp_id)) or (@ram_id_empresa = 0))
					and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1016 and rptarb_hojaid = isnull(doccl.cico_id,doc.cico_id))) or (@ram_id_circuitocontable = 0))
	
				group by asi.cue_id, asi.ccos_id

				order by sum(asi_debe-asi_haber) asc

		end else begin

			declare c_items insensitive cursor for

				select asi.cue_id, 
							 null,
							 sum(asi_debe-asi_haber)
	
				from AsientoItem asi inner join Asiento 	ast 	on asi.as_id 					= ast.as_id
		 												 inner join Documento	doc  	on ast.doc_id  				= doc.doc_id
														 inner join Cuenta    cue   on asi.cue_id         = cue.cue_id
	                         	 left  join Documento doccl	on ast.doc_id_cliente	= doccl.doc_id
	
				where (cuec_id = 9 or cuec_id = 10) /*Solo cuentas de resultado*/
					and as_fecha between @FechaIni and @FechaFin
					and asi.as_id <> isnull(@as_id_cr,0)
					and asi.as_id <> isnull(@as_id_cp,0)

					and (doc.emp_id = @emp_id or @emp_id	=0)
					and (isnull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id	=0)

					and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1018 and rptarb_hojaid = doc.emp_id)) or (@ram_id_empresa = 0))
					and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 1016 and rptarb_hojaid = isnull(doccl.cico_id,doc.cico_id))) or (@ram_id_circuitocontable = 0))
	
				group by asi.cue_id

				order by sum(asi_debe-asi_haber) asc

		end

		open c_items

																					
		fetch next from c_items into @cue_id, @ccos_id, @saldo
		while @@fetch_status=0
		begin

			if @saldo <> 0 begin

				if @saldo < 0 begin

					set @asi_debe  = abs(@saldo)
					set @asi_haber = 0

				end else begin

					set @asi_debe  = 0
					set @asi_haber = abs(@saldo)

				end
	
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
			end
																						
			fetch next from c_items into @cue_id, @ccos_id, @saldo

		end

		close c_items
		deallocate c_items

		-- Resultado del ejercicio
		--

		select @saldo = sum(asi_debe)-sum(asi_haber) from AsientoItemTMP where asTMP_id = @asTMP_id

		set @saldo = isnull(@saldo,0)

		set @asi_debe  = 0
		set @asi_haber = 0

		if @saldo < 0 set @asi_debe  = abs(@saldo)
		else					set @asi_haber = abs(@saldo)

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
																			@cue_id_resultado,
																			null
																		)

		begin tran

			if @as_id_cr is not null begin 

				update EjercicioContable set as_id_cierreresultados = null where ejc_id = @@ejc_id
				if @@error <> 0 goto ControlError

				exec sp_DocAsientoDelete @as_id_cr,0,0,1 -- No check access
				if @@error <> 0 goto ControlError

			end

			exec sp_DocAsientoSave @asTMP_id, @as_id_cr out, 0
			if @@error <> 0 goto ControlError
		
			update EjercicioContable set as_id_cierreresultados = @as_id_cr where ejc_id = @@ejc_id

		commit tran

		select @as_id_cr

	end

	return
ControlError:
                          
	raiserror ('Ha ocurrido un error al grabar el asiento de cierre de resultados. sp_EjercicioCierreRSave.', 16, 1)

	if @@trancount > 0

		rollback tran

end
GO