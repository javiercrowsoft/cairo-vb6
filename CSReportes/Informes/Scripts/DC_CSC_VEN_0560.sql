/*---------------------------------------------------------------------
Nombre: Ventas por Vendedor, Cliente 
---------------------------------------------------------------------*/
/*  

Para testear:

exec [DC_CSC_VEN_0560] 1,'20070101 00:00:00','20080715 00:00:00','0','0','0','0','0','0','0',3,1


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0560]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0560]

go
create procedure DC_CSC_VEN_0560 (

  @@us_id    		int,
	@@Fini 		 		datetime,
	@@Ffin 		 		datetime,

  @@pro_id   				varchar(255),
  @@cli_id   				varchar(255),
  @@ven_id	 				varchar(255),
  @@cico_id	 				varchar(255),
  @@doc_id	 				varchar(255),
  @@mon_id	 				varchar(255),
  @@emp_id	 				varchar(255),
  @@pr_id	 					varchar(255),

  @@mon_id_informe	int,

	@@bVerGrafico     smallint

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
declare @ven_id   		int
declare @cico_id  		int
declare @doc_id   		int
declare @mon_id   		int
declare @emp_id   		int
declare @pr_id				int

declare @ram_id_provincia        int
declare @ram_id_cliente          int
declare @ram_id_vendedor         int
declare @ram_id_circuitoContable int
declare @ram_id_documento        int
declare @ram_id_moneda           int
declare @ram_id_empresa          int
declare @ram_id_producto  			 int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pro_id,  		 @pro_id out,  			@ram_id_provincia out
exec sp_ArbConvertId @@cli_id,  		 @cli_id out,  			@ram_id_cliente out
exec sp_ArbConvertId @@ven_id,  		 @ven_id out,  			@ram_id_vendedor out
exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 			@ram_id_circuitoContable out
exec sp_ArbConvertId @@doc_id,  		 @doc_id out,  			@ram_id_documento out
exec sp_ArbConvertId @@mon_id,  		 @mon_id out,  			@ram_id_moneda out
exec sp_ArbConvertId @@emp_id,  		 @emp_id out,  			@ram_id_empresa out
exec sp_ArbConvertId @@pr_id, 			 @pr_id out, 				@ram_id_producto out

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

if @ram_id_producto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
	end else 
		set @ram_id_producto = 0
end

create table #t_DC_CSC_VEN_0560 ( ven_id 			int,
																	pa_id     	int,
																	pa_id_orden int not null default(0),
																	cli_id    	int,
																	pr_id				int,
																	orden_id 		int,

																	Codigo 					varchar(255),
																	Vendedor				varchar(255),
																	Empresa					varchar(255),
																	Cliente					varchar(255),
																	Producto      	varchar(255),
																	
																	Neto							decimal(18,6),
																	IVA								decimal(18,6),
																	[Otros Impuestos] decimal(18,6),
																	Total							decimal(18,6),

																	total_vendedor    decimal(18,6) not null default(0),
																	total_pais        decimal(18,6) not null default(0)
																)

create table #t_DC_CSC_VEN_0560_2(ven_id 			int not null,
																	pa_id     	int,
																	pa_id_orden int not null default(0),
																	cli_id    	int not null,
																	pr_id				int not null,
																	orden_id 		int not null,

																	Codigo 		varchar(255) not null,
																	Vendedor	varchar(255) not null,
																	Empresa		varchar(255) not null,
																	Cliente		varchar(255) not null,
																	Producto	varchar(255) not null,
																	
																	Neto							decimal(18,6) not null,
																	IVA								decimal(18,6) not null,
																	[Otros Impuestos] decimal(18,6) not null,
																	Total							decimal(18,6) not null,

																	total_vendedor    decimal(18,6) not null default(0),
																	total_pais        decimal(18,6) not null default(0),

																	mon_id			int not null,
																	Cotizacion  decimal(18,6) not null default(0),
																	Fecha       datetime not null,
																	es_remito		tinyint not null default(0) -- Para pasar de moneda del 
                                                                          -- documento a moneda del informe

																)
insert into #t_DC_CSC_VEN_0560_2
															(
																	ven_id,
																	cli_id,
																	pr_id,
																	orden_id,
																	Codigo,
																	Vendedor,
																	Empresa,
																	Cliente,
																	Producto,
																	
																	Neto,
																	IVA,
																	[Otros Impuestos],
																	Total,
																	mon_id,
																	Cotizacion,
																	Fecha,
																	es_remito
															)
select
    ven_id,
		cli_id,
		pr_id,
		1 											as orden_id,
  	Codigo,
  	Vendedor,
		Empresa,
		Cliente,
		Producto,
		sum (Neto)							as Neto,
		sum (IVA)								as IVA,
  	0 											as [Otros Impuestos],
		sum (Total)							as Total,
		mon_id,
		Cotizacion,
		Fecha,
		es_remito

from 

(
/*- ///////////////////////////////////////////////////////////////////////

REMITOS

/////////////////////////////////////////////////////////////////////// */
    select
        isnull(ven.ven_id,0) 		as ven_id,
				rv.cli_id,
				rvi.pr_id,
    		1 											as orden_id,
      	IsNull(ven_codigo,'')		as Codigo,
      	IsNull(ven_nombre,'Clientes sin vendedor') 
    														as Vendedor,
    		emp_nombre							as Empresa,
    		cli_nombre							as Cliente,
				pr_nombreventa					as Producto,
    		sum (
    			  	case rv.doct_id
    						when 24     then -(rvi_neto - (rvi_neto*rv_descuento1/100)	
																						- ((rvi_neto -(rvi_neto*rv_descuento1/100))*rv_descuento2/100))
    						else              rvi_neto - (rvi_neto*rv_descuento1/100)	
																						- ((rvi_neto -(rvi_neto*rv_descuento1/100))*rv_descuento2/100)
    					end
    				)										as Neto,
    		sum (
    			  	case rv.doct_id
    						when 24     then  -((rvi_ivari+rvi_ivarni) 
																		- ((rvi_ivari+rvi_ivarni)*rv_descuento1/100)
																		- (((rvi_ivari+rvi_ivarni)*rv_descuento1/100)*rv_descuento2/100))
    						else               (rvi_ivari+rvi_ivarni)
																		- ((rvi_ivari+rvi_ivarni)*rv_descuento1/100)
																		- (((rvi_ivari+rvi_ivarni)*rv_descuento1/100)*rv_descuento2/100)

    					end
    				)										as IVA,
    		sum (
    			  	case rv.doct_id
    						when 24     then  -(rvi_importe - (rvi_importe*rv_descuento1/100)	
																						- ((rvi_importe -(rvi_importe*rv_descuento1/100))*rv_descuento2/100))
    						else               rvi_importe - (rvi_importe*rv_descuento1/100)	
																						- ((rvi_importe -(rvi_importe*rv_descuento1/100))*rv_descuento2/100)
    					end
    				)										as Total,
				doc.mon_id,

				-- Necesitamos la cotizacion de los remitos por
				-- que los importes estan expresados en la moneda
				-- del documento, y por ende debemos trasladarlos
				-- a moneda legal y luego a moneda del informe
				--
				rv_cotizacion						as Cotizacion,
				rv_fecha								as Fecha,
				1												as es_remito
    
    from 
    
      RemitoVenta rv  inner join cliente   cli         on rv.cli_id   = cli.cli_id 
                      inner join documento doc         on rv.doc_id   = doc.doc_id
    									inner join documentoTipo doct    on rv.doct_id  = doct.doct_id
                      inner join moneda    mon         on doc.mon_id  = mon.mon_id
                      inner join circuitocontable cico on doc.cico_id = cico.cico_id
                      inner join empresa   emp         on doc.emp_id  = emp.emp_id
               	      left join vendedor   ven         on cli.ven_id  = ven.ven_id

											inner join remitoventaitem rvi    on rv.rv_id    = rvi.rv_id
											inner join producto pr            on rvi.pr_id   = pr.pr_id
    where 
    
    				  rv_fecha >= @@Fini
    			and	rv_fecha <= @@Ffin 
    			and rv.est_id <> 7
    
    			and (
    						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
    					)
    			and (
								exists(select * from UsuarioEmpresa where cli_id = rv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
							)

    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (cli.pro_id  = @pro_id   or @pro_id=0)
    and   (rv.cli_id   = @cli_id   or @cli_id=0)
    and   (cli.ven_id  = @ven_id   or @ven_id=0)
    and   (doc.cico_id = @cico_id  or @cico_id=0)
    and   (rv.doc_id   = @doc_id   or @doc_id=0)
    and   (doc.mon_id  = @mon_id   or @mon_id=0)
    and   (doc.emp_id  = @emp_id   or @emp_id=0)
		and   (rvi.pr_id   = @pr_id    or @pr_id=0)
    
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
                      and  rptarb_hojaid = rv.cli_id
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
                      and  rptarb_hojaid = cli.ven_id
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
                      and  rptarb_hojaid = rv.doc_id
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
                      and  rptarb_hojaid = doc.emp_id
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
		                  and  tbl_id = 30 
		                  and  rptarb_hojaid = rvi.pr_id
									   ) 
		           )
		        or 
							 (@ram_id_producto = 0)
					 )
		
    group by
    
        isnull(ven.ven_id,0),
				rv.cli_id,
				rvi.pr_id,
      	IsNull(ven_codigo,''),
      	IsNull(ven_nombre,'Clientes sin vendedor'),
    		emp_nombre,
    		cli_nombre,
				doc.mon_id,
				rv_cotizacion,
				rv_fecha,
				pr_nombreventa

