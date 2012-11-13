VERSION 5.00
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Object = "{AB350268-0AA3-445C-8F38-C22EB727290F}#1.1#0"; "CSHelp2.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.2#0"; "CSMaskEdit2.ocx"
Object = "{757F6B6F-8057-4D0A-85C2-0A1807E33D34}#1.9#0"; "CSGrid2.ocx"
Begin VB.UserControl cGridAdvanced 
   ClientHeight    =   5115
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   8565
   ScaleHeight     =   5115
   ScaleWidth      =   8565
   Begin VB.ComboBox ctlCB 
      Appearance      =   0  'Flat
      Height          =   315
      Left            =   3105
      Style           =   2  'Dropdown List
      TabIndex        =   6
      Top             =   1485
      Visible         =   0   'False
      Width           =   2220
   End
   Begin CSHelp2.cHelp ctlHL 
      Height          =   315
      Left            =   3060
      TabIndex        =   5
      Top             =   180
      Visible         =   0   'False
      Width           =   2295
      _ExtentX        =   4048
      _ExtentY        =   556
      BorderColor     =   12164479
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
   End
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
   Begin CSGrid2.cGrid grCtrl 
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
      HeaderDragReorderColumns=   0   'False
      DisableIcons    =   -1  'True
   End
   Begin CSMaskEdit2.cMaskEdit ctlMKE 
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
      BorderColor     =   12164479
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit ctlMEFE 
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
      Text            =   "01-01-1900"
      csType          =   6
      BorderColor     =   12164479
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit ctlTXPassword 
      Height          =   285
      Left            =   3060
      TabIndex        =   3
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
      BorderColor     =   12164479
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSMaskEdit2.cMaskEdit ctlTX 
      Height          =   285
      Left            =   3060
      TabIndex        =   4
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
      BorderColor     =   12164479
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

Private Const c_HelpInvalidValue = "Help_Invalid"

Private Const c_Left = 1
Private Const c_Right = 2
Private Const c_Up = 3
Private Const c_Down = 4
' estructuras
' variables privadas

Private WithEvents m_Columns                       As cGridColumns
Attribute m_Columns.VB_VarHelpID = -1

Private m_RowSelected                              As Long ' Ultima fila seleccionada por el usuario

Private m_lRowEditing                              As Long
Private m_lColEditing                              As Long
Private m_Editing                                  As Boolean

Private Enum eCtrlId
  ctlNoneId
  ctlHelpId
  ctlMkeId
  ctlPassId
  ctlMefeId
  ctlTxId
  ctlCbId
  ctlCbHId
End Enum

Private m_EditCtrlId                               As eCtrlId

Private m_SecondTime                               As Boolean
Private m_LastKeyRow                               As Integer

Private m_focusInMe                                As Boolean
Private m_GridLines                                As Long

Private m_bDontSelectInGotFocus                    As Boolean

' Este flag no se penso para poder tener un control
' sobre este activex desde un form que lo contenga
' Basicamente sirve para en el unload o en query unload
' del form informarle al control que no debe disparar mas
' eventos.
'
' Todo esto fue para evitar un flor de bug que nos rompio
' las bolas por mas de dos semanas, pero finalmente se
' resolvio de otra forma.
'
' En resumen la variable no se usa, pero si llega a ser
' util en el futuro esta disponible.
'
' Tambien se puede remover, pero esto implicara romper
' la compatibilidad binaria del componente.
'
Private m_Unloaded                                 As Boolean

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
Public Event RowWasDeleted(ByVal lRow As Long)
Public Event DblClick(ByVal lRow As Long, ByVal lCol As Long)
Public Event SelectionChange(ByVal lRow As Long, ByVal lCol As Long)
Public Event MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single, bDoDefault As Boolean)
Public Event SelectionRowChange(ByVal lRow As Long, ByVal lCol As Long)
Public Event SelectionColChange(ByVal lRow As Long, ByVal lCol As Long)
'Public Event MultiSelectionRowChange(ByVal lStartRow As Long, ByVal lStartCol As Long, ByVal lEndRow As Long, ByVal lEndCol As Long)

' propiedadades publicas
Public Property Get GridCtrl() As Object
  Set GridCtrl = grCtrl
End Property

Public Property Let Unloaded(ByVal rhs As Boolean)
  m_Unloaded = rhs
End Property

Public Property Get DontSelectInGotFocus() As Boolean
  DontSelectInGotFocus = m_bDontSelectInGotFocus
End Property

Public Property Let DontSelectInGotFocus(ByVal rhs As Boolean)
  m_bDontSelectInGotFocus = rhs
End Property

Public Property Get Editable() As Boolean
  On Error Resume Next
  Editable = grCtrl.Editable
End Property

Public Property Let Editable(ByVal rhs As Boolean)
  On Error Resume Next
  grCtrl.Editable = rhs
End Property

Public Property Get Columns() As cGridColumns
  Set Columns = m_Columns
End Property

Public Property Set Columns(ByRef rhs As cGridColumns)
  Set m_Columns = rhs
End Property

Public Property Get RowForeColor(ByVal lRow As Long) As Long
  On Error Resume Next
  RowForeColor = grCtrl.CellForeColor(lRow, 1)
End Property

