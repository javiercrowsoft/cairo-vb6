if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondoItemCanDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondoItemCanDelete]

go
/*

 sp_DocMovimientoFondoItemCanDelete 93

*/

create procedure sp_DocMovimientoFondoItemCanDelete (
  @@mf_id         int,
  @@mfTMP_id      int,
  @@bIsDelete      tinyint,
  @@Message       varchar(8000) out,
  @@bChequeUsado  tinyint out,
  @@bCanDelete    tinyint out
)
as

begin

  declare @cheque    varchar(5000)
  declare @cheques  varchar(8000)

  set @cheques = ''

  -- Controlo que ningun cheque mencionado en 
  -- este movimiento de fondos este utilizado
  -- por otro movimiento de fondos o por una 
  -- orden de pago ya que si es asi, no puedo
  -- vincular asociar este cheque con la cuenta
  -- mencionada en la cobranza, sino que debo:
  --
  --  1-  dar un error si esta usado en una orden de pago
  --      o un deposito bancario, 
  --  2-  dar un error si esta usado en un movimiento
  --      de fondo posterior
  --  3-  asociarlo al movimiento de fondos inmediato anterior
  --      al movimiento que estoy borrando

  --------------------------------------------------------------------------------------------
  --
  --  1-  dar un error si esta usado en una orden de pago 
  --      o un deposito bancario, 
  --

  if exists ( select cheq.cheq_id 
              from Cheque cheq inner join MovimientoFondoItem mfi on cheq.cheq_id = mfi.cheq_id
              where mfi.mf_id = @@mf_id
                and cheq.opg_id is not null
                and (
                      @@bIsDelete <> 0
                  or  exists (select mfi_id 
                              from MovimientoFondoItemBorradoTMP 
                              where mf_id     = @@mf_id
                                and mfTMP_id   = @@mfTMP_id
                                and mfi_id     = mfi.mfi_id
                              )
                    )
            )
  begin

    declare c_chequeOPG insensitive cursor for 
        select   'Cheque: '
               + convert(varchar,cheq_numero) +  ' - '
               + cheq_numerodoc + ' - ' 
               + 'OP: ' + emp_nombre + ' - '
               + doc_nombre + ' - '
               + convert(varchar,opg_numero) + ' - '
               + opg_nrodoc + ' - ' 
               + convert(varchar(12),opg_fecha,105) + ' - ' 
               + prov_nombre

        from Cheque cheq inner join MovimientoFondoItem mfi on cheq.cheq_id = mfi.cheq_id
                         inner join OrdenPago opg           on cheq.opg_id  = opg.opg_id
                         inner join Documento doc           on opg.doc_id   = doc.doc_id
                         inner join Proveedor prov          on opg.prov_id  = prov.prov_id
                         inner join Empresa emp             on doc.emp_id   = emp.emp_id

        where mfi.mf_id = @@mf_id
          and cheq.opg_id is not null

          and (
                @@bIsDelete <> 0
            or  exists (select mfi_id 
                        from MovimientoFondoItemBorradoTMP 
                        where mf_id     = @@mf_id
                          and mfTMP_id   = @@mfTMP_id
                          and mfi_id     = mfi.mfi_id
                        )
              )

    open c_chequeOPG

    fetch next from c_chequeOPG into @cheque

    while @@fetch_status = 0
    begin

        set @cheques = @cheques + @cheque
        fetch next from c_chequeOPG into @cheque
    end

    close c_chequeOPG

    deallocate c_chequeOPG

    set @@bCanDelete = 0
    set @@Message = '@@ERROR_SP:Existe uno o mas cheques en este movimiento de fondos que han sido utilizados en una orden de pago.;' + @cheques
    return
  end

  -- Busco cheques de tercero que menciona este movimiento de fondo
  -- y han sido depositados
  --
  -- Cheque depositado
  if exists(select cheq.cheq_id 
            from Cheque cheq inner join MovimientoFondoItem mfi on cheq.cheq_id   = mfi.cheq_id 
                             inner join DepositoBancoItem dbcoi on cheq.cheq_id  = dbcoi.cheq_id
                             inner join DepositoBanco dbco      on dbcoi.dbco_id = dbco.dbco_id
            where mfi.mf_id    = @@mf_id 
              and dbco.est_id <> 7 /*Anulado*/
              and (
                    @@bIsDelete <> 0
                or  exists (select mfi_id 
                            from MovimientoFondoItemBorradoTMP 
                            where mf_id     = @@mf_id
                              and mfTMP_id   = @@mfTMP_id
                              and mfi_id     = mfi.mfi_id
                            )
                  )
            )
  begin

    declare c_chequeDBCO insensitive cursor for 
        select   'Cheque: '
               + convert(varchar,cheq_numero) +  ' - '
               + cheq_numerodoc + ' - ' 
               + 'DB: ' + emp_nombre + ' - '
               + doc_nombre + ' - '
               + convert(varchar,dbco_numero) + ' - '
               + dbco_nrodoc + ' - ' 
               + convert(varchar(12),dbco_fecha,105) + ' - ' 
               + bco_nombre

        from Cheque cheq inner join MovimientoFondoItem mfi on cheq.cheq_id   = mfi.cheq_id 
                         inner join DepositoBancoItem dbcoi on cheq.cheq_id  = dbcoi.cheq_id
                         inner join DepositoBanco dbco      on dbcoi.dbco_id = dbco.dbco_id
                         inner join Documento doc           on dbco.doc_id   = doc.doc_id
                         inner join Banco bco               on dbco.bco_id   = bco.bco_id
                         inner join Empresa emp             on doc.emp_id    = emp.emp_id

        where mfi.mf_id    = @@mf_id 
          and dbco.est_id <> 7 

          and (
                @@bIsDelete <> 0
            or  exists (select mfi_id 
                        from MovimientoFondoItemBorradoTMP 
                        where mf_id     = @@mf_id
                          and mfTMP_id   = @@mfTMP_id
                          and mfi_id     = mfi.mfi_id
                        )
              )

    open c_chequeDBCO

    fetch next from c_chequeDBCO into @cheque

    while @@fetch_status = 0
    begin

        set @cheques = @cheques + @cheque
        fetch next from c_chequeDBCO into @cheque
    end

    close c_chequeDBCO

    deallocate c_chequeDBCO

    set @@bCanDelete = 0
    set @@Message = '@@ERROR_SP:Existe uno o mas cheques en este movimiento de fondos que han sido depoistados.;' + @cheques
    return
  end


  --------------------------------------------------------------------------------------------
  --
  --  2-  dar un error si esta usado en un movimiento
  --      de fondo posterior
  --

  if exists ( select cheq.cheq_id 
              from Cheque cheq inner join MovimientoFondoItem mfi on     cheq.cheq_id = mfi.cheq_id
                                                                    and mfi.mf_id    = @@mf_id
              where IsNull(cheq.mf_id,0) > @@mf_id

                and (
                      @@bIsDelete <> 0
                  or  exists (select mfi_id 
                              from MovimientoFondoItemBorradoTMP 
                              where mf_id     = @@mf_id
                                and mfTMP_id   = @@mfTMP_id
                                and mfi_id     = mfi.mfi_id
                              )
                    )
            )
  begin
  
    declare c_chequeMF insensitive cursor for 
        select   'Cheque: '
               + convert(varchar,cheq_numero) +  ' - '
               + cheq_numerodoc + ' - ' 
               + 'MF: ' + emp_nombre + ' - '
               + doc_nombre + ' - '
               + convert(varchar,mf.mf_numero) + ' - '
               + mf.mf_nrodoc + ' - ' 
               + convert(varchar(12),mf.mf_fecha,105)

        from (
                Cheque cheq 
                         inner join MovimientoFondoItem mfi on     cheq.cheq_id = mfi.cheq_id                         
                                                              and  mfi.mf_id    = @@mf_id
              )
                         inner join MovimientoFondo mf      on cheq.mf_id   = mf.mf_id
  
                         inner join Documento doc           on mf.doc_id    = doc.doc_id
                         inner join Empresa emp             on doc.emp_id   = emp.emp_id

        where (
                @@bIsDelete <> 0
            or  exists (select mfi_id 
                        from MovimientoFondoItemBorradoTMP 
                        where mf_id     = @@mf_id
                          and mfTMP_id   = @@mfTMP_id
                          and mfi_id     = mfi.mfi_id
                        )
              )

    open c_chequeMF

    fetch next from c_chequeMF into @cheque

    while @@fetch_status = 0
    begin

        set @cheques = @cheques + @cheque
        fetch next from c_chequeMF into @cheque
    end

    close c_chequeMF

    deallocate c_chequeMF

    set @@bCanDelete = 0
    set @@Message = '@@ERROR_SP:Existe uno o mas cheques en este movimiento que han sido utilizados en una movimiento de fondos posterior.;' + @cheques
    return
  end

  -- Uno de los cheques mencionados por este movimiento de fondos esta
  -- cambiando de cuenta en el debe, o cambie el cheque en el item y
  -- este cheque ya fue usado por un movimiento de fondos posterior
  --
  if @@bIsDelete = 0 begin

    if exists ( select cheq.cheq_id 

                -- Items del movimiento que estoy modificando
                -- los necesito para saber si cambio la cuenta 
                -- de este cheque
                from (MovimientoFondoItemTMP mfit
                           inner join MovimientoFondoItem mfi    on    mfit.mfi_id       = mfi.mfi_id
                                                                  and mfit.mfTMP_id     = @@mfTMP_id
                                                                  and mfi.mf_id         = @@mf_id
                                                                  and (      mfit.cue_id_debe <> mfi.cue_id_debe
                                                                        or  mfit.cheq_id      = mfi.cheq_id
                                                                      )                                                                    
                      )
                           inner join Cheque cheq                on mfi.cheq_id         = cheq.cheq_id 
                where IsNull(cheq.mf_id,0) > @@mf_id
              )
    begin
    
      declare c_chequeMF insensitive cursor for 
          select   'Cheque: '
                 + convert(varchar,cheq_numero) +  ' - '
                 + cheq_numerodoc + ' - ' 
                 + 'MF: ' + emp_nombre + ' - '
                 + doc_nombre + ' - '
                 + convert(varchar,mf.mf_numero) + ' - '
                 + mf.mf_nrodoc + ' - ' 
                 + convert(varchar(12),mf.mf_fecha,105)
  
          from (MovimientoFondoItemTMP mfit 
                           inner join MovimientoFondoItem mfi    on    mfit.mfi_id       = mfi.mfi_id
                                                                  and mfit.mfTMP_id     = @@mfTMP_id
                                                                  and mfi.mf_id        = @@mf_id
                                                                  and (      mfit.cue_id_debe <> mfi.cue_id_debe
                                                                        or  mfit.cheq_id      = mfi.cheq_id
                                                                      )
                )
                           inner join Cheque cheq              on mfi.cheq_id  = cheq.cheq_id
                           inner join MovimientoFondo mf      on cheq.mf_id   = mf.mf_id
                           inner join Documento doc           on mf.doc_id    = doc.doc_id
                           inner join Empresa emp             on doc.emp_id   = emp.emp_id
  
          where IsNull(cheq.mf_id,0) > @@mf_id
            and  (
                  @@bIsDelete <> 0
              or  exists (select mfi_id 
                          from MovimientoFondoItemBorradoTMP 
                          where mf_id     = @@mf_id
                            and mfTMP_id   = @@mfTMP_id
                            and mfi_id     = mfi.mfi_id
                          )
                )
  
      open c_chequeMF
  
      fetch next from c_chequeMF into @cheque
  
      while @@fetch_status = 0
      begin
  
          set @cheques = @cheques + @cheque
          fetch next from c_chequeMF into @cheque
      end
  
      close c_chequeMF
  
      deallocate c_chequeMF
  
      set @@bCanDelete = 0
      set @@Message = '@@ERROR_SP:Existe uno o mas cheques en este movimiento que han sido utilizados en una movimiento de fondos posterior.;' + @cheques
      return
    end
  end

  --------------------------------------------------------------------------------------------
  --
  --  3-  asociarlo al movimiento de fondos inmediato anterior
  --      al movimiento que estoy borrando
  --
  if exists ( select cheq.cheq_id 
              from Cheque cheq inner join MovimientoFondoItem mfi on cheq.cheq_id = mfi.cheq_id
              where mfi.mf_id = @@mf_id
                and (
                      @@bIsDelete <> 0
                  or  exists (select mfi_id 
                              from MovimientoFondoItemBorradoTMP 
                              where mf_id     = @@mf_id
                                and mfTMP_id   = @@mfTMP_id
                                and mfi_id     = mfi.mfi_id
                              )
                    )
                and exists(select mfi_id from MovimientoFondoItem mfi
                                                inner join MovimientoFondo mf on mfi.mf_id = mf.mf_id
                           where mfi.cheq_id = cheq.cheq_id
                             and mfi.mf_id  <> @@mf_id
                             and mf.est_id  <> 7 /* Anulado */
                    )
             )
    set @@bChequeUsado = 1
  else
    set @@bChequeUsado = 0

  set @@bCanDelete = 1

  --------------------------------------------------------------------------------------------

end
go