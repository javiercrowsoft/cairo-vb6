VERSION 5.00
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{532123E7-BCE7-43D6-94ED-AEA94949D5E6}#1.0#0"; "CSComboBox.ocx"
Object = "{757F6B6F-8057-4D0A-85C2-0A1807E33D34}#1.7#0"; "CSGrid2.ocx"
Begin VB.Form fGroups 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Grupos"
   ClientHeight    =   4680
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6585
   ForeColor       =   &H80000008&
   Icon            =   "fGroups.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4680
   ScaleWidth      =   6585
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSImageList.cImageList imlColumns 
      Left            =   2460
      Top             =   4140
      _ExtentX        =   953
      _ExtentY        =   953
      Size            =   1880
      Images          =   "fGroups.frx":000C
      KeyCount        =   2
      Keys            =   "ÿ"
   End
   Begin CSComboBox.cComboBox cboOrder 
      Height          =   315
      Left            =   3555
      TabIndex        =   9
      Top             =   1740
      Visible         =   0   'False
      Width           =   1725
      _ExtentX        =   3043
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
   Begin CSButton.cButtonLigth cmdMoveDown 
      Height          =   300
      Left            =   6165
      TabIndex        =   7
      Top             =   990
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   529
      Caption         =   "u"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Marlett"
         Size            =   18
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Marlett"
      FontSize        =   18
      ForeColor       =   -2147483632
   End
   Begin CSButton.cButtonLigth cmdMoveUp 
      Height          =   300
      Left            =   6165
      TabIndex        =   6
      Top             =   630
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   529
      Caption         =   "t"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Marlett"
         Size            =   18
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Marlett"
      FontSize        =   18
      ForeColor       =   -2147483632
   End
   Begin CSButton.cButtonLigth cmdRemove 
      Height          =   300
      Left            =   2520
      TabIndex        =   5
      Top             =   990
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   529
      Caption         =   "3"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Marlett"
         Size            =   18
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Marlett"
      FontSize        =   18
      ForeColor       =   -2147483632
   End
   Begin CSGrid2.cGrid grGroups 
      Height          =   3435
      Left            =   2950
      TabIndex        =   4
      Top             =   630
      Width           =   3140
      _ExtentX        =   5503
      _ExtentY        =   6059
      MultiSelect     =   -1  'True
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
      BorderStyle     =   2
      EditOnClick     =   -1  'True
   End
   Begin CSButton.cButtonLigth cmdAdd 
      Height          =   300
      Left            =   2520
      TabIndex        =   3
      Top             =   630
      Width           =   375
      _ExtentX        =   661
      _ExtentY        =   529
      Caption         =   "4"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Marlett"
         Size            =   18
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Marlett"
      FontSize        =   18
      ForeColor       =   -2147483632
   End
   Begin CSGrid2.cGrid grColumns 
      Height          =   3435
      Left            =   80
      TabIndex        =   2
      Top             =   630
      Width           =   2390
      _ExtentX        =   4233
      _ExtentY        =   6059
      MultiSelect     =   -1  'True
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
      BorderStyle     =   2
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Height          =   330
      Left            =   4995
      TabIndex        =   1
      Top             =   4275
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   582
      Caption         =   "&Cancelar"
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
   Begin CSButton.cButtonLigth cmdOK 
      Height          =   330
      Left            =   3780
      TabIndex        =   0
      Top             =   4275
      Width           =   1140
      _ExtentX        =   2011
      _ExtentY        =   582
      Caption         =   "&Aceptar"
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
   Begin VB.Image Image1 
      Height          =   480
      Left            =   45
      Picture         =   "fGroups.frx":0784
      Top             =   45
      Width           =   480
   End
   Begin VB.Label lbTtitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Seleccione las columnas para agrupar"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   330
      Left            =   675
      TabIndex        =   8
      Top             =   135
      Width           =   5865
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H8000000C&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   555
      Left            =   -45
      Top             =   0
      Width           =   6720
   End
   Begin VB.Line Line3 
      BorderColor     =   &H8000000E&
      X1              =   -90
      X2              =   6705
      Y1              =   4155
      Y2              =   4155
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000010&
      X1              =   -90
      X2              =   6705
      Y1              =   4140
      Y2              =   4140
   End
End
Attribute VB_Name = "fGroups"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fGroups
' 20-11-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fGroups"

