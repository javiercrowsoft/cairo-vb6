VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form fFormula 
   Caption         =   "Formula"
   ClientHeight    =   5325
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   11070
   Icon            =   "fFormula.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   ScaleHeight     =   5325
   ScaleWidth      =   11070
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox TxDescrip 
      Appearance      =   0  'Flat
      BackColor       =   &H80000014&
      BorderStyle     =   0  'None
      Height          =   2220
      Left            =   5580
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   6
      Top             =   810
      Width           =   3750
   End
   Begin VB.TextBox ctxFormula 
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
      Height          =   2115
      Left            =   5595
      MultiLine       =   -1  'True
      TabIndex        =   1
      Top             =   1890
      Width           =   5055
   End
   Begin VB.PictureBox PicSplitterBar 
      BackColor       =   &H8000000D&
      BorderStyle     =   0  'None
      Height          =   4290
      Left            =   5220
      ScaleHeight     =   4290
      ScaleWidth      =   105
      TabIndex        =   4
      TabStop         =   0   'False
      Top             =   810
      Width           =   105
   End
   Begin VB.PictureBox PicSplitter 
      BorderStyle     =   0  'None
      Height          =   4290
      Left            =   3330
      MousePointer    =   9  'Size W E
      ScaleHeight     =   4290
      ScaleWidth      =   45
      TabIndex        =   5
      TabStop         =   0   'False
      Top             =   810
      Width           =   50
   End
   Begin CSButton.cButton cmdCancelar 
      Cancel          =   -1  'True
      Height          =   315
      Left            =   8055
      TabIndex        =   3
      Top             =   4230
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
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
   Begin CSButton.cButton cmdAceptar 
      Height          =   315
      Left            =   6660
      TabIndex        =   2
      Top             =   4230
      Width           =   1275
      _ExtentX        =   2249
      _ExtentY        =   556
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
   Begin MSComctlLib.ImageList il 
      Left            =   5535
      Top             =   4095
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
            Picture         =   "fFormula.frx":030A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fFormula.frx":06A4
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fFormula.frx":0A3E
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fFormula.frx":0FD8
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fFormula.frx":1372
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.TreeView tvFormulas 
      Height          =   3780
      HelpContextID   =   10001
      Left            =   0
      TabIndex        =   0
      Top             =   810
      Width           =   2325
      _ExtentX        =   4101
      _ExtentY        =   6668
      _Version        =   393217
      HideSelection   =   0   'False
      Indentation     =   353
      LabelEdit       =   1
      LineStyle       =   1
      Style           =   7
      Appearance      =   1
   End
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fFormula.frx":170C
      Top             =   45
      Width           =   675
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "Editor de Formulas"
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
      TabIndex        =   7
      Top             =   270
      Width           =   2235
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
Attribute VB_Name = "fFormula"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fFormula
' 11-11-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fFormula"

Private Const sglSplitLimit = 500

Private Const c_key_SysFunctions = "FS"
Private Const c_key_SysVars = "VS"
Private Const c_key_SysLabels = "VL"
Private Const c_key_SysDBFields = "VC"

Private Const c_FunId As String = "I"
Private Const c_FunDescrip As String = "D"
Private Const c_FunName As String = "N"
Private Const c_HelpContextId As String = "H"
Private Const c_IsDBFieldOrLabel As String = "FL"

' estructuras
' variables privadas
Private m_moving                        As Boolean

Private m_Ok                            As Boolean

Private m_Done                          As Boolean

' eventos
Public Event CheckSintaxis(ByRef Cancel As Boolean, ByVal code As String)

' propiedades publicas
Public Property Get Ok() As Boolean
   Ok = m_Ok
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
Private Sub cmdAceptar_Click()
  On Error GoTo ControlError
  
  Dim Cancel As Boolean
  
  RaiseEvent CheckSintaxis(Cancel, ctxFormula.Text)

  If Cancel Then Exit Sub

  m_Ok = True
  Hide
  
  GoTo ExitProc
