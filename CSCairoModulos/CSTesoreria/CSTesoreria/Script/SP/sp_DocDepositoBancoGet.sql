if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoBancoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoBancoGet]

go

/*

sp_DocDepositoBancoGet 13,7

*/

create procedure sp_DocDepositoBancoGet (
	@@emp_id   int,
	@@dbco_id  int,
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

  select @doc_id = doc_id from DepositoBanco where dbco_id = @@dbco_id
	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocDepositoBancoEditableGet @@emp_id, @@dbco_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select 
			DepositoBanco.*,
			Cuenta.mon_id,
	    bco_nombre,
	    est_nombre,
      suc_nombre,
      doc_nombre,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      cue_nombre,
      @bEditable					as editable,
      @editMsg						as editMsg,
      @ta_Propuesto 			as TaPropuesto,
			@ta_Mascara					as TaMascara
	
	from 
			DepositoBanco  	 inner  join documento      on DepositoBanco.doc_id  = documento.doc_id
											 inner  join estado         on DepositoBanco.est_id  = estado.est_id
											 inner  join sucursal       on DepositoBanco.suc_id  = sucursal.suc_id
		                   inner  join Banco        	on DepositoBanco.bco_id  = Banco.bco_id
                       inner  join Cuenta         on DepositoBanco.cue_id  = Cuenta.cue_id
		                   left join legajo          	on DepositoBanco.lgj_id  = legajo.lgj_id

  where dbco_id = @@dbco_id

end