if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_MovimientoFondo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_MovimientoFondo]

/*
		sp_lsdoc_MovimientoFondo 1
    select * from MovimientoFondo
*/

go
create procedure sp_lsdoc_MovimientoFondo (
	@@mf_id int
)as 
begin

select 
			mf_id,
			''									  as [TypeTask],
			mf_numero             as [Número],
			mf_nrodoc						  as [Comprobante],
	    cli_nombre            as [Cliente],
      doc_nombre					  as [Documento],
	    est_nombre					  as [Estado],
			mf_fecha						  as [Fecha],
			mf_total							as [Total],
			mf_pendiente					as [Pendiente],
			case mf_firmado
				when 0 then 'No'
				else        'Si'
			end										as [Firmado],
			
	    ccos_nombre					  as [Centro de costo],
      suc_nombre					  as [Sucursal],
			emp_nombre            as [Empresa],

      resp.us_nombre        as [Responsable],

			MovimientoFondo.Creado,
			MovimientoFondo.Modificado,
			usuario.us_nombre     as [Modifico],
			mf_descrip						as [Observaciones]
from 
			MovimientoFondo  inner join documento     on MovimientoFondo.doc_id   = documento.doc_id
  										 inner join empresa       on documento.emp_id 				= empresa.emp_id
											 inner join estado        on MovimientoFondo.est_id   = estado.est_id
											 inner join sucursal      on MovimientoFondo.suc_id   = sucursal.suc_id
		                   left  join cliente       on MovimientoFondo.cli_id   = cliente.cli_id
		                   left  join usuario       on MovimientoFondo.modifico = usuario.us_id
		                   left join usuario resp   on MovimientoFondo.us_id    = resp.us_id
		                   left join centrocosto    on MovimientoFondo.ccos_id  = centrocosto.ccos_id
where 
					@@mf_id = mf_id

end
