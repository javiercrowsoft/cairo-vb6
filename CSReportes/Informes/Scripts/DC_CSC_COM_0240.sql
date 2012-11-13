/*---------------------------------------------------------------------
Nombre: Detalle de Compra de Articulos
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_COM_0240 1, 
								'20050105',
								'20050105',
								'0',
								'0',
								'0',
								'0',
								'0',
								'0',
								'0',
								'0',
								'0',
								'0'
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0240]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0240]

go
create procedure DC_CSC_COM_0240 (

  @@us_id    		int,
	@@Fini 		 		datetime,
	@@Ffin 		 		datetime,

	@@pr_id           varchar(255),
  @@pro_id   				varchar(255),
  @@prov_id   			varchar(255),

  @@cico_id	 				varchar(255),
  @@ccos_id	   			varchar(255),
  @@suc_id	 				varchar(255),
  @@doct_id	 				int,
  @@doc_id	 				varchar(255),
  @@emp_id	 				varchar(255),

	@@bSoloConCccos		smallint

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

declare @pr_id        int
declare @pro_id   		int
declare @prov_id   		int
declare @cico_id  		int
declare @doc_id   		int
declare @doct_id   		int
declare @emp_id   		int

declare @ccos_id	    int
declare @suc_id	  		int

declare @ram_id_producto         int
declare @ram_id_provincia        int
declare @ram_id_proveedor        int
declare @ram_id_circuitoContable int
declare @ram_id_documento        int
declare @ram_id_documentoTipo    int
declare @ram_id_moneda           int
declare @ram_id_empresa          int
declare @ram_id_centroCosto      int
declare @ram_id_centroCostoItem  int
declare @ram_id_condicionPago    int
declare @ram_id_listaPrecio      int
declare @ram_id_listaDescuento   int
declare @ram_id_sucursal         int
declare @ram_id_transporte       int

declare @clienteID       int
declare @clienteIDccosi  int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id,  		   @pr_id 	out,  		@ram_id_producto  				out
exec sp_ArbConvertId @@pro_id,  		 @pro_id 	out,  		@ram_id_provincia 				out
exec sp_ArbConvertId @@prov_id,  		 @prov_id out,  		@ram_id_proveedor 				out
exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 			@ram_id_circuitoContable 	out
exec sp_ArbConvertId @@doc_id,  		 @doc_id 	out,  		@ram_id_documento 				out
exec sp_ArbConvertId @@doct_id,  		 @doct_id out,  		@ram_id_documentoTipo			out
exec sp_ArbConvertId @@emp_id,  		 @emp_id 	out,  		@ram_id_empresa   				out
exec sp_ArbConvertId @@ccos_id, 		 @ccos_id out, 			@ram_id_centroCosto 			out
exec sp_ArbConvertId @@suc_id,       @suc_id 	out, 			@ram_id_sucursal 					out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteIDccosi out

if @ram_id_producto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
	end else 
		set @ram_id_producto = 0
end

if @ram_id_provincia <> 0 begin

--	exec sp_ArbGetGroups @ram_id_provincia, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_provincia, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_provincia, @clienteID 
	end else 
		set @ram_id_provincia = 0
end

if @ram_id_proveedor <> 0 begin

--	exec sp_ArbGetGroups @ram_id_proveedor, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_proveedor, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_proveedor, @clienteID 
	end else 
		set @ram_id_proveedor = 0
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

if @ram_id_documentoTipo <> 0 begin

--	exec sp_ArbGetGroups @ram_id_documentoTipo, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_documentoTipo, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_documentoTipo, @clienteID 
	end else 
		set @ram_id_documentoTipo = 0
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

if @ram_id_centroCostoItem <> 0 begin

--	exec sp_ArbGetGroups @ram_id_centroCostoItem, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_centroCostoItem, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_centroCostoItem, @clienteIDccosi 
	end else 
		set @ram_id_centroCostoItem = 0
end

if @ram_id_condicionPago <> 0 begin

--	exec sp_ArbGetGroups @ram_id_condicionPago, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_condicionPago, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_condicionPago, @clienteID 
	end else 
		set @ram_id_condicionPago = 0
end

if @ram_id_listaPrecio <> 0 begin

--	exec sp_ArbGetGroups @ram_id_listaPrecio, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_listaPrecio, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_listaPrecio, @clienteID 
	end else 
		set @ram_id_listaPrecio = 0
end

if @ram_id_listaDescuento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_listaDescuento, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_listaPrecio, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_listaDescuento, @clienteID 
	end else 
		set @ram_id_listaDescuento = 0
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

	select  fc.fc_id 		as comp_id,
					fc.doct_id 	as doct_id,
					fc.prov_id,

					isnull(ccos_nombre, '(Sin Centro de Costo)')
															as [Centro de Costo],
					prov_nombre					as Proveedor,
					doc_nombre					as Documento,
					emp_nombre				  as Empresa, 
					fc_fecha						as Fecha, 
					fc_nrodoc						as Comprobante, 
					fc_numero						as Numero,
					pr_nombrecompra			as Articulo,
	
					case when fc.doct_id = 8 then -fci_importe
							 else                      fci_importe
					end as Importe
	

	from facturacompra fc  inner join proveedor prov 					on fc.prov_id = prov.prov_id
												 inner join documento doc   				on fc.doc_id   = doc.doc_id
								         inner join empresa   emp   				on doc.emp_id  = emp.emp_id
												 inner join FacturaCompraItem fci		on 		fc.fc_id = fci.fc_id 
												 inner join producto  pr    				on fci.pr_id = pr.pr_id

												 left join centrocosto ccos on isnull(fci.ccos_id,fc.ccos_id) = ccos.ccos_id
							
								         left join moneda    mon          on fc.mon_id   = mon.mon_id
								         left join circuitocontable cico  on doc.cico_id = cico.cico_id	
								 	       left join provincia   pro        on prov.pro_id = pro.pro_id
	where
	
					  fc_fecha >= @@Fini
				and	fc_fecha <= @@Ffin 

				and fc.est_id <> 7

				and (isnull(fci.ccos_id,fc.ccos_id) is not null or @@bSoloConCccos = 0)
	
	-- Validar usuario - empresa
				and (
							exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
						)
				and (
							exists(select * from UsuarioEmpresa where (@prov_id=0  or fc.prov_id = @prov_id) 
																										and us_id = @@us_id
										) 
							or (@us_empresaEx = 0)
						)
	
						
	/* -///////////////////////////////////////////////////////////////////////
	
	INICIO SEGUNDA PARTE DE ARBOLES
	
	/////////////////////////////////////////////////////////////////////// */
	
	and   (fci.pr_id = @pr_id or @pr_id=0)
	
	and   (@pro_id=0 or prov.pro_id = @pro_id)
	
	and   (@prov_id=0 or fc.prov_id = @prov_id)
	
	and   (doc.cico_id = @cico_id or @cico_id=0)
	and   (fc.doc_id = @doc_id or @doc_id=0)
	and   (fc.doct_id = @doct_id or @doct_id=0)
	and   (doc.emp_id = @emp_id or @emp_id=0)
	
	and   (@ccos_id=0 or fc.ccos_id 	= @ccos_id)
	and   (fc.suc_id 					= @suc_id  	or @suc_id=0)
	
	-- Arboles
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
	
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 6 
	                  and  rptarb_hojaid = prov.pro_id
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
	                  and  tbl_id = 29 
	                  and  rptarb_hojaid = fc.prov_id
								   ) 
	           )
	        or 
						 (@ram_id_proveedor = 0)
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
	                  and  rptarb_hojaid = fc.doc_id
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
	                  and  tbl_id = 4003
	                  and  rptarb_hojaid = fc.doct_id
								   ) 
	           )
	        or 
						 (@ram_id_documentoTipo = 0)
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
	                  and  tbl_id = 21 
	                  and  fc.ccos_id   = rptarb_hojaid
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
	                  and  rptarb_hojaid = fc.suc_id
								   ) 
	           )
	        or 
						 (@ram_id_sucursal = 0)
				 )

	order by 

		ccos_nombre,
		prov_nombre,
		fc_fecha,
		fc.doct_id

end