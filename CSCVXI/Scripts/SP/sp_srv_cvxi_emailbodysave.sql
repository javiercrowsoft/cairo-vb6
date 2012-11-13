if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_emailbodysave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_emailbodysave]

go
/*

*/

create procedure sp_srv_cvxi_emailbodysave (

	@@cmiea_id					 int,
	@@mail_id 					 varchar(255),
	@@body_html          varchar(8000),
	@@body_plain         varchar(8000)

)

as

begin

	set nocount on

	declare @cmie_id int

	select @cmie_id = cmie_id	from ComunidadInternetMail where cmie_mailid = @@mail_id and cmiea_id = @@cmiea_id

	if @cmie_id is not null begin

		update ComunidadInternetMail set cmie_body_html = @@body_html where cmie_mailid = @@mail_id		
		update ComunidadInternetMail set cmie_body_plain = @@body_plain where cmie_mailid = @@mail_id		
		update ComunidadInternetMail set cmie_body_updated = 1 where cmie_mailid = @@mail_id		

	end

end