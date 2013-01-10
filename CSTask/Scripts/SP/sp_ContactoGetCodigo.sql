if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ContactoGetCodigo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ContactoGetCodigo]

/*

 sp_ContactoGetCodigo 

*/

go
create procedure sp_ContactoGetCodigo 

as

begin

  set nocount on

  declare @codigo varchar(50)

  select @codigo = max(cont_codigo) from Contacto where isnumeric(cont_codigo)>0

  if len(@codigo)> 0 select convert(int,@codigo)+1
  else               select 1

end

go