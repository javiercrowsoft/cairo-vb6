if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_LiquidacionAddEmpleados]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LiquidacionAddEmpleados]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

sp_LiquidacionAddEmpleados '0',3,0

*/
create procedure sp_LiquidacionAddEmpleados (
	@@em_id  varchar(255)
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

	select 	distinct 
					em.em_id,
					em_apellido + ', ' + em_nombre as em_nombre

	from Empleado em 

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

	order by 2

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

