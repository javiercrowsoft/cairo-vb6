/*---------------------------------------------------------------------
Nombre: Detalle de comprobantes de facuracion
---------------------------------------------------------------------*/
/*  

Para testear:
select * from documentotipo
DC_CSC_VEN_0200 1, '20050311','20050311','0', '0','0','0','0','0','0','0'
,'0','0', 1,'0','0','0','0','0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0200]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0200]

go
create procedure DC_CSC_VEN_0200 (

  @@us_id    		int,
	@@Fini 		 		datetime,
	@@Ffin 		 		datetime,

	@@est_id					varchar(255),
  @@pro_id   				varchar(255),
  @@cli_id   				varchar(255),
  @@ven_id	 				varchar(255),
  @@cico_id	 				varchar(255),
  @@ccos_id	   			varchar(255),
  @@ccos_id_item	 	varchar(255),
  @@cpg_id	 				varchar(255),
  @@lp_id	   				varchar(255),
  @@ld_id  	 				varchar(255),
  @@suc_id	 				varchar(255),
  @@doct_id	 				varchar(255),
  @@doc_id	 				varchar(255),
  @@mon_id	 				varchar(255),
  @@trans_id 				varchar(255),
  @@depl_id	 				varchar(255),
  @@emp_id	 				varchar(255)

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

declare @est_id 			int
declare @pro_id   		int
declare @cli_id   		int
declare @ven_id   		int
declare @cico_id  		int
declare @doc_id   		int
declare @doct_id   		int
declare @mon_id   		int
declare @emp_id   		int

declare @ccos_id	    int
declare @ccos_id_item	int
declare @cpg_id	  		int
declare @lp_id	  		int
declare @ld_id  			int
declare @suc_id	  		int
declare @trans_id 		int
declare @depl_id			int


declare @ram_id_Estado 					 int
declare @ram_id_provincia        int
declare @ram_id_cliente          int
declare @ram_id_vendedor         int
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
declare @ram_id_depositoLogico   int

declare @clienteID int
declare @clienteIDccosi int

declare @IsRaiz    tinyint

exec sp_ArbConvertId @@est_id, 			 @est_id out, 			@ram_id_Estado out
exec sp_ArbConvertId @@pro_id,  		 @pro_id out,  			@ram_id_provincia out
exec sp_ArbConvertId @@cli_id,  		 @cli_id out,  			@ram_id_cliente out
exec sp_ArbConvertId @@ven_id,  		 @ven_id out,  			@ram_id_vendedor out
exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 			@ram_id_circuitoContable out
exec sp_ArbConvertId @@doc_id,  		 @doc_id out,  			@ram_id_documento out
exec sp_ArbConvertId @@doct_id,  		 @doct_id out,  		@ram_id_documentoTipo out
exec sp_ArbConvertId @@mon_id,  		 @mon_id out,  			@ram_id_moneda out
exec sp_ArbConvertId @@emp_id,  		 @emp_id out,  			@ram_id_empresa out
exec sp_ArbConvertId @@ccos_id, 		 @ccos_id out, 			@ram_id_centroCosto out
exec sp_ArbConvertId @@ccos_id_item, @ccos_id_item out, @ram_id_centroCostoItem out
exec sp_ArbConvertId @@cpg_id, 			 @cpg_id out, 			@ram_id_condicionPago out
exec sp_ArbConvertId @@lp_id,        @lp_id out, 				@ram_id_listaPrecio out
exec sp_ArbConvertId @@ld_id,        @ld_id out, 				@ram_id_listaDescuento out
exec sp_ArbConvertId @@suc_id,       @suc_id out, 			@ram_id_sucursal out
exec sp_ArbConvertId @@trans_id,     @trans_id out, 		@ram_id_transporte out
exec sp_ArbConvertId @@depl_id,      @depl_id out, 			@ram_id_depositoLogico out

exec sp_GetRptId @clienteID out
exec sp_GetRptId @clienteIDccosi out

if @ram_id_Estado <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
	end else 
		set @ram_id_Estado = 0
end

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

	exec sp_ArbIsRaiz @ram_id_listaDescuento, @IsRaiz out
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

if @ram_id_transporte <> 0 begin

--	exec sp_ArbGetGroups @ram_id_transporte, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_transporte, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_transporte, @clienteID 
	end else 
		set @ram_id_transporte = 0
end

if @ram_id_depositoLogico <> 0 begin

--	exec sp_ArbGetGroups @ram_id_depositoLogico, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_depositoLogico, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_depositoLogico, @clienteID 
	end else 
		set @ram_id_depositoLogico = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES
select * from producto
/////////////////////////////////////////////////////////////////////// */
select 
		fv.fv_id        as id,
		1               as tipo_id,
		cli_nombre			as Cliente,
		cli_codigo			as Codigo,
		doct_nombre			as Tipo,
		doc_nombre			as Documento,
		fv_nrodoc				as Comprobante,
		fv_fecha				as Fecha,
		cpg_nombre			as [Condicion de Pago],
		pr_nombreVenta  as Articulo,
		pr_codigo				as [Codigo Articulo],
		fvi_cantidad		as Cantidad,
		depl_nombre     as Deposito,
		fv_descuento1   as Descuento,
		case	
			when doct.doct_id = 7 then -fvi_precio
		else fvi_precio
		end             as Precio,
		case	
			when doct.doct_id = 7 then -fvi_neto
		else fvi_neto
		end             as Neto

