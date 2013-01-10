if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientoGet]

go

/*

exec sp_DocAsientoEditableGet 57, 7, 0, '',1
sp_DocAsientoGet 57,7,1
select max(as_numero) from Asiento
select as_id from Asiento where as_numero = 57
*/

create procedure sp_DocAsientoGet (
  @@emp_id   int,
  @@as_id    int,
  @@us_id    int
)
as

begin

declare @bEditable     tinyint
declare @editMsg       varchar(255)
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
  select @doc_id = doc_id from Asiento where as_id = @@as_id

  exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocAsientoEditableGet @@emp_id, @@as_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select 
      ast.*,
      doct_nombre + ' ' + as_doc_cliente as doc_cliente,
      doc_nombre,
      @bEditable            as editable,
      @editMsg              as editMsg,
      @ta_Mascara            as TaMascara,
      @ta_Propuesto         as TaPropuesto
  
  from 

      Asiento ast inner join documento doc         on ast.doc_id           = doc.doc_id
                  left  join documentotipo doct   on ast.doct_id_cliente = doct.doct_id

  where as_id = @@as_id

end