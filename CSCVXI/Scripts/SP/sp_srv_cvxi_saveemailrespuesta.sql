if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_saveEmailRespuesta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_saveEmailRespuesta]

go
/*

*/

create procedure sp_srv_cvxi_saveEmailRespuesta (

  @@cmi_id            int,
  @@cmia_id            int,
  @@idm_id            int,
  @@cmie_id            int,
  @@cmir_from          varchar(1000),
  @@cmir_to            varchar(5000),
  @@cmir_subject      varchar(5000),
  @@cmir_body          varchar(8000)

)

as

begin

  set nocount on

  declare @cmir_id int

  exec sp_dbgetnewid 'ComunidadInternetRespuesta', 'cmir_id', @cmir_id out, 0

  insert into ComunidadInternetRespuesta (
                                          cmir_id,
                                          cmi_id,
                                          cmia_id,
                                          idm_id,
                                          cmie_id,
                                          cmir_body,
                                          cmir_from,
                                          cmir_subject,
                                          cmir_to
                                        )
                                values  (
                                          @cmir_id,
                                          @@cmi_id,
                                          @@cmia_id,
                                          @@idm_id,
                                          @@cmie_id,
                                          @@cmir_body,
                                          @@cmir_from,
                                          @@cmir_subject,
                                          @@cmir_to
                                        )


end