/*

sp_col producto
lsListaPrecio '10','109',0,1

select * from producto 
select * from rama where ram_nombre like '%cil%'

select * from rama where ram_nombre like '%MULT%'

select * from listaprecio where lp_nombre like '%fac%'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[lsListaPrecio]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[lsListaPrecio]

go
create procedure lsListaPrecio (

@@lp_id          varchar(255),
@@pr_id          varchar(255),
@@bIva          smallint,
@@bSinClientes  smallint,
@@bSinBases     smallint

)as 
begin

  set nocount on

--/////////////////////////////////////////////////////////////////////////////////
-- Arboles
--/////////////////////////////////////////////////////////////////////////////////

  declare @lp_id int
  declare @pr_id int
  declare @Ram_id_ListaPrecio int
  declare @Ram_id_Producto    int
  
  declare @clienteID   int
  declare @IsRaiz     tinyint

  exec sp_ArbConvertId @@lp_id, @lp_id out, @Ram_id_ListaPrecio out
  exec sp_ArbConvertId @@pr_id, @pr_id out, @Ram_id_Producto out
  
  if @Ram_id_ListaPrecio <> 0 or @Ram_id_Producto <> 0 begin

    exec sp_GetRptId @clienteID out

    if @Ram_id_ListaPrecio <> 0 begin  
      exec sp_ArbIsRaiz @Ram_id_ListaPrecio, @IsRaiz out
      if @IsRaiz = 0  exec sp_ArbGetAllHojas @Ram_id_ListaPrecio, @clienteID
      else            set @Ram_id_ListaPrecio = 0
    end

    if @Ram_id_Producto <> 0 begin  
      exec sp_ArbIsRaiz @Ram_id_Producto, @IsRaiz out
      if @IsRaiz = 0  exec sp_ArbGetAllHojas @Ram_id_Producto, @clienteID
      else            set @Ram_id_Producto = 0
    end
  
  end else begin
  
    set @clienteID = 0
  
  end

--/////////////////////////////////////////////////////////////////////////////////
-- Que productos van en que lista
--/////////////////////////////////////////////////////////////////////////////////

  declare @t        int
  declare @lp_id_pr int

  create table #productos(pr_id int, lp_id int)
  create table #lps(lp_id int, t int)

  declare c_listas insensitive cursor for select lp_id from ListaPrecio 
  where 
        (ListaPrecio.lp_id     = @lp_id or @lp_id=0)
  
  -- Arboles
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 27 -- tbl_id de ListaPrecio
                    and  rptarb_hojaid = ListaPrecio.lp_id
                   ) 
             )
          or 
             (@Ram_id_ListaPrecio = 0)
         )
  open c_listas

  fetch next from c_listas into @lp_id_pr
  while @@fetch_status=0 
  begin

    delete #lps

    set @t=1

    -- Inserto los productos mencionados por la lista
    -- que no tienen precio definido, ose solo indican 
    -- un porcentaje sobre listas base
    --
    insert into #productos(pr_id,lp_id) 
    select pr_id,@lp_id_pr from ListaPrecioItem where lp_id = @lp_id_pr and lpi_precio = 0
    
    -- Obtengo las litas bases
    --
    insert into #lps(lp_id,t) select lp_id_padre,@t from listaprecio where lp_id = @lp_id_pr and lp_id_padre is not null
    insert into #lps(lp_id,t) select lp_id_padre,@t from listapreciolista where lp_id = @lp_id_pr

    -- Mientras existan listas base sin procesar
    --
    while exists(select * from #lps where t = @t and @t < 20) -- Pongo un tope de 20 por control para evitar un bucle sin fin
    begin

--       select lp_nombre, pr_id from ListaPrecioItem lpi inner join listaprecio lp on lpi.lp_id = lp.lp_id where lp.lp_id in (select lp_id from #lps where t = @t)
--       select @t

      insert into #productos(pr_id,lp_id) 
      select pr_id,@lp_id_pr from ListaPrecioItem 
      where lp_id in (select lp_id from #lps where t = @t)
        and not exists(select * from #productos 
                        where pr_id = ListaPrecioItem.pr_id
                          and lp_id = @lp_id_pr
                      )
        and   (ListaPrecioItem.pr_id = @pr_id or @pr_id=0)
        and   (
                  (exists(select rptarb_hojaid 
                          from rptArbolRamaHoja 
                          where
                               rptarb_cliente = @clienteID
                          and  tbl_id = 30 -- select tbl_id, tbl_nombrefisico from tabla where tbl_nombre = 'producto'
                          and  rptarb_hojaid = ListaPrecioItem.pr_id
                         ) 
                   )
                or 
                   (@Ram_id_Producto = 0)
               )

  
      set @t = @t+1
      -- Obtengo las listas base de las listas base
      --
      insert into #lps(lp_id,t) select lp_id_padre,@t from listaprecio where lp_id in (select lp_id from #lps where t = @t-1)
      insert into #lps(lp_id,t) select lp_id_padre,@t from listapreciolista where lp_id in (select lp_id from #lps where t = @t-1)
    end

    -- Proceso la siguiente lista seleccionada por el usuario
    --
    fetch next from c_listas into @lp_id_pr
  end

  close c_listas
  deallocate c_listas

--/////////////////////////////////////////////////////////////////////////////////
-- Tabla temporal
--/////////////////////////////////////////////////////////////////////////////////
  
  create table #tmpListaPrecio(
    Tipo            tinyint not null, 
    lp_id            int not null,  
    lp_nombre        varchar  (100) not null,
    lp_codigo        varchar  (15) not null,
    lp_descrip      varchar  (255) not null,
    lp_fechadesde    datetime not null,
    lp_fechahasta    datetime not null,
    lp_default      varchar(10),
    lp_id_padre      int null,
    lp_porcentaje    decimal not null,
    lp_tipo          varchar(100) not null,
    activo          tinyint not null,
    creado          datetime not null,
    modificado      datetime not null,
    modifico        int not null,
    lpi_id          int null,
    pr_nombreventa   varchar(255),
    pr_codigo       varchar(100),
    pr_id           int,
    cli_nombre      varchar(100),
    cli_codigo      varchar(100),
    lpPadre         varchar(100),
    lpPadreCodigo   varchar(15),
    lpi_precio      decimal(18,6),
    lpi_porcentaje  decimal(18,6),
    rub_nombre      varchar(100),
  )
  
  insert into
  #tmpListaPrecio(
    Tipo,
    lp_id,
    lp_nombre,
    lp_codigo,
    lp_descrip,
    lp_fechadesde,
    lp_fechahasta,
    lp_default,
    lp_id_padre,
    lp_porcentaje,
    lp_tipo,
    activo,
    creado,
    modificado,
    modifico,
    lpi_id,
    pr_nombreventa,
    pr_codigo,
    pr_id,
    cli_nombre,
    cli_codigo,
    lpPadre,
    lpPadreCodigo,
    lpi_precio,
    lpi_porcentaje,
    rub_nombre
  )

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Precios propios de cada una de las listas seleccionadas
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

  select 
  0 as Tipo, 
  listaprecio.lp_id,
  listaprecio.lp_nombre,
  listaprecio.lp_codigo,
  listaprecio.lp_descrip,
  listaprecio.lp_fechadesde,
  listaprecio.lp_fechahasta,
  case listaprecio.lp_default
    when 0 then 'No'
    else        'Si'
  end,
  listaprecio.lp_id_padre,
  listaprecio.lp_porcentaje,
  case 
    when listaprecio.lp_tipo = 1 then 'Venta'
    else                              'Compra'
  end,
  listaprecio.activo,
  listaprecio.creado,
  listaprecio.modificado,
  listaprecio.modifico,
  lpi_id,
  case 
      when ListaPrecio.lp_tipo = 1 then pr_nombreventa
      else                              pr_nombrecompra
  end as pr_nombreventa,
  pr_codigo,
  Producto.pr_id,
  '' as cli_nombre,
  '' as cli_codigo,
  ListaBase.lp_nombre as lpPadre,
  ListaBase.lp_codigo as lpPadreCodigo,
  lpi_precio,
  lpi_porcentaje,
  rub_nombre
  
  from 
  
  ListaPrecio left join ListaPrecio as ListaBase on ListaPrecio.lp_id_padre = ListaBase.lp_id
              left join ListaPrecioItem          on ListaPrecio.lp_id       = ListaPrecioItem.lp_id
              left join Producto                 on ListaPrecioItem.pr_id   = Producto.pr_id
              left join Rubro                    on Producto.rub_id         = Rubro.rub_id
  
  where 
        (ListaPrecio.lp_id     = @lp_id or @lp_id=0)
  and   (ListaPrecioItem.pr_id = @pr_id or @pr_id=0)

  -- Arboles
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 27 -- tbl_id de ListaPrecio
                    and  rptarb_hojaid = ListaPrecio.lp_id
                   ) 
             )
          or 
             (@Ram_id_ListaPrecio = 0)
         )
  
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 30 -- select tbl_id, tbl_nombrefisico from tabla where tbl_nombre = 'producto'
                    and  rptarb_hojaid = ListaPrecioItem.pr_id
                   ) 
             )
          or 
             (@Ram_id_Producto = 0)
         )

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  union

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Precios de listas bases
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

  select

  0 as Tipo, 
  listaprecio.lp_id,
  listaprecio.lp_nombre,
  listaprecio.lp_codigo,
  listaprecio.lp_descrip,
  listaprecio.lp_fechadesde,
  listaprecio.lp_fechahasta,
  case listaprecio.lp_default
    when 0 then 'No'
    else        'Si'
  end,
  listaprecio.lp_id_padre,
  listaprecio.lp_porcentaje,
  case 
    when listaprecio.lp_tipo = 1 then 'Venta'
    else                              'Compra'
  end,
  listaprecio.activo,
  listaprecio.creado,
  listaprecio.modificado,
  listaprecio.modifico,
  0 as lpi_id,

  case 
      when ListaPrecio.lp_tipo = 1 then pr_nombreventa
      else                             pr_nombrecompra
  end as pr_nombreventa,

  pr_codigo,
  Producto.pr_id,
  '' as cli_nombre,
  '' as cli_codigo,
  ListaBase.lp_nombre as lpPadre,
  ListaBase.lp_codigo as lpPadreCodigo,
  0 as lpi_precio,
  0 as lpi_porcentaje,
  rub_nombre
  
  from 
  
  ListaPrecio left join ListaPrecio as ListaBase on ListaPrecio.lp_id_padre = ListaBase.lp_id
              left join #productos               on ListaPrecio.lp_id = #productos.lp_id 
              left join Producto                 on #productos.pr_id = Producto.pr_id 
              left join Rubro                    on Producto.rub_id = Rubro.rub_id
  
  where 
        (ListaPrecio.lp_id     = @lp_id or @lp_id=0)
  
  -- Arboles
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 27 -- tbl_id de ListaPrecio
                    and  rptarb_hojaid = ListaPrecio.lp_id
                   ) 
             )
          or 
             (@Ram_id_ListaPrecio = 0)
         )
  

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  union

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Datos de cabecera de las listas seleccionadas
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  
  select 
  1 as Tipo,
  listaprecio.lp_id,
  listaprecio.lp_nombre,
  listaprecio.lp_codigo,
  listaprecio.lp_descrip,
  listaprecio.lp_fechadesde,
  listaprecio.lp_fechahasta,
  case listaprecio.lp_default
    when 0 then 'No'
    else        'Si'
  end,
  listaprecio.lp_id_padre,
  listaprecio.lp_porcentaje,
  listaprecio.lp_tipo,
  listaprecio.activo,
  listaprecio.creado,
  listaprecio.modificado,
  listaprecio.modifico,
  0 as lpi_id,
  '' as pr_nombreventa,
  '' as pr_codigo,
  0  as pr_id,
  cli_nombre,
  cli_codigo,
  ListaBase.lp_nombre as lpPadre,
  ListaBase.lp_codigo as lpPadreCodigo,
  0 as lpi_precio ,
  0 as lpi_porcentaje,
  '' as rub_nombre
  
  from 
  
  ListaPrecio 
              inner join ListaPrecioCliente       on   ListaPrecio.lp_id = ListaPrecioCliente.lp_id
                                                  and  @@bSinClientes = 0
              inner join Cliente                  on ListaPrecioCliente.cli_id = Cliente.cli_id
                                                  and  @@bSinClientes = 0  
              left join ListaPrecio as ListaBase on ListaPrecio.lp_id_padre = ListaBase.lp_id
  where 
        (ListaPrecio.lp_id     = @lp_id or @lp_id=0)
  
  -- Arboles
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 27 -- tbl_id de ListaPrecio
                    and  rptarb_hojaid = ListaPrecio.lp_id
                   ) 
             )
          or 
             (@Ram_id_ListaPrecio = 0)
         )

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  union

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Datos de cabecera de las listas seleccionadas
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  
  select 
  2 as Tipo,
  listaprecio.lp_id,
  listaprecio.lp_nombre,
  listaprecio.lp_codigo,
  listaprecio.lp_descrip,
  listaprecio.lp_fechadesde,
  listaprecio.lp_fechahasta,
  case listaprecio.lp_default
    when 0 then 'No'
    else        'Si'
  end,
  listaprecio.lp_id_padre,
  listaprecio.lp_porcentaje,
  listaprecio.lp_tipo,
  listaprecio.activo,
  listaprecio.creado,
  listaprecio.modificado,
  listaprecio.modifico,
  0 as lpi_id,
  '' as pr_nombreventa,
  '' as pr_codigo,
  0  as pr_id,
  '' as cli_nombre,
  '' as cli_codigo,
  ListaBase.lp_nombre as lpPadre,
  ListaBase.lp_codigo as lpPadreCodigo,
  0 as lpi_precio ,
  0 as lpi_porcentaje,
  '' as rub_nombre
  
  from 
  
  ListaPrecio inner join ListaPrecioLista         on ListaPrecio.lp_id            = ListaPrecioLista.lp_id
              inner join ListaPrecio as ListaBase on ListaPrecioLista.lp_id_padre = ListaBase.lp_id
  
  where 
        (ListaPrecio.lp_id     = @lp_id or @lp_id=0)
  
  -- Arboles
  and   (
            (exists(select rptarb_hojaid 
                    from rptArbolRamaHoja 
                    where
                         rptarb_cliente = @clienteID
                    and  tbl_id = 27 -- tbl_id de ListaPrecio
                    and  rptarb_hojaid = ListaPrecio.lp_id
                   ) 
             )
          or 
             (@Ram_id_ListaPrecio = 0)
         )
  and @@bSinBases = 0

  order by Tipo


--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Obtengo los precios de las listas base
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
  
  declare @precio decimal(18,6)
  
  declare c_precio insensitive cursor 
                    for select lp_id, pr_id 
                    from #tmpListaPrecio 
                    where tipo = 0 and lpi_precio = 0
  
  open c_precio
  
  fetch next from c_precio into @lp_id, @pr_id 
  while @@fetch_status = 0 begin
  
    exec sp_lpGetPrecio @lp_id, @pr_id, @precio out, 0
  
    update #tmpListaPrecio set lpi_precio = @precio where pr_id = @pr_id and lp_id = @lp_id
      
    fetch next from c_precio into @lp_id, @pr_id 
  end
  
  close c_precio
  
  deallocate c_precio
  
  if @@bIva <> 0 
    select 
      t.Tipo,
      t.lp_id,
      t.lp_nombre,
      t.lp_codigo,
      t.lp_descrip,
      t.lp_fechadesde,
      t.lp_fechahasta,
      t.lp_default,
      t.lp_id_padre,
      t.lp_porcentaje,
      t.lp_tipo,
      t.activo,
      t.creado,
      t.modificado,
      t.modifico,
      t.lpi_id,
      t.pr_nombreventa,
      t.pr_codigo,
      t.pr_id,
      t.cli_nombre,
      t.cli_codigo,
      t.lpPadre,
      t.lpPadreCodigo,
      case l.lp_tipo
        when 1 then t.lpi_precio + t.lpi_precio * (tv.ti_porcentaje /100)
        when 2 then t.lpi_precio + t.lpi_precio * (tc.ti_porcentaje /100)
      end lpi_precio,
      t.lpi_porcentaje,
      t.rub_nombre,
      1 as ivaIncluido,
      @@bSinBases as sinBase

    from #tmpListaPrecio t left join Producto p        on t.pr_id = p.pr_id
                           left join ListaPrecio l     on t.lp_id = l.lp_id
                           left join TasaImpositiva tc  on p.ti_id_ivaricompra = tc.ti_id
                           left join TasaImpositiva tv  on p.ti_id_ivariventa  = tv.ti_id
    order by t.Tipo

  else

    select 
      *,
      0 as ivaIncluido,
      @@bSinBases as sinBase

    from #tmpListaPrecio order by Tipo

end
go