select * from facturacompra fc

where fc_totalotros <> IsNull((select sum(fcot_debe-fcot_haber) from facturacompraotro where fc_id = fc.fc_id),0)