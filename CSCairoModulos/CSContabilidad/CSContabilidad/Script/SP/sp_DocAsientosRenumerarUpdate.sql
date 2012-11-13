if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientosRenumerarUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientosRenumerarUpdate]

go
create procedure sp_DocAsientosRenumerarUpdate (

		-- Parametros
		@@ejc_id				 int,

		-- Parametros y retorno		
		@ejcas_id				 int out,

		-- Retorno
		@nro_aux    		 int out

)
as

begin

	set nocount on


					----------------------------------------
					-- Actualizo los numeros de asiento de
					-- la tabla EjercicioAsientoResumen
					--

					declare c_ejcas insensitive cursor for 

						select 	ejcas_id

						from EjercicioAsientoResumen 
						where ejcas_nrodoc = '' 
							and ejc_id = @@ejc_id
						order by ejcas_fecha asc

					open c_ejcas

					fetch next from c_ejcas into @ejcas_id
					while @@fetch_status = 0
					begin

						set @nro_aux = @nro_aux +1

						update EjercicioAsientoResumen 
								set ejcas_nrodoc = substring('00000000',1,8-len(convert(varchar(50),@nro_aux))) + convert(varchar(50),@nro_aux)
						where ejcas_id = @ejcas_id

						fetch next from c_ejcas into @ejcas_id
					end

					close c_ejcas
					deallocate c_ejcas
					--
					----------------------------------------
end
GO