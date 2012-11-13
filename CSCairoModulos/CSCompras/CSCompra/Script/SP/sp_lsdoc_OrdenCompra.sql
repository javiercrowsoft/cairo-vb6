
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_OrdenCompra]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_OrdenCompra]

go
create procedure sp_lsdoc_OrdenCompra (
@@oc_id int
)as 
begin
select 
			oc_id,
			''									  as [TypeTask],
			oc_numero             as [Número],
			oc_nrodoc						  as [Comprobante],
	    prov_nombre           as [Proveedor],
      doc_nombre					  as [Documento],
	    est_nombre					  as [Estado],
			oc_fecha						  as [Fecha],
			oc_fechaentrega				as [Fecha de entrega],
			case impreso
				when 0 then 'No'
				else        'Si'
			end										as [Impreso],
			oc_neto								as [Neto],
			oc_ivari							as [IVA RI],
			oc_ivarni							as [IVA RNI],
			oc_subtotal						as [Subtotal],
			oc_total							as [Total],
			oc_pendiente					as [Pendiente],
			case oc_firmado
				when 0 then 'No'
				else        'Si'
			end										as [Firmado],
			
			oc_descuento1					as [% Desc. 1],
			oc_descuento2					as [% Desc. 2],
			oc_importedesc1				as [Desc. 1],
			oc_importedesc2				as [Desc. 2],

	    lp_nombre							as [Lista de Precios],
	    ld_nombre							as [Lista de descuentos],
	    cpg_nombre						as [Condicion de Pago],
	    ccos_nombre						as [Centro de costo],
      suc_nombre						as [Sucursal],
			emp_nombre            as [Empresa],

			OrdenCompra.Creado,
			OrdenCompra.Modificado,
			us_nombre             as [Modifico],
			oc_descrip						as [Observaciones]
from 
			OrdenCompra inner join documento     on OrdenCompra.doc_id   = documento.doc_id
								   inner join empresa       on documento.emp_id 		 = empresa.emp_id
                   inner join condicionpago on OrdenCompra.cpg_id   = condicionpago.cpg_id
									 inner join estado        on OrdenCompra.est_id   = estado.est_id
									 inner join sucursal      on OrdenCompra.suc_id   = sucursal.suc_id
                   inner join Proveedor     on OrdenCompra.prov_id  = Proveedor.prov_id
                   inner join usuario       on OrdenCompra.modifico = usuario.us_id
                   left join centrocosto    on OrdenCompra.ccos_id  = centrocosto.ccos_id
                   left join listaprecio    on OrdenCompra.lp_id    = listaprecio.lp_id
  								 left join listadescuento on OrdenCompra.ld_id    = listadescuento.ld_id
where 

				  
					@@oc_id = oc_id

end
