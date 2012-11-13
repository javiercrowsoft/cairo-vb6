if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_info_cliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_info_cliente]
-- select * from cliente
-- sp_info_cliente 1,8,''

go
create procedure sp_info_cliente (
	@@us_id  	int,
	@@cli_id  int,
	@@filter  varchar(255)
)
as

begin

	set nocount on

	create table #info_cli_deudaempresa(cli_id int)
	insert into #info_cli_deudaempresa (cli_id)values(@@cli_id)

	declare @emp_nombre varchar(255)
	declare @sqlstmt    varchar(255)
	declare @field			varchar(255)
	declare @n          smallint
	declare @sn         varchar(10)

	declare @empclid_creditoctacte 	  decimal(18,6)
	declare @empclid_creditototal     decimal(18,6)
	declare @empclid_creditoactivo    decimal(18,6)
	declare @empclid_deudapedido      decimal(18,6)
	declare @empclid_deudaorden       decimal(18,6)
	declare @empclid_deudaremito      decimal(18,6)
	declare @empclid_deudactacte      decimal(18,6)
	declare @empclid_deudadoc         decimal(18,6)
	declare @empclid_deudatotal       decimal(18,6)
	declare @total_sin_doc            decimal(18,6)

	declare c_empclid insensitive cursor for 

	select  emp_nombre,
					empclid_creditoctacte, 
					empclid_creditototal, 
					empclid_creditoactivo, 
					empclid_deudapedido,  
					empclid_deudaorden,
					empclid_deudaremito,
					empclid_deudactacte, 
					empclid_deudadoc,    
					empclid_deudatotal

	from EmpresaClienteDeuda empclid left join Empresa emp on empclid.emp_id = emp.emp_id 
	where cli_id = @@cli_id

	set @n = 0

	open c_empclid
	fetch next from c_empclid into  @emp_nombre,
																  @empclid_creditoctacte, 
																	@empclid_creditototal, 
																	@empclid_creditoactivo, 
																	@empclid_deudapedido,
																	@empclid_deudaorden,
																	@empclid_deudaremito,
																	@empclid_deudactacte, 
																	@empclid_deudadoc,    
																	@empclid_deudatotal

	while @@fetch_status = 0
	begin

		set @n  = @n + 1
		set @sn = convert(varchar,@n)

		-- Nombre de la empresa
		--
		set @field = '[Empresa -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_cli_deudaempresa add '+ @field +' varchar(255) not null default('''')'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_cli_deudaempresa set ' + @field + ' = ''' + replace(@emp_nombre,'''','''''') + ''''
		exec (@sqlstmt)

		-- Credito en Cta. Cte.
		set @field = '[Credito Cta. Cte. -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_cli_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_cli_deudaempresa set ' + @field + ' = ' + convert(varchar,@empclid_creditoctacte)
		exec (@sqlstmt)

		-- Credito Total
		set @field = '[Credito Total -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_cli_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_cli_deudaempresa set ' + @field + ' = ' + convert(varchar,@empclid_creditototal)
		exec (@sqlstmt)

		-- Deuda en Pedidos
		set @field = '[Deuda en Pedidos -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_cli_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_cli_deudaempresa set ' + @field + ' = ' + convert(varchar,@empclid_deudapedido)
		exec (@sqlstmt)

		-- Deuda en Pedidos
		set @field = '[Deuda en Ordenes de Serv. -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_cli_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_cli_deudaempresa set ' + @field + ' = ' + convert(varchar,@empclid_deudaorden)
		exec (@sqlstmt)

		-- Deuda en Remido
		set @field = '[Deuda en Remido -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_cli_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_cli_deudaempresa set ' + @field + ' = ' + convert(varchar,@empclid_deudaremito)
		exec (@sqlstmt)

		-- Deuda en Cta. Cte.
		set @field = '[Deuda en Cta. Cte. -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_cli_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_cli_deudaempresa set ' + @field + ' = ' + convert(varchar,@empclid_deudactacte)
		exec (@sqlstmt)

		set @total_sin_doc = @empclid_deudapedido + @empclid_deudaremito + @empclid_deudactacte

		-- Deuda (sin documentos)
		set @field = '[Deuda (sin documentos) -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_cli_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_cli_deudaempresa set ' + @field + ' = ' + convert(varchar,@total_sin_doc)
		exec (@sqlstmt)

		-- Deuda en Documentos
		set @field = '[Deuda en Documentos -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_cli_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_cli_deudaempresa set ' + @field + ' = ' + convert(varchar,@empclid_deudadoc)
		exec (@sqlstmt)

		-- Total
		set @field = '[Total -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_cli_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_cli_deudaempresa set ' + @field + ' = ' + convert(varchar,@empclid_deudatotal)
		exec (@sqlstmt)

		fetch next from c_empclid into  @emp_nombre,
																		@empclid_creditoctacte, 
																		@empclid_creditototal, 
																		@empclid_creditoactivo, 
																		@empclid_deudapedido,  
																		@empclid_deudaorden,
																		@empclid_deudaremito,
																		@empclid_deudactacte, 
																		@empclid_deudadoc,    
																		@empclid_deudatotal
	end
	close c_empclid
	deallocate c_empclid

select 

  '--- Nombre, CUIT, Categoria Fiscal ---'              
																			as [---Denominación---],
	cli_nombre                          as [Nombre],
  cli_razonsocial                     as [Razon social],
  cli_codigo                          as [Codigo],
	cli_cuit														as [CUIT],
	case cli_catfiscal            
		when 1 then 'Inscripto'
    when 2 then 'Exento'
    when 3 then 'No inscripto'
    when 4 then 'Consumidor final'
    when 5 then 'Extranjero'
    else 'Sin definir'
	end     
																			as [Categoria fiscal], 
	cli_ingresosbrutos                  as [Ingresos brutos],
	cli_chequeorden                     as [Cheque a la Pedido],

  '--- Deuda ---'                     as [---Deuda---],
  cpg_nombre                          as [Condicion de pago],
  cli_deudapedido                     as [Deuda en Pedidos],
  cli_deudaorden                      as [Deuda en Orden de Serv.],
  cli_deudaremito                     as [Deuda en Remitos],
  cli_deudactacte                     as [Deuda en Cta. Cte.],
  cli_deudapedido                     
  + cli_deudaremito                   
  + cli_deudactacte                   as [Total (sin documentos)],
	cli_deudadoc                        as [Deuda en Documentos],
  cli_deudapedido                     
  + cli_deudaremito                   
  + cli_deudactacte
	+ cli_deudadoc                      as [Total],

  '--- Deuda por Empresa ---'         as [---Deuda por Empresa---],
	de.*,

	'--- Direccion y Telefonos ---'     as [---Direccion---],
  cli_tel                             as [Telefono],
  cli_fax                             as [Fax],
  cli_calle + ' ' +	cli_callenumero 
  + ' ' + cli_piso 
  + ' ' + cli_depto + ' ' +
  isnull(pro_nombre,'')								as [Direccion], 
  '(' + cli_codpostal + ') ' + 
  cli_localidad                       as [Localidad],
	cli_email														as [Email],
	cli_web														  as [Web],
	cli_yahoo														as [Yahoo],
	cli_messanger												as [Messenger],
  zon_nombre                          as [Zona], 

	'--- Lista de Precios, Vendedor y Transporte ---'     
																			as [---Ventas---],
  lp_nombre														as [Lista de precios],
  ld_nombre														as [Lista de descuentos],
  ven_nombre                          as [Vendedor],
	trans_nombre                        as Transporte


from  cliente cli left join provincia pro									on cli.pro_id 	= pro.pro_id
									left join zona zon											on cli.zon_id 	= zon.zon_id
									left join condicionpago cpg   					on cli.cpg_id 	= cpg.cpg_id
									left join listaprecio lp      					on cli.lp_id  	= lp.lp_id
									left join listadescuento ld   					on cli.ld_id  	= ld.ld_id
									left join vendedor ven        					on cli.ven_id 	= ven.ven_id
									left join transporte trans    					on cli.trans_id = trans.trans_id
									left join #info_cli_deudaempresa de     on cli.cli_id   = de.cli_id

where cli.cli_id = @@cli_id
	
end