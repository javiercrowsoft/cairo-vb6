if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0230]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0230]
go

/*
select * from OrdenCompra

sp_docOrdenCompraget 47

DC_CSC_COM_0230  
								1,	
								'20060818',	
								'20060818',		
								'0',		
								'0',		
								'0',		
								'0',		
								'0',		
								'0',		
								'0',
								0,
								0

*/

create procedure DC_CSC_COM_0230 (

  @@us_id    int,

	@@Fini 		 datetime,
	@@Ffin 		 datetime,
	
	@@prov_id  			varchar(255),
	@@est_id				varchar(255),
	@@ccos_id				varchar(255),
	@@suc_id				varchar(255),
	@@doc_id				varchar(255),
	@@cpg_id				varchar(255),
	@@emp_id				varchar(255),
	@@bPendientes   smallint,
	@@showRemitos		smallint
)as 

begin

	set nocount on

	/*- ///////////////////////////////////////////////////////////////////////
	
	INICIO PRIMERA PARTE DE ARBOLES
	
	/////////////////////////////////////////////////////////////////////// */
	
	declare @prov_id int
	declare @ccos_id int
	declare @suc_id int
	declare @est_id int
	declare @doc_id int
	declare @cpg_id int
	declare @emp_id int
	
	declare @ram_id_Proveedor int
	declare @ram_id_CentroCosto int
	declare @ram_id_Sucursal int
	declare @ram_id_Estado int
	declare @ram_id_Documento int
	declare @ram_id_CondicionPago int 
	declare @ram_id_Empresa int 
	
	declare @ClienteID int
	declare @IsRaiz    tinyint
	
	exec sp_ArbConvertId @@prov_id, @prov_id out, @ram_id_Proveedor out
	exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_CentroCosto out
	exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
	exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
	exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
	exec sp_ArbConvertId @@cpg_id, @cpg_id out, @ram_id_CondicionPago out 
	exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 
	
	exec sp_GetRptId @ClienteID out
	
	if @ram_id_Proveedor <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Proveedor, @ClienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Proveedor, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Proveedor, @ClienteID 
		end else 
			set @ram_id_Proveedor = 0
	end
	
	if @ram_id_CentroCosto <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_CentroCosto, @ClienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_CentroCosto, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_CentroCosto, @ClienteID 
		end else 
			set @ram_id_CentroCosto = 0
	end
	
	if @ram_id_Estado <> 0 begin
	
		exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Estado, @ClienteID 
		end else 
			set @ram_id_Estado = 0
	end
	
	if @ram_id_Sucursal <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_Sucursal, @ClienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Sucursal, @ClienteID 
		end else 
			set @ram_id_Sucursal = 0
	end
	
	if @ram_id_Documento <> 0 begin
	
		exec sp_ArbIsRaiz @ram_id_Documento, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_Documento, @ClienteID 
		end else 
			set @ram_id_Documento = 0
	end
	
	if @ram_id_CondicionPago <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_CondicionPago, @ClienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_CondicionPago, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_CondicionPago, @ClienteID 
		end else 
			set @ram_id_CondicionPago = 0
	end
	
	if @ram_id_empresa <> 0 begin
	
	--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id
	
		exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
	  if @IsRaiz = 0 begin
			exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
		end else 
			set @ram_id_empresa = 0
	end
	
	/*- ///////////////////////////////////////////////////////////////////////
	
	FIN PRIMERA PARTE DE ARBOLES
	
	/////////////////////////////////////////////////////////////////////// */
	-- sp_columns OrdenCompra
	
	create table #t_dc_csc_com_0230 (oc_id 		int not null, 
																	 prov_id  int not null,
																	 oci_id 	int not null,
																	 pr_id    int not null
																	)
	
	
			insert into #t_dc_csc_com_0230 (oc_id, prov_id, oci_id, pr_id)
	
			select 
						oc.oc_id,
						oc.prov_id,
						oci.oci_id,
					  oci.pr_id
			from 
						OrdenCompra oc   inner join documento doc    		 on oc.doc_id = doc.doc_id
														 left  join OrdenCompraItem oci  on oc.oc_id  = oci.oc_id
			where 
			
							  @@Fini <= oc_fecha
						and	@@Ffin >= oc_fecha 		
			
						and (@@bPendientes = 0 or oci_pendientefac > 0)
			
			/* -///////////////////////////////////////////////////////////////////////
			
			INICIO SEGUNDA PARTE DE ARBOLES
			
			/////////////////////////////////////////////////////////////////////// */
			
			and   (oc.prov_id = @prov_id or @prov_id=0)
			and   (oc.est_id  = @est_id  or @est_id=0)
			and   (oc.suc_id  = @suc_id  or @suc_id=0)
			and   (oc.doc_id  = @doc_id  or @doc_id=0)
			and   (oc.cpg_id  = @cpg_id  or @cpg_id=0) 
			and   (oc.ccos_id = @ccos_id or @ccos_id=0)
			and   (doc.emp_id = @emp_id  or @emp_id=0)
			
			-- Arboles
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @ClienteID
			                  and  tbl_id = 29
			                  and  rptarb_hojaid = oc.prov_id
										   ) 
			           )
			        or 
								 (@ram_id_Proveedor = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @ClienteID
			                  and  tbl_id = 21
			                  and  rptarb_hojaid = oc.ccos_id
										   ) 
			           )
			        or 
								 (@ram_id_CentroCosto = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @ClienteID
			                  and  tbl_id = 4005
			                  and  rptarb_hojaid = oc.est_id
										   ) 
			           )
			        or 
								 (@ram_id_Estado = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @ClienteID
			                  and  tbl_id = 1007
			                  and  rptarb_hojaid = oc.suc_id
										   ) 
			           )
			        or 
								 (@ram_id_Sucursal = 0)
						 )
			
			and   (              
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @ClienteID
			                  and  tbl_id = 4001
			                  and  rptarb_hojaid = oc.doc_id
										   ) 
			           )
			        or 
								 (@ram_id_Documento = 0)
						 )
			
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @ClienteID
			                  and  tbl_id = 1005
			                  and  rptarb_hojaid = oc.cpg_id
										   ) 
			           )
			        or 
								 (@ram_id_CondicionPago = 0)
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
	
	--////////////////////////////////////////////////////////////////////////
	
			select 
						oc.oc_id							as comp_id,
						oc.doct_id						as doct_id,
						0                     as orden_id,
						t.oc_id               as grupo,
	
						oci.oci_id,
						oc_numero             as [Número],
						oc_nrodoc						  as [Comprobante],

						oc_ordencompra    		as [PO],
						oc_presupuesto				as [RMA],

						null                  as [Remito Número],
						null  						    as [Remito Comprobante],

				    prov_nombre           as [Proveedor],
			      doc_nombre					  as [Documento],
				    est_nombre					  as [Estado],

						oc_fecha						  as [Fecha],
						oc_fechaentrega				as [Fecha de entrega],

						null						  		as [Remito Fecha],
						null									as [Remito Fecha de entrega],

						case oc.impreso
							when 0 then 'No'
							else        'Si'
						end										as [Impreso],
						oc_neto								as [Neto],
						oc_ivari							as [IVA RI],
						oc_ivarni							as [IVA RNI],
						oc_subtotal						as [Subtotal],
						oc_total							as [Total],
						oc_pendiente					as [Pendiente],
						case oc_firmado
							when 0 then 'No'
							else        'Si'
						end										as [Firmado],
						
						oc_descuento1					as [% Desc. 1],
						oc_descuento2					as [% Desc. 2],
						oc_importedesc1				as [Desc. 1],
						oc_importedesc2				as [Desc. 2],
			
				    lp_nombre						  as [Lista de Precios],
				    ld_nombre						  as [Lista de descuentos],
				    cpg_nombre					  as [Condicion de Pago],
				    ccos_nombre					  as [Centro de costo],
			      suc_nombre					  as [Sucursal],
						emp_nombre            as [Empresa],
			
						pr_nombrecompra       as Articulo,
						oci_cantidad          as Cantidad,
						oci_pendientefac			as [Item Pendiente],
						oci_precio*oci_pendientefac
																	as [Item $ Pendiente],
			
						oc.Creado,
						oc.Modificado,
						us_nombre             as [Modifico],
						oc_descrip						as [Observaciones],
						oci_descrip						as [Items Observaciones]
			from 
						#t_dc_csc_com_0230 t
	
													 inner join	ordencompra oc     on t.oc_id     = oc.oc_id
	
													 inner join documento doc    	 on oc.doc_id   = doc.doc_id
													 inner join empresa   emp    	 on doc.emp_id  = emp.emp_id
				                   inner join condicionpago cpg  on oc.cpg_id   = cpg.cpg_id
													 inner join estado    est      on oc.est_id   = est.est_id
													 inner join sucursal  suc      on oc.suc_id   = suc.suc_id
				                   inner join Proveedor prov     on oc.prov_id  = prov.prov_id
				                   inner join usuario   us       on oc.modifico = us.us_id
				                   left join centrocosto  ccos   on oc.ccos_id  = ccos.ccos_id
				                   left join listaprecio  lp     on oc.lp_id    = lp.lp_id
				  								 left join listadescuento  ld  on oc.ld_id    = ld.ld_id
	
													 left join OrdenCompraItem oci on t.oci_id 		= oci.oci_id
																												and t.oc_id     = oci.oc_id
	
				                   left join Producto pr         on oci.pr_id 	= pr.pr_id
			where 
			
							  @@Fini <= oc_fecha
						and	@@Ffin >= oc_fecha 		
	
						and (@@bPendientes = 0 or oci_pendientefac > 0)
	
		union all
			
			select 
						rc.rc_id							as comp_id,
						rc.doct_id						as doct_id,
						1                     as orden_id,
						t.oc_id               as grupo,
	
						rci.rci_id,
						oc_numero             as [Número],
						oc_nrodoc						  as [Comprobante],

						oc_ordencompra    		as [PO],
						oc_presupuesto				as [RMA],

						rc_numero             as [Remito Número],
						rc_nrodoc						  as [Remito Comprobante],

				    prov_nombre           as [Proveedor],
			      doc_nombre					  as [Documento],
				    est_nombre					  as [Estado],

						oc_fecha						  as [Fecha],
						oc_fechaentrega				as [Fecha de entrega],

						rc_fecha						  as [Remito Fecha],
						rc_fechaentrega				as [Remito Fecha de entrega],

						case rc.impreso
							when 0 then 'No'
							else        'Si'
						end										as [Impreso],
						rc_neto								as [Neto],
						rc_ivari							as [IVA RI],
						rc_ivarni							as [IVA RNI],
						rc_subtotal						as [Subtotal],
						rc_total							as [Total],
						rc_pendiente					as [Pendiente],
						case rc_firmado
							when 0 then 'No'
							else        'Si'
						end										as [Firmado],
						
						rc_descuento1					as [% Desc. 1],
						rc_descuento2					as [% Desc. 2],
						rc_importedesc1				as [Desc. 1],
						rc_importedesc2				as [Desc. 2],
			
				    lp_nombre						  as [Lista de Precios],
				    ld_nombre						  as [Lista de descuentos],
				    cpg_nombre					  as [Condicion de Pago],
				    ccos_nombre					  as [Centro de costo],
			      suc_nombre					  as [Sucursal],
						emp_nombre            as [Empresa],
			
						pr_nombrecompra       as Articulo,
						rci_cantidad          as Cantidad,
						rci_pendiente   			as [Item Pendiente],
						rci_precio*rci_pendiente
																	as [Item $ Pendiente],
			
						rc.Creado,
						rc.Modificado,
						us_nombre             as [Modifico],
						rc_descrip						as [Observaciones],
						rci_descrip						as [Items Observaciones]
			from 
						#t_dc_csc_com_0230 t
													 inner join ordencompra oc        on t.oc_id 		 = oc.oc_id	

													 inner join	remitocompra rc    		on rc.prov_id  = t.prov_id

													 inner join RemitoCompraItem rci 	on   rc.rc_id  = rci.rc_id
																														and	 t.pr_id   = rci.pr_id
	
				                   inner join Producto pr         	on rci.pr_id 	 = pr.pr_id
	
	
													 inner join documento doc    	 		on rc.doc_id   = doc.doc_id
													 inner join empresa   emp    	 		on doc.emp_id  = emp.emp_id
				                   inner join condicionpago cpg  		on rc.cpg_id   = cpg.cpg_id
													 inner join estado    est      		on rc.est_id   = est.est_id
													 inner join sucursal  suc      		on rc.suc_id   = suc.suc_id
				                   inner join Proveedor prov     		on rc.prov_id  = prov.prov_id
				                   inner join usuario   us       		on rc.modifico = us.us_id
				                   left join centrocosto  ccos   		on rc.ccos_id  = ccos.ccos_id
				                   left join listaprecio  lp     		on rc.lp_id    = lp.lp_id
				  								 left join listadescuento  ld  		on rc.ld_id    = ld.ld_id
	
			where @@showRemitos <> 0
				and rc_fecha >= @@Fini
				and rci_pendiente > 0
			
			order by Fecha, Comprobante, orden_id, [Remito Comprobante]
end
go