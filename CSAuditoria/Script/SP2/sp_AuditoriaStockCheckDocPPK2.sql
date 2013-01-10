-- Script de Chequeo de Integridad de:

-- 1 - Control de documentos que mueven stock

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaStockCheckDocPPK2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaStockCheckDocPPK2]

go

create procedure sp_AuditoriaStockCheckDocPPK2 (

  @@ppk_id      int,
  @@st_id       int,
  @@bSuccess    tinyint out,
  @@bErrorMsg   varchar(5000) out,
  @@bIsConsumo  tinyint
)
as

begin

  set nocount on

  declare @bError tinyint

  set @bError     = 0
  set @@bSuccess   = 0
  set @@bErrorMsg = '@@ERROR_SP:'

  declare @st_id         int
  declare @audi_id       int
  declare @doct_id      int
  declare @ppk_nrodoc   varchar(50) 
  declare @ppk_numero   varchar(50) 

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


-------------------------------------------------------------------------------------
  declare @sti_produccion  int
  declare @sti_consumo    int

  select @sti_consumo = st_id2, @sti_produccion = st_id1 from ParteProdKit where ppk_id = @@ppk_id

  if exists(select * from StockItem where sti_ingreso = 0 and sti_salida = 0 and st_id = @sti_consumo)
  begin
    set @bError = 1
    set @@bErrorMsg = @@bErrorMsg 
                      + 'El movimiento de stock de consumo asociado al parte de produccion posee items cuya cantidad de ingreso y egreso es cero. Este error puede darse por que no se indico una cantidad en los lotes de stock de los insumos que llevan numero de lote.'
                      + char(10)
    goto ControlError
  end

  if exists(select * from StockItem where sti_ingreso = 0 and sti_salida = 0 and st_id = @sti_produccion)
  begin
    set @bError = 1
    set @@bErrorMsg = @@bErrorMsg 
                      + 'El movimiento de stock de produccion asociado al parte de produccion posee items cuya cantidad de ingreso y egreso es cero.'
                      + char(10)
    goto ControlError
  end
