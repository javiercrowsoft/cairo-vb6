if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocResolucionCuponFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocResolucionCuponFirmar]

go

/*

sp_DocResolucionCuponFirmar 17,8

*/

create procedure sp_DocResolucionCuponFirmar (
  @@rcup_id int,
  @@us_id int
)
as

begin

  declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
  if exists(select rcup_firmado from ResolucionCupon where rcup_id = @@rcup_id and rcup_firmado <> 0)
  begin
    update ResolucionCupon set rcup_firmado = 0 where rcup_id = @@rcup_id
    set @bFirmar = 1
  -- Sino lo firma
  end else begin
    update ResolucionCupon set rcup_firmado = @@us_id where rcup_id = @@rcup_id
    set @bFirmar = 0
  end

  exec sp_DocResolucionCuponSetEstado @@rcup_id

  select ResolucionCupon.est_id,est_nombre 
  from ResolucionCupon inner join Estado on ResolucionCupon.est_id = Estado.est_id
  where rcup_id = @@rcup_id

  if @bFirmar <> 0   exec sp_HistoriaUpdate 18009, @@rcup_id, @@us_id, 9
  else               exec sp_HistoriaUpdate 18009, @@rcup_id, @@us_id, 10

end