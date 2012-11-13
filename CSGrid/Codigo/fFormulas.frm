VERSION 5.00
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{532123E7-BCE7-43D6-94ED-AEA94949D5E6}#1.0#0"; "CSComboBox.ocx"
Object = "{757F6B6F-8057-4D0A-85C2-0A1807E33D34}#1.0#0"; "CSGrid2.ocx"
Begin VB.Form fFormulas 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Totales"
   ClientHeight    =   4965
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8325
   Icon            =   "fFormulas.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4965
   ScaleWidth      =   8325
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin CSImageList.cImageList imlColumns 
      Left            =   540
      Top             =   3600
      _ExtentX        =   953
      _ExtentY        =   953
      Size            =   1880
      Images          =   "fFormulas.frx":000C
      KeyCount        =   2
      Keys            =   "ÿ"
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Height          =   330
      Left            =   6825
      TabIndex        =   1
      Top             =   4575
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
      Left            =   5580
      TabIndex        =   2
      Top             =   4575
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
   Begin CSComboBox.cComboBox cbAux 
      Height          =   315
      Left            =   4740
      TabIndex        =   3
      Top             =   1440
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
   Begin CSGrid2.cGrid grFormulas 
      Height          =   3735
      Left            =   60
      TabIndex        =   4
      Top             =   600
      Width           =   8175
      _ExtentX        =   13467
      _ExtentY        =   6588
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
      DisableIcons    =   -1  'True
      EditOnClick     =   -1  'True
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000010&
      X1              =   50
      X2              =   8250
      Y1              =   4440
      Y2              =   4440
   End
   Begin VB.Line Line3 
      BorderColor     =   &H8000000E&
      X1              =   50
      X2              =   8250
      Y1              =   4455
      Y2              =   4455
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Indique las columnas y el el tipo de total (suma, Maximo,etc)"
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
      Left            =   720
      TabIndex        =   0
      Top             =   135
      Width           =   7545
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   90
      Picture         =   "fFormulas.frx":0784
      Top             =   45
      Width           =   480
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H8000000C&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   555
      Left            =   -60
      Top             =   0
      Width           =   8400
   End
End
Attribute VB_Name = "fFormulas"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fFormulas
' 22-11-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fFormulas"

Private Const C_COL_COLUMN = 1
Private Const C_COL_FORMULA = 2

Private Const C_ICON_COLUMN = 0
' estructuras
' variables privadas
Private m_bCancel       As Boolean
Private m_sFieldList()  As String
Private m_sFieldKey()   As String
Private m_iFieldCount   As Long
Private m_iSelCount     As Long
Private m_sSelKey()     As String
Private m_sSelField()   As String
Private m_sSelFormula() As csGridFormulaTypes
Private m_ColumnEdited  As Long
Private m_NoClick       As Boolean
' eventos
' propiedades publicas
Public Property Get SelectionCount() As Long
  SelectionCount = m_iSelCount
End Property
Public Property Get SelectedKey(ByVal iIndex As Long) As String
  SelectedKey = m_sSelKey(iIndex)
End Property
Public Property Get SelectedField(ByVal iIndex As Long) As String
  SelectedField = m_sSelField(iIndex)
End Property
Public Property Get SelectedFormula(ByVal iIndex As Long) As csGridFormulaTypes
  SelectedFormula = m_sSelFormula(iIndex)
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Sub SetFormulas(ByRef Formulas As cGridColFormulas)
  Dim Formula As cGridColFormula
  Dim i       As Long
  
  For Each Formula In Formulas
    With grFormulas
      .AddRow
      With .Cell(.Rows, C_COL_COLUMN)
        .Text = Formula.Column
        .IconIndex = C_ICON_COLUMN
        .ItemData = pGetIdxForKey(Formula.ColumnKey)
      End With
      With .Cell(.Rows, C_COL_FORMULA)
        .Text = pGetFormulaName(Formula.FormulaType)
        .ItemData = Formula.FormulaType
      End With
    End With
  Next
  
  pSort
  
  With grFormulas
    .AddRow
    .CellIcon(.Rows, C_COL_COLUMN) = C_ICON_COLUMN
  End With
