if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_info_proveedor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_info_proveedor]

-- select * from proveedor
-- sp_info_proveedor 1,7,''

go
create procedure sp_info_proveedor (
	@@us_id     int,
	@@prov_id 	int,
	@@filter    varchar(255)
)
as

begin

	set nocount on 

	create table #info_prov_deudaempresa(prov_id int)
	insert into #info_prov_deudaempresa (prov_id)values(@@prov_id)

	declare @emp_nombre varchar(255)
	declare @sqlstmt    varchar(255)
	declare @field			varchar(255)
	declare @n          smallint
	declare @sn         varchar(10)

	declare @empprovd_creditoctacte 	 decimal(18,6)
	declare @empprovd_creditototal     decimal(18,6)
	declare @empprovd_creditoactivo    decimal(18,6)
	declare @empprovd_deudaorden       decimal(18,6)
	declare @empprovd_deudaremito      decimal(18,6)
	declare @empprovd_deudactacte      decimal(18,6)
	declare @empprovd_deudadoc         decimal(18,6)
	declare @empprovd_deudatotal       decimal(18,6)
	declare @total_sin_doc             decimal(18,6)

	declare c_empprovd insensitive cursor for 

	select  emp_nombre,
					empprovd_creditoctacte, 
					empprovd_creditototal, 
					empprovd_creditoactivo, 
					empprovd_deudaorden,  
					empprovd_deudaremito,
					empprovd_deudactacte, 
					empprovd_deudadoc,    
					empprovd_deudatotal

	from EmpresaProveedorDeuda empprovd inner join Empresa emp on empprovd.emp_id = emp.emp_id
	where prov_id = @@prov_id

	set @n = 0

	open c_empprovd
	fetch next from c_empprovd into @emp_nombre,
																	@empprovd_creditoctacte, 
																	@empprovd_creditototal, 
																	@empprovd_creditoactivo, 
																	@empprovd_deudaorden,  
																	@empprovd_deudaremito,
																	@empprovd_deudactacte, 
																	@empprovd_deudadoc,    
																	@empprovd_deudatotal

	while @@fetch_status = 0
	begin

		set @n  = @n + 1
		set @sn = convert(varchar,@n)

		-- Nombre de la empresa
		--
		set @field = '[Empresa -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_prov_deudaempresa add '+ @field +' varchar(255) not null default('''')'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_prov_deudaempresa set ' + @field + ' = ''' + replace(@emp_nombre,'''','''''') + ''''
		exec (@sqlstmt)

		-- Credito en Cta. Cte.
		set @field = '[Credito Cta. Cte. -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_prov_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_prov_deudaempresa set ' + @field + ' = ' + convert(varchar,@empprovd_creditoctacte)
		exec (@sqlstmt)

		-- Credito Total
		set @field = '[Credito Total -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_prov_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_prov_deudaempresa set ' + @field + ' = ' + convert(varchar,@empprovd_creditototal)
		exec (@sqlstmt)

		-- Deuda en Ordenes de Compra
		set @field = '[Deuda en Ordenes de Compra -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_prov_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_prov_deudaempresa set ' + @field + ' = ' + convert(varchar,@empprovd_deudaorden)
		exec (@sqlstmt)

		-- Deuda en Remido
		set @field = '[Deuda en Remido -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_prov_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_prov_deudaempresa set ' + @field + ' = ' + convert(varchar,@empprovd_deudaremito)
		exec (@sqlstmt)

		-- Deuda en Cta. Cte.
		set @field = '[Deuda en Cta. Cte. -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_prov_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_prov_deudaempresa set ' + @field + ' = ' + convert(varchar,@empprovd_deudactacte)
		exec (@sqlstmt)

		set @total_sin_doc = @empprovd_deudaorden + @empprovd_deudaremito + @empprovd_deudactacte

		-- Deuda (sin documentos)
		set @field = '[Deuda (sin documentos) -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_prov_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_prov_deudaempresa set ' + @field + ' = ' + convert(varchar,@total_sin_doc)
		exec (@sqlstmt)

		-- Deuda en Documentos
		set @field = '[Deuda en Documentos -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_prov_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_prov_deudaempresa set ' + @field + ' = ' + convert(varchar,@empprovd_deudadoc)
		exec (@sqlstmt)

		-- Total
		set @field = '[Total -(-('+ @sn +']'
		set @sqlstmt = 'alter table #info_prov_deudaempresa add '+ @field +' decimal(18,6) not null default(0)'
		exec (@sqlstmt)
		set @sqlstmt = 'update #info_prov_deudaempresa set ' + @field + ' = ' + convert(varchar,@empprovd_deudatotal)
		exec (@sqlstmt)

		fetch next from c_empprovd into @emp_nombre,
																		@empprovd_creditoctacte, 
																		@empprovd_creditototal, 
																		@empprovd_creditoactivo, 
																		@empprovd_deudaorden,  
																		@empprovd_deudaremito,
																		@empprovd_deudactacte, 
																		@empprovd_deudadoc,    
																		@empprovd_deudatotal
	end
	close c_empprovd
	deallocate c_empprovd

select

  '--- Nombre, CUIT, Categoria Fiscal ---'              
																			as [---Denominación---],
	prov_nombre                         as [Nombre],
  prov_razonsocial                    as [Razon social],
  prov_codigo                         as [Codigo],
	prov_cuit														as [CUIT],
	prov_ingresosbrutos                 as [Ingresos brutos],
	case prov_catfiscal            
		when 1 then 'Inscripto'
    when 2 then 'Exento'
    when 3 then 'No inscripto'
    when 4 then 'Consumidor final'
    when 5 then 'Extranjero'
    else 'Sin definir'
	end     
																			as [Categoria fiscal], 
	prov_chequeorden                    as [Cheque a la orden],

  '--- Deuda ---'                     as [---Deuda---],
  cpg_nombre                          as [Condicion de pago],
  prov_deudaorden                     as [Deuda en Ordenes de Compra],
  prov_deudaremito                    as [Deuda en Remitos],
  prov_deudactacte                    as [Deuda en Cta. Cte.],
  prov_deudaorden                     
  + prov_deudaremito                   
  + prov_deudactacte                  as [Total (sin documentos)],
	prov_deudadoc                       as [Deuda en Documentos],
	prov_deudaorden
  + prov_deudaremito                   
  + prov_deudactacte
	+ prov_deudadoc                     as [Total],

  '--- Deuda por Empresa ---'         as [---Deuda por Empresa---],
	de.*,

	'--- Direccion y Telefonos ---'     as [---Direccion---], 
  prov_tel                            as [Telefono],
  prov_fax                            as [Fax],
  prov_calle + ' ' + prov_callenumero 
  + ' ' + prov_piso 
  + ' ' + prov_depto + ' ' +
  isnull(pro_nombre,'')								as [Direccion], 
  '(' + prov_codpostal + ') ' + 
  prov_localidad                      as [Localidad],
	prov_email													as [Email],
	prov_web														as [Web],
  zon_nombre                          as [Zona], 

	'--- Lista de Precios ---'     
																			as [---Compras---],
  lp_nombre														as [Lista de precios],
  ld_nombre														as [Lista de descuentos]


from proveedor prov	left join provincia pro									on prov.pro_id  = pro.pro_id
										left join zona zon											on prov.zon_id  = zon.zon_id
										left join condicionpago cpg							on prov.cpg_id  = cpg.cpg_id
										left join listaprecio lp								on prov.lp_id   = lp.lp_id
										left join listadescuento ld							on prov.ld_id   = ld.ld_id
										left join #info_prov_deudaempresa de    on prov.prov_id = de.prov_id

where prov.prov_id =  @@prov_id
	
end