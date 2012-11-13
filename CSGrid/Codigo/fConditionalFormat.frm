VERSION 5.00
Object = "{E82A759A-7510-4F56-B239-9C0B78CF437B}#1.0#0"; "CSImageList.ocx"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{757F6B6F-8057-4D0A-85C2-0A1807E33D34}#1.0#0"; "CSGrid2.ocx"
Begin VB.Form fConditionalFormat 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Formato Condicional"
   ClientHeight    =   4920
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8310
   Icon            =   "fConditionalFormat.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4920
   ScaleWidth      =   8310
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.ComboBox cbAux1 
      Height          =   315
      Left            =   4590
      Sorted          =   -1  'True
      TabIndex        =   6
      Top             =   1530
      Visible         =   0   'False
      Width           =   1545
   End
   Begin VB.ComboBox cbAux2 
      Height          =   315
      Left            =   4680
      Sorted          =   -1  'True
      Style           =   2  'Dropdown List
      TabIndex        =   5
      Top             =   2115
      Visible         =   0   'False
      Width           =   1545
   End
   Begin CSButton.cButtonLigth cmdHelp 
      Height          =   315
      Left            =   3300
      TabIndex        =   4
      Top             =   1980
      Visible         =   0   'False
      Width           =   195
      _ExtentX        =   344
      _ExtentY        =   556
      Caption         =   "..."
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
      ForeColor       =   0
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Height          =   330
      Left            =   6840
      TabIndex        =   0
      Top             =   4515
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
      Left            =   5595
      TabIndex        =   1
      Top             =   4515
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
   Begin CSImageList.cImageList imlColumns 
      Left            =   720
      Top             =   3240
      _ExtentX        =   953
      _ExtentY        =   953
      Size            =   1880
      Images          =   "fConditionalFormat.frx":000C
      KeyCount        =   2
      Keys            =   "ÿ"
   End
   Begin CSGrid2.cGrid grFormats 
      Height          =   3675
      Left            =   60
      TabIndex        =   3
      Top             =   600
      Width           =   8175
      _ExtentX        =   14420
      _ExtentY        =   6482
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
      Editable        =   -1  'True
      EditOnClick     =   -1  'True
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   120
      Picture         =   "fConditionalFormat.frx":0784
      Top             =   60
      Width           =   480
   End
   Begin VB.Label lbTitle 
      BackStyle       =   0  'Transparent
      Caption         =   "Indique las columnas, las condiciones y el formato"
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
      Left            =   780
      TabIndex        =   2
      Top             =   135
      Width           =   7545
   End
   Begin VB.Line Line3 
      BorderColor     =   &H8000000E&
      X1              =   60
      X2              =   8260
      Y1              =   4395
      Y2              =   4395
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000010&
      X1              =   60
      X2              =   8260
      Y1              =   4380
      Y2              =   4380
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H8000000C&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   555
      Left            =   0
      Top             =   0
      Width           =   8400
   End
End
Attribute VB_Name = "fConditionalFormat"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fConditionalFormat
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
Private Const C_Module = "fConditionalFormat"

Private Const C_COL_COLUMN = 1
Private Const C_COL_OPERATOR = 2
Private Const C_COL_VALUE = 3
Private Const C_COL_BACKCOLOR = 4
Private Const C_COL_FORECOLOR = 5
Private Const C_COL_FONTFORMAT = 6

Private Const C_ICON_COLUMN = 0
' estructuras
' variables privadas
Private m_bCancel       As Boolean
Private m_sFieldList()  As String
Private m_sFieldKey()   As String
Private m_iFieldCount   As Long
Private m_iSelCount     As Long
Private m_sSelKey()     As String
Private m_sSelKey2()    As String
Private m_sSelField()   As String
Private m_sSelField2()  As String
Private m_eSelOperator() As csGridFormatOperator
Private m_sSelCompareTo()    As String
Private m_iSelBackColor()    As Long
Private m_iSelForeColor()    As Long
Private m_oSelFont()         As StdFont
Private m_ColumnEdited       As Long
Private m_NoClick            As Boolean

