VERSION 5.00
Begin VB.Form frmAbout 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "About Editawy Control"
   ClientHeight    =   1995
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4740
   ClipControls    =   0   'False
   Icon            =   "frmAbout.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1995
   ScaleWidth      =   4740
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton Command1 
      Caption         =   "OK"
      Height          =   315
      Left            =   3780
      TabIndex        =   0
      Top             =   1620
      Width           =   855
   End
   Begin VB.Label Label4 
      Caption         =   "http://www.mewsoft.com"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   178
         Weight          =   700
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C00000&
      Height          =   315
      Left            =   720
      MouseIcon       =   "frmAbout.frx":000C
      MousePointer    =   99  'Custom
      TabIndex        =   4
      Top             =   1320
      Width           =   3255
   End
   Begin VB.Label Label3 
      Caption         =   "For details and updates, please visit our site at :"
      Height          =   315
      Left            =   180
      TabIndex        =   3
      Top             =   1020
      Width           =   4335
   End
   Begin VB.Label Label2 
      Caption         =   "Copyrights © 2006 Mewsoft Corporation"
      Height          =   375
      Left            =   1140
      TabIndex        =   2
      Top             =   540
      Width           =   3255
   End
   Begin VB.Label Label1 
      Caption         =   "Mewsoft Editawy Control"
      Height          =   315
      Left            =   1200
      TabIndex        =   1
      Top             =   180
      Width           =   3135
   End
   Begin VB.Image Image1 
      Appearance      =   0  'Flat
      Height          =   765
      Left            =   60
      Picture         =   "frmAbout.frx":0316
      Stretch         =   -1  'True
      Top             =   180
      Width           =   915
   End
End
Attribute VB_Name = "frmAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==========================================================
'           Copyright Information
'==========================================================
'Program Name: Mewsoft Editawy
'Program Author   : Elsheshtawy, A. A.
'Home Page        : http://www.mewsoft.com
'Copyrights © 2006 Mewsoft Corporation. All rights reserved.
'==========================================================
'==========================================================
Option Explicit

Private Sub Command1_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    CenterForm Me
End Sub

Private Sub Label4_Click()
    ShellDocument "http://www.mewsoft.com"
End Sub
