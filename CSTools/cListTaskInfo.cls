VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cListTaskInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cListTaskInfo
' 15-05-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cListTaskInfo"
' estructuras
' variables privadas
Private m_Name        As String
Private m_Id          As String

' eventos
' propiedades publicas
Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Get Id() As String
   Id = m_Id
End Property

' propiedades privadas
' funciones publicas
' funciones friend
Friend Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Friend Property Let Id(ByVal rhs As String)
   m_Id = rhs
End Property
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


