/*---------------------------------------------------------------------
Nombre: Ordena las ramas de un arbol
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0120]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0120]

GO

create procedure DC_CSC_SYS_0120 (

  @@us_id   int,
  @@arb_id  int

)
as
begin

  exec sp_ArbSortRamas @@arb_id

  select 1, 'El proceso se ejecuto con éxito' as Info

end
go