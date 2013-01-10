SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/*

delete ComunidadInternetVenta

sp_srv_cvxi_ventasave 1, 'HORA230','UPS Atomlux 500 220v 5 salidas c/soft monitoreo Microcentro','89946048','358,90','10025662','Acreditado','09/08/2010','20100809 00:00:00'

*/

ALTER  procedure sp_srv_cvxi_ventasave (

  @@cmi_id              int,
  @@cmia_id             int,
  @@cmi_user           varchar(255),
  @@cmiv_ventaId       varchar(255),
  @@nick               varchar(255),
  @@nombre              varchar(255),
  @@apellido            varchar(255),
  @@articulo           varchar(1000),
  @@articuloid          varchar(255),
  @@preciostr          varchar(50),
  @@cantidadstr        varchar(50),
  @@precio             decimal(18,6),
  @@cantidad            decimal(18,6),

  @@email                 varchar(255),
  @@telefono             varchar(255),
  @@localidad            varchar(255),
  @@provincia            varchar(255),

  @@fecha              datetime

)

as

begin

  set nocount on

  --//////////////////////////////////////////////////////////////////////
  --
  -- IMPORTANTE: el codigo de ComunidadInternetEmailAccount debe coincidir
  --             con el valor del parametro @@cmi_user
  --
  --//////////////////////////////////////////////////////////////////////


  ------------------------------------------------------------------------
  -- Prefijos de comunidades
  --
  -- Los clientes van prefijados segun su comunidad
  --
  declare @nick varchar(50)

  if @@cmi_id = 1 -- 1 es MercadoLibre

      set @nick = '(ML)#'+ @@nick

  else if @@cmi_id = 2 -- 2 es MasOportunidades

      set @nick = '(MO)#'+ @@nick

  declare @cmiv_id int
  declare @pr_id int
  declare @pv_id int
  declare @cli_id int
  declare @cmie_id int

  -- Solo verifico que no este el header
  --
  select  @cmiv_id = cmiv_id,
          @pv_id = pv_id,
          @pr_id = pr_id,
          @cli_id = cli_id,
          @cmie_id = cmie_id
  from ComunidadInternetVenta
  where cmiv_ventaId = @@cmiv_ventaId 
    and cmi_id = @@cmi_id
    and cmiv_articulo = @@articulo
    and cmiv_articuloid = @@articuloid
    and abs(datediff(d,cmiv_fecha,@@fecha)) <= 2
    and cmiv_nick = @@nick

  -- Si no tengo el producto en la venta
  --
  if @pr_id is null begin

    select @pr_id = min(pr_id)
    from ComunidadInternetProducto
    where cmipr_codigo = @@articuloid
      and cmi_id = @@cmi_id

    if @pr_id is null begin
  
      select @pr_id = min(pr_id)
      from ProductoComunidadInternet
      where prcmi_codigo = @@articuloid
        and cmi_id = @@cmi_id
  
    end

  end

  -- Si no tengo el cliente en la venta
  --
  if @cli_id is null begin

    select @cli_id = min(cli_id)
    from cliente
    where cli_codigocomunidad = @nick
  
    if @cli_id is not null and @pr_id is not null begin
  
      select @pv_id = max(pv.pv_id)
      from PedidoVenta pv inner join PedidoVentaItem pvi on pv.pv_id = pvi.pv_id
      where pv.cli_id = @cli_id
        and pvi.pr_id = @pr_id
        and pvi.pvi_codigocomunidad = @@articuloid
        and pv_pendiente > 0

        -- el pedido no tiene que estar usado por otra venta
        --
        and not exists( select 1 
                        from ComunidadInternetVenta 
                        where pv_id = pv.pv_id
                           and cmiv_id = @cmiv_id)  
    end

  end

  -- Si no tengo el pedido de venta y si tengo el cliente
  --
  if @cli_id is not null and @pv_id is null begin

    select @pv_id = max(pv.pv_id)
    from PedidoVenta pv inner join PedidoVentaItem pvi on pv.pv_id = pvi.pv_id
    where pv.cli_id = @cli_id
      and pvi.pvi_codigocomunidad = @@articuloid
      and pv_pendiente > 0

      -- el pedido no tiene que estar usado por otra venta
      --
      and not exists( select 1 
                      from ComunidadInternetVenta 
                      where pv_id = pv.pv_id
                         and cmiv_id = @cmiv_id)

    if @pv_id is null begin

      select @pv_id = max(pv.pv_id)
      from PedidoVenta pv inner join PedidoVentaItem pvi on pv.pv_id = pvi.pv_id
      where pv.cli_id = @cli_id
        and pvi.pvi_codigocomunidad = @@articuloid

        -- el pedido no tiene que estar usado por otra venta
        --
        and not exists( select 1 
                        from ComunidadInternetVenta 
                        where pv_id = pv.pv_id
                           and cmiv_id = @cmiv_id)

    end

  end

  -- Si no tengo el mail y tengo el pedido de venta
  --
  if @pv_id is not null and @cmie_id is null begin

    select @cmie_id = cmie_id
    from ComunidadInternetMail
    where pv_id = @pv_id

  end

  if @cmiv_id is null begin

    --//////////////////////////////////////////////////////////////////////////
    --
    -- Si la venta es nueva y no hay pedido de venta, vamos a generar un mail
    -- ficticio y este va a generar un pedido.
    -- Con este mecanismo, vamos a reemplazar el esquema de mail sin programar
    -- nada nuevo.
    -- En una implementacion no debe estar activo el servicio de mail y el servicio
    -- de ventas al mismo tiempo, pero si se pueden activar alternativamente.
    -- Los planes son reemplazar el servicio de mail por ser excesivamente complejo
    -- y requerir demasiado mantenimiento y una instalacion avanzada.
    -- El servicio de ventas no requiere de instalacion y con unos meses en produccion
    -- sabremos si requiere mucho o poco mantenimiento.
    --
    --//////////////////////////////////////////////////////////////////////////

    if @pv_id is null begin

      -- 1 Insertamos en mail
      --
      -- 2 Llamamos a sp_srv_cvxi_pedidoVentaSave
      --
      -- 3 Actualizamos vaiables
      --

      -- Mail
      --
      exec sp_dbgetnewid 'ComunidadInternetMail','cmie_id',@cmie_id out, 0

      declare @cmie_fromname varchar(255)
      select @cmie_fromname = cmi_nombre
      from ComunidadInternet
      where cmi_id = @@cmi_id

      declare @cmiea_id int
      select @cmiea_id = cmiea_id
      from ComunidadInternetEmailAccount
      where cmiea_codigo = @@cmi_user

      -- Si no esta bien configurado usamos el primero de la lista
      -- que es el auxiliar. El nombre de esta cuenta es "DEBE CONFIGURAR LA CUENTA" :P
      --
      if @cmiea_id is null set @cmiea_id = 1

      insert into ComunidadInternetMail (cmie_id
                                          ,cmie_account
                                          ,cmie_mailid
                                          ,cmie_fromname
                                          ,cmie_fromaddress
                                          ,cmie_to
                                          ,cmie_subject
                                          ,cmie_body_html
                                          ,cmie_body_plain
                                          ,cmie_body_mime
                                          ,cmie_subject_mime
                                          ,cmie_header_mime
                                          ,cmie_body_updated
                                          ,cmie_date
                                          ,cmi_id
                                          ,cmiea_id
                                          ,cli_id
                                          ,est_id
                                          ,pv_id
                                          ,creado
                                          )
                                  values (@cmie_id
                                          ,'pv: ' + @@cmi_user
                                          ,@cmie_id
                                          ,@cmie_fromname
                                          ,'pv: no_responder' -- cmie_fromaddress
                                          ,'pv: no_mail'       -- cmie_to
                                          ,'venta detectada por pagina de ventas' -- cmie_subject
                                          ,'pv: no body'       -- cmie_body_html
                                          ,'pv: no body'       -- cmie_body_plain
                                          ,'pv: no body'       -- cmie_body_mime
                                          ,'pv: no subject'   -- cmie_subject_mime
                                          ,'pv: no header'     -- cmie_header_mime
                                          ,1                   -- cmie_body_updated
                                          ,@@fecha             -- cmie_date
                                          ,@@cmi_id
                                          ,@cmiea_id
                                          ,null               -- cli_id
                                          ,1                   -- est_id
                                          ,null               -- pv_id
                                          ,getdate()           -- creado
                                          )

      declare @cmiti_id int
      declare @cmiei_id int


      -- @@codigo_producto
      --
      select @cmiti_id = cmiti_id 
      from ComunidadInternetTextoItem cmiti 
      where cmiti_codigomacro = '@@codigo_producto'

      exec sp_dbgetnewid 'ComunidadInternetMailItem','cmiei_id',@cmiei_id out, 0

      insert into ComunidadInternetMailItem (cmiei_id
                                              ,cmiei_valor
                                              ,cmiei_valorhtml
                                              ,cmiei_texto
                                              ,cmiti_id
                                              ,cmie_id
                                              )
                                      values (
                                              @cmiei_id
                                              ,@@articuloid     --cmiei_valor
                                              ,''               --cmiei_valorhtml
                                              ,'pv: no texto'   --cmiei_texto
                                              ,@cmiti_id
                                              ,@cmie_id
                                              )
      --//////////////////////////////////////////////////////////////////////////////

      -- @@nombre_producto
      --
      select @cmiti_id = cmiti_id 
      from ComunidadInternetTextoItem cmiti 
      where cmiti_codigomacro = '@@nombre_producto'

      exec sp_dbgetnewid 'ComunidadInternetMailItem','cmiei_id',@cmiei_id out, 0

      insert into ComunidadInternetMailItem (cmiei_id
                                              ,cmiei_valor
                                              ,cmiei_valorhtml
                                              ,cmiei_texto
                                              ,cmiti_id
                                              ,cmie_id
                                              )
                                      values (
                                              @cmiei_id
                                              ,@@articulo       --cmiei_valor
                                              ,''               --cmiei_valorhtml
                                              ,'pv: no texto'   --cmiei_texto
                                              ,@cmiti_id
                                              ,@cmie_id
                                              )
      --//////////////////////////////////////////////////////////////////////////////

      -- @@cantidad
      --
      select @cmiti_id = cmiti_id 
      from ComunidadInternetTextoItem cmiti 
      where cmiti_codigomacro = '@@cantidad'

      exec sp_dbgetnewid 'ComunidadInternetMailItem','cmiei_id',@cmiei_id out, 0

      insert into ComunidadInternetMailItem (cmiei_id
                                              ,cmiei_valor
                                              ,cmiei_valorhtml
                                              ,cmiei_texto
                                              ,cmiti_id
                                              ,cmie_id
                                              )
                                      values (
                                              @cmiei_id
                                              ,@@cantidad       --cmiei_valor
                                              ,''               --cmiei_valorhtml
                                              ,'Cantidad:'   --cmiei_texto
                                              ,@cmiti_id
                                              ,@cmie_id
                                              )
      --//////////////////////////////////////////////////////////////////////////////

      -- @@precio
      --
      select @cmiti_id = cmiti_id 
      from ComunidadInternetTextoItem cmiti 
      where cmiti_codigomacro = '@@precio'

      exec sp_dbgetnewid 'ComunidadInternetMailItem','cmiei_id',@cmiei_id out, 0

      insert into ComunidadInternetMailItem (cmiei_id
                                              ,cmiei_valor
                                              ,cmiei_valorhtml
                                              ,cmiei_texto
                                              ,cmiti_id
                                              ,cmie_id
                                              )
                                      values (
                                              @cmiei_id
                                              ,@@precio         --cmiei_valor
                                              ,''               --cmiei_valorhtml
                                              ,'Precio final:'   --cmiei_texto
                                              ,@cmiti_id
                                              ,@cmie_id
                                              )
      --//////////////////////////////////////////////////////////////////////////////

      -- @@apodo
      --
      select @cmiti_id = cmiti_id 
      from ComunidadInternetTextoItem cmiti 
      where cmiti_codigomacro = '@@apodo'

      exec sp_dbgetnewid 'ComunidadInternetMailItem','cmiei_id',@cmiei_id out, 0

      insert into ComunidadInternetMailItem (cmiei_id
                                              ,cmiei_valor
                                              ,cmiei_valorhtml
                                              ,cmiei_texto
                                              ,cmiti_id
                                              ,cmie_id
                                              )
                                      values (
                                              @cmiei_id
                                              ,@@nick           --cmiei_valor
                                              ,''               --cmiei_valorhtml
                                              ,'pv: no texto'   --cmiei_texto
                                              ,@cmiti_id
                                              ,@cmie_id
                                              )
      --//////////////////////////////////////////////////////////////////////////////

      -- @@nombre_comprador
      --
      select @cmiti_id = cmiti_id 
      from ComunidadInternetTextoItem cmiti 
      where cmiti_codigomacro = '@@nombre_comprador'

      exec sp_dbgetnewid 'ComunidadInternetMailItem','cmiei_id',@cmiei_id out, 0

      insert into ComunidadInternetMailItem (cmiei_id
                                              ,cmiei_valor
                                              ,cmiei_valorhtml
                                              ,cmiei_texto
                                              ,cmiti_id
                                              ,cmie_id
                                              )
                                      values (
                                              @cmiei_id
                                              ,@@nombre + ' ' + @@apellido  --cmiei_valor
                                              ,''                           --cmiei_valorhtml
                                              ,'pv: no texto'               --cmiei_texto
                                              ,@cmiti_id
                                              ,@cmie_id
                                              )
      --//////////////////////////////////////////////////////////////////////////////

      -- @@telefono_comprador
      --
      select @cmiti_id = cmiti_id 
      from ComunidadInternetTextoItem cmiti 
      where cmiti_codigomacro = '@@telefono_comprador'

      exec sp_dbgetnewid 'ComunidadInternetMailItem','cmiei_id',@cmiei_id out, 0

      insert into ComunidadInternetMailItem (cmiei_id
                                              ,cmiei_valor
                                              ,cmiei_valorhtml
                                              ,cmiei_texto
                                              ,cmiti_id
                                              ,cmie_id
                                              )
                                      values (
                                              @cmiei_id
                                              ,@@telefono        --cmiei_valor
                                              ,''               --cmiei_valorhtml
                                              ,'pv: no texto'   --cmiei_texto
                                              ,@cmiti_id
                                              ,@cmie_id
                                              )
      --//////////////////////////////////////////////////////////////////////////////

      -- @@tel_interno_comprador
      --
      select @cmiti_id = cmiti_id 
      from ComunidadInternetTextoItem cmiti 
      where cmiti_codigomacro = '@@tel_interno_comprador'

      exec sp_dbgetnewid 'ComunidadInternetMailItem','cmiei_id',@cmiei_id out, 0

      insert into ComunidadInternetMailItem (cmiei_id
                                              ,cmiei_valor
                                              ,cmiei_valorhtml
                                              ,cmiei_texto
                                              ,cmiti_id
                                              ,cmie_id
                                              )
                                      values (
                                              @cmiei_id
                                              ,''               --cmiei_valor
                                              ,''               --cmiei_valorhtml
                                              ,'pv: no texto'   --cmiei_texto
                                              ,@cmiti_id
                                              ,@cmie_id
                                              )
      --//////////////////////////////////////////////////////////////////////////////

      -- @@email_comprador
      --
      select @cmiti_id = cmiti_id 
      from ComunidadInternetTextoItem cmiti 
      where cmiti_codigomacro = '@@email_comprador'

      exec sp_dbgetnewid 'ComunidadInternetMailItem','cmiei_id',@cmiei_id out, 0

      insert into ComunidadInternetMailItem (cmiei_id
                                              ,cmiei_valor
                                              ,cmiei_valorhtml
                                              ,cmiei_texto
                                              ,cmiti_id
                                              ,cmie_id
                                              )
                                      values (
                                              @cmiei_id
                                              ,@@email          --cmiei_valor
                                              ,''               --cmiei_valorhtml
                                              ,'pv: no texto'   --cmiei_texto
                                              ,@cmiti_id
                                              ,@cmie_id
                                              )
      --//////////////////////////////////////////////////////////////////////////////

      -- @@ciudad_comprador
      --
      select @cmiti_id = cmiti_id 
      from ComunidadInternetTextoItem cmiti 
      where cmiti_codigomacro = '@@ciudad_comprador'

      exec sp_dbgetnewid 'ComunidadInternetMailItem','cmiei_id',@cmiei_id out, 0

      insert into ComunidadInternetMailItem (cmiei_id
                                              ,cmiei_valor
                                              ,cmiei_valorhtml
                                              ,cmiei_texto
                                              ,cmiti_id
                                              ,cmie_id
                                              )
                                      values (
                                              @cmiei_id
                                              ,@@localidad       --cmiei_valor
                                              ,''               --cmiei_valorhtml
                                              ,'pv: no texto'   --cmiei_texto
                                              ,@cmiti_id
                                              ,@cmie_id
                                              )
      --//////////////////////////////////////////////////////////////////////////////

      -- @@provincia_comprador
      --
      select @cmiti_id = cmiti_id 
      from ComunidadInternetTextoItem cmiti 
      where cmiti_codigomacro = '@@provincia_comprador'

      exec sp_dbgetnewid 'ComunidadInternetMailItem','cmiei_id',@cmiei_id out, 0

      insert into ComunidadInternetMailItem (cmiei_id
                                              ,cmiei_valor
                                              ,cmiei_valorhtml
                                              ,cmiei_texto
                                              ,cmiti_id
                                              ,cmie_id
                                              )
                                      values (
                                              @cmiei_id
                                              ,@@provincia      --cmiei_valor
                                              ,''               --cmiei_valorhtml
                                              ,'pv: no texto'   --cmiei_texto
                                              ,@cmiti_id
                                              ,@cmie_id
                                              )
      --//////////////////////////////////////////////////////////////////////////////

      -- @@pais_comprador
      --
      select @cmiti_id = cmiti_id 
      from ComunidadInternetTextoItem cmiti 
      where cmiti_codigomacro = '@@pais_comprador'

      exec sp_dbgetnewid 'ComunidadInternetMailItem','cmiei_id',@cmiei_id out, 0

      insert into ComunidadInternetMailItem (cmiei_id
                                              ,cmiei_valor
                                              ,cmiei_valorhtml
                                              ,cmiei_texto
                                              ,cmiti_id
                                              ,cmie_id
                                              )
                                      values (
                                              @cmiei_id
                                              ,''               --cmiei_valor
                                              ,''               --cmiei_valorhtml
                                              ,'pv: no texto'   --cmiei_texto
                                              ,@cmiti_id
                                              ,@cmie_id
                                              )
      --//////////////////////////////////////////////////////////////////////////////

      -- 2 Llamamos a sp_srv_cvxi_pedidoVentaSave
      --
      exec sp_srv_cvxi_pedidoVentaSave @cmie_id, @@cmi_id, @@cmia_id, 1

      -- 3 Actualizamos vaiables
      --
      select @pv_id = pv_id, @cli_id = cli_id from ComunidadInternetMail where cmie_id = @cmie_id

    end

    --//////////////////////////////////////////////////////////////////////////
    -- Registro de ventas
    --

    exec sp_dbgetnewid 'ComunidadInternetVenta', 'cmiv_id', @cmiv_id out, 0

    insert into ComunidadInternetVenta 
                                    (   cmiv_id,
                                       cmiv_ventaId,
                                       cmiv_nick,
                                       cmiv_nombre,
                                       cmiv_apellido,
                                       cmiv_articulo,
                                       cmiv_articuloid,
                                       cmiv_preciostr,
                                       cmiv_cantidadstr,
                                       cmiv_precio,
                                       cmiv_cantidad,

                                       cmiv_email,
                                       cmiv_localidad,
                                       cmiv_telefono,
                                       cmiv_provincia,

                                       cmiv_fecha,
                                       cmi_id,
                                       cli_id,
                                       pr_id,
                                       pv_id,
                                       cmie_id
                                     )

                          values      (@cmiv_id,
                                       @@cmiv_ventaId,
                                       @@nick,
                                       @@nombre,
                                       @@apellido,
                                       @@articulo,
                                       @@articuloid,
                                       @@preciostr,
                                       @@cantidadstr,
                                       @@precio,
                                       @@cantidad,

                                       @@email,
                                       @@localidad,
                                       @@telefono,
                                       @@provincia,

                                       @@fecha,
                                       @@cmi_id,
                                       @cli_id,
                                       @pr_id,
                                       @pv_id,
                                       @cmie_id
                                      )
  end      

    update ComunidadInternetVenta set cmie_id = @cmie_id,
                                      pv_id = @pv_id,
                                      pr_id = @pr_id,
                                      cli_id = @cli_id
    where cmiv_id = @cmiv_id

  select @cmiv_id as cmiv_id, @cmie_id as cmie_id

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

