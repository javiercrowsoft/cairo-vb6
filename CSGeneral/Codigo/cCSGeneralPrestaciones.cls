VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCSGeneralPrestaciones"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cCSGeneralPrestaciones
' 27-01-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' enumeraciones
Public Enum csGeneralPrestacion
  csPreGNewDepositoLogico = 1016
  csPreGEditDepositoLogico = 1017
  csPreGDeleteDepositoLogico = 1018
  csPreGListDepositoLogico = 1019
  
  csPreGNewUnidad = 1020
  csPreGEditUnidad = 1021
  csPreGDeleteUnidad = 1022
  csPreGListUnidad = 1023
  
  csPreGNewSucursalCliente = 1024
  csPreGEditSucursalCliente = 1025
  csPreGDeleteSucursalCliente = 1026
  csPreGListSucursalCliente = 1027
  
  csPreGNewBanco = 1032
  csPreGEditBanco = 1033
  csPreGDeleteBanco = 1034
  csPreGListBanco = 1035
  
  csPreGNewVendedores = 1036
  csPreGEditVendedores = 1037
  csPreGDeleteVendedores = 1038
  csPreGListVendedores = 1039
  
  csPreGNewTarjetaCredito = 1040
  csPreGEditTarjetaCredito = 1041
  csPreGDeleteTarjetaCredito = 1042
  csPreGListTarjetaCredito = 1043
  
  csPreGNewCuenta = 1044
  csPreGEditCuenta = 1045
  csPreGDeleteCuenta = 1046
  csPreGListCuenta = 1047
  
  csPreGNewLeyenda = 1048
  csPreGEditLeyenda = 1049
  csPreGDeleteLeyenda = 1050
  csPreGListLeyenda = 1051
  
  csPreGNewCentroCosto = 1052
  csPreGEditCentroCosto = 1053
  csPreGDeleteCentroCosto = 1054
  csPreGListCentroCosto = 1055
  
  csPreGNewCobrador = 1056
  csPreGEditCobrador = 1057
  csPreGDeleteCobrador = 1058
  csPreGListCobrador = 1059
  
  csPreGNewReglaLiquidacion = 1060
  csPreGEditReglaLiquidacion = 1061
  csPreGDeleteReglaLiquidacion = 1062
  csPreGListReglaLiquidacion = 1063
  
  csPreGNewClearing = 1064
  csPreGEditClearing = 1065
  csPreGDeleteClearing = 1066
  csPreGListClearing = 1067
  
  csPreGNewCliente = 1068
  csPreGEditCliente = 1069
  csPreGDeleteCliente = 1070
  csPreGListCliente = 1071
  
  csPreGNewProveedor = 1072
  csPreGEditProveedor = 1073
  csPreGDeleteProveedor = 1074
  csPreGListProveedor = 1075
  
  csPreGNewProducto = 1076
  csPreGEditProducto = 1077
  csPreGDeleteProducto = 1078
  csPreGListProducto = 1079
  
  csPreGNewRubro = 1080
  csPreGEditRubro = 1081
  csPreGDeleteRubro = 1082
  csPreGListRubro = 1083
  
  csPreGNewEscala = 1084
  csPreGEditEscala = 1085
  csPreGDeleteEscala = 1086
  csPreGListEscala = 1087
  
  csPreGNewTransporte = 1088
  csPreGEditTransporte = 1089
  csPreGDeleteTransporte = 1090
  csPreGListTransporte = 1091
    
  csPreGNewPais = 1104
  csPreGEditPais = 1105
  csPreGDeletePais = 1106
  csPreGListPais = 1107
  
  csPreGNewCiudad = 1108
  csPreGEditCiudad = 1109
  csPreGDeleteCiudad = 1110
  csPreGListCiudad = 1111

  csPreGNewProvincia = 1112
  csPreGEditProvincia = 1113
  csPreGDeleteProvincia = 1114
  csPreGListProvincia = 1115
  
  csPreGNewZona = 1116
  csPreGEditZona = 1117
  csPreGDeleteZona = 1118
  csPreGListZona = 1119

  csPreGNewTasaImpositiva = 1120
  csPreGEditTasaImpositiva = 1121
  csPreGDeleteTasaImpositiva = 1122
  csPreGListTasaImpositiva = 1123
  
  csPreGNewDepositoFisico = 1124
  csPreGEditDepositoFisico = 1125
  csPreGDeleteDepositoFisico = 1126
  csPreGListDepositoFisico = 1127
  
  csPreGNewCalidad = 1132
  csPreGEditCalidad = 1133
  csPreGDeleteCalidad = 1134
  csPreGListCalidad = 1135

  csPreGNewMarca = 1136
  csPreGEditMarca = 1137
  csPreGDeleteMarca = 1138
  csPreGListMarca = 1139

  csPreGNewCamion = 1140
  csPreGEditCamion = 1141
  csPreGDeleteCamion = 1142
  csPreGListCamion = 1143

  csPreGNewChofer = 1144
  csPreGEditChofer = 1145
  csPreGDeleteChofer = 1146
  csPreGListChofer = 1147

  csPreGNewCondicionPago = 1148
  csPreGEditCondicionPago = 1149
  csPreGDeleteCondicionPago = 1150
  csPreGListCondicionPago = 1151
  
  csPreGNewSucursal = 1157
  csPreGEditSucursal = 1158
  csPreGDeleteSucursal = 1159
  csPreGListSucursal = 1160
  
  csPreGNewRubroTabla = 1161
  csPreGEditRubroTabla = 1162
  csPreGDeleteRubroTabla = 1163
  csPreGListRubroTabla = 1164

  csPreGNewGasto = 1165
  csPreGEditGasto = 1166
  csPreGDeleteGasto = 1167
  csPreGListGasto = 1168

  csPreGNewCuentaGrupo = 1169
  csPreGEditCuentaGrupo = 1170
  csPreGDeleteCuentaGrupo = 1171
  csPreGListCuentaGrupo = 1172
  
  csPreGNewPercepcion = 1176
  csPreGDeletePercepcion = 1178
  csPreGEditPercepcion = 1179
  csPreGListPercepcion = 1180

  csPreGNewPercepcionTipo = 1181
  csPreGDeletePercepcionTipo = 1182
  csPreGEditPercepcionTipo = 1183
  csPreGListPercepcionTipo = 1184

  csPreGNewRetencion = 1185
  csPreGDeleteRetencion = 1186
  csPreGEditRetencion = 1187
  csPreGListRetencion = 1188

  csPreGNewRetencionTipo = 1189
  csPreGDeleteRetencionTipo = 1190
  csPreGEditRetencionTipo = 1191
  csPreGListRetencionTipo = 1192

  csPreGNewDepartamento = 1193
  csPreGDeleteDepartamento = 1194
  csPreGEditDepartamento = 1195
  csPreGListDepartamento = 1196

  csPreGNewCircuitoContable = 1197
  csPreGEditCircuitoContable = 1198
  csPreGDeleteCircuitoContable = 1199
  csPreGListCircuitoContable = 1200

  csPreGNewEmpresa = 1201
  csPreGEditEmpresa = 1202
  csPreGDeleteEmpresa = 1203
  csPreGListEmpresa = 1204

  csPreGNewPersona = 1205
  csPreGEditPersona = 1206
  csPreGDeletePersona = 1207
  csPreGListPersona = 1208

  csPreGNewWebArticulo = 1209
  csPreGEditWebArticulo = 1210
  csPreGDeleteWebArticulo = 1211
  csPreGListWebArticulo = 1212
  
  csPreGNewIdioma = 1213
  csPreGEditIdioma = 1214
  csPreGDeleteIdioma = 1215
  csPreGListIdioma = 1216

  csPreGNewTipoOperacion = 1218
  csPreGEditTipoOperacion = 1219
  csPreGDeleteTipoOperacion = 1220
  csPreGListTipoOperacion = 1221

  csPreGNewEmbalaje = 1222
  csPreGEditEmbalaje = 1223
  csPreGDeleteEmbalaje = 1224
  csPreGListEmbalaje = 1225
  
  csPreGNewProductoFKit = 1226
  csPreGEditProductoFKit = 1227
  csPreGDeleteProductoFKit = 1228
  csPreGListProductoFKit = 1229
  
  csPreGIndiceCorpList = 1230
  
  csPreGNewFeriado = 1235
  csPreGEditFeriado = 1236
  csPreGDeleteFeriado = 1237
  csPreGListFeriado = 1238
  
  csPreGNewCaja = 1239
  csPreGEditCaja = 1240
  csPreGDeleteCaja = 1241
  csPreGListCaja = 1242
  
  csPreGNewListaPrecioMarcado = 1243
  csPreGEditListaPrecioMarcado = 1244
  csPreGDeleteListaPrecioMarcado = 1245
  csPreGListListaPrecioMarcado = 1246

  csPreGNewCatalogoWeb = 1247
  csPreGEditCatalogoWeb = 1248
  csPreGDeleteCatalogoWeb = 1249
  csPreGListCatalogoWeb = 1250

  csPreGNewAjusteInflacion = 1251
  csPreGEditAjusteInflacion = 1252
  csPreGDeleteAjusteInflacion = 1253
  csPreGListAjusteInflacion = 1254

  csPreGEditAjusteInflacionIndice = 1255

  csPreGNewProductoHelpConfig = 1256
  csPreGEditProductoHelpConfig = 1257
  csPreGDeleteProductoHelpConfig = 1258
  csPreGListProductoHelpConfig = 1259

  csPreGNewCalle = 1260
  csPreGEditCalle = 1261
  csPreGDeleteCalle = 1262
  csPreGListCalle = 1263
  
  csPreGNewCatalogoWebCategoria = 1264
  csPreGEditCatalogoWebCategoria = 1265
  csPreGDeleteCatalogoWebCategoria = 1266
  csPreGListCatalogoWebCategoria = 1267

  csPreGNewClienteContactoTipo = 1268
  csPreGEditClienteContactoTipo = 1269
  csPreGDeleteClienteContactoTipo = 1270
  csPreGListClienteContactoTipo = 1271

  csPreGNewPersonaDocumentoTipo = 1272
  csPreGEditPersonaDocumentoTipo = 1273
  csPreGDeletePersonaDocumentoTipo = 1274
  csPreGListPersonaDocumentoTipo = 1275
  
  csPreGNewPosicionArancel = 1276
  csPreGEditPosicionArancel = 1277
  csPreGDeletePosicionArancel = 1278
  csPreGListPosicionArancel = 1279

  csPreGNewTarifario = 1280
  csPreGEditTarifario = 1281
  csPreGDeleteTarifario = 1282
  csPreGListTarifario = 1283
  
  csPreGNewFormaPago = 1284
  csPreGEditFormaPago = 1285
  csPreGDeleteFormaPago = 1286
  csPreGListFormaPago = 1287

  csPreGNewVentaModo = 1288
  csPreGEditVentaModo = 1289
  csPreGDeleteVentaModo = 1290
  csPreGListVentaModo = 1291