from
	facturaVenta fv inner join cliente          cli  on fv.cli_id  = cli.cli_id
									inner join condicionPago    cpg  on fv.cpg_id  = cpg.cpg_id
									inner join facturaVentaItem fvi  on fv.fv_id   = fvi.fv_id
									inner join producto         pr   on fvi.pr_id  = pr.pr_id
									inner join documentoTipo    doct on fv.doct_id = doct.doct_id
									inner join documento        doc  on fv.doc_id  = doc.doc_id

                  inner join moneda    mon         on fv.mon_id   = mon.mon_id
                  inner join circuitocontable cico on doc.cico_id = cico.cico_id
                  inner join empresa   emp         on doc.emp_id  = emp.emp_id

									left join centroCosto ccos       on fvi.ccos_id = ccos.ccos_id
           	      left join provincia   pro        on cli.pro_id  = pro.pro_id
                  left join stock       st         on fv.st_id    = st.st_id
									left join depositoLogico depl		 on st.depl_id_origen = depl.depl_id
where 

				  fv_fecha >= @@Fini
			and	fv_fecha <= @@Ffin 

			and fv.est_id <> 7

			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
			and (
						exists(select * from UsuarioEmpresa where cli_id = fv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (fv.est_id = @est_id or @est_id=0)
and   (cli.pro_id = @pro_id or @pro_id=0)
and   (fv.cli_id = @cli_id or @cli_id=0)
and   (		IsNull(fv.ven_id,0) 	= @ven_id
			 or	IsNull(cli.ven_id,0) 	= @ven_id
			 or @ven_id	=0
			)
and   (doc.cico_id = @cico_id or @cico_id=0)
and   (fv.doct_id = @doct_id or @doct_id=0)
and   (fv.doc_id = @doc_id or @doc_id=0)
and   (fv.mon_id = @mon_id or @mon_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (fv.ccos_id = @ccos_id or @ccos_id=0)
and   (fvi.ccos_id = @ccos_id_item or @ccos_id_item=0)
and   (fv.cpg_id = @cpg_id or @cpg_id=0)
and   (fv.lp_id = @lp_id or @lp_id=0)

and   (fv.ld_id = @ld_id or @ld_id=0)
and   (fv.suc_id = @suc_id or @suc_id=0)
and   (fv.trans_id = @trans_id or @trans_id=0)
and   (st.depl_id_origen = @depl_id or @depl_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4005 
                  and  rptarb_hojaid = fv.est_id
							   ) 
           )
        or 
					 (@ram_id_Estado = 0)
			 )

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
                  and  (		rptarb_hojaid = isnull(fv.ven_id,0)
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
                  and  tbl_id = 4003
                  and  rptarb_hojaid = fv.doct_id
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
                  and  tbl_id = 21 
                  and  rptarb_hojaid = fv.ccos_id
							   ) 
           )
        or 
					 (@ram_id_centroCosto = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteIDccosi
                  and  tbl_id = 21 
                  and  rptarb_hojaid = fvi.ccos_id
							   ) 
           )
        or 
					 (@ram_id_centroCostoItem = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1005 
                  and  rptarb_hojaid = fv.cpg_id
							   ) 
           )
        or 
					 (@ram_id_condicionPago = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 27 
                  and  rptarb_hojaid = fv.lp_id
							   ) 
           )
        or 
					 (@ram_id_listaPrecio = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1006 
                  and  rptarb_hojaid = fv.ld_id
							   ) 
           )
        or 
					 (@ram_id_listaDescuento = 0)
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
					 (@ram_id_sucursal = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 34 
                  and  rptarb_hojaid = fv.trans_id
							   ) 
           )
        or 
					 (@ram_id_transporte = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 
                  and  rptarb_hojaid = st.depl_id_origen
							   ) 
           )
        or 
					 (@ram_id_depositoLogico = 0)
			 )
