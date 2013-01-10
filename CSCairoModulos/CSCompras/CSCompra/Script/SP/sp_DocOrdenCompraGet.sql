if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraGet]

go

/*

*/

create procedure sp_DocOrdenCompraGet (
  @@emp_id   int,
  @@oc_id    int,
  @@us_id    int
)
as

begin

declare @bEditable     tinyint
declare @editMsg       varchar(255)
declare @doc_id        int
declare @ta_Mascara   varchar(100)
declare @ta_Propuesto tinyint

declare @bIvari        tinyint
declare @bIvarni      tinyint
declare @prov_id       int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             TALONARIO Y ESTADO DE EDICION                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @prov_id = prov_id, @doc_id = doc_id from OrdenCompra where oc_id = @@oc_id

  exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_proveedorGetIva @prov_id, @bIvari out, @bIvarni out, 0
  exec sp_DocOrdenCompraEditableGet @@emp_id, @@oc_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select 
      OrdenCompra.*,
      prov_nombre,
      cli_nombre,
      lp_nombre,
      ld_nombre,
      cpg_nombre,
      est_nombre,
      ccos_nombre,
      suc_nombre,
      doc_nombre,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      @bIvari             as bIvaRi,
      @bIvarni            as bIvaRni,
      @bEditable          as editable,
      @editMsg            as editMsg,
      @ta_Propuesto       as TaPropuesto,
      @ta_Mascara          as TaMascara
  
  from 
      OrdenCompra  inner join documento       on OrdenCompra.doc_id  = documento.doc_id
                   inner join condicionpago  on OrdenCompra.cpg_id  = condicionpago.cpg_id
                   inner join estado         on OrdenCompra.est_id  = estado.est_id
                   inner join sucursal       on OrdenCompra.suc_id  = sucursal.suc_id
                   inner join proveedor      on OrdenCompra.prov_id = proveedor.prov_id
                   left join cliente cli     on OrdenCompra.cli_id  = cli.cli_id
                   left join centrocosto     on OrdenCompra.ccos_id = centrocosto.ccos_id
                   left join listaprecio     on OrdenCompra.lp_id   = listaprecio.lp_id
                   left join listadescuento  on OrdenCompra.ld_id   = listadescuento.ld_id
                   left join legajo          on OrdenCompra.lgj_id  = legajo.lgj_id

  where oc_id = @@oc_id

end