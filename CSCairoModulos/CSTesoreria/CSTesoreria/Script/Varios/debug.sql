/*sp_DocCobranzaGetAplic 18

select * from facturaventacobranzatmp where cobztmp_id = 69
select * from cobranzatmp where cobztmp_id = 69
*/

begin transaction
select * from facturaventacobranza where cobz_id = 18
--select * from facturaventapago where cobz_id = 18
exec sp_DocCobranzaSaveAplic 72
--select * from facturaventapago where cobz_id = 18
select * from facturaventacobranza where cobz_id = 18
--select * from cobranzaitem where cobzi_tipo = 5
rollback transaction

/*

        select c.cue_id, sum(fvi_importe), c.mon_id 
                    from FacturaVentaItem fvi inner join Cuenta c on fvi.cue_id = c.cue_id
                                              inner join FacturaVentaCobranza fvc on fvc.fv_id = fvi.fv_id
        where cobz_id = 16
        group by c.cue_id, c.mon_id


        select c.cue_id, sum(fvi_importe), c.mon_id 
                    from FacturaVentaItem fvi inner join Cuenta c on fvi.cue_id = c.cue_id
        group by c.cue_id, c.mon_id


        select * from Cobranza 
        select * from facturaventacobranza
        select * from FacturaVentadeuda 
        select * from FacturaVentapago 

delete facturaventacobranza
delete facturaventadeuda
delete facturaventapago

*/