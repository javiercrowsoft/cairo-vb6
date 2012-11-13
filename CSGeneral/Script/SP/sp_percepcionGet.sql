if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_percepcionGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_percepcionGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_percepcionGet 2

create procedure sp_percepcionGet (
	@@perc_id	int
)
as

set nocount on

begin

	select
							Percepcion.*,
							perct_nombre,
              ta_nombre
	from
						Percepcion inner join PercepcionTipo on Percepcion.perct_id = PercepcionTipo.perct_id
											 left  join Talonario      on Percepcion.ta_id    = Talonario.ta_id
	where
						perc_id = @@perc_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



