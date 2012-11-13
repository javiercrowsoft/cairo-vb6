VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCounter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cCounter
' 25-10-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCounter"
' estructuras
' variables privadas
Private m_count         As Integer
Private m_ID            As String

' eventos
' propiedadades publicas
Public Property Get Id() As String
   Id = m_ID
End Property

Public Property Let Id(ByVal rhs As String)
   m_ID = rhs
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub IncrementCount()
  m_count = m_count + 1
End Sub

Public Function GetCount() As Integer
  GetCount = m_count
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  m_count = 0

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
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


