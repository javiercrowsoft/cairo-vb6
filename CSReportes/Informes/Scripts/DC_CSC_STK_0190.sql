/*---------------------------------------------------------------------
Nombre: Detalle de numeros de serie
Virginia ya sabe como se relaciona mas de una vez la misma tabla a  un select.
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0190]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0190]

/*

DC_CSC_STK_0190 1,'20060101','20060115',

select * from producto where 

select * from productonumeroserie where prns_codigo = 'a17283'

select * from stockcache where prns_id = 68930


sp_DocStockNroSerieValidate 668




*/

go
create procedure DC_CSC_STK_0190 (

  @@us_id     int,

	@@Fini 		 		datetime,
	@@Ffin 		 		datetime,

  @@pr_id     			varchar(255),
  @@depl_id	 				varchar(255),
	@@depf_id         varchar(255),
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

declare @emp_id   								int

declare @pr_id 										int

declare @ram_id_producto 					int
declare @ram_id_depositoLogico   	int
declare @ram_id_depositoFisico   	int
declare @ram_id_empresa           int

declare @depl_id			int
declare @depf_id			int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, 				@pr_id out, 				@ram_id_producto 					out
exec sp_ArbConvertId @@depl_id,       @depl_id out, 			@ram_id_depositoLogico 		out
exec sp_ArbConvertId @@depf_id,       @depf_id out, 			@ram_id_depositoFisico 		out
exec sp_ArbConvertId @@emp_id,  		  @emp_id 	out,  		@ram_id_empresa   				out

exec sp_GetRptId @clienteID out

if @ram_id_producto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_producto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_producto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_producto, @clienteID 
	end else 
		set @ram_id_producto = 0
end

if @ram_id_depositoLogico <> 0 begin

--	exec sp_ArbGetGroups @ram_id_depositoLogico, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_depositoLogico, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_depositoLogico, @clienteID 
	end else 
		set @ram_id_depositoLogico = 0
end

if @ram_id_depositoFisico <> 0 begin

--	exec sp_ArbGetGroups @ram_id_depositoFisico, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_depositoFisico, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_depositoFisico, @clienteID 
	end else 
		set @ram_id_depositoFisico = 0
end

if @ram_id_empresa <> 0 begin

--	exec sp_ArbGetGroups @ram_id_empresa, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_empresa, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_empresa, @clienteID 
	end else 
		set @ram_id_empresa = 0
end


create table #dc_csc_stk_0190_pr (pr_id int)

insert into #dc_csc_stk_0190_pr
select pr_id 
from Producto
where 
			(pr_id = @pr_id or @pr_id=0)
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30
                  and  (rptarb_hojaid = pr_id)
							   ) 
           )
        or 
					 (@ram_id_producto = 0)
			 )

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

select 
       st.id_cliente			 	as comp_id,
			 st.doct_id_cliente  	as doct_id,

			 emp_nombre             as [Empresa],
			 pr.pr_nombrecompra  		as [Producto],
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
			 sum(sti_ingreso)       as Cantidad,
			 st_descrip          		as [Observaciones]

from 
			(
			producto pr							inner join #dc_csc_stk_0190_pr tpr 	on pr.pr_id = tpr.pr_id
			)

															left  join stockItem sti    		on  	pr.pr_id = sti.pr_id
																																and sti_ingreso > 0 

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

where 

				  st_fecha >= @@Fini
			and	st_fecha <= @@Ffin 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (pr.pr_id = @pr_id or @pr_id=0)
and   (doc.emp_id = @emp_id or @emp_id=0)

and   (st.depl_id_destino = @depl_id 	or
			 st.depl_id_origen  = @depl_id 	or
			 @depl_id=0
			)
and   (depld.depf_id 			= @depf_id 	or
			 deplo.depf_id      = @depf_id  or
			 @depf_id=0
			)

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
                  and  tbl_id = 11 
                  and  (		rptarb_hojaid = st.depl_id_origen
												 or rptarb_hojaid = st.depl_id_destino
												)
							   ) 
           )
        or 
					 (@ram_id_depositoLogico = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 10
                  and  (		rptarb_hojaid = depld.depf_id
												 or rptarb_hojaid = deplo.depf_id
												)
							   ) 
           )
        or 
					 (@ram_id_depositoFisico = 0)
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

group by

			 st.st_id,
       st.id_cliente,
			 st.doct_id_cliente,

			 emp_nombre,
			 pr.pr_nombrecompra,
			 st_fecha,
			 st_nrodoc,
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
			 end,
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
			 end,
			 

			 IsNull(fvcli.cli_nombre,
              rvcli.cli_nombre),
			 IsNull(fcprov.prov_nombre,
              rcprov.prov_nombre),
			 deplo.depl_nombre,
       depld.depl_nombre,
			 st_descrip

order by pr_nombrecompra,Fecha,st.st_id

end
go