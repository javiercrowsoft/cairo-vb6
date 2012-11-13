VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cIABMProperty"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cIABMProperty
' 03-01-01

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
' Properties publicas
Public Property Get Name() As String
End Property
Public Property Let Name(ByVal rhs As String)
End Property
Public Property Get Value() As String
End Property
Public Property Let Value(ByVal rhs As String)
End Property
Public Property Get PropertyType() As csTypeABMProperty
End Property
Public Property Let PropertyType(ByVal rhs As csTypeABMProperty)
End Property
Public Property Get SubType() As csSubTypeABMProperty
End Property
Public Property Let SubType(ByVal rhs As csSubTypeABMProperty)
End Property
Public Property Get Table() As csTables
End Property
Public Property Let Table(ByVal rhs As csTables)
End Property
Public Property Let Size(ByVal rhs As Integer)
End Property
Public Property Get Size() As Integer
End Property
Public Property Let OptionGroup(ByVal rhs As Integer)
End Property
Public Property Get OptionGroup() As Integer
End Property
Public Property Let List(ByVal rhs As cIABMList)
End Property
Public Property Get List() As cIABMList
End Property
Public Property Let HelpId(ByVal rhs As Long)
End Property
Public Property Get HelpId() As Long
End Property
Public Property Let HelpFilter(ByVal rhs As String)
End Property
Public Property Get HelpFilter() As String
End Property
Public Property Let HelpValueProcess(ByVal rhs As String)
End Property
Public Property Get HelpValueProcess() As String
End Property
Public Property Let HelpFieldValueProcess(ByVal rhs As String)
End Property
Public Property Get HelpFieldValueProcess() As String
End Property

Public Property Let HelpSPFilter(ByVal rhs As String)
End Property
Public Property Get HelpSPFilter() As String
End Property

Public Property Let HelpSPInfoFilter(ByVal rhs As String)
End Property
Public Property Get HelpSPInfoFilter() As String
End Property

Public Property Let Key(ByVal rhs As Integer)
End Property
Public Property Get Key() As Integer
End Property
Public Property Get TabIndex() As Integer
End Property
Public Property Let TabIndex(ByVal rhs As Integer)
End Property
Public Property Get Enabled() As Boolean
End Property
Public Property Let Enabled(ByVal rhs As Boolean)
End Property

Public Property Get Grid() As cIABMGrid
End Property

Public Property Let GridAdd(ByVal rhs As Boolean)
End Property
Public Property Let GridRemove(ByVal rhs As Boolean)
End Property
Public Property Let GridEdit(ByVal rhs As Boolean)
End Property

Public Property Get GridAdd() As Boolean
End Property
Public Property Get GridRemove() As Boolean
End Property
Public Property Get GridEdit() As Boolean
End Property

Public Property Get Top() As Integer
End Property
Public Property Let Top(ByVal rhs As Integer)
End Property
Public Property Get Left() As Integer
End Property
Public Property Let Left(ByVal rhs As Integer)
End Property
Public Property Get LeftToPrevious() As Integer
End Property
Public Property Let LeftToPrevious(ByVal rhs As Integer)
End Property
Public Property Get LeftFromProperty() As String
End Property
Public Property Let LeftFromProperty(ByVal rhs As String)
End Property
Public Property Get LeftLabel() As Integer
End Property
Public Property Let LeftLabel(ByVal rhs As Integer)
End Property
Public Property Get LeftFrame() As Integer
End Property
Public Property Let LeftFrame(ByVal rhs As Integer)
End Property
Public Property Get LeftNotChange() As Boolean
End Property
Public Property Let LeftNotChange(ByVal rhs As Boolean)
End Property
Public Property Get TopNotChange() As Boolean
End Property
Public Property Let TopNotChange(ByVal rhs As Boolean)
End Property
Public Property Get Width() As Integer
End Property
Public Property Let Width(ByVal rhs As Integer)
End Property
Public Property Get Height() As Integer
End Property
Public Property Let Height(ByVal rhs As Integer)
End Property
Public Property Get TopToPrevious() As Integer
End Property
Public Property Let TopToPrevious(ByVal rhs As Integer)
End Property
Public Property Get TopFromProperty() As String
End Property
Public Property Let TopFromProperty(ByVal rhs As String)
End Property
Public Property Get TopFrame() As Integer
End Property
Public Property Let TopFrame(ByVal rhs As Integer)
End Property
Public Property Get Buttons() As String
End Property
Public Property Let Buttons(ByVal rhs As String)
End Property
Public Property Get SelectedIndex() As Long
End Property
Public Property Let SelectedIndex(ByVal rhs As Long)
End Property

Public Property Get FontName() As String
End Property
Public Property Let FontName(ByVal rhs As String)
End Property
Public Property Get FontSize() As Single
End Property
Public Property Let FontSize(ByVal rhs As Single)
End Property
Public Property Get FontBold() As Boolean
End Property
Public Property Let FontBold(ByVal rhs As Boolean)
End Property
Public Property Get FontUnderLine() As Boolean
End Property
Public Property Let FontUnderLine(ByVal rhs As Boolean)
End Property
Public Property Get FontItalic() As Boolean
End Property
Public Property Let FontItalic(ByVal rhs As Boolean)
End Property
Public Property Get ForeColor() As Long
End Property
Public Property Let ForeColor(ByVal rhs As Long)
End Property
Public Property Get BackColor() As Long
End Property
Public Property Let BackColor(ByVal rhs As Long)
End Property

Public Property Get Picture() As IPictureDisp
End Property
Public Property Set Picture(ByVal rhs As IPictureDisp)
End Property

Public Property Get ListText() As String
End Property
Public Property Let ListText(ByVal rhs As String)
End Property
Public Property Get ListListIndex() As Integer
End Property
Public Property Let ListListIndex(ByVal rhs As Integer)
End Property
Public Property Get ListItemData() As Long
End Property
Public Property Let ListItemData(ByVal rhs As Long)
End Property
Public Property Get ListWhoSetItem() As csListWhoSetItem
End Property
Public Property Let ListWhoSetItem(ByVal rhs As csListWhoSetItem)
End Property

Public Property Get TextAlign() As AlignmentConstants
End Property
Public Property Let TextAlign(ByVal rhs As AlignmentConstants)
End Property

Public Property Get TextMask() As String
End Property
Public Property Let TextMask(ByVal rhs As String)
End Property

Public Property Get Format() As String
End Property
Public Property Let Format(ByVal rhs As String)
End Property

Public Property Get Visible() As Boolean
End Property
Public Property Let Visible(ByVal rhs As Boolean)
End Property

' Properties privadas
' funciones publicas
' funciones privadas
' construccion - destruccion
