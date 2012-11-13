VERSION 5.00
Object = "{600443F6-6F00-4B3F-BEB8-92D0CDADE10D}#4.3#0"; "CSMaskEdit.ocx"
Object = "{D5E078F9-5926-4845-9172-73CD66955B2C}#2.4#0"; "CSGrid.ocx"
Object = "{C3B62925-B0EA-11D7-8204-00D0090360E2}#7.2#0"; "CSComboBox.ocx"
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Begin VB.UserControl cGridAdvanced 
   ClientHeight    =   5115
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   8565
   ScaleHeight     =   5115
   ScaleWidth      =   8565
   Begin VB.Timer tmCombo 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   960
      Top             =   3480
   End
   Begin CSImageList.cImageList imlMain 
      Left            =   6255
      Top             =   1350
      _ExtentX        =   953
      _ExtentY        =   953
      Size            =   1880
      Images          =   "cGridAdvanced.ctx":0000
      KeyCount        =   2
      Keys            =   "ÿ"
   End
   Begin CSComboBox.cComboBox ctlCB 
      Height          =   315
      Left            =   3060
      TabIndex        =   7
      Top             =   2940
      Visible         =   0   'False
      Width           =   2295
      _ExtentX        =   4048
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ListIndex       =   -1
      Text            =   ""
   End
   Begin CSComboBox.cComboBox ctlCBhock 
      Height          =   315
      Left            =   3060
      TabIndex        =   6
      Top             =   3420
      Visible         =   0   'False
      Width           =   2295
      _ExtentX        =   4048
      _ExtentY        =   556
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ListIndex       =   -1
      Text            =   ""
   End
   Begin CSGrid.cGrid grCtrl 
      Height          =   2400
      Left            =   90
      TabIndex        =   0
      Top             =   135
      Width           =   2535
      _ExtentX        =   4471
      _ExtentY        =   4233
      BackgroundPictureHeight=   0
      BackgroundPictureWidth=   0
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      DisableIcons    =   -1  'True
   End
   Begin CSMaskEdit.cMaskEdit ctlMKE 
      Height          =   285
      Left            =   3060
      TabIndex        =   1
      Top             =   540
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   503
      Alignment       =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      EnabledNoChngBkColor=   0   'False
      Text            =   "$ 0.00"
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit.cMaskEdit ctlMEFE 
      Height          =   285
      Left            =   3060
      TabIndex        =   2
      Top             =   2160
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   503
      Alignment       =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      EnabledNoChngBkColor=   0   'False
      Text            =   "01/01/1900"
      csType          =   6
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSControls.cHelp ctlHL 
      Height          =   285
      Left            =   3060
      TabIndex        =   3
      Top             =   135
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      ButtonStyle     =   0
   End
   Begin CSMaskEdit.cMaskEdit ctlTXPassword 
      Height          =   285
      Left            =   3060
      TabIndex        =   4
      Top             =   945
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit.cMaskEdit ctlTX 
      Height          =   285
      Left            =   3060
      TabIndex        =   5
      Top             =   2565
      Visible         =   0   'False
      Width           =   2265
      _ExtentX        =   3995
      _ExtentY        =   503
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "MS Sans Serif"
      FontSize        =   8.25
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
End
Attribute VB_Name = "cGridAdvanced"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cGridAdvanced
' 15-05-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cGridAdvanced"

Private Const c_Left = 1
Private Const c_Right = 2
Private Const c_Up = 3
Private Const c_Down = 4
' estructuras
' variables privadas

Private WithEvents m_Columns                       As cGridColumns
Attribute m_Columns.VB_VarHelpID = -1

Private m_lRowEditing                              As Long
Private m_lColEditing                              As Long
Private m_Editing                                  As Boolean

Private m_Ctl                                      As Control

Private m_SecondTime                               As Boolean
Private m_LastKeyRow                               As Integer

Private m_focusInMe                                As Boolean
Private m_GridLines                                As Long

' eventos
Public Event ColumnBeforeEdit(ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, ByRef bCancel As Boolean)
Public Event ColumnAfterEdit(ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long, ByRef bCancel As Boolean)
Public Event ColumnAfterUpdate(ByVal lRow As Long, ByVal lCol As Long, ByVal NewValue As Variant, ByVal NewValueID As Long)
Public Event ColumnCancelEdit()
Public Event ColumnButtonClick(ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, ByRef bCancel As Boolean)
Public Event ColumnClick(ByVal lCol As Long)
Public Event FillsListAdHok(ByRef cbList As Object)
Public Event ValidateRow(ByVal lRow As Long, ByRef bCancel As Boolean)
Public Event NewRow(ByVal lRow As Long)
Public Event DeleteRow(ByVal lRow As Long, ByRef bCancel As Boolean)
Public Event DblClick(ByVal lRow As Long, ByVal lCol As Long)
Public Event SelectionChange(ByVal lRow As Long, ByVal lCol As Long)
Public Event MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single, bDoDefault As Boolean)

