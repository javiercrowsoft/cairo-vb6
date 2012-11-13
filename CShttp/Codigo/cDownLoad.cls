VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDownLoad"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_inetctl                       As InetCtlsObjects.Inet
Attribute m_inetctl.VB_VarHelpID = -1

Private m_errorDescrip                  As String

Private m_Status                        As String
Private m_ProxyAddress                  As String
Private m_RemotePort                    As String
Private m_RemoteHost                    As String
Private m_DataType                      As DataTypeConstants
Private m_Protocol                      As ProtocolConstants

'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'
' m_Status:
'
'    *  URL not provided
'      This message is displayed if the correct URL is not provided or is not provided at all.
'    * Timed Out
'      This message is displayed when the time out occurs.
'    * Server not found
'      If the computer from where the file is to be downloaded is not found then this error message is displayed.
'    * File not found
'      If the file is not found on the remote computer then this message will tell the user that the file could not be found.
'    * File was downloaded successfully
'      This message is displayed if the file is successfully retrieved and downloaded to the system.
'/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get Status() As String
   Status = m_Status
End Property

Public Property Let Status(ByVal rhs As String)
   m_Status = rhs
End Property

Public Property Get ProxyAddress() As String
   ProxyAddress = m_ProxyAddress
End Property

Public Property Let ProxyAddress(ByVal rhs As String)
   m_ProxyAddress = rhs
End Property

Public Property Get RemotePort() As String
   RemotePort = m_RemotePort
End Property

Public Property Let RemotePort(ByVal rhs As String)
   m_RemotePort = rhs
End Property

Public Property Get RemoteHost() As String
   RemoteHost = m_RemoteHost
End Property

Public Property Let RemoteHost(ByVal rhs As String)
   m_RemoteHost = rhs
End Property

'///////////////////////////////////////////////////////////////////////////////////////////////////////////////
' * icString
'   Use this type if you want to download the data as a string.
' * IcByteArray
'   Use this datatype if you want to download the data as a binary.
'///////////////////////////////////////////////////////////////////////////////////////////////////////////////
Public Property Get DataType() As DataTypeConstants
   DataType = m_DataType
End Property

Public Property Let DataType(ByVal rhs As DataTypeConstants)
   m_DataType = rhs
End Property

Public Property Get Protocol() As ProtocolConstants
   Protocol = m_Protocol
End Property

Public Property Let Protocol(ByVal rhs As ProtocolConstants)
   m_Protocol = rhs
End Property

Public Property Get ErrorDescrip() As String
  ErrorDescrip = m_errorDescrip
End Property

Public Function DLoad(ByVal strURL As String, Optional ByVal sOutPutFile As String) As Boolean
  Dim bytes()   As Byte
  Dim fn        As Integer
  Dim msg       As String
  Dim buf       As String
  Dim fnf       As Integer
  Dim snf       As Integer
  Dim tout      As Integer
  Dim OK        As Integer
  Dim tempbuf   As String
  Dim strResult As String
  
  With m_inetctl
  
    'Set the transfer protocol
    .Protocol = Protocol
    
    '///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ' * icUseDefault
    '   The control uses the access settings that are specified in the
    '   Windows registry to access the Internet.
    ' * icDirect
    '   The control has a direct connection to the Internet.
    ' * icNamedProxy
    '   The control uses a proxy server. The proxy server must be
    '   specified in the control's Proxy property.
    '///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    'Set the Access Type to Default
    .AccessType = icUseDefault
    
    'Set the proxy address
    If Not ProxyAddress = "" Then
      .AccessType = icNamedProxy
      .Proxy = ProxyAddress
    End If
    
    '.UserName = "aaba\jalvarez"
    '.Password = "654321"
    
    If Not RemotePort = "" Then
      .RemotePort = RemotePort
    End If
  End With

  On Error Resume Next
  
  m_errorDescrip = ""
  
  If strURL = "" Then
    Status = "URL not provided"
    Exit Function
  End If

  With m_inetctl
  
'    If m_DataType = icByteArray Then
'      bytes() = .OpenURL(strURL, icByteArray)
'    Else
'      strResult = .OpenURL(strURL, icString)
'    End If
    
    .Execute strURL, "GET"
    
    If Err.Number Then
      m_errorDescrip = Err.Description
      Err.Clear
    End If
    ' Essential to avoid tying up the system
    Do Until .StillExecuting = False ' WAIT Downloading..
      DoEvents
    Loop
  End With

'  tempbuf = bytes()
  
  'If the URL returned any thing, put the first
  '50 characters in a buffer, Error messages
  'will be found here.
  If Len(strResult) > 50 Then
    buf = Left(strResult, 100)
  Else
    buf = bytes()
  End If
  
  'Catch a time out error
  If Err = 35761 Then
    tout = tout + 1
    Status = "Timed out: " & tout
    Err.Clear
    Exit Function
  
'    'If nothing is returned, it usually means
'    'that the server was not found.
'  ElseIf tempbuf = "" Then
'    snf = snf + 1
'    Status = "Server not found: " & snf
'    Exit Function
  
  'if nothing is returned, it usually means that
  'the server was found, but the requested file was
  'not present.
  
  ElseIf InStr(1, buf, "404") Then
    fnf = fnf + 1
    Status = "File not found: " & fnf
    Exit Function
  Else
    'Otherwise, everything is OK
    OK = OK + 1
    Status = "File was downloaded successfully: " & OK
  
  End If
  
  If Err.Number Then
    m_errorDescrip = m_errorDescrip & vbCrLf & Err.Description
    Err.Clear
  End If
  
  pSaveFile sOutPutFile
  
  If Err.Number Then m_errorDescrip = m_errorDescrip & vbCrLf & Err.Description
  
'  'Get a file number
'  fn = FreeFile
'
'  'Open a binary file and load data into it!
'  Open sOutPutFile For Binary Access Write As #fn
'  Put #fn, , bytes()
'  DoEvents
'  'Close the open file
'  Close #fn

  DLoad = True
End Function

Private Sub Class_Initialize()
  'Set m_inetctl = CreateObject("InetCtls.Inet")
  Load fInetCtrl
  Set m_inetctl = fInetCtrl.Inet1
End Sub

Private Sub Class_Terminate()
  Set m_inetctl = Nothing
  Unload fInetCtrl
End Sub

Private Sub pSaveFile(ByVal File As String)
  Dim vtData() As Byte       ' Data variable.
  Dim intFile  As Integer    ' File number variable.

  intFile = FreeFile()       ' Get free file number.
  
  ' Open a file to write to.
  Open File For Binary Access Write As #intFile

  ' Get the first chunk. NOTE: specify a byte
  ' array (icByteArray) to retrieve a binary file.
  vtData = m_inetctl.GetChunk(1024, icByteArray)

  Do While UBound(vtData) > 0
    Put #intFile, , vtData()
    ' Get next chunk.
    vtData = m_inetctl.GetChunk(1024, icByteArray)
  Loop
  Put #intFile, , vtData()
  Close #intFile

End Sub

Public Function CreateObject(ByVal Class As String) As Object
  On Error GoTo ControlError
  Set CreateObject = Interaction.CreateObject(Class)
  Exit Function
ControlError:
  Err.Raise Err.Number, Err.Source, "No se pudo crear el objeto " & Class & ".\nError Original: " & Err.Description, Err.HelpFile, Err.HelpContext
End Function

