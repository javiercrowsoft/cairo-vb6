if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocCobranzaAsientosSave]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocCobranzaAsientosSave]

/*



  update cobranza set cobz_grabarAsiento = 1

  delete CobranzaAsiento

  insert into CobranzaAsiento (cobz_id,cobz_fecha) select cobz_id,'20040304' from Cobranza 
  where cobz_grabarAsiento <> 0 

  sp_DocCobranzaAsientosSave 

  select * from asiento
  select cobz_id,as_id from Cobranza

  sp_monedaGetCotizacion 3,'20040304'

*/

go
create procedure sp_DocCobranzaAsientosSave 
as

begin

  set nocount on

  declare @cobz_id   int
  declare @est_id   int
  declare @as_id    int
  declare @bError   smallint
  declare @MsgError varchar(5000)

  declare c_CobranzaAsientos insensitive cursor for
    select cobza.cobz_id, est_id, as_id 
    from CobranzaAsiento cobza inner join Cobranza cobz on cobza.cobz_id = cobz.cobz_id 
    order by cobza.cobz_fecha

  open c_CobranzaAsientos
  fetch next from c_CobranzaAsientos into @cobz_id, @est_id, @as_id

  while @@fetch_status=0 begin

    if @est_id = 7 begin

      update Cobranza set as_id = null where cobz_id = @cobz_id
      exec sp_DocAsientoDelete @as_id,0,0,1 -- No check access
      delete CobranzaAsiento where cobz_id = @cobz_id

    end else begin

      exec sp_DocCobranzaAsientoSave @cobz_id,0,@bError out, @MsgError out
      if @bError <> 0 begin
        raiserror ('Ha ocurrido un error al grabar la cobranza. sp_DocCobranzaAsientosSave.', 16, 1)
      end else begin
        delete CobranzaAsiento where cobz_id = @cobz_id
      end

    end

    fetch next from c_CobranzaAsientos into @cobz_id, @est_id, @as_id
  end

  close c_CobranzaAsientos
  deallocate c_CobranzaAsientos

end