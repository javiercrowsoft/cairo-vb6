-- Script de Chequeo de Integridad de:

-- 3 - Control de estado y pendientes

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaEstadoValidateDocOPG]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaEstadoValidateDocOPG]

go

create procedure sp_AuditoriaEstadoValidateDocOPG (

	@@opg_id      int,
	@@aud_id 			int

)
as

begin

  set nocount on

	declare @audi_id 					int
	declare @doct_id      		int
	declare @opg_nrodoc 			varchar(50) 
	declare @opg_numero 			varchar(50) 
	declare @est_id       		int
	declare @opg_pendiente		decimal(18,6)
	declare @opg_total    		decimal(18,6)
	declare @aplicado     		decimal(18,6)

	select 
						@doct_id 		 		= doct_id,
						@opg_nrodoc  		= opg_nrodoc,
						@opg_numero  		= convert(varchar,opg_numero),
						@est_id      		= est_id,
						@opg_pendiente	= opg_pendiente,
						@opg_total			= opg_total

	from OrdenPago where opg_id = @@opg_id

	select @aplicado = (IsNull(
													(select sum(fcopg_importe) from FacturaCompraOrdenPago 
													 where opg_id = @@opg_id),0)
											)

	if abs(round(@opg_total,2) - round(@opg_pendiente + @aplicado,2)) > 0.01 begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El pendiente de la orden de pago no coincide con la suma de sus aplicaciones '
                                 + '(comp.:' + @opg_nrodoc + ' nro.: '+ @opg_numero + ')',
																 3,
																 3,
																 @doct_id,
																 @@opg_id
																)
	end

	if 		@est_id <> 7 
		and @est_id <> 5 
		and @est_id <> 4 begin

		if round(@opg_pendiente,2) = 0 begin

				exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
				if @@error <> 0 goto ControlError	
										
				insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
													 values (@@aud_id, 
	                                 @audi_id,
	                                 'La orden de pago no tiene pendiente y su estado no es finalizado, o anulado, o pendiente de firma '
	                                 + '(comp.:' + @opg_nrodoc + ' nro.: '+ @opg_numero + ')',
																	 3,
																	 3,
																	 @doct_id,
																	 @@opg_id
																	)
		end

	end

ControlError:

end
GO