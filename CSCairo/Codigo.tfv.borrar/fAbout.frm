VERSION 5.00
Begin VB.Form fAbout 
   BackColor       =   &H00C0C0FF&
   BorderStyle     =   0  'None
   ClientHeight    =   4575
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   7815
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "fAbout.frx":0000
   ScaleHeight     =   4575
   ScaleWidth      =   7815
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
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
      Left            =   5340
      TabIndex        =   0
      Top             =   3540
      Width           =   2415
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

