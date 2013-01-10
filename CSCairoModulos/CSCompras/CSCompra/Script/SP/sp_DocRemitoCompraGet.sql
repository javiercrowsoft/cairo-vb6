if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoCompraGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoCompraGet]

go

/*

*/

create procedure sp_DocRemitoCompraGet (
  @@emp_id   int,
  @@rc_id    int,
  @@us_id    int
)
as

begin

declare @bEditable     tinyint
declare @editMsg       varchar(255)
declare @doc_id        int
declare @ta_Mascara   varchar(100)
declare @ta_Propuesto tinyint

declare @bIvari    tinyint
declare @bIvarni  tinyint
declare @prov_id  int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             TALONARIO Y ESTADO DE EDICION                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select @prov_id = prov_id, @doc_id = doc_id from RemitoCompra where rc_id = @@rc_id

  exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_proveedorGetIva @prov_id, @bIvari out, @bIvarni out, 0
  exec sp_DocRemitoCompraEditableGet @@emp_id, @@rc_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select 
      RemitoCompra.*,
      prov_nombre,
      lp_nombre,
      ld_nombre,
      cpg_nombre,
      est_nombre,
      ccos_nombre,
      suc_nombre,
      doc_nombre,
      documento.mon_id,
      documento.doc_rc_despachoImpo,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      case RemitoCompra.doct_id 
        when 4  /*Remito de Compra*/             then depl_id_destino
        when 25 /*Devolucion Remito de Compra*/ then depl_id_origen
      end                  as depl_id,
      case RemitoCompra.doct_id 
        when 4  /*Remito de Compra*/             then dDestino.depl_nombre
        when 25 /*Devolucion Remito de Compra*/ then dOrigen.depl_nombre
      end                 as depl_nombre,
      @bIvari             as bIvaRi,
      @bIvarni            as bIvaRni,
      @bEditable          as editable,
      @editMsg            as editMsg,
      @ta_Propuesto       as TaPropuesto,
      @ta_Mascara          as TaMascara,
      dic.dic_numero,
      dic.dic_porcfobfinal,
      dic.dic_id
  
  from 

      RemitoCompra inner join documento      on RemitoCompra.doc_id   = documento.doc_id
                   inner join estado         on RemitoCompra.est_id   = estado.est_id
                   inner join sucursal       on RemitoCompra.suc_id   = sucursal.suc_id
                   inner join proveedor      on RemitoCompra.prov_id  = proveedor.prov_id
                   left join condicionpago   on RemitoCompra.cpg_id   = condicionpago.cpg_id
                   left join centrocosto     on RemitoCompra.ccos_id  = centrocosto.ccos_id
                   left join listaprecio     on RemitoCompra.lp_id    = listaprecio.lp_id
                   left join listadescuento  on RemitoCompra.ld_id    = listadescuento.ld_id
                   left join stock           on RemitoCompra.st_id    = stock.st_id
                   left join legajo          on RemitoCompra.lgj_id   = legajo.lgj_id
                   left join depositologico dOrigen  on stock.depl_id_origen  = dOrigen.depl_id
                   left join depositologico dDestino on stock.depl_id_destino = dDestino.depl_id
                   left join despachoimpcalculo dic  on RemitoCompra.rc_id = dic.rc_id

  where RemitoCompra.rc_id = @@rc_id

end
GO