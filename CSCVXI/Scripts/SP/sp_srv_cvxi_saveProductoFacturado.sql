if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_saveProductoFacturado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_saveProductoFacturado]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_srv_cvxi_saveProductoFacturado 1,'FMARQUEZ74','79990053'

create procedure sp_srv_cvxi_saveProductoFacturado (
	@@cmi_id		int,
	@@nick		 	varchar(255),
	@@articulo	varchar(255)
)
as

set nocount on

begin

	declare @cli_id int
	declare @pr_id  int
	declare @pvi_id int
	declare @pv_id  int
	declare @rvi_id int
	declare @min_fecha datetime
	declare @update tinyint

	set @min_fecha = getdate()
	set @min_fecha = dateadd(d,-30,@min_fecha)

	set @update = 0

	if @@cmi_id = 1 set @@nick = '(ml)#' + @@nick

	select  @cli_id = cli_id
	from Cliente
	where cli_codigocomunidad = @@nick

	select @pr_id = pr_id
	from ProductoComunidadInternet
	where prcmi_codigo = @@articulo
		and cmi_id = @@cmi_id

	select @pvi_id = min(pvi_id)
	from PedidoVenta pv inner join PedidoVentaItem pvi on pv.pv_id = pvi.pv_id
	where pv.cli_id = @cli_id
		and pvi.pr_id = @pr_id
		and pv_fecha > @min_fecha
		and pv_cvxi_calificado = 0

	select @pv_id = pv_id 
	from PedidoVentaItem 
	where pvi_id = @pvi_id

	if exists (select 1 from PedidoFacturaVenta where pvi_id = @pvi_id) begin

		set @update = 1

	end else begin

		select @rvi_id = rvi_id from PedidoRemitoVenta where pvi_id = @pvi_id

		if exists (select 1 from RemitoFacturaVenta where rvi_id = @rvi_id) begin

			set @update = 1

		end

	end

	if @update = 1 begin

		update PedidoVenta set pv_cvxi_calificado = 1 where pv_id = @pv_id

	end

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go
