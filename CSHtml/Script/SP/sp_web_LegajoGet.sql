SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_LegajoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_LegajoGet]
GO

/*

sp_web_LegajoGet 7

*/

create Procedure sp_web_LegajoGet
(
	@@us_id int  
) 
as
begin

	select lgj_id, 
				 case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as [Legajo]

	from Legajo

	union

	select 0 as lgj_id, 
				 '(Ninguno)' as [Legajo]

	order by Legajo

end
go
set quoted_identifier off 
go
set ansi_nulls on 
go
