if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_PadronUpdate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_PadronUpdate]

/*

sp_web_PadronUpdate 

*/

go
create procedure sp_web_PadronUpdate (

      @@pad_id                                        int,
      @@soc_id                                        int,
      @@pad_fecha                                     datetime,
      @@pad_apellidoNombre                            varchar(255),
      @@pad_sexo                                      tinyint,
      @@pad_fechanac                                  datetime,
      @@pa_id                                         int,
      @@estc_id                                       int,
      @@pad_callef                                    varchar(255),
      @@pad_localidadf                                varchar(255),
      @@pad_codPostalf                                varchar(255),
      @@pro_id_fiscal                                 int,
      @@pad_callep                                    varchar(255),
      @@pad_localidadp                                varchar(255),
      @@pad_codPostalp                                varchar(255),
      @@pro_id_postal                                 int,
      @@pad_telParticular                             varchar(255),
      @@pad_telProfesional                            varchar(255),
      @@pad_telCelular                                varchar(255),
      @@pad_radio                                     varchar(255),
      @@pad_nextel                                    varchar(255),
      @@pad_email                                     varchar(255),
      @@CodCompCelular                                int,
      @@soce_id                                       int,
      @@pad_especialidad                              varchar(255),
      @@pad_anioCurso                                 smallint,
      @@pad_otorgadoPor                               varchar(255),
      @@pad_certFAAAR                                 tinyint,
      @@pad_fechaCertFAAAR                            datetime,
      @@pad_reCertFAAAR                               tinyint,
      @@pad_fechaReCertFAAAR                          datetime,
      @@pad_examenFAAAR                               tinyint,
      @@pad_fechaExamenFAAAR                          datetime,
      @@socc_id                                       int,
      @@pad_socHonorario                              tinyint,
      @@pad_fechaSocHonorario                         datetime,
      @@pad_matNac                                    varchar(255),
      @@pad_certMatNac                                tinyint,
      @@pad_fechaEgreso                               datetime,
      @@pad_diploma25                                 tinyint,
      @@pad_medalla50                                 tinyint,
      @@tcon_id                                       int,
      @@pad_agenda                                    varchar(255),
      @@pad_palm                                      varchar(255),
      @@tdoc_id                                       int,
      @@pad_nrodoc                                    varchar(255),
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
      @@pad_cajaConstancia                            tinyint,
      @@pad_cajaNro                                   varchar(255),
      @@pad_matProv                                   varchar(255),
      @@pad_certMatProv                               tinyint,
      @@pad_cajaConstBaja                             tinyint,
      @@pad_fechaConstBaja                            datetime,
      @@colg_id                                       int,
      @@pad_FotocopiaDoc                               tinyint,
      @@pad_cuotaSocial                               tinyint,
      @@pad_descrip                                   varchar(255),
      @@pad_domFiscalAfip                             tinyint,
      @@est_id                                        int,
      @@pad_okContaduria                              tinyint,
      @@pad_okSecretaria                              tinyint,
      @@us_id_carga                                   int,
      @@us_id_contaduria                              int,
      @@us_id_secretaria                              int,
      @@pad_fax                                       varchar(50),
      @@pa_id_postal                                  int,
      @@pad_telPostal                                 varchar(50),

      @@pad_ivaCertExcFechaFin                        datetime,
      @@pad_ganCertExcFechaFin                        datetime,
      @@pad_ibCertExcFechaFin                          datetime,

      @@pad_ivaCertExcFechaIni                        datetime,
      @@pad_ganCertExcFechaIni                        datetime,
      @@pad_ibCertExcFechaIni                          datetime,

      @@pad_cbuInformada                              tinyint,
      @@pad_SecNoModif                                 tinyint,
      @@pad_ContNoModif                                tinyint

)
as

