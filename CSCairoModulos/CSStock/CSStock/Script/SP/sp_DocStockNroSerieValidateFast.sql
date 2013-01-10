if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockNroSerieValidateFast]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockNroSerieValidateFast]

/*

select * from producto where pr_codigo like 'regs'

sp_DocStockNroSerieValidateFast '657',0

*/

go
create procedure sp_DocStockNroSerieValidateFast (
  @@pr_id     int = 0,
  @@prns_id   int = 0
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

    end

    fetch next from c_ns into @prns_id,@pr_id_kit
  end

  close c_ns
  deallocate c_ns

  return
ControlError:

  set @MsgError = 'Ha ocurrido un error al validar los numeros de serie. sp_DocStockNroSerieValidateFast. ' + IsNull(@MsgError,'')
  raiserror (@MsgError, 16, 1)

  if @@trancount > 0 begin
    rollback transaction  
  end
end