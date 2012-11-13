if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_PedidosCompra]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_PedidosCompra]
go

/*
select * from PedidoCompra

sp_docPedidoCompraget 47

sp_lsdoc_PedidosCompra

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

create procedure sp_lsdoc_PedidosCompra (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@us_id_usuario   varchar(255),
@@est_id					varchar(255),
@@ccos_id					varchar(255),
@@suc_id					varchar(255),
@@doc_id					varchar(255),
@@emp_id					varchar(255)
)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @us_id   int
declare @ccos_id int
declare @suc_id int
declare @est_id int
declare @doc_id int
declare @emp_id int

declare @ram_id_Usuario int
declare @ram_id_CentroCosto int
declare @ram_id_Sucursal int
declare @ram_id_Estado int
declare @ram_id_Documento int
declare @ram_id_Empresa int 

declare @ClienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@us_id_usuario, @us_id out, @ram_id_Usuario out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_CentroCosto out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

exec sp_GetRptId @ClienteID out

if @ram_id_Usuario <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Usuario, @ClienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Usuario, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Usuario, @ClienteID 
	end else 
		set @ram_id_Usuario = 0
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
-- sp_columns PedidoCompra


select 
			pc_id,
			''									  as [TypeTask],
			pc_numero             as [Número],
			pc_nrodoc						  as [Comprobante],
	    us2.us_nombre         as [Usuario],
      doc_nombre					  as [Documento],
	    est_nombre					  as [Estado],
			pc_fecha						  as [Fecha],
			pc_fechaentrega				as [Fecha de entrega],
			pc_neto								as [Neto],
			pc_ivari							as [IVA RI],
			pc_ivarni							as [IVA RNI],
			pc_subtotal						as [Subtotal],
			pc_total							as [Total],
			pc_pendiente					as [Pendiente],
			case pc_firmado
				when 0 then 'No'
				else        'Si'
			end										as [Firmado],

	    lp_nombre						  as [Lista de Precios],
	    ccos_nombre					  as [Centro de costo],
      suc_nombre					  as [Sucursal],
			emp_nombre            as [Empresa],

			PedidoCompra.Creado,
			PedidoCompra.Modificado,
			us1.us_nombre         as [Modifico],
			pc_descrip						as [Observaciones]
from 
			PedidoCompra inner join documento     on PedidoCompra.doc_id   = documento.doc_id
									 inner join empresa       on documento.emp_id      = empresa.emp_id
									 inner join estado        on PedidoCompra.est_id   = estado.est_id
									 inner join sucursal      on PedidoCompra.suc_id   = sucursal.suc_id
                   inner join usuario us2   on PedidoCompra.us_id    = us2.us_id
                   inner join usuario us1   on PedidoCompra.modifico = us1.us_id
                   left join centrocosto    on PedidoCompra.ccos_id  = centrocosto.ccos_id
                   left join listaprecio    on PedidoCompra.lp_id    = listaprecio.lp_id

where 

				  @@Fini <= pc_fecha
			and	@@Ffin >= pc_fecha 		

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (us2.us_id = @us_id or @us_id=0)
and   (Estado.est_id = @est_id or @est_id=0)
and   (Sucursal.suc_id = @suc_id or @suc_id=0)
and   (Documento.doc_id = @doc_id or @doc_id=0)
and   (CentroCosto.ccos_id = @ccos_id or @ccos_id=0)
and   (Empresa.emp_id = @emp_id or @emp_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @ClienteID
                  and  tbl_id = 29 
                  and  rptarb_hojaid = us2.us_id
							   ) 
           )
        or 
					 (@ram_id_Usuario = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @ClienteID
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
                       rptarb_cliente = @ClienteID
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
                       rptarb_cliente = @ClienteID
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
                       rptarb_cliente = @ClienteID
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
                  and  tbl_id = 1018 
                  and  rptarb_hojaid = Empresa.emp_id
							   ) 
           )
        or 
					 (@ram_id_empresa = 0)
			 )

	order by pc_fecha
go