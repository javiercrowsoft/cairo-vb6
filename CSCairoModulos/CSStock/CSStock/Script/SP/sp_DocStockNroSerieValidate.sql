if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockNroSerieValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockNroSerieValidate]

/*

exec sp_docstockcachecreate
exec sp_DocStockNroSerieValidate 0,91457


select sum(sti_ingreso)-sum(sti_salida) from stockitem where prns_id = 91457 and depl_id =-3

select * from StockCache where prns_id = 5595

select * from StockItem where prns_id = 91457 and depl_id = -2 

                      group by prns_id, depl_id 


select * from StockItem where prns_id = 6
select * from productonumeroserie where prns_codigo = '14068 (D-0007003)'
select * from parteprodkit

1379

-------------------------------------------------------------------------------------------
    update ProductoNumeroSerie set pr_id_kit = si.pr_id_kit from stockItem si
    where ProductoNumeroSerie.prns_id = si.prns_id
      and sti_id = (  select top 1 sti_id
                      from StockItem
                      where prns_id = si.prns_id 
                        and pr_id_kit is not null
                      order by st_id desc
                    )
      and ppk_id is not null and ProductoNumeroSerie.pr_id_kit is null
-------------------------------------------------------------------------------------------

*/

go
create procedure sp_DocStockNroSerieValidate (
  @@pr_id     int = 0,
  @@prns_id   int = 0,
  @@bDeleteSinMovimientos tinyint = 0
)
as

