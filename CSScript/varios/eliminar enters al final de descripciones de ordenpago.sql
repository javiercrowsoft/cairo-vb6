declare @opg_id int
declare @opg_descrip varchar(255)

declare c_facturas insensitive cursor for select opg_id, opg_descrip from OrdenPago

open c_facturas

fetch next from c_facturas into @opg_id, @opg_descrip
while @@fetch_status=0
begin


  while right(@opg_descrip,1)=char(13) or right(@opg_descrip,1)=char(10) 
  begin
    if len(@opg_descrip) <= 1 set @opg_descrip = ''
    else                      set @opg_descrip = left(@opg_descrip,len(@opg_descrip)-1)
  end

  update OrdenPago set opg_descrip = @opg_descrip where opg_id = @opg_id


  fetch next from c_facturas into @opg_id, @opg_descrip
end

close c_facturas

deallocate c_facturas