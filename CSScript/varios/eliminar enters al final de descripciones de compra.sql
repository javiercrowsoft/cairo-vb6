declare @fc_id int
declare @fc_descrip varchar(255)

declare c_facturas insensitive cursor for select fc_id, fc_descrip from FacturaCompra

open c_facturas

fetch next from c_facturas into @fc_id, @fc_descrip
while @@fetch_status=0
begin


  while right(@fc_descrip,1)=char(13) or right(@fc_descrip,1)=char(10) 
  begin
    if len(@fc_descrip) <= 1 set @fc_descrip = ''
    else                     set @fc_descrip = left(@fc_descrip,len(@fc_descrip)-1)
  end

  update FacturaCompra set fc_descrip = @fc_descrip where fc_id = @fc_id


  fetch next from c_facturas into @fc_id, @fc_descrip
end

close c_facturas

deallocate c_facturas