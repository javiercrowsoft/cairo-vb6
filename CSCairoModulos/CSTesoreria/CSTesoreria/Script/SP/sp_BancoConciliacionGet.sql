if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_BancoConciliacionGet ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_BancoConciliacionGet ]

go

/*
select * from cuenta where cue_nombre like '%doc%'
sp_BancoConciliacionGet 496,'20060606','21000101',1
sp_BancoConciliacionGet 141,'20060106','21000101',1

sp_BancoConciliacionGet 141,'19900101 00:00:00','20061029 00:00:00',1

*/
create procedure sp_BancoConciliacionGet  (
	@@bcoc_id    		int
)
as

begin

	select bcoc.*,
				 cue_nombre

	from BancoConciliacion bcoc inner join Cuenta cue on bcoc.cue_id = cue.cue_id

	where bcoc.bcoc_id = @@bcoc_id

end				