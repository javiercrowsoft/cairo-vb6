VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cChatSession"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cChatSession
' 01-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cChatSession"
' estructuras
' variables privadas
Private m_ClientIds() As Long
Private m_collTempIds As Collection
Private m_SessionKey  As String

' eventos
' propiedadades publicas
Public Property Get ClientIds(ByVal Idx As Long) As Long
  If Idx > UBound(m_ClientIds) Then Exit Property
  ClientIds = m_ClientIds(Idx)
End Property

Public Property Let ClientIds(ByVal Idx As Long, ByVal rhs As Long)
  If Idx > UBound(m_ClientIds) Then
    ReDim Preserve m_ClientIds(Idx)
  End If
  m_ClientIds(Idx) = rhs
End Property

Public Property Get SessionKey() As String
  SessionKey = m_SessionKey
End Property

Public Property Let SessionKey(ByVal rhs As String)
  m_SessionKey = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub AddRealId(ByVal Id As Long)
  ClientIds(UBound(m_ClientIds) + 1) = Id
End Sub

Public Sub AddTempId(ByVal Id As Long)
  m_collTempIds.Add Id
End Sub

Public Sub RemoveRealId(ByVal Id As Long)
  Dim i      As Long
  Dim bFound As Boolean
  
  For i = 1 To UBound(m_ClientIds)
    If m_ClientIds(i) = Id Then
      bFound = True
      Exit For
    End If
  Next
  
  If bFound Then
    For i = i To UBound(m_ClientIds) - 1
      m_ClientIds(i) = m_ClientIds(i + 1)
    Next
    
    If UBound(m_ClientIds) > 0 Then
      ReDim Preserve m_ClientIds(UBound(m_ClientIds) - 1)
    End If
  End If
End Sub

Public Sub RemoveTempId(ByVal Id As Long)
  Dim i As Long
  For i = 1 To m_collTempIds.Count
    If m_collTempIds.Item(i) = Id Then
      m_collTempIds.Remove i
      Exit Sub
    End If
  Next
End Sub

Public Function ClientsCount() As Long
  ClientsCount = UBound(m_ClientIds)
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  ReDim m_ClientIds(0)
  Set m_collTempIds = New Collection

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  ReDim m_ClientIds(0)
  CollClear m_collTempIds
  Set m_collTempIds = Nothing
  
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


