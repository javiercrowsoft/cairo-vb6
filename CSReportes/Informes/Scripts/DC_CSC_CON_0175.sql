/*---------------------------------------------------------------------
Nombre: Resumen del Mayor de cuentas por cuentas relacionadas
				si existe el cheque toma la fecha del campo cheq_fechacobro
				sino usa as_fecha
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0175]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0175]


/*

	select * from cuenta where cue_nombre like '%itau%'

 [DC_CSC_CON_0175] 1,'20061201 00:00:00','20061231 00:00:00','23','0','0',0,'0',0

 [DC_CSC_CON_0175] 1,'20070117 00:00:00','20070117 00:00:00','26','0','0',0,'0',0

*/

go
create procedure DC_CSC_CON_0175(

  @@us_id    int,
	@@Fini 		 datetime,
	@@Ffin 		 datetime,

	@@cue_id 		varchar(255),
	@@ccos_id 	varchar(255),
	@@cico_id		varchar(255),
	@@bMonExt 	smallint, 
  @@emp_id    varchar(255),
	@@bSaldo    smallint
) 

as 

begin

set nocount on

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


create table #t_DC_CSC_CON_0175 (
				[Orden]									int,
				as_id										int,
				id_cliente							int,
				doct_id_cliente					int,
				cue_id                  int,
				asi_id									int,
				cheq_id                 int,
				[Cuenta]								varchar(255),
				[Fecha]									datetime,
				[Tipo documento]				varchar(255),
				[Empresa]								varchar(255), 
				[Comprobante]						varchar(500),
				[Asiento]								varchar(50),
				[Numero]								varchar(50),
				[Descripcion]						varchar(5000),
				[Centro Costo]					varchar(255),
				[Debe]									decimal(18,6),
				[Haber]									decimal(18,6),
				[Saldo]									decimal(18,6),
				[Debe mon Ext]					decimal(18,6),
				[Haber mon Ext]					decimal(18,6),
				[Saldo mon Ext]					decimal(18,6)
)

create table #t_DC_CSC_CON_0175_2 (
				cue_id                  int,
				asi_id									int,
				asi_id2									int,
				Debe									  decimal(18,6),
				Haber									  decimal(18,6),
				[Debe mon Ext]					decimal(18,6),
				[Haber mon Ext]					decimal(18,6)
)


/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */


insert into #t_DC_CSC_CON_0175


--////////////////////////////////////////////////////////////////////////
--
--
-- Saldo inicial
--
--
--////////////////////////////////////////////////////////////////////////


					select 
								0                                         as [Orden],
								0 																				as as_id,
								0 																				as id_cliente,
								0 																				as doct_id_cliente,
								asi.cue_id,
								0																					as asi_id,
								0																					as cheq_id,
					
								cue_nombre    													  as [Cuenta],
								@@Fini                                    as [Fecha],
								''																				as [Tipo documento],
					      ''                                        as [Empresa], 
								'Saldo inicial'     											as [Comprobante],
								'' 																				as [Asiento],
								''                											  as [Numero],
								''                												as [Descripcion],
								''	        															as [Centro Costo],
								sum(asi_debe)											  			as [Debe],
								sum(asi_haber)               			  			as [Haber],
								0			  																	as [Saldo],
								sum(case 
									when asi_debe > 0 then asi_origen  			
									else 0
								end)																			as [Debe mon Ext],
								sum(case 
									when asi_haber > 0 then asi_origen  			
									else 0
								end)																			as [Haber mon Ext],
								0			  																	as [Saldo mon Ext]
					
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
																				left  join Cheque cheq           on asi.cheq_id         = cheq.cheq_id
					
					where 
--									  ((as_fecha < @@Fini and asi.cheq_id is null) or  cheq_fechacobro < @@Fini)
								  --as_fecha < @@Fini  
									(			(as_fecha < @@Fini and asi.cheq_id is null) 
										or  (cheq_fechacobro < @@Fini and cheq_fechacobro >= as_fecha)
										or  (as_fecha < @@Fini and cheq_fechacobro < as_fecha)
									)

								and @@bSaldo <> 0
					
								and (
											exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
										)
					/* -///////////////////////////////////////////////////////////////////////
					
					INICIO SEGUNDA PARTE DE ARBOLES
					
					/////////////////////////////////////////////////////////////////////// */
					
					and   (cue.cue_id 	= @cue_id 	or @cue_id=0)
					and   (asi.ccos_id 	= @ccos_id 	or @ccos_id=0)
					and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id=0)
					and   (emp.emp_id 	= @emp_id 	or @emp_id=0) 

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
											asi.cue_id, cue_nombre