Private m_bEditingFilters    As Boolean

Private m_bAddValue          As Boolean

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
Public Property Get SelectedField2(ByVal iIndex As Long) As String
  SelectedField2 = m_sSelField2(iIndex)
End Property
Public Property Get SelectedOperator(ByVal iIndex As Long) As csGridFormatOperator
  SelectedOperator = m_eSelOperator(iIndex)
End Property
Public Property Get SelectedKey2(ByVal iIndex As Long) As String
  SelectedKey2 = m_sSelKey2(iIndex)
End Property
Public Property Get SelectedCompareTo(ByVal iIndex As Long) As String
  SelectedCompareTo = m_sSelCompareTo(iIndex)
End Property
Public Property Get SelectedForeColor(ByVal iIndex As Long) As Long
  SelectedForeColor = m_iSelForeColor(iIndex)
End Property
Public Property Get SelectedBackColor(ByVal iIndex As Long) As Long
  SelectedBackColor = m_iSelBackColor(iIndex)
End Property
Public Property Get SelectedFont(ByVal iIndex As Long) As StdFont
  Set SelectedFont = m_oSelFont(iIndex)
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Sub SetFormats(ByRef Formats As cGridColFormats)
  Dim Format  As cGridColFormat
  Dim i       As Long
  Dim sFnt    As StdFont
  
  For Each Format In Formats
    With grFormats
      .AddRow
      With .Cell(.Rows, C_COL_COLUMN)
        .Text = Format.Column
        .IconIndex = C_ICON_COLUMN
        .ItemData = pGetIdxForKey(Format.ColumnKey)
      End With
      With .Cell(.Rows, C_COL_OPERATOR)
        .Text = pGetOperatorName(Format.Operator)
        .ItemData = Format.Operator
      End With
      With .Cell(.Rows, C_COL_VALUE)
        If Format.ColumnKey2 <> "" Then
          .Text = Format.Column2
          .IconIndex = C_ICON_COLUMN
          .ItemData = pGetIdxForKey(Format.ColumnKey2)
        Else
          .Text = Format.CompareTo
          .ItemData = -1
        End If
      End With
      If Format.ForeColor <> -1 Then
        Set sFnt = grFormats.CellFont(.Rows, C_COL_FORECOLOR)
        sFnt.Name = "Marlett"
        sFnt.Size = 12
        grFormats.CellFont(.Rows, C_COL_FORECOLOR) = sFnt
        With .Cell(.Rows, C_COL_FORECOLOR)
          .Text = "g"
          .ForeColor = Format.ForeColor
        End With
      End If
      If Format.BackColor <> -1 Then
        Set sFnt = grFormats.CellFont(.Rows, C_COL_BACKCOLOR)
        sFnt.Name = "Marlett"
        sFnt.Size = 12
        grFormats.CellFont(.Rows, C_COL_BACKCOLOR) = sFnt
        With .Cell(.Rows, C_COL_BACKCOLOR)
          .Text = "g"
          .ForeColor = Format.BackColor
        End With
      End If
      If Not Format.Font Is Nothing Then
        With .Cell(.Rows, C_COL_FONTFORMAT)
          Set .Font = Format.Font
          .Text = Format.Font.Name
        End With
      End If
    End With
  Next
  
  pSort
  
  With grFormats
    .AddRow
    .Cell(.Rows, C_COL_COLUMN).IconIndex = C_ICON_COLUMN
  End With
End Sub

