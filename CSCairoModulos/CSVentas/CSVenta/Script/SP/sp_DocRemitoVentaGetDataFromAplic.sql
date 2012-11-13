if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaGetDataFromAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaGetDataFromAplic]

/*

	sp_DocRemitoVentaGetDataFromAplic 4,'23,45'

*/

go
create procedure sp_DocRemitoVentaGetDataFromAplic (
	@@doct_id int,
	@@strIds	varchar(5000)
)
as

begin

	declare @timeCode datetime
	set @timeCode = getdate()
	exec sp_strStringToTable @timeCode, @@strIds, ','

	if @@doct_id = 5 -- Remito Venta begin
	begin

		select distinct 
						pv.suc_id,
						pv.cpg_id,
						pv.ccos_id,
						pv.ven_id,
						pv.lgj_id,
						pv.pro_id_origen,
						pv.pro_id_destino,
						pv.trans_id,
						pv.chof_id,
						pv.cam_id,
						pv.cam_id_semi,
						pv.clis_id, 
						pv_ordencompra,

						suc_nombre,
						cpg_nombre,
						ccos_nombre,
						ven_nombre,
						lgj_titulo,
						po.pro_nombre as provincia_origen,
						pd.pro_nombre as provincia_destino,
						trans_nombre,
						chof_nombre,
						cam.cam_patente,
						semi.cam_patente	as semi,
						clis_nombre

	  from (PedidoVenta pv inner join TmpStringToTable	
						on pv.pv_id  = convert(int,TmpStringToTable.tmpstr2tbl_campo)
								and tmpstr2tbl_id = @timeCode
				 )

				 left join sucursal suc 					on suc.suc_id 		= pv.suc_id
				 left join condicionpago cpg 			on cpg.cpg_id 		= pv.cpg_id
				 left join centrocosto ccos  			on ccos.ccos_id 	= pv.ccos_id
				 left join vendedor ven						on ven.ven_id 		= pv.ven_id
				 left join legajo lgj         		on lgj.lgj_id 		= pv.lgj_id
				 left join provincia po       		on po.pro_id 			= pv.pro_id_origen
				 left join provincia pd       		on pd.pro_id 			= pv.pro_id_destino
				 left join transporte trans   		on trans.trans_id = pv.trans_id
				 left join chofer chof        		on chof.chof_id 	= pv.chof_id
				 left join camion cam         		on cam.cam_id 		= pv.cam_id
         left join camion semi        		on semi.cam_id 		= pv.cam_id_semi
         left join clientesucursal clis		on clis.clis_id 	= pv.clis_id

		where tmpstr2tbl_id = @timeCode

	end else

		-- Devolvemos un recordset vacio para que el que llama
		-- no fallse el preguntar por eof
		select 0 as dummy from RemitoVenta where 1=2

end
go

/*
				 left join sucursal suc 					on suc.suc_id 		= @@@.suc_id
				 left join condicionpago cpg 			on cpg.cpg_id 		= @@@.cpg_id
				 left join centrocosto ccos  			on ccos.ccos_id 	= @@@.ccos_id
				 left join vendedor ven						on ven.ven_id 		= @@@.ven_id
				 left join legajo lgj         		on lgj.lgj_id 		= @@@.lgj_id
				 left join provincia po       		on po.pro_id 			= @@@.pro_id_origen
				 left join provincia pd       		on pd.pro_id 			= @@@.pro_id_destino
				 left join transporte trans   		on trans.trans_id = @@@.trans_id
				 left join chofer chof        		on chof.chof_id 	= @@@.chof_id
				 left join camion cam         		on cam.cam_id 		= @@@.cam_id
         left join camion semi        		on semi.cam_id 		= @@@.cam_id_semi
         left join clientesucursal clis		on clis.clis_id 	= @@@.clis_id

*/