if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ContactoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ContactoGet]

/*

 sp_web_ContactoGet 124

*/

go
create procedure sp_web_ContactoGet (

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
go