Public Property Let RowForeColor(ByVal lRow As Long, ByVal rhs As Long)
  On Error GoTo ControlError
  
  Dim iCol As Long
  Dim OldRedraw As Boolean
  
  OldRedraw = grCtrl.Redraw
  grCtrl.Redraw = False
  For iCol = 1 To grCtrl.Columns
    If LenB(grCtrl.CellTag(lRow, iCol)) Then
      
      If grCtrl.CellTag(lRow, iCol) = c_HelpInvalidValue Then
        
        grCtrl.CellForeColor(lRow, iCol) = vbRed
      
      Else
        grCtrl.CellForeColor(lRow, iCol) = rhs
      End If
      
    Else
      grCtrl.CellForeColor(lRow, iCol) = rhs
    End If
  Next

  GoTo ExitProc
ControlError:
  MngError Err, "RowForeColor", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  grCtrl.Redraw = OldRedraw
End Property

Public Property Get RowBackColor(ByVal lRow As Long) As Long
  On Error Resume Next
  RowBackColor = grCtrl.CellBackColor(lRow, 1)
End Property

Public Property Let RowBackColor(ByVal lRow As Long, ByVal rhs As Long)
  On Error GoTo ControlError
  
  Dim iCol As Long
  Dim OldRedraw As Boolean
  
  OldRedraw = grCtrl.Redraw
  grCtrl.Redraw = False
  For iCol = 2 To grCtrl.Columns
    grCtrl.CellBackColor(lRow, iCol) = rhs
  Next

  GoTo ExitProc
ControlError:
  MngError Err, "grCtrl_DeleteCellValue", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  grCtrl.Redraw = OldRedraw
End Property

Public Property Get RowVisible(ByVal lRow As Long) As Boolean
  On Error Resume Next
  RowVisible = grCtrl.RowVisible(lRow)
End Property

Public Property Let RowVisible(ByVal lRow As Long, ByVal rhs As Boolean)
  On Error Resume Next
  grCtrl.RowVisible(lRow) = rhs
End Property

Public Property Get Rows() As Long
  On Error Resume Next
  Rows = grCtrl.Rows
End Property

Public Property Let Rows(ByVal rhs As Long)
  On Error Resume Next
  Dim iRow As Long
  grCtrl.Rows = rhs
  
  For iRow = 1 To grCtrl.Rows
    pSetFormatCells iRow
  Next
End Property

Public Property Get BackColor() As OLE_COLOR
  On Error Resume Next
  BackColor = grCtrl.BackColor
End Property

Public Property Let BackColor(ByVal rhs As OLE_COLOR)
  On Error Resume Next
  grCtrl.BackColor = rhs
End Property

Public Property Get DrawFocusRectangle() As Boolean
  On Error Resume Next
  DrawFocusRectangle = grCtrl.DrawFocusRectangle
End Property

Public Property Let DrawFocusRectangle(ByVal rhs As Boolean)
  On Error Resume Next
  grCtrl.DrawFocusRectangle = rhs
End Property

Public Property Get GridLines() As Boolean
  On Error Resume Next
  GridLines = grCtrl.GridLines
End Property

Public Property Let GridLines(ByVal rhs As Boolean)
  On Error Resume Next
  m_GridLines = rhs
  grCtrl.GridLines = rhs
End Property

Public Property Get SelectedRow() As Long
  On Error Resume Next
  SelectedRow = grCtrl.SelectedRow
End Property

Public Property Let SelectedRow(ByVal rhs As Long)
  On Error Resume Next
  grCtrl.SelectedRow = rhs
End Property

Public Property Get SelectedCol() As Long
  On Error Resume Next
  SelectedCol = grCtrl.SelectedCol
End Property

Public Property Let SelectedCol(ByVal rhs As Long)
  On Error Resume Next
  grCtrl.SelectedCol = rhs
End Property

Public Property Get Cell(ByVal lRow As Long, ByVal lCol As Long) As cGridCell
  On Error Resume Next
  Set Cell = grCtrl.Cell(lRow, lCol)
End Property

Public Property Get CellItemdata(ByVal lRow As Long, ByVal lCol As Long) As Long
  On Error Resume Next
  CellItemdata = grCtrl.Cell(lRow, lCol).ItemData
End Property

Public Property Let CellItemdata(ByVal lRow As Long, ByVal lCol As Long, ByVal rhs As Long)
  On Error Resume Next
  grCtrl.Cell(lRow, lCol).ItemData = rhs

  Dim c As cGridColumn
  Set c = pGetColumn(lCol)
  
  If c Is Nothing Then Exit Property
  
  With grCtrl
  
    If c.EditType = cspCheck Then
      .CellIcon(lRow, lCol) = IIf(.CellItemdata(lRow, lCol), csECheck, csEUncheck)
    End If
  End With
  
End Property

Public Property Let Redraw(ByVal rhs As Boolean)
  On Error Resume Next
  grCtrl.Redraw = rhs
  grCtrl.Draw
End Property

Public Property Get MultiSelect() As Boolean
  On Error Resume Next
  MultiSelect = grCtrl.MultiSelect
End Property

Public Property Let MultiSelect(ByVal rhs As Boolean)
  On Error Resume Next
  grCtrl.MultiSelect = rhs
End Property

Public Property Get BorderStyle() As csGridBorderStyleEnum
  On Error Resume Next
  BorderStyle = grCtrl.BorderStyle
End Property
  
Public Property Let BorderStyle(ByVal rhs As csGridBorderStyleEnum)
  On Error Resume Next
  grCtrl.BorderStyle = rhs
End Property
   
