if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoBOMEGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoBOMEGet]

/*

 sp_ProductoBOMEGet 35639

*/

go
create procedure sp_ProductoBOMEGet (
	@@pbm_id 		int
)
as

begin

	set nocount on

  select 
      pbme.*,
      pr_nombreCompra

  from
    ProductoBOMElaborado pbme inner join Producto pr on pbme.pr_id = pr.pr_id
  
  where
       @@pbm_id = pbme.pbm_id
end

go
