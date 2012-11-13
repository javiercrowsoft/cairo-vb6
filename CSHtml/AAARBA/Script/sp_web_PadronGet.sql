SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_PadronGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_PadronGet]
GO


create procedure sp_web_PadronGet (

	@@aabasoc_id		int,
	@@pad_id				int,
	@@bEditEx       smallint = 0  -- Indica que la interfaz de edicion corresponde
													      -- a tesoreria o contaduria, con lo cual puede ser
													      -- editada cuando el estado es distinto de 1015 y 1016
)
as

begin

	set nocount on

	if exists(select * from aaarbaweb..medicos where baja_fecha is not null and medico = @@aabasoc_id)
	begin
		select 0 as bEdit, 'El socio ha sido dado de baja. No puede ser actualizado.' as msg
		return
	end

	if IsNull(@@pad_id,0) = 0 begin

		select @@pad_id = max(pad_id) from aaarbaweb..PadronSocio where soc_id = @@aabasoc_id

		set @@pad_id = IsNull(@@pad_id,0)

	end

	declare @bFichaFinalizada tinyint
	set @bFichaFinalizada = 0

	if @@pad_id <> 0 begin

		declare @est_id 			int
		declare @est_id_sec 	int
		declare @est_id_cont 	int

		select 	@est_id 			= est_id,
						@est_id_sec		= est_id_sec,
						@est_id_cont	= est_id_cont

		from aaarbaweb..PadronSocio 
	  where pad_id = @@pad_id 

		-- Si esta anulada, o esta finalizada
		-- comienza una nueva ficha

		if 		 (@est_id = 7 and @est_id_sec = 7 and @est_id_cont = 7)
				or (@est_id = 5 and @est_id_sec = 5 and @est_id_cont = 5)
		begin

			set @bFichaFinalizada = 1

		end else begin

			if @@bEditEx = 0 begin
	
				if exists(select * 
									from aaarbaweb..PadronSocio 
								  where pad_id = @@pad_id 
										and	(
															est_id_sec  <> 1015
													or  est_id_cont <> 1016
												)
								  )
				begin
	
					if exists(select * 
										from aaarbaweb..PadronSocio 
									  where pad_id = @@pad_id 
											and	(
																est_id_sec  = 1011
														or  est_id_cont = 1011
													)
									  )
					begin
	
							select 0 as bEdit, 
										'Esta ficha ya ha sido analizada y aprobada por Secretaria o Contaduria y ' +
	                  'se encuentra pendiente de aplicar a SAG.'
											 as msg
	
					end else begin
	
						if exists(select * 
											from aaarbaweb..PadronSocio 
										  where pad_id = @@pad_id 
												and	(
																	est_id_sec  = 5
															or  est_id_cont = 5
														)
										  )
						begin
		
								select 0 as bEdit, 
											'Esta ficha ya ha sido analizada y aprobada por Secretaria o Contaduria.'
												 as msg
	
						end else begin
	
							if exists(select * 
												from aaarbaweb..PadronSocio 
											  where pad_id = @@pad_id 
													and	(
																		est_id_sec  = 1015	
																and est_id_cont = 1014
															)
											  )
							begin
			
									select 0 as bEdit, 
												'Esta ficha no puede modificarse debido a que esta pendiente de corregir por Secretaria y Contaduria.'
													 as msg
		
							end else begin
									select 0 as bEdit, 
												'Esta ficha ya ha sido analizada por Secretaria o Contaduria, '+
												'para editarla debe usar las opciones '+ 
												'"01 - Fichas con Datos de Contaduria Pendientes de Verificar por Atencion al Socio" '+ 
												'"02 - Fichas con Datos de Secretaria Pendientes de Verificar por Atencion al Socio"'
													 as msg
							end
						end
					end
					return
				end
			end
		end
	end

	if @@pad_id <> 0 and @bFichaFinalizada = 0 begin

		select p.*,

						bEdit=1,

						socc_nombre,
						estc_nombre,
						soce_nombre,
						tcon_nombre,
						tdoc_nombre,
						catf_nombre,
						catfg_nombre,
						catfib_nombre,
						igbt_nombre,
						igbj_nombre,
						colg_nombre,
						est.est_nombre,
						estcont.est_nombre as est_nombre_cont,
						estsec.est_nombre  as est_nombre_sec,
						us_c.us_nombre     as us_modifico_cont,
						us_s.us_nombre     as us_modifico_sec,
						p.creado				   as modificado,					
		
					 pf.pro_nombre as pro_nombref,
					 pp.pro_nombre as pro_nombrep,
					 pa.pa_nombre,
           pap.pa_nombre as pa_nombrep,
					 case pad_sexo
							when 1 then 'Masculino'
							when 2 then 'Femenino'
							else        ''
					 end											as pad_sexo_nombre,
					 DesCompCelular
	
		from aaarbaweb..PadronSocio p left join Provincia 										pf 			on p.pro_id_fiscal  = pf.pro_id
																	left join Provincia 										pp 			on p.pro_id_postal  = pp.pro_id
																	left join Pais      										pa 			on p.pa_id   				= pa.pa_id
	
																	left join aaarbaweb..SocioCategoria   	socc  	on p.socc_id        = socc.socc_id
	                                left join EstadoCivil         					estc  	on p.estc_id        = estc.estc_id
	                                left join aaarbaweb..SocioEspecialidad  soce  	on p.soce_id        = soce.soce_id
	                                left join aaarbaweb..TipoConexion       tcon  	on p.tcon_id        = tcon.tcon_id
	                                left join aaarbaweb..TipoDocumento      tdoc  	on p.tdoc_id        = tdoc.tdoc_id
	                                left join CategoriaFiscal     					catf  	on p.catf_id        = catf.catf_id
	                                left join CategoriaFiscalGanancias			catfg 	on p.catfg_id       = catfg.catfg_id
	                                left join CategoriaFiscalIngBrutos    	catfib	on p.catib_id       = catfib.catfib_id
	                                left join IngresosBrutosTipo          	igbt    on p.igbt_id        = igbt.igbt_id
	                                left join IngresosBrutosJurisdiccion  	igbj    on p.igbj_id        = igbj.igbj_id
	                                left join aaarbaweb..Colegio            colg    on p.colg_id        = colg.colg_id
	                                left join Estado                      	est     on p.est_id         = est.est_id
																	left join Pais                          pap     on p.pa_id_postal   = pap.pa_id

	                                left join Estado                      	estcont    on p.est_id_cont = estcont.est_id
	                                left join Estado                      	estsec     on p.est_id_sec  = estsec.est_id

																	left join Usuario                       us_c      on p.us_id_contaduria = us_c.us_id
																	left join Usuario                       us_s      on p.us_id_secretaria = us_s.us_id
																	left join aaarbaweb..CompCelular 				cc        on p.CodCompCelular = cc.CodCompCelular
	
		where pad_id = @@pad_id

	end else begin

		declare @pro_idf int
		declare @pro_idp int
		declare @pa_id   int

		select @pa_id =
						case 
								when nacional in('BOLIVIANA','BOLIVIANO')
																				then 30
								when nacional in('ARG. NATURA.','ARGENTINA NATURALIZA','ARGENTINA NAT:',
                     'ARG. NAT.','ARG.OPCION','ARGENTIANA','Agentina','ARGENTINO NATURALIZA',
										 'ARGENTINA NATURAL.','ARG','ARGENTINA','ARGENTINO NATURAL.','ARG. NAT',
                     'Argentino','ARGENTINA NAT.','ARG.') 
																				then 12
								when nacional in('PERUANA','PERUANA NAT.','PERUANO','PERUANA NAC. ARG.')
																				then 174
								when nacional in('URUGUAYO')					
																				then 225
								when nacional in('ECUATORIANO','ECUATORIANA')
																				then 66
								when nacional in('RUSA')							
																				then 184
								when nacional in('DOMINICANO')				
																				then 65
								when nacional in('COLOM','COLOMBIA','COLOMBIANO','COLOMBIANA')
																				then 51
								when nacional in('PARAGUAYA')				
																				then 173
								when nacional in('ALEMANA')					
																				then 4
								when nacional in('ESPA¥OLA','ESPAÑOLA')
																				then 73
								when nacional in('BRASILEÑA')				
																				then 33
								when nacional in('VENEZOLANO')				
																				then 228
								else										0
						end
		from aaarbaweb..Medicos
		where medico = @@aabasoc_id

		select @pro_idp =
						case provin
							when 'ME'  then 24
							when 'LP'  then 12 
							when 'CR'  then 10
							when 'MI'  then 9
							when 'NE'  then 8
							when 'CF'  then 31
							when 'BA'  then 3
							when 'RN'  then 26
							when 'CO'  then 21
							when 'SF'  then 32
							when 'CH'  then 34
							when 'ER'	 then 11
							when 'JU'	 then 13
							when 'SA'	 then 14
							when 'FO'	 then 15
							when 'CHA' then 16
							when 'CA'	 then 17
							when 'TU'	 then 18
							when 'SE'	 then 19
							when 'RJ'	 then 20
							when 'SJ'	 then 22
							when 'SL'	 then 23
							when 'SC'	 then 29
							when 'TF'	 then 30

							when 'B'   then 3
							when 'C'   then 31
							when 'S'   then 32

						end
		from aaarbaweb..medi_direc md
		where 	md.medico = @@aabasoc_id
        and	md.postal_marca <> 0


		select @pro_idf =
						case provincia

								--Codigo      Codi Descripcion          percep_ib_marca gran_contri_no_percep 
								----------- ---- -------------------- --------------- --------------------- 
								when '00'  			 --CF   Capital Federal      1               0
								then  31         --Cidudad de Buenos Aires

								when '01'        --BA   Buenos Aires         1               0
								then   3         --Buenos Aires

								when '03'        --CO   Cordoba              NULL            NULL
								then  21         --Cordoba

								when '07'        --ME   Mendoza              NULL            NULL
								then  24         --Mendoza

								when '14'        --TU   Tucuman              NULL            NULL
								then  18         --Tucuman

								when '09'        --SA   Salta                NULL            NULL
								then  14         --Salta

								when '12'        --SF   Santa Fe             NULL            NULL
								then  32         --Santa Fe

								when '21'        --LP   La Pampa             NULL            NULL
								then  12         --La Pampa

								when '04'        --CR   Corrientes           NULL            NULL
								then  10         --Corrientes

								when '05'        --ER   Entre Rios           NULL            NULL
								then  11         --Entre Rios

								when '18'        --FO   Formosa              0               0
								then  15         --Formosa

								when '24'        --TF   Tierra del Fuego     0               0
								then  30         --Tierra del Fuego

								when '19'        --MI   Misiones             0               0
								then   9         --Misiones

								when '06'        --JU   Jujuy                0               0
								then  13         --Jujuy

								when '02'        --CA   Catamarca            0               0
								then  17         --Catamarca

								when '11'        --SL   San Luis             0               0
								then  23         --San Luis

								when '13'        --SE   Santiago del Estero  0               0
								then  19         --Santiago del Estero

								when '10'        --SJ   San Juan             0               0
								then  22         --San Juan

								when '23'        --SC   Santa Cruz           0               0
								then  29         --Santa Cruz

								when '17'        --CH   Chubut               0               0
								then  34         --Chubut

								when '22'        --RN   Rio Negro            0               0
								then  26         --Rio Negro

								when '20'        --NE   Neuquen              0               0
								then   8         --Neuquen

								when '16'        --CHA  Chaco                0               0
								then  16         --Chaco

								when '08'				 --LR		La Rioja	
								then  20         --La Rioja

								else null        --EXT  EXTRANJERA           0               0


						end

		from aaarbaweb..proveedores p 	
		where p.proveedor = @@aabasoc_id


		declare @pad_especialidad                              varchar(255)
		declare @pad_certFAAAR                                 tinyint
		declare @pad_fechaCertFAAAR                            datetime
		declare @pad_reCertFAAAR                               tinyint
		declare @pad_fechaReCertFAAAR                          datetime
		declare @pad_examenFAAAR                               tinyint
		declare @pad_fechaExamenFAAAR                          datetime
		declare @pad_socHonorario                              tinyint
		declare @pad_fechaSocHonorario                         datetime
		declare @pad_certMatNac                                tinyint
		declare @pad_diploma25																 tinyint
		declare @pad_medalla50                              tinyint
		declare @tcon_id                                       int
		declare @pad_agenda                                    varchar(255)
		declare @pad_palm                                      varchar(255)
		declare @pad_certMatProv                               tinyint
		declare @colg_id                                       int
		declare @pad_FotocopiaDoc                           	 tinyint
		declare @pad_descrip                                   varchar(255)
		declare @pad_telParticular                             varchar(255)
		declare @pad_cuotaSocial                               tinyint
		declare @pad_fechaEgreso                             	 datetime

		declare @pad_ibJurisdiccion                            varchar(255)


		declare @modificado_cont							datetime
		declare @modificado_sec								datetime
		declare @modificado_sag_cont					datetime
		declare @modificado_sag_sec						datetime		

		if @@pad_id <> 0 begin

			declare @pad_id_min_ver int
			declare @pad_numero_aux int

			--declare @CodCompCelular int

			select 

						@pad_numero_aux         = pad_numero,

						@pad_especialidad 			= pad_especialidad,
						@pad_certFAAAR    			= pad_certFAAAR,
						@pad_fechaCertFAAAR			= pad_fechaCertFAAAR,
						@pad_reCertFAAAR   			= pad_reCertFAAAR,
						@pad_fechaReCertFAAAR		= pad_fechaReCertFAAAR,
						@pad_examenFAAAR     		= pad_examenFAAAR,
						@pad_fechaExamenFAAAR		= pad_fechaExamenFAAAR,
						@pad_socHonorario    		= pad_socHonorario,
						@pad_fechaSocHonorario	= pad_fechaSocHonorario,
						@pad_certMatNac       	= pad_certMatNac,
						@pad_diploma25					= pad_diploma25,
						@pad_medalla50        	= pad_medalla50,
						@tcon_id              	= tcon_id,
						@pad_agenda           	= pad_agenda,
						@pad_palm             	= pad_palm,
						@pad_certMatProv      	= pad_certMatProv,
						@colg_id              	= colg_id,
						@pad_FotocopiaDoc     	= pad_FotocopiaDoc,
						@pad_descrip          	= pad_descrip,
						@pad_telParticular    	= pad_telParticular,
						@pad_cuotaSocial      	= pad_cuotaSocial,
						@pad_fechaEgreso      	= pad_fechaEgreso,

						@pad_ibJurisdiccion			= pad_ibJurisdiccion,

						@modificado_sag_cont		= modificado_sag_cont,
						@modificado_sag_sec			= modificado_sag_sec--,

