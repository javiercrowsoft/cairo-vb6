/*---------------------------------------------------------------------
Nombre: Cuenta Corriente de Compras
---------------------------------------------------------------------*/

/*
	Para testear:


	[DC_CSC_COM_0290] 1,'20080101 00:00:00','20081231 00:00:00'

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0290]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0290]

go
create procedure [dbo].[DC_CSC_COM_0290] (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime

)as 

begin

set nocount on

	select 	
					fc.doct_id					as doct_id,
					fc.fc_id						as comp_id,
					fc_nrodoc 					as Comprobante,
					prov_razonsocial		as Proveedor,
				 	fc_fecha						as [Fecha Factura],
					fc_fechaiva         as [Fecha IVA],
				 	as_fecha 						as [Fecha Asiento],
					fc_total						as Total
	
	from facturacompra fc left join asiento ast 		on fc.as_id 	= ast.as_id
												left join proveedor prov 	on fc.prov_id = prov.prov_id
	
	where fc_fecha between @@Fini and	@@Ffin
		and fc_fecha <> as_fecha
		and est_id <> 7
	
	order by as_fecha

end