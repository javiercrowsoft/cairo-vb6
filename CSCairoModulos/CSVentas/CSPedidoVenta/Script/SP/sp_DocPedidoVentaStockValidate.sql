if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaStockValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaStockValidate]

/*

 select * from pedidoventa
  
  declare @bstock smallint
  exec sp_DocPedidoVentaStockValidate 7, @bstock out
  select @bstock

*/

go
create procedure sp_DocPedidoVentaStockValidate (
  @@pv_id       int,
  @@bStock      smallint out
)
as

begin

  set nocount on

  declare @pr_id                   int
  declare @pvi_pendiente           decimal(18,6)
  declare @pr_id_kit               int
  declare @cantidad               decimal(18,6)

/*
    1) Voy a ver si hay stock para cada uno de los items del pedido de venta

        Lo mas complicado es la existencia de Kits, ya que estos consumen productos que
        ya estan en un kit, y productos que pueden ser utilizados para producir nuevos kits.

        Esto significa que a los kits debo descomponerlos en sus items y analizar cuanto stock
        demandan. Primero debo comprometer el stock asociado al kit y luego si no alcanza
        debo comprometer los items del kit.

        Para aquellos kits que estan compuestos por otros kits, debo desagregarlo en sus items
        solo hasta el nivel que permita controlar stock por items, ya que hay kits que llevan un
        proceso de preparacion de varios dias y por tanto no importa si existen componentes para
        producirlo.

    1.1) Los divido en dos grupos A) los que no son Kits y B) los que son Kits
    1.2) Agrupo todos los productos ambos grupos por pr_id
    1.3) Los del grupo A son los mas simples, si no hay stock para estos no analizo mas

    1.4) Con los kits tengo que descomponerlos, ver cuantos kits hay preparados, y si no alcanza
         debo descontar insumos no asociados a los kits que puedo producir rapidamente.
         Para aquellos insumos que son kits y no controlan stock por items debo tener stock de kits
         ya preparados

    1.5) La demanda de stock es la suma de todos los pendientes de :
              - productos que no son kits 
              - productos que son kits y no hay suficientes kits preparados y controlan stock por item

    1.4) Ahora recorro cada uno de los articulos del grupo B, y pido la info del kit
    1.5) Por cada componente que es kit y permite controlar stock por items voy cargando
         esos items en la tabla temporal
    1.6) Ahora analizo los items del grupo B y listo. Tengo que tener encuenta aquellos items
         que son kits y no permiten controlar stock por items ya que su preparacion es muy
         compleja y lleva varios dias.
*/    

--////////////////////////////////////////////////////////////////////////////////////////////
  -- Obtengo la lista de depositos permitidos
  declare @ram_id_stock    varchar(255)
  select @ram_id_stock = ram_id_stock from PedidoVenta where pv_id = @@pv_id

  declare @depl_id int
  declare @ram_id_DepositoLogico int

  declare @clienteID int
  declare @IsRaiz    tinyint

  exec sp_GetRptId @clienteID out

  exec sp_ArbConvertId @ram_id_stock, @depl_id out, @ram_id_DepositoLogico out

  if @ram_id_DepositoLogico <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_DepositoLogico, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_DepositoLogico, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_DepositoLogico, @clienteID 
    end else 
      set @ram_id_DepositoLogico = 0

  end else begin

    declare @cfg_valor varchar(255)

    -- Tengo que validar segun lo que indique la configuracion de stock
    exec sp_Cfg_GetValor  'Stock-General',
                          'Tipo Control Stock',
                          @cfg_valor out,
                          0
    set @cfg_valor = IsNull(@cfg_valor,0)
  
    -- csEStockFisico
    if convert(int,@cfg_valor) = 4 begin
  
      declare @depf_id int
  
      select @depf_id = depf_id from DepositoLogico where depl_id = @depl_id
  
      insert into rptArbolRamaHoja (rptarb_cliente, rptarb_hojaid, tbl_id)
                            select @clienteID, depl_id, 11 
                            from DepositoLogico 
                            where depf_id = @depf_id
  
      set @depl_id = 0

    end

  end

--////////////////////////////////////////////////////////////////////////////////////////////

  create table #PedidoVtaStock (
                                  pr_id             int,
                                  pr_id_kit          int,
                                  pr_id_kitpadre    int,
                                  pvi_pendiente     decimal(18,6)
                                )
  
  insert into #PedidoVtaStock (pr_id, pr_id_kit, pr_id_kitpadre, pvi_pendiente)
  select 
        pr_id,pr_id_kit,pr_id_kitpadre, sum(pvi_pendiente) 
  from 
        PedidoVentaItemStock i inner join PedidoVenta v on i.pv_id = v.pv_id
  where 
            v.ram_id_stock = @ram_id_stock
  group by 
            pr_id,pr_id_kit,pr_id_kitpadre

  -- Para debug
  -- select p.pr_nombrecompra, s.* from #PedidoVtaStock s inner join Producto p on s.pr_id = p.pr_id

  -- Somos pesismistas
  set @@bStock = 0

  if exists(


                select 
                          -- Para debug
                          -- i.pr_id, pr_nombrecompra , IsNull(sum(stc_cantidad),0), max(i.pvi_pendiente), i.pr_id_kit, i.pr_id_kitpadre
                          i.pr_id
                
                from
                
                      #PedidoVtaStock i left join StockCache s
                
                                      on 
                                            i.pr_id = s.pr_id
                                       and  
                                        (
                                             i.pr_id_kit = s.pr_id_kit 
                                          or (
                                                  i.pr_id_kit is null
                                              and s.pr_id_kit is null
                                             )
                                          or i.pr_id_kitpadre = s.pr_id_kit
                                        )
                
                                  inner join Producto p on i.pr_id = p.pr_id

                  and   ((s.depl_id <> -1 and s.depl_id <> -2) or s.depl_id is null)

                  /* -/////////////////////////////////////////////////////////////////////// */
                  -- Arboles
                  and   (s.depl_id = @depl_id or @depl_id=0 or s.depl_id is null)
                  and   (
                            (exists(select rptarb_hojaid 
                                    from rptArbolRamaHoja 
                                    where
                                         rptarb_cliente = @clienteID
                                    and  tbl_id = 11 -- tbl_id de DepositoLogico
                                    and  (rptarb_hojaid = s.depl_id or s.depl_id is null)
                                   ) 
                             )
                          or 
                             (@ram_id_DepositoLogico = 0)
                         )                                  
                                                            
                  group by
                  
                            i.pr_id, pr_nombrecompra, i.pr_id_kit, i.pr_id_kitpadre
                  
                  having IsNull(sum(stc_cantidad),0) < max(i.pvi_pendiente)

           )
  begin
          -- No hay stock
          return
  end

  -- Si llegue hasta aqui entonces hay stock suficiente
  set @@bStock = 1

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el estado del pedido de venta. sp_DocPedidoVentaStockValidate.', 16, 1)

end