if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_preguntasave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_preguntasave]

go
/*

*/

create procedure [dbo].[sp_srv_cvxi_preguntasave] (

  @@cmi_id              int,
  @@us_id              int,
  @@cmip_preguntaid     varchar(255),
  @@nick               varchar(255),
  @@pregunta           varchar(4000),
  @@articuloid          varchar(50),
  @@respuesta           varchar(4000),
  @@fecha              datetime,
  @@fecha_respuesta     datetime

)

as

begin

  set nocount on

  declare @cmip_id int

  -- Solo verifico que no este el header
  --
  select @cmip_id = cmip_id  
  from ComunidadInternetPregunta
  where cmip_preguntaid = @@cmip_preguntaid 
    and cmi_id = @@cmi_id
    and cmip_articuloid = @@articuloid

  if @@respuesta = '</TEXTAREA>' set @@respuesta = ''

  if @cmip_id is null and @@nick <> '' begin

    exec sp_dbgetnewid 'ComunidadInternetPregunta', 'cmip_id', @cmip_id out, 0

    insert into ComunidadInternetPregunta 
                                    (   cmip_id,
                                       cmip_preguntaid,
                                       cmip_nick,
                                       cmip_pregunta,
                                       cmip_respuesta,
                                       cmip_fecha,
                                       cmip_fecha_respuesta,
                                       cmip_articuloid,
                                       cmi_id,
                                       modifico
                                     )

                          values      (@cmip_id,
                                       @@cmip_preguntaid,
                                       @@nick,
                                       @@pregunta,
                                       @@respuesta,
                                       @@fecha,
                                       @@fecha_respuesta,
                                       @@articuloid,
                                       @@cmi_id,
                                       @@us_id
                                      )
  end

  else

    if @@respuesta <> '' 

      update ComunidadInternetPregunta 
        set cmip_respuesta = @@respuesta,
            cmip_fecha_respuesta = @@fecha_respuesta,
            modifico = @@us_id,
            us_id_respondio = @@us_id
      where cmip_id = @cmip_id

  select @cmip_id as cmip_id

end
