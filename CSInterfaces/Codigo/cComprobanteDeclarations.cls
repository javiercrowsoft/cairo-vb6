VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDeclarations"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDeclarations
' 00-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDeclarations"

Public Enum csTypeDocumento
  csTypeDocFacturaVenta = 1
  csTypeDocFacturaCompra = 2
  csTypeDocRemitoVenta = 3
  csTypeDocRemitoCompra = 4
  csTypeDocPedidoVenta = 5
  csTypeDocPedidoCompra = 6
  csTypeDocNotaCreditoVenta = 7
  csTypeDocNotaCreditoCompra = 8
  csTypeDocNotaDebitoVenta = 9
  csTypeDocNotaDebitoCompra = 10
  csTypeDocPresupuestoVenta = 11
  csTypeDocPresupuestoCompra = 12
  csTypeDocCobranza = 13
  csTypeDocTransferenciaStock = 14
  csTypeDocAsientoContable = 15
  csTypeDocOrdenDePago = 16
  csTypeDocDepositoBanco = 17
  csTypeDocPresupuestoEnvio = 18
  csTypeDocPermisoEmbarque = 19
  csTypeDocManifiestoCarga = 20
  csTypeDocPackingList = 21
  csTypeDocDevolucionPedidoVta = 22
  csTypeDocDevolucionPedidoCpra = 23
  csTypeDocDevolucionRemitoVta = 24
  csTypeDocDevolucionRemitoCpra = 25
End Enum

Public Enum csTypeImpuesto
  csTypeImpuestoIva = 1
  csTypeImpuestoIgrBrutos = 2
End Enum
' estructuras
' variables privadas
' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


