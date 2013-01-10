SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_ClienteGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ClienteGet]
GO

/*

sp_web_ClienteGet 7

*/

create Procedure sp_web_ClienteGet
(
  @@us_id int  
) 
as
begin

  select top 200 cli_id, 
           cli_nombre as [Cliente]

  from Cliente

  union

  select   0 as cli_id,
          '(Ninguno)' as [Cliente]

  order by cli_nombre

end
go
set quoted_identifier off 
go
set ansi_nulls on 
go

