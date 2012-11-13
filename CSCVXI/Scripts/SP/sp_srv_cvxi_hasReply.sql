if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_hasReply]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_hasReply]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_srv_cvxi_hasReply  3

create procedure sp_srv_cvxi_hasReply (
	@@cmie_id 				int,
	@@cmi_id					int,
	@@cmia_id					int,
	@@idm_id					int
)
as

set nocount on

begin

	if exists(select * 
						from ComunidadInternetRespuesta 
						where cmie_id = @@cmie_id 
							and (cmi_id = @@cmi_id or @@cmi_id = 0)
							and (cmia_id = @@cmia_id or @@cmia_id = 0) 
							and (idm_id = @@idm_id or @@idm_id = 0) 
					)
	begin

		select 1 as result

	end else begin

		select 0 as result

	end

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go