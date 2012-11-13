/*---------------------------------------------------------------------
Nombre: Detalle de numeros de serie
Virginia ya sabe como se relaciona mas de una vez la misma tabla a  un select.
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0130]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0130]

/*

exec [DC_CSC_STK_0130] 79,'0','13'

*/

go
create procedure DC_CSC_STK_0130 (

  @@us_id     int,
  @@pr_id     varchar(255),
  @@prns_id   varchar(255)

)as 
begin
set nocount on
/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id int
declare @prns_id int

declare @ram_id_producto int
declare @ram_id_productoserie int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_producto out
exec sp_ArbConvertId @@prns_id, @prns_id out, @ram_id_productoserie out

exec sp_GetRptId @clienteID out

if @@prns_id = '0' and @@pr_id = '0' begin
	select 
				 '@@ERROR_SP_RS:Debe indicar un articulo o un numero de serie, no puede dejar los dos campos en blanco'
											as error_in_sp_id
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

create table #dc_csc_stk_0130_prns (prns_id int)

insert into #dc_csc_stk_0130_prns
select distinct prns_id from ProductoNumeroSerie
where (prns_id = @prns_id or @prns_id=0)
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1017 
                  and  rptarb_hojaid = prns_id
							   ) 
           )
        or 
					 (@ram_id_productoserie = 0)
			 )

and		(pr_id = @pr_id or pr_id_kit = @pr_id or @pr_id=0)
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30
                  and  (rptarb_hojaid = pr_id or rptarb_hojaid = pr_id_kit)
							   ) 
           )
        or 
					 (@ram_id_producto = 0)
			 )

create table #dc_csc_stk_0130_pr (pr_id int)

insert into #dc_csc_stk_0130_pr
select distinct pr_id 
from ProductoNumeroSerie prns inner join #dc_csc_stk_0130_prns tprns on prns.prns_id = tprns.prns_id
where 
			(pr_id = @pr_id or pr_id_kit = @pr_id or @pr_id=0)
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30
                  and  (rptarb_hojaid = pr_id or rptarb_hojaid = pr_id_kit)
							   ) 
           )
        or 
					 (@ram_id_producto = 0)
			 )

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 

       case st.id_cliente
					when  0 then st.st_id
					else				 st.id_cliente
			 end				  			 	as comp_id,
			 isnull(st.doct_id_cliente,st.doct_id)
												  	as doct_id,

			 prns.prns_id,

			 emp_nombre             as [Empresa],
			 pr.pr_nombrecompra  		as [Producto],
			 pkit.pr_nombrecompra		as [Usado en Kit],
			 prns_codigo 				 		as [Nro. Serie],
			 st_fecha            		as [Fecha],

			 case doct_id_cliente
				when 1 then  fv.creado
				when 7 then  fv.creado
				when 2 then  fc.creado
				when 8 then  fc.creado
				when 3 then  rv.creado
				when 4 then  rc.creado
				when 28 then rs.creado
				when 30 then isnull(ppkp.creado, ppkc.creado)
				when 34 then isnull(ppkp.creado, ppkc.creado)
				when 42 then os.creado
				when 43 then prp.creado
				else st.creado
			 end			              as [Creado],

			 st_nrodoc           		as [Comprobante Stock],
			 case doct_id_cliente
				when 1  then  docfv.doc_nombre
				when 7  then  docfv.doc_nombre
				when 2  then  docfc.doc_nombre
				when 8  then  docfc.doc_nombre
				when 3  then  docrv.doc_nombre
				when 24 then  docrv.doc_nombre
				when 4  then  docrc.doc_nombre
				when 25 then  docrc.doc_nombre
				when 28 then docrs.doc_nombre
				when 30 then isnull(docppkp.doc_nombre, docppkc.doc_nombre)
				when 34 then isnull(docppkp.doc_nombre, docppkc.doc_nombre)
				when 42 then docos.doc_nombre
				when 43 then docprp.doc_nombre
				else doc.doc_nombre
			 end 										as [Documento],
 			 case doct_id_cliente
				when 1  then  fv.fv_nrodoc
				when 7  then  fv.fv_nrodoc
				when 2  then  fc.fc_nrodoc
				when 8  then  fc.fc_nrodoc
				when 3  then  rv.rv_nrodoc
				when 24 then  rv.rv_nrodoc
				when 4  then  rc.rc_nrodoc
				when 25 then  rc.rc_nrodoc
				when 28 then rs.rs_nrodoc
				when 30 then isnull(ppkp.ppk_nrodoc, ppkc.ppk_nrodoc)
				when 34 then isnull(ppkp.ppk_nrodoc, ppkc.ppk_nrodoc)
				when 42 then os.os_nrodoc
				when 43 then prp.prp_nrodoc
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
			 prns_fechavto       		as [Fecha Vto],
			 prns_descrip        		as [Observacion Serie],
			 st_descrip          		as [Observaciones]

from (
				(
			productoNumeroSerie prns 
															inner join #dc_csc_stk_0130_prns tprns	on prns.prns_id 	= tprns.prns_id
				)
															inner join #dc_csc_stk_0130_pr tpr 			on prns.pr_id 		= tpr.pr_id
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
                              left  join ordenservicio os  		on st.st_id       = os.st_id
															left  join partereparacion prp  on st.st_id       = prp.st_id

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
															left  join documento    docos   on os.doc_id          = docos.doc_id
															left  join documento    docprp  on prp.doc_id         = prp.doc_id


union all

select 

			 prp_id				  			 	as comp_id,
			 prp.doct_id				  	as doct_id,

			 prns.prns_id,

			 emp_nombre             as [Empresa],
			 pr.pr_nombrecompra  		as [Producto],
			 ''											as [Usado en Kit],
			 prns_codigo 				 		as [Nro. Serie],
			 prp_fecha            	as [Fecha],
			 prp.creado         		as [Creado],
			 ''                   	as [Comprobante Stock],
			 docprp.doc_nombre			as [Documento],
 			 prp_nrodoc							as [NroDoc],
			 ''                    	as [Cliente],
			 ''										 	as [Proveedor],
			 deplo.depl_nombre   		as [Origen],
       ''   									as [Destino],
			 prns_fechavto       		as [Fecha Vto],
			 prns_descrip        		as [Observacion Serie],
			 prp_descrip          	as [Observaciones]

from (
				(
			productoNumeroSerie prns 
															inner join #dc_csc_stk_0130_prns tprns	on prns.prns_id 	= tprns.prns_id
				)
															inner join #dc_csc_stk_0130_pr tpr 			on prns.pr_id 		= tpr.pr_id
			)
															inner join producto pr 					on prns.pr_id        = pr.pr_id
															left  join partereparacion prp  on prns.prns_id      = prp.prns_id
															left  join documento    docprp  on prp.doc_id        = docprp.doc_id
															left  join empresa      emp 		on docprp.emp_id     = emp.emp_id
															left  join stock st             on prp.st_id         = st.st_id
															left  join depositologico deplo on st.depl_id_origen = deplo.depl_id
												

order by prns.prns_id, Fecha, Creado, prns_codigo, comp_id

end
go