ControlError:
  MngError Err, "", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdCancelar_Click()
  m_Ok = False
  Hide
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  If KeyCode = vbKeyF1 Then
    If ActiveControl Is ctxFormula Then
      
    ElseIf ActiveControl Is tvFormulas Then
      
    End If
  End If
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode <> vbFormCode Then
    Cancel = True
    m_Ok = False
    Hide
  End If
End Sub

Private Sub Form_Resize()
  SizeControls
End Sub

Private Sub Form_Unload(Cancel As Integer)
  CSKernelClient2.UnloadForm Me, Me.Name, False
End Sub

'-------------------------------------------------------------
' Splitter
Private Sub PicSplitter_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
    With PicSplitter
      PicSplitterBar.Move .Left, .Top, .Width \ 2, .Height - 20
    End With
    PicSplitterBar.Visible = True
    m_moving = True
End Sub

Private Sub PicSplitter_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    Dim sglPos As Single

    If m_moving Then
        sglPos = x + PicSplitter.Left
        If sglPos < sglSplitLimit Then
            PicSplitterBar.Left = sglSplitLimit
        ElseIf sglPos > Width - sglSplitLimit Then
            PicSplitterBar.Left = Width - sglSplitLimit
        Else
            PicSplitterBar.Left = sglPos
        End If
    End If
End Sub
Private Sub PicSplitter_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
    SizeControls
    PicSplitterBar.Visible = False
    m_moving = False
End Sub

Private Sub SizeControls()
    Dim i As Long
    Dim iHeigth     As Long
    
    On Error GoTo ControlError
    
    DoEvents: DoEvents: DoEvents: DoEvents
    
    If WindowState = vbMinimized Then Exit Sub
    
    PicSplitterBar.Visible = False
    
    If PicSplitterBar.Left > ScaleWidth Then
        PicSplitterBar.Left = ScaleWidth - 50
    End If
    
    shTop.Width = ScaleWidth
    
    cmdAceptar.Top = ScaleHeight - cmdAceptar.Height - 50
    cmdCancelar.Top = cmdAceptar.Top
    
    iHeigth = cmdAceptar.Top - PicSplitter.Top - 100
    
    PicSplitter.Left = PicSplitterBar.Left
    PicSplitter.Height = iHeigth
    PicSplitterBar.Height = PicSplitter.Height
    tvFormulas.Width = PicSplitter.Left
    
    tvFormulas.Height = iHeigth
    ctxFormula.Height = iHeigth - TxDescrip.Height - 80
    ctxFormula.Left = PicSplitter.Left + PicSplitter.Width
    ctxFormula.Width = ScaleWidth - ctxFormula.Left
    TxDescrip.Left = ctxFormula.Left
    TxDescrip.Width = ScaleWidth - ctxFormula.Left
    cmdCancelar.Left = ScaleWidth - cmdCancelar.Width - 50
    cmdAceptar.Left = cmdCancelar.Left - cmdAceptar.Width - 100
ControlError:
End Sub

Public Sub CreateArbol()
  Set tvFormulas.ImageList = il
  With tvFormulas.Nodes
    .Clear
    .Add , , c_key_SysFunctions, "Funciones Predefinidas", 3
    .Add , , c_key_SysVars, "Variables predefinidas", 3
    .Add c_key_SysVars, tvwChild, c_key_SysDBFields, "Campos", 3
    .Add c_key_SysVars, tvwChild, c_key_SysLabels, "Etiquetas", 3
  End With
End Sub

Public Sub AddFormula(ByVal Id As Long, ByVal Name As String, ByVal NameUser As String, ByVal Descrip As String, ByVal HelpContextId As Long)
  With tvFormulas.Nodes
    With .Add(c_key_SysFunctions, tvwChild, , NameUser, 1)
      .Tag = SetInfoString(.Tag, c_FunId, Id)
      .Tag = SetInfoString(.Tag, c_FunDescrip, Descrip)
      .Tag = SetInfoString(.Tag, c_FunName, Name)
      .Tag = SetInfoString(.Tag, c_HelpContextId, HelpContextId)
    End With
  End With
  
  'ctxFormula.AddWord Name, enumFunction
