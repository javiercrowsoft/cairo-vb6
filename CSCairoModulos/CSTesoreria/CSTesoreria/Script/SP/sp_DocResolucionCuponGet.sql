if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocResolucionCuponGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocResolucionCuponGet]

go

/*

sp_DocResolucionCuponGet 13,7

*/

create procedure sp_DocResolucionCuponGet (
	@@emp_id   int,
	@@rcup_id  int,
  @@us_id    int
)
as

begin

declare @bEditable 		tinyint
declare @editMsg   		varchar(255)
declare @doc_id    		int
declare @ta_id        int
declare @ta_Mascara 	varchar(100)
declare @ta_Propuesto tinyint

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             TALONARIO Y ESTADO DE EDICION                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @doc_id = doc_id from ResolucionCupon where rcup_id = @@rcup_id
	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocResolucionCuponEditableGet @@emp_id, @@rcup_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select 
			ResolucionCupon.*,
	    est_nombre,
      suc_nombre,
      doc_nombre,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      @bEditable					as editable,
      @editMsg						as editMsg,
      @ta_Propuesto 			as TaPropuesto,
			@ta_Mascara					as TaMascara
	
	from 
			ResolucionCupon  inner  join documento      on ResolucionCupon.doc_id  = documento.doc_id
											 inner  join estado         on ResolucionCupon.est_id  = estado.est_id
											 inner  join sucursal       on ResolucionCupon.suc_id  = sucursal.suc_id
		                   left join legajo          	on ResolucionCupon.lgj_id  = legajo.lgj_id

  where rcup_id = @@rcup_id

end