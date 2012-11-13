if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientosResumirAux]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientosResumirAux]

go
create procedure sp_DocAsientosResumirAux (

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

		@IsLast					 tinyint,

		@last_year       int out,
		@last_week       int out,
		@last_month      int out,

		@curr_year       int out,
		@curr_week       int out,
		@curr_month      int out,


		-- Parametros y retorno

		@dif 						 int out,
		@real_dif				 int out,
		@fecha           datetime out,
		@fecha_desde     datetime out,
		@fecha_hasta     datetime out,
		@weekday         int out,
		@monthday        int out,
		
		@ejcas_id				 int out,
		@bUpdateEjcas    tinyint out,

		-- Retorno
		@nro        		 int out,

		-- Retorno
		@nro_aux    		 int out

)
as

begin

	set nocount on



		-- Si resumo asientos ya sea de ventas o compras, 
		-- por mes o por semana
		--
		if @tipo_fv <> 3 or @tipo_fc <> 3 begin

			set @bUpdateEjcas = 0
			
			-- Obtengo la semana y el mes de la fecha actual
			--
			set datefirst 1 
	
			set @curr_year 	= year(@as_fecha)
			set @curr_month = month(@as_fecha)
			set @curr_week 	= datepart(wk,@as_fecha)
	
			set datefirst @oldDateFirst			  
			------------------------------------------------
	
			-- Si ventas o compras se resumen semanalmente
			--
			if @tipo_fc = 1 or @tipo_fv = 1 begin

				if @last_week <> @curr_week or @IsLast <> 0 begin

					exec sp_DocAsientosRenumerarWeek
																								-- Parametros
																								
																								@@ejc_id				 ,
																								@emp_id  				 ,
																								@cico_id 				 ,
																								@ram_id_circuitocontable ,
																								@clienteID 			 ,
																								
																								@tipo_fc 				 ,
																								@tipo_fv 				 ,
																								@oldDateFirst 	 ,
																								@as_fecha		     ,
																								
																								@last_year       ,
																								@last_week       ,
																								
																								@curr_year       ,
																								@curr_week       ,
																								
																								
																								-- Parametros y retorno
																								
																								@dif 						 out,
																								@real_dif				 out,
																								@fecha           out,
																								@fecha_desde     out,
																								@fecha_hasta     out,
																								@weekday         out,
																								
																								@ejcas_id				 out,
																								@bUpdateEjcas    out,
																								
																								-- Retorno
																								@nro        		 out
				end
			
			end

			-- Si ventas o compras se resumen mensualmente
			--
			if @tipo_fc = 2 or @tipo_fv = 2 begin

				if @last_month <> @curr_month or @IsLast <> 0 begin

					exec sp_DocAsientosRenumerarMonth
																								-- Parametros
																								
																								@@ejc_id				 ,
																								@emp_id  				 ,
																								@cico_id 				 ,
																								@ram_id_circuitocontable ,
																								@clienteID 			 ,
																								
																								@tipo_fc 				 ,
																								@tipo_fv 				 ,
																								@oldDateFirst 	 ,
																								@as_fecha		     ,
																								
																								@last_year       ,
																								@last_month      ,
																								
																								@curr_year       ,
																								@curr_month      ,
																								
																								
																								-- Parametros y retorno
																								
																								@dif 						 out,
																								@real_dif				 out,
																								@fecha           out,
																								@fecha_desde     out,
																								@fecha_hasta     out,
																								@monthday        out,
																								
																								@ejcas_id				 out,
																								@bUpdateEjcas    out,
																								
																								-- Retorno
																								@nro        		 out	
				end			
			end

			if @bUpdateEjcas <> 0 begin

				exec sp_DocAsientosRenumerarUpdate		@@ejc_id,
																					
																							-- Parametros y retorno		
																							@ejcas_id	out,
																					
																							-- Retorno
																							@nro_aux out
			end

			set @last_year 	= @curr_year
			set @last_month = @curr_month
			set @last_week  = @curr_week

		end

end

GO