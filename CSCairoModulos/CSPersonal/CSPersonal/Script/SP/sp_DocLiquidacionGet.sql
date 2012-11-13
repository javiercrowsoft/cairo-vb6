if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocLiquidacionGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocLiquidacionGet]

go

/*

sp_DocLiquidacionGet 13,7

*/

create procedure sp_DocLiquidacionGet (
	@@emp_id   int,
	@@liq_id   int,
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
  select @doc_id = doc_id from Liquidacion where liq_id = @@liq_id
	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocLiquidacionEditableGet @@emp_id, @@liq_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select 
			Liquidacion.*,
	    est_nombre,
	    ccos_nombre,
      suc_nombre,
      doc_nombre,
			liqp_nombre,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      @bEditable					as editable,
      @editMsg						as editMsg,
      @ta_Propuesto 			as TaPropuesto,
			@ta_Mascara					as TaMascara
	
	from 
			Liquidacion  inner join documento      				on Liquidacion.doc_id  = documento.doc_id
									 inner join estado         				on Liquidacion.est_id  = estado.est_id
									 inner join sucursal       				on Liquidacion.suc_id  = sucursal.suc_id
                   left join centrocosto     				on Liquidacion.ccos_id = centrocosto.ccos_id
                   left join legajo          				on Liquidacion.lgj_id  = legajo.lgj_id
									 left join liquidacionplantilla		on Liquidacion.liqp_id  = liquidacionplantilla.liqp_id

  where liq_id = @@liq_id

end