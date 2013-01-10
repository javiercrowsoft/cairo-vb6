if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraGetAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraGetAplic]

go

/*

select * from facturaCompra

exec sp_DocFacturaCompraGetAplic 26,1

exec sp_DocFacturaCompraGetAplic 2,3582,1

sp_DocFacturaCompraGetAplic 24,2

*/
create procedure sp_DocFacturaCompraGetAplic (
  @@emp_id      int,
  @@fc_id       int,
  @@tipo        tinyint    /* 1: Vencimientos 
                              2: Aplicaciones OrdenPagos y Notas de credito 
                              3: Aplicaciones posibles (OrdenPagos y Notas de credito) 
                              4: Pendientes Items (Articulos)
                              5: Aplicaciones Ordenes de Compra y Remitos
                              6: Aplicaciones posibles (Ordenes y Remitos)
                            */
)
as
begin

  declare @prov_id   int
  declare @doct_id  int

  select @prov_id = prov_id, 
         @doct_id = fc.doct_id, 
         @@emp_id = d.emp_id
  from FacturaCompra fc inner join Documento d on fc.doc_id = d.doc_id
  where fc_id = @@fc_id

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Vencimientos
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if @@tipo = 1  begin

      select 
              fcd.fcd_id,
              0                     as fcp_id,
              fcd.fcd_fecha         as fecha,
              isnull((select sum(fcopg_importe)       From FacturaCompraOrdenPago fcc     where fcd.fcd_id = fcc.fcd_id),0)
            + isnull((select sum(fccn1.fcnc_importe)   From FacturaCompraNotaCredito fccn1 where fcd.fcd_id = fccn1.fcd_id_factura),0)
            + isnull((select sum(fccn2.fcnc_importe)   From FacturaCompraNotaCredito fccn2 where fcd.fcd_id = fccn2.fcd_id_notacredito),0)
                                    as importe,
              fcd.fcd_pendiente      as pendiente
    
      from FacturaCompraDeuda fcd 
      where fcd.fc_id = @@fc_id
      group by fcd.fcd_id, fcd.fcd_fecha, fcd.fcd_pendiente

    union

      select 
              0                 as fcd_id,
              fcp_id,
              fcp_fecha         as fecha,
              fcp_importe       as importe,
              0                  as pendiente
    
      from FacturaCompraPago
      where fc_id = @@fc_id

    order by fecha

  end else begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Aplicaciones OrdenPagos y Notas de credito 
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if @@tipo = 2 begin  


      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Notas de credito select * from documentotipo
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if @doct_id = 8 /*Nota de Credito Compra*/ begin

        select 
                fcnc_id,
                fcnc_importe              as Aplicado,

                fcd_id_factura            as fcd_id2,
                fcd_id_notacredito        as fcd_id,

                fcp_id_factura            as fcp_id2,
                fcp_id_notacredito        as fcp_id,

                fcdfc.fcd_pendiente        as pendiente,
                fc_id_factura             as fc_id,
                fc_nrodoc                  as nrodoc,
                doc_nombre,

                /* para el union */
                0                           as opg_id,
                0                           as fcopg_id,
                0                           as fcopg_importeOrigen,
                0                           as fcopg_cotizacion,
                0                           as opg_pendiente,
                ''                          as opg_nroDoc,
                IsNull(fcdfc.fcd_fecha,
                       fcpfc.fcp_fecha)     as opg_fecha
                /* fin para el union */
      
        from FacturaCompraNotaCredito fcnc   
                                      inner join FacturaCompra fc           on fcnc.fc_id_factura       = fc.fc_id

                                      left  join FacturaCompraPago  fcpnc   on fcnc.fcp_id_notacredito   = fcpnc.fcp_id
                                      left  join FacturaCompraDeuda fcdnc   on fcnc.fcd_id_notacredito   = fcdnc.fcd_id
  
                                      left  join FacturaCompraPago  fcpfc   on fcnc.fcp_id_factura       = fcpfc.fcp_id
                                      left  join FacturaCompraDeuda fcdfc   on fcnc.fcd_id_factura       = fcdfc.fcd_id
  
                                      left  join Documento d               on fc.doc_id   = d.doc_id
        where fcnc.fc_id_notacredito = @@fc_id

        order by fc_nrodoc

       end else begin

      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Factura y Nota de debito 
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

          select 
                  fcnc_id,
                  fcnc_importe                as Aplicado,

                  fcd_id_factura              as fcd_id,
                  fcd_id_notacredito          as fcd_id2,
  
                  fcp_id_factura              as fcp_id,
                  fcp_id_notacredito          as fcp_id2,

                  fcdnc.fcd_pendiente         as pendiente,
                  fc_id_notacredito           as fc_id,
                  fc_nrodoc                    as nrodoc,
                  doc_nombre,

                  /* para el union */
                  0                           as opg_id,
                  0                           as fcopg_id,
                  0                           as fcopg_importeOrigen,
                  0                           as fcopg_cotizacion,
                  IsNull(fcdnc.fcd_fecha,
                         fcpnc.fcp_fecha)     as opg_fecha

                  /* fin para el union */
          
          from FacturaCompraNotaCredito fcnc   
                                        inner join FacturaCompra fc           on fcnc.fc_id_notacredito    = fc.fc_id
    
                                        left  join FacturaCompraPago  fcpnc   on fcnc.fcp_id_notacredito   = fcpnc.fcp_id
                                        left  join FacturaCompraDeuda fcdnc   on fcnc.fcd_id_notacredito   = fcdnc.fcd_id
  
                                        left  join FacturaCompraPago  fcpfc   on fcnc.fcp_id_factura   = fcpfc.fcp_id
                                        left  join FacturaCompraDeuda fcdfc   on fcnc.fcd_id_factura   = fcdfc.fcd_id
    
                                        left  join Documento d               on fc.doc_id   = d.doc_id
          where fcnc.fc_id_factura = @@fc_id
      
        union

          select  
                  /* para el union */
                  0                           as fcnc_id,
                  fcopg_importe                as Aplicado,
                  fcc.fcd_id                  as fcd_id,
                  0                           as fcd_id2,
                  fcc.fcp_id                  as fcp_id,
                  0                           as fcp_id2,
                  opg_pendiente                as pendiente,
                  0                           as fc_id,
                  opg_nroDoc                  as nrodoc,
                  doc_nombre,
                  /* fin para el union */
          
                  opg.opg_id,
                  fcopg_id,
                  fcopg_importeOrigen,
                  fcopg_cotizacion,
                  opg_fecha

        
          from FacturaCompraOrdenPago fcc  inner join FacturaCompra fc        on fcc.fc_id   = fc.fc_id
                                           inner join OrdenPago opg          on fcc.opg_id   = opg.opg_id 
                                           left  join FacturaCompraDeuda fcd on fcc.fcd_id   = fcd.fcd_id
                                           left  join FacturaCompraPago  fcp on fcc.fcp_id   = fcp.fcp_id
                                           left  join Documento d            on opg.doc_id   = d.doc_id
          where fc.fc_id = @@fc_id
      
        order by fc_nrodoc,opg_fecha 
      
      end

    end else begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Aplicaciones posibles (OrdenPagos y Notas de credito) 
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      if @@tipo = 3 begin  
  
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Notas de credito 
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if @doct_id = 8 /*Nota de Credito Compra*/ begin
  
            select 
                    0                    as opg_id,
                    fc.fc_id,
                    fcd_id,
                    fcd_fecha           as Fecha,
                    doc_nombre,
                    fc_nrodoc           as nroDoc,
                    fcd_pendiente       as Pendiente
          
            from FacturaCompra fc           inner join FacturaCompraDeuda fcd    on fc.fc_id   = fcd.fc_id
                                            inner join Documento d               on fc.doc_id   = d.doc_id
            where fc.prov_id = @prov_id

              and fc.est_id <> 7

              -- Empresa
              and d.emp_id = @@emp_id

              and fc.doct_id <> 8 /* Facturas y Notas de debito */
              and not exists(select fcnc_id from FacturaCompraNotaCredito
                                            where fcd_id_factura    = fcd.fcd_id 
                                              and fc_id_notacredito = @@fc_id
                            )
              and round(fcd_pendiente,2) > 0
        
          order by nroDoc, fecha 
  
         end else begin
  
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Factura y Nota de debito 
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
              select 
                      0                    as opg_id,
                      fc.fc_id,
                      fcd_id,
                      fcd_fecha           as Fecha,
                      doc_nombre,
                      fc_nrodoc           as nroDoc,
                      fcd_pendiente       as Pendiente
            
              from FacturaCompra fc         inner join FacturaCompraDeuda fcd    on fc.fc_id   = fcd.fc_id
                                            inner join Documento d               on fc.doc_id   = d.doc_id
              where fc.prov_id = @prov_id

                and fc.est_id <> 7

                -- Empresa
                and d.emp_id = @@emp_id

                and fc.doct_id = 8 /* Notas de credito */
                and not exists(select fcd_id from FacturaCompraNotaCredito
                                              where fcd_id_notacredito = fcd.fcd_id 
                                                and fc_id_factura      = @@fc_id)
                and round(fcd_pendiente,2) > 0        

            union 
          
              select 
                      opg_id,
                      0                  as fc_id,
                      0                  as fcd_id,
                      opg_fecha          as Fecha,
                      doc_nombre,
                      opg_nrodoc         as nroDoc,
                      opg_pendiente      as Pendiente
            
              from OrdenPago opg           inner join Documento d               on opg.doc_id = d.doc_id
              where prov_id = @prov_id

                and opg.est_id <> 7

                -- Empresa
                and d.emp_id = @@emp_id

                and not exists(select opg_id from FacturaCompraOrdenPago 
                                              where opg_id = opg.opg_id 
                                                and fc_id   = @@fc_id)
                and round(opg_pendiente,2) > 0

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
                  fci.fci_id, 
                   fci.pr_id, 
                  pr_nombrecompra, 
                  fci_pendiente, 
                  fci_cantidadaremitir - fci_pendiente  as aplicado,
                  fci_orden

          from 
                FacturaCompraItem fci   inner join Producto p on fci.pr_id  = p.pr_id
          where 
                fci.fc_id = @@fc_id

          order by 
                  fci_orden

        end else begin
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Aplicaciones Ordenes y Remitos                  sp_col ordenfacturaCompra
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          if @@tipo = 5 begin  

              select  
                            fci.fci_id,
                            fci.pr_id,

                            oci.oci_id,
                            ocfc_id,

                            0                   as rci_id,
                            0                    as rcfc_id,

                            ocfc_cantidad       as Aplicado,

                            doc_nombre,
                            oc_nrodoc            as nrodoc,
                            oc_fecha            as Fecha,
                            oci_pendientefac        as Pendiente,

                            oci_orden            as orden
                            
              from 
                            FacturaCompraItem fci inner join OrdenFacturaCompra ocfc on fci.fci_id   = ocfc.fci_id
                                                  inner join OrdenCompraItem oci     on ocfc.oci_id  = oci.oci_id
                                                  inner join OrdenCompra oc          on oci.oc_id    = oc.oc_id
                                                  inner join Documento doc           on oc.doc_id    = doc.doc_id
              where
                            fci.fc_id = @@fc_id

            union

              select  
                            fci.fci_id,
                            fci.pr_id,

                            0                    as oci_id,
                            0                    as ocfc_id,

                            rci.rci_id,
                            rcfc_id,

                            rcfc_cantidad       as Aplicado,

                            doc_nombre,
                            rc_nrodoc            as nrodoc,
                            rc_fecha            as Fecha,
                            rci_pendientefac    as Pendiente,

                            rci_orden            as orden
                            
                            
              from 
                            FacturaCompraItem fci inner join RemitoFacturaCompra rcfc on fci.fci_id   = rcfc.fci_id
                                                   inner join RemitoCompraItem rci     on rcfc.rci_id  = rci.rci_id
                                                   inner join RemitoCompra rc          on rci.rc_id     = rc.rc_id
                                                   inner join Documento doc             on rc.doc_id    = doc.doc_id
              where
                            fci.fc_id = @@fc_id
              order by
                            Fecha, nrodoc, orden                            

          end else begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--
