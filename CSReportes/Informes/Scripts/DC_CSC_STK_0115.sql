/*---------------------------------------------------------------------
Nombre: Detalle de numeros de serie
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0115]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0115]

/*

select * from depositologico

DC_CSC_STK_0115 1,0,0,6,0

*/

go
create procedure DC_CSC_STK_0115 (

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

create table #t_dc_csc_stk_0115 (

	prns_id 							int,
	orden                 int,

	comp_id									int,
	doct_id				  				int,

  [Nombre Venta]				varchar(255),
  [Nombre Compra]				varchar(255),
  [Nro Serie]						varchar(255),
  [Fecha Vto]						datetime,
  [Deposito Actual]			varchar(255),
  [Usado en Kit]				varchar(255),
  [Proveedor]						varchar(255),
	[Cliente]							varchar(255),
	[Empresa Ingreso]			varchar(255),
	[Empresa Egreso]			varchar(255),
	[Empresa Produccion]	varchar(255),
	[Fecha Ingreso]				datetime,
	[Doc Ingreso]					varchar(255),
	[Fecha Parte]					datetime,
	[Doc Parte]						varchar(255),
	[Fecha Egreso]				datetime,
	[Doc Egreso]					varchar(255),

	[Fecha]            			datetime,
	[Comprobante Stock]			varchar(255),
	[Documento]							varchar(255),
	[Empresa]								varchar(255),
	[NroDoc]								varchar(255),
	[Origen]								varchar(255),
	[Destino]								varchar(255),

	[Observaciones]				varchar(255)
	
)

insert into #t_dc_csc_stk_0115 
	(
		prns_id 							,
		orden									,
	  [Nombre Venta]				,
	  [Nombre Compra]				,
	  [Nro Serie]						,
	  [Fecha Vto]						,
	  [Deposito Actual]			,
	  [Usado en Kit]				,
	  [Proveedor]						,
		[Cliente]							,
		[Empresa Ingreso]			,
		[Empresa Egreso]			,
		[Empresa Produccion]	,
		[Fecha Ingreso]				,
		[Doc Ingreso]					,
		[Fecha Parte]					,
		[Doc Parte]						,
		[Fecha Egreso]				,
		[Doc Egreso]					,
		[Observaciones]				
	)

select 

  ps.prns_id,
	0                    as Orden,
  p.pr_nombrecompra    as [Nombre Venta],
  p.pr_nombreventa     as [Nombre Compra],
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


-- 	declare c_series insensitive cursor for 
-- 			select prns_id from #t_dc_csc_stk_0115 
-- 
-- 	open c_series
-- 
-- 	fetch next from c_series into @prns_id
-- 	while @@fetch_status = 0
-- 	begin
-- 
-- 
-- 		
-- 
-- 		fetch next from c_series into @prns_id
-- 	end
-- 
-- 	close c_series
-- 	deallocate c_series

insert into #t_dc_csc_stk_0115 
	(
		prns_id 							,
		orden									,
		comp_id								,
		doct_id				  			,
		[Empresa]							,
	  [Nombre Venta]				,
	  [Nombre Compra]				,
	  [Nro Serie]						,
	  [Fecha]								,
		[Comprobante Stock]		,
		[Documento]						,
		[NroDoc]							,
	  [Proveedor]						,
		[Cliente]							,
		[Origen]							,
		[Destino]							,
		[Observaciones]				
	)