' propiedadades publicas
Public Property Get Editable() As Boolean
  Editable = grCtrl.Editable
End Property

Public Property Let Editable(ByVal rhs As Boolean)
  grCtrl.Editable = rhs
End Property

Public Property Get Columns() As cGridColumns
   Set Columns = m_Columns
End Property

Public Property Set Columns(ByRef rhs As cGridColumns)
   Set m_Columns = rhs
End Property

Public Property Get RowForeColor(ByVal lRow As Long) As Long
  RowForeColor = grCtrl.CellForeColor(lRow, 1)
End Property

Public Property Let RowForeColor(ByVal lRow As Long, ByVal rhs As Long)
  On Error GoTo ControlError
  
  Dim iCol As Long
  Dim OldRedraw As Boolean
  
  OldRedraw = grCtrl.Redraw
  grCtrl.Redraw = False
  For iCol = 1 To grCtrl.Columns
    grCtrl.CellForeColor(lRow, iCol) = rhs
  Next

  GoTo ExitProc
ControlError:
  MngError Err, "RowForeColor", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  grCtrl.Redraw = OldRedraw
End Property

Public Property Get RowBackColor(ByVal lRow As Long) As Long
  RowBackColor = grCtrl.CellBackColor(lRow, 1)
End Property

Public Property Let RowBackColor(ByVal lRow As Long, ByVal rhs As Long)
  On Error GoTo ControlError
  
  Dim iCol As Long
  Dim OldRedraw As Boolean
  
  OldRedraw = grCtrl.Redraw
  grCtrl.Redraw = False
  For iCol = 1 To grCtrl.Columns
    grCtrl.CellBackColor(lRow, iCol) = rhs
  Next

  GoTo ExitProc
ControlError:
  MngError Err, "grCtrl_DeleteCellValue", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  grCtrl.Redraw = OldRedraw
End Property

Public Property Get RowVisible(ByVal lRow As Long) As Boolean
  RowVisible = grCtrl.RowVisible(lRow)
End Property

Public Property Let RowVisible(ByVal lRow As Long, ByVal rhs As Boolean)
  grCtrl.RowVisible(lRow) = rhs
End Property

Public Property Get Rows() As Long
  Rows = grCtrl.Rows
End Property

Public Property Let Rows(ByVal rhs As Long)
  Dim iRow As Long
  grCtrl.Rows = rhs
  
  For iRow = 1 To grCtrl.Rows
    pSetFormatCells iRow
  Next
End Property

Public Property Get BackColor() As OLE_COLOR
  BackColor = grCtrl.BackColor
End Property

Public Property Let BackColor(ByVal rhs As OLE_COLOR)
  grCtrl.BackColor = rhs
End Property

Public Property Get DrawFocusRectangle() As Boolean
  DrawFocusRectangle = grCtrl.DrawFocusRectangle
End Property

Public Property Let DrawFocusRectangle(ByVal rhs As Boolean)
  grCtrl.DrawFocusRectangle = rhs
End Property

Public Property Get GridLines() As Boolean
  GridLines = grCtrl.GridLines
End Property

Public Property Let GridLines(ByVal rhs As Boolean)
  m_GridLines = rhs
  grCtrl.GridLines = rhs
End Property

Public Property Get SelectedRow() As Long
  SelectedRow = grCtrl.SelectedRow
End Property

Public Property Let SelectedRow(ByVal rhs As Long)
  grCtrl.SelectedRow = rhs
End Property

Public Property Get SelectedCol() As Long
  SelectedCol = grCtrl.SelectedCol
End Property

Public Property Let SelectedCol(ByVal rhs As Long)
  grCtrl.SelectedCol = rhs
End Property

Public Property Get Cell(ByVal lRow As Long, ByVal lCol As Long) As cGridCell
  Set Cell = grCtrl.Cell(lRow, lCol)
End Property

Public Property Let Redraw(ByVal rhs As Boolean)
  grCtrl.Redraw = rhs
  grCtrl.Draw
End Property

Public Property Get MultiSelect() As Boolean
  MultiSelect = grCtrl.MultiSelect
End Property

Public Property Let MultiSelect(ByVal rhs As Boolean)
  grCtrl.MultiSelect = rhs
End Property

