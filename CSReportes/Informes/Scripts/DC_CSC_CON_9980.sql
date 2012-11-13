if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_9980]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_9980]
GO
/*  

Para testear:

[DC_CSC_CON_9980] 70,'20051001 00:00:00','20060930 00:00:00','0','0','0','0','5'

DC_CSC_CON_9980 1, 
								'20060101',
								'20060120',
								'0', 
								'0',
								'0',
								'0',
								'0'
*/

create procedure DC_CSC_CON_9980 (

	@@us_id     int,

	@@fDesde		datetime,
	@@fHasta		datetime,
	@@doc_id		int,
	@@emp_id		int,
	@@cico_id		varchar(255)

)as 

begin
	set nocount on

	declare @bSuccess tinyint

	exec sp_DocAsientoResumirAsientos2
																			@@doc_id		,
																			@@emp_id		,
																			@@cico_id		,
																			@@fDesde		,
																			@@fHasta		,
																			@@us_id     ,
																			@bSuccess out


	if @bSuccess <> 0 begin

		select 	0						as comp_id,
						0           as doct_id,
						''					as Fecha,
						''   				as Comprobante,
						'El proceso concluyo con exito y se generaron los siguientes asientos' as Observaciones

		union all

		select 	as_id				as comp_id, 
						doct_id			as doct_id,
						as_fecha		as Fecha,
						as_nrodoc   as Comprobante,
						as_descrip  as Observaciones 

		from Asiento

		where as_fecha between @@fdesde and @@fhasta and as_doc_cliente in ('[ARC]','[ARV]')

	end else begin

		select 0 as comp_id, 'El proceso no pudo generar los asientos de resumen' as Info

	end



end
GO