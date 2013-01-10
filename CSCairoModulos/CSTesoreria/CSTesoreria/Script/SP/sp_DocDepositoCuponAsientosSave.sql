if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoCuponAsientosSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoCuponAsientosSave]

/*

  delete DepositoCuponAsiento

  insert into DepositoCuponAsiento (dcup_id,dcup_fecha) select dcup_id,'20040304' from DepositoCupon 
where dcup_grabarAsiento <> 0 

  sp_DocDepositoCuponAsientosSave 

  select * from asiento
  select dcup_id,as_id from DepositoCupon
  update DepositoCupon set as_id = null

  sp_monedaGetCotizacion 3,'20040304'

*/

go
create procedure sp_DocDepositoCuponAsientosSave 
as

begin

  set nocount on

  declare @dcup_id     int
  declare @est_id   int
  declare @as_id    int
  declare @bError   smallint
  declare @MsgError varchar(5000)

  declare c_DepBcoAsientos insensitive cursor for
    select dcupa.dcup_id, est_id, as_id 
    from DepositoCuponAsiento dcupa inner join DepositoCupon dcup on dcupa.dcup_id = dcup.dcup_id 
    order by dcupa.dcup_fecha

  open c_DepBcoAsientos
  fetch next from c_DepBcoAsientos into @dcup_id, @est_id, @as_id

  while @@fetch_status=0 begin

    if @est_id = 7 begin

      update DepositoCupon set as_id = null where dcup_id = @dcup_id
      exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
      delete DepositoCuponAsiento where dcup_id = @dcup_id

    end else begin

      exec sp_DocDepositoCuponAsientoSave @dcup_id,0,@bError out, @MsgError out
      if @bError <> 0 begin
        raiserror ('Ha ocurrido un error el asiento de la presentacion de cupones. sp_DocDepositoCuponAsientosSave.', 16, 1)
      end else begin
        delete DepositoCuponAsiento where dcup_id = @dcup_id
      end

    end

    fetch next from c_DepBcoAsientos into @dcup_id, @est_id, @as_id
  end

  close c_DepBcoAsientos
  deallocate c_DepBcoAsientos

end