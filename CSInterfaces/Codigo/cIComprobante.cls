VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIComprobante"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cIComprobante
' 07-05-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cIComprobante"
' estructuras
' variables privadas
Private m_ID                            As Long
Private m_TipoDocumento                 As csTypeDocumento
Private m_Documento                     As Long
Private m_Total                         As Double
Private m_Items                         As cIComprobanteItems
Private m_Fecha                         As Date
Private m_Numero                        As Long
Private m_NroComprobante                As String
Private m_Direccion                     As String
Private m_Impuestos                     As cIComprobanteImpuestos
Private m_Neto                          As Double
Private m_FechaVto                      As Date
Private m_Cliente                       As Long
Private m_Proveedor                     As Long
Private m_DepositoOrigen                As Long
Private m_DepositoDestino               As Long

' eventos
' propiedadades publicas
Public Property Get ID() As Long
   ID = m_ID
End Property

Public Property Let ID(ByVal rhs As Long)
   m_ID = rhs
End Property

Public Property Get TipoDocumento() As csTypeDocumento
   TipoDocumento = m_TipoDocumento
End Property

Public Property Let TipoDocumento(ByVal rhs As csTypeDocumento)
   m_TipoDocumento = rhs
End Property

Public Property Get Documento() As Long
   Documento = m_Documento
End Property

Public Property Let Documento(ByVal rhs As Long)
   m_Documento = rhs
End Property

Public Property Get Total() As Double
   Total = m_Total
End Property

Public Property Let Total(ByVal rhs As Double)
   m_Total = rhs
End Property

Public Property Get Items() As cIComprobanteItems
   Set Items = m_Items
End Property

Public Property Set Items(ByVal rhs As cIComprobanteItems)
   Set m_Items = rhs
End Property

Public Property Get Fecha() As Date
   Fecha = m_Fecha
End Property

Public Property Let Fecha(ByVal rhs As Date)
   m_Fecha = rhs
End Property

Public Property Get Numero() As Long
   Numero = m_Numero
End Property

Public Property Let Numero(ByVal rhs As Long)
   m_Numero = rhs
End Property

Public Property Get NroComprobante() As String
   NroComprobante = m_NroComprobante
End Property

Public Property Let NroComprobante(ByVal rhs As String)
   m_NroComprobante = rhs
End Property

Public Property Get Direccion() As String
   Direccion = m_Direccion
End Property

Public Property Let Direccion(ByVal rhs As String)
   m_Direccion = rhs
End Property

Public Property Get Impuestos() As cIComprobanteImpuestos
   Set Impuestos = m_Impuestos
End Property

Public Property Set Impuestos(ByVal rhs As cIComprobanteImpuestos)
   Set m_Impuestos = rhs
End Property

Public Property Get Neto() As Double
   Neto = m_Neto
End Property

Public Property Let Neto(ByVal rhs As Double)
   m_Neto = rhs
End Property

Public Property Get FechaVto() As Date
   FechaVto = m_FechaVto
End Property

Public Property Let FechaVto(ByVal rhs As Date)
   m_FechaVto = rhs
End Property

Public Property Get Cliente() As Long
   Cliente = m_Cliente
End Property

Public Property Let Cliente(ByVal rhs As Long)
   m_Cliente = rhs
End Property

Public Property Get Proveedor() As Long
   Proveedor = m_Proveedor
End Property

Public Property Let Proveedor(ByVal rhs As Long)
   m_Proveedor = rhs
End Property

Public Property Get DepositoOrigen() As Long
   DepositoOrigen = m_DepositoOrigen
End Property

Public Property Let DepositoOrigen(ByVal rhs As Long)
   m_DepositoOrigen = rhs
End Property

Public Property Get DepositoDestino() As Long
   DepositoDestino = m_DepositoDestino
End Property

Public Property Let DepositoDestino(ByVal rhs As Long)
   m_DepositoDestino = rhs
End Property

Public Property Get TotalImpuestos() As Double
  Dim Impuesto As cIComprobanteImpuesto
  Dim rtn      As Double
  
  For Each Impuesto In m_Impuestos
   rtn = rtn + Impuesto.Importe
  Next
  
  TotalImpuestos = rtn
End Property

Public Property Let TotalImpuestos(ByVal rhs As Double)
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_Items = New cIComprobanteItems
  Set m_Impuestos = New cIComprobanteImpuestos
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Impuestos = Nothing
  Set m_Items = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

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


