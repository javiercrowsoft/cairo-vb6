if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteReparacionGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteReparacionGet]

go

/*

sp_DocParteReparacionGet 12,7

*/

create procedure sp_DocParteReparacionGet (
  @@emp_id   int,
  @@prp_id   int,
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
  select @cli_id = cli_id, @doc_id = doc_id from ParteReparacion where prp_id = @@prp_id

  exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_clienteGetIva @cli_id, @bIvari out, @bIvarni out, 0
  exec sp_DocParteReparacionEditableGet @@emp_id, @@prp_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

  select 
      ParteReparacion.*,
      cli_nombre,
      lp_nombre,
      ld_nombre,
      cpg_nombre,
      est_nombre,
      ccos_nombre,
      suc_nombre,
      doc_nombre,
      documento.mon_id,

      prns_codigo,
      cont_nombre,
      pr_nombrecompra + ' - OS:' + os_nrodoc as serie_descrip,

      depl_id_origen      as depl_id,
      dOrigen.depl_nombre  as depl_nombre,
      dOrigen.depf_id      as depf_id,


      us_nombre,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      clis_nombre,
  
      @bIvari             as bIvaRi,
      @bIvarni            as bIvaRni,
      @bEditable          as editable,
      @editMsg            as editMsg,
      @ta_Propuesto       as TaPropuesto,
      @ta_Mascara          as TaMascara
  
  from 
      ParteReparacion 
                   inner join documento      on ParteReparacion.doc_id   = documento.doc_id
                   inner join estado         on ParteReparacion.est_id   = estado.est_id
                   inner join sucursal       on ParteReparacion.suc_id   = sucursal.suc_id
                   inner join cliente        on ParteReparacion.cli_id   = cliente.cli_id

                   inner join productonumeroserie prns on   ParteReparacion.prns_id   = prns.prns_id

                   left join contacto cont   on ParteReparacion.cont_id  = cont.cont_id
                   left join condicionpago   on ParteReparacion.cpg_id   = condicionpago.cpg_id
                   left join centrocosto     on ParteReparacion.ccos_id  = centrocosto.ccos_id
                   left join listaprecio     on ParteReparacion.lp_id    = listaprecio.lp_id
                   left join listadescuento  on ParteReparacion.ld_id    = listadescuento.ld_id
                   left join stock           on ParteReparacion.st_id    = stock.st_id
                   left join depositologico dOrigen  on stock.depl_id_origen  = dOrigen.depl_id
                   left join depositologico dDestino on stock.depl_id_destino = dDestino.depl_id

                   left join usuario us2     on ParteReparacion.us_id   = us2.us_id
                   left join legajo          on ParteReparacion.lgj_id  = legajo.lgj_id
                   left join ClienteSucursal on ParteReparacion.clis_id = ClienteSucursal.clis_id

                   left join producto pr      on prns.pr_id = pr.pr_id
                   left join OrdenServicio os on partereparacion.os_id = os.os_id

  where prp_id = @@prp_id

end