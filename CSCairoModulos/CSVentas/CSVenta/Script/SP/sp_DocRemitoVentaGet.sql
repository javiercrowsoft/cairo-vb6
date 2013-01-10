if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocRemitoVentaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocRemitoVentaGet]

go

/*

sp_DocRemitoVentaGet 12,7

*/

create procedure sp_DocRemitoVentaGet (
  @@emp_id   int,
  @@rv_id    int,
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
declare @cli_id   int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             TALONARIO Y ESTADO DE EDICION                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @cli_id = cli_id, @doc_id = doc_id from RemitoVenta where rv_id = @@rv_id

  exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_clienteGetIva @cli_id, @bIvari out, @bIvarni out, 0
  exec sp_DocRemitoVentaEditableGet @@emp_id, @@rv_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select 
      RemitoVenta.*,
      cli_nombre,
      lp_nombre,
      ld_nombre,
      cpg_nombre,
      est_nombre,
      ccos_nombre,
      suc_nombre,
      doc_nombre,
      documento.mon_id,

      case RemitoVenta.doct_id 
        when 3  /*Remito de Venta*/             then depl_id_origen
        when 24 /*Devolucion Remito de Venta*/   then depl_id_destino
      end                  as depl_id,

      case RemitoVenta.doct_id 
        when 3  /*Remito de Venta*/             then dOrigen.depl_nombre
        when 24 /*Devolucion Remito de Venta*/   then dDestino.depl_nombre
      end                 as depl_nombre,

      case RemitoVenta.doct_id 
        when 3  /*Remito de Venta*/             then dOrigen.depf_id
        when 24 /*Devolucion Remito de Venta*/   then dDestino.depf_id
      end                 as depf_id,


      ven_nombre,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      pOrigen.pro_nombre  as ProOrigen,
      pDestino.pro_nombre as ProDestino,
      trans_nombre,
      clis_nombre,
      chof_nombre,
      cam.cam_patente,
      case semi.cam_essemi
        when 0 then semi.cam_patentesemi
        else        semi.cam_patente
      end                  as cam_patentesemi,
  
      @bIvari             as bIvaRi,
      @bIvarni            as bIvaRni,
      @bEditable          as editable,
      @editMsg            as editMsg,
      @ta_Propuesto       as TaPropuesto,
      @ta_Mascara          as TaMascara
  
  from 
      RemitoVenta inner join documento       on RemitoVenta.doc_id   = documento.doc_id
                   inner join estado         on RemitoVenta.est_id   = estado.est_id
                   inner join sucursal       on RemitoVenta.suc_id   = sucursal.suc_id
                   inner join cliente        on RemitoVenta.cli_id   = cliente.cli_id
                   left join condicionpago   on RemitoVenta.cpg_id   = condicionpago.cpg_id
                   left join centrocosto     on RemitoVenta.ccos_id  = centrocosto.ccos_id
                   left join listaprecio     on RemitoVenta.lp_id    = listaprecio.lp_id
                   left join listadescuento  on RemitoVenta.ld_id    = listadescuento.ld_id
                   left join stock           on RemitoVenta.st_id    = stock.st_id
                   left join depositologico dOrigen  on stock.depl_id_origen  = dOrigen.depl_id
                   left join depositologico dDestino on stock.depl_id_destino = dDestino.depl_id

                   left join vendedor        on RemitoVenta.ven_id  = vendedor.ven_id
                   left join legajo          on RemitoVenta.lgj_id  = legajo.lgj_id

                   left join Provincia as pOrigen  on  RemitoVenta.pro_id_origen  = pOrigen.pro_id
                   left join Provincia as pDestino on  RemitoVenta.pro_id_destino = pDestino.pro_id

                   left join Transporte      on RemitoVenta.trans_id     = Transporte.trans_id
                   left join Chofer chof     on RemitoVenta.chof_id      = chof.chof_id
                   left join Camion cam      on RemitoVenta.cam_id       = cam.cam_id
                   left join Camion semi     on RemitoVenta.cam_id_semi = semi.cam_id

                   left join ClienteSucursal on RemitoVenta.clis_id = ClienteSucursal.clis_id

  where rv_id = @@rv_id

end