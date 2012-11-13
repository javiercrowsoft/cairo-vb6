VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCuentaCategoria"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCuentaCategoria
' 18-02-01
'--------------------------------------------------------------------------------
' notas:
'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
'--------------------------------------------------------------------------------

' constantes

' Grupos de Categorias de cuentas
' estructuras
Public Enum csECuentaCategoriaTipo
    csETCuecPatrimonial = 1
    csETCuecResultado = 2
    csETCuecOtro = 3
    csETCuecLibroIva = 4
End Enum
Public Enum csECuentaCategoria
    csECuecDocEnCartera = 1
    csECuecBancos = 2
    csECuecPatrimoniales = 3
    csECuecDeudPorVentas = 4
    csECuecBienesDeUso = 5
    csECuecBienesDeCambio = 6
    csECuecCuentasFiscales = 7
    csECuecAcreedores = 8
    csECuecIngresos = 9
    csECuecEgresos = 10
    csECuecCostoMercVend = 12
    csECuecOtros = 13
    csECuecCaja = 14
    csECuecIVABinesDeUso = 15
    csECuecIVALocaciones = 16
    csECuecIVAServicios = 17
    csECuecIVABienes = 18
    csECuecDepositoCupones = 19
End Enum
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion

