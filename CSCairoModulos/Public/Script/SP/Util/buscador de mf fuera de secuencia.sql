declare @mf_id       int
declare @mf_nrodoc   varchar(255)
declare @mf_fecha    datetime
declare @mf_id2     int
declare @mf_nrodoc2  varchar(255)
declare @mf_fecha2   datetime
declare @n          int
declare @doc_id      int
declare @q          int

declare @obs        varchar(255)
declare @obs2       varchar(255)

declare c_docs insensitive cursor for select mf_id, mf_fecha, mf_nrodoc,doc_id from movimientofondo order by mf_nrodoc
open c_docs
fetch next from c_docs into @mf_id, @mf_fecha, @mf_nrodoc, @doc_id
while @@fetch_status=0
begin

  set @n = 0
  set @q = 0
  set @mf_id2 = @mf_id
  while @n < 10 begin

    select @mf_id2 = min(mf_id) from movimientofondo where mf_id > @mf_id2 and doc_id = @doc_id
    set @n = @n +1

    select @mf_fecha2 = mf_fecha, @mf_nrodoc2 = mf_nrodoc
    from movimientofondo where mf_id = @mf_id2


    if @mf_nrodoc < @mf_nrodoc2 and datediff(d,@mf_fecha2,@mf_fecha)>200 begin
      set @q = @q + 1
    end

    if @q>9 begin

      select @obs  = mf_descrip from movimientofondo where mf_id = @mf_id
      select @obs2 = mf_descrip from movimientofondo where mf_id = @mf_id2

      print 'Documento fuera de secuencia (' +convert(varchar,@mf_id)+ ')' 
            + @mf_nrodoc + ' ' + convert(varchar(12),@mf_fecha,105) 
            + ', '+ @mf_nrodoc2 + ' ' + convert(varchar(12),@mf_fecha2,105) 
            + ' (' +convert(varchar,@mf_id2)+ ') ' 
            + '(' + @obs
            + ') ('
            + @obs2 + ') '
            + convert(varchar,datediff(d,@mf_fecha2,@mf_fecha)) 
      goto next_mf
    end
  end
next_mf:

  fetch next from c_docs into @mf_id, @mf_fecha, @mf_nrodoc, @doc_id
end

close c_docs
deallocate c_docs

