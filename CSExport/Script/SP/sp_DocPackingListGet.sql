if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListGet]

go

/*

sp_DocPackingListGet 57,7

*/

create procedure sp_DocPackingListGet (
	@@emp_id   int,
	@@pklst_id int,
  @@us_id int
)
as

begin

declare @bEditable 		tinyint
declare @editMsg   		varchar(255)
declare @doc_id    		int
declare @ta_Mascara 	varchar(100)
declare @ta_Propuesto tinyint

declare @bIvari		tinyint
declare @bIvarni  tinyint
declare @cli_id   int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             TALONARIO Y ESTADO DE EDICION                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @cli_id = cli_id, @doc_id = doc_id from PackingList where pklst_id = @@pklst_id

	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
	exec sp_clienteGetIva @cli_id, @bIvari out, @bIvarni out, 0
  exec sp_DocPackingListEditableGet @@emp_id, @@pklst_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select 
			PackingList.*,
	    cli_nombre,
	    lp_nombre,
	    ld_nombre,
	    cpg_nombre,
	    est_nombre,
	    ccos_nombre,
      suc_nombre,
      doc_nombre,
			origen.pue_nombre   as [Puerto Origen],
			destino.pue_nombre  as [Puerto Destino],
			barc_nombre,
      @bIvari             as bIvaRi,
      @bIvarni            as bIvaRni,
      @bEditable					as editable,
      @editMsg						as editMsg,
      @ta_Propuesto 			as TaPropuesto,
			@ta_Mascara					as TaMascara
	
	from 
			PackingList  inner join documento      on PackingList.doc_id  = documento.doc_id
									 inner join estado         on PackingList.est_id  = estado.est_id
									 inner join sucursal       on PackingList.suc_id  = sucursal.suc_id
                   inner join cliente        on PackingList.cli_id  = cliente.cli_id

									 left join puerto origen  on PackingList.pue_id_origen  = origen.pue_id
									 left join puerto destino on PackingList.pue_id_destino = destino.pue_id

									 left join barco          on PackingList.barc_id = barco.barc_id

                   left join condicionpago   on PackingList.cpg_id  = condicionpago.cpg_id
                   left join centrocosto     on PackingList.ccos_id = centrocosto.ccos_id
                   left join listaprecio     on PackingList.lp_id   = listaprecio.lp_id
									 left join listadescuento  on PackingList.ld_id   = listadescuento.ld_id

  where pklst_id = @@pklst_id

end