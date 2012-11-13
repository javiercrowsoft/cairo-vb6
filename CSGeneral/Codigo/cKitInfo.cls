VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cKitInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cKitInfo
' 17-07-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cKitInfo"
' estructuras
' variables privadas
Private m_pr_id                         As Long
Private m_Nombre                        As String
Private m_Cantidad                      As Long
Private m_LlevaNroSerie                 As Boolean
Private m_pr_id_kit                     As Long
' eventos
' propiedades publicas
Public Property Get pr_id() As Long
  pr_id = m_pr_id
End Property

Public Property Let pr_id(ByVal rhs As Long)
  m_pr_id = rhs
End Property

Public Property Get pr_id_kit() As Long
  pr_id_kit = m_pr_id_kit
End Property

Public Property Let pr_id_kit(ByVal rhs As Long)
  m_pr_id_kit = rhs
End Property

Public Property Get Nombre() As String
  Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
  m_Nombre = rhs
End Property

Public Property Get Cantidad() As Long
  Cantidad = m_Cantidad
End Property

Public Property Let Cantidad(ByVal rhs As Long)
  m_Cantidad = rhs
End Property

Public Property Get LlevaNroSerie() As Boolean
  LlevaNroSerie = m_LlevaNroSerie
End Property

Public Property Let LlevaNroSerie(ByVal rhs As Boolean)
  m_LlevaNroSerie = rhs
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