-------------------------------------------------------------------------------------
                              
  set @st_id = @@st_id

  select 
            @doct_id      = doct_id,
            @ppk_nrodoc  = ppk_nrodoc,
            @ppk_numero  = convert(varchar,ppk_numero)

  from ParteProdKit where ppk_id = @@ppk_id


  declare @ppki_id                  int
  declare @ppki_cantidad            decimal(18,6)
  declare @pr_id                    int
  declare @pr_nombreventa            varchar(255)
  declare @pr_llevastock            smallint
  declare @pr_eskit                  smallint
  declare @pr_kitItems              decimal(18,6)
  declare @pr_resumido              tinyint
  declare @pr_llevanroserie          smallint
  declare @sti_cantidad             decimal(18,6)
  declare @cant_kits                decimal(18,6)

  declare @pr_item                  varchar(255)
  declare @prns_cantidad            int
  declare @pr_id_item               int

  --//////////////////////////////
  --
  -- Sin numero de serie
  --
    declare c_ppk_item insensitive cursor for
  
      select 
              sum(ppki_cantidad),
              ppki.pr_id,
              pr_nombreventa,
              pr_llevastock,
              pr_kitResumido,
              pr_eskit,
              pr_kitItems,
              pr_llevanroserie
      from
            ParteProdKitItem ppki inner join Producto pr on ppki.pr_id = pr.pr_id
  
      where ppk_id = @@ppk_id and (pr_llevanroserie = 0 or pr_eskit <> 0)

      group by
              ppki.pr_id,
              pr_nombreventa,
              pr_llevastock,
              pr_kitResumido,
              pr_eskit,
              pr_kitItems,
              pr_llevanroserie
  
    open c_ppk_item
  
    fetch next from c_ppk_item into 
                                    @ppki_cantidad,
                                    @pr_id,
                                    @pr_nombreventa,
                                    @pr_llevastock,
                                    @pr_resumido,
                                    @pr_eskit,
                                    @pr_kitItems,
                                    @pr_llevanroserie
  
    while @@fetch_status = 0
    begin

      set @sti_cantidad = 0

      if @pr_llevastock <> 0 begin

        if @pr_eskit <> 0 and @@bIsConsumo = 0 begin

          if @pr_resumido <> 0 set @pr_kitItems = 1

          set @cant_kits      = @ppki_cantidad
          set @ppki_cantidad  = @ppki_cantidad * @pr_kitItems

          select @sti_cantidad = sum(sti_ingreso) 
          from 
                StockItem 
          where 
                st_id            = @st_id
            and pr_id_kit         = @pr_id

        end else begin

          select @sti_cantidad = sum(sti_ingreso) 
          from 
                StockItem 
          where 
                st_id     = @st_id
            and pr_id     = @pr_id
            and pr_id_kit is null

        end

        set @sti_cantidad = IsNull(@sti_cantidad,0)

        if @sti_cantidad <> @ppki_cantidad begin

          if @pr_eskit <> 0 and @@bIsConsumo = 0 begin

            set @bError = 1
            set @@bErrorMsg = @@bErrorMsg 
                              + 'El parte de produccion indica ' + convert(varchar,convert(decimal(18,2),@cant_kits)) 
                              + ' Kit "' + @pr_nombreventa + '" compuesto(s) en total por '
                              + convert(varchar,convert(decimal(18,2),@ppki_cantidad)) + ' items'
                              + ' y el movimiento de stock indica ' + convert(varchar,convert(decimal(18,2),@sti_cantidad))
                              + char(10)

          end else begin

            set @bError = 1
            set @@bErrorMsg = @@bErrorMsg 
                              + 'El parte de produccion indica ' + convert(varchar,convert(decimal(18,2),@ppki_cantidad))
                              + ' "' + @pr_nombreventa + '" y el movimiento de stock indica '
                              + convert(varchar,convert(decimal(18,2),@sti_cantidad))
                              + char(10)

          end
        end

        -- Ahora los numeros de serie de los que son kit
        --
        if @pr_llevanroserie <> 0 and @pr_eskit <> 0 and @@bIsConsumo = 0 begin

          delete #KitItems
          delete #KitItemsSerie

          exec sp_StockProductoGetKitInfo @pr_id, 0

          declare c_ppk_itemKit insensitive cursor for

            select 
                    k.pr_id,
                    pr_nombrecompra,
                    cantidad 
            from 
                    #KitItemsSerie k inner join Producto p on k.pr_id = p.pr_id

            where pr_llevanroserie <> 0

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
              and pr_id            = @pr_id_item
              and pr_id_kit        = @pr_id

            set @sti_cantidad = IsNull(@sti_cantidad,0)
  
            if @sti_cantidad <> @prns_cantidad begin
  
              set @bError = 1
              set @@bErrorMsg = @@bErrorMsg 
                                + 'El parte de produccion indica que el Kit "' + @pr_nombreventa +
                                + '" lleva ' + convert(varchar,convert(decimal(18,2),@prns_cantidad))
                                + ' "' + @pr_item
                                + '" y el movimiento de stock indica ' + convert(varchar,convert(decimal(18,2),@sti_cantidad))
                                + char(10)
  
            end

            fetch next from c_ppk_itemKit into @pr_id_item, @pr_item, @prns_cantidad
          end

          close c_ppk_itemKit

          deallocate c_ppk_itemKit                  

        end

      end else begin

        if exists(select * from StockItem where st_id = @st_id and pr_id = @pr_id) begin

          set @bError = 1
          set @@bErrorMsg = @@bErrorMsg 
                            + 'Este parte de produccion indica el producto "' + @pr_nombreventa 
                            + '" que no mueve stock pero esta incluido en el movimiento '
                            + 'de stock asociado a Este parte de produccion '
                            + char(10)

        end

      end
  
      fetch next from c_ppk_item into 
                                      @ppki_cantidad,
                                      @pr_id,
                                      @pr_nombreventa,
                                      @pr_llevastock,
                                      @pr_resumido,
                                      @pr_eskit,
                                      @pr_kitItems,
                                      @pr_llevanroserie
    end
  
    close c_ppk_item
  
    deallocate c_ppk_item


  --//////////////////////////////
  --
  -- Con numero de serie
  --
    declare c_ppk_item insensitive cursor for
  
      select 
              ppki_id,
              ppki_cantidad,
              ppki.pr_id,
              pr_nombreventa,
              pr_eskit,
              pr_kitItems
      from
            ParteProdKitItem ppki inner join Producto pr on ppki.pr_id = pr.pr_id
  
      where ppk_id = @@ppk_id and pr_llevanroserie <> 0 and pr_eskit = 0
  
    open c_ppk_item
  
    fetch next from c_ppk_item into 
                                    @ppki_id,
                                    @ppki_cantidad,
                                    @pr_id,
                                    @pr_nombreventa,
                                    @pr_eskit,
                                    @pr_kitItems
  
    while @@fetch_status = 0
    begin

      set @sti_cantidad = 0

      select @sti_cantidad = sum(sti_ingreso) 
      from 
            StockItem 
      where 
            st_id       = @st_id
        and pr_id       = @pr_id
        and sti_grupo   = @ppki_id
        and pr_id_kit   is null

      set @sti_cantidad = IsNull(@sti_cantidad,0)

      if @sti_cantidad <> @ppki_cantidad begin

        set @bError = 1
        set @@bErrorMsg = @@bErrorMsg 
                          + 'El parte de produccion indica ' + convert(varchar,convert(decimal(18,2),@ppki_cantidad))
                          + ' "' + @pr_nombreventa + '" y el movimiento de stock indica '
                          + convert(varchar,convert(decimal(18,2),@sti_cantidad))
                          + char(10)
      end

      fetch next from c_ppk_item into 
                                      @ppki_id,
                                      @ppki_cantidad,
                                      @pr_id,
                                      @pr_nombreventa,
                                      @pr_eskit,
                                      @pr_kitItems
    end
  
    close c_ppk_item
  
    deallocate c_ppk_item

ControlError:

  drop table #KitItems
  drop table #KitItemsSerie

  -- No hubo errores asi que todo bien
  --
  if @bError = 0 set @@bSuccess = 1

end
GO