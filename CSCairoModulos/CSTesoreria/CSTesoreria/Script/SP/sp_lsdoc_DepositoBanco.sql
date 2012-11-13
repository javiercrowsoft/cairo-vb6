if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_DepositoBanco]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_DepositoBanco]

/*
		sp_lsdoc_DepositoBanco 1
    select * from DepositoBanco
*/

go
create procedure sp_lsdoc_DepositoBanco (
	@@dbco_id int
)as 
begin

select 
			dbco_id,
			''									  	as [TypeTask],
			dbco_numero             as [Número],
			dbco_nrodoc						  as [Comprobante],
	    bco_nombre            	as [Banco],
      cue_nombre              as [Cuenta],
      doc_nombre					  	as [Documento],
	    est_nombre					  	as [Estado],
			dbco_fecha						  as [Fecha],
			dbco_total							as [Total],
			case dbco_firmado
				when 0 then 'No'
				else        'Si'
			end											as [Firmado],
			
      suc_nombre							as [Sucursal],
			emp_nombre              as [Empresa],

			DepositoBanco.Creado,
			DepositoBanco.Modificado,
			usuario.us_nombre     	as [Modifico],
			dbco_descrip						as [Observaciones]
from 
			DepositoBanco  		inner join documento     	on DepositoBanco.doc_id   = documento.doc_id
											  inner join empresa        on documento.emp_id 			= empresa.emp_id
											 	inner join estado        	on DepositoBanco.est_id   = estado.est_id
											 	inner join sucursal      	on DepositoBanco.suc_id   = sucursal.suc_id
		                   	inner join Banco       		on DepositoBanco.bco_id   = Banco.bco_id
		                   	inner join Cuenta       	on DepositoBanco.cue_id   = Cuenta.cue_id
		                   	left  join usuario       	on DepositoBanco.modifico = usuario.us_id
where 
					@@dbco_id = dbco_id

end