union all

/*- ///////////////////////////////////////////////////////////////////////

NOTAS DE CREDITO / DEBITO

/////////////////////////////////////////////////////////////////////// */
    select
        isnull(ven.ven_id,0),
				fv.cli_id,
				fvi.pr_id,
    		1 											as orden_id,
      	IsNull(ven_codigo,'')		as Codigo,
      	IsNull(ven_nombre,'Clientes sin vendedor') 
    														as Vendedor,
    		emp_nombre							as Empresa,
    		cli_nombre							as Cliente,
				pr_nombreventa          as Producto,
    		sum (
    			  	case fv.doct_id
    						when 7      then -(fvi_neto - (fvi_neto*fv_descuento1/100)	
																						- ((fvi_neto -(fvi_neto*fv_descuento1/100))*fv_descuento2/100))
    						else              fvi_neto - (fvi_neto*fv_descuento1/100)	
																						- ((fvi_neto -(fvi_neto*fv_descuento1/100))*fv_descuento2/100)
    					end
    				)										as Neto,
    		sum (
    			  	case fv.doct_id
    						when 7      then  -((fvi_ivari+fvi_ivarni) - ((fvi_ivari+fvi_ivarni)*fv_descuento1/100)	
																						- (((fvi_ivari+fvi_ivarni) -((fvi_ivari+fvi_ivarni)*fv_descuento1/100))*fv_descuento2/100))
    						else               (fvi_ivari+fvi_ivarni) - ((fvi_ivari+fvi_ivarni)*fv_descuento1/100)	
																						- (((fvi_ivari+fvi_ivarni) -((fvi_ivari+fvi_ivarni)*fv_descuento1/100))*fv_descuento2/100)
    					end
    				)										as IVA,
    		sum (
    			  	case fv.doct_id
    						when 7      then  -(fvi_importe - (fvi_importe*fv_descuento1/100)	
																						- ((fvi_importe -(fvi_importe*fv_descuento1/100))*fv_descuento2/100))
    						else               fvi_importe - (fvi_importe*fv_descuento1/100)	
																						- ((fvi_importe -(fvi_importe*fv_descuento1/100))*fv_descuento2/100)
    					end
    				)										as Total,
				doc.mon_id,

				-- La cotizacion de las facturas no es necesaria
				-- ya que los importes siempre estan en moneda legal
				-- solo necesitamos saber si tiene cotizacion y por
				-- eso usamos este case, para que luego al agrupar
				-- no se generen muchas filas por la existencia de
				-- diferentes cotizaciones
				--
				case when fv_cotizacion <> 0 then 1
						 else													0
				end											as fv_cotizacion,

				fv_fecha								as Fecha,
				0    										as es_remito

    from 
    
      facturaventa fv inner join cliente   cli         on fv.cli_id   = cli.cli_id 
                      inner join documento doc         on fv.doc_id   = doc.doc_id
    									inner join documentoTipo doct    on fv.doct_id  = doct.doct_id
                      inner join moneda    mon         on fv.mon_id   = mon.mon_id
                      inner join circuitocontable cico on doc.cico_id = cico.cico_id
                      inner join empresa   emp         on doc.emp_id  = emp.emp_id
    
               	      left join vendedor   ven         on cli.ven_id  = ven.ven_id
											inner join facturaventaitem fvi   on fv.fv_id    = fvi.fv_id
											inner join producto pr            on fvi.pr_id   = pr.pr_id
    
    where 
    
    				  fv_fecha >= @@Fini
    			and	fv_fecha <= @@Ffin 
    			and fv.est_id <> 7

          and fv.doct_id in (7,9) -- Notas de credito y debito
    
    			and (
    						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
    					)
    			and (
								exists(select * from UsuarioEmpresa where cli_id = fv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
							)

    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (cli.pro_id  = @pro_id   or @pro_id=0)
    and   (fv.cli_id   = @cli_id   or @cli_id=0)
		and   (cli.ven_id  = @ven_id	 or @ven_id=0)
    and   (doc.cico_id = @cico_id  or @cico_id=0)
    and   (fv.doc_id   = @doc_id   or @doc_id=0)
    and   (fv.mon_id   = @mon_id   or @mon_id=0)
    and   (doc.emp_id  = @emp_id   or @emp_id=0)
		and   (fvi.pr_id   = @pr_id    or @pr_id=0)
    
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
                      and  rptarb_hojaid = fv.cli_id
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
                  		and  rptarb_hojaid = cli.ven_id
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
                      and  rptarb_hojaid = fv.doc_id
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
                      and  rptarb_hojaid = fv.mon_id
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
                      and  rptarb_hojaid = doc.emp_id
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
		                  and  tbl_id = 30 
		                  and  rptarb_hojaid = fvi.pr_id
									   ) 
		           )
		        or 
							 (@ram_id_producto = 0)
					 )
    
    group by
    
        isnull(ven.ven_id,0),
				fv.cli_id,
				fvi.pr_id,
      	IsNull(ven_codigo,''),
      	IsNull(ven_nombre,'Clientes sin vendedor'),
    		emp_nombre,
    		cli_nombre,
				doc.mon_id,
				case when fv_cotizacion <> 0 then 1
						 else													0
				end,
				fv_fecha,
				pr_nombreventa


