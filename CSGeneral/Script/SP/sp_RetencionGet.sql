if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_RetencionGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_RetencionGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_RetencionGet 2

create procedure sp_RetencionGet (
	@@ret_id	int
)
as

set nocount on

begin

	select
							ret.*,
							rett_nombre,
							ta_nombre,
							ibc_nombre
	from
						Retencion ret left  join RetencionTipo rett 					on ret.rett_id = rett.rett_id
													left  join Talonario ta    							on ret.ta_id   = ta.ta_id
													left  join IngresosBrutosCategoria ibc 	on ret.ibc_id  = ibc.ibc_id
	where
						ret_id = @@ret_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