Public Sub SetFilters(ByRef Filters As cGridColFilters)
  Dim Filter  As cGridColFilter
  Dim i       As Long
  Dim sFnt    As StdFont
  
  For Each Filter In Filters
    With grFormats
      .AddRow
      With .Cell(.Rows, C_COL_COLUMN)
        .Text = Filter.Column
        .IconIndex = C_ICON_COLUMN
        .ItemData = pGetIdxForKey(Filter.ColumnKey)
      End With
      With .Cell(.Rows, C_COL_OPERATOR)
        .Text = pGetOperatorName(Filter.Operator)
        .ItemData = Filter.Operator
      End With
      With .Cell(.Rows, C_COL_VALUE)
        If Filter.ColumnKey2 <> "" Then
          .Text = Filter.Column2
          .IconIndex = C_ICON_COLUMN
          .ItemData = pGetIdxForKey(Filter.ColumnKey2)
        Else
          .Text = Filter.CompareTo
          .ItemData = -1
        End If
      End With
    End With
  Next
  
  pSort
  
  With grFormats
    .AddRow
    .Cell(.Rows, C_COL_COLUMN).IconIndex = C_ICON_COLUMN
    
    .ColumnVisible(C_COL_BACKCOLOR) = False
    .ColumnVisible(C_COL_FORECOLOR) = False
    .ColumnVisible(C_COL_FONTFORMAT) = False
    
    m_bEditingFilters = True
  End With
  
  Me.Caption = "Filtros"
  Me.lbTitle.Caption = "Indique las columnas y las condiciones"
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
Private Sub pAddRowIfIsComplete()
  With grFormats
    If .SelectedRow = .Rows _
       And .Cell(.Rows, C_COL_COLUMN).Text <> "" _
       And .Cell(.Rows, C_COL_OPERATOR).Text <> "" _
       And .Cell(.Rows, C_COL_VALUE).Text <> "" _
       And (.Cell(.Rows, C_COL_FORECOLOR).Text <> "" _
       Or .Cell(.Rows, C_COL_BACKCOLOR).Text <> "" _
       Or .Cell(.Rows, C_COL_FONTFORMAT).Text <> "" _
       Or m_bEditingFilters) _
       Then
       .AddRow
       grFormats.CellIcon(grFormats.Rows, C_COL_COLUMN) = C_ICON_COLUMN
       
    End If
  End With
End Sub

Private Sub pEndEdit()
  If m_NoClick Then
    m_NoClick = False
  Else
    If m_bAddValue Then
      cbAux1_Click
    Else
      cbAux2_Click
    End If
  End If
End Sub

Private Sub cmdCancel_Click()
  Unload Me
End Sub

Private Sub cmdHelp_Click()
  Dim sFnt      As StdFont
  Dim lRow      As Long
  Dim lCol      As Long
  Dim Color     As Long
  
  lRow = grFormats.SelectedRow
  lCol = m_ColumnEdited
  
  Select Case m_ColumnEdited
    Case C_COL_BACKCOLOR, C_COL_FORECOLOR
      If VBChooseColor(Color, , , , Me.hWnd) Then
        
        Set sFnt = grFormats.CellFont(lRow, lCol)
        sFnt.Name = "Marlett"
        sFnt.Size = 12
        grFormats.CellFont(lRow, lCol) = sFnt
        With grFormats.Cell(lRow, lCol)
          .ForeColor = Color
          .Text = "g"
        End With
        cmdHelp.Visible = False
        pAddRowIfIsComplete
        grFormats.SetFocus
      End If
    Case C_COL_FONTFORMAT
    
      Dim iFnt          As IFont
      
      Set iFnt = grFormats.CellFont(lRow, lCol)
      iFnt.Clone sFnt
      Set iFnt = Nothing
      
      If VBChooseFont(sFnt, , Me.hWnd) Then
        grFormats.CellFont(lRow, lCol) = sFnt
        grFormats.CellText(lRow, lCol) = sFnt.Name
        cmdHelp.Visible = False
        pAddRowIfIsComplete
        grFormats.SetFocus
      End If
  End Select
End Sub

