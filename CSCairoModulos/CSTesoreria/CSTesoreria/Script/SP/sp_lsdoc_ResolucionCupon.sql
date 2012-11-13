if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_ResolucionCupon]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_ResolucionCupon]

/*
		sp_lsdoc_ResolucionCupon 1
    select * from ResolucionCupon
*/

go
create procedure sp_lsdoc_ResolucionCupon (
	@@rcup_id int
)as 
begin

select distinct
			ResolucionCupon.rcup_id,
			''									  	as [TypeTask],
			rcup_numero             as [Número],
			rcup_nrodoc						  as [Comprobante],
			tjc_nombre              as [Tarjeta],
	    bco_nombre            	as [Banco],
      cue_nombre              as [Cuenta],
      doc_nombre					  	as [Documento],
	    est_nombre					  	as [Estado],
			rcup_fecha						  as [Fecha],
			rcup_total							as [Total],
			case rcup_firmado
				when 0 then 'No'
				else        'Si'
			end											as [Firmado],
			
      suc_nombre							as [Sucursal],
			emp_nombre              as [Empresa],

			ResolucionCupon.Creado,
			ResolucionCupon.Modificado,
			usuario.us_nombre     	as [Modifico],
			rcup_descrip						as [Observaciones]
from 
			ResolucionCupon  		inner join documento     				on ResolucionCupon.doc_id   		= documento.doc_id
											    inner join empresa        			on documento.emp_id 					  = empresa.emp_id
											 	  inner join estado        				on ResolucionCupon.est_id   		= estado.est_id
											 	  inner join sucursal      				on ResolucionCupon.suc_id   		= sucursal.suc_id
												  inner join ResolucionCuponItem	on ResolucionCupon.rcup_id  		= ResolucionCuponItem.rcup_id
		                   	  inner join Cuenta       				on ResolucionCuponItem.cue_id   = Cuenta.cue_id
		                   	  inner join Banco       					on Cuenta.bco_id   						  = Banco.bco_id
												  inner join TarjetaCreditoCupon  on ResolucionCuponItem.tjcc_id  = TarjetaCreditoCupon.tjcc_id
                          inner join TarjetaCredito     	on TarjetaCreditoCupon.tjc_id   = TarjetaCredito.tjc_id
		                   	  left  join usuario       				on ResolucionCupon.modifico 		= usuario.us_id
where 
					@@rcup_id = ResolucionCupon.rcup_id

end