union all

/*- ///////////////////////////////////////////////////////////////////////

FACTURAS DIRECTAS

/////////////////////////////////////////////////////////////////////// */
    select
        isnull(ven.ven_id,0),
				fv.cli_id,
				fvi.pr_id,
    		1 											as orden_id,
      	IsNull(ven_codigo,'')		as Codigo,
      	IsNull(ven_nombre,'Clientes sin vendedor') 
    														as Vendedor,
    		emp_nombre							as Empresa,
    		cli_nombre							as Cliente,
				pr_nombreventa          as Producto,
    		sum (
    			  	case fv.doct_id
    						when 7      then -(fvi_neto - (fvi_neto*fv_descuento1/100)	
																						- ((fvi_neto -(fvi_neto*fv_descuento1/100))*fv_descuento2/100))
    						else              fvi_neto - (fvi_neto*fv_descuento1/100)	
																						- ((fvi_neto -(fvi_neto*fv_descuento1/100))*fv_descuento2/100)
    					end
    				)										as Neto,
    		sum (
    			  	case fv.doct_id
    						when 7      then  -((fvi_ivari+fvi_ivarni) - ((fvi_ivari+fvi_ivarni)*fv_descuento1/100)	
																						- (((fvi_ivari+fvi_ivarni) -((fvi_ivari+fvi_ivarni)*fv_descuento1/100))*fv_descuento2/100))
    						else               (fvi_ivari+fvi_ivarni) - ((fvi_ivari+fvi_ivarni)*fv_descuento1/100)	
																						- (((fvi_ivari+fvi_ivarni) -((fvi_ivari+fvi_ivarni)*fv_descuento1/100))*fv_descuento2/100)
    					end
    				)										as IVA,
    		sum (
    			  	case fv.doct_id
    						when 7      then  -(fvi_importe - (fvi_importe*fv_descuento1/100)	
																						- ((fvi_importe -(fvi_importe*fv_descuento1/100))*fv_descuento2/100))
    						else               fvi_importe - (fvi_importe*fv_descuento1/100)	
																						- ((fvi_importe -(fvi_importe*fv_descuento1/100))*fv_descuento2/100)
    					end
    				)										as Total,
				doc.mon_id,

				-- La cotizacion de las facturas no es necesaria
				-- ya que los importes siempre estan en moneda legal
				-- solo necesitamos saber si tiene cotizacion y por
				-- eso usamos este case, para que luego al agrupar
				-- no se generen muchas filas por la existencia de
				-- diferentes cotizaciones
				--
				case when fv_cotizacion <> 0 then 1
						 else													0
				end											as fv_cotizacion,

				fv_fecha								as Fecha,
				0    										as es_remito    

    from 
    
      facturaventa fv inner join cliente   cli         on fv.cli_id   = cli.cli_id 
                      inner join documento doc         on fv.doc_id   = doc.doc_id
    									inner join documentoTipo doct    on fv.doct_id  = doct.doct_id
                      inner join moneda    mon         on fv.mon_id   = mon.mon_id
                      inner join circuitocontable cico on doc.cico_id = cico.cico_id
                      inner join empresa   emp         on doc.emp_id  = emp.emp_id
    
               	      left join vendedor   ven         on cli.ven_id  = ven.ven_id
											inner join facturaventaitem fvi   on fv.fv_id    = fvi.fv_id
											inner join producto pr            on fvi.pr_id   = pr.pr_id
    
    where 
    
    				  fv_fecha >= @@Fini
    			and	fv_fecha <= @@Ffin 
    			and fv.est_id <> 7

          and fv.doct_id = 1 -- Facturas de venta

							and not exists(select * from FacturaVentaItem fvi
		                                        inner join RemitoFacturaVenta rfv
																							on 	(	
																												 fv.fv_id  = fvi.fv_id
																					    			 and fv.fv_fecha >= @@Fini
																					    			 and fv.fv_fecha <= @@Ffin 
																					    		 )
																							 	and		fvi.fvi_id = rfv.fvi_id

																						    and   (cli.pro_id  = @pro_id   or @pro_id=0)
																						    and   (fv.cli_id   = @cli_id   or @cli_id=0)
																								and   (cli.ven_id	 = @ven_id	 or @ven_id=0)
																						    and   (doc.cico_id = @cico_id  or @cico_id=0)
																						    and   (fv.doc_id   = @doc_id   or @doc_id=0)
																						    and   (fv.mon_id   = @mon_id   or @mon_id=0)
																						    and   (doc.emp_id  = @emp_id   or @emp_id=0)
																								and   (fvi.pr_id   = @pr_id    or @pr_id=0)
																						    
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
																						                      and  rptarb_hojaid = fv.cli_id
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
																						                  		and  rptarb_hojaid = cli.ven_id
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
																						                      and  rptarb_hojaid = fv.doc_id
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
																						                      and  rptarb_hojaid = fv.mon_id
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
																						                      and  rptarb_hojaid = doc.emp_id
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
																								                  and  tbl_id = 30 
																								                  and  rptarb_hojaid = fvi.pr_id
																															   ) 
																								           )
																								        or 
																													 (@ram_id_producto = 0)
																											 )
														)
    
    			and (
    						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
    					)
    			and (
								exists(select * from UsuarioEmpresa where cli_id = fv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
							)

    /* -///////////////////////////////////////////////////////////////////////
    
    INICIO SEGUNDA PARTE DE ARBOLES
    
    /////////////////////////////////////////////////////////////////////// */
    
    and   (cli.pro_id  = @pro_id   or @pro_id=0)
    and   (fv.cli_id   = @cli_id   or @cli_id=0)
		and   (cli.ven_id	 = @ven_id	 or @ven_id=0)
    and   (doc.cico_id = @cico_id  or @cico_id=0)
    and   (fv.doc_id   = @doc_id   or @doc_id=0)
    and   (fv.mon_id   = @mon_id   or @mon_id=0)
    and   (doc.emp_id  = @emp_id   or @emp_id=0)
		and   (fvi.pr_id   = @pr_id    or @pr_id=0)
    
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
                      and  rptarb_hojaid = fv.cli_id
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
                  		and  rptarb_hojaid = cli.ven_id
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
                      and  rptarb_hojaid = fv.doc_id
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
                      and  rptarb_hojaid = fv.mon_id
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
                      and  rptarb_hojaid = doc.emp_id
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
		                  and  tbl_id = 30 
		                  and  rptarb_hojaid = fvi.pr_id
									   ) 
		           )
		        or 
							 (@ram_id_producto = 0)
					 )
    
    group by
    
        isnull(ven.ven_id,0),
				fv.cli_id,
				fvi.pr_id,
      	IsNull(ven_codigo,''),
      	IsNull(ven_nombre,'Clientes sin vendedor'),
    		emp_nombre,
    		cli_nombre,
				doc.mon_id,
				case when fv_cotizacion <> 0 then 1
						 else													0
				end,
				fv_fecha,
				pr_nombreventa

) as t

    group by
    
        ven_id,
				cli_id,
				pr_id,
      	Codigo,
      	Vendedor,
    		Empresa,
    		Cliente,
				Producto,
				mon_id,
				Cotizacion,
				Fecha,
				es_remito

