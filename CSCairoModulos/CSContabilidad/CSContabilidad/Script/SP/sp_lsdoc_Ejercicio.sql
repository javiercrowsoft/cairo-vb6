
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Ejercicio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Ejercicio]

go
create procedure sp_lsdoc_Ejercicio (

	@@ejc_id int

)as 
begin

select 
			ejc_id,
			''									  as [TypeTask],
			ejc_codigo            as [Código],
			ejc_nombre					  as [Nombre],
			emp_nombre            as [Empresa],

			case when as_id_cierrepatrimonial is null 
						and as_id_cierreresultados is null then 'Abierto'
           else            													'Cierre'
			end										as [Estado],

			ap.as_nrodoc          as [Apertura],
			ap.as_fecha						as [Fecha Apertura],
			acp.as_nrodoc         as [Cierre Patrimonial],
			acp.as_fecha          as [Fecha Cierre Patrimonial],
			acr.as_nrodoc         as [Cierre Resultados],
      acr.as_fecha          as [Fecha Cierre Resultados],

			ejc.Creado,
			ejc.Modificado,
			us_nombre             as [Modifico],
			ejc_descrip						as [Observaciones]
from 
			EjercicioContable ejc

              inner join usuario       on ejc.modifico = usuario.us_id
							left  join empresa       on isnumeric(ejc.emp_id)<>0 and ejc.emp_id = convert(varchar,empresa.emp_id)
							left  join asiento ap    on ejc.as_id_apertura 					= ap.as_id
							left  join asiento acp   on ejc.as_id_cierrepatrimonial = acp.as_id
							left  join asiento acr	 on ejc.as_id_cierreresultados 	= acr.as_id
where 			  
			ejc.ejc_id = @@ejc_id

end
