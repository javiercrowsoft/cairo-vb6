if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocEsCobranzaCdo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocEsCobranzaCdo]

go

/*

  sp_DocEsCobranzaCdo 34

*/

create procedure sp_DocEsCobranzaCdo (
	@@fv_id    		int
)
as

set nocount on

begin

	declare @cpg_id int

	select @cpg_id = cpg_id from FacturaVenta where fv_id = @@fv_id

	select cpg_escontado from CondicionPago where cpg_id = @cpg_id
end

go