Public Property Get HeaderDragReOrderColumns() As Boolean
  On Error Resume Next
  HeaderDragReOrderColumns = grCtrl.HeaderDragReOrderColumns
End Property

Public Property Let HeaderDragReOrderColumns(ByVal rhs As Boolean)
  On Error Resume Next
  grCtrl.HeaderDragReOrderColumns = rhs
End Property

Public Property Get HeaderFlat() As Boolean
  On Error Resume Next
  HeaderFlat = grCtrl.HeaderFlat
End Property

Public Property Let HeaderFlat(ByVal rhs As Boolean)
  On Error Resume Next
  grCtrl.HeaderFlat = rhs
End Property

Public Property Get RowMode() As Boolean
  On Error Resume Next
  RowMode = grCtrl.RowMode
End Property

Public Property Let RowMode(ByVal rhs As Boolean)
  On Error Resume Next
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
  On Error Resume Next
  Header = grCtrl.Header
End Property

Public Property Let Header(ByVal rhs As Boolean)
  On Error Resume Next
  grCtrl.Header = rhs
End Property

Public Property Get Enabled() As Boolean
  On Error Resume Next
  Enabled = grCtrl.Enabled
End Property

Public Property Let Enabled(ByVal rhs As Boolean)
  On Error Resume Next
  grCtrl.Enabled = rhs
End Property

Public Property Let RowTextStartColumn(ByVal rhs As Integer)
  On Error Resume Next
  grCtrl.RowTextStartColumn = rhs
End Property

Public Property Get RowTextStartColumn() As Integer
  On Error Resume Next
  RowTextStartColumn = grCtrl.RowTextStartColumn
End Property

Public Property Get HasRowText() As Boolean
  On Error Resume Next
  HasRowText = grCtrl.HasRowText
End Property

Public Property Let RowHeight(ByVal lRow As Long, ByVal rhs As Long)
  On Error Resume Next
  grCtrl.RowHeight(lRow) = rhs
End Property

Public Property Get DefaultRowHeight() As Long
  On Error Resume Next
  DefaultRowHeight = grCtrl.DefaultRowHeight
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub ClearEx(Optional ByVal bRemoveCols As Boolean = False, _
                   Optional ByVal bRemoveGroups As Boolean = False, _
                   Optional ByVal bRemoveFormulas As Boolean = False, _
                   Optional ByVal bRemoveFormats As Boolean = False, _
                   Optional ByVal bRemoveFilters As Boolean = False)
  
  grCtrl.ClearEx bRemoveCols, _
                 bRemoveGroups, _
                 bRemoveFormulas, _
                 bRemoveFormats, _
                 bRemoveFilters
End Sub

Public Sub RefreshGroupsAndFormulasEx(ByVal bForceRefresh As Boolean)
  grCtrl.RefreshGroupsAndFormulasEx bForceRefresh
End Sub

Public Sub ClearGroups()
  grCtrl.Groups.Clear
End Sub

Public Property Get RowIsGroup(ByVal lRow As Long) As Boolean
  RowIsGroup = grCtrl.RowIsGroup(lRow)
End Property

Public Property Get CellText(ByVal lRow As Long, ByVal lCol As Long) As Variant
  CellText = grCtrl.CellText(lRow, lCol)
End Property

Public Property Let CellText(ByVal lRow As Long, ByVal lCol As Long, ByVal sText As Variant)
  grCtrl.CellText(lRow, lCol) = sText
End Property

Public Property Get ColumnWidth(ByVal vKey As Variant) As Long
  ColumnWidth = grCtrl.ColumnWidth(vKey)
End Property

Public Property Let ColumnWidth(ByVal vKey As Variant, ByVal lWidth As Long)
  grCtrl.ColumnWidth(vKey) = lWidth
End Property

Public Function AddGroup() As cGridGroup
  Set AddGroup = grCtrl.Groups.Add(Nothing)
End Function

Public Sub ExpandAllGroups()
  grCtrl.ExpandAllGroups
End Sub

Public Property Get EvaluateTextHeight(ByVal lRow As Long, ByVal lCol As Long) As Long
  On Error Resume Next
  EvaluateTextHeight = grCtrl.EvaluateTextHeight(lRow, lCol)
End Property

Public Sub AutoWidthColumn(ByVal vKey As Variant)
  On Error Resume Next
  grCtrl.AutoWidthColumn vKey
End Sub

Public Sub AutoWidthColumns()
  On Error Resume Next
  grCtrl.AutoWidthColumns
End Sub

Public Sub SelectRow(ByVal lRow As Long)

  If grCtrl.MultiSelect Then Exit Sub

  UnSelectRow
  m_RowSelected = lRow
  RowBackColor(lRow) = &HFFAAAA
End Sub

Public Sub ClearSelection()
  On Error Resume Next
  grCtrl.ClearSelection
End Sub

Public Sub UnSelectRow()
  On Error GoTo ControlError
  
  If grCtrl.MultiSelect Then Exit Sub

  Dim iCol As Long
  Dim OldRedraw As Boolean
  
  OldRedraw = grCtrl.Redraw
  grCtrl.Redraw = False
  
  If m_RowSelected > 0 And m_RowSelected <= grCtrl.Rows Then
    
    pSetFormatCells m_RowSelected
    m_RowSelected = 0
    
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "UnSelectRow", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  grCtrl.Redraw = OldRedraw
End Sub