union all

--////////////////////////////////////////////////////////////////////////
--
--
-- Entre fechas
--
--
--////////////////////////////////////////////////////////////////////////

						select 
									1                                         as Orden,
									ast.as_id,
									id_cliente,
									doct_id_cliente,
									asi.cue_id,
									asi.asi_id,
									asi.cheq_id,
						
									cue_nombre    													  as Cuenta,
									as_fecha                                  as Fecha,
									IsNull(doctcl.doct_nombre,
												 doct.doct_nombre)								  as [Tipo documento],
						      emp_nombre                                as Empresa, 
									as_doc_cliente     											  as Comprobante,
									as_nrodoc																	as [Asiento],
									as_numero         											  as Numero,
									as_descrip        												as Descripcion,
									ccos_nombre																as [Centro Costo],
									asi_debe													  			as Debe,
									asi_haber                    			  			as Haber,
									0			  																	as Saldo,
									case 
										when asi_debe > 0 then asi_origen  			
										else 0
									end																				as [Debe mon Ext],
									case 
										when asi_haber > 0 then asi_origen  			
										else 0
									end																				as [Haber mon Ext],
									0			  																	as [Saldo mon Ext]
						
						from
						
									AsientoItem asi         inner join Cuenta cue						 on asi.cue_id  				= cue.cue_id
																					left  join CentroCosto ccos			 on asi.ccos_id 				= ccos.ccos_id
																					inner join Asiento ast   				 on asi.as_id   				= ast.as_id
						                              inner join Documento doc 				 on ast.doc_id      		= doc.doc_id
						                              inner join Empresa emp           on doc.emp_id        	= emp.emp_id 
						                              inner join CircuitoContable	cico on doc.cico_id   			= cico.cico_id
																					inner join DocumentoTipo doct    on ast.doct_id         = doct.doct_id
																					left  join DocumentoTipo doctcl  on ast.doct_id_cliente = doctcl.doct_id
						                              left  join Documento doccl			 on ast.doc_id_cliente	= doccl.doc_id
																					left  join Cheque cheq           on asi.cheq_id         = cheq.cheq_id
						
						where 
-- 									(
-- 											(	  	as_fecha between @@Fini and @@Ffin
-- 												and asi.cheq_id is null
-- 											)
-- 										or (cheq_fechacobro between @@Fini and @@Ffin)
-- 									)

									(
											(	  	as_fecha between @@Fini and @@Ffin
												and asi.cheq_id is null
											)
										or (cheq_fechacobro between @@Fini and @@Ffin and cheq_fechacobro >= as_fecha)
										or (as_fecha between @@Fini and @@Ffin and as_fecha > cheq_fechacobro)
									)
						
									and (
												exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
											)
						
						/* -///////////////////////////////////////////////////////////////////////
						
						INICIO SEGUNDA PARTE DE ARBOLES
						
						/////////////////////////////////////////////////////////////////////// */
						
						and   (cue.cue_id 	= @cue_id 	or @cue_id=0)
						and   (ccos.ccos_id = @ccos_id 	or @ccos_id=0)
						and   (IsNull(doccl.cico_id,doc.cico_id) = @cico_id or @cico_id=0)
						and   (emp.emp_id 	= @emp_id 	or @emp_id=0) 

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


