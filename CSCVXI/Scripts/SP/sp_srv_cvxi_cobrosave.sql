if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_cobrosave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_cobrosave]

go
/*

delete ComunidadInternetCobro

sp_srv_cvxi_cobrosave 1, 'HORA230','UPS Atomlux 500 220v 5 salidas c/soft monitoreo Microcentro','89946048','358,90','10025662','Acreditado','09/08/2010','20100809 00:00:00'

*/

create procedure sp_srv_cvxi_cobrosave (

	@@cmi_id           	 int,
	@@cmic_cobroId  		 varchar(50),
	@@nick          		 varchar(255),
	@@articulo           varchar(1000),
	@@articuloid		 		 varchar(255),
	@@cobrado 	         varchar(50),
	@@estado  	         varchar(255),
	@@fechastr           varchar(255),
	@@fecha              datetime,
	@@descrip            varchar(5000)

)

as

begin

	set nocount on

	------------------------------------------------------------------------
	-- Prefijos de comunidades
	--
	-- Los clientes van prefijados segun su comunidad
	--
	declare @nick varchar(50)

	if @@cmi_id = 1 -- 1 es MercadoLibre

			set @nick = '(ML)#'+ @@nick

	else if @@cmi_id = 2 -- 2 es MasOportunidades

			set @nick = '(MO)#'+ @@nick

	declare @cmic_id int
	declare @pr_id int
	declare @pv_id int
	declare @cli_id int

	-- Solo verifico que no este el header
	--
	select @cmic_id = cmic_id	
	from ComunidadInternetCobro
	where cmic_cobroid = @@cmic_cobroid 
		and cmi_id = @@cmi_id
		and cmic_articulo = @@articulo
		and cmic_articuloid = @@articuloid
		and cmic_fecha = @@fecha
		and cmic_nick = @@nick

	select @pr_id = min(pr_id)
	from ComunidadInternetProducto
	where cmipr_codigo = @@articuloid
		and cmi_id = @@cmi_id

	if @pr_id is null begin

		select @pr_id = min(pr_id)
		from ProductoComunidadInternet
		where prcmi_codigo = @@articuloid
			and cmi_id = @@cmi_id

	end

	select @cli_id = min(cli_id)
	from cliente
	where cli_codigocomunidad = @nick

	if @cli_id is not null and @pr_id is not null begin

		select @pv_id = pv.pv_id
		from PedidoVenta pv inner join PedidoVentaItem pvi on pv.pv_id = pvi.pv_id
		where pv.cli_id = @cli_id
			and pvi.pr_id = @pr_id
			and pv_pendiente > 0

	end

	if @cli_id is not null and @pv_id is null begin

		select @pv_id = max(pv.pv_id)
		from PedidoVenta pv inner join PedidoVentaItem pvi on pv.pv_id = pvi.pv_id
		where pv.cli_id = @cli_id
			and pvi.pvi_codigocomunidad = @@articuloid
			and pv_pendiente > 0

		if @pv_id is null begin

			select @pv_id = max(pv.pv_id)
			from PedidoVenta pv inner join PedidoVentaItem pvi on pv.pv_id = pvi.pv_id
			where pv.cli_id = @cli_id
				and pvi.pvi_codigocomunidad = @@articuloid

		end

	end

	if @cmic_id is null begin

		exec sp_dbgetnewid 'ComunidadInternetCobro', 'cmic_id', @cmic_id out, 0

		insert into ComunidadInternetCobro 
																		(	 cmic_id,
																			 cmic_cobroid,
																			 cmic_nick,
																			 cmic_articulo,
																			 cmic_articuloid,
																			 cmic_estado,
																			 cmic_cobrado,
																			 cmic_fechastr,
																			 cmic_fecha,
																			 cmic_descrip,
																			 cmi_id,
																			 cli_id,
																			 pr_id,
																			 pv_id
																		 )

													values			(@cmic_id,
																			 @@cmic_cobroid,
																			 @@nick,
																			 @@articulo,
																			 @@articuloid,
																			 @@estado,
																			 @@cobrado,
																			 @@fechastr,
																			 @@fecha,
																			 @@descrip,
																			 @@cmi_id,
																			 @cli_id,
																			 @pr_id,
																			 @pv_id
																			)
	end

	else

		update ComunidadInternetCobro 
					set 	cmic_estado = @@estado, 
								pv_id = @pv_id,
								pr_id = @pr_id,
								cli_id = @cli_id,
								cmic_descrip = case when @@descrip <> '' then @@descrip else cmic_descrip end

		where cmic_id = @cmic_id
			

	select @cmic_id as cmic_id

end