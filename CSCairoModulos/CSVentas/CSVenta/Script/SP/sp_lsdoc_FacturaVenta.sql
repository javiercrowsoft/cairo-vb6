
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_FacturaVenta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_FacturaVenta]

/*
		sp_lsdoc_FacturaVenta 14
    select * from facturaventa
*/

go
create procedure sp_lsdoc_FacturaVenta (
	@@fv_id int
)as 
begin
select 
			fv_id,
			''									  as [TypeTask],
			fv_numero             as [Número],
			fv_nrodoc						  as [Comprobante],
	    cli_nombre            as [Cliente],
      doc_nombre					  as [Documento],
	    est_nombre					  as [Estado],
			fv_fecha						  as [Fecha],
			fv_fechaentrega				as [Fecha de entrega],
			fv_neto								as [Neto],
			fv_ivari							as [IVA RI],
			fv_ivarni							as [IVA RNI],
			fv_subtotal						as [Subtotal],
			fv_total							as [Total],
			fv_pendiente					as [Pendiente],
			case fv_firmado
				when 0 then 'No'
				else        'Si'
			end										as [Firmado],
			case impreso
				when 0 then 'No'
				else        'Si'
			end										as [Impreso],
			case emailenviado
				when 0 then 'No'
				else        'Si'
			end										as [Email],
			
			fv_descuento1					as [% Desc. 1],
			fv_descuento2					as [% Desc. 2],
			fv_importedesc1				as [Desc. 1],
			fv_importedesc2				as [Desc. 2],

	    lp_nombre						as [Lista de Precios],
	    ld_nombre						as [Lista de descuentos],
	    cpg_nombre					as [Condicion de Pago],
	    ccos_nombre					as [Centro de costo],
      suc_nombre					as [Sucursal],
			emp_nombre          as [Empresa],

			FacturaVenta.Creado,
			FacturaVenta.Modificado,
			us_nombre             as [Modifico],
			case when fv_cae = '' and doc_esfacturaelectronica <> 0 then 'Pendiente' else fv_cae end 
														as [CAE],
			fv_cae_nrodoc					as [CAE Comprobante],
			fv_cae_vto            as [CAE Vto],
			fv_descrip						as [Observaciones]
from 
			Facturaventa inner join documento     on Facturaventa.doc_id   = documento.doc_id
									 inner join empresa       on documento.emp_id      = empresa.emp_id     
                   inner join condicionpago on Facturaventa.cpg_id   = condicionpago.cpg_id
									 inner join estado        on Facturaventa.est_id   = estado.est_id
									 inner join sucursal      on Facturaventa.suc_id   = sucursal.suc_id
                   inner join cliente       on Facturaventa.cli_id   = cliente.cli_id
                   inner join usuario       on Facturaventa.modifico = usuario.us_id
                   left join vendedor       on Facturaventa.ven_id   = vendedor.ven_id
                   left join centrocosto    on Facturaventa.ccos_id  = centrocosto.ccos_id
                   left join listaprecio    on Facturaventa.lp_id    = listaprecio.lp_id
  								 left join listadescuento on Facturaventa.ld_id    = listadescuento.ld_id
where 

				  
					@@fv_id = fv_id

end
