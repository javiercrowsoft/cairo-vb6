VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMailSimpleMapi"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_AttachFiles As Collection

Public Property Get AttachFiles() As Collection
  Set AttachFiles = m_AttachFiles
End Property

Public Function SendMail(ByVal ToName As String, _
                         ByVal ToEmail As String, _
                         ByVal subject As String, _
                         ByVal body As String)

  Dim fc As fControls
  
  Set fc = New fControls

  Load fc

  With fc.MAPISession1
    .SignOn
    
    With fc.MAPIMessages1
      .SessionID = fc.MAPISession1.SessionID
      .Compose
      .RecipDisplayName = ToName
      .RecipAddress = ToEmail
      
      pResolveName fc.MAPIMessages1
      
      ' Create the message
      .MsgSubject = subject
      .MsgNoteText = body
      
      If m_AttachFiles.Count > 0 Then
    
        If .MsgNoteText = "" Then
          .MsgNoteText = String$(m_AttachFiles.Count, " ")
        End If
    
        .AttachmentType = AttachTypeConstants.mapData
        .MsgIndex = -1
        
        Dim i As Long
    
        For i = 1 To m_AttachFiles.Count
        
          ' Add attachment
          .AttachmentIndex = i - 1
          .AttachmentName = pGetFileName(m_AttachFiles.Item(i))
          .AttachmentPathName = m_AttachFiles.Item(i)
        Next
      End If
    
      ' Para que Outloock Express no chille
      '
      If .RecipDisplayName = "" Then
        .RecipDisplayName = "(Ingrese una dirección)"
      End If
      If .RecipAddress = "" Then
        .RecipAddress = "(Ingrese una dirección)"
      End If
    
      ' Send the message
      .AddressEditFieldCount = 3
      .Send True
    End With
    .SignOff
  End With
  
End Function

Private Sub pResolveName(ByRef MapiMsgs As MAPIMessages)
  On Error Resume Next
  
  With MapiMsgs
    ' Resolve recipient name
    '
    .AddressResolveUI = True
    .ResolveName
  End With
  
  Err.Clear
End Sub

Private Function pGetFileName(ByVal FullPath As String) As String
    Dim nseppos As Long
    Dim ssep    As String
    Dim rtn     As String
    Dim path    As String

    nseppos = Len(FullPath)
    
    If nseppos = 0 Then
        path = FullPath
        rtn = FullPath
        Exit Function
    End If
    ssep = Mid$(FullPath, nseppos, 1)
    Do Until ssep = "\"
        nseppos = nseppos - 1
        If nseppos = 0 Then Exit Do
        ssep = Mid$(FullPath, nseppos, 1)
    Loop

    Select Case nseppos
        Case Len(FullPath)
            'Si el separador es encontrado al final entonces, se trata de un directorio raiz ej. c:\, d:\, etc.
            path = Left$(FullPath, nseppos - 1)
            rtn = FullPath
        Case 0
            'Si el separador no es encontrado entonces, se trata de un directorio raiz ej. c:, d:, etc.
            path = FullPath
            rtn = FullPath
        Case Else
            path = Left$(FullPath, nseppos - 1)
            rtn = Mid$(FullPath, nseppos + 1)
    End Select
    
    pGetFileName = rtn
End Function


Private Sub Class_Initialize()
  On Error Resume Next
  Set m_AttachFiles = New Collection
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  Set fControls = Nothing
  Set m_AttachFiles = Nothing
  Err.Clear
End Sub
