if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocDepositoCuponFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocDepositoCuponFirmar]

go

/*

sp_DocDepositoCuponFirmar 17,8

*/

create procedure sp_DocDepositoCuponFirmar (
  @@dcup_id int,
  @@us_id int
)
as

begin

  declare @bFirmar tinyint

  -- Si esta firmado le quita la firma
  if exists(select dcup_firmado from DepositoCupon where dcup_id = @@dcup_id and dcup_firmado <> 0)
  begin
    update DepositoCupon set dcup_firmado = 0 where dcup_id = @@dcup_id
    set @bFirmar = 1
  -- Sino lo firma
  end else begin
    update DepositoCupon set dcup_firmado = @@us_id where dcup_id = @@dcup_id
    set @bFirmar = 0
  end

  exec sp_DocDepositoCuponSetEstado @@dcup_id

  select DepositoCupon.est_id,est_nombre 
  from DepositoCupon inner join Estado on DepositoCupon.est_id = Estado.est_id
  where dcup_id = @@dcup_id

  if @bFirmar <> 0   exec sp_HistoriaUpdate 18008, @@dcup_id, @@us_id, 9
  else               exec sp_HistoriaUpdate 18008, @@dcup_id, @@us_id, 10

end