Private Const C_COL_COLUMNS_COLUMN = 1
Private Const C_COL_GROUP_COLUMN = 1
Private Const C_COL_GROUP_SORT_ORDER = 2

Private Const C_TEXT_ASCENDING = "A-Z"
Private Const C_TEXT_DECENDING = "Z-A"

Private Const C_ASCENDING = 1
Private Const C_DESCENDING = 2

Private Const C_ICON_COLUMN = 0
Private Const C_ICON_GROUP = 1

' estructuras
' variables privadas
Private m_bCancel       As Boolean
Private m_sFieldList()  As String
Private m_sFieldKey()   As String
Private m_iFieldCount   As Long
Private m_iSelCount     As Long
Private m_sSelKey()     As String
Private m_sSelField()   As String
Private m_eSelOrder()   As cShellSortOrderCOnstants
Private m_Done          As Boolean
Private m_NoClick       As Boolean
Private m_bHideColumns  As Boolean
' eventos
' propiedades publicas
Public Property Get SelectionCount() As Long
  SelectionCount = m_iSelCount
End Property
Public Property Get SelectedKey(ByVal iIndex As Long) As String
  SelectedKey = m_sSelKey(iIndex)
End Property
Public Property Get SelectedOrder(ByVal iIndex As Long) As cShellSortOrderCOnstants
  SelectedOrder = m_eSelOrder(iIndex)
End Property
Public Property Get SelectedField(ByVal iIndex As Long) As String
  SelectedField = m_sSelField(iIndex)
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Sub SetHideColumns(ByRef Grid As Object)
  On Error Resume Next
  
  cmdMoveDown.Visible = False
  cmdMoveUp.Visible = False
  Me.Width = 6260
  Me.Caption = "Ocultar Columnas"
  lbTtitle.Caption = "Seleccione las columnas a ocultar"
  
  grGroups.ColumnVisible(2) = False
  
  Dim j As Long
  Dim i As Long
  
  For j = 1 To Grid.Columns
    If Not Grid.ColumnVisible(j) Then
      If InStr(1, LCase$(Grid.ColumnHeader(j)), c_IdColPrefix) = 0 Then
        
        For i = 1 To grColumns.Rows
          If Grid.ColumnHeader(j) = grColumns.Cell(i, C_COL_COLUMNS_COLUMN).Text Then
            grColumns.SelectedRow = i
            grColumns.SelectedCol = 1
            cmdAdd_Click
            Exit For
          End If
        Next
      End If
    End If
  Next
  
  m_bHideColumns = True
End Sub

Public Sub SetGroups(ByRef Groups As Object)
  Dim Group As cGridGroup
  Dim i     As Long
  
  For Each Group In Groups
    For i = 1 To grColumns.Rows
      If Group.Name = grColumns.Cell(i, C_COL_COLUMNS_COLUMN).Text Then
        grColumns.SelectedRow = i
        grColumns.SelectedCol = 1
        cmdAdd_Click
        Exit For
      End If
    Next
  Next
End Sub

Public Sub AddField(ByVal sField As String, ByVal sKey As String)
  m_iFieldCount = m_iFieldCount + 1
  ReDim Preserve m_sFieldList(m_iFieldCount) As String
  ReDim Preserve m_sFieldKey(m_iFieldCount) As String
  m_sFieldList(m_iFieldCount) = sField
  m_sFieldKey(m_iFieldCount) = sKey

  pAddColumn m_sFieldList(m_iFieldCount), m_iFieldCount
End Sub

Public Property Get Cancelled() As Boolean
  Cancelled = m_bCancel
End Property

' funciones friend
' funciones privadas
Private Sub cboOrder_Click()
  If m_NoClick Then
    m_NoClick = False
    Exit Sub
  End If
  
  cboOrder.Visible = False
  If grGroups.SelectedRow = 0 Then Exit Sub
  
  With grGroups.Cell(grGroups.SelectedRow, C_COL_GROUP_SORT_ORDER)
    .Text = cboOrder.Text
    .ItemData = cboOrder.ItemData(cboOrder.ListIndex)
  End With
  
  grGroups.SetFocus
End Sub

Private Sub cboOrder_KeyDown(KeyCode As Integer, Shift As Integer)
  m_NoClick = True
End Sub

Private Sub cboOrder_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyReturn Then
    m_NoClick = False
    cboOrder_Click
  End If
