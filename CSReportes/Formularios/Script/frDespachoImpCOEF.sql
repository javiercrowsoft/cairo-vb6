/*

select * from despachoimpcalculo

frDespachoImpCOEF 4

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frDespachoImpCOEF]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frDespachoImpCOEF]

go
create procedure frDespachoImpCOEF (

  @@dic_id      int

)as 

begin

  declare @mon_signo_def varchar(255)

  select @mon_signo_def = mon_signo from Moneda where mon_legal <> 0

  declare @codigo_ex_work     int   set @codigo_ex_work     = 1
  declare @codigo_seguro      int   set @codigo_seguro      = 2
  declare @codigo_embalaje    int   set @codigo_embalaje     = 3
  declare @codigo_totalfob    int   set @codigo_totalfob     = -3
  declare @codigo_flete       int   set @codigo_flete       = 4
  declare @codigo_totalcif    int   set @codigo_totalcif     = -5
  declare @codigo_derechos    int   set @codigo_derechos     = 6
  declare @codigo_estadist    int   set @codigo_estadist     = 7
  declare @codigo_totalcifde  int   set @codigo_totalcifde   = -8
  declare @codigo_iva21       int   set @codigo_iva21       = 9
  declare @codigo_iva3431_91  int   set @codigo_iva3431_91   = 10
  declare @codigo_gan3543_92  int   set @codigo_gan3543_92  = 11
  declare @codigo_igb         int   set @codigo_igb          = 12

  declare @codigo_gastosloc   int   set @codigo_gastosloc    = -13
  declare @codigo_sim         int   set @codigo_sim          = 14
  declare @codigo_honodesp    int   set @codigo_honodesp    = 15
  declare @codigo_gtogsan     int   set @codigo_gtogsan      = 16
  declare @codigo_almacen     int   set @codigo_almacen      = 17
  declare @codigo_ley25413    int   set @codigo_ley25413    = 18
  declare @codigo_acarreo     int   set @codigo_acarreo      = 19
  declare @codigo_gastos      int   set @codigo_gastos      = 20
  declare @codigo_ivagastos   int   set @codigo_ivagastos    = 21

  declare @codigo_banco       int   set @codigo_banco       = 22
  declare @codigo_sumaapagar  int   set @codigo_sumaapagar  = -23
  declare @codigo_recuperoiva int   set @codigo_recuperoiva  = -24

  declare @codigo_digital_doc int   set @codigo_digital_doc = 25
  declare @codigo_gastosenvio int   set @codigo_gastosenvio = 26
  declare @codigo_gtopba      int   set @codigo_gtopba      = 27

--///////////////////////////////////////////////////////////////////////////////////////////////////
--
--
--    DATOS DE CABECERA
--
--
--///////////////////////////////////////////////////////////////////////////////////////////////////

  select 

        1              as orden_id,

        dic.dic_id,
        dic.dic_numero,
        dic.dic_fecha,
        dic.dic_tipo,
        dic.dic_titulo,
        dic.dic_descrip,
        dic.dic_via,
        dic.dic_viaempresa,
        dic.dic_factura,
        dic.dic_cambio1,
        dic.dic_cambio2,
        dic.dic_pase,
        dic.dic_totalgtos,
        dic.dic_porcfob/100 as dic_porcfob,
        dic.dic_var/100 as dic_var,
        dic.dic_porcfobfinal/100 as dic_porcfobfinal,
        dic.dic_total,
        dic.dic_totalorigen,
        dic.mon_id1,
        dic.mon_id2,
        dic.creado,
        dic.modificado,
        dic.modifico,
        dic.rc_id,

        case dic_tipo
          when 1 then 'Provisorio'
          when 2 then 'Definitivo'
        end                   as Tipo,
        prov_nombre,
        rc_nrodoc,
        mon1.mon_nombre        as moneda1,
        mon2.mon_nombre        as moneda2,
        mon1.mon_signo        as signo1,
        mon2.mon_signo        as signo2,
        @mon_signo_def        as signo_def,

        (    select 
                  dici_importe      
          
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_ex_work
          
          ) as codigo_ex_work,
        
        (    select 
                  dici_importe      
          
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_seguro
        
          ) as codigo_seguro,
        
        (    select 
                  dici_importe      
          
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_embalaje
        
          ) as codigo_embalaje,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_totalfob
          ) as codigo_totalfob,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_flete
          ) as codigo_flete,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_totalcif
          ) as codigo_totalcif,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_derechos
          ) as codigo_derechos,
        
        (    select 
                  dici_porc
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_derechos
          ) as codigo_derechos_p,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_estadist
          ) as codigo_estadist,
        
        (    select 
                  dici_porc
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_estadist
          ) as codigo_estadist_p,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_totalcifde
          ) as codigo_totalcifde,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_iva21
          ) as codigo_iva21,
        
        (    select 
                  dici_porc
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_iva21
          ) as codigo_iva21_p,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_iva3431_91
          ) as codigo_iva3431_91,
        
        (    select 
                  dici_porc
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_iva3431_91
          ) as codigo_iva3431_91_p,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_gan3543_92
          ) as codigo_gan3543_92,
        
        (    select 
                  dici_porc
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_gan3543_92
          ) as codigo_gan3543_92_p,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_igb
          ) as codigo_igb,
        
        (    select 
                  dici_porc
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_igb
          ) as codigo_igb_p,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_gastosloc
          ) as codigo_gastosloc,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_sim
          ) as codigo_sim,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_sim
          ) as codigo_sim_v,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_honodesp
          ) as codigo_honodesp,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_honodesp
          ) as codigo_honodesp_v,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_gtogsan
          ) as codigo_gtogsan,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_gtogsan
          ) as codigo_gtogsan_v,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_almacen
          ) as codigo_almacen,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_almacen
          ) as codigo_almacen_v,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_ley25413
          ) as codigo_ley25413,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_ley25413
          ) as codigo_ley25413_v,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_acarreo
          ) as codigo_acarreo,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_acarreo
          ) as codigo_acarreo_v,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_gastos
          ) as codigo_gastos,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_gastos
          ) as codigo_gastos_v,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_ivagastos
          ) as codigo_ivagastos,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_ivagastos
          ) as codigo_ivagastos_v,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_banco
        
          ) as codigo_banco,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_banco
        
          ) as codigo_banco_v,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_sumaapagar
        
          ) as codigo_sumaapagar,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_sumaapagar
        
          ) as codigo_sumaapagar_v,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_recuperoiva
        
          ) as codigo_recuperoiva,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_recuperoiva
        
          ) as codigo_recuperoiva_v,
        
        ---------------------------------------------------------------------------
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_digital_doc
        
          ) as codigo_digital_doc,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_digital_doc
        
          ) as codigo_digital_doc_v,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_gastosenvio
        
          ) as codigo_gastosenvio,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_gastosenvio
        
          ) as codigo_gastosenvio_v,
        
        (    select 
                  dici_importe
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_gtopba
        
          ) as codigo_gtopba,
        
        (    select 
                  dici_valor
                    
            from DespachoImpCalculoItem 
            where dic_id = @@dic_id and dici_codigo = @codigo_gtopba
        
          ) as codigo_gtopba_v,
        
        ---------------------------------------------------------------------------
        
        null as dicp_id,
        null as dicp_derechos,
        null as dicp_estadisticas,
        null as dicp_iva,
        null as dicp_iva3431,
        null as dicp_ganancias,
        null as dicp_igb,
        null as dicp_gastoenvio,
        null as poar_id,
        
        null as poar_nombre,

        ---------------------------------------------------------------------------

        null as pr_nombrecompra,
        null as rci_precio,
        null as rci_costo,
        null as rci_cantidadaremitir,
        null as rci_neto,
        null as rci_costo_neto

  from 
        DespachoImpCalculo dic inner join RemitoCompra rc on dic.rc_id      = rc.rc_id
                               inner join Proveedor prov  on rc.prov_id      = prov.prov_id
                                inner join Usuario us      on dic.modifico   = us.us_id
                               inner join Moneda mon1     on dic.mon_id1    = mon1.mon_id
                               left  join Moneda mon2     on dic.mon_id2    = mon2.mon_id


  where 
            
            dic.dic_id = @@dic_id

--///////////////////////////////////////////////////////////////////////////////////////////////////
--
--
--    POSICIONES ARANCELARIAS
--
--
--///////////////////////////////////////////////////////////////////////////////////////////////////

union all

  select 

        2              as orden_id,

        dic.dic_id,
        dic.dic_numero,
        dic.dic_fecha,
        dic.dic_tipo,
        dic.dic_titulo,
        dic.dic_descrip,
        dic.dic_via,
        dic.dic_viaempresa,
        dic.dic_factura,
        dic.dic_cambio1,
        dic.dic_cambio2,
        dic.dic_pase,
        dic.dic_totalgtos,
        dic.dic_porcfob/100 as dic_porcfob,
        dic.dic_var/100 as dic_var,
        dic.dic_porcfobfinal/100 as dic_porcfobfinal,
        dic.dic_total,
        dic.dic_totalorigen,
        dic.mon_id1,
        dic.mon_id2,
        dic.creado,
        dic.modificado,
        dic.modifico,
        dic.rc_id,

        case dic_tipo
          when 1 then 'Provisorio'
          when 2 then 'Definitivo'
        end                   as Tipo,
        prov_nombre,
        rc_nrodoc,
        mon1.mon_nombre        as moneda1,
        mon2.mon_nombre        as moneda2,
        mon1.mon_signo        as signo1,
        mon2.mon_signo        as signo2,
        @mon_signo_def        as signo_def,

        null as codigo_ex_work,
        
        null as codigo_embalaje,
        null as codigo_seguro,
        null as codigo_totalfob,
        null as codigo_flete,
        
        null as codigo_totalcif,
        null as codigo_derechos,
        null as codigo_derechos_p,
        null as codigo_estadist,
        null as codigo_estadist_p,
        null as codigo_totalcifde,
        null as codigo_iva21,
        null as codigo_iva21_p,
        null as codigo_iva3431_91,
        null as codigo_iva3431_91_p,
        null as codigo_gan3543_92,
        null as codigo_gan3543_92_p,
        null as codigo_igb,
        null as codigo_igb_p,
        null as codigo_gastosloc,
        null as codigo_sim,
        null as codigo_sim_v,
        null as codigo_honodesp,
        null as codigo_honodesp_v,
        null as codigo_gtogsan,
        null as codigo_gtogsan_v,
        null as codigo_almacen,
        null as codigo_almacen_v,
        null as codigo_ley25413,
        null as codigo_ley25413_v,
        null as codigo_acarreo,
        null as codigo_acarreo_v,
        null as codigo_gastos,
        null as codigo_gastos_v,
        null as codigo_ivagastos,
        null as codigo_ivagastos_v,
        null as codigo_banco,
        null as codigo_banco_v,
        null as codigo_sumaapagar,
        null as codigo_sumaapagar_v,
        null as codigo_recuperoiva,
        null as codigo_recuperoiva_v,
        
        ---------------------------------------------------------------------------
        null as codigo_digital_doc,
        null as codigo_digital_doc_v,
        null as codigo_gastosenvio,
        null as codigo_gastosenvio_v,
        null as codigo_gtopba,
        null as codigo_gtopba_v,
        
        ---------------------------------------------------------------------------
        
        dicp.dicp_id,
        dicp.dicp_derechos,
        dicp.dicp_estadisticas,
        dicp.dicp_iva,
        dicp.dicp_iva3431,
        dicp.dicp_ganancias,
        dicp.dicp_igb,
        dicp.dicp_gastoenvio,
        dicp.poar_id,
        
        poar_nombre + ' ' + poar_codigo as poar_nombre,

        ---------------------------------------------------------------------------

        null as pr_nombrecompra,
        null as rci_precio,
        null as rci_costo,
        null as rci_cantidadaremitir,
        null as rci_neto,
        null as rci_costo_neto

  from 
        DespachoImpCalculo dic inner join RemitoCompra rc on dic.rc_id      = rc.rc_id
                               inner join Proveedor prov  on rc.prov_id      = prov.prov_id
                                inner join Usuario us      on dic.modifico   = us.us_id
                               inner join Moneda mon1     on dic.mon_id1    = mon1.mon_id
                               left  join Moneda mon2     on dic.mon_id2    = mon2.mon_id

                               left  join DespachoImpCalculoPosicionArancel dicp on dic.dic_id = dicp.dic_id
                               left  join PosicionArancel poar on dicp.poar_id = poar.poar_id
  where 
            
            dic.dic_id = @@dic_id

union all

--///////////////////////////////////////////////////////////////////////////////////////////////////
--
--
--    PRODUCTOS
--
--
--///////////////////////////////////////////////////////////////////////////////////////////////////

  select 

        3              as orden_id,

        dic.dic_id,
        dic.dic_numero,
        dic.dic_fecha,
        dic.dic_tipo,
        dic.dic_titulo,
        dic.dic_descrip,
        dic.dic_via,
        dic.dic_viaempresa,
        dic.dic_factura,
        dic.dic_cambio1,
        dic.dic_cambio2,
        dic.dic_pase,
        dic.dic_totalgtos,
        dic.dic_porcfob/100 as dic_porcfob,
        dic.dic_var/100 as dic_var,
        dic.dic_porcfobfinal/100 as dic_porcfobfinal,
        dic.dic_total,
        dic.dic_totalorigen,
        dic.mon_id1,
        dic.mon_id2,
        dic.creado,
        dic.modificado,
        dic.modifico,
        dic.rc_id,

        case dic_tipo
          when 1 then 'Provisorio'
          when 2 then 'Definitivo'
        end                   as Tipo,
        prov_nombre,
        rc_nrodoc,
        mon1.mon_nombre        as moneda1,
        mon2.mon_nombre        as moneda2,
        mon1.mon_signo        as signo1,
        mon2.mon_signo        as signo2,
        @mon_signo_def        as signo_def,

        null as codigo_ex_work,
        
        null as codigo_embalaje,
        null as codigo_seguro,
        null as codigo_totalfob,
        null as codigo_flete,
        
        null as codigo_totalcif,
        null as codigo_derechos,
        null as codigo_derechos_p,
        null as codigo_estadist,
        null as codigo_estadist_p,
        null as codigo_totalcifde,
        null as codigo_iva21,
        null as codigo_iva21_p,
        null as codigo_iva3431_91,
        null as codigo_iva3431_91_p,
        null as codigo_gan3543_92,
        null as codigo_gan3543_92_p,
        null as codigo_igb,
        null as codigo_igb_p,
        null as codigo_gastosloc,
        null as codigo_sim,
        null as codigo_sim_v,
        null as codigo_honodesp,
        null as codigo_honodesp_v,
        null as codigo_gtogsan,
        null as codigo_gtogsan_v,
        null as codigo_almacen,
        null as codigo_almacen_v,
        null as codigo_ley25413,
        null as codigo_ley25413_v,
        null as codigo_acarreo,
        null as codigo_acarreo_v,
        null as codigo_gastos,
        null as codigo_gastos_v,
        null as codigo_ivagastos,
        null as codigo_ivagastos_v,
        null as codigo_banco,
        null as codigo_banco_v,
        null as codigo_sumaapagar,
        null as codigo_sumaapagar_v,
        null as codigo_recuperoiva,
        null as codigo_recuperoiva_v,
        
        ---------------------------------------------------------------------------
        null as codigo_digital_doc,
        null as codigo_digital_doc_v,
        null as codigo_gastosenvio,
        null as codigo_gastosenvio_v,
        null as codigo_gtopba,
        null as codigo_gtopba_v,
        
        ---------------------------------------------------------------------------
                
        null as dicp_id,
        null as dicp_derechos,
        null as dicp_estadisticas,
        null as dicp_iva,
        null as dicp_iva3431,
        null as dicp_ganancias,
        null as dicp_igb,
        null as dicp_gastoenvio,
        pr.poar_id,
        
        poar_codigo as poar_nombre,

        ---------------------------------------------------------------------------

        pr_nombrecompra,
        rci_precio,
        rci_costo,
        rci_cantidadaremitir,
        rci_neto,
        rci_costo * rci_cantidadaremitir as rci_costo_neto
        

  from 
        DespachoImpCalculo dic inner join RemitoCompra rc on dic.rc_id      = rc.rc_id
                               inner join Proveedor prov  on rc.prov_id      = prov.prov_id
                                inner join Usuario us      on dic.modifico   = us.us_id
                               inner join Moneda mon1     on dic.mon_id1    = mon1.mon_id
                               left  join Moneda mon2     on dic.mon_id2    = mon2.mon_id

                               left  join RemitoCompraItem rci on rc.rc_id = rci.rc_id
                               left  join Producto pr on rci.pr_id = pr.pr_id

                               left  join PosicionArancel poar on pr.poar_id = poar.poar_id
  where 
            
            dic.dic_id = @@dic_id

end
go