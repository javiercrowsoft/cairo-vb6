if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoGetKits]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoGetKits]

/*

 select * from cliente where cli_codigo like '300%'
 select * from documento

 sp_ProductoGetKits 35639

*/

go
create procedure sp_ProductoGetKits (
	@@pr_id 		int
)
as

begin

	set nocount on

  select 
         prfk_id,
         prfk_codigo,
         prfk_nombre,
         prfk_default

  from ProductoFormulaKit f

  where 
      pr_id = @@pr_id
end

go