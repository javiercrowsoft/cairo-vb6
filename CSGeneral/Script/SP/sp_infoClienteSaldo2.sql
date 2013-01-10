if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoClienteSaldo2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoClienteSaldo2]

/*

sp_infoClienteSaldo2 '',114,1

*/

go
create procedure sp_infoClienteSaldo2 (
  @@us_id        int,
  @@emp_id       int,
  @@cli_id       int,
  @@info_aux     varchar(255) = ''
)
as

begin

  set nocount on

  select 

        cli_deudapedido
      + cli_deudaorden
      + cli_deudaremito
      + cli_deudapackinglist
      + cli_deudamanifiesto
      + cli_deudactacte       
      + cli_deudadoc          as saldo,    

      cli_deudapedido,
      cli_deudaorden,
      cli_deudaremito,
      cli_deudapackinglist,
      cli_deudamanifiesto,
      cli_deudactacte,    
      cli_deudadoc,
      cli_deudatotal,
      cli_creditoctacte,
      cli_creditototal
  
  from Cliente 

  where cli_id = @@cli_id

end
go