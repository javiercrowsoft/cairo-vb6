SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_UsuariosGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_UsuariosGet]
GO

/*

sp_web_UsuariosGet 7

*/

create Procedure sp_web_UsuariosGet
(
  @@us_id int  
) 
as

  select 
      us_id,
      us_nombre               as [Usuario]

  from usuario

  union

  select 
      0 as us_id,
      '(Ninguno)'               as [Usuario]

  order by us_nombre

go
set quoted_identifier off 
go
set ansi_nulls on 
go

