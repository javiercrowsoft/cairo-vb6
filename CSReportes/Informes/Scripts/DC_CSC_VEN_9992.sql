/*

Permite asociar rapidamente una lista de precios a un conjunto de clientes.

[DC_CSC_VEN_9992] 1,'20060501','20060531','dmd629'

*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9992]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9992]


go
create procedure DC_CSC_VEN_9992 (

  @@us_id    			int,
	@@fini          datetime,
	@@ffin          datetime,
  @@descrip   		varchar(255) 

)as 
begin

  set nocount on

	select 	rv.rv_id,
					emp_nombre        as [Empresa],
					doc_nombre        as [Documento],
					rv_fecha					as [Fecha],
					cli_nombre				as [Cliente],
					cli_razonsocial		as [Razon Social],
					rv_numero     		as [Número],
					rv_nrodoc					as [Comprobante],
					rv_descrip				as [Observaciones],
					rvi_descrip   		as [Item Observación],
					pr_nombreventa    as [Producto]
					

	from (RemitoVenta rv 	inner join Cliente cli 					on rv.cli_id = cli.cli_id
																												and	rv_fecha between @@fini and @@ffin
				)
												inner join Documento doc        on rv.doc_id = doc.doc_id
												inner join Empresa emp          on rv.emp_id = emp.emp_id
												left join  RemitoVentaItem rvi 	on 		rv.rv_id  = rvi.rv_id
																													and rvi_descrip like '%' + @@descrip + '%'
												left join  Producto pr          on rvi.pr_id = pr.pr_id

	where 

				(			rv_descrip like '%' + @@descrip + '%' 
					or 	rvi_descrip like '%' + @@descrip + '%'
				)

	order by rv_fecha, rv_nrodoc
end
go
 