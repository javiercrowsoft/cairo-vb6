-- delete facturaventacobranzatmp
-- delete cobranzaitemtmp
-- delete cobranzatmp
-- delete facturaventacobranza
-- delete cobranzaitem
-- delete cheque
-- delete tarjetacreditocupon
-- delete facturaventapago
-- delete cobranza

select * from facturaventacobranzatmp
select * from cobranzaitemtmp
select * from cobranzatmp

select * from facturaventacobranza
select * from cobranzaitem  
select sum(cobzi_importe) from cobranzaitem where cobzi_tipo <> 5
select * from cobranza

select * from facturaventapago

select * from tarjetacreditocupon
select * from cheque