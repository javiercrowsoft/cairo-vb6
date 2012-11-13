/*---------------------------------------------------------------------
Nombre: Actualiza la Fecha de IVA y la Fecha de Asientos con el valor de fv_fecha
---------------------------------------------------------------------*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_9993]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_9993]

/*

[DC_CSC_CON_9993] 1,1

*/

go
create procedure DC_CSC_CON_9993 (

  @@us_id    		int,

	@@corregir    smallint

)as 
begin

  set nocount on

	if @@corregir <> 0 begin

		update FacturaVenta set fv_fechaiva = fv_fecha
		where fv_id in (

			select 	fv.fv_id
		
			from FacturaVenta fv inner join Asiento ast on fv.as_id = ast.as_id
		
			where fv_fecha <> as_fecha

		)

		update Asiento set as_fecha = fv_fecha
		from FacturaVenta fv
		where Asiento.as_id in (

			select 	fv.as_id
		
			from FacturaVenta fv inner join Asiento ast on fv.as_id = ast.as_id
		
			where fv_fecha <> as_fecha

		)
		and Asiento.as_id = fv.as_id 

		update FacturaVenta set fv_fechaiva = fv_fecha
		where fv_fecha <> fv_fechaiva and est_id = 7

		update FacturaVenta set fv_fechaiva = fv_fecha
		from Asiento ast
		where ast.as_id in (

			select 	fv.as_id
		
			from FacturaVenta fv inner join Asiento ast on fv.as_id = ast.as_id
		
			where fv_fecha = as_fecha

		)
		and ast.as_id = FacturaVenta.as_id 
		and fv_fechaiva <> fv_fecha

	end


	select 	fv_id						as comp_id, 
					fv.doct_id			as doct_id,
					fv_fecha        as Fecha,
					fv_nrodoc       as Factura,
					fv_fechaiva     as IVA,
					as_fecha        as [Fecha Asiento],
					as_nrodoc       as Asiento,
					est_nombre      as Estado,
					doct_nombre     as [Tipo de Documento]

	from FacturaVenta fv left join Asiento ast on fv.as_id = ast.as_id
											 left join Estado est on fv.est_id = est.est_id
											 left join DocumentoTipo doct on fv.doct_id = doct.doct_id

	where fv_fecha <> as_fecha
		or fv_fecha <> fv_fechaiva

end
go
 