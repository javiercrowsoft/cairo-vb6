VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSocket"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'********************************************************************************
'CSocket class
'Copyright © 2002 by Oleg Gdalevich
'Visual Basic Internet Programming website (http://www.vbip.com)
'********************************************************************************
'To use this class module you need:
'   MSocketSupport code module
'********************************************************************************
'Version: 1.0.12     Modified: 17-OCT-2002
'********************************************************************************
'To get latest version of this code please visit the following web page:
'http://www.vbip.com/winsock-api/csocket-class/csocket-class-01.asp
'********************************************************************************
Option Explicit
'
'Added: 23-AUG-2002
Private Declare Function PostMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
'
'The CSocket protocol's constants as for
'the MS Winsock Control interface
Public Enum ProtocolConstants
    sckTCPProtocol = 0
    sckUDPProtocol = 1
End Enum
'
'The CSocket error's constants as for
'the MS Winsock Control interface
Public Enum ErrorConstants
    sckAddressInUse = 10048
    sckAddressNotAvailable = 10049
    sckAlreadyComplete = 10037
    sckAlreadyConnected = 10056
    sckBadState = 40006
    sckConnectAborted = 10053
    sckConnectionRefused = 10061
    sckConnectionReset = 10054
    sckGetNotSupported = 394
    sckHostNotFound = 11001
    sckHostNotFoundTryAgain = 11002
    sckInProgress = 10036
    sckInvalidArg = 40014
    sckInvalidArgument = 10014
    sckInvalidOp = 40020
    sckInvalidPropertyValue = 380
    sckMsgTooBig = 10040
    sckNetReset = 10052
    sckNetworkSubsystemFailed = 10050
    sckNetworkUnreachable = 10051
    sckNoBufferSpace = 10055
    sckNoData = 11004
    sckNonRecoverableError = 11003
    sckNotConnected = 10057
    sckNotInitialized = 10093
    sckNotSocket = 10038
    sckOpCanceled = 10004
    sckOutOfMemory = 7
    sckOutOfRange = 40021
    sckPortNotSupported = 10043
    sckSetNotSupported = 383
    sckSocketShutdown = 10058
    sckSuccess = 40017
    sckTimedout = 10060
    sckUnsupported = 40018
    sckWouldBlock = 10035
    sckWrongProtocol = 40026
End Enum
'
'The CSocket state's constants as for
'the MS Winsock Control interface
Public Enum StateConstants
    sckClosed = 0
    sckOpen
    sckListening
    sckConnectionPending
    sckResolvingHost
    sckHostResolved
    sckConnecting
    sckConnected
    sckClosing
    sckError
End Enum
'
'In order to resolve a host name the MSocketSupport.ResolveHost
'function can be called from the Connect and SendData methods
'of this class. The callback acceptor for that routine is the
'PostGetHostEvent procedure. This procedure determines what to
'do next with the received host's address checking a value of
'the m_varInternalState variable.
Private Enum InternalStateConstants
    istConnecting
    istSendingDatagram
End Enum
'
Private m_varInternalState As InternalStateConstants
'
'Local (module level) variables to hold values of the
'properties of this (CSocket) class.
Private mvarProtocol        As ProtocolConstants
Private mvarState           As StateConstants
Private m_lngBytesReceived  As Long
Private m_strLocalHostName  As String
Private m_strLocalIP        As String
Private m_lngLocalPort      As Long
Private m_strRemoteHost     As String
Private m_strRemoteHostIP   As String
Private m_lngRemotePort     As Long
Private m_lngSocketHandle   As Long
'
'Resolving host names is performed in an asynchronous mode,
'the m_lngRequestID variable just holds the value returned
'by the ResolveHost function from the MSocketSupport module.
Private m_lngRequestID      As Long
'
'Internal (for this class) buffers. They are the VB Strings.
'Don't trust that guy who told that the VB String data type
'cannot properly deal with binary data. Actually, it can, and
'moreover you have a lot of means to deal with that data -
'the VB string functions (such as Left, Mid, InStr and so on).
'If you need to get a byte array from a string, just call the
'StrConv function:
'
'byteArray() = StrConv(strBuffer, vbFromUnicode)
'
Private m_strSendBuffer     As String 'The internal buffer for outgoing data
Private m_strRecvBuffer     As String 'The internal buffer for incoming data
'
'Lenght of the Winsock buffers. By default = 8192 bytes for TCP sockets.
'These values are initialized in the SocketExists function.
'Now, I really don't know why I was in need to get these values.
Private m_lngSendBufferLen  As Long
Private m_lngRecvBufferLen  As Long
'
'Maximum size of a datagram that can be sent through
'a message-oriented (UDP) socket. This value is returned
'by the InitWinsock function from the MSocketSupport module.
Private m_lngMaxMsgSize     As Long
'
'This flag variable indicates that the socket is bound to
'some local socket address
Private m_blnSocketIsBound  As Boolean  'Added: 10-MAR-2002
'
Private m_blnSendFlag As Boolean        'Added: 12-SEP-2002
'
'This flag variable indicates that the SO_BROADCAST option
'is set on the socket
Private m_blnBroadcast      As Boolean  'Added: 09-JULY-2002


Private m_UserData As Variant