-- TODO:
-- Cuando ya este en sag hay que comentar esto
-- y traerlo desde sag
--						@CodCompCelular         = CodCompCelular


			from aaarbaweb..padronSocio 
			where pad_id = @@pad_id

			select @pad_id_min_ver = min(pad_id) from aaarbaweb..padronSocio where pad_numero = @pad_numero_aux

			select

						@modificado_cont				= creado,
						@modificado_sec					= creado

			from aaarbaweb..padronSocio 
			where pad_id = @pad_id_min_ver


-- TODO:
-- Comentar cuando el campo exista en sag
--			declare @DesCompCelular varchar(255)
--			select @DesCompCelular = DesCompCelular from aaarbaweb..CompCelular where CodCompCelular = @CodCompCelular

		end 

------------------------------------------------------------------------------------

		declare @pad_ivaCertExcRet      	tinyint
		declare @pad_ivaExcRetNro       	varchar(255)
		declare @pad_ivaExcRetPorcentaje  decimal
		declare @pad_ivaCertExcFechaFin		datetime
		declare @pad_ivaCertExcFechaIni		datetime


		select
					@pad_ivaCertExcRet 				= const_cert_exclusion,
					@pad_ivaExcRetNro  				= Nro_Certificado,
					@pad_ivaExcRetPorcentaje	= Porcentaje,
					@pad_ivaCertExcFechaFin		= Fecha_Fin,
					@pad_ivaCertExcFechaIni		= Fecha_Inicio

		     from aaarbaweb..exclusion_retencion_proveedor
		where
							
										proveedor = @@aabasoc_id
							and		tipo_retencion = 5
							and   Fecha_Fin = (select max(Fecha_Fin) from aaarbaweb..exclusion_retencion_proveedor
																 where proveedor = @@aabasoc_id and tipo_retencion = 5)

