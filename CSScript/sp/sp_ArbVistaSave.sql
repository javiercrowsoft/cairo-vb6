if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbVistaSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbVistaSave]

go
create procedure sp_ArbVistaSave (
	@@arb_id          int,
	@@arbv_id     		int,
	@@arbv_nombre			varchar(100),
	@@arbv_descrip    varchar(255)
)
as

set nocount on

begin

	if @@arbv_id = 0 begin

		exec sp_dbgetnewid 'ArbolVista', 'arbv_id', @@arbv_id out, 0

		insert into ArbolVista (arb_id, arbv_id, arbv_nombre, arbv_descrip)
								values     (@@arb_id, @@arbv_id, @@arbv_nombre, @@arbv_descrip)

	end else begin

		update ArbolVista set arbv_nombre = @@arbv_nombre, arbv_descrip = @@arbv_descrip
		where arbv_id = @@arbv_id

	end

	select @@arbv_id

end

