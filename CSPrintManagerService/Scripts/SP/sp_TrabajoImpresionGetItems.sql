if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_TrabajoImpresionGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_TrabajoImpresionGetItems]

/*

*/

go
create procedure sp_TrabajoImpresionGetItems (
  @@timp_id int
) 
as

begin

  select *
  from TrabajoImpresionItem
  where timp_id = @@timp_id
  order by timpi_id

end

go