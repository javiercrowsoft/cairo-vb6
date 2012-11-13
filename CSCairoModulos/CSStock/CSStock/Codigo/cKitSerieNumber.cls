VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cKitSerieNumber"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cKitSerieNumber
' 15-08-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cKitSerieNumber"
' estructuras
' variables privadas
Private m_pr_id             As Long
Private m_Nombre            As String
Private m_prns_id           As Long
Private m_Serie             As String
' eventos
' propiedades publicas

Public Property Get pr_id() As Long
  pr_id = m_pr_id
End Property
Public Property Let pr_id(ByVal rhs As Long)
  m_pr_id = rhs
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property
Public Property Let Nombre(ByVal rhs As String)
  m_Nombre = rhs
End Property

Public Property Get prns_id() As Long
  prns_id = m_prns_id
End Property
Public Property Let prns_id(ByVal rhs As Long)
  m_prns_id = rhs
End Property

Public Property Get Serie() As String
  Serie = m_Serie
End Property
Public Property Let Serie(ByVal rhs As String)
  m_Serie = rhs
End Property

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
