declare @arb_id  int
declare @cli_id  int
declare @ven_nombre   varchar(255)
declare @ven_nombre2  varchar(255)
declare @hoja_id int
declare @ram_id  int
declare @raiz    int

declare @max_hojas	int set @max_hojas = 300
declare @n      		int set @n = @max_hojas +1

select @arb_id = min(arb_id) from arbol where tbl_id = 28
select @raiz = ram_id from rama where arb_id = @arb_id and ram_id_padre = 0

-- Clientes de La Europea:
--
declare c_cli insensitive cursor for 
select cli_id, ven_nombre 
from cliente cli inner join vendedor ven on cli.ven_id = ven.ven_id
where (  substring(cli_codigo,1,6) < '800000' 
			or substring(cli_codigo,1,6) >'899999'
			)
	and not exists(select * from hoja where arb_id = @arb_id and id = cli_id)
order by cli_codigo

if not exists(select ram_id from rama where ram_nombre = 'La Europea' and ram_id_padre = @raiz) begin
		exec sp_dbgetnewid 'Rama','ram_id',@ram_id out, 0
		insert into Rama (ram_id,arb_id,ram_nombre,modifico,ram_id_padre,ram_orden)values(@ram_id,@arb_id,'La Europea',1,@raiz,1000)
		select @raiz = @ram_id
end else select @raiz = ram_id from rama where ram_nombre = 'La Europea' and ram_id_padre = @raiz

set @ven_nombre2 = "!#@@!!"
set @ven_nombre  = "!#@@!!"

open c_cli
fetch next from c_cli into @cli_id, @ven_nombre
while @@fetch_status = 0 
begin

	if @ven_nombre2 <> @ven_nombre begin
		if not exists(select ram_id from rama where ram_nombre = 'La Europea' and ram_id_padre = @raiz) begin

	end

	if @n > @max_hojas begin
		exec sp_dbgetnewid 'Rama','ram_id',@ram_id out, 0
		insert into Rama (ram_id,arb_id,ram_nombre,modifico,ram_id_padre,ram_orden)values(@ram_id,@arb_id,'Grupo Aux',1,@raiz,1000)
		set @n=1
	end

	exec sp_dbgetnewid 'Hoja','hoja_id',@hoja_id out, 0

	insert into Hoja (hoja_id,ram_id,arb_id,id,modifico)values(@hoja_id,@ram_id,@arb_id,@cli_id,1)

	set @n=@n+1

	fetch next from c_cli into @cli_id, @ven_nombre
end

close c_cli
deallocate c_cli