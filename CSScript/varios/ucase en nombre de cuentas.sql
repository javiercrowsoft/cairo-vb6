declare @cue_nombre varchar(255)
declare @cue_id     int
declare @nombre     varchar(255)
declare @n          int
declare @c          char(1)
declare @ucase      smallint

declare cue insensitive cursor for select cue_id,cue_nombre from cuenta

open cue
fetch next from cue into @cue_id,@cue_nombre
while @@fetch_status=0
begin

  set @n=1
  set @nombre = ''
  set @ucase = 0

  while @n <= len(@cue_nombre)
  begin

    set @c = substring(@cue_nombre, @n,1)

    if @n=1 or @c = ' '  set @ucase = 1

    if @ucase <> 0 begin
      set @nombre = @nombre + upper(@c)
      if @c not in(' ','/','\','-','.',',','(',')') set @ucase = 0
    end
    else
      set @nombre = @nombre + lower(@c)

    set @n = @n+1

  end

  set @nombre = replace(@nombre, ' en ', ' en ')
  set @nombre = replace(@nombre, ' por ', ' por ')
  set @nombre = replace(@nombre, ' de ', ' de ')
  set @nombre = replace(@nombre, ' para ', ' para ')
  set @nombre = replace(@nombre, ' entre ', ' entre ')
  set @nombre = replace(@nombre, ' hasta ', ' hasta ')
  set @nombre = replace(@nombre, ' sin ', ' sin ')
  set @nombre = replace(@nombre, ' sobre ', ' sobre ')
  set @nombre = replace(@nombre, ' al ', ' al ')
  set @nombre = replace(@nombre, ' el ', ' el ')
  set @nombre = replace(@nombre, ' las ', ' las ')
  set @nombre = replace(@nombre, ' los ', ' los ')
  set @nombre = replace(@nombre, ' y ', ' y ')
  set @nombre = replace(@nombre, ' a ', ' a ')
  set @nombre = replace(@nombre, ' e ', ' e ')
  set @nombre = replace(@nombre, ' i ', ' i ')
  set @nombre = replace(@nombre, ' o ', ' o ')
  set @nombre = replace(@nombre, ' u ', ' u ')
  set @nombre = replace(@nombre, ' del ', ' del ')

  --select @nombre
  update cuenta set cue_nombre = @nombre where cue_id = @cue_id

  fetch next from cue into @cue_id,@cue_nombre
end
close cue
deallocate cue