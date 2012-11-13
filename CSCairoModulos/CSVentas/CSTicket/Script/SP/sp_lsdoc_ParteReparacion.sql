
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_ParteReparacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_ParteReparacion]

go
create procedure sp_lsdoc_ParteReparacion (
@@prp_id int
)as 
begin

set nocount on

select 
			prp_id,
			''									  as [TypeTask],
			prp_numero            as [Número],
			prp_nrodoc						as [Comprobante],
	    cli_nombre            as [Cliente],
      doc_nombre					  as [Documento],

			case prp_tipo
					when 1 then 'Presupuesto'
          when 2 then 'Reparación'
			end                   as [Tipo],
      case prp_estado
					when 1 then 'Pendiente'
					when 2 then 'Rechazado'
					when 3 then 'En Aprobación'
					when 4 then 'Aprobado'
					when 5 then 'En Espera de Repuestos'
          else        'Sin definir'
      end                   as [Estado Rep.],

	    est_nombre					  as [Estado],
			prns_codigo           as [Nro. Serie],
			prns_codigo2          as [OT],
			prp_fecha						  as [Fecha],
			prp_fechaentrega			as [Fecha de entrega],
			prp_neto							as [Neto],
			prp_ivari							as [IVA RI],
			prp_ivarni						as [IVA RNI],
			prp_subtotal					as [Subtotal],
			prp_total							as [Total],
			
			prp_descuento1				as [% Desc. 1],
			prp_descuento2				as [% Desc. 2],
			prp_importedesc1			as [Desc. 1],
			prp_importedesc2			as [Desc. 2],
			
			us2.us_nombre					as [Técnico],

	    lp_nombre							as [Lista de Precios],
	    ld_nombre							as [Lista de descuentos],
	    cpg_nombre						as [Condicion de Pago],
	    ccos_nombre						as [Centro de costo],
      suc_nombre						as [Sucursal],
			emp_nombre            as [Empresa],

			ParteReparacion.Creado,
			ParteReparacion.Modificado,
			usuario.us_nombre     as [Modifico],
			prp_descrip						as [Observaciones]
from 
			ParteReparacion 
									inner join documento     on ParteReparacion.doc_id   = documento.doc_id
								  inner join empresa       on documento.emp_id 		 		 = empresa.emp_id
                  inner join condicionpago on ParteReparacion.cpg_id   = condicionpago.cpg_id
									inner join estado        on ParteReparacion.est_id   = estado.est_id
									inner join sucursal      on ParteReparacion.suc_id   = sucursal.suc_id
                  inner join cliente       on ParteReparacion.cli_id   = cliente.cli_id
                  inner join usuario       on ParteReparacion.modifico = usuario.us_id

									left join productonumeroserie prns on ParteReparacion.prns_id = prns.prns_id
                  left join usuario us2    on ParteReparacion.us_id    = us2.us_id
                  left join centrocosto    on ParteReparacion.ccos_id  = centrocosto.ccos_id
                  left join listaprecio    on ParteReparacion.lp_id    = listaprecio.lp_id
  								left join listadescuento on ParteReparacion.ld_id    = listadescuento.ld_id
where 

				  
					@@prp_id = prp_id

end
go