VERSION 5.00
Object = "{353A8433-36B8-422E-ABBD-36CEE8BE628E}#1.0#0"; "CSButton.ocx"
Begin VB.Form Form1 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Form1"
   ClientHeight    =   4845
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8325
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4845
   ScaleWidth      =   8325
   StartUpPosition =   3  'Windows Default
   Begin CSButton.cButtonLigth cButtonLigth2 
      Height          =   3615
      Left            =   1035
      TabIndex        =   9
      Top             =   630
      Width           =   4830
      _ExtentX        =   8520
      _ExtentY        =   6376
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
   Begin CSButton.cButton cButton3 
      Height          =   3615
      Left            =   1755
      TabIndex        =   8
      Top             =   630
      Width           =   4830
      _ExtentX        =   8520
      _ExtentY        =   6376
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
   Begin VB.PictureBox cButton2 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   3015
      ScaleHeight     =   315
      ScaleWidth      =   1935
      TabIndex        =   7
      Top             =   1755
      Width           =   1995
   End
   Begin VB.PictureBox cButtonLigth1 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   435
      Left            =   2400
      ScaleHeight     =   375
      ScaleWidth      =   1635
      TabIndex        =   6
      Top             =   3180
      Width           =   1695
   End
   Begin VB.TextBox Text2 
      Height          =   315
      Left            =   420
      TabIndex        =   2
      Text            =   "Text2"
      Top             =   2100
      Width           =   1515
   End
   Begin VB.TextBox Text1 
      Height          =   315
      Left            =   420
      TabIndex        =   1
      Text            =   "Text1"
      Top             =   1560
      Width           =   1455
   End
   Begin VB.PictureBox cButton1 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   0
      Left            =   420
      ScaleHeight     =   255
      ScaleWidth      =   1275
      TabIndex        =   0
      Top             =   720
      Width           =   1335
   End
   Begin VB.PictureBox cButton1 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   1
      Left            =   1740
      ScaleHeight     =   255
      ScaleWidth      =   1275
      TabIndex        =   3
      Top             =   720
      Width           =   1335
   End
   Begin VB.PictureBox cButton1 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   2
      Left            =   3060
      ScaleHeight     =   255
      ScaleWidth      =   1275
      TabIndex        =   4
      Top             =   720
      Width           =   1335
   End
   Begin VB.PictureBox cButton1 
      BackColor       =   &H80000009&
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Index           =   3
      Left            =   4380
      ScaleHeight     =   255
      ScaleWidth      =   1275
      TabIndex        =   5
      Top             =   720
      Width           =   1335
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private Sub cButton2_Click()
  cButtonLigth1.Default = True
End Sub

Private Sub cButtonLigth1_Click()
  cButton2.Default = True
End Sub

Private Sub Form_Click()
  Static n
  n = n + 1
  If n > 3 Then n = 0
  cButton1(n).TabSelected = True
End Sub
