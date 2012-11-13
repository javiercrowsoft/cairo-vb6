VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fColumns 
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "Columnas"
   ClientHeight    =   5910
   ClientLeft      =   60
   ClientTop       =   300
   ClientWidth     =   4260
   Icon            =   "fColumns.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5910
   ScaleWidth      =   4260
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButton cmdAceptar 
      Height          =   330
      Left            =   1170
      TabIndex        =   1
      Top             =   5535
      Width           =   1410
      _ExtentX        =   2487
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
   Begin MSComctlLib.ListView lvColumns 
      Height          =   4770
      Left            =   45
      TabIndex        =   0
      Top             =   720
      Width           =   4155
      _ExtentX        =   7329
      _ExtentY        =   8414
      Sorted          =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FlatScrollBar   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      Appearance      =   1
      NumItems        =   0
   End
   Begin CSButton.cButton cmdCancelar 
      Height          =   330
      Left            =   2745
      TabIndex        =   2
      Top             =   5535
      Width           =   1410
      _ExtentX        =   2487
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
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Seleccione una columna"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Left            =   900
      TabIndex        =   3
      Top             =   270
      Width           =   2940
   End
   Begin VB.Image Image1 
      Height          =   540
      Left            =   135
      Picture         =   "fColumns.frx":000C
      Top             =   90
      Width           =   600
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   735
      Left            =   -90
      Top             =   -45
      Width           =   4650
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   360
      X2              =   2070
      Y1              =   5490
      Y2              =   5490
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   90
      X2              =   3015
      Y1              =   5445
      Y2              =   5445
   End
End
Attribute VB_Name = "fColumns"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fColumns
' 01-11-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fColumns"

Private Const c_FieldType = "t"
Private Const c_Index = "i"
' estructuras
' variables privadas
Private m_Ok                            As Boolean
Private m_Field                         As String
Private m_Index                         As Long
Private m_FieldType                     As Long

' eventos
' propiedades publicas
Public Property Get Ok() As Boolean
   Ok = m_Ok
End Property

Public Property Get Field() As String
   Field = m_Field
End Property

Public Property Let Field(ByVal rhs As String)
   m_Field = rhs
   Dim i As Long
   With lvColumns.ListItems
   For i = 1 To .Count
    If .Item(i).Text = rhs Then
      .Item(i).Selected = True
      Exit For
    End If
   Next
   End With
End Property

Public Property Get Index() As Long
   Index = m_Index
End Property

Public Property Get FieldType() As Long
   FieldType = m_FieldType
End Property

' propiedades privadas
' funciones publicas
Public Sub ClearColumns()
  With lvColumns
    .ListItems.Clear
    .ColumnHeaders.Clear
    
    With .ColumnHeaders.Add(, , "Nombre")
      .Width = 3500
    End With
    .View = lvwReport
    .Sorted = True
    .SortKey = 0
  End With
End Sub

Public Sub FillColumns(ByVal DataSource As String, ByRef Columns As CSReportDll2.cColumnsInfo)
  Dim Col   As CSReportDll2.cColumnInfo
  Dim Item  As ListItem
  
  With lvColumns
    For Each Col In Columns
      Set Item = .ListItems.Add(, , GetDataSourceStr(DataSource) & Col.Name)
      Item.Tag = SetInfoString(.Tag, c_Index, Col.Position)
      Item.Tag = SetInfoString(.Tag, c_FieldType, Col.TypeColumn)
    Next
  End With
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  lvColumns.Width = Me.ScaleWidth - lvColumns.Left * 2
  lvColumns.Height = Me.ScaleHeight - lvColumns.Top - cmdAceptar.Height - 240
  
  Line1.X2 = Me.Width
  Line2.X2 = Me.Width
  Line1.y1 = Me.ScaleHeight - cmdAceptar.Height - 180
  Line1.Y2 = Line1.y1
  Line2.y1 = Line1.y1 + 20
  Line2.Y2 = Line2.y1
  
  Shape1.Width = Me.Width
  
  cmdAceptar.Top = Line1.y1 + 100
  cmdCancelar.Top = cmdAceptar.Top
  cmdCancelar.Left = Me.ScaleWidth - cmdCancelar.Width - 50
  cmdAceptar.Left = cmdCancelar.Left - cmdAceptar.Width - 50
End Sub

' funciones friend
' funciones privadas
Private Sub lvColumns_DblClick()
  cmdAceptar_Click
End Sub

Private Sub cmdAceptar_Click()
  If lvColumns.SelectedItem Is Nothing Then
    MsgWarning "Debe seleccionar una Field"
    Exit Sub
  End If
  
  m_Field = lvColumns.SelectedItem.Text
  m_Index = Val(GetInfoString(lvColumns.SelectedItem.Tag, c_Index, "0"))
  m_FieldType = Val(GetInfoString(lvColumns.SelectedItem.Tag, c_FieldType, "0"))
  m_Ok = True
  
  Hide
End Sub

Private Sub cmdCancelar_Click()
  m_Ok = False
  Hide
End Sub

' construccion - destruccion
Private Sub Form_Load()
  CenterForm Me
  With lvColumns
    .FlatScrollBar = False
    .FullRowSelect = True
    .GridLines = True
  End With
  Line1.X1 = 0
  Line2.X1 = 0
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
