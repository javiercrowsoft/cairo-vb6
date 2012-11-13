if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_PickingListGetPedidos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PickingListGetPedidos]

go

create procedure sp_PickingListGetPedidos (
	@@fDesde datetime,
	@@fHasta datetime,
	@@cli_id varchar(255),
	@@est_id varchar(255),
	@@ven_id varchar(255),
	@@zon_id varchar(255),

	@@pkl_id int
)
as

begin


	declare @cli_id int
	declare @est_id int
	declare @ven_id int
	declare @zon_id int
	
	declare @ram_id_Cliente int
	declare @ram_id_Estado int
	declare @ram_id_Vendedor int
	declare @ram_id_Zona int
	
	declare @clienteID int
	declare @IsRaiz    tinyint
	
	exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
	exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
	exec sp_ArbConvertId @@ven_id, @ven_id out, @ram_id_Vendedor out
	exec sp_ArbConvertId @@zon_id, @zon_id out, @ram_id_Zona out
	
	exec sp_GetRptId @clienteID out
	
	if @ram_id_Cliente <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
		end else 
			set @ram_id_Cliente = 0
	end
	
	if @ram_id_Estado <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
		end else 
			set @ram_id_Estado = 0
	end

	if @ram_id_Vendedor <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Vendedor, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Vendedor, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Vendedor, @clienteID 
		end else 
			set @ram_id_Vendedor = 0
	end

	if @ram_id_Zona <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Zona, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Zona, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Zona, @clienteID 
		end else 
			set @ram_id_Zona = 0
	end

--///////////////////////////////////////////////////////////////////////////////////////////////

--///////////////////////////////////////////////////////////////////////////////////////////////
	
		select 
						0  as pklpv_id,
						0  as pklpvi_id,
						'' as pklpv_descrip,
						pv.pv_id,
						pv_fecha,
						pv_nrodoc,
						pv_total,
						pv.cli_id,

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

						0 as pklpv_orden,

						pvi.pvi_id,
					  pvi_cantidadaremitir,
						pvi_cantidadaremitir as pklpvi_cantidadaremitir,

						case when pr_ventastock <> 0 then convert
																							(
																								decimal(18,2),
	
																								convert(
																												decimal(18,2),
																												convert(int,pvi_cantidadaremitir*pr_ventastock)
																												)
																								+
																									(	pvi_cantidadaremitir
																										-		round(1.0 / pr_ventastock,2)
																											* convert(int,pvi_cantidadaremitir*pr_ventastock)
																									) / 100
																							)
	
								 else 												pvi_cantidadaremitir
	
						end  as cantidad_stock,
						pr_nombreventa,
						pvi.ccos_id,
						ccos_nombre
	
		from PedidoVenta pv inner join Cliente cli on pv.cli_id = cli.cli_id

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
										   left  join Producto pr on pvi.pr_id = pr.pr_id
											 left  join CentroCosto ccos on pvi.ccos_id = ccos.ccos_id

		where 
					pv.est_id <> 7

			and pv_fecha between @@Fdesde and @@Fhasta

			and not exists(select * from PickingListPedido where pkl_id = @@pkl_id and pv_id = pv.pv_id)
			
	and   (pv.cli_id = @cli_id or @cli_id=0)
	and   (pv.est_id = @est_id or @est_id=0)
	and   (isnull(pv.ven_id,cli.ven_id) = @ven_id or @ven_id=0)
	and   (cli.zon_id = @zon_id or @zon_id=0)
	
	-- Arboles
	and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID	and  tbl_id = 28   and  rptarb_hojaid = pv.cli_id)) or (@ram_id_Cliente = 0))
	and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 4005 and  rptarb_hojaid = pv.est_id)) or (@ram_id_Estado = 0))
	and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 15   and  rptarb_hojaid = isnull(pv.ven_id,cli.ven_id))) or (@ram_id_Vendedor = 0))
	and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and  tbl_id = 8    and  rptarb_hojaid = cli.zon_id)) or (@ram_id_Zona = 0))

	order by cli_nombre, pv_fecha, pv.pv_id
	

end

go