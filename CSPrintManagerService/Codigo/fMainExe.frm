VERSION 5.00
Begin VB.Form fMain 
   Caption         =   "CrowSoft Servicio de Impresion"
   ClientHeight    =   3765
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   5205
   Icon            =   "fMainExe.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3765
   ScaleWidth      =   5205
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tm 
      Interval        =   1000
      Left            =   4200
      Top             =   1800
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Servidor de Impresión"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   18
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   855
      Left            =   1320
      TabIndex        =   0
      Top             =   360
      Width           =   3735
   End
   Begin VB.Image Image1 
      Height          =   855
      Left            =   120
      Picture         =   "fMainExe.frx":038A
      Top             =   120
      Width           =   900
   End
   Begin VB.Shape shTop 
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   1335
      Left            =   0
      Top             =   0
      Width           =   5175
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_service As cService


Private Sub Form_Load()
  Set m_service = New cService
  m_service.run fMain
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  shTop.Width = Me.ScaleWidth
  m_service.Resize Me.Left + 300, Me.Top + 1800, Me.Height - 2100, Me.Width - 600
End Sub

Private Sub tm_Timer()
  Form_Resize
End Sub
