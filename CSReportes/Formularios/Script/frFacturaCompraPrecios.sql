if exists (select * from sysobjects where id = object_id(N'[dbo].[frFacturaCompraPrecios]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frFacturaCompraPrecios]

/*

   frFacturaCompraPrecios 340

select * from listaprecio where lp_id = 73
select * from listaprecioitem where lp_id = 73 and pr_id = 134

select * from moneda
select mon_id,* from listaprecio where lp_id = 73

*/

go
create procedure frFacturaCompraPrecios (

  @@fc_id      int

)as 

begin

  set nocount on

  -- ex: moneda extranjera

  -- Contiene las listas bases
  --
  create table #t_ListasBase (lp_id int,
                              n     int
                              )

  -- Contiene el precio en moneda extranjera del proveedor
  -- y los precios en moneda default y extranjera de la lista del proveedor
  --
  create table #t_FacturaCompraPrecios (fci_id         int,
                                        fci_precio_ex  decimal(18,6) not null default(0),
                                        lp_precio     decimal(18,6) not null default(0),
                                        lp_precio_ex   decimal(18,6) not null default(0)
                                      )

  declare @lp_precio  decimal(18,6)

  declare @lp_id           int
  declare @lp_id_base     int
  declare @lp_id_precio    int
  declare @cotiz_prov     decimal(18,6)

  declare @fci_id int
  declare @pr_id  int
  declare @fci_precio   decimal(18,6)

  declare @cotiz        decimal(18,6)
  declare @mon_default   decimal(18,6)
  declare @mon_id        int

  declare @fc_fecha      datetime

  -- Obtengo la lista de precios asociada a la factura la fecha 
  -- y la cotizacicion del proveedor
  --
  select @lp_id = lp_id, @cotiz_prov = fc_cotizacionprov, @fc_fecha = fc_fecha
  from FacturaCompra where fc_id = @@fc_id

  if @cotiz_prov = 0 set @cotiz_prov = 1

  -- Cargo la temporal con todos los items de la factura
  --
  insert into #t_FacturaCompraPrecios ( fci_id, fci_precio_ex )
                              select    fci_id,
                                        fci_precio / @cotiz_prov
                              from FacturaCompraItem where fc_id = @@fc_id

  -- Si la factura tiene un alista de precios definida
  --
  if @lp_id is not null begin

    -- Por cada item de la factura voy a buscar el precio en la
    -- lista base del proveedor
    --
    declare c_itemsfc insensitive cursor for 
        select fci_id, pr_id, fci_precio from FacturaCompraItem where fc_id = @@fc_id

    open c_itemsfc

    fetch next from c_itemsfc into @fci_id, @pr_id, @fci_precio
    while @@fetch_status=0
    begin

      -- Anulo el precio anterior
      --
      select @lp_precio = null

      -- Busco un precio en la lista indicada en el comprobante
      --
      select @lp_precio = lpi_precio from ListaPrecioItem where lp_id = @lp_id and pr_id = @pr_id
      set @lp_id_precio = @lp_id

      -- Inserto en esta temporal todas las listas bases de la lista
      -- asociada al comprobante
      --
      insert into #t_ListasBase (lp_id, n)
      select lp_id, 0
      from ListaPrecioLista
      where lp_id = @lp_id

      -- Mientras no tenga un precio y existan listas bases que analizar
      --
      while @lp_precio is null and exists(select * from #t_ListasBase where n = 0)
      begin

        -- Creo un cursor para recorrer cada base
        --
        declare c_listas insensitive cursor for select lp_id from #t_ListasBase where n = 0
        open c_listas

        fetch next from c_listas into @lp_id_base
        while @@fetch_status=0 and @lp_precio is null
        begin

          -- Busco el precio en la lista base
          --
          select @lp_precio = lpi_precio from ListaPrecioItem where lp_id = @lp_id_base and pr_id = @pr_id
          set @lp_id_precio = @lp_id_base

          fetch next from c_listas into @lp_id_base
        end

        close c_listas
        deallocate c_listas

        -- Me preparo para ver las bases de las bases
        --
        update #t_ListasBase set n = n+1
        
        -- Cargo las bases de las bases
        --
        insert into #t_ListasBase 
        select lp_id_padre, 0 
        from ListaPrecioLista 
        where lp_id in (select lp_id from #t_ListasBase where n = 1)

      end

      if @lp_precio is not null begin

        -- Obtengo la moneda de la lista de precios
        --
        select @mon_id = mon_id from ListaPrecio where lp_id = @lp_id_precio
  
        -- Si la moneda de la lista es la moneda default
        --
        select @mon_default = mon_legal from moneda where mon_id = @mon_id

        if @mon_default = 0 begin
  
          -- Obtengo la cotizacion de la lista base
          --
          exec sp_monedaGetCotizacion @mon_id, @fc_fecha, 0, @cotiz out

        end else set @cotiz = 1

        -- Actualizo la temporal con la info de la lista
        --  
        update #t_FacturaCompraPrecios set
                                          lp_precio_ex   = @lp_precio,
                                          lp_precio     = @lp_precio * @cotiz
        where fci_id = @fci_id

      end

      fetch next from c_itemsfc into @fci_id, @pr_id, @fci_precio
    end

    close c_itemsfc
    deallocate c_itemsfc

  end

  --/////////////////////////////////////////////////////////////////////////
  --
  --  SELECT DE RETORNO
  --
  --/////////////////////////////////////////////////////////////////////////

  select 

        fc.*,
        fci.*,


        fc_fecha            as Fecha,
        fc_nrodoc           as Comprobante,
        fc_descrip          as Observaciones,

        su.suc_nombre          as Sucursal,  
        cp.cpg_nombre          as [Cond. Pago],
        cc.ccos_nombre        as [Centro de Costo],
    
        case 
          when lgj_titulo <> '' then lgj_titulo 
          else lgj_codigo 
        end                    as lgj_codigo,

        prov_nombre         as Proveedor,
        prov_tel            as Telefono,      
        prov_calle          as Calle,
        prov_callenumero    as Nro,
        prov_localidad      as Localidad,

        fci_cantidad        as Cantidad,
        pr_nombrecompra      as Articulo,

        fci_precio_ex,
        lp_precio,     
        lp_precio_ex

  from FacturaCompra fc inner join FacturaCompraItem fci on fc.fc_id = fci.fc_id
                        inner join #t_FacturaCompraPrecios t on fci.fci_id = t.fci_id
                        inner join Producto pr on fci.pr_id = pr.pr_id
                        inner join Proveedor prov on fc.prov_id = prov.prov_id
                        inner join CondicionPago cp  on fc.cpg_id  = cp.cpg_id
                        inner join sucursal su on fc.suc_id  = su.suc_id
                        left  join Legajo on fc.lgj_id  = Legajo.lgj_id
                        left  join CentroCosto cc on fc.ccos_id = cc.ccos_id

  where fc.fc_id = @@fc_id
  
end
go

