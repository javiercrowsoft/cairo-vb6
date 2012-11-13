VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "tabctl32.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.2#0"; "CSMaskEdit2.ocx"
Begin VB.Form fToolsOptions 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Opciones"
   ClientHeight    =   4740
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   6090
   Icon            =   "fToolsOptions.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4740
   ScaleWidth      =   6090
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Height          =   675
      Left            =   -90
      ScaleHeight     =   675
      ScaleWidth      =   6615
      TabIndex        =   4
      Top             =   4050
      Width           =   6615
      Begin CSButton.cButton cmdCancelar 
         Cancel          =   -1  'True
         Height          =   315
         Left            =   3465
         TabIndex        =   5
         Top             =   315
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
         Left            =   2115
         TabIndex        =   6
         Top             =   315
         Width           =   1275
         _ExtentX        =   2249
         _ExtentY        =   556
         Caption         =   "&Aceptar"
         Style           =   2
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
      Begin CSButton.cButton cmdApply 
         Height          =   315
         Left            =   4815
         TabIndex        =   7
         Top             =   315
         Width           =   1275
         _ExtentX        =   2249
         _ExtentY        =   556
         Caption         =   "&Aplicar"
         Style           =   3
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
      Begin VB.Line Line5 
         BorderColor     =   &H80000010&
         X1              =   60
         X2              =   6345
         Y1              =   180
         Y2              =   180
      End
      Begin VB.Line Line6 
         BorderColor     =   &H80000014&
         X1              =   45
         X2              =   6330
         Y1              =   190
         Y2              =   190
      End
   End
   Begin TabDlg.SSTab tabMain 
      Height          =   3435
      Left            =   -45
      TabIndex        =   1
      Top             =   765
      Width           =   6180
      _ExtentX        =   10901
      _ExtentY        =   6059
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "General"
      TabPicture(0)   =   "fToolsOptions.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Label2"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "txWorkFolder"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).ControlCount=   2
      TabCaption(1)   =   "Apariencia"
      TabPicture(1)   =   "fToolsOptions.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "chkHideLeftBar"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).Control(1)=   "TxBackColor"
      Tab(1).Control(1).Enabled=   0   'False
      Tab(1).Control(2)=   "TxLeftBarColor"
      Tab(1).Control(2).Enabled=   0   'False
      Tab(1).Control(3)=   "shLeftBarColor"
      Tab(1).Control(3).Enabled=   0   'False
      Tab(1).Control(4)=   "Label1"
      Tab(1).Control(4).Enabled=   0   'False
      Tab(1).Control(5)=   "Label11"
      Tab(1).Control(5).Enabled=   0   'False
      Tab(1).Control(6)=   "shBackColor"
      Tab(1).Control(6).Enabled=   0   'False
      Tab(1).ControlCount=   7
      Begin VB.CheckBox chkHideLeftBar 
         Alignment       =   1  'Right Justify
         Caption         =   "Ocultar la Barra Izquierda"
         Height          =   420
         Left            =   -74730
         TabIndex        =   10
         Top             =   1395
         Width           =   2310
      End
      Begin CSMaskEdit2.cMaskEdit TxBackColor 
         Height          =   285
         Left            =   -73065
         TabIndex        =   2
         Top             =   630
         Width           =   2040
         _ExtentX        =   3598
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
         Text            =   "0"
         csType          =   2
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
         csWithOutCalc   =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit TxLeftBarColor 
         Height          =   285
         Left            =   -73065
         TabIndex        =   8
         Top             =   1035
         Width           =   2040
         _ExtentX        =   3598
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
         Text            =   "0"
         csType          =   2
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
         csWithOutCalc   =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txWorkFolder 
         Height          =   285
         Left            =   90
         TabIndex        =   11
         Top             =   900
         Width           =   6000
         _ExtentX        =   10583
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
         csType          =   9
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin VB.Label Label2 
         Caption         =   "Carpeta de Trabajo"
         Height          =   285
         Left            =   135
         TabIndex        =   12
         Top             =   585
         Width           =   2625
      End
      Begin VB.Shape shLeftBarColor 
         BackStyle       =   1  'Opaque
         BorderColor     =   &H00808080&
         BorderWidth     =   2
         Height          =   300
         Left            =   -70995
         Top             =   1035
         Width           =   285
      End
      Begin VB.Label Label1 
         Caption         =   "Barra Izquierda :"
         Height          =   285
         Left            =   -74730
         TabIndex        =   9
         Top             =   1035
         Width           =   1680
      End
      Begin VB.Label Label11 
         Caption         =   "Fondo de la Ventana :"
         Height          =   285
         Left            =   -74730
         TabIndex        =   3
         Top             =   630
         Width           =   1680
      End
      Begin VB.Shape shBackColor 
         BackStyle       =   1  'Opaque
         BorderColor     =   &H00808080&
         BorderWidth     =   2
         Height          =   300
         Left            =   -70995
         Top             =   630
         Width           =   285
      End
   End
   Begin MSComDlg.CommonDialog CommDialog 
      Left            =   5580
      Top             =   60
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Image Image1 
      Height          =   585
      Left            =   135
      Picture         =   "fToolsOptions.frx":0044
      Top             =   45
      Width           =   675
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "Opciones:"
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
Attribute VB_Name = "fToolsOptions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdAceptar_Click()
  cmdApply_Click
  Unload Me
