drop procedure sp_DocStockNroSerieValidateDepositoLogico
go
create procedure sp_DocStockNroSerieValidateDepositoLogico

as

begin

  set nocount on
  
  declare @depl_id int
  
  declare c_dep insensitive cursor for
  select depl_id from depositologico where depl_id <> -3
  
  open c_dep
  
  fetch next from c_dep into @depl_id
  while @@fetch_status=0
  begin
  
    update ProductoNumeroSerie set depl_id = @depl_id
    where prns_id in
    (
            select prns_id
            from StockItem 
            where depl_id = @depl_id
            group by prns_id 
            having sum(sti_ingreso-sti_salida) > 0
    )
  
    fetch next from c_dep into @depl_id
  end
  close c_dep
  deallocate c_dep

  -- Tercero
  --
  update ProductoNumeroSerie set depl_id = -3
  where 
  -- No tiene que haber ningun deposito con stock
  not exists
  (
          select depl_id
          from StockItem 
          where prns_id = ProductoNumeroSerie.prns_id 
            and depl_id <> -3
          group by depl_id
          having sum(sti_ingreso-sti_salida) > 0
  )
  -- Tiene que haber estado en tercero
  and exists( select depl_id
              from StockItem 
              where prns_id = ProductoNumeroSerie.prns_id
                and depl_id = -3
            )
  
  -- Interno
  --
  update ProductoNumeroSerie set depl_id = -3
  where 
  -- No tiene que haber ningun deposito con stock
  not exists
  (
          select depl_id
          from StockItem 
          where prns_id = ProductoNumeroSerie.prns_id 
            and depl_id <> -3
          group by depl_id
          having sum(sti_ingreso-sti_salida) > 0
  )
  -- No tiene que haber estado en tercero
  and not exists( select depl_id
              from StockItem 
              where prns_id = ProductoNumeroSerie.prns_id
                and depl_id = -3
            )

end