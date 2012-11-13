-- TODO:EMPRESA
/*---------------------------------------------------------------------
Nombre: Nombre: Imputacion contable por documentos resumido (cuenta, centro de costo y circuito contable)
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0072]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0072]


/*

DC_CSC_CON_0072 1,
								'20050101',
								'20051001',
								'0',
								'0',
								'0',
								'0',
								0,
								'0'
				
*/

go
create procedure DC_CSC_CON_0072(

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@cue_id 		varchar(255),
	@@ccos_id 	varchar(255),
	@@cico_id		varchar(255),
	@@doc_id    varchar(255),
	@@bMonExt 	smallint, -- TODO:EMPRESA
  @@emp_id    varchar(255)
) 

as 

begin

set nocount on

/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id  int
declare @ccos_id int
declare @cico_id int
declare @doc_id  int
declare @emp_id  int -- TODO:EMPRESA


declare @ram_id_cuenta 						int
declare @ram_id_centrocosto 			int
declare @ram_id_circuitocontable  int
declare @ram_id_documento 				int
declare @ram_id_Empresa   				int -- TODO:EMPRESA

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id,  @cue_id out,  @ram_id_cuenta out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_centrocosto out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@doc_id,  @doc_id out,  @ram_id_documento out
exec sp_ArbConvertId @@emp_id,  @emp_id out,  @ram_id_Empresa out -- TODO:EMPRESA

exec sp_GetRptId @clienteID out

if @ram_id_cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
	end else 
		set @ram_id_cuenta = 0
end

if @ram_id_centrocosto <> 0 begin

--	exec sp_ArbGetGroups @ram_id_centrocosto, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_centrocosto, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_centrocosto, @clienteID 
	end else 
		set @ram_id_centrocosto = 0
end

if @ram_id_circuitocontable <> 0 begin

--	exec sp_ArbGetGroups @ram_id_circuitocontable, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_circuitocontable, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_circuitocontable, @clienteID 
	end else 
		set @ram_id_circuitocontable = 0
end

if @ram_id_documento <> 0 begin

--	exec sp_ArbGetGroups @ram_id_documento, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_documento, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_documento, @clienteID 
	end else 
		set @ram_id_documento = 0
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

--////////////////////////////////////////////////////////////////////////
-- Saldo inicial

select 
			0                                         as [Orden],
			cue_nombre    													  as [Cuenta],
			cue_codigo    													  as [Codigo],
			@@Fini                                    as [Fecha],
			''																				as [Tipo documento],
      ''                                        as [Empresa], -- TODO:EMPRESA
			''     																		as [Comprobante],
			'' 																				as [Asiento],
			''                											  as [Numero],
			''                												as [Descripcion],
			ccos_nombre																as [Centro Costo],
			cico_nombre																as [Circuito contable],
			sum(asi_debe)											  			as [Debe],
			sum(asi_haber)               			  			as [Haber],
			sum(asi_debe)-sum(asi_haber)							as [Saldo],
			sum(case 
				when asi_debe > 0 then asi_origen  			
				else 0
			end)																			as [Debe mon Ext],
			sum(case 
				when asi_haber > 0 then asi_origen  			
				else 0
			end)																			as [Haber mon Ext],
			sum(case 
						when asi_debe > 0 then asi_origen  			
						else 0
					end)
			- sum(case 
						when asi_haber > 0 then asi_origen  			
						else 0
					end)    															as [Saldo mon Ext],
			@@bMonExt                   			  			as [Ver mon Ext]

