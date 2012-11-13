/*---------------------------------------------------------------------
Nombre: Detalle de numeros de serie
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0110]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0110]

/*
DC_CSC_STK_0110 1,619,0
*/

go
create procedure DC_CSC_STK_0110 (

  @@us_id     int,
  @@pr_id     varchar(255),
  @@prns_id   varchar(255),
	@@depl_id 	varchar(255),
	@@depf_id		varchar(255)

)as 
begin
set nocount on
/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id int
declare @prns_id int
declare @depl_id int
declare @depf_id int

declare @ram_id_producto int
declare @ram_id_productoserie int
declare @ram_id_DepositoLogico int
declare @ram_id_DepositoFisico int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_producto out
exec sp_ArbConvertId @@prns_id, @prns_id out, @ram_id_productoserie out
exec sp_ArbConvertId @@depl_id, @depl_id out, @ram_id_DepositoLogico out
exec sp_ArbConvertId @@depf_id, @depf_id out, @ram_id_DepositoFisico out

exec sp_GetRptId @clienteID out

if @@prns_id = '0' and @@pr_id = '0' and @@depl_id = '0' begin
  select 1,'Debe indicar un articulo o un numero de serie, no puede dejar los dos campos en blanco'
  return
end

if @ram_id_producto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
	end else 
		set @ram_id_producto = 0
end

if @ram_id_productoserie <> 0 begin

--	exec sp_ArbGetGroups @ram_id_productoserie, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_productoserie, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_productoserie, @clienteID 
	end else 
		set @ram_id_productoserie = 0
end

if @ram_id_DepositoLogico <> 0 begin

--	exec sp_ArbGetGroups @ram_id_DepositoLogico, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_DepositoLogico, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_DepositoLogico, @clienteID 
	end else 
		set @ram_id_DepositoLogico = 0
end

if @ram_id_DepositoFisico <> 0 begin

--	exec sp_ArbGetGroups @ram_id_DepositoFisico, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_DepositoFisico, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_DepositoFisico, @clienteID 
	end else 
		set @ram_id_DepositoFisico = 0
end

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


select 

  p.pr_id,
  p.pr_nombrecompra    as [Nombre Compra],
  p.pr_nombreventa     as [Nombre Venta],
  prns_codigo          as [Nro Serie],
  prns_fechavto        as [Fecha Vto],
  d.depl_nombre        as [Deposito Actual],
  pk.pr_nombreventa    as [Usado en Kit],
  prov_nombre          as [Proveedor],
  cli_nombre           as [Cliente],

  (select case doct_id_ingreso
            when 2 then (select emp_nombre from FacturaCompra f inner join Documento d on f.doc_id = d.doc_id
																																inner join Empresa e   on d.emp_id = e.emp_id
                         where fc_id = doc_id_ingreso)
            when 4 then (select emp_nombre from RemitoCompra r  inner join Documento d on r.doc_id = d.doc_id
																																inner join Empresa e   on d.emp_id = e.emp_id
                         where rc_id = doc_id_ingreso)
          end) as  [Empresa Ingreso],

  (select case doct_id_salida
            when 1 then (select emp_nombre from FacturaVenta f 	inner join Documento d on f.doc_id = d.doc_id
																																inner join Empresa e   on d.emp_id = e.emp_id
                         where fv_id = doc_id_salida)
            when 3 then (select emp_nombre from RemitoVenta r 	inner join Documento d on r.doc_id = d.doc_id
																																inner join Empresa e   on d.emp_id = e.emp_id
                         where rv_id = doc_id_salida)
          end) as  [Empresa Egreso],

	empp.emp_nombre      as [Empresa Produccion],

  (select case doct_id_ingreso
            when 2 then (select fc_fecha from FacturaCompra f
                         where fc_id = doc_id_ingreso)
            when 4 then (select rc_fecha from RemitoCompra r
                         where rc_id = doc_id_ingreso)
          end) as  [Fecha Ingreso],
  (select case doct_id_ingreso
            when 2 then (select doc_nombre + ' ' + fc_nrodoc from FacturaCompra f inner join Documento d on f.doc_id = d.doc_id
                         where fc_id = doc_id_ingreso)
            when 4 then (select doc_nombre + ' ' + rc_nrodoc from RemitoCompra r inner join Documento d on r.doc_id = d.doc_id
                         where rc_id = doc_id_ingreso)
          end) as  [Doc Ingreso],

  ppk_fecha                          as [Fecha Parte],
  dppk.doc_nombre + ' ' + ppk_nrodoc as [Doc Parte],

  (select case doct_id_salida
            when 1 then (select fv_fecha from FacturaVenta f
                         where fv_id = doc_id_salida)
            when 3 then (select rv_fecha from RemitoVenta r
                         where rv_id = doc_id_salida)
          end) as  [Fecha Egreso],
  (select case doct_id_salida
            when 1 then (select doc_nombre + ' ' + fv_nrodoc from FacturaVenta f inner join Documento d on f.doc_id = d.doc_id
                         where fv_id = doc_id_salida)
            when 3 then (select doc_nombre + ' ' + rv_nrodoc from RemitoVenta r inner join Documento d on r.doc_id = d.doc_id
                         where rv_id = doc_id_salida)
          end) as  [Doc Egreso],

  prns_descrip         as [Observaciones]

from 

-- Listado de tablas que corresponda	
ProductoNumeroSerie ps inner join Producto p        on ps.pr_id     = p.pr_id
                       inner join DepositoLogico d  on ps.depl_id   = d.depl_id
                       inner join DepositoFisico df on d.depf_id    = df.depf_id
                       left  join Producto pk      on ps.pr_id_kit  = pk.pr_id
                       left  join Cliente cl       on ps.cli_id     = cl.cli_id
                       left  join Proveedor prov   on ps.prov_id    = prov.prov_id
                       left  join ParteProdKit ppk on ps.ppk_id     = ppk.ppk_id
                       left  join Documento dppk   on ppk.doc_id    = dppk.doc_id
											 left  join Empresa empp     on dppk.emp_id   = empp.emp_id
where 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

      (prns_id = @prns_id or @prns_id=0)
and   (ps.pr_id = @pr_id or ps.pr_id_kit = @pr_id or @pr_id=0)

and   (d.depl_id = @depl_id or @depl_id=0)
and   (df.depf_id = @depf_id or @depf_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30 -- tbl_id de Proyecto
                  and  (rptarb_hojaid = ps.pr_id or rptarb_hojaid = ps.pr_id_kit)
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
                  and  tbl_id = 1017 -- tbl_id de Proyecto
                  and  rptarb_hojaid = prns_id
							   ) 
           )
        or 
					 (@ram_id_productoserie = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 
                  and  rptarb_hojaid = d.depl_id
							   ) 
           )
        or 
					 (@ram_id_DepositoLogico = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 10 
                  and  rptarb_hojaid = d.depf_id
							   ) 
           )
        or 
					 (@ram_id_DepositoFisico = 0)
			 )
end
go