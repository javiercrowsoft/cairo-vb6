if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRecuentoStockGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRecuentoStockGet]

go

/*

exec sp_DocRecuentoStockEditableGet 57, 7, 0, '',1
sp_DocRecuentoStockGet 57,7

select max(rs_numero) from RecuentoStock

*/

create procedure sp_DocRecuentoStockGet (
  @@emp_id   int,
  @@rs_id    int,
  @@us_id    int
)
as

begin

declare @bEditable tinyint
declare @editMsg   varchar(255)
declare @doc_id        int
declare @ta_Mascara   varchar(100)
declare @ta_Propuesto tinyint

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             TALONARIO Y ESTADO DE EDICION                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @doc_id = doc_id from RecuentoStock where rs_id = @@rs_id

  exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocRecuentoStockEditableGet @@emp_id, @@rs_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select 
      RecuentoStock.*,
      suc_nombre,
      doc_nombre,
      depl_nombre,
      @bEditable          as editable,
      @editMsg            as editMsg,
      @ta_Propuesto       as TaPropuesto,
      @ta_Mascara          as TaMascara
  
  from 
      RecuentoStock inner join documento      on RecuentoStock.doc_id  = documento.doc_id
                    inner join sucursal       on RecuentoStock.suc_id  = sucursal.suc_id
                    inner join depositologico on RecuentoStock.depl_id = depositologico.depl_id

  where rs_id = @@rs_id

end