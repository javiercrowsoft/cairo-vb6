
/*---------------------------------------------------------------------
Nombre: Facturas de compra que utilizan x tasa de iva
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0100]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0100]


/*

	select * from tasaimpositiva

 [DC_CSC_CON_0100] 1,'20050901','20050930','27','0','2'

*/

go
create procedure DC_CSC_CON_0100(

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@ti_id 		varchar(255),
	@@cico_id		varchar(255),
  @@emp_id    varchar(255)
) 

as 

begin

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @ti_id 		int
declare @cico_id 	int
declare @emp_id 	int 


declare @ram_id_tasaimpositiva 		int
declare @ram_id_circuitocontable 	int
declare @ram_id_Empresa   				int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@ti_id, 		@ti_id out, 	@ram_id_tasaimpositiva out
exec sp_ArbConvertId @@cico_id, 	@cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@emp_id, 		@emp_id out, 	@ram_id_Empresa out 

exec sp_GetRptId @clienteID out

if @ram_id_tasaimpositiva <> 0 begin

--	exec sp_ArbGetGroups @ram_id_tasaimpositiva, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_tasaimpositiva, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_tasaimpositiva, @clienteID 
	end else 
		set @ram_id_tasaimpositiva = 0
end

if @ram_id_circuitocontable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
	end else 
		set @ram_id_circuitocontable = 0
end

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


select 	fc.fc_id, 
				pr_nombrecompra as Articulo,
				fc_nrodoc 			as Comprobante,
				fc_numero 			as Numero,
				fc_fecha  			as Fecha,
				emp_nombre 			as Empresa,
				doc_nombre 			as Documento,
				prov_nombre 		as Proveedor,
				case fc.doct_id 
					when 8 then  -fci_ivari
					else   				fci_ivari    		
				end             as iva


from FacturaCompra fc inner join Proveedor prov 				on fc.prov_id = prov.prov_id
											inner join Documento doc  				on fc.doc_id  = doc.doc_id
											inner join Empresa emp    				on doc.emp_id = emp.emp_id
											inner join FacturaCompraItem fci	on fc.fc_id   = fci.fc_id
											inner join Producto pr						on fci.pr_id  = pr.pr_id
											inner join TasaImpositiva ti      on pr.ti_id_ivaricompra = ti.ti_id

where 
	    fc_fecha between @@Fini and @@Ffin
	and est_id <> 7
	and round(fci_ivari,2) <> 0

			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (ti.ti_id 		= @ti_id 		or @ti_id		=0)
and   (doc.cico_id 	= @cico_id 	or @cico_id	=0)
and   (doc.emp_id 	= @emp_id 	or @emp_id	=0) 

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 9
                  and  rptarb_hojaid = ti.ti_id
							   ) 
           )
        or 
					 (@ram_id_tasaimpositiva = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1016 
                  and  rptarb_hojaid = doc.cico_id
							   ) 
           )
        or 
					 (@ram_id_circuitocontable = 0)
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
					 (@ram_id_Empresa = 0)
			 )

order by pr_nombrecompra, fc_fecha

end
go
