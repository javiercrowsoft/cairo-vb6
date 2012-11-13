/*---------------------------------------------------------------------
Nombre: Detalle de Compra de Articulos
---------------------------------------------------------------------*/
/*  

Para testear:

exec [DC_CSC_COM_0250] 1,'20070101 00:00:00','20071217 00:00:00','0','0','0','0','0','0',0,'0','1',0


*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_COM_0250]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_COM_0250]

go
create procedure DC_CSC_COM_0250 (

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

create table #t_dc_csc_com_0250(
			ccos_id				int,
			fecha 				datetime,
			pr_id					int,
			importe				decimal(18,6)
)

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

	insert into #t_dc_csc_com_0250(ccos_id, fecha, pr_id, importe)

	select  
					isnull(fci.ccos_id, fc.ccos_id),
					fc_fecha,
					fci.pr_id,

					sum (
								case when fc.doct_id = 8 then -fci_importe
										 else                      fci_importe
								end
							)	

	from facturacompra fc  inner join documento doc   				on fc.doc_id = doc.doc_id
												 inner join FacturaCompraItem fci		on fc.fc_id  = fci.fc_id 
												 left join centrocosto ccos on isnull(fci.ccos_id,fc.ccos_id) = ccos.ccos_id
							
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
	
	and   (fci.pr_id 				= @pr_id 				or @pr_id		=0)
	and   (fc.pro_id_origen = @pro_id 			or @pro_id	=0)
	and   (fc.prov_id 			= @prov_id			or @prov_id	=0)
	
	and   (doc.cico_id 			= @cico_id 			or @cico_id=0)
	and   (fc.doc_id 				= @doc_id 			or @doc_id=0)
	and   (fc.doct_id 			= @doct_id 			or @doct_id=0)
	and   (doc.emp_id 			= @emp_id 			or @emp_id=0)
	and   (fc.suc_id 				= @suc_id  			or @suc_id=0)
	
	and   (fci.ccos_id = @ccos_id or fc.ccos_id = @ccos_id or @ccos_id=0)

	
	-- Arboles
	and   (
						(exists(select rptarb_hojaid 
	                  from rptArbolRamaHoja 
	                  where
	                       rptarb_cliente = @clienteID
	                  and  tbl_id = 30
	                  and  rptarb_hojaid = fci.pr_id 
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
	                  and  rptarb_hojaid = fc.pro_id_origen
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

	group by

		isnull(fci.ccos_id, fc.ccos_id),
		fc.fc_fecha,
		fci.pr_id

	order by 

		fc_fecha


	create table #t_dc_csc_com_0250_meses (

												row_id int not null,

												ccos_id		int,
												pr_id			int,

												mes01 decimal(18,6) not null default(0),
												mes02 decimal(18,6) not null default(0),
												mes03 decimal(18,6) not null default(0),
												mes04 decimal(18,6) not null default(0),
												mes05 decimal(18,6) not null default(0),
												mes06 decimal(18,6) not null default(0),
												mes07 decimal(18,6) not null default(0),
												mes08 decimal(18,6) not null default(0),
												mes09 decimal(18,6) not null default(0),
												mes10 decimal(18,6) not null default(0),
												mes11 decimal(18,6) not null default(0),
												mes12 decimal(18,6) not null default(0)

												)

	declare c_facturas insensitive cursor for 
			select ccos_id, fecha, pr_id, importe from #t_dc_csc_com_0250 order by ccos_id, pr_id, fecha

	open c_facturas

	declare @importe decimal(18,6)
	declare @fecha   datetime

	declare @row_id int
	declare @mes int
	declare @fecha_mes1 datetime

	set @fecha_mes1 = dateadd(d,-(datepart(d,@@Fini)-1),@@Fini)

	declare @last_ccos_id int
	declare @last_pr_id   int

	set @last_ccos_id = 0
	set @last_pr_id = 0
	set @row_id = 0

	fetch next from c_facturas into @ccos_id, @fecha, @pr_id, @importe
	while @@fetch_status = 0
	begin

		if @last_ccos_id <> @ccos_id begin

			set @row_id = @row_id + 1

			insert into #t_dc_csc_com_0250_meses (row_id, ccos_id, pr_id)
																		 values(@row_id, @ccos_id, @pr_id)

			set @last_ccos_id = @ccos_id
			set @last_pr_id = @pr_id

		end else begin

			if @last_pr_id <> @pr_id begin

				set @row_id = @row_id + 1

				insert into #t_dc_csc_com_0250_meses (row_id, ccos_id, pr_id)
																			 values(@row_id, @ccos_id, @pr_id)
	
				set @last_pr_id = @pr_id

			end

		end

		set @mes = datediff(m,@fecha_mes1,@fecha)

		if @mes = 1  update #t_dc_csc_com_0250_meses set mes01 = mes01+@importe where row_id = @row_id
		if @mes = 2  update #t_dc_csc_com_0250_meses set mes02 = mes02+@importe where row_id = @row_id
		if @mes = 3  update #t_dc_csc_com_0250_meses set mes03 = mes03+@importe where row_id = @row_id
		if @mes = 4  update #t_dc_csc_com_0250_meses set mes04 = mes04+@importe where row_id = @row_id
		if @mes = 5  update #t_dc_csc_com_0250_meses set mes05 = mes05+@importe where row_id = @row_id
		if @mes = 6  update #t_dc_csc_com_0250_meses set mes06 = mes06+@importe where row_id = @row_id
		if @mes = 7  update #t_dc_csc_com_0250_meses set mes07 = mes07+@importe where row_id = @row_id
		if @mes = 8  update #t_dc_csc_com_0250_meses set mes08 = mes08+@importe where row_id = @row_id
		if @mes = 9  update #t_dc_csc_com_0250_meses set mes09 = mes09+@importe where row_id = @row_id
		if @mes = 10 update #t_dc_csc_com_0250_meses set mes10 = mes10+@importe where row_id = @row_id
		if @mes = 11 update #t_dc_csc_com_0250_meses set mes11 = mes11+@importe where row_id = @row_id
		if @mes = 12 update #t_dc_csc_com_0250_meses set mes12 = mes12+@importe where row_id = @row_id

		fetch next from c_facturas into @ccos_id, @fecha, @pr_id, @importe
	end

	close c_facturas
	deallocate c_facturas


	select 

			1 as aux_id,

			ccos_nombre     as [Centro de Costo],
			pr_nombrecompra as Articulo,

			t.*

	from #t_dc_csc_com_0250_meses t inner join Producto pr on t.pr_id = pr.pr_id
																	left  join CentroCosto ccos on t.ccos_id = ccos.ccos_id

	order by

		ccos_nombre,
		pr_nombrecompra

end