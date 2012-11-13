VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cABMProperty"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements CSInterfacesABM.cIABMProperty

'--------------------------------------------------------------------------------
' cABMProperty
' 07-01-01

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
Private m_Name          As String
Private m_SubType       As csSubTypeABMProperty
Private m_Table         As csTables
Private m_Type          As csTypeABMProperty
Private m_Value         As String
Private m_List          As cABMList
Private m_OptionGroup   As Integer
Private m_Size          As Integer
Private m_HelpId        As Long
Private m_TabIndex      As Integer
Private m_TabIndex2     As Integer
Private m_Enabled       As Boolean

Private m_Grid        As cABMGrid
Private m_GridAdd     As Boolean
Private m_GridRemove  As Boolean
Private m_GridEdit    As Boolean

Private m_ControlLoaded    As Boolean
Private m_Index            As Integer
Private m_LabelIndex       As Integer
Private m_Key              As Integer
Private m_KeyCol           As String

Private m_FieldValueProcess As String
Private m_HelpFilter        As String
Private m_HelpValueProcess  As String
Private m_HelpSPFilter      As String
Private m_HelpSPInfoFilter  As String

Private m_Top                           As Integer
Private m_TopToPrevious                 As Integer
Private m_Left                          As Integer
Private m_Visible                       As Boolean
Private m_LeftToPrevious                As Integer
Private m_LeftLabel                     As Integer
Private m_LeftFrame                     As Integer
Private m_LeftNotChange                 As Boolean
Private m_TopFrame                      As Integer
Private m_LeftFromProperty              As String
Private m_Width                         As Integer
Private m_Height                        As Integer
Private m_TopFromProperty               As String
Private m_TopNotChange                  As Boolean

Private m_nTop                          As Integer
Private m_nLeft                         As Integer
Private m_nWidth                        As Integer
Private m_nHeight                       As Integer

Private m_SelectedIndex                 As Long

Private m_Toolbar                       As Toolbar

Private m_Buttons                       As String

Private m_FontName                      As String
Private m_FontSize                      As Single
Private m_FontBold                      As Boolean
Private m_FontUnderline                 As Boolean
Private m_FontItalic                    As Boolean
Private m_ForeColor                     As Long
Private m_BackColor                     As Long

Private m_TextAlign                     As AlignmentConstants
Private m_TextMask                      As String
Private m_Format                        As String

Private m_IsEditProperty                As Boolean
Private m_IsForABM                      As Boolean

Private m_InputDisabled                 As Boolean

Private m_ListText                      As String
Private m_ListListIndex                 As Integer
Private m_ListItemData                  As Long
Private m_ListWhoSetItem                As csListWhoSetItem

Private m_HelpType                      As csHelpType

Private m_picture                       As IPictureDisp

Private m_Ctl                           As Object

Private m_NoShowButton                  As Boolean

' eventos
' propiedades publicas

Public Property Get NoShowButton() As Boolean
  NoShowButton = m_NoShowButton
End Property
Public Property Let NoShowButton(ByVal rhs As Boolean)
  m_NoShowButton = rhs
End Property

Public Property Get InputDisabled() As Boolean
  InputDisabled = m_InputDisabled
End Property
Public Property Let InputDisabled(ByVal rhs As Boolean)
  m_InputDisabled = rhs
End Property
Public Property Get IsEditProperty() As Boolean
  IsEditProperty = m_IsEditProperty
End Property
Public Property Let IsEditProperty(ByVal rhs As Boolean)
  m_IsEditProperty = rhs
End Property
Public Property Get IsForABM() As Boolean
  IsForABM = m_IsForABM
End Property
Public Property Let IsForABM(ByVal rhs As Boolean)
  m_IsForABM = rhs
End Property
Public Property Get ControlLoaded() As Boolean
  ControlLoaded = m_ControlLoaded
End Property
Public Property Let ControlLoaded(ByVal rhs As Boolean)
  m_ControlLoaded = rhs
End Property
Public Property Get Index() As Integer
  Index = m_Index
End Property
Public Property Let Index(ByVal rhs As Integer)
  m_Index = rhs
End Property
Public Property Get LabelIndex() As Integer
  LabelIndex = m_LabelIndex
