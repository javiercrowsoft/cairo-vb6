if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_ArbSubirRama]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbSubirRama]

go
create procedure SP_ArbSubirRama (
  @@ram_id int
)
as

set nocount on

declare @ram_orden smallint

select @ram_orden = ram_orden from rama where ram_id = @@ram_id

if @ram_orden = 0 return

update rama set ram_orden = ram_orden + 1 

where ram_id_padre = (select ram_id_padre from rama where ram_id = @@ram_id) 

and ram_orden = @ram_orden - 1

update rama set ram_orden = ram_orden -1 where ram_id = @@ram_id
