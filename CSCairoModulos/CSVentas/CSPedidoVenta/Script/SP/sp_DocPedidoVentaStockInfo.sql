if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoVentaStockInfo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoVentaStockInfo]

/*

	 select * from pedidoventaitemstock where pv_id = 8
	
  exec sp_DocPedidoVentaStockInfo 8

delete stockcache
exec sp_docstockcachecreate
select * from stockcache where pr_id=10 and pr_id_kit = 575

*/

go
create procedure sp_DocPedidoVentaStockInfo (
	@@pv_id 			int
)
as

begin

	set nocount on

	declare @pr_id 									int
  declare @pvi_pendiente 					decimal(18,6)
  declare @pr_id_kit 							int
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
    1.6) Ahora anlizo los items del grupo B y listo. Tengo que tener encuenta aquellos items
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
	
	--	exec sp_ArbGetGroups @ram_id_DepositoLogico, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_DepositoLogico, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_DepositoLogico, @clienteID 
		end else 
			set @ram_id_DepositoLogico = 0
	end
--////////////////////////////////////////////////////////////////////////////////////////////

	create table #PedidoVtaStock (
																	pr_id 						int,
																	pr_id_kit					int,
																	pr_id_kitpadre		int,
																	pvi_pendiente     decimal(18,6)
																)
	
	insert into #PedidoVtaStock (pr_id, pr_id_kit, pr_id_kitpadre, pvi_pendiente)
	select 
				pr_id,pr_id_kit,pr_id_kitpadre, sum(pvi_pendiente) 
	from 
				PedidoVentaItemStock i inner join PedidoVenta v on i.pv_id = v.pv_id
	where 
						v.ram_id_stock = @ram_id_stock
			and		exists(select * from PedidoVentaItem vi where vi.pr_id = i.pr_id and  vi.pv_id = @@pv_id)

	group by 
						pr_id,pr_id_kit,pr_id_kitpadre

								select 
													i.pr_id, 
													pr_nombreventa , 
													IsNull(sum(stc_cantidad),0) as [Cantidad en Stock], 
													max(i.pvi_pendiente) as [Cantidad pedido], 
													max(i.pvi_pendiente) - IsNull(sum(stc_cantidad),0) as [Faltante], 
													i.pr_id_kit, 
													i.pr_id_kitpadre
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

                 where i.pr_id_kitpadre is null                                          

									group by
									
														i.pr_id, pr_nombreventa, i.pr_id_kit, i.pr_id_kitpadre
									
									having IsNull(sum(stc_cantidad),0) < max(i.pvi_pendiente)

---------------------
						union
---------------------

								select 
													0 as pr_id, 
													pr_nombreventa, 
													IsNull(sum(stc_cantidad),0) as [Cantidad en Stock], 
													1 as [Cantidad pedido], 
													1 - IsNull(sum(stc_cantidad),0) as [Faltante], 
													0 as pr_id_kit, 
													i.pr_id_kitpadre
								
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
								
																	inner join Producto p on i.pr_id_kitpadre = p.pr_id

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

                 where i.pr_id_kitpadre is not null                                          

									group by
									
													 i.pr_id_kitpadre, pr_nombreventa
									
									having IsNull(sum(stc_cantidad),0) < max(i.pvi_pendiente)

	return
ControlError:

	raiserror ('Ha ocurrido un error al actualizar el estado del pedido de venta. sp_DocPedidoVentaStockInfo.', 16, 1)

end