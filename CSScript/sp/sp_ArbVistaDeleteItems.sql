if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbVistaDeleteItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbVistaDeleteItems]

go
create procedure sp_ArbVistaDeleteItems (
	@@arbv_id     		int
)
as

set nocount on

begin

	delete RamaVista where arbv_id = @@arbv_id

end

