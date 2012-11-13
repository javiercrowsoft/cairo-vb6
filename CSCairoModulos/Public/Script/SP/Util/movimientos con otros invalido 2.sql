select * from facturacompra fc
where fc_totalotros <> 0 and not exists(select * from facturacompraotro where fc_id = fc.fc_id)

A-0004-00008415
A-0004-00008872
A-0002-00006871
A-0002-00004682
A-1096-00008154
A-0001-00000002
