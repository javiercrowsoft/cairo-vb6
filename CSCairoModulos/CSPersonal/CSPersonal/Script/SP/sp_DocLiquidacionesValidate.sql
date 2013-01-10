if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocLiquidacionesValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocLiquidacionesValidate]

/*

  exec  sp_DocLiquidacionesValidate

*/

go
create procedure sp_DocLiquidacionesValidate 
as

begin

  exec sp_DocLiquidacionesSetEstado
end 

go