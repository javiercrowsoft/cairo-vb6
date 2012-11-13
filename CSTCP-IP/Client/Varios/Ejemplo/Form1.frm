VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox Text1 
      Height          =   1500
      Left            =   675
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   630
      Width           =   3390
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Click()
  SendData lSocket, "jaja"
End Sub

'This project needs a TextBox
'-> (Name)=Text1
'-> MultiLine=True
'in a form
Private Sub Form_Load()
  Top = 0
  Left = 0
    'KPD-Team 2000
    'URL: http://www.allapi.net/
    'E-Mail: KPDTeam@Allapi.net
    Dim sSave As String
    Me.AutoRedraw = True
    Set Obj = Me.Text1
    'Start subclassing
    HookForm Me
    'create a new winsock session
    StartWinsock sSave
    'show the winsock version on this form
    If InStr(1, sSave, Chr$(0)) > 0 Then sSave = Left$(sSave, InStr(1, sSave, Chr$(0)) - 1)
    Me.Print sSave
    'connect to Microsoft.com
    lSocket = ConnectSock("192.160.142.93", 5001, 0, Me.hwnd, False)
End Sub
Private Sub Form_Unload(Cancel As Integer)
    'close our connection to microsoft.com
    closesocket lSocket
    'end winsock session
    EndWinsock
    'stop subclassing
    UnHookForm Me
End Sub

