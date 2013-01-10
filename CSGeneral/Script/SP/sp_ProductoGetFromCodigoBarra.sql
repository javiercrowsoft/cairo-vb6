if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoGetFromCodigoBarra ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoGetFromCodigoBarra ]

/*

 sp_ProductoGetFromCodigoBarra  6

*/

go
create procedure sp_ProductoGetFromCodigoBarra  (
  @@pr_codigobarra     varchar(255)
)
as

begin

  set nocount on

  select pr_id, pr_nombrecompra, pr_nombreventa 

  from Producto pr

  where pr_codigobarra = @@pr_codigobarra

end
go