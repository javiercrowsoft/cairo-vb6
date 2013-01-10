if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCashFlowGet ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCashFlowGet ]

go

/*
select * from cuenta where cue_nombre like '%doc%'
sp_DocCashFlowGet 496,'19000101','21000101'

sp_DocCashFlowGet null,'20060101 00:00:00','20061029 00:00:00'

*/
create procedure sp_DocCashFlowGet  (
  @@cf_id int
)
as

begin

  select   cf.*,
          cue_nombre

  from CashFlow cf  left join Cuenta cue on cf.cue_id = cue.cue_id

  where cf_id = @@cf_id

end        