-- Script de Chequeo de Integridad de:

-- 6 - Control de totales en items y headers

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaTotalesValidateDocCOBZ]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaTotalesValidateDocCOBZ]

go

create procedure sp_AuditoriaTotalesValidateDocCOBZ (

	@@cobz_id    int,
	@@aud_id 		int

)
as

begin

  set nocount on

	declare @audi_id 						int
	declare @doct_id      			int
	declare @cobz_nrodoc 				varchar(50) 
	declare @cobz_numero 				varchar(50) 
	declare @cobz_total    			decimal(18,6)
	declare @cobz_otros         	decimal(18,6)

	select 
						@doct_id 		 		= doct_id,
						@cobz_nrodoc  	= cobz_nrodoc,
						@cobz_numero  	= convert(varchar,cobz_numero),
						@cobz_total			= cobz_total,

						@cobz_otros			= cobz_otros

	from Cobranza where cobz_id = @@cobz_id

	declare @importe 				decimal(18,6)

	select @importe = sum(case cobzi_otrotipo 
													when 2 then - cobzi_importe 
													else 				  cobzi_importe 
												end) from CobranzaItem 
	where cobz_id 		= @@cobz_id 
		and cobzi_tipo	<> 5 -- Cuenta corriente
	group by cobz_id

	set @importe 			= isnull(@importe,0)

	if round(@importe,2) <> round(@cobz_total,2) begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El total de esta cobranza no coincide con la suma de los totales de sus items '
                                 + '(comp.:' + @cobz_nrodoc + ' nro.: '+ @cobz_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@cobz_id
																)

	end

	set @importe = 0

	select @importe = sum(case cobzi_otrotipo 
													when 2 then - cobzi_importe 
													else 				  cobzi_importe 
												end) from CobranzaItem 
	where cobz_id 		= @@cobz_id 
		and cobzi_tipo	= 4 -- Otros
	group by cobz_id

	set @importe 			= isnull(@importe,0)

	if round(@importe,2) <> round(@cobz_otros,2) begin

			exec sp_dbgetnewid 'AuditoriaItem', 'audi_id', @audi_id out,0
			if @@error <> 0 goto ControlError	
									
			insert into AuditoriaItem (aud_id, audi_id, audi_descrip,audn_id,audg_id,doct_id,comp_id)
												 values (@@aud_id, 
                                 @audi_id,
                                 'El total de otros de esta cobranza no coincide con la suma de los totales de sus items de tipo otros '
                                 + '(comp.:' + @cobz_nrodoc + ' nro.: '+ @cobz_numero + ')',
																 3,
																 4,
																 @doct_id,
																 @@cobz_id
																)

	end

ControlError:

end
GO