if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_Cfg_GetValor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_Cfg_GetValor]

go

/*

sp_Cfg_GetValor 1

*/
create procedure sp_Cfg_GetValor (
  @@cfg_grupo     varchar(60),
  @@cfg_aspecto   varchar(60),
  @@cfg_valor     varchar(5000) out,
  @@bShow         tinyint = 0,
  @@emp_id        int = null
)
as

begin

  set nocount on

  select @@cfg_valor = cfg_valor

  from   Configuracion

  where 
      cfg_grupo   = @@cfg_grupo
  and cfg_aspecto = @@cfg_aspecto
  and (emp_id = @@emp_id or (emp_id is null and @@emp_id is null))

  if @@bShow <> 0 select @@cfg_valor

end