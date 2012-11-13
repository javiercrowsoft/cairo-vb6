/*---------------------------------------------------------------------
Nombre: Detalle de numeros de serie
Virginia ya sabe como se relaciona mas de una vez la misma tabla a  un select.
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0160]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0160]

/*
DC_CSC_STK_0160 1,0,13
select * from stocklote
*/

go
create procedure DC_CSC_STK_0160 (

  @@us_id     int,
  @@pr_id     varchar(255),
  @@stl_id    varchar(255)

)as 
begin
set nocount on
/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @pr_id int
declare @stl_id int

declare @ram_id_producto int
declare @ram_id_stocklote int

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@pr_id, @pr_id out, @ram_id_producto out
exec sp_ArbConvertId @@stl_id, @stl_id out, @ram_id_stocklote out

exec sp_GetRptId @clienteID out

if @@stl_id = '0' and @@pr_id = '0' begin
	select 
				 '@@ERROR_SP_RS:Debe indicar un articulo o un lote, no puede dejar los dos campos en blanco'
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

if @ram_id_stocklote <> 0 begin

--	exec sp_ArbGetGroups @ram_id_stocklote, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_stocklote, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_stocklote, @clienteID 
	end else 
		set @ram_id_stocklote = 0
end

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

			 stl.stl_id,

			 emp_nombre             as [Empresa],
			 pr.pr_nombrecompra  		as [Producto],
			 pkit.pr_nombrecompra		as [Usado en Kit],
			 stl_codigo 				 		as [Nro. Serie],
			 st_fecha            		as [Fecha],
			 st_nrodoc           		as [Comprobante Stock],
			 sti_ingreso            as Cantidad,
			 case doct_id_cliente
				when 1 then  docfv.doc_nombre
				when 7 then  docfv.doc_nombre
				when 2 then  docfc.doc_nombre
				when 8 then  docfc.doc_nombre
				when 3 then  isnull(isnull(isnull(docrv.doc_nombre,docrvcn.doc_nombre),docrvct.doc_nombre),docrvp.doc_nombre)
				when 4 then  docrc.doc_nombre
				when 28 then docrs.doc_nombre
				when 30 then isnull(docppkp.doc_nombre, docppkc.doc_nombre)
				else doc.doc_nombre
			 end 										as [Documento],
 			 case doct_id_cliente
				when 1 then  fv.fv_nrodoc
				when 7 then  fv.fv_nrodoc
				when 2 then  fc.fc_nrodoc
				when 8 then  fc.fc_nrodoc
				when 3 then  isnull(isnull(isnull(rv.rv_nrodoc,rvcn.rv_nrodoc),rvct.rv_nrodoc),rvp.rv_nrodoc)
				when 4 then  rc.rc_nrodoc
				when 28 then rs.rs_nrodoc
				when 30 then isnull(ppkp.ppk_nrodoc, ppkc.ppk_nrodoc)
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
			 stl_fechavto       		as [Fecha Vto],
			 stl_descrip        		as [Observacion Serie],
			 st_descrip          		as [Observaciones]

from stockLote stl 						inner join producto pr 					on stl.pr_id      = pr.pr_id
															left  join stockItem sti    		on  	stl.stl_id  = sti.stl_id
																																and sti_ingreso > 0 

                              left  join producto pkit				on sti.pr_id_kit  = pkit.pr_id

															left  join stock st         		on sti.st_id      = st.st_id

                              left  join remitoVenta rv   		on st.st_id       = rv.st_id

                              left  join remitoVenta rvcn  	on st.st_id       = rvcn.st_id_consumo
                              left  join remitoVenta rvct  	on st.st_id       = rvct.st_id_consumoTemp
                              left  join remitoVenta rvp  	on st.st_id       = rvp.st_id_producido

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

															left  join documento    docrvcn on rvcn.doc_id       = docrvcn.doc_id
															left  join documento    docrvct on rvct.doc_id       = docrvct.doc_id
															left  join documento    docrvp  on rvp.doc_id        = docrvp.doc_id

															left  join documento    docfv   on fv.doc_id          = docfv.doc_id
															left  join documento    docrc   on rc.doc_id          = docrc.doc_id
															left  join documento    docfc   on fc.doc_id          = docfc.doc_id

															left  join documento    docrs   on rs.doc_id          = docrs.doc_id
															left  join documento    docppkc on ppkc.doc_id        = docppkc.doc_id
															left  join documento    docppkp on ppkp.doc_id        = docppkp.doc_id

where 

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

      (stl.stl_id = @stl_id or @stl_id=0)
and   (sti.pr_id = @pr_id or sti.pr_id_kit = @pr_id or @pr_id=0)

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 30 
                  and  (rptarb_hojaid = sti.pr_id or rptarb_hojaid = sti.pr_id_kit)
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
                  and  tbl_id = 1026 
                  and  rptarb_hojaid = stl.stl_id
							   ) 
           )
        or 
					 (@ram_id_stocklote = 0)
			 )

order by stl_codigo,Fecha,st.st_id

end
go