if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_aplicacionesget]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_aplicacionesget]

go
/*

*/

create procedure sp_srv_cvxi_aplicacionesget 

as

begin

  set nocount on

  select * from ComunidadInternetAplicacion

end