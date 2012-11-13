VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMTabs"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMTabs

'--------------------------------------------------------------------------------
' cABMTabs
' 06-01-01

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
Private Function cIABMTabs_Add(ByVal o As CSInterfacesABM.cIABMTabItem, Optional Key As Variant) As CSInterfacesABM.cIABMTabItem
    On Error GoTo ControlError

    If o Is Nothing Then Set o = New cABMTabItem

    If IsMissing(Key) Then
        m_Coll.Add o
    Else
        m_Coll.Add o, GetKey(Key)
    End If

    Set cIABMTabs_Add = o
    Exit Function
ControlError:
    Set cIABMTabs_Add = Nothing

End Function

Private Sub cIABMTabs_Clear()
    CollClear m_Coll
End Sub

Private Function cIABMTabs_Count() As Long
    cIABMTabs_Count = m_Coll.Count
End Function

Private Function cIABMTabs_Item(ByVal kItem As Variant) As CSInterfacesABM.cIABMTabItem
    On Error GoTo ControlError
    
    If VarType(kItem) <> vbInteger And VarType(kItem) <> vbLong Then
      If IsNumeric(kItem) Then kItem = GetKey(kItem)
    End If
    
    Set cIABMTabs_Item = m_Coll(kItem)
    Exit Function
ControlError:
    Err.Clear
End Function

Private Function cIABMTabs_NewEnum() As stdole.IUnknown
    Set cIABMTabs_NewEnum = m_Coll.[_NewEnum]
End Function

Private Sub cIABMTabs_Remove(ByVal kItem As Variant)
    m_Coll.Remove kItem
End Sub

' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
    Set m_Coll = New Collection
End Sub

Private Sub Class_Terminate()
    CollClear m_Coll
    Set m_Coll = Nothing
End Sub