End Enum

' variables privadas
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub Init()
  
  SecurityAdd csPreGNewProvincia, "Agregar Provincias", "General"
  SecurityAdd csPreGDeleteProvincia, "Borrar Provincias", "General"
  SecurityAdd csPreGEditProvincia, "Editar Provincias", "General"
  SecurityAdd csPreGListProvincia, "Listar Provincias", "General"
  
  SecurityAdd csPreGNewZona, "Agregar Zonas", "General"
  SecurityAdd csPreGDeleteZona, "Borrar Zonas", "General"
  SecurityAdd csPreGEditZona, "Editar Zonas", "General"
  SecurityAdd csPreGListZona, "Listar Zonas", "General"
  
  SecurityAdd csPreGNewTasaImpositiva, "Agregar Tasas Impositivas", "General"
  SecurityAdd csPreGDeleteTasaImpositiva, "Borrar Tasas Impositivas", "General"
  SecurityAdd csPreGEditTasaImpositiva, "Editar Tasas Impositivas", "General"
  SecurityAdd csPreGListTasaImpositiva, "Listar Tasas Impositivas", "General"
  
  SecurityAdd csPreGNewDepositoFisico, "Agregar Depositos Fisicos", "General"
  SecurityAdd csPreGDeleteDepositoFisico, "Borrar Depositos Fisicos", "General"
  SecurityAdd csPreGEditDepositoFisico, "Editar Depositos Fisicos", "General"
  SecurityAdd csPreGListDepositoFisico, "Listar Depositos Fisicos", "General"
  
  SecurityAdd csPreGNewDepositoLogico, "Agregar Depositos Logicos", "General"
  SecurityAdd csPreGDeleteDepositoLogico, "Borrar Depositos Logicos", "General"
  SecurityAdd csPreGEditDepositoLogico, "Editar Depositos Logicos", "General"
  SecurityAdd csPreGListDepositoLogico, "Listar Depositos Logicos", "General"
  
  SecurityAdd csPreGNewUnidad, "Agregar Unidades", "General"
  SecurityAdd csPreGDeleteUnidad, "Borrar Unidades", "General"
  SecurityAdd csPreGEditUnidad, "Editar Unidades", "General"
  SecurityAdd csPreGListUnidad, "Listar Unidades", "General"
  
  SecurityAdd csPreGNewSucursalCliente, "Agregar Sucursal Cliente", "General"
  SecurityAdd csPreGDeleteSucursalCliente, "Borrar Sucursal Cliente", "General"
  SecurityAdd csPreGEditSucursalCliente, "Editar Sucursal Cliente", "General"
  SecurityAdd csPreGListSucursalCliente, "Listar Sucursal Cliente", "General"
  
  SecurityAdd csPreGNewBanco, "Agregar Bancos", "General"
  SecurityAdd csPreGDeleteBanco, "Borrar Bancos", "General"
  SecurityAdd csPreGEditBanco, "Editar Bancos", "General"
  SecurityAdd csPreGListBanco, "Listar Bancos", "General"
   
  SecurityAdd csPreGNewVendedores, "Agregar Vendedores", "General"
  SecurityAdd csPreGDeleteVendedores, "Borrar Vendedores", "General"
  SecurityAdd csPreGEditVendedores, "Editar Vendedores", "General"
  SecurityAdd csPreGListVendedores, "Listar Vendedores", "General"

  SecurityAdd csPreGNewTarjetaCredito, "Agregar Tarjeta de Credito", "General"
  SecurityAdd csPreGDeleteTarjetaCredito, "Borrar Tarjeta de Credito", "General"
  SecurityAdd csPreGEditTarjetaCredito, "Editar Tarjeta de Credito", "General"
  SecurityAdd csPreGListTarjetaCredito, "Listar Tarjeta de Credito", "General"
  
  SecurityAdd csPreGNewCuenta, "Agregar Cuenta", "General"
  SecurityAdd csPreGDeleteCuenta, "Borrar Cuenta", "General"
  SecurityAdd csPreGEditCuenta, "Editar Cuenta", "General"
  SecurityAdd csPreGListCuenta, "Listar Cuenta", "General"
  
  SecurityAdd csPreGNewLeyenda, "Agregar Leyenda", "General"
  SecurityAdd csPreGDeleteLeyenda, "Borrar Leyenda", "General"
  SecurityAdd csPreGEditLeyenda, "Editar Leyenda", "General"
  SecurityAdd csPreGListLeyenda, "Listar Leyenda", "General"
  
  SecurityAdd csPreGNewCentroCosto, "Agregar Centro de Costo", "General"
  SecurityAdd csPreGDeleteCentroCosto, "Borrar Centro de Costo", "General"
  SecurityAdd csPreGEditCentroCosto, "Editar Centro de Costo", "General"
  SecurityAdd csPreGListCentroCosto, "Listar Centro de Costo", "General"
  
  SecurityAdd csPreGNewCobrador, "Agregar Cobrador", "General"
  SecurityAdd csPreGDeleteCobrador, "Borrar Cobrador", "General"
  SecurityAdd csPreGEditCobrador, "Editar Cobrador", "General"
  SecurityAdd csPreGListCobrador, "Listar Cobrador", "General"
  
  SecurityAdd csPreGNewReglaLiquidacion, "Agregar ReglaLiquidacion", "General"
  SecurityAdd csPreGDeleteReglaLiquidacion, "Borrar ReglaLiquidacion", "General"
  SecurityAdd csPreGEditReglaLiquidacion, "Editar ReglaLiquidacion", "General"
  SecurityAdd csPreGListReglaLiquidacion, "Listar ReglaLiquidacion", "General"
  
  SecurityAdd csPreGNewClearing, "Agregar Clearing", "General"
  SecurityAdd csPreGDeleteClearing, "Borrar Clearing", "General"
  SecurityAdd csPreGEditClearing, "Editar Clearing", "General"
  SecurityAdd csPreGListClearing, "Listar Clearing", "General"
  
  SecurityAdd csPreGNewCliente, "Agregar Cliente", "General"
  SecurityAdd csPreGDeleteCliente, "Borrar Cliente", "General"
  SecurityAdd csPreGEditCliente, "Editar Cliente", "General"
  SecurityAdd csPreGListCliente, "Listar Cliente", "General"
  
  SecurityAdd csPreGNewProveedor, "Agregar Proveedor", "General"
  SecurityAdd csPreGDeleteProveedor, "Borrar Proveedor", "General"
  SecurityAdd csPreGEditProveedor, "Editar Proveedor", "General"
  SecurityAdd csPreGListProveedor, "Listar Proveedor", "General"
  
  SecurityAdd csPreGNewProducto, "Agregar Producto", "General"
  SecurityAdd csPreGDeleteProducto, "Borrar Producto", "General"
  SecurityAdd csPreGEditProducto, "Editar Producto", "General"
  SecurityAdd csPreGListProducto, "Listar Producto", "General"
  
  SecurityAdd csPreGNewRubro, "Agregar Rubro", "General"
  SecurityAdd csPreGDeleteRubro, "Borrar Rubro", "General"
  SecurityAdd csPreGEditRubro, "Editar Rubro", "General"
  SecurityAdd csPreGListRubro, "Listar Rubro", "General"
  
  SecurityAdd csPreGNewEscala, "Agregar Escala", "General"
  SecurityAdd csPreGDeleteEscala, "Borrar Escala", "General"
  SecurityAdd csPreGEditEscala, "Editar Escala", "General"
  SecurityAdd csPreGListEscala, "Listar Escala", "General"

  SecurityAdd csPreGNewTransporte, "Agregar Transporte", "General"
  SecurityAdd csPreGDeleteTransporte, "Borrar Transporte", "General"
  SecurityAdd csPreGEditTransporte, "Editar Transporte", "General"
  SecurityAdd csPreGListTransporte, "Listar Transporte", "General"

  SecurityAdd csPreGNewPais, "Agregar Pais", "País"
  SecurityAdd csPreGDeletePais, "Borrar Pais", "País"
  SecurityAdd csPreGEditPais, "Editar Pais", "País"
  SecurityAdd csPreGListPais, "Listar Pais", "País"
  
  SecurityAdd csPreGNewCiudad, "Agregar Ciudad", "Ciudad"
  SecurityAdd csPreGDeleteCiudad, "Borrar Ciudad", "Ciudad"
  SecurityAdd csPreGEditCiudad, "Editar Ciudad", "Ciudad"
  SecurityAdd csPreGListCiudad, "Listar Ciudad", "Ciudad"

  SecurityAdd csPreGNewCalidad, "Agregar Calidad", "Calidad"
  SecurityAdd csPreGDeleteCalidad, "Borrar Calidad", "Calidad"
  SecurityAdd csPreGEditCalidad, "Editar Calidad", "Calidad"
  SecurityAdd csPreGListCalidad, "Listar Calidad", "Calidad"

  SecurityAdd csPreGNewMarca, "Agregar Marca", "Marca"
  SecurityAdd csPreGDeleteMarca, "Borrar Marca", "Marca"
  SecurityAdd csPreGEditMarca, "Editar Marca", "Marca"
  SecurityAdd csPreGListMarca, "Listar Marca", "Marca"

  SecurityAdd csPreGNewCamion, "Agregar Camion", "Camion"
  SecurityAdd csPreGDeleteCamion, "Borrar Camion", "Camion"
  SecurityAdd csPreGEditCamion, "Editar Camion", "Camion"
  SecurityAdd csPreGListCamion, "Listar Camion", "Camion"

  SecurityAdd csPreGNewChofer, "Agregar Chofer", "Chofer"
  SecurityAdd csPreGDeleteChofer, "Borrar Chofer", "Chofer"
  SecurityAdd csPreGEditChofer, "Editar Chofer", "Chofer"
  SecurityAdd csPreGListChofer, "Listar Chofer", "Chofer"

  SecurityAdd csPreGNewCondicionPago, "Agregar Condición Pago", "Condición Pago"
  SecurityAdd csPreGDeleteCondicionPago, "Borrar Condición Pago", "Condición Pago"
  SecurityAdd csPreGEditCondicionPago, "Editar Condición Pago", "Condición Pago"
  SecurityAdd csPreGListCondicionPago, "Listar Condición Pago", "Condición Pago"
  
  SecurityAdd csPreGNewSucursal, "Agregar Sucursal", "Sucursal"
  SecurityAdd csPreGDeleteSucursal, "Borrar Sucursal", "Sucursal"
  SecurityAdd csPreGEditSucursal, "Editar Sucursal", "Sucursal"
  SecurityAdd csPreGListSucursal, "Listar Sucursal", "Sucursal"
  
  SecurityAdd csPreGNewRubroTabla, "Agregar RubroTabla", "RubroTabla"
  SecurityAdd csPreGDeleteRubroTabla, "Borrar RubroTabla", "RubroTabla"
  SecurityAdd csPreGEditRubroTabla, "Editar RubroTabla", "RubroTabla"
  SecurityAdd csPreGListRubroTabla, "Listar RubroTabla", "RubroTabla"

  SecurityAdd csPreGNewGasto, "Agregar Gasto", "Gasto"
  SecurityAdd csPreGDeleteGasto, "Borrar Gasto", "Gasto"
  SecurityAdd csPreGEditGasto, "Editar Gasto", "Gasto"
  SecurityAdd csPreGListGasto, "Listar Gasto", "Gasto"

  SecurityAdd csPreGNewCuentaGrupo, "Agregar Grupos Cuenta", "General"
  SecurityAdd csPreGDeleteCuentaGrupo, "Borrar Grupos Cuenta", "General"
  SecurityAdd csPreGEditCuentaGrupo, "Editar Grupos Cuenta", "General"
  SecurityAdd csPreGListCuentaGrupo, "Listar Grupos Cuenta", "General"
  
  SecurityAdd csPreGNewPercepcion, "Agregar Percepcion", "General"
  SecurityAdd csPreGDeletePercepcion, "Borrar Percepcion", "General"
  SecurityAdd csPreGEditPercepcion, "Editar Percepcion", "General"
  SecurityAdd csPreGListPercepcion, "Listar Percepcion", "General"

  SecurityAdd csPreGNewPercepcionTipo, "Agregar Percepcion Tipo", "General"
  SecurityAdd csPreGDeletePercepcionTipo, "Borrar Percepcion Tipo", "General"
  SecurityAdd csPreGEditPercepcionTipo, "Editar Percepcion Tipo", "General"
  SecurityAdd csPreGListPercepcionTipo, "Listar Percepcion Tipo", "General"

  SecurityAdd csPreGNewRetencion, "Agregar Retencion", "General"
  SecurityAdd csPreGDeleteRetencion, "Borrar Retencion", "General"
  SecurityAdd csPreGEditRetencion, "Editar Retencion", "General"
  SecurityAdd csPreGListRetencion, "Listar Retencion", "General"

  SecurityAdd csPreGNewRetencionTipo, "Agregar Retencion Tipo", "General"
  SecurityAdd csPreGDeleteRetencionTipo, "Borrar Retencion Tipo", "General"
  SecurityAdd csPreGEditRetencionTipo, "Editar Retencion Tipo", "General"
  SecurityAdd csPreGListRetencionTipo, "Listar Retencion Tipo", "General"

  SecurityAdd csPreGNewDepartamento, "Agregar Departamento", "General"
  SecurityAdd csPreGDeleteDepartamento, "Borrar Departamento", "General"
  SecurityAdd csPreGEditDepartamento, "Editar Departamento", "General"
  SecurityAdd csPreGListDepartamento, "Listar Departamento", "General"

  SecurityAdd csPreGNewCircuitoContable, "Agregar Circuito Contable", "General"
  SecurityAdd csPreGDeleteCircuitoContable, "Borrar Circuito Contable", "General"
  SecurityAdd csPreGEditCircuitoContable, "Editar Circuito Contable", "General"
  SecurityAdd csPreGListCircuitoContable, "Listar Circuito Contable", "General"

  SecurityAdd csPreGNewEmpresa, "Agregar Empresa", "General"
  SecurityAdd csPreGDeleteEmpresa, "Borrar Empresa", "General"
  SecurityAdd csPreGEditEmpresa, "Editar Empresa", "General"
  SecurityAdd csPreGListEmpresa, "Listar Empresa", "General"

  SecurityAdd csPreGNewPersona, "Agregar Persona", "General"
  SecurityAdd csPreGDeletePersona, "Borrar Persona", "General"
  SecurityAdd csPreGEditPersona, "Editar Persona", "General"
  SecurityAdd csPreGListPersona, "Listar Persona", "General"

  SecurityAdd csPreGNewWebArticulo, "Agregar WebArticulo", "General"
  SecurityAdd csPreGDeleteWebArticulo, "Borrar WebArticulo", "General"
  SecurityAdd csPreGEditWebArticulo, "Editar WebArticulo", "General"
  SecurityAdd csPreGListWebArticulo, "Listar WebArticulo", "General"

  SecurityAdd csPreGNewIdioma, "Agregar Idioma", "General"
  SecurityAdd csPreGDeleteIdioma, "Borrar Idioma", "General"
  SecurityAdd csPreGEditIdioma, "Editar Idioma", "General"
  SecurityAdd csPreGListIdioma, "Listar Idioma", "General"

  SecurityAdd csPreGNewTipoOperacion, "Agregar Tipo de Operacion", "General"
  SecurityAdd csPreGDeleteTipoOperacion, "Borrar Tipo de Operacion", "General"
  SecurityAdd csPreGEditTipoOperacion, "Editar Tipo de Operacion", "General"
  SecurityAdd csPreGListTipoOperacion, "Listar Tipo de Operacion", "General"

  SecurityAdd csPreGNewEmbalaje, "Agregar Embalaje", "General"
  SecurityAdd csPreGDeleteEmbalaje, "Borrar Embalaje", "General"
  SecurityAdd csPreGEditEmbalaje, "Editar Embalaje", "General"
  SecurityAdd csPreGListEmbalaje, "Listar Embalaje", "General"

  SecurityAdd csPreGNewProductoFKit, "Agregar Formula de Producción de Kit", "General"
  SecurityAdd csPreGDeleteProductoFKit, "Borrar Formula de Producción de Kit", "General"
  SecurityAdd csPreGEditProductoFKit, "Editar Formula de Producción de Kit", "General"
  SecurityAdd csPreGListProductoFKit, "Listar Formula de Producción de Kit", "General"
  
  SecurityAdd csPreGIndiceCorpList, "Consultar el Indice Corporativo", "General"

  SecurityAdd csPreGNewFeriado, "Agregar Feriado", "General"
  SecurityAdd csPreGDeleteFeriado, "Borrar Feriado", "General"
  SecurityAdd csPreGEditFeriado, "Editar Feriado", "General"
  SecurityAdd csPreGListFeriado, "Listar Feriado", "General"
  
  SecurityAdd csPreGNewCaja, "Agregar Caja", "General"
  SecurityAdd csPreGDeleteCaja, "Borrar Caja", "General"
  SecurityAdd csPreGEditCaja, "Editar Caja", "General"
  SecurityAdd csPreGListCaja, "Listar Caja", "General"

  SecurityAdd csPreGNewListaPrecioMarcado, "Agregar Tabla de Marcado de Precios", "General"
  SecurityAdd csPreGDeleteListaPrecioMarcado, "Borrar Tabla de Marcado de Precios", "General"
  SecurityAdd csPreGEditListaPrecioMarcado, "Editar Tabla de Marcado de Precios", "General"
  SecurityAdd csPreGListListaPrecioMarcado, "Listar Tabla de Marcado de Precios", "General"

  SecurityAdd csPreGNewCatalogoWeb, "Agregar Catalogo Web", "General"
  SecurityAdd csPreGDeleteCatalogoWeb, "Borrar Catalogo Web", "General"
  SecurityAdd csPreGEditCatalogoWeb, "Editar Catalogo Web", "General"
  SecurityAdd csPreGListCatalogoWeb, "Listar Catalogo Web", "General"

  SecurityAdd csPreGNewAjusteInflacion, "Agregar Esquema de Ajuste por Inflación", "General"
  SecurityAdd csPreGDeleteAjusteInflacion, "Borrar Esquema de Ajuste por Inflación", "General"
  SecurityAdd csPreGEditAjusteInflacion, "Editar Esquema de Ajuste por Inflación", "General"
  SecurityAdd csPreGListAjusteInflacion, "Listar Esquema de Ajuste por Inflación", "General"
  
  SecurityAdd csPreGEditAjusteInflacionIndice, "Editar Indices de Ajuste por Inflación", "General"
  
  SecurityAdd csPreGNewProductoHelpConfig, "Agregar Configuracion del Help de Articulos", "General"
  SecurityAdd csPreGEditProductoHelpConfig, "Editar Configuracion del Help de Articulos", "General"
  SecurityAdd csPreGDeleteProductoHelpConfig, "Borrar Configuracion del Help de Articulos", "General"
  SecurityAdd csPreGListProductoHelpConfig, "Listar Configuracion del Help de Articulos", "General"

  SecurityAdd csPreGNewCalle, "Agregar Calles", "General"
  SecurityAdd csPreGEditCalle, "Editar Calles", "General"
  SecurityAdd csPreGDeleteCalle, "Borrar Calles", "General"
  SecurityAdd csPreGListCalle, "Listar Calles", "General"
  
  SecurityAdd csPreGNewCatalogoWebCategoria, "Agregar Categoria de Catalogo Web", "General"
  SecurityAdd csPreGEditCatalogoWebCategoria, "Editar Categoria de Catalogo Web", "General"
  SecurityAdd csPreGDeleteCatalogoWebCategoria, "Borrar Categoria de Catalogo Web", "General"
  SecurityAdd csPreGListCatalogoWebCategoria, "Listar Categoria de Catalogo Web", "General"

  SecurityAdd csPreGNewClienteContactoTipo, "Agregar Tipo de Contacto", "General"
  SecurityAdd csPreGEditClienteContactoTipo, "Editar Tipo de Contacto", "General"
  SecurityAdd csPreGDeleteClienteContactoTipo, "Borrar Tipo de Contacto", "General"
  SecurityAdd csPreGListClienteContactoTipo, "Listar Tipo de Contacto", "General"

  SecurityAdd csPreGNewPersonaDocumentoTipo, "Agregar Tipo de Documento", "General"
  SecurityAdd csPreGEditPersonaDocumentoTipo, "Editar Tipo de Documento", "General"
  SecurityAdd csPreGDeletePersonaDocumentoTipo, "Borrar Tipo de Documento", "General"
  SecurityAdd csPreGListPersonaDocumentoTipo, "Listar Tipo de Documento", "General"

  SecurityAdd csPreGNewPosicionArancel, "Agregar Posicion Arancelaria", "General"
  SecurityAdd csPreGEditPosicionArancel, "Editar Posicion Arancelaria", "General"
  SecurityAdd csPreGDeletePosicionArancel, "Borrar Posicion Arancelaria", "General"
  SecurityAdd csPreGListPosicionArancel, "Listar Posicion Arancelaria", "General"

  SecurityAdd csPreGNewTarifario, "Agregar Tarifario", "General"
  SecurityAdd csPreGEditTarifario, "Editar Tarifario", "General"
  SecurityAdd csPreGDeleteTarifario, "Borrar Tarifario", "General"
  SecurityAdd csPreGListTarifario, "Listar Tarifario", "General"

  SecurityAdd csPreGNewFormaPago, "Agregar Forma de Pago", "General"
  SecurityAdd csPreGEditFormaPago, "Editar Forma de Pago", "General"
  SecurityAdd csPreGDeleteFormaPago, "Borrar Forma de Pago", "General"
  SecurityAdd csPreGListFormaPago, "Listar Forma de Pago", "General"

  SecurityAdd csPreGNewVentaModo, "Agregar Modo de Venta", "General"
  SecurityAdd csPreGEditVentaModo, "Editar Modo de Venta", "General"
  SecurityAdd csPreGDeleteVentaModo, "Borrar Modo de Venta", "General"
  SecurityAdd csPreGListVentaModo, "Listar Modo de Venta", "General"

End Sub

' funciones privadas
' construccion - destruccion
