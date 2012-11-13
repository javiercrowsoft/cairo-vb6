VERSION 5.00
Begin VB.Form fSplash 
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   4575
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   7815
   LinkTopic       =   "Form1"
   Picture         =   "fSplash.frx":0000
   ScaleHeight     =   4575
   ScaleWidth      =   7815
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Interval        =   3000
      Left            =   135
      Top             =   2205
   End
   Begin VB.Label lbVersion 
      Alignment       =   1  'Right Justify
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BackStyle       =   0  'Transparent
      Caption         =   "1.0.1"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   240
      Left            =   4320
      TabIndex        =   0
      Top             =   3420
      Width           =   1005
   End
End
Attribute VB_Name = "fSplash"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Click()
  Unload Me
End Sub

Private Sub Form_Load()
  lbVersion.Caption = App.Major & "." & App.Minor & "." & App.Revision
  
  Left = fMain.Left + (fMain.Width - Width) / 2
  Top = fMain.Top + (fMain.Height - Height) / 2
  
  Timer1.Enabled = True
End Sub

Private Sub Timer1_Timer()
  Timer1.Enabled = False
  Unload Me
End Sub