Public Sub MultiUnSelectRow()
  On Error GoTo ControlError
  
  Dim iCol As Long
  Dim OldRedraw As Boolean
  
  OldRedraw = grCtrl.Redraw
  grCtrl.Redraw = False
  
  Dim lRow As Long
  
  For lRow = 1 To grCtrl.Rows
    
    pSetFormatCells lRow
    
  Next

  GoTo ExitProc
ControlError:
  MngError Err, "MultiUnSelectRow", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  grCtrl.Redraw = OldRedraw
End Sub

Public Sub MultiSelectRow()
  On Error GoTo ControlError
  
  Dim iCol As Long
  Dim OldRedraw As Boolean
  
  OldRedraw = grCtrl.Redraw
  grCtrl.Redraw = False
  
  Dim lRow As Long
  
  For lRow = 1 To grCtrl.Rows
    
    If grCtrl.IsRowSelected(lRow) Then
      RowBackColor(lRow) = &HFFAAAA
    Else
      pSetFormatCells lRow
    End If
    
  Next

  GoTo ExitProc
ControlError:
  MngError Err, "MultiSelectRow", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  grCtrl.Redraw = OldRedraw
End Sub

Public Sub SetHeaders()
  On Error Resume Next
  grCtrl.SetHeaders
End Sub

Public Function IsRowSelected(ByVal lRow As Long) As Boolean
  On Error Resume Next
  IsRowSelected = grCtrl.IsRowSelected(lRow)
End Function

Public Sub GroupColumns()
  On Error Resume Next
  grCtrl.GroupColumns
End Sub

Public Sub Clear(Optional ByVal bRemoveCols As Boolean = False)
  On Error Resume Next
  grCtrl.Clear bRemoveCols
End Sub

Public Function RemoveRow(ByVal lRow As Long)
  On Error Resume Next
  grCtrl.RemoveRow lRow
End Function

Private Sub ctlCB_KeyDown(KeyCode As Integer, Shift As Integer)
  pMngKeyDown KeyCode, Shift
End Sub

Public Sub CellFromPoint( _
    ByVal xPixels As Long, _
    ByVal yPixels As Long, _
    ByRef lRow As Long, _
    ByRef lCol As Long _
  )
  On Error Resume Next
  grCtrl.CellFromPoint xPixels, _
                       yPixels, _
                       lRow, _
                       lCol
End Sub
' funciones friend
' funciones privadas

' Controles de edicion
Private Sub ctlCB_LostFocus()
  On Error Resume Next
  tmCombo.Enabled = True
End Sub

Private Sub ctlHL_KeyDown(KeyCode As Integer, Shift As Integer)
  pMngKeyDown KeyCode, Shift
End Sub

Private Sub ctlHL_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyReturn Then KeyAscii = 0
End Sub

Private Sub ctlHL_LostFocus()
  On Error Resume Next
  
  Dim ValueProcess  As String
  ValueProcess = ctlHL.ValueHelp
  
  Dim lRowEditing As Long
  Dim lColEditing As Long
  
  lRowEditing = m_lRowEditing
  lColEditing = m_lColEditing

  ctlHL.Validate
  pEndEdit ctlHL, ctlHL.Text, ctlHL.Id, ValueProcess, lRowEditing, lColEditing
End Sub

Private Sub ctlMEFE_KeyDown(KeyCode As Integer, Shift As Integer)
  pMngKeyDown KeyCode, Shift
End Sub

Private Sub ctlMKE_KeyDown(KeyCode As Integer, Shift As Integer)
  pMngKeyDown KeyCode, Shift
End Sub

Private Sub ctlTX_ButtonClick(Cancel As Boolean)
  On Error Resume Next
  RaiseEvent ColumnButtonClick(grCtrl.SelectedRow, grCtrl.SelectedCol, 0, Cancel)
  ctlTX.Text = grCtrl.CellText(grCtrl.SelectedRow, grCtrl.SelectedCol)
End Sub

Private Sub ctlTX_KeyDown(KeyCode As Integer, Shift As Integer)
  pMngKeyDown KeyCode, Shift
End Sub

Private Sub ctlTX_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyReturn Then KeyAscii = 0
End Sub

Private Sub ctlTX_LostFocus()
  On Error Resume Next
  pEndEdit ctlTX, ctlTX.Text
End Sub

Private Sub ctlTXPassword_KeyDown(KeyCode As Integer, Shift As Integer)
  pMngKeyDown KeyCode, Shift
End Sub

Private Sub ctlTXPassword_LostFocus()
  On Error Resume Next
  pEndEdit ctlTXPassword, ctlTXPassword.Text
End Sub

Private Sub ctlMKE_LostFocus()
  On Error Resume Next
  pEndEdit ctlMKE, ctlMKE.csValue
End Sub

Private Sub ctlMEFE_LostFocus()
  On Error Resume Next
  pEndEdit ctlMEFE, ctlMEFE.csValue
End Sub

Private Sub grCtrl_CancelEdit()
  On Error GoTo ControlError
  
  pEndEditAux

  GoTo ExitProc
