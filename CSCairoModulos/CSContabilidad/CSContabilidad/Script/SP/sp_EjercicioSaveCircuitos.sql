if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_EjercicioSaveCircuitos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EjercicioSaveCircuitos]

-- sp_EjercicioSaveCircuitos 1,1

go
create procedure sp_EjercicioSaveCircuitos (

	@@ejc_id 				int

)as 
begin

	set nocount on

	declare @@cico_id									varchar(50)
	declare @cico_id									int
	declare @ram_id_circuitocontable 	int

	select 	@@cico_id = cico_id

	from EjercicioContable

	where ejc_id = @@ejc_id

	declare @clienteID 				int	
	declare @IsRaiz    				tinyint

	exec sp_GetRptId @clienteID out

	exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
	
	if @ram_id_circuitocontable <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
		end else 
			set @ram_id_circuitocontable = 0
	end

	delete EjercicioContableCircuitoContable where ejc_id = @@ejc_id

	if @cico_id <> 0 begin

		insert into EjercicioContableCircuitoContable (ejc_id, cico_id) values(@@ejc_id, @cico_id)

	end else begin

		insert into EjercicioContableCircuitoContable (ejc_id, cico_id) 
		select @@ejc_id, rptarb_hojaid
		from rptArbolRamaHoja 
		where rptarb_cliente = @clienteID 
			and tbl_id = 1016 

	end
	
end
go