SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_ContactosGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ContactosGet]
GO

/*

sp_web_ContactosGet 7

*/

create Procedure sp_web_ContactosGet
(
  @@us_id int  
) 
as
begin

  select cont_id, 
         cont_nombre as [Contacto]

  from Contacto

  union

  select 0 as cont_id, 
         '(Ninguno)' as [Contacto]

  order by cont_nombre

end
go
set quoted_identifier off 
go
set ansi_nulls on 
go

