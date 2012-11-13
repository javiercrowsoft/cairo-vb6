if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_PartesReparacion]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_PartesReparacion]
go

/*
select * from ParteReparacion

sp_docParteReparacionget 47

sp_lsdoc_PartesReparacion 79,'20070101 00:00:00','20081231 00:00:00','0','0','0','0','0','0','0','0','0','0'

sp_lsdoc_PartesReparacion

  7,
	'20030101',
	'20090101',
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

create procedure sp_lsdoc_PartesReparacion (

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

@@cli_id  varchar(255),
@@est_id	varchar(255),
@@ccos_id	varchar(255),
@@suc_id	varchar(255),
@@us_id2	varchar(255),
@@doc_id	varchar(255),
@@cpg_id	varchar(255),

@@prns_id	varchar(255),
@@cont_id	varchar(255),

@@emp_id	varchar(255)

)as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cli_id int
declare @ccos_id int
declare @suc_id int
declare @est_id int
declare @us_id2 int
declare @doc_id int
declare @cpg_id int

declare @prns_id int
declare @cont_id int

declare @emp_id int

declare @ram_id_Cliente int
declare @ram_id_CentroCosto int
declare @ram_id_Sucursal int
declare @ram_id_Estado int
declare @ram_id_usuario2 int
declare @ram_id_Documento int
declare @ram_id_CondicionPago int 
declare @ram_id_serie int 
declare @ram_id_contacto int 
declare @ram_id_Empresa int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cli_id, @cli_id out, @ram_id_Cliente out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_CentroCosto out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@est_id, @est_id out, @ram_id_Estado out
exec sp_ArbConvertId @@us_id2, @us_id2 out, @ram_id_usuario2 out
exec sp_ArbConvertId @@doc_id, @doc_id out, @ram_id_Documento out
exec sp_ArbConvertId @@cpg_id, @cpg_id out, @ram_id_CondicionPago out 
exec sp_ArbConvertId @@prns_id, @prns_id out, @ram_id_serie out 
exec sp_ArbConvertId @@cont_id, @cont_id out, @ram_id_contacto out 
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

if @ram_id_usuario2 <> 0 begin

--	exec sp_ArbGetGroups @ram_id_usuario2, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_usuario2, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_usuario2, @clienteID 
	end else 
		set @ram_id_usuario2 = 0
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

if @ram_id_serie <> 0 begin

--	exec sp_ArbGetGroups @ram_id_serie, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_serie, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_serie, @clienteID 
	end else 
		set @ram_id_serie = 0
end

if @ram_id_contacto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_contacto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_contacto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_contacto, @clienteID 
	end else 
		set @ram_id_contacto = 0
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
-- sp_columns ParteReparacion


select 
			prp_id,
			''									  as [TypeTask],
			prp_numero            as [Número],
			prp_nrodoc						as [Comprobante],
	    cli_nombre            as [Cliente],
      doc_nombre					  as [Documento],

			case prp_tipo
					when 1 then 'Presupuesto'
          when 2 then 'Reparación'
			end                   as [Tipo],
      case prp_estado
					when 1 then 'Pendiente'
					when 2 then 'Rechazado'
					when 3 then 'En Aprobación'
					when 4 then 'Aprobado'
					when 5 then 'En Espera de Repuestos'
          else        'Sin definir'
      end                   as [Estado Rep.],

	    est_nombre					  as [Estado],
			prns_codigo           as [Nro. Serie],
			prns_codigo2          as [OT],
			prp_fecha						  as [Fecha],
			prp_fechaentrega			as [Fecha de entrega],
			prp_neto							as [Neto],
			prp_ivari							as [IVA RI],
			prp_ivarni						as [IVA RNI],
			prp_subtotal					as [Subtotal],
			prp_total							as [Total],
			prp_descuento1				as [% Desc. 1],
			prp_descuento2				as [% Desc. 2],
			prp_importedesc1			as [Desc. 1],
			prp_importedesc2			as [Desc. 2],

			us2.us_nombre					as [Técnico],
			
	    lp_nombre						  as [Lista de Precios],
	    ld_nombre						  as [Lista de descuentos],
	    cpg_nombre					  as [Condicion de Pago],
	    ccos_nombre					  as [Centro de costo],
      suc_nombre					  as [Sucursal],
			emp_nombre            as [Empresa],

			ParteReparacion.Creado,
			ParteReparacion.Modificado,
			usuario.us_nombre     as [Modifico],
			prp_descrip						as [Observaciones]
from 
			ParteReparacion 
									left join documento     on ParteReparacion.doc_id   = documento.doc_id
									left join empresa       on documento.emp_id     		 = empresa.emp_id
									left join estado        on ParteReparacion.est_id   = estado.est_id
									left join sucursal      on ParteReparacion.suc_id   = sucursal.suc_id
                  left join cliente       on ParteReparacion.cli_id   = cliente.cli_id
                  left join usuario       on ParteReparacion.modifico = usuario.us_id

									left join ProductoNumeroSerie prns on ParteReparacion.prns_id = prns.prns_id

									left  join Contacto cont on ParteReparacion.cont_id  = cont.cont_id

                  left join condicionpago  on ParteReparacion.cpg_id   = condicionpago.cpg_id
                  left join usuario us2    on ParteReparacion.us_id    = us2.us_id
                  left join centrocosto    on ParteReparacion.ccos_id  = centrocosto.ccos_id
                  left join listaprecio    on ParteReparacion.lp_id    = listaprecio.lp_id
  								left join listadescuento on ParteReparacion.ld_id    = listadescuento.ld_id
where 

				  @@Fini <= prp_fecha
			and	@@Ffin >= prp_fecha 		

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (Cliente.cli_id = @cli_id or @cli_id=0)
and   (Estado.est_id = @est_id or @est_id=0)
and   (Sucursal.suc_id = @suc_id or @suc_id=0)
and   (Documento.doc_id = @doc_id or @doc_id=0)
and   (CondicionPago.cpg_id = @cpg_id or @cpg_id=0) 
and   (CentroCosto.ccos_id = @ccos_id or @ccos_id=0)
and   (us2.us_id = @us_id2 or @us_id2=0)
and   (prns.prns_id = @prns_id or @prns_id=0)
and   (cont.cont_id = @cont_id or @cont_id=0)
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
                  and  tbl_id = 3 
                  and  rptarb_hojaid = us2.us_id
							   ) 
           )
        or 
					 (@ram_id_usuario2 = 0)
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
                  and  tbl_id = 1017 
                  and  rptarb_hojaid = prns.prns_id
							   ) 
           )
        or 
					 (@ram_id_serie = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 2001 
                  and  rptarb_hojaid = cont.cont_id
							   ) 
           )
        or 
					 (@ram_id_contacto = 0)
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

	order by prp_fecha, prp_nrodoc
	
end
go