------------------------------------------------------------------------------------------------------------------
union all
------------------------------------------------------------------------------------------------------------------
select 
		rv.rv_id        as id,
		1               as tipo_id,
		cli_nombre			as Cliente,
		cli_codigo			as Codigo,
		doct_nombre			as Tipo,
		doc_nombre			as Documento,
		rv_nrodoc				as Comprobante,
		rv_fecha				as Fecha,
		cpg_nombre			as [Condicion de Pago],
		pr_nombreVenta  as Articulo,
		pr_codigo				as [Codigo Articulo],
		rvi_cantidad		as Cantidad,
		depl_nombre     as Deposito,
		rv_descuento1		as Descuento,
		case	
			when doct.doct_id = 24 then -rvi_precio 
		else rvi_precio
		end             as Precio,
		case	
			when doct.doct_id = 24 then -rvi_neto 
		else rvi_neto
		end             as Neto

from
	remitoVenta rv inner join cliente          cli  on rv.cli_id  = cli.cli_id
								 inner join condicionPago    cpg  on rv.cpg_id  = cpg.cpg_id
								 inner join remitoVentaItem  rvi  on rv.rv_id   = rvi.rv_id
								 inner join producto         pr   on rvi.pr_id  = pr.pr_id
								 inner join documentoTipo    doct on rv.doct_id = doct.doct_id
								 inner join documento        doc  on rv.doc_id  = doc.doc_id


                  inner join moneda    mon         on doc.mon_id  = mon.mon_id
                  inner join circuitocontable cico on doc.cico_id = cico.cico_id
                  inner join empresa   emp         on doc.emp_id  = emp.emp_id

									left join centroCosto ccos       on rvi.ccos_id = ccos.ccos_id
           	      left join provincia   pro        on cli.pro_id  = pro.pro_id
                  left join stock       st         on rv.st_id    = st.st_id
									left join depositoLogico depl		 on st.depl_id_origen = depl.depl_id
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

and   (rv.est_id = @est_id or @est_id=0)
and   (cli.pro_id = @pro_id or @pro_id=0)
and   (rv.cli_id = @cli_id or @cli_id=0)
and   (		IsNull(rv.ven_id,0) 	= @ven_id
			 or	IsNull(cli.ven_id,0) 	= @ven_id
			 or @ven_id	=0
			)
and   (doc.cico_id = @cico_id or @cico_id=0)
and   (rv.doct_id = @doct_id or @doct_id=0)
and   (rv.doc_id = @doc_id or @doc_id=0)
and   (doc.mon_id = @mon_id or @mon_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (rv.ccos_id = @ccos_id or @ccos_id=0)
and   (rvi.ccos_id = @ccos_id_item or @ccos_id_item=0)
and   (rv.cpg_id = @cpg_id or @cpg_id=0)
and   (rv.lp_id = @lp_id or @lp_id=0)

and   (rv.ld_id = @ld_id or @ld_id=0)
and   (rv.suc_id = @suc_id or @suc_id=0)
and   (st.depl_id_origen = @depl_id or @depl_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4005 
                  and  rptarb_hojaid = rv.est_id
							   ) 
           )
        or 
					 (@ram_id_Estado = 0)
			 )

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
                  and  (		rptarb_hojaid = isnull(rv.ven_id,0)
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
                  and  tbl_id = 4003
                  and  rptarb_hojaid = rv.doct_id
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
                  and  tbl_id = 21 
                  and  rptarb_hojaid = rv.ccos_id
							   ) 
           )
        or 
					 (@ram_id_centroCosto = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteIDccosi
                  and  tbl_id = 21 
                  and  rptarb_hojaid = rvi.ccos_id
							   ) 
           )
        or 
					 (@ram_id_centroCostoItem = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1005 
                  and  rptarb_hojaid = rv.cpg_id
							   ) 
           )
        or 
					 (@ram_id_condicionPago = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 27 
                  and  rptarb_hojaid = rv.lp_id
							   ) 
           )
        or 
					 (@ram_id_listaPrecio = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1006 
                  and  rptarb_hojaid = rv.ld_id
							   ) 
           )
        or 
					 (@ram_id_listaDescuento = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 
                  and  rptarb_hojaid = rv.suc_id
							   ) 
           )
        or 
					 (@ram_id_sucursal = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 
                  and  rptarb_hojaid = st.depl_id_origen
							   ) 
           )
        or 
					 (@ram_id_depositoLogico = 0)
			 )

