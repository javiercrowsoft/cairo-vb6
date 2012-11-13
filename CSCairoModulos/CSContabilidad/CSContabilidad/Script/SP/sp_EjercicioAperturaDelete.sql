if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EjercicioAperturaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EjercicioAperturaDelete]

go
create procedure sp_EjercicioAperturaDelete (

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

	declare @as_id_pa     int
	declare @as_id_r      int

	select 	@emp_id 		= emp_id,
					@cico_id 		= cico_id,
					@fechaIni 	= ejc_fechaIni,
					@doc_id			= doc_id,
					@ejc_nombre	= ejc_nombre,
					@as_id			= as_id_apertura,
					@as_id_pa   = as_id_cierrepatrimonial,
					@as_id_r    = as_id_cierreresultados

	from EjercicioContable

	where ejc_id = @@ejc_id

	if @as_id_pa is not null or @as_id_r is not null begin

		raiserror ('@@ERROR_SP:Este ejercicio posee asientos de cierre. Debe borrar los asientos de cierre del ejercicio para poder borrar el asiento de apertura.', 16, 1)

	end else begin

		begin tran
	
			if @as_id is not null begin 
	
				update EjercicioContable set as_id_apertura = null where ejc_id = @@ejc_id
				if @@error <> 0 goto ControlError
	
				exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
				if @@error <> 0 goto ControlError
	
			end
	
		commit tran

	end

	return
ControlError:
                          
	raiserror ('Ha ocurrido un error al borrar el asiento de apertura. sp_EjercicioAperturaDelete.', 16, 1)

	if @@trancount > 0

		rollback tran

end
GO