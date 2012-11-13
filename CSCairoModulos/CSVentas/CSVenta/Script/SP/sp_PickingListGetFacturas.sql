if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_PickingListGetFacturas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PickingListGetFacturas]

go

-- sp_PickingListGetFacturas 4

create procedure sp_PickingListGetFacturas (

	@@pkl_id int

)
as

begin

	select 		fv_id,
				 		fv_nrodoc,

						fv.cli_id,
						fv.doc_id,

						doc_nombre,

						zon_nombre,

						ven_nombre,

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

						fv_total,

						fv_descrip

		from FacturaVenta fv inner join Cliente cli on fv.cli_id = cli.cli_id
												 inner join Documento doc on fv.doc_id = doc.doc_id

											 -- Sucursal de entrega del cliente
											 --
											 left  join ClienteSucursal clis on 	fv.cli_id = clis.cli_id 
													-- El codigo debe ser "e" para que el sistema la tome 
													-- como sucursal de entrega 
																												and clis_codigo = 'e' 
													-- El documento no debe indicar una sucursal
																												and fv.clis_id is null 

											 -- Sucursal explicitamente indicada en la orden de servicio
											 --
											 left  join ClienteSucursal clispv on fv.clis_id = clispv.clis_id

											 --------------------------------------------------------------------
											 left join Zona zon on cli.zon_id = zon.zon_id
											 left join Vendedor ven on isnull(fv.ven_id,cli.ven_id) = ven.ven_id

		where fv_id in (
											select fvi.fv_id 
											from PedidoFacturaVenta pvfv inner join FacturaVentaItem fvi on pvfv.fvi_id = fvi.fvi_id
																									 inner join PickingListPedidoItem pklpvi on pvfv.pvi_id = pklpvi.pvi_id
											where pklpvi.pkl_id = @@pkl_id
									)	

		order by zon_nombre, ven_nombre

end

go