End Sub

Private Sub cmdApply_Click()
  Dim frm As Form
  
  If gWorkFolder <> txWorkFolder.Text Then
    gbFirstOpen = True
  End If
  
  SaveToolOptions
  LoadToolOptions
  
  For Each frm In Forms
    If TypeOf frm Is fReporte Then
      frm.picTop.BackColor = shBackColor.BackColor
      frm.BackColor = shBackColor.BackColor
      frm.lnLeft.BorderColor = shBackColor.BackColor
      frm.PicRule.BackColor = shLeftBarColor.BackColor
      frm.PicRule.Visible = chkHideLeftBar.Value = vbUnchecked
      frm.SizeControls
      frm.RefreshAll
      frm.RefreshPostion
    End If
  Next
End Sub

Private Sub cmdCancelar_Click()
  Me.Hide
End Sub

Private Sub Form_Load()
  On Error Resume Next
  CSKernelClient2.LoadForm Me, Me.Name
  TxBackColor.Text = gBackColor
  TxLeftBarColor.Text = gLeftBarColor
  txWorkFolder.Text = gWorkFolder
  TxBackColor_LostFocus
  TxLeftBarColor_LostFocus
  chkHideLeftBar.Value = IIf(gHideLeftBar, vbChecked, vbUnchecked)
End Sub

Private Sub Form_Unload(Cancel As Integer)
  CSKernelClient2.UnloadForm Me, Me.Name
End Sub

Private Sub TxBackColor_ButtonClick(ByRef Cancel As Boolean)
  On Error Resume Next
  
  Cancel = True
  With CommDialog
    .CancelError = True
    .Color = TxBackColor.csValue
    Err.Clear
    .ShowColor
    If Err.Number <> 0 Then Exit Sub
    TxBackColor.Text = .Color
  End With
  
  shBackColor.BackColor = TxBackColor.csValue
End Sub

Private Sub TxBackColor_KeyPress(KeyAscii As Integer)
  On Error Resume Next
  If KeyAscii = vbKeyReturn Then
    shBackColor.BackColor = TxBackColor.csValue
  End If
End Sub

Private Sub TxBackColor_LostFocus()
  TxBackColor_KeyPress vbKeyReturn
End Sub

Private Sub TxLeftBarColor_ButtonClick(Cancel As Boolean)
  On Error Resume Next
  
  Cancel = True
  With CommDialog
    .CancelError = True
    .Color = TxLeftBarColor.csValue
    Err.Clear
    .ShowColor
    If Err.Number <> 0 Then Exit Sub
    TxLeftBarColor.Text = .Color
  End With
  
  shLeftBarColor.BackColor = TxLeftBarColor.csValue
End Sub

Private Sub TxLeftBarColor_KeyPress(KeyAscii As Integer)
  On Error Resume Next
  If KeyAscii = vbKeyReturn Then
    shLeftBarColor.BackColor = TxLeftBarColor.csValue
  End If
End Sub

Private Sub TxLeftBarColor_LostFocus()
  TxLeftBarColor_KeyPress vbKeyReturn
End Sub