End Property
Public Property Let LabelIndex(ByVal rhs As Integer)
  m_LabelIndex = rhs
End Property
Public Property Get KeyCol() As String
  KeyCol = m_KeyCol
End Property
Public Property Let KeyCol(ByVal rhs As String)
  m_KeyCol = rhs
End Property
Friend Property Get TabIndex() As Integer
  TabIndex = m_TabIndex2
End Property
Friend Property Let TabIndex(ByVal rhs As Integer)
  m_TabIndex2 = rhs
End Property

Private Property Let cIABMProperty_Buttons(ByVal rhs As String)
  m_Buttons = rhs
End Property

Private Property Get cIABMProperty_Buttons() As String
  cIABMProperty_Buttons = m_Buttons
End Property

Public Property Set Toolbar(ByRef rhs As Object)
  Set m_Toolbar = rhs
End Property

Public Property Get Toolbar() As Object
  Set Toolbar = m_Toolbar
End Property

Private Property Let cIABMProperty_Format(ByVal rhs As String)
  m_Format = rhs
End Property

Private Property Get cIABMProperty_Format() As String
  cIABMProperty_Format = m_Format
End Property

'Public Property Get GridAdd() As Boolean
'    GridAdd = m_GridAdd
'End Property
'Public Property Get GridRemove() As Boolean
'    GridRemove = m_GridRemove
'End Property
'Public Property Get GridEdit() As Boolean
'    GridEdit = m_GridEdit
'End Property

Private Property Get cIABMProperty_GridAdd() As Boolean
    cIABMProperty_GridAdd = m_GridAdd
End Property

Private Property Get cIABMProperty_GridEdit() As Boolean
    cIABMProperty_GridEdit = m_GridEdit
End Property

Private Property Get cIABMProperty_GridRemove() As Boolean
    cIABMProperty_GridRemove = m_GridRemove
End Property

Private Property Let cIABMProperty_HelpSPFilter(ByVal rhs As String)
  m_HelpSPFilter = rhs
End Property

Private Property Get cIABMProperty_HelpSPFilter() As String
  cIABMProperty_HelpSPFilter = m_HelpSPFilter
End Property

Private Property Let cIABMProperty_HelpSPInfoFilter(ByVal rhs As String)
  m_HelpSPInfoFilter = rhs
End Property

Private Property Get cIABMProperty_HelpSPInfoFilter() As String
  cIABMProperty_HelpSPInfoFilter = m_HelpSPInfoFilter
End Property

' Interfaz
Private Property Let cIABMProperty_Key(ByVal rhs As Integer)
    m_Key = rhs
End Property
Private Property Get cIABMProperty_Key() As Integer
    cIABMProperty_Key = m_Key
End Property

Private Property Let cIABMProperty_Enabled(ByVal rhs As Boolean)
    m_Enabled = rhs
End Property

Private Property Get cIABMProperty_Enabled() As Boolean
    cIABMProperty_Enabled = m_Enabled
End Property

Private Property Get cIABMProperty_Grid() As CSInterfacesABM.cIABMGrid
    If m_Grid Is Nothing Then Set m_Grid = New cABMGrid
    Set cIABMProperty_Grid = m_Grid
End Property

Private Property Let cIABMProperty_GridAdd(ByVal rhs As Boolean)
    m_GridAdd = rhs
End Property

Private Property Let cIABMProperty_GridEdit(ByVal rhs As Boolean)
    m_GridEdit = rhs
End Property

Private Property Let cIABMProperty_GridRemove(ByVal rhs As Boolean)
    m_GridRemove = rhs
End Property

Private Property Let cIABMProperty_HelpFieldValueProcess(ByVal rhs As String)
    m_FieldValueProcess = rhs
End Property

Private Property Get cIABMProperty_HelpFieldValueProcess() As String
    cIABMProperty_HelpFieldValueProcess = m_FieldValueProcess
End Property

Private Property Let cIABMProperty_HelpFilter(ByVal rhs As String)
    m_HelpFilter = rhs
End Property

Private Property Get cIABMProperty_HelpFilter() As String
    cIABMProperty_HelpFilter = m_HelpFilter
End Property

Private Property Let cIABMProperty_HelpId(ByVal rhs As Long)
    m_HelpId = rhs
End Property

