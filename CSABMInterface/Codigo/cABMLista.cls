VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMList

'--------------------------------------------------------------------------------
' cABMList
' 14-01-01

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
Private m_Coll As Collection
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones privadas
Private Function cIABMList_Add(ByVal o As CSInterfacesABM.cIABMListItem, Optional Key As Variant) As CSInterfacesABM.cIABMListItem
    On Error GoTo ControlError

    If o Is Nothing Then Set o = New cABMListItem

    If IsMissing(Key) Then
        m_Coll.Add o
    Else
        m_Coll.Add o, GetKey(Key)
    End If

    Set cIABMList_Add = o
    Exit Function
ControlError:
    Set cIABMList_Add = Nothing
End Function

Private Sub cIABMList_Clear()
    CollClear m_Coll
End Sub

Private Function cIABMList_Count() As Long
    cIABMList_Count = m_Coll.Count
End Function

Private Function cIABMList_Item(ByVal kItem As Variant) As CSInterfacesABM.cIABMListItem
    On Error GoTo ControlError
    If IsNumeric(kItem) Then kItem = GetKey(kItem)
    Set cIABMList_Item = m_Coll(kItem)
    Exit Function
ControlError:
    Err.Clear
End Function

Private Function cIABMList_NewEnum() As stdole.IUnknown
    Set cIABMList_NewEnum = m_Coll.[_NewEnum]
End Function

Private Sub cIABMList_Remove(ByVal kItem As Variant)
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

