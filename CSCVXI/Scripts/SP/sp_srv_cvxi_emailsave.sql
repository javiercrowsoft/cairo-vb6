if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_emailsave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_emailsave]

go
/*

*/

create procedure sp_srv_cvxi_emailsave (

	@@cmiea_id           int,
	@@mail_id 					 varchar(255),
	@@fromname           varchar(1000),
	@@fromaddress        varchar(1000),
	@@subject            varchar(2000),
	@@account            varchar(255),
	@@email_to           varchar(255),
	@@date               datetime

)

as

begin

	set nocount on

	declare @cmie_id int

	-- Solo verifico que no este el header
	--
	select @cmie_id = cmie_id	
	from ComunidadInternetMail 
	where cmie_mailid = @@mail_id 
		and cmiea_id = @@cmiea_id
		and cmie_date = @@date

	if @cmie_id is null begin

		exec sp_dbgetnewid 'ComunidadInternetMail','cmie_id', @cmie_id out, 0

		insert into ComunidadInternetMail (cmi_id,
																			 cmie_account,
																			 cmie_body_html,
																			 cmie_body_plain,
																			 cmie_body_mime,
																			 cmie_fromaddress,
																			 cmie_fromname,
																			 cmie_header_mime,
																			 cmie_id,
																			 cmie_mailid,
																			 cmie_subject,
																			 cmie_subject_mime,
																			 cmie_to,
																			 cmiea_id,
																			 cmie_date
																		 )

													values			(null,
																			 @@account,
																			 '',
																			 '',
																			 '',
																			 @@fromaddress,
																			 @@fromname,
																			 '',
																			 @cmie_id,
																			 @@mail_id,
																			 @@subject,
																			 '',
																			 @@email_to,
																			 @@cmiea_id,
																			 @@date
																			)

	end

	select @cmie_id as cmie_id

end