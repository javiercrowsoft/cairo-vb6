/*

select * from rama where ram_nombre like 'el nombre de alguna rama de algun arbol de la tabla a listar'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_ProductoSerie]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_ProductoSerie]
go

/*
*/

create procedure sp_lsdoc_ProductoSerie (

  @@prns_id		int

)as 


select

		prns.prns_id,
		''									as [TypeTask],

		prns_codigo					as [Numero Serie],
		prns_codigo2				as [OT],

		cli_nombre          as Cliente,
		isnull(
		isnull(
		isnull(t.tar_fechaini,
					 os.os_fecha),
					 rc.rc_fecha),
					 fc.fc_fecha)
												as [Ingreso],
		depl_nombre         as Deposito,
		doc_nombre					as Documento,
		isnull(isnull(isnull(isnull(isnull(
					 rc_nrodoc,fc_nrodoc),rs_nrodoc),ppk_nrodoc),impt_nrodoc),os_nrodoc)
												as Comprobante,
		pr_nombrecompra			as Equipo,

		t.tar_fechafin      as [Fecha Limite],
		rub_nombre          as Rubro,

		usr.us_nombre				as Responable,
    usa.us_nombre				as Asigno,
		prov_nombre         as Proveedor,
		prns_descrip				as Observaciones

from 
			ProductoNumeroSerie prns

											inner join Producto pr   on prns.pr_id   = pr.pr_id
											left join tarea t               on prns.tar_id = t.tar_id
											left join proyecto proy         on t.proy_id   = proy.proy_id


											left join remitocompra 		rc  	on prns.doct_id_ingreso = 4 		and prns.doc_id_ingreso = rc.rc_id
											left join facturacompra 	fc  	on prns.doct_id_ingreso = 2 		and prns.doc_id_ingreso = fc.fc_id
											left join recuentostock   rs  	on prns.doct_id_ingreso = 28		and prns.doc_id_ingreso = rs.rs_id
                      left join parteprodkit    ppk 	on prns.doct_id_ingreso = 30    and prns.doc_id_ingreso = ppk.ppk_id
                      left join importaciontemp impt	on prns.doct_id_ingreso = 29		and prns.doc_id_ingreso = impt.impt_id
											left join ordenservicio   os  	on prns.doct_id_ingreso = 42    and prns.doc_id_ingreso = os.os_id

											left  join documento doc on 		rc.doc_id		= doc.doc_id 
																									or  fc.doc_id		= doc.doc_id 
																									or  rs.doc_id		= doc.doc_id 
																									or  ppk.doc_id	= doc.doc_id 
																									or  impt.doc_id	= doc.doc_id 
																									or  os.doc_id		= doc.doc_id 

											left  join empresa emp   on doc.emp_id  		= emp.emp_id
											left  join sucursal suc  on 		rc.suc_id		= suc.suc_id 
																									or  fc.suc_id		= suc.suc_id 
																									or  rs.suc_id		= suc.suc_id 
																									or  ppk.suc_id	= suc.suc_id 
																									or  impt.suc_id	= suc.suc_id 
																									or  os.suc_id		= suc.suc_id 

											left  join usuario usr   on t.us_id_responsable 	= usr.us_id
											left  join usuario usa   on t.us_id_asignador     = usa.us_id

											left  join depositologico depl	on prns.depl_id 	= depl.depl_id

											left  join rubro rub 				on pr.rub_id 		= rub.rub_id
											left  join cliente cli 			on prns.cli_id 	= cli.cli_id
											left  join proveedor prov 	on prns.prov_id = prov.prov_id

where 
				prns.prns_id = @@prns_id
go