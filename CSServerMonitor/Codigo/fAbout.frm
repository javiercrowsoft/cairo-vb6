VERSION 5.00
Begin VB.Form fAbout 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Acerca de "
   ClientHeight    =   3705
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6120
   Icon            =   "fAbout.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3705
   ScaleWidth      =   6120
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.Line Line1 
      BorderColor     =   &H00808080&
      X1              =   -240
      X2              =   6120
      Y1              =   2160
      Y2              =   2160
   End
   Begin VB.Label lbTradeMarks 
      BackStyle       =   0  'Transparent
      Caption         =   $"fAbout.frx":000C
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   915
      Left            =   90
      TabIndex        =   4
      Top             =   2760
      Width           =   4155
   End
   Begin VB.Label lbCopyRight 
      BackStyle       =   0  'Transparent
      Caption         =   "CopyRight © CrowSoft 2003"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   330
      Left            =   90
      TabIndex        =   3
      Top             =   2355
      Width           =   4155
   End
   Begin VB.Label lbVersion 
      BackStyle       =   0  'Transparent
      Caption         =   "1.0.0"
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
      Height          =   330
      Left            =   4680
      TabIndex        =   2
      Top             =   1800
      Width           =   1365
   End
   Begin VB.Label lbProductName 
      BackStyle       =   0  'Transparent
      Caption         =   "Consola del Administrador"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   24
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00808080&
      Height          =   1140
      Left            =   2160
      TabIndex        =   1
      Top             =   585
      Width           =   3300
   End
   Begin VB.Label lbCompany 
      BackStyle       =   0  'Transparent
      Caption         =   "CrowSoft"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   18
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   510
      Left            =   1215
      TabIndex        =   0
      Top             =   135
      Width           =   2490
   End
   Begin VB.Image Image1 
      Height          =   1410
      Left            =   -45
      Picture         =   "fAbout.frx":00D1
      Top             =   -45
      Width           =   1125
   End
End
Attribute VB_Name = "fAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
  On Error Resume Next
  CenterForm Me
  lbProductName.Caption = App.ProductName
  lbCompany.Caption = App.CompanyName
  lbVersion.Caption = App.Major & "." & App.Minor & "." & App.Revision
  lbCopyRight.Caption = App.LegalCopyright
  lbTradeMarks.Caption = App.LegalTrademarks
End Sub
