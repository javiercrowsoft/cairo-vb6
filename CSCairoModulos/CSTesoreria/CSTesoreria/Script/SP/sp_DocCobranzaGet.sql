if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaGet]

go

/*

sp_DocCobranzaGet 57,7

*/

create procedure sp_DocCobranzaGet (
	@@emp_id   int,
	@@cobz_id int,
  @@us_id   int
)
as

begin

declare @bEditable 		tinyint
declare @editMsg   		varchar(255)
declare @doc_id    		int
declare @ta_Mascara 	varchar(100)
declare @ta_Propuesto tinyint

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             TALONARIO Y ESTADO DE EDICION                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @doc_id = doc_id from Cobranza where cobz_id = @@cobz_id

	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocCobranzaEditableGet @@emp_id, @@cobz_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select 
			Cobranza.*,
	    cli_nombre,
	    est_nombre,
	    ccos_nombre,
      suc_nombre,
      doc_nombre,
      cob_nombre,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      @bEditable          	as editable,
      @editMsg            	as editMsg,
			@ta_Mascara						as TaMascara,
      @ta_Propuesto         as TaPropuesto
	
	from 
			Cobranza inner join Documento      		 on Cobranza.doc_id  = Documento.doc_id
									 inner join Estado         on Cobranza.est_id  = Estado.est_id
									 inner join Sucursal       on Cobranza.suc_id  = Sucursal.suc_id
                   inner join Cliente        on Cobranza.cli_id  = Cliente.cli_id
                   left join CentroCosto     on Cobranza.ccos_id = CentroCosto.ccos_id
                   left join Cobrador        on Cobranza.cob_id  = Cobrador.cob_id
                   left join Legajo          on Cobranza.lgj_id  = Legajo.lgj_id

  where cobz_id = @@cobz_id

end