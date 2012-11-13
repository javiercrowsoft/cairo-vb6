if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_9997]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_9997]
GO


/*

DC_CSC_STK_9997 1

*/

create procedure DC_CSC_STK_9997 (

	@@us_id int

)
as
begin

	set nocount on

	select 1 										as aux,
				 id_cliente 					as comp_id,
				 doct_id_cliente 			as doct_id, 
				 st_id            		as Stock,
				 doct_nombre 					as Tipo,
				 st_fecha							as Fecha, 
				 st_nrodoc 						as Comprobante,
				 deplo.depl_nombre		as Origen,
				 depld.depl_nombre    as Destino

	from stock st inner join documentotipo doct on st.doct_id_cliente   = doct.doct_id
								inner join depositologico deplo on st.depl_id_origen  = deplo.depl_id
								inner join depositologico depld on st.depl_id_destino = depld.depl_id

	where st_id in (
	select distinct st_id from stockitem where pr_id_kit <> pr_id
	)

	order by Tipo, Stock

end
GO