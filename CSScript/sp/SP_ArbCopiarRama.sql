if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_ArbCopiarRama]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbCopiarRama]

go
/*

select * from rama where ram_nombre like '%conta%'
select * from rama where ram_nombre like '%inf. e%'

begin tran
	exec SP_ArbCopiarRama 538,82495,1
rollback tran

*/
create procedure SP_ArbCopiarRama (
	@@ram_id_ToCopy  int,
	@@ram_id_ToPaste int,
	@@solo_los_hijos smallint
)
as

set nocount on

if @@ram_id_ToCopy = 0 return
if @@ram_id_ToPaste = 0 return

declare @ram_id		int
declare @new_ram_id 	int
declare @hoja_id	int
declare @new_hoja_id	int
declare @ram_id_padre	int
declare @arb_id		int

select @arb_id = arb_id from rama where ram_id = @@ram_id_ToPaste

create table #t_ramasACopiar(
ram_id int not null
)
create table #t_rama_ramaNew(
ram_id 		int not null,
ram_id_new 	int not null
)


declare @incluir_ram_id_to_copy int

if @@solo_los_hijos <> 0 set @incluir_ram_id_to_copy =0
else			 set @incluir_ram_id_to_copy =1

-- Obtengo la decendencia
insert into #t_ramasACopiar exec SP_ArbGetDecendencia @@ram_id_ToCopy, @incluir_ram_id_to_copy 

-- Creo un cursor para recorrer cada rama e ir copiandola
declare RamasACopiar insensitive cursor for select ram_id from #t_ramasACopiar

open RamasACopiar

fetch next from RamasACopiar into @ram_id

while @@fetch_status = 0
begin

	-- si esta es la rama principal de la copia, su padre tiene que ser la rama en la que estoy pegando
	if @ram_id = @@ram_id_ToCopy
		set @ram_id_padre = @@ram_id_ToPaste
	else
	begin
		-- Obtengo el padre de la rama que estoy copiando
		select @ram_id_padre = ram_id_padre from rama where ram_id = @ram_id


		-- Si pedi copiar solo los hijos y la rama que estoy copiando es hija directa, entonces su padre es la rama en la que estoy pegando
		if @@solo_los_hijos <> 0 and @ram_id_padre = @@ram_id_ToCopy
		begin
			set @ram_id_padre = @@ram_id_ToPaste
		end
		else
		begin
			-- Obtengo el nuevo padre
			select @ram_id_padre = ram_id_new from rama,#t_rama_ramaNew where rama.ram_id = #t_rama_ramaNew.ram_id and rama.ram_id = @ram_id_padre
		end
	end

	-- Por cada rama obtengo un id nuevo
	exec SP_DBGetNewId 'rama','ram_id',@new_ram_id output,0

	insert into rama (ram_id, ram_nombre, arb_id, modificado, creado, modifico, ram_id_padre) 
	select @new_ram_id, ram_nombre, @arb_id, getdate(), creado, modifico, @ram_id_padre from rama where ram_id = @ram_id

	insert into #t_rama_ramaNew (ram_id,ram_id_new) values(@ram_id,@new_ram_id)


	-- Creo un cursor para recorrer cada una de las hojas e insertarlas
	declare HojasACopiar insensitive cursor for select hoja_id from Hoja where ram_id = @ram_id

	open HojasACopiar
	
	fetch next from HojasACopiar into @hoja_id

	-- Ahora sus hojas
	while @@fetch_status = 0
	begin

		-- Por cada hoja obtengo un id nuevo
		exec SP_DBGetNewId 'hoja','hoja_id',@new_hoja_id output,0

		insert into hoja (hoja_id, id, modificado, creado, modifico, ram_id, arb_id) 
		select @new_hoja_id, id, getdate(), creado, modifico, @new_ram_id, @arb_id from hoja where hoja_id = @hoja_id

		fetch next from HojasACopiar into @hoja_id
	end

	close HojasACopiar
	deallocate HojasACopiar

	fetch next from RamasACopiar into @ram_id	
end

close RamasACopiar

deallocate RamasACopiar

-- para debug

-- exec SP_ArbGetDecendencia @@ram_id_ToCopy, 1
-- exec SP_ArbGetDecendencia @@ram_id_ToPaste, 1

-- declare @arb_idcopy 	int
-- declare @arb_idpaste 	int
-- 
-- select @arb_idcopy  = arb_id from rama where ram_id = @@ram_id_tocopy
-- select @arb_idpaste = arb_id from rama where ram_id = @@ram_id_topaste
-- 
-- select count(*) from rama where arb_id = @arb_idcopy
-- select count(*) from rama where arb_id = @arb_idpaste
-- 
-- select count(*) from hoja where arb_id = @arb_idcopy
-- select count(*) from hoja where arb_id = @arb_idpaste
