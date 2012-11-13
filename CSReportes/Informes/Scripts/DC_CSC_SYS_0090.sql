-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Lista errores de auditoria
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0090]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0090]


/*

 [DC_CSC_SYS_0090] 1,'20050223 00:00:00','20050131 00:00:00','121','0','0',0,'1',1

*/

go
create procedure DC_CSC_SYS_0090 (

	@@us_id int
)

as

begin

	set nocount on

	select 
				audi_id,
				case a.doct_id
						when	1 then fv_fecha
						when	7 then fv_fecha
						when	9 then fv_fecha
	
						when  2 then fc_fecha
						when  8 then fc_fecha
						when  10 then fc_fecha
	
						when  3 then rv_fecha
						when  4 then rc_fecha
				end 							as Fecha,
	
				doc_nombre        as Documento,
	
				case a.doct_id
						when	1 then fv_nrodoc
						when	7 then fv_nrodoc
						when	9 then fv_nrodoc
	
						when  2 then fc_nrodoc
						when  8 then fc_nrodoc
						when  10 then fc_nrodoc
	
						when  3 then rv_nrodoc
						when  4 then rc_nrodoc
				end 							as Documento,
				audi_descrip 			as Observaciones
	
	from 
	
		auditoriaitem a 
											left join remitoventa 	rv on a.comp_id = rv.rv_id and a.doct_id = rv.doct_id
											left join remitocompra 	rc on a.comp_id = rc.rc_id and a.doct_id = rc.doct_id
											left join facturaventa  fv on a.comp_id = fv.fv_id and a.doct_id = fv.doct_id
											left join facturacompra fc on a.comp_id = fc.fc_id and a.doct_id = fc.doct_id
	
											left join documento doc  on 		rv.doc_id = doc.doc_id 
																									or 	fv.doc_id = doc.doc_id
																									or 	rc.doc_id = doc.doc_id
																									or 	fc.doc_id = doc.doc_id
	
	where audi_descrip not like '%no mueve stock%' --and audi_descrip like '%valvu%'

end

go