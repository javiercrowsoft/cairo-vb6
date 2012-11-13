VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMGridRows"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMGridRows

'--------------------------------------------------------------------------------
' cABMGridRows
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
Private m_Coll    As Collection
Private m_HaveKey As Boolean

' eventos
' propiedades publicas
Public Property Get HaveKey() As Boolean
  HaveKey = m_HaveKey
End Property

Public Property Let HaveKey(ByVal rhs As Boolean)
  m_HaveKey = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Add(ByVal o As CSInterfacesABM.cIABMGridRow, _
                    Optional Key As Variant) As CSInterfacesABM.cIABMGridRow
                    
  On Error GoTo ControlError

  Dim r       As cABMGridRow
  Dim strKey  As String

  If o Is Nothing Then Set o = New cABMGridRow

  Set r = o

  If IsMissing(Key) Then
    If r.Index > 0 And r.Index <= m_Coll.Count Then
      m_Coll.Add o, , r.Index
    Else
      m_Coll.Add o
    End If
  Else
    
    m_HaveKey = True
    strKey = GetKey(Key)
    r.Key = strKey
    If r.Index > 0 And r.Index <= m_Coll.Count Then
      m_Coll.Add o, strKey, r.Index
    Else
      m_Coll.Add o, strKey
    End If
  End If
    
  If o.Item(c_keyRowItem) Is Nothing Then
    o.Add(Nothing, c_keyRowItem).Value = m_Coll.Count
  End If

  ' Si Index fue cero entonces se agrego al final
  If r.Index = 0 Then r.Index = m_Coll.Count

  Set Add = o
  Exit Function
ControlError:
  Set Add = Nothing
End Function

Private Function cIABMGridRows_Add(ByVal o As CSInterfacesABM.cIABMGridRow, _
                                   Optional Key As Variant) As CSInterfacesABM.cIABMGridRow
  If IsMissing(Key) Then
    Set cIABMGridRows_Add = Add(o)
  Else
    Set cIABMGridRows_Add = Add(o, Key)
  End If
End Function

Private Sub cIABMGridRows_Clear()
  m_HaveKey = False
  CollClear m_Coll
End Sub

Private Function cIABMGridRows_Count() As Long
  cIABMGridRows_Count = m_Coll.Count
End Function

Private Function cIABMGridRows_Item(ByVal kItem As Variant) As CSInterfacesABM.cIABMGridRow
  On Error GoTo ControlError
  If Not IsNumeric(kItem) Then kItem = GetKey(kItem)
  Set cIABMGridRows_Item = m_Coll(kItem)
  Exit Function
ControlError:
  Err.Clear
End Function

Private Function cIABMGridRows_NewEnum() As stdole.IUnknown
  Set cIABMGridRows_NewEnum = m_Coll.[_NewEnum]
End Function

Public Sub Remove(ByVal kItem As Variant, _
                  ByVal bUpdateKey As Boolean)
  
  On Error GoTo ControlError
  Dim i As Integer
  
  Dim Row  As cABMGridRow
  Dim iRow As CSInterfacesABM.cIABMGridRow
  
  Set Row = m_Coll.Item(kItem)
  i = Row.Index
  
  m_Coll.Remove kItem
  
  If bUpdateKey Then
  
    For i = i To m_Coll.Count
      Set Row = m_Coll.Item(i)
      
      Row.Index = i
      
      Set iRow = Row
      If Not iRow.Item(c_keyRowItem) Is Nothing Then
        iRow.Item(c_keyRowItem).Value = i
      End If
    Next
  
  End If
  
ControlError:
End Sub

Private Sub cIABMGridRows_Remove(ByVal kItem As Variant)
  Remove kItem, True
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
