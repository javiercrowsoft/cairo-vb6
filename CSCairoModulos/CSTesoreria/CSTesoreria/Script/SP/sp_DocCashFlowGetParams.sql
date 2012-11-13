if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCashFlowGetParams ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCashFlowGetParams ]

go

/*

sp_DocCashFlowGetParams 3

*/
create procedure sp_DocCashFlowGetParams (
	@@cf_id int
)
as

begin

	select 	cfp.*,
					cli_nombre,
					prov_nombre,
					bco_nombre,
					cue_nombre

	from CashFlowParam cfp  left join Cliente cli 		on cfp.cli_id 	= cli.cli_id
													left join Proveedor prov 	on cfp.prov_id 	= prov.prov_id
													left join Banco bco 			on cfp.bco_id 	= bco.bco_id
													left join Cuenta cue      on cfp.cue_id   = cue.cue_id
	where cf_id = @@cf_id

end				