/*---------------------------------------------------------------------
Nombre: modifica la fecha de un remito
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9800]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9800]

/*

select * from remitoventa where rv_nrodoc = 'x-0001-00001903'
DC_CSC_VEN_9800 1,4
*/

go
create procedure DC_CSC_VEN_9800 (

  @@us_id     int,
  @@impid_id  int

)as 
begin
set nocount on


	select
				1                     as orden_id,
				rv.rv_id,
				emp_nombre            as Empresa,
				rv_fecha							as Fecha,
				rv_nrodoc     				as Remito,
				cli_nombre    				as Cliente,
				cli_codigo    				as Codigo,
				sum(rvi_cantidad)			as Cantidad,
				rv_total              as Importe,
				impid_descrip,
        impid_fecha

	from RemitoVenta rv inner join RemitoVentaItem rvi on rv.rv_id  		= rvi.rv_id
											inner join Cliente cli         on rv.cli_id 		= cli.cli_id
											inner join Empresa emp         on rv.emp_id 		= emp.emp_id
                      inner join ImportacionID i     on rv.impid_id   = i.impid_id

	where rv.impid_id = @@impid_id

	group by
						rv.rv_id, 
						emp_nombre, 
						rv_fecha, 
						rv_nrodoc, 
						cli_nombre, 
						cli_codigo, 
						rv_total,
						impid_descrip,
						impid_fecha

end
go