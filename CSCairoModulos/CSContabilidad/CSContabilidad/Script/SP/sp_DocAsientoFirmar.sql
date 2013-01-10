if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocAsientoFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocAsientoFirmar]

go

/*

sp_DocAsientoFirmar 17,8

*/

create procedure sp_DocAsientoFirmar (
  @@as_id int,
  @@us_id int
)
as

begin

  declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
  if exists(select as_firmado from Asiento where as_id = @@as_id and as_firmado <> 0)
  begin
    update Asiento set as_firmado = 0 where as_id = @@as_id
    set @bFirmar = 1
  -- Sino lo firma
  end else begin
    update Asiento set as_firmado = @@us_id where as_id = @@as_id
    set @bFirmar = 0
  end

  exec sp_DocAsientoSetEstado @@as_id

  select Asiento.est_id,est_nombre 
  from Asiento inner join Estado on Asiento.est_id = Estado.est_id
  where as_id = @@as_id

  if @bFirmar <> 0   exec sp_HistoriaUpdate 19001, @@as_id, @@us_id, 9
  else               exec sp_HistoriaUpdate 19001, @@as_id, @@us_id, 10

end