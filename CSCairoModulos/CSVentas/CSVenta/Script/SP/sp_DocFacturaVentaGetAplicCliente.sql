if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGetAplicCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGetAplicCliente]

go

/*

sp_DocFacturaVentaGetAplicCliente 1,112,6

select * from cliente where cli_id = 23
select * from cliente where cli_id = 26

*/
create procedure sp_DocFacturaVentaGetAplicCliente (
  @@emp_id      int,
  @@fv_id       int,
  @@tipo        tinyint    /* 1: Vencimientos 
                              2: Aplicaciones Cobranzas y Notas de credito 
                              3: Aplicaciones posibles (Cobranzas y Notas de credito) 
                              4: Pendientes Items (Articulos)
                              5: Aplicaciones Pedidos y Remitos
                              6: Aplicaciones posibles (Pedidos y Remitos)
                            */
)
as
begin

  create table #t_clientes (cli_id int)

  declare @cli_id   int
  declare @doct_id  int

  select @cli_id  = cli_id, 
         @doct_id = doct_id,
         @@emp_id = emp_id 
  from FacturaVenta where fv_id = @@fv_id

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Vencimientos
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if @@tipo = 1  begin

      select 
              fvd.fvd_id,
              0                     as fvp_id,
              fvd.fvd_fecha         as fecha,
              isnull((select sum(fvcobz_importe)      from FacturaVentaCobranza fvc      where fvd.fvd_id = fvc.fvd_id),0)
            + isnull((select sum(fvcn1.fvnc_importe) from FacturaVentaNotaCredito fvcn1 where fvd.fvd_id = fvcn1.fvd_id_factura),0)
            + isnull((select sum(fvcn2.fvnc_importe) from FacturaVentaNotaCredito fvcn2 where fvd.fvd_id = fvcn2.fvd_id_notacredito),0)
                                    as importe,
              fvd.fvd_pendiente      as pendiente
    
      from FacturaVentaDeuda fvd
      where fvd.fv_id = @@fv_id
      group by fvd.fvd_id, fvd.fvd_fecha, fvd.fvd_pendiente

    union

      select 
              0                 as fvd_id,
              fvp_id,
              fvp_fecha         as fecha,
              fvp_importe       as importe,
              0                  as pendiente
    
      from FacturaVentaPago
      where fv_id = @@fv_id

    order by fecha

  end else begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Aplicaciones Cobranzas y Notas de credito 
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if @@tipo = 2 begin  


      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Notas de credito 
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if @doct_id = 7 /*Nota de Credito Venta*/ begin

        select 
                fvnc_id,
                fvnc_importe              as Aplicado,

                fvd_id_factura            as fvd_id2,
                fvd_id_notacredito        as fvd_id,

                fvp_id_factura            as fvp_id2,
                fvp_id_notacredito        as fvp_id,

                fvdfv.fvd_pendiente        as pendiente,
                fv_id_factura             as fv_id,
                fv_nrodoc                  as nrodoc,
                doc_nombre,

                /* para el union */
                0                           as cobz_id,
                0                           as fvcobz_id,
                0                           as fvcobz_importeOrigen,
                0                           as fvcobz_cotizacion,
                0                           as cobz_pendiente,
                ''                          as cobz_nroDoc,
                IsNull(fvdfv.fvd_fecha,
                       fvpfv.fvp_fecha)     as cobz_fecha
                /* fin para el union */
      
        from FacturaVentaNotaCredito fvnc   
                                      inner join FacturaVenta fv           on fvnc.fv_id_factura       = fv.fv_id

                                      left  join FacturaVentaPago  fvpnc   on fvnc.fvp_id_notacredito   = fvpnc.fvp_id
                                      left  join FacturaVentaDeuda fvdnc   on fvnc.fvd_id_notacredito   = fvdnc.fvd_id
  
                                      left  join FacturaVentaPago  fvpfv   on fvnc.fvp_id_factura       = fvpfv.fvp_id
                                      left  join FacturaVentaDeuda fvdfv   on fvnc.fvd_id_factura       = fvdfv.fvd_id
  
                                      left  join Documento d               on fv.doc_id   = d.doc_id
        where fvnc.fv_id_notacredito = @@fv_id

        order by fv_nrodoc

       end else begin

      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Factura y Nota de debito 
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

          select 
                  fvnc_id,
                  fvnc_importe                as Aplicado,

                  fvd_id_factura              as fvd_id,
                  fvd_id_notacredito          as fvd_id2,
  
                  fvp_id_factura              as fvp_id,
                  fvp_id_notacredito          as fvp_id2,

                  fvdnc.fvd_pendiente         as pendiente,
                  fv_id_notacredito            as fv_id,
                  fv_nrodoc                    as nrodoc,
                  doc_nombre,

                  /* para el union */
                  0                           as cobz_id,
                  0                           as fvcobz_id,
                  0                           as fvcobz_importeOrigen,
                  0                           as fvcobz_cotizacion,
                  IsNull(fvdnc.fvd_fecha,
                         fvpnc.fvp_fecha)     as cobz_fecha
                  /* fin para el union */
          
          from FacturaVentaNotaCredito fvnc   
                                        inner join FacturaVenta fv           on fvnc.fv_id_notacredito    = fv.fv_id
    
                                        left  join FacturaVentaPago  fvpnc   on fvnc.fvp_id_notacredito   = fvpnc.fvp_id
                                        left  join FacturaVentaDeuda fvdnc   on fvnc.fvd_id_notacredito   = fvdnc.fvd_id
  
                                        left  join FacturaVentaPago  fvpfv   on fvnc.fvp_id_factura   = fvpfv.fvp_id
                                        left  join FacturaVentaDeuda fvdfv   on fvnc.fvd_id_factura   = fvdfv.fvd_id
    
                                        left  join Documento d               on fv.doc_id   = d.doc_id
          where fvnc.fv_id_factura = @@fv_id
      
        union

          select  
                  /* para el union */
                  0                           as fvnc_id,
                  fvcobz_importe              as Aplicado,
                  fvc.fvd_id                  as fvd_id,
                  0                           as fvd_id2,
                  fvc.fvp_id                  as fvp_id,
                  0                           as fvp_id2,
                  cobz_pendiente              as pendiente,
                  0                           as fv_id,
                  cobz_nroDoc                  as nrodoc,
                  doc_nombre,
                  /* fin para el union */
          
                  cobz.cobz_id,
                  fvcobz_id,
                  fvcobz_importeOrigen,
                  fvcobz_cotizacion,
                  cobz_fecha

        
          from FacturaVentaCobranza fvc  inner join FacturaVenta fv       on fvc.fv_id     = fv.fv_id
                                         inner join Cobranza cobz         on fvc.cobz_id   = cobz.cobz_id 
                                         left  join FacturaVentaDeuda fvd on fvc.fvd_id   = fvd.fvd_id
                                         left  join FacturaVentaPago  fvp on fvc.fvp_id   = fvp.fvp_id
                                         left  join Documento d           on cobz.doc_id   = d.doc_id
          where fv.fv_id = @@fv_id
      
        order by fv_nrodoc,cobz_fecha 
      
      end

    end else begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Aplicaciones posibles (Cobranzas y Notas de credito) 
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      if @@tipo = 3 begin  
  
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Notas de credito 
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if @doct_id = 7 /*Nota de Credito Venta*/ begin
  
            select 
                    0                    as cobz_id,
                    fv.fv_id,
                    fvd_id,
                    fvd_fecha           as Fecha,
                    doc_nombre,
                    fv_nrodoc           as nroDoc,
                    fvd_pendiente       as Pendiente
          
            from FacturaVenta fv           inner join FacturaVentaDeuda fvd    on fv.fv_id   = fvd.fv_id
                                          inner join Documento d               on fv.doc_id   = d.doc_id
            where fv.cli_id = @cli_id

              and fv.est_id <> 7

              -- Empresa
              and d.emp_id = @@emp_id

              and fv.doct_id <> 7 /* Facturas y Notas de debito */
              and not exists(select fvnc_id from FacturaVentaNotaCredito
                                            where fvd_id_factura    = fvd.fvd_id 
                                              and fv_id_notacredito = @@fv_id
                            )
              and round(fvd_pendiente,2) > 0

          order by nroDoc, fecha 
  
         end else begin
  
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Factura y Nota de debito 
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
              select 
                      0                    as cobz_id,
                      fv.fv_id,
                      fvd_id,
                      fvd_fecha           as Fecha,
                      doc_nombre,
                      fv_nrodoc           as nroDoc,
                      fvd_pendiente       as Pendiente
            
              from FacturaVenta fv           inner join FacturaVentaDeuda fvd    on fv.fv_id   = fvd.fv_id
                                            inner join Documento d               on fv.doc_id   = d.doc_id
              where fv.cli_id = @cli_id

                and fv.est_id <> 7

                -- Empresa
                and d.emp_id = @@emp_id

                and fv.doct_id = 7 /* Notas de credito */
                and not exists(select fvd_id from FacturaVentaNotaCredito
                                              where fvd_id_notacredito = fvd.fvd_id 
                                                and fv_id_factura      = @@fv_id)
                and round(fvd_pendiente,2) > 0          

            union 
          
              select 
                      cobz_id,
                      0                   as fv_id,
                      0                   as fvd_id,
                      cobz_fecha          as Fecha,
                      doc_nombre,
                      cobz_nrodoc         as nroDoc,
                      cobz_pendiente      as Pendiente
            
              from Cobranza cobz           inner join Documento d               on cobz.doc_id = d.doc_id
              where cli_id = @cli_id

                and cobz.est_id <> 7

                -- Empresa
                and d.emp_id = @@emp_id

                and not exists(select cobz_id from FacturaVentaCobranza 
                                              where cobz_id = cobz.cobz_id 
                                                and fv_id   = @@fv_id)
                and round(cobz_pendiente,2) > 0
            order by nroDoc, fecha 

        end
      end else begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Pendientes Items (Articulos)                  
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if @@tipo = 4 begin  

          select   
                  fvi.fvi_id, 
                   fvi.pr_id, 
                  pr_nombreventa, 
                  fvi_pendiente, 
                  fvi_cantidadaremitir - fvi_pendiente  as aplicado,
                  fvi_orden

          from 
                FacturaVentaItem fvi   inner join Producto p on fvi.pr_id  = p.pr_id
          where 
                fvi.fv_id = @@fv_id

          order by 
                  fvi_orden

        end else begin
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Aplicaciones Pedidos y Remitos                  sp_col pedidofacturaventa
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          if @@tipo = 5 begin  

              select  
                            fvi.fvi_id,
                            fvi.pr_id,

                            pvi.pvi_id,
                            pvfv_id,

                            0                   as rvi_id,
                            0                    as rvfv_id,

                            pvfv_cantidad       as Aplicado,

                            doc_nombre,
                            pv_nrodoc            as nrodoc,
                            pv_fecha            as Fecha,
                            pvi_pendiente        as Pendiente,

                            pvi_orden            as orden
                            
              from 
                            FacturaVentaItem fvi inner join PedidoFacturaVenta pvfv on fvi.fvi_id   = pvfv.fvi_id
                                                 inner join PedidoVentaItem pvi     on pvfv.pvi_id  = pvi.pvi_id
                                                 inner join PedidoVenta pv          on pvi.pv_id    = pv.pv_id
                                                 inner join Documento doc           on pv.doc_id    = doc.doc_id
              where
                            fvi.fv_id = @@fv_id

            union

              select  
                            fvi.fvi_id,
                            fvi.pr_id,

                            0                    as pvi_id,
                            0                    as pvfv_id,

                            rvi.rvi_id,
                            rvfv_id,

                            rvfv_cantidad       as Aplicado,

                            doc_nombre,
                            rv_nrodoc            as nrodoc,
                            rv_fecha            as Fecha,
                            rvi_pendientefac    as Pendiente,

                            rvi_orden            as orden
                            
                            
              from 
                            FacturaVentaItem fvi inner join RemitoFacturaVenta rvfv on fvi.fvi_id   = rvfv.fvi_id
                                                 inner join RemitoVentaItem rvi     on rvfv.rvi_id  = rvi.rvi_id
                                                 inner join RemitoVenta rv          on rvi.rv_id    = rv.rv_id
                                                 inner join Documento doc           on rv.doc_id    = doc.doc_id
              where
                            fvi.fv_id = @@fv_id
              order by
                            Fecha, nrodoc, orden                            

          end else begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Aplicaciones posibles (Pedidos y Remitos)     sp_col pedidofacturaventa
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            if @@tipo = 6 begin  

                insert into #t_clientes (cli_id) values(@cli_id)

                declare @cfg_valor varchar(5000) 
              
                exec sp_Cfg_GetValor  'Ventas-General',
                                      'Aplicaciones entre Grupos de Clientes',
                                      @cfg_valor out,
                                      0
              
                set @cfg_valor = IsNull(@cfg_valor,0)
                if convert(int,@cfg_valor) <> 0 begin

                  declare @cli_id_padre int
                  select @cli_id_padre = cli_id_padre from Cliente where cli_id = @cli_id

                  if @cli_id_padre is not null begin

                    insert into #t_clientes (cli_id)
                    select cli_id from cliente where cli_id = @cli_id_padre and  cli_id <> @cli_id

                  end

                  insert into #t_clientes (cli_id)
                  select cli_id from cliente where cli_id_padre = @cli_id
                    and not exists (select cli_id from #t_clientes where cli_id = cliente.cli_id)
                end

                select  top 100
                              pvi.pr_id,
  
                              pvi_id,
  
                              0                   as rvi_id,
    
                              doc_nombre,
                              pv_nrodoc            as nrodoc,
                              pv_fecha            as Fecha,
                              pvi_pendiente        as Pendiente,
  
                              pvi_orden            as orden
                              
                from 
                              FacturaVentaItem fvi inner join FacturaVenta fv       on fvi.fv_id = fv.fv_id

                                                   inner join PedidoVenta pv        on    fv.cli_id  = pv.cli_id
                                                                                      and pv.doct_id = 5
                                                                                      and pv.est_id  <> 7

                                                   inner join Documento doc         on pv.doc_id = doc.doc_id

                                                   inner join PedidoVentaItem pvi   on       pv.pv_id  = pvi.pv_id 
                                                                                        and fvi.pr_id = pvi.pr_id

                where
                              fvi.fv_id = @@fv_id

                          -- Empresa
                          and doc.emp_id = @@emp_id

                          and pvi_pendiente > 0

                          -- El pedidoventaitem no tiene que estar vinculado 
                          -- con ningun item de esta factura
                          --
                          and not exists(select * 
                                            from PedidoFacturaVenta pvfv inner join FacturaVentaItem fvi 
                                                                              on pvfv.fvi_id = fvi.fvi_id
                                            where pvi_id = pvi.pvi_id and fv_id = fv.fv_id)
  
              union
  
                select  top 700  
                              rvi.pr_id,
  
                              0                    as pvi_id,
  
                              rvi_id,
    
                              doc_nombre,
                              rv_nrodoc            as nrodoc,
                              rv_fecha            as Fecha,
                              rvi_pendientefac    as Pendiente,

                              rvi_orden            as orden
                              
                from 
                              FacturaVentaItem fvi inner join FacturaVenta fv       on fvi.fv_id = fv.fv_id

                                                   inner join RemitoVenta rv        on     exists(    select * from #t_Clientes t 
                                                                                                     where t.cli_id = rv.cli_id
                                                                                                  )
                                                                                      and rv.doct_id = 3
                                                                                      and rv.est_id  <> 7

                                                   inner join Documento doc         on rv.doc_id = doc.doc_id

                                                   inner join RemitoVentaItem rvi   on       rv.rv_id  = rvi.rv_id 
                                                                                        and fvi.pr_id = rvi.pr_id

                where
                              fvi.fv_id = @@fv_id

                          -- Empresa
                          and doc.emp_id = @@emp_id

                          and rvi_pendientefac > 0

                          -- El remitoventaitem no tiene que estar vinculado 
                          -- con ningun item de esta factura
                          --
                          and not exists(select * 
                                            from RemitoFacturaVenta rvfv inner join FacturaVentaItem fvi 
                                                                              on rvfv.fvi_id = fvi.fvi_id
                                            where rvi_id = rvi.rvi_id and fv_id = fv.fv_id)
  
            end
          end
        end
      end
    end
  end
end

go
