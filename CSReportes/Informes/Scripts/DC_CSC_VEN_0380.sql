/*---------------------------------------------------------------------
Nombre: Detalle de Venta de Articulos
---------------------------------------------------------------------*/
/*  

Para testear:

DC_CSC_VEN_0380 1, 
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
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0380]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0380]

go
create procedure DC_CSC_VEN_0380 (

  @@us_id    		int,
	@@Fini 		 		datetime,
	@@Ffin 		 		datetime,

	@@pr_id           varchar(255),
  @@pro_id   				varchar(255),
  @@cli_id   				varchar(255),

  @@cico_id	 				varchar(255),
  @@ccos_id	   			varchar(255),
  @@suc_id	 				varchar(255),
  @@doct_id	 				int,
  @@doc_id	 				varchar(255),
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

declare @pr_id        int
declare @pro_id   		int
declare @cli_id   		int
declare @cico_id  		int
declare @doc_id   		int
declare @emp_id   		int

declare @ccos_id	    int
declare @suc_id	  		int

declare @ram_id_producto         int
declare @ram_id_provincia        int
declare @ram_id_Cliente        int
declare @ram_id_circuitoContable int
declare @ram_id_documento        int
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
exec sp_ArbConvertId @@cli_id,  		 @cli_id  out,  		@ram_id_Cliente		 				out
exec sp_ArbConvertId @@cico_id, 		 @cico_id out, 			@ram_id_circuitoContable 	out
exec sp_ArbConvertId @@doc_id,  		 @doc_id 	out,  		@ram_id_documento 				out
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

if @ram_id_Cliente <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Cliente, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Cliente, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Cliente, @clienteID 
	end else 
		set @ram_id_Cliente = 0
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

select 

							1 					 as orden_id,	

              fv.fv_id		as comp_id,
							fv.doct_id  as doct_id,

							fv.st_id    as comp_id2,
							st.doct_id  as doct_id2,

							fv_fecha              [Fecha],
							emp_nombre            [Empresa],
							doc.doc_nombre				[Documento],
							fv.fv_nrodoc          [Comprobante],
              fv.fv_numero          [Numero],

							doc2.doc_nombre				[Transferencia],
							st.st_nrodoc          [Trans. Comprobante],
              st.st_numero          [Trans. Numero],

							cli_nombre           [Cliente],

							fv.cli_id,

							pr_nombrecompra       [Articulo],
							pr_nombreventa        [Articulo Venta],

							fvi_cantidad     			[Cantidad],

							fvi_precio						[Precio],

							case when fv.doct_id = 7 then -fvi_neto
									 else                      fvi_neto
							end     							[Neto],

							case when fv.doct_id = 7 then -fvi_importe
									 else                      fvi_importe
							end        						[Importe],
							fvi_descrip           [Observaciones]

	
from 

	FacturaVenta	fv 

					 inner join documento doc   on fv.doc_id   = doc.doc_id
	         inner join empresa   emp   on doc.emp_id  = emp.emp_id

					 inner join FacturaVentaItem fvi		on 		fv.fv_id = fvi.fv_id 

					 inner join producto  pr    on fvi.pr_id = pr.pr_id
	
					 inner join Cliente cli  on fv.cli_id = cli.cli_id 

					 left join centroCosto ccos on fv.ccos_id  = ccos.ccos_id

	         left join moneda    mon          on fv.mon_id   = mon.mon_id
	         left join circuitocontable cico  on doc.cico_id = cico.cico_id	
	 	       left join provincia   pro        on cli.pro_id = pro.pro_id

					 left join Stock st 				on fv.st_id 	= st.st_id
					 left join documento doc2   on st.doc_id  = doc2.doc_id
where

				  fv_fecha >= @@Fini
			and	fv_fecha <= @@Ffin 

-- Validar usuario - empresa
			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
			and (
						exists(select * from UsuarioEmpresa where (@cli_id=0  or fv.cli_id = @cli_id) 
																									and us_id = @@us_id
									) 
						or (@us_empresaEx = 0)
					)

					
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (fvi.pr_id = @pr_id or @pr_id=0)

and   (@pro_id=0 or cli.pro_id = @pro_id)

and   (@cli_id=0 or fv.cli_id = @cli_id)

and   (doc.cico_id = @cico_id or @cico_id=0)
and   (fv.doc_id = @doc_id or @doc_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (@ccos_id=0 or fv.ccos_id 	= @ccos_id)
and   (fv.suc_id 					= @suc_id  	or @suc_id=0)

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
					 (@ram_id_Cliente = 0)
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
                  and  fv.ccos_id   = rptarb_hojaid
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
                  and  rptarb_hojaid = fv.suc_id
							   ) 
           )
        or 
					 (@ram_id_sucursal = 0)
			 )

union all

select 

							1 					 as orden_id,	

              rv.rv_id		as comp_id,
							rv.doct_id  as doct_id,
							rv.st_id    as comp_id2,
							st.doct_id  as doct_id2,

							rv_fecha              [Fecha],
							emp_nombre            [Empresa],
							doc.doc_nombre				[Documento],
							rv.rv_nrodoc          [Comprobante],
              rv.rv_numero          [Numero],

							doc2.doc_nombre				[Transferencia],
							st.st_nrodoc          [Trans. Comprobante],
              st.st_numero          [Trans. Numero],

							cli_nombre           	[Cliente],

							rv.cli_id,

							pr_nombrecompra       [Articulo],
							pr_nombreventa        [Articulo Venta],

							rvi_cantidad     			[Cantidad],

							rvi_precio						[Precio],
							case when rv.doct_id = 24 then -rvi_neto
									 else                       rvi_neto
							end                   [Neto],
							case when rv.doct_id = 24 then -rvi_importe           
									 else                       rvi_importe
              end                   [Importe],
							rvi_descrip           [Observaciones]
	
from 

	RemitoVenta	rv 

					 inner join documento doc   on rv.doc_id   = doc.doc_id
	         inner join empresa   emp   on doc.emp_id  = emp.emp_id

					 inner join RemitoVentaItem rvi		on 		rv.rv_id = rvi.rv_id 

					 inner join producto  pr    on rvi.pr_id = pr.pr_id
	
					 inner join Cliente cli  on rv.cli_id = cli.cli_id 

					 left join centroCosto ccos on rv.ccos_id  = ccos.ccos_id

	         left join moneda    mon          on doc.mon_id   = mon.mon_id
	         left join circuitocontable cico  on doc.cico_id = cico.cico_id	
	 	       left join provincia   pro        on cli.pro_id = pro.pro_id

					 left join Stock st 				on rv.st_id 	= st.st_id
					 left join documento doc2   on st.doc_id  = doc2.doc_id

where

				  rv_fecha >= @@Fini
			and	rv_fecha <= @@Ffin 

-- Validar usuario - empresa
			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
			and (
						exists(select * from UsuarioEmpresa where (@cli_id=0  or rv.cli_id = @cli_id) 
																									and us_id = @@us_id
									) 
						or (@us_empresaEx = 0)
					)

					
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (rvi.pr_id = @pr_id or @pr_id=0)

and   (@pro_id=0 or cli.pro_id = @pro_id)

and   (@cli_id=0 or rv.cli_id = @cli_id)

and   (doc.cico_id = @cico_id or @cico_id=0)
and   (rv.doc_id = @doc_id or @doc_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (@ccos_id=0 or rv.ccos_id 	= @ccos_id)
and   (rv.suc_id 					= @suc_id  	or @suc_id=0)

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
					 (@ram_id_Cliente = 0)
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
                  and  rv.ccos_id   = rptarb_hojaid
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
                  and  rptarb_hojaid = rv.suc_id
							   ) 
           )
        or 
					 (@ram_id_sucursal = 0)
			 )

order by Fecha, Documento, Cliente

end
go

