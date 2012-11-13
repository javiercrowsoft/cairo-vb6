
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_ImportacionTemp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_ImportacionTemp]

go
create procedure sp_lsdoc_ImportacionTemp (
@@impt_id int
)as 
begin
select 
			impt_id,
			''									  	as [TypeTask],
			impt_numero             as [Número],
			impt_nrodoc						  as [Comprobante],
	    prov_nombre           	as [Proveedor],
      doc_nombre					  	as [Documento],
	    est_nombre					  	as [Estado],
			impt_fecha						  as [Fecha],
			impt_fechaentrega				as [Fecha de entrega],
			impt_neto								as [Neto],
			impt_ivari							as [IVA RI],
			impt_ivarni							as [IVA RNI],
			impt_subtotal						as [Subtotal],
			impt_total							as [Total],
			case impt_firmado
				when 0 then 'No'
				else        'Si'
			end										as [Firmado],
			
			impt_descuento1					as [% Desc. 1],
			impt_descuento2					as [% Desc. 2],
			impt_importedesc1				as [Desc. 1],
			impt_importedesc2				as [Desc. 2],

	    lp_nombre							as [Lista de Precios],
	    ld_nombre							as [Lista de descuentos],
	    cpg_nombre						as [Condicion de Pago],
	    ccos_nombre						as [Centro de costo],
      suc_nombre						as [Sucursal],
			emp_nombre            as [Empresa],

			ImportacionTemp.Creado,
			ImportacionTemp.Modificado,
			us_nombre             as [Modifico],
			impt_descrip						as [Observaciones]
from 
			ImportacionTemp inner join documento     on ImportacionTemp.doc_id   = documento.doc_id
											inner join empresa       on documento.emp_id 				 = empresa.emp_id
		                  inner join condicionpago on ImportacionTemp.cpg_id   = condicionpago.cpg_id
											inner join estado        on ImportacionTemp.est_id   = estado.est_id
											inner join sucursal      on ImportacionTemp.suc_id   = sucursal.suc_id
		                  inner join Proveedor     on ImportacionTemp.prov_id  = proveedor.prov_id
		                  inner join usuario       on ImportacionTemp.modifico = usuario.us_id
		                  left join centrocosto    on ImportacionTemp.ccos_id  = centrocosto.ccos_id
		                  left join listaprecio    on ImportacionTemp.lp_id    = listaprecio.lp_id
		  								left join listadescuento on ImportacionTemp.ld_id    = listadescuento.ld_id
where 

				  
					@@impt_id = impt_id

end
go