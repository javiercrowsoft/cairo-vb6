-- Script de Chequeo de Integridad de:

-- 1 - Control de documentos que mueven stock

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaStockValidateDocPPK2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaStockValidateDocPPK2]

go

create procedure sp_AuditoriaStockValidateDocPPK2 (

  @@ppk_id      int,
  @@aud_id       int,
  @@st_id       int,
  @@bConsumo    tinyint

)
as

begin

  set nocount on

  create table #KitItems      (
                                pr_id int not null, 
                                nivel int not null
                              )

  create table #KitItemsSerie(
                                pr_id_kit       int null,
                                cantidad         decimal(18,6) not null,
                                pr_id           int not null, 
                                prk_id           int not null,
                                nivel           smallint not null default(0)
                              )

  declare @st_id         int
  declare @audi_id       int
  declare @doct_id      int
  declare @ppk_nrodoc   varchar(50) 
  declare @ppk_numero   varchar(50) 

  set @st_id = @@st_id

  select 
            @doct_id      = doct_id,
            @ppk_nrodoc  = ppk_nrodoc,
            @ppk_numero  = convert(varchar,ppk_numero)

  from ParteProdKit where ppk_id = @@ppk_id


  declare @ppki_cantidad            decimal(18,6)
  declare @pr_id                    int
  declare @pr_nombreventa            varchar(255)
  declare @stl_id                   int  
  declare @sti_cantidad             decimal(18,6)
  declare @cant_kits                decimal(18,6)
  declare @pr_kitItems              decimal(18,6)

  declare @prfk_id                  int

  declare @pr_item                  varchar(255)
  declare @prns_cantidad            int
  declare @pr_id_item               int

--------------------------------------------------------------------------------------------------------

    set @sti_cantidad = 0

    -- Si es el movimiento de consumo
    -- obtengo la cantidad de insumos
    --
    if @@bConsumo <> 0 begin

      set @pr_kitItems = 0

      select @pr_kitItems = sum(prk_cantidad) 
      from ProductoKit pk inner join Producto pr on pk.pr_id_item = pr.pr_id
                          inner join ParteProdKitItem ppk on pk.prfk_id = ppk.prfk_id
      where ppk_id = @@ppk_id
        and pr.pr_llevastock <> 0

      set @pr_kitItems = IsNull(@pr_kitItems,0)

    end else begin

      set @pr_kitItems = 1

    end

    select @cant_kits = sum(ppki_cantidad) 
    from ParteProdKitItem 
    where ppk_id = @@ppk_id

    set @ppki_cantidad  = @ppki_cantidad * @pr_kitItems

    -- Cantidades del stock
    --
    select @sti_cantidad = sum(sti_ingreso) 
    from 
          StockItem 
    where 
          st_id = @st_id

    set @sti_cantidad = IsNull(@sti_cantidad,0)

    if @sti_cantidad <> @ppki_cantidad begin

      exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
      if @@error <> 0 goto ControlError  


      insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                         values (@@aud_id, 
                                 @audi_id,
                                 'El parte de produccion indica ' + convert(varchar,convert(decimal(18,2),@cant_kits)) 
                                 + ' Kit "' + @pr_nombreventa + '" compuesto(s) en total por '
                                 + convert(varchar,convert(decimal(18,2),@ppki_cantidad)) + ' items'
                                 + ' y el movimiento de stock indica ' + convert(varchar,convert(decimal(18,2),@sti_cantidad))
                                 + ' (comp.:' + @ppk_nrodoc + ' nro.: '+ @ppk_numero + ')',
                                 3,
                                 1,
                                 @doct_id,
                                 @@ppk_id
                                )

    end

--------------------------------------------------------------------------------------------------------


  declare c_ppk_item insensitive cursor for

    select 
            sum(ppki_cantidad),
            ppki.pr_id,
            ppki.prfk_id,
            pr_nombreventa,
            stl_id
    from
          ParteProdKitItem ppki inner join Producto pr on ppki.pr_id = pr.pr_id

    where ppk_id = @@ppk_id
      and pr_llevanroserie <> 0

    group by
            ppki.pr_id,
            ppki.prfk_id,
            pr_nombreventa,
            stl_id

  open c_ppk_item

  fetch next from c_ppk_item into 
                                  @ppki_cantidad,
                                  @pr_id,
                                  @prfk_id,
                                  @pr_nombreventa,
                                  @stl_id

  while @@fetch_status = 0
  begin

    delete #KitItems
    delete #KitItemsSerie

    if @@bConsumo = 0  set @cant_kits = @ppki_cantidad

    if @@bConsumo <> 0 begin

      exec sp_StockProductoGetKitInfo @pr_id, 0, 0, 1, 1, 1, @prfk_id, 1

    end else begin

      exec sp_StockProductoGetKitInfo @pr_id, 0

    end

    if @@bConsumo = 0 begin

      declare c_ppk_itemKit insensitive cursor for

      select 
              k.pr_id,
              pr_nombrecompra,
              cantidad 
      from 
              #KitItemsSerie k inner join Producto p on k.pr_id = p.pr_id

      where pr_llevanroserie <> 0

    end else begin


      declare c_ppk_itemKit insensitive cursor for

      select 
              0,
              '',
              sum(cantidad)
      from 
              #KitItemsSerie k inner join Producto p on k.pr_id = p.pr_id

      where pr_llevanroserie <> 0

    end

    open c_ppk_itemKit

    fetch next from c_ppk_itemKit into @pr_id_item, @pr_item, @prns_cantidad

    while @@fetch_status=0
    begin

      set @prns_cantidad = @prns_cantidad * @cant_kits
      set @sti_cantidad  = 0

      select @sti_cantidad = sum(sti_ingreso) 
      from 
            StockItem 
      where 
            st_id            = @st_id
        and (pr_id            = @pr_id_item or @pr_id_item = 0)
        and prns_id is not null
        and IsNull(stl_id,0) = IsNull(@stl_id,0)

      set @sti_cantidad = IsNull(@sti_cantidad,0)

      if @sti_cantidad <> @prns_cantidad begin

        exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
        if @@error <> 0 goto ControlError  

        insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
                           values (@@aud_id, 
                                   @audi_id,
                                   'El parte de produccion indica que el Kit "' + @pr_nombreventa +
                                   + '" lleva ' + convert(varchar,convert(decimal(18,2),@prns_cantidad))
                                   + ' "' + @pr_item
                                   + '" y el movimiento de stock indica ' + convert(varchar,convert(decimal(18,2),@sti_cantidad))
                                   + ' (comp.:' + @ppk_nrodoc + ' nro.: '+ @ppk_numero + ')',
                                   3,
                                   1,
                                   @doct_id,
                                   @@ppk_id
                                  )
      end

      fetch next from c_ppk_itemKit into @pr_id_item, @pr_item, @prns_cantidad
    end

    close c_ppk_itemKit

    deallocate c_ppk_itemKit                  

    fetch next from c_ppk_item into 
                                    @ppki_cantidad,
                                    @pr_id,
                                    @prfk_id,
                                    @pr_nombreventa,
                                    @stl_id
  end

  close c_ppk_item

  deallocate c_ppk_item

ControlError:

  drop table #KitItems
  drop table #KitItemsSerie

end
GO