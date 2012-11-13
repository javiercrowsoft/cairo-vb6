VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fToolbox 
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "Controles"
   ClientHeight    =   7050
   ClientLeft      =   60
   ClientTop       =   300
   ClientWidth     =   6210
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7050
   ScaleWidth      =   6210
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox picMain 
      BackColor       =   &H80000005&
      Height          =   5820
      Left            =   0
      ScaleHeight     =   5760
      ScaleWidth      =   5310
      TabIndex        =   4
      Top             =   720
      Width           =   5370
      Begin VB.PictureBox picLabel 
         BackColor       =   &H00C0E0FF&
         BorderStyle     =   0  'None
         Height          =   1815
         Left            =   1755
         ScaleHeight     =   1815
         ScaleWidth      =   1725
         TabIndex        =   8
         Top             =   0
         Width           =   1725
         Begin CSButton.cButtonLigth cmdLabels 
            Height          =   285
            Index           =   0
            Left            =   90
            TabIndex        =   10
            Top             =   45
            Visible         =   0   'False
            Width           =   1500
            _ExtentX        =   2646
            _ExtentY        =   503
            Caption         =   ""
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
            BorderColor     =   -2147483643
            BackColor       =   -2147483643
            BorderStyle     =   0
            BackColorPressed=   -2147483643
            BackColorUnpressed=   -2147483643
            Align           =   1
         End
      End
      Begin VB.PictureBox picFormulas 
         BackColor       =   &H00C0E0FF&
         BorderStyle     =   0  'None
         Height          =   1680
         Left            =   3510
         ScaleHeight     =   1680
         ScaleWidth      =   1725
         TabIndex        =   6
         Top             =   0
         Width           =   1725
         Begin CSButton.cButtonLigth cmdFormulas 
            Height          =   285
            Index           =   0
            Left            =   45
            TabIndex        =   11
            Top             =   450
            Visible         =   0   'False
            Width           =   1680
            _ExtentX        =   2963
            _ExtentY        =   503
            Caption         =   ""
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
            BackColor       =   -2147483643
            BorderStyle     =   0
            BackColorPressed=   -2147483643
            BackColorUnpressed=   -2147483643
            Align           =   1
         End
         Begin VB.Label lbFormulas 
            BackColor       =   &H00E0E0E0&
            Caption         =   "x"
            BeginProperty Font 
               Name            =   "MS Sans Serif"
               Size            =   8.25
               Charset         =   0
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   240
            Index           =   0
            Left            =   0
            TabIndex        =   7
            Top             =   45
            Visible         =   0   'False
            Width           =   1590
         End
      End
      Begin VB.PictureBox picFields 
         BackColor       =   &H00C0E0FF&
         BorderStyle     =   0  'None
         Height          =   1995
         Left            =   0
         ScaleHeight     =   1995
         ScaleWidth      =   1725
         TabIndex        =   5
         Top             =   0
         Width           =   1725
         Begin CSButton.cButtonLigth cmdFields 
            Height          =   285
            Index           =   0
            Left            =   0
            TabIndex        =   9
            Top             =   60
            Visible         =   0   'False
            Width           =   1680
            _ExtentX        =   2963
            _ExtentY        =   503
            Caption         =   ""
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
            BackColor       =   -2147483643
            BorderStyle     =   0
            BackColorPressed=   -2147483643
            BackColorUnpressed=   -2147483643
            Align           =   1
         End
      End
   End
   Begin VB.VScrollBar ScrVertical 
      Height          =   780
      Left            =   5670
      Max             =   5
      TabIndex        =   3
      TabStop         =   0   'False
      Top             =   765
      Width           =   240
   End
   Begin CSButton.cButton TabField 
      Height          =   315
      Left            =   0
      TabIndex        =   0
      Top             =   6615
      Width           =   1035
      _ExtentX        =   1826
      _ExtentY        =   556
      Caption         =   "Campos"
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
      BorderStyle     =   0
   End
   Begin CSButton.cButton TabLabel 
      Height          =   315
      Left            =   1050
      TabIndex        =   1
      Top             =   6615
      Width           =   1125
      _ExtentX        =   1984
      _ExtentY        =   556
      Caption         =   "Etiquetas"
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
      BorderStyle     =   0
   End
   Begin CSButton.cButton TabFormula 
      Height          =   315
      Left            =   2235
      TabIndex        =   2
      Top             =   6615
      Width           =   1125
      _ExtentX        =   1984
      _ExtentY        =   556
      Caption         =   "Formulas"
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
      BorderStyle     =   0
   End
   Begin VB.Label LbControl 
      BackStyle       =   0  'Transparent
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   3165
      TabIndex        =   13
      Top             =   135
      Width           =   1815
   End
   Begin VB.Label lbSecLn 
      BackStyle       =   0  'Transparent
      Caption         =   "Controles"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   915
      TabIndex        =   12
      Top             =   225
      Width           =   2475
   End
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fToolbox.frx":0000
      Top             =   45
      Width           =   675
   End
   Begin VB.Image imgLabel 
      Height          =   240
      Left            =   5580
      Picture         =   "fToolbox.frx":0935
      Top             =   3105
      Visible         =   0   'False
      Width           =   240
   End
   Begin VB.Image imgFormula 
      Height          =   240
      Left            =   5580
      Picture         =   "fToolbox.frx":0A7F
      Top             =   2520
      Visible         =   0   'False
      Width           =   240
   End
   Begin VB.Image imgField 
      Height          =   240
      Left            =   5535
      Picture         =   "fToolbox.frx":0BC9
      Top             =   1935
      Visible         =   0   'False
      Width           =   240
   End
   Begin VB.Shape Shape1 
      BorderStyle     =   0  'Transparent
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   690
      Left            =   0
      Top             =   0
      Width           =   6360
   End
