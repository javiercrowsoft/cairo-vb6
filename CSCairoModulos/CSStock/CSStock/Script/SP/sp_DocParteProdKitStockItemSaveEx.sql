if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocParteProdKitStockItemSaveEx]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocParteProdKitStockItemSaveEx]

/*
 select * from ParteProdKit
 sp_DocParteProdKitStockItemSaveEx 26

*/

go
create procedure sp_DocParteProdKitStockItemSaveEx (
  @@ppkiTMP_id      int,
  @@ppki_id         int,
  @@st_id           int,
  @@sti_orden        int out,
  @@ppki_descrip    varchar(255),
  @@depl_id_origen  int,
  @@depl_id_destino int,

  @@bDesarme        tinyint,

  @@bSuccess         tinyint out,
  @@MsgError        varchar(5000)= '' out
)
as
begin


  set nocount on

  declare @prskTMP_id     int
  declare @prsk_id        int 
  declare @pr_id          int 
  declare @prns_id        int 
  declare @prns_codigo    varchar(100) 
  declare @stl_id          int 
  declare @stl_codigo      varchar(50) 
  declare @prfk_id         int

  declare @prk_id          int
  declare @pr_id_item     int
  declare @prns_id_item   int
  declare @stl_id_item    int
  declare @prski_cantidad  decimal(18,6)


  declare @bIdentidad         tinyint
  declare @bIdentidadXItem    tinyint
  declare @ta_id_serie        int

  declare @bLote               tinyint
  declare @bLoteXItem          tinyint
  declare @ta_id_lote          int

  declare @prns_id_kit        int

  declare @ta_propuesto       tinyint
  declare @ta_tipo            smallint
  declare @ta_numero           varchar(100)

  declare @prns_descrip        varchar(255) 
  declare @prns_fechavto      datetime 
  declare @stl_id_serie        int

  declare @stl_id_kit         int
  declare @last_stl_id_kit    int

  declare @stl_descrip        varchar(255) 
  declare @stl_fechavto        datetime 
  declare @stl_fecha          datetime
  declare @stl_id_padre        int
  declare @pa_id              int

  declare @modifico            int

  declare @sti_id             int
  declare @prski_id           int

  declare @ppkia_id           int
  declare @ppkia_cantidad     decimal(18,6)

  declare @ppki_cantidad      decimal(18,6)

  declare @stik_id             int

  declare @ppk_numero         int
  declare @codigo_aux         varchar(255)

  declare @pr_id_kit          int     -- Los necesito para los items que 
  declare @bLlevaSerie        tinyint -- consumo y son kits
  declare @bIsKit             tinyint --
                                      
  set @prns_descrip =  ''
  
  if @@bDesarme <> 0 begin

    select @ppk_numero = ppk_numero 
    from ParteProdKit ppk 
                inner join ParteProdKitItem ppki 
                            on ppk.ppk_id = ppki.ppk_id
    where ppki_id = @@ppki_id

    set @codigo_aux = ' (D-' + substring('0000000',
                                         1,
                                         7-len(convert(varchar(255),@ppk_numero))
                                        )
                             + convert(varchar(255),@ppk_numero) +')'

  end

  select @modifico = modifico from Stock where st_id = @@st_id

  --////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --
  --  Kits con Identidad
  --
  --
  --////////////////////////////////////////////////////////////////////////////////////////////////////////

  if exists(select prskTMP_id  
            from ProductoSerieKitTMP 
            where ppkiTMP_id = @@ppkiTMP_id) 
  begin

    -- Guardo cada uno de los Kits con identidad
    --
    declare c_prsk insensitive cursor for
  
      select prskTMP_id,
             prsk_id, 
             pr_id, 
             prns_id, 
             prns_codigo, 
             stl_id, 
             stl_codigo, 
             prfk_id 
  
      from ProductoSerieKitTMP where ppkiTMP_id = @@ppkiTMP_id
  
    open c_prsk
  
    fetch next from c_prsk into @prskTMP_id,
                                @prsk_id, 
                                @pr_id, 
                                @prns_id, 
                                @prns_codigo, 
                                @stl_id, 
                                @stl_codigo, 
                                @prfk_id 
  
    while @@fetch_status = 0
    begin
  
  --////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --
  --  ProductoSerieKit
  --
  --
  --////////////////////////////////////////////////////////////////////////////////////////////////////////
  
      select @bIdentidad         = pr_KitIdentidad,
             @bIdentidadXItem    = pr_KitIdentidadXItem,
             @ta_id_serie       = ta_id_kitSerie,
             @bLote             = pr_KitLote,
             @bLoteXItem        = pr_KitLoteXItem,
             @ta_id_lote        = ta_id_kitLote            
  
      from Producto where pr_id = @pr_id
  
    --////////////////////////////////////////////////////////////////////////////////////////////////////////
    --
    --
    --  Identidad
    --
    --
    --////////////////////////////////////////////////////////////////////////////////////////////////////////
  
      --------------------------------------------------
      -- Si es el Movimiento de Producción
      --
      if     (@@bDesarme = 0  and @@depl_id_origen = -2)    -- Produccion
        or  (@@bDesarme <> 0 and @@depl_id_origen <> -2)  -- Desarme
      begin

        -- Si estoy armando un kit
        -- 
        if @@bDesarme = 0 begin

          --   Si el numero de kit sale de un item voy a crear un nuevo prns_id
          --  con el pr_id del kit y con el mismo prns_codigo del item.
          --
          --  Si el ProductoSerieKit ya existe, debo actualizar el prns_codigo
          --  
        
          -- Ya sea insert o update, si la identidad
          -- la da un item la cargo desde la tabla ProductoNumeroSerie
          --
          if @bIdentidadXItem <> 0 begin
  
              select @prns_codigo        = prns_codigo,
                     @prns_descrip       = prns_descrip, 
                     @prns_fechavto      = prns_fechavto, 
                     @stl_id_serie      = stl_id
    
              from ProductoNumeroSerie where prns_id = @prns_id
          end
        
          -- Si es nuevo debo crear el numero de serie
          -- 
          if IsNull(@prsk_id,0) = 0 begin
  
            -- Si la identidad es por talonario
            -- (es decir no es por item)
            --
            if @bIdentidadXItem = 0 begin
  
              -- //////////////////////////////////////////////////////////////////////////////////
              --
              -- Talonario
              --
                
                  exec sp_talonarioNoDocGetPropuesto @ta_id_serie, '', @ta_propuesto out,@ta_tipo out
                  if @@error <> 0 goto ControlError
              
                  if @ta_propuesto = 0 begin
              
                    if @ta_tipo = 3 /*Auto Impresor*/ begin                  
      
                      exec sp_talonarioGetNextNumber @ta_id_serie, @ta_numero out
                      if @@error <> 0 goto ControlError
      
                      -- Con esto evitamos que dos tomen el mismo número
                      --
                      exec sp_TalonarioSet @ta_id_serie, @ta_numero
                      if @@error <> 0 goto ControlError
      
                      set @prns_codigo = @ta_numero
      
                    end
                  
                  end else begin
  
                    if @prns_codigo = '' begin
  
                      exec sp_talonarioGetNextNumber @ta_id_serie, @ta_numero out
                      if @@error <> 0 goto ControlError
      
                      -- Con esto evitamos que dos tomen el mismo número
                      --
                      exec sp_TalonarioSet @ta_id_serie, @ta_numero
                      if @@error <> 0 goto ControlError
      
                      set @prns_codigo = @ta_numero
  
                    end
  
                  end
              --
              -- Fin Talonario
              --
              -- //////////////////////////////////////////////////////////////////////////////////
  
              -- Si es por talonario, no tengo lote, ni descripcion ni otras yerbas
              --
              set @prns_descrip   = ''
              set @prns_fechavto  = '18991230'
              set @stl_id_serie   = null
  
            end
  
            -- Insertamos el nuevo numero de serie
            --  
            exec sp_dbGetNewId 'ProductoNumeroSerie', 'prns_id', @prns_id_kit out, 0
            if @@error <> 0 goto ControlError
  
            insert into ProductoNumeroSerie (
                                             prns_id, 
                                             prns_codigo, 
                                             prns_descrip, 
                                             prns_fechavto, 
                                             pr_id, 
                                             depl_id,
                                             stl_id,
                                             pr_id_kit,
                                             modifico
                                             )
                                      values(
                                             @prns_id_kit, 
                                             @prns_codigo, 
                                             @prns_descrip, 
                                             @prns_fechavto, 
                                             @pr_id, 
                                             @@depl_id_destino,
                                             @stl_id_serie,
                                             @pr_id,                                             
                                             @modifico  
                                             )
            if @@error <> 0 goto ControlError
  
            -- Ok ya estamos listos para insertar un nuevo ProductoSerieKit
            --
            exec sp_dbGetNewId 'ProductoSerieKit', 'prsk_id', @prsk_id out, 0
            if @@error <> 0 goto ControlError
  
            insert into ProductoSerieKit (
                                          ppki_id,
                                          prsk_id,
                                          pr_id,
                                          prns_id,
                                          prfk_id,
                                          stl_id,
                                          modifico
                                          )
                                   values(
                                          @@ppki_id,
                                          @prsk_id,
                                          @pr_id,
                                          @prns_id_kit,
                                          @prfk_id,
                                          null,       -- Si lleva, se actualiza mas abajo
                                          @modifico
                                          )
            if @@error <> 0 goto ControlError

            update ProductoNumeroSerie set prsk_id = @prsk_id  where prns_id = @prns_id_kit
            if @@error <> 0 goto ControlError
  
          -- Si el ProductoSerieKit ya existe
          -- solo actualizo el numero de serie
          --
          end else begin

            -- Borro todos los ProductoSerieKitItem
            -- y los vuelvo a generar
            --
            -- OJO: Esto solo lo hago si estoy armando.
            -- En los partes de desarme NUNCA modifico
            -- la estructura del Kit es decir que las 
            -- tablas ProductoSerieKit y ProductoSerieKitItem
            -- NO se tocan, excepto para actualizar el ppki_id_desarme 
            -- del ProductoSerieKit
            --
            delete ProductoSerieKitItem where prsk_id = @prsk_id
            if @@error <> 0 goto ControlError
  
            -- Obtengo el id del numero de serie asociado al ProductoSerieKit
            --
            select @prns_id_kit = prns_id from ProductoSerieKit where prsk_id = @prsk_id
  
            -- Si no tengo identidad por item
            -- es decir sale de un talonario
            --
            if @bIdentidadXItem = 0 begin
  
                exec sp_talonarioNoDocGetPropuesto @ta_id_serie, '', @ta_propuesto out,@ta_tipo out
                if @@error <> 0 goto ControlError
            
                -- Solo puede haber modificaciones si el talonario es propuesto
                --
                if @ta_propuesto <> 0 begin
  
                  -- Solo se modifica el codigo del numero de serie
                  --
                  update ProductoNumeroSerie set prns_codigo = @prns_codigo, 
                                                 modifico    = @modifico,
                                                  depl_id     = @@depl_id_destino
                  where prns_id = @prns_id_kit
                  if @@error <> 0 goto ControlError
                end
  
            -- Si la identidad es por item
            --
            end else begin
  
              -- Actualizamos al nuevo estado del numero de serie que
              -- nos da la identidad de este kit
              --
              update ProductoNumeroSerie set prns_codigo     = @prns_codigo,
                                             prns_descrip   = @prns_descrip, 
                                             prns_fechavto  = @prns_fechavto, 
                                             stl_id          = @stl_id_serie,
                                             modifico        = @modifico,
                                             depl_id        = @@depl_id_destino
              where prns_id = @prns_id_kit
              if @@error <> 0 goto ControlError
  
            end  

          end
  
          --////////////////////////////////////////////////////////////////////////////////////////////////////////
          --
          --
          --  Lote
          --
          --
          --////////////////////////////////////////////////////////////////////////////////////////////////////////
  
          if @bLote <> 0 begin
  
            --   Si el lote del kit sale de un item voy a crear un nuevo stl_id
            --  con el pr_id del kit y con el mismo stl_codigo del item.
            --
            --  Si el lote ya existe, debo actualizar el stl_codigo
            --  
            
            -- Ya sea insert o update, si el Lote
            -- lo da un item lo cargo desde la tabla StockLote
            --
            if @bLoteXItem <> 0 begin
    
                select @stl_codigo        = stl_codigo,
                       @stl_descrip       = stl_descrip, 
                       @stl_fecha         = stl_fecha,
                       @stl_fechavto      = stl_fechavto,
                       @stl_id_padre      = stl_id_padre,
                       @pa_id              = pa_id
      
                from StockLote where stl_id = @stl_id
            end
            
            -- En este punto, siempre existe el ProductoSerieKit, ya sea nuevo o no, por
            -- que ya lo cree mas arriba si fue necesario, por esta razon, busco el lote
            -- en la tabla ProductoSerieKit, ya que si lo cree recien, va a estar en null
            -- y si es un update, tengo que actualziar el lote y no insertar uno nuevo
            -- 
            select @stl_id_kit = stl_id from ProductoSerieKit where prsk_id = @prsk_id
    
            -- Si no tengo lote, me aseguro que no exista ya uno con el mismo codigo
            -- y mismo producto
            --
            if @stl_id_kit is null begin
    
              -- Si no existe un lote con este codigo y el pr_id
              -- del Kit, debo crear un lote nuevo
              -- 
              select @stl_id_kit = @stl_id from StockLote where stl_codigo = @stl_codigo and pr_id = @pr_id        
    
            end

            -- Creo un solo lote por cada ppki_id
            --
            if @stl_id_kit is null and @bLoteXItem = 0 begin

              set @stl_id_kit = @last_stl_id_kit

            end
    
            if @stl_id_kit is null begin
    
              -- Si el Lote es por talonario
              -- (es decir no es por item)
              --
              if @bLoteXItem = 0 begin
    
                -- //////////////////////////////////////////////////////////////////////////////////
                --
                -- Talonario
                --
                  
                    exec sp_talonarioNoDocGetPropuesto @ta_id_lote, '', @ta_propuesto out, @ta_tipo out
                    if @@error <> 0 goto ControlError
                
                    if @ta_propuesto = 0 begin
                
                      if @ta_tipo = 3 /*Auto Impresor*/ begin                  
        
                        exec sp_talonarioGetNextNumber @ta_id_lote, @ta_numero out
                        if @@error <> 0 goto ControlError
        
                        -- Con esto evitamos que dos tomen el mismo número
                        --
                        exec sp_TalonarioSet @ta_id_lote, @ta_numero
                        if @@error <> 0 goto ControlError
        
                        set @stl_codigo = @ta_numero
        
                      end
                    
                    end else begin
    
                      if @stl_codigo = '' begin
    
                        exec sp_talonarioGetNextNumber @ta_id_lote, @ta_numero out
                        if @@error <> 0 goto ControlError
        
                        -- Con esto evitamos que dos tomen el mismo número
                        --
                        exec sp_TalonarioSet @ta_id_lote, @ta_numero
                        if @@error <> 0 goto ControlError
        
                        set @stl_codigo = @ta_numero
    
                      end
    
                    end
                --
                -- Fin Talonario
                --
                -- //////////////////////////////////////////////////////////////////////////////////
    
                -- Si es por talonario, no tengo lote, ni descripcion ni otras yerbas
                --
                set @stl_descrip   = ''
                set @stl_fecha     = getdate()
                set @stl_fechavto  = '18991230'
                set @stl_id_padre   = null
                set @pa_id         = null
    
              end
    
              -- Insertamos el nuevo Lote
              --  
              exec sp_dbGetNewId 'StockLote', 'stl_id', @stl_id_kit out, 0
              if @@error <> 0 goto ControlError
    
              insert into StockLote (
                                               stl_id, 
                                               stl_codigo, 
                                               stl_nroLote,  
                                               stl_descrip, 
                                               stl_fecha,
                                               stl_fechavto, 
                                               pr_id, 
                                               stl_id_padre,
                                               pa_id,
                                               modifico
                                               )
                                        values(
                                               @stl_id_kit, 
                                               @stl_codigo, 
                                               @stl_codigo, 
                                               @stl_descrip, 
                                               @stl_fecha, 
                                               @stl_fechavto, 
                                               @pr_id, 
                                               @stl_id_padre,
                                               @pa_id,
                                               @modifico  
                                               )
              if @@error <> 0 goto ControlError

              set @last_stl_id_kit = @stl_id_kit
    
            -- Si el ProductoSerieKit ya existe
            -- solo actualizo el numero de lote
            --
            end else begin
    
              -- Si no tengo Lote por item
              -- es decir sale de un talonario
              --
              if @bLoteXItem = 0 begin
    
                  exec sp_talonarioNoDocGetPropuesto @ta_id_lote, '', @ta_propuesto out,@ta_tipo out
                  if @@error <> 0 goto ControlError
              
                  -- Solo puede haber modificaciones si el talonario es propuesto
                  --
                  if @ta_propuesto <> 0 begin
    
                    -- Solo se modifica el codigo del numero de lote
                    --
                    update StockLote set stl_codigo = @stl_codigo, 
                                         modifico   = @modifico
                    where stl_id = @stl_id_kit
                    if @@error <> 0 goto ControlError
                  end
    
              -- Si el Lote es por item
              --
              end else begin
    
                -- Actualizamos al nuevo estado del Lote que
                -- nos da el Lote de este kit
                --
                update StockLote set stl_codigo     = @stl_codigo,
                                     stl_descrip     = @stl_descrip, 
                                     stl_fecha      = @stl_fecha, 
                                     stl_fechavto    = @stl_fechavto, 
                                     stl_id_padre    = @stl_id_padre,
                                     pa_id          = @pa_id,
                                     modifico        = @modifico
                where stl_id = @stl_id_kit
                if @@error <> 0 goto ControlError
    
              end  
            end

            -- Actualizamos el lote del numero de serie de este kit
            --
            update ProductoNumeroSerie set stl_id  = @stl_id_kit
            where prns_id = @prns_id_kit
            if @@error <> 0 goto ControlError

          end
  
          --////////////////////////////////////////////////////////////////////////////////////////////////////////
          --
          --
          --  Stock Lote
          --
          --
          --////////////////////////////////////////////////////////////////////////////////////////////////////////
  
          -----------------------------
          -- Identidad
          --
  
          exec SP_DBGetNewId 'StockItemKit','stik_id',@stik_id out, 0

          insert into StockItemKit (stik_id,stik_cantidad,pr_id,st_id,stik_llevanroserie)
                          values   (@stik_id,1,@pr_id,@@st_id,1)
          if @@error <> 0 goto ControlError

          exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
          if @@error <> 0 goto ControlError
    
          insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip, 
                                 pr_id, depl_id, prns_id, stl_id, prsk_id, pr_id_kit,
                                 sti_grupo, stik_id)
                          values(@@st_id, @sti_id, @@sti_orden, 0, 1, @prns_descrip, 
                                 @pr_id, @@depl_id_origen, @prns_id_kit, @stl_id_kit, @prsk_id, @pr_id, 
                                 (@pr_id * 1000) + @@ppki_id + @stik_id, @stik_id)
          if @@error <> 0 goto ControlError
    
          set @@sti_orden = @@sti_orden + 1
    
          exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
          if @@error <> 0 goto ControlError
    
          insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip,
                                 pr_id, depl_id, prns_id, stl_id, prsk_id, pr_id_kit, 
                                 sti_grupo, stik_id)
                          values(@@st_id, @sti_id, @@sti_orden, 1, 0, @prns_descrip, 
                                 @pr_id, @@depl_id_destino, @prns_id_kit, @stl_id_kit, @prsk_id, @pr_id,
                                 (@pr_id * 1000) + @@ppki_id + @stik_id, @stik_id)
          if @@error <> 0 goto ControlError
    
          set @@sti_orden = @@sti_orden + 1
          
        end 
        
        -- Si estoy desarmando el kit
        --
        else begin
        
          -- Tengo que enviar el número de serie del kit
          -- (el que le da la identidad) al deposito interno
          -- y liberar todos los numeros de serie y demas
          -- insumos (lotes, alternativas, etc.), sacandolos
          -- de interno y dejandolos en el deposito origen
          --
          
          -- TODO: cargar variables: @prns_descrip @pr_id @prns_id_kit stl_id_kit
          --       este no puede estar vacio @prsk_id (debemos obtenerlo a travez del prns_id de ProductoSerieKitTMP)

          set @prns_id_kit = @prns_id

          select @prsk_id = prsk_id, @stl_id_kit = stl_id, @pr_id = pr_id 
          from ProductoSerieKit 
          where prns_id = @prns_id_kit

          select @prns_codigo   = prns_codigo,
                 @prns_descrip   = prns_descrip

          from ProductoNumeroSerie
          where prns_id = @prns_id_kit

          set @prns_codigo = replace(@prns_codigo,@codigo_aux,'')
          set @prns_codigo = @prns_codigo+@codigo_aux

          update ProductoNumeroSerie 
                  set prns_codigo = @prns_codigo 
          where prns_id = @prns_id_kit
          if @@error <> 0 goto ControlError

          update ProductoSerieKit 
                  set ppki_id_desarme = @@ppki_id 
          where prsk_id = @prsk_id
          if @@error <> 0 goto ControlError

          exec SP_DBGetNewId 'StockItemKit','stik_id',@stik_id out, 0

          insert into StockItemKit (stik_id,stik_cantidad,pr_id,st_id,stik_llevanroserie)
                          values   (@stik_id,1,@pr_id,@@st_id,1)
          if @@error <> 0 goto ControlError

          exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
          if @@error <> 0 goto ControlError
    
          insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip, 
                                 pr_id, depl_id, prns_id, stl_id, prsk_id, pr_id_kit,
                                 sti_grupo, stik_id)
                          values(@@st_id, @sti_id, @@sti_orden, 0, 1, @prns_descrip, 
                                 @pr_id, @@depl_id_origen, @prns_id_kit, @stl_id_kit, @prsk_id, @pr_id, 
                                 (@pr_id * 1000) + @@ppki_id + @stik_id, @stik_id)
          if @@error <> 0 goto ControlError
    
          set @@sti_orden = @@sti_orden + 1
    
          exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
          if @@error <> 0 goto ControlError
    
          insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip,
                                 pr_id, depl_id, prns_id, stl_id, prsk_id, pr_id_kit, 
                                 sti_grupo, stik_id)
                          values(@@st_id, @sti_id, @@sti_orden, 1, 0, @prns_descrip, 
                                 @pr_id, @@depl_id_destino, @prns_id_kit, @stl_id_kit, @prsk_id, @pr_id, 
                                 (@pr_id * 1000) + @@ppki_id + @stik_id, @stik_id)
          if @@error <> 0 goto ControlError
    
          set @@sti_orden = @@sti_orden + 1          
        
        end
        
      end  
      --
      -- Fin Movimiento de Producción
      --------------------------------------------------

