if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbGetAllHojas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbGetAllHojas]

go
create procedure sp_ArbGetAllHojas (
	@@ram_id     int,
  @@clienteId  int=0,
  @@tblIdAlias int=0
)
as

set nocount on

create table #t_rama(
ram_id int not null,
n      int not null		
)

if @@ram_id = 0 return

declare @tot2 int
declare @tot1 int
declare @n    int

select @tot1 = -1
select @tot2 =  0
select @n    =  1

insert into #t_rama (ram_id,n) values(@@ram_id,0) 

while @tot1 < @tot2
begin
	select @tot1 = @tot2
	insert into #t_rama (ram_id,n) 
		select r.ram_id,@n
		from rama r ,#t_rama t 
		where r.ram_id_padre = t.ram_id and t.n = @n - 1 and r.ram_id <> t.ram_id

	select @tot2 = (select count(*) from #t_rama)
	select @n= @n + 1
end

if @@clienteId <> 0 begin

	declare @tbl_id int

  select @tbl_id = tbl_id 
  from arbol,rama 
	where
	  -- join
        arbol.arb_id = rama.arb_id
		-- filter
    and rama.ram_id = @@ram_id

	if @@tblIdAlias <> 0 set @tbl_id=@@tblIdAlias

	insert into rptArbolRamaHoja (rptarb_cliente, rptarb_hojaid, tbl_id, ram_id)
  select distinct @@clienteId, id , @tbl_id, t.ram_id

	from hoja h,#t_rama t where h.ram_id = t.ram_id

end else begin

	select id from hoja h,#t_rama t where h.ram_id = t.ram_id

end

GO
