if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_BancoConciliacionGetLast ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_BancoConciliacionGetLast ]

go

/*

update BancoConciliacion set bcoc_numero = bcoc_id

sp_BancoConciliacionGetLast 160

*/
create procedure sp_BancoConciliacionGetLast  (
	@@cue_id  int
)
as

begin

	declare @bcoc_numero int

	select @bcoc_numero = max(bcoc_numero)

	from BancoConciliacion bcoc

	where bcoc.cue_id = @@cue_id

	------------------------------------------------------

	select bcoc_id

	from BancoConciliacion bcoc

	where bcoc.cue_id = @@cue_id
		and	bcoc_numero = @bcoc_numero

end				