Private Sub cmdOK_Click()
  On Error Resume Next
  
  Dim i As Long
  
  m_bCancel = False
  
  Dim iRow As Long
  
  If cbAux.Visible Then
    m_NoClick = False
    pEndEdit
  End If
  
  ReDim Preserve m_sSelField(0)
  ReDim Preserve m_sSelField2(0)
  ReDim Preserve m_eSelOperator(0)
  ReDim Preserve m_sSelKey(0)
  ReDim Preserve m_sSelKey2(0)
  ReDim Preserve m_sSelCompareTo(0)
  ReDim Preserve m_iSelBackColor(0)
  ReDim Preserve m_iSelForeColor(0)
  ReDim Preserve m_oSelFont(0)
  m_iSelCount = 0
  
  Me.Hide
  
  If grFormats.Rows > 0 Then
  
    pSort
  
    For i = 1 To grFormats.Rows
      
      With grFormats
      
        If .Cell(i, C_COL_COLUMN).Text <> "" _
            And .Cell(i, C_COL_OPERATOR).Text <> "" _
            And .Cell(i, C_COL_VALUE).Text <> "" _
            And (.Cell(i, C_COL_FORECOLOR).Text <> "" _
            Or .Cell(i, C_COL_BACKCOLOR).Text <> "" _
            Or .Cell(i, C_COL_FONTFORMAT).Text <> "" _
            Or m_bEditingFilters) Then
          
          m_iSelCount = m_iSelCount + 1
          
          ReDim Preserve m_sSelField(m_iSelCount)
          ReDim Preserve m_sSelField2(m_iSelCount)
          ReDim Preserve m_eSelOperator(m_iSelCount)
          ReDim Preserve m_sSelKey(m_iSelCount)
          ReDim Preserve m_sSelKey2(m_iSelCount)
          ReDim Preserve m_sSelCompareTo(m_iSelCount)
          ReDim Preserve m_iSelBackColor(m_iSelCount)
          ReDim Preserve m_iSelForeColor(m_iSelCount)
          ReDim Preserve m_oSelFont(m_iSelCount)
          
          iRow = grFormats.Cell(i, C_COL_COLUMN).ItemData
              
          m_sSelField(m_iSelCount) = m_sFieldList(iRow)
          m_eSelOperator(m_iSelCount) = grFormats.Cell(i, C_COL_OPERATOR).ItemData
          m_sSelKey(m_iSelCount) = m_sFieldKey(iRow)
        
          iRow = grFormats.Cell(i, C_COL_VALUE).ItemData
          If iRow = -1 Then
            m_sSelCompareTo(m_iSelCount) = grFormats.Cell(i, C_COL_VALUE).Text
          Else
            m_sSelKey2(m_iSelCount) = m_sFieldKey(iRow)
            m_sSelField2(m_iSelCount) = m_sFieldList(iRow)
          End If
          
          With grFormats.Cell(i, C_COL_BACKCOLOR)
            If .Text <> "" Then
              m_iSelBackColor(m_iSelCount) = .ForeColor
            Else
              m_iSelBackColor(m_iSelCount) = -1
            End If
          End With
          With grFormats.Cell(i, C_COL_FORECOLOR)
            If .Text <> "" Then
              m_iSelForeColor(m_iSelCount) = .ForeColor
            Else
              m_iSelForeColor(m_iSelCount) = -1
            End If
          End With
          With grFormats.Cell(i, C_COL_FONTFORMAT)
            If .Text <> "" Then
              Set m_oSelFont(m_iSelCount) = .Font
            End If
          End With
        End If
      End With
    Next i
  End If
  
  Unload Me
End Sub

Private Sub pSort()
  Dim i As Long
  
  i = 1
  Do While i <= grFormats.Rows And grFormats.Rows > 1
    If grFormats.CellText(i, C_COL_COLUMN) = "" Then
      grFormats.RemoveRow i
    Else
      i = i + 1
    End If
  Loop
  
  With grFormats.SortObject
    .Clear
    .SortColumn(1) = 1
    .SortOrder(1) = CCLOrderAscending
    .SortType(1) = CCLSortString
  End With
  grFormats.Sort
End Sub

Private Sub pAddColumn(ByVal ColumnName As String, ByVal ColId As Long)
  grFormats.AddRow
  With grFormats.Cell(grFormats.Rows, C_COL_COLUMN)
    .Text = ColumnName
    .ItemData = ColId
    .IconIndex = C_ICON_COLUMN
  End With
