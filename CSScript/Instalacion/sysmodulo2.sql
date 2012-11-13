if exists(select * from sysModulo where sysm_id = 41) begin
update sysModulo set sysm_objetoinicializacion= 'CSOAPI.cInitCSOAPI',sysm_objetoedicion= 'CSOAPI.cSysmodulo',sysm_id= 41,sysm_orden= 40,pre_id= 21 where sysm_id = 41
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSOAPI.cInitCSOAPI','CSOAPI.cSysmodulo',41,40,21)
end
if exists(select * from sysModulo where sysm_id = 42) begin
update sysModulo set sysm_objetoinicializacion= 'CSOAPI.cInitCSOAPI',sysm_objetoedicion= 'CSOAPI.cTabla',sysm_id= 42,sysm_orden= 41,pre_id= 25 where sysm_id = 42
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSOAPI.cInitCSOAPI','CSOAPI.cTabla',42,41,25)
end
if exists(select * from sysModulo where sysm_id = 43) begin
update sysModulo set sysm_objetoinicializacion= 'CSOAPI.cInitCSOAPI',sysm_objetoedicion= 'CSOAPI.cSysmoduloTCP',sysm_id= 43,sysm_orden= 43,pre_id= 29 where sysm_id = 43
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSOAPI.cInitCSOAPI','CSOAPI.cSysmoduloTCP',43,43,29)
end
if exists(select * from sysModulo where sysm_id = 1001) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cBanco',sysm_id= 1001,sysm_orden= 1003,pre_id= 1035 where sysm_id = 1001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cBanco',1001,1003,1035)
end
if exists(select * from sysModulo where sysm_id = 1002) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cCentroCosto',sysm_id= 1002,sysm_orden= 1002,pre_id= 1055 where sysm_id = 1002
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cCentroCosto',1002,1002,1055)
end
if exists(select * from sysModulo where sysm_id = 1003) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cClearing',sysm_id= 1003,sysm_orden= 1004,pre_id= 1067 where sysm_id = 1003
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cClearing',1003,1004,1067)
end
if exists(select * from sysModulo where sysm_id = 1004) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cCliente',sysm_id= 1004,sysm_orden= 1007,pre_id= 1071 where sysm_id = 1004
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cCliente',1004,1007,1071)
end
if exists(select * from sysModulo where sysm_id = 1006) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cCobrador',sysm_id= 1006,sysm_orden= 1010,pre_id= 1059 where sysm_id = 1006
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cCobrador',1006,1010,1059)
end
if exists(select * from sysModulo where sysm_id = 1007) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneralEx.cInitCSGeneralEx',sysm_objetoedicion= 'CSGeneralEx.cMoneda',sysm_id= 1007,sysm_orden= 1002,pre_id= 1031 where sysm_id = 1007
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneralEx.cInitCSGeneralEx','CSGeneralEx.cMoneda',1007,1002,1031)
end
if exists(select * from sysModulo where sysm_id = 1008) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cCuenta',sysm_id= 1008,sysm_orden= 1001,pre_id= 1047 where sysm_id = 1008
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cCuenta',1008,1001,1047)
end
GO
if exists(select * from sysModulo where sysm_id = 1009) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cCuentaGrupo',sysm_id= 1009,sysm_orden= 1009,pre_id= 1172 where sysm_id = 1009
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cCuentaGrupo',1009,1009,1172)
end
if exists(select * from sysModulo where sysm_id = 1010) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cDepositoFisico',sysm_id= 1010,sysm_orden= 1003,pre_id= 1127 where sysm_id = 1010
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cDepositoFisico',1010,1003,1127)
end
if exists(select * from sysModulo where sysm_id = 1011) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cDepositoLogico',sysm_id= 1011,sysm_orden= 1004,pre_id= 1019 where sysm_id = 1011
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cDepositoLogico',1011,1004,1019)
end
if exists(select * from sysModulo where sysm_id = 1012) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cEscala',sysm_id= 1012,sysm_orden= 1005,pre_id= 1087 where sysm_id = 1012
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cEscala',1012,1005,1087)
end
if exists(select * from sysModulo where sysm_id = 1013) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cLeyenda',sysm_id= 1013,sysm_orden= 1004,pre_id= 1051 where sysm_id = 1013
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cLeyenda',1013,1004,1051)
end
if exists(select * from sysModulo where sysm_id = 1014) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneralEx.cInitCSGeneralEx',sysm_objetoedicion= 'CSGeneralEx.cListaPrecio',sysm_id= 1014,sysm_orden= 1011,pre_id= 1099 where sysm_id = 1014
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneralEx.cInitCSGeneralEx','CSGeneralEx.cListaPrecio',1014,1011,1099)
end
if exists(select * from sysModulo where sysm_id = 1015) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cProducto',sysm_id= 1015,sysm_orden= 1007,pre_id= 1079 where sysm_id = 1015
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cProducto',1015,1007,1079)
end
if exists(select * from sysModulo where sysm_id = 1016) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cProveedor',sysm_id= 1016,sysm_orden= 1006,pre_id= 1075 where sysm_id = 1016
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cProveedor',1016,1006,1075)
end
if exists(select * from sysModulo where sysm_id = 1017) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cReglaLiquidacion',sysm_id= 1017,sysm_orden= 1008,pre_id= 1063 where sysm_id = 1017
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cReglaLiquidacion',1017,1008,1063)
end
if exists(select * from sysModulo where sysm_id = 1018) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cRubro',sysm_id= 1018,sysm_orden= 1006,pre_id= 1083 where sysm_id = 1018
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cRubro',1018,1006,1083)
end
GO
if exists(select * from sysModulo where sysm_id = 1019) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cTarjetaCredito',sysm_id= 1019,sysm_orden= 1005,pre_id= 1043 where sysm_id = 1019
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cTarjetaCredito',1019,1005,1043)
end
if exists(select * from sysModulo where sysm_id = 1020) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cTasaImpositiva',sysm_id= 1020,sysm_orden= 1003,pre_id= 1123 where sysm_id = 1020
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cTasaImpositiva',1020,1003,1123)
end
if exists(select * from sysModulo where sysm_id = 1021) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cTransporte',sysm_id= 1021,sysm_orden= 1005,pre_id= 1091 where sysm_id = 1021
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cTransporte',1021,1005,1091)
end
if exists(select * from sysModulo where sysm_id = 1022) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cUnidad',sysm_id= 1022,sysm_orden= 1004,pre_id= 1023 where sysm_id = 1022
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cUnidad',1022,1004,1023)
end
if exists(select * from sysModulo where sysm_id = 1023) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cVendedores',sysm_id= 1023,sysm_orden= 1009,pre_id= 1039 where sysm_id = 1023
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cVendedores',1023,1009,1039)
end
if exists(select * from sysModulo where sysm_id = 1024) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cZona',sysm_id= 1024,sysm_orden= 1006,pre_id= 1119 where sysm_id = 1024
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cZona',1024,1006,1119)
end
if exists(select * from sysModulo where sysm_id = 1027) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cPais',sysm_id= 1027,sysm_orden= 1027,pre_id= 1107 where sysm_id = 1027
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cPais',1027,1027,1107)
end
if exists(select * from sysModulo where sysm_id = 1028) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cProvincia',sysm_id= 1028,sysm_orden= 1027,pre_id= 1115 where sysm_id = 1028
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cProvincia',1028,1027,1115)
end
if exists(select * from sysModulo where sysm_id = 1030) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cCiudad',sysm_id= 1030,sysm_orden= 1028,pre_id= 1111 where sysm_id = 1030
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cCiudad',1030,1028,1111)
end
if exists(select * from sysModulo where sysm_id = 1031) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneralEx.cInitCSGeneralEx',sysm_objetoedicion= 'CSGeneralEx.cChequera',sysm_id= 1031,sysm_orden= 1004,pre_id= 1131 where sysm_id = 1031
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneralEx.cInitCSGeneralEx','CSGeneralEx.cChequera',1031,1004,1131)
end
GO
if exists(select * from sysModulo where sysm_id = 1032) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cChofer',sysm_id= 1032,sysm_orden= 1032,pre_id= 1147 where sysm_id = 1032
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cChofer',1032,1032,1147)
end
if exists(select * from sysModulo where sysm_id = 1033) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cMarca',sysm_id= 1033,sysm_orden= 1033,pre_id= 1139 where sysm_id = 1033
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cMarca',1033,1033,1139)
end
if exists(select * from sysModulo where sysm_id = 1034) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cCalidad',sysm_id= 1034,sysm_orden= 1034,pre_id= 1135 where sysm_id = 1034
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cCalidad',1034,1034,1135)
end
if exists(select * from sysModulo where sysm_id = 1035) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cCamion',sysm_id= 1035,sysm_orden= 1035,pre_id= 1143 where sysm_id = 1035
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cCamion',1035,1035,1143)
end
if exists(select * from sysModulo where sysm_id = 1036) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cCondicionPago',sysm_id= 1036,sysm_orden= 1036,pre_id= 1151 where sysm_id = 1036
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cCondicionPago',1036,1036,1151)
end
if exists(select * from sysModulo where sysm_id = 1037) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneralEx.cInitCSGeneralEx',sysm_objetoedicion= 'CSGeneralEx.cListaDescuento',sysm_id= 1037,sysm_orden= 1037,pre_id= 1155 where sysm_id = 1037
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneralEx.cInitCSGeneralEx','CSGeneralEx.cListaDescuento',1037,1037,1155)
end
if exists(select * from sysModulo where sysm_id = 1038) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneralEx.cInitCSGeneralEx',sysm_objetoedicion= 'CSGeneralEx.cGeneralConfig',sysm_id= 1038,sysm_orden= 1026,pre_id= 1156 where sysm_id = 1038
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneralEx.cInitCSGeneralEx','CSGeneralEx.cGeneralConfig',1038,1026,1156)
end
if exists(select * from sysModulo where sysm_id = 1039) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cSucursal',sysm_id= 1039,sysm_orden= 1039,pre_id= 1027 where sysm_id = 1039
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cSucursal',1039,1039,1027)
end
if exists(select * from sysModulo where sysm_id = 1040) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cRubroTabla',sysm_id= 1040,sysm_orden= 1040,pre_id= 1164 where sysm_id = 1040
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cRubroTabla',1040,1040,1164)
end
if exists(select * from sysModulo where sysm_id = 1041) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneralEx.cInitCSGeneralEx',sysm_objetoedicion= 'CSGeneralEx.cVentaConfig',sysm_id= 1041,sysm_orden= 1005,pre_id= 1173 where sysm_id = 1041
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneralEx.cInitCSGeneralEx','CSGeneralEx.cVentaConfig',1041,1005,1173)
end
GO
if exists(select * from sysModulo where sysm_id = 1042) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneralEx.cInitCSGeneralEx',sysm_objetoedicion= 'CSGeneralEx.cTesoreriaConfig',sysm_id= 1042,sysm_orden= 1001,pre_id= 1174 where sysm_id = 1042
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneralEx.cInitCSGeneralEx','CSGeneralEx.cTesoreriaConfig',1042,1001,1174)
end
if exists(select * from sysModulo where sysm_id = 1043) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneralEx.cInitCSGeneralEx',sysm_objetoedicion= 'CSGeneralEx.cCompraConfig',sysm_id= 1043,sysm_orden= 1005,pre_id= 1175 where sysm_id = 1043
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneralEx.cInitCSGeneralEx','CSGeneralEx.cCompraConfig',1043,1005,1175)
end
if exists(select * from sysModulo where sysm_id = 1044) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cPercepcionTipo',sysm_id= 1044,sysm_orden= 1041,pre_id= 1184 where sysm_id = 1044
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cPercepcionTipo',1044,1041,1184)
end
if exists(select * from sysModulo where sysm_id = 1045) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cPercepcion',sysm_id= 1045,sysm_orden= 1045,pre_id= 1180 where sysm_id = 1045
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cPercepcion',1045,1045,1180)
end
if exists(select * from sysModulo where sysm_id = 1046) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cRetencionTipo',sysm_id= 1046,sysm_orden= 1046,pre_id= 1192 where sysm_id = 1046
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cRetencionTipo',1046,1046,1192)
end
if exists(select * from sysModulo where sysm_id = 1047) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cRetencion',sysm_id= 1047,sysm_orden= 1047,pre_id= 1188 where sysm_id = 1047
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cRetencion',1047,1047,1188)
end
if exists(select * from sysModulo where sysm_id = 1048) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cDepartamento',sysm_id= 1048,sysm_orden= 1048,pre_id= 1196 where sysm_id = 1048
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cDepartamento',1048,1048,1196)
end
if exists(select * from sysModulo where sysm_id = 1049) begin
update sysModulo set sysm_objetoinicializacion= 'CSGeneral.cInitCSGeneral',sysm_objetoedicion= 'CSGeneral.cCircuitoContable',sysm_id= 1049,sysm_orden= 1049,pre_id= 1200 where sysm_id = 1049
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSGeneral.cInitCSGeneral','CSGeneral.cCircuitoContable',1049,1049,1200)
end
if exists(select * from sysModulo where sysm_id = 2003) begin
update sysModulo set sysm_objetoinicializacion= 'CSTarea.cInitCSTarea',sysm_objetoedicion= 'CSTarea.cTarea',sysm_id= 2003,sysm_orden= 2000,pre_id= 2003 where sysm_id = 2003
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSTarea.cInitCSTarea','CSTarea.cTarea',2003,2000,2003)
end
if exists(select * from sysModulo where sysm_id = 2007) begin
update sysModulo set sysm_objetoinicializacion= 'CSTarea.cInitCSTarea',sysm_objetoedicion= 'CSTarea.cPrioridad',sysm_id= 2007,sysm_orden= 2002,pre_id= 2007 where sysm_id = 2007
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSTarea.cInitCSTarea','CSTarea.cPrioridad',2007,2002,2007)
end
GO
if exists(select * from sysModulo where sysm_id = 2011) begin
update sysModulo set sysm_objetoinicializacion= 'CSTarea.cInitCSTarea',sysm_objetoedicion= 'CSTarea.cTareaEstado',sysm_id= 2011,sysm_orden= 2003,pre_id= 2011 where sysm_id = 2011
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSTarea.cInitCSTarea','CSTarea.cTareaEstado',2011,2003,2011)
end
if exists(select * from sysModulo where sysm_id = 2015) begin
update sysModulo set sysm_objetoinicializacion= 'CSTarea.cInitCSTarea',sysm_objetoedicion= 'CSTarea.cContacto',sysm_id= 2015,sysm_orden= 2001,pre_id= 2015 where sysm_id = 2015
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSTarea.cInitCSTarea','CSTarea.cContacto',2015,2001,2015)
end
if exists(select * from sysModulo where sysm_id = 2016) begin
update sysModulo set sysm_objetoinicializacion= 'CSTarea.cInitCSTarea',sysm_objetoedicion= 'CSTarea.cProyecto',sysm_id= 2016,sysm_orden= 2004,pre_id= 2019 where sysm_id = 2016
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSTarea.cInitCSTarea','CSTarea.cProyecto',2016,2004,2019)
end
if exists(select * from sysModulo where sysm_id = 2017) begin
update sysModulo set sysm_objetoinicializacion= 'CSTarea.cInitCSTarea',sysm_objetoedicion= 'CSTarea.cHora',sysm_id= 2017,sysm_orden= 2005,pre_id= 2023 where sysm_id = 2017
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSTarea.cInitCSTarea','CSTarea.cHora',2017,2005,2023)
end
if exists(select * from sysModulo where sysm_id = 3001) begin
update sysModulo set sysm_objetoinicializacion= 'CSPedidoVenta.cInitCSPedidoVenta',sysm_objetoedicion= 'CSPedidoVenta.cPedidoVenta',sysm_id= 3001,sysm_orden= 3000,pre_id= 3003 where sysm_id = 3001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSPedidoVenta.cInitCSPedidoVenta','CSPedidoVenta.cPedidoVenta',3001,3000,3003)
end
if exists(select * from sysModulo where sysm_id = 4001) begin
update sysModulo set sysm_objetoinicializacion= 'CSDocumento.cInitCSDocumento',sysm_objetoedicion= 'CSDocumento.cDocumento',sysm_id= 4001,sysm_orden= 4000,pre_id= 4003 where sysm_id = 4001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSDocumento.cInitCSDocumento','CSDocumento.cDocumento',4001,4000,4003)
end
if exists(select * from sysModulo where sysm_id = 4002) begin
update sysModulo set sysm_objetoinicializacion= 'CSDocumento.cInitCSDocumento',sysm_objetoedicion= 'CSDocumento.cFechaControlAcceso',sysm_id= 4002,sysm_orden= 4002,pre_id= 4007 where sysm_id = 4002
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSDocumento.cInitCSDocumento','CSDocumento.cFechaControlAcceso',4002,4002,4007)
end
if exists(select * from sysModulo where sysm_id = 4004) begin
update sysModulo set sysm_objetoinicializacion= 'CSDocumento.cInitCSDocumento',sysm_objetoedicion= 'CSDocumento.cTalonario',sysm_id= 4004,sysm_orden= 4004,pre_id= 4011 where sysm_id = 4004
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSDocumento.cInitCSDocumento','CSDocumento.cTalonario',4004,4004,4011)
end
if exists(select * from sysModulo where sysm_id = 6001) begin
update sysModulo set sysm_objetoinicializacion= 'CSInfoAFIP.cInitCSInfoAFIP',sysm_objetoedicion= 'CSInfoAFIP.cAFIPEsquema',sysm_id= 6001,sysm_orden= 6000,pre_id= 6004 where sysm_id = 6001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSInfoAFIP.cInitCSInfoAFIP','CSInfoAFIP.cAFIPEsquema',6001,6000,6004)
end
if exists(select * from sysModulo where sysm_id = 7001) begin
update sysModulo set sysm_objetoinicializacion= 'CSInforme.cInitCSInforme',sysm_objetoedicion= 'CSInforme.cInforme',sysm_id= 7001,sysm_orden= 7000,pre_id= 7004 where sysm_id = 7001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSInforme.cInitCSInforme','CSInforme.cInforme',7001,7000,7004)
end
GO
if exists(select * from sysModulo where sysm_id = 7002) begin
update sysModulo set sysm_objetoinicializacion= 'CSInforme.cInitCSInforme',sysm_objetoedicion= 'CSInforme.cInformeConfig',sysm_id= 7002,sysm_orden= 7001,pre_id= 7013 where sysm_id = 7002
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSInforme.cInitCSInforme','CSInforme.cInformeConfig',7002,7001,7013)
end
if exists(select * from sysModulo where sysm_id = 8001) begin
update sysModulo set sysm_objetoinicializacion= 'CSAFIPRes1361.cInitCSAFIPRes1361',sysm_objetoedicion= 'CSAFIPRes1361.cProveedorCAIS',sysm_id= 8001,sysm_orden= 8000,pre_id= 0 where sysm_id = 8001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSAFIPRes1361.cInitCSAFIPRes1361','CSAFIPRes1361.cProveedorCAIS',8001,8000,0)
end
if exists(select * from sysModulo where sysm_id = 8002) begin
update sysModulo set sysm_objetoinicializacion= 'CSAFIPRes1361.cInitCSAFIPRes1361',sysm_objetoedicion= 'CSAFIPRes1361.cCAIS',sysm_id= 8002,sysm_orden= 8001,pre_id= 8002 where sysm_id = 8002
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSAFIPRes1361.cInitCSAFIPRes1361','CSAFIPRes1361.cCAIS',8002,8001,8002)
end
if exists(select * from sysModulo where sysm_id = 9001) begin
update sysModulo set sysm_objetoinicializacion= 'CSAFIPRes3419.cInitCSAFIPRes3419',sysm_objetoedicion= 'CSAFIPRes3419.cDummy',sysm_id= 9001,sysm_orden= 9000,pre_id= 0 where sysm_id = 9001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSAFIPRes3419.cInitCSAFIPRes3419','CSAFIPRes3419.cDummy',9001,9000,0)
end
if exists(select * from sysModulo where sysm_id = 11001) begin
update sysModulo set sysm_objetoinicializacion= 'CSApicultura.cInitCSApicultura',sysm_objetoedicion= 'CSApicultura.cColmena',sysm_id= 11001,sysm_orden= 11000,pre_id= 11015 where sysm_id = 11001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSApicultura.cInitCSApicultura','CSApicultura.cColmena',11001,11000,11015)
end
if exists(select * from sysModulo where sysm_id = 11002) begin
update sysModulo set sysm_objetoinicializacion= 'CSApicultura.cInitCSApicultura',sysm_objetoedicion= 'CSApicultura.cAlsa',sysm_id= 11002,sysm_orden= 11001,pre_id= 11003 where sysm_id = 11002
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSApicultura.cInitCSApicultura','CSApicultura.cAlsa',11002,11001,11003)
end
if exists(select * from sysModulo where sysm_id = 11003) begin
update sysModulo set sysm_objetoinicializacion= 'CSApicultura.cInitCSApicultura',sysm_objetoedicion= 'CSApicultura.cReina',sysm_id= 11003,sysm_orden= 11002,pre_id= 11011 where sysm_id = 11003
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSApicultura.cInitCSApicultura','CSApicultura.cReina',11003,11002,11011)
end
if exists(select * from sysModulo where sysm_id = 12001) begin
update sysModulo set sysm_objetoinicializacion= 'CSEmpaque.cInitCSEmpaque',sysm_objetoedicion= 'CSEmpaque.cBarco',sysm_id= 12001,sysm_orden= 12001,pre_id= 1000052 where sysm_id = 12001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSEmpaque.cInitCSEmpaque','CSEmpaque.cBarco',12001,12001,1000052)
end
if exists(select * from sysModulo where sysm_id = 12002) begin
update sysModulo set sysm_objetoinicializacion= 'CSEmpaque.cInitCSEmpaque',sysm_objetoedicion= 'CSEmpaque.cCalibradora',sysm_id= 12002,sysm_orden= 12002,pre_id= 1000040 where sysm_id = 12002
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSEmpaque.cInitCSEmpaque','CSEmpaque.cCalibradora',12002,12002,1000040)
end
if exists(select * from sysModulo where sysm_id = 12003) begin
update sysModulo set sysm_objetoinicializacion= 'CSEmpaque.cInitCSEmpaque',sysm_objetoedicion= 'CSEmpaque.cConfiguracionCalibradora',sysm_id= 12003,sysm_orden= 12003,pre_id= 1000036 where sysm_id = 12003
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSEmpaque.cInitCSEmpaque','CSEmpaque.cConfiguracionCalibradora',12003,12003,1000036)
end
GO
if exists(select * from sysModulo where sysm_id = 12004) begin
update sysModulo set sysm_objetoinicializacion= 'CSEmpaque.cInitCSEmpaque',sysm_objetoedicion= 'CSEmpaque.cPuerto',sysm_id= 12004,sysm_orden= 12004,pre_id= 1000056 where sysm_id = 12004
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSEmpaque.cInitCSEmpaque','CSEmpaque.cPuerto',12004,12004,1000056)
end
if exists(select * from sysModulo where sysm_id = 12005) begin
update sysModulo set sysm_objetoinicializacion= 'CSEmpaque.cInitCSEmpaque',sysm_objetoedicion= 'CSEmpaque.cContraMarca',sysm_id= 12005,sysm_orden= 12005,pre_id= 1000060 where sysm_id = 12005
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSEmpaque.cInitCSEmpaque','CSEmpaque.cContraMarca',12005,12005,1000060)
end
if exists(select * from sysModulo where sysm_id = 13001) begin
update sysModulo set sysm_objetoinicializacion= 'CSProduccion.cInitCSProduccion',sysm_objetoedicion= 'CSProduccion.cMaquina',sysm_id= 13001,sysm_orden= 13001,pre_id= 13005 where sysm_id = 13001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSProduccion.cInitCSProduccion','CSProduccion.cMaquina',13001,13001,13005)
end
if exists(select * from sysModulo where sysm_id = 15001) begin
update sysModulo set sysm_objetoinicializacion= 'CSEnvio.cInitCSEnvio',sysm_objetoedicion= 'CSEnvio.cLegajo',sysm_id= 15001,sysm_orden= 15001,pre_id= 15004 where sysm_id = 15001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSEnvio.cInitCSEnvio','CSEnvio.cLegajo',15001,15001,15004)
end
if exists(select * from sysModulo where sysm_id = 15002) begin
update sysModulo set sysm_objetoinicializacion= 'CSEnvio.cInitCSEnvio',sysm_objetoedicion= 'CSEnvio.cParteDiario',sysm_id= 15002,sysm_orden= 15002,pre_id= 15008 where sysm_id = 15002
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSEnvio.cInitCSEnvio','CSEnvio.cParteDiario',15002,15002,15008)
end
if exists(select * from sysModulo where sysm_id = 15003) begin
update sysModulo set sysm_objetoinicializacion= 'CSEnvio.cInitCSEnvio',sysm_objetoedicion= 'CSEnvio.cEnvioConfig',sysm_id= 15003,sysm_orden= 15003,pre_id= 15009 where sysm_id = 15003
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSEnvio.cInitCSEnvio','CSEnvio.cEnvioConfig',15003,15003,15009)
end
if exists(select * from sysModulo where sysm_id = 15006) begin
update sysModulo set sysm_objetoinicializacion= 'CSEnvio.cInitCSEnvio',sysm_objetoedicion= 'CSEnvio.cLegajoTipo',sysm_id= 15006,sysm_orden= 15004,pre_id= 15021 where sysm_id = 15006
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSEnvio.cInitCSEnvio','CSEnvio.cLegajoTipo',15006,15004,15021)
end
if exists(select * from sysModulo where sysm_id = 16001) begin
update sysModulo set sysm_objetoinicializacion= 'CSVenta.cInitCSVenta',sysm_objetoedicion= 'CSVenta.cRemitoVenta',sysm_id= 16001,sysm_orden= 16001,pre_id= 16009 where sysm_id = 16001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSVenta.cInitCSVenta','CSVenta.cRemitoVenta',16001,16001,16009)
end
if exists(select * from sysModulo where sysm_id = 16002) begin
update sysModulo set sysm_objetoinicializacion= 'CSVenta.cInitCSVenta',sysm_objetoedicion= 'CSVenta.cFacturaVenta',sysm_id= 16002,sysm_orden= 16002,pre_id= 16005 where sysm_id = 16002
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSVenta.cInitCSVenta','CSVenta.cFacturaVenta',16002,16002,16005)
end
if exists(select * from sysModulo where sysm_id = 17001) begin
update sysModulo set sysm_objetoinicializacion= 'CSCompra.cInitCSCompra',sysm_objetoedicion= 'CSCompra.cRemitoCompra',sysm_id= 17001,sysm_orden= 17001,pre_id= 17009 where sysm_id = 17001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSCompra.cInitCSCompra','CSCompra.cRemitoCompra',17001,17001,17009)
end
GO
if exists(select * from sysModulo where sysm_id = 17002) begin
update sysModulo set sysm_objetoinicializacion= 'CSCompra.cInitCSCompra',sysm_objetoedicion= 'CSCompra.cPedidoCompra',sysm_id= 17002,sysm_orden= 17002,pre_id= 17017 where sysm_id = 17002
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSCompra.cInitCSCompra','CSCompra.cPedidoCompra',17002,17002,17017)
end
if exists(select * from sysModulo where sysm_id = 17003) begin
update sysModulo set sysm_objetoinicializacion= 'CSCompra.cInitCSCompra',sysm_objetoedicion= 'CSCompra.cFacturaCompra',sysm_id= 17003,sysm_orden= 17003,pre_id= 17005 where sysm_id = 17003
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSCompra.cInitCSCompra','CSCompra.cFacturaCompra',17003,17003,17005)
end
if exists(select * from sysModulo where sysm_id = 18001) begin
update sysModulo set sysm_objetoinicializacion= 'CSTesoreria.cInitCSTesoreria',sysm_objetoedicion= 'CSTesoreria.cCobranza',sysm_id= 18001,sysm_orden= 18001,pre_id= 18010 where sysm_id = 18001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSTesoreria.cInitCSTesoreria','CSTesoreria.cCobranza',18001,18001,18010)
end
if exists(select * from sysModulo where sysm_id = 18002) begin
update sysModulo set sysm_objetoinicializacion= 'CSTesoreria.cInitCSTesoreria',sysm_objetoedicion= 'CSTesoreria.cOrdenPago',sysm_id= 18002,sysm_orden= 18002,pre_id= 18017 where sysm_id = 18002
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSTesoreria.cInitCSTesoreria','CSTesoreria.cOrdenPago',18002,18002,18017)
end
if exists(select * from sysModulo where sysm_id = 18003) begin
update sysModulo set sysm_objetoinicializacion= 'CSTesoreria.cInitCSTesoreria',sysm_objetoedicion= 'CSTesoreria.cMovimientoFondo',sysm_id= 18003,sysm_orden= 18003,pre_id= 18023 where sysm_id = 18003
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSTesoreria.cInitCSTesoreria','CSTesoreria.cMovimientoFondo',18003,18003,18023)
end
if exists(select * from sysModulo where sysm_id = 18004) begin
update sysModulo set sysm_objetoinicializacion= 'CSTesoreria.cInitCSTesoreria',sysm_objetoedicion= 'CSTesoreria.cRendicion',sysm_id= 18004,sysm_orden= 18004,pre_id= 18029 where sysm_id = 18004
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSTesoreria.cInitCSTesoreria','CSTesoreria.cRendicion',18004,18004,18029)
end
if exists(select * from sysModulo where sysm_id = 19001) begin
update sysModulo set sysm_objetoinicializacion= 'CSContabilidad.cInitCSContabilidad',sysm_objetoedicion= 'CSContabilidad.cAsiento',sysm_id= 19001,sysm_orden= 19001,pre_id= 19004 where sysm_id = 19001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSContabilidad.cInitCSContabilidad','CSContabilidad.cAsiento',19001,19001,19004)
end
if exists(select * from sysModulo where sysm_id = 20004) begin
update sysModulo set sysm_objetoinicializacion= 'CSStock.cInitCSStock',sysm_objetoedicion= 'CSStock.cStock',sysm_id= 20004,sysm_orden= 20004,pre_id= 20004 where sysm_id = 20004
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSStock.cInitCSStock','CSStock.cStock',20004,20004,20004)
end
if exists(select * from sysModulo where sysm_id = 20005) begin
update sysModulo set sysm_objetoinicializacion= 'CSStock.cInitCSStock',sysm_objetoedicion= 'CSStock.cRecuentoStock',sysm_id= 20005,sysm_orden= 20005,pre_id= 20010 where sysm_id = 20005
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSStock.cInitCSStock','CSStock.cRecuentoStock',20005,20005,20010)
end
if exists(select * from sysModulo where sysm_id = 21001) begin
update sysModulo set sysm_objetoinicializacion= 'CSImplementacion.cInitCSImplementacion',sysm_objetoedicion= 'CSImplementacion.cImportacion',sysm_id= 21001,sysm_orden= 21001,pre_id= 21004 where sysm_id = 21001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSImplementacion.cInitCSImplementacion','CSImplementacion.cImportacion',21001,21001,21004)
end
GO
if exists(select * from sysModulo where sysm_id = 22001) begin
update sysModulo set sysm_objetoinicializacion= 'CSExport.cInitCSExport',sysm_objetoedicion= 'CSExport.cAduana',sysm_id= 22001,sysm_orden= 22001,pre_id= 22004 where sysm_id = 22001
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSExport.cInitCSExport','CSExport.cAduana',22001,22001,22004)
end
if exists(select * from sysModulo where sysm_id = 22002) begin
update sysModulo set sysm_objetoinicializacion= 'CSExport.cInitCSExport',sysm_objetoedicion= 'CSExport.cEmbarque',sysm_id= 22002,sysm_orden= 22002,pre_id= 22008 where sysm_id = 22002
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSExport.cInitCSExport','CSExport.cEmbarque',22002,22002,22008)
end
if exists(select * from sysModulo where sysm_id = 22003) begin
update sysModulo set sysm_objetoinicializacion= 'CSExport.cInitCSExport',sysm_objetoedicion= 'CSExport.cPermisoEmbarque',sysm_id= 22003,sysm_orden= 22003,pre_id= 22012 where sysm_id = 22003
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSExport.cInitCSExport','CSExport.cPermisoEmbarque',22003,22003,22012)
end
if exists(select * from sysModulo where sysm_id = 22004) begin
update sysModulo set sysm_objetoinicializacion= 'CSExport.cInitCSExport',sysm_objetoedicion= 'CSExport.cManifiestoCarga',sysm_id= 22004,sysm_orden= 22004,pre_id= 22018 where sysm_id = 22004
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSExport.cInitCSExport','CSExport.cManifiestoCarga',22004,22004,22018)
end
if exists(select * from sysModulo where sysm_id = 22005) begin
update sysModulo set sysm_objetoinicializacion= 'CSExport.cInitCSExport',sysm_objetoedicion= 'CSExport.cPackingList',sysm_id= 22005,sysm_orden= 22005,pre_id= 22023 where sysm_id = 22005
end else begin 
INSERT INTO sysModulo (sysm_objetoinicializacion,sysm_objetoedicion,sysm_id,sysm_orden,pre_id)VALUES ('CSExport.cInitCSExport','CSExport.cPackingList',22005,22005,22023)
end