End Sub

Private Function pGetIdxForKey(ByVal Key As String) As Long
  Dim n As Long
  For n = 1 To UBound(m_sFieldKey)
    If m_sFieldKey(n) = Key Then
      pGetIdxForKey = n
      Exit Function
    End If
  Next
End Function

Public Sub AddField(ByVal sField As String, ByVal sKey As String)
  m_iFieldCount = m_iFieldCount + 1
  ReDim Preserve m_sFieldList(m_iFieldCount) As String
  ReDim Preserve m_sFieldKey(m_iFieldCount) As String
  m_sFieldList(m_iFieldCount) = sField
  m_sFieldKey(m_iFieldCount) = sKey
End Sub

Public Property Get Cancelled() As Boolean
  Cancelled = m_bCancel
End Property

' funciones friend
' funciones privadas
Private Sub cbAux_Click()
  
  If m_NoClick Then
    m_NoClick = False
    Exit Sub
  End If
  
  cbAux.Visible = False
  If grFormulas.SelectedRow = 0 Then Exit Sub
  
  With grFormulas.Cell(grFormulas.SelectedRow, m_ColumnEdited)
    .Text = cbAux.Text
    .ItemData = cbAux.ItemData(cbAux.ListIndex)
  End With
  With grFormulas
    If .SelectedRow = .Rows _
       And .Cell(.Rows, C_COL_COLUMN).Text <> "" _
       And .Cell(.Rows, C_COL_FORMULA).Text <> "" Then
       .AddRow
       grFormulas.CellIcon(grFormulas.Rows, C_COL_COLUMN) = C_ICON_COLUMN
    End If
  End With
  
  grFormulas.SetFocus
End Sub

Private Sub cbAux_KeyDown(KeyCode As Integer, Shift As Integer)
  If KeyCode = vbKeyDelete And (Shift And vbCtrlMask) = vbCtrlMask Then
    cbAux.Visible = False
    grFormulas.SetFocus
    grFormulas.RemoveRow grFormulas.SelectedRow
  Else
    m_NoClick = True
  End If
End Sub

Private Sub cbAux_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyReturn Then
    m_NoClick = False
    cbAux_Click
  End If
End Sub

Private Sub cmdCancel_Click()
  Unload Me
End Sub

Private Sub cmdOK_Click()
  On Error Resume Next
  
  Dim i As Long
  
  m_bCancel = False
  
  Dim iRow As Long
  
  ReDim Preserve m_sSelField(0)
  ReDim Preserve m_sSelFormula(0)
  ReDim Preserve m_sSelKey(0)
  m_iSelCount = 0
  
  Me.Hide
  
  If grFormulas.Rows > 0 Then
  
    pSort
  
    For i = 1 To grFormulas.Rows
      
      With grFormulas
      
        If .Cell(i, C_COL_COLUMN).Text <> "" And .Cell(i, C_COL_FORMULA).Text <> "" Then
          
          m_iSelCount = m_iSelCount + 1
          
          ReDim Preserve m_sSelField(m_iSelCount)
          ReDim Preserve m_sSelFormula(m_iSelCount)
          ReDim Preserve m_sSelKey(m_iSelCount)
          
          
          iRow = grFormulas.Cell(i, C_COL_COLUMN).ItemData
              
          m_sSelField(m_iSelCount) = m_sFieldList(iRow)
          m_sSelFormula(m_iSelCount) = grFormulas.Cell(i, C_COL_FORMULA).ItemData
          m_sSelKey(m_iSelCount) = m_sFieldKey(iRow)
        End If
      End With
    Next i
  End If
  
  Unload Me
End Sub

Private Sub pSort()
  With grFormulas.SortObject
    .Clear
    .SortColumn(1) = 1
    .SortOrder(1) = CCLOrderAscending
    .SortType(1) = CCLSortString
  End With
  grFormulas.Sort
End Sub

Private Sub pAddColumn(ByVal ColumnName As String, ByVal ColId As Long)
  grFormulas.AddRow
  With grFormulas.Cell(grFormulas.Rows, C_COL_COLUMN)
    .Text = ColumnName
    .ItemData = ColId
    .IconIndex = C_ICON_COLUMN
  End With
