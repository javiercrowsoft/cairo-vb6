update cheque set cue_id = null where cheq_id in

(

           select cheq_id from cheque cheq 
           where cue_id is not null and exists(select * from ordenpagoitem opgi inner join ordenpago opg on opgi.opg_id = opg.opg_id and est_id <> 7 where cheq_id = cheq.cheq_id)

)
GO

declare c_cheque insensitive cursor for 

select cheq.cheq_id 
from cheque cheq 
      inner join cobranzaitem cobzi 
          on cheq.cheq_id = cobzi.cheq_id 
          and cheq.cue_id = cobzi.cue_id
where 
      cheq.cue_id is not null 
  and (    exists(
              select * from movimientofondoitem mfi 
              inner join movimientofondo mf on mfi.mf_id = mf.mf_id and est_id <> 7 
              where mfi.cheq_id = cheq.cheq_id
                and mfi.cue_id_debe <> cobzi.cue_id
            )
        or
          exists(
              select * from depositobancoitem dbcoi
              inner join depositobanco dbco on dbcoi.dbco_id = dbco.dbco_id and est_id <> 7 
              where dbcoi.cheq_id = cheq.cheq_id
                and dbco.cue_id <> cobzi.cue_id
            )
      )

declare @cheque   int
declare @cue_id   int
declare @mfi_id   int
declare @dbcoi_id int

open c_cheque
fetch next from c_cheque into @cheque
while @@fetch_status=0
begin

  set @cue_id     = null
  set @mfi_id     = null
  set @dbcoi_id   = null

  if exists(select * 
            from DepositoBancoItem dbcoi 
              inner join DepositoBanco dbco 
                on dbcoi.dbco_id = dbco.dbco_id
                  and dbco.est_id <> 7
            where dbcoi.cheq_id = @cheque
            ) begin

    select @dbcoi_id = max(dbcoi_id)  
    from DepositoBancoItem dbcoi 
      inner join DepositoBanco dbco 
        on dbcoi.dbco_id = dbco.dbco_id
          and dbco.est_id <> 7
    where dbcoi.cheq_id = @cheque

    select @cue_id = cue_id from DepositoBancoItem where dbcoi_id = @dbcoi_id

  end else begin

    select @mfi_id = max(mfi_id) 
    from movimientofondoitem mfi 
            inner join movimientofondo mf 
              on mfi.mf_id = mf.mf_id and est_id <> 7 
    where mfi.cheq_id = @cheque
  
    select @cue_id = cue_id_debe from MovimientoFondoItem where mfi_id = @mfi_id

  end

  if @cue_id is not null
    update Cheque set cue_id = @cue_id where cheq_id = @cheque

  fetch next from c_cheque into @cheque
end
close c_cheque
deallocate c_cheque
GO