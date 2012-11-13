VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form fTreeViewCtrls 
   Caption         =   "Controles"
   ClientHeight    =   5025
   ClientLeft      =   60
   ClientTop       =   420
   ClientWidth     =   5490
   Icon            =   "fTreeViewCtrls.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5025
   ScaleWidth      =   5490
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txFormula 
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   12
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   1575
      Left            =   3780
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   4
      Top             =   1080
      Width           =   1575
   End
   Begin MSComctlLib.ImageList il 
      Left            =   4320
      Top             =   2940
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   5
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTreeViewCtrls.frx":038A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTreeViewCtrls.frx":0724
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTreeViewCtrls.frx":0ABE
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTreeViewCtrls.frx":1058
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTreeViewCtrls.frx":13F2
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.TreeView tvCtrls 
      Height          =   2340
      HelpContextID   =   10001
      Left            =   0
      TabIndex        =   1
      Top             =   765
      Width           =   3825
      _ExtentX        =   6747
      _ExtentY        =   4128
      _Version        =   393217
      HideSelection   =   0   'False
      Indentation     =   353
      LabelEdit       =   1
      LineStyle       =   1
      Style           =   7
      Appearance      =   1
   End
   Begin CSButton.cButton cmdEdit 
      Height          =   330
      Left            =   1680
      TabIndex        =   2
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
      Picture         =   "fTreeViewCtrls.frx":178C
   End
   Begin CSButton.cButton cmdClose 
      Height          =   330
      Left            =   2880
      TabIndex        =   3
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
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   2520
      Y1              =   3750
      Y2              =   3750
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   2400
      Y1              =   3630
      Y2              =   3630
   End
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fTreeViewCtrls.frx":18E6
      Top             =   45
      Width           =   675
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
      TabIndex        =   0
      Top             =   225
      Width           =   2235
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
Attribute VB_Name = "fTreeViewCtrls"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fTreeViewCtrls
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
Private Const C_Module = "fTreeViewCtrls"

Private Const c_height = "fTreeViewCtrls.Height"
Private Const c_left = "fTreeViewCtrls.Left"
Private Const c_top = "fTreeViewCtrls.Top"
Private Const c_width = "fTreeViewCtrls.Width"

Private Const c_config = "Interfaz"
' estructuras
' variables privadas
Private m_Loaded                    As Boolean
Private WithEvents m_fFormula       As fFormula
Attribute m_fFormula.VB_VarHelpID = -1
Private m_Report                    As cReport

' eventos
Public Event SetFocusCtrl(ByVal CtrlKey As String)
Public Event EditCtrl(ByVal CtrlKey As String)
Public Event SetFocusSec(ByVal SecKey As String)
Public Event EditSection(ByVal SecKey As String)
Public Event UpdateFormulaHide(ByVal CtrlKey As String, ByVal Formula As String)
Public Event UpdateSectionFormulaHide(ByVal SecKey As String, ByVal Formula As String)
Public Event UpdateFormulaValue(ByVal CtrlKey As String, ByVal Formula As String)

' propiedades publicas
Public Property Get Loaded() As Boolean
  Loaded = m_Loaded
End Property
' propiedades friend
' propiedades privadas
Public Sub Clear()
  With tvCtrls
    .Nodes.Clear
  End With
End Sub

Public Sub AddCtrls(ByRef Report As cReport)
  Dim nodeRoot    As Node
  Dim nodeGroup   As Node
  
  Set tvCtrls.ImageList = Me.il
  
  Set nodeRoot = tvCtrls.Nodes.Add(, , , Report.Name, 3)
  nodeRoot.Expanded = True
  Set nodeGroup = tvCtrls.Nodes.Add(nodeRoot, tvwChild, , "Headers", 3)
  pAddCtrlsAux Report.Headers, nodeGroup
  Set nodeGroup = tvCtrls.Nodes.Add(nodeRoot, tvwChild, , "GroupHeader", 3)
  pAddCtrlsAux Report.GroupsHeaders, nodeGroup
  Set nodeGroup = tvCtrls.Nodes.Add(nodeRoot, tvwChild, , "Details", 3)
  pAddCtrlsAux Report.Details, nodeGroup
  Set nodeGroup = tvCtrls.Nodes.Add(nodeRoot, tvwChild, , "Group Footer", 3)
  pAddCtrlsAux Report.GroupsFooters, nodeGroup
  Set nodeGroup = tvCtrls.Nodes.Add(nodeRoot, tvwChild, , "Footers", 3)
  pAddCtrlsAux Report.Footers, nodeGroup