Private Property Get cIABMProperty_HelpId() As Long
    cIABMProperty_HelpId = m_HelpId
End Property

Private Property Let cIABMProperty_HelpValueProcess(ByVal rhs As String)
    m_HelpValueProcess = rhs
End Property

Private Property Get cIABMProperty_HelpValueProcess() As String
    cIABMProperty_HelpValueProcess = m_HelpValueProcess
End Property

Private Property Let cIABMProperty_LeftFrame(ByVal rhs As Integer)
  m_LeftFrame = rhs
End Property

Private Property Get cIABMProperty_LeftFrame() As Integer
  cIABMProperty_LeftFrame = m_LeftFrame
End Property

Private Property Let cIABMProperty_LeftFromProperty(ByVal rhs As String)
  m_LeftFromProperty = rhs
End Property

Private Property Get cIABMProperty_LeftFromProperty() As String
  cIABMProperty_LeftFromProperty = m_LeftFromProperty
End Property

Private Property Let cIABMProperty_LeftLabel(ByVal rhs As Integer)
  m_LeftLabel = rhs
End Property

Private Property Get cIABMProperty_LeftLabel() As Integer
  cIABMProperty_LeftLabel = m_LeftLabel
End Property

Private Property Let cIABMProperty_LeftNotChange(ByVal rhs As Boolean)
  m_LeftNotChange = rhs
End Property

Private Property Get cIABMProperty_LeftNotChange() As Boolean
  cIABMProperty_LeftNotChange = m_LeftNotChange
End Property

Private Property Let cIABMProperty_LeftToPrevious(ByVal rhs As Integer)
  m_LeftToPrevious = rhs
End Property

Private Property Get cIABMProperty_LeftToPrevious() As Integer
  cIABMProperty_LeftToPrevious = m_LeftToPrevious
End Property

Private Property Let cIABMProperty_List(ByVal rhs As CSInterfacesABM.cIABMList)
  Set m_List = rhs
End Property

Private Property Get cIABMProperty_List() As CSInterfacesABM.cIABMList
  If m_List Is Nothing Then Set m_List = New cABMList
  Set cIABMProperty_List = m_List
End Property

Private Property Let cIABMProperty_Name(ByVal rhs As String)
  m_Name = rhs
End Property

Private Property Get cIABMProperty_Name() As String
  cIABMProperty_Name = m_Name
End Property

Private Property Let cIABMProperty_OptionGroup(ByVal rhs As Integer)
  m_OptionGroup = rhs
End Property

Private Property Get cIABMProperty_OptionGroup() As Integer
  cIABMProperty_OptionGroup = m_OptionGroup
End Property

Private Property Set cIABMProperty_Picture(ByVal rhs As stdole.Picture)
  Set m_picture = rhs
End Property

Private Property Get cIABMProperty_Picture() As stdole.Picture
  Set cIABMProperty_Picture = m_picture
End Property

Private Property Let cIABMProperty_SelectedIndex(ByVal rhs As Long)
  m_SelectedIndex = rhs
End Property

Private Property Get cIABMProperty_SelectedIndex() As Long
  cIABMProperty_SelectedIndex = m_SelectedIndex
End Property

Private Property Let cIABMProperty_SubType(ByVal rhs As csSubTypeABMProperty)
  m_SubType = rhs
End Property

Private Property Get cIABMProperty_SubType() As csSubTypeABMProperty
  cIABMProperty_SubType = m_SubType
End Property

Private Property Let cIABMProperty_TabIndex(ByVal rhs As Integer)
  m_TabIndex = rhs
End Property

Private Property Get cIABMProperty_TabIndex() As Integer
  cIABMProperty_TabIndex = m_TabIndex
End Property

Private Property Let cIABMProperty_Table(ByVal rhs As csTables)
  m_Table = rhs
End Property

Private Property Get cIABMProperty_Table() As csTables
  cIABMProperty_Table = m_Table
End Property

Private Property Let cIABMProperty_Size(ByVal rhs As Integer)
  m_Size = rhs
End Property

Private Property Get cIABMProperty_Size() As Integer
  cIABMProperty_Size = m_Size
End Property

Private Property Let cIABMProperty_PropertyType(ByVal rhs As csTypeABMProperty)
  m_Type = rhs
End Property