from

	AsientoItem           inner join Cuenta 							 on AsientoItem.cue_id  		= Cuenta.cue_id
												left  join CentroCosto  				 on AsientoItem.ccos_id 		= CentroCosto.ccos_id
												inner join Asiento      				 on AsientoItem.as_id   		= Asiento.as_id
	                      inner join Documento    				 on Asiento.doc_id      		= Documento.doc_id
	                      inner join Empresa               on Documento.emp_id        = Empresa.emp_id -- TODO:EMPRESA
	                      inner join CircuitoContable			 on Documento.cico_id   		= CircuitoContable.cico_id
												inner join DocumentoTipo doct    on Asiento.doct_id         = doct.doct_id
												left  join DocumentoTipo doctcl  on Asiento.doct_id_cliente = doctcl.doct_id
	
											 left join facturaVenta  			fv 	 on id_cliente = fv.fv_id 		 and doct_id_cliente in (1,7,9)
											 left join facturaCompra 			fc 	 on id_cliente = fc.fc_id 		 and doct_id_cliente in (2,8,10)
											 left join cobranza      			cobz on id_cliente = cobz.cobz_id  and doct_id_cliente = 13
											 left join ordenPago     			opg  on id_cliente = opg.opg_id    and doct_id_cliente = 16
											 left join movimientoFondo    mf   on id_cliente = mf.mf_id      and doct_id_cliente = 26
											 left join depositoBanco      dbco on id_cliente = dbco.dbco_id  and doct_id_cliente = 17
											 left join depositoCupon      dcup on id_cliente = dcup.dcup_id  and doct_id_cliente = 32
											 left join resolucionCupon    rcup on id_cliente = rcup.rcup_id  and doct_id_cliente = 33
					
											 left join documento  			dfv 	 on fv.doc_id   = dfv.doc_id
											 left join documento  			dfc 	 on fc.doc_id   = dfc.doc_id
											 left join documento  			dcobz  on cobz.doc_id = dcobz.doc_id
											 left join documento  			dopg   on opg.doc_id  = dopg.doc_id
											 left join documento  			dmf    on mf.doc_id   = dmf.doc_id
											 left join documento  			ddbco  on dbco.doc_id = ddbco.doc_id
											 left join documento  			ddcup  on dcup.doc_id = ddcup.doc_id
											 left join documento  			drcup  on rcup.doc_id = drcup.doc_id

where 
		  as_fecha >= @@Fini  
	and as_fecha <= @@Ffin

-- TODO:EMPRESA
			and (
						exists(select * from EmpresaUsuario where emp_id = documento.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (AsientoItem.cue_id 	= @cue_id  or @cue_id=0)
and   (AsientoItem.ccos_id  = @ccos_id or @ccos_id=0)
and   (Documento.cico_id 		= @cico_id or @cico_id=0)
and   (
						((dfv.doc_id 	 = @doc_id  or @doc_id=0) and dfv.doc_id is not null)
				or
						((dfc.doc_id 	 = @doc_id  or @doc_id=0) and dfc.doc_id is not null)
				or
						((dcobz.doc_id  = @doc_id  or @doc_id=0) and dcobz.doc_id is not null)
				or
						((dopg.doc_id   = @doc_id  or @doc_id=0) and dopg.doc_id is not null)
				or
						((dmf.doc_id    = @doc_id  or @doc_id=0) and dmf.doc_id is not null)
				or
						((ddbco.doc_id  = @doc_id  or @doc_id=0) and ddbco.doc_id is not null)
				or
						((ddcup.doc_id  = @doc_id  or @doc_id=0) and ddcup.doc_id is not null)
				or
						((drcup.doc_id  = @doc_id  or @doc_id=0) and drcup.doc_id is not null)
			)
and   (Empresa.emp_id 			= @emp_id  or @emp_id=0) -- TODO:EMPRESA

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 -- tbl_id de Proyecto
                  and  rptarb_hojaid = AsientoItem.cue_id
							   ) 
           )
        or 
					 (@ram_id_cuenta = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 21 -- tbl_id de Proyecto
                  and  rptarb_hojaid = AsientoItem.ccos_id
							   ) 
           )
        or 
					 (@ram_id_centrocosto = 0)
			 )

and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1016 -- tbl_id de Proyecto
                  and  rptarb_hojaid = Documento.cico_id
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
                  and  tbl_id = 4001 -- select * from tabla where tbl_nombre like '%documento%'
									and   (
															(rptarb_hojaid = dfv.doc_id and dfv.doc_id is not null)
													or
															(rptarb_hojaid = dfc.doc_id and dfc.doc_id is not null)
													or
															(rptarb_hojaid = dcobz.doc_id and dcobz.doc_id is not null)
													or
															(rptarb_hojaid = dopg.doc_id and dopg.doc_id is not null)
													or
															(rptarb_hojaid = dmf.doc_id and dmf.doc_id is not null)
													or
															(rptarb_hojaid = ddbco.doc_id  and ddbco.doc_id is not null)
													or
															(rptarb_hojaid = ddcup.doc_id  and ddcup.doc_id is not null)
													or
															(rptarb_hojaid = drcup.doc_id  and drcup.doc_id is not null)
												)

							   ) 
           )
        or 
					 (@ram_id_documento = 0)
			 )
-- TODO:EMPRESA
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 1018 -- select * from tabla where tbl_nombre = 'empresa'
                  and  rptarb_hojaid = Documento.emp_id
							   ) 
           )
        or 
					 (@ram_id_Empresa = 0)
			 )

	group by
			cue_nombre,
			cue_codigo,
			ccos_nombre,
			cico_nombre


order by cue_nombre, orden, Fecha

end
go