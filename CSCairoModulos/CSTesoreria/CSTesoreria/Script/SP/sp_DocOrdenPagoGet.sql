if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoGet]

go

/*

sp_DocOrdenPagoGet 57,7

*/

create procedure sp_DocOrdenPagoGet (
  @@emp_id   int,
  @@opg_id   int,
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
  select @doc_id = doc_id from OrdenPago where opg_id = @@opg_id

  exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocOrdenPagoEditableGet @@emp_id, @@opg_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select 
      OrdenPago.*,
      prov_nombre,
      est_nombre,
      ccos_nombre,
      suc_nombre,
      doc_nombre,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      @bEditable            as editable,
      @editMsg              as editMsg,
      @ta_Mascara            as TaMascara,
      @ta_Propuesto         as TaPropuesto
  
  from 
      OrdenPago inner join Documento             on OrdenPago.doc_id  = Documento.doc_id
                   inner join Estado             on OrdenPago.est_id  = Estado.est_id
                   inner join Sucursal           on OrdenPago.suc_id  = Sucursal.suc_id
                   inner join Proveedor          on OrdenPago.prov_id = Proveedor.prov_id
                   left join CentroCosto         on OrdenPago.ccos_id = CentroCosto.ccos_id
                   left join Legajo              on OrdenPago.lgj_id  = Legajo.lgj_id

  where opg_id = @@opg_id

end