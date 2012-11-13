VERSION 5.00
Begin VB.Form fAbout 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   2910
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   7260
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   ScaleHeight     =   2910
   ScaleWidth      =   7260
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   $"fAbout.frx":0000
      Height          =   855
      Left            =   180
      TabIndex        =   2
      Top             =   1860
      Width           =   6675
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "CrowSoft"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   24
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   555
      Left            =   3540
      TabIndex        =   1
      Top             =   300
      Width           =   3255
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "CSSQLAdmin"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0080C0FF&
      Height          =   555
      Left            =   4500
      TabIndex        =   0
      Top             =   900
      Width           =   2235
   End
   Begin VB.Shape Shape1 
      Height          =   2895
      Left            =   0
      Top             =   0
      Width           =   7215
   End
   Begin VB.Image Image1 
      Height          =   1485
      Left            =   60
      Picture         =   "fAbout.frx":0137
      Top             =   120
      Width           =   3360
   End
End
Attribute VB_Name = "fAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Click()
  On Error Resume Next
  Unload Me
End Sub

Private Sub Form_Load()
  On Error Resume Next
  CenterForm Me
End Sub

Private Sub Image1_Click()
  Form_Click
End Sub

Private Sub Label1_Click()
  Form_Click
End Sub

Private Sub Label2_Click()
  Form_Click
End Sub

Private Sub Label3_Click()
  Form_Click
End Sub
