SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoGetFacturas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoGetFacturas]
GO




/*

select * from documentotipo

exec sp_DocOrdenPagoGetFacturas 6,0,0
exec sp_DocOrdenPagoGetFacturas 6,1,0
exec sp_DocOrdenPagoGetFacturas 6,0,1
exec sp_DocOrdenPagoGetFacturas 6,1,0

*/

CREATE procedure sp_DocOrdenPagoGetFacturas (
  @@emp_id            int,
  @@prov_id           int,
  @@bSoloVencidos     tinyint = 1,
  @@bAgrupado         tinyint = 0
)
as

begin

  exec sp_DocOrdenPagoGetFacturasCliente @@emp_id, @@prov_id, @@bSoloVencidos, @@bAgrupado

end



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


