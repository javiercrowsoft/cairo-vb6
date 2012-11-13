if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EjercicioCierrePDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EjercicioCierrePDelete]

--  sp_EjercicioCierrePDelete 1,1,0
-- 

go
create procedure sp_EjercicioCierrePDelete (                                                                  

	@@us_id					int,
	@@ejc_id 				int,
	@@bCentroCosto	smallint = 0

)as 
begin

	set nocount on

	declare @emp_id 			varchar(50)
	declare @cico_id			varchar(50)
	declare @fechaIni			datetime
	declare @fechaFin			datetime
	declare @doc_id   		int
	declare @ejc_nombre		varchar(255)
	declare @as_id_ap			int
	declare @as_id_cp			int
	declare @as_id_cr			int

	select 	@emp_id 		= emp_id,
					@cico_id 		= cico_id,
					@fechaIni 	= ejc_fechaIni,
					@fechaFin 	= ejc_fechaFin,
					@doc_id			= doc_id,
					@ejc_nombre	= ejc_nombre,
					@as_id_ap		= as_id_apertura,
					@as_id_cp		= as_id_cierrepatrimonial,
					@as_id_cr   = as_id_cierreresultados

	from EjercicioContable

	where ejc_id = @@ejc_id

	declare @ejc_id_siguiente int
	declare @as_id_ap_next 		int

	exec sp_EjercicioGetNext @emp_id, @cico_id, @fechaFin, @ejc_id_siguiente out, 0

	if @ejc_id_siguiente is not null begin
	
		select @as_id_ap_next = as_id_apertura 
		from EjercicioContable
		where ejc_id = @ejc_id_siguiente

	end

	if @as_id_ap_next is not null begin

		raiserror ('@@ERROR_SP:El ejercicio siguiente esta abierto. Debe borrar el asiento de apertura del siguiente ejercicio para poder borrar el asiento de cierre patrimonial.', 16, 1)

	end else begin

		begin tran
	
			if @as_id_cp is not null begin 
	
				update EjercicioContable set as_id_cierrepatrimonial = null where ejc_id = @@ejc_id
				if @@error <> 0 goto ControlError
	
				exec sp_DocAsientoDelete @as_id_cp,0,0,1 -- No check access
				if @@error <> 0 goto ControlError
	
			end
	
		commit tran

	end

	return
ControlError:
                          
	raiserror ('Ha ocurrido un error al borrar el asiento de cierre patrimonial. sp_EjercicioCierrePDelete.', 16, 1)

	if @@trancount > 0

		rollback tran

end
GO