VERSION 5.00
Begin VB.Form fSplash 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   4500
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   6120
   Icon            =   "fSplashAFIP.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "fSplashAFIP.frx":08CA
   ScaleHeight     =   4500
   ScaleWidth      =   6120
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer Timer1 
      Interval        =   1000
      Left            =   0
      Top             =   0
   End
   Begin VB.Label LbVersion 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "1.0.0"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00000000&
      Height          =   240
      Left            =   4185
      TabIndex        =   0
      Top             =   1800
      Width           =   435
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H00000000&
      Height          =   4500
      Left            =   0
      Top             =   0
      Width           =   6120
   End
End
Attribute VB_Name = "fSplash"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim m_inicio As Boolean
Dim m_leftVersion  As Integer

Private Sub Form_Load()
    Top = (Screen.Height - Height) * 0.25
    Left = (Screen.Width - Width) * 0.5
    m_inicio = True
    LbVersion.Caption = App.Major & "." & App.Minor & "." & App.Revision
    m_leftVersion = LbVersion.Left
    LbVersion.Left = -LbVersion.Width
End Sub

Private Sub Timer1_Timer()
  Timer1.Enabled = False
  AlwaysOnTop Me, True
End Sub
