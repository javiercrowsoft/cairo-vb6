VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "tabctl32.ocx"
Object = "{F7BB685C-0860-4FD1-A9CF-22277199D7A5}#1.2#0"; "CSMaskEdit2.ocx"
Begin VB.Form fPageSetup 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Configurar Página"
   ClientHeight    =   4605
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5850
   Icon            =   "fPageSetup.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4605
   ScaleWidth      =   5850
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox Picture1 
      BorderStyle     =   0  'None
      Height          =   795
      Left            =   -120
      ScaleHeight     =   795
      ScaleWidth      =   6615
      TabIndex        =   3
      Top             =   3945
      Width           =   6615
      Begin CSButton.cButton cmdCancelar 
         Cancel          =   -1  'True
         Height          =   315
         Left            =   4545
         TabIndex        =   4
         Top             =   240
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
         Default         =   -1  'True
         Height          =   315
         Left            =   3150
         TabIndex        =   5
         Top             =   240
         Width           =   1275
         _ExtentX        =   2249
         _ExtentY        =   556
         Caption         =   "&Aceptar"
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
      Begin VB.Line Line6 
         BorderColor     =   &H80000014&
         X1              =   90
         X2              =   6375
         Y1              =   60
         Y2              =   60
      End
      Begin VB.Line Line5 
         BorderColor     =   &H80000010&
         X1              =   105
         X2              =   6390
         Y1              =   45
         Y2              =   45
      End
   End
   Begin TabDlg.SSTab TabMain 
      Height          =   4350
      Left            =   -30
      TabIndex        =   0
      Top             =   600
      Width           =   6285
      _ExtentX        =   11086
      _ExtentY        =   7673
      _Version        =   393216
      Style           =   1
      Tabs            =   1
      TabsPerRow      =   5
      TabHeight       =   503
      TabCaption(0)   =   "Tamaño"
      TabPicture(0)   =   "fPageSetup.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Label6"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Label5"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "Label13"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "Shape2"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "imgHorizontal"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).Control(5)=   "imgVertical"
      Tab(0).Control(5).Enabled=   0   'False
      Tab(0).Control(6)=   "Label1"
      Tab(0).Control(6).Enabled=   0   'False
      Tab(0).Control(7)=   "txWidth"
      Tab(0).Control(7).Enabled=   0   'False
      Tab(0).Control(8)=   "txHeight"
      Tab(0).Control(8).Enabled=   0   'False
      Tab(0).Control(9)=   "cbPaperType"
      Tab(0).Control(9).Enabled=   0   'False
      Tab(0).Control(10)=   "opVertical"
      Tab(0).Control(10).Enabled=   0   'False
      Tab(0).Control(11)=   "opHorizontal"
      Tab(0).Control(11).Enabled=   0   'False
      Tab(0).ControlCount=   12
      Begin VB.OptionButton opHorizontal 
         Caption         =   "Horizontal"
         Height          =   255
         Left            =   1800
         TabIndex        =   13
         Top             =   2700
         Width           =   1035
      End
      Begin VB.OptionButton opVertical 
         Caption         =   "Vertical"
         Height          =   255
         Left            =   1800
         TabIndex        =   12
         Top             =   2340
         Width           =   1035
      End
      Begin VB.ComboBox cbPaperType 
         Height          =   315
         ItemData        =   "fPageSetup.frx":0028
         Left            =   1365
         List            =   "fPageSetup.frx":002A
         Sorted          =   -1  'True
         Style           =   2  'Dropdown List
         TabIndex        =   10
         Top             =   720
         Width           =   2280
      End
      Begin CSMaskEdit2.cMaskEdit txHeight 
         Height          =   330
         Left            =   1365
         TabIndex        =   6
         Top             =   1140
         Width           =   1230
         _ExtentX        =   2170
         _ExtentY        =   582
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   9.75
         EnabledNoChngBkColor=   0   'False
         Text            =   "0.00"
         csType          =   3
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin CSMaskEdit2.cMaskEdit txWidth 
         Height          =   330
         Left            =   1365
         TabIndex        =   7
         Top             =   1500
         Width           =   1230
         _ExtentX        =   2170
         _ExtentY        =   582
         Alignment       =   1
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   9.75
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         FontName        =   "MS Sans Serif"
         FontSize        =   9.75
         EnabledNoChngBkColor=   0   'False
         Text            =   "0.00"
         csType          =   3
         BorderColor     =   12164479
         BorderType      =   1
         csNotRaiseError =   -1  'True
      End
      Begin VB.Label Label1 
         Caption         =   " Orientación"
         Height          =   315
         Left            =   195
         TabIndex        =   14
         Top             =   1980
         Width           =   915
      End
      Begin VB.Image imgVertical 
         Height          =   480
         Left            =   720
         Picture         =   "fPageSetup.frx":002C
         Top             =   2340
         Width           =   390
      End
      Begin VB.Image imgHorizontal 
         Height          =   375
         Left            =   720
         Picture         =   "fPageSetup.frx":02AE
         Top             =   2400
         Width           =   480
      End
      Begin VB.Shape Shape2 
         BorderColor     =   &H80000010&
         Height          =   1125
         Left            =   105
         Top             =   2100
         Width           =   5595
      End
      Begin VB.Label Label13 
         Caption         =   "Tipo de papel :"
         Height          =   285
         Left            =   180
         TabIndex        =   11
         Top             =   720
         Width           =   1155
      End
      Begin VB.Label Label5 
         Caption         =   "Ancho :"
         Height          =   285
         Left            =   690
         TabIndex        =   9
         Top             =   1500
         Width           =   915
      End
      Begin VB.Label Label6 
         Caption         =   "Alto :"
         Height          =   285
         Left            =   870
         TabIndex        =   8
         Top             =   1140
         Width           =   915
      End
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   135
      Picture         =   "fPageSetup.frx":04C0
      Top             =   45
      Width           =   480
   End
   Begin VB.Label Label8 
      BackStyle       =   0  'Transparent
      Caption         =   "Configurar página"
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
      Left            =   690
      TabIndex        =   2
      Top             =   135
      Width           =   2235
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
      Left            =   2925
      TabIndex        =   1
      Top             =   135
      Width           =   1815
   End
   Begin VB.Shape Shape1 
      BorderStyle     =   0  'Transparent
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   600
      Left            =   0
      Top             =   0
      Width           =   6360
   End
