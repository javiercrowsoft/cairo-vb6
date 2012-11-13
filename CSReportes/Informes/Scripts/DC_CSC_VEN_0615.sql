/*---------------------------------------------------------------------
Nombre: Imputacion Contable de Documentos de Venta
---------------------------------------------------------------------*/
/*  

select * from empresa

select * from cuenta where cuec_id = 8

Para testear:

exec DC_CSC_VEN_0615 1,'20060501','20070430','0','0','0',0,'1',0

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_0615]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_0615]

go
create procedure DC_CSC_VEN_0615 (

  @@us_id    			int,
	@@Fini 		 		  datetime,
	@@Ffin 		 			datetime,

	@@cue_id 				varchar(255),
	@@ccos_id 			varchar(255),
	@@cico_id				varchar(255),
	@@bMonExt 			smallint, 
  @@emp_id    		varchar(255),
	@@bSaldo    		smallint,
	@@bSinAsEj      smallint
) 

as 

begin

	set nocount on

	create table #t_dc_csc_ven_0615_as (as_id int)

	if @@bSinAsEj <> 0 begin
		insert into #t_dc_csc_ven_0615_as(as_id)
		select as_id_apertura 					from ejerciciocontable
		union
		select as_id_cierrepatrimonial 	from ejerciciocontable
		union
		select as_id_cierreresultados 	from ejerciciocontable
	end

	create table #t_DC_CSC_VEN_0615 (cue_id int)

	insert into #t_DC_CSC_VEN_0615 (cue_id)

	select distinct cue_id
	from Cobranza cobz inner join CobranzaItem cobzi on 	cobz.cobz_id = cobzi.cobz_id
																										and cobzi_tipo  = 5 -- cuenta corriente
	where cobz_fecha between @@Fini and @@Ffin
		and	est_id <> 7

	insert into #t_DC_CSC_VEN_0615 (cue_id)

	select distinct isnull(isnull(cue.cue_id,
																clicueg.cue_id),
												 cueg.cue_id)

	from FacturaVenta fv  left join Asiento ast     								on fv.as_id 		= ast.as_id
												left join AsientoItem asi 								on ast.as_id 		= asi.as_id
												left join Cuenta cue      								on 	asi.cue_id 	= cue.cue_id
																																	and	cue.cuec_id = 4

												inner join documento doc  								on fv.doc_id 			= doc.doc_id
												inner join cuentagrupo cueg 							on doc.cueg_id 		= cueg.cueg_id
												left  join Clientecuentagrupo clicueg 	  on cueg.cueg_id 	= clicueg.cueg_id
																																	and	fv.cli_id 		= clicueg.cli_id
	where fv_fecha between @@Fini and @@Ffin
		and est_id <> 7
		and not exists(select * from #t_DC_CSC_VEN_0615 
									where cue_id = isnull(isnull(cue.cue_id,
																								clicueg.cue_id),
																				 cueg.cue_id)
								)

--	select cue_nombre,cue.cue_id from #t_DC_CSC_VEN_0615 t inner join cuenta cue on t.cue_id = cue.cue_id


/*- ///////////////////////////////////////////////////////////////////////

INICIO PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

declare @cue_id int
declare @ccos_id int
declare @cico_id int
declare @emp_id int 

declare @ram_id_cuenta int
declare @ram_id_centrocosto int
declare @ram_id_circuitocontable int
declare @ram_id_Empresa   int 

declare @clienteID int
declare @IsRaiz    tinyint

exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_cuenta out
exec sp_ArbConvertId @@ccos_id, @ccos_id out, @ram_id_centrocosto out
exec sp_ArbConvertId @@cico_id, @cico_id out, @ram_id_circuitocontable out
exec sp_ArbConvertId @@emp_id, @emp_id out, @ram_id_Empresa out 

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
			0 																				as as_id,
			0 																				as comp_id,
			0 																				as doct_id,

			cue_codigo                                as [Codigo],
			cue_nombre    													  as [Cuenta],
			@@Fini                                    as [Fecha],
			case 
				when doct_id_cliente in (1,7,9,13) then 1
        else                                     2
      end                                       as [De Ventas],
			''																				as [Tipo documento],
      ''                                        as [Empresa], 

			'(Saldo inicial)'    											as [Comprobante],
      ''                                        as [Comp. Origen],
      ''																	      as [Asiento],

      ''                                        as Cliente,
      ''                                        as Cliente,
			isnull(cli_nombre,'(Sin Tercero)')				as Tercero,
			''                											  as [Numero],
			''                												as [Descripcion],
			''	        															as [Centro Costo],
			sum(asi_debe)						  								as [Debe],
			sum(asi_haber)      			  							as [Haber],
			sum(case 
				when asi_debe > 0 then asi_origen  			
				else 0
			end)																			as [Debe mon Ext],
			sum(case 
				when asi_haber > 0 then asi_origen  			
				else 0
			end)																			as [Haber mon Ext],
			@@bMonExt                   			  			as [Ver mon Ext]

from

			AsientoItem asi         inner join Cuenta cue						 on 		asi.cue_id  = cue.cue_id 
																																	and @@bSaldo <> 0

															inner join Asiento ast   				 on asi.as_id   				= ast.as_id
                              inner join Documento doc 				 on ast.doc_id      		= doc.doc_id
                              inner join Empresa emp           on doc.emp_id        	= emp.emp_id 
                              inner join CircuitoContable	cico on doc.cico_id   			= cico.cico_id
															inner join DocumentoTipo doct    on ast.doct_id         = doct.doct_id
															left  join DocumentoTipo doctcl  on ast.doct_id_cliente = doctcl.doct_id
                              left  join Documento doccl			 on ast.doc_id_cliente	= doccl.doc_id                              

                              left  join FacturaVenta fv       on doct_id_cliente in (1,7,9) and fv.as_id = ast.as_id
                              left  join Cobranza cobz         on doct_id_cliente = 13 and cobz.as_id = ast.as_id
															left  join Cliente cli           on (		 fv.cli_id   = cli.cli_id
																																		or cobz.cli_id = cli.cli_id
																																	)

where 
				  as_fecha < @@Fini  
			and @@bSaldo <> 0

			and exists(select * from #t_DC_CSC_VEN_0615 where cue_id = cue.cue_id)

			and not exists(select * from #t_dc_csc_ven_0615_as where as_id = ast.as_id)

			-- Si son facturas tiene que ser la cuenta del deudor
			--
			and (fv.fv_id is null or asi.asi_tipo = 1) 

			-- Si son cobz tiene que ser la cuenta del deudor
			--
			and (cobz.cobz_id is null or exists (select * from Cobranzaitem cobzi 
	                                         where cobzi.cobz_id = cobz.cobz_id 
																						 and cobzi_tipo 	 = 5 
																						 and cobzi.cue_id  = asi.cue_id
																					)
					)

			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)
/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cue.cue_id = @cue_id or @cue_id=0)
and   (asi.ccos_id = @ccos_id or @ccos_id=0)
and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id=0)
and   (emp.emp_id = @emp_id or @emp_id=0) 

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 
                  and  rptarb_hojaid = asi.cue_id
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
                  and  tbl_id = 21 
                  and  rptarb_hojaid = asi.ccos_id
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
                  and  tbl_id = 1016 
                  and  rptarb_hojaid = IsNull(doccl.cico_id,doc.cico_id)
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

	group by
			isnull(cli_nombre,'(Sin Tercero)'),
			cue_codigo,
			cue_nombre,
			case 
				when doct_id_cliente in (1,7,9,13)  then 1
        else                                     2
      end

union all

--////////////////////////////////////////////////////////////////////////
-- Entre fechas

select 
			ast.as_id,
			id_cliente																as comp_id,
			doct_id_cliente														as doct_id,
			cue_codigo																as Codigo,
			cue_nombre    													  as Cuenta,
			as_fecha                                  as Fecha,
			case 
				when doct_id_cliente in (1,7,9,13)  then 1
        else                                     2
      end                                       as [De Ventas],
			IsNull(doctcl.doct_nombre,
						 doct.doct_nombre)								  as [Tipo documento],
      emp_nombre                                as Empresa, 

			as_nrodoc + ' ' + as_doc_cliente     		  as Comprobante,
      as_doc_cliente                            as [Comp. Origen],
      as_nrodoc																	as [Asiento],

      cli_nombre                                as Cliente,
      prov_nombre                               as Proveedor,
			isnull(cli_nombre,
             isnull('(*Proveedor: '+prov_nombre+')','(Sin Tercero)')) 	
																								as Tercero,
			
			as_numero         											  as Numero,
			as_descrip        												as Descripcion,
			ccos_nombre																as [Centro Costo],
			asi_debe									  							as Debe,
			asi_haber           			  							as Haber,
			case 
				when asi_debe > 0 then asi_origen  			
				else 0
			end																				as [Debe mon Ext],
			case 
				when asi_haber > 0 then asi_origen  			
				else 0
			end																				as [Haber mon Ext],
			@@bMonExt                   			  			as [Ver mon Ext]

from

			AsientoItem asi         inner join Cuenta cue						 on asi.cue_id  				= cue.cue_id
															inner join Asiento ast   				 on asi.as_id   				= ast.as_id
                              inner join Documento doc 				 on ast.doc_id      		= doc.doc_id
                              inner join Empresa emp           on doc.emp_id        	= emp.emp_id 
                              inner join CircuitoContable	cico on doc.cico_id   			= cico.cico_id
															inner join DocumentoTipo doct    on ast.doct_id         = doct.doct_id
															left  join CentroCosto ccos			 on asi.ccos_id 				= ccos.ccos_id
															left  join DocumentoTipo doctcl  on ast.doct_id_cliente = doctcl.doct_id
                              left  join Documento doccl			 on ast.doc_id_cliente	= doccl.doc_id

                              left  join FacturaVenta fv       on doct_id_cliente in (1,7,9) and fv.as_id  = ast.as_id
                              left  join FacturaCompra fc      on doct_id_cliente in (2,8,10) and fc.as_id = ast.as_id
                              left  join Cobranza cobz         on doct_id_cliente = 13 and cobz.as_id = ast.as_id
                              left  join OrdenPago opg         on doct_id_cliente = 16 and opg.as_id = ast.as_id
                              left  join MovimientoFondo mf    on doct_id_cliente = 26 and mf.as_id = ast.as_id

                              left  join Cliente cli on      fv.cli_id   = cli.cli_id 
                                                          or cobz.cli_id = cli.cli_id 
                                                          or mf.cli_id   = cli.cli_id

                              left  join Proveedor prov on   fc.prov_id  = prov.prov_id 
                                                          or opg.prov_id = prov.prov_id 
where 

				  as_fecha >= @@Fini
			and	as_fecha <= @@Ffin

			-- Si son facturas tiene que ser la cuenta del deudor
			--
			and (fv.fv_id is null or asi.asi_tipo = 1) 

			-- Si son cobz tiene que ser la cuenta del deudor
			--
			and (cobz.cobz_id is null or exists (select * from Cobranzaitem cobzi 
	                                         where cobzi.cobz_id = cobz.cobz_id 
																						 and cobzi_tipo 	 = 5 
																						 and cobzi.cue_id  = asi.cue_id
																					)
					)

			and exists(select * from #t_DC_CSC_VEN_0615 where cue_id = cue.cue_id)

			and not exists(select * from #t_dc_csc_ven_0615_as where as_id = ast.as_id)

			and (
						exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
					)

/* -///////////////////////////////////////////////////////////////////////

INICIO SEGUNDA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

and   (cue.cue_id = @cue_id or @cue_id=0)
and   (ccos.ccos_id = @ccos_id or @ccos_id=0)
and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id=0)
and   (emp.emp_id = @emp_id or @emp_id=0) 

-- Arboles
and   (
					(exists(select rptarb_hojaid 
                  from rptArbolRamaHoja 
                  where
                       rptarb_cliente = @clienteID
                  and  tbl_id = 17 
                  and  rptarb_hojaid = asi.cue_id
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
                  and  tbl_id = 21 
                  and  rptarb_hojaid = asi.ccos_id
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
                  and  tbl_id = 1016 
                  and  rptarb_hojaid = IsNull(doccl.cico_id,doc.cico_id)
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

order by tercero, [de Ventas], cue_nombre, cue_codigo, Fecha, [Comp. Origen]

end