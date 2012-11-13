sp_test
go
drop procedure sp_test
go
create procedure sp_test as
set nocount on
create table #test (grupo varchar(255),grupo2 varchar(255),grupo3 varchar(255), valor decimal(18,6))

declare @n int

set @n=1
while @n<11
begin

	insert into #test (grupo,grupo2,grupo3,valor) values('a','a.1','a1.1',10)
	
	set @n=@n+1
end


set @n=1
while @n<11
begin

	insert into #test (grupo,grupo2,grupo3,valor) values('a','a.1','a.1.3',10)
	
	set @n=@n+1
end

set @n=1
while @n<11
begin

	insert into #test (grupo,grupo2,grupo3,valor) values('a','a.2','a.2.1',10)
	
	set @n=@n+1
end

set @n=1
while @n<11
begin

	insert into #test (grupo,grupo2,grupo3,valor) values('a','a.2','a.2.2',10)
	
	set @n=@n+1
end

set @n=1
while @n<11
begin

	insert into #test (grupo,grupo2,grupo3,valor) values('b','b.1','b.1.1',10)
	
	set @n=@n+1
end

set @n=1
while @n<11
begin

	insert into #test (grupo,grupo2,grupo3,valor) values('b','b.1','b.1.3',10)
	
	set @n=@n+1
end

set @n=1
while @n<11
begin

	insert into #test (grupo,grupo2,grupo3,valor) values('b','b.2','b.2.2',10)
	
	set @n=@n+1
end


set @n=1
while @n<11
begin

	insert into #test (grupo,grupo2,grupo3,valor) values('a','a.1','a.1.2',10)
	
	set @n=@n+1
end

set @n=1
while @n<11
begin

	insert into #test (grupo,grupo2,grupo3,valor) values('b','b.2','b.2.1',10)
	
	set @n=@n+1
end

set @n=1
while @n<11
begin

	insert into #test (grupo,grupo2,grupo3,valor) values('b','b.1','b.1.2',10)
	
	set @n=@n+1
end

select * from #test

--select grupo,sum(valor)from #test group by grupo