if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClienteSaldo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClienteSaldo]

/*

sp_infoClienteSaldo '',114,1

*/

go
create procedure sp_infoClienteSaldo (
  @@us_id        int,
  @@emp_id       int,
  @@cli_id       int,
  @@info_aux     varchar(255) = ''
)
as

begin

  set nocount on

  exec sp_infoClienteSaldo2   @@us_id,
                              @@emp_id,
                              @@cli_id,
                              @@info_aux

end
go