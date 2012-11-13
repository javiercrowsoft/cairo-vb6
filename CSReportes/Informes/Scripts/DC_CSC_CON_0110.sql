
/*---------------------------------------------------------------------
Nombre: Facturas de Venta que utilizan x tasa de iva
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0110]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0110]


/*

	select * from tasaimpositiva

 [DC_CSC_CON_0110] 1,'20000901','20080930','11','0','0'

*/

go
create procedure DC_CSC_CON_0110(

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


select 	fv.fv_id, 
				pr_nombreVenta  as Articulo,
				fv_nrodoc 			as Comprobante,
				fv_numero 			as Numero,
				fv_fecha  			as Fecha,
				emp_nombre 			as Empresa,
				doc_nombre 			as Documento,
				cli_nombre 		  as Cliente,
				case fv.doct_id 
					when 7 then  -fvi_ivari
					else   				fvi_ivari    		
				end             as iva


from FacturaVenta fv  inner join Cliente cli 						on fv.cli_id 	= cli.cli_id
											inner join Documento doc  				on fv.doc_id  = doc.doc_id
											inner join Empresa emp    				on doc.emp_id = emp.emp_id
											inner join FacturaVentaItem fvi		on fv.fv_id   = fvi.fv_id
											inner join Producto pr						on fvi.pr_id  = pr.pr_id
											inner join TasaImpositiva ti      on pr.ti_id_ivariVenta = ti.ti_id

where 
	    fv_fecha between @@Fini and @@Ffin
	and est_id <> 7
	and round(fvi_ivari,2) <> 0

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

order by pr_nombreVenta, fv_fecha

end
go
