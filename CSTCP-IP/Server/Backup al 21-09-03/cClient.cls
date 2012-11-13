VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cClient"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cClient
' 02-11-2002

' Contiene la info de los clientes conectados

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cClient"
' estructuras
' variables privadas
Private m_ID                            As Long
Private m_Socket                        As Socket
' Coleccion de servicios que han registrado a este cliente
Private m_Services                      As cServices
' eventos
' propiedadades publicas
Public Property Get ID() As Long
   ID = m_ID
End Property

Public Property Let ID(ByVal rhs As Long)
   m_ID = rhs
End Property

Public Property Get Socket() As Socket
   Set Socket = m_Socket
End Property

Public Property Set Socket(ByRef rhs As Socket)
   Set m_Socket = rhs
End Property

Public Property Get Services() As cServices
   Set Services = m_Services
End Property

Public Property Set Services(ByRef rhs As cServices)
   Set m_Services = rhs
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_Services = New cServices

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Services = Nothing
  Set m_Socket = Nothing
  
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


