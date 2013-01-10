if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LpGetPrecio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LpGetPrecio]

go
/*

sp_lpGetPrecio 48,13,0,1,1,0,0,1,0

*/
create Procedure sp_LpGetPrecio(
  @@lp_id         int,
  @@pr_id         int,
  @@precio         decimal(18,6) = 0 out,
  @@select        tinyint = 0,
  @@bCreateTable  tinyint = 1,
  @@lp_id_padre   int = 0,
  @@n             tinyint = 0,
  @@bNoUseCache   tinyint = 0,
  @@lp_id_lpc      int = 0,        -- Este Id de lista de precios
                                  -- se utiliza para dar prioridad a la lista
                                  -- base definida en la ListaPrecioConfig

  @@bIsForCompra  tinyint = 0
)
as
begin

  set nocount on

  declare @lpi_porcentaje decimal(18,6)
  declare @lp_porcglobal  decimal(18,6)
  declare @precio         decimal(18,6)
  declare @lp_id           int

  declare @mon_id         int
  declare @mon_id_base    int
  declare @mon_default    tinyint
  declare @lp_porcentaje  decimal(18,6)

  declare @lp_enCache     tinyint
  declare @cfg_valor       varchar(5000) 

  select   @mon_id         = mon_id, 
          @lp_porcentaje   = lp_porcentaje,
          @lp_enCache      = lp_encache

  from ListaPrecio 
  where lp_id = @@lp_id
    and activo <> 0

  declare @cotiz    decimal(18,6)
  declare @cotiz2   decimal(18,6)

  declare @lpm_id          int    -- lpm_id mencionado en la solapa precios de una lista hija
  declare @lpm_id_lista   int    -- lmp_id mencionado en la solapa general de una lista hija
  declare @lpm_id_precio  int    -- lpm_id mencionado en la solapa precios de la misma lista 
                                -- que estoy procesando

  declare @fecha  datetime
  set @fecha = getdate()


  -- Si es la primera llamada a la lista
  -- analizo el uso de ListaPrecioConfig
  --
  declare @bCheckListaPrecioConfig tinyint
  
  if @@n = 0 set @bCheckListaPrecioConfig = 1
  else        set @bCheckListaPrecioConfig = 0

  -- Si es la primera llamada compruebo si se trata de una lista de compras
  --
  if @@n = 0 begin
    if exists (select * from ListaPrecio where lp_id = @@lp_id and lp_tipo = 2)
      set @@bIsForCompra = 1
  end

  set @@n = @@n + 1

  -- Si la lista no existe devuelvo precio 0
  --
  if @@lp_id is null begin

    set @precio = 0

  end else begin

    -- Si la lista no existe devuelvo precio 0
    --
    if not exists (select lp_id from listaprecio where lp_id = @@lp_id and activo <> 0) begin

      set @precio = 0

    end else begin

      declare @bFromCache tinyint
    
      set @bFromCache = 0
    
      if @@bNoUseCache = 0 begin
    
        if @lp_enCache <> 0 begin

          declare @bCacheActivo int

          -- Veo si el cache esta activo
          --
          exec sp_Cfg_GetValor  'Ventas-General',
                                'Utilizar Cache de Precios',
                                @cfg_valor out,
                                0

          if isnumeric(@cfg_valor)=0 set @bCacheActivo = 0
          else                        set @bCacheActivo = convert(int,@cfg_valor)
    
          if @bCacheActivo <> 0 begin

            set @bFromCache = 1
      
            select @precio = IsNull(lpp_precio,0)
            from ListaPrecioPrecio 
            where pr_id = @@pr_id 
              and lp_id = @@lp_id
          end
        end
      end

      if @bFromCache = 0 begin

        -- Si es la primera llamada a la lista
        -- analizo el uso de ListaPrecioConfig
        --
        if @bCheckListaPrecioConfig<>0 begin

          -- Solo si la lista principal no tiene un precio fijo
          --
          if not exists(select * from ListaPrecioItem where lp_id = @@lp_id and pr_id = @@pr_id)
          begin
  
            -- Si existen listas definidas para este producto
            --
            if exists(select * from ListaPrecioConfig where pr_id = @@pr_id) begin
  
              -- Si existen precios en las listas definidas para este producto
              --
              if exists(select * 
                        from ListaPrecioItem lpi
                        where pr_id = @@pr_id 
                          and exists( select * 
                                      from ListaPrecioConfig 
                                      where pr_id = @@pr_id 
                                        and lp_id = lpi.lp_id
                                    )
                      ) 
              begin

                -- Cargo en una temporal todas las listas
                -- (la principal y todo sus ancestros)
                --
                    declare @k int
                    create table #listas_padre(lp_id int, k int)
      
                    -- La lista principal
                    --
                    insert #listas_padre(lp_id, k) 
                    values(@@lp_id, 0)
                    
                    set @k=1
      
                    -- La lista padre de la principal (viejo esquema)
                    --
                    insert #listas_padre(lp_id, k) 
                    select lp_id_padre, @k
                    from ListaPrecio
                    where lp_id = @@lp_id
                      and lp_id_padre is not null
      
                    -- Las listas padre de la principal (nuevo viejo esquema)
                    --
                    insert #listas_padre(lp_id, k) 
                    select lp_id_padre, @k
                    from ListaPrecioLista lp
                    where lp_id = @@lp_id
                      and lp_id_padre is not null
                      and not exists(select * from #listas_padre where lp_id = lp.lp_id_padre)
      
                    -- Obtengo las listas padres de esta lista
                    -- y compruebo si existe al menos una lista padre
                    -- asociada al producto y asociada a la lista
                    --
                    while exists(  select * 
                                  from ListaPrecioLista lp 
                                        inner join #listas_padre p 
                                          on  lp.lp_id = p.lp_id 
                                          and p.k = @k
                                )
                    begin

                      -- La lista padre de los padres (viejo esquema)
                      --
                      insert #listas_padre(lp_id, k) 
                      select lp_id_padre, @k+1
                      from ListaPrecio lp 
                            inner join #listas_padre p
                              on  lp.lp_id = p.lp_id
                              and p.k = @k
                      where lp_id_padre is not null
                        and not exists(select * from #listas_padre where lp_id = lp.lp_id_padre)
      
                      -- Las listas padre de los padres (nuevo viejo esquema)
                      --
                      insert #listas_padre(lp_id, k) 
                      select lp_id_padre, @k+1
                      from ListaPrecioLista lp
                            inner join #listas_padre p
                              on  lp.lp_id = p.lp_id
                              and p.k = @k
                      where lp_id_padre is not null
                        and not exists(select * from #listas_padre where lp_id = lp.lp_id_padre)

                      set @k = @k +1

                    end  
                -- Fin
                -- Cargo en una temporal todas las listas
                -- (la principal y todo sus ancestros)

                -- Ahora verifico que almenos una de estas listas
                -- asociadas al producto en ListaPrecioConfig
                -- tambien este asociada a la lista principal
                -- o a uno  de sus ancestros
                --
  
                  -- Si existen precios en las listas definidas para este producto
                  --
                  if exists(select * 
                            from ListaPrecioItem lpi
                            where pr_id = @@pr_id 
                              and exists( select * 
                                          from ListaPrecioConfig lpc 
                                                inner join #listas_padre p
                                                  on lpc.lp_id = p.lp_id
                                          where pr_id = @@pr_id 
                                            and lpc.lp_id = lpi.lp_id
                                        )
                          ) 
                  begin
  
                    declare @lpc_orden int

                    select @lpc_orden = min(lpc_orden)
                    from ListaPrecioConfig lpc
                          inner join #listas_padre p
                            on lpc.lp_id = p.lp_id
                    where pr_id = @@pr_id 
                      and exists( select * 
                                  from ListaPrecioItem lpi
                                  where pr_id = @@pr_id 
                                    and lp_id = lpc.lp_id
                                )
  
                    select @@lp_id_lpc = lp_id
                    from ListaPrecioConfig i
                    where pr_id = @@pr_id 
                      and lpc_orden = @lpc_orden

                    set @@lp_id_lpc = isnull(@@lp_id_lpc,0)
                  end

              end
  
            end

          end
          -- Fin
          -- Si no hay precios fijos en la lista principal
          --

        end
        -- Fin
        -- ListaPrecioConfig
        --

        -- Busco un precio en esta lista
        --
        select 
                @precio         = lpi_precio,
                @lpm_id_precio  = lpm_id
        from 
                ListaPrecioItem 
        where 
                lp_id   = @@lp_id
          and    pr_id   = @@pr_id
          and   (lp_id  = @@lp_id_lpc or @@lp_id_lpc = 0)

        -- Si tengo una lista de marcado
        --
        if IsNull(@precio,0) <> 0 and @lpm_id_precio is not null and @@bIsForCompra = 0 begin

          exec sp_LpGetPrecioMarcado @lpm_id_precio, @mon_id, @precio out          

        end

        -- Sino hay precio
        --
        if IsNull(@precio,0) = 0 begin
  
          -- Si es la primear llamada creo las tablas
          --
          if @@bCreateTable <> 0 begin
            
            create table #Precios(
                                  lpi_precio        decimal(18,6), 
                                  lpi_porcentaje    decimal(18,6),
                                  lp_id_padre       int,
                                  lp_id             int,
                                  lpm_id            int
                                 )
        
            create table #Listas(
                                 lp_id           int not null, 
                                 lp_porcglobal   decimal(18,6), 
                                 n               tinyint, 
                                 mon_id         int,
                                 lpm_id          int
                                )
        
            set @@bCreateTable = 0
          end
  
          -- Inserto el porcentaje si lo hay
          -- sobre este articulo
          --
          insert into #Precios (lpi_precio, lpi_porcentaje, lp_id_padre, lp_id, lpm_id)
          select 
                  0,
                  lpi_porcentaje,
                  @@lp_id_padre,
                  @@lp_id,
                  lpm_id    
          from 
                  ListaPrecioItem
          where 
                  lp_id   = @@lp_id
            and    pr_id   = @@pr_id
  
          -------------------------------------------------------------------------------
          -- Inserto todas las listas bases de esta lista    
          --
          -- viejo esquema
          --
          insert into #Listas (lp_id, lp_porcglobal, n, mon_id)
  
          select   lp_id, 
                  @lp_porcentaje,
                  @@n,
                  mon_id 
  
          from ListaPrecio lp
          where exists(select * from ListaPrecio 
                       where lp_id = @@lp_id 
                         and lp_id_padre = lp.lp_id
                      )
            and activo <> 0
      
          -- nuevo esquema
          --
          insert into #Listas (lp_id, lp_porcglobal, n, mon_id, lpm_id)
  
          select lpl.lp_id_padre, 
                 lpl.lpl_porcentaje,
                 @@n, 
                 lp.mon_id,
                 lpl.lpm_id
  
          from ListaPrecioLista lpl inner join ListaPrecio lp on lpl.lp_id_padre = lp.lp_id
          where lpl.lp_id = @@lp_id
            and lp.activo <> 0
          -------------------------------------------------------------------------------
  
          -- Recorro cada lista base buscando un precio
          --    
          while exists(select * from #Listas where n = @@n) begin
  
            set @lpm_id         = null
            set @lpm_id_lista   = null
            set @mon_id_base    = null
            set @lpi_porcentaje = 0
            set @lp_porcglobal  = 0          
  
            -- Obtengo la primera lista base
            --
            select @lp_id = min(lp_id) from #Listas where n = @@n
  
            -- obtengo el porcentaje global y el porcentaje sobre articulo para esta lista base
            --
            select @lpi_porcentaje = lpi_porcentaje,
                   @lpm_id         = lpm_id
            from #Precios where lp_id = @@lp_id
            
            select @lp_porcglobal  = lp_porcglobal,
                   @mon_id_base     = mon_id,
                   @lpm_id_lista   = lpm_id
            from #Listas  where lp_id = @lp_id
  
            -- La saco de la bolsa de listas pendientes
            --
            delete #Listas where lp_id = @lp_id
            
            -- La lista me devuelve el precio
            --
            --                  -- La lista base
            --                                                      -- La lista en la que estoy parado 
            exec sp_LpGetPrecio @lp_id, @@pr_id, @precio out, 0, 0, @@lp_id, @@n, @@bNoUseCache, @@lp_id_lpc, @@bIsForCompra

            -- Si tengo un precio
            --
            if @precio <> 0 begin

              -- Le aplico los porcentajes
              --
              set @precio = @precio + (@precio * IsNull(@lp_porcglobal,0) /100) 
                                    + (@precio * IsNull(@lpi_porcentaje,0) /100) 

              -- Si tengo una lista de marcado sobre el articulo
              --
              if @lpm_id is not null begin
  
                exec sp_LpGetPrecioMarcado @lpm_id, @mon_id_base, @precio out
  
              end

              -- Si tengo una lista de marcado sobre la lista
              --
              if @lpm_id_lista is not null begin
  
                exec sp_LpGetPrecioMarcado @lpm_id_lista, @mon_id_base, @precio out
  
              end

              -- Si la moneda de la lista es distinta
              -- a la de la base (es decir a la del precio)
              --
              if @mon_id <> @mon_id_base begin
  
                -- Si la moneda de la lista es la moneda default
                --
                select @mon_default = mon_legal from moneda where mon_id = @mon_id
  
                -- Voy a tener que pasar a pesos el precio
                -- de la base ya que encontre un precio en dolares u otra moneda
                -- distinta a pesos (obvio el ejemplo es pa Argentina che)
                --
                if @mon_default <> 0 begin
  
                  -- Obtengo la cotizacion de la lista base
                  --
                  exec sp_monedaGetCotizacion @mon_id_base, @fecha, 0, @cotiz out
  
                  -- Paso a Pesos el precio (sigo en argentino pue)
                  --
                  set @precio = @precio * @cotiz
  
                -- Ahora bien si la moneda de la lista no es la moneda default 
                -- (pesos pa los argentinos {quien sabe por cuanto tiempo no :) })
                --
                end else begin
  
                  -- Veamos si la lista base esta en pesos
                  --
                  select @mon_default = mon_legal from moneda where mon_id = @mon_id_base
  
                  if @mon_default <> 0 begin
  
                    -- Ok la base esta en pesos asi que obtengo la cotizacion de la lista
                    -- para la que se me pidio el precio
                    --
                    exec sp_monedaGetCotizacion @mon_id, @fecha, 0, @cotiz out
  
                    -- Si hay cotizacion, divido el precio y guala, tengo
                    -- el precio expresado en dolares o yerbas similares
                    --
                    if @cotiz <> 0   set @precio = @precio / @cotiz
                    else            set @precio = 0 -- :( sin cotizacion no hay precio
  
                  end else begin
  
                    -- Ok, al chango se le ocurrio comprar en dolares y vender en reales
                    -- entonces paso los dolares a pesos y luego los pesos a reales y listo
                    --
                    exec sp_monedaGetCotizacion @mon_id_base, @fecha, 0, @cotiz out
                    exec sp_monedaGetCotizacion @mon_id,      @fecha, 0, @cotiz2 out
  
                    set @precio = @precio * @cotiz
  
                    -- Si hay cotizacion, divido el precio y guala, tengo
                    -- el precio expresado en dolares o yerbas similares
                    --
                    if @cotiz2 <> 0 set @precio = @precio / @cotiz2
                    else            set @precio = 0 -- :( sin cotizacion no hay precio
  
                  end
                end
              end

              if not exists(select * from #Precios where lp_id = @lp_id) begin

                insert into #Precios (lpi_precio, lpi_porcentaje, lp_id_padre, lp_id, lpm_id)
                            values   (@precio, 0, @@lp_id, 0, 0)
  
              end else begin
  
                -- Aplico al precio de la lista base el porcentaje global y el porcentaje sobre articulo
                --
                update #Precios set lpi_precio = @precio 
                where lp_id = @lp_id
              end

            end
            -----------------------------------------------------------------------------------------
  
          end -- while
        
          -- Si no encontre precios en esta lista devuelvo 0
          --
          if not exists(select * from #Precios where lpi_precio <> 0) begin

            set @precio = 0    
    
          end else begin

            declare @bTomarElMayor int

            -- Veo si el cache esta activo
            --
            exec sp_Cfg_GetValor  'Ventas-General',
                                  'Tomar el Mayor Precio',
                                  @cfg_valor out,
                                  0

            if isnumeric(@cfg_valor)=0  set @bTomarElMayor = 0
            else                         set @bTomarElMayor = convert(int,@cfg_valor)
  
            if @bTomarElMayor <> 0
              select @precio = max(lpi_precio) from #Precios where lp_id_padre = @@lp_id  and lpi_precio <> 0
            else  
              select @precio = min(lpi_precio) from #Precios where lp_id_padre = @@lp_id  and lpi_precio <> 0
  
          end

        end --if IsNull(@precio,0) = 0 begin

        -- Ahora aplico las condiciones de redondeo de la lista
        -- solo si estoy en la primera llamada
        --
        if @@n = 1 and @precio <> 0 begin

          declare @pr_noredondeo tinyint

          select @pr_noredondeo = pr_noredondeo from Producto where pr_id = @@pr_id

          if @pr_noredondeo = 0 begin

            declare @bRedondear int
  
            -- Veo si hay que redondear
            --
            exec sp_Cfg_GetValor  'Ventas-General',
                                  'Redondear Decimales en Precios',
                                  @cfg_valor out,
                                  0
  
            if isnumeric(@cfg_valor)=0  set @bRedondear = 0
            else                         set @bRedondear = convert(int,@cfg_valor)
  
            if @bRedondear <> 0 and @@bIsForCompra = 0 begin
  
              -- Obtengo la cantidad de decimales
              --
              exec sp_Cfg_GetValor  'Ventas-General',
                                    'Decimales en Precios',
                                    @cfg_valor out,
                                    0
  
              declare @decimales int            
              if isnumeric(@cfg_valor)<>0 
                      set @decimales = convert(int,@cfg_valor)
              else     set @decimales = 0
  
              set @precio = round(@precio,@decimales)
  
              declare @precio_entero int
              set @precio_entero = @precio
  
              -- Solo si el precio es entero  
              --
              if @precio_entero = @precio begin
  
                -- Veo cuantos centavos le quiere restar 
                -- a los importes enteros
                --
                exec sp_Cfg_GetValor  'Ventas-General',
                                      'Restar a precios enteros',
                                      @cfg_valor out,
                                      0
    
                declare @centavos decimal(18,6)
                
                if isnumeric(@cfg_valor)<>0
                        set @centavos = convert(decimal(18,6),@cfg_valor)
                else     set @centavos = 0
    
                if @centavos <> 0 begin
                  set @precio = @precio - @centavos
                end
              end
  
            end --if @bRedondear <> 0 begin
          end --if @pr_noredondeo <> 0 begin
        end --if @@n = 1 and @precio <> 0 begin

      end --if @bFromCache = 0 begin
    end --if not exists (select lp_id from listaprecio where lp_id = @@lp_id) begin
  end --if @@lp_id is null begin

  set @@precio = IsNull(@precio,0)

  if @@select <> 0 select @@precio
end
