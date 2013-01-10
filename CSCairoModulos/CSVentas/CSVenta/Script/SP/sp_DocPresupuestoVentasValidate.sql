if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVentasValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVentasValidate]

/*

  exec  sp_DocPresupuestoVentasValidate

*/

go
create procedure sp_DocPresupuestoVentasValidate 
as

begin

  exec sp_DocPresupuestoVentasSetPendiente 
  exec sp_DocPresupuestoVentasSetEstado
end 

go