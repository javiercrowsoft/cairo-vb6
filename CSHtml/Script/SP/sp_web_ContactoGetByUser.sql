if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ContactoGetByUser]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ContactoGetByUser]

/*

 sp_web_ContactoGetByUser 124

*/

go
create procedure sp_web_ContactoGetByUser (

	@@us_id int

)
as

begin

	set nocount on

	exec sp_web_ContactoGetEx 
																  0,
																  0,
																  '',
																  @@us_id,
																	0
																	
end