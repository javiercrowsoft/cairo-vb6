if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_LiquidacionCodigoTipo]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_LiquidacionCodigoTipo]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_LiquidacionCodigoTipo] ON [dbo].[LiquidacionCodigoTipo] 
FOR DELETE 
AS

declare @liqct_id int

declare c_LiquidacionCodigoTipo insensitive cursor for

  select liqct_id from deleted

open c_LiquidacionCodigoTipo

fetch next from c_LiquidacionCodigoTipo into @liqct_id
while @@fetch_status = 0
begin
  if @liqct_id in (1,2,3) begin

    rollback transaction
    raiserror ('@@ERROR_SP:Los tipos codigos de liquidacion Remunerativo, No Remunerativo y Descuento no pueden borrarse', 16, 11)
  end

  fetch next from c_LiquidacionCodigoTipo into @liqct_id
end

close c_LiquidacionCodigoTipo
deallocate c_LiquidacionCodigoTipo
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

