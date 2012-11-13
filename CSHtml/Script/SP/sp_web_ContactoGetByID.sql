if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ContactoGetByID]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ContactoGetByID]

/*

 sp_web_ContactoGetByID 35498

*/

go
create procedure sp_web_ContactoGetByID (

	@@cont_id int,
  @@us_id   int

)
as

begin

	set nocount on

	exec sp_web_ContactoGetEx 
																  0,
																  0,
																  '',
																	@@us_id,
																  @@cont_id,
																	0

end