select 
			 prns.prns_id,
			 1                    as Orden,

       case st.id_cliente
					when  0 then st.st_id
					else				 st.id_cliente
			 end				  			 	as comp_id,
			 isnull(st.doct_id_cliente,st.doct_id)
												  	as doct_id,

			 emp_nombre             as [Empresa],
			 pr.pr_nombrecompra  		as [Producto],
			 pkit.pr_nombrecompra		as [Usado en Kit],
			 prns_codigo 				 		as [Nro. Serie],
			 st_fecha            		as [Fecha],
			 st_nrodoc           		as [Comprobante Stock],
			 case doct_id_cliente
				when 1 then  docfv.doc_nombre
				when 7 then  docfv.doc_nombre
				when 2 then  docfc.doc_nombre
				when 8 then  docfc.doc_nombre
				when 3 then  docrv.doc_nombre
				when 4 then  docrc.doc_nombre
				when 28 then docrs.doc_nombre
				when 30 then isnull(docppkp.doc_nombre, docppkc.doc_nombre)
				when 34 then isnull(docppkp.doc_nombre, docppkc.doc_nombre)
				else doc.doc_nombre
			 end 										as [Documento],
 			 case doct_id_cliente
				when 1 then  fv.fv_nrodoc
				when 7 then  fv.fv_nrodoc
				when 2 then  fc.fc_nrodoc
				when 8 then  fc.fc_nrodoc
				when 3 then  rv.rv_nrodoc
				when 4 then  rc.rc_nrodoc
				when 28 then rs.rs_nrodoc
				when 30 then isnull(ppkp.ppk_nrodoc, ppkc.ppk_nrodoc)
				when 34 then isnull(ppkp.ppk_nrodoc, ppkc.ppk_nrodoc)
				else st.st_nrodoc
			 end 										as [NroDoc],
			 

			 IsNull(fvcli.cli_nombre,
              rvcli.cli_nombre)          
			                     		as [Cliente],
			 IsNull(fcprov.prov_nombre,
              rcprov.prov_nombre)          
													 		as [Proveedor],
			 deplo.depl_nombre   		as [Origen],
       depld.depl_nombre   		as [Destino],
			 st_descrip          		as [Observaciones]

from (
			productoNumeroSerie prns 
															inner join #t_dc_csc_stk_0115 tprns	on prns.prns_id 	= tprns.prns_id
			)
															inner join producto pr 					on prns.pr_id      = pr.pr_id
															left  join stockItem sti    		on  	prns.prns_id = sti.prns_id
																																and sti_ingreso > 0 

                              left  join producto pkit				on sti.pr_id_kit  = pkit.pr_id

															left  join stock st         		on sti.st_id      = st.st_id

                              left  join remitoVenta rv   		on st.st_id       = rv.st_id
                              left  join facturaVenta fv  		on st.st_id       = fv.st_id
                              left  join remitoCompra rc  		on st.st_id       = rc.st_id
                              left  join facturaCompra fc 		on st.st_id       = fc.st_id

                              left  join parteProdKit ppkc  	on st.st_id       = ppkc.st_id1
                              left  join parteProdKit ppkp  	on st.st_id       = ppkp.st_id2
                              left  join recuentoStock rs  		on st.st_id       = rs.st_id1


															left  join cliente     rvcli 		on rv.cli_id      = rvcli.cli_id
                              left  join cliente     fvcli 		on fv.cli_id      = fvcli.cli_id

															left  join proveedor   rcprov		on rc.prov_id     = rcprov.prov_id
                              left  join proveedor   fcprov		on rc.prov_id     = fcprov.prov_id

															left  join depositoLogico deplo on st.depl_id_origen  = deplo.depl_id
															left  join depositoLogico depld on st.depl_id_destino = depld.depl_id
															
															left  join documento    doc     on st.doc_id          = doc.doc_id
															left  join empresa      emp 		on doc.emp_id         = emp.emp_id
												
															left  join documento    docrv   on rv.doc_id          = docrv.doc_id      
															left  join documento    docfv   on fv.doc_id          = docfv.doc_id
															left  join documento    docrc   on rc.doc_id          = docrc.doc_id
															left  join documento    docfc   on fc.doc_id          = docfc.doc_id

															left  join documento    docrs   on rs.doc_id          = docrs.doc_id
															left  join documento    docppkc on ppkc.doc_id        = docppkc.doc_id
															left  join documento    docppkp on ppkp.doc_id        = docppkp.doc_id



	select * 
	from #t_dc_csc_stk_0115
	order by prns_id, orden, Fecha, comp_id

end
go