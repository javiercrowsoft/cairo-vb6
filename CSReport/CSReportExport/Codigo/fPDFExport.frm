VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form fPDFExport 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Exportar a PDF"
   ClientHeight    =   2325
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   9960
   Icon            =   "fPDFExport.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2325
   ScaleWidth      =   9960
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog cdSave 
      Left            =   4770
      Top             =   1245
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin CSButton.cButtonLigth cmdSave 
      Height          =   330
      Left            =   4230
      TabIndex        =   1
      Top             =   1875
      Width           =   1335
      _ExtentX        =   2355
      _ExtentY        =   582
      Caption         =   "&Guardar"
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
      Picture         =   "fPDFExport.frx":058A
   End
   Begin CSButton.cButtonLigth cmdSendMail 
      Height          =   330
      Left            =   705
      TabIndex        =   0
      Top             =   1875
      Width           =   1725
      _ExtentX        =   3043
      _ExtentY        =   582
      Caption         =   "&Enviar por e-mail"
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
      Picture         =   "fPDFExport.frx":0B24
   End
   Begin CSButton.cButtonLigth cmdPreview 
      Height          =   330
      Left            =   2505
      TabIndex        =   2
      Top             =   1875
      Width           =   1650
      _ExtentX        =   2910
      _ExtentY        =   582
      Caption         =   "&Vista previa"
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
      Picture         =   "fPDFExport.frx":0C2B
   End
   Begin CSButton.cButtonLigth cmdClose 
      Height          =   330
      Left            =   5820
      TabIndex        =   8
      Top             =   1875
      Width           =   1095
      _ExtentX        =   1931
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
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "¿Que desea hacer con el archivo?"
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
      Height          =   375
      Left            =   720
      TabIndex        =   7
      Top             =   1425
      Width           =   3060
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Se generó con éxito."
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
      Height          =   375
      Left            =   720
      TabIndex        =   6
      Top             =   1110
      Width           =   5400
   End
   Begin VB.Image imLarge 
      Height          =   480
      Left            =   60
      Picture         =   "fPDFExport.frx":0D34
      Top             =   120
      Width           =   480
   End
   Begin VB.Label Label5 
      BackColor       =   &H00FFFFFF&
      Caption         =   "El archivo:"
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
      TabIndex        =   4
      Top             =   120
      Width           =   1695
   End
   Begin VB.Label lbFile 
      BackStyle       =   0  'Transparent
      ForeColor       =   &H00000000&
      Height          =   495
      Left            =   720
      TabIndex        =   3
      Top             =   540
      Width           =   9120
   End
   Begin VB.Label Label4 
      BackColor       =   &H00FFFFFF&
      ForeColor       =   &H00000000&
      Height          =   1815
      Left            =   0
      TabIndex        =   5
      Top             =   -60
      Width           =   10140
   End
End
Attribute VB_Name = "fPDFExport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const C_Module = "fPDFExport"

Public Event SendEmail()
Public Event Save()
Public Event Preview()

Private m_OutputFile As String

Public Property Get OutputFile() As String
  OutputFile = m_OutputFile
End Property

Public Property Let OutputFile(ByVal rhs As String)
  m_OutputFile = rhs
End Property

Private Sub cmdClose_Click()
  On Error Resume Next
  Unload Me
End Sub

Private Sub cmdPreview_Click()
  On Error GoTo ControlError
  
  RaiseEvent Preview

  GoTo ExitProc
ControlError:
  MngError Err, "cmdPreview_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdSave_Click()
  On Error GoTo ControlError
  
  RaiseEvent Save

  GoTo ExitProc
ControlError:
  MngError Err, "cmdSave_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub cmdSendMail_Click()
  On Error GoTo ControlError
  
  RaiseEvent SendEmail

  GoTo ExitProc
ControlError:
  MngError Err, "cmdSendMail_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Load()
  On Error Resume Next
  CenterForm Me
End Sub
