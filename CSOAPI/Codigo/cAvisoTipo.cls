VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAvisoTipo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cWindow
' 07-01-2004

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
Private m_ID                            As Long
Private m_Nombre                        As String
Private m_ObjetoEdicion                 As String
Private m_ObjetoInit                    As String
Private m_SpInfo                        As String
' eventos
' propiedades publicas
Public Property Get Id() As Long
   Id = m_ID
End Property

Public Property Let Id(ByVal rhs As Long)
   m_ID = rhs
End Property

Public Property Get Nombre() As String
   Nombre = m_Nombre
End Property

Public Property Let Nombre(ByVal rhs As String)
   m_Nombre = rhs
End Property

Public Property Get ObjetoEdicion() As String
   ObjetoEdicion = m_ObjetoEdicion
End Property

Public Property Let ObjetoEdicion(ByVal rhs As String)
   m_ObjetoEdicion = rhs
End Property

Public Property Get ObjetoInit() As String
   ObjetoInit = m_ObjetoInit
End Property

Public Property Let ObjetoInit(ByVal rhs As String)
   m_ObjetoInit = rhs
End Property

Public Property Get SpInfo() As String
   SpInfo = m_SpInfo
End Property

Public Property Let SpInfo(ByVal rhs As String)
   m_SpInfo = rhs
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


