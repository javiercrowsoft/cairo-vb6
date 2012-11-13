VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMGridRow"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMGridRow

'--------------------------------------------------------------------------------
' cABMGridRow
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
Private m_Coll        As Collection
Private m_Index       As Integer
Private m_Visible     As Boolean
Private m_BackColor   As Long
Private m_ForeColor   As Long
Private m_Key         As String
Private m_IsGroup     As Boolean
Private m_IsSelected  As Boolean
' eventos
' propiedades publicas
Public Property Get Visible() As Boolean
  Visible = m_Visible
End Property

Public Property Let Visible(ByVal rhs As Boolean)
  m_Visible = rhs
End Property

Public Property Get IsGroup() As Boolean
  IsGroup = m_IsGroup
End Property

Public Property Let IsGroup(ByVal rhs As Boolean)
  m_IsGroup = rhs
End Property

Public Property Get Index() As Integer
  Index = m_Index
End Property

Public Property Let Index(ByVal rhs As Integer)
  m_Index = rhs
End Property

Public Property Get ForeColor() As ColorConstants
   ForeColor = m_ForeColor
End Property

Public Property Let ForeColor(ByVal rhs As ColorConstants)
   m_ForeColor = rhs
End Property

Public Property Get BackColor() As ColorConstants
   BackColor = m_BackColor
End Property

Public Property Let BackColor(ByVal rhs As ColorConstants)
   m_BackColor = rhs
End Property

Public Property Get Key() As String
  Key = m_Key
End Property

Public Property Let Key(ByVal rhs As String)
  m_Key = rhs
End Property

Public Property Get IsSelected() As Boolean
  IsSelected = m_IsSelected
End Property

Public Property Let IsSelected(ByVal rhs As Boolean)
  m_IsSelected = rhs
End Property

' propiedades privadas
' funciones publicas
Public Function Item(ByVal kItem As Variant) As CSInterfacesABM.cIABMGridCellValue
  Set Item = cIABMGridRow_Item(kItem)
End Function

Public Function Add(ByVal o As CSInterfacesABM.cIABMGridCellValue, _
                    Optional Key As Variant, _
                    Optional ByVal Index As Long = -1) As CSInterfacesABM.cIABMGridCellValue

  On Error GoTo ControlError

  If o Is Nothing Then Set o = New cABMGridRowValue

  If IsMissing(Key) Then
    If Index = -1 Then
      m_Coll.Add o
    Else
      m_Coll.Add o, , Index
    End If
  Else
    Dim c       As cABMGridRowValue
    Dim strKey  As String
    Set c = o
    strKey = GetKey(Key)
    c.strKey = strKey
    
    If Index = -1 Then
      m_Coll.Add o, strKey
    Else
      m_Coll.Add o, strKey, Index
    End If
  End If

  Set Add = o
  Exit Function
ControlError:
  Set Add = Nothing
End Function

Private Sub cIABMGridRow_Clear()
  CollClear m_Coll
End Sub

Private Function cIABMGridRow_Count() As Long
  cIABMGridRow_Count = m_Coll.Count
End Function

Private Function cIABMGridRow_Add(ByVal o As CSInterfacesABM.cIABMGridCellValue, Optional Key As Variant) As CSInterfacesABM.cIABMGridCellValue
  If IsMissing(Key) Then
    Set cIABMGridRow_Add = Add(o)
  Else
    Set cIABMGridRow_Add = Add(o, Key)
  End If
End Function

Private Function cIABMGridRow_Item(ByVal kItem As Variant) As CSInterfacesABM.cIABMGridCellValue
  On Error GoTo ControlError
  If VarType(kItem) <> vbInteger And VarType(kItem) <> vbLong Then
    If IsNumeric(kItem) Then kItem = GetKey(kItem)
  End If
  Set cIABMGridRow_Item = m_Coll.Item(kItem)
  Exit Function
ControlError:
  Err.Clear
End Function

Private Function cIABMGridRow_NewEnum() As stdole.IUnknown
  Set cIABMGridRow_NewEnum = m_Coll.[_NewEnum]
End Function

Private Sub cIABMGridRow_Remove(ByVal kItem As Variant)
  m_Coll.Remove kItem
End Sub

' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Coll = New Collection
  m_Visible = True
  m_ForeColor = vbWindowText
  m_BackColor = vbWindowBackground
End Sub

Private Sub Class_Terminate()
  CollClear m_Coll
  Set m_Coll = Nothing
End Sub
