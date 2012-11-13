if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_UsuarioGetCueIdTicket]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_UsuarioGetCueIdTicket]

go

/*

sp_UsuarioGetCueIdTicket 1,1

*/

create procedure sp_UsuarioGetCueIdTicket (

	@@us_id 	int,
	@@emp_id	int,
	@@hr      tinyint = 0

)
as

begin

	set nocount on

	declare @cj_id int

	select @cj_id = min(cj.cj_id) from CajaCajero cjc inner join Caja cj on cjc.cj_id = cj.cj_id
	where cj.emp_id = @@emp_id
		and cjc.us_id = @@us_id
		and ((cj_hojaruta <> 0 and @@hr <> 0) or (cj_hojaruta = 0 and @@hr = 0))

	declare @cue_id int

	select @cue_id = min(cue_id_trabajo) 
	from CajaCuenta cjcue inner join Cuenta cue on cjcue.cue_id_trabajo = cue.cue_id
	where cj_id = @cj_id
		and cue_esTicket <> 0
		and cuec_id = 14

	select cue_id, cue_nombre from cuenta where cue_id = @cue_id

end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

