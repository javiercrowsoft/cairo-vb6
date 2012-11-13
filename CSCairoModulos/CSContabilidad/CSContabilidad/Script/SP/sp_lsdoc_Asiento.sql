
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_Asiento]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_Asiento]

go
create procedure sp_lsdoc_Asiento (
@@as_id int
)as 
begin
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

			(	select sum(asi_debe)
				from asientoitem   
				where asientoitem.as_id = asiento.as_id
					and asi_debe <> 0)as [Total],

			Asiento.Creado,
			Asiento.Modificado,
			us_nombre             as [Modifico],
			as_descrip						as [Observaciones]
from 
			Asiento inner join documento     on Asiento.doc_id   = documento.doc_id
              inner join usuario       on Asiento.modifico = usuario.us_id
							inner join empresa       on documento.emp_id = empresa.emp_id
where 

				  
					@@as_id = as_id

end