End Sub

Private Sub cmdCancel_Click()
  Unload Me
End Sub

Private Sub cmdMoveDown_Click()
  Dim tmpCol As String
  Dim tmpIdx As Long
  Dim Idx    As Long
  
  If grGroups.SelectedRow = 0 Then Exit Sub
  
  If grGroups.SelectedRow = grGroups.Rows Then Exit Sub
  
  Idx = grGroups.SelectedRow
  
  With grGroups.Cell(Idx, C_COL_GROUP_COLUMN)
    tmpCol = .Text
    tmpIdx = .ItemData
    .Text = grGroups.Cell(Idx + 1, C_COL_GROUP_COLUMN).Text
    .ItemData = grGroups.Cell(Idx + 1, C_COL_GROUP_COLUMN).ItemData
  End With

  With grGroups.Cell(Idx + 1, C_COL_GROUP_COLUMN)
    .Text = tmpCol
    .ItemData = tmpIdx
  End With

  With grGroups.Cell(Idx, C_COL_GROUP_SORT_ORDER)
    tmpCol = .Text
    tmpIdx = .ItemData
    .Text = grGroups.Cell(Idx + 1, C_COL_GROUP_SORT_ORDER).Text
    .ItemData = grGroups.Cell(Idx + 1, C_COL_GROUP_SORT_ORDER).ItemData
  End With

  With grGroups.Cell(Idx + 1, C_COL_GROUP_SORT_ORDER)
    .Text = tmpCol
    .ItemData = tmpIdx
  End With
  
  grGroups.SelectedRow = Idx + 1
End Sub

Private Sub cmdMoveUp_Click()
  Dim tmpCol As String
  Dim tmpIdx As Long
  Dim Idx    As Long
  
  If grGroups.SelectedRow <= 1 Then Exit Sub
  
  Idx = grGroups.SelectedRow
  
  With grGroups.Cell(Idx, C_COL_GROUP_COLUMN)
    tmpCol = .Text
    tmpIdx = .ItemData
    .Text = grGroups.Cell(Idx - 1, C_COL_GROUP_COLUMN).Text
    .ItemData = grGroups.Cell(Idx - 1, C_COL_GROUP_COLUMN).ItemData
  End With

  With grGroups.Cell(Idx - 1, C_COL_GROUP_COLUMN)
    .Text = tmpCol
    .ItemData = tmpIdx
  End With

  With grGroups.Cell(Idx, C_COL_GROUP_SORT_ORDER)
    tmpCol = .Text
    tmpIdx = .ItemData
    .Text = grGroups.Cell(Idx - 1, C_COL_GROUP_SORT_ORDER).Text
    .ItemData = grGroups.Cell(Idx - 1, C_COL_GROUP_SORT_ORDER).ItemData
  End With

  With grGroups.Cell(Idx - 1, C_COL_GROUP_SORT_ORDER)
    .Text = tmpCol
    .ItemData = tmpIdx
  End With
  
  grGroups.SelectedRow = Idx - 1
End Sub

Private Sub cmdOK_Click()
  On Error Resume Next
  
  Dim i As Long
  
  m_bCancel = False
  
  Dim iRow As Long
  
  For i = 1 To grGroups.Rows
    m_iSelCount = m_iSelCount + 1
    ReDim Preserve m_sSelField(1 To m_iSelCount) As String
    
    iRow = grGroups.Cell(i, C_COL_GROUP_COLUMN).ItemData
        
    m_sSelField(m_iSelCount) = m_sFieldList(iRow)
                                               
    ReDim Preserve m_sSelKey(1 To m_iSelCount) As String
    m_sSelKey(m_iSelCount) = m_sFieldKey(iRow)
    
    If Not m_bHideColumns Then
    
      ReDim Preserve m_eSelOrder(1 To m_iSelCount) As cShellSortOrderCOnstants
      If grGroups.Cell(i, C_COL_GROUP_SORT_ORDER).ItemData = C_DESCENDING Then
        m_eSelOrder(m_iSelCount) = CCLOrderDescending
      Else
        m_eSelOrder(m_iSelCount) = CCLOrderAscending
      End If
    End If
  Next i
  
  Unload Me
End Sub

