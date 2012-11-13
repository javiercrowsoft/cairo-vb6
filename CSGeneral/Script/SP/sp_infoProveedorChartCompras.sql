SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_infoProveedorChartCompras]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorChartCompras]
GO

create procedure sp_infoProveedorChartCompras (
	@@us_id        int,
	@@emp_id       int,
	@@prov_id      int,
	@@info_aux     varchar(255) = ''
)
as

begin

	set nocount on

	exec sp_infoProveedorChartCompras2 @@us_id,
																	   @@emp_id,
																	   @@prov_id,
																	   @@info_aux

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
