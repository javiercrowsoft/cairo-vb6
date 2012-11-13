/*---------------------------------------------------------------------
Nombre: Asientos con debe <> haber
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0030]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0030]

/*

 select * from TmpStringToTable

 DC_CSC_SYS_0030 1

*/

go
create procedure DC_CSC_SYS_0030 (

  @@us_id          int

)as 
begin
set nocount on

select 
			as_id,
			''									  as [TypeTask],
			as_numero             as [Número],
			as_nrodoc						  as [Comprobante],
      doc_nombre					  as [Documento],
			as_fecha						  as [Fecha],
      case doct_id_cliente

				when 1  then           'Factura de Venta'
				when 2  then           'Factura de Compra'
				when 7  then           'Nota de Credito Venta'
				when 8  then           'Nota de Credito Compra'
				when 9  then           'Nota de Debito Venta'
				when 10  then          'Nota de Debito Compra'
				when 13  then          'Cobranza'
				when 16  then          'Orden de Pago'
				when 17  then          'Deposito Banco'
				when 26  then          'Movimiento de Fondos'

			end  									as [Tipo Doc.],
			as_doc_cliente        as [Documento Aux],
			emp_nombre            as [Empresa],

			asiento.Creado,
			asiento.Modificado,
			us_nombre             as [Modifico],
			as_descrip						as [Observaciones]
from 
			asiento inner join documento     on asiento.doc_id   = documento.doc_id
              inner join usuario       on Asiento.modifico = usuario.us_id
							inner join empresa       on documento.emp_id = empresa.emp_id

where as_id in (

select a.as_id from asientoitem ai inner join asiento a on ai.as_id = a.as_id

group by a.as_id having round(sum(asi_debe - asi_haber),1) <> 0

) 

end
go