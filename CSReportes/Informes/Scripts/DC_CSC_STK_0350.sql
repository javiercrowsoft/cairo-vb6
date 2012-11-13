
/*---------------------------------------------------------------------
Nombre: Stock por depósito
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0350]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0350]

GO

/*
DC_CSC_STK_0350 
											1,
											'20200101',
											'106',
											'0',
											'0',
											'0',
											'0'

select * from rama where ram_nombre like '%dvd%'
select pr_id,pr_nombrecompra from producto where pr_nombrecompra like '%AMD Athlon 3.4 160GB%'
select * from tabla where tbl_nombrefisico like '%produ%'
*/

create procedure DC_CSC_STK_0350 (

  @@us_id    int,
	@@Ffin 		 datetime,

@@pr_id 		varchar(255),
@@depl_id 	varchar(255),
@@depf_id		varchar(255),
@@conStock	smallint

)as 

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id int
declare @depl_id int
declare @depf_id int
declare @suc_id int
declare @emp_id   int 

declare @ram_id_Producto int
declare @ram_id_DepositoLogico int
declare @ram_id_DepositoFisico int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_Producto out
exec sp_ArbConvertId @@depl_id, @depl_id out, @ram_id_DepositoLogico out
exec sp_ArbConvertId @@depf_id, @depf_id out, @ram_id_DepositoFisico out

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

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


/*- ///////////////////////////////////////////////////////////////////////

CALCULO DE STOCK

/////////////////////////////////////////////////////////////////////// */


-- MOVIENTOS DESPUES DE FECHA HASTA

		create table #t_dc_csc_stk_0350_stock (st_id int not null)

		create table #t_dc_csc_stk_0350 (depl_id int not null, pr_id int not null, cantidad decimal(18,6) not null default(0))

		insert into #t_dc_csc_stk_0350_stock 
		select st_id from Stock where st_fecha > @@Ffin 
		
		insert into #t_dc_csc_stk_0350
		
		select 
						sti.depl_id,
						sti.pr_id,
						-- Resto lo que se movio despues de fecha hasta
						-(		sum(sti_ingreso)
								- sum(sti_salida)
						 )
		from
		
					#t_dc_csc_stk_0350_stock s
									inner join StockItem sti							on  s.st_id  		= sti.st_id
									inner join DepositoLogico d 					on sti.depl_id 	= d.depl_id  
		where 

		-- Discrimino depositos internos
		
					(d.depl_id <> -2 and d.depl_id <> -3)
		
		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (sti.pr_id = @pr_id or @pr_id=0)
		and   (d.depl_id = @depl_id or @depl_id=0)
		and   (d.depf_id = @depf_id or @depf_id=0)
		
		-- Arboles
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 30 
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
		                  and  tbl_id = 11 
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
		                  and  tbl_id = 10 
		                  and  rptarb_hojaid = d.depf_id
									   ) 
		           )
		        or 
							 (@ram_id_DepositoFisico = 0)
					 )
		
		group by 		
						sti.depl_id,
						sti.pr_id

-- STOCK ACTUAL DESDE STOCKCACHE
		
		insert into #t_dc_csc_stk_0350
		
		select 
						sti.depl_id,
						sti.pr_id,
						-- Sumo lo que hay actualmente
						sum(stc_cantidad)
		from
		
					StockCache sti inner join DepositoLogico d on sti.depl_id 	= d.depl_id  
		where 
		
		-- Discrimino depositos internos
		
						  (d.depl_id <> -2 and d.depl_id <> -3)
		
		/* -///////////////////////////////////////////////////////////////////////
		
		INICIO SEGUNDA PARTE DE ARBOLES
		
		/////////////////////////////////////////////////////////////////////// */
		
		and   (sti.pr_id = @pr_id or @pr_id=0)
		and   (d.depl_id = @depl_id or @depl_id=0)
		and   (d.depf_id = @depf_id or @depf_id=0)
		
		-- Arboles
		and   (
							(exists(select rptarb_hojaid 
		                  from rptArbolRamaHoja 
		                  where
		                       rptarb_cliente = @clienteID
		                  and  tbl_id = 30 
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
		                  and  tbl_id = 11 
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
		                  and  tbl_id = 10 
		                  and  rptarb_hojaid = d.depf_id
									   ) 
		           )
		        or 
							 (@ram_id_DepositoFisico = 0)
					 )
		
		group by 		
						sti.depl_id,
						sti.pr_id

--////////////////////////////////////////////////////////////////////////
--
-- SELECT DE RETORNO
--
--////////////////////////////////////////////////////////////////////////
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
				sum(cantidad)             as [Cantidad]
from
			#t_dc_csc_stk_0350 sti
							inner join DepositoLogico d 					on sti.depl_id 		= d.depl_id  
							inner join Producto p                 on sti.pr_id 			= p.pr_id
              inner join Unidad u                   on un_id_stock    = u.un_id
							inner join DepositoFisico df          on d.depf_id      = df.depf_id

group by 		
				pr_nombrecompra,
				pr_nombreventa,
				pr_reposicion,
				pr_stockminimo,
				pr_stockmaximo,
				depf_nombre,
				depl_nombre,
				un_nombre

having @@conStock = 0 or sum(cantidad)<> 0

order by 	pr_nombrecompra,
					pr_nombreventa

GO