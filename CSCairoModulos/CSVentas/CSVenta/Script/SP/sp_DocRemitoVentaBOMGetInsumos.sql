if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaBOMGetInsumos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaBOMGetInsumos]

go

/*

select * from pedidoventaitem where pv_id = 8
exec sp_DocRemitoVentaBOMGetInsumos '1,2,3,4,5,6'

*/

create procedure sp_DocRemitoVentaBOMGetInsumos (
	@@strIds 					  varchar(5000)
)
as

begin

  set nocount on

	declare @timeCode datetime
	set @timeCode = getdate()
	exec sp_strStringToTable @timeCode, @@strIds, ','

	select 

			pbmi.*,
			pr_nombrecompra,
			(select max(pbme_cantidad) from ProductoBOMElaborado where pbm_id = pbmi.pbm_id)
			as pbme_cantidad

  from ProductoBOMItem pbmi inner join Producto pr 	on pbmi.pr_id = pr.pr_id
											  		inner join TmpStringToTable			
																				on pbmi.pbm_id  = convert(int,TmpStringToTable.tmpstr2tbl_campo)
	where tmpstr2tbl_id =  @timeCode

	order by pbmi.pbm_id, pr_nombrecompra

end
go