--////////////////////////////////////////////////////////////////
--
-- Cursor para obtener los valores en moneda del informe
--

	-- Estos los uso para cuando no tengo para una moneda
	-- una cotizacion en un periodo mencionado por comprobantes
	-- de este informe
	--
	declare @error_msg  varchar(5000)
	declare @mon_nombre varchar(255)

	declare @fecha datetime

	declare @mon_id_legal int
	select @mon_id_legal = mon_id from Moneda where mon_legal <> 0
	
	declare @cotizacion decimal(18,6)
	
	if @@mon_id_informe = 0 set @@mon_id_informe = @mon_id_legal

	-- Paso los remitos en moneda extranjera a moneda legal
	--
	-- Recuerden que los remitos estan expresados en moneda del documento
	--
	update #t_DC_CSC_VEN_0560_2 set 

																	Neto	= Neto  * Cotizacion,
																	IVA		= IVA   * Cotizacion,
																	Total	= Total * Cotizacion

	where es_remito <> 0 and Cotizacion <> 0

	-- Actualizo a moneda del informe todos los movimientos
	-- que tienen cotizacion y por ende los importes estan en moneda legal
	--
	-- solo si la moneda del informe no es la moneda legal
	--
	if @@mon_id_informe <> @mon_id_legal begin

			declare c_moneda insensitive cursor for 
				select fecha 
				from #t_DC_CSC_VEN_0560_2 
				where cotizacion <> 0 
				group by fecha
			
			open c_moneda
		
			fetch next from c_moneda into @fecha
			while @@fetch_status = 0
			begin
		
					set @cotizacion = null
	
					select @cotizacion = moni_precio
					from MonedaItem 
					where mon_id = @@mon_id_informe
						and moni_fecha = ( select max(moni_fecha) 
															 from MonedaItem 
															 where mon_id = @@mon_id_informe
															 	 and moni_fecha <= @fecha
															)
	
					if isnull(@cotizacion,0) = 0 begin
	
						select @mon_nombre = mon_nombre from Moneda where mon_id = @@mon_id_informe
		
						set @error_msg =   '@@ERROR_SP:No hay registrada en el sistema, una cotizacion para la fecha ' + convert(varchar,@fecha,105)
		                         + '.'+char(13)+char(13)
		                         + 'Debe utilizar la opcion "Configuración > Tesoreria > Monedas" para registrar la cotizacion del [' + @mon_nombre + '] a esta fecha.'
		
						raiserror ( @error_msg, 
											  16, 
												1)
						return
	
					end
	
					-- Paso de pesos a moneda del informe
					--
					update #t_DC_CSC_VEN_0560_2 set 
	
																		Neto		= Neto  / @cotizacion,
																		IVA			= IVA   / @cotizacion,
																		Total		= Total / @cotizacion
	
					where fecha = @fecha
		
				fetch next from c_moneda into @fecha
			end
		
			close c_moneda
			deallocate c_moneda

	end

	-- Actualizo todos los movimientos sin cotizacion
	-- es decir las facturas y los remitos en moneda legal
	-- y facturas y remitos en moneda extranjera pero sin cotizacion
	-- lo cual no deberia existir pero lo hago por si las moscas
	--
	declare c_moneda insensitive cursor for 
		select mon_id, fecha 
		from #t_DC_CSC_VEN_0560_2 
		where cotizacion = 0 
		group by mon_id, fecha
	
	open c_moneda

	fetch next from c_moneda into @mon_id, @fecha
	while @@fetch_status = 0
	begin

		-- Primero paso a Pesos

			-- Si ya esta en pesos no hago nada
			--
			if @mon_id <> @mon_id_legal begin

				set @cotizacion = null

				select @cotizacion = moni_precio
				from MonedaItem 
				where mon_id = @mon_id
					and moni_fecha = ( select max(moni_fecha) 
														 from MonedaItem 
														 where mon_id = @mon_id
														 	 and moni_fecha <= @fecha
														)

				if isnull(@cotizacion,0) = 0 begin

					select @mon_nombre = mon_nombre from Moneda where mon_id = @mon_id
	
					set @error_msg =   '@@ERROR_SP:No hay registrada en el sistema, una cotizacion para la fecha ' + convert(varchar,@fecha,105)
	                         + '.'+char(13)+char(13)
	                         + 'Debe utilizar la opcion "Configuración > Tesoreria > Monedas" para registrar la cotizacion del [' + @mon_nombre + '] a esta fecha.'
	
					raiserror ( @error_msg, 
										  16, 
											1)
					return

				end

				update #t_DC_CSC_VEN_0560_2 set 

																	Neto		= Neto  * @cotizacion,
																	IVA			= IVA   * @cotizacion,
																	Total		= Total * @cotizacion

				where fecha = @fecha and mon_id = @mon_id and cotizacion = 0

			end

		-- Ahora paso a la moneda del informe		

			-- Si ya esta en moneda del informe no hago nada
			--
			-- Ojo esto es: como yo pase a pesos todos los movimientos
			-- de esta fecha y cotizacion, si la moneda del informe
			-- es pesos entonces no hay que hacer nada
			--
			-- No confundirse al leer el if :)
			--
			if @@mon_id_informe <> @mon_id_legal begin

				set @cotizacion = null

				select @cotizacion = moni_precio
				from MonedaItem 
				where mon_id = @@mon_id_informe
					and moni_fecha = ( select max(moni_fecha) 
														 from MonedaItem 
														 where mon_id = @@mon_id_informe
														 	 and moni_fecha <= @fecha
														)

				if isnull(@cotizacion,0) = 0 begin

					select @mon_nombre = mon_nombre from Moneda where mon_id = @@mon_id_informe
	
					set @error_msg =   '@@ERROR_SP:No hay registrada en el sistema, una cotizacion para la fecha ' + convert(varchar,@fecha,105)
	                         + '.'+char(13)+char(13)
	                         + 'Debe utilizar la opcion "Configuración > Tesoreria > Monedas" para registrar la cotizacion del [' + @mon_nombre + '] a esta fecha.'
	
					raiserror ( @error_msg, 
										  16, 
											1)
					return

				end

				update #t_DC_CSC_VEN_0560_2 set 

																	Neto		= Neto  / @cotizacion,
																	IVA			= IVA   / @cotizacion,
																	Total		= Total / @cotizacion

				where fecha = @fecha and mon_id = @mon_id and cotizacion = 0

			end

		fetch next from c_moneda into @mon_id, @fecha
	end

	close c_moneda
	deallocate c_moneda

--
--////////////////////////////////////////////////////////////////


--////////////////////////////////////////////////////////////////
--
-- Resumo la tabla sin info de cotizacion ni fechas
--

	insert into #t_DC_CSC_VEN_0560
																(
																		ven_id,
																		cli_id,
																		pr_id,
																		orden_id,
																		Codigo,
																		Vendedor,
																		Empresa,
																		Cliente,
																		Producto,
																		
																		Neto,
																		IVA,
																		[Otros Impuestos],
																		Total
																)
	select
	    ven_id,
			cli_id,
			pr_id,
			1 											as orden_id,
	  	Codigo,
	  	Vendedor,
			Empresa,
			Cliente,
			Producto,
			sum (Neto)							as Neto,
			sum (IVA)								as IVA,
	  	0 											as [Otros Impuestos],
			sum (Total)							as Total
	
	from #t_DC_CSC_VEN_0560_2

    group by
    
        ven_id,
				cli_id,
				pr_id,
      	Codigo,
      	Vendedor,
    		Empresa,
    		Cliente,
				Producto

--
--////////////////////////////////////////////////////////////////

--////////////////////////////////////////////////////////////////
--
-- Totales
--

		update #t_DC_CSC_VEN_0560 set pa_id = pro.pa_id
		from Cliente cli  inner join Provincia pro on cli.pro_id = pro.pro_id
											inner join pais pa       on pro.pa_id  = pa.pa_id
		where #t_DC_CSC_VEN_0560.cli_id = cli.cli_id
		
		update #t_DC_CSC_VEN_0560 set total_vendedor = (select sum(total) from #t_DC_CSC_VEN_0560 t where isnull(ven_id,0) = isnull(#t_DC_CSC_VEN_0560.ven_id,0))
		update #t_DC_CSC_VEN_0560 set total_pais = (select sum(total) from #t_DC_CSC_VEN_0560 t where isnull(pa_id,0) = isnull(#t_DC_CSC_VEN_0560.pa_id,0))
		
		declare @total decimal(18,6)
		
		select @total = sum(total) from #t_DC_CSC_VEN_0560
		
		set @total = isnull(@total,0)

