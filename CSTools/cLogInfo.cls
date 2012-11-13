VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLogInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cLogInfo
' 19-08-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cLogInfo"
' estructuras
' variables privadas
Private m_File                          As Integer
Private m_Created                       As String
Private m_Occurs                        As String
Private m_Source                        As String
Private m_Message                       As String

' eventos
' propiedadades publicas
Public Property Get File() As Integer
   File = m_File
End Property

Public Property Let File(ByVal rhs As Integer)
   m_File = rhs
End Property

Public Property Get Created() As String
   Created = m_Created
End Property

Public Property Let Created(ByVal rhs As String)
   m_Created = rhs
End Property

Public Property Get Occurs() As String
   Occurs = m_Occurs
End Property

Public Property Let Occurs(ByVal rhs As String)
   m_Occurs = rhs
End Property

Public Property Get Source() As String
   Source = m_Source
End Property

Public Property Let Source(ByVal rhs As String)
   m_Source = rhs
End Property

Public Property Get Message() As String
   Message = m_Message
End Property

Public Property Let Message(ByVal rhs As String)
   m_Message = rhs
End Property


' propiedadades friend
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
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

