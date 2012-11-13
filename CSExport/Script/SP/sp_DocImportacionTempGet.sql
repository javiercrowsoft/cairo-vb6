if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocImportacionTempGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocImportacionTempGet]

go

/*

ImportacionTemp                   reemplazar por el nombre del documento Ej. PedidoVenta
@@impt_id                     reemplazar por el id del documento ej @@pv_id  (incluir 2 arrobas)
ImportacionTemp                 reemplazar por el nombre de la tabla ej PedidoVenta
impt_id                     reemplazar por el campo ID ej. pv_id

exec sp_DocImportacionTempEditableGet 57, 7, 0, '',1
sp_DocImportacionTempGet 57,7
select max(pv_numero) from ImportacionTemp
select pv_id from ImportacionTemp where XX_numero = 57
*/

create procedure sp_DocImportacionTempGet (
	@@emp_id   int,
	@@impt_id  int,
  @@us_id    int
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
declare @prov_id  int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             TALONARIO Y ESTADO DE EDICION                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @prov_id = prov_id, @doc_id = doc_id from ImportacionTemp where impt_id = @@impt_id

	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
	exec sp_proveedorGetIva @prov_id, @bIvari out, @bIvarni out, 0
  exec sp_DocImportacionTempEditableGet @@emp_id, @@impt_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select 
			ImportacionTemp.*,
	    prov_nombre,
	    lp_nombre,
	    ld_nombre,
	    cpg_nombre,
	    est_nombre,
	    ccos_nombre,
      suc_nombre,
      doc_nombre,
			depl_id_destino 			as depl_id,
			depl_nombre						as depl_nombre,
      @bIvari             	as bIvaRi,
      @bIvarni            	as bIvaRni,
      @bEditable          	as editable,
      @editMsg            	as editMsg,
			@ta_Mascara						as TaMascara,
      @ta_Propuesto         as TaPropuesto	

	from 
			ImportacionTemp  inner join documento      on ImportacionTemp.doc_id   = documento.doc_id
											 inner join estado         on ImportacionTemp.est_id   = estado.est_id
											 inner join sucursal       on ImportacionTemp.suc_id   = sucursal.suc_id
		                   inner join proveedor      on ImportacionTemp.prov_id  = proveedor.prov_id
		                   left join condicionpago   on ImportacionTemp.cpg_id   = condicionpago.cpg_id
		                   left join centrocosto     on ImportacionTemp.ccos_id  = centrocosto.ccos_id
		                   left join listaprecio     on ImportacionTemp.lp_id    = listaprecio.lp_id
											 left join listadescuento  on ImportacionTemp.ld_id    = listadescuento.ld_id
		                   left join stock           on ImportacionTemp.st_id    = stock.st_id
		                   left join depositologico  on stock.depl_id_destino 	 = depl_id


  where impt_id = @@impt_id

end