
/*---------------------------------------------------------------------
Nombre: Mayor de cuentas con detalle de cheques
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0295]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0295]


/*

 [DC_CSC_CON_0295] 1,'20060120 00:00:00','20060131 00:00:00','0','0','0',0,'0',0

 [DC_CSC_CON_0295] 1,'20060120 00:00:00','20060129 00:00:00','0','0','0',0,'0',0

*/

go
create procedure DC_CSC_CON_0295(

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


create table #t_DC_CSC_CON_0295 (
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
        [Comp. Origen]          varchar(500),
				[Asiento]								varchar(50),

        [Cliente]               varchar(255),
        [Proveedor]             varchar(255),

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

/*- ///////////////////////////////////////////////////////////////////////

FIN PRIMERA PARTE DE ARBOLES

/////////////////////////////////////////////////////////////////////// */

--////////////////////////////////////////////////////////////////////////
-- Saldo inicial
insert into #t_DC_CSC_CON_0295

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
          ''                                        as [Comp. Origen],
          ''																	      as [Asiento],

          ''                                        as Cliente,
          ''                                        as Proveedor,

					''                											  as [Numero],
					''  																			as [Descripcion],
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
		
					AsientoItem asi         inner join Cuenta cue						 on asi.cue_id  				= cue.cue_id
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
		and   (asi.ccos_id  = @ccos_id 	or @ccos_id=0)
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
-- Entre fechas

		select 
					1                                         as Orden,
					ast.as_id,
					id_cliente,
					doct_id_cliente,
					asi.cue_id,
					asi.asi_id,
					asi.cheq_id,
		
					cue_nombre    													  as Cuenta,
					isnull(cheq_fecha2,as_fecha)              as Fecha,
					IsNull(doctcl.doct_nombre,
								 doct.doct_nombre)								  as [Tipo documento],
		      emp_nombre                                as Empresa, 

					as_nrodoc + ' ' 
					+ isnull(doctcli.doct_codigo,'') + ' ' 
					+ as_doc_cliente     		  								as Comprobante,

          as_doc_cliente                            as [Comp. Origen],
          as_nrodoc																	as [Asiento],

          cli_nombre                                as Cliente,
          prov_nombre                               as Proveedor,

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

																	left  join DocumentoTipo doctcli on ast.doct_id_cliente = doctcli.doct_id

														  		left  join Cheque cheq           on asi.cheq_id         = cheq.cheq_id
		where 
		
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

/* -///////////////////////////////////////////////////////////////////////

SELECT DE RETORNO

/////////////////////////////////////////////////////////////////////// */

		select 

					asi.[Orden]									,
					asi.as_id					as comp_id,
					15								as doct_id,
					asi.as_id										,
					asi.id_cliente							,
					asi.doct_id_cliente					,
					asi.cue_id                  ,
					asi.asi_id									,
					asi.cheq_id                 ,
					asi.[Cuenta]								,
					asi.[Fecha]									,
					asi.[Tipo documento]				,
					asi.[Empresa]								,

					asi.[Comprobante]						,
          asi.[Comp. Origen]          ,
					asi.[Asiento]								,

          asi.[Cliente]               ,
          asi.[Proveedor]             ,

					asi.[Numero]								,
					asi.[Descripcion]						,
					asi.[Centro Costo]					,
					asi.[Debe]									,
					asi.[Haber]									,
					asi.[Saldo]									,
					asi.[Debe mon Ext]					,
					asi.[Haber mon Ext]					,
					asi.[Saldo mon Ext]					,

					1                     as orden_id,                                    
					@@bMonExt             as [Ver mon Ext],
		
					null   								as [Cheque],
					null  								as [Nro. Cheque],
					null   								as Importe,			
					null   								as [Importe Origen],
					null  								as Tipo,
					null									as Cobro,
					null									as Vencimiento,
					null  								as Observaciones,
					null  								as Clearing
		
		from #t_DC_CSC_CON_0295	asi

		union all
		
		select 

					asi.[Orden]									,
					asi.as_id					as comp_id,
					15								as doct_id,
					asi.as_id										,
					asi.id_cliente							,
					asi.doct_id_cliente					,
					asi.cue_id                  ,
					asi.asi_id									,
					asi.cheq_id                 ,
					asi.[Cuenta]								,
					asi.[Fecha]									,
					asi.[Tipo documento]				,
					asi.[Empresa]								,

					asi.[Comprobante]						,
          asi.[Comp. Origen]          ,
					asi.[Asiento]								,

          asi.[Cliente]               ,
          asi.[Proveedor]             ,

					asi.[Numero]								,
					asi.[Descripcion]						,
					asi.[Centro Costo]					,
					0 as [Debe]									,
					0 as [Haber]								,
					0 as [Saldo]								,
					0 as [Debe mon Ext]					,
					0 as [Haber mon Ext]				,
					0 as [Saldo mon Ext]				,

					2                     as orden_id,                                    
					@@bMonExt             as [Ver mon Ext],

					cheq_numero																as [Cheque],
					cheq_numerodoc														as [Nro. Cheque],
					cheq_importe															as Importe,
					cheq_importeOrigen												as [Importe Origen],
					case
							when cheq_tipo = 1 then 		'Propio'
							when cheq_propio <> 0 then	'De tercero (p)'
							else							      		'De tercero'
					end																				as Tipo,
					cheq_fechacobro             							as Cobro,
					cheq_fechaVto															as Vencimiento,
					cheq_descrip															as Observaciones,
					cle_nombre																as Clearing
		
		
		from #t_DC_CSC_CON_0295 asi	  inner join Cheque cheq          on asi.cheq_id  = cheq.cheq_id
																	inner join Clearing cle         on cheq.cle_id  = cle.cle_id
		

		order by Cuenta, Orden, Fecha, asi.[Comp. Origen], asi_id, orden_id, Cobro

end

go

