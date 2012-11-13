SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_ProveedorGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ProveedorGet]
GO

/*

sp_web_ProveedorGet 7

*/

create Procedure sp_web_ProveedorGet
(
	@@us_id int  
) 
as
begin

	select top 200 prov_id, 
				 	prov_nombre as [Proveedor]

	from Proveedor

	union

	select 	0 as prov_id,
					'(Ninguno)' as [Proveedor]

	order by prov_nombre

end
go
set quoted_identifier off 
go
set ansi_nulls on 
go

