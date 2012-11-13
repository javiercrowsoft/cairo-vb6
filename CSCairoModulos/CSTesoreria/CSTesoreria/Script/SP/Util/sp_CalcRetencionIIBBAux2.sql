
-- select * from retencion

declare @opg_id 			int
declare @opgi_importe decimal(18,6)
declare @base 				decimal(18,6)
declare @retencion 		decimal(18,6)

declare c_opg_aux insensitive cursor for
select opg.opg_id, opgi_importe 
from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id
where ret_id in (8,9)
	and est_id <> 7

open c_opg_aux

fetch next from c_opg_aux into @opg_id, @opgi_importe
while @@fetch_status=0
begin

	set @base = 0
	set @retencion = 0

	exec sp_CalcRetencionIIBBAux @opg_id, @base out, @retencion out

	if abs(isnull(@retencion,0) - isnull(@opgi_importe,0))>0.01 begin

		select @opgi_importe as opgi_importe, @opg_id as opg_id, @retencion as retencion
	end

	fetch next from c_opg_aux into @opg_id, @opgi_importe
end

close c_opg_aux
deallocate c_opg_aux