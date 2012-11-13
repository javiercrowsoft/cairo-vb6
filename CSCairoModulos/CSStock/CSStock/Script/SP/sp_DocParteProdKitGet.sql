if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteProdKitGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteProdKitGet]

go

/*

exec sp_DocParteProdKitEditableGet 57, 7, 0, '',1
sp_DocParteProdKitGet 57,7

select max(ppk_numero) from ParteProdKit

*/

create procedure sp_DocParteProdKitGet (
	@@emp_id   int,
	@@ppk_id   int,
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
  select @doc_id = doc_id from ParteProdKit where ppk_id = @@ppk_id

	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocParteProdKitEditableGet @@emp_id, @@ppk_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select 
			ParteProdKit.*,
      suc_nombre,
      doc_nombre,
      depl_nombre,
      @bEditable				  as editable,
      @editMsg            as editMsg,
      @ta_Propuesto 			as TaPropuesto,
			@ta_Mascara					as TaMascara
	
	from 
			ParteProdKit inner join documento      on ParteProdKit.doc_id  = documento.doc_id
									  inner join sucursal       on ParteProdKit.suc_id  = sucursal.suc_id
                    inner join depositologico on ParteProdKit.depl_id = depositologico.depl_id

  where ppk_id = @@ppk_id

end