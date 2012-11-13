VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6075
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6405
   LinkTopic       =   "Form1"
   ScaleHeight     =   6075
   ScaleWidth      =   6405
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text4 
      Height          =   1860
      Left            =   990
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   5
      Top             =   4050
      Width           =   4965
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Send"
      Height          =   330
      Left            =   945
      TabIndex        =   4
      Top             =   3645
      Width           =   1680
   End
   Begin VB.TextBox Text3 
      Height          =   1860
      Left            =   945
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   3
      Top             =   1665
      Width           =   4965
   End
   Begin VB.TextBox Text2 
      Height          =   285
      Left            =   945
      TabIndex        =   2
      Text            =   "5001"
      Top             =   765
      Width           =   2580
   End
   Begin VB.TextBox Text1 
      Height          =   285
      Left            =   945
      TabIndex        =   1
      Text            =   "mesalina"
      Top             =   360
      Width           =   2580
   End
   Begin VB.CommandButton Connect 
      Caption         =   "Connect"
      Height          =   330
      Left            =   945
      TabIndex        =   0
      Top             =   1170
      Width           =   1680
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private WithEvents m_client As cTCPIPClient
Attribute m_client.VB_VarHelpID = -1

Private Sub Command1_Click()
  m_client.SendAndReciveText Text3.Text, SRV_ID_CHAT
End Sub

Private Sub Connect_Click()
  m_client.ConnectToServer Text1.Text, Text2.Text
End Sub

Private Sub Form_Load()
  Set m_client = New cTCPIPClient
  m_client.ShowLog = True
End Sub

Private Sub Form_Unload(Cancel As Integer)
  MsgBox "destruyendo"
  m_client.TerminateSesion
  Set m_client = Nothing
  MsgBox "destruido"
End Sub

Private Sub m_client_ReciveText(ByVal Buffer As String)
  Text4.Text = Text4.Text & Buffer
End Sub
