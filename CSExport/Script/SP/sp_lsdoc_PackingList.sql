
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_PackingList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_PackingList]

/*
		sp_lsdoc_PackingList 14
    select * from PermisoEmbarque
*/

go
create procedure sp_lsdoc_PackingList (
	@@pklst_id int
)as 
begin




select 
			pklst_id,
			''									    as [TypeTask],
			pklst_numero            as [Número],
			pklst_nrodoc					  as [Comprobante],
	    cli_nombre              as [Cliente],
      doc_nombre					    as [Documento],
	    est_nombre				  	  as [Estado],
			pklst_fecha						  as [Fecha],
			pklst_pendiente					as [Pendiente],
			case pklst_firmado
				when 0 then 'No'
				else        'Si'
			end										as [Firmado],
			
	    ccos_nombre						as [Centro de costo],
      suc_nombre						as [Sucursal],
			emp_nombre            as [Empresa],

			PackingList.Creado,
			PackingList.Modificado,
			us_nombre               as [Modifico],
			pklst_descrip						as [Observaciones]
from 
			PackingList     inner join Documento     on PackingList.doc_id   = Documento.doc_id
										  inner join empresa       on documento.emp_id 		 = empresa.emp_id
										  inner join Estado        on PackingList.est_id   = Estado.est_id
										  inner join Sucursal      on PackingList.suc_id   = Sucursal.suc_id
	                    inner join Cliente       on PackingList.cli_id   = Cliente.cli_id
	                    inner join Usuario       on PackingList.modifico = Usuario.us_id
	                    left join Centrocosto    on PackingList.ccos_id  = Centrocosto.ccos_id

where 
				  
					@@pklst_id = pklst_id

end
