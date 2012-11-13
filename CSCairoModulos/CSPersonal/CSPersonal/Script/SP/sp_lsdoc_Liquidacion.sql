/*


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Liquidacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Liquidacion]
go

/*

sp_lsdoc_Liquidacion 1

*/

create procedure sp_lsdoc_Liquidacion (

	@@liq_id int

)as 

begin

set nocount on

select 
			liq_id,
			''									  as [TypeTask],
			liq_numero            as [Número],
			liq_nrodoc						as [Comprobante],
      doc_nombre					  as [Documento],
	    est_nombre					  as [Estado],
			liq_fecha						  as [Fecha],
			liq_neto							as [Neto],
			liq_total							as [Total],
			case liq_firmado
				when 0 then 'No'
				else        'Si'
			end										as [Firmado],
			case impreso
				when 0 then 'No'
				else        'Si'
			end										as [Impreso],
			
	    ccos_nombre					as [Centro de costo],
      suc_nombre					as [Sucursal],
			emp_nombre          as [Empresa],

			Liquidacion.Creado,
			Liquidacion.Modificado,
			us_nombre             as [Modifico],
			liq_descrip						as [Observaciones]

from 
			Liquidacion inner join documento      on Liquidacion.doc_id   = documento.doc_id
									inner join empresa        on documento.emp_id     = empresa.emp_id     
									inner join estado         on Liquidacion.est_id   = estado.est_id
									inner join sucursal       on Liquidacion.suc_id   = sucursal.suc_id
                  inner join usuario        on Liquidacion.modifico = usuario.us_id
                  left  join centrocosto    on Liquidacion.ccos_id  = centrocosto.ccos_id
where 

		Liquidacion.liq_id = @@liq_id

end
go