-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Transferencias de Compensacion
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0360]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0360]

GO

create procedure DC_CSC_STK_0360 (

  @@us_id    int,

	@@fDesde   datetime,
	@@fHasta   datetime,

@@depl_id_origen 	int,
@@depl_id_destino int

)as 

begin

	set nocount on

	select 	st_numero as Numero,

					st.st_id					as comp_id,
					doct_id						as doct_id,

					st_fecha as Fecha,
					st_nrodoc as Comprobante,
					do.depl_nombre as Origen,
					dd.depl_nombre as Destino,
					st_descrip     as Observaciones

	from stock st left join depositologico do on st.depl_id_origen = do.depl_id
								left join depositologico dd on st.depl_id_destino = dd.depl_id

	where depl_id_origen in (@@depl_id_origen,@@depl_id_destino) and depl_id_destino in (@@depl_id_origen,@@depl_id_destino)

		and st_fecha between @@fDesde and @@fHasta

end
GO