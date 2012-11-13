VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIComprobanteItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cIComprobanteItem
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
Private Const C_Module = "cIComprobanteItem"
' estructuras
' variables privadas
Private m_ID                            As Long
Private m_Item                          As Integer
Private m_ComprobanteID                 As Long
Private m_Cantidad                      As Double
Private m_Importe                       As Double
Private m_Neto                          As Double
Private m_Total                         As Double
Private m_DepositoOrigen                As Long
Private m_DepositoDestino               As Long
Private m_Impuestos                     As cIComprobanteImpuestos
' eventos
' propiedadades publicas
Public Property Get ID() As Long
   ID = m_ID
End Property

Public Property Let ID(ByVal rhs As Long)
   m_ID = rhs
End Property

Public Property Get Item() As Integer
   Item = m_Item
End Property

Public Property Let Item(ByVal rhs As Integer)
   m_Item = rhs
End Property

Public Property Get ComprobanteID() As Long
   ComprobanteID = m_ComprobanteID
End Property

Public Property Let ComprobanteID(ByVal rhs As Long)
   m_ComprobanteID = rhs
End Property

Public Property Get Cantidad() As Double
   Cantidad = m_Cantidad
End Property

Public Property Let Cantidad(ByVal rhs As Double)
   m_Cantidad = rhs
End Property

Public Property Get Importe() As Double
   Importe = m_Importe
End Property

Public Property Let Importe(ByVal rhs As Double)
   m_Importe = rhs
End Property

Public Property Get Neto() As Double
   Neto = m_Neto
End Property

Public Property Let Neto(ByVal rhs As Double)
   m_Neto = rhs
End Property

Public Property Get Total() As Double
   Total = m_Total
End Property

Public Property Let Total(ByVal rhs As Double)
   m_Total = rhs
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

Public Property Get Impuestos() As cIComprobanteImpuestos
   Set Impuestos = m_Impuestos
End Property

Public Property Set Impuestos(ByRef rhs As cIComprobanteImpuestos)
   Set m_Impuestos = rhs
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