--////////////////////////////////////////////////////////////////////////
--
--
-- Aplicacion de las cuentas del asiento entre debe y haber
--
--
--////////////////////////////////////////////////////////////////////////
									
									declare @asi_id 			int		
									declare @asi_id2			int
									declare @asi_id3			int
									declare @cue_id_asi3	int
									declare @monto      	decimal(18,6)
									declare @monto2     	decimal(18,6)
									declare @monto3     	decimal(18,6)
									declare @aplicado     decimal(18,6)
									declare @as_id        int
									declare @asi_orden  	int
									declare @isdebe     	tinyint
									
									
									-- Creamos un cursor sobre todos los asientoitems 
									-- que afectan a nuestra cuenta
									--
									declare c_asi insensitive cursor for 
									
												select asi_id 
												from #t_DC_CSC_CON_0175 
												where orden <> 0
												order by asi_id
									
									open c_asi
									
									fetch next from c_asi into @asi_id
									while @@fetch_status = 0
									begin
									
										select 	@as_id 			= as_id, 
														@asi_orden 	= asi_orden,  
														@isdebe 		= case when asi_debe <> 0 then 1 else 0 end,
														@monto3     = case when asi_debe <> 0 then asi_debe else asi_haber end
									
										from AsientoItem 
										where asi_id = @asi_id
									
										-------------------------------------------------------------------------------------------
										--
										declare c_asi2 insensitive cursor for 
									
												select asi_id, case @isdebe when 0 then asi_haber else asi_debe end
												from AsientoItem asi
												where as_id = @as_id 
									
													-- Debe estar antes que el asientoitem que estamos procesando
													--
													and asi_orden < @asi_orden
									
													-- Debe estar del mismo lado (debe o haber) 
													-- que el asientoitem que estamos procesando
													--
													and (		
																	(@isdebe <> 0 and asi_debe  <> 0) 
																or
																	(@isdebe = 0  and asi_haber <> 0) 
															)
									
													-- No tiene que estar procesada aun
													--
													and not exists(select * from #t_DC_CSC_CON_0175_2 where asi_id = asi.asi_id)
										
												order by asi_orden
									
										open c_asi2
										
										fetch next from c_asi2 into @asi_id2, @monto
										while @@fetch_status = 0
										begin
									
											-------------------------------------------------------------------------------------------
											--
									
											-- Otro cursorsito mas :)
											--
									
											-- Buscamos todos los asientoitem
											-- que esten del OTRO lado (debe o haber) (EL LADO OSCURO :)
											-- que el asientoitem que estamos procesando
											--
									
											declare c_asi3 insensitive cursor for
									
													select 	asi_id, 
																	cue_id,
									
																		asi_debe 
																	+ asi_haber 
																	- IsNull((select sum(debe + haber)
																		 from #t_DC_CSC_CON_0175_2 
																		 where asi_id2 = asi.asi_id
																		),0)
									
													from AsientoItem asi
													where as_id = @as_id 
										
														-- Debe estar del lado contrario (debe o haber) 
														-- que el asientoitem que estamos procesando
														--
														and (		
																		(@isdebe <> 0 and asi_haber <> 0) 
																	or
																		(@isdebe = 0  and asi_debe  <> 0) 
																)
										
														-- No tiene que estar procesada aun
														--
														and not exists( select * from #t_DC_CSC_CON_0175_2 
																					  where asi_id2 = asi.asi_id 
																							and debe + haber = (asi_debe + asi_haber)
																					)
									
													order by asi_orden
									
											open c_asi3
											
											fetch next from c_asi3 into @asi_id3, @cue_id_asi3, @monto2
											while @@fetch_status = 0
											begin
									
												if @monto < @monto2 set @aplicado = @monto
												else								set @aplicado = @monto2
									
												insert into #t_DC_CSC_CON_0175_2 (				
																													cue_id,                  
																													asi_id,								
																													asi_id2,									
																													Debe,									  
																													Haber,									  
																													[Debe mon Ext],					
																													[Haber mon Ext]					
																													)
																									values (
																													@cue_id_asi3,
																													@asi_id2,     --> OJO al Piojo: Esto no es un bug
																													@asi_id3,			-->               y esto tampoco
																													case @isdebe when 0 then @aplicado 	else 0 end,
																													case @isdebe when 0 then 0 					else  @aplicado end,
																													0,
																													0
																													)
									
									
												set @monto = @monto - @aplicado
									
												if @monto <=0 goto exit_c_asi3
									
												fetch next from c_asi3 into @asi_id3, @cue_id_asi3, @monto2
											end
									
									exit_c_asi3:
											
											close c_asi3
											deallocate c_asi3
											--
											-------------------------------------------------------------------------------------------
									
									
											fetch next from c_asi2 into @asi_id2, @monto
										end
										
										close c_asi2
										deallocate c_asi2
										--
										-------------------------------------------------------------------------------------------
									
										-------------------------------------------------------------------------------------------
										/*
									
									
													OK, si llegamos hasta aqui solo nos falta procesa el asientoitem de nuestra cuenta
									
									
										*/
										-------------------------------------------------------------------------------------------
									
											-------------------------------------------------------------------------------------------
											--
									
											set @monto = @monto3
									
											-- Otro cursorsito mas :)
											--
									
											-- Buscamos todos los asientoitem
											-- que esten del OTRO lado (debe o haber) (EL LADO OSCURO :)
											-- que el asientoitem que estamos procesando
											--
									
											declare c_asi3 insensitive cursor for
									
													select 	asi_id, 
																	cue_id,
									
																		asi_debe 
																	+ asi_haber 
																	- IsNull((select sum(debe + haber)
																		 from #t_DC_CSC_CON_0175_2 
																		 where asi_id2 = asi.asi_id
																		),0)
									
													from AsientoItem asi
													where as_id = @as_id 
										
														-- Debe estar del lado contrario (debe o haber) 
														-- que el asientoitem que estamos procesando
														--
														and (		
																		(@isdebe <> 0 and asi_haber <> 0) 
																	or
																		(@isdebe = 0  and asi_debe  <> 0) 
																)
										
														-- No tiene que estar procesada aun
														--
														and not exists( select * from #t_DC_CSC_CON_0175_2 
																					  where asi_id2 = asi.asi_id 
																							and (debe + haber) = (asi_debe + asi_haber)
																					)
									
													order by asi_orden
									
											open c_asi3
											
											fetch next from c_asi3 into @asi_id3, @cue_id_asi3, @monto2
											while @@fetch_status = 0
											begin
									
												if @monto < @monto2 set @aplicado = @monto
												else								set @aplicado = @monto2
									
												insert into #t_DC_CSC_CON_0175_2 (				
																													cue_id,                  
																													asi_id,								
																													asi_id2,									
																													Debe,									  
																													Haber,									  
																													[Debe mon Ext],					
																													[Haber mon Ext]					
																													)
																									values (
																													@cue_id_asi3,
																													@asi_id,      --> OJO al Piojo: Esto no es un bug
																													@asi_id3,			-->               y esto tampoco
																													case @isdebe when 0 then @aplicado 	else 0 end,
																													case @isdebe when 0 then 0 					else  @aplicado end,
																													0,
																													0
																													)
									
									
												set @monto = @monto - @aplicado
									
												if @monto <=0 goto exit_c_asi3_2
									
												fetch next from c_asi3 into @asi_id3, @cue_id_asi3, @monto2
											end
									
									exit_c_asi3_2:
											
											close c_asi3
											deallocate c_asi3
											--
											-------------------------------------------------------------------------------------------
									
										fetch next from c_asi into @asi_id
									end
									
									close c_asi
									deallocate c_asi
									--
									-------------------------------------------------------------------------------------------


