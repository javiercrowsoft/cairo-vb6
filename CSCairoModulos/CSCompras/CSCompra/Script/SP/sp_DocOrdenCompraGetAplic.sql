if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenCompraGetAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenCompraGetAplic]

go

/*

select * from pedidoordencompra
select * from pedidocompraitem

sp_DocOrdenCompraGetAplic 1,10,5

*/
create procedure sp_DocOrdenCompraGetAplic (
  @@emp_id      int,
  @@oc_id       int,
  @@tipo        tinyint    /* 1: Items
                              2: Aplicaciones Facturas
                              3: Aplicaciones Posibles Facturas
                              4: Aplicaciones Pedidos de Compra
                              5: Aplicaciones Posibles Pedidos de Compra
                            */
)
as
begin

  declare @prov_id   int
  declare @doct_id  int

  select @prov_id = prov_id, @doct_id = doct_id from OrdenCompra where oc_id = @@oc_id


--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 1: Items
  if @@tipo = 1 begin

    select   
            oci.oci_id, 
             oci.pr_id, 
            pr_nombreCompra, 
            oci_pendiente,
            oci_pendientefac,
            oci_cantidad - oci_pendiente             as AplicPedido,
            oci_cantidadaremitir - oci_pendientefac  as AplicRemito,
            oci_orden
  
    from 
          OrdenCompraItem oci   inner join Producto p on oci.pr_id  = p.pr_id
    where 
          oci.oc_id = @@oc_id
  
    order by 
            oci_orden

  end else begin -- 1: if Items
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 2: Aplicaciones Facturas
    if @@tipo = 2 begin


      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Devoluciones
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if @doct_id = 23 /* Devolucion */ begin

        -- Ordenes
        select  
                      oci.oci_id,                                              -- Item
                      oci.pr_id,                                              -- Producto

                      0                      as fci_id,                        -- Factura
                      ocd.oci_id            as ocd_id,                        -- Orden de Compra
                      0                     as rci_id,                        -- Remito
                      ocdc_id                as vinc_id,                        -- id Aplicacion

                      ocdc_cantidad         as Aplicado,                      -- Aplicacion

                      doc_nombre,                                              -- Datos del item de la orden de compra
                      oc_nrodoc              as nrodoc,                        --
                      oc_fecha              as Fecha,                          --
                      ocd.oci_pendientefac  as Pendiente,                      --

                      ocd.oci_orden          as orden                          --
                      
        from 
              -- Items de la devolucion       tabal de vinculacion                               (es una devolucion)
              OrdenCompraItem oci  inner join OrdenDevolucionCompra ocdc   on oci.oci_id   = ocdc.oci_id_devolucion

                                          --  Items de Ordenes asociados con la devolucion       (es un Orden)
                                   inner join OrdenCompraItem ocd          on ocdc.oci_id_Orden = ocd.oci_id

                                              -- Datos del documento de los items de Orden asociadso con la devolucion
                                   inner join OrdenCompra oc               on ocd.oc_id    = oc.oc_id
                                   inner join Documento doc               on oc.doc_id    = doc.doc_id
        where
                    oci.oc_id = @@oc_id    -- solo items de la devolucion solicitada

        order by oci.oci_orden

       end else begin

      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Ordenes
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

          -- Devoluciones
              select  
                            oci.oci_id,                                  -- Item
                            oci.pr_id,                                  -- Producto

                            0                      as fci_id,            -- Factura
                            ocd.oci_id            as ocd_id,            -- Devolucion
                            0                     as rci_id,            -- Remito
                            ocdc_id                as vinc_id,            -- Id Aplicacion

                            ocdc_cantidad         as Aplicado,          -- Aplicacion

                            doc_nombre,                                  -- Datos del item de la devolucion
                            oc_nrodoc              as nrodoc,            --
                            oc_fecha              as Fecha,              --
                            ocd.oci_pendientefac  as Pendiente,          --

                            ocd.oci_orden          as orden              --
                            
              from 

                -- Items de la orden             tabla vinculacion                                  (es un Orden)
                OrdenCompraItem oci  inner join OrdenDevolucionCompra ocdc   on oci.oci_id   = ocdc.oci_id_Orden

                                            -- Items de Devolucion asociados con el Orden         (es una devolucion)
                                     inner join OrdenCompraItem ocd          on ocdc.oci_id_devolucion = ocd.oci_id

                                            --
                                     inner join OrdenCompra oc               on ocd.oc_id    = oc.oc_id
                                     inner join Documento doc               on oc.doc_id    = doc.doc_id
              where
                          oci.oc_id = @@oc_id   -- solo items de la devolucion solicitada
        union

          -- Facturas
              select  
                            oci.oci_id,                                    -- Item
                            oci.pr_id,                                    -- Producto

                            fci.fci_id,                                    -- Factura
                            0                   as ocd_id,                -- Devolucion
                            0                   as rci_id,                -- Remito
                            ocfc_id              as vinc_id,                -- Id Aplicacion

                            ocfc_cantidad       as Aplicado,              -- Aplicacion

                            doc_nombre,                                    --  Datos del item de la devolucion
                            fc_nrodoc            as nrodoc,                --
                            fc_fecha            as Fecha,                  --
                            fci_pendiente        as Pendiente,              --

                            fci_orden            as orden                  --
                            
              from 

                -- Items de la orden             tabla vinculacion                         
                OrdenCompraItem oci  inner join OrdenFacturaCompra ocfc on oci.oci_id   = ocfc.oci_id
                                     inner join FacturaCompraItem fci    on ocfc.fci_id  = fci.fci_id
                                     inner join FacturaCompra fc         on fci.fc_id    = fc.fc_id
                                     inner join Documento doc           on fc.doc_id    = doc.doc_id
              where
                        oci.oc_id = @@oc_id    -- solo items de la devolucion solicitada

      union

          -- Remitos
              select  
                            oci.oci_id,                                    -- Item
                            oci.pr_id,                                    -- Producto

                            0                   as fci_id,                -- Factura
                            0                   as ocd_id,                -- Devolucion
                            rci.rci_id,                                    -- Remito
                            ocrc_id              as vinc_id,                -- Id Aplicacion

                            ocrc_cantidad       as Aplicado,              -- Aplicacion

                            doc_nombre,                                    --  Datos del item de la devolucion
                            rc_nrodoc            as nrodoc,                --
                            rc_fecha            as Fecha,                  --
                            rci_pendiente        as Pendiente,              --

                            rci_orden            as orden                  --
                            
              from 

                -- Items de la orden             tabla vinculacion                         
                OrdenCompraItem oci  inner join OrdenRemitoCompra ocrc  on oci.oci_id   = ocrc.oci_id
                                     inner join RemitoCompraItem rci     on ocrc.rci_id  = rci.rci_id
                                     inner join RemitoCompra rc          on rci.rc_id    = rc.rc_id
                                     inner join Documento doc           on rc.doc_id    = doc.doc_id
              where
                        oci.oc_id = @@oc_id    -- solo items de la devolucion solicitada
      
        order by nrodoc, fecha 
      
      end


    end else begin -- 2: if Aplicaciones Facturas
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 3: Aplicaciones Posibles Facturas
      if @@tipo = 3 begin

        --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        --
        --   Devoluciones
        --
        --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if @doct_id = 36 /* Devolucion */ begin
  
              select  distinct
                            0                     as oci_id,        -- Item
                            oci.pr_id,                              -- Producto

                            0                      as fci_id,        -- Factura
                            ocd.oci_id            as ocd_id,        -- Orden de Compra
                            0                     as rci_id,        -- Remito
                            0                      as vinc_id,        -- Id Aplicacion


                            0                      as Aplicado,      -- Aplicacion

                            doc_nombre,                              -- Datos del item de la orden
                            od.oc_nrodoc          as nrodoc,        --
                            od.oc_fecha           as Fecha,          --
                            ocd.oci_pendientefac  as Pendiente,      --

                            ocd.oci_orden          as orden          --
                            
              from 
                    -- Items de la devolucion       ' Voy hasta el header para obtener el proveedor
                                                  --' y lo uso para hacer un join a otros Ordenes de Compra
                                                  --' de tipo Orden que puedan vincularce con esta devolucion 
                    OrdenCompraItem oci  inner join OrdenCompra oc         on oci.oc_id = oc.oc_id

                                                  -- Vinculacion con el proveedor y contra Ordenes unicamente
                                         inner join OrdenCompra od        on     oc.prov_id = od.prov_id 
                                                                            and od.doct_id = 35
                                                                            and od.est_id  <> 7

                                         inner join Documento doc         on od.doc_id = doc.doc_id
      
                                                  -- Ahora vinculo con los items de dichos Ordenes que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join OrdenCompraItem ocd   on       oc.oc_id  = ocd.oc_id 
                                                                              and oci.pr_id = ocd.pr_id

              where
                            oci.oc_id = @@oc_id

                        -- Empresa
                        and doc.emp_id = @@emp_id

                        -- Tiene que haber pendiente en el item de la orden
                        and ocd.oci_pendientefac > 0  

                        -- El 'Orden Compra item' no tiene que estar vinculado 
                        -- con ningun item de esta devolucion
                        --
                                          -- Busco que no exista en la tabla 
                                          -- de vinculacion algun vinculo entre
                                          -- el item de la devolucion y el de la orden
                                          --
                        and not exists(select *                           
                                        from OrdenDevolucionCompra ocdc   

                                          where 
                                                    -- Ahora vinculo este item con el item de la devolucion
                                                      ocdc.oci_id_devolucion = oci.oci_id 
                                                  and 
                                                    -- y con el item de la orden
                                                      ocdc.oci_id_Orden = ocd.oci_id)

          order by nroDoc, fecha 

        --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        --
        --   Ordenes
        --
        --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        end else begin

                select  distinct
                              0                       as oci_id,          -- Item
                              oci.pr_id,                                  -- Producto
  
                              0                        as fci_id,            -- Factura
                              ocd.oci_id              as ocd_id,            -- Devolucion
                              0                       as rci_id,            -- Remito
                              0                        as vinc_id,            -- Id Aplicacion
  
                              0                       as Aplicado,          -- Aplicacion
  
                              doc_nombre,                                    -- Datos del item de la devolucion
                              od.oc_nrodoc            as nrodoc,            --
                              od.oc_fecha             as Fecha,              --
                              ocd.oci_pendientefac    as Pendiente,          --
  
                              ocd.oci_orden            as orden              --
                              
                from 
                    -- Items de la orden             ' Voy hasta el header para obtener el proveedor
                                                  --' y lo uso para hacer un join a devoluciones
                                                  --' que puedan vincularce con este Orden
                    OrdenCompraItem oci  inner join OrdenCompra oc         on oci.oc_id = oc.oc_id

                                                  -- Vinculacion con el proveedor y contra devoluciones unicamente
                                         inner join OrdenCompra od        on     oc.prov_id = od.prov_id 
                                                                            and od.doct_id = 36
                                                                            and od.est_id  <> 7

                                         inner join Documento doc         on od.doc_id = doc.doc_id

                                                  -- Ahora vinculo con los items de dichas devoluciones que posean el mismo
                                                  -- producto que el item de la orden
                                         inner join OrdenCompraItem ocd   on       od.oc_id  = ocd.oc_id 
                                                                              and oci.pr_id = ocd.pr_id
  
                where
                            oci.oc_id = @@oc_id

                        -- Empresa
                        and doc.emp_id = @@emp_id

                        -- Tiene que haber pendiente en el item de la orden
                        and ocd.oci_pendientefac > 0    

                        -- El 'Orden Compra item' no tiene que estar vinculado 
                        -- con ningun item de este Orden
                        --
                                          -- Busco que no exista en la tabla 
                                          -- de vinculacion algun vinculo entre
                                          -- el item de la devolucion y el de la orden
                                          --
                        and not exists(select * 
                                          from OrdenDevolucionCompra ocdc 

                                            where 
                                                    -- Ahora vinculo este item con el item de la orden
                                                    ocdc.oci_id_Orden = oci.oci_id 
                                                and 
                                                    -- y con el item de la devaluacion
                                                    ocdc.oci_id_devolucion = ocd.oci_id)

            union
  
                select  distinct
                              0                   as oci_id,          -- Item
                              oci.pr_id,                              -- Producto
  
                              fci.fci_id          as fci_id,          -- Factura
                              0                   as ocd_id,          -- Devolucion
                              0                   as rci_id,          -- Remito
                              0                   as vinc_id,          -- Id Devolucion
  
                              0                    as Aplicado,        -- Aplicacion
  
                              doc_nombre,                              -- Datos del item de la factura
                              fc_nrodoc            as nrodoc,          --
                              fc_fecha            as Fecha,            --
                              fci.fci_pendiente    as Pendiente,        --
  
                              fci.fci_orden        as orden            --
                              
                from 
                    -- Items de la orden             ' Voy hasta el header para obtener el proveedor
                                                  --' y lo uso para hacer un join a otras facturas
                                                  --' que puedan vincularce con este Orden
                    OrdenCompraItem oci  inner join OrdenCompra oc         on oci.oc_id = oc.oc_id

                                                  -- Vinculacion con el proveedor y contra Ordenes unicamente
                                         inner join FacturaCompra fc        on     oc.prov_id = fc.prov_id
                                                                              and fc.doct_id in (2,10)
                                                                              and fc.est_id  <> 7

                                         inner join Documento doc         on fc.doc_id = doc.doc_id

                                                  -- Ahora vinculo con los items de dichas facturas que posean el mismo
                                                  -- producto que el item de la orden
                                         inner join FacturaCompraItem fci  on       fc.fc_id  = fci.fc_id 
                                                                              and oci.pr_id = fci.pr_id
  
                where
                            oci.oc_id = @@oc_id

                        -- Empresa
                        and doc.emp_id = @@emp_id

                        -- Tiene que haber pendiente en el item de la orden
                        and fci.fci_pendiente > 0
  
                        -- El 'Orden Compra item' no tiene que estar vinculado 
                        -- con ningun item de este Orden
                        --
                                          -- Busco que no exista en la tabla 
                                          -- de vinculacion algun vinculo entre
                                          -- el item de la devolucion y el de la orden
                                          --
                        and not exists(select * 
                                          from OrdenFacturaCompra ocfc 

                                            where 
                                                    -- y con el item de la orden
                                                    ocfc.oci_id = oci.oci_id
                                                and 
                                                    -- Ahora vinculo este item con el item de la factura
                                                    ocfc.fci_id = fci.fci_id)

          union

                select  distinct
                              0                   as oci_id,          -- Item
                              oci.pr_id,                              -- Producto
  
                              0                    as fci_id,          -- Factura
                              0                   as ocd_id,          -- Devolucion
                              rci.rci_id,                              -- Remito
                              0                   as vinc_id,          -- Id Devolucion
  
                              0                    as Aplicado,        -- Aplicacion
  
                              doc_nombre,                              -- Datos del item de la factura
                              rc_nrodoc            as nrodoc,          --
                              rc_fecha            as Fecha,            --
                              rci.rci_pendiente    as Pendiente,        --
  
                              rci.rci_orden        as orden            --
                              
                from 
                    -- Items de la orden             ' Voy hasta el header para obtener el proveedor
                                                  --' y lo uso para hacer un join a otros remitos
                                                  --' que puedan vincularce con este Orden
                    OrdenCompraItem oci  inner join OrdenCompra oc         on oci.oc_id = oc.oc_id

                                                  -- Vinculacion con el proveedor y contra Ordenes unicamente
                                         inner join RemitoCompra rc        on     oc.prov_id = rc.prov_id
                                                                            and rc.doct_id = 4
                                                                            and rc.est_id  <> 7

                                         inner join Documento doc         on rc.doc_id = doc.doc_id

                                                  -- Ahora vinculo con los items de dichos remitos que posean el mismo
                                                  -- producto que el item de la orden
                                         inner join RemitoCompraItem rci   on       rc.rc_id  = rci.rc_id 
                                                                              and oci.pr_id = rci.pr_id
  
                where
                            oci.oc_id = @@oc_id

                        -- Empresa
                        and doc.emp_id = @@emp_id

                        -- Tiene que haber pendiente en el item de la orden
                        and rci.rci_pendiente > 0
  
                        -- El 'Orden Compra item' no tiene que estar vinculado 
                        -- con ningun item de este Orden
                        --
                                          -- Busco que no exista en la tabla 
                                          -- de vinculacion algun vinculo entre
                                          -- el item de la devolucion y el de la orden
                                          --
                        and not exists(select * 
                                          from OrdenRemitoCompra ocrc 

                                            where 
                                                    -- y con el item de la orden
                                                    ocrc.oci_id = oci.oci_id
                                                and 
                                                    -- Ahora vinculo este item con el item de la factura
                                                    ocrc.rci_id = rci.rci_id)

            order by nroDoc, fecha 

        end

      end else begin -- 3: if Aplicaciones Posibles Facturas

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 4: Aplicaciones Ordenes de Compra
        if @@tipo = 4 begin

            select  
                          oci.oci_id,                                    -- Item
                          oci.pr_id,                                    -- Producto

                          pci.pci_id,                                    -- Orden
                          pcoc_id             as vinc_id,                -- Id Aplicacion

                          pcoc_cantidad       as Aplicado,              -- Aplicacion

                          doc_nombre,                                    --  Datos del item de la devolucion
                          pc_nrodoc            as nrodoc,                --
                          pc_fecha            as Fecha,                  --
                          pci_pendiente        as Pendiente,              --

                          pci_orden            as orden                  --
                          
            from 

              -- Items de la orden de compra             tabla vinculacion                         
              OrdenCompraItem oci  inner join PedidoOrdenCompra pcoc   on oci.oci_id   = pcoc.oci_id
                                   inner join PedidoCompraItem pci     on pcoc.pci_id  = pci.pci_id
                                   inner join PedidoCompra pc          on pci.pc_id    = pc.pc_id
                                   inner join Documento doc            on pc.doc_id    = doc.doc_id
            where
                      oci.oc_id = @@oc_id    -- solo items de la devolucion solicitada
    
            order by nrodoc, fecha 

      
        end else begin -- 4: if Aplicaciones Pedidos de Compra

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 5: Aplicaciones Posibles Pedidos de Compra
          if @@tipo = 5 begin

                select  distinct
                              0                   as oci_id,      -- Item
                              oci.pr_id,                          -- Producto
  
                              pci_id,                              -- Pedidos de Compra
                              0                   as vinc_id,      -- Id Aplicacion
  
                              0                   as Aplicado,    -- Aplicacion
  
                              doc_nombre,                          -- Datos del documento
                              pc_nrodoc            as nrodoc,      --
                              pc_fecha            as Fecha,        --
                              pci.pci_pendiente    as Pendiente,    --
  
                              pci.pci_orden        as orden        --
                              
                from 
                    -- Items del pedido
                    OrdenCompraItem oci  inner join OrdenCompra oc         on oci.oc_id = oc.oc_id

                                                  -- Ahora vinculo con los items de pedidos que posean el mismo
                                                  -- producto que el item de la orden de compra
                                         inner join PedidoCompraItem pci  on oci.pr_id = pci.pr_id

                                         inner join PedidoCompra pc        on     pci.pc_id  = pc.pc_id
                                                                            and pc.doct_id = 6
                                                                            and pc.est_id  <> 7

                                         inner join Documento doc         on pc.doc_id = doc.doc_id
  
                where
                            oci.oc_id = @@oc_id

                        -- Empresa
                        and doc.emp_id = @@emp_id

                        -- Tiene que haber pendiente en el item del pedido
                        and pci.pci_pendiente > 0

                        -- El 'Pedido Compra item' no tiene que estar vinculado 
                        -- con ningun item de esta orden de compra
                        --
                                          -- Busco que no exista en la tabla 
                                          -- de vinculacion algun vinculo entre
                                          -- el item del pedido y el de la orden de compra
                                          --
                        and not exists(select * 
                                          from PedidoOrdenCompra pcoc 

                                            where 
                                                    -- Item de la orden de compra
                                                    pcoc.oci_id = oci.oci_id
                                                and 
                                                    -- Item del pedido
                                                    pcoc.pci_id = pci.pci_id)


                order by nroDoc, fecha 
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 5: Aplicaciones Posibles Pedidos de Compra
          end -- 5: Else Aplicaciones Posibles Pedidos de Compra
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 4: Aplicaciones Pedidos de Compra
        end -- 4: Else Aplicaciones Pedidos de Compra
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 3: Aplicaciones Posibles Facturas
      end -- 3: Else Aplicaciones Posibles Facturas
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 2: Aplicaciones Facturas
    end -- 2: Else Aplicaciones Facturas
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 1: Items
  end -- 1: Else Items
end

go

