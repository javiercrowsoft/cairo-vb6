if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ContactoDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ContactoDelete]

/*

  select max(cont_id) from contacto

  sp_web_ContactoDelete 1,3447,0

*/

go
create procedure sp_web_ContactoDelete (
  @@us_id     int,
	@@cont_id 	int,
  @@rtn     	int out

)
as

begin

  /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%%'*/
  declare @cont_nombre varchar(255)
  select @cont_nombre = cont_nombre from contacto where cont_id = @@cont_id
  exec sp_HistoriaUpdate 2001, @@cont_id, @@us_id, 3, @cont_nombre

	set nocount on
	delete Contacto where cont_id = @@cont_id 

	set @@rtn = 1

end