Private Property Get cIABMProperty_PropertyType() As csTypeABMProperty
  cIABMProperty_PropertyType = m_Type
End Property

Private Property Let cIABMProperty_TextAlign(ByVal rhs As AlignmentConstants)
  m_TextAlign = rhs
End Property

Private Property Get cIABMProperty_TextAlign() As AlignmentConstants
  cIABMProperty_TextAlign = m_TextAlign
End Property

Private Property Let cIABMProperty_TextMask(ByVal rhs As String)
  m_TextMask = rhs
End Property

Private Property Get cIABMProperty_TextMask() As String
  cIABMProperty_TextMask = m_TextMask
End Property

Private Property Let cIABMProperty_TopFrame(ByVal rhs As Integer)
  m_TopFrame = rhs
End Property

Private Property Get cIABMProperty_TopFrame() As Integer
  cIABMProperty_TopFrame = m_TopFrame
End Property

Private Property Let cIABMProperty_TopFromProperty(ByVal rhs As String)
  m_TopFromProperty = rhs
End Property

Private Property Get cIABMProperty_TopFromProperty() As String
  cIABMProperty_TopFromProperty = m_TopFromProperty
End Property

Private Property Let cIABMProperty_TopNotChange(ByVal rhs As Boolean)
  m_TopNotChange = rhs
End Property

Private Property Get cIABMProperty_TopNotChange() As Boolean
  cIABMProperty_TopNotChange = m_TopNotChange
End Property

Private Property Let cIABMProperty_Value(ByVal rhs As String)
  Select Case m_Type
    Case csTypeABMProperty.cspCheck, csTypeABMProperty.cspOption
      m_Value = CInt(CBool(rhs))
    Case csTypeABMProperty.cspNumeric
      If Not IsNumeric(rhs) Then Err.Raise csErrorInvalidPropertyValue, "CSOAPI", "SetInfoString_: Valor invalido para una propiedad numerica (" & rhs & ")."
      m_Value = rhs
    Case csTypeABMProperty.cspProgressBar
      If Val(m_Value) < 0 Then
        m_Value = 0
      ElseIf Val(m_Value) > 100 Then
        m_Value = 100
      Else
        m_Value = Val(rhs)
      End If
    Case Else
      m_Value = rhs
  End Select
End Property

Private Property Get cIABMProperty_Value() As String
  Select Case m_Type
    Case csTypeABMProperty.cspCheck, csTypeABMProperty.cspOption
      If Not IsNumeric(m_Value) Then
        If m_Value = "" Then
          cIABMProperty_Value = 0
        Else
          cIABMProperty_Value = CInt(CBool(m_Value))
        End If
      Else
        cIABMProperty_Value = CInt(CBool(m_Value))
      End If
    Case csTypeABMProperty.cspProgressBar
      cIABMProperty_Value = Val(m_Value)
    Case Else
      cIABMProperty_Value = m_Value
  End Select
End Property

Private Property Get cIABMProperty_Top() As Integer
  cIABMProperty_Top = m_Top
End Property

Public Property Let cIABMProperty_Top(ByVal rhs As Integer)
  m_Top = rhs
End Property

Public Property Get Top() As Integer
  Top = m_nTop
End Property

Public Property Let Top(ByVal rhs As Integer)
  m_nTop = rhs
End Property

Public Property Get Left() As Integer
  Left = m_nLeft
End Property

Public Property Let Left(ByVal rhs As Integer)
  m_nLeft = rhs
End Property

Public Property Get Width() As Integer
  Width = m_nWidth
End Property

Public Property Let Width(ByVal rhs As Integer)
  m_nWidth = rhs
End Property

Public Property Get Height() As Integer
  Height = m_nHeight
End Property

Public Property Let Height(ByVal rhs As Integer)
  m_nHeight = rhs
End Property

Private Property Get cIABMProperty_Left() As Integer
  cIABMProperty_Left = m_Left
End Property

Public Property Let cIABMProperty_Left(ByVal rhs As Integer)
  m_Left = rhs
End Property

Private Property Let cIABMProperty_Visible(ByVal rhs As Boolean)
  m_Visible = rhs
End Property

Private Property Get cIABMProperty_Visible() As Boolean
  cIABMProperty_Visible = m_Visible
End Property

