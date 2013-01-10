SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_PrioridadGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_PrioridadGet]
GO

/*

sp_web_PrioridadGet 7

*/

create Procedure sp_web_PrioridadGet
(
  @@us_id int  
) 
as
begin

  select prio_id, 
         prio_nombre as [Prioridad]

  from Prioridad

  union

  select 0 as prio_id, 
         '(Ninguna)' as [Prioridad]

  order by prio_nombre

end
go
set quoted_identifier off 
go
set ansi_nulls on 
go