begin

  declare @MsgError            varchar(5000) set @MsgError = ''

  set nocount on

  -- Actualiza el deposito segun la tabla stock cache
  --
  declare @prns_id   int
  declare @depl_id   int
  declare @pr_id_kit int
  declare @cantidad          decimal(18,6)
  declare @depositosConStock int


  -- Vincula los numeros de serie con el ultimo kit que los consumio
  --
  declare c_ns insensitive cursor for 
  select prns_id from ProductoNumeroSerie where (pr_id = @@pr_id or @@pr_id = 0)
                                            and (prns_id = @@prns_id or @@prns_id = 0)
  open c_ns

  fetch next from c_ns into @prns_id
  while @@fetch_status=0
  begin

    set @pr_id_kit = null

    select top 1 @pr_id_kit = pr_id_kit 
    from StockItem 
    where prns_id = @prns_id 
      and pr_id_kit is not null
    order by st_id desc

    update ProductoNumeroSerie set pr_id_kit = @pr_id_kit where prns_id = @prns_id

    fetch next from c_ns into @prns_id
  end

  close c_ns
  deallocate c_ns

  declare c_ns insensitive cursor for 
  select prns_id,pr_id_kit from ProductoNumeroSerie where (pr_id = @@pr_id or pr_id_kit = @@pr_id or @@pr_id = 0)
                                                      and (prns_id = @@prns_id or @@prns_id = 0)

  open c_ns

  fetch next from c_ns into @prns_id, @pr_id_kit
  while @@fetch_status=0
  begin

    set @depl_id = null

    select @pr_id_kit = IsNull(@pr_id_kit,0)

    select @cantidad = sum(stc_cantidad) from StockCache where  prns_id = @prns_id 
                                                            and depl_id not in (-2,-3)
                                                            and IsNull(pr_id_kit,0) = @pr_id_kit  
    if IsNull(@cantidad,0) > 0 begin

      select @depositosConStock = count(*) from StockCache where prns_id = @prns_id and stc_cantidad > 0

      if @depositosConStock = 1
        select top 1 @depl_id = depl_id from StockCache where prns_id = @prns_id and stc_cantidad > 0 

      else begin
        select top 1 @depl_id = s.depl_id 
        from StockCache s inner join StockItem si on      s.depl_id = si.depl_id 
                                                      and sti_ingreso > 0
                                                      and s.prns_id = si.prns_id
        where s.prns_id = @prns_id and stc_cantidad > 0
        order by si.st_id desc
      end

      if @depl_id is not null begin

        update ProductoNumeroSerie set depl_id = @depl_id where prns_id = @prns_id
      end

    end else begin

      select @cantidad = sum(sti_ingreso)-sum(sti_salida) from stockitem where prns_id = @prns_id and depl_id =-3

      if IsNull(@cantidad,0) > 0 update ProductoNumeroSerie set depl_id = -3 where prns_id = @prns_id
      else begin                      

        -- Si el numero de serie no existe en produccion y si existen en tercero, es por que lo
        -- compre y lo vendi y como al comprarlo entra por -3 y al venderlo sale por -3
        -- en -3 tengo cero, pero esta bien, asi que lo dejo en el deposito de terceros
        -- Excepto cuando es un kit ya que en este caso estoy produciendolo y por ende
        -- sale de -2 cuando lo armo y vuelve a -2 cuando lo desarmo y queda -2 en cero
        -- (-2 es produccion :)
        -- es decir que si lo tengo en produccion y en tercero y en ambos en cero
        -- lo dejo en el ultimo deposito que lo movio
        --
        if not exists(select * from StockItem 
                      where prns_id = @prns_id 
                        and depl_id = -2 
                        and IsNull(pr_id_kit,0) = @pr_id_kit 
                      group by prns_id, depl_id 
                      having sum(sti_ingreso)-sum(sti_salida)>0
                    ) 
          and
               exists(select * from StockItem where prns_id = @prns_id and depl_id = -3)
        begin

          select top 1 @depl_id = depl_id from StockItem
          where prns_id = @prns_id 
            and sti_ingreso > 0
            and depl_id in (-2,-3)
          order by sti_id desc
          
          if @depl_id is not null begin

            update ProductoNumeroSerie set depl_id = @depl_id where prns_id = @prns_id  
          end

        end else

          if @depl_id is not null begin
  
            update ProductoNumeroSerie set depl_id = @depl_id where prns_id = @prns_id  

          end else begin

            select top 1 @depl_id = depl_id from StockItem 
            where prns_id = @prns_id 
              and sti_ingreso > 0
              and depl_id in (-2,-3)
            order by sti_id desc
            
            if @depl_id is not null begin
  
              update ProductoNumeroSerie set depl_id = @depl_id where prns_id = @prns_id  
            end
          end
      end
    end

    fetch next from c_ns into @prns_id,@pr_id_kit
  end

  close c_ns
  deallocate c_ns

  begin transaction

  -- Desvincula los numeros de serie que estan con kits
  -- que no existen
  --
  update ProductoNumeroSerie set pr_id_kit = null 
  where prns_id in (
                      select prns_id from ProductoNumeroSerie ps
                      where not exists (select * from StockItem si inner join StockItemKit sk on si.stik_id = sk.stik_id
                                        where si.pr_id      = ps.pr_id 
                                          and sk.pr_id      = ps.pr_id_kit
                                          and si.prns_id    = ps.prns_id
                                          )
                        and pr_id_kit is not null
                   )
  and pr_id_kit is not null
  and (prns_id = @@prns_id or @@prns_id = 0)
  and (pr_id = @@pr_id or pr_id_kit = @@pr_id or @@pr_id = 0)

  -- Desvincula los numeros de serie que estan con partes que no los mencionan
  --
  update ProductoNumeroSerie set ppk_id = null 
  where not exists (
                      select prns_id from StockItem si inner join ParteProdKit ppk on si.st_id = ppk.st_id1
                      where prns_id = ProductoNumeroSerie.prns_id
                   )
  and ppk_id is not null
  and (prns_id = @@prns_id or @@prns_id = 0)
  and (pr_id = @@pr_id or pr_id_kit = @@pr_id or @@pr_id = 0)


  if @@bDeleteSinMovimientos <> 0 begin

    delete ProductoNumeroSerie 
    where not exists(select prns_id from StockItem where prns_id = ProductoNumeroSerie.prns_id)
      and (prns_id = @@prns_id or @@prns_id = 0)
      and (pr_id = @@pr_id or pr_id_kit = @@pr_id or @@pr_id = 0)

  end

  commit transaction

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al validar los numeros de serie. sp_DocStockNroSerieValidate. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end
end