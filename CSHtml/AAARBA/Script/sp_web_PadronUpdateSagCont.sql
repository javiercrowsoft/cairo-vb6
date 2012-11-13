SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



ALTER    procedure sp_web_PadronUpdateSagCont (

			@@soc_id                                        int,
			@@pad_fecha                                     datetime,
			@@pad_callef                                    varchar(255),
			@@pad_localidadf                                varchar(255),
			@@pad_codPostalf                                varchar(255),
			@@pro_id_fiscal                                 int,
			@@pad_cuit                                      varchar(255),
			@@pad_cuil                                      varchar(255),
			@@catf_id                                       int,
			@@pad_ivaConstancia                             tinyint,
			@@pad_ivaCertExcRet                             tinyint,
			@@pad_ivaExcRetNro                              varchar(255),
			@@pad_ivaExcRetPorcentaje                       decimal,
			@@catfg_id                                      int,
			@@pad_ganConstancia                             tinyint,
			@@pad_ganCertExcRet                             tinyint,
			@@pad_ganExcRetNro                              varchar(255),
			@@pad_ganExcRetPorcentaje                       decimal,
			@@catib_id                                      int,
			@@pad_ingBrutosNro                              varchar(255),
			@@pad_ibConstancia                              tinyint,
			@@igbt_id                                       int,
			@@igbj_id                                       int,
			@@pad_ibJurisdiccion                            varchar(255),
			@@pad_ibCertExcRet                              tinyint,
			@@pad_ibExcRetNro                               varchar(255),
			@@pad_ibExcRetPorcentaje                        decimal,
			@@pad_descrip                                   varchar(255),
			@@pad_domFiscalAfip                             tinyint,
			@@pad_okContaduria                              tinyint,
			@@us_id_carga                                   int,
      @@pad_descripCont                               varchar(255),
      @@est_id_cont                                   int,

			@@pad_ivaCertExcFechaFin												datetime,
			@@pad_ganCertExcFechaFin												datetime,
			@@pad_ibCertExcFechaFin													datetime,

			@@pad_ivaCertExcFechaIni												datetime,
			@@pad_ganCertExcFechaIni												datetime,
			@@pad_ibCertExcFechaIni													datetime,

			@@pad_cbuInformada                              tinyint

)
as

begin

	set nocount on

		declare @pro_idf varchar(2)

--///////////////////////////////////////////////////////////////////////////////////////////////////
		select @pro_idf =

						case @@pro_id_fiscal

								--Codigo      Codi Descripcion          percep_ib_marca gran_contri_no_percep 
								----------- ---- -------------------- --------------- --------------------- 
								when 	31  			 --CF   Capital Federal      1               0
								then '00'        --Cidudad de Buenos Aires

								when  3          --BA   Buenos Aires         1               0
								then '01'        --Buenos Aires

								when  21         --CO   Cordoba              NULL            NULL
								then '03'        --Cordoba

								when  24         --ME   Mendoza              NULL            NULL
								then '07'        --Mendoza

								when  18         --TU   Tucuman              NULL            NULL
								then '14'        --Tucuman

								when  14         --SA   Salta                NULL            NULL
								then '09'        --Salta

								when  32         --SF   Santa Fe             NULL            NULL
								then '12'        --Santa Fe

								when  12         --LP   La Pampa             NULL            NULL
								then '21'        --La Pampa

								when  10         --CR   Corrientes           NULL            NULL
								then '04'        --Corrientes

								when  11         --ER   Entre Rios           NULL            NULL
								then '05'        --Entre Rios

								when  15         --FO   Formosa              0               0
								then '18'        --Formosa

								when  30         --TF   Tierra del Fuego     0               0
								then '24'        --Tierra del Fuego

								when  9          --MI   Misiones             0               0
								then '19'        --Misiones

								when  13         --JU   Jujuy                0               0
								then '06'        --Jujuy

								when  17         --CA   Catamarca            0               0
								then '02'        --Catamarca

								when  23         --SL   San Luis             0               0
								then '11'        --San Luis

								when  19         --SE   Santiago del Estero  0               0
								then '13'        --Santiago del Estero

								when  22         --SJ   San Juan             0               0
								then '10'        --San Juan

								when  29         --SC   Santa Cruz           0               0
								then '23'        --Santa Cruz

								when  34         --CH   Chubut               0               0
								then '17'        --Chubut

								when  26         --RN   Rio Negro            0               0
								then '22'        --Rio Negro

								when  8          --NE   Neuquen              0               0
								then '20'        --Neuquen

								when  16         --CHA  Chaco                0               0
								then '16'        --Chaco

								when  20				 --LR		La Rioja	
								then '08'        --La Rioja

								when null        --EXT  EXTRANJERA           0               0
								then '  '
						end

