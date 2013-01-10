if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_articulosave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_articulosave]

go
/*

*/

create procedure sp_srv_cvxi_articulosave (

  @@cmi_id              int,
  @@codigo               varchar(255),
  @@nombre               varchar(1000),
  @@ventas              varchar(50),
  @@ofertas              varchar(50),
  @@visitas              varchar(50),
  @@disponible          varchar(50),
  @@finaliza            varchar(50)
)

as

begin

  set nocount on

  declare @cmipr_id int

  -- Solo verifico que no este el header
  --
  select @cmipr_id = cmipr_id  
  from ComunidadInternetProducto
  where cmi_id = @@cmi_id
    and cmipr_codigo = @@codigo

  if @cmipr_id is null begin

    exec sp_dbgetnewid 'ComunidadInternetProducto', 'cmipr_id', @cmipr_id out, 0

    insert into ComunidadInternetProducto
                                    (   cmi_id,
                                       cmipr_id,
                                       cmipr_codigo,
                                       cmipr_nombre,
                                       cmipr_ventas,
                                       cmipr_ofertas,
                                       cmipr_visitas,
                                       cmipr_disponible,
                                       cmipr_finaliza
                                     )

                          values      (@@cmi_id,
                                       @cmipr_id,
                                       @@codigo,
                                       @@nombre,
                                       @@ventas,
                                       @@ofertas,
                                       @@visitas,
                                       @@disponible,
                                       @@finaliza
                                      )
  end
  else 

    update ComunidadInternetProducto 
      set modificado         = getdate(),
          cmipr_nombre      = @@nombre,
          cmipr_ventas       = @@ventas,
          cmipr_ofertas     = @@ofertas,
          cmipr_visitas     = @@visitas,
          cmipr_disponible   = @@disponible,
          cmipr_finaliza     = @@finaliza
    where cmipr_id = @cmipr_id

end