End Sub

Private Sub grFormats_DeleteCellValue(ByVal lRow As Long, ByVal lCol As Long)
  With grFormats.Cell(lRow, lCol)
    .Text = ""
    .ItemData = 0
  End With
End Sub

Private Sub grFormats_DeleteRow(ByVal lRow As Long, bCancel As Boolean)
  With grFormats
    If .Rows <= 1 Then
      bCancel = True
      If .Rows < 1 Then
        .AddRow
        .CellIcon(1, C_COL_COLUMN) = C_ICON_COLUMN
      Else
        With .Cell(1, C_COL_COLUMN)
          .Text = ""
          .ItemData = 0
        End With
        With .Cell(1, C_COL_OPERATOR)
          .Text = ""
          .ItemData = 0
        End With
        With .Cell(1, C_COL_FONTFORMAT)
          .Text = ""
          .ItemData = 0
        End With
        With .Cell(1, C_COL_FORECOLOR)
          .Text = ""
          .ItemData = 0
        End With
        With .Cell(1, C_COL_BACKCOLOR)
          .Text = ""
          .ItemData = 0
        End With
        With .Cell(1, C_COL_VALUE)
          .Text = ""
          .ItemData = 0
        End With
      End If
    End If
  End With
End Sub

Private Sub grFormats_RequestEdit(ByVal lRow As Long, ByVal lCol As Long, ByVal iKeyAscii As Integer, bCancel As Boolean)
  Dim lLeft     As Long
  Dim lTop      As Long
  Dim lWidth    As Long
  Dim lHeight   As Long
  Dim bEditCb   As Boolean
  Dim bEditCmd  As Boolean
  
  ' Termino la edicion que esta pendiente
  If cbAux.Visible Then
    m_NoClick = False
    cbAux.Visible = False
    pEndEdit
  End If
  
  grFormats.CellBoundary lRow, lCol, lLeft, lTop, lWidth, lHeight
  
  lLeft = grFormats.Left + lLeft
  lTop = grFormats.Top + lTop
  
  Select Case lCol
    Case C_COL_OPERATOR
      m_bAddValue = False
      bEditCb = True
      pFillOperator
    
    Case C_COL_COLUMN
      m_bAddValue = False
      bEditCb = True
      pFillColumn False
    
    Case C_COL_VALUE
      m_bAddValue = True
      bEditCb = True
      pFillColumn True
    
    Case C_COL_BACKCOLOR, C_COL_FORECOLOR, C_COL_FONTFORMAT
      m_bAddValue = False
      bEditCmd = True
  End Select
  
  If bEditCb Then
    cmdHelp.Visible = False
    
    With cbAux
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
      ListSetListIndexForText cbAux, grFormats.Cell(lRow, lCol).Text
      m_NoClick = False
    End If
    m_ColumnEdited = lCol
    
  ElseIf bEditCmd Then
    With cmdHelp
      .Left = lLeft + lWidth - .Width - 10
      .Top = lTop + 10
      .Height = lHeight - 20
      .Visible = True
    End With
    m_ColumnEdited = lCol
  End If
End Sub

Private Function pGetOperatorName(ByVal FormatType As csGridFormatOperator) As String
  Select Case FormatType
    Case csGrFOEqual
      pGetOperatorName = "Igual a"
    Case csGrFOMajor
      pGetOperatorName = "Mayor que"
    Case csGrFOMinor
      pGetOperatorName = "Menor que"
    Case csGrFONotEqual
      pGetOperatorName = "Distinto de"
    Case csGrFOStartLike
      pGetOperatorName = "Empieza con"
    Case csGrFOLike
      pGetOperatorName = "Contiene a"
    Case csGrFOEndLike
      pGetOperatorName = "Termina en"
  End Select
End Function

