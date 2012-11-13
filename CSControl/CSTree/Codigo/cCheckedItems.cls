VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCheckedItems"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCheckedItems
' 03-10-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
' estructuras
' variables privadas
Private m_Coll          As Collection
Private m_IsLoaded      As Boolean
' propiedades publicas
Public Property Get IsLoaded() As Boolean
    IsLoaded = m_IsLoaded
End Property
Public Property Let IsLoaded(ByVal rhs As Boolean)
    m_IsLoaded = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Add2(ByVal Id As Long, ByVal Key As Variant) As Boolean
    Dim c As cCheckedItem
    
    Set c = Add(c, Key)
    
    If c Is Nothing Then Exit Function
    
    c.Id = Id
    
End Function

Public Function Add(ByVal c As cCheckedItem, Optional ByVal Key As Variant) As cCheckedItem
    On Error GoTo ControlError

    If c Is Nothing Then Set c = New cCheckedItem

    If IsMissing(Key) Then
        m_Coll.Add c
    Else
        If IsNumeric(Key) Then Key = GetKey(Key)
        m_Coll.Add c, Key
    End If

    Set Add = c
    Exit Function
ControlError:
    Set Add = Nothing
End Function
Public Sub Clear()
    CollClear m_Coll
    m_IsLoaded = False
End Sub
Public Sub Remove(ByVal kItem As Variant)
    On Error GoTo ControlError
    If IsNumeric(kItem) Then kItem = GetKey(kItem)
    m_Coll.Remove kItem
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

Public Function item(ByVal kItem As Variant) As cCheckedItem
Attribute item.VB_UserMemId = 0
    On Error GoTo ControlError
    If IsNumeric(kItem) Then
        kItem = GetKey(kItem)
    End If
    Set item = m_Coll(kItem)
    Exit Function
ControlError:
End Function

Public Function ItemAt(ByVal kItem As Integer) As cCheckedItem
    On Error GoTo ControlError
    Set ItemAt = m_Coll(kItem)
    Exit Function
ControlError:
End Function

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
    Set NewEnum = m_Coll.[_NewEnum]
End Function

Public Function Load(ByVal Id As Long) As Boolean

End Function

Public Sub Copy(ByVal Id As Long)

End Sub

Public Function Paste(ByVal IdToCopy As Long, ByVal IdToPaste As Long)

End Function

Public Function Cut(ByVal Id As Long)

End Function
' funciones privadas
Private Sub Class_Initialize()
    Set m_Coll = New Collection
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
    CollClear m_Coll
    Set m_Coll = Nothing
End Sub





