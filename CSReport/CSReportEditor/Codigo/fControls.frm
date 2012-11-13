VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fControls 
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "Controles"
   ClientHeight    =   4980
   ClientLeft      =   60
   ClientTop       =   300
   ClientWidth     =   4035
   Icon            =   "fControls.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4980
   ScaleWidth      =   4035
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ListView lvControls 
      Height          =   2790
      Left            =   0
      TabIndex        =   0
      Top             =   765
      Width           =   4035
      _ExtentX        =   7117
      _ExtentY        =   4921
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
   Begin CSButton.cButton cmdEdit 
      Height          =   330
      Left            =   1680
      TabIndex        =   1
      Top             =   3870
      Width           =   1050
      _ExtentX        =   1852
      _ExtentY        =   582
      Caption         =   "&Editar"
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
      Picture         =   "fControls.frx":000C
   End
   Begin CSButton.cButton cmdClose 
      Height          =   330
      Left            =   2880
      TabIndex        =   2
      Top             =   3870
      Width           =   1050
      _ExtentX        =   1852
      _ExtentY        =   582
      Caption         =   "&Cerrar"
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
   Begin VB.Label Label8 
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
      Left            =   1050
      TabIndex        =   3
      Top             =   225
      Width           =   2235
   End
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fControls.frx":0166
      Top             =   45
      Width           =   675
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   2400
      Y1              =   3630
      Y2              =   3630
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   2520
      Y1              =   3750
      Y2              =   3750
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
Attribute VB_Name = "fControls"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fControls
' -01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fControls"

Private Const c_height = "FControls.Height"
Private Const c_left = "FControls.Left"
Private Const c_top = "FControls.Top"
Private Const c_width = "FControls.Width"

Private Const c_config = "Interfaz"
' estructuras
' variables privadas
Private m_Loaded              As Boolean
' eventos
Public Event SetFocusCtrl(ByVal CtrlKey As String)
Public Event EditCtrl(ByVal CtrlKey As String)
' propiedades publicas
Public Property Get Loaded() As Boolean
  Loaded = m_Loaded
End Property
' propiedades friend
' propiedades privadas
' funciones publicas
Public Sub Clear()
  With lvControls
    .ListItems.Clear
    .ColumnHeaders.Clear
    
    .ColumnHeaders.Add(, , "Nombre").Width = 2500
    .ColumnHeaders.Add(, , "f(Valor)").Width = 1000
    .ColumnHeaders.Add(, , "f(Visible)").Width = 1000
    .ColumnHeaders.Add(, , "DataBase").Width = 3500
    
    .View = lvwReport
    .Sorted = True
    .SortKey = 0
  End With
End Sub

Public Sub AddCtrls(ByRef Report As cReport)
  Dim Ctrl        As CSReportDll2.cReportControl
  Dim Item        As ListItem
  Dim ctrlName    As String
  Dim ctrlField   As String
  Dim ctrlLabel   As String
  Dim ctrlInfo    As String
  
  With lvControls

    For Each Ctrl In Report.Controls
      
      ctrlName = Ctrl.Name
      ctrlInfo = ""
      ctrlField = ""
      
      Select Case Ctrl.ControlType
        Case csRptCtField
          ctrlField = Ctrl.Field.Name
        Case csRptCtDbImage
          ctrlInfo = Ctrl.Field.Name
        Case csRptCtImage
          ctrlInfo = " (Imagen)"
        Case csRptCtLabel
          ctrlInfo = Ctrl.Label.Text
      End Select
      
      
      If Len(ctrlInfo) Then
        ctrlName = ctrlName & " (" & ctrlInfo & ")"
      End If
      
      Set Item = .ListItems.Add(, , ctrlName)
      Item.Tag = Ctrl.Key
      If Ctrl.HasFormulaValue Then
        Item.SubItems(1) = "*"
      End If
      If Ctrl.HasFormulaHide Then
        Item.SubItems(2) = "*"
      End If
      If Len(ctrlField) Then
        Item.SubItems(3) = ctrlField
        Item.ForeColor = vbBlue
      End If
      If Left$(LCase(Ctrl.Name), 4) = "lnk_" Then
        Item.ForeColor = vbRed
      End If
    Next Ctrl
  End With
End Sub

Private Sub cmdClose_Click()
  Unload Me
End Sub

Private Sub cmdEdit_Click()
  On Error GoTo ControlError
  
  If lvControls.SelectedItem Is Nothing Then Exit Sub
  RaiseEvent EditCtrl(lvControls.SelectedItem.Tag)

  GoTo ExitProc
ControlError:
  MngError Err, "cmdEdit_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' funciones friend
' funciones privadas
Private Sub Form_Resize()
  SizeControls
End Sub

Private Sub SizeControls()
  On Error Resume Next
  With lvControls
    .Height = Me.ScaleHeight - .Top - cmdEdit.Height - 240
    .Width = Me.ScaleWidth - .Left
  End With
  
  With cmdEdit
    .Top = ScaleHeight - .Height - 80
    .Left = ScaleWidth - .Width * 2 - 160
  End With

  With cmdClose
    .Top = ScaleHeight - .Height - 80
    .Left = ScaleWidth - .Width - 80
  End With
  
  Shape1.Width = Me.Width
  
  Line1.X2 = ScaleWidth
  Line2.X2 = ScaleWidth
  Line1.y1 = lvControls.Height + lvControls.Top + 80
  Line1.Y2 = Line1.y1
  Line2.y1 = Line1.y1 + 10
  Line2.Y2 = Line2.y1

End Sub

Private Sub lvControls_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
  lvControls.SortKey = ColumnHeader.Index - 1
End Sub

Private Sub lvControls_DblClick()
  RaiseEvent SetFocusCtrl(lvControls.SelectedItem.Tag)
End Sub

' construccion - destruccion
Private Sub Form_Load()
  Dim H As Long
  Dim L As Long
  Dim T As Long
  Dim W As Long
  
  m_Loaded = True
  
  H = GetSetting(App.EXEName, c_config, c_height, 0)
  W = GetSetting(App.EXEName, c_config, c_width, 0)
  L = GetSetting(App.EXEName, c_config, c_left, 0)
  T = GetSetting(App.EXEName, c_config, c_top, 0)
  
  If H = 0 Then H = Height
  If W = 0 Then W = Width
  If L = 0 Then L = fMain.Left
  If T = 0 Then T = fMain.Top + 800
  
  With lvControls
    .FlatScrollBar = False
    .FullRowSelect = True
    .GridLines = True
  End With
  
  Me.Move L, T, W, H
  
End Sub

Private Sub Form_Unload(Cancel As Integer)
  m_Loaded = False
  If WindowState <> vbNormal Then Exit Sub
  SaveSetting App.EXEName, c_config, c_height, Height
  SaveSetting App.EXEName, c_config, c_width, Width
  SaveSetting App.EXEName, c_config, c_left, Left
  SaveSetting App.EXEName, c_config, c_top, Top
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