------------------------------------------------------------------------------------

		declare @pad_ganCertExcRet        tinyint
		declare @pad_ganExcRetNro         varchar(255)
		declare @pad_ganExcRetPorcentaje  decimal
		declare @pad_ganCertExcFechaFin		datetime
		declare @pad_ganCertExcFechaIni		datetime

		select
					@pad_ganCertExcRet					= const_cert_exclusion,
					@pad_ganExcRetNro						= Nro_Certificado,
					@pad_ganExcRetPorcentaje		= Porcentaje,
					@pad_ganCertExcFechaFin			=	Fecha_Fin,
					@pad_ganCertExcFechaIni			= Fecha_Inicio

		from aaarbaweb..exclusion_retencion_proveedor
		where
							
										proveedor = @@aabasoc_id
							and		tipo_retencion = 1
							and   Fecha_Fin = (select max(Fecha_Fin) from aaarbaweb..exclusion_retencion_proveedor
																 where proveedor = @@aabasoc_id and tipo_retencion = 1)

------------------------------------------------------------------------------------

		declare @pad_ibCertExcRet         tinyint
		declare @pad_ibExcRetNro          varchar(255)
		declare @pad_ibExcRetPorcentaje   decimal
		declare @pad_ibCertExcFechaFin		datetime
		declare @pad_ibCertExcFechaIni		datetime

		select
					@pad_ibCertExcRet						= const_cert_exclusion,
					@pad_ibExcRetNro						= Nro_Certificado,
					@pad_ibExcRetPorcentaje			= Porcentaje,
					@pad_ibCertExcFechaFin			= Fecha_Fin,
					@pad_ibCertExcFechaIni			= Fecha_Inicio

		from aaarbaweb..exclusion_retencion_proveedor
		where
							
										proveedor = @@aabasoc_id
							and		tipo_retencion = 2
							and   Fecha_Fin = (select max(Fecha_Fin) from aaarbaweb..exclusion_retencion_proveedor
																 where proveedor = @@aabasoc_id and tipo_retencion = 2)

