if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientoGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientoGetItems]

go

/*

sp_DocAsientoGetItems 1

*/
create procedure sp_DocAsientoGetItems (
	@@as_id int
)
as

begin

	select 	AsientoItem.*,
					cue_nombre, 
          ccos_nombre

	from 	AsientoItem inner join cuenta 								on AsientoItem.cue_id = cuenta.cue_id
        						left join centrocosto as ccos 		on AsientoItem.ccos_id = ccos.ccos_id
	where 
			as_id = @@as_id

	order by asi_orden

end