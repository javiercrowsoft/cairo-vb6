if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_listaPrecioUpdateCache]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_listaPrecioUpdateCache]

go
/*

sp_listaPrecioUpdateCache 0

*/
create Procedure sp_listaPrecioUpdateCache(
  @@lp_id           int,
  @@bDelHuerfanos    tinyint = 1,
  @@pr_id           int = 0,
  @@bSelect         int = 1
)
as
begin

  set nocount on

  -- Obtengo la descendencia de esta lista y por cada lista genero 
  -- precios para todos los articulos mencionados en esta lista
  --
  -- Los articulos mencionados por esta lista son todos los articulos
  -- explicitamente incluidos en la lista y todos los articulos
  -- de las listas base

  -- obtengo las listas hijas, nietas, tatara nietas etc. es decir 
  -- la descendencia
  --

    create table #ListasPadres(lp_id int not null, n tinyint, pendiente tinyint)
    create table #ListasHijas(lp_id int not null, n tinyint, pendiente tinyint)

  -- sp_ListaPrecioValidate se encarga de cargar las dos tablas
  -- y como lo llamo con n>0 no devuelve datos.
  --
  exec sp_ListaPrecioValidate @@lp_id, 0, 1, 1
  exec sp_ListaPrecioValidate @@lp_id, 0, 1, 0

  declare @lp_id         int
  declare @pr_id         int
  declare @precio       decimal(18,6)
  declare @precio_cache decimal(18,6)

  declare c_listas insensitive cursor for 
    select lp_id 
    from ListaPrecio 
    where (lp_id in (select lp_id from #ListasHijas)
        or lp_id = @@lp_id
          )
      and lp_enCache <> 0

  open c_listas
  fetch next from c_listas into @lp_id
  while @@fetch_status=0
  begin

    declare c_productos insensitive cursor for 
      select distinct pr_id
      from ListaPrecioItem lpi
      where  (
                 lp_id in (select lp_id from #ListasPadres)
               or lp_id = @@lp_id
            )
        and (pr_id = @@pr_id or @@pr_id = 0)

    open c_productos

    fetch next from c_productos into @pr_id
    while @@fetch_status=0
    begin

      exec sp_LpGetPrecio 

                  @lp_id,         --  @@lp_id         int,
                  @pr_id,         --  @@pr_id         int,
                  @precio out,    --  @@precio         decimal(18,6) = 0 out,
                  0,              --  @@select        tinyint = 0,
                  1,              --  @@bCreateTable  tinyint = 1,
                  0,              --  @@lp_id_padre   int = 0,
                  0,              --  @@n             tinyint = 0,
                  1                --  @@bNoUseCache   tinyint = 0

      set @precio_cache = 0

      select @precio_cache = lpp_precio 
      from ListaPrecioPrecio 
      where lp_id = @lp_id and pr_id = @pr_id

      if isnull(@precio_cache,0) <> @precio begin

        delete ListaPrecioPrecio where lp_id = @lp_id and pr_id = @pr_id
        insert into ListaPrecioPrecio (lp_id, pr_id, lpp_precio)
                               values (@lp_id, @pr_id, @precio)

        -- Para que se actualicen los catalogos web
        --
        update producto set modificado = getdate() where pr_id = @pr_id

      end

      fetch next from c_productos into @pr_id
    end

    close c_productos
    deallocate c_productos

    fetch next from c_listas into @lp_id
  end

  close c_listas
  deallocate c_listas

  if @@bDelHuerfanos <> 0 begin

    delete from ListaPrecioPrecio 
    where not exists(select * from ListaPrecioItem where pr_id = ListaPrecioPrecio.pr_id)

    delete from ListaPrecioPrecio 
    where not exists(select * 
                     from ListaPrecioItem lpi inner join ListaPrecio lp on lpi.lp_id = lp.lp_id
                     where pr_id = ListaPrecioPrecio.pr_id
                       and lp.activo <> 0
                    )

    delete from ListaPrecioPrecio 
    from ListaPrecio lp
    where ListaPrecioPrecio.lp_id = lp.lp_id
      and lp.activo = 0

    -- Obtengo todos los articulos mencionados por esta lista
    -- y sus padres y si encuentro un precio para un articulo
    -- que no esta en esta lista lo borro
    --
    declare c_lista_en_cache insensitive cursor for select lp_id from ListaPrecio where lp_enCache <> 0

    open c_lista_en_cache

    fetch next from c_lista_en_cache into @lp_id
    while @@fetch_status=0
    begin

      delete #ListasPadres
      delete #ListasHijas

      exec sp_ListaPrecioValidate @lp_id, 0, 1, 1
      exec sp_ListaPrecioValidate @lp_id, 0, 1, 0
      
      insert into #ListasPadres (lp_id, n, pendiente) values(@lp_id,0,0)

      -- Borro todos los precios que estan en el cache
      -- y no estan ni en la lista del cache ni en sus padres

      delete ListaPrecioPrecio 
      where lp_id = @lp_id
        and not exists(select pr_id 
                        from ListaPrecioItem lpi 
                          inner join #ListasPadres l 
                            on lpi.lp_id = l.lp_id)

      fetch next from c_lista_en_cache into @lp_id
    end
    close c_lista_en_cache
    deallocate c_lista_en_cache
  end

  if @@bSelect <> 0 select -1 as success

end
