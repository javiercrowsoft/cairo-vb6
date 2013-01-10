if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_pedidoVentaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_pedidoVentaSave]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

/* 

  select cmi_id, cmiea_id from comunidadinternetmail where cmie_id = 4168

  select max(cmie_id) from comunidadinternetmail cmie 
  where exists(select * from comunidadinternetrespuesta where cmie_id = cmie.cmie_id)
    and cmie_id < 4168

begin tran

  exec sp_srv_cvxi_pedidoVentaSave 4168,1,1

rollback tran

*/

create procedure sp_srv_cvxi_pedidoVentaSave (
  @@cmie_id         int,
  @@cmi_id          int,
  @@cmia_id          int,
  @@noSelect        int = 0
)
as

set nocount on

begin

  -----------------------------------------------------------------------------
  -- Pasos
    
      -- 1 Llenar header temporal de pedido
    
        -- 1.1 obtener cliente
    
          -- 1.1.1 si no existe crearlo
    
      -- 2 Llenar Items de pedido
    
        -- 2.1 obtener producto
      
          -- 2.1.1 si no existe usar varios asociado a comunidad
    
      -- 3 Llamar a sp_DocPedidoVentaSave
    
      -- 4 Fin

  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Implementacion
    
      -- 1 Llenar header temporal de pedido

      declare @cli_id        int
      declare @cpg_id        int
      declare @doc_id        int
      declare @doct_id      int
      declare @emp_id        int
      declare @pv_id        int
      declare @pv_ivari      decimal(18,6)
      declare @pv_neto      decimal(18,6)
      declare @pv_nrodoc    varchar(255)
      declare @pv_total      decimal(18,6)
      declare @suc_id        int

      select @doc_id = cmi.doc_id,
             @suc_id = cmi.suc_id,
             @emp_id = doc.emp_id

      from ComunidadInternet cmi inner join Documento doc on cmi.doc_id = doc.doc_id
      where cmi_id = @@cmi_id

    
        -- 1.1 obtener cliente

          -- 1.1.1 si no existe crearlo
          exec sp_srv_cvxi_pedidoVentaSaveGetCliId @@cmie_id, @@cmi_id, @cli_id out

      -- Obtengo iva, neto, subtotal y total del header
      declare @ivari           decimal(18,6)
      declare @neto            decimal(18,6)
      declare @precio         decimal(18,6)
      declare @cantidad       decimal(18,6)
      declare @ti_porcentaje   decimal(18,6)
      declare @pr_id              int
      declare @ti_id_ivariventa   int

      declare @pv_descrip     varchar(5000)

      select @pv_descrip = isnull(cmi_nombre,'') + ' - ' + isnull(cmiea_nombre,'')
      from ComunidadInternetMail cmie
                left join ComunidadInternet cmi on cmi.cmi_id = @@cmi_id
                left join ComunidadInternetEmailAccount cmiea on cmie.cmiea_id = cmiea.cmiea_id
      where cmie.cmie_id = @@cmie_id

      -- Obtengo codigo y descripcion del producto en el mail
      --
      declare @codigo_producto varchar(255)
      select @codigo_producto = cmiei_valor 
      from ComunidadInternetMailItem cmiei 
              inner join ComunidadInternetTextoItem cmiti 
                on cmiei.cmiti_id = cmiti.cmiti_id
      where cmie_id = @@cmie_id 
        and cmiti_codigomacro = '@@codigo_producto'

      declare @nombre_producto varchar(255)
      select @nombre_producto = cmiei_valor 
      from ComunidadInternetMailItem cmiei 
              inner join ComunidadInternetTextoItem cmiti 
                on cmiei.cmiti_id = cmiti.cmiti_id
      where cmie_id = @@cmie_id 
        and cmiti_codigomacro = '@@nombre_producto'

      set @codigo_producto = ltrim(rtrim(@codigo_producto))
      set @nombre_producto = ltrim(rtrim(@nombre_producto))

      declare @cantidad_mail varchar(255)
      select @cantidad_mail = cmiei_valor 
      from ComunidadInternetMailItem cmiei 
              inner join ComunidadInternetTextoItem cmiti 
                on cmiei.cmiti_id = cmiti.cmiti_id
      where cmie_id = @@cmie_id 
        and cmiti_codigomacro = '@@cantidad'

      declare @precio_mail varchar(255)
      select @precio_mail = cmiei_valor 
      from ComunidadInternetMailItem cmiei 
              inner join ComunidadInternetTextoItem cmiti 
                on cmiei.cmiti_id = cmiti.cmiti_id
      where cmie_id = @@cmie_id 
        and cmiti_codigomacro = '@@precio'

      -------------------------------------------------------------
      -- Casos especiales de cada comunidad
      --
      -- El formateo depende de la comunidad asi que aqui resuelvo
      -- todo lo necesario para la interpretacion de valores numericos (cantidad y precio)
      --
      if @@cmi_id = 1 -- 1 es MercadoLibre
      begin
        set @precio_mail = replace(@precio_mail,'$','')
        set @precio_mail = replace(@precio_mail,'c/u.','')
      end

      set @precio_mail = replace(@precio_mail,',','.')

      if isnumeric(@cantidad_mail)<>0 set @cantidad = convert(decimal(18,6),@cantidad_mail)
      else                             set @cantidad = 1

      if isnumeric(@precio_mail)<>0 set @precio = convert(decimal(18,6),@precio_mail)
      else                           set @precio = 0

      -- Obtengo el producto asociado
      --
      select @pr_id             = pr.pr_id, 
             @ti_id_ivariventa   = ti_id_ivariventa
      from Producto pr 
                inner join ProductoComunidadInternet prcmi on pr.pr_id = prcmi.pr_id
      where prcmi.cmi_id = @@cmi_id
        and prcmi_codigo = @codigo_producto

      -- Si no encontre el producto uso el varios asociado a la comunidad
      --
      if @pr_id is null begin

        select @pr_id = pr_id from ComunidadInternet where cmi_id = @@cmi_id
        select @ti_id_ivariventa = ti_id_ivariventa from Producto where pr_id = @pr_id

      end

      select @ti_porcentaje = ti_porcentaje from TasaImpositiva where ti_id = @ti_id_ivariventa

      -- Al precio le saco el iva
      --
      set @precio = @precio / (1 + @ti_porcentaje / 100)

      select @ivari = (@precio * @ti_porcentaje / 100) * @cantidad
      select @neto = @precio * @cantidad

      -----------------------------------------------------------------------
      declare @lp_id int
      declare @ld_id int

      select @lp_id = lp_id, @ld_id = ld_id from ComunidadInternet where cmi_id = @@cmi_id

      if @lp_id is null begin

        declare @cfg_valor varchar(5000)
        exec sp_Cfg_GetValor 'Ventas-General', 'ClientesPVlp_id', @cfg_valor out

        set @cfg_valor = isnull(@cfg_valor,'0')
        if isnumeric(@cfg_valor)<> 0 begin

          set @lp_id = convert(int,@cfg_valor)
          if not exists(select * from ListaPrecio where lp_id = @lp_id and lp_tipo = 1)
            set @lp_id = null

        end
      end
      -----------------------------------------------------------------------
      
      declare @pvTMP_id int
      exec sp_dbgetnewid 'PedidoVentaTMP', 'pvTMP_id', @pvTMP_id out, 0

      insert into PedidoVentaTMP (
                                    pvTMP_id
                                    ,pv_id
                                    ,pv_nrodoc
                                    ,pv_numero
                                    ,pv_fecha
                                    ,pv_fechaentrega
                                    ,pv_descrip
                                    ,pv_descuento1
                                    ,pv_descuento2
                                    ,pv_destinatario
                                    ,pv_importedesc1
                                    ,pv_importedesc2
                                    ,pv_ivari
                                    ,pv_ivarni
                                    ,pv_neto
                                    ,pv_ordencompra
                                    ,pv_subtotal
                                    ,pv_total
                                    ,cam_id
                                    ,cam_id_semi
                                    ,ccos_id
                                    ,chof_id
                                    ,cli_id
                                    ,clis_id
                                    ,cpg_id
                                    ,creado
                                    ,doc_id
                                    ,est_id
                                    ,ld_id
                                    ,lgj_id
                                    ,lp_id
                                    ,modificado
                                    ,modifico
                                    ,pro_id_destino
                                    ,pro_id_origen
                                    ,ram_id_stock
                                    ,suc_id
                                    ,trans_id
                                    ,ven_id
                                    )
                              values (
                                    @pvTMP_id
                                    ,0--pv_id
                                    ,''--pv_nrodoc el talonario asociado al documento debe ser autoimpresor
                                    ,0--pv_numero
                                    ,convert(varchar,getdate(),112)--pv_fecha
                                    ,convert(varchar,getdate(),112)--pv_fechaentrega
                                    -- ,'Generado automaticamente por el servicio de emails de comunidades de internet. Email id: ' + convert(varchar,@@cmie_id) --pv_descrip
                                    ,@pv_descrip
                                    ,0--pv_descuento1
                                    ,0--pv_descuento2
                                    ,''--pv_destinatario
                                    ,0--pv_importedesc1
                                    ,0--pv_importedesc2
                                    ,@ivari--pv_ivari
                                    ,0--pv_ivarni
                                    ,@neto--pv_neto
                                    ,''--pv_ordencompra
                                    ,@neto--pv_subtotal
                                    ,@neto+@ivari--pv_total
                                    ,null--cam_id
                                    ,null--cam_id_semi
                                    ,null--ccos_id
                                    ,null--chof_id
                                    ,@cli_id--cli_id
                                    ,null--clis_id
                                    ,-2--cpg_id fecha del documento
                                    ,getdate()--creado
                                    ,@doc_id--doc_id
                                    ,1--est_id pendiente
                                    ,@ld_id--ld_id
                                    ,null--lgj_id
                                    ,@lp_id--lp_id
                                    ,getdate()--modificado
                                    ,1--modifico Administrador
                                    ,null--pro_id_destino
                                    ,null--pro_id_origen
                                    ,''--ram_id_stock
                                    ,@suc_id--suc_id
                                    ,null--trans_id
                                    ,null--ven_id
                                    )
    
      -- 2 Llenar Items de pedido
    
        -- 2.1 obtener producto
            -- resuelto al calcular el neto del header
      
          -- 2.1.1 si no existe usar varios asociado a comunidad
            -- resuelto al calcular el neto del header

      declare @pviTMP_id int

      exec sp_dbgetnewid 'PedidoVentaItem','pvi_id',@pviTMP_id out, 0

      insert into PedidoVentaItemTMP (
                                              pvTMP_id
                                              ,pviTMP_id
                                              ,pvi_cantidad
                                              ,pvi_cantidadaremitir
                                              ,pvi_descrip
                                              ,pvi_descuento
                                              ,pvi_id
                                              ,pvi_importe
                                              ,pvi_ivari
                                              ,pvi_ivariporc
                                              ,pvi_ivarni
                                              ,pvi_ivarniporc
                                              ,pvi_neto
                                              ,pvi_orden
                                              ,pvi_pendiente
                                              ,pvi_pendientepklst
                                              ,pvi_pendienteprv
                                              ,pvi_precio
                                              ,pvi_precioLista
                                              ,pvi_precioUsr
                                              ,pr_id
                                              ,ccos_id
                                      )
                              values (
                                              @pvTMP_id
                                              ,@pviTMP_id
                                              ,@cantidad
                                              ,@cantidad
                                              ,isnull(@nombre_producto,'') + ' (' + isnull(@codigo_producto,'') + ')'--pvi_descrip
                                              ,0--pvi_descuento
                                              ,0--pvi_id
                                              ,@neto+@ivari--pvi_importe
                                              ,@ivari--pvi_ivari
                                              ,@ti_porcentaje--pvi_ivariporc
                                              ,0--pvi_ivarni
                                              ,0--pvi_ivarniporc
                                              ,@neto--pvi_neto
                                              ,1--pvi_orden
                                              ,0--pvi_pendiente
                                              ,0--pvi_pendientepklst
                                              ,0--pvi_pendienteprv
                                              ,@precio--pvi_precio
                                              ,0--pvi_precioLista
                                              ,@precio--pvi_precioUsr
                                              ,@pr_id--pr_id
                                              ,null--ccos_id
                                      )

      -- 3 Llamar a sp_DocPedidoVentaSave
      declare @bSuccess tinyint 
      exec sp_DocPedidoVentaSave @pvTMP_id, 0, @pv_id out, @bSuccess out
      if @bSuccess <> 0 begin

        update ComunidadInternetMail set pv_id = @pv_id, cli_id = @cli_id where cmie_id = @@cmie_id

        update PedidoVentaItem set pvi_codigocomunidad = isnull(@codigo_producto,'')--pvi_codigocomunidad
        where pv_id = @pv_id


        if @@noSelect = 0 select 1 as result, @pv_id as pv_id

      end else

        if @@noSelect = 0 select 0 as result, 0 as pv_id

      -- 4 Fin

  -----------------------------------------------------------------------------

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

