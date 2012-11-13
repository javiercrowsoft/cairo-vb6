VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{57EC5E1A-9098-47A9-A8E3-EF352F97282B}#2.1#0"; "csButton.ocx"
Begin VB.Form fProgress 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Progreso"
   ClientHeight    =   4500
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6915
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4500
   ScaleWidth      =   6915
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ProgressBar prg 
      Height          =   285
      Left            =   225
      TabIndex        =   9
      Top             =   3375
      Width           =   2400
      _ExtentX        =   4233
      _ExtentY        =   503
      _Version        =   393216
      Appearance      =   0
      Scrolling       =   1
   End
   Begin MSComctlLib.ImageList Img 
      Left            =   3240
      Top             =   135
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
            Picture         =   "fProgress.frx":0000
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fProgress.frx":059A
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fProgress.frx":0B34
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin CSButton.cButton cmdCancel 
      Cancel          =   -1  'True
      Height          =   330
      Left            =   495
      TabIndex        =   5
      Top             =   3960
      Width           =   1410
      _ExtentX        =   2487
      _ExtentY        =   582
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
   Begin MSComctlLib.TreeView Tv 
      Height          =   3435
      Left            =   2835
      TabIndex        =   0
      Top             =   810
      Width           =   3750
      _ExtentX        =   6615
      _ExtentY        =   6059
      _Version        =   393217
      Indentation     =   353
      LineStyle       =   1
      Style           =   7
      ImageList       =   "Img"
      Appearance      =   0
   End
   Begin VB.Label lbTitle 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "CDTecka"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   765
      TabIndex        =   8
      Top             =   45
      Width           =   1200
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   135
      Picture         =   "fProgress.frx":0C8E
      Top             =   0
      Width           =   480
   End
   Begin VB.Line Line2 
      BorderColor     =   &H8000000F&
      BorderWidth     =   2
      X1              =   180
      X2              =   2565
      Y1              =   2925
      Y2              =   2925
   End
   Begin VB.Line Line1 
      BorderColor     =   &H8000000F&
      BorderWidth     =   2
      X1              =   180
      X2              =   2565
      Y1              =   3825
      Y2              =   3825
   End
   Begin VB.Label lbCDName 
      BackStyle       =   0  'Transparent
      Caption         =   "Visual Studio 6.0"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1185
      Left            =   270
      TabIndex        =   7
      Top             =   1485
      Width           =   2355
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Generando el diccionario del CD"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   270
      TabIndex        =   6
      Top             =   810
      Width           =   2265
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Son"
      Height          =   285
      Left            =   270
      TabIndex        =   4
      Top             =   3060
      Width           =   375
   End
   Begin VB.Label lbSon 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   240
      Left            =   585
      TabIndex        =   3
      Top             =   3060
      Width           =   780
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Van"
      Height          =   285
      Left            =   1485
      TabIndex        =   2
      Top             =   3060
      Width           =   375
   End
   Begin VB.Shape Shape2 
      BorderColor     =   &H8000000F&
      BorderWidth     =   2
      Height          =   3570
      Left            =   2745
      Top             =   765
      Width           =   3975
   End
   Begin VB.Label lbVan 
      Alignment       =   1  'Right Justify
      Caption         =   "0"
      Height          =   240
      Left            =   1800
      TabIndex        =   1
      Top             =   3060
      Width           =   780
   End
   Begin VB.Shape Shape1 
      BorderStyle     =   0  'Transparent
      FillColor       =   &H80000014&
      FillStyle       =   0  'Solid
      Height          =   3750
      Left            =   135
      Top             =   675
      Width           =   6675
   End
   Begin VB.Shape shTitle 
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   510
      Left            =   0
      Top             =   0
      Width           =   6975
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
' 18-07-2003

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
Private m_RaiseEvent As Boolean
' eventos
' propiedades publicas
Public Event StartProcess()
Public Event Cancel()

' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cmdCancel_Click()
  If Ask("Desea cancelar el proceso", vbYes) Then
    RaiseEvent Cancel
  End If
End Sub

' construccion - destruccion
Private Sub Form_Activate()
  If m_RaiseEvent Then
    m_RaiseEvent = False
    RaiseEvent StartProcess
  End If
End Sub

Private Sub Form_Load()
  m_RaiseEvent = True
  CenterForm Me
End Sub
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