--////////////////////////////////////////////////////////////////////////////////////////////////////////
--
--
--  ProductoSerieKitItem
--
--
--////////////////////////////////////////////////////////////////////////////////////////////////////////


      -- Si estoy armando un kit, los items del 
      -- ProductoSerieKit salen de ProductoSerieKitItemTMP
      -- ya se nuevo o modificado
      -- 
      if @@bDesarme = 0 begin

        declare c_prskItem insensitive cursor for
  
          select   prk_id,
                  pr_id,
                  prns_id,
                  stl_id,
                  prski_cantidad
              
          from ProductoSerieKitItemTMP 
          where prskTMP_id = @prskTMP_id
          
      end 
      
      -- Si estoy desarmando sale todo del ProductoSerieKit
      -- que se desarma, es decir de ProductoSerieKitItem
      --
      else begin

        select @prsk_id = prsk_id
        from ProductoSerieKit
        where prns_id = @prns_id
      
        declare c_prskItem insensitive cursor for
  
          select   prk_id,
                  pr_id,
                  prns_id,
                  stl_id,
                  prski_cantidad
              
          from ProductoSerieKitItem
          where prsk_id = @prsk_id

      end
  
      open c_prskItem
  
      fetch next from c_prskItem into @prk_id,
                                      @pr_id_item,
                                      @prns_id_item,
                                      @stl_id_item,
                                      @prski_cantidad
  
      while @@fetch_status=0
      begin

        --------------------------------------------------
        -- Si es el Movimiento de Producción
        --
        if     (@@bDesarme = 0  and @@depl_id_origen = -2)    -- Produccion
          or  (@@bDesarme <> 0 and @@depl_id_origen <> -2)  -- Desarme
        begin

          -- Si estoy armando un kit
          -- 
          if @@bDesarme = 0 begin

            ---------------------------
            -- ProducoSerieKitItem
            --
  
            exec sp_dbGetNewId 'ProductoSerieKitItem', 'prski_id', @prski_id out, 0
            if @@error <> 0 goto ControlError
  
            insert into ProductoSerieKitItem (prsk_id,
                                              prski_id,
                                              prski_cantidad,
                                              prk_id,
                                              pr_id,
                                              prns_id,
                                              stl_id
                                             ) 
                                      values (
                                              @prsk_id,
                                              @prski_id,
                                              @prski_cantidad,
                                              @prk_id,
                                              @pr_id_item,
                                              @prns_id_item,
                                              @stl_id_item
                                             )
          end

        end 
        --
        -- Fin Movimiento de Producción
        --------------------------------------------------

        --------------------------------------------------
        -- Si es el Movimiento de Consumo
        --
        else begin

          ---------------------------
          -- Stock
          --

          select   @bIsKit       = pr_esKit,
                  @bLlevaSerie  = pr_llevanroserie
          from Producto where pr_id = @pr_id_item

          if @bIsKit <> 0 begin

            exec SP_DBGetNewId 'StockItemKit','stik_id',@stik_id out, 0
  
            insert into StockItemKit (stik_id,stik_cantidad,pr_id,st_id,stik_llevanroserie)
                            values   (@stik_id,1,@pr_id_item,@@st_id,@bLlevaSerie)
            if @@error <> 0 goto ControlError

            set @pr_id_kit = @pr_id_item

          end else begin

            set @stik_id     = null
            set @pr_id_kit   = null

          end

          if @prns_id_item is not null and @stl_id_item is null begin
      
            select @stl_id_item = stl_id from ProductoNumeroSerie where prns_id = @prns_id_item
      
          end
  
          exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
          if @@error <> 0 goto ControlError
      
          insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip, 
                                 pr_id, depl_id, prns_id, stl_id, sti_grupo, stik_id, pr_id_kit)
                          values(@@st_id, @sti_id, @@sti_orden, 0, @prski_cantidad, '', 
                                 @pr_id_item, @@depl_id_origen, @prns_id_item, @stl_id_item, 
                                 (@pr_id_item * 1000) + @@ppki_id + isnull(@stik_id,0),@stik_id, @pr_id_kit)
          if @@error <> 0 goto ControlError
      
          set @@sti_orden = @@sti_orden + 1
      
          exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
          if @@error <> 0 goto ControlError
      
          insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip,
                                 pr_id, depl_id, prns_id, stl_id, sti_grupo, stik_id, pr_id_kit)
                          values(@@st_id, @sti_id, @@sti_orden, @prski_cantidad, 0, '', 
                                 @pr_id_item, @@depl_id_destino, @prns_id_item, @stl_id_item, 
                                 (@pr_id_item * 1000) + @@ppki_id + isnull(@stik_id,0), @stik_id, @pr_id_kit)
          if @@error <> 0 goto ControlError
      
          set @@sti_orden = @@sti_orden + 1

          -- 
          -- Fin
          ---------------------------

        end

        --
        -- Fin Movimiento de Consumo
        --------------------------------------------------


        fetch next from c_prskItem into @prk_id,
                                        @pr_id_item,
                                        @prns_id_item,
                                        @stl_id_item,
                                        @prski_cantidad
      end
  
      close c_prskItem
      deallocate c_prskItem
  
  --////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --
  --  Fin ProductoSerieKitItem
  --
  --
  --////////////////////////////////////////////////////////////////////////////////////////////////////////
  
      fetch next from c_prsk into @prskTMP_id,
                                  @prsk_id, 
                                  @pr_id, 
                                  @prns_id, 
                                  @prns_codigo, 
                                  @stl_id, 
                                  @stl_codigo, 
                                  @prfk_id 
  
  
    end
  
    close c_prsk
    deallocate c_prsk

  end

  --////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --
  --  Fin ProductoSerieKit (es decir Kits con Identidad)
  --
  --
  --////////////////////////////////////////////////////////////////////////////////////////////////////////


  --////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --
  --  Alternativas y Kits Resumidos sin Identidad
  --
  --
  --////////////////////////////////////////////////////////////////////////////////////////////////////////

  else begin

    --////////////////////////////////////////////////////////////////////////////////////////////////////////
    --
    --
    --  Kits resumidos sin Identidad
    --
    --
    --////////////////////////////////////////////////////////////////////////////////////////////////////////

    --------------------------------------------------
    -- Si es el Movimiento de Produccion
    --
    if     (@@bDesarme = 0  and @@depl_id_origen = -2)    -- Produccion
      or  (@@bDesarme <> 0 and @@depl_id_origen <> -2)  -- Desarme
    begin

        select @pr_id         = pr_id, 
               @ppki_cantidad = ppki_cantidad 

        from ParteProdKitItem 
        where ppki_id = @@ppki_id

        --------------------------------------------------------------------------------------------
        -- Creo el StockItemKit

        -- Si el deposito destino es produccion es por que estoy consumiendo los componentes del kit
        -- por lo tanto el StockItemKit lo genero por cada item del kit que lleve nro de serie. Esto
        -- lo hacen los sp sp_DocParteProdKitSaveNroSerie y sp_DocParteProdKitStockItemSave.
        -- Aca solo genero StockItemKit cuando el deposito no es produccion o sea que estoy
        -- dando de alta el nuevo kit.
        --
        -- Si se trata de un desarme es a la inversa
        --
      
        exec SP_DBGetNewId 'StockItemKit','stik_id',@stik_id out, 0
    
        -- Este es el StockItemKit asociado al Kit que estamos produciendo o sea @@pr_id
        --
        insert into StockItemKit (stik_id,stik_cantidad,pr_id,st_id,stik_llevanroserie)
                        values   (@stik_id,@ppki_cantidad,@pr_id,@@st_id,0)

        -- Fin StockItemKit
        ---------------------------

        ---------------------------
        -- Stock
        --

        exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
        if @@error <> 0 goto ControlError
    
        insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip, 
                               pr_id, depl_id, prns_id, stl_id, pr_id_kit,stik_id)
                        values(@@st_id, @sti_id, @@sti_orden, 0, @ppki_cantidad, '', 
                               @pr_id, @@depl_id_origen, null, null, @pr_id,@stik_id)
        if @@error <> 0 goto ControlError
    
        set @@sti_orden = @@sti_orden + 1
    
        exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
        if @@error <> 0 goto ControlError
    
        insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip,
                               pr_id, depl_id, prns_id, stl_id, pr_id_kit,stik_id)
                        values(@@st_id, @sti_id, @@sti_orden, @ppki_cantidad, 0, '', 
                               @pr_id, @@depl_id_destino, null, null, @pr_id,@stik_id)
        if @@error <> 0 goto ControlError
    
        set @@sti_orden = @@sti_orden + 1

    --////////////////////////////////////////////////////////////////////////////////////////////////////////
    --
    --
    --  Fin Kits resumidos sin Identidad
    --
    --
    --////////////////////////////////////////////////////////////////////////////////////////////////////////

    end else begin

    --////////////////////////////////////////////////////////////////////////////////////////////////////////
    --
    --
    --  Alternativas sin Identidad
    --
    --
    --////////////////////////////////////////////////////////////////////////////////////////////////////////

      delete ParteProdKitItemA where ppki_id = @@ppki_id
      if @@error <> 0 goto ControlError

      declare c_ppkia insensitive cursor for 

          select pr_id, ppkia_cantidad, prk_id from ParteProdKitItemATMP where ppkiTMP_id = @@ppkiTMP_id

      open c_ppkia

      fetch next from c_ppkia into @pr_id, @ppkia_cantidad, @prk_id
      while @@fetch_status = 0
      begin

        -- Insertamos la nueva alternativa
        --  
        exec sp_dbGetNewId 'ParteProdKitItemA', 'ppkia_id', @ppkia_id out, 0
        if @@error <> 0 goto ControlError
        
        insert into ParteProdKitItemA (ppki_id, ppkia_id, ppkia_cantidad, pr_id, prk_id) 
                                values(@@ppki_id, @ppkia_id, @ppkia_cantidad, @pr_id, @prk_id)
        if @@error <> 0 goto ControlError


        ---------------------------
        -- Stock
        --

        exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
        if @@error <> 0 goto ControlError
    
        insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip, 
                               pr_id, depl_id, prns_id, stl_id)
                        values(@@st_id, @sti_id, @@sti_orden, 0, @ppkia_cantidad, '', 
                               @pr_id, @@depl_id_origen, null, null)
        if @@error <> 0 goto ControlError
    
        set @@sti_orden = @@sti_orden + 1
    
        exec SP_DBGetNewId 'StockItem','sti_id',@sti_id out, 0
        if @@error <> 0 goto ControlError
    
        insert into StockItem (st_id, sti_id, sti_orden, sti_ingreso, sti_salida, sti_descrip,
                               pr_id, depl_id, prns_id, stl_id)
                        values(@@st_id, @sti_id, @@sti_orden, @ppkia_cantidad, 0, '', 
                               @pr_id, @@depl_id_destino, null, null)
        if @@error <> 0 goto ControlError
    
        set @@sti_orden = @@sti_orden + 1

        -- 
        -- Fin
        ---------------------------

        fetch next from c_ppkia into @pr_id, @ppkia_cantidad, @prk_id
      end

      close c_ppkia
      deallocate c_ppkia

    end

    --////////////////////////////////////////////////////////////////////////////////////////////////////////
    --
    --
    --  Fin Alternativas sin Identidad
    --
    --
    --////////////////////////////////////////////////////////////////////////////////////////////////////////

  end

  --////////////////////////////////////////////////////////////////////////////////////////////////////////
  --
  --
  --  Fin Alternativas y Kits Resumidos sin Identidad
  --
  --
  --////////////////////////////////////////////////////////////////////////////////////////////////////////

  set @@bSuccess = 1
  return

ControlError:
  set @@MsgError = 'Ha ocurrido un error al grabar el item de stock del recuento de stock. sp_DocParteProdKitSaveNroSerie.'

Validate:

  set @@bSuccess = 0

end
go

