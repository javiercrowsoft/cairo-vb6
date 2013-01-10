if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_LiquidacionCodigoTipoUpdate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_LiquidacionCodigoTipoUpdate]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_LiquidacionCodigoTipoUpdate] ON [dbo].[LiquidacionCodigoTipo] 
FOR INSERT, UPDATE
AS

declare @liqct_id int

declare c_LiquidacionCodigoTipoUpdate insensitive cursor for

  select liqct_id from inserted

open c_LiquidacionCodigoTipoUpdate

fetch next from c_LiquidacionCodigoTipoUpdate into @liqct_id
while @@fetch_status = 0
begin
  if @liqct_id = 1 begin
    update LiquidacionCodigoTipo set liqct_nombre = 'Remunerativo' where liqct_id = 1
  end
  if @liqct_id = 2 begin
    update LiquidacionCodigoTipo set liqct_nombre = 'No Remunerativo' where liqct_id = 2
  end
  if @liqct_id = 3 begin
    update LiquidacionCodigoTipo set liqct_nombre = 'Descuento' where liqct_id = 3
  end

  fetch next from c_LiquidacionCodigoTipoUpdate into @liqct_id
end

close c_LiquidacionCodigoTipoUpdate
deallocate c_LiquidacionCodigoTipoUpdate


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

