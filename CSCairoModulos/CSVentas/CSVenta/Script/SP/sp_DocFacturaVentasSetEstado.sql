if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentasSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentasSetEstado]

/*

 sp_DocFacturaVentasSetEstado 

*/

go
create procedure sp_DocFacturaVentasSetEstado (
  @@desde       datetime = '19900101',
  @@hasta       datetime = '21000101'
)
as

begin

  declare @fv_id int

  declare c_Ventas insensitive cursor for 
    select fv_id from facturaVenta where fv_fecha between @@desde and @@hasta

  open c_Ventas

  fetch next from c_Ventas into @fv_id
  while @@fetch_status = 0 begin

    exec sp_DocFacturaVentaSetEstado @fv_id

    fetch next from c_Ventas into @fv_id
  end

  close c_Ventas
  deallocate c_Ventas
end