------------------------------------------------------------------------------------------------------------------
union all
------------------------------------------------------------------------------------------------------------------
select 
		pv.pv_id        as id,
		1               as tipo_id,
		cli_nombre			as Cliente,
		cli_codigo			as Codigo,
		doct_nombre			as Tipo,
		doc_nombre			as Documento,
		pv_nrodoc				as Comprobante,
		pv_fecha				as Fecha,
		cpg_nombre			as [Condicion de Pago],
		pr_nombreVenta  as Articulo,
		pr_codigo				as [Codigo Articulo],
		pvi_cantidad		as Cantidad,
		''     					as Deposito,
		pv_descuento1		as Descuento,
		case	
			when doct.doct_id = 22 then -pvi_precio 
		else pvi_precio
		end             as Precio,
		case	
			when doct.doct_id = 22 then -pvi_neto 
		else pvi_neto
		end             as Neto

from
	PedidoVenta pv inner join cliente          cli  on pv.cli_id  = cli.cli_id
								 inner join condicionPago    cpg  on pv.cpg_id  = cpg.cpg_id
								 inner join PedidoVentaItem  pvi  on pv.pv_id   = pvi.pv_id
								 inner join producto         pr   on pvi.pr_id  = pr.pr_id
								 inner join documentoTipo    doct on pv.doct_id = doct.doct_id
								 inner join documento        doc  on pv.doc_id  = doc.doc_id


                  inner join moneda    mon         on doc.mon_id  = mon.mon_id
                  inner join circuitocontable cico on doc.cico_id = cico.cico_id
                  inner join empresa   emp         on doc.emp_id  = emp.emp_id

									left join centroCosto ccos       on pvi.ccos_id = ccos.ccos_id
           	      left join provincia   pro        on cli.pro_id  = pro.pro_id
where 

				  pv_fecha >= @@Fini
			and	pv_fecha <= @@Ffin 

			and pv.est_id <> 7

			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
			and (
						exists(select * from UsuarioEmpresa where cli_id = pv.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)
					

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (pv.est_id = @est_id or @est_id=0)
and   (cli.pro_id = @pro_id or @pro_id=0)
and   (pv.cli_id = @cli_id or @cli_id=0)
and   (		IsNull(pv.ven_id,0) 	= @ven_id
			 or	IsNull(cli.ven_id,0) 	= @ven_id
			 or @ven_id	=0
			)
and   (doc.cico_id = @cico_id or @cico_id=0)
and   (pv.doct_id = @doct_id or @doct_id=0)
and   (pv.doc_id = @doc_id or @doc_id=0)
and   (doc.mon_id = @mon_id or @mon_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (pv.ccos_id = @ccos_id or @ccos_id=0)
and   (pvi.ccos_id = @ccos_id_item or @ccos_id_item=0)
and   (pv.cpg_id = @cpg_id or @cpg_id=0)
and   (pv.lp_id = @lp_id or @lp_id=0)

and   (pv.ld_id = @ld_id or @ld_id=0)
and   (pv.suc_id = @suc_id or @suc_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4005 
                  and  rptarb_hojaid = pv.est_id
							   ) 
           )
        or 
					 (@ram_id_Estado = 0)
			 )

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
                  and  tbl_id = 4003
                  and  rptarb_hojaid = pv.doct_id
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
                       rptarb_cliente = @clienteIDccosi
                  and  tbl_id = 21 
                  and  rptarb_hojaid = pvi.ccos_id
							   ) 
           )
        or 
					 (@ram_id_centroCostoItem = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1005 
                  and  rptarb_hojaid = pv.cpg_id
							   ) 
           )
        or 
					 (@ram_id_condicionPago = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 27 
                  and  rptarb_hojaid = pv.lp_id
							   ) 
           )
        or 
					 (@ram_id_listaPrecio = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1006 
                  and  rptarb_hojaid = pv.ld_id
							   ) 
           )
        or 
					 (@ram_id_listaDescuento = 0)
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