--////////////////////////////////////////////////////////////////////////
--
--
-- Select de Retorno
--
--
--////////////////////////////////////////////////////////////////////////

									select 
												0                           as group_id,
												0                           as orden_id,
												cue.cue_id,
												cue_codigo									as Codigo,
												cue_identificacionexterna		as Codigo2,
												cue_nombre            			as Cuenta,
												sum(debe)										as Debe,
												sum(haber)									as Haber,
												sum(debe - haber)  					as Saldo
									
									from #t_DC_CSC_CON_0175 asi	  inner join Cuenta cue           on asi.cue_id = cue.cue_id
									
									where orden = 0
									
									group by cue.cue_id,
												cue_nombre,
												cue_codigo,
												cue_identificacionexterna
									
									union all
									
									select 
												0                           as group_id,
												1                           as orden_id,
												cue.cue_id,
												cue_codigo										as Codigo,
												cue_identificacionexterna			as Codigo2,
												cue_nombre            				as Cuenta,
												sum(asi2.haber)								as Debe,
												sum(asi2.debe)								as Haber,
												-sum(asi2.debe - asi2.haber)  as Saldo
									
									from #t_DC_CSC_CON_0175 asi	  inner join #t_DC_CSC_CON_0175_2 asi2     
																																								on 		asi.asi_id 	= asi2.asi_id
																								inner join Cuenta cue           on asi2.cue_id 		= cue.cue_id
									where orden <> 0 
									
									group by 	cue.cue_id,
														cue_nombre,
														cue_codigo,
														cue_identificacionexterna
									
									order by orden_id, cue_nombre


end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

