VERSION 5.00
Begin VB.Form fAbout 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   0  'None
   ClientHeight    =   3450
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   5940
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "fAboutSmall.frx":0000
   ScaleHeight     =   3450
   ScaleWidth      =   5940
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Shape Shape1 
      Height          =   3450
      Left            =   0
      Top             =   0
      Width           =   5940
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Cairo"
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   48
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00404040&
      Height          =   1335
      Left            =   3000
      TabIndex        =   2
      Top             =   1860
      Width           =   3675
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "CrowSoft"
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   36
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000080FF&
      Height          =   975
      Left            =   1320
      TabIndex        =   1
      Top             =   1380
      Width           =   4395
   End
   Begin VB.Label LbVersion 
      Alignment       =   1  'Right Justify
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "exe: 10.0.10 - db: 10.0.1"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   270
      Left            =   3360
      TabIndex        =   0
      Top             =   3120
      Width           =   2415
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "CrowSoft"
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   36
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C0C0C0&
      Height          =   975
      Left            =   1305
      TabIndex        =   3
      Top             =   1350
      Width           =   4395
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "Cairo"
      BeginProperty Font 
         Name            =   "Arial Black"
         Size            =   48
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C0C0C0&
      Height          =   1335
      Left            =   2970
      TabIndex        =   4
      Top             =   1845
      Width           =   3675
   End
End
Attribute VB_Name = "fAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Activate()
  ActiveBar Me
End Sub

Private Sub Form_Deactivate()
  DeactiveBar Me
End Sub

Private Sub Form_Load()
  CSKernelClient2.CenterForm Me, fMain
  LbVersion.Caption = "exe: " & GetExeVersion & " - db: " & CSOAPI2.BdVersion
End Sub

Private Sub Form_Unload(Cancel As Integer)
  DeactiveBar Me
End Sub

Private Sub Form_Click()
  Unload Me
End Sub

