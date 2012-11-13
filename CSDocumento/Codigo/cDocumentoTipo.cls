VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDocumentoTipo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDocumentoTipo
' 01-12-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDocumentoTipo"

' OJO: Este enum esta repetido en sp_DocSetImpreso
'      y se usa para marcar que el comprobante fue impreso
'      si agregan un nuevo documentotipo acuerdense de darlo
'      de alta en el case sp_DocSetImpreso
'
Public Enum csEDocumentoTipo
  csEDT_FacturaVenta = 1
  csEDT_FacturaCompra = 2
  csEDT_RemitoVenta = 3
  csEDT_RemitoCompra = 4
  csEDT_PedidoVenta = 5
  csEDT_PedidoCompra = 6
  csEDT_NotaCreditoVenta = 7
  csEDT_NotaCreditoCompra = 8
  csEDT_NotaDebitoVenta = 9
  csEDT_NotaDebitoCompra = 10
  csEDT_PresupuestoVenta = 11
  csEDT_PresupuestoCompra = 12
  csEDT_Cobranza = 13
  csEDT_TrasferenciaStock = 14
  csEDT_AsientoContable = 15
  csEDT_OrdenPago = 16
  csEDT_DepositoBanco = 17
  csEDT_PresupuestoEnvio = 18
  csEDT_PermisoEmbarque = 19
  csEDT_ManifiestoCarga = 20
  csEDT_PackingList = 21
  csEDT_DevolucionPedidoVta = 22
  csEDT_DevolucionPedidoCpra = 23
  csEDT_DevolucionRemitoVta = 24
  csEDT_DevolucionRemitoCpra = 25
  csEDT_MovimientoFondo = 26
  csEDT_Rendicion = 27            ' Hay que borrarlo cuando rompamos la compatibilidad binaria
  csEDT_RecuentoStock = 28
  csEDT_ImportacionTemp = 29
  csEDT_ParteProdKit = 30
  csEDT_PackingListDevolucion = 31
  csEDT_DepositoCupon = 32
  csEDT_ResolucionCupon = 33
  csEDT_ParteDesarmeKit = 34
  csEDT_OrdenCompra = 35
  csEDT_DevolucionOrdenCpra = 36
  csEDT_CotizacionCompra = 37
  csEDT_DevolucionCotizacionCpra = 38
  csEDT_DevolucionPresuVta = 39
  csEDT_DevolucionPresuCpra = 40
  csEDT_DevolucionManifiesto = 41
  csEDT_OrdenServicio = 42
  csEDT_ParteReparacion = 43
  csEDT_StockProveedor = 44
  csEDT_StockCliente = 45
  csEDT_OrdenProdKit = 46
  csEDT_Liquidacion = 47

  ' OJO: Este enum esta repetido en sp_DocSetImpreso
  '      y se usa para marcar que el comprobante fue impreso
  '      si agregan un nuevo documentotipo acuerdense de darlo
  '      de alta en el case sp_DocSetImpreso
  '

End Enum


' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

