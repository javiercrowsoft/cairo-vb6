/*

DC_CSC_VEN_9780 1, '1', '0', 1

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_VEN_9780]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_VEN_9780]

go
create procedure DC_CSC_VEN_9780 (

@@us_id         int,
@@catw_id       varchar(255),
@@lp_id          varchar(255),
@@agregar       smallint

)as 
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

  declare @lp_id int

  exec sp_ArbConvertId @@lp_id, @lp_id out, 0

  -- sp_ListaPrecioValidate se encarga de cargar las dos tablas
  -- y como lo llamo con n>0 no devuelve datos.
  --
  exec sp_ListaPrecioValidate @lp_id, 0, 1, 1
  exec sp_ListaPrecioValidate @lp_id, 0, 1, 0

--/////////////////////////////////////////////////////////////////////////////////
-- Arboles
--/////////////////////////////////////////////////////////////////////////////////

  declare @catw_id int

  exec sp_ArbConvertId @@catw_id, @catw_id out, 0

  if @catw_id = 0 begin
    select 1 as id_aux, 'Debe seleccionar un catalogo. No puede seleccionar una rama o multiple seleecion en el parametro catalogo. Tampoco puede dejarlo vacio.' as Info
    return
  end

  if @@agregar = 0 delete CatalogoWebItem where catw_id = @catw_id

  declare @catwi_id int


  declare @pr_id      int

  declare @clienteID   int
  declare @IsRaiz     tinyint
  
  declare c_items insensitive cursor for 
    select pr_id from Producto 
      where exists(
                    select pr_id
                    from ListaPrecioItem lpi
                    where (         lp_id in (select lp_id from #ListasPadres)
                                 or lp_id = @lp_id
                          )
                      and pr_id = Producto.pr_id
                  )


        and pr_sevende <> 0

  open c_items

  fetch next from c_items into @pr_id
  while @@fetch_status=0 
  begin

    if not exists(select * from CatalogoWebItem where catw_id = @catw_id and pr_id = @pr_id)
    begin

      exec sp_dbgetnewid 'CatalogoWebItem', 'catwi_id', @catwi_id out, 0

      insert into CatalogoWebItem (catwi_id, catw_id, pr_id, catwi_activo, modifico)
                            values(@catwi_id, @catw_id, @pr_id, 1, @@us_id)
    end

    fetch next from c_items into @pr_id
  end

  close c_items
  deallocate c_items

  select  catwi.pr_id,
          pr_codigo      as Codigo,
          pr_nombreventa as Articulo,
          case when catwi_activo<>0 then 'si' else 'no' end   as Activo
  from CatalogoWebItem catwi inner join Producto pr on catwi.pr_id = pr.pr_id
  where catwi.catw_id = @catw_id

end
go