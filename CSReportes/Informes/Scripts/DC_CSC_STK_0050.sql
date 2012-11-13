/*---------------------------------------------------------------------
Nombre: Stock por depósito es identico al DC_CSC_STK_0051
				si hay un bug aqui lo hay en el DC_CSC_STK_0051
				la unica diferencia es el sort
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0050]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0050]

GO

/*

*/

create procedure DC_CSC_STK_0050 (

  @@us_id    int,
	@@Ffin 		 datetime,

@@pr_id 		varchar(255),
@@depl_id 	varchar(255),
@@depf_id		varchar(255),
@@suc_id		varchar(255), -- TODO:EMPRESA
@@emp_id  	varchar(255),
@@conStock	smallint

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id int
declare @depl_id int
declare @depf_id int
declare @suc_id int
declare @emp_id   int -- TODO:EMPRESA

declare @ram_id_Producto int
declare @ram_id_DepositoLogico int
declare @ram_id_DepositoFisico int
declare @ram_id_Sucursal int
declare @ram_id_Empresa   int -- TODO:EMPRESA

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto out
exec sp_ArbConvertId @@depl_id, @depl_id out, @ram_id_DepositoLogico out
exec sp_ArbConvertId @@depf_id, @depf_id out, @ram_id_DepositoFisico out
exec sp_ArbConvertId @@suc_id, @suc_id out, @ram_id_Sucursal out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out -- TODO:EMPRESA

exec sp_GetRptId @clienteID out

if @ram_id_Producto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Producto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Producto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Producto, @clienteID 
	end else 
		set @ram_id_Producto = 0
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

if @ram_id_Sucursal <> 0 begin

--	exec sp_ArbGetGroups @ram_id_Sucursal, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_Sucursal, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_Sucursal, @clienteID 
	end else 
		set @ram_id_Sucursal = 0
end

-- TODO:EMPRESA
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


select 
				0,
				pr_nombrecompra           as [Articulo Compra],
				pr_nombreventa            as [Articulo Venta],
				pr_reposicion             as [Punto de Reposición],
				pr_stockminimo            as [Sotck Minimo],
				pr_stockmaximo            as [Stock Maximo],
				depf_nombre               as [Deposito Fisico],
				depl_nombre               as [Deposito],
				un_nombre									as [Unidad],
				sum(sti_ingreso)
				- sum(sti_salida)         as [Cantidad]
from

			Stock 	inner join StockItem sti							on Stock.st_id 		= sti.st_id
							inner join DepositoLogico d 					on sti.depl_id 		= d.depl_id  
							inner join Producto p                 on sti.pr_id 			= p.pr_id
              inner join Unidad u                   on un_id_stock    = u.un_id
							inner join DepositoFisico df          on d.depf_id      = df.depf_id
							inner join Sucursal s                 on Stock.suc_id   = s.suc_id
              inner join Documento doc              on stock.doc_id   = doc.doc_id

where 

					st_fecha <= @@Ffin 

-- TODO: Parametrizar

--			and (sti.pr_id_kit is null or sti.pr_id = sti.pr_id_kit)

-- Discrimino depositos internos
			and (d.depl_id <> -2 and d.depl_id <> -3)


-- TODO:EMPRESA
			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (p.pr_id = @pr_id or @pr_id=0)
and   (d.depl_id = @depl_id or @depl_id=0)
and   (df.depf_id = @depf_id or @depf_id=0)
and   (s.suc_id = @suc_id or @suc_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0) -- TODO:EMPRESA

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30 -- tbl_id de Proyecto
                  and  rptarb_hojaid = sti.pr_id
							   ) 
           )
        or 
					 (@ram_id_Producto = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 11 -- tbl_id de Proyecto
                  and  rptarb_hojaid = sti.depl_id
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
                  and  tbl_id = 10 -- tbl_id de Proyecto
                  and  rptarb_hojaid = d.depf_id
							   ) 
           )
        or 
					 (@ram_id_DepositoFisico = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1007 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Stock.suc_id
							   ) 
           )
        or 
					 (@ram_id_Sucursal = 0)
			 )

-- TODO:EMPRESA
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- select * from tabla where tbl_nombre = 'empresa'
                  and  rptarb_hojaid = doc.emp_id
							   ) 
           )
        or 
					 (@ram_id_Empresa = 0)
			 )
group by 		
				pr_nombrecompra,
				pr_nombreventa,
				pr_reposicion,
				pr_stockminimo,
				pr_stockmaximo,
				depf_nombre,
				depl_nombre,
				un_nombre

having @@conStock = 0 or (sum(sti_ingreso)- sum(sti_salida))<> 0

order by 	
					depl_nombre,
					pr_nombrecompra,
					pr_nombreventa

GO