End
Attribute VB_Name = "fToolbox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fToolBox
' 04-12-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fToolBox"

Private Const c_height = "FToolBox.Height"
Private Const c_left = "FToolBox.Left"
Private Const c_top = "FToolBox.Top"
Private Const c_width = "FToolBox.Width"

Private Const c_config = "Interfaz"

Private Const c_tabfield = 1
Private Const c_tablabels = 2
Private Const c_tabformulas = 3

Private Const c_ControlName = "C"
Private Const c_FormulaName = "F"

Private Const c_FieldIndex = "FC"
Private Const c_FieldType = "FT"
' estructuras
' variables privadas
Private m_TopFields           As Long
Private m_TopLabels           As Long
Private m_TopFormulas         As Long
Private m_Done                As Boolean
Private m_Tab                 As Long
Private m_Loaded              As Boolean
Private m_OldOnTopState       As Boolean

' eventos
Public Event AddControl(ByVal ControlName As String, ByVal ControlType As csRptEditCtrlType, ByVal FieldName As String, ByVal FormulaText As String, ByVal FieldType As Long, ByVal FieldIndex As Long)

' propiedades publicas
Public Property Get Loaded() As Boolean
  Loaded = m_Loaded
End Property

' propiedades privadas
' funciones publicas

Public Sub Clear()
  On Error Resume Next
  Dim i As Long
  
  For i = 1 To cmdFields.Count
    Unload cmdFields(i)
  Next
  For i = 1 To cmdFormulas.Count
    Unload cmdFormulas(i)
  Next
  For i = 1 To cmdLabels.Count
    Unload cmdLabels(i)
  Next
  For i = 1 To lbFormulas.Count
    Unload lbFormulas(i)
  Next
  m_TopFields = 0
  m_TopLabels = 0
  m_TopFormulas = 0
  Init
  TabField_Click
End Sub

Public Sub AddField(ByVal Name As String, ByVal FieldType As Long, ByVal FieldIndex As Long)
  Load cmdFields(cmdFields.Count + 1)
  With cmdFields(cmdFields.Count)
    .Top = m_TopFields
    .Visible = True
    .Caption = Name
    .Tag = SetInfoString(.Tag, c_FieldIndex, FieldIndex)
    .Tag = SetInfoString(.Tag, c_FieldType, FieldType)
    Set .Picture = imgField.Picture
    m_TopFields = m_TopFields + .Height
  End With
End Sub

Public Sub AddLbFormula(ByVal Name As String)
  Load lbFormulas(lbFormulas.Count + 1)
  With lbFormulas(lbFormulas.Count)
    .Top = m_TopFormulas
    .Visible = True
    .Caption = Name
    m_TopFormulas = m_TopFormulas + .Height
  End With
End Sub

