if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVentaGetAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVentaGetAplic]

go

/*

select * from PresupuestoVenta

sp_DocPresupuestoVentaGetAplic 24,3

*/
create procedure sp_DocPresupuestoVentaGetAplic (
  @@emp_id      int,
  @@prv_id       int,
  @@tipo        tinyint    /* 1: Items
                              2: Aplicaciones Pedidos
                              3: Aplicaciones Posibles Pedidos
                              4: Aplicaciones Packing
                              5: Aplicaciones Posibles Packing
                            */
)
as
begin

  declare @cli_id   int
  declare @doct_id  int

  select @cli_id = cli_id, @doct_id = doct_id from PresupuestoVenta where prv_id = @@prv_id


--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 1: Items
  if @@tipo = 1 begin

    select   
            prvi.prvi_id, 
             prvi.pr_id, 
            pr_nombreventa, 
            prvi_pendiente, 
            prvi_cantidadaremitir - prvi_pendiente  as AplicRemito,
            prvi_orden
  
    from 
          PresupuestoVentaItem prvi   inner join Producto p on prvi.pr_id  = p.pr_id
    where 
          prvi.prv_id = @@prv_id
  
    order by 
            prvi_orden

  end else begin -- 1: if Items
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 2: Aplicaciones Pedidos
    if @@tipo = 2 begin


      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Devoluciones
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if @doct_id = 39 /* Devolucion */ begin

        -- Presupuestos
        select  
                      prvi.prvi_id,                                            -- Item
                      prvi.pr_id,                                              -- Producto

                      0                      as pvi_id,                        -- Pedido
                      prvd.prvi_id          as prvd_id,                        -- Presupuesto de venta
                      0                     as rvi_id,                        -- Remito
                      prvdv_id              as vinc_id,                        -- id Aplicacion

                      prvdv_cantidad         as Aplicado,                      -- Aplicacion

                      doc_nombre,                                              -- Datos del item del Presupuesto de venta
                      prv_nrodoc            as nrodoc,                        --
                      prv_fecha              as Fecha,                          --
                      prvd.prvi_pendiente    as Pendiente,                      --

                      prvd.prvi_orden        as orden                          --
                      
        from 
              -- Items de la devolucion       tabal de vinculacion                               (es una devolucion)
              PresupuestoVentaItem prvi  
                                   inner join PresupuestoDevolucionVenta prvdv   on prvi.prvi_id   = prvdv.prvi_id_devolucion

                                          --  Items de Presupuestos asociados con la devolucion       (es un Presupuesto)
                                   inner join PresupuestoVentaItem prvd          on prvdv.prvi_id_Presupuesto = prvd.prvi_id

                                              -- Datos del documento de los items de Presupuesto asociadso con la devolucion
                                   inner join PresupuestoVenta prv              on prvd.prv_id   = prv.prv_id
                                   inner join Documento doc                     on prv.doc_id    = doc.doc_id
        where
                    prvi.prv_id = @@prv_id    -- solo items de la devolucion solicitada

        order by prvi.prvi_orden

       end else begin

      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      --
      --   Presupuestos
      --
      --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

          -- Devoluciones
              select  
                            prvi.prvi_id,                                -- Item
                            prvi.pr_id,                                  -- Producto

                            0                      as pvi_id,            -- Pedido
                            prvd.prvi_id          as prvd_id,            -- Devolucion
                            prvdv_id              as vinc_id,            -- Id Aplicacion

                            prvdv_cantidad         as Aplicado,          -- Aplicacion

                            doc_nombre,                                  -- Datos del item de la devolucion
                            prv_nrodoc            as nrodoc,            --
                            prv_fecha              as Fecha,              --
                            prvd.prvi_pendiente    as Pendiente,          --

                            prvd.prvi_orden        as orden              --
                            
              from 

                -- Items del Presupuesto             tabla vinculacion                                  (es un Presupuesto)
                PresupuestoVentaItem prvi  inner join PresupuestoDevolucionVenta prvdv   on prvi.prvi_id   = prvdv.prvi_id_Presupuesto

                                            -- Items de Devolucion asociados con el Presupuesto         (es una devolucion)
                                     inner join PresupuestoVentaItem prvd          on prvdv.prvi_id_devolucion = prvd.prvi_id

                                            --
                                     inner join PresupuestoVenta prv               on prvd.prv_id    = prv.prv_id
                                     inner join Documento doc                     on prv.doc_id      = doc.doc_id
              where
                          prvi.prv_id = @@prv_id   -- solo items de la devolucion solicitada
        union

          -- Pedidos
              select  
                            prvi.prvi_id,                                  -- Item
                            prvi.pr_id,                                    -- Producto

                            pvi.pvi_id,                                    -- Pedido
                            0                   as prvd_id,                -- Devolucion
                            prvpv_id            as vinc_id,                -- Id Aplicacion

                            prvpv_cantidad      as Aplicado,              -- Aplicacion

                            doc_nombre,                                    --  Datos del item de la devolucion
                            pv_nrodoc            as nrodoc,                --
                            pv_fecha            as Fecha,                  --
                            pvi_pendienteprv    as Pendiente,              --

                            pvi_orden            as orden                  --
                            
              from 

                -- Items del Presupuesto             tabla vinculacion                         
                PresupuestoVentaItem prvi  
                                     inner join PresupuestoPedidoVenta pvpv   on prvi.prvi_id   = pvpv.prvi_id
                                     inner join PedidoVentaItem pvi            on pvpv.pvi_id    = pvi.pvi_id
                                     inner join PedidoVenta pv                 on pvi.pv_id      = pv.pv_id
                                     inner join Documento doc                 on pv.doc_id      = doc.doc_id
              where
                        prvi.prv_id = @@prv_id    -- solo items de la devolucion solicitada
      
        order by nrodoc, fecha 
      
      end


    end else begin -- 2: if Aplicaciones Pedidos
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 3: Aplicaciones Posibles Pedidos
      if @@tipo = 3 begin

        --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        --
        --   Devoluciones
        --
        --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if @doct_id = 39 /* Devolucion */ begin
  
              select  
                            prvi.prvi_id,                            -- Item
                            prvi.pr_id,                              -- Producto

                            0                      as pvi_id,        -- Pedido
                            prvd.prvi_id          as prvd_id,        -- Presupuesto de venta
                            0                     as rvi_id,        -- Remito
                            0                      as vinc_id,        -- Id Aplicacion


                            0                      as Aplicado,      -- Aplicacion

                            doc_nombre,                              -- Datos del item del Presupuesto
                            rd.prv_nrodoc          as nrodoc,        --
                            rd.prv_fecha           as Fecha,          --
                            prvd.prvi_pendiente    as Pendiente,      --

                            prvd.prvi_orden        as orden          --
                            
              from 
                    -- Items de la devolucion       ' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otros presupuestos de venta
                                                  --' de tipo Presupuesto que puedan vincularce con esta devolucion 
                    PresupuestoVentaItem prvi  
                                         inner join PresupuestoVenta prv       on prvi.prv_id = prv.prv_id

                                                  -- Vinculacion con el cliente y contra presupuestos unicamente
                                         inner join PresupuestoVenta rd        on     prv.cli_id = rd.cli_id 
                                                                                and rd.doct_id = 11
                                                                                and rd.est_id  <> 7

                                         inner join Documento doc         on rd.doc_id = doc.doc_id
      
                                                  -- Ahora vinculo con los items de dichos Presupuestos que posean el mismo
                                                  -- producto que el item de la devolucion
                                         inner join PresupuestoVentaItem prvd   on    prv.prv_id = prvd.prv_id 
                                                                                  and prvi.pr_id = prvd.pr_id

              where
                            prvi.prv_id = @@prv_id

                        -- Empresa
                        and doc.emp_id = @@emp_id

                        -- Tiene que haber pendiente en el item del Presupuesto
                        and prvd.prvi_pendiente > 0  

                        -- El 'Presupuesto venta item' no tiene que estar vinculado 
                        -- con ningun item de esta devolucion
                        --
                                          -- Busco que no exista en la tabla 
                                          -- de vinculacion algun vinculo entre
                                          -- el item de la devolucion y el del Presupuesto
                                          --
                        and not exists(select *                           
                                        from PresupuestoDevolucionVenta prvdv   

                                          where 
                                                    -- Ahora vinculo este item con el item de la devolucion
                                                      prvdv.prvi_id_devolucion = prvi.prvi_id 
                                                  and 
                                                    -- y con el item del Presupuesto
                                                      prvdv.prvi_id_Presupuesto = prvd.prvi_id)

          order by nroDoc, fecha 

        --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        --
        --   Presupuestos
        --
        --////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        end else begin

                select  
                              prvi.prvi_id,                                -- Item
                              prvi.pr_id,                                  -- Producto
  
                              0                        as pvi_id,            -- Pedido
                              prvd.prvi_id            as prvd_id,            -- Devolucion
                              0                        as vinc_id,            -- Id Aplicacion
  
                              0                       as Aplicado,          -- Aplicacion
  
                              doc_nombre,                                    -- Datos del item de la devolucion
                              rd.prv_nrodoc            as nrodoc,            --
                              rd.prv_fecha             as Fecha,              --
                              prvd.prvi_pendiente      as Pendiente,          --
  
                              prvd.prvi_orden          as orden              --
                              
                from 
                    -- Items del Presupuesto         ' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a devoluciones
                                                  --' que puedan vincularce con este Presupuesto
                    PresupuestoVentaItem prvi  
                                         inner join PresupuestoVenta prv       on prvi.prv_id = prv.prv_id

                                                  -- Vinculacion con el cliente y contra devoluciones unicamente
                                         inner join PresupuestoVenta rd        on     prv.cli_id = rd.cli_id 
                                                                                and rd.doct_id = 39
                                                                                and rd.est_id  <> 7

                                         inner join Documento doc             on rd.doc_id = doc.doc_id

                                                  -- Ahora vinculo con los items de dichas devoluciones que posean el mismo
                                                  -- producto que el item del Presupuesto
                                         inner join PresupuestoVentaItem prvd   on     rd.prv_id  = prvd.prv_id 
                                                                                  and prvi.pr_id = prvd.pr_id
  
                where
                            prvi.prv_id = @@prv_id

                        -- Empresa
                        and doc.emp_id = @@emp_id

                        -- Tiene que haber pendiente en el item del Presupuesto
                        and prvd.prvi_pendiente > 0    

                        -- El 'Presupuesto venta item' no tiene que estar vinculado 
                        -- con ningun item de este Presupuesto
                        --
                                          -- Busco que no exista en la tabla 
                                          -- de vinculacion algun vinculo entre
                                          -- el item de la devolucion y el del Presupuesto
                                          --
                        and not exists(select * 
                                          from PresupuestoDevolucionVenta prvdv 

                                            where 
                                                    -- Ahora vinculo este item con el item del Presupuesto
                                                    prvdv.prvi_id_Presupuesto = prvi.prvi_id 
                                                and 
                                                    -- y con el item de la devaluacion
                                                    prvdv.prvi_id_devolucion = prvd.prvi_id)

            union
  
                select  
                              prvi.prvi_id,                              -- Item
                              prvi.pr_id,                                -- Producto
  
                              pvi.pvi_id            as pvi_id,          -- Pedido
                              0                     as prvd_id,          -- Devolucion
                              0                     as vinc_id,          -- Id Devolucion
  
                              0                      as Aplicado,        -- Aplicacion
  
                              doc_nombre,                                -- Datos del item de la Pedido
                              pv_nrodoc              as nrodoc,          --
                              pv_fecha              as Fecha,            --
                              pvi.pvi_pendienteprv  as Pendiente,        --
  
                              pvi.pvi_orden          as orden            --
                              
                from 
                    -- Items del Presupuesto         ' Voy hasta el header para obtener el cliente
                                                  --' y lo uso para hacer un join a otras Pedidos
                                                  --' que puedan vincularce con este Presupuesto
                    PresupuestoVentaItem prvi  
                                         inner join PresupuestoVenta prv   on prvi.prv_id = prv.prv_id

                                                  -- Vinculacion con el cliente y contra pedidos unicamente
                                         inner join PedidoVenta pv        on     prv.cli_id = pv.cli_id
                                                                            and pv.doct_id = 5
                                                                            and pv.est_id <> 7

                                         inner join Documento doc         on pv.doc_id = doc.doc_id

                                                  -- Ahora vinculo con los items de dichas Pedidos que posean el mismo
                                                  -- producto que el item del Presupuesto
                                         inner join PedidoVentaItem pvi  on       pv.pv_id = pvi.pv_id 
                                                                              and prvi.pr_id = pvi.pr_id
  
                where
                            prvi.prv_id = @@prv_id

                        -- Empresa
                        and doc.emp_id = @@emp_id

                        -- Tiene que haber pendiente en el item del Presupuesto
                        and pvi.pvi_pendienteprv > 0
  
                        -- El 'Presupuesto venta item' no tiene que estar vinculado 
                        -- con ningun item de este Presupuesto
                        --
                                          -- Busco que no exista en la tabla 
                                          -- de vinculacion algun vinculo entre
                                          -- el item de la devolucion y el del Presupuesto
                                          --
                        and not exists(select * 
                                          from PresupuestoPedidoVenta pvpv 

                                            where 
                                                    -- y con el item del Presupuesto
                                                    pvpv.prvi_id = prvi.prvi_id
                                                and 
                                                    -- Ahora vinculo este item con el item de la Pedido
                                                    pvpv.pvi_id = pvi.pvi_id)

            order by nroDoc, fecha 

        end

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 3: Aplicaciones Posibles Pedidos
      end -- 3: Else Aplicaciones Posibles Pedidos
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 2: Aplicaciones Pedidos
    end -- 2: Else Aplicaciones Pedidos
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- 1: Items
  end -- 1: Else Items
end

go

