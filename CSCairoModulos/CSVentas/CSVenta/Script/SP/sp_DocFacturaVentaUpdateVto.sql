if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaUpdateVto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaUpdateVto]

/*

 sp_DocFacturaVentaUpdateVto 124

*/

go
create procedure sp_DocFacturaVentaUpdateVto (

      @@fv_id            int,
      @@diff            int
)
as

begin

  declare @fvd_fecha2  datetime
  declare @fvd_fecha   datetime
  declare @fvd_id      int

  update FacturaVentaDeuda set fvd_fecha = dateadd(d,@@diff,fvd_fecha) where fv_id = @@fv_id
  update FacturaVentaPago  set fvp_fecha = dateadd(d,@@diff,fvp_fecha) where fv_id = @@fv_id

  declare c_deuda insensitive cursor for 
    select fvd_id, fvd_fecha from FacturaVentaDeuda where fv_id = @@fv_id

  open c_deuda

  fetch next from c_deuda into @fvd_id, @fvd_fecha
  while @@fetch_status=0
  begin

    exec sp_DocGetFecha2 @fvd_fecha, @fvd_fecha2 out, 0, null

    update FacturaVentaDeuda set fvd_fecha2 = @fvd_fecha2 where fvd_id = @fvd_id

    fetch next from c_deuda into @fvd_id, @fvd_fecha
  end

  close c_deuda
  deallocate c_deuda

end

go