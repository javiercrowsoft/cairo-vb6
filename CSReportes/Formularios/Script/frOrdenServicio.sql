/*
Nombre: Formulario de Orden de Servicio
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frOrdenServicio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frOrdenServicio]

/*

select * from OrdenServicio

frOrdenServicio 1110

*/

go
create procedure frOrdenServicio (

	@@os_id			int

)
as 

begin

--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	select 
			0                 as orden,
      os.*,
      os.os_fecha       as [Fecha Ing.],
      cli.cli_nombre    as Cliente,
			cli.cli_contacto  as Contacto,
      cli.cli_cuit      as Cuit,
      cli.cli_tel       as Telefono,
      est.est_nombre    as Estado,

			osi.*,

			pr_nombrecompra,
			pr_codigo,

			prns.prns_id,
			prns_codigo,
			prns_codigo2,
			prns_codigo3,
			etf_nombre,
			null edi_nombre,
			null oss_valor,

			cli_calle + ' ' +
			cli_callenumero + ' ' +
			cli_piso + ' ' +
			cli_depto  			as calle,

			cli_calle + ' ' +
			cli_callenumero + ' ' +
			cli_piso + ' ' +
			cli_depto  			as direccion,

			clis_calle + ' ' +
			clis_callenumero + ' ' +
			clis_piso + ' ' +
			clis_depto  			as calle_suc,

			clis_calle + ' ' +
			clis_callenumero + ' ' +
			clis_piso + ' ' +
			clis_depto  			as direccion_suc

  from OrdenServicio os inner join Cliente cli on os.cli_id = cli.cli_id
                        inner join Estado est  on os.est_id = est.est_id
												inner join OrdenServicioItem osi on os.os_id = osi.os_id
												inner join Producto pr on osi.pr_id = pr.pr_id

												inner join StockItem sti on 	osi.osi_id  = sti.sti_grupo
																									and	os.st_id		= sti.st_id
																									and sti.sti_ingreso > 0

												inner join ProductoNumeroSerie prns on sti.prns_id = prns.prns_id

												left  join EquipoTipoFalla etf			on osi.etf_id = etf.etf_id
												left  join ClienteSucursal clis 		on os.clis_id = clis.clis_id 
																														or (cli.cli_id = clis.cli_id and clis_codigo = 'e' and os.clis_id is null)

	where os.os_id = @@os_id

union all

	select 
			1                 as orden,
      os.*,
      os.os_fecha       as [Fecha Ing.],
      cli.cli_nombre    as Cliente,
			cli.cli_contacto  as Contacto,
      cli.cli_cuit      as Cuit,
      cli.cli_tel       as Telefono,
      est.est_nombre    as Estado,

			osi.*,

			pr_nombrecompra,
			pr_codigo,

			prns.prns_id,
			prns_codigo,
			prns_codigo2,
			prns_codigo3,
			etf_nombre,

			edi_nombre,
			oss_valor,

			cli_calle + ' ' +
			cli_callenumero + ' ' +
			cli_piso + ' ' +
			cli_depto  			as calle,

			cli_calle + ' ' +
			cli_callenumero + ' ' +
			cli_piso + ' ' +
			cli_depto  			as direccion,

			clis_calle + ' ' +
			clis_callenumero + ' ' +
			clis_piso + ' ' +
			clis_depto  			as calle_suc,

			clis_calle + ' ' +
			clis_callenumero + ' ' +
			clis_piso + ' ' +
			clis_depto  			as direccion_suc

  from OrdenServicio os inner join Cliente cli on os.cli_id = cli.cli_id
                        inner join Estado est  on os.est_id = est.est_id
												inner join OrdenServicioItem osi on os.os_id = osi.os_id
												inner join Producto pr on osi.pr_id = pr.pr_id

												inner join StockItem sti on 	osi.osi_id  = sti.sti_grupo
																									and	os.st_id		= sti.st_id
																									and sti.sti_ingreso > 0

												inner join ProductoNumeroSerie prns on sti.prns_id = prns.prns_id

												left  join OrdenServicioSerie oss		on 	os.os_id 		= oss.os_id
																														and sti.prns_id = oss.prns_id

												left  join EquipoTipoFalla etf			on osi.etf_id = etf.etf_id

												left  join EquipoDetalleItem edi		on oss.edi_id = edi.edi_id
												left  join ClienteSucursal clis 		on (os.clis_id = clis.clis_id)
																														or (cli.cli_id = clis.cli_id and clis_codigo = 'e' and os.clis_id is null)

	where os.os_id = @@os_id

	order by prns.prns_id

end
go