------------------------------------------------------------------------------------------------------------------
union all
------------------------------------------------------------------------------------------------------------------
select 
		os.os_id        as id,
		1               as tipo_id,
		cli_nombre			as Cliente,
		cli_codigo			as Codigo,
		doct_nombre			as Tipo,
		doc_nombre			as Documento,
		os_nrodoc				as Comprobante,
		os_fecha				as Fecha,
		cpg_nombre			as [Condicion de Pago],
		pr_nombreVenta  as Articulo,
		pr_codigo				as [Codigo Articulo],
		osi_cantidad		as Cantidad,
		depl_nombre     as Deposito,
		os_descuento1		as Descuento,
		case	
			when doct.doct_id = 24 then -osi_precio 
		else osi_precio
		end             as Precio,
		case	
			when doct.doct_id = 24 then -osi_neto 
		else osi_neto
		end             as Neto

from
	OrdenServicio os inner join cliente          	cli  on os.cli_id  = cli.cli_id
									 inner join condicionPago    	cpg  on os.cpg_id  = cpg.cpg_id
									 inner join OrdenServicioItem osi  on os.os_id   = osi.os_id
									 inner join producto         	pr   on osi.pr_id  = pr.pr_id
									 inner join documentoTipo    	doct on os.doct_id = doct.doct_id
									 inner join documento        	doc  on os.doc_id  = doc.doc_id


                  inner join moneda    mon         on doc.mon_id  = mon.mon_id
                  inner join circuitocontable cico on doc.cico_id = cico.cico_id
                  inner join empresa   emp         on doc.emp_id  = emp.emp_id

									left join centroCosto ccos       on osi.ccos_id = ccos.ccos_id
           	      left join provincia   pro        on cli.pro_id  = pro.pro_id
                  left join stock       st         on os.st_id    = st.st_id
									left join depositoLogico depl		 on st.depl_id_origen = depl.depl_id
where 

				  os_fecha >= @@Fini
			and	os_fecha <= @@Ffin 

			and os.est_id <> 7

			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
			and (
						exists(select * from UsuarioEmpresa where cli_id = os.cli_id and us_id = @@us_id) or (@us_empresaEx = 0)
					)
					

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (os.est_id = @est_id or @est_id=0)
and   (cli.pro_id = @pro_id or @pro_id=0)
and   (os.cli_id = @cli_id or @cli_id=0)
and   (doc.cico_id = @cico_id or @cico_id=0)
and   (os.doct_id = @doct_id or @doct_id=0)
and   (os.doc_id = @doc_id or @doc_id=0)
and   (doc.mon_id = @mon_id or @mon_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (os.ccos_id = @ccos_id or @ccos_id=0)
and   (osi.ccos_id = @ccos_id_item or @ccos_id_item=0)
and   (os.cpg_id = @cpg_id or @cpg_id=0)
and   (os.lp_id = @lp_id or @lp_id=0)

and   (os.ld_id = @ld_id or @ld_id=0)
and   (os.suc_id = @suc_id or @suc_id=0)
and   (st.depl_id_origen = @depl_id or @depl_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4005 
                  and  rptarb_hojaid = os.est_id
							   ) 
           )
        or 
					 (@ram_id_Estado = 0)
			 )

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
                  and  rptarb_hojaid = os.cli_id
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
                  and  rptarb_hojaid = os.doc_id
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
                  and  rptarb_hojaid = os.doct_id
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
                  and  tbl_id = 21 
                  and  rptarb_hojaid = os.ccos_id
							   ) 
           )
        or 
					 (@ram_id_centroCosto = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteIDccosi
                  and  tbl_id = 21 
                  and  rptarb_hojaid = osi.ccos_id
							   ) 
           )
        or 
					 (@ram_id_centroCostoItem = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1005 
                  and  rptarb_hojaid = os.cpg_id
							   ) 
           )
        or 
					 (@ram_id_condicionPago = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 27 
                  and  rptarb_hojaid = os.lp_id
							   ) 
           )
        or 
					 (@ram_id_listaPrecio = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1006 
                  and  rptarb_hojaid = os.ld_id
							   ) 
           )
        or 
					 (@ram_id_listaDescuento = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 
                  and  rptarb_hojaid = os.suc_id
							   ) 
           )
        or 
					 (@ram_id_sucursal = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 
                  and  rptarb_hojaid = st.depl_id_origen
							   ) 
           )
        or 
					 (@ram_id_depositoLogico = 0)
			 )

order by tipo_id, cliente, fecha, comprobante


end


go