ControlError:
  MngError Err, "grCtrl_CancelEdit", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
  
  Dim c         As cGridColumn
  Dim NewValue  As String
  Dim Id        As Long
  Dim bCancel   As Boolean
  
  Set c = pGetColumn(lCol)
  
  If c.EditType = cspGrid Then
    grCtrl.RemoveRow lRow
    Exit Sub
  End If
  
  If Not c.Enabled Then Exit Sub
  
  If c.EditType <> cspCheck Then
    With grCtrl.Cell(lRow, lCol)
      If c.EditType = cspNumeric Then
        NewValue = "0"
      ElseIf c.EditType = cspDate Then
        NewValue = #1/1/1900#
      Else
        NewValue = ""
        Id = 0
      End If
    End With
  End If

  RaiseEvent ColumnAfterEdit(lRow, lCol, NewValue, Id, bCancel)
  If bCancel Then Exit Sub

  If c.EditType <> cspCheck Then
    With grCtrl.Cell(lRow, lCol)
      If c.EditType = cspNumeric Then
        .Text = NewValue
      ElseIf c.EditType = cspDate Then
        .Text = NewValue
      Else
        .Text = NewValue
        .ItemData = Id
      End If
    End With
  End If

  RaiseEvent ColumnAfterUpdate(lRow, lCol, NewValue, Id)

  GoTo ExitProc
ControlError:
  MngError Err, "grCtrl_DeleteCellValue", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub grCtrl_DeleteRow(ByVal lRow As Long, bCancel As Boolean)
  On Error Resume Next
  
  RaiseEvent DeleteRow(lRow, bCancel)
  SetFocusControl grCtrl
End Sub

Private Sub grCtrl_GotFocus()
  On Error Resume Next
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

Private Sub grCtrl_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single, bDoDefault As Boolean)
  On Error Resume Next
  
  RaiseEvent MouseDown(Button, Shift, x, y, bDoDefault)
  
End Sub

Private Sub grCtrl_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error Resume Next
  
  If grCtrl.MultiSelect Then
    MultiSelectRow
  End If
  
End Sub

