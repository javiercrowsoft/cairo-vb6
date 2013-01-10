if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClientePartes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClientePartes]

/*

sp_infoClientePartes '',114,1

*/

go
create procedure sp_infoClientePartes (
  @@us_id         int,
  @@emp_id        int,
  @@cli_id        int,
  @@info_aux      varchar(255) = ''
)
as

begin

  set nocount on

  exec sp_infoClientePartes2 @@us_id,
                             @@emp_id,
                             @@cli_id,
                             @@info_aux

end
go
