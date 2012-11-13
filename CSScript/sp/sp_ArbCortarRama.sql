if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_ArbCortarRama]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbCortarRama]

go
/*
	creado:		15/05/2000
	Proposito:	Copia una rama y toda su decendencia en otra rama.
*/
create procedure SP_ArbCortarRama (
	@@ram_id_ToCopy  int,
	@@ram_id_ToPaste int,
	@@solo_los_hijos smallint
)
as

set nocount on

if @@ram_id_ToCopy = 0 return
if @@ram_id_ToPaste = 0 return


-- para evitar recursividad
create table #TRama( ram_id int)

declare @incluir_ram_id_to_copy int

if @@solo_los_hijos <> 0 set @incluir_ram_id_to_copy =0
else			 set @incluir_ram_id_to_copy =1

insert into #TRama exec SP_ArbGetDecendencia @@ram_id_ToCopy, @incluir_ram_id_to_copy

if exists (select * from #TRama where ram_id = @@ram_id_ToPaste) return


-- si solo corto los hijos, entonces las modificaciones van en el primer nivel de la decendencia de @@ram_id_ToCopy
if @@solo_los_hijos <> 0	update rama set ram_id_padre = @@ram_id_ToPaste where ram_id_padre = @@ram_id_ToCopy
else				update rama set ram_id_padre = @@ram_id_ToPaste where ram_id = @@ram_id_ToCopy


-- si cambio de arbol hay que modificar arb_id
declare @arb_id int

select @arb_id = arb_id from rama where ram_id = @@ram_id_ToPaste

-- esto dice si el arb_id de la rama en la que copio es distinto del arb_id de la rama en la que pego
if not exists (select * from arbol inner join rama on arbol.arb_id = rama.arb_id where @arb_id = rama.arb_id and ram_id = @@ram_id_ToCopy)
begin

	-- primero las ramas
	update rama set arb_id = @arb_id from #TRama where rama.ram_id = #TRama.ram_id


	-- ahora las hojas
	update hoja set arb_id = @arb_id from #TRama where hoja.ram_id = #TRama.ram_id
end
