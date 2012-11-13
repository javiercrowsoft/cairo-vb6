VERSION 5.00
Begin VB.Form fPics 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox PicGrid 
      AutoRedraw      =   -1  'True
      Height          =   510
      Left            =   495
      ScaleHeight     =   450
      ScaleWidth      =   1125
      TabIndex        =   1
      Top             =   315
      Width           =   1185
   End
   Begin VB.PictureBox PicBackground 
      AutoRedraw      =   -1  'True
      Height          =   510
      Left            =   495
      ScaleHeight     =   450
      ScaleWidth      =   1125
      TabIndex        =   0
      Top             =   945
      Width           =   1185
   End
End
Attribute VB_Name = "fPics"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

