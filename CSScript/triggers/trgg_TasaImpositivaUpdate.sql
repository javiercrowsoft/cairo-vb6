if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[trgg_TasaImpositivaUpdate]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[trgg_TasaImpositivaUpdate]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

CREATE TRIGGER [trgg_TasaImpositivaUpdate] ON [dbo].[TasaImpositiva] 
FOR INSERT, UPDATE
AS

declare @ti_id int

declare c_tiUpdate insensitive cursor for

	select ti_id from inserted

open c_tiUpdate

fetch next from c_tiUpdate into @ti_id
while @@fetch_status = 0
begin
	if @ti_id = -1 begin
		update TasaImpositiva set ti_nombre = 'Auxiliar Responsable No Inscripto Ventas', ti_codigo = 'auxrniv' where ti_id = -1
	end
	if @ti_id = -2 begin
		update TasaImpositiva set ti_nombre = 'Auxiliar Responsable No Inscripto Compras', ti_codigo = 'auxrnic' where ti_id = -2
	end

	fetch next from c_tiUpdate into @ti_id
end

close c_tiUpdate
deallocate c_tiUpdate


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

