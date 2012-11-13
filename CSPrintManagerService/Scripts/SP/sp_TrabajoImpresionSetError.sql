if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_TrabajoImpresionSetError]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_TrabajoImpresionSetError]

/*

*/

go
create procedure sp_TrabajoImpresionSetError(

	@@timp_id int
) 
as

begin

	update TrabajoImpresion set timp_estado = 4 where timp_id = @@timp_id

end

go