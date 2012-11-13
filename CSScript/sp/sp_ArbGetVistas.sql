if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbGetVistas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbGetVistas]

go
create procedure sp_ArbGetVistas (
	@@arb_id     int
)
as

set nocount on

begin

	select * from ArbolVista where arb_id = @@arb_id

end

