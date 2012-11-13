if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_getemail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_getemail]

go
/*

*/

create procedure sp_srv_cvxi_getemail (

	@@cmie_id int

)

as

begin

	set nocount on

	select * 
	from ComunidadInternetMail
	where cmie_id = @@cmie_id

end