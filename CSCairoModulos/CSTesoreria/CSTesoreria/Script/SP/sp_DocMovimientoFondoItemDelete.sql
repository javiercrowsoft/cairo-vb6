if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoItemDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoItemDelete]

go
/*

 sp_DocMovimientoFondoItemDelete 93

*/

create procedure sp_DocMovimientoFondoItemDelete (
	@@mf_id 				int,
	@@mfTMP_id      int,
	@@bIsDelete			tinyint,
	@@bChequeUsado  tinyint
)
as

begin

	if @@bIsDelete = 0 begin

		if not exists (select mfi_id 
					         from MovimientoFondoItemBorradoTMP 
					         where mf_id 		= @@mf_id
										 and mfTMP_id = @@mfTMP_id
									)
			return

	end

	--------------------------------------------------------------------------------------------
	--  3-  asociarlo al movimiento de fondos inmediato anterior
  --      al movimiento que estoy borrando
	--
	if @@bChequeUsado <> 0 begin

		declare @mf_id 			int
		declare @cheq_id		int
	
		declare c_cheques insensitive cursor for 
								select cheq_id 
								from MovimientoFondoItem mfi
								where mf_id = @@mf_id	
									and	cheq_id is not null

									and (
												@@bIsDelete <> 0
										or	exists (select mfi_id 
									              from MovimientoFondoItemBorradoTMP 
									              where mf_id 		= @@mf_id
																	and mfTMP_id 	= @@mfTMP_id
									                and mfi_id 		= mfi.mfi_id
																)
											)
	
		open c_cheques
	
		fetch next from c_cheques into @cheq_id
	
		while @@fetch_status = 0
		begin
	
			set @mf_id = null
	
			-- Busco un movimiento de fondos anterior al que estoy borrando
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
	      -- anterior al que estoy borrando y lo vinculo con dicho movimiento
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
				-- movimientos anteriores al que estoy borrando
				-- es por que entro en este movimiento y por ende solo 
        -- queda borrarlo. Esto incluye propios y de terceros.
				--
				end else begin

					-- Desvinculo el cheque del item para poder borrarlo
					update MovimientoFondoItem set cheq_id = null 
          where mf_id = @@mf_id 
						and cheq_id = @cheq_id
					if @@error <> 0 return
	
					-- Desvinculo el cheque de cualquier AsientoItem que lo mencione
					--
					update AsientoItem set cheq_id = null where cheq_id = @cheq_id
					if @@error <> 0 return

					-- Borro los cheques de tercero que entraron por este movimiento de fondos
					delete Cheque where cheq_id = @cheq_id
					if @@error <> 0 return

				end
	
			end
			
			fetch next from c_cheques into @cheq_id
		end
	
		close c_cheques
	
		deallocate c_cheques

	end
	--------------------------------------------------------------------------------------------

	create table #mfi_cheque (cheq_id int not null)

	insert #mfi_cheque (cheq_id)
		select cheq_id 
		from MovimientoFondoItem mfi
		where mf_id = @@mf_id 
		and cheq_id is not null
		and (
					@@bIsDelete <> 0
			or	exists (select mfi_id 
		              from MovimientoFondoItemBorradoTMP 
		              where mf_id 		= @@mf_id
										and mfTMP_id 	= @@mfTMP_id
		                and mfi_id 		= mfi.mfi_id
									)
				)

	--------------------------------------------------------------------------------------------
	delete MovimientoFondoItem 	where mf_id = @@mf_id
																and (
																			@@bIsDelete <> 0
																	or	exists (select mfi_id 
																              from MovimientoFondoItemBorradoTMP 
																              where mf_id 		= @@mf_id
																								and mfTMP_id 	= @@mfTMP_id
																                and mfi_id 		= MovimientoFondoItem.mfi_id
																							)
																		)
	if @@error <> 0 return

	--------------------------------------------------------------------------------------------	
	--
	if @@bChequeUsado = 0 begin

		-- Desvinculo el cheque de cualquier AsientoItem que lo mencione
		--
		update AsientoItem set cheq_id = null 
		where cheq_id in (
												select cheq_id 
												from Cheque
												where mf_id = @@mf_id 
													and cobz_id is null 
													and chq_id is null
													and exists (select cheq_id from #mfi_cheque where cheq_id = Cheque.cheq_id)
											)
		if @@error <> 0 return

		-- Borro los cheques de tercero que entraron por este movimiento de fondos
		delete Cheque 
		where mf_id = @@mf_id 
			and cobz_id is null 
			and chq_id is null
			and exists (select cheq_id from #mfi_cheque where cheq_id = Cheque.cheq_id)
		if @@error <> 0 return
	
		-- Desvinculo el cheque de cualquier AsientoItem que lo mencione
		--
		update AsientoItem set cheq_id = null 
		where cheq_id in (
												select cheq_id 
												from Cheque
												where mf_id = @@mf_id 
													and chq_id is not null -- solo los cheques propios tienen chequera (chq_id)
													and exists (select cheq_id from #mfi_cheque where cheq_id = Cheque.cheq_id)
											)
		if @@error <> 0 return

		-- Borro los cheques propios utilizados por el movimiento de fondos
		delete Cheque 
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

	end

	drop table #mfi_cheque

end
go