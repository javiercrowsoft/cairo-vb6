VERSION 5.00
Begin VB.Form fAsk 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Archivos"
   ClientHeight    =   2205
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5880
   Icon            =   "fAsk.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2205
   ScaleWidth      =   5880
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdNo 
      Cancel          =   -1  'True
      Height          =   315
      Left            =   4350
      TabIndex        =   1
      Top             =   1800
      Width           =   1290
   End
   Begin VB.CommandButton cmdYes 
      Default         =   -1  'True
      Height          =   315
      Left            =   3000
      TabIndex        =   0
      Top             =   1800
      Width           =   1290
   End
   Begin VB.CheckBox chkDontAsk 
      Height          =   240
      Left            =   225
      TabIndex        =   2
      Top             =   1350
      Width           =   3765
   End
   Begin VB.Image Image1 
      Height          =   570
      Left            =   150
      Picture         =   "fAsk.frx":000C
      Top             =   150
      Width           =   615
   End
   Begin VB.Label lbQuestion 
      Height          =   840
      Left            =   975
      TabIndex        =   3
      Top             =   300
      Width           =   4440
   End
End
Attribute VB_Name = "fAsk"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_Yes As Boolean

Public Property Get Yes() As Boolean
    Yes = m_Yes
End Property

Private Sub cmdNo_Click()
    Me.Hide
End Sub

Private Sub cmdYes_Click()
    m_Yes = True
    Me.Hide
End Sub

Private Sub Form_Load()
    On Error Resume Next
    With Me
        .Move (Screen.Width - .Width) * 0.5, _
              (Screen.Height - .Height) * 0.5
    End With
    m_Yes = False
End Sub
