if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoBancoAsientosSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoBancoAsientosSave]

/*

  delete DepositoBancoAsiento

  insert into DepositoBancoAsiento (dbco_id,dbco_fecha) select dbco_id,'20040304' from DepositoBanco 
where dbco_grabarAsiento <> 0 

  sp_DocDepositoBancoAsientosSave 

  select * from asiento
  select dbco_id,as_id from DepositoBanco
  update DepositoBanco set as_id = null

  sp_monedaGetCotizacion 3,'20040304'

*/

go
create procedure sp_DocDepositoBancoAsientosSave 
as

begin

  set nocount on

  declare @dbco_id   int
  declare @est_id   int
  declare @as_id    int
  declare @bError   smallint
  declare @MsgError varchar(5000)

  declare c_DepBcoAsientos insensitive cursor for
    select dbcoa.dbco_id, est_id, as_id 
    from DepositoBancoAsiento dbcoa inner join DepositoBanco dbco on dbcoa.dbco_id = dbco.dbco_id 
    order by dbcoa.dbco_fecha

  open c_DepBcoAsientos
  fetch next from c_DepBcoAsientos into @dbco_id, @est_id, @as_id

  while @@fetch_status=0 begin

    if @est_id = 7 begin

      update DepositoBanco set as_id = null where dbco_id = @dbco_id
      exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
      delete DepositoBancoAsiento where dbco_id = @dbco_id

    end else begin

      exec sp_DocDepositoBancoAsientoSave @dbco_id,0,@bError out, @MsgError out
      if @bError <> 0 begin
        raiserror ('Ha ocurrido un error el asiento del deposito bancario. sp_DocDepositoBancoAsientosSave.', 16, 1)
      end else begin
        delete DepositoBancoAsiento where dbco_id = @dbco_id
      end

    end

    fetch next from c_DepBcoAsientos into @dbco_id, @est_id, @as_id
  end

  close c_DepBcoAsientos
  deallocate c_DepBcoAsientos

end