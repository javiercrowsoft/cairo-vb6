if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_ArbBorrarRama]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbBorrarRama]

go
/*
	creado:		15/05/2000
	Proposito:	Devuelve toda la decendencia de una rama incluyendo a la misma rama

	insert into exec:	- SP_ArbBorrarRama

*/
create procedure SP_ArbBorrarRama (
	@@ram_id int
)
as

set nocount on

create table #t_ramasABorrar(
ram_id int not null
)

begin transaction

if @@ram_id = 0 return

-- si la rama es raiz tengo que borrar el arbol
declare @arb_id int

-- para actulizar el orden
declare @ram_orden smallint
declare @ram_id_padre int

select @arb_id = arb_id, @ram_orden = ram_orden, @ram_id_padre = ram_id_padre from rama where ram_id = @@ram_id and ram_id_padre = 0

-- obtengo la decendencia
insert into #t_ramasABorrar exec SP_ArbGetDecendencia @@ram_id

-- primero las hojas
delete Hoja from #t_ramasABorrar where Hoja.ram_id = #t_ramasABorrar.ram_id

if @@error <> 0 goto ControlError

-- ahora las ramas
delete Rama from #t_ramasABorrar where Rama.ram_id = #t_ramasABorrar.ram_id

if @@error <> 0 goto ControlError

-- si era una raiz borro el arbol
if @arb_id is not null 
	delete Arbol where arb_id = @arb_id
else
-- sino, tengo que actualizar el orden de los que estaban bajo esta rama	
	update rama set ram_orden = ram_orden -1 where ram_id_padre = @ram_id_padre and ram_orden < @ram_orden

if @@error <> 0 goto ControlError

commit transaction
return

ControlError:
rollback transaction

raiserror ('No se pude borrar la rama',
	
	   16, 1)

