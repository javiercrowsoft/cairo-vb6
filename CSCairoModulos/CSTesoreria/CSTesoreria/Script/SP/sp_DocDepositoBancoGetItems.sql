if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoBancoGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoBancoGetItems]

go

/*

*/
create procedure sp_DocDepositoBancoGetItems (
  @@dbco_id       int,
  @@dbcoi_tipo    tinyint
)
as

begin

  select   dbcoi.*, 
          cue_nombre,
          bco_nombre,

          chq_codigo,
          cheq_numero,
          bco_nombre,
          cle_nombre,
          mon_nombre,
          mon.mon_id,
          cheq_numerodoc,
          bco.bco_id,
          cle.cle_id,
          cheq_fechavto,
          cheq_fechacobro


  from   DepositoBancoItem dbcoi
        inner join Cuenta           on dbcoi.cue_id  = Cuenta.cue_id
        left  join chequera chq     on dbcoi.chq_id  = chq.chq_id   
        left  join Cheque cheq      on dbcoi.cheq_id = cheq.cheq_id
        left  join moneda mon        on cheq.mon_id   = mon.mon_id
        left  join banco bco        on cheq.bco_id   = bco.bco_id
        left  join clearing cle     on cheq.cle_id   = cle.cle_id

  where 
        dbcoi.dbco_id = @@dbco_id
    and dbcoi_tipo     = @@dbcoi_tipo

  order by dbcoi_orden
end
go