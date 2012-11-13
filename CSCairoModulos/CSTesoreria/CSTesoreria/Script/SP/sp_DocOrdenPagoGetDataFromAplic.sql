if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoGetDataFromAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoGetDataFromAplic]

/*

	sp_DocOrdenPagoGetDataFromAplic 3,'23,45'

*/

go
create procedure sp_DocOrdenPagoGetDataFromAplic (
	@@doct_id int,
	@@strIds	varchar(5000)
)
as

begin

	declare @timeCode datetime
	set @timeCode = getdate()
	exec sp_strStringToTable @timeCode, @@strIds, ','

	if @@doct_id = 2 -- Factura Compra begin
	begin

		select distinct 
						fc.suc_id,
						fc.lgj_id,
						fc.cpg_id,
						fc.ccos_id,

						suc_nombre,
						lgj_titulo,
						cpg_nombre,
						ccos_nombre						

	  from (FacturaCompra fc inner join TmpStringToTable	
						on fc.fc_id  = convert(int,TmpStringToTable.tmpstr2tbl_campo)
								and tmpstr2tbl_id = @timeCode
				 )

				 left join sucursal suc 					on suc.suc_id 		= fc.suc_id
				 left join condicionpago cpg 			on cpg.cpg_id 		= fc.cpg_id
				 left join centrocosto ccos  			on ccos.ccos_id 	= fc.ccos_id
				 left join legajo lgj         		on lgj.lgj_id 		= fc.lgj_id

		where tmpstr2tbl_id = @timeCode

	end else

		-- Devolvemos un recordset vacio para que el que llama
		-- no fallse el preguntar por eof
		select 0 as dummy from OrdenPago where 1=2

end
go

/*
				 left join sucursal suc 					on suc.suc_id 		= @@@.suc_id
				 left join condicionpago cpg 			on cpg.cpg_id 		= @@@.cpg_id
				 left join centrocosto ccos  			on ccos.ccos_id 	= @@@.ccos_id
				 left join legajo lgj         		on lgj.lgj_id 		= @@@.lgj_id
				 left join provincia po       		on po.pro_id 			= @@@.pro_id_origen
				 left join provincia pd       		on pd.pro_id 			= @@@.pro_id_destino
				 left join transporte trans   		on trans.trans_id = @@@.trans_id
				 left join chofer chof        		on chof.chof_id 	= @@@.chof_id
				 left join camion cam         		on cam.cam_id 		= @@@.cam_id
         left join camion semi        		on semi.cam_id 		= @@@.cam_id_semi

*/