End Sub

Private Sub grFormulas_DeleteCellValue(ByVal lRow As Long, ByVal lCol As Long)
  With grFormulas.Cell(lRow, lCol)
    .Text = ""
    .ItemData = 0
  End With
End Sub

Private Sub grFormulas_DeleteRow(ByVal lRow As Long, bCancel As Boolean)
  With grFormulas
    If .Rows <= 1 Then
      bCancel = True
      If .Rows < 1 Then
        .AddRow
        .Cell(1, C_COL_COLUMN).IconIndex = C_ICON_COLUMN
      Else
        With .Cell(1, C_COL_COLUMN)
          .Text = ""
          .ItemData = 0
        End With
        With .Cell(1, C_COL_FORMULA)
          .Text = ""
          .ItemData = 0
        End With
      End If
    End If
  End With
End Sub

Private Sub grFormulas_RequestEdit(ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  Dim lLeft     As Long
  Dim lTop      As Long
  Dim lWidth    As Long
  Dim lHeight   As Long
  
  grFormulas.CellBoundary lRow, lCol, lLeft, lTop, lWidth, lHeight
  
  lLeft = grFormulas.Left + lLeft
  lTop = grFormulas.Top + lTop
  
  With cbAux
    .Left = lLeft
    .Width = lWidth
    .Top = lTop
    .Visible = True
    .SetFocus
  End With
  
  Select Case lCol
  
    Case C_COL_FORMULA
      pFillFormula
    Case C_COL_COLUMN
      pFillColumn
    
  End Select
  
  If iKeyAscii <> 0 Then
    SendKeys "{F4}"
    SendKeys Chr(iKeyAscii)
  Else
    m_NoClick = True
    ListSetListIndexForText cbAux, grFormulas.Cell(lRow, lCol).Text
    m_NoClick = False
  End If
  
  m_ColumnEdited = lCol
End Sub

Private Function pGetFormulaName(ByVal FormulaType As csGridFormulaTypes) As String
  Select Case FormulaType
    Case csGrFTAverage
      pGetFormulaName = "Promedio"
    Case csGrFTMax
      pGetFormulaName = "Maximo"
    Case csGrFTMin
      pGetFormulaName = "Minimo"
    Case csGrFTSum
      pGetFormulaName = "Sumar"
    Case csGrFTCount
      pGetFormulaName = "Contar"
  End Select
End Function

Private Sub pFillFormula()
  cbAux.Clear
  With cbAux
    .AddItem pGetFormulaName(csGrFTAverage)
    .ItemData(.NewIndex) = csGrFTAverage
    .AddItem pGetFormulaName(csGrFTMax)
    .ItemData(.NewIndex) = csGrFTMax
    .AddItem pGetFormulaName(csGrFTMin)
    .ItemData(.NewIndex) = csGrFTMin
    .AddItem pGetFormulaName(csGrFTSum)
    .ItemData(.NewIndex) = csGrFTSum
    .AddItem pGetFormulaName(csGrFTCount)
    .ItemData(.NewIndex) = csGrFTCount
  End With
End Sub

Private Sub pFillColumn()
  Dim i As Long
  
  cbAux.Clear
  For i = 1 To UBound(m_sFieldList)
    With cbAux
      .AddItem m_sFieldList(i)
      .ItemData(.NewIndex) = i
    End With
  Next
End Sub
' construccion - destruccion
Private Sub Form_Initialize()
  m_iFieldCount = 0
  ReDim m_sFieldList(0) As String
End Sub

Private Sub Form_Load()
  Dim i As Long
  
  CenterForm Me
  
  m_bCancel = True
  
  grFormulas.GridLines = True
  
  grFormulas.AddColumn , "Columna", , , (grFormulas.Width * 0.75 - 100) / Screen.TwipsPerPixelX
  grFormulas.AddColumn , "Formula", , , (grFormulas.Width * 0.25 - 100) / Screen.TwipsPerPixelX
  
  grFormulas.ImageList = imlColumns
  grFormulas.Editable = True
  grFormulas.MultiSelect = False
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