Public Property Get BorderStyle() As csGridBorderStyleEnum
  BorderStyle = grCtrl.BorderStyle
End Property
  
Public Property Let BorderStyle(ByVal rhs As csGridBorderStyleEnum)
  grCtrl.BorderStyle = rhs
End Property
   
Public Property Get HeaderDragReOrderColumns() As Boolean
  HeaderDragReOrderColumns = grCtrl.HeaderDragReOrderColumns
End Property

Public Property Let HeaderDragReOrderColumns(ByVal rhs As Boolean)
  grCtrl.HeaderDragReOrderColumns = rhs
End Property

Public Property Get HeaderFlat() As Boolean
  HeaderFlat = grCtrl.HeaderFlat
End Property

Public Property Let HeaderFlat(ByVal rhs As Boolean)
  grCtrl.HeaderFlat = rhs
End Property

Public Property Get RowMode() As Boolean
  RowMode = grCtrl.RowMode
End Property

Public Property Let RowMode(ByVal rhs As Boolean)
  grCtrl.RowMode = rhs
  If rhs Then
    With grCtrl
      .HighlightBackColor = vbHighlight
      .HighlightForeColor = vbHighlightText
      .GridLines = False
    End With
  Else
    With grCtrl
      .HighlightBackColor = vb3DHighlight
      .HighlightForeColor = vbWindowText
      .GridLines = m_GridLines
    End With
  End If
End Property

Public Property Get Header() As Boolean
  Header = grCtrl.Header
End Property

Public Property Let Header(ByVal rhs As Boolean)
  grCtrl.Header = rhs
End Property

Public Property Get Enabled() As Boolean
  Enabled = grCtrl.Enabled
End Property

Public Property Let Enabled(ByVal rhs As Boolean)
  grCtrl.Enabled = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub SetHeaders()
  grCtrl.SetHeaders
End Sub

Public Function IsRowSelected(ByVal lRow As Long) As Boolean
  IsRowSelected = grCtrl.IsRowSelected(lRow)
End Function

Public Sub GroupColumns()
  grCtrl.GroupColumns
End Sub

Public Sub Clear(Optional ByVal bRemoveCols As Boolean = False)
  grCtrl.Clear bRemoveCols
End Sub

Public Function RemoveRow(ByVal lRow As Long)
  grCtrl.RemoveRow lRow
End Function

Private Sub ctlCB_KeyDown(KeyCode As Integer, Shift As Integer)
  pMngKeyDown KeyCode, Shift
End Sub

' funciones friend
' funciones privadas

' Controles de edicion
Private Sub ctlCB_LostFocus()
  On Error Resume Next
  tmCombo.Enabled = True
End Sub

Private Sub ctlCBhock_KeyDown(KeyCode As Integer, Shift As Integer)
  pMngKeyDown KeyCode, Shift
End Sub

Private Sub ctlCBhock_LostFocus()
  On Error Resume Next
  pEndEdit ctlCBhock, ctlCBhock.Text, ListID(ctlCB)
End Sub

Private Sub ctlHL_KeyDown(KeyCode As Integer, Shift As Integer)
  pMngKeyDown KeyCode, Shift
End Sub

Private Sub ctlHL_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyReturn Then KeyAscii = 0
End Sub

Private Sub ctlHL_LostFocus()
  On Error Resume Next
  ctlHL.Validate
  pEndEdit ctlHL, ctlHL.Text, ctlHL.Id
End Sub

Private Sub ctlMEFE_KeyDown(KeyCode As Integer, Shift As Integer)
  pMngKeyDown KeyCode, Shift
End Sub

Private Sub ctlMKE_KeyDown(KeyCode As Integer, Shift As Integer)
  pMngKeyDown KeyCode, Shift
End Sub

Private Sub ctlTX_ButtonClick(Cancel As Boolean)
  RaiseEvent ColumnButtonClick(grCtrl.SelectedRow, grCtrl.SelectedCol, 0, Cancel)
End Sub

Private Sub ctlTX_KeyDown(KeyCode As Integer, Shift As Integer)
  pMngKeyDown KeyCode, Shift
End Sub

Private Sub ctlTX_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyReturn Then KeyAscii = 0
End Sub

Private Sub ctlTX_LostFocus()
  pEndEdit ctlTX, ctlTX.Text
End Sub

Private Sub ctlTXPassword_KeyDown(KeyCode As Integer, Shift As Integer)
  pMngKeyDown KeyCode, Shift
End Sub

Private Sub ctlTXPassword_LostFocus()
  pEndEdit ctlTXPassword, ctlTXPassword.Text
End Sub

