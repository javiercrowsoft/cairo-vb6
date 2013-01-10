if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorPagos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorPagos]

/*

sp_infoProveedorPagos '',114,1

*/

go
create procedure sp_infoProveedorPagos (
  @@us_id         int,
  @@emp_id        int,
  @@prov_id       int,
  @@info_aux      varchar(255) = ''
)
as

begin

  set nocount on

  exec sp_infoProveedorPagos2 @@us_id,
                              @@emp_id,
                              @@prov_id,
                              @@info_aux

end
go