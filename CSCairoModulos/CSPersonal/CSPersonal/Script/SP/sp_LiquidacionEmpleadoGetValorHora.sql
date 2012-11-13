if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LiquidacionEmpleadoGetValorHora]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LiquidacionEmpleadoGetValorHora]

go

/*
update empleado set sindco_id = 3, sindca_id = 4, sind_id = 2
sp_LiquidacionEmpleadoGetValorHora 3, '20070101'
*/

create procedure sp_LiquidacionEmpleadoGetValorHora (
	@@em_id 		int,
	@@fecha     datetime
)
as

begin

	set nocount on

	declare @sind_id int
	declare @sindco_id int
	declare @sindca_id int

	select  @sind_id = sind_id,
					@sindco_id = sindco_id,
					@sindca_id = sindca_id  
	from Empleado 
	where em_id = @@em_id

	select sindcc_importe 
	from SindicatoConvenioCategoria	
	where sindca_id = @sindca_id 
		and sind_id = @sind_id 
		and sindco_id = @sindco_id
		and @@fecha between sindcc_desde and sindcc_hasta
end

go