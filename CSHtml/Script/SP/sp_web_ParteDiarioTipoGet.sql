SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioTipoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioTipoGet]
GO

/*

sp_web_ParteDiarioTipoGet 7

*/

create Procedure sp_web_ParteDiarioTipoGet

as
begin

	select ptdt_id, 
				 ptdt_nombre as [Tipo]

	from ParteDiarioTipo

	order by ptdt_nombre

end
go
set quoted_identifier off 
go
set ansi_nulls on 
go

