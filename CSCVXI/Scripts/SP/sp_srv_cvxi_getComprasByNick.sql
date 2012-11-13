if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_getComprasByNick]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_getComprasByNick]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_srv_cvxi_getProductoFacturado 1,'VANINALAU','84298294'
-- sp_srv_cvxi_getComprasByNick 1,'VANINALAU','84298294'

create procedure sp_srv_cvxi_getComprasByNick (
	@@cmi_id		int,
	@@nick		 	varchar(255),
	@@articulo	varchar(255)
)
as

set nocount on

begin

	declare @cli_id int
	declare @rvi_id int
	declare @min_fecha datetime

	set @min_fecha = getdate()
	set @min_fecha = dateadd(d,-30,@min_fecha)

	if @@cmi_id = 1 set @@nick = '(ml)#' + @@nick

	select  @cli_id = cli_id
	from Cliente
	where cli_codigocomunidad = @@nick

	if exists (select 1 
							from PedidoFacturaVenta pvfv 
								inner join PedidoVentaItem pvi
									on pvfv.pvi_id = pvi.pvi_id 
								inner join PedidoVenta pv 
									on pvi.pv_id = pv.pv_id 
							where pv.cli_id = @cli_id
								and pv_fecha > @min_fecha
								and pv_cvxi_calificado = 0
						) begin

		select '<b><font color=red>' + cli_codigocomunidad + '</font> ' + cli_nombre + '</b><br>'
					 + convert(varchar,pv_fecha,102) + '   '
           + pv_nrodoc + '<br>'
           + convert(varchar,convert(int,pvi_cantidad)) + ' - Art: '
           + pr_nombreventa + '<br>'
					 + pvi_descrip + '<br>'
					 + convert(varchar,convert(decimal(18,2),pvi_precio*(1+(pvi_ivariporc/100))))
					 + '<br>'
					 + 'codigo articulo ml: ' + @@articulo

		from PedidoVenta pv inner join PedidoVentaItem pvi on pv.pv_id = pvi.pv_id
												inner join Producto pr on pvi.pr_id = pr.pr_id
												inner join Cliente cli on pv.cli_id = cli.cli_id
		where pv.cli_id = @cli_id
			and pv_fecha > @min_fecha
			and pv_cvxi_calificado = 0
		return

	end

	select ''
	return

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go
