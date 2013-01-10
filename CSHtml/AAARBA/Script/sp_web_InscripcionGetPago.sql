if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionGetPago]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionGetPago]

/*

sp_web_InscripcionGetPago 12

*/

go
create procedure sp_web_InscripcionGetPago (
  @@insc_id  int
)
as

begin

  set nocount on

  select 
        AABAinsc_chkAutoHono,
        AABAinsc_fechaFormHono,
        AABAinsc_fechaAltaHono,
        AABAinsc_importeHono,
        AABAinsc_fechaFormCBU,
        AABAinsc_fechaAltaCBU,
        AABAinsc_importeCBU,
        AABAinsc_titularCBU,
        AABAinsc_tipoDocCBU,
        AABAinsc_nroDocCBU,
        AABAinsc_nroCBU,
        AABAinsc_tipoCuentaCBU,
        AABAinsc_nroCtaCBU,
        bco_id_CBU,
        bco_nombre,
        AABAinsc_sucursalCBU,
        AABAinsc_fechaAltaTarjeta,
        tjc_id,
        AABAinsc_nroTarjeta,
        AABAinsc_fechaVtoTarjeta,
        AABAinsc_codSegTarjeta,
        AABAinsc_titularTarjeta,
        AABAinsc_dirResumenTarjeta,
        AABAinsc_dirPedidoTarjeta,
        AABAinsc_telefonoTarjeta,
        AABAinsc_tipoDocTarjeta,
        AABAinsc_nroDocTarjeta,
        AABAinsc_autorizacionTarjeta

  from aaarbaweb..Inscripcion insc left join banco bco on insc.bco_id_CBU = bco.bco_id

  where insc_id = @@insc_id

end

go
