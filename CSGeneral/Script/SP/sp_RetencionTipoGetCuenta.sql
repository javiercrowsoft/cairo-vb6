if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_RetencionTipoGetCuenta]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_RetencionTipoGetCuenta]

go

set quoted_identifier on 
go
set ansi_nulls on 
go
/*
 exec sp_RetencionTipoGetCuenta 2
*/
create procedure sp_RetencionTipoGetCuenta (
	@@ret_id	      int
)
as

set nocount on

begin


	select 
						cue.cue_id, 
						cue_nombre

	from	Retencion ret inner join RetencionTipo rett on ret.rett_id = rett.rett_id
                      inner join Cuenta cue         on rett.cue_id = cue.cue_id

	where ret_id = @@ret_id
end
go
set quoted_identifier off 
go
set ansi_nulls on 
go



