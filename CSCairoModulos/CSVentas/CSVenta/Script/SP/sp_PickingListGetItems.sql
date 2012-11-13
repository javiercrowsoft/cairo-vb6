if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_PickingListGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PickingListGetItems]

go

/*

select * from PickingList

select * from PickingListPedido where pkl_id = 2
select * from PickingListPedidoItem where pkl_id = 2 order by pv_id

exec sp_PickingListGetItems 2

*/

create procedure sp_PickingListGetItems (

	@@pkl_id 	int

)
as

begin

	set nocount on

	select 
					pklpv.pklpv_id,
					pklpvi_id,
					pklpv.pv_id,
					pklpv_descrip,
					pv_fecha,
					pv_nrodoc,
					pv_total,
					pv_pendiente,
					pv.cli_id,
					pv.est_id   as est_id_pedido,

					'*) ' +
					cli.cli_nombre + ' - ' +

					case
							 when clispv.clis_calle <> '' then

										clispv.clis_calle + ' ' +
										clispv.clis_callenumero + ' ' +
										clispv.clis_piso + ' ' +
										clispv.clis_depto + ' (' +
										clispv.clis_codpostal + ') ' +
										clispv.clis_localidad + ' - ' +
										clispv.clis_tel + ' - ' +
										clispv.clis_contacto

							 when clis.clis_calle <> '' then

										clis.clis_calle + ' ' +
										clis.clis_callenumero + ' ' +
										clis.clis_piso + ' ' +
										clis.clis_depto + ' (' +
										clis.clis_codpostal + ') ' +
										clis.clis_localidad + ' - ' +
										clis.clis_tel + ' - ' +
										clis.clis_contacto

							 else

										cli_calle + ' ' +
										cli_callenumero + ' ' +
										cli_piso + ' ' +
										cli_depto + ' (' +
										cli_codpostal + ') ' +
										cli_localidad + ' - ' +
										cli_tel + ' - ' +
										cli_contacto

					end as cli_nombre,

					pklpv_orden,

					pvi.pvi_id,
				  pvi_cantidadaremitir,
					isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir) as pklpvi_cantidadaremitir,

					case when pr_ventastock <> 0 then convert
																						(
																							decimal(18,2),

																							convert(
																											decimal(18,2),
																											convert(int,isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir)*pr_ventastock+0.0001)
																											)
																							+
																								(	isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir)
																									-		round(1.0 / pr_ventastock,2)
																										* convert(int,isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir)*pr_ventastock+0.0001)
																								) / 100
																						)

							 else 												isnull(pklpvi_cantidadaremitir,pvi_cantidadaremitir)

					end  as cantidad_stock,

					pr_nombreventa,
					pvi.ccos_id,
					ccos_nombre

	from 
				PickingListPedido pklpv 

												 inner join PedidoVenta pv on pklpv.pv_id = pv.pv_id
												 inner join Cliente cli on pv.cli_id = cli.cli_id

												 -- Sucursal de entrega del cliente
												 --
												 left  join ClienteSucursal clis on 	pv.cli_id = clis.cli_id 
														-- El codigo debe ser "e" para que el sistema la tome 
														-- como sucursal de entrega 
																													and clis_codigo = 'e' 
														-- El documento no debe indicar una sucursal
																													and pv.clis_id is null 

												 -- Sucursal explicitamente indicada en la orden de servicio
												 --
											 left  join ClienteSucursal clispv on pv.clis_id = clispv.clis_id

											 left  join PedidoVentaItem pvi on pv.pv_id = pvi.pv_id

											 left  join PickingListPedidoItem pklpvi on 	pklpv.pklpv_id = pklpvi.pklpv_id
																																and pvi.pvi_id = pklpvi.pvi_id

										   left  join Producto pr on pvi.pr_id = pr.pr_id
											 left  join CentroCosto ccos on pvi.ccos_id = ccos.ccos_id

	where 
					pklpv.pkl_id = @@pkl_id				

	order by pklpv_orden, pv_fecha, pv.pv_id

end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

