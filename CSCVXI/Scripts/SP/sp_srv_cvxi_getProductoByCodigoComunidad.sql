SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

-- sp_srv_cvxi_getProductoByCodigoComunidad 1,'109937576'
-- sp_srv_cvxi_getProductoByCodigoComunidad 1, '107469083'
-- sp_srv_cvxi_getProductoByCodigoComunidad 1, '109629944'

ALTER  procedure sp_srv_cvxi_getProductoByCodigoComunidad (
	@@cmi_id			int,
	@@articuloId 	varchar(255)
)
as

set nocount on

begin

	declare @pr_id int
	declare @nombre_comunidad varchar(5000)

	select @nombre_comunidad = isnull(cmipr_nombre,''), 
				 @pr_id = pr_id
	from ComunidadInternetProducto cpr
	where cmipr_codigo = @@articuloId
		and cmi_id = @@cmi_id

	if @nombre_comunidad = '' begin

		select @pr_id = pr_id
	  from ProductoComunidadInternet 
	  where prcmi_codigo = @@articuloId
		  and cmi_id = @@cmi_id
	
		declare @pvi_id int
	
		if @pr_id is null begin
	
			select @pvi_id = max(pvi_id) from pedidoventaitem where pvi_descrip like '%' + @@articuloId + '%'
	
		end else begin
	
			select @pvi_id = max(pvi_id) from PedidoVentaItem where pr_id = @pr_id and pvi_descrip <> ''
	
			if @pvi_id is null begin
	
				select @pvi_id = max(pvi_id) from pedidoventaitem where pvi_descrip like '%' + @@articuloId + '%'
	
			end
	
		end
		
		select @nombre_comunidad = pvi_descrip from pedidoventaitem where pvi_id = @pvi_id

	end

	declare @i int

	set @i = charindex(@nombre_comunidad,'html')

	if @i > 0 set @nombre_comunidad = substring(@nombre_comunidad,1,@i)

	if @pr_id is null begin

		select 'Articulo Comodin' 		as nombre,
						isnull(@nombre_comunidad,'') 
															as codigo,
					 ''   as alias,
					 ''		as descrip
						
	end else begin
	
		select pr_nombreventa 		as nombre,
					 pr_codigo + '<br>' + pr_nombrefactura 
						+ '<br> ' + isnull(@nombre_comunidad,'') 
															as codigo,
					 pr_aliasweb        as alias,
					 pr_descripcompra		as descrip
						
		from Producto pr
	
		where pr_id = @pr_id

	end

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO