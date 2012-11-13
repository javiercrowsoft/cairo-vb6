/*---------------------------------------------------------------------
Nombre: Aplicacion de Documentos de Venta
---------------------------------------------------------------------*/
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*
select * from empresacliente where cli_nombre like '%car on%'

DC_CSC_VEN_0025 1,
                '20040915',
                '20090930',
                '0',
                '0',
                '0',
                '0',
								0
*/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0025]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0025]
GO

create procedure DC_CSC_VEN_0025 (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@cli_id  		varchar(255),
@@suc_id  		varchar(255), 
@@cico_id			varchar(255), 
@@emp_id  		varchar(255),
@@pendientes	smallint			-- <> 0: solo pendientes
														-- =  0: todas

)as 

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id 	int
declare @suc_id 	int
declare @cico_id  int
declare @emp_id 	int 

declare @ram_id_Cliente  int
declare @ram_id_Sucursal int
declare @ram_id_circuitocontable int
declare @ram_id_Empresa  int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_Cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
	end else 
		set @ram_id_Cliente = 0
end

if @ram_id_Sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
	end else 
		set @ram_id_Sucursal = 0
end

if @ram_id_circuitocontable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
	end else 
		set @ram_id_circuitocontable = 0
end

----------------------------------------

if @ram_id_Empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Empresa, @clienteID 
	end else 
		set @ram_id_Empresa = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


/*- ///////////////////////////////////////////////////////////////////////

SALDOS

/////////////////////////////////////////////////////////////////////// */

	create table #t_dc_csc_ven_0025 (
	
		cli_id 				   int,
		emp_id  				 int,
		cobznc_pendiente decimal(18,6),
	  fv_pendiente     decimal(18,6)
	)

		--/////////////////////////////////////
		--
		-- ORDENES DE PAGO
		--
		
		insert into #t_dc_csc_ven_0025
		
		select 
		
			cli_id,
		  cobz.emp_id,
			cobz_total - isnull((select sum(fvcobz_importe) 
                           from FacturaVentaCobranza fvcobz inner join FacturaVenta fv
													  																  on fvcobz.fv_id = fv.fv_id			
                           where fvcobz.cobz_id = cobz.cobz_id
													   and fv.fv_fecha <= @@Ffin
                          ),0),
			0  
		
		from
		
			Cobranza cobz inner join Documento doc on cobz.doc_id = doc.doc_id
		
		where 
		
						  cobz.cobz_fecha < @@Fini
					and	cobz.est_id <> 7

					and (cobz_total - isnull((select sum(fvcobz_importe) 
                          from FacturaVentaCobranza fvcobz inner join FacturaVenta fv
													 																  on fvcobz.fv_id = fv.fv_id			
                          where fvcobz.cobz_id = cobz.cobz_id
													  and fv.fv_fecha <= @@Ffin
                        ),0)<> 0)
		---------------------------------------------------------------------------
					and (
								exists(select * from EmpresaUsuario where emp_id = cobz.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
    			and (
								exists(select * from UsuarioEmpresa where cli_id = cobz.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
							)
		---------------------------------------------------------------------------
		
		and   (cobz.cli_id = @cli_id or @cli_id=0)
		and   (cobz.suc_id = @suc_id or @suc_id=0)
		and   (cobz.emp_id = @emp_id or @emp_id=0) 
		and   (doc.cico_id = @cico_id or @cico_id=0)
		
		-- Arboles
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 28
		                  and  rptarb_hojaid = cobz.cli_id
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
		                  and  tbl_id = 1007
		                  and  rptarb_hojaid = cobz.suc_id
									   ) 
		           )
		        or 
							 (@ram_id_Sucursal = 0)
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
							 (@ram_id_circuitocontable = 0)
					 )

		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1018 
		                  and  rptarb_hojaid = cobz.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_Empresa = 0)
					 )

		--/////////////////////////////////////
		--
		-- NOTAS DE CREDITO
		--

		union all
		
		select 
		
			cli_id,
		  nc.emp_id,
		  fv_total - IsNull((select sum(fvnc_importe) 
                         from FacturaVentaNotaCredito fvnc inner join FacturaVenta fv
																												   on fvnc.fv_id_factura = fv.fv_id			
                         where fvnc.fv_id_notacredito = nc.fv_id
												   and fv.fv_fecha <= @@Ffin
                        ),0),
			0
		
		from
		
			FacturaVenta nc inner join Documento docnc on nc.doc_id = docnc.doc_id
		                      
		where 
		
						  nc.fv_fecha < @@Fini
		      and docnc.doct_id = 7 /* 7	Nota de Credito Venta */
					and nc.est_id <> 7
		
					and (fv_total - IsNull((select sum(fvnc_importe) 
                         from FacturaVentaNotaCredito fvnc inner join FacturaVenta fv
																												   on fvnc.fv_id_factura = fv.fv_id			
                         where fvnc.fv_id_notacredito = nc.fv_id
												   and fv.fv_fecha <= @@Ffin
                        ),0)<>0)
		---------------------------------------------------------------------------
					and (
								exists(select * from EmpresaUsuario where emp_id = docnc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		---------------------------------------------------------------------------
		
		and   (nc.cli_id   		= @cli_id  or @cli_id  =0)
		and   (nc.suc_id    	= @suc_id  or @suc_id  =0)
		and   (docnc.emp_id 	= @emp_id  or @emp_id  =0)
		and   (docnc.cico_id 	= @cico_id or @cico_id =0)

		-- Arboles
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 28
		                  and  rptarb_hojaid = nc.cli_id
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
		                  and  tbl_id = 1007
		                  and  rptarb_hojaid = nc.suc_id
									   ) 
		           )
		        or 
							 (@ram_id_Sucursal = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1016 
		                  and  rptarb_hojaid = docnc.cico_id
									   ) 
		           )
		        or 
							 (@ram_id_circuitocontable = 0)
					 )

		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1018 
		                  and  rptarb_hojaid = docnc.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_Empresa = 0)
					 )
		
		--/////////////////////////////////////
		--
		-- FACTURAS
		--

		union all

		select 
		
					cli_id,
				  fv.emp_id,
				  0,
					fv_total - IsNull((select sum(fvnc_importe) 
			                               from FacturaVentaNotaCredito fvnc inner join FacturaVenta nc
																																		   on fvnc.fv_id_notacredito = nc.fv_id			
			                               where fvnc.fv_id_factura = fv.fv_id
																		   and nc.fv_fecha <= @@Ffin
			                               ),0)
													 - IsNull((select sum(fvcobz_importe) 
				                             from FacturaVentaCobranza fvcobz inner join Cobranza cobz
																			 																  on fvcobz.cobz_id = cobz.cobz_id			
				                             where fvcobz.fv_id = fv.fv_id
																		   and cobz.cobz_fecha <= @@Ffin
				                             ),0)
		
		from
		
			FacturaVenta fv inner join Documento docfv on fv.doc_id = docfv.doc_id
		
		where 
		
						  fv_fecha < @@Fini
		      and docfv.doct_id <> 7 /* 7	Nota de Credito Venta */
				  and fv.est_id <> 7

					and (fv_total - IsNull((select sum(fvnc_importe) 
	                                from FacturaVentaNotaCredito fvnc inner join FacturaVenta nc
																																   on fvnc.fv_id_notacredito = nc.fv_id			
	                                where fvnc.fv_id_factura = fv.fv_id
																    and nc.fv_fecha <= @@Ffin
	                                ),0)
											  - IsNull((select sum(fvcobz_importe) 
		                              from FacturaVentaCobranza fvcobz inner join Cobranza cobz
																	 																  on fvcobz.cobz_id = cobz.cobz_id			
		                              where fvcobz.fv_id = fv.fv_id
																    and cobz.cobz_fecha <= @@Ffin
		                              ),0)<>0)
		
		---------------------------------------------------------------------------
					and (
								exists(select * from EmpresaUsuario where emp_id = docfv.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
    			and (
								exists(select * from UsuarioEmpresa where cli_id = fv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
							)
		---------------------------------------------------------------------------
		
		and   (fv.cli_id    	= @cli_id   or @cli_id  = 0)
		and   (fv.suc_id    	= @suc_id   or @suc_id  = 0)
		and   (docfv.emp_id 	= @emp_id   or @emp_id  = 0) 
		and   (docfv.cico_id  = @cico_id  or @cico_id = 0)
		
		-- Arboles
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
		                  and  tbl_id = 1007
		                  and  rptarb_hojaid = fv.suc_id
									   ) 
		           )
		        or 
							 (@ram_id_Sucursal = 0)
					 )
		
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1016 
		                  and  rptarb_hojaid = docfv.cico_id
									   ) 
		           )
		        or 
							 (@ram_id_circuitocontable = 0)
					 )

		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 1018 
		                  and  rptarb_hojaid = docfv.emp_id
									   ) 
		           )
		        or 
							 (@ram_id_Empresa = 0)
					 )

/*- //////////////////////////////////////////////////////////////////////

SELECT DE RETORNO

/////////////////////////////////////////////////////////////////////// */

	--/////////////////////////////////////
	--	
	-- SALDOS
	--

	declare @SaldoAl varchar(255)
	set @SaldoAl = 'Saldo al ' + convert(varchar(10),dateadd(d,-1,@@fini),110)

	select 
	
		0         								as cobz_id,
	  0       									as fv_id,
		cli_nombre								as Cliente,
	  @@fini  									as [Cobranza/NC Fecha],
	  null                      as [Cobranza/NC],
	  emp_nombre                as Empresa, 
	  @SaldoAl                  as [Cobranza/NC Comprobante],
	  null               	      as [Cobranza/NC Numero],
	  null                     	as [Cobranza/NC Total],
	  sum(cobznc_pendiente)			as [Cobranza/NC Pendiente],
	  null                      as [Cobranza/NC Legajo],
	  null                      as [Factura Fecha],
	  null                      as [Documento de Venta],
	  null                      as [Factura Comprobante],
	  null                      as [Factura Numero],
	  null                      as [Moneda],
	  null                     	as [Aplicacion],
		null                      as [Factura Total],
	  sum(fv_pendiente)         as [Factura Pendiente],
	  null                      as [Factura Legajo],
	  0                       	as Orden,
    null                      as Observaciones,
    null                      as [Obs. Factura]
	
	from #t_dc_csc_ven_0025 t inner join Cliente cli on t.cli_id = cli.cli_id
	                          inner join Empresa emp    on t.emp_id  = emp.emp_id

		group by cli_nombre,emp_nombre
	
	union all

	--/////////////////////////////////////
	--	
	-- ENTRE FECHAS
	--

	--/////////////////////////////////////
	--	
	-- COBRANZAS
	--

	select 
	
		cobz.cobz_id							as cobz_id,
	  fv.fv_id									as comp_id,
	
		cli_nombre								as Cliente,
	  cobz_fecha								as [Cobranza/NC Fecha],
	  doccobz.doc_nombre        as [Cobranza/NC],
	  emp_nombre                as [Empresa], 
	  cobz_nrodoc               as [Cobranza/NC Comprobante],
	  cobz_numero               as [Cobranza/NC Numero],
	  cobz_total                as [Cobranza/NC Total],
	
	  cobz_total	- IsNull((select sum(fvcobz_importe) 
			                    from FacturaVentaCobranza fvcobz inner join FacturaVenta fv
													 																    on fvcobz.fv_id = fv.fv_id			
			                    where fvcobz.cobz_id = cobz.cobz_id
													  and fv.fv_fecha <= @@Ffin
			                    ),0)
															as [Cobranza/NC Pendiente],
	  lgjcobz.lgj_codigo        as [Cobranza/NC Legajo],
	  fv_fecha                  as [Factura Fecha],
	  docfv.doc_nombre          as [Documento de Venta],
	  fv_nrodoc                 as [Factura Comprobante],
	  fv_numero                 as [Factura Numero],
	  mon_nombre                as [Moneda],
	  fvcobz_importe            as [Aplicacion],
		fv_total                  as [Factura Total],
	  0                         as [Factura Pendiente],
	  lgjfv.lgj_codigo          as [Factura Legajo],
	  0                       	as Orden,
	  cobz_descrip              as Observaciones,
    fv_descrip                as [Obs. Factura]	  
	
	from
	
		Cobranza cobz				inner join Cliente cli 										on cobz.cli_id 			 = cli.cli_id
												inner join Sucursal                       on cobz.suc_id       = Sucursal.suc_id
	                      inner join Documento doccobz              on cobz.doc_id       = doccobz.doc_id
	                      inner join Empresa                        on doccobz.emp_id    = Empresa.emp_id 
	                      left  join Legajo lgjcobz                 on cobz.lgj_id       = lgjcobz.lgj_id
												left  join FacturaVentaCobranza fvcobz    on cobz.cobz_id 		 = fvcobz.cobz_id
												left  join FacturaVenta fv                on fvcobz.fv_id      = fv.fv_id
												left  join Documento docfv                on fv.doc_id         = docfv.doc_id
	                      left  join Moneda m                       on fv.mon_id         = m.mon_id
	                      left  join Legajo lgjfv                   on fv.lgj_id         = lgjfv.lgj_id
	where 
	
					  cobz_fecha >= @@Fini
				and	cobz_fecha <= @@Ffin 
	
	      and cobz.est_id <> 7
	
	---------------------------------------------------------------------------
				and (
							exists(select * from EmpresaUsuario where emp_id = doccobz.emp_id and us_id = @@us_id) or (@@us_id = 1)
						)
   			and (
							exists(select * from UsuarioEmpresa where cli_id = cobz.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
						)
	---------------------------------------------------------------------------
	
	and   (cobz.cli_id 		 = @cli_id 	 or @cli_id	 =0)
	and   (cobz.suc_id 		 = @suc_id 	 or @suc_id	 =0)
	and   (cobz.emp_id 		 = @emp_id 	 or @emp_id	 =0) 
	and   (doccobz.cico_id = @cico_id  or @cico_id =0)
	
	-- Arboles
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 28 
	                  and  rptarb_hojaid = cobz.cli_id
								   ) 
	           )
	        or 
						 (@ram_id_Cliente = 0)
				 )
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 1007 
	                  and  rptarb_hojaid = cobz.suc_id
								   ) 
	           )
	        or 
						 (@ram_id_Sucursal = 0)
				 )
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 1016 
	                  and  rptarb_hojaid = doccobz.cico_id
								   ) 
	           )
	        or 
						 (@ram_id_circuitocontable = 0)
				 )

	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 1018 
	                  and  rptarb_hojaid = doccobz.emp_id
								   ) 
	           )
	        or 
						 (@ram_id_Empresa = 0)
				 )
	
	--/////////////////////////////////////
	--	
	-- NOTAS DE CREDITO
	--

	union all
		
	select 
	
		nc.fv_id     							as cobz_id,
	  fv.fv_id									as comp_id,
	
		cli_nombre								as Cliente,
	  nc.fv_fecha								as [Cobranza/NC Fecha],
	  docnc.doc_nombre          as [Cobranza/NC],
	  emp_nombre                as [Empresa], 
	  nc.fv_nrodoc              as [Cobranza/NC Comprobante],
	  nc.fv_numero              as [Cobranza/NC Numero],
	  nc.fv_total               as [Cobranza/NC Total],
	
	  nc.fv_total - IsNull((select sum(fvnc_importe) 
	                        from FacturaVentaNotaCredito fvnc inner join FacturaVenta fv
																													     on fvnc.fv_id_factura = fv.fv_id			
	                        where fvnc.fv_id_notacredito = nc.fv_id
													  and fv.fv_fecha <= @@Ffin
	                        ),0)           
															as [Cobranza/NC Pendiente],
	  lgjnc.lgj_codigo          as [Cobranza/NC Legajo],
	  fv.fv_fecha               as [Factura Fecha],
	  docfv.doc_nombre          as [Documento de Venta],
	  fv.fv_nrodoc              as [Factura Comprobante],
	  fv.fv_numero              as [Factura Numero],
	  mon_nombre                as [Moneda],
	  fvnc_importe              as [Aplicacion],
		fv.fv_total               as [Factura Total],
	  0                         as [Factura Pendiente],
	  lgjfv.lgj_codigo          as [Factura Legajo],
	  0                       	as Orden,
	  nc.fv_descrip             as Observaciones,
    fv.fv_descrip             as [Obs. Factura]	  
	
	from
	
		FacturaVenta nc 		inner join Cliente cli 										on nc.cli_id 			  		= cli.cli_id
												inner join Sucursal                       on nc.suc_id        		= Sucursal.suc_id
	                      inner join Documento docnc                on nc.doc_id        		= docnc.doc_id
	                      inner join Empresa                        on docnc.emp_id         = Empresa.emp_id 
	                      left  join Legajo lgjnc                   on nc.lgj_id        		= lgjnc.lgj_id
												left  join FacturaVentaNotaCredito fvnc   on nc.fv_id 			  		= fvnc.fv_id_notacredito
												left  join FacturaVenta fv                on fvnc.fv_id_factura   = fv.fv_id
												left  join Documento docfv                on fv.doc_id        		= docfv.doc_id
	                      left  join Moneda m                       on fv.mon_id        		= m.mon_id
	                      left  join Legajo lgjfv                   on fv.lgj_id        		= lgjfv.lgj_id
	where 
	
					  nc.fv_fecha >= @@Fini
				and	nc.fv_fecha <= @@Ffin 
	
	      and nc.est_id <> 7
	      and docnc.doct_id = 7 /* 7	Nota de Credito Venta */
	
	---------------------------------------------------------------------------
				and (
							exists(select * from EmpresaUsuario where emp_id = docnc.emp_id and us_id = @@us_id) or (@@us_id = 1)
						)
   			and (
							exists(select * from UsuarioEmpresa where cli_id = nc.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
						)

	---------------------------------------------------------------------------
	
	and   (nc.cli_id 			= @cli_id 	or @cli_id		=0)
	and   (nc.suc_id 			= @suc_id 	or @suc_id		=0)
	and   (nc.emp_id 			= @emp_id 	or @emp_id		=0) 
	and   (docnc.cico_id 	= @cico_id  or @cico_id  	=0) 
	
	-- Arboles
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 28 
	                  and  rptarb_hojaid = nc.cli_id
								   ) 
	           )
	        or 
						 (@ram_id_Cliente = 0)
				 )
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 1007 
	                  and  rptarb_hojaid = nc.suc_id
								   ) 
	           )
	        or 
						 (@ram_id_Sucursal = 0)
				 )
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 1016 
	                  and  rptarb_hojaid = docnc.cico_id
								   ) 
	           )
	        or 
						 (@ram_id_circuitocontable = 0)
				 )

	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 1018 
	                  and  rptarb_hojaid = docnc.emp_id
								   ) 
	           )
	        or 
						 (@ram_id_Empresa = 0)
				 )
	
	--/////////////////////////////////////
	--	
	-- FACTURAS
	--

	union all
	
	select 
	
		0													as cobz_id,
	  fv.fv_id									as comp_id,
	
		cli_nombre								as Cliente,
	  convert(datetime,'19900101')
	            								as [Cobranza/NC Fecha],
	  ''                        as [Cobranza/NC],
	  emp_nombre                as [Empresa], 
	  ''                        as [Cobranza/NC Comprobante],
	  null             					as [Cobranza/NC Numero],
	  0                					as [Cobranza/NC Total],
	  0            							as [Cobranza/NC Pendiente],
	  ''                        as [Cobranza/NC Legajo],
	  fv_fecha                  as [Factura Fecha],
	  docfv.doc_nombre          as [Documento de Venta],
	  fv_nrodoc                 as [Factura Comprobante],
	  fv_numero                 as [Factura Numero],
	  mon_nombre                as [Moneda],
	  fv_total - fv_pendiente		as [Aplicacion],
		fv_total                  as [Factura Total],
	
		fv_total - IsNull((select sum(fvnc_importe) 
	                     from FacturaVentaNotaCredito fvnc inner join FacturaVenta nc
																											   on fvnc.fv_id_notacredito = nc.fv_id			
	                     where fvnc.fv_id_factura = fv.fv_id
											   and nc.fv_fecha <= @@Ffin
	                     ),0)
						 - IsNull((select sum(fvcobz_importe) 
	                     from FacturaVentaCobranza fvcobz inner join Cobranza cobz
												 																  on fvcobz.cobz_id = cobz.cobz_id			
	                     where fvcobz.fv_id = fv.fv_id
											   and cobz.cobz_fecha <= @@Ffin
	                     ),0)
	
	
															as [Factura Pendiente],
	
	  lgjfv.lgj_codigo          as [Factura Legajo],
	  1                       	as Orden,
    null                      as Observaciones,
    fv.fv_descrip             as [Obs. Factura]	  
	
	from
	
		FacturaVenta fv 				inner join Cliente cli 										on fv.cli_id 			= cli.cli_id
														inner join Sucursal                       on fv.suc_id      = Sucursal.suc_id
														inner join Documento docfv                on fv.doc_id      = docfv.doc_id
	                          inner join Empresa                        on docfv.emp_id   = Empresa.emp_id 
			                      inner join Moneda m                       on fv.mon_id      = m.mon_id
	                          left  join Legajo lgjfv                   on fv.lgj_id      = lgjfv.lgj_id
	where 
	
					  fv_fecha >= @@Fini
				and	fv_fecha <= @@Ffin 

				and (fv_pendiente <> 0 or @@pendientes = 0)
	
				and docfv.doct_id <> 7 /* 7	Nota de Credito Venta */
	
	      and fv.est_id <> 7
	
			  and (
							fv_total - IsNull((select sum(fvnc_importe) 
	                               from FacturaVentaNotaCredito fvnc inner join FacturaVenta nc
																																   on fvnc.fv_id_notacredito = nc.fv_id			
	                               where fvnc.fv_id_factura = fv.fv_id
																   and nc.fv_fecha <= @@Ffin
	                               ),0)
											 - IsNull((select sum(fvcobz_importe) 
		                             from FacturaVentaCobranza fvcobz inner join Cobranza cobz
																	 																  on fvcobz.cobz_id = cobz.cobz_id			
		                             where fvcobz.fv_id = fv.fv_id
																   and cobz.cobz_fecha <= @@Ffin
		                             ),0) >0
						)
	
	
	---------------------------------------------------------------------------
				and (
							exists(select * from EmpresaUsuario where emp_id = docfv.emp_id and us_id = @@us_id) or (@@us_id = 1)
						)
   			and (
							exists(select * from UsuarioEmpresa where cli_id = fv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
						)

	---------------------------------------------------------------------------
	
	and   (fv.cli_id 			= @cli_id 	or @cli_id	=0)
	and   (fv.suc_id 			= @suc_id 	or @suc_id	=0)
	and   (fv.emp_id 			= @emp_id 	or @emp_id	=0) 
	and   (docfv.cico_id 	= @cico_id  or @cico_id =0) 
	
	-- Arboles
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
						 (@ram_id_Cliente = 0)
				 )
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 1007 
	                  and  rptarb_hojaid = fv.suc_id
								   ) 
	           )
	        or 
						 (@ram_id_Sucursal = 0)
				 )
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 1016 
	                  and  rptarb_hojaid = docfv.cico_id
								   ) 
	           )
	        or 
						 (@ram_id_circuitocontable = 0)
				 )

	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 1018 
	                  and  rptarb_hojaid = docfv.emp_id
								   ) 
	           )
	        or 
						 (@ram_id_Empresa = 0)
				 )
	
	--///////////////////////////////////////////////////////////////
	
	order by
	
		Cliente, Orden, [Cobranza/NC Fecha], [Cobranza/NC Numero], [Factura Fecha]


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
