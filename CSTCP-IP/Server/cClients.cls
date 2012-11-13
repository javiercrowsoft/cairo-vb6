VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cClients"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cClients
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
Private Const C_Module = "cClients"
' estructuras
' variables privadas
Private m_Coll        As Collection
Private m_NextId      As Long
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Function Add(ByVal Socket As cSocket, Optional Key As Variant) As cClient
    On Error GoTo ControlError

    Dim c As cClient

    If Socket Is Nothing Then Exit Function

    Set c = New cClient

    If IsMissing(Key) Then
        m_Coll.Add c
    Else
        m_Coll.Add c, GetKey(Key)
    End If
    
    Set c.Socket = Socket
    c.ID = pGetNextID

#If PREPROC_DEBUG Then
    SaveLog C_Module & " Item added " & Key
#End If

    Set Add = c
    Exit Function
ControlError:
    Set Add = Nothing
End Function

Public Sub Clear()
    CollClear m_Coll
End Sub

Public Sub Remove(ByVal kItem As Variant)
    On Error GoTo ControlError
    
    If VarType(kItem) = vbString Then
      m_Coll.Remove GetIndexFromKey(m_Coll, kItem)
    Else
      m_Coll.Remove kItem
    End If
    
#If PREPROC_DEBUG Then
    SaveLog C_Module & " Item removed " & kItem
#End If

    Exit Sub
ControlError:
End Sub

Public Function Count() As Long
    On Error GoTo ControlError
    Count = m_Coll.Count
    Exit Function
ControlError:
    Count = 0
End Function

Public Function Item(ByVal kItem As Variant) As cClient
Attribute Item.VB_UserMemId = 0
    On Error GoTo ControlError
    Set Item = m_Coll(kItem)
    Exit Function
ControlError:
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
    Set NewEnum = m_Coll.[_NewEnum]
End Function

' funciones privadas
Private Function pGetNextID() As Long
  m_NextId = m_NextId + 1
  pGetNextID = m_NextId
End Function

' construccion - destruccion
Private Sub Class_Initialize()
    Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
    CollClear m_Coll
    Set m_Coll = Nothing
End Sub

