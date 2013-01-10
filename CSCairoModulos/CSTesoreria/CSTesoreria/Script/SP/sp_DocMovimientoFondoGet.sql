if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoGet]

go

/*

sp_DocMovimientoFondoGet 13,7

*/

create procedure sp_DocMovimientoFondoGet (
  @@emp_id   int,
  @@mf_id    int,
  @@us_id    int
)
as

begin

declare @bEditable     tinyint
declare @editMsg       varchar(255)
declare @doc_id        int
declare @ta_id        int
declare @ta_Mascara   varchar(100)
declare @ta_Propuesto tinyint

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             TALONARIO Y ESTADO DE EDICION                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @doc_id = doc_id from MovimientoFondo where mf_id = @@mf_id
  exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocMovimientoFondoEditableGet @@emp_id, @@mf_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select 
      MovimientoFondo.*,
      cli_nombre,
      est_nombre,
      ccos_nombre,
      suc_nombre,
      doc_nombre,
      us_nombre,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      @bEditable          as editable,
      @editMsg            as editMsg,
      @ta_Propuesto       as TaPropuesto,
      @ta_Mascara          as TaMascara
  
  from 
      MovimientoFondo  inner join documento      on MovimientoFondo.doc_id  = documento.doc_id
                       inner join estado         on MovimientoFondo.est_id  = estado.est_id
                       inner join sucursal       on MovimientoFondo.suc_id  = sucursal.suc_id
                       left  join Cliente        on MovimientoFondo.cli_id  = Cliente.cli_id
                       left join centrocosto     on MovimientoFondo.ccos_id = centrocosto.ccos_id
                       left join usuario         on MovimientoFondo.us_id   = usuario.us_id
                       left join legajo          on MovimientoFondo.lgj_id  = legajo.lgj_id

  where mf_id = @@mf_id

end