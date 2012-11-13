if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_EmpleadoPeriodoAddEmpleados]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_EmpleadoPeriodoAddEmpleados]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_EmpleadoPeriodoAddEmpleados '0', '20080901', '20080930'

*/
create procedure sp_EmpleadoPeriodoAddEmpleados (
	@@empe_id 	int,
	@@em_id  		varchar(255),
	@@desde  		datetime,
	@@hasta  		datetime
)
as
begin

	set nocount on

	----------------------------------------------------------------------------------------

	declare @em_id int
	declare @ram_id_Empleado int
	
	declare @clienteID int
	declare @IsRaiz    tinyint
	
	exec sp_ArbConvertId @@em_id, 			@em_id out, 			@ram_id_Empleado out
	
	exec sp_GetRptId @clienteID out

	if @ram_id_Empleado <> 0 begin
	
		-- exec sp_ArbGetGroups @ram_id_Empleado, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Empleado, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Empleado, @clienteID 
		end else 
			set @ram_id_Empleado = 0
	end

	----------------------------------------------------------------------------------------


	----------------------------------------------------------------------------------------

	select 	em.em_id,
					emccos.ccos_id,
					em_apellido + ', ' + em_nombre as em_nombre,
					ccos_nombre

	from Empleado em left join EmpleadoCentroCosto emccos on 		em.em_id = emccos.em_id
																													and emccos_desde <= @@desde
																													and emccos_hasta >= @@hasta

									 left join CentroCosto ccos on emccos.ccos_id = ccos.ccos_id

	where (em.em_id = @em_id or @em_id = 0)
		and (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 35005
	                  and  rptarb_hojaid = em.em_id
								   ) 
	           )
	        or 
						 (@ram_id_Empleado = 0)
				 )

		and not exists(select * from EmpleadoHoras where empe_id = @@empe_id and ccos_id = ccos.ccos_id and em_id = em.em_id)

	order by em_nombre

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