Private Sub ctlMKE_LostFocus()
  pEndEdit ctlMKE, ctlMKE.csValue
End Sub

Private Sub ctlMEFE_LostFocus()
  pEndEdit ctlMEFE, ctlMEFE.csValue
End Sub

Private Sub grCtrl_ColumnClick(ByVal lCol As Long)
  On Error Resume Next
  RaiseEvent ColumnClick(lCol)
End Sub

Private Sub grCtrl_DblClick(ByVal lRow As Long, ByVal lCol As Long)
  On Error Resume Next
  RaiseEvent DblClick(lRow, lCol)
End Sub

Private Sub grCtrl_DeleteCellValue(ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  Dim c     As cGridColumn
  
  Set c = pGetColumn(lCol)
  
  If Not c.Enabled Then Exit Sub
  
  If c.EditType <> cspCheck Then
    With grCtrl.Cell(lRow, lCol)
      If c.EditType = cspNumeric Then
        .Text = "0"
      ElseIf c.EditType = cspDate Then
        .Text = #1/1/1900#
      Else
        .Text = ""
        .ItemData = 0
      End If
    End With
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "grCtrl_DeleteCellValue", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub grCtrl_DeleteRow(ByVal lRow As Long, bCancel As Boolean)
  On Error Resume Next
  
  RaiseEvent DeleteRow(lRow, bCancel)
  SetFocusControl grCtrl
End Sub

Private Sub grCtrl_GotFocus()
  pEndEditAux
End Sub

Private Sub grCtrl_KeyDown(KeyCode As Integer, Shift As Integer, bDoDefault As Boolean)
  On Error Resume Next
  
  If KeyCode = vbKeyReturn Or KeyCode = 39 Then
    pKeyAux c_Right
    bDoDefault = False
  ElseIf KeyCode = 37 Then
    pKeyAux c_Left
    bDoDefault = False
  End If
End Sub

Private Sub grCtrl_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single, bDoDefault As Boolean)
  On Error Resume Next
  
  RaiseEvent MouseDown(Button, Shift, X, Y, bDoDefault)
End Sub

