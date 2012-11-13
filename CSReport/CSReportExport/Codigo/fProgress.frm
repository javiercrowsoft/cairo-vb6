VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fProgress 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Exportando a Word"
   ClientHeight    =   2010
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   Icon            =   "fProgress.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2010
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ImageList imlLarge 
      Left            =   3240
      Top             =   600
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   32
      ImageHeight     =   32
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   3
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fProgress.frx":014A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fProgress.frx":0464
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fProgress.frx":077E
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ImageList imlSmall 
      Left            =   3960
      Top             =   600
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   3
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fProgress.frx":1058
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fProgress.frx":11B2
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fProgress.frx":130C
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ProgressBar prgVar 
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   1260
      Width           =   4215
      _ExtentX        =   7435
      _ExtentY        =   450
      _Version        =   393216
      BorderStyle     =   1
      Appearance      =   0
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Cancel          =   -1  'True
      Height          =   315
      Left            =   1740
      TabIndex        =   4
      Top             =   1620
      Width           =   1260
      _ExtentX        =   2223
      _ExtentY        =   556
      Caption         =   "Cancelar"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Arial"
      FontSize        =   9
   End
   Begin VB.Label lbCurrPage 
      Alignment       =   1  'Right Justify
      Height          =   375
      Left            =   1680
      TabIndex        =   8
      Top             =   780
      Width           =   375
   End
   Begin VB.Label Label3 
      Caption         =   "Generando página"
      Height          =   375
      Left            =   240
      TabIndex        =   7
      Top             =   780
      Width           =   1455
   End
   Begin VB.Label lbPages 
      Height          =   255
      Left            =   2400
      TabIndex        =   6
      Top             =   780
      Width           =   615
   End
   Begin VB.Label Label1 
      Caption         =   "de"
      Height          =   240
      Left            =   2160
      TabIndex        =   5
      Top             =   780
      Width           =   300
   End
   Begin VB.Label lbTask 
      BackStyle       =   0  'Transparent
      Caption         =   "Exportando a Word"
      ForeColor       =   &H00000000&
      Height          =   375
      Left            =   1620
      TabIndex        =   0
      Top             =   360
      Width           =   3015
   End
   Begin VB.Label Label5 
      BackColor       =   &H00FFFFFF&
      Caption         =   "Progreso"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   255
      Left            =   720
      TabIndex        =   1
      Top             =   120
      Width           =   1695
   End
   Begin VB.Image imLarge 
      Height          =   480
      Left            =   60
      Picture         =   "fProgress.frx":18A6
      Top             =   120
      Width           =   480
   End
   Begin VB.Label Label4 
      BackColor       =   &H00FFFFFF&
      ForeColor       =   &H00000000&
      Height          =   720
      Left            =   0
      TabIndex        =   2
      Top             =   0
      Width           =   4680
   End
End
Attribute VB_Name = "fProgress"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fProgress
' 26-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  ' estructuras
  ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fProgress"
Private Enum csEIcons
  csEIWord = 1
  csEIExcel
  csEIAcrobat
End Enum
' estructuras
' variables privadas
Private m_Done                  As Boolean
Private m_Ok                    As Boolean
Private m_bRaiseEventSendEmail  As Boolean

' eventos
Public Event Cancel()
Public Event Export()
'Public Event KillProcessPDFCreator()

' propiedades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Public Property Let Ok(ByVal rhs As Boolean)
  m_Ok = rhs
End Property
' propiedades privadas
' funciones publicas
Public Sub InitExcel()
  Set Me.Icon = imlSmall.ListImages(csEIExcel).Picture
  Set imLarge.Picture = imlLarge.ListImages(csEIExcel).Picture
End Sub

Public Sub InitWord()
  Set Me.Icon = imlSmall.ListImages(csEIWord).Picture
  Set imLarge.Picture = imlLarge.ListImages(csEIWord).Picture
End Sub

Public Sub InitAcrobat()
  Set Me.Icon = imlSmall.ListImages(csEIAcrobat).Picture
  Set imLarge.Picture = imlLarge.ListImages(csEIAcrobat).Picture
End Sub

' funciones friend
' funciones privadas
Private Sub cmdCancel_Click()
  RaiseEvent Cancel
End Sub

Private Sub Form_Activate()
  If m_Done Then Exit Sub
  m_Done = True
  m_Ok = False
  RaiseEvent Export
  Hide
End Sub

'Private Sub tmKillPdfCreator_Timer()
'  On Error GoTo ControlError
'
'  RaiseEvent KillProcessPDFCreator '"PDFCreator.exe"
'
'  GoTo ExitProc
'ControlError:
'  MngError Err, "tmKillPdfCreator_Timer", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
'End Sub

' construccion - destruccion
Private Sub Form_Load()
  CenterForm Me
  m_Done = False
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  gError.MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
