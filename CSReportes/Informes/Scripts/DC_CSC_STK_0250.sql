/*---------------------------------------------------------------------
Nombre: Listar articulos
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_STK_0250]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_STK_0250]

/*

[DC_CSC_STK_0250] 4,'20071211 00:00:00','1628',0,184,'0','0','0','0',0,0,10000,364,395,382,0,0,0,0,0,0

*/

go
create procedure DC_CSC_STK_0250 (

  @@us_id          int,

  @@Ffin             datetime,
  @@pr_id          varchar(255),
  @@metodoVal      smallint,
  @@lp_id          int,
  @@suc_id         varchar(255), 
  @@emp_id          varchar(255),
  @@depl_id        varchar(255),
  @@depf_id         varchar(255),
  @@bShowCosto     smallint,
  @@bCostoXInsumos smallint,

  @@cantidad       int,

  @@prfk_id01       int, 
  @@prfk_id02       int, 
  @@prfk_id03       int, 
  @@prfk_id04       int, 
  @@prfk_id05       int, 
  @@prfk_id06       int, 
  @@prfk_id07       int, 
  @@prfk_id08       int, 
  @@prfk_id09       int
)as 

begin

set nocount on

  create table #KitItems      (
                                pr_id int not null, 
                                nivel int not null
                              )

  create table #KitItemsSerie(
                                pr_id_kit       int null,
                                cantidad         decimal(18,6) not null,
                                cant_kits       int not null default(0),
                                faltante        int not null default(0),
                                pr_id           int not null, 
                                prk_id           int not null,
                                costo           decimal(18,6) not null default(0),
                                costo_x_insumos  decimal(18,6) not null default(0),
                                col_order       tinyint not null default(3),
                                nivel           smallint not null default(0)
                              )

  if @@bShowCosto <> 0 begin

    exec DC_CSC_PRD_0020 
    
      @@us_id,
    
      @@Ffin,
      @@pr_id,
      @@metodoVal,
      1,   --@@bShowInsumo,
      @@lp_id,
      @@suc_id,
      @@emp_id,
    
      @@prfk_id01,
      @@prfk_id02,
      @@prfk_id03,
      @@prfk_id04,
      @@prfk_id05,
      @@prfk_id06,
      @@prfk_id07,
      @@prfk_id08,
      @@prfk_id09,
      -9999 --@@prfk_id10

  end

  declare @pr_id     int
  declare @depl_id  int
  declare @depf_id   int

  declare @ram_id_Producto         int
  declare @ram_id_DepositoLogico   int
  declare @ram_id_DepositoFisico   int
  
  declare @clienteID int
  declare @IsRaiz    tinyint
  
  exec sp_ArbConvertId @@pr_id,        @pr_id  out,       @ram_id_Producto out
  exec sp_ArbConvertId @@depl_id,      @depl_id out,       @ram_id_DepositoLogico out
  exec sp_ArbConvertId @@depf_id,      @depf_id out,       @ram_id_DepositoFisico out

  exec sp_GetRptId @clienteID out

  if @pr_id = 0 begin

        select 
              'Debe seleccionar un articulo. No puede seleccionar una carpeta o usar la selección multiple.'
               as error_in_sp_id
        return
  end
  
  if @ram_id_DepositoLogico <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_DepositoLogico, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_DepositoLogico, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_DepositoLogico, @clienteID 
    end else 
      set @ram_id_DepositoLogico = 0
  end

  if @ram_id_DepositoFisico <> 0 begin
  
  --  exec sp_ArbGetGroups @ram_id_DepositoFisico, @clienteID, @@us_id
  
    exec sp_ArbIsRaiz @ram_id_DepositoFisico, @IsRaiz out
    if @IsRaiz = 0 begin
      exec sp_ArbGetAllHojas @ram_id_DepositoFisico, @clienteID 
    end else 
      set @ram_id_DepositoFisico = 0
  end

  -- Voy a obtener la cantidad de insumos que necesito
  -- para producir el Kit
  --

    -- Si me pidieron que lo haga con costos
    -- estas tablas ya las creo el sp dc_csc_prd_0020
    -- y no solo tengo los items sino tambien los costos :)
    --  
    if @@bShowCosto = 0 begin

      create table #FormulasKit (prfk_id int)
  
      if @@prfk_id02 <> 0 begin
        insert into #FormulasKit(prfk_id) values(@@prfk_id02)
      end
      if @@prfk_id03 <> 0 begin
        insert into #FormulasKit(prfk_id) values(@@prfk_id03)
      end
      if @@prfk_id04 <> 0 begin
        insert into #FormulasKit(prfk_id) values(@@prfk_id04)
      end
      if @@prfk_id05 <> 0 begin
        insert into #FormulasKit(prfk_id) values(@@prfk_id05)
      end
      if @@prfk_id06 <> 0 begin
        insert into #FormulasKit(prfk_id) values(@@prfk_id06)
      end
      if @@prfk_id07 <> 0 begin
        insert into #FormulasKit(prfk_id) values(@@prfk_id07)
      end
      if @@prfk_id08 <> 0 begin
        insert into #FormulasKit(prfk_id) values(@@prfk_id08)
      end
      if @@prfk_id09 <> 0 begin
        insert into #FormulasKit(prfk_id) values(@@prfk_id09)
      end

      exec sp_StockProductoGetKitInfo @pr_id, 0, 0, 0, 1, 1, @@prfk_id01, 0, 1, 1, 1, 1
  
    end

  -- Por cada insumo del kit voy a obtener la que hoy existe en el stock
  --

  --///////////////////////////////////////////////////////////////////////
  -- 
  -- Obtengo el stock para el kits a producir y todos sus insumos
  --

      -- MOVIENTOS DESPUES DE FECHA HASTA
      
          create table #t_dc_csc_stk_0250_stock (st_id int not null)
      
          create table #t_dc_csc_stk_0250 (depl_id int not null, pr_id int not null, cantidad decimal(18,6) not null default(0))
      
          insert into #t_dc_csc_stk_0250_stock 
          select st_id from Stock where st_fecha > @@Ffin 
          
          insert into #t_dc_csc_stk_0250
          
          select 
                  sti.depl_id,
                  sti.pr_id,
                  -- Resto lo que se movio despues de fecha hasta
                  -(    sum(sti_ingreso)
                      - sum(sti_salida)
                   )
          from
          
                #t_dc_csc_stk_0250_stock s
                        inner join StockItem sti              on  s.st_id      = sti.st_id
                        inner join DepositoLogico d           on sti.depl_id   = d.depl_id  
          where 
      
          -- Discrimino depositos internos
          
                (d.depl_id <> -2 and d.depl_id <> -3)
          
          /* -///////////////////////////////////////////////////////////////////////
          
          INICIO SEGUNDA PARTE DE ARBOLES
          
          /////////////////////////////////////////////////////////////////////// */
          
          and   (sti.pr_id = @pr_id or exists (select * from #KitItemsSerie where pr_id = sti.pr_id))
          and   (d.depl_id = @depl_id or @depl_id=0)
          and   (d.depf_id = @depf_id or @depf_id=0)
          
          -- Arboles
          and   (
                    (exists(select rptarb_hojaid 
                            from rptArbolRamaHoja 
                            where
                                 rptarb_cliente = @clienteID
                            and  tbl_id = 11 
                            and  rptarb_hojaid = sti.depl_id
                           ) 
                     )
                  or 
                     (@ram_id_DepositoLogico = 0)
                 )
          
          and   (
                    (exists(select rptarb_hojaid 
                            from rptArbolRamaHoja 
                            where
                                 rptarb_cliente = @clienteID
                            and  tbl_id = 10 
                            and  rptarb_hojaid = d.depf_id
                           ) 
                     )
                  or 
                     (@ram_id_DepositoFisico = 0)
                 )
          
          group by     
                  sti.depl_id,
                  sti.pr_id
      
      -- STOCK ACTUAL DESDE STOCKCACHE
          
          insert into #t_dc_csc_stk_0250
          
          select 
                  sti.depl_id,
                  sti.pr_id,
                  -- Sumo lo que hay actualmente
                  sum(stc_cantidad)
          from
          
                StockCache sti inner join DepositoLogico d on sti.depl_id   = d.depl_id  
          where 
          
          -- Discrimino depositos internos
          
                    (d.depl_id <> -2 and d.depl_id <> -3)
          
          /* -///////////////////////////////////////////////////////////////////////
          
          INICIO SEGUNDA PARTE DE ARBOLES
          
          /////////////////////////////////////////////////////////////////////// */
          
          and   (sti.pr_id = @pr_id or exists (select * from #KitItemsSerie where pr_id = sti.pr_id))
          and   (d.depl_id = @depl_id or @depl_id=0)
          and   (d.depf_id = @depf_id or @depf_id=0)
          
          -- Arboles          
          and   (
                    (exists(select rptarb_hojaid 
                            from rptArbolRamaHoja 
                            where
                                 rptarb_cliente = @clienteID
                            and  tbl_id = 11 
                            and  rptarb_hojaid = sti.depl_id
                           ) 
                     )
                  or 
                     (@ram_id_DepositoLogico = 0)
                 )
          
          and   (
                    (exists(select rptarb_hojaid 
                            from rptArbolRamaHoja 
                            where
                                 rptarb_cliente = @clienteID
                            and  tbl_id = 10 
                            and  rptarb_hojaid = d.depf_id
                           ) 
                     )
                  or 
                     (@ram_id_DepositoFisico = 0)
                 )
          
          group by     
                  sti.depl_id,
                  sti.pr_id
  -- 
  -- Fin stock para el kit y sus insumos
  --
  --///////////////////////////////////////////////////////////////////////

  create table #t_stock(pr_id int not null, cantidad decimal(18,6) not null)
  insert into #t_stock
  select   pr_id,
          sum(cantidad)
  from #t_dc_csc_stk_0250
  group by pr_id

  -- Voy a ver cuantos kits puedo fabricar con los insumos que hay
  --
  update #KitItemsSerie set cant_kits  = s.cantidad / #KitItemsSerie.cantidad
  from #t_stock s
  where #KitItemsSerie.pr_id = s.pr_id
     
  -- Resto a la cantidad de kits que hay en stock, la cantidad indicada
  -- y
  -- 
  -- Si el resto es positivo: (1)
  --
  --     informo la cantidad que tengo en stock y ademas listo los excedentes que
  --     tengo de otros insumos del kit informando cuantos kits me sobran
  --    y cuantos kits puedo armar con lo que tengo en stock
  --
  -- Si el resto es negativo: (2)
  --
  --    Lo resto a la cantidad que puedo producir con lo que tengo
  --    en stock y si el resultado es positivo hago lo mismo que en 1.
  --
  --    Si el resultado es negativo calculo cuanto necesito para producir 
  --    lo que me piden y respondo la cantidad de cada insumo que necesito comprar 
  --    para producir la cantidad indicada
  --
  declare @en_stock             decimal(18,6)

  declare @resto_stock          decimal(18,6) -- Lo que me queda despues de restar la cantidad pedida
                                              -- a lo que tengo actualmente en stock

  declare @resto_teorico        decimal(18,6) -- Lo que me queda despues de producir 
                                              -- con los insumos que tengo en stock y
                                              -- sumarle las existencias y luego restarle
                                              -- la cantidad pedida

  declare @cant_puedo_producir  decimal(18,6) -- Lo que puedo producir con lo que tengo en stock

  select @en_stock = cantidad
  from #t_stock
  where pr_id = @pr_id

  select @cant_puedo_producir = min(cant_kits)
  from #KitItemsSerie

  set @resto_stock   = @en_stock - @@cantidad
  set @resto_teorico = @cant_puedo_producir + @en_stock - @@cantidad

  declare @faltante decimal(18,6)

  if @resto_stock < 0 begin

    set @faltante    = abs(@resto_stock)
    set @resto_stock = 0

  end else

    set @faltante = 0

  declare @a_comprar           decimal(18,6)
  declare @sobrante_teorico    decimal(18,6)

  set @a_comprar         = 0
  set @sobrante_teorico = 0

  if @resto_teorico < 0 
    set @a_comprar         = abs(@resto_teorico)
  else
    set @sobrante_teorico = @resto_teorico


  update #KitItemsSerie set col_order = 2 
  from Producto pr
  where #KitItemsSerie.pr_id = pr.pr_id
    and pr.pr_eskit <> 0

  --////////////////////////////////////////////////////////////////////
  --
  -- Kit a Producir
  --
  insert into #KitItemsSerie(
                              pr_id_kit,
                              cantidad,
                              cant_kits,
                              pr_id,
                              prk_id,
                              col_order
                            )
                values (
                              @pr_id,
                              1,
                              @en_stock,
                              @pr_id,
                              0,
                              1
                        )

  declare @pr_nombrecompra varchar(5000)
  select @pr_nombrecompra = pr_nombrecompra from producto where pr_id = @pr_id

  declare @stock         int
  declare @cantidad_kit int
  declare @pr_id_subkit int
  declare @faltante_kit int
  declare @nivel        smallint

  declare c_subkits insensitive cursor for 
    select distinct t.pr_id, t.nivel 
    from #KitItemsSerie t inner join producto pr on t.pr_id = pr.pr_id and pr.pr_esKit <> 0
    order by t.nivel

  open c_subkits
  fetch next from c_subkits into @pr_id_subkit, @nivel
  while @@fetch_status = 0
  begin

    -- Obtengo lo que le falta al kit
    -- para saber cuanto me falta de cada uno
    -- de sus insumos
    --
    select @cantidad_kit = cantidad,
           @faltante_kit = faltante 
    from #KitItemsSerie
    where pr_id = @pr_id_subkit

    -- Si se trata del primer kit
    -- el faltante sale de la variable @faltante
    --
    if @pr_id_subkit = @pr_id 
      select @faltante_kit = @faltante

    -- Obtengo el stock del kit
    --
    select @stock = cantidad
    from #t_Stock 
    where pr_id = @pr_id_subkit

    -- Lo que me falta por cada insumo
    -- es igual a la cantidad de piezas por kit
    -- por la cantidad de kits que debo producir
    -- menos el stock de cada insumo
    --
    update #KitItemsSerie 
      set faltante = (#KitItemsSerie.cantidad * @faltante_kit) -- Cantidad de piezas por kit
                    - s.cantidad                               -- Stock de cada insumo
    from #t_stock s
    where #KitItemsSerie.pr_id_kit = @pr_id_subkit
      and #KitItemsSerie.pr_id = s.pr_id

    -- Esto lo uso para ordenar las filas
    --
    update #KitItemsSerie set nivel = @nivel 
    where #KitItemsSerie.pr_id_kit = @pr_id_subkit

    fetch next from c_subkits into @pr_id_subkit, @nivel
  end
  close c_subkits
  deallocate c_subkits

  --/////////////////////////////////////////////////////////////////////////////////////////
  --
  -- Calculo del costo de los kits
  --

  -- Esto solo afecta a la primera parte del reporte que totaliza
  -- el costo de producir los faltantes de kits.
  --
  -- solo se deben sumar los faltantes de piezas del primer nivel
  -- sea o no kits
  --

  -- Paso a costo_x_insumos el valor de todos los insumos
  -- sin importar a que nivel pertencen incluso aunque sean
  -- subkits
  --
  update #KitItemsSerie set costo_x_insumos = costo 
  from Producto pr
  where #KitItemsSerie.pr_id = pr.pr_id

  -- Si el costo de los kits debe obtenerse por insumos
  -- obtengo el costo de todos los sub-kits desde el de nivel
  -- mas bajo hasta los de primer nivel
  --
  if @@bCostoXInsumos <> 0 begin

    declare @costo_x_insumos decimal(18,6)
      
    -- Abro un cursor sobre los subkits ordenado 
    -- por nivel de mayor a menor
    --
    declare c_subkits insensitive cursor for 
      select distinct t.pr_id, t.nivel 
      from #KitItemsSerie t inner join producto pr on t.pr_id = pr.pr_id and pr.pr_esKit <> 0
      order by t.nivel desc
  
    open c_subkits
    fetch next from c_subkits into @pr_id_subkit, @nivel
    while @@fetch_status = 0
    begin
  
      select @cantidad_kit = cantidad 
      from #KitItemsSerie
      where pr_id = @pr_id_subkit

      -- Obtengo el costo del subkit
      --  
      select @costo_x_insumos = sum(costo*cantidad/@cantidad_kit)
      from #KitItemsSerie
      where pr_id_kit = @pr_id_subkit

      update #KitItemsSerie 
        set costo_x_insumos = @costo_x_insumos
      where pr_id = @pr_id_subkit

      fetch next from c_subkits into @pr_id_subkit, @nivel
    end
    close c_subkits
    deallocate c_subkits

  end

  -- Por ultimo pongo e cero todos los costos 
  -- excepto el del kit que estoy produciendo
  --
  update #KitItemsSerie 
    set costo_x_insumos = 0
  where pr_id <> @pr_id

  update #KitItemsSerie 
    set faltante = @faltante
  where pr_id = @pr_id

  --/////////////////////////////////////////////////////////////////////////////////////////
  --
  -- Select de Retorno
  --

  select 
      1                     as group_id,
      t.col_order           as order_id,
      t.nivel               as nivel_id,

      case when t.pr_id <> @pr_id 
            and i.pr_esKit <> 0   then t.pr_id 
           else                         0
      end                    as pr_id_subkit,  -- Lo usa el reporte para saber si debe o no mostrar la fila

      case when t.pr_id = @pr_id then t.pr_id
           else                       0
      end                   as pr_id_kit,      -- Lo usa el reporte para saber si debe o no mostrar la fila

      'Necesidad de Compra' as Tipo,

      case when i.pr_eskit <> 0 then i.pr_nombrecompra
           else                      k.pr_nombrecompra      
      end                   as Kit,

      i.pr_nombrecompra     as Insumo,
      s.cantidad            as Stock,
      t.cantidad * @@cantidad
                            as [Cantidad Pedida],
      @cant_puedo_producir  as [Produccion Posible],

      case when t.faltante > 0 then
                t.faltante
           else 0
      end                   as [Se Deben Producir],

      t.cantidad            as [Unidades por Kit],
      t.cant_kits           as [Produccion Posible Insumo],
      case when t.faltante < 0 then
                abs(t.faltante)
           else 0
      end                    as Sobrante,
      ''                    as Proveedor,
      @sobrante_teorico     as [Sobrante Posible],

      @a_comprar            as [Produccion Pendiente de Insumos],

      case when t.faltante > 0 then
                t.faltante
           else 0
      end                    as Faltante,

      case when t.faltante > 0 then
                t.costo_x_insumos * t.faltante
           else 0
      end                    as [Faltante $]

  from  #KitItemsSerie t inner join Producto k on t.pr_id_kit = k.pr_id
                         inner join Producto i on t.pr_id     = i.pr_id
                         left  join #t_stock s on t.pr_id     = s.pr_id

  union all

  --////////////////////////////////////////////////////////////////////
  -- Proveedores
  --
  select
      2                     as group_id,
      t.col_order           as order_id,
      t.nivel               as nivel_id,

      case when t.pr_id <> @pr_id 
            and i.pr_esKit <> 0   then t.pr_id 
           else                         0
      end                    as pr_id_subkit,    -- Lo usa el reporte para saber si debe o no mostrar la fila

      case when t.pr_id = @pr_id then t.pr_id
           else                       0
      end                   as pr_id_kit,       -- Lo usa el reporte para saber si debe o no mostrar la fila

      'Proveedores'         as Tipo,
      @pr_nombrecompra      as Kit,
      i.pr_nombrecompra     as Insumo,
      s.cantidad            as Stock,
      t.cantidad * @@cantidad
                            as [Cantidad Pedida],
      @cant_puedo_producir  as [Produccion Posible],

      case when t.faltante >0 then
                t.faltante
           else 0
      end                   as [Se Deben Producir],

      t.cantidad            as [Unidades por Kit],
      t.cant_kits           as [Produccion Posible Insumo],
      case when t.faltante < 0 then
                abs(t.faltante)
           else 0
      end                    as Sobrante,
      case when prov_nombre is null then '(Sin Proveedor)'
           else                            rtrim(
                                          prov_nombre + ' ' + 
                                          prov_tel + ' ' + 
                                          prov_fax + ' ' + 
                                          prov_email)
      end                    as Proveedor,
      @sobrante_teorico     as [Sobrante Posible],
      @a_comprar            as [Produccion Pendiente de Insumos],

      case when t.faltante > 0 then
                t.faltante
           else 0
      end                    as Faltante,

      case when i.pr_eskit <> 0 then
                0
           when t.faltante > 0 then
                t.costo * t.faltante
           else 0
      end                    as [Faltante $]


  from  #KitItemsSerie t inner join Producto k on t.pr_id_kit = k.pr_id
                         inner join Producto i on t.pr_id     = i.pr_id
                         left  join #t_stock s on t.pr_id     = s.pr_id

                         left  join ProductoProveedor prprov on t.pr_id = prprov.pr_id
                         left  join Proveedor prov           on prprov.prov_id = prov.prov_id

  where s.cantidad - t.faltante < 0

  order by group_id, kit, proveedor, t.nivel, t.col_order, insumo

end

GO