if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_InfGetReportes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_InfGetReportes]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


-- sp_InfGetReportes 0
create procedure sp_InfGetReportes (
	@@us_id int
)
as
begin
	set nocount on

	select 
			inf_id,
			inf_nombre,
			inf_codigo,
			inf_descrip,
			inf_storedprocedure,
			inf_reporte,
			inf_presentaciondefault,
			inf_modulo,
			inf_tipo,
			inf_propietario,
			creado,
			modificado,
			modifico,
			activo
  from informe

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

