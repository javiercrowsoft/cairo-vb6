VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCDOEmail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Const C_Module = "cCDOEmail"

Const cdoSendUsingPickup = 1
Const cdoSendUsingPort = 2
Const cdoSendUsingExchange = 3

Const cdoAnonymous = 0
Const cdoBasic = 1
Const cdoNTLM = 2

Public Function SendMailByCDO(ByVal aTo As String, _
                              ByVal Subject As String, _
                              ByVal TextBody As String, _
                              ByVal HTMLBody As String, _
                              ByVal BCC As String, _
                              ByVal Files As String, _
                              ByVal smtp, _
                              ByVal aFrom As String, _
                              ByVal userEmail As String, _
                              ByVal passwordEmail As String)
  On Error GoTo ControlError

  Dim Message 'As New CDO.Message '(New - For VBA)
  
  'MsgBox "1"
  
  'Create CDO message object
  Set Message = CreateObject("CDO.Message")

  Err.Clear

  'Set configuration fields.
  With Message.Configuration.fields
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

  MsgBox "2"

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

  'MsgBox "3"

  'Returns zero If succesfull. Error code otherwise
  SendMailByCDO = Err.Number = 0

  Exit Function
ControlError:
  MngError Err, "SendMailByCDO", C_Module, ""
End Function