End
Attribute VB_Name = "fPageSetup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'--------------------------------------------------------------------------------
' fPageSetup
' 02-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fPageSetup"
' estructuras
' variables privadas
Private m_Ok                As Boolean

Private m_CustomHeight      As Single
Private m_CustomWidth       As Single
' eventos
' propiedades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Public Function InitDialog(ByVal PaperSize As PrinterObjectConstants, _
                           ByVal CustomWidth As Single, _
                           ByVal CustomHeight As Single, _
                           ByVal Orientation As Long)

  
  m_CustomHeight = CustomHeight
  m_CustomWidth = CustomWidth

  opHorizontal.Value = Orientation = vbPRORLandscape

  ListSetListIndexForId cbPaperType, PaperSize
End Function

Public Function PaperSize() As PrinterObjectConstants
  PaperSize = ListID(cbPaperType)
End Function

Public Function CustomWidth() As Single
  CustomWidth = CSng(txWidth.Text) * 564
End Function

Public Function CustomHeigth() As Single
  CustomHeigth = CSng(txHeight.Text) * 564
End Function

' funciones friend
' funciones privadas
Private Function pFillPageTypes()
  
  With cbPaperType
    .AddItem "Carta"
    .ItemData(.NewIndex) = vbPRPSLetter
    .AddItem "A4"
    .ItemData(.NewIndex) = vbPRPSA4
    .AddItem "A3"
    .ItemData(.NewIndex) = vbPRPSA3
    .AddItem "Oficio"
    .ItemData(.NewIndex) = vbPRPSLegal
    .AddItem "(Personalizado)"
    .ItemData(.NewIndex) = vbPRPSUser
  End With

  ListSetListIndexForId cbPaperType, vbPRPSLetter
End Function

Private Sub cbPaperType_Click()
  Dim Width   As Single
  Dim Height  As Single
  
  txWidth.Enabled = False
  txHeight.Enabled = False
  
  Select Case ListID(cbPaperType)
    Case vbPRPSLetter
      Width = 21.59
      Height = 27.94
    Case vbPRPSLegal
      Width = 21.59
      Height = 35.56
    Case vbPRPSA4
      Width = 21
      Height = 29.7
    Case vbPRPSA3
      Width = 29.7
      Height = 42
    Case Else
      txWidth.Enabled = True
      txHeight.Enabled = True
      Height = m_CustomHeight / 564
      Width = m_CustomWidth / 564
  End Select
  
  txWidth.Text = Width
  txHeight.Text = Height
End Sub

Private Sub cmdAceptar_Click()
  m_Ok = True
  Me.Hide
End Sub

Private Sub cmdCancelar_Click()
  m_Ok = False
  Me.Hide
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If UnloadMode = vbFormControlMenu Then
    Cancel = True
    cmdCancelar_Click
  End If
End Sub

Private Sub opVertical_Click()
  pSetOrientation
End Sub

Private Sub opHorizontal_Click()
  pSetOrientation
End Sub

Private Sub pSetOrientation()
  If opVertical.Value Then
    imgHorizontal.Visible = False
    imgVertical.Visible = True
  Else
    imgHorizontal.Visible = True
    imgVertical.Visible = False
  End If
End Sub
' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  
  pFillPageTypes
  opVertical.Value = True

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