begin

  set nocount on

  if @@pad_fechanac < '19000102' or @@pad_fechanac is null begin

    select @@pad_fechanac = naci_fecha from aaarbaweb..medicos where medico = @@soc_id

    if @@pad_fechanac is null set @@pad_fechanac = '19000101' 
  end

  declare @pad_id       int
  declare @pad_numero   int

  exec sp_dbgetnewid 'aaarbaweb..PadronSocio','pad_id',@pad_id out, 0

  if IsNull(@@pad_id,0) = 0 set @@pad_id = null

  if @@pad_id is null begin

    select @@pad_id = max(pad_id) 
    from aaarbaweb..PadronSocio 
    where soc_id = @@soc_id
      and not 
          (
              (est_id = 5 and est_id_cont = 5 and est_id_sec = 5)
          or  (est_id = 7 and est_id_cont = 7 and est_id_sec = 7)
          )

    if IsNull(@@pad_id,0) = 0 set @@pad_id = null

  end

  if @@pad_id is null begin

    -- Si no tiene padre o sea es la primera ficha, le doy el numero
    --
    exec sp_dbgetnewid 'aaarbaweb..PadronSocio','pad_numero',@pad_numero out, 0    

  end else begin

    -- Obtengo el numero desde el padre
    --
    select @pad_numero = pad_numero from aaarbaweb..PadronSocio where pad_id = @@pad_id

  end

  if   @@pad_SecNoModif <> 0 and @@pad_ContNoModif <> 0 begin
    set @@est_id =5
  end else
    set @@est_id =isnull(@@est_id,1)

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
                            CodCompCelular,
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

                            pad_ivaCertExcFechaFin,
                            pad_ganCertExcFechaFin,
                            pad_ibCertExcFechaFin,

                            pad_ivaCertExcFechaIni,
                            pad_ganCertExcFechaIni,
                            pad_ibCertExcFechaIni,

                            pad_cbuInformada,
                            pad_SecNoModif,
                            pad_ContNoModif


  )
  values
  (
                            @pad_id,
                            @@pad_id,
                            @pad_numero,
                            @@soc_id,
                            @@pad_fecha,
                            @@pad_apellidoNombre,
                            @@pad_sexo,
                            @@pad_fechanac,
                            @@pa_id,
                            @@estc_id,
                            @@pad_callef,
                            @@pad_localidadf,
                            @@pad_codPostalf,
                            @@pro_id_fiscal,
                            @@pad_callep,
                            @@pad_localidadp,
                            @@pad_codPostalp,
                            @@pro_id_postal,
                            @@pad_telParticular,
                            @@pad_telProfesional,
                            @@pad_telCelular,
                            @@pad_radio,
                            @@pad_nextel,
                            @@pad_email,
                            @@CodCompCelular,
                            @@soce_id,
                            @@pad_especialidad,
                            @@pad_anioCurso,
                            @@pad_otorgadoPor,
                            @@pad_certFAAAR,
                            @@pad_fechaCertFAAAR,
                            @@pad_reCertFAAAR,
                            @@pad_fechaReCertFAAAR,
                            @@pad_examenFAAAR,
                            @@pad_fechaExamenFAAAR,
                            @@socc_id,
                            @@pad_socHonorario,
                            @@pad_fechaSocHonorario,
                            @@pad_matNac,
                            @@pad_certMatNac,
                            @@pad_fechaEgreso,
                            @@pad_diploma25,
                            @@pad_medalla50,
                            @@tcon_id,
                            @@pad_agenda,
                            @@pad_palm,
                            @@tdoc_id,
                            @@pad_nrodoc,
                            @@pad_cuit,
                            @@pad_cuil,
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
                            @@pad_cajaConstancia,
                            @@pad_cajaNro,
                            @@pad_matProv,
                            @@pad_certMatProv,
                            @@pad_cajaConstBaja,
                            @@pad_fechaConstBaja,
                            @@colg_id,
                            @@pad_FotocopiaDoc,
                            @@pad_cuotaSocial,
                            @@pad_descrip,
                            @@pad_domFiscalAfip,
                            @@est_id,
                            @@pad_okContaduria,
                            @@pad_okSecretaria,
                            @@us_id_carga,
                            @@us_id_contaduria,
                            @@us_id_secretaria,
                            @@pad_fax,
                            @@pa_id_postal,
                            @@pad_telPostal,

                            @@pad_ivaCertExcFechaFin,
                            @@pad_ganCertExcFechaFin,
                            @@pad_ibCertExcFechaFin,

                            @@pad_ivaCertExcFechaIni,
                            @@pad_ganCertExcFechaIni,
                            @@pad_ibCertExcFechaIni,

                            @@pad_cbuInformada,
                            @@pad_SecNoModif,
                            @@pad_ContNoModif
    )


  if   @@pad_SecNoModif <> 0 begin
  
    update aaarbaweb..PadronSocio set est_id_sec = 5 where pad_id = @pad_id

  end
  if  @@pad_ContNoModif <> 0 begin

    update aaarbaweb..PadronSocio set est_id_cont = 5 where pad_id = @pad_id

  end

  select @pad_id

end





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

