if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCompraGetAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCompraGetAplic]

go

/*

select * from PedidoCompra

sp_DocPedidoCompraGetAplic 1,24,3

*/
create procedure sp_DocPedidoCompraGetAplic (
  @@emp_id      int,
  @@pc_id       int,
  @@tipo        tinyint    /* 1: Items
                              2: Aplicaciones Ordenes de Compra
                              3: Aplicaciones Posibles Ordenes de Compra
                            */
)
as
begin

  declare @doct_id  int

  select @doct_id = doct_id from PedidoCompra where pc_id = @@pc_id


--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 1: Items
  if @@tipo = 1 begin

    select   
            pci.pci_id, 
             pci.pr_id, 
            pr_nombreCompra, 
            pci_pendiente, 
            pci_cantidadaremitir - pci_pendiente  as AplicCotizacion,
            pci_orden
  
    from 
          PedidoCompraItem pci   inner join Producto p on pci.pr_id  = p.pr_id
    where 
          pci.pc_id = @@pc_id
  
    order by 
            pci_orden

  end else begin -- 1: if Items
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 2: Aplicaciones Ordenes de Compra
    if @@tipo = 2 begin


      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Devoluciones
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if @doct_id = 23 /* Devolucion */ begin

        -- Pedidos
        select  
                      pci.pci_id,                                              -- Item
                      pci.pr_id,                                              -- Producto

                      0                      as oci_id,                        -- Ordenes de compra
                      pcd.pci_id            as pcd_id,                        -- Pedido de Compra
                      0                     as coti_id,                        -- Cotizacion
                      pcdc_id                as vinc_id,                        -- id Aplicacion

                      pcdc_cantidad         as Aplicado,                      -- Aplicacion

                      doc_nombre,                                              -- Datos del item del pedido de Compra
                      pc_nrodoc              as nrodoc,                        --
                      pc_fecha              as Fecha,                          --
                      pcd.pci_pendiente      as Pendiente,                      --

                      pcd.pci_orden          as orden                          --
                      
        from 
              -- Items de la devolucion       tabal de vinculacion                               (es una devolucion)
              PedidoCompraItem pci  inner join PedidoDevolucionCompra pcdc   on pci.pci_id   = pcdc.pci_id_devolucion

                                          --  Items de pedidos asociados con la devolucion       (es un pedido)
                                    inner join PedidoCompraItem pcd          on pcdc.pci_id_pedido = pcd.pci_id

                                              -- Datos del documento de los items de pedido asociadso con la devolucion
                                    inner join PedidoCompra pc               on pcd.pc_id    = pc.pc_id
                                    inner join Documento doc                 on pc.doc_id    = doc.doc_id
        where
                    pci.pc_id = @@pc_id    -- solo items de la devolucion solicitada

        order by pci.pci_orden

       end else begin

      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Pedidos
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

          -- Devoluciones
              select  
                            pci.pci_id,                                  -- Item
                            pci.pr_id,                                  -- Producto

                            0                      as oci_id,            -- Ordenes de Compra
                            pcd.pci_id            as pcd_id,            -- Devolucion
                            0                     as coti_id,            -- Cotizacion
                            pcdc_id                as vinc_id,            -- Id Aplicacion

                            pcdc_cantidad         as Aplicado,          -- Aplicacion

                            doc_nombre,                                  -- Datos del item de la devolucion
                            pc_nrodoc              as nrodoc,            --
                            pc_fecha              as Fecha,              --
                            pcd.pci_pendiente  as Pendiente,          --

                            pcd.pci_orden          as orden              --
                            
              from 

                -- Items del pedido             tabla vinculacion                                  (es un pedido)
                PedidoCompraItem pci  inner join PedidoDevolucionCompra pcdc   on pci.pci_id   = pcdc.pci_id_pedido

                                            -- Items de Devolucion asociados con el pedido         (es una devolucion)
                                      inner join PedidoCompraItem pcd          on pcdc.pci_id_devolucion = pcd.pci_id

                                            --
                                      inner join PedidoCompra pc               on pcd.pc_id    = pc.pc_id
                                      inner join Documento doc                 on pc.doc_id    = doc.doc_id
              where
                          pci.pc_id = @@pc_id   -- solo items de la devolucion solicitada

        union

          -- Ordenes de Compra
              select  
                            pci.pci_id,                                    -- Item
                            pci.pr_id,                                    -- Producto

                            oci.oci_id,                                    -- Ordenes de Compra
                            0                   as pcd_id,                -- Devolucion
                            0                   as coti_id,                -- Cotizacion
                            pcoc_id              as vinc_id,                -- Id Aplicacion

                            pcoc_cantidad       as Aplicado,              -- Aplicacion

                            doc_nombre,                                    --  Datos del item de la devolucion
                            oc_nrodoc            as nrodoc,                --
                            oc_fecha            as Fecha,                  --
                            oci_pendiente        as Pendiente,              --

                            oci_orden            as orden                  --
                            
              from 

                -- Items del pedido             tabla vinculacion                         
                PedidoCompraItem pci  inner join PedidoOrdenCompra pcoc  on pci.pci_id   = pcoc.pci_id
                                      inner join OrdenCompraItem oci     on pcoc.oci_id  = oci.oci_id
                                      inner join OrdenCompra oc          on oci.oc_id    = oc.oc_id
                                      inner join Documento doc           on oc.doc_id    = doc.doc_id
              where
                        pci.pc_id = @@pc_id    -- solo items de la devolucion solicitada

      union

          -- Cotizaciones
              select  
                            pci.pci_id,                                    -- Item
                            pci.pr_id,                                    -- Producto

                            0                   as oci_id,                -- Ordenes de Compra
                            0                   as pcd_id,                -- Devolucion
                            coti.coti_id,                                  -- Cotizacion
                            pccot_id            as vinc_id,                -- Id Aplicacion

                            pccot_cantidad       as Aplicado,              -- Aplicacion

                            doc_nombre,                                    --  Datos del item de la devolucion
                            cot_nrodoc            as nrodoc,                --
                            cot_fecha              as Fecha,                  --
                            coti_pendiente        as Pendiente,              --

                            coti_orden            as orden                  --
                            
              from 

                -- Items del pedido             tabla vinculacion                         
                PedidoCompraItem pci  inner join PedidoCotizacionCompra pccot  on pci.pci_id       = pccot.pci_id
                                      inner join CotizacionCompraItem coti     on pccot.coti_id   = coti.coti_id
                                      inner join CotizacionCompra cot          on coti.cot_id     = cot.cot_id
                                      inner join Documento doc                  on cot.doc_id      = doc.doc_id
              where
                        pci.pc_id = @@pc_id    -- solo items de la devolucion solicitada
      
        order by nrodoc, fecha 
      
      end


    end else begin -- 2: if Aplicaciones Ordenes de Compra
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 3: Aplicaciones Posibles Ordenes de Compra
      if @@tipo = 3 begin

        --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        --
        --   Devoluciones
        --
        --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if @doct_id = 23 /* Devolucion */ begin
  
              select  
                            pci.pci_id,                              -- Item
                            pci.pr_id,                              -- Producto

                            0                      as oci_id,        -- Ordenes de Compra
                            pcd.pci_id            as pcd_id,        -- Pedido de Compra
                            0                     as coti_id,        -- Cotizacion
                            0                      as vinc_id,        -- Id Aplicacion


                            0                      as Aplicado,      -- Aplicacion

                            doc_nombre,                              -- Datos del item del pedido
                            pd.pc_nrodoc          as nrodoc,        --
                            pd.pc_fecha           as Fecha,          --
                            pcd.pci_pendiente      as Pendiente,      --

                            pcd.pci_orden          as orden          --
                            
              from 
                    -- Items de la devolucion       ' Voy hasta el header para obtener el usuario
                                                  --' y lo uso para hacer un join a otros pedidos de Compra
                                                  --' de tipo pedido que puedan vincularce con esta devolucion 
                    PedidoCompraItem pci  inner join PedidoCompra pc         on pci.pc_id = pc.pc_id

                                                  -- Vinculacion con el usuario y contra pedidos unicamente
                                         inner join PedidoCompra pd        on     pc.us_id    = pd.us_id 
                                                                            and pd.doct_id = 6
                                                                            and pd.est_id  <> 7

                                         inner join Documento doc         on pd.doc_id = doc.doc_id
      
                                                  -- Ahora vinculo con los items de dichos pedidos que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join PedidoCompraItem pcd   on     pc.pc_id  = pcd.pc_id 
                                                                              and pci.pr_id = pcd.pr_id

              where
                            pci.pc_id = @@pc_id

                        -- Empresa
                        and doc.emp_id = @@emp_id

                        -- Tiene que haber pendiente en el item del pedido
                        and pcd.pci_pendiente > 0  

                        -- El 'pedido Compra item' no tiene que estar vinculado 
                        -- con ningun item de esta devolucion
                        --
                                          -- Busco que no exista en la tabla 
                                          -- de vinculacion algun vinculo entre
                                          -- el item de la devolucion y el del pedido
                                          --
                        and not exists(select *                           
                                        from PedidoDevolucionCompra pcdc   

                                          where 
                                                    -- Ahora vinculo este item con el item de la devolucion
                                                      pcdc.pci_id_devolucion = pci.pci_id 
                                                  and 
                                                    -- y con el item del pedido
                                                      pcdc.pci_id_pedido = pcd.pci_id)

          order by nroDoc, fecha 

        --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        --
        --   Pedidos
        --
        --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        end else begin

                select  
                              pci.pci_id,                                  -- Item
                              pci.pr_id,                                  -- Producto
  
                              0                        as oci_id,            -- Ordenes de Compra
                              pcd.pci_id              as pcd_id,            -- Devolucion
                              0                       as coti_id,            -- Cotizacion
                              0                        as vinc_id,            -- Id Aplicacion
  
                              0                       as Aplicado,          -- Aplicacion
  
                              doc_nombre,                                    -- Datos del item de la devolucion
                              pd.pc_nrodoc            as nrodoc,            --
                              pd.pc_fecha             as Fecha,              --
                              pcd.pci_pendiente        as Pendiente,          --
  
                              pcd.pci_orden            as orden              --
                              
                from 
                    -- Items del pedido             ' Voy hasta el header para obtener el usuario
                                                  --' y lo uso para hacer un join a devoluciones
                                                  --' que puedan vincularce con este pedido
                    PedidoCompraItem pci  inner join PedidoCompra pc         on pci.pc_id = pc.pc_id

                                                  -- Vinculacion con el usuario y contra devoluciones unicamente
                                         inner join PedidoCompra pd        on     pc.us_id    = pd.us_id 
                                                                            and pd.doct_id = 23
                                                                            and pd.est_id  <> 7

                                         inner join Documento doc         on pd.doc_id = doc.doc_id

                                                  -- Ahora vinculo con los items de dichas devoluciones que posean el mismo
                                                  -- producto que el item del pedido
                                         inner join PedidoCompraItem pcd   on       pd.pc_id  = pcd.pc_id 
                                                                              and pci.pr_id = pcd.pr_id
  
                where
                            pci.pc_id = @@pc_id

                        -- Empresa
                        and doc.emp_id = @@emp_id

                        -- Tiene que haber pendiente en el item del pedido
                        and pcd.pci_pendiente > 0    

                        -- El 'pedido Compra item' no tiene que estar vinculado 
                        -- con ningun item de este pedido
                        --
                                          -- Busco que no exista en la tabla 
                                          -- de vinculacion algun vinculo entre
                                          -- el item de la devolucion y el del pedido
                                          --
                        and not exists(select * 
                                          from PedidoDevolucionCompra pcdc 

                                            where 
                                                    -- Ahora vinculo este item con el item del pedido
                                                    pcdc.pci_id_pedido = pci.pci_id 
                                                and 
                                                    -- y con el item de la devaluacion
                                                    pcdc.pci_id_devolucion = pcd.pci_id)

            union
  
                select  
                              pci.pci_id,                              -- Item
                              pci.pr_id,                              -- Producto
  
                              oci.oci_id          as oci_id,          -- Ordenes de Compra
                              0                   as pcd_id,          -- Devolucion
                              0                   as coti_id,          -- Cotizacion
                              0                   as vinc_id,          -- Id Devolucion
  
                              0                    as Aplicado,        -- Aplicacion
  
                              doc_nombre,                              -- Datos del item de la Orden de Compra
                              oc_nrodoc            as nrodoc,          --
                              oc_fecha            as Fecha,            --
                              oci.oci_pendiente    as Pendiente,        --
  
                              oci.oci_orden        as orden            --
                              
                from 
                    -- Items del pedido             ' Voy hasta el header para obtener el usuario
                                                  --' y lo uso para hacer un join a otras ordens de compra
                                                  --' que puedan vincularce con este pedido
                    PedidoCompraItem pci  inner join PedidoCompra pc       on pci.pc_id = pc.pc_id

                                                  -- Ahora vinculo con los items de dichas ordenes de compra que posean el mismo
                                                  -- producto que el item del pedido
                                         inner join OrdenCompraItem oci   on  pci.pr_id = oci.pr_id
  
                                                  -- Vinculacion con el usuario y contra pedidos unicamente
                                         inner join OrdenCompra oc        on     oci.oc_id  = oc.oc_id 
                                                                            and oc.doct_id = 35
                                                                            and  oc.est_id  <> 7

                                         inner join Documento doc         on oc.doc_id = doc.doc_id

                where
                            pci.pc_id = @@pc_id

                        -- Empresa
                        and doc.emp_id = @@emp_id

                        -- Tiene que haber pendiente en el item del pedido
                        and oci.oci_pendiente > 0
  
                        -- El 'pedido Compra item' no tiene que estar vinculado 
                        -- con ningun item de este pedido
                        --
                                          -- Busco que no exista en la tabla 
                                          -- de vinculacion algun vinculo entre
                                          -- el item de la devolucion y el del pedido
                                          --
                        and not exists(select * 
                                          from PedidoOrdenCompra pcoc 

                                            where 
                                                    -- y con el item del pedido
                                                    pcoc.pci_id = pci.pci_id
                                                and 
                                                    -- Ahora vinculo este item con el item de la ordenes de compra
                                                    pcoc.oci_id = oci.oci_id)

          union

                select  
                              pci.pci_id,                              -- Item
                              pci.pr_id,                              -- Producto
  
                              0                    as oci_id,          -- Ordenes de Compra
                              0                   as pcd_id,          -- Devolucion
                              coti.coti_id,                              -- Cotizacion
                              0                   as vinc_id,          -- Id Devolucion
  
                              0                    as Aplicado,        -- Aplicacion
  
                              doc_nombre,                              -- Datos del item de la orden de compra
                              cot_nrodoc            as nrodoc,          --
                              cot_fecha             as Fecha,            --
                              coti.coti_pendiente    as Pendiente,        --
  
                              coti.coti_orden        as orden            --
                              
                from 
                    -- Items del pedido             ' Voy hasta el header para obtener el usuario
                                                  --' y lo uso para hacer un join a otras cotizaciones
                                                  --' que puedan vincularce con este pedido
                    PedidoCompraItem pci  inner join PedidoCompra pc         on pci.pc_id = pc.pc_id

                                                  -- Ahora vinculo con los items de dichas cotizaciones que posean el mismo
                                                  -- producto que el item del pedido
                                         inner join CotizacionCompraItem coti   on pci.pr_id   = coti.pr_id
  
                                                  -- Vinculacion con el usuario y contra pedidos unicamente
                                         inner join CotizacionCompra cot        on     coti.cot_id = cot.cot_id 
                                                                                  and cot.doct_id = 37
                                                                                  and cot.est_id  <> 7

                                         inner join Documento doc               on cot.doc_id = doc.doc_id

                where
                            pci.pc_id = @@pc_id

                        -- Empresa
                        and doc.emp_id = @@emp_id

                        -- Tiene que haber pendiente en el item del pedido
                        and coti.coti_pendiente > 0
  
                        -- El 'pedido Compra item' no tiene que estar vinculado 
                        -- con ningun item de este pedido
                        --
                                          -- Busco que no exista en la tabla 
                                          -- de vinculacion algun vinculo entre
                                          -- el item de la devolucion y el del pedido
                                          --
                        and not exists(select * 
                                          from PedidoCotizacionCompra pccot 

                                            where 
                                                    -- y con el item del pedido
                                                    pccot.pci_id = pci.pci_id
                                                and 
                                                    -- Ahora vinculo este item con el item de la orden de compra
                                                    pccot.coti_id = coti.coti_id)

            order by nroDoc, fecha 

        end

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 3: Aplicaciones Posibles Ordenes de Compra
      end -- 3: if Aplicaciones Posibles Ordenes de Compra
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 2: Aplicaciones Ordenes de Compra
    end -- 2: Else Aplicaciones Ordenes de Compra
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 1: Items
  end -- 1: Else Items
end

go

