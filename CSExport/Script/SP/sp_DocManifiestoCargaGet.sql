if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocManifiestoCargaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocManifiestoCargaGet]

go

/*

sp_DocManifiestoCargaGet 1, 7

*/

create procedure sp_DocManifiestoCargaGet (
	@@emp_id   int,
	@@mfc_id   int,
  @@us_id    int
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

  select @doc_id = doc_id from ManifiestoCarga where mfc_id = @@mfc_id

	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocManifiestoCargaEditableGet @@emp_id, @@mfc_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select 
			ManifiestoCarga.*,
	    cli_nombre,
	    est_nombre,
	    ccos_nombre,
      suc_nombre,
      doc_nombre,
      trans_nombre,
      chof_nombre,
      barc_nombre,
      cmarc_nombre,
      pOrigen.pue_nombre          as [Puerto Origen],
      pDestino.pue_nombre         as [Puerto Destino],
      dOrigen.depl_nombre         as [Deposito Origen],
      dDestino.depl_nombre        as [Deposito Destino],
      @bEditable          	as editable,
      @editMsg            	as editMsg,
			@ta_Mascara						as TaMascara,
      @ta_Propuesto         as TaPropuesto
	
	from 
			ManifiestoCarga  inner join documento      on ManifiestoCarga.doc_id  = documento.doc_id
											 inner join estado         on ManifiestoCarga.est_id  = estado.est_id
											 inner join sucursal       on ManifiestoCarga.suc_id  = sucursal.suc_id
		                   inner join Cliente        on ManifiestoCarga.cli_id  = Cliente.cli_id

											 left join Transporte     on ManifiestoCarga.trans_id  = Transporte.trans_id
											 left  join Chofer         on ManifiestoCarga.chof_id   = Chofer.chof_id
											 left join Barco          on ManifiestoCarga.barc_id   = Barco.barc_id
											 left  join ContraMarca    on ManifiestoCarga.cmarc_id  = ContraMarca.cmarc_id

											 left join Puerto pOrigen  			   on ManifiestoCarga.pue_id_origen    = pOrigen.pue_id
											 left join Puerto pDestino 			   on ManifiestoCarga.pue_id_destino   = pDestino.pue_id
											 left join DepositoLogico dOrigen   on ManifiestoCarga.depl_id_origen   = dOrigen.depl_id
											 left join DepositoLogico dDestino  on ManifiestoCarga.depl_id_destino  = dDestino.depl_id

		                   left join centrocosto     on ManifiestoCarga.ccos_id = centrocosto.ccos_id

  where mfc_id = @@mfc_id

end