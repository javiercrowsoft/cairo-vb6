if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_TrabajoImpresionSetDone]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_TrabajoImpresionSetDone]

/*

*/

go
create procedure sp_TrabajoImpresionSetDone(

	@@timp_id int
) 
as

begin

	update TrabajoImpresion set timp_estado = 3 where timp_id = @@timp_id

end

go