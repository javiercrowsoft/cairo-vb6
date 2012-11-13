VERSION 5.00
Begin VB.UserControl cComboBox 
   ClientHeight    =   1815
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   2085
   ScaleHeight     =   1815
   ScaleWidth      =   2085
   ToolboxBitmap   =   "cComboBox.ctx":0000
   Begin VB.ComboBox cbCombo1 
      Height          =   315
      Left            =   60
      Sorted          =   -1  'True
      Style           =   2  'Dropdown List
      TabIndex        =   0
      Top             =   60
      Width           =   1215
   End
End
Attribute VB_Name = "cComboBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Enum csComboStyle
  csCbList = 1
  csCbCombo = 2
End Enum

Private m_cFlatten As cFlatControl

Private m_Style As csComboStyle

'Event Declarations:
Event Click() 'MappingInfo=cbCombo,cbCombo1,-1,Click
Event DblClick() 'MappingInfo=cbCombo,cbCombo1,-1,DblClick
Event KeyDown(KeyCode As Integer, Shift As Integer) 'MappingInfo=cbCombo,cbCombo1,-1,KeyDown
Event KeyPress(KeyAscii As Integer) 'MappingInfo=cbCombo,cbCombo1,-1,KeyPress
Event KeyUp(KeyCode As Integer, Shift As Integer) 'MappingInfo=cbCombo,cbCombo1,-1,KeyUp
Event Change() 'MappingInfo=cbCombo,cbCombo1,-1,Change
Event OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, y As Single) 'MappingInfo=cbCombo,cbCombo1,-1,OLEDragDrop
Event OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, y As Single, State As Integer) 'MappingInfo=cbCombo,cbCombo1,-1,OLEDragOver
Event OLECompleteDrag(Effect As Long) 'MappingInfo=cbCombo,cbCombo1,-1,OLECompleteDrag
Event Validate(Cancel As Boolean) 'MappingInfo=cbCombo,cbCombo1,-1,Validate

Private Sub UserControl_Initialize()
  On Error Resume Next
  
  Set m_cFlatten = New cFlatControl
  m_cFlatten.Attach cbCombo1
  StyleEx = csCbList
End Sub

Private Sub UserControl_Resize()
  On Error Resume Next
  cbCombo1.Move 0, 0, UserControl.ScaleWidth
  UserControl.Height = cbCombo1.Height
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,BackColor
Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_Description = "Returns/sets the background color used to display text and graphics in an object."
  On Error Resume Next
  BackColor = cbCombo1.BackColor
End Property

Public Property Let BackColor(ByVal New_BackColor As OLE_COLOR)
  On Error Resume Next
  cbCombo1.BackColor = New_BackColor
  PropertyChanged "BackColor"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,ForeColor
Public Property Get ForeColor() As OLE_COLOR
Attribute ForeColor.VB_Description = "Returns/sets the foreground color used to display text and graphics in an object."
  On Error Resume Next
  ForeColor = cbCombo1.ForeColor
End Property

Public Property Let ForeColor(ByVal New_ForeColor As OLE_COLOR)
  On Error Resume Next
  cbCombo1.ForeColor() = New_ForeColor
  PropertyChanged "ForeColor"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,Enabled
Public Property Get Enabled() As Boolean
Attribute Enabled.VB_Description = "Returns/sets a value that determines whether an object can respond to user-generated events."
  On Error Resume Next
  Enabled = cbCombo1.Enabled
End Property

Public Property Let Enabled(ByVal New_Enabled As Boolean)
  On Error Resume Next
  cbCombo1.Enabled() = New_Enabled
  PropertyChanged "Enabled"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,Font
Public Property Get Font() As Font
Attribute Font.VB_Description = "Returns a Font object."
Attribute Font.VB_UserMemId = -512
  On Error Resume Next
  Set Font = cbCombo1.Font
End Property

Public Property Set Font(ByVal New_Font As Font)
  On Error Resume Next
  Set cbCombo1.Font = New_Font
  PropertyChanged "Font"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,Refresh
