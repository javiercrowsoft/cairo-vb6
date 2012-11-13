if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoItemAnular]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoItemAnular]

go

create procedure sp_DocMovimientoFondoItemAnular (
	@@mf_id 				int,
	@@bChequeUsado  tinyint
)
as

begin

	--------------------------------------------------------------------------------------------
	--  3-  asociarlo al movimiento de fondos inmediato anterior
  --      al movimiento que estoy anulando
	--
	if @@bChequeUsado <> 0 begin

		declare @mf_id 			int
		declare @cheq_id		int
	
		declare c_cheques insensitive cursor for 
								select cheq_id 
								from MovimientoFondoItem mfi
								where mf_id = @@mf_id	
									and	cheq_id is not null
	
		open c_cheques
	
		fetch next from c_cheques into @cheq_id
	
		while @@fetch_status = 0
		begin
	
			set @mf_id = null
	
			-- Busco un movimiento de fondos anterior al que estoy anulando
			-- que mencione al cheque
			-- 
			select @mf_id = max(mfi.mf_id) 
			from Cheque cheq inner join MovimientoFondoItem mfi on cheq.cheq_id = mfi.cheq_id
											 inner join MovimientoFondo mf      on mfi.mf_id    = mf.mf_id
			where cheq.cheq_id = @cheq_id 
				and mfi.mf_id   <> @@mf_id
				and mf.est_id   <> 7 /* Anulado */				
	
			-- Hay un movimiento de fondos que mueve el cheque
			--
			if @mf_id is not null begin
			
				-- Devuelvo el cheque a la cuenta indicada por el ultimo movimiento de fondos
	      -- anterior al que estoy anulando y lo vinculo con dicho movimiento
				--
				update Cheque set cue_id = mfi.cue_id_debe, mf_id = @mf_id from MovimientoFondoItem mfi
											where 	Cheque.cheq_id = mfi.cheq_id  
													and mfi.mf_id 	   = @mf_id
													and Cheque.cheq_id = @cheq_id
				if @@error <> 0 return
	
			end else begin
	
				-- Si el cheque entro por una cobranza
				--
				if exists(select * from cheque where cheq_id = @cheq_id and cobz_id is not null)
				begin
	
					-- Devuelvo a documentos en cartera los cheques de tercero y 
					-- los desvinculo de este movimiento de fondos
					update Cheque set cue_id = cobzi.cue_id, mf_id = null from CobranzaItem cobzi
												where 	Cheque.cheq_id 	= cobzi.cheq_id 	
														and Cheque.mf_id 		= @@mf_id
														and Cheque.cheq_id 	= @cheq_id
					if @@error <> 0 return

				-- Si no entro por una cobranza y no hay 
				-- movimientos anteriores al que estoy anulando
				-- es por que entro en este movimiento y por ende solo 
        -- queda anularlo. Esto incluye propios y de terceros.
				--
				end else begin
	
					-- Anular los cheques de tercero que entraron 
          -- por este movimiento de fondos
					update Cheque set cheq_anulado = 1
					where cheq_id = @cheq_id
					if @@error <> 0 return

				end
	
			end
			
			fetch next from c_cheques into @cheq_id
		end
	
		close c_cheques
	
		deallocate c_cheques

	-- No hay cheques usados
	--
	end else begin

		create table #mfi_cheque (cheq_id int not null)
	
		insert #mfi_cheque (cheq_id)
			select cheq_id 
			from MovimientoFondoItem mfi
			where mf_id = @@mf_id 
			and cheq_id is not null

		-- Anulo los cheques de tercero que entraron por este movimiento de fondos
		update Cheque set cheq_anulado = 1
		where mf_id = @@mf_id 
			and cobz_id is null 
			and chq_id is null
			and exists (select cheq_id from #mfi_cheque where cheq_id = Cheque.cheq_id)
		if @@error <> 0 return
	
		-- Anulo los cheques propios utilizados por el movimiento de fondos
		update Cheque set cheq_anulado = 1
		where mf_id = @@mf_id 
			and chq_id is not null -- solo los cheques propios tienen chequera (chq_id)
			and exists (select cheq_id from #mfi_cheque where cheq_id = Cheque.cheq_id)
		if @@error <> 0 return
	
		-- Devuelvo a documentos en cartera los cheques de tercero y los 
		-- desvinculo de este movimiento de fondos
		update Cheque set cue_id = cobzi.cue_id, mf_id = null 
		from CobranzaItem cobzi
		where 	cobzi.cheq_id 	= Cheque.cheq_id 
				and Cheque.mf_id 		= @@mf_id
				and exists (select cheq_id from #mfi_cheque where cheq_id = Cheque.cheq_id)
		if @@error <> 0 return

		drop table #mfi_cheque

	end

end
go