Public Sub AddFormula(ByVal Name As String, ByVal ControlName As String, ByVal FormulaName As String)
  Load cmdFormulas(cmdFormulas.Count + 1)
  With cmdFormulas(cmdFormulas.Count)
    .Top = m_TopFormulas
    .Visible = True
    .Caption = Name
    .Tag = SetInfoString(.Tag, c_ControlName, ControlName)
    .Tag = SetInfoString(.Tag, c_FormulaName, FormulaName)
    Set .Picture = imgFormula.Picture
    m_TopFormulas = m_TopFormulas + .Height
  End With
End Sub

Public Sub AddLabels(ByVal Name As String)
  Load cmdLabels(cmdLabels.Count + 1)
  With cmdLabels(cmdLabels.Count)
    .Top = m_TopLabels
    .Visible = True
    .Caption = Name
    Set .Picture = imgLabel.Picture
    m_TopLabels = m_TopLabels + .Height
  End With
End Sub

Public Sub Init()
  TabField.Push

  picFields.Move 20, 20, 100, m_TopFields + 80
  picFormulas.Move 20, 20, 100, m_TopFormulas + 80
  picLabel.Move 20, 20, 100, m_TopLabels + 80
  
  SizeControls
End Sub

Private Sub cmdFields_Click(Index As Integer)
  Dim FieldIndex  As Long
  Dim FieldType   As Long
  
  With cmdFields(Index)
    FieldIndex = GetInfoString(.Tag, c_FieldIndex, 0)
    FieldType = GetInfoString(.Tag, c_FieldType, 0)
    RaiseEvent AddControl("", csRptEditField, .Caption, "", FieldType, FieldIndex)
    .Visible = False
    DoEvents
    .Visible = True
  End With
End Sub

Private Sub cmdFormulas_Click(Index As Integer)
  With cmdFormulas(Index)
    RaiseEvent AddControl(GetInfoString(.Tag, c_ControlName), csRptEditFormula, "", GetInfoString(.Tag, c_FormulaName), 0, 0)
    .Visible = False
    DoEvents
    .Visible = True
  End With
End Sub

Private Sub cmdLabels_Click(Index As Integer)
  With cmdLabels(Index)
    RaiseEvent AddControl("", csRptEditLabel, .Caption, "", 0, 0)
    .Visible = False
    DoEvents
    .Visible = True
  End With
End Sub

Private Sub Form_Activate()
  If m_Done Then Exit Sub
  m_Done = True
  pSortColumns
  TabField.SetFocus
End Sub

' funciones friend
' funciones privadas
Private Sub Form_Resize()
  SizeControls
End Sub

Private Sub SizeControls()
  On Error Resume Next
  Dim iWidth As Long
  
  TabField.Top = ScaleHeight - TabField.Height - 20
  TabFormula.Top = TabField.Top
  TabLabel.Top = TabField.Top
  
  Shape1.Width = Me.Width
  
  Dim bShowScrollBar As Boolean
  
  Select Case m_Tab
    Case c_tabfield
      bShowScrollBar = picFields.Height > picMain.Height
      If ScaleHeight > 20 Then ScrVertical.Max = picFields.Height - picMain.Height
    Case c_tabformulas
      bShowScrollBar = picFormulas.Height > picMain.Height
      If ScaleHeight > 20 Then ScrVertical.Max = picFormulas.Height - picMain.Height
    Case c_tablabels
      bShowScrollBar = picLabel.Height > picMain.Height
      If ScaleHeight > 20 Then ScrVertical.Max = picLabel.Height - picMain.Height
  End Select
  
  iWidth = ScaleWidth - 40
  If bShowScrollBar Then
    ScrVertical.Left = ScaleWidth - ScrVertical.Width
    ScrVertical.Top = picMain.Top
    ScrVertical.Height = TabField.Top - 60 - picMain.Top
    
    ScrVertical.LargeChange = ScrVertical.Max / 2
    ScrVertical.SmallChange = ScrVertical.Max / 100
    
    iWidth = iWidth - ScrVertical.Width
    ScrVertical.Visible = True
  Else
    ScrVertical.Visible = False
  End If
  
  picFields.Width = iWidth - 40
  picFormulas.Width = picFields.Width
  picLabel.Width = picFields.Width
  
  picMain.Move 20, picMain.Top, iWidth, TabField.Top - 60 - picMain.Top
  
  Dim c As Control
  For Each c In Controls
    If TypeOf c Is cButtonLigth Or TypeOf c Is Label Then
      If Not (c Is TabField Or c Is TabLabel Or c Is TabFormula) Then
        c.Width = picFormulas.Width - 60
      End If
    End If
  Next