End Sub
' funciones publicas
' funciones friend
' funciones privadas
Private Function pAddCtrlsAux(ByRef Sections As cReportSections, _
                              ByRef nodeFather As Node)
  Dim nodeSec     As Node
  Dim nodeSecLn   As Node
  Dim nodeCtrl    As Node
  Dim Text        As String
  Dim bComplexF   As Boolean
  
  Dim Sec     As cReportSection
  Dim SecLn   As cReportSectionLine
  Dim Ctrl    As cReportControl
  
  nodeFather.Expanded = True

  For Each Sec In Sections
    Set nodeSec = tvCtrls.Nodes.Add(nodeFather, tvwChild, , Sec.Name, 3)
    nodeSec.Tag = "S" & Sec.Key
    
    If Sec.FormulaHide.Text <> vbNullString Then
      If Sec.FormulaHide.Text = "0" Then
        Text = "Invisible"
        bComplexF = False
      Else
        Text = "Formula para mostrar"
        bComplexF = True
      End If
      With tvCtrls.Nodes.Add(nodeSec, tvwChild, , Text, 1)
        If Not Sec.HasFormulaHide Then
          .ForeColor = vbRed
        End If
        If bComplexF Then
          .Tag = "@FH=" & Sec.FormulaHide.Text
        End If
      End With
    End If
    
    For Each SecLn In Sec.SectionLines
      Set nodeSecLn = tvCtrls.Nodes.Add(nodeSec, tvwChild, , "Renglón " & SecLn.Indice, 3)
      nodeSecLn.Tag = "S" & SecLn.Key
      
      If SecLn.FormulaHide.Text <> vbNullString Then
        If SecLn.FormulaHide.Text = "0" Then
          Text = "Invisible"
          bComplexF = False
        Else
          Text = "Formula para mostrar"
          bComplexF = True
        End If
        With tvCtrls.Nodes.Add(nodeSecLn, tvwChild, , Text, 1)
          If Not SecLn.HasFormulaHide Then
            .ForeColor = vbRed
          End If
          If bComplexF Then
            .Tag = "@FH=" & SecLn.FormulaHide.Text
          End If
        End With
      End If
      For Each Ctrl In SecLn.Controls
        Set nodeCtrl = tvCtrls.Nodes.Add(nodeSecLn, tvwChild, , Ctrl.Name, 4)
        With nodeCtrl
          .Tag = Ctrl.Key
          .BackColor = Ctrl.Label.Aspect.BackColor
          .ForeColor = Ctrl.Label.Aspect.Font.ForeColor
        End With
        If Ctrl.ControlType = csRptCtField Then
          tvCtrls.Nodes.Add nodeCtrl, tvwChild, , Ctrl.Field.Name, 5
        End If
        If Ctrl.FormulaHide.Text <> vbNullString Then
          
          If Ctrl.FormulaHide.Text = "0" Then
            Text = "Invisible"
            bComplexF = False
          Else
            Text = "Formula para mostrar"
            bComplexF = True
          End If
          
          With tvCtrls.Nodes.Add(nodeCtrl, tvwChild, , Text, 1)
            If Not Ctrl.HasFormulaHide Then
              .ForeColor = vbRed
            End If
            If bComplexF Then
              .Tag = "@FH=" & Ctrl.FormulaHide.Text
            End If
          End With
        End If
        If Ctrl.FormulaValue.Text <> vbNullString Then
          With tvCtrls.Nodes.Add(nodeCtrl, tvwChild, , "Formula de valor", 2)
            If Not Ctrl.HasFormulaValue Then
              .ForeColor = vbRed
            End If
            .Tag = "@FV=" & Ctrl.FormulaValue.Text
          End With
        End If
      Next
    Next
  Next
