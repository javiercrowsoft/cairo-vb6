if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaSaveDesAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaSaveDesAplic]

/*

 sp_DocFacturaVentaSaveDesAplic 124

*/

GO
create procedure sp_DocFacturaVentaSaveDesAplic (
  @@fv_id int
)
as

begin

  set nocount on

  declare @fvTMP_id int
  declare @doc_id int

  select @doc_id = doc_id from FacturaVenta where fv_id = @@fv_id

  exec sp_dbgetnewid 'FacturaVentaTMP','fvTMP_id',@fvTMP_id out, 0

  insert into FacturaVentaTMP (fvTMP_id, fv_id, fv_numero, fv_nrodoc, cli_id, suc_id, doc_id, cpg_id, fv_grabarasiento, est_id, modifico)
                        values(@fvTMP_id, @@fv_id, 0, '', 0, 0, @doc_id, -2, 0, 1, 1)

  exec sp_DocFacturaVentaSaveAplic @fvTMP_id, 0
end

GO