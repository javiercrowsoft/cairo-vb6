if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ClienteHelp2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ClienteHelp2]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

*/
create procedure sp_ClienteHelp2 (
	@@emp_id          int,
  @@us_id           int,
	@@bForAbm         tinyint,
	@@bFilterType     tinyint,
	@@filter 					varchar(255)  = '',
  @@check  					smallint 			= 0,
  @@cli_id          int           = 0,
	@@filter2         varchar(255)  = ''
)
as
begin

	set nocount on

	declare @us_EmpresaEx tinyint
  declare @us_EmpXDpto  tinyint

	select @us_EmpresaEx = us_empresaex, @us_EmpXDpto = us_empxdpto from Usuario where us_id = @@us_id

--/////////////////////////////////////////////////////////////////////////////////////

	declare @filter varchar(255)
	set @filter = @@filter
	exec sp_HelpGetFilter @@bFilterType, @filter out

--/////////////////////////////////////////////////////////////////////////////////////

	if @us_EmpresaEx <> 0 begin

		if @@check <> 0 begin

			select	cli_id,
							cli_nombre				as [Nombre],
							cli_codigo   			as [Codigo]
	
			from Cliente cli
	
			where (cli_nombre = @@filter or cli_codigo = @@filter)
				and (cli_id = @@cli_id or @@cli_id=0)
				and (			@@bForAbm <> 0 
							or (
							        cli.activo <> 0
			  					and (exists (select * from EmpresaCliente where cli_id = cli.cli_id and emp_id = @@emp_id))
									and (exists (select * from UsuarioEmpresa where cli_id = cli.cli_id and us_id = @@us_id) or @@us_id = 1)
									)
						)
	
		end else begin
	
				select top 150
							 cli_id,
		           cli_nombre        as Nombre,
		           cli_codigo        as Codigo,

							 cli_calle + ' ' +
							 cli_callenumero + ' ' +
							 cli_piso + ' ' +
							 cli_depto  + ' - ' +
							
							 cli_localidad + ' - ' +
							 cli_codpostal 		as [Dirección],

							 cli_contacto     as Contacto,
							 ven_nombre       as Vendedor,
							 cli_tel					as [Teléfono],
							 cpg_nombre				as [Cond. Pago],

               cli_razonsocial   as [Razon social],
               cli_cuit          as [CUIT],
        			 case cli_catfiscal
          				when 1 then 'Inscripto'
          				when 2 then 'Exento'
          				when 3 then 'No inscripto'
          				when 4 then 'Consumidor Final'
          				when 5 then 'Extranjero'
          				when 6 then 'Mono Tributo'
          				when 7 then 'Extranjero Iva'
          				when 8 then 'No responsable'
          				when 9 then 'No Responsable exento'
          				when 10 then 'No categorizado'
                  else 'Sin categorizar'
        			 end as [Categoria Fiscal]

				from cliente cli left join condicionpago cpg on cli.cpg_id = cpg.cpg_id
												 left join vendedor ven on cli.ven_id = ven.ven_id
	
				where (cli_codigo like @filter or cli_nombre like @filter
                or cli_razonsocial like @filter
                or cli_cuit like @filter
                or @@filter = ''

								or (cli_calle + ' ' +
									  cli_callenumero + ' ' +
									  cli_piso + ' ' +
									  cli_depto  + ' - ' +
									
									  cli_localidad + ' - ' +
									  cli_codpostal)

										like @filter

								or cli_contacto like @filter
								or cli_tel like @filter
								or ven_nombre like @filter
							)

				and (@@bForAbm <> 0 or (
									(exists (select * from EmpresaCliente where cli_id = cli.cli_id and emp_id = @@emp_id))
							and (exists (select * from UsuarioEmpresa where cli_id = cli.cli_id and us_id = @@us_id) or @@us_id = 1)
		    			and cli.activo <> 0
						))
		end

  end else begin 
    if @us_EmpXDpto <> 0 begin

  		if @@check <> 0 begin
  		
  			select 	cli_id,
  							cli_nombre				as [Nombre],
  							cli_codigo   			as [Codigo]
  	
  			from Cliente cli
  	
  			where (cli_nombre = @@filter or cli_codigo = @@filter)
					and (cli_id = @@cli_id or @@cli_id=0)
					and (			@@bForAbm <> 0 
								or (
			  		    		cli.activo <> 0
			    			and	(exists (select * from EmpresaCliente where cli_id = cli.cli_id and emp_id = @@emp_id))
			          and (exists (select * from DepartamentoCliente dc inner join UsuarioDepartamento ud on dc.dpto_id = ud.dpto_id
			                        where cli_id = cli.cli_id and us_id = @@us_id
			                       ) 
			                or @@us_id = 1
			               )  	
							 ))
  	
  		end else begin
  	
				select top 50
							 cli_id,
		           cli_nombre        as Nombre,
		           cli_codigo        as Codigo,

							 cli_calle + ' ' +
							 cli_callenumero + ' ' +
							 cli_piso + ' ' +
							 cli_depto  + ' - ' +
							
							 cli_localidad + ' - ' +
							 cli_codpostal 		as [Dirección],

							 cli_contacto     as Contacto,
							 ven_nombre       as Vendedor,
							 cli_tel					as [Teléfono],
							 cpg_nombre				as [Cond. Pago],

               cli_razonsocial   as [Razon social],
               cli_cuit          as [CUIT],
        			 case cli_catfiscal
          				when 1 then 'Inscripto'
          				when 2 then 'Exento'
          				when 3 then 'No inscripto'
          				when 4 then 'Consumidor Final'
          				when 5 then 'Extranjero'
          				when 6 then 'Mono Tributo'
          				when 7 then 'Extranjero Iva'
          				when 8 then 'No responsable'
          				when 9 then 'No Responsable exento'
          				when 10 then 'No categorizado'
                  else 'Sin categorizar'
        			 end as [Categoria Fiscal]


				from cliente cli left join condicionpago cpg on cli.cpg_id = cpg.cpg_id
												 left join vendedor ven on cli.ven_id = ven.ven_id
	
				where (cli_codigo like @filter or cli_nombre like @filter
                or cli_razonsocial like @filter
                or cli_cuit like @filter
                or @@filter = ''

								or (cli_calle + ' ' +
									  cli_callenumero + ' ' +
									  cli_piso + ' ' +
									  cli_depto  + ' - ' +
									
									  cli_localidad + ' - ' +
									  cli_codpostal)

										like @filter

								or cli_contacto like @filter
								or cli_tel like @filter
								or ven_nombre like @filter
							)

				and (@@bForAbm <> 0 or (
								 		(exists (select * from EmpresaCliente where cli_id = cli.cli_id and emp_id = @@emp_id))
			          and (exists (select * from DepartamentoCliente dc inner join UsuarioDepartamento ud on dc.dpto_id = ud.dpto_id
			                        where cli_id = cli.cli_id and us_id = @@us_id
			                       ) 
			                or @@us_id = 1
			               )  	
			    			and cli.activo <> 0
						))
  		end		

  	end else begin
  
  		if @@check <> 0 begin
  		
  			select 	cli_id,
  							cli_nombre				as [Nombre],
  							cli_codigo   			as [Codigo]
  	
  			from Cliente cli
  	
  			where (cli_nombre = @@filter or cli_codigo = @@filter)
					and (cli_id = @@cli_id or @@cli_id=0)
					and (
									@@bForAbm <> 0 
								or 
			    				(
					  		    		cli.activo <> 0
										and	exists (select * from EmpresaCliente where cli_id = cli.cli_id and emp_id = @@emp_id)
									)
							)
  	
  		end else begin
  	
				select top 50
							 cli_id,
		           cli_nombre        as Nombre,
		           cli_codigo        as Codigo,

							 cli_calle + ' ' +
							 cli_callenumero + ' ' +
							 cli_piso + ' ' +
							 cli_depto  + ' - ' +
							
							 cli_localidad + ' - ' +
							 cli_codpostal 		as [Dirección],

							 cli_contacto     as Contacto,
							 ven_nombre       as Vendedor,
							 cli_tel					as [Teléfono],
							 cpg_nombre				as [Cond. Pago],

               cli_razonsocial   as [Razon social],
               cli_cuit          as [CUIT],
        			 case cli_catfiscal
          				when 1 then 'Inscripto'
          				when 2 then 'Exento'
          				when 3 then 'No inscripto'
          				when 4 then 'Consumidor Final'
          				when 5 then 'Extranjero'
          				when 6 then 'Mono Tributo'
          				when 7 then 'Extranjero Iva'
          				when 8 then 'No responsable'
          				when 9 then 'No Responsable exento'
          				when 10 then 'No categorizado'
                  else 'Sin categorizar'
        			 end as [Categoria Fiscal]

				from cliente cli left join condicionpago cpg on cli.cpg_id = cpg.cpg_id
												 left join vendedor ven on cli.ven_id = ven.ven_id
	
				where (cli_codigo like @filter or cli_nombre like @filter
                or cli_razonsocial like @filter
                or cli_cuit like @filter
                or @@filter = ''

								or (cli_calle + ' ' +
									  cli_callenumero + ' ' +
									  cli_piso + ' ' +
									  cli_depto  + ' - ' +
									
									  cli_localidad + ' - ' +
									  cli_codpostal)

										like @filter

								or cli_contacto like @filter
								or cli_tel like @filter
								or ven_nombre like @filter
							)

				and (		@@bForAbm <> 0 
							or 
								(			exists (select * from EmpresaCliente where cli_id = cli.cli_id and emp_id = @@emp_id)
			    				and cli.activo <> 0
								)
						)
  	
  		end		
  	end
  end
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

