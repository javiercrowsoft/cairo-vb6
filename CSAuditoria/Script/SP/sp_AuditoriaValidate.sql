-- Script de Chequeo de Integridad del Sistema

-- 1 - Control de documentos que mueven stock

-- 2 - Control de vencimientos FC y FV

-- 3 - Control de estado y pendientes

-- 4 - Control de cache de credito

-- 5 - Control de fechas fuera de rango (anteriores a 2003 o posteriores a GetDate())

-- 6 - Control de totales en items y headers

/*
delete auditoriaitem
delete auditoria
exec sp_AuditoriaValidate 
*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaValidate]

go

create procedure sp_AuditoriaValidate 

as

begin

  set nocount on

	declare @aud_id 			int
	declare @aud_fecha    datetime

	select @aud_fecha = aud_fecha from Auditoria where aud_id = (select max(aud_id) from Auditoria where aud_fin > '19000101')

	set @aud_fecha = IsNull(@aud_fecha, '19000101')

	exec sp_dbgetnewid 'Auditoria','aud_id', @aud_id out,0
	if @@error <> 0 goto ControlError	

	insert into Auditoria (aud_id) values (@aud_id)

	-- 1 - Control de documentos que mueven stock	

	exec sp_AuditoriaStockValidate @aud_id, @aud_fecha
/*
	-- 2 - Control de vencimientos FC y FV
	
	exec sp_AuditoriaVtoValidate @aud_id, @aud_fecha
	
	-- 3 - Control de estado y pendientes

	exec sp_AuditoriaEstadoValidate @aud_id, @aud_fecha
	
	-- 4 - Control de cache de credito

	exec sp_AuditoriaCreditoValidate @aud_id, @aud_fecha
	
	-- 5 - Control de fechas fuera de rango (anteriores a 2003 o posteriores a GetDate())

--	exec sp_AuditoriaFechasValidate @aud_id, @aud_fecha

	-- 6 - Control de totales en items y headers

	exec sp_AuditoriaTotalesValidate @aud_id, @aud_fecha
*/
	-- Fin del proceso

	update Auditoria set aud_fin = getdate() where aud_id = @aud_id

ControlError:

end