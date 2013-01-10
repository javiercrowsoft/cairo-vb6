if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaGetStockItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaGetStockItem]

/*
  
  exec sp_DocPedidoVentaGetStockItem 0,168,'1'

*/

go
create procedure [dbo].[sp_DocPedidoVentaGetStockItem] (
  @@pv_id           int,
  @@pr_id           int,
  @@ram_id_stock    varchar(255)
)
as

begin

  set nocount on

  --////////////////////////////////////////////////////////////////////////////////////////////
  -- Obtengo la lista de depositos permitidos
  select @@ram_id_stock = ram_id_stock from PedidoVenta where pv_id = @@pv_id

  declare @depl_id int
  declare @ram_id_DepositoLogico int
  declare @ventastock decimal(18,6)

  select @ventastock = pr_ventastock from producto where pr_id = @@pr_id

  if isnull(@ventastock,0) = 0.0 set @ventastock = 1

  declare @clienteID int
  declare @IsRaiz    tinyint

  exec sp_GetRptId @clienteID out

  exec sp_ArbConvertId @@ram_id_stock, @depl_id out, @ram_id_DepositoLogico out

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
      set @ram_id_DepositoLogico = 1 -- para simular una rama y que funcione el filtro

    end

  end

  declare @cantidad_stock decimal(18,6)

  select @cantidad_stock = sum(stc_cantidad) 
  from StockCache s
  where pr_id = @@pr_id
    and   (s.depl_id = @depl_id or @depl_id=0 or s.depl_id is null)
    and   (
              (exists(select rptarb_hojaid 
                      from rptArbolRamaHoja 
                      where
                           rptarb_cliente = @clienteID
                      and  tbl_id = 11
                      and  (rptarb_hojaid = s.depl_id or s.depl_id is null)
                     ) 
               )
            or 
               (@ram_id_DepositoLogico = 0)
           )                                  

  declare @cantidad_pedida decimal(18,6)

  select @cantidad_pedida = sum(pvi_pendiente)
  from PedidoVentaItemStock
  where pr_id = @@pr_id
    and pv_id <> @@pv_id

  select  isnull(@cantidad_stock/@ventastock,0) - isnull(@cantidad_pedida,0)   as stock,
          isnull(@cantidad_stock/@ventastock,0)                                as stock_real,
          isnull(@cantidad_pedida,0)                                          as pedidos
          
  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el estado del pedido de venta. sp_DocPedidoVentaGetStockItem.', 16, 1)

end
GO