Private Sub cmdAdd_Click()
  On Error Resume Next
  
  Dim i As Long
  
  i = 1
  
  Do While i <= grColumns.Rows
    If grColumns.IsRowSelected(i) Then
      grGroups.AddRow
      With grGroups.Cell(grGroups.Rows, C_COL_GROUP_COLUMN)
        .Text = grColumns.Cell(i, C_COL_COLUMNS_COLUMN).Text
        .ItemData = grColumns.Cell(i, C_COL_COLUMNS_COLUMN).ItemData
        .IconIndex = C_ICON_GROUP
      End With
      
      If Not m_bHideColumns Then
        With grGroups.Cell(grGroups.Rows, C_COL_GROUP_SORT_ORDER)
          .Text = C_TEXT_ASCENDING
          .ItemData = C_ASCENDING
        End With
      End If
      
      grColumns.RemoveRow i
    Else
      i = i + 1
    End If
  Loop
End Sub

Private Sub cmdRemove_Click()
  On Error Resume Next
  
  Dim i As Long
  
  i = 1
  Do While i <= grGroups.Rows
    
    If grGroups.IsRowSelected(i) Then
      grColumns.AddRow
      With grColumns.Cell(grColumns.Rows, C_COL_COLUMNS_COLUMN)
        .Text = grGroups.Cell(i, C_COL_GROUP_COLUMN).Text
        .ItemData = grGroups.Cell(i, C_COL_GROUP_COLUMN).ItemData
        .IconIndex = C_ICON_COLUMN
      End With
      grGroups.RemoveRow i
    Else
      i = i + 1
    End If
  Loop
End Sub

Private Sub pSort()
  With grColumns.SortObject
    .Clear
    .SortColumn(1) = 1
    .SortOrder(1) = CCLOrderAscending
    .SortType(1) = CCLSortString
  End With
  grColumns.Sort
End Sub

Private Sub pAddColumn(ByVal ColumnName As String, ByVal ColId As Long)
  grColumns.AddRow
  With grColumns.Cell(grColumns.Rows, C_COL_COLUMNS_COLUMN)
    .Text = ColumnName
    .ItemData = ColId
    .IconIndex = C_ICON_COLUMN
  End With
End Sub

Private Sub grGroups_RequestEdit(ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  If lCol = C_COL_GROUP_SORT_ORDER Then
    Dim lLeft     As Long
    Dim lTop      As Long
    Dim lWidth    As Long
    Dim lHeight   As Long
    
    grGroups.CellBoundary lRow, lCol, lLeft, lTop, lWidth, lHeight
    
    lLeft = grGroups.Left + lLeft
    lTop = grGroups.Top + lTop
    
    With cboOrder
      .Left = lLeft
      .Width = lWidth
      .Top = lTop
      .Visible = True
      .SetFocus
    End With
    
    If iKeyAscii <> 0 Then
      SendKeys "{F4}"
      SendKeys Chr(iKeyAscii)
    Else
      m_NoClick = True
      ListSetListIndexForText cboOrder, grGroups.Cell(lRow, lCol).Text
      m_NoClick = False
    End If
  
  End If
End Sub
' construccion - destruccion
Private Sub Form_Activate()
  If m_Done Then Exit Sub
  m_Done = False
  pSort
  grColumns.ScrollVerticalForceShowHide
  grGroups.ScrollVerticalForceShowHide
End Sub

Private Sub Form_Initialize()
  m_iFieldCount = 0
  ReDim m_sFieldList(0) As String
End Sub

Private Sub Form_Load()
  Dim i As Long
  
  CenterForm Me
  
  m_bCancel = True
  
  With cboOrder
    .AddItem C_TEXT_ASCENDING
    .ItemData(.NewIndex) = C_ASCENDING
  End With
  
  With cboOrder
    .AddItem C_TEXT_DECENDING
    .ItemData(.NewIndex) = C_DESCENDING
  End With
  
  grColumns.AddColumn , "Columnas", , , _
                      (grColumns.Width - 400) / Screen.TwipsPerPixelX
  grGroups.AddColumn , "Columnas", , , _
                      (grColumns.Width - 200) / Screen.TwipsPerPixelX
  grGroups.AddColumn , "Ordenar", , , _
                      (grGroups.Width - (grColumns.Width - 100)) / Screen.TwipsPerPixelX
  
  grColumns.ImageList = imlColumns
  grGroups.ImageList = imlColumns
  grGroups.Editable = True
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