End Function

Private Sub cmdClose_Click()
  Unload Me
End Sub

Private Function pGetSectionKey() As String
  On Error GoTo ControlError
  
  If tvCtrls.SelectedItem Is Nothing Then Exit Function
  
  If Left$(tvCtrls.SelectedItem.Tag, 2) = "SK" Then
    pGetSectionKey = Mid$(tvCtrls.SelectedItem.Tag, 2)
    Exit Function
  Else
    If Not tvCtrls.SelectedItem.Parent Is Nothing Then
      If Left$(tvCtrls.SelectedItem.Parent.Tag, 2) = "SK" Then
        pGetSectionKey = Mid$(tvCtrls.SelectedItem.Parent.Tag, 2)
        Exit Function
      End If
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "pGetSectionKey", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next

End Function

Private Function pGetCtrlKey() As String
  On Error GoTo ControlError
  
  If tvCtrls.SelectedItem Is Nothing Then Exit Function
  
  If Left$(tvCtrls.SelectedItem.Tag, 1) = "K" Then
    pGetCtrlKey = tvCtrls.SelectedItem.Tag
    Exit Function
  Else
    If Not tvCtrls.SelectedItem.Parent Is Nothing Then
      If Left$(tvCtrls.SelectedItem.Parent.Tag, 1) = "K" Then
        pGetCtrlKey = tvCtrls.SelectedItem.Parent.Tag
        Exit Function
      End If
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "pGetCtrlKey", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next

End Function

Private Sub cmdEdit_Click()
  On Error GoTo ControlError
  
  If tvCtrls.SelectedItem Is Nothing Then Exit Sub
  
  If Left$(tvCtrls.SelectedItem.Tag, 1) = "K" Then
    RaiseEvent EditCtrl(tvCtrls.SelectedItem.Tag)
    Exit Sub
  Else
    If Not tvCtrls.SelectedItem.Parent Is Nothing Then
      If Left$(tvCtrls.SelectedItem.Parent.Tag, 1) = "K" Then
        RaiseEvent EditCtrl(tvCtrls.SelectedItem.Parent.Tag)
        Exit Sub
      End If
    End If
  End If

  If Left$(tvCtrls.SelectedItem.Tag, 2) = "SK" Then
    RaiseEvent EditSection(Mid$(tvCtrls.SelectedItem.Tag, 2))
    Exit Sub
  Else
    If Not tvCtrls.SelectedItem.Parent Is Nothing Then
      If Left$(tvCtrls.SelectedItem.Parent.Tag, 2) = "SK" Then
        RaiseEvent EditSection(Mid$(tvCtrls.SelectedItem.Parent.Tag, 2))
        Exit Sub
      End If
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "cmdEdit_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Resize()
  SizeControls
End Sub

Private Sub SizeControls()
  On Error Resume Next
  With tvCtrls
    .Height = Me.ScaleHeight - .Top - cmdEdit.Height - 240
  End With
  
  With txFormula
    .Top = tvCtrls.Top
    .Height = Me.ScaleHeight - .Top - cmdEdit.Height - 240
    .Width = Me.ScaleWidth - tvCtrls.Width - tvCtrls.Left * 5
    .Left = tvCtrls.Width + tvCtrls.Left * 2
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
  Line1.y1 = tvCtrls.Height + tvCtrls.Top + 80
  Line1.Y2 = Line1.y1
  Line2.y1 = Line1.y1 + 10
  Line2.Y2 = Line2.y1

End Sub

Private Sub lvControls_DblClick()
  RaiseEvent SetFocusCtrl(tvCtrls.SelectedItem.Tag)
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
  
  Me.Move L, T, W, H
  
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Set m_fFormula = Nothing
  Set m_Report = Nothing
  
  m_Loaded = False
  If WindowState <> vbNormal Then Exit Sub
  SaveSetting App.EXEName, c_config, c_height, Height
  SaveSetting App.EXEName, c_config, c_width, Width
  SaveSetting App.EXEName, c_config, c_left, Left
  SaveSetting App.EXEName, c_config, c_top, Top