------------------------------------------------------------------------------------

		select 
					  1 as bEdit,

						aabasoc_apellido + ', ' 
            + aabasoc_nombre 						as pad_apellidoNombre,
						case civil_esta          		
									when 1 then 1
									when 2 then 2
									when 3 then 4
									when 4 then 3
									when 5 then 8
									when 6 then 5
									when 7 then 6
						end													as estc_id,
						(select estc_nombre from EstadoCivil where (estc_id = 1 and civil_esta = 1)
																										or (estc_id = 2 and civil_esta = 2)
																										or (estc_id = 3 and civil_esta = 4)
																										or (estc_id = 4 and civil_esta = 3)
																										or (estc_id = 5 and civil_esta = 8)
																										or (estc_id = 6 and civil_esta = 5)
																										or (estc_id = 7 and civil_esta = 6)
						)														as estc_nombre,

            naci_fecha                  as pad_fechanac,
            docu_nume                   as pad_nrodoc,
            socio_cate                  as socc_id,    
						socc_nombre,
						cambio_fecha_cate_1         as cat_fecha1,
						cambio_fecha_cate_2         as cat_fecha2,
						cambio_fecha_cate_4         as cat_fecha4,
						anio_cursa                  as pad_anioCurso,
						--diplo_25_a									as pad_diploma25,
						p.cuit                      as pad_cuit,
            e_mail_direc                as pad_email,
						radio_mensa                 as pad_radio,
						tele_nextel                 as pad_nextel,
						tele_profesional            as pad_telProfesional,
						movil                       as pad_telCelular,
					  matri_nacio                 as pad_matNac,
            matri_provin                as pad_matProv,
						--fecha_egre                  as pad_fechaEgreso,
						otorga_por									as pad_otorgadoPor,
						case docu_tipo
								when 'LE' 		then 1
								when 'DNI'    then 3
								when 'CE'     then 7
								when 'CI'     then 5
								when 'DD'     then 8
						end			                    as tdoc_id,
						(select tdoc_nombre from aaarbaweb..TipoDocumento where (tdoc_id = 1 and docu_tipo = 'LE')
																																or (tdoc_id = 3 and docu_tipo = 'DNI')
																																or (tdoc_id = 7 and docu_tipo = 'CE')
																																or (tdoc_id = 5 and docu_tipo = 'CI')
																																or (tdoc_id = 8 and docu_tipo = 'DD')
						)			                      as tdoc_nombre,
						--docu_fotocopia              as pad_fotocopiaDoc,
						@pa_id                      as pa_id,
						pa.pa_nombre,                   
						md.domi  										as pad_callep,
						codi_postal									as pad_codPostalp,
						loca												as pad_localidadp,
						@pro_idp                    as pro_id_postal,
						prop.pro_nombre             as pro_nombrep,
						tele												as pad_telPostal,

						Domicilio										as pad_callef,
						Localidad										as pad_localidadf,
						CodigoPostal								as pad_codPostalf,
						@pro_idf                    as pro_id_fiscal,

						prof.pro_nombre             as pro_nombref,
						soce_id,
						soce_nombre,

						case p.iva
																					-- 1           RI              Inscripto
												when 1  then 1    --NO USAR INSCRIPTO 21

																					-- 3           RNI             No Inscripto
												when 2  then 3    --NO INSCRIPTO

																					-- 5           EXT             Extranjero
												when 4  then 5    --EXPORTACION

																					-- 1           RI              Inscripto
												when 6  then 1    --NO USAR INSCRIPTO 27

																					-- 1           RI              Inscripto
												when 7  then 1    --RESPONSABLE INSCRIPTO

																					-- 2           NA              No Alcanzado
												when 8  then 12   --NO ALCANZADO

																					-- 2           EX              Exento
												when 3  then 2    --EXENTO

																					-- 6           MON             Monotributo
												when 5  then 6    --MONOTRIBUTISTA

																					-- 4           CF              Consumidor Final
												when 9  then 4    --CONSUMIDOR FINAL

																					-- 10          NC              No Categorizado
												when 10 then 10   --NO CATEGORIZADO

																					-- 11          RIM             Inscripto M
												when 11 then 11   --RESPONSABLE INSCRIPTO ...

																					-- 4           CF              Consumidor Final
												else 4
						end                         as catf_id,
						catf_nombre,

						isnull(categoria_ganan,8)   as catfg_id,
						catfg_nombre,
						isnull(tipo_contribuyente,3)as igbt_id,
						igbt_nombre,
						m.sexo                      as pad_sexo,
						IsNull(igbj_id,4)						as igbj_id,
						igbj_nombre,
						catfib_id										as catib_id,
						catfib_nombre               as catfib_nombre,
						nro_caja_prev								as pad_cajaNro,

						case md.pais 
									when 34	then 73 	--España
									when 39	then 115 	--Italia 
									when 54	then 12 	--Argentina
						end pa_id_postal,

						case md.pais 
									when 34	then 'España'
									when 39	then 'Italia '
									when 54	then 'Argentina'
						end pa_nombrep,
						md.tele,
						AABAsoc_AfipMal,

						m.Fax										as pad_fax,

						@pad_especialidad 			as pad_especialidad,
						@pad_certFAAAR    			as pad_certFAAAR,
						@pad_fechaCertFAAAR			as pad_fechaCertFAAAR,
						@pad_reCertFAAAR   			as pad_reCertFAAAR,
						@pad_fechaReCertFAAAR		as pad_fechaReCertFAAAR,
						@pad_examenFAAAR     		as pad_examenFAAAR,
						@pad_fechaExamenFAAAR		as pad_fechaExamenFAAAR,
						@pad_socHonorario    		as pad_socHonorario,
						@pad_fechaSocHonorario	as pad_fechaSocHonorario,
						@pad_certMatNac       	as pad_certMatNac,
						@pad_diploma25					as pad_diploma25,
						@pad_medalla50        	as pad_medalla50,
						@tcon_id              	as tcon_id,
						@pad_agenda           	as pad_agenda,
						@pad_palm             	as pad_palm,
						@pad_certMatProv      	as pad_certMatProv,
						@colg_id              	as colg_id,
						@pad_FotocopiaDoc     	as pad_FotocopiaDoc,
						@pad_descrip          	as pad_descrip,
						@pad_telParticular    	as pad_telParticular,
						@pad_cuotaSocial      	as pad_cuotaSocial,
						@pad_fechaEgreso      	as pad_fechaEgreso,

