/*---------------------------------------------------------------------
Nombre: Analisis de Pedidos de Venta
---------------------------------------------------------------------*/
/*  

Para testear:

exec [DC_CSC_VEN_0700] 2,'20060101 00:00:00','20070323 00:00:00','0','0','0','0','0','0','0',0,'0','0','0',1,1,0,1,0


*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0700]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0700]
GO

create procedure DC_CSC_VEN_0700 (

  @@us_id    		int,
	@@Fini 		 		datetime,
	@@Ffin 		 		datetime,

  @@pro_id   				varchar(255),
  @@cli_id   				varchar(255),
  @@pr_id           varchar(255),
  @@ven_id	 				varchar(255),
  @@cico_id	 				varchar(255),
  @@ccos_id	   			varchar(255),
  @@suc_id	 				varchar(255),
  @@doct_id	 				int,
  @@doc_id	 				varchar(255),
  @@mon_id	 				varchar(255),
  @@emp_id	 				varchar(255),
	@@bshowMonth     	smallint,
	@@bshowYear				smallint,
	@@mon_id_informe  int,
	@@showChartCant   smallint,
	@@sortByCant			smallint

)as 
begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pro_id   		int
declare @cli_id   		int
declare @pr_id        int
declare @ven_id   		int
declare @cico_id  		int
declare @doc_id   		int
declare @mon_id   		int
declare @emp_id   		int

declare @ccos_id	    int
declare @suc_id	  		int

declare @ram_id_provincia        int
declare @ram_id_cliente          int
declare @ram_id_producto         int
declare @ram_id_vendedor         int
declare @ram_id_circuitoContable int
declare @ram_id_documento        int
declare @ram_id_moneda           int
declare @ram_id_empresa          int
declare @ram_id_centroCosto      int
declare @ram_id_sucursal         int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pro_id,  		 @pro_id out,  			@ram_id_provincia out
exec sp_ArbConvertId @@cli_id,  		 @cli_id out,  			@ram_id_cliente out
exec sp_ArbConvertId @@pr_id,  		 	 @pr_id out,  			@ram_id_producto out
exec sp_ArbConvertId @@ven_id,  		 @ven_id out,  			@ram_id_vendedor out
exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 			@ram_id_circuitoContable out
exec sp_ArbConvertId @@doc_id,  		 @doc_id out,  			@ram_id_documento out
exec sp_ArbConvertId @@mon_id,  		 @mon_id out,  			@ram_id_moneda out
exec sp_ArbConvertId @@emp_id,  		 @emp_id out,  			@ram_id_empresa out
exec sp_ArbConvertId @@ccos_id, 		 @ccos_id out, 			@ram_id_centroCosto out
exec sp_ArbConvertId @@suc_id,       @suc_id out, 			@ram_id_sucursal out

exec sp_GetRptId @clienteID out

if @ram_id_provincia <> 0 begin

--	exec sp_ArbGetGroups @ram_id_provincia, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_provincia, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_provincia, @clienteID 
	end else 
		set @ram_id_provincia = 0
end

if @ram_id_cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cliente, @clienteID 
	end else 
		set @ram_id_cliente = 0
end

if @ram_id_producto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
	end else 
		set @ram_id_producto = 0
end

if @ram_id_vendedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_vendedor, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_vendedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_vendedor, @clienteID 
	end else 
		set @ram_id_vendedor = 0
end

if @ram_id_circuitoContable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitoContable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_circuitoContable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_circuitoContable, @clienteID 
	end else 
		set @ram_id_circuitoContable = 0
end

if @ram_id_documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
	end else 
		set @ram_id_documento = 0
end

if @ram_id_moneda <> 0 begin

--	exec sp_ArbGetGroups @ram_id_moneda, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_moneda, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_moneda, @clienteID 
	end else 
		set @ram_id_moneda = 0
end

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end

if @ram_id_centroCosto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_centroCosto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_centroCosto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_centroCosto, @clienteID 
	end else 
		set @ram_id_centroCosto = 0
end

if @ram_id_sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_sucursal, @clienteID 
	end else 
		set @ram_id_sucursal = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

	create table #pvi ( pv_id int not null, pr_id int not null, 
											pvi_cantidad decimal(18,6) not null default(0), 
											pvi_neto decimal(18,6) not null default(0), 
											maximo decimal(18,6) not null default(0),
											minimo decimal(18,6) not null default(0)
										)
	create table #cotizaciones (mon_id int not null, cotiz decimal(18,6) not null default(0))

	create table #t_pv_dc_csc_ven_0700_1 (pv_id int not null)
	create table #t_pv_dc_csc_ven_0700_2 (pv_id int not null)

	--//////////////////////////////////////////////////////////////////////////////////
	--
	--	PEDIDOS QUE CUMPLEN CON LOS FILTROS
	--
	--//////////////////////////////////////////////////////////////////////////////////	

		declare @fecha_desde 			datetime
		declare @fecha_desde_mes 	datetime
		declare @ultimo_dia       varchar(255)
		declare @dias             int

		set @ultimo_dia = convert(varchar,@@Fini,105)

		if @@bshowYear <> 0	set @fecha_desde = dateadd(yy,-1,@@Ffin)
		else								set @fecha_desde = @@Fini

		if @fecha_desde > @@Fini set @fecha_desde = @@Fini
		set @fecha_desde_mes = dateadd(m,-1,@@Ffin)

		set @dias = day(@fecha_desde)-1
		set @fecha_desde = dateadd(d,-@dias,@fecha_desde)

		insert into #t_pv_dc_csc_ven_0700_1 (pv_id)

		select 
			pv.pv_id

		from 

			pedidoventa pv inner join documento doc on pv.doc_id = doc.doc_id
											inner join cliente   cli on pv.cli_id = cli.cli_id

		where 
		
						  pv_fecha >= @fecha_desde
					and	pv_fecha <= @@Ffin 
		
					and pv.est_id <> 7

					and (
								exists(select * from EmpresaUsuario where emp_id = pv.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
					and (
								exists(select * from UsuarioEmpresa where cli_id = pv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
							)
		
		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (cli.pro_id = @pro_id or @pro_id=0)
		and   (pv.cli_id = @cli_id or @cli_id=0)
		and   (		IsNull(pv.ven_id,0) 	= @ven_id
					 or	IsNull(cli.ven_id,0) 	= @ven_id
					 or @ven_id	=0
					)
		and   (doc.cico_id = @cico_id or @cico_id=0)
		and   (pv.doc_id = @doc_id or @doc_id=0)
		and   (doc.mon_id = @mon_id or @mon_id=0)
		and   (pv.emp_id = @emp_id or @emp_id=0)
		
		and   (pv.ccos_id = @ccos_id or @ccos_id=0)
		and   (pv.suc_id = @suc_id or @suc_id=0)
		
		-- Arboles
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 6 
		                  and  rptarb_hojaid = cli.pro_id
									   ) 
		           )
		        or 
							 (@ram_id_provincia = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 28 
		                  and  rptarb_hojaid = pv.cli_id
									   ) 
		           )
		        or 
							 (@ram_id_cliente = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 15 
                  and  (		rptarb_hojaid = isnull(pv.ven_id,0)
												or	rptarb_hojaid = isnull(cli.ven_id,0)
												)
									   ) 
		           )
		        or 
							 (@ram_id_vendedor = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1016 
		                  and  rptarb_hojaid = doc.cico_id
									   ) 
		           )
		        or 
							 (@ram_id_circuitoContable = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 4001 
		                  and  rptarb_hojaid = pv.doc_id
									   ) 
		           )
		        or 
							 (@ram_id_documento = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 12 
		                  and  rptarb_hojaid = doc.mon_id
									   ) 
		           )
		        or 
							 (@ram_id_moneda = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1018 
		                  and  rptarb_hojaid = pv.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_empresa = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 21 
		                  and  rptarb_hojaid = pv.ccos_id
									   ) 
		           )
		        or 
							 (@ram_id_centroCosto = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1007 
		                  and  rptarb_hojaid = pv.suc_id
									   ) 
		           )
		        or 
							 (@ram_id_sucursal = 0)
					 )

		insert into #t_pv_dc_csc_ven_0700_2 (pv_id)
		select t.pv_id from #t_pv_dc_csc_ven_0700_1 t inner join pedidoventa pv on t.pv_id = pv.pv_id
		where 		pv_fecha >= @@Fini
					and	pv_fecha <= @@Ffin 

	--//////////////////////////////////////////////////////////////////////////////////
	--
	--	COTIZACIONES
	--
	--//////////////////////////////////////////////////////////////////////////////////	

	insert into #cotizaciones (mon_id) select mon_id from moneda
	
	declare monedas insensitive cursor for select mon_id from moneda
	
	declare @cotiz 		decimal(18,6)
	declare @mon_id_c int
	declare @hoy    	datetime
	
	set @hoy = getdate()
	
	open monedas
	
	fetch next from monedas into @mon_id_c
	while @@fetch_status=0
	begin
	
		exec sp_monedaGetCotizacion @mon_id_c, @hoy, 0, @cotiz out
	
		update #cotizaciones set cotiz = @cotiz where mon_id = @mon_id_c
	
		fetch next from monedas into @mon_id_c
	end
	close monedas
	deallocate monedas

	select @mon_id_c=mon_id from moneda where mon_legal <> 0
	update #cotizaciones set cotiz = 1 where mon_id = @mon_id_c

	if @@mon_id_informe <> 0 and @@mon_id_informe <> @mon_id_c begin

		-- llevo todas las cotizaciones a moneda del informe

		select @cotiz = cotiz from #cotizaciones where mon_id = @@mon_id_informe

		if @cotiz = 0 update #cotizaciones set cotiz = 0 where mon_id <> @@mon_id_informe
		else					update #cotizaciones set cotiz = cotiz / @cotiz where mon_id <> @@mon_id_informe

		update #cotizaciones set cotiz = 1 where mon_id = @@mon_id_informe

	end
	

	--//////////////////////////////////////////////////////////////////////////////////
	--
	--	ITEMS DE PEDIDOS QUE CUMPLEN CON LOS FILTROS
	--
	--//////////////////////////////////////////////////////////////////////////////////	

	insert into #pvi (pv_id, pr_id, pvi_cantidad, pvi_neto, maximo, minimo)
	
	select  pvi.pv_id,
					pvi.pr_id,
					sum(pvi_cantidad),
					sum(pvi_neto),
					max(pvi_precio),
					min(pvi_precio)
	
	from pedidoventa pv inner join #t_pv_dc_csc_ven_0700_2 t  on pv.pv_id = t.pv_id
											inner join pedidoventaitem pvi 			on pv.pv_id = pvi.pv_id
	
	where est_id <> 7	
		--and pvi_neto <> 0 
		and pv_fecha >= @@Fini 
		and	pv_fecha <= @@Ffin 

	group by pvi.pv_id,
					 pvi.pr_id

	delete #pvi 
	where pr_id not in
											(	select pr_id 
												from producto pr
												where     (pr.pr_id   = @pr_id    or @pr_id=0)
												    and   (
												    					(exists(select rptarb_hojaid 
												                      from rptArbolRamaHoja 
												                      where
												                           rptarb_cliente = @clienteID
												                      and  tbl_id = 30 
												                      and  rptarb_hojaid = pr.pr_id
												    							   ) 
												               )
												            or 
												    					 (@ram_id_producto = 0)
												    			 )										
											)	
	
	create table #total_mes (cantidad decimal(18,6) not null default(0), 
													 neto 		decimal(18,6) not null default(0), 
													 maximo 	decimal(18,6) not null default(0),
													 minimo 	decimal(18,6) not null default(0)
													)

	if @@bShowMonth <> 0 begin

		insert into #total_mes (cantidad,neto,maximo,minimo)

		-- Total de ventas del mes
		select  
						count(*)												as Cantidad,
						isnull(sum(pv_neto*cotiz),0)		as Neto,
						isnull(max(pv_neto*cotiz),0)		as Maximo,
						isnull(min(pv_neto*cotiz),0)		as Minimo
	
		from pedidoventa pv inner join #t_pv_dc_csc_ven_0700_2 t  on pv.pv_id = t.pv_id
												inner join documento doc on pv.doc_id = doc.doc_id 
												inner join #cotizaciones c on doc.mon_id = c.mon_id
		where est_id <> 7	
			and pv_neto <> 0 
			and pv_fecha >= @fecha_desde_mes 
			and	pv_fecha <= @@Ffin 
	
	end 

	create table #t_dc_csc_ven_0700_select 
										(
											orden_id 		int not null,
											Fecha		 		varchar(255)	not null,
											Grupo1	 		varchar(255)	not null,
											Grupo2	 		varchar(255)	not null,
											Cantidad 		decimal(18,6) not null default(0), 
											Neto 				decimal(18,6) not null default(0), 
											Promedio		decimal(18,6) not null default(0), 
											Maximo 			decimal(18,6) not null default(0),
											Minimo 			decimal(18,6) not null default(0),

											total_cantidad 			decimal(18,6) not null default(0),
											total_neto					decimal(18,6) not null default(0)
										)

	--//////////////////////////////////////////////////////////////////////////////////
	--
	--	TABLA TEMPORAL PARA OBTENER PORCENTAJES
	--
	--//////////////////////////////////////////////////////////////////////////////////	

	insert into #t_dc_csc_ven_0700_select 
									(
											orden_id,
											Fecha,
											Grupo1,
											Grupo2,
											Cantidad,
											Neto,
											Promedio,
											Maximo,
											Minimo
									)

	-- Ventas del ultimo mes
	select 	1													as orden_id,
					convert(varchar,pv_fecha,105)
																		as Fecha,
					''                        as Grupo1,
					''                        as Grupo2,
					count(*)									as Cantidad,
					sum(pv_neto*cotiz)							as Neto,
					sum(pv_neto*cotiz)/count(*)			as Promedio,
					max(pv_neto*cotiz)							as Maximo,
					min(pv_neto*cotiz)							as Minimo
	from pedidoventa pv inner join #t_pv_dc_csc_ven_0700_2 t  on pv.pv_id = t.pv_id
											inner join documento doc on pv.doc_id = doc.doc_id 
											inner join #cotizaciones c on doc.mon_id = c.mon_id
	where est_id <> 7	and pv_neto <> 0 and pv_fecha >= @fecha_desde_mes and	pv_fecha <= @@Ffin 
		and @@bshowMonth <> 0
	group by convert(varchar,pv_fecha,105)
	
	union all
	
	-- Ventas por semana del ultimo mes
	select 	2													as orden_id,
					convert(varchar,datepart(ww,pv_fecha))
																		as Fecha,
					''												as Grupo1,
					''                        as Grupo2,
					count(*)									as Cantidad,
					sum(pv_neto*cotiz)							as Neto,
					sum(pv_neto*cotiz)/count(*)			as Promedio,
					max(pv_neto*cotiz)							as Maximo,
					min(pv_neto*cotiz)							as Minimo
	from pedidoventa pv inner join #t_pv_dc_csc_ven_0700_2 t  on pv.pv_id = t.pv_id
											inner join documento doc on pv.doc_id = doc.doc_id 
											inner join #cotizaciones c on doc.mon_id = c.mon_id
	where est_id <> 7	
		and pv_neto <> 0 
		and pv_fecha >= @fecha_desde_mes 
		and	pv_fecha <= @@Ffin 
		and @@bshowMonth <> 0
	group by convert(varchar,datepart(ww,pv_fecha))
	
	union all
	
	-- Total de ventas del mes
	select  3													as orden_id,
					@ultimo_dia							  as Fecha,
					''												as Grupo1,
					''                        as Grupo2,
					m.cantidad								as Cantidad,
					m.neto							 			as Neto,
					m.neto/m.cantidad					as Promedio,
					m.maximo									as Maximo,
					m.minimo									as Minimo

	from #total_mes m
	where @@bshowMonth <> 0

	union all
	
	-- Ventas del año
	select  4													as orden_id,
					substring(convert(varchar,pv_fecha,102),1,7)
																		as Fecha,
					''												as Grupo1,
					''                        as Grupo2,
					count(*)									as Cantidad,
					sum(pv_neto*cotiz)							as Neto,
					sum(pv_neto*cotiz)/count(*)			as Promedio,
					max(pv_neto*cotiz)							as Maximo,
					min(pv_neto*cotiz)							as Minimo
	
	from pedidoventa pv inner join #t_pv_dc_csc_ven_0700_1 t  on pv.pv_id = t.pv_id
											inner join documento doc on pv.doc_id = doc.doc_id 
											inner join #cotizaciones c on doc.mon_id = c.mon_id
	where est_id <> 7	and pv_neto <> 0 and pv_fecha >= @fecha_desde and	pv_fecha <= @@Ffin 
	group by substring(convert(varchar,pv_fecha,102),1,7)
	
	union all
	
	-- Ventas por cliente
	select  5													as orden_id,
					@ultimo_dia							  as Fecha,
					''                        as Grupo1,
					cli_nombre							  as Grupo2,
					count(*)									as Cantidad,
					sum(pv_neto*cotiz)							as Neto,
					sum(pv_neto*cotiz)/count(*)			as Promedio,
					max(pv_neto*cotiz)							as Maximo,
					min(pv_neto*cotiz)							as Minimo
	from pedidoventa pv inner join #t_pv_dc_csc_ven_0700_2 t  on pv.pv_id = t.pv_id
											inner join documento doc on pv.doc_id = doc.doc_id 
											inner join #cotizaciones c on doc.mon_id = c.mon_id
											inner join cliente cli on pv.cli_id = cli.cli_id
	where est_id <> 7	and pv_neto <> 0 and pv_fecha >= @@Fini and	pv_fecha <= @@Ffin 
	group by cli_nombre
	
	union all
	
	-- Ventas por producto
	select  6													as orden_id,
					@ultimo_dia							  as Fecha,
					''                        as Grupo1,
					pr_nombreventa					  as Grupo2,
					sum(pvi_cantidad)					as Cantidad,
					sum(pvi_neto*cotiz)				as Neto,
					sum(pvi_neto*cotiz)/sum(pvi_cantidad)	
																		as Promedio,
					max(maximo*cotiz)								as Maximo,
					min(minimo*cotiz)								as Minimo
	
	from pedidoventa pv inner join #pvi pvi on pv.pv_id = pvi.pv_id
											inner join producto pr on pvi.pr_id = pr.pr_id
	
			 inner join documento doc on pv.doc_id = doc.doc_id 
			 inner join #cotizaciones c on doc.mon_id = c.mon_id

	where est_id <> 7	
		--and pvi_neto <> 0	
		and pv_fecha >= @@Fini 
		and	pv_fecha <= @@Ffin 
	group by pr_nombreventa
	
	union all
	
	-- Ventas por cliente x producto
	select  7													as orden_id,
					@ultimo_dia  							as Fecha,
					cli_nombre                as Grupo1,
					pr_nombreventa					  as Grupo2,
					sum(pvi_cantidad)					as Cantidad,
					sum(pvi_neto*cotiz)				as Neto,
					sum(pvi_neto*cotiz)/sum(pvi_cantidad)	
																		as Promedio,
					max(maximo*cotiz)								as Maximo,
					min(minimo*cotiz)								as Minimo
	
	from pedidoventa pv inner join #pvi pvi on pv.pv_id = pvi.pv_id
											inner join producto pr on pvi.pr_id = pr.pr_id
											inner join cliente cli on pv.cli_id = cli.cli_id
	
			 inner join documento doc on pv.doc_id = doc.doc_id 
			 inner join #cotizaciones c on doc.mon_id = c.mon_id
	where est_id <> 7	
		--and pvi_neto <> 0	
		and pv_fecha >= @@Fini 
		and	pv_fecha <= @@Ffin 
		and @pr_id = 0
	group by cli_nombre, pr_nombreventa

	union all

	-- Ventas por producto x cliente
	select  8													as orden_id,
					@ultimo_dia  							as Fecha,
					pr_nombreventa            as Grupo1,
					cli_nombre					  		as Grupo2,
					sum(pvi_cantidad)					as Cantidad,
					sum(pvi_neto*cotiz)				as Neto,
					sum(pvi_neto*cotiz)/sum(pvi_cantidad)	
																		as Promedio,
					max(maximo*cotiz)								as Maximo,
					min(minimo*cotiz)								as Minimo
	
	from pedidoventa pv inner join #pvi pvi on pv.pv_id = pvi.pv_id
											inner join producto pr on pvi.pr_id = pr.pr_id
											inner join cliente cli on pv.cli_id = cli.cli_id
	
			 inner join documento doc on pv.doc_id = doc.doc_id 
			 inner join #cotizaciones c on doc.mon_id = c.mon_id
	where est_id <> 7	
		--and pvi_neto <> 0	
		and pv_fecha >= @@Fini 
		and	pv_fecha <= @@Ffin 
	group by pr_nombreventa, cli_nombre

	update #t_dc_csc_ven_0700_select 
		set total_cantidad = (select sum(cantidad) 
													from #t_dc_csc_ven_0700_select t 
													where t.orden_id = #t_dc_csc_ven_0700_select.orden_id)
				,
				total_neto = (select sum(neto)
													from #t_dc_csc_ven_0700_select t 
													where t.orden_id = #t_dc_csc_ven_0700_select.orden_id)
	--//////////////////////////////////////////////////////////////////////////////////
	--
	--	SELECT DE RETORNO
	--
	--//////////////////////////////////////////////////////////////////////////////////	

	if @@sortByCant <> 0 

		select *,
					 case when total_cantidad <> 0 then cantidad / total_cantidad
								else											0
					 end 				as [Porcentaje en Cantidad],
					 case when total_neto <> 0 then neto / total_neto
								else											0
					 end 				as [Porcentaje en Neto]
	
		from #t_dc_csc_ven_0700_select 

		order by orden_id, fecha, grupo1, cantidad desc
	
	else

		select *,
					 case when total_cantidad <> 0 then cantidad / total_cantidad
								else											0
					 end 				as [Porcentaje en Cantidad],
					 case when total_neto <> 0 then neto / total_neto
								else											0
					 end 				as [Porcentaje en Neto]
	
		from #t_dc_csc_ven_0700_select 

		order by orden_id, fecha, grupo1, neto desc
	
end

GO