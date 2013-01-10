/*
update asientoitem set asi_debe = round(asi_debe,2), asi_haber = round(asi_haber,2)

select ast.as_id, sum(asi_debe) - sum(asi_haber),sum(asi_debe) , sum(asi_haber)  
from asiento ast inner join asientoitem asi on ast.as_id = asi.as_id
where ast.as_id = 2510
group by ast.as_id
having sum(asi_debe) <> sum(asi_haber)
*/

--begin tran

declare @dif     decimal(18,6)
declare @as_id   int
declare @asi_id int

set nocount on

declare c_ast_as insensitive cursor for

    select ast.as_id, sum(asi_debe) - sum(asi_haber) 
    from asiento ast inner join asientoitem asi on ast.as_id = asi.as_id
    group by ast.as_id
    having sum(asi_debe) <> sum(asi_haber)

open c_ast_as

fetch next from c_ast_as into @as_id, @dif
while @@fetch_status=0
begin

  set @asi_id = null

  if @dif < 0 
    select @asi_id = min(asi_id) from asientoitem where as_id = @as_id and asi_debe <> 0
  else
    select @asi_id = min(asi_id) from asientoitem where as_id = @as_id and asi_haber <> 0


  if @asi_id is not null begin
    if @dif < 0 
      update asientoitem set asi_debe = asi_debe + abs(@dif) where asi_id = @asi_id
    else
      update asientoitem set asi_haber = asi_haber + abs(@dif) where asi_id = @asi_id
  end

  fetch next from c_ast_as into @as_id, @dif
end

close c_ast_as
deallocate c_ast_as

--rollback tran