if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_getTextoItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_getTextoItem]

go
/*

*/

create procedure sp_srv_cvxi_getTextoItem (

  @@cmiti_id int

)

as

begin

  set nocount on

  select * 
  from ComunidadInternetTextoItem
  where cmiti_id = @@cmiti_id

end