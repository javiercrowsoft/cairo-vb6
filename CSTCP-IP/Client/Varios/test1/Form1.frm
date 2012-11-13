VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5505
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8805
   LinkTopic       =   "Form1"
   ScaleHeight     =   5505
   ScaleWidth      =   8805
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer tmSend 
      Left            =   7920
      Top             =   3510
   End
   Begin VB.TextBox txServer 
      Height          =   330
      Left            =   7515
      TabIndex        =   4
      Top             =   1350
      Width           =   1230
   End
   Begin VB.TextBox txReceived 
      Height          =   2670
      Left            =   0
      MultiLine       =   -1  'True
      TabIndex        =   3
      Top             =   0
      Width           =   7485
   End
   Begin VB.CommandButton cmdConnect 
      Caption         =   "connect"
      Height          =   330
      Left            =   7515
      TabIndex        =   2
      Top             =   90
      Width           =   1185
   End
   Begin VB.TextBox txSend 
      Height          =   2670
      Left            =   45
      MultiLine       =   -1  'True
      TabIndex        =   1
      Top             =   2790
      Width           =   7440
   End
   Begin VB.CommandButton cmdSend 
      Caption         =   "send"
      Height          =   330
      Left            =   7515
      TabIndex        =   0
      Top             =   3015
      Width           =   1185
   End
   Begin MSWinsockLib.Winsock Winsock1 
      Left            =   8235
      Top             =   450
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
      RemotePort      =   5001
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_From As Long
Private m_TCPIPId As Long

Private Sub cmdConnect_Click()
  On Error Resume Next
  Winsock1.RemotePort = 5001
  Winsock1.RemoteHost = txServer.Text
  Winsock1.Connect
  Debug.Print Winsock1.State
End Sub

Private Sub cmdSend_Click()
  On Error Resume Next
  cmdSend.Enabled = False
  m_From = 0
  m_TCPIPId = 0
  tmSend.Interval = 100
  tmSend.Enabled = True
End Sub

Private Sub Form_Load()
  cmdSend.Enabled = False
  txServer.Text = Winsock1.LocalHostName
End Sub

Private Sub tmSend_Timer()
  On Error Resume Next
  
  tmSend.Enabled = False
  
  Dim msg As String
  
  Dim c As cTCPIPManager
  
  Set c = New cTCPIPManager
  
  msg = c.CreateMessageToSend(txSend.Text, m_From, 1, 1, SRV_ID_CHAT, m_TCPIPId)
  Winsock1.SendData msg
  
  If m_From = 0 Then
    cmdSend.Enabled = True
    Exit Sub
  End If
  
  tmSend.Enabled = True
End Sub

Private Sub Winsock1_Close()
  cmdSend.Enabled = False
End Sub

Private Sub Winsock1_Connect()
  cmdSend.Enabled = True
End Sub

Private Sub Winsock1_DataArrival(ByVal bytesTotal As Long)
  Dim Message As String
  Dim Bytes() As Byte
  Dim i As Integer
  
  Winsock1.GetData Bytes, vbArray + vbByte, bytesTotal

  Dim c As cTCPIPManager
  Set c = New cTCPIPManager
  
  c.GetMessage Bytes
  
  For i = LBound(Bytes) To UBound(Bytes)

      Message = Message & Chr(Bytes(i))

  Next i
  
  txReceived.Text = txReceived.Text & Message & vbCrLf
End Sub

Private Sub Winsock1_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
  MsgBox Number & " - " & Description & " - " & Scode & " - " & Source & " - " & HelpFile & " - " & HelpContext & " - " & CancelDisplay
End Sub
