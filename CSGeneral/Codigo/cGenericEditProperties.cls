VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGenericEditProperties"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cEditGenericProperties
' 01-12-08

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
Private m_Coll              As Collection

' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
Public Function Add(ByVal o As cGenericEditProperty, Optional Key As Variant) As cGenericEditProperty
  On Error GoTo ControlError

  If o Is Nothing Then Set o = New cGenericEditProperty

  If IsMissing(Key) Then
      m_Coll.Add o
  Else
      m_Coll.Add o, GetKey(Key)
  End If

  Set Add = o
  
  Exit Function
ControlError:
  Set Add = Nothing

End Function

Public Sub Clear()
  CollClear m_Coll
End Sub

Public Function Count() As Long
  Count = m_Coll.Count
End Function

Public Function Item(ByVal kItem As Variant) As cGenericEditProperty
Attribute Item.VB_UserMemId = 0
  On Error GoTo ControlError
  If VarType(kItem) <> vbInteger And VarType(kItem) <> vbLong Then
    If IsNumeric(kItem) Then kItem = GetKey(kItem)
  End If
  Set Item = m_Coll(kItem)
  Exit Function
ControlError:
  Err.Clear
End Function

Public Function NewEnum() As stdole.IUnknown
Attribute NewEnum.VB_UserMemId = -4
  Set NewEnum = m_Coll.[_NewEnum]
End Function

Public Sub Remove(ByVal kItem As Variant)
  m_Coll.Remove kItem
End Sub

' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing
End Sub

