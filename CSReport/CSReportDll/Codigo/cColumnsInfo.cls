VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cColumnsInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cColumnsInfo
' 30-10-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' Clase base
' constantes
Private Const C_Module As String = "cColumnsInfo"

' estructuras
' variables privadas
Private m_Coll As Collection

' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function Add(Optional ByVal c As cColumnInfo = Nothing, Optional ByRef Key As Variant) As cColumnInfo
  On Error GoTo ControlError
  
  If c Is Nothing Then Set c = New cColumnInfo
  
  If IsMissing(Key) Then
    Key = GetNextKey()
  Else
    RefreshNextKey (Key)
  End If

  Key = GetKey(Key)

  m_Coll.Add c, Key

  c.Position = m_Coll.Count()

  c.Key = Key

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
  m_Coll.Remove kItem
  Exit Sub
ControlError:
End Sub

Public Function Count() As Long
  On Error GoTo ControlError
  Count = m_Coll.Count()
  Exit Function
ControlError:
  Count = 0
End Function

Public Function Item(ByVal kItem As Variant) As cColumnInfo
Attribute Item.VB_UserMemId = 0
  On Error GoTo ControlError
  Set Item = m_Coll.Item(kItem)
  Exit Function
ControlError:
End Function

' funciones privadas

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_Coll.[_NewEnum]
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing
End Sub