Private Property Get cIABMProperty_Width() As Integer
  cIABMProperty_Width = m_Width
End Property

Public Property Let cIABMProperty_Width(ByVal rhs As Integer)
  m_Width = rhs
End Property

Private Property Get cIABMProperty_Height() As Integer
  cIABMProperty_Height = m_Height
End Property

Public Property Let cIABMProperty_Height(ByVal rhs As Integer)
  m_Height = rhs
End Property

Private Property Get cIABMProperty_TopToPrevious() As Integer
  cIABMProperty_TopToPrevious = m_TopToPrevious
End Property

Public Property Let cIABMProperty_TopToPrevious(ByVal rhs As Integer)
  m_TopToPrevious = rhs
End Property

Private Property Get cIABMProperty_FontName() As String
  cIABMProperty_FontName = m_FontName
End Property

Public Property Let cIABMProperty_FontName(ByVal rhs As String)
  m_FontName = rhs
End Property

Private Property Get cIABMProperty_FontSize() As Single
  cIABMProperty_FontSize = m_FontSize
End Property

Public Property Let cIABMProperty_FontSize(ByVal rhs As Single)
  m_FontSize = rhs
End Property

Private Property Get cIABMProperty_FontBold() As Boolean
  cIABMProperty_FontBold = m_FontBold
End Property

Public Property Let cIABMProperty_FontBold(ByVal rhs As Boolean)
  m_FontBold = rhs
End Property

Private Property Get cIABMProperty_FontUnderLine() As Boolean
  cIABMProperty_FontUnderLine = m_FontUnderline
End Property

Public Property Let cIABMProperty_FontUnderLine(ByVal rhs As Boolean)
  m_FontUnderline = rhs
End Property

Private Property Get cIABMProperty_FontItalic() As Boolean
  cIABMProperty_FontItalic = m_FontItalic
End Property

Public Property Let cIABMProperty_FontItalic(ByVal rhs As Boolean)
  m_FontItalic = rhs
End Property

Private Property Get cIABMProperty_ForeColor() As Long
  cIABMProperty_ForeColor = m_ForeColor
End Property

Public Property Let cIABMProperty_ForeColor(ByVal rhs As Long)
  m_ForeColor = rhs
End Property

Private Property Get cIABMProperty_BackColor() As Long
  cIABMProperty_BackColor = m_BackColor
End Property

Public Property Let cIABMProperty_BackColor(ByVal rhs As Long)
  m_BackColor = rhs
End Property

Public Property Get ctl() As Object
  Set ctl = m_Ctl
End Property

Public Property Set ctl(ByRef rhs As Object)
  Set m_Ctl = rhs
End Property

Private Property Get cIABMProperty_ListText() As String
  cIABMProperty_ListText = m_ListText
End Property

Public Property Let cIABMProperty_ListText(ByVal rhs As String)
  m_ListText = rhs
End Property

Private Property Get cIABMProperty_ListListIndex() As Integer
  cIABMProperty_ListListIndex = m_ListListIndex
End Property

Public Property Let cIABMProperty_ListListIndex(ByVal rhs As Integer)
  m_ListListIndex = rhs
End Property

Private Property Get cIABMProperty_ListItemData() As Long
  cIABMProperty_ListItemData = m_ListItemData
End Property

Public Property Let cIABMProperty_ListItemData(ByVal rhs As Long)
  m_ListItemData = rhs
End Property

Private Property Get cIABMProperty_ListWhoSetItem() As csListWhoSetItem
  cIABMProperty_ListWhoSetItem = m_ListWhoSetItem
End Property

Public Property Let cIABMProperty_ListWhoSetItem(ByVal rhs As csListWhoSetItem)
  m_ListWhoSetItem = rhs
End Property

Public Property Get HelpType() As csHelpType
  HelpType = m_HelpType
End Property

Public Property Let HelpType(ByVal rhs As csHelpType)
  m_HelpType = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  m_Top = -1
  m_Left = -1
  m_ForeColor = -1
  m_BackColor = -1
  m_Enabled = True
  m_TextAlign = vbLeftJustify
  m_Visible = True
  m_IsEditProperty = True
End Sub

Private Sub Class_Terminate()
  Set m_Grid = Nothing
  Set m_Ctl = Nothing
End Sub

