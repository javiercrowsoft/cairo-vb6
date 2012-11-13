SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_infoProveedorChartCompras2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorChartCompras2]
GO

create procedure sp_infoProveedorChartCompras2 (
	@@us_id        int,
	@@emp_id       int,
	@@prov_id      int,
	@@info_aux     varchar(255) = ''
)
as

begin

	set nocount on

	declare @fDesde datetime
	declare @dias   int

	set @fDesde = dateadd(m,-5,getdate())
	set @dias = datepart(d,@fDesde)
	set @dias = @dias-1
	if @dias > 0 set @fDesde = dateadd(d,-@dias,@fDesde)

	select 	datepart(yyyy,fc_fecha)		as Anio, 
					datepart(m,fc_fecha)			as Mes,
					sum(case when doct_id = 8 then -fc_neto else fc_neto end)   					  
																		as Total

	from FacturaCompra fc 

	where prov_id = @@prov_id 
		and fc_fecha >= @fDesde
		and est_id <> 7

	group by datepart(yyyy,fc_fecha), datepart(m,fc_fecha)

	order by datepart(yyyy,fc_fecha), datepart(m,fc_fecha)

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
