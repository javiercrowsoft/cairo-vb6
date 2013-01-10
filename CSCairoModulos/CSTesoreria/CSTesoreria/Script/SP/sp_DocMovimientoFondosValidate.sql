if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondosValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondosValidate]

/*

  exec  sp_DocMovimientoFondosValidate

*/

go
create procedure sp_DocMovimientoFondosValidate 
as

begin

  exec sp_DocMovimientoFondosSetPendiente 
  exec sp_DocMovimientoFondosSetEstado
end 

go