if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_ArbGetDecendencia]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbGetDecendencia]

go
/*
  creado:    15/05/2000
  Proposito:  Devuelve toda la decendencia de una rama incluyendo a la misma rama

  insert into exec:  - SP_ArbCopiarRama
        - SP_ArbBorrarRama
        - SP_ArbCortarRama 

SP_ArbGetDecendencia 5722,1,1,0

*/
create procedure SP_ArbGetDecendencia (
  @@ram_id     int,
  @@incluir_ram_id   smallint = 1,
  @@incluir_ram_id_padre  smallint = 0,  -- este default es necesario para: SP_ArbCopiarRama, SP_ArbBorrarRama
  @@incluir_nombre  smallint = 0,  -- este default es necesario para: SP_ArbCopiarRama, SP_ArbBorrarRama
  @@incluir_arb_id  smallint = 0  -- este default es necesario para: SP_ArbCopiarRama, SP_ArbBorrarRama
)
as

set nocount on

create table #t_rama(
ram_id     int not null,
n          int not null,
ram_id_padre   int not null,
arb_id    int not null,
orden     int not null    
)

if @@ram_id = 0 return

declare @tot2 int
declare @tot1 int
declare @n    int

select @tot1 = -1
select @tot2 =  0
select @n    =  1

declare @arb_id int
if @@incluir_arb_id<>0   select @arb_id = arb_id from rama where ram_id = @@ram_id
else      set    @arb_id = 0

insert into #t_rama (ram_id,n,ram_id_padre,arb_id,orden) select @@ram_id,0,ram_id_padre,@arb_id,ram_orden from rama where ram_id = @@ram_id 

while @tot1 < @tot2
begin
  select @tot1 = @tot2
  insert into #t_rama (ram_id,n,ram_id_padre,arb_id,orden) select r.ram_id,@n,r.ram_id_padre,@arb_id,ram_orden from rama r ,#t_rama t 
    where r.ram_id_padre = t.ram_id and t.n = @n - 1 
      -- esto chequea que no existan referencias circulares
      and not exists(select * from #t_rama where #t_rama.ram_id = r.ram_id)
    order by r.ram_orden

  select @tot2 = (select count(*) from #t_rama)
  select @n= @n + 1
end

declare @sqlstmt   varchar(255)
declare @where     varchar(50)
declare @sqlArbId   varchar (50)

if @@incluir_ram_id = 0    set @where = ' where t.ram_id <> ' + convert(varchar(18),@@ram_id)
else        set @where = ''

if @@incluir_arb_id <> 0  set @sqlArbId = ',t.arb_id' 
else        set @sqlArbId = ''


if @@incluir_ram_id_padre <> 0
begin
  if @@incluir_nombre <> 0
    set @sqlstmt = 'select t.ram_id,t.ram_id_padre,r.ram_nombre' + @sqlArbId + ' from #t_rama t inner join rama r on t.ram_id = r.ram_id'
  else
    set @sqlstmt = 'select ram_id,ram_id_padre' + @sqlArbId + ' from #t_rama t'
end
else
begin
  if @@incluir_nombre <> 0
    set @sqlstmt = 'select t.ram_id,r.ram_nombre' + @sqlArbId + ' from #t_rama t inner join rama r on t.ram_id = r.ram_id'
  else
    set @sqlstmt = 'select ram_id' + @sqlArbId + ' from #t_rama t'
end

set @sqlstmt = @sqlstmt + @where + ' order by n,orden'

exec(@sqlstmt)