if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGetPercepcionesForCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGetPercepcionesForCliente]

go

/*
select * from cliente where pro_id = 3 and cli_catfiscal = 1
sp_DocFacturaVentaGetPercepcionesForCliente 8,2

*/
create procedure sp_DocFacturaVentaGetPercepcionesForCliente (
	@@cli_id int,
	@@emp_id int,
	@@fecha  datetime
)
as

begin

	declare @catf_id		int
	declare @pro_id     int

	select  @catf_id = cli_catFiscal,
					@pro_id  = pro_id
	from Cliente
	where cli_id = @@cli_id

	select perc.*,perci.*,perccatf_base
	from Percepcion perc inner join PercepcionItem perci on perc.perc_id = perci.perc_id

											 inner join PercepcionCategoriaFiscal catf on perc.perc_id = catf.perc_id
																																	and catf_id = @catf_id
	where (
								(     exists(select * from PercepcionProvincia 
															where pro_id = @pro_id and perc_id = perc.perc_id)
				
									and exists(select * from Configuracion 
														 where cfg_grupo = 'Ventas-General' 
															 and cfg_aspecto = 'Percepcion'
															 and convert(int, cfg_valor) = perc.perc_id
														)
				
									and not exists(select * from ClientePercepcion 
															where cli_id = @@cli_id and perc_id = perc.perc_id)
				
								)

						or  exists(select * from ClientePercepcion 
												where cli_id = @@cli_id 
													and perc_id = perc.perc_id
													and @@fecha between cliperc_desde and cliperc_hasta
											)
				)
		and exists(select * from PercepcionEmpresa 
								where emp_id = @@emp_id and perc_id = perc.perc_id)

end

GO