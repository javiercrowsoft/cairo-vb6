if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorPedidos]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorPedidos]

/*

sp_infoProveedorPedidos 1,1,39

*/

go
create procedure sp_infoProveedorPedidos (
  @@us_id         int,
  @@emp_id        int,
  @@prov_id       int,
  @@info_aux      varchar(255) = ''
)
as

begin

  set nocount on

  exec sp_infoProveedorPedidos2 @@us_id,
                                @@emp_id,
                                @@prov_id,
                                @@info_aux

end
go