Public Sub Refresh()
Attribute Refresh.VB_Description = "Forces a complete repaint of a object."
  On Error Resume Next
  cbCombo1.Refresh
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,AddItem
Public Sub AddItem(ByVal Item As String, Optional ByVal Index As Variant)
Attribute AddItem.VB_Description = "Adds an item to a Listbox or ComboBox control or a row to a Grid control."
  On Error Resume Next
  cbCombo1.AddItem Item, Index
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,hWnd
Public Property Get hwnd() As Long
Attribute hwnd.VB_Description = "Returns a handle (from Microsoft Windows) to an object's window."
  On Error Resume Next
  hwnd = cbCombo1.hwnd
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,ItemData
Public Property Get ItemData(ByVal Index As Integer) As Long
Attribute ItemData.VB_Description = "Returns/sets a specific number for each item in a ComboBox or ListBox control."
  On Error Resume Next
  ItemData = cbCombo1.ItemData(Index)
End Property

Public Property Let ItemData(ByVal Index As Integer, ByVal New_ItemData As Long)
  On Error Resume Next
  cbCombo1.ItemData(Index) = New_ItemData
  PropertyChanged "ItemData"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,ListCount
Public Property Get ListCount() As Integer
Attribute ListCount.VB_Description = "Returns the number of items in the list portion of a control."
  On Error Resume Next
  ListCount = cbCombo1.ListCount
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,ListIndex
Public Property Get ListIndex() As Integer
Attribute ListIndex.VB_Description = "Returns/sets the index of the currently selected item in the control."
Attribute ListIndex.VB_MemberFlags = "400"
  On Error Resume Next
  ListIndex = cbCombo1.ListIndex
End Property

Public Property Let ListIndex(ByVal New_ListIndex As Integer)
  On Error Resume Next
  cbCombo1.ListIndex() = New_ListIndex
  PropertyChanged "ListIndex"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,Locked
Public Property Get Locked() As Boolean
Attribute Locked.VB_Description = "Determines whether a control can be edited."
  On Error Resume Next
  Locked = cbCombo1.Locked
End Property

Public Property Let Locked(ByVal New_Locked As Boolean)
  On Error Resume Next
  cbCombo1.Locked() = New_Locked
  PropertyChanged "Locked"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,MouseIcon
Public Property Get MouseIcon() As Picture
Attribute MouseIcon.VB_Description = "Sets a custom mouse icon."
  On Error Resume Next
  Set MouseIcon = cbCombo1.MouseIcon
End Property

Public Property Set MouseIcon(ByVal New_MouseIcon As Picture)
  On Error Resume Next
  Set cbCombo1.MouseIcon = New_MouseIcon
  PropertyChanged "MouseIcon"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,MousePointer
Public Property Get MousePointer() As Integer
Attribute MousePointer.VB_Description = "Returns/sets the type of mouse pointer displayed when over part of an object."
  On Error Resume Next
  MousePointer = cbCombo1.MousePointer
End Property

Public Property Let MousePointer(ByVal New_MousePointer As Integer)
  On Error Resume Next
  cbCombo1.MousePointer() = New_MousePointer
  PropertyChanged "MousePointer"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,NewIndex
Public Property Get NewIndex() As Integer
Attribute NewIndex.VB_Description = "Returns the index of the item most recently added to a control."
  On Error Resume Next
  NewIndex = cbCombo1.NewIndex
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,OLEDragMode
Public Property Get OLEDragMode() As Integer
Attribute OLEDragMode.VB_Description = "Returns/Sets whether this object can act as an OLE drag/drop source, and whether this process is started automatically or under programmatic control."
  On Error Resume Next
  OLEDragMode = cbCombo1.OLEDragMode
End Property

Public Property Let OLEDragMode(ByVal New_OLEDragMode As Integer)
  On Error Resume Next
  cbCombo1.OLEDragMode() = New_OLEDragMode
  PropertyChanged "OLEDragMode"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,OLEDropMode
Public Property Get OLEDropMode() As Integer
Attribute OLEDropMode.VB_Description = "Returns/Sets whether this object can act as an OLE drop target."
  On Error Resume Next
  OLEDropMode = cbCombo1.OLEDropMode
End Property

Public Property Let OLEDropMode(ByVal New_OLEDropMode As Integer)
  On Error Resume Next
  cbCombo1.OLEDropMode() = New_OLEDropMode
  PropertyChanged "OLEDropMode"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,OLEDrag