End Sub

Public Sub ExpandTree()
  Dim i As Long
  
  For i = 1 To tvFormulas.Nodes.Count
    tvFormulas.Nodes(i).Expanded = True
  Next i
  tvFormulas.Nodes(1).Selected = True
End Sub

Public Sub AddDBField(ByVal Name As String, ByVal Descrip As String)
  AddAux Name, Descrip, c_key_SysDBFields, 5
End Sub

Public Sub AddLabel(ByVal Name As String)
  AddAux Name, "", c_key_SysLabels, 4
End Sub

Private Sub AddAux(ByVal Name As String, ByVal Descrip As String, ByVal Key As String, ByVal Image As Long)
  With tvFormulas.Nodes
    With .Add(Key, tvwChild, , , Image)
      If Descrip = "" Then
        .Text = Name
      Else
        .Text = Descrip & " (" & Name & ")"
      End If
      .Tag = SetInfoString(.Tag, c_FunDescrip, Descrip)
      .Tag = SetInfoString(.Tag, c_FunName, Name)
      .Tag = SetInfoString(.Tag, c_IsDBFieldOrLabel, "1")
    End With
  End With
    
  'ctxFormula.AddWord Name, enumFunction
End Sub
' construccion - destruccion

Private Sub Form_Load()
  m_Ok = False
  m_Done = False

  CSKernelClient2.LoadForm Me, Me.Name
  
  PicSplitter.Top = shTop.Height + 20
  PicSplitterBar.Top = PicSplitter.Top
  tvFormulas.Top = PicSplitter.Top
  TxDescrip.Top = PicSplitter.Top
  ctxFormula.Top = TxDescrip.Top + TxDescrip.Height + 100
  tvFormulas.Left = 0
  SizeControls
  PicSplitterBar.ZOrder
  
  App.HelpFile = "D:\Proyectos\CSReport\Report help file\crowsoft.chm"
End Sub

Private Function IsFunction(ByRef Node As MSComctlLib.Node) As Boolean
  IsFunction = Val(GetInfoString(Node.Tag, c_FunId, "0")) <> 0
End Function

Private Function IsDBOrLabel(ByRef Node As MSComctlLib.Node) As Boolean
  IsDBOrLabel = Val(GetInfoString(Node.Tag, c_IsDBFieldOrLabel, "0")) <> 0
End Function

Private Sub tvFormulas_DblClick()
  If tvFormulas.SelectedItem Is Nothing Then Exit Sub
  If Not IsFunction(tvFormulas.SelectedItem) And Not IsDBOrLabel(tvFormulas.SelectedItem) Then Exit Sub
  With ctxFormula
    .SelText = ""
    If IsDBOrLabel(tvFormulas.SelectedItem) Then
      .Text = Mid(.Text, 1, .SelStart) & " " & GetInfoString(tvFormulas.SelectedItem.Tag, c_FunName, "") & " " & Mid(.Text, .SelStart + 1)
    Else
      .Text = Mid(.Text, 1, .SelStart) & " " & GetInfoString(tvFormulas.SelectedItem.Tag, c_FunName, "") & "() " & Mid(.Text, .SelStart + 1)
    End If
  End With
End Sub

Private Sub tvFormulas_NodeClick(ByVal Node As MSComctlLib.Node)
  If IsFunction(Node) Then
    TxDescrip.Text = GetInfoString(Node.Tag, c_FunDescrip, "")
    tvFormulas.HelpContextId = Val(GetInfoString(Node.Tag, c_HelpContextId, "0"))
  Else
    TxDescrip.Text = ""
  End If
End Sub

Private Sub TxDescrip_KeyPress(KeyAscii As Integer)
  KeyAscii = 0
End Sub
