if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_CBUtoGalicia]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_CBUtoGalicia]

/*

insert into bgal_archivo (bgalarch_id,bgalarch_nombre,bgalarch_fecha,modifico,bgalarch_tipo)values(1,'DEBITOS 17-05-2005.TXT','20050517',1,2)
insert into bgal_archivoinscripcion values(4,1,18) 
select * from condicionpago

sp_web_CBUtoGalicia 0

sp_col inscripcion

*/

go
create procedure sp_web_CBUtoGalicia (
  @@includeAll smallint
)
as

begin

  set nocount on

  select   insc_id, 
          insc_numero, 
          insc_fecha,
          insc_apellido, 
          insc_nombre, 
          insc_asociacion,
          insc_socio,
          insc_socioLASFAR,
          insc_documento,
          insc_tipodocumento,
          AABAinsc_nroCBU,
          0 as enviada
  
  from aaarbaweb..inscripcion insc 

  where not exists(select * from BGAL_ArchivoInscripcion where insc_id = insc.insc_id)
    and cpg_id = 3
    and not
        (
                 AABAinsc_fechaFormCBU = '18991230'
            or  AABAinsc_fechaAltaCBU = '18991230'
            or  AABAinsc_importeCBU  = 0
            or  AABAinsc_titularCBU = ''
            or  AABAinsc_tipoDocCBU = 0
            or  AABAinsc_nroDocCBU = ''
            or  AABAinsc_nroCBU = ''
            or  AABAinsc_tipoCuentaCBU = 0 
            or  AABAinsc_nroCtaCBU = ''
            or  bco_id_CBU is null
            or  AABAinsc_sucursalCBU = ''
          )

  union

  select   insc_id, 
          insc_numero, 
          insc_fecha,
          insc_apellido, 
          insc_nombre, 
          insc_asociacion,
          insc_socio,
          insc_socioLASFAR,
          insc_documento,
          insc_tipodocumento,
          AABAinsc_nroCBU,
          1 as enviada
  
  from aaarbaweb..inscripcion insc 

  where exists(select * from BGAL_ArchivoInscripcion where insc_id = insc.insc_id)
    and cpg_id = 3 
    and @@includeAll <> 0
    and not
        (
                 AABAinsc_fechaFormCBU = '18991230'
            or  AABAinsc_fechaAltaCBU = '18991230'
            or  AABAinsc_importeCBU  = 0
            or  AABAinsc_titularCBU = ''
            or  AABAinsc_tipoDocCBU = 0
            or  AABAinsc_nroDocCBU = ''
            or  AABAinsc_nroCBU = ''
            or  AABAinsc_tipoCuentaCBU = 0 
            or  AABAinsc_nroCtaCBU = ''
            or  bco_id_CBU is null
            or  AABAinsc_sucursalCBU = ''
          )

  order by insc_fecha
  
end

go
