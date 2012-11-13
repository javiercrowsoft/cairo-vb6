VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_errDescrip    As String
Private m_errNumber     As String

Private m_Attachments() As String

Public Property Get ErrDescrip() As String
  ErrDescrip = m_errDescrip
End Property

Public Property Get ErrNumber() As String
  ErrNumber = m_errNumber
End Property

Public Sub ErrClear()
  m_errDescrip = ""
  m_errNumber = ""
End Sub

Public Sub ClearAttach()
  ReDim m_Attachments(0)
End Sub

Public Function AddAttach(ByVal sFullFileName As String) As Boolean
  ReDim Preserve m_Attachments(UBound(m_Attachments) + 1)
  m_Attachments(UBound(m_Attachments)) = sFullFileName
End Function

Public Function SendEmail(ByVal sTo As String, _
                          ByVal sFrom As String, _
                          ByVal sSender As String, _
                          ByVal SMTP_SERVER As String, _
                          ByVal iPort As Long, _
                          ByVal sUser As String, _
                          ByVal sPwd As String, _
                          ByVal sSubject As String, _
                          ByVal sBody As String) As Boolean
                          
  On Error GoTo Err_SendEmail
  
  Dim Cdo2Configuration As CDO.Configuration
  Dim Cdo2Message       As CDO.Message
  Dim Cdo2Fields

  ' Create a new Configuration object.
  '
  Set Cdo2Configuration = New CDO.Configuration
  
  ' Get a reference to the Configuration object's Fields collection
  '
  Set Cdo2Fields = Cdo2Configuration.Fields
  
  ' Set the Configuration object's properties through its Fields
  ' collection.
  '
  With Cdo2Fields
    .Item(cdoSMTPServer) = SMTP_SERVER
    .Item(cdoSendUsingMethod) = cdoSendUsingPort
    
    .Item(cdoSMTPServerPort) = iPort
    .Item(cdoSMTPConnectionTimeout) = 20
    .Item(cdoSMTPAuthenticate) = cdoBasic
    
    If sUser <> vbNullString Then
      .Item(cdoSendUserName) = sUser
      .Item(cdoSendPassword) = sPwd
    End If

    .Update ' Important
  End With
  DoEvents

  ' Create a new message.
  Set Cdo2Message = New CDO.Message

  ' Set the message's configuration.
  Set Cdo2Message.Configuration = Cdo2Configuration
  DoEvents

  ' Set the message content.
  Cdo2Message.Subject = sSubject
  Cdo2Message.TextBody = sBody

  ' Address the message.
  Cdo2Message.Sender = sSender
  Cdo2Message.From = sFrom
  Cdo2Message.To = sTo

  pAddAttachments Cdo2Message
  DoEvents
  
  ' Send the message.
  Cdo2Message.Send
  DoEvents

  Set Cdo2Message = Nothing
  Set Cdo2Configuration = Nothing
  Set Cdo2Fields = Nothing
  SendEmail = True
  Exit Function

Err_SendEmail:
  SendEmail = False
  m_errDescrip = Err.Description
  m_errNumber = Err.Number
End Function

Private Function pAddAttachments(ByRef MyMessage As CDO.Message) As Boolean
  Dim i     As Integer
  Dim att   As IBodyPart

  For i = 1 To UBound(m_Attachments)
    MyMessage.AddAttachment m_Attachments(i)
  Next i

  Set att = Nothing
  
  pAddAttachments = True
End Function

Private Sub Class_Initialize()
  On Error Resume Next
  ReDim m_Attachments(0)
End Sub