Public Sub OLEDrag()
Attribute OLEDrag.VB_Description = "Starts an OLE drag/drop event with the given control as the source."
  On Error Resume Next
  cbCombo1.OLEDrag
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,RightToLeft
Public Property Get RightToLeft() As Boolean
Attribute RightToLeft.VB_Description = "Determines text display direction and control visual appearance on a bidirectional system."
  On Error Resume Next
  RightToLeft = cbCombo1.RightToLeft
End Property

Public Property Let RightToLeft(ByVal New_RightToLeft As Boolean)
  On Error Resume Next
  cbCombo1.RightToLeft() = New_RightToLeft
  PropertyChanged "RightToLeft"
End Property

Public Property Get Style() As Integer
  On Error Resume Next
  Style = cbCombo1.Style
End Property

Public Property Get StyleEx() As csComboStyle
  On Error Resume Next
  StyleEx = m_Style
End Property

Public Property Let StyleEx(ByVal RHS As csComboStyle)
  On Error Resume Next
  m_Style = RHS
  PropertyChanged "StyleEx"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,Text
Public Property Get Text() As String
Attribute Text.VB_Description = "Returns/sets the text contained in the control."
  On Error Resume Next
  Text = cbCombo1.Text
End Property

Public Property Let Text(ByVal New_Text As String)
  On Error Resume Next
  cbCombo1.Text() = New_Text
  PropertyChanged "Text"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,ToolTipText
Public Property Get ToolTipText() As String
Attribute ToolTipText.VB_Description = "Returns/sets the text displayed when the mouse is paused over the control."
  On Error Resume Next
  ToolTipText = cbCombo1.ToolTipText
End Property

Public Property Let ToolTipText(ByVal New_ToolTipText As String)
  On Error Resume Next
  cbCombo1.ToolTipText() = New_ToolTipText
  PropertyChanged "ToolTipText"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,CausesValidation
Public Property Get CausesValidation() As Boolean
Attribute CausesValidation.VB_Description = "Returns/sets whether validation occurs on the control which lost focus."
  On Error Resume Next
  CausesValidation = cbCombo1.CausesValidation
End Property

Public Property Let CausesValidation(ByVal New_CausesValidation As Boolean)
  On Error Resume Next
  cbCombo1.CausesValidation() = New_CausesValidation
  PropertyChanged "CausesValidation"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,DataMember
Public Property Get DataMember() As String
Attribute DataMember.VB_Description = "Returns/sets a value that describes the DataMember for a data connection."
  On Error Resume Next
  DataMember = cbCombo1.DataMember
End Property

Public Property Let DataMember(ByVal New_DataMember As String)
  On Error Resume Next
  cbCombo1.DataMember() = New_DataMember
  PropertyChanged "DataMember"
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,List
Public Property Get List(ByVal Index As Integer) As String
Attribute List.VB_Description = "Returns/sets the items contained in a control's list portion."
  On Error Resume Next
  List = cbCombo1.List(Index)
End Property

Public Property Let List(ByVal Index As Integer, ByVal New_List As String)
  On Error Resume Next
  cbCombo1.List(Index) = New_List
  PropertyChanged "List"
End Property

'Load property values from storage
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
  On Error Resume Next

  StyleEx = PropBag.ReadProperty("StyleEx", csCbList)
  cbCombo1.BackColor = PropBag.ReadProperty("BackColor", &H80000005)
  cbCombo1.ForeColor = PropBag.ReadProperty("ForeColor", &H80000008)
  cbCombo1.Enabled = PropBag.ReadProperty("Enabled", True)
  Set cbCombo1.Font = PropBag.ReadProperty("Font", Ambient.Font)
  cbCombo1.ListIndex = PropBag.ReadProperty("ListIndex", 0)
  cbCombo1.Locked = PropBag.ReadProperty("Locked", False)
  Set MouseIcon = PropBag.ReadProperty("MouseIcon", Nothing)
  cbCombo1.MousePointer = PropBag.ReadProperty("MousePointer", 0)
  cbCombo1.OLEDragMode = PropBag.ReadProperty("OLEDragMode", 0)
  cbCombo1.OLEDropMode = PropBag.ReadProperty("OLEDropMode", 0)
  cbCombo1.RightToLeft = PropBag.ReadProperty("RightToLeft", False)
  cbCombo1.Text = PropBag.ReadProperty("Text", "Combo1")
  cbCombo1.ToolTipText = PropBag.ReadProperty("ToolTipText", "")
  cbCombo1.CausesValidation = PropBag.ReadProperty("CausesValidation", True)
  cbCombo1.DataMember = PropBag.ReadProperty("DataMember", "")
