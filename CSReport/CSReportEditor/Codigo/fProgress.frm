VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fProgress 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Progreso"
   ClientHeight    =   2820
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4740
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2820
   ScaleWidth      =   4740
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ProgressBar prgVar 
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   1860
      Width           =   4455
      _ExtentX        =   7858
      _ExtentY        =   450
      _Version        =   393216
      Appearance      =   0
      Scrolling       =   1
   End
   Begin CSButton.cButtonLigth cmdCancel 
      Cancel          =   -1  'True
      Height          =   315
      Left            =   1740
      TabIndex        =   1
      Top             =   2460
      Width           =   1260
      _ExtentX        =   2223
      _ExtentY        =   556
      Caption         =   "Cancelar"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      FontName        =   "Arial"
      FontSize        =   8.25
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   60
      X2              =   4680
      Y1              =   2355
      Y2              =   2355
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   60
      X2              =   4680
      Y1              =   2340
      Y2              =   2340
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H8000000F&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00FFFFFF&
      Height          =   375
      Left            =   60
      Top             =   1800
      Width           =   4575
   End
   Begin VB.Image Image1 
      Height          =   720
      Left            =   60
      Picture         =   "fProgress.frx":0000
      Top             =   120
      Width           =   720
   End
   Begin VB.Label lbTask 
      BackStyle       =   0  'Transparent
      Caption         =   "Listado de Ventas por Cliente Padre, Cliente y Cuenta Contable"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   555
      Left            =   1080
      TabIndex        =   10
      Top             =   420
      Width           =   3615
   End
   Begin VB.Label Label1 
      Caption         =   "Registros :"
      Height          =   240
      Left            =   180
      TabIndex        =   9
      Top             =   1440
      Width           =   780
   End
   Begin VB.Label Label2 
      Caption         =   "Van :"
      Height          =   255
      Left            =   2400
      TabIndex        =   8
      Top             =   1440
      Width           =   375
   End
   Begin VB.Label lbRecordCount 
      Height          =   255
      Left            =   1080
      TabIndex        =   7
      Top             =   1440
      Width           =   975
   End
   Begin VB.Label lbCurrRecord 
      Height          =   255
      Left            =   2880
      TabIndex        =   6
      Top             =   1440
      Width           =   735
   End
   Begin VB.Label Label3 
      Caption         =   "Generando página :"
      Height          =   255
      Left            =   180
      TabIndex        =   5
      Top             =   1140
      Width           =   1575
   End
   Begin VB.Label lbCurrPage 
      Height          =   255
      Left            =   1860
      TabIndex        =   4
      Top             =   1140
      Width           =   975
   End
   Begin VB.Label Label5 
      BackColor       =   &H00FFFFFF&
      Caption         =   "Progreso"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   255
      Left            =   840
      TabIndex        =   2
      Top             =   120
      Width           =   1695
   End
   Begin VB.Label Label4 
      BackColor       =   &H00FFFFFF&
      ForeColor       =   &H00000000&
      Height          =   1020
      Left            =   0
      TabIndex        =   3
      Top             =   0
      Width           =   4740
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
' 13-02-2002

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
' estructuras
' variables privadas
' eventos
Public Event Cancel()
' propiedades publicas
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cmdCancel_Click()
  RaiseEvent Cancel
End Sub
' construccion - destruccion
Private Sub Form_Load()
  CenterForm Me
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  gError.MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