End Sub

' construccion - destruccion
Private Sub Form_Load()
  Dim H As Long
  Dim L As Long
  Dim T As Long
  Dim W As Long
  
  m_Done = False
  m_Loaded = True
  
  m_TopFields = 0
  m_TopLabels = 0
  m_TopFormulas = 0
  
  cmdFields(0).Left = 0
  cmdFormulas(0).Left = 0
  cmdLabels(0).Left = 0
  
  H = GetSetting(App.EXEName, c_config, c_height, 0)
  W = GetSetting(App.EXEName, c_config, c_width, 0)
  L = GetSetting(App.EXEName, c_config, c_left, 0)
  T = GetSetting(App.EXEName, c_config, c_top, 0)
  
  If H = 0 Then H = Height
  If W = 0 Then W = Width
  If L = 0 Then L = fMain.Left
  If T = 0 Then T = fMain.Top + 800
  
  Me.Move L, T, W, H
  
  Me.picFields.BackColor = vbWindowBackground
  Me.picFormulas.BackColor = vbWindowBackground
  Me.picLabel.BackColor = vbWindowBackground
  
End Sub

Private Sub Form_Unload(Cancel As Integer)
  m_Loaded = False
  If WindowState <> vbNormal Then Exit Sub
  SaveSetting App.EXEName, c_config, c_height, Height
  SaveSetting App.EXEName, c_config, c_width, Width
  SaveSetting App.EXEName, c_config, c_left, Left
  SaveSetting App.EXEName, c_config, c_top, Top
  m_OldOnTopState = False
End Sub

Private Sub TabField_Click()
  ScrVertical.Visible = False
  picLabel.Visible = False
  picFormulas.Visible = False
  picFields.Visible = True
  DoEvents
  m_Tab = c_tabfield
  SizeControls
End Sub

Private Sub TabFormula_Click()
  ScrVertical.Visible = False
  picLabel.Visible = False
  picFormulas.Visible = True
  picFields.Visible = False
  DoEvents
  m_Tab = c_tabformulas
  SizeControls
End Sub

Private Sub TabLabel_Click()
  ScrVertical.Visible = False
  picLabel.Visible = True
  picFormulas.Visible = False
  picFields.Visible = False
  DoEvents
  m_Tab = c_tablabels
  SizeControls
End Sub

Private Sub ScrVertical_Scroll()
  On Error Resume Next
  
  Dim c As Control
  
  Select Case m_Tab
    Case c_tabfield
      Set c = picFields
    Case c_tabformulas
      Set c = picFormulas
    Case c_tablabels
      Set c = picLabel
  End Select
  
  c.Top = (ScrVertical.Value * -1) + 20
End Sub

Private Sub ScrVertical_Change()
  On Error Resume Next
  
  Dim c As Control
  
  Select Case m_Tab
    Case c_tabfield
      Set c = picFields
    Case c_tabformulas
      Set c = picFormulas
    Case c_tablabels
      Set c = picLabel
  End Select
  c.Top = (ScrVertical.Value * -1) + 20

End Sub

Private Function pSortColumns()
  Dim i          As Long
  Dim j          As Long
  Dim tmp        As String
  Dim vColumns() As String
  
  ReDim vColumns(Me.cmdFields.Count)
  
  On Error Resume Next
  For i = 0 To UBound(vColumns)
    vColumns(i) = Me.cmdFields(i).Caption
  Next
  
  For i = UBound(vColumns) - 1 To 0 Step -1
    For j = 0 To i
      If vColumns(j) > vColumns(j + 1) Then
        tmp = vColumns(j)
        vColumns(j) = vColumns(j + 1)
        vColumns(j + 1) = tmp
      End If
    Next
  Next
  
  Dim Top As Long
  
  For i = 0 To UBound(vColumns)
    If vColumns(i) <> "" Then
      For j = 0 To Me.cmdFields.Count
        Err.Clear
        If Me.cmdFields(j).Caption = vColumns(i) Then
          If Err.Number = 0 Then
            Me.cmdFields(j).Top = Top
            Top = Top + Me.cmdFields(j).Height
            Exit For
          End If
        End If
      Next
    End If
  Next
  
End Function

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
