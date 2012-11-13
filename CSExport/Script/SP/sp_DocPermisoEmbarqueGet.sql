if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPermisoEmbarqueGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPermisoEmbarqueGet]

go

/*

sp_DocPermisoEmbarqueGet 57,7

*/

create procedure sp_DocPermisoEmbarqueGet (
	@@emp_id   int,
	@@pemb_id int,
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

  select @doc_id = doc_id from PermisoEmbarque where pemb_id = @@pemb_id

	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocPermisoEmbarqueEditableGet @@emp_id, @@pemb_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select 
			PermisoEmbarque.*,
	    lp_nombre,
	    est_nombre,
	    ccos_nombre,
      suc_nombre,
      doc_nombre,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      emb_nombre,
      adu_nombre,
      bco_nombre,
      @bEditable          	as editable,
      @editMsg            	as editMsg,
			@ta_Mascara						as TaMascara,
      @ta_Propuesto         as TaPropuesto
	
	from 
			PermisoEmbarque inner join Documento   		on PermisoEmbarque.doc_id  = Documento.doc_id
									 		inner join Estado         on PermisoEmbarque.est_id  = Estado.est_id
									 		inner join Sucursal       on PermisoEmbarque.suc_id  = Sucursal.suc_id
	                    inner join Embarque       on PermisoEmbarque.emb_id   = Embarque.emb_id
	                    inner join Aduana 			  on PermisoEmbarque.adu_id   = Aduana.adu_id
	                    inner join Banco          on PermisoEmbarque.bco_id   = Banco.bco_id
                   		left join CentroCosto     on PermisoEmbarque.ccos_id = CentroCosto.ccos_id
                   		left join ListaPrecio     on PermisoEmbarque.lp_id   = ListaPrecio.lp_id
											left join Legajo          on PermisoEmbarque.lgj_id  = Legajo.lgj_id

  where pemb_id = @@pemb_id

end