--						const_modif_datos_afip  as pad_domFiscalAfip,
						INSCRIPCION_AFIP				as pad_ivaConstancia,
						CONST_INSCRIP_GANAN 		as pad_ganConstancia,
						CONST_INSCRIP_IIBB  		as pad_ibConstancia,
						nro_insc_iibb 					as pad_ingBrutosNro,

						@pad_ibJurisdiccion			as pad_ibJurisdiccion,

						@pad_ivaCertExcRet					as pad_ivaCertExcRet,
						@pad_ivaExcRetNro						as pad_ivaExcRetNro,
						@pad_ivaExcRetPorcentaje		as pad_ivaExcRetPorcentaje,

						@pad_ganCertExcRet					as pad_ganCertExcRet,
						@pad_ganExcRetNro						as pad_ganExcRetNro,
						@pad_ganExcRetPorcentaje		as pad_ganExcRetPorcentaje,

						@pad_ibCertExcRet						as pad_ibCertExcRet,
						@pad_ibExcRetNro						as pad_ibExcRetNro,
						@pad_ibExcRetPorcentaje			as pad_ibExcRetPorcentaje,

						CONST_INSCRIP_CAJA_PREV			as pad_cajaConstancia,
						const_baja_caja_prev				as pad_cajaConstBaja,
						fec_ing_baja_caja_prev			as pad_fechaConstBaja,

						@pad_ibCertExcFechaFin			as pad_ibCertExcFechaFin,
						@pad_ibCertExcFechaIni			as pad_ibCertExcFechaIni,
	
						@pad_ganCertExcFechaFin			as pad_ganCertExcFechaFin,
						@pad_ganCertExcFechaIni			as pad_ganCertExcFechaIni,
	
						@pad_ivaCertExcFechaFin		  as pad_ivaCertExcFechaFin,
						@pad_ivaCertExcFechaIni		  as pad_ivaCertExcFechaIni,

						@modificado_cont				as modificado_cont,
						@modificado_sec					as modificado_sec,
						@modificado_sag_cont		as modificado_sag_cont,
						@modificado_sag_sec			as modificado_sag_sec,

						soc.aabasoc_id          as soc_id,
						0                       as pad_numero,
						getdate()               as pad_fecha,
						case m.sexo
							when 1 then 'Masculino'
							when 2 then 'Femenino'
							else        ''
						end											as pad_sexo_nombre,
						case p.iva
							when 	9 then p.cuit                  
							else				 ''
						end											as pad_cuil,

