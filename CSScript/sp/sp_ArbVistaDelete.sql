if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbVistaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbVistaDelete]

go
create procedure sp_ArbVistaDelete (
  @@arbv_id         int
)
as

set nocount on

begin

  delete RamaVista where arbv_id = @@arbv_id
  delete ArbolVista where arbv_id = @@arbv_id

end

