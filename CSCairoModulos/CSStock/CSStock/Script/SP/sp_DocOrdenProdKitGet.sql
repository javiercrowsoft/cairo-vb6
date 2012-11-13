if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenProdKitGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenProdKitGet]

go

/*

exec sp_DocOrdenProdKitEditableGet 57, 7, 0, '',1
sp_DocOrdenProdKitGet 57,7

select max(opk_numero) from OrdenProdKit

*/

create procedure sp_DocOrdenProdKitGet (
	@@emp_id   int,
	@@opk_id   int,
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
  select @doc_id = doc_id from OrdenProdKit where opk_id = @@opk_id

	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocOrdenProdKitEditableGet @@emp_id, @@opk_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select 
			OrdenProdKit.*,
      suc_nombre,
      doc_nombre,
      depl_nombre,
      @bEditable				  as editable,
      @editMsg            as editMsg,
      @ta_Propuesto 			as TaPropuesto,
			@ta_Mascara					as TaMascara
	
	from 
			OrdenProdKit inner join documento      on OrdenProdKit.doc_id  = documento.doc_id
									 inner join sucursal       on OrdenProdKit.suc_id  = sucursal.suc_id
                   inner join depositologico on OrdenProdKit.depl_id = depositologico.depl_id

  where opk_id = @@opk_id

end