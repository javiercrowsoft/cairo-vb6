VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form fPrinterError 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "CrowSoft Impresión"
   ClientHeight    =   5775
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   6930
   Icon            =   "fPrinterError.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5775
   ScaleWidth      =   6930
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txPrinters 
      BorderStyle     =   0  'None
      Height          =   3015
      Left            =   540
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   2
      Text            =   "fPrinterError.frx":038A
      Top             =   1740
      Width           =   6015
   End
   Begin CSButton.cButtonLigth cmdOk 
      Cancel          =   -1  'True
      Default         =   -1  'True
      Height          =   315
      Left            =   5160
      TabIndex        =   1
      Top             =   5280
      Width           =   1395
      _ExtentX        =   2461
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
      ForeColor       =   0
   End
   Begin VB.Shape Shape2 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00FFC0C0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   3045
      Left            =   525
      Top             =   1725
      Width           =   6050
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   420
      Picture         =   "fPrinterError.frx":0390
      Top             =   600
      Width           =   480
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   120
      X2              =   6840
      Y1              =   5100
      Y2              =   5100
   End
   Begin VB.Label lbMessage 
      BackStyle       =   0  'Transparent
      Caption         =   "Label1"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1215
      Left            =   1140
      TabIndex        =   0
      Top             =   420
      Width           =   5295
   End
   Begin VB.Shape Shape1 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00FFC0C0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   4755
      Left            =   180
      Top             =   240
      Width           =   6555
   End
End
Attribute VB_Name = "fPrinterError"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdOk_Click()
  On Error Resume Next
  Me.Hide
End Sub

Private Sub Form_Load()
  On Error Resume Next
  CSKernelClient2.CenterForm Me
End Sub
