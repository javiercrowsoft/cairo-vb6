if exists (select * from sysobjects where id = object_id(N'[dbo].[frMovimientoCaja]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frMovimientoCaja]

/*

frMovimientoCaja 57

*/
go
create procedure frMovimientoCaja (

  @@mcj_id      int

)as 

begin

  declare @mcj_id_apertura int
  declare @mcj_tipo         int
  declare @cj_id           int

  select @mcj_tipo = mcj_tipo, @cj_id = cj_id from MovimientoCaja where mcj_id = @@mcj_id

  if @mcj_tipo = 2 begin

    select @mcj_id_apertura = max(mcj_id) from MovimientoCaja where mcj_tipo = 1 and cj_id = @cj_id and mcj_id < @@mcj_id

  end else set @mcj_id_apertura = null


  declare @apertura datetime
  declare @cierre   datetime

  select @apertura = dateadd(second,datepart(second,mcj_hora),
                              dateadd(minute,datepart(minute,mcj_hora),
                                  dateadd(hour,datepart(hour,mcj_hora),
                                    mcj_fecha)))
  from MovimientoCaja where mcj_id = @mcj_id_apertura 

  select @cierre = dateadd(second,datepart(second,mcj_hora),
                              dateadd(minute,datepart(minute,mcj_hora),
                                  dateadd(hour,datepart(hour,mcj_hora),
                                    mcj_fecha)))
  from MovimientoCaja where mcj_id = @@mcj_id 

--//////////////////////////////////////////////////////////////////////////////////////////
--
-- Movimiento de las cuentas de una apertura o cierre de caja
--
--//////////////////////////////////////////////////////////////////////////////////////////
  
  select
        0                                          as orden_id,

        0                                          as as_id,
  
        mcj.mcj_id,
  
        1                                         as tipo,
        case when mcj_tipo = 1 then 'Apertura de Caja' 
             else                   'Cierre de Caja'
        end                                       as [Operación],
        cj_codigo + ' ' + cj_nombre               as Caja,
        us_nombre                                  as Cajero,
        mcj_fecha                                 as Fecha,
  
        ''                                         as [Centro Costo Item],
  
        null                                      as [Fecha comprobante],
         ''                                        as [Tipo comp.],

         mcj_nrodoc                                as [Nro. comp. Caja],
        mcj.mcj_numero                            as [Numero Caja],
        mcj.modificado                            as [Mov. Caja. Modificado],

         mcj_nrodoc                                as [Nro. comp.],
        mcj.mcj_numero                            as [Numero],
        mcj_descrip                               as Aclaraciones,

        bco_nombre                                as Banco,
        cue.cue_nombre                            as Cuenta,
         ''                                         as [Nro. cheque],
        null                                       as Vencimiento,
        null                                       as Cobro,
         mcji_descrip                               as Detalle,
        0                                          as Importe,
        mcji_importe                              as Fondos,

        null                                      as cobz_id, -- este lo uso para agrupar
        null                                      as fv_id, -- este lo uso para agrupar
        null                                      as [Fecha Factura],
        ''                                        as Factura,
        ''                                        as Cliente,
        0                                          as Aplicado,

        ''                                        as Tarjeta,
        ''                                        as Cupon,
        0                                          as [Importe Cupon],

        ''                                        as Articulo,
        0                                          as Cantidad,
        0                                          as Precio,
        0                                         as [Art. Importe],

        @apertura                                 as Apertura,
        @cierre                                   as Cierre

  
  from 
  
        MovimientoCaja mcj 
                    inner join Usuario c                      on mcj.us_id_cajero = c.us_id
                    inner join Caja cj                        on mcj.cj_id = cj.cj_id
                    inner join Empresa emp                    on cj.emp_id = emp.emp_id
                    left  join MovimientoCajaItem mcji         on mcj.mcj_id = mcji.mcj_id
                    left  join Cuenta cue                      on mcji.cue_id_trabajo = cue.cue_id
                    left  join Banco bco                      on cue.bco_id = bco.bco_id
  
  where
        mcj.mcj_id = @@mcj_id

--//////////////////////////////////////////////////////////////////////////////////////////////
--
-- Movimientos de la caja
--
--//////////////////////////////////////////////////////////////////////////////////////////////

  union all

  select 
        0                                          as orden_id,

        ast.as_id                                  as as_id,
  
        mcj.mcj_id,
  
        2                                         as tipo,
        case when mcj_tipo = 1 then 'Apertura de Caja' 
             else                   'Cierre de Caja'
        end                                       as [Operación],
        cj_codigo + ' ' + cj_nombre               as Caja,
        us_nombre                                  as Cajero,
        mcj_fecha                                 as Fecha,
  
        ccosi.ccos_nombre                         as [Centro Costo Item],
  
        as_fecha                                  as [Fecha comprobante],
         doct_nombre                                as [Tipo comp.],

         mcj_nrodoc                                as [Nro. comp. Caja],
        mcj.mcj_numero                            as [Numero Caja],
        mcj.modificado                            as [Mov. Caja. Modificado],

         case when as_doc_cliente <> '' then as_doc_cliente else as_nrodoc end
                                                  as [Nro. comp.],
        mcj.mcj_numero                            as [Numero],
        mcj_descrip                               as Aclaraciones,

        bco_nombre                                as Banco,
        cue.cue_nombre                            as Cuenta,
         cheq_numerodoc                             as [Nro. cheque],
        cheq_fechaVto                             as Vencimiento,
        cheq_fechaCobro                           as Cobro,
         mcjm_descrip                               as Detalle,
        mcjm_importe                              as Importe,
        0                                         as Fondos,

        fvcobz.cobz_id                            as cobz_id, -- este lo uso para agrupar
        fv.fv_id                                  as fv_id,
        fv_fecha                                  as [Fecha Factura],
        fv_nrodoc                                 as Factura,
        cli_nombre                                as Cliente,
        (asi_debe-asi_haber)                      as Aplicado,

        ''                                        as Tarjeta,
        ''                                        as Cupon,
        0                                          as [Importe Cupon],

        pr_nombreventa                            as Articulo,
        fvi_cantidad                              as Cantidad,
        fvi_precio                                as Precio,
        fvi_importe                               as [Art. Importe],

        @apertura                                 as Apertura,
        @cierre                                   as Cierre

  
  from 
  
        MovimientoCaja mcj 
                    inner join Usuario c                      on mcj.us_id_cajero = c.us_id
                    inner join Caja cj                        on mcj.cj_id = cj.cj_id
                    inner join Empresa emp                    on cj.emp_id = emp.emp_id
                    inner join MovimientocajaMovimiento mcjm  on mcj.mcj_id = mcjm.mcj_id

                    inner join Asiento ast                    on mcjm.as_id = ast.as_id

                    inner join CajaCuenta cjc                 on cj.cj_id = cjc.cj_id

                    inner join AsientoItem asi                on     ast.as_id = asi.as_id
                                                                and  cjc.cue_id_trabajo = asi.cue_id

                    left join  Cheque ch                    on asi.cheq_id   = ch.cheq_id
                    left join  Chequera chq                 on ch.chq_id     = chq.chq_id
                    left join  Cuenta cue                    on asi.cue_id    = cue.cue_id
  
                    left join  Cuenta chqc                  on chq.cue_id    = chqc.cue_id
                    left join  Banco b                      on (chqc.bco_id  = b.bco_id or ch.bco_id = b.bco_id)
  
                    left join CentroCosto ccosi             on asi.ccos_id   = ccosi.ccos_id

                    left join DocumentoTipo doct            on isnull(ast.doct_id_cliente,ast.doct_id) = doct.doct_id


                    left join FacturaVentaCobranza fvcobz   on ast.id_cliente = fvcobz.cobz_id and ast.doct_id_cliente = 13
                    left join FacturaVentaDeuda fvd         on fvcobz.fvd_id = fvd.fvd_id
                    left join FacturaVentaPago fvp          on fvcobz.fvp_id = fvp.fvp_id
                    left join FacturaVenta fv               on fvd.fv_id = fv.fv_id or fvp.fv_id = fv.fv_id
                    left join FacturaVentaItem fvi          on fv.fv_id = fvi.fv_id
                    left join Producto pr                   on fvi.pr_id = pr.pr_id
                    left join Cliente cli                   on fv.cli_id = cli.cli_id
  where
        mcj.mcj_id = @@mcj_id

  --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  union all

  select
        0                                          as orden_id,

        ast.as_id                                  as as_id,  
        mcj.mcj_id,
  
        2                                         as tipo,
        case when mcj_tipo = 1 then 'Apertura de Caja' 
             else                   'Cierre de Caja'
        end                                       as [Operación],
        cj_codigo + ' ' + cj_nombre               as Caja,
        us_nombre                                  as Cajero,
        mcj_fecha                                 as Fecha,
  
        ccosi.ccos_nombre                         as [Centro Costo Item],
  
        as_fecha                                  as [Fecha comprobante],
         doct_nombre                                as [Tipo comp.],

         mcj_nrodoc                                as [Nro. comp. Caja],
        mcj.mcj_numero                            as [Numero Caja],
        mcj.modificado                            as [Mov. Caja. Modificado],

         case when as_doc_cliente <> '' then as_doc_cliente else as_nrodoc end
                                                  as [Nro. comp.],
        mcj.mcj_numero                            as [Numero],
        mcj_descrip                               as Aclaraciones,

        bco_nombre                                as Banco,
        cue.cue_nombre                            as Cuenta,
         cheq_numerodoc                             as [Nro. cheque],
        cheq_fechaVto                             as Vencimiento,
        cheq_fechaCobro                           as Cobro,
         asi_descrip                                 as Detalle,
        asi_debe-asi_haber                         as Importe,
        0                                         as Fondos,

        null                                      as cobz_id, -- este lo uso para agrupar
        null                                      as fv_id, -- este lo uso para agrupar
        null                                      as [Fecha Factura],
        null                                       as Factura,
        null                                      as Cliente,
        null                                      as Aplicado,

        ''                                        as Tarjeta,
        ''                                        as Cupon,
        0                                          as [Importe Cupon],

        ''                                        as Articulo,
        0                                          as Cantidad,
        0                                          as Precio,
        0                                         as [Art. Importe],

        @apertura                                 as Apertura,
        @cierre                                   as Cierre
  
  from 
  
        MovimientoCaja mcj 
                    inner join Usuario c                      on mcj.us_id_cajero = c.us_id
                    inner join Caja cj                        on mcj.cj_id = cj.cj_id
                    inner join Empresa emp                    on cj.emp_id = emp.emp_id

                    inner join Asiento ast                    on mcj.as_id = ast.as_id

                    inner join CajaCuenta cjc                 on cj.cj_id = cjc.cj_id

                    inner join AsientoItem asi                on     ast.as_id = asi.as_id
                                                                and  cjc.cue_id_trabajo = asi.cue_id

                    left join  Cheque ch                    on asi.cheq_id   = ch.cheq_id
                    left join  Chequera chq                 on ch.chq_id     = chq.chq_id
                    left join  Cuenta cue                    on asi.cue_id    = cue.cue_id
  
                    left join  Cuenta chqc                  on chq.cue_id    = chqc.cue_id
                    left join  Banco b                      on (chqc.bco_id  = b.bco_id or ch.bco_id = b.bco_id)
  
                    left join CentroCosto ccosi             on asi.ccos_id   = ccosi.ccos_id

                    left join DocumentoTipo doct            on ast.doct_id    = doct.doct_id


  where
        mcj.mcj_id = @mcj_id_apertura

  --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  union all

  select
        0                                          as orden_id,

        ast.as_id                                  as as_id,  
        mcj.mcj_id,
  
        3                                         as tipo,
        case when mcj_tipo = 1 then 'Apertura de Caja' 
             else                   'Cierre de Caja'
        end                                       as [Operación],
        cj_codigo + ' ' + cj_nombre               as Caja,
        us_nombre                                  as Cajero,
        mcj_fecha                                 as Fecha,
  
        null                                      as [Centro Costo Item],
  
        as_fecha                                  as [Fecha comprobante],
         doct_nombre                                as [Tipo comp.],

         mcj_nrodoc                                as [Nro. comp. Caja],
        mcj.mcj_numero                            as [Numero Caja],
        mcj.modificado                            as [Mov. Caja. Modificado],

         case when as_doc_cliente <> '' then as_doc_cliente else as_nrodoc end
                                                  as [Nro. comp.],
        mcj.mcj_numero                            as [Numero],
        mcj_descrip                               as Aclaraciones,

        null                                      as Banco,
        null                                      as Cuenta,
         null                                      as [Nro. cheque],
        null                                      as Vencimiento,
        null                                      as Cobro,
         null                                       as Detalle,
        0                                         as Importe,
        0                                         as Fondos,

        null                                      as cobz_id, -- este lo uso para agrupar
        fv.fv_id                                  as fv_id, -- este lo uso para agrupar
        fv_fecha                                  as [Fecha Factura],
        fv_nrodoc                                 as Factura,
        cli_nombre                                as Cliente,
        fv_pendiente                               as Aplicado,

        ''                                        as Tarjeta,
        ''                                        as Cupon,
        0                                          as [Importe Cupon],

        pr_nombreventa                            as Articulo,
        fvi_cantidad                              as Cantidad,
        fvi_precio                                as Precio,
        fvi_importe                               as [Art. Importe],

        @apertura                                 as Apertura,
        @cierre                                   as Cierre
  
  from 
  
        MovimientoCaja mcj 
                    inner join Usuario c                      on mcj.us_id_cajero = c.us_id
                    inner join Caja cj                        on mcj.cj_id = cj.cj_id
                    inner join Empresa emp                    on cj.emp_id = emp.emp_id

                    inner join Asiento ast                    on mcj.as_id = ast.as_id

                    inner join FacturaVenta fv                on mcj.mcj_id = fv.mcj_id
                    inner join Cliente cli                    on fv.cli_id  = cli.cli_id
                    inner join DocumentoTipo doct             on fv.doct_id = doct.doct_id

                    inner join FacturaVentaItem fvi           on fv.fv_id = fvi.fv_id
                    inner join Producto pr                    on fvi.pr_id = pr.pr_id
            
  where
        mcj.mcj_id = @mcj_id_apertura

    and (not exists(select * from FacturaVentaCobranza where fv_id = fv.fv_id)
         or fv_pendiente <> 0)


  --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  union all

  select 
        0                                          as orden_id,

        ast.as_id                                  as as_id,
  
        mcj.mcj_id,
  
        4                                         as tipo,
        case when mcj_tipo = 1 then 'Apertura de Caja' 
             else                   'Cierre de Caja'
        end                                       as [Operación],
        cj_codigo + ' ' + cj_nombre               as Caja,
        us_nombre                                  as Cajero,
        mcj_fecha                                 as Fecha,
  
        ccosi.ccos_nombre                         as [Centro Costo Item],
  
        as_fecha                                  as [Fecha comprobante],
         doct_nombre                                as [Tipo comp.],

         mcj_nrodoc                                as [Nro. comp. Caja],
        mcj.mcj_numero                            as [Numero Caja],
        mcj.modificado                            as [Mov. Caja. Modificado],

         case when as_doc_cliente <> '' then as_doc_cliente else as_nrodoc end
                                                  as [Nro. comp.],
        mcj.mcj_numero                            as [Numero],
        mcj_descrip                               as Aclaraciones,

        bco_nombre                                as Banco,
        cue.cue_nombre                            as Cuenta,
         cheq_numerodoc                             as [Nro. cheque],
        cheq_fechaVto                             as Vencimiento,
        cheq_fechaCobro                           as Cobro,
         mcjm_descrip                               as Detalle,
        mcjm_importe                              as Importe,
        0                                         as Fondos,

        tjc.tjc_id                                 as cobz_id, -- este lo uso para agrupar
        null                                      as fv_id, -- este lo uso para agrupar
        fv_fecha                                  as [Fecha Factura],
        fv_nrodoc                                 as Factura,
        cli_nombre                                as Cliente,
        (asi_debe-asi_haber)                      as Aplicado,

        tjc_nombre                                as Tarjeta,
        tjcc_numerodoc                            as Cupon,
        tjcc_importe                              as [Importe Cupon],

        ''                                        as Articulo,
        0                                          as Cantidad,
        0                                          as Precio,
        0                                         as [Art. Importe],

        @apertura                                 as Apertura,
        @cierre                                   as Cierre
  
  from 
  
        MovimientoCaja mcj 
                    inner join Usuario c                      on mcj.us_id_cajero = c.us_id
                    inner join Caja cj                        on mcj.cj_id = cj.cj_id
                    inner join Empresa emp                    on cj.emp_id = emp.emp_id
                    inner join MovimientocajaMovimiento mcjm  on mcj.mcj_id = mcjm.mcj_id

                    inner join Asiento ast                    on mcjm.as_id = ast.as_id

                    inner join CajaCuenta cjc                 on cj.cj_id = cjc.cj_id

                    inner join AsientoItem asi                on     ast.as_id = asi.as_id
                                                                and  cjc.cue_id_trabajo = asi.cue_id

                    left join  Cheque ch                    on asi.cheq_id   = ch.cheq_id
                    left join  Chequera chq                 on ch.chq_id     = chq.chq_id
                    left join  Cuenta cue                    on asi.cue_id    = cue.cue_id
  
                    left join  Cuenta chqc                  on chq.cue_id    = chqc.cue_id
                    left join  Banco b                      on (chqc.bco_id  = b.bco_id or ch.bco_id = b.bco_id)
  
                    left join CentroCosto ccosi             on asi.ccos_id   = ccosi.ccos_id

                    left join DocumentoTipo doct            on isnull(ast.doct_id_cliente,ast.doct_id) = doct.doct_id


                    left join FacturaVentaCobranza fvcobz   on ast.id_cliente = fvcobz.cobz_id and ast.doct_id_cliente = 13
                    left join FacturaVentaDeuda fvd         on fvcobz.fvd_id = fvd.fvd_id
                    left join FacturaVentaPago fvp          on fvcobz.fvp_id = fvp.fvp_id
                    left join FacturaVenta fv               on fvd.fv_id = fv.fv_id or fvp.fv_id = fv.fv_id
                    left join Cliente cli                   on fv.cli_id = cli.cli_id

                    left join CobranzaItem cobzi            on fvcobz.cobz_id = cobzi.cobz_id
                    left join TarjetaCreditoCupon tjcc      on cobzi.tjcc_id = tjcc.tjcc_id
                    left join TarjetaCredito tjc            on tjcc.tjc_id = tjc.tjc_id
  where
        mcj.mcj_id = @@mcj_id
    and cobzi.tjcc_id is not null

--/////////////////////////////////////////////////////////////////////////////////////////

  order by tipo, as_id


end
  


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

