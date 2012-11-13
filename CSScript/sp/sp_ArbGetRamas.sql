if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_ArbGetRamas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbGetRamas]

go
create procedure sp_ArbGetRamas (
	@@arb_id int
)
as

set nocount on

declare @raiz_id int

select @raiz_id = ram_id from rama where arb_id = @@arb_id and ram_id_padre = 0

exec SP_ArbGetDecendencia @raiz_id,1,1,1