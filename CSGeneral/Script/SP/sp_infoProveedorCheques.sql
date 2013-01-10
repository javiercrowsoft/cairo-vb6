if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorCheques]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorCheques]

/*

sp_infoProveedorCheques '',114,1

*/

go
create procedure sp_infoProveedorCheques (
  @@us_id         int,
  @@emp_id        int,
  @@prov_id       int,
  @@info_aux      varchar(255) = ''
)
as

begin

  set nocount on

  exec sp_infoProveedorCheques2 @@us_id,
                                @@emp_id,
                                @@prov_id,
                                @@info_aux

end
go