-- TODO: Traer el campo desde SAG cuando exista en la tabla Medicos
--       Tamara le paso el requerimiento a Gustavo
--
						codcompcelular,

						0 as pad_cbuInformada,
						0 as pad_SecNoModif,
						0 as pad_ContNoModif


		from
					aaba_socio soc left join aaarbaweb..medicos m 			on soc.aabasoc_id = m.medico
												 left join aaarbaweb..proveedores p 	on soc.aabasoc_id = p.proveedor
                         left join aaarbaweb..medi_direc md   on 			m.medico  = md.medico
                                                                 and	md.postal_marca <> 0
												 left join provincia prof             on @pro_idf = prof.pro_id
												 left join provincia prop             on @pro_idp = prop.pro_id
                         left join pais pa                    on @pa_id   = pa.pa_id

												 left join aaarbaweb..SocioEspecialidad soce
																															on m.especiali = soce.soce_id

												 left join aaarbaweb..Proveedores_Datos_Impositivos provi
																															on p.proveedor = provi.proveedor
												 left join IngresosBrutosTipo igbt    on provi.tipo_contribuyente = igbt.igbt_id
												 left join CategoriaFiscalGanancias catfg
                                                              on provi.categoria_ganan    = catfg.catfg_id

												 left join IngresosBrutosJurisdiccion igbj 
																															on jurisdic_iibb = igbj.igbj_id

												 left join CategoriaFiscalIngBrutos catfib
																															on p.ingresos_brutos = catfib.catfib_id
												 left join aaarbaweb..sociocategoria socc on socio_cate = socc.socc_id

												 left join CategoriaFiscal catf       on     (p.iva = 1  and catf_id = 1)
																																	or (p.iva = 2  and catf_id = 3)
																																	or (p.iva = 4  and catf_id = 5)
																																	or (p.iva = 6  and catf_id = 1)
																																	or (p.iva = 7  and catf_id = 1)
																																	or (p.iva = 8  and catf_id = 12)
																																	or (p.iva = 3  and catf_id = 2)
																																	or (p.iva = 5  and catf_id = 6)
																																	or (p.iva = 9  and catf_id = 4)
																																	or (p.iva = 10 and catf_id = 10)
																																	or (p.iva = 11 and catf_id = 11)

		where 
					aabasoc_id = @@aabasoc_id

	end
end






GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

