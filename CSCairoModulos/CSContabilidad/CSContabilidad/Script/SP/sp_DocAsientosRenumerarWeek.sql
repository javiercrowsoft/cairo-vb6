if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientosRenumerarWeek]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientosRenumerarWeek]

go
create procedure sp_DocAsientosRenumerarWeek (

		-- Parametros

		@@ejc_id				 int,
		@emp_id  				 int,
		@cico_id 				 int,
		@ram_id_circuitocontable int,
		@clienteID 			 int,

		@tipo_fc 				 tinyint,
		@tipo_fv 				 tinyint,
		@oldDateFirst 	 int,
		@as_fecha		     datetime,

		@last_year       int,
		@last_week       int,

		@curr_year       int,
		@curr_week       int,


		-- Parametros y retorno

		@dif 						 int out,
		@real_dif				 int out,
		@fecha           datetime out,
		@fecha_desde     datetime out,
		@fecha_hasta     datetime out,
		@weekday         int out,
		
		@ejcas_id				 int out,
		@bUpdateEjcas    tinyint out,

		-- Retorno
		@nro        		 int out

)
as

begin

	set nocount on

					-------------------------------------------------------------------
					if @curr_year - @last_year > 0 begin

						set @dif = (53 - @last_week) 
						
						if @curr_year - @last_year -2 > 0 

							set @dif = @dif + ((@curr_year - @last_year -2) * 53)

						set @dif = @dif + @curr_week

					end else

						set @dif = @curr_week - @last_week
					-------------------------------------------------------------------

					set @real_dif = 0

					-- Ahora verifico que existan ventas o compras
					-- en cada periodo
					--
					while @dif > 0
					begin

						set @fecha = dateadd(wk, -@dif, @as_fecha)

						set datefirst 1 
				
						set @weekday = datepart(dw,@as_fecha)
				
						set datefirst @oldDateFirst			  

						-- Primer dia de la semana
						set @fecha_desde = dateadd(d,-(@weekday-1),@fecha)
	
						-- Ultimo dia de la semana
						set @fecha_hasta = dateadd(d,6,@fecha_desde)

						-- Existen Compras
						--
						if @tipo_fc = 1 begin

							if exists(select * from facturacompra fc inner join documento doc on fc.doc_id = doc.doc_id
											  where fc_fecha between @fecha_desde and @fecha_hasta 
													and est_id <> 7 
													and doc.emp_id  = @emp_id
													and (doc.cico_id = @cico_id or @cico_id = 0)
													and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and rptarb_hojaid = doc.cico_id)) or (@ram_id_circuitocontable = 0))
												)
							begin

								set @real_dif = @real_dif +1

								set @bUpdateEjcas = 1

								exec sp_dbgetnewid 'EjercicioAsientoResumen', 'ejcas_id', @ejcas_id out, 0

								insert into EjercicioAsientoResumen (ejc_id , ejcas_id, ejcas_fecha, ejcas_nrodoc, ejcas_tipo)
																						values	(@@ejc_id, @ejcas_id, @fecha_hasta, '', 2)
							end
						end

						-- Existen Ventas
						--
						if @tipo_fv = 1 begin

							if exists(select * from facturaventa fv inner join documento doc on fv.doc_id = doc.doc_id
											  where fv_fecha between @fecha_desde and @fecha_hasta 
													and est_id <> 7 
													and doc.emp_id  = @emp_id
													and (doc.cico_id = @cico_id or @cico_id = 0)
													and ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 1016 and rptarb_hojaid = doc.cico_id)) or (@ram_id_circuitocontable = 0))
												)
							begin

								set @real_dif = @real_dif +1

								set @bUpdateEjcas = 1

								exec sp_dbgetnewid 'EjercicioAsientoResumen', 'ejcas_id', @ejcas_id out, 0

								insert into EjercicioAsientoResumen (ejc_id , ejcas_id, ejcas_fecha, ejcas_nrodoc, ejcas_tipo)
																						values	(@@ejc_id, @ejcas_id, @fecha_hasta, '', 1)
							end

						end

						set @dif = @dif -1 
					end

					set @nro = @nro + @real_dif

end

GO