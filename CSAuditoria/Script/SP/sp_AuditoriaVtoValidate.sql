-- Script de Chequeo de Integridad de:

-- 2 - Control de vencimientos FC y FV

if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_AuditoriaVtoValidate]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AuditoriaVtoValidate]

go

create procedure sp_AuditoriaVtoValidate (

  @@aud_id       int,
  @@aud_fecha   datetime

)
as

begin

  set nocount on

  -- Factura de Venta
  --
  declare @fv_id int

  declare c_audi_vto insensitive cursor for 

    select fv_id 
    from FacturaVenta fv
    where fv.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @fv_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaVtoValidateDocFV @fv_id, @@aud_id

    fetch next from c_audi_vto into @fv_id
  end

  close c_audi_vto

  deallocate c_audi_vto

  -- Factura de Compra
  --
  declare @fc_id int

  declare c_audi_vto insensitive cursor for 

    select fc_id 
    from FacturaCompra fc 
    where fc.modificado >= @@aud_fecha

  open c_audi_vto

  fetch next from c_audi_vto into @fc_id
  while @@fetch_status = 0
  begin

    exec sp_AuditoriaVtoValidateDocFC @fc_id, @@aud_id

    fetch next from c_audi_vto into @fc_id
  end

  close c_audi_vto

  deallocate c_audi_vto

ControlError:

end
GO