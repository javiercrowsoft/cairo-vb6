VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame1 
      Caption         =   "Frame1"
      Height          =   1995
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   4395
      Begin VB.OptionButton Option1 
         Caption         =   "Option1"
         Height          =   195
         Index           =   0
         Left            =   480
         TabIndex        =   1
         Top             =   360
         Width           =   735
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function SetParent Lib "user32" (ByVal hWndChild As Long, ByVal hWndNewParent As Long) As Long

Private Sub Form_Click()
  Load Me.Frame1(1)
  
  Me.Frame1(1).Top = 4000
  Me.Frame1(1).Visible = True
  Me.Frame1(1).BackColor = vbRed
  
  Load Me.Option1(1)
  Me.Option1(1).Visible = True
  
  Me.Option1(1).Top = Me.Option1(0).Top + 440
  
  Load Me.Option1(2)
  Load Me.Option1(3)
  
  Me.Option1(2).Visible = True
  Me.Option1(3).Visible = True
    
  SetParent Me.Option1(2).hWnd, Me.Frame1(1).hWnd
  SetParent Me.Option1(3).hWnd, Me.Frame1(1).hWnd
  
  Me.Option1(2).Top = Me.Option1(0).Top
  Me.Option1(3).Top = Me.Option1(0).Top + 440
  
End Sub

