SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_PadronUpdateCont]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_PadronUpdateCont]
GO

create procedure sp_web_PadronUpdateCont (

      @@pad_id                                        int,
      @@soc_id                                        int,
      @@pad_fecha                                     datetime,
      @@pad_callef                                    varchar(255),
      @@pad_localidadf                                varchar(255),
      @@pad_codPostalf                                varchar(255),
      @@pro_id_fiscal                                 int,
      @@pad_cuit                                      varchar(255),
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

      @@pad_ivaCertExcFechaFin                        datetime,
      @@pad_ganCertExcFechaFin                        datetime,
      @@pad_ibCertExcFechaFin                          datetime,

      @@pad_ivaCertExcFechaIni                        datetime,
      @@pad_ganCertExcFechaIni                        datetime,
      @@pad_ibCertExcFechaIni                          datetime
)
as

begin

  set nocount on

  declare @pad_id       int
  declare @pad_numero   int
  declare @pad_id_padre int

  exec sp_dbgetnewid 'aaarbaweb..PadronSocio','pad_id',@pad_id out, 0

  if IsNull(@@pad_id,0) = 0 set @@pad_id = null

  --//////////////////////////////////////////////////////////////////////////////////////////////////
  select @pad_id_padre = max(pad_id) from aaarbaweb..PadronSocio where soc_id = @@soc_id

  if IsNull(@pad_id_padre,0) = 0 set @pad_id_padre = null

  if @pad_id_padre is null begin

    -- Si no tiene padre o sea es la primera ficha, le doy el numero
    --
    exec sp_dbgetnewid 'aaarbaweb..PadronSocio','pad_numero',@pad_numero out, 0    

  end else begin

    -- Obtengo el numero desde el padre
    --
    select @pad_numero = pad_numero from aaarbaweb..PadronSocio where pad_id = @pad_id_padre

  end
  --//////////////////////////////////////////////////////////////////////////////////////////////////

  insert into aaarbaweb..PadronSocio (
                            pad_id,
                            pad_id_padre,
                            pad_numero,
                            soc_id,
                            pad_fecha,
                            pad_apellidoNombre,
                            pad_sexo,
                            pad_fechanac,
                            pa_id,
                            estc_id,
                            pad_callef,
                            pad_localidadf,
                            pad_codPostalf,
                            pro_id_fiscal,
                            pad_callep,
                            pad_localidadp,
                            pad_codPostalp,
                            pro_id_postal,
                            pad_telParticular,
                            pad_telProfesional,
                            pad_telCelular,
                            pad_radio,
                            pad_nextel,
                            pad_email,
                            soce_id,
                            pad_especialidad,
                            pad_anioCurso,
                            pad_otorgadoPor,
                            pad_certFAAAR,
                            pad_fechaCertFAAAR,
                            pad_reCertFAAAR,
                            pad_fechaReCertFAAAR,
                            pad_examenFAAAR,
                            pad_fechaExamenFAAAR,
                            socc_id,
                            pad_socHonorario,
                            pad_fechaSocHonorario,
                            pad_matNac,
                            pad_certMatNac,
                            pad_fechaEgreso,
                            pad_diploma25,
                            pad_medalla50,
                            tcon_id,
                            pad_agenda,
                            pad_palm,
                            tdoc_id,
                            pad_nrodoc,
                            pad_cuit,
                            pad_cuil,
                            catf_id,
                            pad_ivaConstancia,
                            pad_ivaCertExcRet,
                            pad_ivaExcRetNro,
                            pad_ivaExcRetPorcentaje,
                            catfg_id,
                            pad_ganConstancia,
                            pad_ganCertExcRet,
                            pad_ganExcRetNro,
                            pad_ganExcRetPorcentaje,
                            catib_id,
                            pad_ingBrutosNro,
                            pad_ibConstancia,
                            igbt_id,
                            igbj_id,
                            pad_ibJurisdiccion,
                            pad_ibCertExcRet,
                            pad_ibExcRetNro,
                            pad_ibExcRetPorcentaje,
                            pad_cajaConstancia,
                            pad_cajaNro,
                            pad_matProv,
                            pad_certMatProv,
                            pad_cajaConstBaja,
                            pad_fechaConstBaja,
                            colg_id,
                            pad_FotocopiaDoc,
                            pad_cuotaSocial,
                            pad_descrip,
                            pad_domFiscalAfip,
                            est_id,
                            pad_okContaduria,
                            pad_okSecretaria,
                            us_id_carga,
                            us_id_contaduria,
                            us_id_secretaria,
                            pad_fax,
                            pa_id_postal,
                            pad_telPostal,
                            pad_descripCont,
                            est_id_cont,
                            est_id_sec,
                            modificado_sec,
                            modificado_cont,

                            pad_ivaCertExcFechaFin,
                            pad_ganCertExcFechaFin,
                            pad_ibCertExcFechaFin,

                            pad_ivaCertExcFechaIni,
                            pad_ganCertExcFechaIni,
                            pad_ibCertExcFechaIni

  )
  select 
                            @pad_id,
                            @pad_id_padre,
                            @pad_numero,
                            @@soc_id,
                            @@pad_fecha,
                            pad_apellidoNombre,
                            pad_sexo,
                            pad_fechanac,
                            pa_id,
                            estc_id,
                            @@pad_callef,
                            @@pad_localidadf,
                            @@pad_codPostalf,
                            @@pro_id_fiscal,
                            pad_callep,
                            pad_localidadp,
                            pad_codPostalp,
                            pro_id_postal,
                            pad_telParticular,
                            pad_telProfesional,
                            pad_telCelular,
                            pad_radio,
                            pad_nextel,
                            pad_email,
                            soce_id,
                            pad_especialidad,
                            pad_anioCurso,
                            pad_otorgadoPor,
                            pad_certFAAAR,
                            pad_fechaCertFAAAR,
                            pad_reCertFAAAR,
                            pad_fechaReCertFAAAR,
                            pad_examenFAAAR,
                            pad_fechaExamenFAAAR,
                            socc_id,
                            pad_socHonorario,
                            pad_fechaSocHonorario,
                            pad_matNac,
                            pad_certMatNac,
                            pad_fechaEgreso,
                            pad_diploma25,
                            pad_medalla50,
                            tcon_id,
                            pad_agenda,
                            pad_palm,
                            tdoc_id,
                            pad_nrodoc,
                            @@pad_cuit,
                            pad_cuil,
                            @@catf_id,
                            @@pad_ivaConstancia,
                            @@pad_ivaCertExcRet,
                            @@pad_ivaExcRetNro,
                            @@pad_ivaExcRetPorcentaje,
                            @@catfg_id,
                            @@pad_ganConstancia,
                            @@pad_ganCertExcRet,
                            @@pad_ganExcRetNro,
                            @@pad_ganExcRetPorcentaje,
                            @@catib_id,
                            @@pad_ingBrutosNro,
                            @@pad_ibConstancia,
                            @@igbt_id,
                            @@igbj_id,
                            @@pad_ibJurisdiccion,
                            @@pad_ibCertExcRet,
                            @@pad_ibExcRetNro,
                            @@pad_ibExcRetPorcentaje,
                            pad_cajaConstancia,
                            pad_cajaNro,
                            pad_matProv,
                            pad_certMatProv,
                            pad_cajaConstBaja,
                            pad_fechaConstBaja,
                            colg_id,
                            pad_FotocopiaDoc,
                            pad_cuotaSocial,
                            @@pad_descrip,
                            @@pad_domFiscalAfip,
                            est_id,
                            @@pad_okContaduria,
                            pad_okSecretaria,
                            @@us_id_carga,
                            @@us_id_carga,
                            us_id_secretaria,
                            pad_fax,
                            pa_id_postal,
                            pad_telPostal,
                            @@pad_descripCont,
                            @@est_id_cont,
                            est_id_sec,
                            modificado_sec,
                            getdate(),

                            @@pad_ivaCertExcFechaFin,
                            @@pad_ganCertExcFechaFin,
                            @@pad_ibCertExcFechaFin,

                            @@pad_ivaCertExcFechaIni,
                            @@pad_ganCertExcFechaIni,
                            @@pad_ibCertExcFechaIni


  from aaarbaweb..PadronSocio where pad_id = @@pad_id

  select @pad_id

end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

