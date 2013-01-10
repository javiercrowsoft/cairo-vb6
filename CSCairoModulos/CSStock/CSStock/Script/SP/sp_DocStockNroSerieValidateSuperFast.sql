drop procedure sp_DocStockNroSerieValidateSuperFast
go
create procedure sp_DocStockNroSerieValidateSuperFast

as
begin

  create table #t_numero_en_la_empresa (prns_id int)

  insert into #t_numero_en_la_empresa (prns_id)
  
        select prns_id
        from StockItem 
        where depl_id not in (-2,-3) 
        group by prns_id 
        having sum(sti_ingreso-sti_salida) <> 0

  declare @prns_id int
  declare @pr_id int
  
  declare c_a_validar insensitive cursor for
  
  select prns_id, pr_id 
  
  from productonumeroserie prns
  
  where
    not exists (
        select prns_id
        from #t_numero_en_la_empresa
        where prns_id = prns.prns_id
      )
    and depl_id <> -2 and depl_id <> -3
  
  union
  
  select prns_id, pr_id 
  
  from productonumeroserie prns
  
  where
    exists (
        select prns_id
        from #t_numero_en_la_empresa
        where prns_id = prns.prns_id
      )
    and (depl_id = -2 or depl_id = -3)
  
  open c_a_validar
  
  fetch next from c_a_validar into @prns_id, @pr_id
  while @@fetch_status=0
  begin
  
  
    exec sp_DocStockNroSerieValidate @pr_id, @prns_id
  
    fetch next from c_a_validar into @prns_id, @pr_id
  end
  
  close c_a_validar
  deallocate c_a_validar

  select prns_id, pr_id, depl_id
  
  from productonumeroserie prns
  
  where
    not exists (
        select prns_id
        from #t_numero_en_la_empresa
        where prns_id = prns.prns_id
      )
    and depl_id <> -2 and depl_id <> -3
  
  union
  
  select prns_id, pr_id, depl_id 
  
  from productonumeroserie prns
  
  where
    exists (
        select prns_id
        from #t_numero_en_la_empresa
        where prns_id = prns.prns_id
      )
    and (depl_id = -2 or depl_id = -3)

end