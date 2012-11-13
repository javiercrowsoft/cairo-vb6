
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_PermisoEmbarque]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_PermisoEmbarque]

/*
		sp_lsdoc_PermisoEmbarque 14
    select * from PermisoEmbarque
*/

go
create procedure sp_lsdoc_PermisoEmbarque (
	@@pemb_id int
)as 
begin
select 
			pemb_id,
			''									    as [TypeTask],
			pemb_numero             as [Número],
			pemb_nrodoc						  as [Comprobante],
	    emb_nombre              as [Embarque],
      doc_nombre					    as [Documento],
	    est_nombre				  	  as [Estado],
			pemb_fecha						  as [Fecha],
			pemb_Total			  			as [Total],
			pemb_TotalOrigen				as [Total Origen],
			pemb_pendiente					as [Pendiente],
			case pemb_firmado
				when 0 then 'No'
				else        'Si'
			end										as [Firmado],
			
	    lp_nombre						as [Lista de Precios],
	    adu_nombre					as [Aduana],
      bco_nombre          as [Banco],
	    ccos_nombre					as [Centro de costo],
      suc_nombre					as [Sucursal],
			emp_nombre          as [Empresa],

			PermisoEmbarque.Creado,
			PermisoEmbarque.Modificado,
			us_nombre               as [Modifico],
			pemb_descrip						as [Observaciones]
from 
			PermisoEmbarque inner join Documento     on PermisoEmbarque.doc_id   = Documento.doc_id
											inner join empresa       on documento.emp_id         = empresa.emp_id
	                    inner join Aduana 			 on PermisoEmbarque.adu_id   = Aduana.adu_id
										  inner join Estado        on PermisoEmbarque.est_id   = Estado.est_id
										  inner join Sucursal      on PermisoEmbarque.suc_id   = Sucursal.suc_id
	                    inner join Embarque      on PermisoEmbarque.emb_id   = Embarque.emb_id
	                    inner join Usuario       on PermisoEmbarque.modifico = Usuario.us_id
	                    inner join Banco         on PermisoEmbarque.bco_id   = Banco.bco_id
	                    left join Centrocosto    on PermisoEmbarque.ccos_id  = Centrocosto.ccos_id
	                    left join Listaprecio    on PermisoEmbarque.lp_id    = Listaprecio.lp_id

where 
				  
					@@pemb_id = pemb_id

end
