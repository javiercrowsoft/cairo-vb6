SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_PadronUpdateSagSec]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_PadronUpdateSagSec]
GO




create procedure sp_web_PadronUpdateSagSec (

      @@soc_id                                        int,
      @@pad_fecha                                     datetime,
      @@pad_apellidoNombre                            varchar(255),
      @@pad_sexo                                      tinyint,
      @@pad_fechanac                                  datetime,
      @@pa_nombre                                     varchar(255),
      @@estc_id                                       int,
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
      @@pad_okSecretaria                              tinyint,
      @@us_id_carga                                   int,
      @@pad_fax                                       varchar(50),
      @@pa_id_postal                                  int,
      @@pad_telPostal                                 varchar(50),
      @@pad_descripSec                                varchar(255),
      @@est_id_sec                                    int
)
as

begin

  set nocount on

    declare @provin varchar(2)

    select  @provin =
            case @@pro_id_postal
              when  3  then 'BA'
              when  8  then 'NE'
              when  9  then 'MI'
              when 10  then 'CR'
              when 11   then 'ER'
              when 12  then 'LP' 
              when 13   then 'JU'
              when 14   then 'SA'
              when 15   then 'FO'
              when 16   then 'CHA'
              when 17   then 'CA'
              when 18   then 'TU'
              when 19   then 'SE'
              when 20   then 'RJ'
              when 21  then 'CO'
              when 22   then 'SJ'
              when 23   then 'SL'
              when 24  then 'ME'
              when 26  then 'RN'
              when 29   then 'SC'
              when 30   then 'TF'
              when 31  then 'CF'
              when 32  then 'SF'
              when 34  then 'CH'
            end

    declare @pa_id_postal int

    select @pa_id_postal =

            case @@pa_id_postal 
                  when 42   then 1     -- Canada
                  when 202   then 27   -- Sudáfrica
                  when 24   then 32   -- Belgica
                  when 81   then 33   -- Francia
                  when 73   then 34   -- España
                  when 115   then 39   -- Italia
                  when 205   then 41   -- Suiza
                  when 174   then 51   -- Peru
                  when 150   then 52   -- Mexico
                  when 12   then 54   -- Argentina
                  when 33   then 55   -- Brasil
                  when 47   then 56   -- Chile
                  when 51   then 57   -- Colombia
                  when 228   then 58   -- Venezuela
                  when 74   then 74   -- EEUU
                  when 101   then 504   -- Honduras
                  when 58   then 506   -- Costa Rica
                  when 172   then 507   -- Panama
                  when 30   then 591   -- Bolivia
                  when 66   then 593   -- Ecuador
                  when 173   then 595   -- Paraguay
                  when 225   then 598   -- Uruguay
            end


-----------------------------------------------------------------------------------------

  if not exists(select * from medi_direc where medico = @@soc_id and postal_marca <> 0) begin

    declare @direc_id smallint 

    select @direc_id = isnull(max(direc_id),0) +1  from medi_direc  where medi_direc.medico = @@soc_id 

    insert into medi_direc (medico,   direc_id,  descrip,     domi,         codi_postal,      loca,
                            pais,          provin,  tele,            fiscal_marca, postal_marca)
                    values (@@soc_id, @direc_id, 'Domicilio', @@pad_callep, @@pad_codPostalp, @@pad_localidadp,
                            @pa_id_postal, @provin, @@pad_telPostal, 0,            1)

  end else begin


    update medi_direc 

                      set 
                          provin          = @provin,
                          domi             = @@pad_callep,
                          codi_postal      = @@pad_codPostalp,
                          loca            = @@pad_localidadp,
                          tele            = @@pad_telPostal,
                          pais            = @pa_id_postal

    where  medico = @@soc_id 
      and postal_marca <> 0

  end