End Sub

Private Sub UserControl_Terminate()
  On Error Resume Next
  Set m_cFlatten = Nothing
  Err.Clear
End Sub

'Write property values to storage
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
  On Error Resume Next

  Call PropBag.WriteProperty("StyleEx", StyleEx, csCbList)
  Call PropBag.WriteProperty("BackColor", cbCombo1.BackColor, &H80000005)
  Call PropBag.WriteProperty("ForeColor", cbCombo1.ForeColor, &H80000008)
  Call PropBag.WriteProperty("Enabled", cbCombo1.Enabled, True)
  Call PropBag.WriteProperty("Font", cbCombo1.Font, Ambient.Font)
  Call PropBag.WriteProperty("ListIndex", cbCombo1.ListIndex, 0)
  Call PropBag.WriteProperty("Locked", cbCombo1.Locked, False)
  Call PropBag.WriteProperty("MouseIcon", MouseIcon, Nothing)
  Call PropBag.WriteProperty("MousePointer", cbCombo1.MousePointer, 0)
  Call PropBag.WriteProperty("OLEDragMode", cbCombo1.OLEDragMode, 0)
  Call PropBag.WriteProperty("OLEDropMode", cbCombo1.OLEDropMode, 0)
  Call PropBag.WriteProperty("RightToLeft", cbCombo1.RightToLeft, False)
  Call PropBag.WriteProperty("Text", cbCombo1.Text, "Combo1")
  Call PropBag.WriteProperty("ToolTipText", cbCombo1.ToolTipText, "")
  Call PropBag.WriteProperty("CausesValidation", cbCombo1.CausesValidation, True)
  Call PropBag.WriteProperty("DataMember", cbCombo1.DataMember, "")
  
  Err.Clear
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,Sorted
Public Property Get Sorted() As Boolean
Attribute Sorted.VB_Description = "Indicates whether the elements of a control are automatically sorted alphabetically."
  On Error Resume Next
  Sorted = cbCombo1.Sorted
End Property

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,RemoveItem
Public Sub RemoveItem(ByVal Index As Integer)
Attribute RemoveItem.VB_Description = "Removes an item from a ListBox or ComboBox control or a row from a Grid control."
  cbCombo1.RemoveItem Index
End Sub

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MappingInfo=cbCombo,cbCombo1,-1,Clear
Public Sub Clear()
Attribute Clear.VB_Description = "Clears the contents of a control or the system Clipboard."
  cbCombo1.Clear
End Sub

'///////////////////////////////////////////////////////////////
Private Sub cbCombo1_Click()
  On Error Resume Next
  RaiseEvent Click
End Sub

Private Sub cbCombo1_DblClick()
  On Error Resume Next
  RaiseEvent DblClick
End Sub

Private Sub cbCombo1_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  RaiseEvent KeyDown(KeyCode, Shift)
End Sub

Private Sub cbCombo1_KeyPress(KeyAscii As Integer)
  On Error Resume Next
  RaiseEvent KeyPress(KeyAscii)
End Sub

Private Sub cbCombo1_KeyUp(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  RaiseEvent KeyUp(KeyCode, Shift)
End Sub

Private Sub cbCombo1_Change()
  On Error Resume Next
  RaiseEvent Change
End Sub

Private Sub cbCombo1_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error Resume Next
  RaiseEvent OLEDragDrop(Data, Effect, Button, Shift, x, y)
End Sub

Private Sub cbCombo1_OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, y As Single, State As Integer)
  On Error Resume Next
  RaiseEvent OLEDragOver(Data, Effect, Button, Shift, x, y, State)
End Sub

Private Sub cbCombo1_OLECompleteDrag(Effect As Long)
  On Error Resume Next
  RaiseEvent OLECompleteDrag(Effect)
End Sub

Private Sub cbCombo1_Validate(Cancel As Boolean)
  On Error Resume Next
  RaiseEvent Validate(Cancel)
End Sub

'//////////////////////////////////////////////////////////////////////////////

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