Private Sub pFillOperator()
  cbAux.Clear
  With cbAux
    .AddItem pGetOperatorName(csGrFOEndLike)
    .ItemData(.NewIndex) = csGrFOEndLike
  
    .AddItem pGetOperatorName(csGrFOEqual)
    .ItemData(.NewIndex) = csGrFOEqual
  
    .AddItem pGetOperatorName(csGrFOLike)
    .ItemData(.NewIndex) = csGrFOLike
  
    .AddItem pGetOperatorName(csGrFOMajor)
    .ItemData(.NewIndex) = csGrFOMajor
  
    .AddItem pGetOperatorName(csGrFOMinor)
    .ItemData(.NewIndex) = csGrFOMinor
  
    .AddItem pGetOperatorName(csGrFONotEqual)
    .ItemData(.NewIndex) = csGrFONotEqual
  
    .AddItem pGetOperatorName(csGrFOStartLike)
    .ItemData(.NewIndex) = csGrFOStartLike
  End With
End Sub

Private Sub pFillColumn(ByVal bAddValue As Boolean)
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
  
  grFormats.GridLines = True
  
  grFormats.AddColumn , "Columna", , , 100
  grFormats.AddColumn , "Operador", , , 70
  grFormats.AddColumn , "Valor", , , 100
  grFormats.AddColumn , "Color Fondo", , , 80
  grFormats.AddColumn , "Color Texto", , , 80
  grFormats.AddColumn , "Fuente", , , 100
  
  grFormats.ImageList = imlColumns
  grFormats.Editable = True
  grFormats.MultiSelect = False
End Sub

Private Function cbAux() As ComboBox
  If m_bAddValue Then
    Set cbAux = cbAux1
  Else
    Set cbAux = cbAux2
  End If
End Function

' Combo fijo
'
Private Sub cbAux1_Click()
  
  If m_NoClick Then
    m_NoClick = False
    Exit Sub
  End If
  
  cbAux.Visible = False
  If grFormats.SelectedRow = 0 Then Exit Sub
  
  With grFormats.Cell(grFormats.SelectedRow, m_ColumnEdited)
    .Text = cbAux.Text
    If cbAux.ListIndex = -1 Then
      .ItemData = -1
    Else
      .ItemData = cbAux.ItemData(cbAux.ListIndex)
    End If
  End With
  
  pAddRowIfIsComplete
  
  grFormats.SetFocus
End Sub

Private Sub cbAux1_KeyDown(KeyCode As Integer, Shift As Integer)
  If KeyCode = vbKeyDelete And (Shift And vbCtrlMask) = vbCtrlMask Then
    cbAux.Visible = False
    grFormats.SetFocus
    grFormats.RemoveRow grFormats.SelectedRow
  Else
    m_NoClick = True
  End If
End Sub

Private Sub cbAux1_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyReturn Then
    m_NoClick = False
    cbAux1_Click
  ElseIf KeyAscii = vbKeyEscape Then
    m_NoClick = True
    cbAux.Visible = False
  End If
End Sub

' Combo editable
'
Private Sub cbAux2_Click()
  
  If m_NoClick Then
    m_NoClick = False
    Exit Sub
  End If
  
  cbAux.Visible = False
  If grFormats.SelectedRow = 0 Then Exit Sub
  
  With grFormats.Cell(grFormats.SelectedRow, m_ColumnEdited)
    .Text = cbAux.Text
    If cbAux.ListIndex = -1 Then
      .ItemData = -1
    Else
      .ItemData = cbAux.ItemData(cbAux.ListIndex)
    End If
  End With
  
  pAddRowIfIsComplete
  
  grFormats.SetFocus
End Sub

Private Sub cbAux2_KeyDown(KeyCode As Integer, Shift As Integer)
  If KeyCode = vbKeyDelete And (Shift And vbCtrlMask) = vbCtrlMask Then
    cbAux.Visible = False
    grFormats.SetFocus
    grFormats.RemoveRow grFormats.SelectedRow
  Else
    m_NoClick = True
  End If
End Sub

Private Sub cbAux2_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyReturn Then
    m_NoClick = False
    cbAux2_Click
  ElseIf KeyAscii = vbKeyEscape Then
    m_NoClick = True
    cbAux.Visible = False
  End If
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
