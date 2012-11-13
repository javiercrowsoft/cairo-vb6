if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_OrdenesServicio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_OrdenesServicio]
go

/*
select * from OrdenServicio

sp_docOrdenServicioget 47

sp_lsdoc_OrdenesServicio

  7,
	'20030101',
	'20050101',
		'0',
		'0',
		'0',
		'0',
		'0',
		'0',
		'0'

*/

create procedure sp_lsdoc_OrdenesServicio (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@cli_id  varchar(255),
@@est_id	varchar(255),
@@ccos_id	varchar(255),
@@suc_id	varchar(255),
@@doc_id	varchar(255),
@@cpg_id	varchar(255),
@@prns_id	varchar(255),
@@emp_id	varchar(255)
)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id int
declare @ccos_id int
declare @suc_id int
declare @est_id int
declare @doc_id int
declare @cpg_id int
declare @prns_id int
declare @emp_id int

declare @ram_id_Cliente int
declare @ram_id_CentroCosto int
declare @ram_id_Sucursal int
declare @ram_id_Estado int
declare @ram_id_Documento int
declare @ram_id_CondicionPago int 
declare @ram_id_ProductoNumeroSerie int 
declare @ram_id_Empresa int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_CentroCosto out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@cpg_id, @cpg_id out, @ram_id_CondicionPago out 
exec sp_ArbConvertId @@prns_id, @prns_id out, @ram_id_ProductoNumeroSerie out 
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

if @ram_id_CentroCosto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_CentroCosto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_CentroCosto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_CentroCosto, @clienteID 
	end else 
		set @ram_id_CentroCosto = 0
end

if @ram_id_Estado <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Estado, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Estado, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Estado, @clienteID 
	end else 
		set @ram_id_Estado = 0
end

if @ram_id_Sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
	end else 
		set @ram_id_Sucursal = 0
end

if @ram_id_Documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Documento, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Documento, @clienteID 
	end else 
		set @ram_id_Documento = 0
end

if @ram_id_CondicionPago <> 0 begin

--	exec sp_ArbGetGroups @ram_id_CondicionPago, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_CondicionPago, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_CondicionPago, @clienteID 
	end else 
		set @ram_id_CondicionPago = 0
end

if @ram_id_ProductoNumeroSerie <> 0 begin

--	exec sp_ArbGetGroups @ram_id_ProductoNumeroSerie, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_ProductoNumeroSerie, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_ProductoNumeroSerie, @clienteID 
	end else 
		set @ram_id_ProductoNumeroSerie = 0
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
-- sp_columns OrdenServicio


select 
			os_id,
			''									  as [TypeTask],
			os_numero             as [Número],
			os_nrodoc						  as [Comprobante],
			cli_nombre            as [Cliente],
      doc_nombre					  as [Documento],
	    est_nombre					  as [Estado],
			os_fecha						  as [Fecha],
			os_fechaentrega				as [Fecha de entrega],
			os_neto								as [Neto],
			os_ivari							as [IVA RI],
			os_ivarni							as [IVA RNI],
			os_subtotal						as [Subtotal],
			os_total							as [Total],
			os_pendiente					as [Pendiente],
			case os_firmado
				when 0 then 'No'
				else        'Si'
			end										as [Firmado],

			case impreso
				when 0 then 'No'
				else        'Si'
			end										as [Impreso],

			os_descuento1					as [% Desc. 1],
			os_descuento2					as [% Desc. 2],
			os_importedesc1				as [Desc. 1],
			os_importedesc2				as [Desc. 2],

	    lp_nombre						  as [Lista de Precios],
	    ld_nombre						  as [Lista de descuentos],
	    cpg_nombre					  as [Condicion de Pago],
	    ccos_nombre					  as [Centro de costo],
      suc_nombre					  as [Sucursal],
			emp_nombre            as [Empresa],

			OrdenServicio.Creado,
			OrdenServicio.Modificado,
			us_nombre             as [Modifico],
			os_descrip						as [Observaciones]
from 
			OrdenServicio inner join documento    on OrdenServicio.doc_id   = documento.doc_id
									 inner join empresa       on documento.emp_id       = empresa.emp_id
									 inner join estado        on OrdenServicio.est_id   = estado.est_id
									 inner join sucursal      on OrdenServicio.suc_id   = sucursal.suc_id
                   inner join Cliente     	on OrdenServicio.cli_id   = Cliente.cli_id
                   inner join usuario       on OrdenServicio.modifico = usuario.us_id
                   left join condicionpago  on OrdenServicio.cpg_id   = condicionpago.cpg_id
                   left join centrocosto    on OrdenServicio.ccos_id  = centrocosto.ccos_id
                   left join listaprecio    on OrdenServicio.lp_id    = listaprecio.lp_id
  								 left join listadescuento on OrdenServicio.ld_id    = listadescuento.ld_id
where 

				  @@Fini <= os_fecha
			and	@@Ffin >= os_fecha 		

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Cliente.cli_id = @cli_id or @cli_id=0)
and   (Estado.est_id = @est_id or @est_id=0)
and   (Sucursal.suc_id = @suc_id or @suc_id=0)
and   (Documento.doc_id = @doc_id or @doc_id=0)
and   (CondicionPago.cpg_id = @cpg_id or @cpg_id=0) 
and   (CentroCosto.ccos_id = @ccos_id or @ccos_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 28 
                  and  rptarb_hojaid = Cliente.cli_id
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
                  and  tbl_id = 21 
                  and  rptarb_hojaid = CentroCosto.ccos_id
							   ) 
           )
        or 
					 (@ram_id_CentroCosto = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 4005 
                  and  rptarb_hojaid = Estado.est_id
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
                  and  tbl_id = 1007 
                  and  rptarb_hojaid = Sucursal.suc_id
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
                  and  tbl_id = 4001 
                  and  rptarb_hojaid = Documento.doc_id
							   ) 
           )
        or 
					 (@ram_id_Documento = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1005 
                  and  rptarb_hojaid = CondicionPago.cpg_id
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
                  and  rptarb_hojaid = Empresa.emp_id
							   ) 
           )
        or 
					 (@ram_id_empresa = 0)
			 )

	-- Busqueda de numero de serie
	--
	and exists(
		select 1 from StockItem sti
		where st_id = OrdenServicio.st_id
			and   (sti.prns_id = @prns_id or @prns_id=0)
			and   (
								(exists(select rptarb_hojaid 
			                  from rptArbolRamaHoja 
			                  where
			                       rptarb_cliente = @clienteID
			                  and  tbl_id = 1017
			                  and  rptarb_hojaid = sti.prns_id
										   ) 
			           )
			        or 
								 (@ram_id_ProductoNumeroSerie = 0)
						 )
	
		)

	order by os_fecha, os_nrodoc
go