--///////////////////////////////////////////////////////////////////////////////////////////////////

		declare @catf_id int

		select @catf_id =

						case @@catf_id
																					-- 1           RI              Inscripto
												when 1  then 7    --NO USAR INSCRIPTO 21

																					-- 2           EX              Exento
												when 2  then 3    --EXENTO

																					-- 3           RNI             No Inscripto
												when 3  then 2    --NO INSCRIPTO

																					-- 4           CF              Consumidor Final
												when 4  then 9    --CONSUMIDOR FINAL

																					-- 5           EXT             Extranjero
												when 5  then 4    --EXPORTACION

																					-- 6           MON             Monotributo
												when 6  then 5    --MONOTRIBUTISTA

																					-- 10          NC              No Categorizado
												when 10 then 10   --NO CATEGORIZADO

																					-- 11          RIM             Inscripto M
												when 11 then 11   --RESPONSABLE INSCRIPTO ...

																					-- 4           CF              Consumidor Final

																					-- 12          NA              No Alcanzado
												when 12 then 8    --NO ALCANZADO

												else 9
						end

--///////////////////////////////////////////////////////////////////////////////////////////////////

		declare @usuario varchar(255) select @usuario = usuario from usuarios where id = @@us_id_carga

		update Proveedores set 	
													provincia						= @pro_idf, 
													Domicilio 					= @@pad_callef,
													Localidad						= @@pad_localidadf,
													CodigoPostal				= @@pad_codPostalf,
													cuit            		= @@pad_cuit,
													iva             		= @catf_id,
													ingresos_brutos			= @@catib_id,

													cbu_informada       = @@pad_cbuInformada,

													Modificado_Usuario 	= @usuario,
													Modificado_Fecha		= getdate(),
													Modificado_Hora			= getdate()


		where proveedor = @@soc_id


		if not exists (select * from Proveedores_Datos_Impositivos where proveedor = @@soc_id)
		begin

			insert Proveedores_Datos_Impositivos (PROVEEDOR,jurisdic_iibb,INSCRIPCION_AFIP,categoria_ganan,tipo_contribuyente,
																						CONST_INSCRIP_GANAN,CONST_INSCRIP_IIBB,nro_insc_iibb,
                                            const_modif_datos_afip, USU_REGISTRO, FEC_REGISTRO,MATRICULADO_CAJA_PREV,
																						CONST_INSCRIP_CAJA_PREV) 

			values(@@soc_id,@@igbj_id,@@pad_ivaConstancia,@@catfg_id,@@igbt_id,
             @@pad_ganConstancia,@@pad_ibConstancia,@@pad_ingBrutosNro,
             @@pad_domFiscalAfip, @usuario, getdate(),0,0)

		end else begin

			update Proveedores_Datos_Impositivos 
	
												set jurisdic_iibb 					= @@igbj_id,
														INSCRIPCION_AFIP				= @@pad_ivaConstancia,
														categoria_ganan 				= @@catfg_id,
														tipo_contribuyente 			= @@igbt_id,
														CONST_INSCRIP_GANAN 		= @@pad_ganConstancia,
														CONST_INSCRIP_IIBB  		= @@pad_ibConstancia,
														nro_insc_iibb 					= @@pad_ingBrutosNro,                              
														const_modif_datos_afip  = @@pad_domFiscalAfip,
														usu_modi_registro 			= @usuario,
														fec_modi_registro 			= getdate()
	
			where proveedor = @@soc_id

		end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

		if @@pad_ivaCertExcRet <> 0 begin

			if exists (select * from exclusion_retencion_proveedor where proveedor = @@soc_id	and	tipo_retencion = 5)
			begin
				update exclusion_retencion_proveedor set
																														/*
																														1	Ganancias
																														2	Ingresos Brutos
																														3	Caja Prevision
																														4	Cargas Sociales
																														5	Ret Iva 1575
																														6	Ganancias 1575
																														7	Autonomos CD
																														*/
					-- @@pad_ivaCertExcRet
					Nro_Certificado							= @@pad_ivaExcRetNro,
					Porcentaje									= @@pad_ivaExcRetPorcentaje,
					const_cert_exclusion				= @@pad_ivaCertExcRet,
					Fecha_Fin										= @@pad_ivaCertExcFechaFin
						
				where
					
								proveedor = @@soc_id
					and		tipo_retencion = 5
	
			end else begin
	
	
	/* Corregir Fechas en insert */
				insert into exclusion_retencion_proveedor ( empresa, 
																										proveedor, 
																										tipo_retencion, 
																										Nro_Certificado,    
																										Porcentaje,
																										Fecha_Inicio, 
																										Fecha_Fin, 							 
																										fecha_inicio_rela,
																										const_cert_exclusion)

																		        values( 1, 
																										@@soc_id, 
																										5, 
																										@@pad_ivaExcRetNro, 
																										@@pad_ivaExcRetPorcentaje, 
																										case
																												when @@pad_ivaCertExcFechaIni < getdate() then getdate()
																												else @@pad_ivaCertExcFechaIni
																										end,
																										case
																												when @@pad_ivaCertExcFechaFin <= getdate() then getdate()
																												else @@pad_ivaCertExcFechaFin
																										end,
																										getdate(), 
																										@@pad_ivaCertExcRet)
			end

		end

		if @@pad_ganCertExcRet <> 0 begin

			if exists (select * from exclusion_retencion_proveedor where proveedor = @@soc_id	and	tipo_retencion = 1)
			begin
				update exclusion_retencion_proveedor set
																														/*
																														1	Ganancias
																														2	Ingresos Brutos
																														3	Caja Prevision
																														4	Cargas Sociales
																														5	Ret Iva 1575
																														6	Ganancias 1575
																														7	Autonomos CD
																														*/
					-- @@pad_ganCertExcRet
					Nro_Certificado							= @@pad_ganExcRetNro,
					Porcentaje									= @@pad_ganExcRetPorcentaje,
					const_cert_exclusion				= @@pad_ganCertExcRet,
					Fecha_Fin										= @@pad_ganCertExcFechaFin
						
				where
					
								proveedor = @@soc_id
					and		tipo_retencion = 1
	
			end else begin
	
	/* Corregir Fechas en insert */
				insert into exclusion_retencion_proveedor ( empresa, 
																										proveedor, 
																										tipo_retencion, 
																										Nro_Certificado, 
																										Porcentaje, 
																										Fecha_Inicio, 
																										Fecha_Fin, 		
																										fecha_inicio_rela,
																										const_cert_exclusion)
	   																        values( 1, 
																										@@soc_id, 
																										1, 
																										@@pad_ivaExcRetNro, 
																										@@pad_ivaExcRetPorcentaje, 

																										case
																												when @@pad_ganCertExcFechaIni < getdate() then getdate()
																												else @@pad_ganCertExcFechaIni
																										end,
																										case
																												when @@pad_ganCertExcFechaFin <= getdate() then getdate()
																												else @@pad_ganCertExcFechaFin
																										end,

																										getdate(),
																										@@pad_ganCertExcRet)
	
			end

		end


		if @@pad_ibCertExcRet <> 0 begin

			if exists (select * from exclusion_retencion_proveedor where proveedor = @@soc_id	and	tipo_retencion = 2)
			begin
				update exclusion_retencion_proveedor set
																														/*
																														1	Ganancias
																														2	Ingresos Brutos
																														3	Caja Prevision
																														4	Cargas Sociales
																														5	Ret Iva 1575
																														6	Ganancias 1575
																														7	Autonomos CD
																														*/
					-- @@pad_ibCertExcRet
					Nro_Certificado							= @@pad_ibExcRetNro,
					Porcentaje									= @@pad_ibExcRetPorcentaje,
					const_cert_exclusion				= @@pad_ibCertExcRet,
					Fecha_Fin										= @@pad_ibCertExcFechaFin
						
				where
					
								proveedor = @@soc_id
					and		tipo_retencion = 2
	
			end else begin
	
	/* Corregir Fechas en insert */
				insert into exclusion_retencion_proveedor ( empresa, 
																										proveedor, 
																										tipo_retencion, 
																										Nro_Certificado,    
																										Porcentaje,
																										Fecha_Inicio, 
																										Fecha_Fin, 		
																										fecha_inicio_rela,
																										const_cert_exclusion)
																	          values(	1, 
																										@@soc_id, 
																										2, 
																										@@pad_ivaExcRetNro, 
																										@@pad_ivaExcRetPorcentaje, 

																										case
																												when @@pad_ibCertExcFechaIni < getdate() then getdate()
																												else @@pad_ibCertExcFechaIni
																										end,
																										case
																												when @@pad_ibCertExcFechaFin <= getdate() then getdate()
																												else @@pad_ibCertExcFechaFin
																										end,
																										getdate(), 
																										@@pad_ibCertExcRet)
	
			end

		end

		update Medicos set cuit = @@pad_cuil, cuit_o_cuil = 'CL' where medico = @@soc_id

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
			
---------------------------------------------------------------------------------------------------------------------

--Proveedores Datos Impositivos

-- 			@@pad_ingBrutosNro                              varchar(255),     nro_insc_iibb
--      @@pad_domFiscalAfip																								const_modif_datos_afip

-- No se actualiza
-- 			@@pad_ibJurisdiccion                            varchar(255),     

---------------------------------------------------------------------------------------------------------------------

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

