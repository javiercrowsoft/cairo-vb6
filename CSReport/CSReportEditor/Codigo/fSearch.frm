VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.2#0"; "CSMaskEdit2.ocx"
Begin VB.Form fSearch 
   BorderStyle     =   5  'Sizable ToolWindow
   Caption         =   "Buscar"
   ClientHeight    =   6615
   ClientLeft      =   60
   ClientTop       =   300
   ClientWidth     =   6525
   Icon            =   "fSearch.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6615
   ScaleWidth      =   6525
   StartUpPosition =   3  'Windows Default
   Begin CSMaskEdit2.cMaskEdit txSearch 
      Height          =   330
      Left            =   810
      TabIndex        =   0
      Top             =   810
      Width           =   3975
      _ExtentX        =   7011
      _ExtentY        =   582
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
      EnabledNoChngBkColor=   0   'False
      Text            =   ""
      csType          =   5
      BorderColor     =   12164479
      BorderType      =   1
      csNotRaiseError =   -1  'True
      ButtonStyle     =   0
   End
   Begin CSButton.cButton cmdAceptar 
      Default         =   -1  'True
      Height          =   330
      Left            =   4995
      TabIndex        =   2
      Top             =   810
      Width           =   1140
      _ExtentX        =   2011
      _ExtentY        =   582
      Caption         =   "&Buscar"
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
   Begin MSComctlLib.ListView lvResult 
      Height          =   3150
      Left            =   45
      TabIndex        =   1
      Top             =   2025
      Width           =   4155
      _ExtentX        =   7329
      _ExtentY        =   5556
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
   Begin MSComctlLib.ImageList il 
      Left            =   4905
      Top             =   4770
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   8
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fSearch.frx":030A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fSearch.frx":06A4
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fSearch.frx":0A3E
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fSearch.frx":0DD8
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fSearch.frx":1172
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fSearch.frx":150C
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fSearch.frx":18A6
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fSearch.frx":1C40
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin CSButton.cButton cmdEdit 
      Height          =   330
      Left            =   4995
      TabIndex        =   3
      Top             =   1215
      Width           =   1140
      _ExtentX        =   2011
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
      Picture         =   "fSearch.frx":1FDA
   End
   Begin VB.Label Label1 
      Caption         =   "Buscar:"
      Height          =   330
      Left            =   180
      TabIndex        =   5
      Top             =   855
      Width           =   690
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   90
      X2              =   3015
      Y1              =   1845
      Y2              =   1845
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   360
      X2              =   2070
      Y1              =   1890
      Y2              =   1890
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "Buscar"
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
      Left            =   960
      TabIndex        =   4
      Top             =   270
      Width           =   2235
   End
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fSearch.frx":2134
      Top             =   45
      Width           =   675
   End
   Begin VB.Shape shTop 
      BorderStyle     =   0  'Transparent
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   690
      Left            =   0
      Top             =   0
      Width           =   6360
   End
End
Attribute VB_Name = "fSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fSearch
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
Private Const C_Module = "fSearch"

Private Enum c_ObjType
  iTypeSec = 6
  iTypeSecLn = 7
  iTypeCtrl = 3
  iTypeSecG = 5
  iTypeFormulaH = 2
  iTypeFormulaV = 1
  iTypeDbField = 4
  iTypeText = 8
End Enum

Private Const c_FieldType = "t"
Private Const c_Index = "i"
Private c_min_width ' virtual const

Public Event SetFocusCtrl(ByVal CtrlKey As String)
Public Event EditCtrl(ByVal CtrlKey As String)
Public Event SetFocusSec(ByVal SecKey As String)
Public Event EditSection(ByVal SecKey As String)

' estructuras
' variables privadas
Private m_fReport                       As fReporte
' eventos
' propiedades publicas
Public Property Set fReport(ByRef rhs As fReporte)
  Set m_fReport = rhs
End Property

Public Property Get fReport() As fReporte
  Set fReport = m_fReport
End Property

' propiedades privadas
' funciones publicas
Private Sub cmdEdit_Click()
  On Error GoTo ControlError
  
  If lvResult.SelectedItem Is Nothing Then Exit Sub
  
  If Left$(lvResult.SelectedItem.Tag, 1) = "K" Then
    RaiseEvent EditCtrl(lvResult.SelectedItem.Tag)
    Exit Sub
  End If

  If Left$(lvResult.SelectedItem.Tag, 2) = "SK" Then
    RaiseEvent EditSection(Mid$(lvResult.SelectedItem.Tag, 2))
    Exit Sub
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "cmdEdit_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  
  If Me.Width < c_min_width Then Me.Width = c_min_width
  
  lvResult.Width = Me.ScaleWidth - lvResult.Left * 2
  lvResult.Height = Me.ScaleHeight - lvResult.Top - 80
  
  Line1.X2 = Me.Width
  Line2.X2 = Me.Width
  
  shTop.Width = Me.Width
End Sub

' funciones friend
' funciones privadas
Private Sub lvColumns_DblClick()
  cmdAceptar_Click
End Sub

