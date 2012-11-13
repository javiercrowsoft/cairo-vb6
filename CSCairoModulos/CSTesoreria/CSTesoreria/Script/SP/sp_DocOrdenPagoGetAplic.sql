SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoGetAplic]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoGetAplic]
GO


/*

delete facturaCompraOrdenPago
delete facturaComprapago

select * from OrdenPago

exec sp_DocOrdenPagoGetAplic 15

sp_columns FacturaCompraOrdenPago

*/
create procedure sp_DocOrdenPagoGetAplic (
	@@emp_id      int,
	@@opg_id 			int
)
as
begin

  exec sp_DocOrdenPagoGetAplicCliente @@emp_id, @@opg_id

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



