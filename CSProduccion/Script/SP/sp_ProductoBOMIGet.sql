if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoBOMIGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoBOMIGet]

/*

 sp_ProductoBOMIGet 35639

*/

go
create procedure sp_ProductoBOMIGet (
  @@pbm_id     int
)
as

begin

  set nocount on

  select 
      pbmi.*,
      pbmit_nombre,
      pr_nombreCompra

  from
    ProductoBOMItem pbmi inner join ProductoBOMItemTipo pbmit on pbmi.pbmit_id = pbmit.pbmit_id
                         left  join Producto            pr    on pbmi.pr_id = pr.pr_id
  
  where pbmi.pbm_id = @@pbm_id

  select
      pbmi.*,
      pr_nombreCompra

  from
    ProductoBOMItemA pbmia inner join ProductoBOMItem pbmi on pbmia.pbmi_id = pbmi.pbmi_id
                           inner join Producto pr           on pbmia.pr_id = pr.pr_id
  where pbmi.pbm_id = @@pbm_id

end

go
