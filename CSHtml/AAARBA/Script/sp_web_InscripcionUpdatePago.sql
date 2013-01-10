if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_InscripcionUpdatePago]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_InscripcionUpdatePago]

/*


*/

go
create procedure sp_web_InscripcionUpdatePago (
  @@insc_id                int,

  -- Datos del pago
  @@AABAinsc_chkAutoHono           tinyint, 
  @@AABAinsc_fechaFormHono         datetime,
  @@AABAinsc_fechaAltaHono         datetime,
  @@AABAinsc_importeHono           decimal(18, 6),
  @@AABAinsc_fechaFormCBU         datetime,
  @@AABAinsc_fechaAltaCBU         datetime,
  @@AABAinsc_importeCBU           decimal(18, 6),
  @@AABAinsc_titularCBU           varchar (255),
  @@AABAinsc_tipoDocCBU           tinyint,
  @@AABAinsc_nroDocCBU             varchar (15),
  @@AABAinsc_nroCBU               varchar (50),
  @@AABAinsc_tipoCuentaCBU         tinyint,
  @@AABAinsc_nroCtaCBU             varchar (50),
  @@bco_id_CBU                     int,
  @@AABAinsc_sucursalCBU           int,
  @@AABAinsc_fechaAltaTarjeta     datetime,
  @@tjc_id                         int,
  @@AABAinsc_nroTarjeta           varchar (30),
  @@AABAinsc_fechaVtoTarjeta       datetime,
  @@AABAinsc_codSegTarjeta         varchar (50),
  @@AABAinsc_titularTarjeta       varchar (255),
  @@AABAinsc_dirResumenTarjeta     varchar (255),
  @@AABAinsc_dirPedidoTarjeta     varchar (255),
  @@AABAinsc_telefonoTarjeta       varchar (50),
  @@AABAinsc_tipoDocTarjeta       tinyint,
  @@AABAinsc_nroDocTarjeta         varchar (15),
  @@AABAinsc_autorizacionTarjeta  varchar (100)
)
as

begin

  set nocount on

  begin transaction

    update aaarbaweb..Inscripcion set

                            AABAinsc_chkAutoHono          =@@AABAinsc_chkAutoHono,
                            AABAinsc_fechaFormHono        =@@AABAinsc_fechaFormHono,
                            AABAinsc_fechaAltaHono        =@@AABAinsc_fechaAltaHono,
                            AABAinsc_importeHono          =@@AABAinsc_importeHono,
                            AABAinsc_fechaFormCBU          =@@AABAinsc_fechaFormCBU,
                            AABAinsc_fechaAltaCBU          =@@AABAinsc_fechaAltaCBU,
                            AABAinsc_importeCBU            =@@AABAinsc_importeCBU,
                            AABAinsc_titularCBU            =@@AABAinsc_titularCBU,
                            AABAinsc_tipoDocCBU            =@@AABAinsc_tipoDocCBU,
                            AABAinsc_nroDocCBU            =@@AABAinsc_nroDocCBU,
                            AABAinsc_nroCBU                =@@AABAinsc_nroCBU,
                            AABAinsc_tipoCuentaCBU        =@@AABAinsc_tipoCuentaCBU,
                            AABAinsc_nroCtaCBU            =@@AABAinsc_nroCtaCBU,
                            bco_id_CBU                    =@@bco_id_CBU,
                            AABAinsc_sucursalCBU          =@@AABAinsc_sucursalCBU,
                            AABAinsc_fechaAltaTarjeta      =@@AABAinsc_fechaAltaTarjeta,
                            tjc_id                        =@@tjc_id,
                            AABAinsc_nroTarjeta            =@@AABAinsc_nroTarjeta,
                            AABAinsc_fechaVtoTarjeta      =@@AABAinsc_fechaVtoTarjeta,
                            AABAinsc_codSegTarjeta        =@@AABAinsc_codSegTarjeta,
                            AABAinsc_titularTarjeta        =@@AABAinsc_titularTarjeta,
                            AABAinsc_dirResumenTarjeta    =@@AABAinsc_dirResumenTarjeta,
                            AABAinsc_dirPedidoTarjeta      =@@AABAinsc_dirPedidoTarjeta,
                            AABAinsc_telefonoTarjeta      =@@AABAinsc_telefonoTarjeta,
                            AABAinsc_tipoDocTarjeta        =@@AABAinsc_tipoDocTarjeta,
                            AABAinsc_nroDocTarjeta        =@@AABAinsc_nroDocTarjeta,
                            AABAinsc_autorizacionTarjeta  =@@AABAinsc_autorizacionTarjeta,

                            modificado          = getdate()

    where insc_id = @@insc_id

    exec sp_web_InscripcionUpdateEstado @@insc_id

  commit transaction

  select insc_id, insc_numero from aaarbaweb..Inscripcion where insc_id = @@insc_id

  return
ControlError:

  if @@trancount > 0 begin
    rollback transaction  
  end

  raiserror ('Error al grabar la inscripción', 16, 1)

end

go
