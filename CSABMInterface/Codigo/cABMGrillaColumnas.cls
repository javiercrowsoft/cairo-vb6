VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMGridColumns"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMGridColumns

'--------------------------------------------------------------------------------
' cABMGridColumns
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
Public Function Add(ByVal o As CSInterfacesABM.cIABMGridColumn, _
                    Optional Key As Variant, _
                    Optional ByVal Index As Long = -1) As CSInterfacesABM.cIABMGridColumn

  On Error GoTo ControlError

  If o Is Nothing Then Set o = New cABMGridColumn

  If IsMissing(Key) Then
    If Index = -1 Then
      m_Coll.Add o
    Else
      m_Coll.Add o, , Index
    End If
  Else
    If Index = -1 Then
      m_Coll.Add o, GetKey(Key)
    Else
      m_Coll.Add o, GetKey(Key), Index
    End If
  End If
  
  Dim Col As cABMGridColumn
  Set Col = o
  Col.Index = m_Coll.Count

  Set Add = o
  Exit Function
ControlError:
  Set Add = Nothing
End Function

Private Function cIABMGridColumns_Add(ByVal o As CSInterfacesABM.cIABMGridColumn, Optional Key As Variant) As CSInterfacesABM.cIABMGridColumn
  If IsMissing(Key) Then
    Set cIABMGridColumns_Add = Add(o)
  Else
    Set cIABMGridColumns_Add = Add(o, Key)
  End If
End Function

Private Sub cIABMGridColumns_Clear()
  CollClear m_Coll
  pInitColIndex
End Sub

Private Function cIABMGridColumns_Count() As Long
  cIABMGridColumns_Count = m_Coll.Count
End Function

Private Function cIABMGridColumns_Item(ByVal kItem As Variant) As CSInterfacesABM.cIABMGridColumn
  On Error GoTo ControlError
  If Not IsNumeric(kItem) Then kItem = GetKey(kItem)
  Set cIABMGridColumns_Item = m_Coll(kItem)
  Exit Function
ControlError:
  Err.Clear
End Function

Private Function cIABMGridColumns_NewEnum() As stdole.IUnknown
  Set cIABMGridColumns_NewEnum = m_Coll.[_NewEnum]
End Function

Private Sub cIABMGridColumns_Remove(ByVal kItem As Variant)
  m_Coll.Remove kItem
End Sub

' funciones privadas
Private Function pInitColIndex()
  Dim c As cIABMGridColumn
  Set c = cIABMGridColumns_Add(Nothing)
  c.Name = "Item"
  c.Width = 600
  c.PropertyType = cspGrid
  c.Enabled = False
End Function
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Coll = New Collection
  pInitColIndex
End Sub

Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing
End Sub
