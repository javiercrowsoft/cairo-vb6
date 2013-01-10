if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_ArbBajarRama]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbBajarRama]

go
create procedure SP_ArbBajarRama (
  @@ram_id int
)
as

set nocount on

declare @ultimo smallint

select @ultimo = max(ram_orden) from rama where ram_id_padre = (select ram_id_padre from rama where ram_id = @@ram_id) 

declare @ram_orden smallint

select @ram_orden = ram_orden from rama where ram_id = @@ram_id

if @ram_orden = @ultimo return

update rama set ram_orden = ram_orden - 1 

where ram_id_padre = (select ram_id_padre from rama where ram_id = @@ram_id) 

and ram_orden = @ram_orden + 1

update rama set ram_orden = ram_orden +1 where ram_id = @@ram_id
