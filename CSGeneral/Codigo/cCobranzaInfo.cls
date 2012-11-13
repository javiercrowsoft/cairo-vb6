VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCobranzaInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCobranzaInfo
' 25-06-2009

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cWindow"
' estructuras
' variables privadas
Private m_Facturas                      As cCobranzaInfoFacturas
Private m_CueIdEfectivo                 As Long
Private m_CueIdTicket                   As Long
Private m_CuentaEfectivo                As String
Private m_CuentaTicket                  As String
' eventos
' propiedades publicas

Public Property Get CueIdEfectivo() As Long
   CueIdEfectivo = m_CueIdEfectivo
End Property

Public Property Let CueIdEfectivo(ByVal rhs As Long)
   m_CueIdEfectivo = rhs
End Property

Public Property Get CuentaEfectivo() As String
   CuentaEfectivo = m_CuentaEfectivo
End Property

Public Property Let CuentaEfectivo(ByVal rhs As String)
   m_CuentaEfectivo = rhs
End Property

Public Property Get CueIdTicket() As Long
   CueIdTicket = m_CueIdTicket
End Property

Public Property Let CueIdTicket(ByVal rhs As Long)
   m_CueIdTicket = rhs
End Property

Public Property Get CuentaTicket() As String
   CuentaTicket = m_CuentaTicket
End Property

Public Property Let CuentaTicket(ByVal rhs As String)
   m_CuentaTicket = rhs
End Property

Public Property Get Facturas() As cCobranzaInfoFacturas
  Set Facturas = m_Facturas
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_Facturas = New cCobranzaInfoFacturas

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Facturas = Nothing

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
