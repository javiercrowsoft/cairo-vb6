drop procedure sp_DocCobranzaUpdateFechaControlAcceso
go
create procedure sp_DocCobranzaUpdateFechaControlAcceso

as
begin

declare fechas insensitive cursor 
  for 
  select fca_id from FechaControlAcceso where fca_id in (
  select fca_id from documento where doct_id = 13
  )

declare @fca_id int
declare @hoy datetime
declare @ayer datetime

set @hoy = getdate()
set @hoy = dateadd(hh,-datepart(hh,@hoy),@hoy)
set @hoy = dateadd(mi,-datepart(mi,@hoy),@hoy)
set @hoy = dateadd(ss,-datepart(ss,@hoy),@hoy)
set @hoy = dateadd(ms,-datepart(ms,@hoy),@hoy)
set @ayer = dateadd(d,-1,@hoy)

--select @hoy

open fechas
fetch next from fechas into @fca_id
while @@fetch_status =0
begin

  update FechaControlAcceso set fca_fechadesde = @ayer where fca_id = @fca_id
  update FechaControlAcceso set fca_fechahasta = @hoy where fca_id = @fca_id

  fetch next from fechas into @fca_id
end

close fechas
deallocate fechas

/*
  select * from FechaControlAcceso where fca_id in (
  select fca_id from documento where doct_id = 13
  )
*/

end
go