End Sub

Private Sub tvCtrls_Click()
  On Error Resume Next
  If Not tvCtrls.SelectedItem Is Nothing Then
    txFormula.Text = Mid$(tvCtrls.SelectedItem.Tag, 5)
  End If
End Sub

Private Sub tvCtrls_DblClick()
  On Error Resume Next
  
  Dim Tag As String
  Dim Formula As String
  
  If Not tvCtrls.SelectedItem Is Nothing Then
    Tag = Left$(tvCtrls.SelectedItem.Tag, 4)
    Formula = Mid$(tvCtrls.SelectedItem.Tag, 5)
    If Tag = "@FV=" Then
      If pEditFormula(Formula, False) Then
        tvCtrls.SelectedItem.Tag = "@FV=" & Formula
        txFormula.Text = Formula
      End If
    ElseIf Tag = "@FH=" Then
      If pEditFormula(Formula, True) Then
        tvCtrls.SelectedItem.Tag = "@FH=" & Formula
        txFormula.Text = Formula
      End If
    End If
  End If
End Sub

Private Sub tvCtrls_NodeClick(ByVal Node As MSComctlLib.Node)
  On Error Resume Next
  With tvCtrls.SelectedItem
    If Left$(.Tag, 1) = "K" Then
      RaiseEvent SetFocusCtrl(.Tag)
    ElseIf Left$(.Tag, 1) = "S" Then
      RaiseEvent SetFocusSec(Mid$(.Tag, 2))
    End If
  End With
End Sub

Private Function pEditFormula(ByRef Formula As String, _
                              ByVal IsFormulaHide As Boolean) As Boolean
  Dim Cancel  As Boolean
  Dim SecKey  As String
  Dim CtrlKey As String
  
  pShowEditFormula Formula, Cancel
  
  SecKey = pGetSectionKey()
  CtrlKey = pGetCtrlKey()
  
  If Not Cancel Then
    If IsFormulaHide Then
      If LenB(CtrlKey) Then
        RaiseEvent UpdateFormulaHide(CtrlKey, Formula)
      Else
        RaiseEvent UpdateSectionFormulaHide(SecKey, Formula)
      End If
    Else
      RaiseEvent UpdateFormulaValue(CtrlKey, Formula)
    End If
  End If
  
  pEditFormula = Not Cancel
End Function

Private Sub pShowEditFormula(ByRef Formula As String, ByRef Cancel As Boolean)
  On Error GoTo ControlError

  Dim f As CSReportDll2.cReportFormulaType
  Dim c As CSReportDll2.cReportControl

  If m_fFormula Is Nothing Then Set m_fFormula = New fFormula
  If m_Report Is Nothing Then Set m_Report = New cReport
  
  With m_fFormula

    ' Cargo el arbol de formulas
    .CreateArbol

    For Each f In m_Report.FormulaTypes
      .AddFormula f.Id, f.Name, f.NameUser, f.Decrip, f.HelpContextId
    Next f

    For Each c In m_Report.Controls
      If c.ControlType = CSReportDll2.csRptControlType.csRptCtField Then
        .AddDBField c.Name, c.Field.Name
      ElseIf c.ControlType = CSReportDll2.csRptControlType.csRptCtLabel Then
        .AddLabel c.Name
      End If
    Next c

    .ctxFormula.Text = Formula

    .ExpandTree

    CenterForm m_fFormula

    .Show vbModal
    
    Cancel = Not .Ok
    
    If Not Cancel Then
      Formula = .ctxFormula.Text
    End If
  End With

  GoTo ExitProc
ControlError:
  MngError Err(), "m_fProperties_ShowEditFormula", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload m_fFormula
End Sub

Private Sub m_fFormula_CheckSintaxis(ByRef Cancel As Boolean, ByVal code As String)
  Dim f As CSReportDll2.cReportFormula
  Set f = New CSReportDll2.cReportFormula
  f.Name = ""
  f.Text = code
  Cancel = Not m_Report.Compiler.CheckSintax(f)
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