-- Aplicaciones posibles (Ordenes y Remitos)     sp_col OrdenfacturaCompra
--
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            if @@tipo = 6 begin  

                select  
                              oci.pr_id,
  
                              oci_id,
  
                              0                   as rci_id,
    
                              doc_nombre,
                              oc_nrodoc            as nrodoc,
                              oc_fecha            as Fecha,
                              oci_pendientefac        as Pendiente,
  
                              oci_orden            as orden
                              
                from 
                              FacturaCompraItem fci inner join FacturaCompra fc       on fci.fc_id  = fc.fc_id

                                                     inner join OrdenCompra oc          on     fc.prov_id = oc.prov_id
                                                                                        and oc.doct_id = 35
                                                                                        and oc.est_id  <> 7

                                                     inner join Documento doc           on oc.doc_id  = doc.doc_id

                                                     inner join OrdenCompraItem oci     on     oc.oc_id  = oci.oc_id 
                                                                                        and fci.pr_id = oci.pr_id

                where
                              fci.fc_id = @@fc_id

                          -- Empresa
                          and doc.emp_id = @@emp_id
            
                          and oci_pendientefac > 0

                          -- El OrdenCompraitem no tiene que estar vinculado 
                          -- con ningun item de esta factura
                          --
                          and not exists(select * 
                                            from OrdenFacturaCompra ocfc inner join FacturaCompraItem fci 
                                                                              on ocfc.fci_id = fci.fci_id
                                            where oci_id = oci.oci_id and fc_id = fc.fc_id)
  
              union
  
                select  
                              rci.pr_id,
  
                              0                    as oci_id,
  
                              rci_id,
    
                              doc_nombre,
                              rc_nrodoc            as nrodoc,
                              rc_fecha            as Fecha,
                              rci_pendientefac    as Pendiente,

                              rci_orden            as orden
                              
                from 
                              FacturaCompraItem fci inner join FacturaCompra fc       on fci.fc_id  = fc.fc_id

                                                     inner join RemitoCompra rc        on     fc.prov_id = rc.prov_id
                                                                                        and rc.doct_id = 4
                                                                                        and rc.est_id  <> 7

                                                     inner join Documento doc           on rc.doc_id  = doc.doc_id

                                                     inner join RemitoCompraItem rci   on       rc.rc_id  = rci.rc_id 
                                                                                        and fci.pr_id = rci.pr_id

                where
                              fci.fc_id = @@fc_id

                          -- Empresa
                          and doc.emp_id = @@emp_id

                          and rci_pendientefac > 0

                          -- El remitoCompraitem no tiene que estar vinculado 
                          -- con ningun item de esta factura
                          --
                          and not exists(select * 
                                            from RemitoFacturaCompra rcfc inner join FacturaCompraItem fci 
                                                                              on rcfc.fci_id = fci.fci_id
                                            where rci_id = rci.rci_id and fc_id = fc.fc_id)
  
            end
          end
        end
      end
    end
  end
end
go