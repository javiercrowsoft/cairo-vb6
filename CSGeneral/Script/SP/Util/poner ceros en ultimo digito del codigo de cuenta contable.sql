declare @cue_codigo varchar(50)
declare @cue_id int

declare c_cue insensitive cursor for select cue_identificacionexterna from cuenta where identificacionexterna<> ''

open c_cue

  fetch next from c_cue into @@cue_codigo, @cue_id

while @@fetch_status=0
begin

  set @n = len(@cue_codigo)
  set @k = 0

  while @k = 0 and @n > 0
  begin


    if substring(@cue_codigo,@n,1)='.' set @k = @n

    set @n = @n-1

  end

  if @k > 0 begin

    set @cue_codigo = substring(@cue_codigo, 1, @k) + right('00'+substring(@cue_codigo,@k+1,100),2)

  end

  fetch next from c_cue into @@cue_codigo, @cue_id

end

close c_cue

deallocate c_cue