'
'These are those MS Winsock's events.
'Pay attention that the "On" prefix is added.
Public Event OnClose()
Attribute OnClose.VB_Description = "Occurs when the connection has been closed"
Public Event OnConnect()
Attribute OnConnect.VB_Description = "Occurs connect operation is completed"
Public Event OnConnectionRequest(ByVal requestID As Long)
Public Event OnDataArrival(ByVal bytesTotal As Long)
Public Event OnError(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
Public Event OnSendComplete()
Public Event OnSendProgress(ByVal bytesSent As Long, ByVal bytesRemaining As Long)

Public Property Get UserData() As Variant
  If IsObject(m_UserData) Then
    Set UserData = m_UserData
  Else
    UserData = m_UserData
  End If
End Property

Public Property Let UserData(ByVal rhs As Variant)
  If IsObject(rhs) Then
    Set m_UserData = rhs
  Else
    m_UserData = rhs
  End If
End Property

Public Sub SendData(varData As Variant)
Attribute SendData.VB_Description = "Send data to remote computer"
    '
    'data to send - will be built from the varData argument
    Dim arrData()       As Byte
    'value returned by the send(sendto) Winsock API function
    Dim lngRetValue     As Long
    'length of the data to send - needed to call the send(sendto) Winsock API function
    Dim lngBufferLength As Long
    'this strucure just contains address of the remote socket to send data to;
    'only for UDP sockets when the sendto Winsock API function is used
    Dim udtSockAddr     As sockaddr_in
    '
    On Error GoTo SendData_Err_Handler
    '
    'If a connection-oriented (TCP) socket was not created or connected to the
    'remote host before calling the SendData method, the MS Winsock Control
    'raises the sckBadState error.
    If mvarProtocol = sckTCPProtocol Then
        '
        If m_lngSocketHandle = INVALID_SOCKET Then
            Err.Raise sckBadState, "CSocket.SendData", _
            "Wrong protocol or connection state for the requested transaction or request."
            Exit Sub
        End If
        '
    Else
        '
        'If the socket is a message-oriented one (UDP), this is OK to create
        'it with the call of the SendData method. The SocketExists function
        'creates a new socket.
        If Not SocketExists Then Exit Sub
        '
    End If
    '
    Select Case varType(varData)
        Case vbArray + vbByte
            'Modified 28-MAY-2002. Thanks to Michael Freidgeim
            '--------------------------------
            'Dim strArray As String
            'strArray = CStr(varData)
            arrData() = varData
            '--------------------------------
        Case vbBoolean
            Dim blnData As Boolean
            blnData = CBool(varData)
            ReDim arrData(LenB(blnData) - 1)
            CopyMemory arrData(0), blnData, LenB(blnData)
        Case vbByte
            Dim bytData As Byte
            bytData = CByte(varData)
            ReDim arrData(LenB(bytData) - 1)
            CopyMemory arrData(0), bytData, LenB(bytData)
        Case vbCurrency
            Dim curData As Currency
            curData = CCur(varData)
            ReDim arrData(LenB(curData) - 1)
            CopyMemory arrData(0), curData, LenB(curData)
        Case vbDate
            Dim datData As Date
            datData = CDate(varData)
            ReDim arrData(LenB(datData) - 1)
            CopyMemory arrData(0), datData, LenB(datData)
        Case vbDouble
            Dim dblData As Double
            dblData = CDbl(varData)
            ReDim arrData(LenB(dblData) - 1)
            CopyMemory arrData(0), dblData, LenB(dblData)
        Case vbInteger
            Dim intData As Integer
            intData = CInt(varData)
            ReDim arrData(LenB(intData) - 1)
            CopyMemory arrData(0), intData, LenB(intData)
        Case vbLong
            Dim lngData As Long
            lngData = CLng(varData)
            ReDim arrData(LenB(lngData) - 1)
            CopyMemory arrData(0), lngData, LenB(lngData)
        Case vbSingle
            Dim sngData As Single
            sngData = CSng(varData)
            ReDim arrData(LenB(sngData) - 1)
            CopyMemory arrData(0), sngData, LenB(sngData)
        Case vbString
            Dim strData As String
            strData = CStr(varData)
            ReDim arrData(Len(strData) - 1)
            arrData() = StrConv(strData, vbFromUnicode)
        Case Else
            '
            'Unknown data type
            '
    End Select
    '
    'Store all the data to send in the module level
    'variable m_strSendBuffer.
    m_strSendBuffer = StrConv(arrData(), vbUnicode)
    '
    'Call the SendBufferedData subroutine in order to send the data.
    'The SendBufferedData sub is just a common procedure that is
    'called from different places in this class.
    'Nothing special - just the code reuse.
    m_blnSendFlag = True
    Call SendBufferedData
    '
EXIT_LABEL:
    '
    Exit Sub
    '
SendData_Err_Handler:
    '
    If Err.LastDllError = WSAENOTSOCK Then
        Err.Raise sckBadState, "CSocket.SendData", "Wrong protocol or connection state for the requested transaction or request."
    Else
        Err.Raise Err.Number, "CSocket.SendData", Err.Description
    End If
    '
    GoTo EXIT_LABEL
    '
End Sub


Public Sub PeekData(varData As Variant, Optional varType As Variant, Optional maxLen As Variant)
Attribute PeekData.VB_Description = "Look at incoming data without removing it from the buffer"
    '
    Dim lngBytesReceived As Long    'value returned by the RecvData function
    '
    On Error GoTo PeekData_Err_Handler
    '
    'The RecvData is a universal subroutine that can either to retrieve or peek
    'data from the Winsock buffer. If a value of the second argument (blnPeek As Boolean)
    'of the RecvData subroutine is True, it will be just peeking.
    lngBytesReceived = RecvData(varData, True, IIf(IsMissing(varType), Empty, varType), _
                                IIf(IsMissing(maxLen), Empty, maxLen))
    '
EXIT_LABEL:
    '
    Exit Sub
    '
PeekData_Err_Handler:
    '
    Err.Raise Err.Number, "CSocket.PeekData", Err.Description
    '
    GoTo EXIT_LABEL
    '
End Sub


Public Sub Listen()
Attribute Listen.VB_Description = "Listen for incoming connection requests"
    '
    Dim lngRetValue As Long 'value returned by the listen Winsock API function
    '
    On Error GoTo Listen_Err_Handler
    '
    'SocketExists is not a variable. It is a function that can
    'create a socket, if the class has no one.
    If Not SocketExists Then Exit Sub
    '
    'The listen Winsock API function cannot be called
    'without the call of the bind one.
    If Not m_blnSocketIsBound Then  'Added: 10-MAR-2002
        Call Bind
    End If                          'Added: 10-MAR-2002
    '
    'Turn the socket into a listening state
    lngRetValue = api_listen(m_lngSocketHandle, 5&)
    '
    If lngRetValue = SOCKET_ERROR Then
        mvarState = sckError
        'Debug.Print "mvarState = sckError"
        Err.Raise Err.LastDllError, "CSocket.Listen", GetErrorDescription(Err.LastDllError)
    Else
        mvarState = sckListening
        'Debug.Print "Listen: mvarState = sckListening"
    End If
    '
EXIT_LABEL:
    '
    Exit Sub
    '
Listen_Err_Handler:
    '
    Err.Raise Err.Number, "CSocket.Listen", Err.Description
    '
    GoTo EXIT_LABEL
    '
End Sub


Public Sub GetData(varData As Variant, Optional varType As Variant, Optional maxLen As Variant)
Attribute GetData.VB_Description = "Retrieve data sent by the remote computer"
    '
    Dim lngBytesReceived As Long    'value returned by the RecvData function
    '
    On Error GoTo GetData_Err_Handler
    '
    'A value of the second argument of the RecvData subroutine is False, so in this way
    'this procedure will retrieve incoming data from the buffer.
    lngBytesReceived = RecvData(varData, False, IIf(IsMissing(varType), Empty, varType), _
                                IIf(IsMissing(maxLen), Empty, maxLen))
    '
EXIT_LABEL:
    '
    Exit Sub
    '
GetData_Err_Handler:
    '
    Err.Raise Err.Number, "CSocket.GetData", Err.Description
    '
    GoTo EXIT_LABEL
    '
End Sub


Public Sub Connect(Optional strRemoteHost As Variant, Optional lngRemotePort As Variant)
Attribute Connect.VB_Description = "Connect to the remote computer"
    '
    Dim lngHostAddress  As Long         '32 bit host address
    Dim udtAddress      As sockaddr_in  'socket address - used by the connect Winsock API function
    Dim lngRetValue     As Long         'value returned by the connect Winsock API function
    '
    On Error GoTo Connect_Err_Handler
    '
    'If no socket has been created before, try to create a new one
    If Not SocketExists Then Exit Sub
    '
    'If the arguments of this function are not missing, they
    'overwrite values of the RemoteHost and RemotePort properties.
    '
    If Not IsMissing(strRemoteHost) Then    'Added: 04-MAR-2002
        If Len(strRemoteHost) > 0 Then
            m_strRemoteHost = CStr(strRemoteHost)
        End If
    End If                                  'Added: 04-MAR-2002
    '
    If Not IsMissing(lngRemotePort) Then    'Added: 04-MAR-2002
        If IsNumeric(lngRemotePort) Then    'Added: 04-MAR-2002
            m_lngRemotePort = CLng(lngRemotePort)
        End If                              'Added: 04-MAR-2002
    End If                                  'Added: 04-MAR-2002
    '
    '----------------------------------------------------------
    'Added: 31-JUL-2002
    '----------------------------------------------------------
    If Len(m_strRemoteHost) = 0 Then
        Err.Raise sckAddressNotAvailable, "CSocket.Connect", GetErrorDescription(sckAddressNotAvailable)
        Exit Sub
    End If
    '----------------------------------------------------------
    '
    m_varInternalState = istConnecting
    '
    '------------------------------------------------------------------
    'Modified: 08-JULY-2002
    '------------------------------------------------------------------
    'Here is a major change. Since version 1.0.6 (08-JULY-2002) the
    'SCocket class doesn't try to resolve the IP address into a
    'domain name while connecting.
    '------------------------------------------------------------------
    '
    'Try to get 32 bit host address from the RemoteHost property value
    lngHostAddress = inet_addr(m_strRemoteHost)
    '
    If lngHostAddress = INADDR_NONE Then
        '
        'The RemoteHost property doesn't contain a valid IP address string,
        'so that is perhaps a domain name string that we need to resolve
        'into IP address
        '
        'The ResolveHost function, that can be found in the MSocketSupport
        'module, will call the WSAAsyncGetHostByName Winsock API function.
        'That function is an asynchronous one, so code in this class will be executing
        'after the call to the PostGetHostEvent procedure from the WindowProc function
        'in the MSupportSocket.
        '
        'Also, as you can see, the second argument is a pointer to the object, that is
        'this instance of the CSocket class. We need this because the callback function
        'has to know to which object send the received host infromation. See the code
        'in the MSocketSupport module for more information.
        '
        'Change the State property value
        mvarState = sckResolvingHost
        'Debug.Print "mvarState = sckResolvingHost"
        '
        m_lngRequestID = 0
        m_lngRequestID = mSocketSupport.ResolveHost(m_strRemoteHost, ObjPtr(Me))
        '
        '-------------------------------------------------------
        'Added: 04-JUNE-2002
        '-------------------------------------------------------
        If m_lngRequestID = 0 Then
            Call DestroySocket
            Err.Raise Err.Number, Err.Source, Err.Description
        End If
        '-------------------------------------------------------
        '
    Else
        '
        'The RemoteHost property contains a valid IP address string,
        'so we can go on connecting to the remote host.
        '
        'Build the sockaddr_in structure to pass it to the connect
        'Winsock API function as an address of the remote host.
        With udtAddress
            '
            .sin_addr = lngHostAddress
            .sin_family = AF_INET
            .sin_port = htons(UnsignedToInteger(CLng(m_lngRemotePort)))
            '
        End With
        '
        'Call the connect Winsock API function in order to establish connection.
        lngRetValue = api_connect(m_lngSocketHandle, udtAddress, Len(udtAddress))
        '
        'Since the socket we use is a non-blocking one, the connect Winsock API
        'function should return a value of SOCKET_ERROR anyway.
        '
        If lngRetValue = SOCKET_ERROR Then
            '
            'The WSAEWOULDBLOCK error is OK for such a socket
            '
            If Not Err.LastDllError = WSAEWOULDBLOCK Then
                Err.Raise Err.LastDllError, "CSocket.Connect", GetErrorDescription(Err.LastDllError)
            Else
                'Change the State property value
                mvarState = sckConnecting
                'Debug.Print "mvarState = sckConnecting"
            End If
            '
        End If
        '
    End If
    '
EXIT_LABEL:
    '
    Exit Sub
    '
Connect_Err_Handler:
    '
    Err.Raise Err.Number, "CSocket.CSocket.Connect", Err.Description
    '
    GoTo EXIT_LABEL
    '
End Sub

Public Sub CloseSocket()
Attribute CloseSocket.VB_Description = "Close current connection"
    '
    Dim lngRetValue As Long 'value returned by the shutdown Winsock API function
    '
    On Error GoTo Close_Err_Handler
    '
    'Why do we need to run the code that should not be running?
    If m_lngSocketHandle = INVALID_SOCKET Then Exit Sub
    '
    If Not mvarState = sckConnected Then
        '
        'If the socket is not connected we can just close it
        Call DestroySocket
        mvarState = sckClosed
        'Debug.Print "mvarState = sckClosed"
        '
    Else
        '
        'If the socket is connected, it's another story.
        'In order to be sure that no data will be lost the
        'graceful shutdown of the socket should be performed.
        '
        mvarState = sckClosing
        'Debug.Print "mvarState = sckClosing"
        '
        'Call the shutdown Winsock API function in order to
        'close the connection. That doesn't mean that the
        'connection will be closed after the call of the
        'shutdown function. Connection will be closed from
        'the PostSocketEvent subroutine when the FD_CLOSE
        'message will be received.
        '
        'For people who know what the FIN segment in the
        'TCP header is - this function sends an empty packet
        'with the FIN bit turned on.
        '
        lngRetValue = shutdown(m_lngSocketHandle, SD_SEND)
        '
        'Debug.Print m_lngSocketHandle & ": shutdown"
        '
        If lngRetValue = SOCKET_ERROR Then
            Err.Raise Err.LastDllError, "CSocket.CloseSocket", GetErrorDescription(Err.LastDllError)
        End If
        '
    End If

EXIT_LABEL:
    '
    Exit Sub
    '
Close_Err_Handler:
    '
    If Err.Number <> 10038 Then
        'Err.Raise Err.Number, "CSocket.Close", Err.Description
    End If
    '
    GoTo EXIT_LABEL
    '
End Sub

Public Sub Bind(Optional lngLocalPort As Long, Optional strLocalIP As String)
Attribute Bind.VB_Description = "Binds socket to specific port and adapter"
    '
    Dim lngRetValue     As Long         'value returned by the bind Winsock API function
    Dim udtLocalAddr    As sockaddr_in  'local socket address to bind to - used by the
    '                                    bind Winsock API function
    Dim lngAddress      As Long         '32-bit host address - value returned by
    '                                    the inet_addr Winsock API function
    '
    On Error GoTo Bind_Err_Handler
    '
    'If no socket has been created before, try to create a new one
    If Not SocketExists Then Exit Sub
    '
    'If the arguments of this function are not missing, they
    'overwrites values of the RemoteHost and RemotePort properties.
    '
    If Len(strLocalIP) > 0 Then
        m_strLocalIP = strLocalIP
    End If
    '
    If lngLocalPort > 0 Then
        m_lngLocalPort = lngLocalPort
    End If
    '
    If Len(m_strLocalIP) > 0 Then
        '
        'If the local IP is known, get the address
        'from it with the inet_addr Winsock API function.
        lngAddress = inet_addr(m_strLocalIP)
        '
    Else
        '
        'If the IP is unknown, assign the default interface's IP.
        'Actually, this line is useless in Visual Basic code,
        'as INADDR_ANY = 0 (IP = 0.0.0.0).
        lngAddress = INADDR_ANY
        '
    End If
    '
    If lngAddress = SOCKET_ERROR Then
        '
        'Bad address - go away
        Err.Raise Err.LastDllError, "CSocket.Bind", GetErrorDescription(Err.LastDllError)
        Exit Sub
        '
    End If
    '
    'Prepare the udtLocalAddr UDT that is a socket address structure.
    With udtLocalAddr
        '
        'host address (32-bits value)
        .sin_addr = lngAddress
        'address family
        .sin_family = AF_INET
        'port number in the network byte order
        .sin_port = htons(UnsignedToInteger(m_lngLocalPort))    'Modified: 04-JUNE-2002
        '
    End With
    '
    'Call the bind Winsock API function in order to assign local address for the socket
    lngRetValue = api_bind(m_lngSocketHandle, udtLocalAddr, Len(udtLocalAddr))
    '
    If lngRetValue = SOCKET_ERROR Then
        '
        Err.Raise Err.LastDllError, "CSocket.Bind", GetErrorDescription(Err.LastDllError)
        '
    Else
        '
        m_blnSocketIsBound = True   'Added: 10-MAR-2002
        '
    End If
    '
EXIT_LABEL:
    '
    Exit Sub
    '
Bind_Err_Handler:
    '
    Err.Raise Err.Number, "CSocket.Bind", Err.Description
    '
    GoTo EXIT_LABEL
    '
End Sub


Public Sub Accept(requestID As Long)
Attribute Accept.VB_Description = "Accept an incoming connection request"
    '
    'The requestID argument is provided with the ConnectRequest
    'event of another instance of the CSocket class. Actually,
    'this argument is a handle of the socket already created
    'calling the Accept Winsock API function by that (another)
    'instance of the CSocket class.
    '
    Dim lngRetValue As Long         'value returned by the getsockname, getpeername, and
    '                                getsockopt Winsock API functions
    Dim lngBuffer   As Long         'the buffer to pass with the getsockopt Winsock API function
    Dim udtSockAddr As sockaddr_in  'socket address - used by the getsockname and getpeername
    '                                Winsock API functions
    Dim udtHostent  As HOSTENT      'structure to hold the host info - returned by the
    '                                getsockname and getpeername Winsock API functions
    '
    On Error GoTo Accept_Err_Handler
    '
    'What we need to do in the body of this subroutine is to
    'initialize the properties of the class that we can find
    'values for. Also we need to register the socket with
    'the RegisterSocket function from MSocketSupport module.
    '
    'Assign the socket handle
    m_lngSocketHandle = requestID
    '
    'Retrieve the connection end-points to initialize
    'the following properties of the CSocket class:
    'LocalPort, LocalIP, LocalHostName
    'RemotePort, RemoteHostIP, RemoteHost
    '
    'Local end point
    '
    lngRetValue = getsockname(m_lngSocketHandle, udtSockAddr, Len(udtSockAddr))
    '
    If lngRetValue = 0 Then
        '
        'LocalPort property
        m_lngLocalPort = IntegerToUnsigned(ntohs(udtSockAddr.sin_port))
        'LocalIP property
        m_strLocalIP = StringFromPointer(inet_ntoa(udtSockAddr.sin_addr))
        'LocalHostName property
        '----------------------------------------------------------------
        'Modified: 31-JUL-2002
        '----------------------------------------------------------------
        'lngRetValue = gethostbyaddr(udtSockAddr.sin_addr, 4&, AF_INET)
        'CopyMemory udtHostent, ByVal lngRetValue, Len(udtHostent)
        'm_strLocalHostName = StringFromPointer(udtHostent.hName)
        m_strLocalHostName = m_strLocalIP
        '----------------------------------------------------------------
        '
    End If
    '
    'Remote end point
    '
    lngRetValue = getpeername(m_lngSocketHandle, udtSockAddr, Len(udtSockAddr))
    '
    If lngRetValue = 0 Then
        '
        'RemotePort property
        m_lngRemotePort = IntegerToUnsigned(ntohs(udtSockAddr.sin_port))
        'RemoteHostIP property
        m_strRemoteHostIP = StringFromPointer(inet_ntoa(udtSockAddr.sin_addr))
        'RemoteHost property
        '----------------------------------------------------------------
        'Modified: 31-JUL-2002
        '----------------------------------------------------------------
        'lngRetValue = gethostbyaddr(udtSockAddr.sin_addr, 4&, AF_INET)
        'CopyMemory udtHostent, ByVal lngRetValue, Len(udtHostent)
        'm_strRemoteHost = StringFromPointer(udtHostent.hName)
        m_strRemoteHost = m_strRemoteHostIP
        '----------------------------------------------------------------
        '
    End If
    '
    'Retrieve the socket type to initialize the Protocol property
    lngRetValue = getsockopt(m_lngSocketHandle, SOL_SOCKET, SO_TYPE, lngBuffer, LenB(lngBuffer))
    '
    If lngRetValue <> SOCKET_ERROR Then
        '
        If lngBuffer = SOCK_STREAM Then
            mvarProtocol = sckTCPProtocol
        Else
            mvarProtocol = sckUDPProtocol
        End If
        '
    End If
    '
    'Get default size of the Winsock's buffers.
    Call GetWinsockBuffers  'Added: 10-MAR-2002
    '
    If mSocketSupport.RegisterSocket(m_lngSocketHandle, ObjPtr(Me)) Then
        '
        'Change the State property value
        mvarState = sckConnected
        'Debug.Print "Accept: mvarState = sckConnected"
        '
    End If
    '
EXIT_LABEL:
    '
    Exit Sub
    '
Accept_Err_Handler:
    '
    Err.Raise Err.Number, "CSocket.Accept", Err.Description
    '
    GoTo EXIT_LABEL
    '
End Sub

Public Property Get State() As StateConstants
    State = mvarState
End Property

Public Property Get SocketHandle() As Long
Attribute SocketHandle.VB_Description = " Returns the socket handle"
    SocketHandle = m_lngSocketHandle
End Property

Public Property Get RemotePort() As Long
Attribute RemotePort.VB_Description = "Returns/Sets the port to be connected to on the remote computer"
    RemotePort = m_lngRemotePort
End Property

Public Property Let RemotePort(NewValue As Long)
    m_lngRemotePort = NewValue
End Property

Public Property Get RemoteHostIP() As String
Attribute RemoteHostIP.VB_Description = "Returns the remote host IP address"
    RemoteHostIP = m_strRemoteHostIP
End Property

Public Property Get RemoteHost() As String
Attribute RemoteHost.VB_Description = "Returns/Sets the name used to identify the remote computer"
    RemoteHost = m_strRemoteHost
End Property

Public Property Let RemoteHost(NewValue As String)
    '
    Dim lngHostAddress As Long '32 bit host address
    Dim lngRetValue    As Long 'value returned by the setsockopt function
    '
    m_strRemoteHost = NewValue
    '
    If Len(NewValue) > 0 Then
        '
        'Check for a valid IP address string
        '
        lngHostAddress = inet_addr(NewValue)
        '
        If Not lngHostAddress = INADDR_NONE Then
            '
            m_strRemoteHostIP = NewValue
            '
            If Not mvarProtocol = sckUDPProtocol Then Exit Property
            If Not SocketExists Then Exit Property
            '
            'If the IP address is a brodcasting one set the option
            '
            If Right(NewValue, 4) = ".255" And m_blnBroadcast = False Then
                '
                lngRetValue = setsockopt(m_lngSocketHandle, SOL_SOCKET, SO_BROADCAST, 1&, 4&)
                '
                If lngRetValue = SOCKET_ERROR Then
                    '
                    With Err
                        .Raise .LastDllError, "CSocket.RemoteHost", GetErrorDescription(.LastDllError)
                    End With
                    '
                Else
                    '
                    m_blnBroadcast = True
                    '
                End If
                '
            ElseIf (Not (Right(NewValue, 4) = ".255")) And (m_blnBroadcast = True) Then
                '
                lngRetValue = setsockopt(m_lngSocketHandle, SOL_SOCKET, SO_BROADCAST, 0&, 4&)
                '
                If lngRetValue = SOCKET_ERROR Then
                    '
                    With Err
                        .Raise .LastDllError, "CSocket.RemoteHost", GetErrorDescription(.LastDllError)
                    End With
                    '
                Else
                    '
                    m_blnBroadcast = False
                    '
                End If
                '
            End If
            '
        End If
        '
    End If
    '
End Property

Public Property Get Protocol() As ProtocolConstants
Attribute Protocol.VB_Description = "Returns/Sets the socket protocol"
    Protocol = mvarProtocol
End Property

Public Property Let Protocol(NewValue As ProtocolConstants)
    '
    If m_lngSocketHandle = INVALID_SOCKET Then  'Modified: 10-MAR-2002
        mvarProtocol = NewValue
    End If
    '
End Property

Public Property Get LocalPort() As Long
Attribute LocalPort.VB_Description = "Returns/Sets the port used on the local computer"
    LocalPort = m_lngLocalPort
End Property

Public Property Let LocalPort(NewValue As Long)
    m_lngLocalPort = NewValue
End Property

Public Property Get LocalIP() As String
Attribute LocalIP.VB_Description = "Returns the local machine IP address"
    LocalIP = m_strLocalIP
End Property

Public Property Get LocalHostName() As String
Attribute LocalHostName.VB_Description = "Returns the local machine name"
    LocalHostName = m_strLocalHostName
End Property

Public Property Get BytesReceived() As Long
Attribute BytesReceived.VB_Description = "Returns the number of bytes received on this connection"
    BytesReceived = m_lngBytesReceived
End Property

Private Sub Class_Initialize()
    '
    'Socket's handle default value
    m_lngSocketHandle = INVALID_SOCKET
    'Initialize the Winsock service
    m_lngMaxMsgSize = mSocketSupport.InitWinsockService
    '
End Sub

Public Function vbSocket() As Long
'********************************************************************************
'Author    :Oleg Gdalevich
'Purpose   :Creates a new socket
'Returns   :The socket handle if successful, otherwise - INVALID_SOCKET
'Arguments :
'********************************************************************************
    '
    On Error GoTo vbSocket_Err_Handler
    '
    Dim lngRetValue     As Long 'value returned by the socket API function
    '
    'Call the socket Winsock API function in order to create a new socket
    If mvarProtocol = sckUDPProtocol Then
        lngRetValue = api_socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
    Else
        lngRetValue = api_socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
    End If
    '
    If lngRetValue = INVALID_SOCKET Then
        '
        Err.Raise Err.LastDllError, "CSocket.vbSocket", GetErrorDescription(Err.LastDllError)
        '
    Else
        '
        'Debug.Print lngRetValue & ": socket created"
        '
        If Not mSocketSupport.RegisterSocket(lngRetValue, ObjPtr(Me)) Then  'Modified: 04-JUNE-2002
            '--------------------------------------------------
            'Added: 04-JUNE-2002
            '--------------------------------------------------
            lngRetValue = INVALID_SOCKET
            Call api_closesocket(lngRetValue)
            Err.Raise Err.Number, Err.Source, Err.Description
            '--------------------------------------------------
            '
        End If
        '
    End If
    '
    'Assign returned value
    vbSocket = lngRetValue
    '
EXIT_LABEL:
    Exit Function

vbSocket_Err_Handler:
    '
    vbSocket = INVALID_SOCKET
    '
End Function

Friend Sub PostSocketEvent(ByVal lngEventID As Long, Optional ByVal lngError As Long)
    '
    'This procedure is called by the WindowProc callback function
    'from the MSocketSupport module. The lngEventID argument is an
    'ID of the network event occurred for the socket. The lngError
    'argument contains an error code only if an error was occurred
    'during an asynchronous execution.
    '
    Dim lngBytesReceived    As Long         'value returned by the RecvDataToBuffer function
    Dim lngRetValue         As Long         'value returned by the getsockname Winsock API function
    Dim lngNewSocket        As Long         'value returned by the accept Winsock API function
    Dim udtSockAddr         As sockaddr_in  'remote socket address for the accept Winscok API function
    Dim udtHostent          As HOSTENT      'structure to hold the host info - returned
    '                                        by the gethostbyaddr Winsock API function
    '
    On Error GoTo ERROR_HANDLER
    '
    If lngError > 0 Then
        '
        'An error was occurred.
        '
        'Change a value of the State property
        mvarState = sckError
        'Debug.Print "mvarState = sckError"
        'Close the socket
        Call DestroySocket
        'The OnError event is just for this case
        RaiseEvent OnError(CInt(lngError), GetErrorDescription(lngError), 0, "", "", 0, False)
        'We have nothing to do here anymore
        Exit Sub
        '
    End If
    '
    Select Case lngEventID
        '
        Case FD_READ
            '
            'Debug.Print "FD_READ"
            '
            'Some data has arrived for this socket.
            'Call the RecvDataToBuffer function that move arrived data
            'from the Winsock buffer to the local one and returns number
            'of bytes received.
            lngBytesReceived = RecvDataToBuffer
            '
            'Debug.Print "Bytes received: " & lngBytesReceived
            '
            'The BytesReceived property contains number of bytes in
            'the local buffer of the class.
            m_lngBytesReceived = m_lngBytesReceived + lngBytesReceived
            '
            'The OnDataArrival event is just for the case when some data
            'was retieved from the Winsock buffer.
            If lngBytesReceived > 0 Then
                RaiseEvent OnDataArrival(Len(m_strRecvBuffer))
            End If
            '
        Case FD_WRITE
            '
            'This message means that the socket in a write-able
            'state, that is, buffer for outgoing data of the transport
            'service is empty and ready to receive data to send through
            'the network.
            '
            'Debug.Print "FD_WRITE"
            '
            'If the local buffer for outgoing data (m_strSendBuffer) is
            'not empty, the previous call of the send/sendto Winsock API
            'function was failed. Call the SendBufferedData procedure in
            'oreder to try to send that data again.
            If Len(m_strSendBuffer) > 0 Then
                '
                Call SendBufferedData
            Else
                '
                If m_blnSendFlag Then           'Added: 12-SEP-2002
                    m_blnSendFlag = False       'Added: 12-SEP-2002
                    RaiseEvent OnSendComplete   'Added: 23-AUG-2002
                End If
                '
            End If
            '
        Case FD_OOB
            '
            'Ignored.
            '
        Case FD_ACCEPT
            '
            'When the socket is in a listening state, arrival of this message
            'means that a connection request was received. Call the accept
            'Winsock API function in oreder to create a new socket for the
            'requested connection.
            lngNewSocket = api_accept(m_lngSocketHandle, udtSockAddr, Len(udtSockAddr))
            '
            'Debug.Print lngNewSocket & ": created"
            '
            'Let the client application know that the request was received
            'and pass with the event argument a handle of the recently created
            'socket. The client application should create a new instance of
            'the CSocket class, and then use the socket handle (lngNewSocket)
            'to initialize its properties. Another way is to do not create
            'one more instance of this class. We may close existing socket,
            'and then accept the new handle:
            '
            '  Private Sub objSocket_OnConnectionRequest(ByVal requestID As Long)
            '      If objSocket.State <> sckClosed Then objSocket.CloseSocket
            '      objSocket.Accept (requestID)
            '  End Sub
            '
            RaiseEvent OnConnectionRequest(lngNewSocket)
            '
        Case FD_CONNECT
            '
            'Arrival of this message means that the connection initiated by the call
            'of the connect Winsock API function was successfully established.
            '
            'Get the connection local end-point parameters
            '
            lngRetValue = getsockname(m_lngSocketHandle, udtSockAddr, LenB(udtSockAddr))
            '
            If lngRetValue = 0 Then
                '
                'LocalPort property
                m_lngLocalPort = IntegerToUnsigned(ntohs(udtSockAddr.sin_port))
                'LocalIP property
                m_strLocalIP = StringFromPointer(inet_ntoa(udtSockAddr.sin_addr))
                'LocalHostName property
                lngRetValue = gethostbyaddr(udtSockAddr.sin_addr, 4&, AF_INET)
                '---------------------------------------------------------------
                'Modified: 31-JUL-2002
                '---------------------------------------------------------------
                If lngRetValue <> 0 Then
                    CopyMemory udtHostent, ByVal lngRetValue, Len(udtHostent)
                    m_strLocalHostName = StringFromPointer(udtHostent.hName)
                Else
                    m_strLocalHostName = m_strLocalIP
                End If
                '---------------------------------------------------------------
                '
            End If
            '
            ' -- Modified: 04-MAR-2002 --
            '
            'Change a value of the State property
            mvarState = sckConnected
            '
            'Let the client app know that the connection was established.
            RaiseEvent OnConnect
            '
            ' -- --------------------- --
            '
            'Debug.Print "mvarState = sckConnected"
            '
        Case FD_CLOSE
            '
            'This message means that the remote host is closing the conection
            '
            '-------------------------------------------------------------------
            'Modified: 20-AUG-2002
            'Thanks to mreggio and other vbip.com Forum members.
            '-------------------------------------------------------------------
            Do
                '
                lngBytesReceived = RecvDataToBuffer
                '
                If lngBytesReceived > 0 Then
                    RaiseEvent OnDataArrival(Len(m_strRecvBuffer))
                End If
                '
            Loop Until lngBytesReceived = 0 Or lngBytesReceived = SOCKET_ERROR
            '
            If mvarState = sckClosing Then
                '
                '---------------
                'Don't even read this as it doesn't work on a very-very
                'fast connection, for example: localhost<->localhost :).
                'The Do..Loop was moved up, now you can see it above the
                '"If mvarState = sckClosing Then" statement
                '-----------------
                '
                'If a value of the State property already is sckClosing,
                'the closing of the connection was initiated by the local
                'end-point (this socket) of the connection. In other words,
                'the shutdown Winsock API function has been called before
                '(the FIN segment is already sent by the local end-point).
                '
                'In this case we need wait until all the data sent by the
                'remote end-point of the connection will be received.
                '
                'Do
                '    '
                '    lngBytesReceived = RecvDataToBuffer
                '    '
                '    If lngBytesReceived > 0 Then
                '        RaiseEvent OnDataArrival(Len(m_strRecvBuffer))
                '    End If
                '    '
                'Loop Until lngBytesReceived = 0 Or lngBytesReceived = SOCKET_ERROR
                '
            '-------------------------------------------------------------------
            Else
                '
                mvarState = sckClosing
                'Debug.Print "mvarState = sckClosing"
                '
                'If a value of the State property is not sckClosing, the
                'connectoin is closing by the remote end-point of the
                'connection (the FIN segment is sent by the remote host).
                'In this case we need send all the remained data from the
                'local buffer before to close the socket.
                If Len(m_strSendBuffer) > 0 Then
                    '
                    Call SendBufferedData
                    '
                End If
                '
            End If
            '
            'Close the socket
            Call DestroySocket
            '
            'Change a value of the State property
            mvarState = sckClosed
            'Debug.Print "mvarState = sckClosed"
            '
            'Let the client app know that the connection is closed
            RaiseEvent OnClose
            '
    End Select
    '
    Exit Sub
    '
ERROR_HANDLER:
    '
    Err.Raise Err.Number, "CSocket.PostSocketEvent", Err.Description    'Modified: 15-APR-2002
    '
End Sub

Friend Sub PostGetHostEvent(ByVal lngRequestID As Long, ByVal lngHostAddress As Long, strHostName As String, Optional lngError As Long)
    '
    'This procedure is called by the WindowProc callback function
    'from the MSocketSupport module. Think about it as about result
    'returned by the ResolveHost function called from this class.
    '
    Dim udtAddress      As sockaddr_in  'socket address - used by the connect Winsock API function
    Dim lngRetValue     As Long         'value returned by the connect Winsock API function
    Dim lngPtrToAddress As Long         'pointer to the string that contains IP address - value
                                        'returned by the inet_ntoa Winsock API function
    '
    On Error GoTo ERROR_HANDLER
    '
    If lngError > 0 Then
        '
        'An error was occerred during resolving the host hame.
        'For example: "Host not found"
        '
        '----------------------------------------------------------------
        'Added: 28-APR-2002
        'There is the case when a computer has a valid IP address
        'but its name cannot be resolved. In this case the code should
        'countinue the execution - we just don't need to change the
        'RemoteHost property value.
        '----------------------------------------------------------------
        '
        'Does the strHostName argument contain a valid IP address?
        lngHostAddress = inet_addr(strHostName)
        '
        If lngHostAddress = INADDR_NONE Then    'Added: 28-APR-2002
            '
            'Change a value of the State property
            mvarState = sckError
            'Debug.Print "mvarState = sckError"
            '
            'Let the client app know that an error was occurred.
            RaiseEvent OnError(CInt(lngError), GetErrorDescription(lngError), 0, "", "", 0, False)
            '
            Exit Sub
            '
        Else    'Added: 28-APR-2002
            '
            'Nothing to do here
            'Both properties the RemoteHost and RemoteHostIP
            'have the same value of the IP address string.
            '
        End If  'Added: 28-APR-2002
        '
    End If
    '
    'Check the id value - Do we really need this?
    If lngRequestID = 0 Then Exit Sub
    '
    If lngRequestID = m_lngRequestID Then
        '
        'Change a value of the State property
        mvarState = sckHostResolved
        'Debug.Print "mvarState = sckHostResolved"
        '
        'Initialize the RemoteHost property
        m_strRemoteHost = strHostName
        '
        'Get pointer to the string that contains the IP address
        lngPtrToAddress = inet_ntoa(lngHostAddress)
        '
        'Retrieve that string by the pointer and init the
        'RemoteHostIP property.
        m_strRemoteHostIP = StringFromPointer(lngPtrToAddress)
        '
        'The ResolveHost function may be called from two methods
        'of the class: Connect and SendData. The m_varInternalState
        'variable tells us where the ResolveHost function called
        'from, and thus what to do here.
        '
        If m_varInternalState = istConnecting Then
            '
            'The ResolveHost was called from the Connect method, so
            'we need to continue the process of the connection establishing.
            '
            'Build the sockaddr_in structure to pass it to the connect
            'Winsock API function as an address of the remote host.
            With udtAddress
                '
                .sin_addr = lngHostAddress
                .sin_family = AF_INET
                .sin_port = htons(UnsignedToInteger(CLng(m_lngRemotePort)))
                '
            End With
            '
            'Call the connect Winsock API function in order to establish connection.
            lngRetValue = api_connect(m_lngSocketHandle, udtAddress, Len(udtAddress))
            '
            'Since the socket we use is a non-blocking one, the connect Winsock API
            'function should return a value of SOCKET_ERROR anyway.
            '
            If lngRetValue = SOCKET_ERROR Then
                '
                'The WSAEWOULDBLOCK error is OK for such a socket
                '
                If Not Err.LastDllError = WSAEWOULDBLOCK Then
                    'Modified: 31-JUL-2002
                    RaiseEvent OnError(Err.LastDllError, GetErrorDescription(Err.LastDllError), 0&, "CSocket.PostGetHostEvent", "", 0&, False)
                Else
                    'Change the State property value
                    mvarState = sckConnecting
                    'Debug.Print "mvarState = sckConnecting"
                End If
                '
            End If
            '
        ElseIf m_varInternalState = istSendingDatagram Then
            '
            'The ResolveHost was called from the SendData method in
            'the case when a message-oriented (UDP) socket is used.
            '
            Call SendBufferedData
            '
        End If
        '
    End If
    '
    Exit Sub
    '
ERROR_HANDLER:
    '
    Err.Raise Err.Number, "CSocket.PostGetHostEvent", Err.Description
    '
End Sub

Private Function SocketExists() As Boolean
    '
    If m_lngSocketHandle = INVALID_SOCKET Then
        '
        'If the m_lngSocketHandle is not a valid value, call
        'the vbSocket function in order to create a new socket
        m_lngSocketHandle = vbSocket
        '
        If m_lngSocketHandle = SOCKET_ERROR Then
            '
            'A value of SOCKET_ERROR means that the socket was not created.
            'In this case the SocketExists function must return False
            Exit Function
            '
        Else
            '
            'Get default size of the Winsock's buffers.
            Call GetWinsockBuffers  'Modified: 10-MAR-2002
            '
        End If
        '
    End If
    '
    'The m_lngSocketHandle variable contains a valid socket
    'handle value. In this case the function returns True.
    SocketExists = True
    '
End Function

Private Sub GetWinsockBuffers()
    '
    'This subroutine is to retrieve default size of the Winsock buffers.
    'These values will be stored in the module level variables:
    'm_lngSendBufferLen and m_lngRecvBufferLen.
    'It can be called from the SocketExists and Accept functions.
    '
    'Added: 10-MAR-2002
    '
    Dim lngRetValue     As Long 'value returned by the getsockopt Winsock API function
    Dim lngBuffer       As Long 'buffer to pass with the getsockopt call
    '
    If mvarProtocol = sckTCPProtocol Then
        'Buffer for incoming data
        lngRetValue = getsockopt(m_lngSocketHandle, SOL_SOCKET, SO_RCVBUF, lngBuffer, 4&)
        m_lngRecvBufferLen = lngBuffer
        'Buffer for outgoing data
        lngRetValue = getsockopt(m_lngSocketHandle, SOL_SOCKET, SO_SNDBUF, lngBuffer, 4&)
        m_lngSendBufferLen = lngBuffer
    Else
        'the m_lngMaxMsgSize value is returned by InitWinsockService
        'function from the MSocketSupport module
        m_lngSendBufferLen = m_lngMaxMsgSize
        m_lngRecvBufferLen = m_lngMaxMsgSize
    End If
    '
End Sub

Private Function RecvDataToBuffer() As Long
    '
    'This function is to retrieve data from the Winsock buffer
    'into the class local buffer. The function returns number
    'of bytes retrieved (received).
    '
    Dim lngBytesReceived        As Long     'value returned by recv/recvfrom Winsock API function
    Dim lngRetValue             As Long     'value returned by gethostbyaddr Winsock API function
    Dim strTempBuffer           As String   'just a temporary buffer
    Dim arrBuffer()             As Byte     'buffer to pass to the recv/recvfrom Winsock API function
    Dim udtSockAddr             As sockaddr_in 'socket address of the remote peer
    Dim lngSockAddrLen          As Long     'size of the sockaddr_in structure
    Dim udtHostent              As HOSTENT  'used to get host name with gethostbyaddr function
    '
    'Prepare the buffer to pass it to the recv/recvfrom Winsock API function.
    'The m_lngRecvBufferLen variable was initialized during creating
    'of the socket, see the vbSocket function to find out how.
    ReDim arrBuffer(m_lngRecvBufferLen - 1)
    '
    If mvarProtocol = sckTCPProtocol Then
        '
        'If the socket is a connection-oriented one, just call the recv function
        'to retrieve all the arrived data from the Winsock buffer.
        lngBytesReceived = recv(m_lngSocketHandle, arrBuffer(0), m_lngRecvBufferLen, 0&)
        '
    Else
        '
        'If the socket uses UDP, it's another story. As stated in the MS Winsock Control
        'documentation after receiving data the RemoteHost, RemoteHostIP, and RemotePort
        'properties contains parameters of the machine sending the UDP data. To achive
        'such a behavior we must use the recvfrom Winsock API function.
        '
        lngSockAddrLen = Len(udtSockAddr)
        '
        lngBytesReceived = recvfrom(m_lngSocketHandle, arrBuffer(0), m_lngRecvBufferLen, _
                                    0&, udtSockAddr, lngSockAddrLen)
        '
        If Not lngBytesReceived = SOCKET_ERROR Then
            '
            'Now the udtSockAddr contains a socket address of the remote host.
            'Initialize the RemoteHost, RemoteHostIP, and RemotePort properties.
            '
            With udtSockAddr
                '
                'RemotePort property
                m_lngRemotePort = IntegerToUnsigned(ntohs(.sin_port))
                'RemoteHostIP property
                m_strRemoteHostIP = StringFromPointer(inet_ntoa(.sin_addr))
                'RemoteHost property
                lngRetValue = gethostbyaddr(.sin_addr, 4&, AF_INET)
                CopyMemory udtHostent, ByVal lngRetValue, Len(udtHostent)
                m_strRemoteHost = StringFromPointer(udtHostent.hName)
                '
            End With
            '
        End If
        '
    End If
    '
    If lngBytesReceived > 0 Then
        '
        'Convert a byte array into the VB string
        strTempBuffer = StrConv(arrBuffer(), vbUnicode)
        'Store received data in the local buffer for incoming data - m_strRecvBuffer
        m_strRecvBuffer = m_strRecvBuffer & Left$(strTempBuffer, lngBytesReceived)
        'Return number of received bytes.
        RecvDataToBuffer = lngBytesReceived
        '
    ElseIf lngBytesReceived = SOCKET_ERROR Then
        '
        Err.Raise Err.LastDllError, "CSocket.RecvToBuffer", GetErrorDescription(Err.LastDllError)
        '
    End If
    '
End Function

Private Function RecvData(varData As Variant, blnPeek As Boolean, Optional varType As Variant, Optional maxLen As Variant) As Long
    '
    'This function is to retrieve data from the local buffer (m_strRecvBuffer).
    'It can be called by two public methods of the class - GetData and PeekData.
    'Behavior of the function is defined by the blnPeek argument. If a value of
    'that argument is True, the function returns number of bytes in the
    'local buffer, and copy data from that buffer into the varData argument.
    'If a value of the blnPeek is False, then this function returns number of
    'bytes received, and move data from the local buffer into the varData
    'argument. MOVE means that data will be removed from the local buffer.
    '
    Dim strRecvData As String   'temporary string buffer
    Dim arrBuffer() As Byte     'temporary byte array buffer
    '
    'If the local buffer is empty, go away - we have nothing to do here.
    If Len(m_strRecvBuffer) = 0 Then Exit Function
    '
    If IsEmpty(maxLen) Then
        maxLen = 0
    End If
    '
    If (Not maxLen > Len(m_strRecvBuffer)) And (maxLen > 0) Then
        '
        strRecvData = Left$(m_strRecvBuffer, CLng(maxLen))
        '
        If Not blnPeek Then
            m_strRecvBuffer = Mid$(m_strRecvBuffer, CLng(maxLen + 1))
        End If
        '
        arrBuffer() = StrConv(strRecvData, vbFromUnicode)
        '
    Else
        '
        arrBuffer() = StrConv(m_strRecvBuffer, vbFromUnicode)
        '
        If Not blnPeek Then
            m_strRecvBuffer = ""
        End If
        '
    End If
    '
    If IsEmpty(varType) Then
        varData = CStr(StrConv(arrBuffer(), vbUnicode))
    Else
        '
        Select Case varType
            Case vbArray + vbByte
                'Modified 28-MAY-2002. Thanks to Michael Freidgeim
                '--------------------------------
                'Dim strArray As String
                'strArray = StrConv(arrBuffer(), vbUnicode)
                'varData = StrConv(strArray, vbFromUnicode)
                varData = arrBuffer()
                '--------------------------------
            Case vbBoolean
                Dim blnData As Boolean
                CopyMemory blnData, arrBuffer(0), LenB(blnData)
                varData = blnData
            Case vbByte
                Dim bytData As Byte
                CopyMemory bytData, arrBuffer(0), LenB(bytData)
                varData = bytData
            Case vbCurrency
                Dim curData As Currency
                CopyMemory curData, arrBuffer(0), LenB(curData)
                varData = curData
            Case vbDate
                Dim datData As Date
                CopyMemory datData, arrBuffer(0), LenB(datData)
                varData = datData
            Case vbDouble
                Dim dblData As Double
                CopyMemory dblData, arrBuffer(0), LenB(dblData)
                varData = dblData
            Case vbInteger
                Dim intData As Integer
                CopyMemory intData, arrBuffer(0), LenB(intData)
                varData = intData
            Case vbLong
                Dim lngData As Long
                CopyMemory lngData, arrBuffer(0), LenB(lngData)
                varData = lngData
            Case vbSingle
                Dim sngData As Single
                CopyMemory sngData, arrBuffer(0), LenB(sngData)
                varData = sngData
            Case vbString
                Dim strData As String
                strData = StrConv(arrBuffer(), vbUnicode)
                varData = strData
                '
        End Select
        '
    End If
    '
    'Added 28-MAY-2002. Thanks to Michael Freidgeim
    m_lngBytesReceived = Len(m_strRecvBuffer) 'reset BytesReceived after Getdata
    '
End Function

Private Sub DestroySocket()
    '
    'The purpose of this subroutine is to unregister the socket with
    'UnregisterSocket that can be found in the MSocketSupport module
    'and close the socket with the closesocket Winsock API function.
    '
    Dim lngRetValue As Long 'value returned by the closesocket
                            'Winsock AP function
    '
    m_strRecvBuffer = "" 'Added: 17-OCT-2002
    '
    If Not m_lngSocketHandle = INVALID_SOCKET Then
        '
        'Unregister the socket. For more info on how it works
        'see the code of the function in the MSocketSupport module
        Call mSocketSupport.UnregisterSocket(m_lngSocketHandle)
        '
        'Close the socket with the closesocket Winsock API function.
        lngRetValue = api_closesocket(m_lngSocketHandle)
        '
        'Debug.Print m_lngSocketHandle & ": closed"
        '
        If lngRetValue = SOCKET_ERROR Then
            Err.Raise Err.LastDllError, "CSocket.DestroySocket", GetErrorDescription(Err.LastDllError)
        End If
        '
        'Change the SocketHandle property value
        m_lngSocketHandle = INVALID_SOCKET
        '
        'If the bind Winsock API function has been called on
        'this socket, m_blnSocketIsBound = True. We need to
        'change this value.
        m_blnSocketIsBound = False  'Added: 10-MAR-2002
        '
        m_blnBroadcast = False      'Added: 09-JULY-2002
        '
    End If
    '
End Sub

Private Sub Class_Terminate()
    '
    If Not m_lngSocketHandle = INVALID_SOCKET Then
        Call DestroySocket
    End If
    '
    Call CleanupWinsock
    '
End Sub

Private Sub SendBufferedData()
    '
    'This procedure sends data from the local buffer (m_strSendBuffer).
    'The data from the client application is passed with the SendData
    'method of the class as an argument and is stored in the local
    'buffer until all the data from that buffer will be sent using this
    'subroutine.
    '
    'Why do we need to store data in the local buffer? There are some
    'things happenning in the Winsock's buffer for outgoing data since
    'we're using non-blocking sockets' calls. If that buffer is full,
    'the transport subsystem doesn't take the data and the send/sendto
    'functions return a value of SOCKET_ERROR, Err.LastDllError give
    'us a value of WSAEWOULDBLOCK. This means that if the socket would
    'be a blocking one, such a call would block socket until the buffer
    'will be freed and ready to accept some data to send.
    '
    'So this procedure can be called several (mostly not more than two)
    'times for the same chunk of data. First call is in the body of the
    'SendData method, and other calls (if necessary) will be performed
    'from the PostSocketEvent subroutine, as soon as the FD_WRITE message
    'will be received. The arrival of the FD_WRITE message means that a
    'socket is in a write-able state - its buffer is ready to get data.
    '
    Dim lngRetValue     As Long         'value returned by send/sendto Winsock API function
    Dim arrData()       As Byte         'data to send with the send/sendto function
    Dim lngBufferLength As Long         'size of the data buffer to send
    Dim udtSockAddr     As sockaddr_in  'address of the remote socket - for the sendto function
    '
    'The send/sendto function needs this value for one of its arguments
    lngBufferLength = Len(m_strSendBuffer)
    m_blnSendFlag = True
    '
    'Convert data from a VB string to a byte array
    arrData() = StrConv(m_strSendBuffer, vbFromUnicode)
    '
    If mvarProtocol = sckTCPProtocol Then
        '
        'just call the send function in order to send data via connection
        lngRetValue = send(m_lngSocketHandle, arrData(0), lngBufferLength, 0&)
        '
    Else
        '
        'With UDP socket we are going to use the sendto Winsock API function.
        'This function needs the socket address of the remote host to send
        'message to.
        '
        If Len(m_strRemoteHostIP) = 0 Then
            '
            'If the RemoteHostIP property is empty, we don't know
            'the remote IP so we need to resolve that address.
            '
            m_varInternalState = istSendingDatagram
            m_lngRequestID = mSocketSupport.ResolveHost(m_strRemoteHost, ObjPtr(Me))
            '
            'The ResolveHost is an asynchronous call. This subroutine wiil be called
            'one more time from the PostGetHostEvent procedure when the host will be
            'resolved.
            '
        Else
            '
            'If we are here the host was resolved successfully and the RemoteHostIP
            'property provides us with IP to send a UDP message to.
            '
            'Build the sockaddr_in structure to pass the remote socket address
            'to the sendto function.
            With udtSockAddr
                .sin_addr = inet_addr(m_strRemoteHostIP)
                .sin_port = htons(UnsignedToInteger(m_lngRemotePort))
                .sin_family = AF_INET
            End With
            '
            'Call the sendto function in order to send a UDP message
            lngRetValue = sendto(m_lngSocketHandle, arrData(0), lngBufferLength, 0&, udtSockAddr, Len(udtSockAddr))
            '
        End If
        '
    End If
    '
    If lngRetValue = SOCKET_ERROR Then
        '
        'If a value of Err.LastDllError is WSAEWOULDBLOCK, that means
        'that the Winsock's buffer for outgoing data is full and cannot
        'accept data to send. In this case we ignore this error and do
        'not empty local buffer (m_strSendBuffer).
        '
        If Not Err.LastDllError = WSAEWOULDBLOCK Then
            'Debug.Print "Error occurred: " & Err.LastDllError & " - " & GetErrorDescription(Err.LastDllError)
            Err.Raise Err.LastDllError, "CSocket.SendData", GetErrorDescription(Err.LastDllError)
        Else
            'Debug.Print "WSAEWOULDBLOCK"
        End If
        '
    Else
        '
        'The data were sent successfully. Raise the OnSendProgress or
        'OnSendComplete event to let the client app know.
        '
        'Debug.Print "SendData - Bytes sent: " & lngRetValue
        '
        If Len(m_strSendBuffer) > lngRetValue Then
            '
            m_strSendBuffer = Mid$(m_strSendBuffer, lngRetValue + 1)
            '
        Else
            '
            m_strSendBuffer = ""
            '
            '---------------------------------------------
            'Modified: 23-AUG-2002
            '---------------------------------------------
            'RaiseEvent OnSendComplete
            Call PostMessage(p_lngWindowHandle, p_lngWinsockMessage, m_lngSocketHandle, FD_WRITE)
            '---------------------------------------------
        End If
        '
        RaiseEvent OnSendProgress(lngRetValue, Len(m_strSendBuffer))
        '
    End If
    '
End Sub
