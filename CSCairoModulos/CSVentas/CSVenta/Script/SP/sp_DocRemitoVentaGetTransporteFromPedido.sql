if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaGetTransporteFromPedido]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaGetTransporteFromPedido]

go

/*

select * from pedidoventaitem where pv_id = 8
exec sp_DocRemitoVentaGetTransporteFromPedido '1,2,3,4,5,6'

*/

create procedure sp_DocRemitoVentaGetTransporteFromPedido (
	@@strIds 					  varchar(5000)
)
as

begin

  set nocount on

	declare @timeCode datetime
	set @timeCode = getdate()
	exec sp_strStringToTable @timeCode, @@strIds, ','

	declare @pv_id int

	select @pv_id = min(convert(int,TmpStringToTable.tmpstr2tbl_campo))
	from TmpStringToTable
	where tmpstr2tbl_id = @timeCode

	select
					pv.trans_id,
					trans_nombre,
					pv.chof_id,
					chof_nombre,
					pv.cam_id 			as cam_id,
					c1.cam_patente 	as cam_patente,
					pv.cam_id_semi	as cam_id_semi,
					c2.cam_patente  as cam_patentesemi

	from PedidoVenta 	pv	left join Transporte trans on pv.trans_id 	 = trans.trans_id
												left join Chofer chof      on pv.chof_id 		 = chof.chof_id
												left join Camion c1        on pv.cam_id 		 = c1.cam_id
                        left join Camion c2        on pv.cam_id_semi = c2.cam_id
	where
			pv_id = @pv_id
end
go