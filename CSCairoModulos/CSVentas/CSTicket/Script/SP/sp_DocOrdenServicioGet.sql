if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenServicioGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenServicioGet]

go

/*

sp_DocOrdenServicioGet 1,25,1

*/

create procedure sp_DocOrdenServicioGet (
  @@emp_id   int,
  @@os_id    int,
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

  select @cli_id = cli_id, @doc_id = doc_id from OrdenServicio where os_id = @@os_id

  exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_ClienteGetIva @cli_id, @bIvari out, @bIvarni out, 0
  exec sp_DocOrdenServicioEditableGet @@emp_id, @@os_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select 
      os.*,
      cli_nombre,
      lp_nombre,
      ld_nombre,
      cpg_nombre,
      est_nombre,
      ccos_nombre,
      suc_nombre,
      doc_nombre,

      cont_nombre,
      clis_nombre,
      proy_nombre,
      prio_nombre,
      inct_nombre,
      inca_nombre,
      tar_numero, 
      zon_nombre,
      us_nombre,

      documento.mon_id,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      depl_id_destino  as depl_id,
      dDestino.depl_nombre as depl_nombre,

      @bIvari             as bIvaRi,
      @bIvarni            as bIvaRni,
      @bEditable          as editable,
      @editMsg            as editMsg,
      @ta_Propuesto       as TaPropuesto,
      @ta_Mascara          as TaMascara
  
  from 
      OrdenServicio os  inner join documento      on os.doc_id   = documento.doc_id
                        inner join estado         on os.est_id   = estado.est_id
                        inner join sucursal       on os.suc_id   = sucursal.suc_id
                        inner join Cliente        on os.cli_id   = Cliente.cli_id
                        left join condicionpago   on os.cpg_id   = condicionpago.cpg_id
                        left join centrocosto     on os.ccos_id  = centrocosto.ccos_id
                        left join listaprecio     on os.lp_id    = listaprecio.lp_id
                        left join listadescuento  on os.ld_id    = listadescuento.ld_id
                        left join stock           on os.st_id    = stock.st_id
                        left join legajo          on os.lgj_id   = legajo.lgj_id
                        left join depositologico dOrigen  on stock.depl_id_origen  = dOrigen.depl_id
                        left join depositologico dDestino on stock.depl_id_destino = dDestino.depl_id
    
                        left join contacto cont           on os.cont_id    = cont.cont_id
                        left join clientesucursal clis     on os.clis_id    = clis.clis_id
                        left join proyecto proy           on os.proy_id    = proy.proy_id
                        left join prioridad prio           on os.prio_id    = prio.prio_id
                        left join incidentetipo inct       on os.inct_id    = inct.inct_id
                        left join incidenteapertura inca   on os.inca_id    = inca.inca_id
                        left join tarea tar               on os.tar_id     = tar.tar_id
                        left join zona zon                on os.zon_id     = zon.zon_id

                        left join Usuario us              on os.us_id_tecnico = us.us_id

  where os.os_id = @@os_id

end
GO