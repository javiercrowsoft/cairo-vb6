VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6135
   ClientLeft      =   120
   ClientTop       =   420
   ClientWidth     =   11415
   LinkTopic       =   "Form1"
   ScaleHeight     =   6135
   ScaleWidth      =   11415
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdSend 
      Caption         =   "Send"
      Height          =   375
      Left            =   6480
      TabIndex        =   3
      Top             =   360
      Width           =   1815
   End
   Begin VB.TextBox txTo 
      Height          =   375
      Left            =   2160
      TabIndex        =   1
      Text            =   "javier@crowsoft.com.ar"
      Top             =   360
      Width           =   3615
   End
   Begin VB.TextBox txLog 
      Height          =   5055
      Left            =   120
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   960
      Width           =   11175
   End
   Begin VB.Label Label1 
      Caption         =   "To"
      Height          =   375
      Left            =   240
      TabIndex        =   2
      Top             =   360
      Width           =   1335
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Const cdoSendUsingPickup = 1
Const cdoSendUsingPort = 2
Const cdoSendUsingExchange = 3

Const cdoAnonymous = 0
Const cdoBasic = 1
Const cdoNTLM = 2

Private Sub cmdSend_Click()
  SendMailByCDO txTo.Text, _
                "prueba2", _
                "hola", _
                "<h1>Hola</h1>", "", "", _
                "mail.todoencartuchos.com", _
                "contacto@todoencartuchos.com", _
                "contacto@todoencartuchos.com", _
                "38mo43yus58"
End Sub

Function SendMailByCDO(ByVal aTo As String, _
                        ByVal Subject As String, _
                        ByVal TextBody As String, _
                        ByVal HTMLBody As String, _
                        ByVal BCC As String, _
                        ByVal Files As String, _
                        ByVal smtp, _
                        ByVal aFrom As String, _
                        ByVal userEmail As String, _
                        ByVal passwordEmail As String)
  On Error Resume Next

  Dim Message 'As New CDO.Message '(New - For VBA)
  
  'Create CDO message object
  Set Message = CreateObject("CDO.Message")

  'Set configuration fields.
  With Message.Configuration.Fields
    'Original sender email address
    .Item("http://schemas.microsoft.com/cdo/configuration/sendemailaddress") = aFrom

    'SMTP settings - without authentication, using standard port 25 on host smtp
    .Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = cdoSendUsingPort
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = smtp

    'SMTP Authentication
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = cdoBasic
    .Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = userEmail
    .Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = passwordEmail

    .Update
  End With

  'Set other message fields.
  With Message
    'From, To, Subject And Body are required.
    .from = aFrom
    .To = aTo
    .Subject = Subject

    'Set TextBody property If you want To send the email As plain text
    .TextBody = TextBody

    'Set HTMLBody  property If you want To send the email As an HTML formatted
    .HTMLBody = HTMLBody

    'Blind copy And attachments are optional.
    If Len(BCC) > 0 Then .BCC = BCC
    If Len(Files) > 0 Then .AddAttachment Files
    
    'Send the email
    .send
  End With

  'Returns zero If succesfull. Error code otherwise
  SendMailByCDO = Err.Number
End Function
