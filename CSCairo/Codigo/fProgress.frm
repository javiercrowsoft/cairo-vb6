VERSION 5.00
Begin VB.Form fProgress 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Installing CrowSoft Cairo"
   ClientHeight    =   3900
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   7680
   Icon            =   "fProgress.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3900
   ScaleWidth      =   7680
   StartUpPosition =   3  'Windows Default
   Begin VB.Label lbFile 
      BackStyle       =   0  'Transparent
      BorderStyle     =   1  'Fixed Single
      Height          =   315
      Left            =   1860
      TabIndex        =   1
      Top             =   3300
      Visible         =   0   'False
      Width           =   5655
   End
   Begin VB.Label lbTask 
      BackStyle       =   0  'Transparent
      Caption         =   "Copiando Archivos:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   60
      TabIndex        =   0
      Top             =   3300
      Visible         =   0   'False
      Width           =   1815
   End
   Begin VB.Image Image1 
      Height          =   3120
      Left            =   -60
      Picture         =   "fProgress.frx":08CA
      Top             =   0
      Width           =   7770
   End
End
Attribute VB_Name = "fProgress"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
  On Error Resume Next
  Me.Left = (Screen.Width - Me.Width) * 0.5
  Me.Top = (Screen.Height - Me.Height) * 0.5
End Sub