-----------------------------------------------------------------------------------------

    declare @docu_tipo varchar(255)

    select @docu_tipo = 
            case @@tdoc_id
                when 1     then 'LE'
                when 3    then 'DNI'
                when 7    then 'CE'
                when 5    then 'CI'
                when 8    then 'DD'
            end

    select @@estc_id =   case @@estc_id
                          when 1 then 1
                          when 2 then 2
                          when 3 then 4
                          when 4 then 3
                          when 5 then 6
                          when 6 then 7
                          when 8 then 5
                          else 7
                        end

    update medicos

                      set 
                          nombre              = @@pad_apellidoNombre,
                          civil_esta           = @@estc_id,
                          naci_fecha          = @@pad_fechanac,
                          nacional            = @@pa_nombre,
                          e_mail_direc        = @@pad_email,
                          radio_mensa         = @@pad_radio,
                          tele_nextel         = @@pad_nextel,
                          tele_profesional    = @@pad_telProfesional,
                          movil               = @@pad_telCelular,
                          Fax                  = @@pad_fax,
                          sexo                = @@pad_sexo,
                          especiali            = @@soce_id,
                          anio_cursa          = @@pad_anioCurso,
                          otorga_por          = @@pad_otorgadoPor,
                          socio_cate          = @@socc_id,
                          matri_nacio         = @@pad_matNac,
                          matri_provin        = @@pad_matProv,
                          docu_nume           = @@pad_nrodoc,
                          docu_tipo            = @docu_tipo,
                          usu_registro        = @@us_id_carga,
                          fec_registro        = getdate()

    where medico = @@soc_id

    if not exists (select * from Proveedores_Datos_Impositivos where proveedor = @@soc_id)
    begin

      insert Proveedores_Datos_Impositivos (PROVEEDOR,
                                            nro_caja_prev,
                                            CONST_INSCRIP_CAJA_PREV,
                                            const_baja_caja_prev,
                                            fec_ing_baja_caja_prev,
                                            fec_const_baja_caja_prev,
                                            MATRICULADO_CAJA_PREV,
                                            INSCRIPCION_AFIP, 
                                            CONST_INSCRIP_GANAN,
                                            USU_REGISTRO,
                                            FEC_REGISTRO)
                                     values (@@soc_id,
                                            @@pad_cajaNro,
                                            @@pad_cajaConstancia,
                                            @@pad_cajaConstBaja,
                                            @@pad_fechaConstBaja,
                                            getdate(),

                                            CASE WHEN LEN(@@pad_cajaNro) = 0 THEN 0 ELSE 1
                                            END ,

                                            0,
                                            0,
                                             'sa',
                                            getdate())

    end else begin

      update Proveedores_Datos_Impositivos 
  
                        set nro_caja_prev             =  @@pad_cajaNro,
                            CONST_INSCRIP_CAJA_PREV  =  @@pad_cajaConstancia,
                            const_baja_caja_prev     =  @@pad_cajaConstBaja,
                            fec_const_baja_caja_prev =  @@pad_fechaConstBaja,
                            fec_ing_baja_caja_prev   =  getdate()                                                  
  
      where proveedor = @@soc_id

    end
---------------------------------------------------------------------------------------------------------------------

-- Campos a agregar a alguna tabla de sag

--Proveedores Datos Impositivos

--       @@pad_cajaConstBaja                             tinyint,    const_baja_caja_prev
--       @@pad_fechaConstBaja                            datetime,   fec_baja_caja_prev
--        getdate()                                                 fec_const_baja_caja_prev

-- No se actualiza
--       @@pad_especialidad                              varchar(255),
--       @@pad_certFAAAR                                 tinyint,
--       @@pad_fechaCertFAAAR                            datetime,
--       @@pad_reCertFAAAR                               tinyint,
--       @@pad_fechaReCertFAAAR                          datetime,
--       @@pad_examenFAAAR                               tinyint,
--       @@pad_fechaExamenFAAAR                          datetime,
--       @@pad_socHonorario                              tinyint,
--       @@pad_fechaSocHonorario                         datetime,
--       @@pad_certMatNac                                tinyint,
--      @@pad_diploma25                                  tinyint,
--       @@pad_medalla50                                 tinyint,
--       @@tcon_id                                       int,
--       @@pad_agenda                                    varchar(255),
--       @@pad_palm                                      varchar(255),
--       @@pad_certMatProv                               tinyint,
--       @@colg_id                                       int,
--       @@pad_FotocopiaDoc                               tinyint,
--       @@pad_descrip                                   varchar(255),
--      @@pad_telParticular
--       @@pad_cuotaSocial                               tinyint,
--      @@pad_fechaEgreso
---------------------------------------------------------------------------------------------------------------------

end





GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