Private Sub cmdAceptar_Click()
  If Trim$(txSearch.Text) = vbNullString Then
    MsgWarning "Debe indicar un texto a buscar"
    Exit Sub
  End If
  
  lvResult.ListItems.Clear

  pSearchInSec m_fReport.Report.Headers, iTypeSec
  pSearchInSec m_fReport.Report.GroupsHeaders, iTypeSecG
  pSearchInSec m_fReport.Report.Details, iTypeSec
  pSearchInSec m_fReport.Report.GroupsFooters, iTypeSecG
  pSearchInSec m_fReport.Report.Footers, iTypeSec
  
End Sub

Private Sub pSearchInSec(ByRef Sections As cReportSections, _
                         ByVal iTypeSection As c_ObjType)
  Dim Sec       As cReportSection
  Dim SecLn     As cReportSectionLine
  Dim Ctrl      As cReportControl
  Dim toSearch  As String
  
  toSearch = LCase(txSearch.Text)
  
  For Each Sec In Sections
    If InStr(1, LCase(Sec.Name), toSearch) Then
      pAddToSearchResult Sec.Name, iTypeSection, iTypeSection, "S" & Sec.Key
    End If
    
    If InStr(1, LCase(Sec.FormulaHide.Text), toSearch) Then
      pAddToSearchResult Sec.Name, _
                         iTypeSection, iTypeFormulaH, "S" & Sec.Key, Sec.FormulaHide.Text
    End If
    
    For Each SecLn In Sec.SectionLines
      If InStr(1, LCase(SecLn.FormulaHide.Text), toSearch) Then
        pAddToSearchResult "Renglón " & SecLn.Indice & " de " & Sec.Name, _
                           iTypeSecLn, iTypeFormulaH, "S" & SecLn.Key, SecLn.FormulaHide.Text
      End If
      
      For Each Ctrl In SecLn.Controls
        If InStr(1, LCase(Ctrl.Name), toSearch) Then
          pAddToSearchResult Ctrl.Name, iTypeCtrl, iTypeCtrl, Ctrl.Key
        End If
        
        If Ctrl.ControlType = csRptCtField Or Ctrl.ControlType = csRptCtDbImage Then
          If InStr(1, LCase(Ctrl.Field.Name), toSearch) Then
            pAddToSearchResult Ctrl.Name, iTypeCtrl, iTypeDbField, Ctrl.Key, Ctrl.Field.Name
          End If
        Else
          If InStr(1, LCase(Ctrl.Label.Text), toSearch) Then
            pAddToSearchResult Ctrl.Name, iTypeCtrl, iTypeText, Ctrl.Key, Ctrl.Label.Text
          End If
        End If
        
        If InStr(1, LCase(Ctrl.FormulaHide.Text), toSearch) Then
          pAddToSearchResult Ctrl.Name, _
                             iTypeCtrl, iTypeFormulaH, Ctrl.Key, Ctrl.FormulaHide.Text
        End If
        
        If InStr(1, LCase(Ctrl.FormulaValue.Text), toSearch) Then
          pAddToSearchResult Ctrl.Name, _
                             iTypeCtrl, iTypeFormulaH, Ctrl.Key, Ctrl.FormulaValue.Text
        End If
      Next
    Next
  Next
End Sub

Private Sub pAddToSearchResult(ByVal Text As String, _
                               ByVal iType As c_ObjType, _
                               ByVal iType2 As c_ObjType, _
                               ByVal Key As String, _
                               Optional ByVal infoAdd As String)
  With lvResult.ListItems.Add(, , Text)
    If infoAdd <> vbNullString Then
      .SubItems(2) = infoAdd
    End If
    
    .SmallIcon = iType
    
    If iType <> iType2 Then
      .ListSubItems(1).ReportIcon = iType2
    End If
    .Tag = Key
  End With
End Sub

Private Sub lvResult_DblClick()
  On Error Resume Next
  If lvResult.SelectedItem Is Nothing Then Exit Sub
  If lvResult.SelectedItem.SubItems(2) <> vbNullString Then
    MsgBox lvResult.SelectedItem.SubItems(2)
  End If
End Sub

Private Sub lvResult_ItemClick(ByVal Item As MSComctlLib.ListItem)
  On Error Resume Next
  With lvResult.SelectedItem
    If Left$(.Tag, 1) = "K" Then
      RaiseEvent SetFocusCtrl(.Tag)
    ElseIf Left$(.Tag, 1) = "S" Then
      RaiseEvent SetFocusSec(Mid$(.Tag, 2))
    End If
  End With
End Sub

' construccion - destruccion
Private Sub Form_Load()
  CenterForm Me
  With lvResult
    .FlatScrollBar = False
    .FullRowSelect = True
    .GridLines = True
    .View = lvwReport
    .LabelEdit = lvwManual
    .SmallIcons = il
    
    .ListItems.Clear
    .ColumnHeaders.Clear
    
    With .ColumnHeaders.Add(, , "Nombre")
      .Width = 2800
    End With
    With .ColumnHeaders.Add(, , "")
      .Width = 400
    End With
    With .ColumnHeaders.Add(, , "Encontrado en")
      .Width = 3500
    End With
    .View = lvwReport
    .Sorted = True
    .SortKey = 0
  End With

  
  Line1.X1 = 0
  Line2.X1 = 0
  c_min_width = cmdAceptar.Left + cmdAceptar.Width + 80
  
  Line1.Y2 = Line1.y1
  Line2.y1 = Line1.y1 + 20
  Line2.Y2 = Line2.y1

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

