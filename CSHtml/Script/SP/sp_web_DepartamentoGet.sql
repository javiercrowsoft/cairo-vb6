SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_DepartamentoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_DepartamentoGet]
GO

/*

sp_web_DepartamentoGet 1

*/

create Procedure sp_web_DepartamentoGet
(
  @@us_id int  
) 
as
begin

  select dpto_id, 
         dpto_nombre as [Departamento]

  from Departamento

  union

  select 0 as dpto_id, 
         '(Ninguno)' as [Departamento]

  order by dpto_nombre

end
go
set quoted_identifier off 
go
set ansi_nulls on 
go