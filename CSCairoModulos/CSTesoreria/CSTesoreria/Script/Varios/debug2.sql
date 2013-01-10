/*

Server: Msg 547, Level 16, State 1, Procedure sp_DocFacturaVentaNotaCreditoSave, Line 361
INSERT statement conflicted with COLUMN FOREIGN KEY constraint 'FK_FacturaVentaNotaCredito_FacturaVenta'. The conflict occurred in database 'Cairo', table 'FacturaVenta', column 'fv_id'.

select * from facturaventadeuda


*/

begin transaction

  exec  sp_DocCobranzaSave 114

  select * from facturaventacobranza

rollback transaction

/*

delete facturaventapago

delete facturaventanotacredito

select * from facturaventanotacredito
select * from facturaventacobranzatmp
select * from facturaventanotacreditotmp




select * from cobranzatmp where cobztmp_id = 110
select * from facturaventatmp where cobztmp_id = 110



delete facturaventanotacreditotmp
delete cobranzatmp

*/

/*
405 399 407

select * from cobranzaitemtmp where cobztmp_id = 82

declare @deuda decimal(18,6)
        set @deuda = 0
        select  @deuda=fvd_pendiente from FacturaVentaDeuda where fvd_id = 5005
        select @deuda

        select  sum(fvcobz_importe) from FacturaVentaCobranza where fvd_id = 405
        select  sum(fvnc_importe) from FacturaVentaNotaCredito where fvd_id_factura = 405
*/