Private Sub grCtrl_RequestEdit(ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  On Error GoTo ControlError

  bCancel = False
  
  RaiseEvent ColumnBeforeEdit(lRow, lCol, iKeyAscii, bCancel)
  If bCancel Then Exit Sub
  
  If Not pEdit(lRow, lCol, iKeyAscii) Then
    bCancel = True
    Exit Sub
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "grCtrl_RequestEdit", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pMngKeyDown(KeyCode As Integer, Shift As Integer)
  On Error GoTo ControlError
  
  If KeyCode = vbKeyReturn Then
    KeyCode = 0
    pEndEditAux
    SetFocusControl grCtrl
    pKeyAux c_Right
    
  ElseIf KeyCode = vbKeyLeft Then
    pKeyArrow c_Left
  
  ElseIf KeyCode = vbKeyRight Then
    pKeyArrow c_Right
    
  ElseIf KeyCode = vbKeyUp Or KeyCode = vbKeyDown Then
    If Not TypeOf ActiveControl Is CSComboBox.cComboBox Then
      pEndEditAux
      SetFocusControl grCtrl
      If KeyCode = vbKeyUp Then
        pKeyAux c_Up
      Else
        pKeyAux c_Down
      End If
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "pMngKeyDown", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pKeyArrow(ByVal Direction As Integer)
  Dim lenText As Integer
  
  If m_Ctl Is Nothing Then Exit Sub
  If m_Ctl Is ctlCB Or m_Ctl Is ctlCBhock Then
    pKeyAux Direction
  Else
    If Direction = c_Right Then
      If m_Ctl Is ctlTX Or m_Ctl Is ctlTX Or m_Ctl Is ctlHL Then
        lenText = Len(m_Ctl.Text)
      ElseIf m_Ctl Is ctlMKE Or m_Ctl Is ctlMEFE Then
        lenText = Len(m_Ctl.csValue)
      End If
    Else
      lenText = 0
    End If
    
    If m_Ctl.SelStart = lenText Then
        pKeyAux Direction
    End If
  End If
End Sub

Private Sub pKeyAux(ByVal Direction As Integer)
  Dim Col As Long
  Dim Row As Long
  
  Dim NewRow As Boolean
  
  pEndEditAux
  
  With grCtrl
    Select Case Direction
      Case c_Left
        Col = pGetNextColVisible(c_Left)
      Case c_Right
        Col = pGetNextColVisible(c_Right)
        If .SelectedRow = .Rows Then NewRow = True
      Case c_Up
        If .SelectedRow > 1 Then
          Row = .SelectedRow
          .SelectedRow = Row - 1
        End If
      Case c_Down
        If .SelectedRow < .Rows Then
          Row = .SelectedRow
          .SelectedRow = Row + 1
        End If
    End Select
    
    If Col > 0 Then
      .SelectedCol = 0
      .SelectedCol = Col
    ElseIf NewRow Then
      pAddRow
    End If
  End With
  
  If m_focusInMe Then SetFocusControl grCtrl
End Sub

Private Sub pAddRow()
  Dim Col       As Integer
  Dim bCancel   As Boolean
  
  With grCtrl
    RaiseEvent ValidateRow(.Rows, bCancel)
    
    If bCancel Then Exit Sub
  
    .AddRow
  
    pSetFormatCells .Rows
    
    DoEvents
    
    RaiseEvent NewRow(.Rows)
    
    Col = pGetFirstColVisible()
    
    If Col = 0 Then Exit Sub
    .SelectedRow = grCtrl.Rows
    .SelectedCol = 0
    .SelectedCol = Col
  End With
End Sub

Private Sub pSetFormatCells(ByVal iRow As Long)
  Dim iCol  As Long
  Dim c     As cGridColumn
  
  With grCtrl
  
    For iCol = 1 To .Columns
      .CellTextAlign(iRow, iCol) = .ColumnAlign(iCol)
      
      Set c = pGetColumn(iCol)
      
      If c.EditType = cspCheck Then
        .CellIcon(iRow, iCol) = IIf(.CellItemData(iRow, iCol), csECheck, csEUncheck)
      End If
      
      If c.Enabled Then
        If .CellBackColor(iRow, iCol) <> vbButtonFace Then
          .CellBackColor(iRow, iCol) = .BackColor
        End If
      Else
        .CellBackColor(iRow, iCol) = vbButtonFace
      End If
    Next
  End With
End Sub

Private Function pGetFirstColVisible() As Integer
  Dim Col As Integer
  
  With grCtrl
    For Col = 1 To .Columns
      If .ColumnVisible(Col) Then
        pGetFirstColVisible = Col
        Exit For
      End If
    Next
  End With
End Function

Private Function pGetNextColVisible(ByVal Direction As Integer) As Integer
  Dim c      As cGridColumn
  Dim lCol   As Integer
  Dim nStep  As Integer
  Dim i      As Integer
  Dim nFrom  As Integer
  Dim nTo    As Integer
  
  With grCtrl
    nFrom = .ColumnOrder(.SelectedCol)
    
    If Direction = c_Left Then
      nFrom = nFrom - 1
      nStep = -1
      nTo = 1
    ElseIf Direction = c_Right Then
      nFrom = nFrom + 1
      nStep = 1
      nTo = .Columns
    Else
      Exit Function
    End If
    
    For lCol = nFrom To nTo Step nStep
      Set c = pGetColumn(lCol)
      If .ColumnVisible(GetColFromOrder(lCol)) And c.Enabled And c.AllowEdit Then
        pGetNextColVisible = GetColFromOrder(lCol)
        Exit For
      End If
    Next
  End With
End Function

Private Function GetColFromOrder(ByVal ColOrder As Long) As Long
  Dim i As Long
  
  With grCtrl
    For i = 1 To .Columns
      If .ColumnOrder(i) = ColOrder Then
        GetColFromOrder = i
        Exit Function
      End If
    Next
  End With
End Function

Private Sub pEndEditAux()
  On Error Resume Next
  
  Dim Id As Long
  Dim Value As String
  
  With m_Ctl
    .Validate
  
    If m_Ctl Is ctlCB Or m_Ctl Is ctlCBhock Then
      Id = ListID(m_Ctl)
    Else
      Id = .Id
    End If
    
    If m_Ctl Is ctlMKE Or m_Ctl Is ctlMEFE Then
      Value = .csValue
    Else
      Value = .Text
    End If
    pEndEdit m_Ctl, Value, Id
  End With
End Sub

Private Function pIsShowingHelp(ByRef Ctl As Control) As Boolean
  On Error Resume Next
  pIsShowingHelp = Ctl.ShowingHelp = True
End Function

Private Sub pEndEdit(ByRef Ctl As Control, ByVal NewValue As Variant, Optional ByVal Id As Long)
  On Error GoTo ControlError

  Dim bCancel As Boolean
  
  If pIsShowingHelp(Ctl) Then Exit Sub
  
  If Not m_Editing Then Exit Sub
  
  m_Editing = False
  
  RaiseEvent ColumnAfterEdit(m_lRowEditing, m_lColEditing, NewValue, Id, bCancel)
  If bCancel Then Exit Sub
  
  With grCtrl.Cell(m_lRowEditing, m_lColEditing)
    
    Select Case pGetColumn(m_lColEditing).EditType
    
      Case cspNumeric
      
        If pGetColumn(m_lColEditing).EditSubType = cspPercent Then
          .Text = Val(NewValue) / 100
        Else
          .Text = Val(NewValue)
        End If
      Case cspCheck
        .IconIndex = IIf(Val(NewValue), csECheck, csEUncheck)
      Case Else
        .Text = NewValue
    End Select
    
    .ItemData = Id
    .TextAlign = m_Columns.Item(m_lColEditing).Align
  End With
  
  Ctl.Visible = False
    
  DoEvents: DoEvents: DoEvents: DoEvents
    
  RaiseEvent ColumnAfterUpdate(m_lRowEditing, m_lColEditing, NewValue, Id)
  
  GoTo ExitProc
ControlError:
  MngError Err, "pEndEdit", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pEdit(ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Dim c     As cGridColumn
  Dim Ctl   As Control
  
  Set c = pGetColumn(lCol)
  
  If Not c.AllowEdit Then Exit Function
  If Not c.Enabled Then Exit Function
  
  If c.EditType = 0 Then Exit Function
  
  If c.EditType = cspCheck Then
  
    Dim CurrentValue As Long
  
    CurrentValue = Val(pGetCurrentValue(c.EditType, lRow, lCol))
    CurrentValue = Not CBool(CurrentValue)
    With grCtrl.Cell(lRow, lCol)
      .IconIndex = IIf(CurrentValue, csECheck, csEUncheck)
      .ItemData = CurrentValue
    End With
    
    RaiseEvent ColumnAfterUpdate(lRow, lCol, "", CurrentValue)
    
  Else
  
    Set Ctl = pGetControl(c, c.EditSubType)
    
    Set m_Ctl = Ctl
    
    pSetPosition Ctl, lRow, lCol
    
    Ctl.Visible = True
    Ctl.ZOrder
    
    SetFocusControl Ctl
    
    pSetValue c.EditType, Ctl, iKeyAscii, _
              pGetCurrentValue(c.EditType, lRow, lCol), _
              pGetCurrentId(c.EditType, lRow, lCol)
    
    m_lRowEditing = lRow
    m_lColEditing = lCol
    m_Editing = True
  End If
End Function

Private Function pGetCurrentValue(ByVal EditType As csTypeABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Variant
  Dim Value As String

  With grCtrl
    
    Select Case EditType
      Case csTypeABMProperty.cspCheck
        Value = .Cell(lRow, lCol).ItemData
      Case Else
        If pGetColumn(lCol).EditSubType = cspPercent Then
          Value = Val(.Cell(lRow, lCol).Text) * 100
        Else
          Value = .Cell(lRow, lCol).Text
        End If
    End Select
  End With
  pGetCurrentValue = Value
End Function

Private Function pGetCurrentId(ByVal EditType As csTypeABMProperty, ByVal lRow As Long, ByVal lCol As Long) As Long
  Dim Value As Long

  Select Case EditType
    Case csTypeABMProperty.cspHelp
      Value = grCtrl.Cell(lRow, lCol).ItemData
  End Select
  
  pGetCurrentId = Value
End Function

Private Sub pSetValue(ByVal EditType As csTypeABMProperty, ByRef Ctl As Control, _
                      ByVal iKeyAscii As Integer, ByVal CurrentValue As Variant, _
                      ByVal CurrentId As Long)
  
  Const chars = "abcdefghijklmnopqrstuvwxyzñ"
  
  With Ctl
    Dim strChr   As String
    Dim cdblVal  As Double
    Dim lenText  As Long
  
    strChr = Chr(iKeyAscii)
    cdblVal = Val(CurrentValue)
    
    Select Case iKeyAscii
      Case vbKey0 To vbKey9
        CurrentValue = strChr
    End Select
    
    If InStr(1, chars, LCase(strChr)) > 0 Then
      CurrentValue = strChr
    End If
    
    Select Case EditType
      Case csTypeABMProperty.cspAdHock, csTypeABMProperty.cspList
        ListSetListIndexForText Ctl, CurrentValue
      
      Case csTypeABMProperty.cspCheck
        If iKeyAscii = vbKeySpace Then
          .Value = IIf(Not CBool(cdblVal), vbChecked, vbUnchecked)
        Else
          .Value = IIf(cdblVal, vbChecked, vbUnchecked)
        End If
      
      Case csTypeABMProperty.cspDate
        If CurrentValue = "" Then CurrentValue = Date
        .Edit
        ' Si es un caracter
        If Len(CurrentValue) = 1 Then
          SendKeys CurrentValue, True
        Else
          .Text = CurrentValue
        End If
        lenText = Len(.Text)
        If iKeyAscii = 0 Then
          .SelStart = 0
          .SelLength = lenText
        Else
          .SelStart = lenText
        End If
      
      Case csTypeABMProperty.cspNumeric
      
        If iKeyAscii = 45 Then
          CurrentValue = Abs(cdblVal) * -1
        ElseIf iKeyAscii = 43 Then
          CurrentValue = Abs(cdblVal)
        End If
      
        .Text = CurrentValue
        lenText = Len(.Text)
        .Edit
        
        If iKeyAscii = 45 Then
          .SelStart = 1
          .SelLength = lenText
        
        ElseIf iKeyAscii = 46 Or strChr = GetSepDecimal Then
          .NoFormat = True
          .Text = "0" & GetSepDecimal
          .SelStart = 2
          .Edit
          DoEvents
          .NoFormat = False
          
        ElseIf Not (IsNumeric(strChr)) Or iKeyAscii = 0 Then
          .SelStart = 0
          .SelLength = lenText
        Else
          .SelStart = lenText
        End If
      
      Case csTypeABMProperty.cspPassword, csTypeABMProperty.cspText, csTypeABMProperty.cspFile, csTypeABMProperty.cspFolder
        
        .Text = CurrentValue
        lenText = Len(.Text)
        .Edit
        
        If iKeyAscii = 0 Then
          .SelStart = 0
          .SelLength = lenText
        Else
          .SelStart = lenText
        End If
      
      Case csTypeABMProperty.cspHelp
        
        .Text = CurrentValue
        lenText = Len(.Text)
        .ValueHelp = CurrentId
        .ValueUser = CurrentValue
        .ValueProcess = CurrentValue
        
        If iKeyAscii = 0 Then
          .SelStart = 0
          .SelLength = lenText
        Else
          .SelStart = lenText
        End If
      
      'Case csTypeABMProperty.cspGrid
        
      'Case csTypeABMProperty.cspOption
    End Select
  End With
End Sub

Private Sub pSetPosition(ByRef Ctl As Control, ByVal lRow As Long, ByVal lCol As Long)
  Dim lLeft      As Long
  Dim lTop       As Long
  Dim lWidth     As Long
  Dim lHeight    As Long
  Dim InnerFrame As Integer
  
  If Ctl Is Nothing Then Exit Sub
  
  InnerFrame = 30
  
  With grCtrl
    If lRow > .Rows Or lCol > .Columns Then Exit Sub
    
    .CellBoundary lRow, lCol, lLeft, lTop, lWidth, lHeight
  End With
  
  Ctl.Move lLeft + InnerFrame, lTop + InnerFrame, lWidth - InnerFrame * 2, lHeight - InnerFrame
End Sub

Private Function pGetControl(ByRef Col As cGridColumn, ByVal SubType As csSubTypeABMProperty)
  Dim c As Control
  
  Select Case Col.EditType
    Case csTypeABMProperty.cspAdHock
      RaiseEvent FillsListAdHok(ctlCBhock)
      Set c = ctlCBhock
      
    Case csTypeABMProperty.cspDate
      Set c = ctlMEFE
      c.Text = Date
      
    'Case csTypeABMProperty.cspGrid
    
    Case csTypeABMProperty.cspFile
      Set c = ctlTX
      With c
        .Text = ""
        .csType = csMkFile
        .ButtonStyle = cButtonSingle
      End With
      
    Case csTypeABMProperty.cspFolder
      Set c = ctlTX
      With c
        .Text = ""
        .csType = csMkFolder
        .ButtonStyle = cButtonSingle
      End With
      
    Case csTypeABMProperty.cspHelp
      Set c = ctlHL
      With c
        .Table = 0
        .Text = ""
        .Id = 0
        .Table = Col.Table
        .Filter = Col.HelpFilter
      End With
      
    Case csTypeABMProperty.cspList
      Set c = ctlCB
      pFillList c, Col
    
    Case csTypeABMProperty.cspNumeric
      Set c = ctlMKE
      With c
        .Text = ""
        Select Case SubType
          Case csSubTypeABMProperty.cspDouble
            .csType = csMkDouble
          Case csSubTypeABMProperty.cspInteger
            .csType = csMkInteger
          Case csSubTypeABMProperty.cspMoney
            .csType = csMkMoney
          Case csSubTypeABMProperty.cspPercent
            .csType = csMkPercent
        End Select
      End With
      
    'Case csTypeABMProperty.cspOption
      
    Case csTypeABMProperty.cspPassword
      Set c = ctlTXPassword
      With c
        .Text = ""
        .MaxLength = Col.Size
      End With
      
    Case csTypeABMProperty.cspText
      Set c = ctlTX
      With c
        If SubType = cspTextButton Then
          .ButtonStyle = cButtonSingle
        Else
          .ButtonStyle = cButtonNone
        End If
        .csType = csMkText
        .Text = ""
        .MaxLength = Col.Size
      End With
      
  End Select
  
  With grCtrl
    c.TabIndex = .TabIndex
    If c.TabIndex > .TabIndex Then c.TabIndex = .TabIndex
  End With
  
  Set pGetControl = c
End Function

Private Sub pFillList(ByRef c As cComboBox, ByRef Col As cGridColumn)
  Dim ListValue As Object
  
  With c
    .Clear
    For Each ListValue In Col.List
      .AddItem ListValue.Value
      .ItemData(.NewIndex) = ListValue.Id
    Next
  End With
End Sub

Private Function pGetColumn(ByVal lCol As Long) As cGridColumn
  Set pGetColumn = m_Columns.Item(lCol)
End Function

Private Sub grCtrl_RequestNewRow()
  On Error Resume Next
  pAddRow
End Sub

Private Sub grCtrl_ScrollChange()
  On Error Resume Next
  pSetPosition m_Ctl, m_lRowEditing, m_lColEditing
End Sub

Private Sub grCtrl_SelectionChange(ByVal lRow As Long, ByVal lCol As Long)
  On Error Resume Next
  RaiseEvent SelectionChange(lRow, lCol)
End Sub

Private Sub grCtrl_ShowHelp(ByVal lRow As Long, ByVal lCol As Long)
  On Error Resume Next
  
  Dim bCancel As Boolean
  
  RaiseEvent ColumnBeforeEdit(lRow, lCol, 0, bCancel)
  If bCancel Then Exit Sub
  
  pShowHelp lRow, lCol
End Sub

Private Sub pShowHelp(ByVal lRow As Long, ByVal lCol As Long)
  On Error GoTo ControlError
  
  Dim c     As cGridColumn
  Dim Ctl   As Control
  
  Set c = pGetColumn(lCol)
  
  With c
    If .EditType = cspCheck Then Exit Sub
    
    Set Ctl = pGetControl(c, .EditSubType)
  
    If Not (Ctl Is ctlHL Or Ctl Is ctlMKE Or Ctl Is ctlMEFE Or .EditType = cspFile Or .EditType = cspFolder Or .EditSubType = cspTextButton) Then
      Exit Sub
    End If
  End With
  
  pEdit lRow, lCol, vbKeyReturn
  
  If c.EditSubType = cspTextButton Then
    ctlTX_ButtonClick False
  Else
    Ctl.ShowHelp
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "pShowHelp", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub grCtrl_ShowPopMenu(Cancel As Boolean)
  Cancel = True
End Sub

Private Sub m_Columns_AddColumn(ByVal c As cGridColumn)
  On Error Resume Next
  
  With c
    grCtrl.AddColumn .Key, .Caption, .Align, .IconIndex, .Width, .Visible, .Fixed, , , .Format, .IsDetail, .SortType
    
    If .EditType = cspCheck Then
      grCtrl.ColumnEditOnClick(grCtrl.Columns) = True
    End If
    
    Set .Grid = grCtrl
  End With
End Sub

Private Sub tmCombo_Timer()
  On Error Resume Next
  tmCombo.Enabled = False
  pEndEdit ctlCB, ctlCB.Text, ListID(ctlCB)
End Sub

Private Sub UserControl_EnterFocus()
  m_focusInMe = True
End Sub

Private Sub UserControl_ExitFocus()
  m_focusInMe = False
End Sub

Private Sub UserControl_Resize()
  On Error Resume Next
  grCtrl.Move 0, 0, UserControl.ScaleWidth, UserControl.ScaleHeight
End Sub

' construccion - destruccion
Private Sub UserControl_Initialize()
  On Error GoTo ControlError

  Set m_Columns = New cGridColumns
  ctlHL.ButtonStyle = cHelpButtonSingle
  With grCtrl
    .ImageList = imlMain
    .HighlightBackColor = vb3DHighlight
    .HighlightForeColor = vbWindowText
    .MultiSelect = False
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "UserControl_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub UserControl_Terminate()
  On Error GoTo ControlError

  Set m_Columns = Nothing
  
  GoTo ExitProc
ControlError:
  MngError Err, "UserControl_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