--
--////////////////////////////////////////////////////////////////
		
--////////////////////////////////////////////////////////////////
--
-- Cursor para ordenar el pais
--

	declare @pa_id int
	declare @pa_id_orden int

	set @pa_id_orden = 0

	declare c_pais insensitive cursor for select pa_id from #t_DC_CSC_VEN_0560 group by pa_id order by sum(total) desc
	open c_pais

	fetch next from c_pais into @pa_id	
	while @@fetch_status=0
	begin

		update #t_DC_CSC_VEN_0560 set pa_id_orden = @pa_id_orden where isnull(pa_id,0) = isnull(@pa_id,0)

		set @pa_id_orden = @pa_id_orden + 1

		fetch next from c_pais into @pa_id
	end
	
	close c_pais
	deallocate c_pais

--
--////////////////////////////////////////////////////////////////


--////////////////////////////////////////////////////////////////
--
-- Retorno
--
		select 
		
					ven_id,
					orden_id,
					pa_id_orden,
					Codigo,
					Vendedor,
					Empresa,
					Cliente,
					Producto,
		
					IsNull(pa_nombre,'Varios') as Pais,
					
					Neto,
					IVA,
					[Otros Impuestos],
					Total,
					total_pais		 as [Total Pais],
		
					case total_pais 
						when 0 then 0
						else        total / total_pais
					end						 as [Porcentaje Pais],
		
					case total_vendedor 
						when 0 then 0
						else        total / total_vendedor
					end						 as [Porcentaje Vendedor],
		
					case 
						when @total = 0 then 0
						else								 total / @total 
					end						 as [Porcentaje Total]
		
		
		from #t_DC_CSC_VEN_0560 t left join pais pa on t.pa_id = pa.pa_id
	
	union all
	
		select 
		
					0 as ven_id,
					0 as orden_id,
					pa_id_orden,
					'' as Codigo,
					'' as Vendedor,
					'' as Empresa,
					'' as Cliente,
					'' as Producto,
		
					IsNull(pa_nombre,'Varios')  as Pais,
					
					0										as Neto,
					0										as IVA,
					0										as [Otros Impuestos],
					total_pais					as Total,
					total_pais					as [Total Pais],
					0						 				as [Porcentaje Pais],
					0						 				as [Porcentaje Vendedor],
					0						 				as [Porcentaje Total]
		
		
		from #t_DC_CSC_VEN_0560 t left join pais pa on t.pa_id = pa.pa_id

		group by pa_id_orden, 
						 pa_nombre,
						 total_pais
	
	order by orden_id desc, vendedor, empresa, cliente, total_pais desc, total desc, pa_id_orden

end
go