Private Sub grCtrl_RequestEdit(ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  On Error GoTo ControlError
  
  bCancel = False
  
  Dim bCtrlV As Boolean
  
  If iKeyAscii = 22 Then
    bCtrlV = True
    iKeyAscii = 0
  End If
  
  RaiseEvent ColumnBeforeEdit(lRow, lCol, iKeyAscii, bCancel)
  If bCancel Then Exit Sub
  
  If Not pEdit(lRow, lCol, iKeyAscii) Then Exit Sub
  
  bCancel = True
  
  If bCtrlV Then
    SendKeys "^v"
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "grCtrl_RequestEdit", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pMngKeyDown(KeyCode As Integer, Shift As Integer)
  On Error GoTo ControlError
  
  If KeyCode = vbKeyReturn Then
    KeyCode = 0
    
    ' WARNING BUG
    ' nuevo por si da errores
    '
    SetFocusControl grCtrl
    pEndEditAux
    '
    ' fin nuevo
    
    pKeyAux c_Right
    
  ElseIf KeyCode = vbKeyLeft Then
    pKeyArrow c_Left
  
  ElseIf KeyCode = vbKeyRight Then
    pKeyArrow c_Right
    
  ElseIf KeyCode = vbKeyUp Or KeyCode = vbKeyDown Then
    If Not TypeOf ActiveControl Is ComboBox Then
      
      ' WARNING BUG
      ' nuevo por si da errores
      '
      SetFocusControl grCtrl
      pEndEditAux
      '
      ' fin nuevo
      
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
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pKeyArrow(ByVal Direction As Integer)
  Dim lenText As Integer
  
  Dim c As Control
  Set c = pGetCtrlEdit()
  
  If c Is Nothing Then Exit Sub
  If c Is ctlCB Then 'Or c Is ctlCBhock Then
    pKeyAux Direction
  Else
    If Direction = c_Right Then
      If c Is ctlTX Or c Is ctlTX Or c Is ctlHL Then
        lenText = Len(c.Text)
      ElseIf c Is ctlMKE Or c Is ctlMEFE Then
        lenText = Len(c.csValue)
      End If
    Else
      If c.SelLength = 0 Then
        lenText = 0
      Else
        lenText = 1
      End If
    End If
    
    If c.SelStart = lenText Then
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
      
      ' En grillas agrupadas al hacer click
      ' sobre la columna item no hay control de
      ' edicion
      '
      If c Is Nothing Then
        If .CellBackColor(iRow, iCol) <> vbButtonFace Then
          .CellBackColor(iRow, iCol) = .BackColor
        End If
        Exit Sub
      End If
      
      If c.EditType = cspCheck Then
        .CellIcon(iRow, iCol) = IIf(.CellItemdata(iRow, iCol), csECheck, csEUncheck)
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
  Dim Col   As Integer
  Dim c     As cGridColumn
  
  With grCtrl
    For Col = 1 To .Columns
      Set c = pGetColumn(Col)
      If .ColumnVisible(GetColFromOrder(Col)) And c.Enabled And c.AllowEdit Then
        pGetFirstColVisible = Col
        Exit Function
      End If
    Next
  End With

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
    
    ' Para evitar un error en grillas
    ' agrupadas
    '
    If nTo > m_Columns.Count Then nTo = m_Columns.Count
    
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
  
  Dim Id            As Long
  Dim Value         As String
  Dim ValueProcess  As String
  Dim c             As Control
  
  Set c = pGetCtrlEdit()
  
  If Not c Is Nothing Then
  
    With c
    
      ' Si es un help
      '
      If c Is ctlHL Then
      
        ' Si es de tipo multiselect
        '
        If ctlHL.HelpType = 3 Then 'csMultiSelect=3
        
          ValueProcess = ctlHL.ValueHelp
        
        End If
      
      End If
    
      If TypeOf c Is CSHelp2.cHelp Then
      
        .Validate
      End If
    
      If c Is ctlCB Then 'Or c Is ctlCBhock Then
        Id = ListID(c)
      ElseIf TypeOf c Is CSHelp2.cHelp Then
        Id = .Id
      End If
      
      If c Is ctlMKE Or c Is ctlMEFE Then
        Value = .csValue
      Else
        Value = .Text
      End If
      pEndEdit c, Value, Id, ValueProcess
    End With
  End If
End Sub

Private Function pIsShowingHelp(ByRef ctl As Control) As Boolean
  On Error Resume Next
  pIsShowingHelp = ctl.ShowingHelp = True
End Function

Private Sub pEndEdit(ByRef ctl As Control, _
                     ByVal NewValue As Variant, _
                     Optional ByVal Id As Long, _
                     Optional ByVal ValueProcess As String, _
                     Optional ByVal lRowEditing As Long = -1, _
                     Optional ByVal lColEditing As Long = -1)
                     
  On Error GoTo ControlError

  Dim bCancel As Boolean
  
  If pIsShowingHelp(ctl) Then Exit Sub
  
  If Not m_Editing Then Exit Sub
  
  m_Editing = False
  
  If lRowEditing = -1 Then lRowEditing = m_lRowEditing
  If lColEditing = -1 Then lColEditing = m_lColEditing
  
  RaiseEvent ColumnAfterEdit(lRowEditing, lColEditing, NewValue, Id, bCancel)
  If bCancel Then
    ctl.Visible = False
    Exit Sub
  End If
  
  With grCtrl.Cell(lRowEditing, lColEditing)
    
    ' Si cierran el form antes de terminar la edicion
    ' oCol es nulo, y da un error que no importa
    ' por lo tanto compruebo que exista un objeto
    ' en oCol antes de seguir
    '
    Dim oCol As cGridColumn
    Set oCol = pGetColumn(lColEditing)
    
    If oCol Is Nothing Then Exit Sub
    
    Select Case pGetColumn(lColEditing).EditType
    
      Case cspNumeric
      
        If pGetColumn(lColEditing).EditSubType = cspPercent Then
          .Text = Val(NewValue) / 100
        Else
          .Text = Val(NewValue)
        End If
      Case cspCheck
        .IconIndex = IIf(Val(NewValue), csECheck, csEUncheck)
      Case Else
        .Text = NewValue
    End Select
    
    .Tag = ValueProcess
    .ItemData = Id
    .TextAlign = m_Columns.Item(lColEditing).Align
    
    If TypeOf ctl Is CSHelp2.cHelp Then
      .Tag = pGetSetValidColorTag(ctl, .Tag)
    End If
    
  End With
  
  ctl.Visible = False
    
  DoEvents: DoEvents: DoEvents: DoEvents
    
  RaiseEvent ColumnAfterUpdate(lRowEditing, lColEditing, NewValue, Id)
  
  GoTo ExitProc
ControlError:
  MngError Err, "pEndEdit", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetSetValidColorTag(ByRef ctl As CSHelp2.cHelp, ByVal Tag As String) As String

  Tag = Replace(Tag, c_HelpInvalidValue, vbNullString)

  If LenB(ctl.Text) And ctl.ValueHelp = "0" And ctl.Id = 0 Then
    pGetSetValidColorTag = c_HelpInvalidValue
  Else
    pGetSetValidColorTag = Tag
  End If
End Function

Private Function pEdit(ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer) As Boolean
  Dim c     As cGridColumn
  Dim ctl   As Control
  
  Set c = pGetColumn(lCol)
  
  ' En grillas agrupadas cuando
  ' se hace click sobre la fila
  ' que contiene al grupo, no tengo
  ' columna que editar
  '
  If c Is Nothing Then
    pEndEditAux
    Exit Function
  End If
  
  If Not c.AllowEdit Then Exit Function
  If Not c.Enabled Then Exit Function
  
  If c.EditType = 0 Then Exit Function
  
  If c.EditType = cspCheck Then
  
    pEndEditAux
  
    Dim CurrentValue As Long
  
    CurrentValue = Val(pGetCurrentValue(c.EditType, lRow, lCol))
    CurrentValue = Not CBool(CurrentValue)
    
    Dim bCancel As Boolean
    RaiseEvent ColumnAfterEdit(lRow, lCol, "", CurrentValue, bCancel)
    If Not bCancel Then
    
      With grCtrl.Cell(lRow, lCol)
        .IconIndex = IIf(CurrentValue, csECheck, csEUncheck)
        .ItemData = CurrentValue
      End With
      
      RaiseEvent ColumnAfterUpdate(lRow, lCol, "", CurrentValue)
    End If
    
    m_EditCtrlId = ctlNoneId
    
  Else
  
    Set ctl = pGetControl(c, c.EditSubType)
    
    pSetPosition ctl, lRow, lCol
    
    ctl.Visible = True
    ctl.ZOrder
    
    SetFocusControl ctl
    
    pSetValue c.EditType, ctl, iKeyAscii, _
              pGetCurrentValue(c.EditType, lRow, lCol), _
              pGetCurrentId(c.EditType, lRow, lCol)
    
    m_lRowEditing = lRow
    m_lColEditing = lCol
    m_Editing = True
  End If
  
  pEdit = True
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

Private Sub pSetValue(ByVal EditType As csTypeABMProperty, ByRef ctl As Control, _
                      ByVal iKeyAscii As Integer, ByVal CurrentValue As Variant, _
                      ByVal CurrentId As Long)
  
  Const chars = "abcdefghijklmnopqrstuvwxyzñ+-"
  
  With ctl
    Dim strChr   As String
    Dim cdblVal  As Double
    Dim lenText  As Long
    Dim NewValue As String
  
    NewValue = CurrentValue
  
    strChr = Chr(iKeyAscii)
    cdblVal = Val(NewValue)
    
    Select Case iKeyAscii
      Case vbKey0 To vbKey9
        NewValue = strChr
    End Select
    
    If InStr(1, chars, LCase(strChr)) > 0 Then
      NewValue = strChr
    End If
    
    Select Case EditType
      Case csTypeABMProperty.cspAdHock, csTypeABMProperty.cspList
        ListSetListIndexForText ctl, NewValue
      
      Case csTypeABMProperty.cspCheck
        If iKeyAscii = vbKeySpace Then
          .Value = IIf(Not CBool(cdblVal), vbChecked, vbUnchecked)
        Else
          .Value = IIf(cdblVal, vbChecked, vbUnchecked)
        End If
      
      Case csTypeABMProperty.cspDate, csTypeABMProperty.cspTime
        If NewValue = "" Then NewValue = Date
        .Edit
        
        ' WARNING BUG
        ' nuevo por si da errores
        '
        If NewValue = "+" Or NewValue = "-" Then
          .SetText NewValue
        
        ' fin nuevo
        
        ' Si es un caracter
        ElseIf Len(NewValue) = 1 Then
          SendKeys NewValue, True
        Else
          .Text = NewValue
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
          If cdblVal = 0 Then
            NewValue = "-"
          Else
            NewValue = Abs(cdblVal) * -1
          End If
        ElseIf iKeyAscii = 43 Then
          NewValue = Abs(cdblVal)
        End If
      
        .Text = NewValue
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
        If .InputDisabled Then
          .Text = CurrentValue
        Else
          .Text = NewValue
        End If
        lenText = Len(.Text)
        .Edit
        
        If iKeyAscii = 0 Then
          .SelStart = 0
          .SelLength = lenText
        Else
          .SelStart = lenText
        End If
      
      Case csTypeABMProperty.cspHelp
        
        .NoSel = True
        .Text = NewValue
        lenText = Len(.Text)
        .ValueHelp = CurrentId
        .ValueUser = NewValue
        .ValueProcess = NewValue
        
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

Private Sub pSetPosition(ByRef ctl As Control, ByVal lRow As Long, ByVal lCol As Long)
  Dim lLeft      As Long
  Dim lTop       As Long
  Dim lWidth     As Long
  Dim lHeight    As Long
  Dim InnerFrame As Integer
  
  If ctl Is Nothing Then Exit Sub
  
  InnerFrame = 30
  
  With grCtrl
    If lRow > .Rows Or lCol > .Columns Then Exit Sub
    
    .CellBoundary lRow, lCol, lLeft, lTop, lWidth, lHeight
  End With
  
  If TypeOf ctl Is ComboBox Then
    ctl.Move lLeft + InnerFrame, lTop + InnerFrame, lWidth - InnerFrame * 2
  Else
    ctl.Move lLeft + InnerFrame, lTop + InnerFrame, lWidth - InnerFrame * 2, lHeight - InnerFrame
  End If
End Sub

Private Function pGetControl(ByRef Col As cGridColumn, ByVal SubType As csSubTypeABMProperty)
  Dim c As Control
  
  Select Case Col.EditType
    Case csTypeABMProperty.cspAdHock
      'RaiseEvent FillsListAdHok(ctlCBhock)
      RaiseEvent FillsListAdHok(ctlCB)
      'Set c = ctlCBhock
      Set c = ctlCB
      m_EditCtrlId = ctlCbHId
      
    Case csTypeABMProperty.cspDate
      ctlMEFE.csType = csMkDate
      Set c = ctlMEFE
      c.Text = Date
      m_EditCtrlId = ctlMefeId
      
    Case csTypeABMProperty.cspTime
      ctlMEFE.csType = csMkTime
      Set c = ctlMEFE
      c.Text = Date
      m_EditCtrlId = ctlMefeId
      
    'Case csTypeABMProperty.cspGrid
    
    Case csTypeABMProperty.cspFile
      Set c = ctlTX
      With c
        .InputDisabled = False
        .Text = ""
        .csType = csMkFile
        .ButtonStyle = cButtonSingle
        .FileFilter = Col.HelpFilter
      End With
      m_EditCtrlId = ctlTxId
      
    Case csTypeABMProperty.cspFolder
      Set c = ctlTX
      With c
        .InputDisabled = False
        .Text = ""
        .csType = csMkFolder
        .ButtonStyle = cButtonSingle
      End With
      m_EditCtrlId = ctlTxId
      
    Case csTypeABMProperty.cspHelp
      Set c = ctlHL
      With c
        .Table = 0
        .Text = ""
        .Id = 0
        .Table = Col.Table
        .Filter = Col.HelpFilter
        .SPFilter = Col.HelpSPFilter
        .SPInfoFilter = Col.HelpSPInfoFilter
        .HelpType = Col.HelpType
        .ForAbm = Col.IsForAbm
      End With
      m_EditCtrlId = ctlHelpId
      
    Case csTypeABMProperty.cspList
      Set c = ctlCB
      pFillList c, Col
      m_EditCtrlId = ctlCbId
    
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
      m_EditCtrlId = ctlMkeId
      
    'Case csTypeABMProperty.cspOption
      
    Case csTypeABMProperty.cspPassword
      Set c = ctlTXPassword
      With c
        .InputDisabled = False
        .Text = ""
        .MaxLength = Col.Size
      End With
      m_EditCtrlId = ctlPassId
      
    Case csTypeABMProperty.cspText
      Set c = ctlTX
      With c
        .InputDisabled = False
        If SubType = cspTextButtonEx Then
          .ButtonStyle = cButtonSingle
        ElseIf SubType = cspTextButton Then
          .ButtonStyle = cButtonSingle
          .InputDisabled = True
        Else
          .ButtonStyle = cButtonNone
        End If
        .csType = csMkText
        .Text = ""
        .MaxLength = Col.Size
      End With
      m_EditCtrlId = ctlTxId
      
  End Select
  
  If Not c Is Nothing Then
    With grCtrl
      c.TabIndex = .TabIndex
      If c.TabIndex > .TabIndex Then c.TabIndex = .TabIndex
    End With
  End If
  
  Set pGetControl = c
End Function

Private Sub pFillList(ByRef c As Object, ByRef Col As cGridColumn)
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

Private Sub grCtrl_RowWasDeleted(ByVal lRow As Long)
  On Error Resume Next
  RaiseEvent RowWasDeleted(lRow)
End Sub

Private Sub grCtrl_ScrollChange()
  On Error Resume Next
  pSetPosition pGetCtrlEdit(), m_lRowEditing, m_lColEditing
End Sub

Private Sub grCtrl_SelectionChange(ByVal lRow As Long, ByVal lCol As Long)
  On Error Resume Next
  RaiseEvent SelectionChange(lRow, lCol)
End Sub

Private Sub grCtrl_SelectionColChange(ByVal lRow As Long, ByVal lCol As Long)
  On Error Resume Next
  RaiseEvent SelectionColChange(lRow, lCol)
End Sub

Private Sub grCtrl_SelectionRowChange(ByVal lRow As Long, ByVal lCol As Long)
  On Error Resume Next
  RaiseEvent SelectionRowChange(lRow, lCol)
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
  Dim ctl   As Control
  
  Set c = pGetColumn(lCol)
  
  With c
    If .EditType = cspCheck Then Exit Sub
    
    Set ctl = pGetControl(c, .EditSubType)
  
    If ctl Is Nothing Then Exit Sub
  
    If Not (ctl Is ctlHL _
         Or ctl Is ctlMKE _
         Or ctl Is ctlMEFE _
         Or .EditType = cspFile _
         Or .EditType = cspFolder _
         Or .EditSubType = cspTextButton _
         Or .EditSubType = cspTextButtonEx) Then
      Exit Sub
    End If
  End With
  
  pEdit lRow, lCol, vbKeyReturn
  
  If c.EditSubType = cspTextButton _
  Or c.EditSubType = cspTextButtonEx Then
    ctlTX_ButtonClick False
  Else
    ctl.ShowHelp
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "pShowHelp", C_Module, ""
  If Err.Number Then Resume ExitProc
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
    
    If .EditType = cspCheck Or .EditType = cspGrid Then
      grCtrl.ColumnEditOnClick(grCtrl.Columns) = True
    End If
    
    Set .Grid = grCtrl
  End With
End Sub

Private Sub tmCombo_Timer()
  On Error Resume Next
  tmCombo.Enabled = False
  
  If m_Unloaded Then
    Exit Sub
  Else
    pEndEdit ctlCB, ctlCB.Text, ListID(ctlCB)
    Err.Clear
  End If
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

Private Function pGetCtrlEdit() As Control
  Dim c As Control
  
  Select Case m_EditCtrlId
    Case ctlCbHId
      'Set c = ctlCBhock
      Set c = ctlCB
      
    Case ctlMefeId
      Set c = ctlMEFE
      
    'Case csTypeABMProperty.cspGrid
    
    Case ctlTxId
      Set c = ctlTX
      
    Case ctlHelpId
      Set c = ctlHL
      
    Case ctlCbId
      Set c = ctlCB
    
    Case ctlMkeId
      Set c = ctlMKE
      
    'Case csTypeABMProperty.cspOption
      
    Case ctlPassId
      Set c = ctlTXPassword
      
  End Select
  
  Set pGetCtrlEdit = c
End Function

Private Function Val(ByVal Value As String) As Double
  Dim SepDecimal As String
  SepDecimal = GetSepDecimal()
  
  ' Despues de 10 años de programar en VB me encuentro
  ' que val si le pasas un % da un type mismatch
  ' quien diria ???
  ' por ende se lo saco y a otra cosa
  Value = Replace(Value, "%", "")
  
  Value = Replace(Value, SepDecimal, ".")
  Val = VBA.Val(Value)
End Function

' construccion - destruccion
Private Sub UserControl_Initialize()
  On Error GoTo ControlError
#If PREPROC_DEBUG Then
  gdbInitInstance C_Module
#End If

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
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub UserControl_Terminate()
  On Error Resume Next
  Set m_Columns = Nothing

#If PREPROC_DEBUG Then
  gdbTerminateInstance C_Module
#End If
End Sub

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

