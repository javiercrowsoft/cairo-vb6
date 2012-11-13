if exists (select * from sysobjects where id = object_id(N'[dbo].[frDepositoBancario]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frDepositoBancario]

/*

frDepositoBancario 1

*/

go
create procedure frDepositoBancario (

  @@dbco_id   int

)
as 

begin

  select 

            DepositoBanco.*,
            DepositoBancoItem.*,
            estado.est_nombre,
            banco.bco_nombre,
            documento.doc_nombre,
            cuenta.cue_nombre,
            sucursal.suc_nombre,
            case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
            DepositoBanco.modificado,
            DepositoBanco.creado,
            DepositoBanco.modifico,
            cheq_numerodoc,
            dateadd(d,cle_dias,dbco_fecha) as acreditacion,
            cle_nombre,
            chbco.bco_nombre as banco_cheque
  
  
    from DepositoBanco  inner join estado                 on DepositoBanco.est_id        = estado.est_id
                        inner join Banco                  on DepositoBanco.bco_id        = Banco.bco_id
                        inner join cuenta                 on DepositoBanco.cue_id        = cuenta.cue_id
                        inner join DepositoBancoItem      on DepositoBanco.dbco_id       = DepositoBancoItem.dbco_id
                        inner join Documento              on DepositoBanco.doc_id        = documento.doc_id
                        inner join sucursal               on DepositoBanco.suc_id        = sucursal.suc_id
                        left  join legajo                 on DepositoBanco.lgj_id        = legajo.lgj_id
                        left  join Cheque                 on DepositoBancoItem.cheq_id   = Cheque.cheq_id
                        left  join Cliente                on Cheque.cli_id               = Cliente.cli_id
                        left  join Banco chbco            on Cheque.bco_id               = chbco.bco_id
                        left  join Clearing               on Cheque.cle_id               = Clearing.cle_id

  where DepositoBanco.dbco_id = @@dbco_id

end
go

