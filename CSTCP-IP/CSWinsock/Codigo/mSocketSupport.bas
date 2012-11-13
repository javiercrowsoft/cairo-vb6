Attribute VB_Name = "mSocketSupport"
'********************************************************************************
'MSocketSupport module
'Copyright 2002 by Oleg Gdalevich
'Visual Basic Internet Programming website (http://www.vbip.com)
'********************************************************************************
'This module contains API declarations and helper functions for the CSocket class
'********************************************************************************
'Version: 1.0.12     Modified: 17-OCT-2002
'********************************************************************************
'To get latest version of this code please visit the following web page:
'http://www.vbip.com/winsock-api/csocket-class/csocket-class-01.asp
'********************************************************************************

Option Explicit
'
Public Const INADDR_NONE = &HFFFF
'
Public Const SOCKET_ERROR = -1
Public Const INVALID_SOCKET = -1
Public Const INADDR_ANY = &H0
'
Public Const FD_SETSIZE = 64
'
'/*
' * Define constant based on rfc883, used by gethostbyxxxx() calls.
' */
Public Const MAXGETHOSTSTRUCT = 1024
'
'/*
' * WinSock 2 extension -- manifest constants for shutdown()
' */
Public Const SD_RECEIVE = &H0
Public Const SD_SEND = &H1
Public Const SD_BOTH = &H2
'
Public Const MSG_OOB = &H1         '/* process out-of-band data */
Public Const MSG_PEEK = &H2        '/* peek at incoming message */
Public Const MSG_DONTROUTE = &H4   '/* send without using routing tables */
Public Const MSG_PARTIAL = &H8000  '/* partial send or recv for message xport */
'
Public Const FD_READ = &H1&
Public Const FD_WRITE = &H2&
Public Const FD_OOB = &H4&
Public Const FD_ACCEPT = &H8&
Public Const FD_CONNECT = &H10&
Public Const FD_CLOSE = &H20&
'
Public Const SOL_SOCKET = 65535
'
' option flags per socket
Public Const SO_DEBUG = &H1&         ' Turn on debugging info recording
Public Const SO_ACCEPTCONN = &H2&    ' Socket has had listen() - READ-ONLY.
Public Const SO_REUSEADDR = &H4&     ' Allow local address reuse.
Public Const SO_KEEPALIVE = &H8&     ' Keep connections alive.
Public Const SO_DONTROUTE = &H10&    ' Just use interface addresses.
Public Const SO_BROADCAST = &H20&    ' Permit sending of broadcast msgs.
Public Const SO_USELOOPBACK = &H40&  ' Bypass hardware when possible.
Public Const SO_LINGER = &H80&       ' Linger on close if data present.
Public Const SO_OOBINLINE = &H100&   ' Leave received OOB data in line.

Public Const SO_DONTLINGER = Not SO_LINGER
Public Const SO_EXCLUSIVEADDRUSE = Not SO_REUSEADDR ' Disallow local address reuse.

' Additional options.
Public Const SO_SNDBUF = &H1001&     ' Send buffer size.
Public Const SO_RCVBUF = &H1002&     ' Receive buffer size.
Public Const SO_ERROR = &H1007&      ' Get error status and clear.
Public Const SO_TYPE = &H1008&       ' Get socket type - READ-ONLY.
'
Public Const WSADESCRIPTION_LEN = 257
Public Const WSASYS_STATUS_LEN = 129
'
Public Type WSAData
    wVersion As Integer
    wHighVersion As Integer
    szDescription As String * WSADESCRIPTION_LEN
    szSystemStatus As String * WSASYS_STATUS_LEN
    iMaxSockets As Integer
    iMaxUdpDg As Integer
    lpVendorInfo As Long
End Type
'
Public Type sockaddr_in
    sin_family       As Integer
    sin_port         As Integer
    sin_addr         As Long
    sin_zero(1 To 8) As Byte
End Type

Public Type fd_set
  fd_count                  As Long '// how many are SET?
  fd_array(1 To FD_SETSIZE) As Long '// an array of SOCKETs
End Type
'
'/*
' * All Windows Sockets error constants are biased by WSABASEERR from
' * the "normal"
' */
Public Const WSABASEERR = 10000
'/*
' * Windows Sockets definitions of regular Microsoft C error constants
' */
Public Const WSAEINTR = (WSABASEERR + 4)
Public Const WSAEBADF = (WSABASEERR + 9)
Public Const WSAEACCES = (WSABASEERR + 13)
Public Const WSAEFAULT = (WSABASEERR + 14)
Public Const WSAEINVAL = (WSABASEERR + 22)
Public Const WSAEMFILE = (WSABASEERR + 24)

'/*
' * Windows Sockets definitions of regular Berkeley error constants
' */
Public Const WSAEWOULDBLOCK = (WSABASEERR + 35)
Public Const WSAEINPROGRESS = (WSABASEERR + 36)
Public Const WSAEALREADY = (WSABASEERR + 37)
Public Const WSAENOTSOCK = (WSABASEERR + 38)
Public Const WSAEDESTADDRREQ = (WSABASEERR + 39)
Public Const WSAEMSGSIZE = (WSABASEERR + 40)
Public Const WSAEPROTOTYPE = (WSABASEERR + 41)
Public Const WSAENOPROTOOPT = (WSABASEERR + 42)
Public Const WSAEPROTONOSUPPORT = (WSABASEERR + 43)
Public Const WSAESOCKTNOSUPPORT = (WSABASEERR + 44)
Public Const WSAEOPNOTSUPP = (WSABASEERR + 45)
Public Const WSAEPFNOSUPPORT = (WSABASEERR + 46)
Public Const WSAEAFNOSUPPORT = (WSABASEERR + 47)
Public Const WSAEADDRINUSE = (WSABASEERR + 48)
Public Const WSAEADDRNOTAVAIL = (WSABASEERR + 49)
Public Const WSAENETDOWN = (WSABASEERR + 50)
Public Const WSAENETUNREACH = (WSABASEERR + 51)
Public Const WSAENETRESET = (WSABASEERR + 52)
Public Const WSAECONNABORTED = (WSABASEERR + 53)
Public Const WSAECONNRESET = (WSABASEERR + 54)
Public Const WSAENOBUFS = (WSABASEERR + 55)
Public Const WSAEISCONN = (WSABASEERR + 56)
Public Const WSAENOTCONN = (WSABASEERR + 57)
Public Const WSAESHUTDOWN = (WSABASEERR + 58)
Public Const WSAETOOMANYREFS = (WSABASEERR + 59)
Public Const WSAETIMEDOUT = (WSABASEERR + 60)
Public Const WSAECONNREFUSED = (WSABASEERR + 61)
Public Const WSAELOOP = (WSABASEERR + 62)
Public Const WSAENAMETOOLONG = (WSABASEERR + 63)
Public Const WSAEHOSTDOWN = (WSABASEERR + 64)
Public Const WSAEHOSTUNREACH = (WSABASEERR + 65)
Public Const WSAENOTEMPTY = (WSABASEERR + 66)
Public Const WSAEPROCLIM = (WSABASEERR + 67)
Public Const WSAEUSERS = (WSABASEERR + 68)
Public Const WSAEDQUOT = (WSABASEERR + 69)
Public Const WSAESTALE = (WSABASEERR + 70)
Public Const WSAEREMOTE = (WSABASEERR + 71)

'/*
' * Extended Windows Sockets error constant definitions
' */
Public Const WSASYSNOTREADY = (WSABASEERR + 91)
Public Const WSAVERNOTSUPPORTED = (WSABASEERR + 92)
Public Const WSANOTINITIALISED = (WSABASEERR + 93)
Public Const WSAEDISCON = (WSABASEERR + 101)
Public Const WSAENOMORE = (WSABASEERR + 102)
Public Const WSAECANCELLED = (WSABASEERR + 103)
Public Const WSAEINVALIDPROCTABLE = (WSABASEERR + 104)
Public Const WSAEINVALIDPROVIDER = (WSABASEERR + 105)
Public Const WSAEPROVIDERFAILEDINIT = (WSABASEERR + 106)
Public Const WSASYSCALLFAILURE = (WSABASEERR + 107)
Public Const WSASERVICE_NOT_FOUND = (WSABASEERR + 108)
Public Const WSATYPE_NOT_FOUND = (WSABASEERR + 109)
Public Const WSA_E_NO_MORE = (WSABASEERR + 110)
Public Const WSA_E_CANCELLED = (WSABASEERR + 111)
Public Const WSAEREFUSED = (WSABASEERR + 112)
'
'/* Authoritative Answer: Host not found */
Public Const WSAHOST_NOT_FOUND = (WSABASEERR + 1001)
'/* Non-Authoritative: Host not found, or SERVERFAIL */
Public Const WSATRY_AGAIN = (WSABASEERR + 1002)
'/* Non recoverable errors, FORMERR, REFUSED, NOTIMP */
Public Const WSANO_RECOVERY = (WSABASEERR + 1003)
'/* Valid name, no data record of requested type */
Public Const WSANO_DATA = (WSABASEERR + 1004)
'
'
'Socket types
'
Public Enum SocketType
    SOCK_STREAM = 1    ' /* stream socket */
    SOCK_DGRAM = 2     ' /* datagram socket */
    SOCK_RAW = 3       ' /* raw-protocol interface */
    SOCK_RDM = 4       ' /* reliably-delivered message */
    SOCK_SEQPACKET = 5 ' /* sequenced packet stream */
End Enum
'
Public Enum AddressFamily
    '
    AF_UNSPEC = 0      '/* unspecified */
'/*
' * Although  AF_UNSPEC  is  defined for backwards compatibility, using
' * AF_UNSPEC for the "af" parameter when creating a socket is STRONGLY
' * DISCOURAGED.    The  interpretation  of  the  "protocol"  parameter
' * depends  on the actual address family chosen.  As environments grow
' * to  include  more  and  more  address families that use overlapping
' * protocol  values  there  is  more  and  more  chance of choosing an
' * undesired address family when AF_UNSPEC is used.
' */
    AF_UNIX = 1        '/* local to host (pipes, portals) */
    AF_INET = 2        '/* internetwork: UDP, TCP, etc. */
    AF_IMPLINK = 3     '/* arpanet imp addresses */
    AF_PUP = 4         '/* pup protocols: e.g. BSP */
    AF_CHAOS = 5       '/* mit CHAOS protocols */
    AF_NS = 6          '/* XEROX NS protocols */
    AF_IPX = AF_NS     '/* IPX protocols: IPX, SPX, etc. */
    AF_ISO = 7         '/* ISO protocols */
    AF_OSI = AF_ISO    '/* OSI is ISO */
    AF_ECMA = 8        '/* european computer manufacturers */
    AF_DATAKIT = 9     '/* datakit protocols */
    AF_CCITT = 10      '/* CCITT protocols, X.25 etc */
    AF_SNA = 11        '/* IBM SNA */
    AF_DECnet = 12     '/* DECnet */
    AF_DLI = 13        '/* Direct data link interface */
    AF_LAT = 14        '/* LAT */
    AF_HYLINK = 15     '/* NSC Hyperchannel */
    AF_APPLETALK = 16  '/* AppleTalk */
    AF_NETBIOS = 17    '/* NetBios-style addresses */
    AF_VOICEVIEW = 18  '/* VoiceView */
    AF_FIREFOX = 19    '/* Protocols from Firefox */
    AF_UNKNOWN1 = 20   '/* Somebody is using this! */
    AF_BAN = 21        '/* Banyan */
    AF_ATM = 22        '/* Native ATM Services */
    AF_INET6 = 23      '/* Internetwork Version 6 */
    AF_CLUSTER = 24    '/* Microsoft Wolfpack */
    AF_12844 = 25      '/* IEEE 1284.4 WG AF */
    AF_MAX = 26
    '
End Enum
'
'/*
' * Protocols
' */
Public Enum SocketProtocol
    IPPROTO_IP = 0             '/* dummy for IP */
    IPPROTO_ICMP = 1           '/* control message protocol */
    IPPROTO_IGMP = 2           '/* internet group management protocol */
    IPPROTO_GGP = 3            '/* gateway^2 (deprecated) */
    IPPROTO_TCP = 6            '/* tcp */
    IPPROTO_PUP = 12           '/* pup */
    IPPROTO_UDP = 17           '/* user datagram protocol */
    IPPROTO_IDP = 22           '/* xns idp */
    IPPROTO_ND = 77            '/* UNOFFICIAL net disk proto */
    IPPROTO_RAW = 255          '/* raw IP packet */
    IPPROTO_MAX = 256
End Enum
'
Public Type HOSTENT
    hName     As Long
    hAliases  As Long
    hAddrType As Integer
    hLength   As Integer
    hAddrList As Long
End Type
'
Public Declare Function gethostbyaddr Lib "ws2_32.dll" (addr As Long, ByVal addr_len As Long, ByVal addr_type As Long) As Long
Public Declare Function gethostbyname Lib "ws2_32.dll" (ByVal host_name As String) As Long
Public Declare Function gethostname Lib "ws2_32.dll" (ByVal host_name As String, ByVal namelen As Long) As Long
Public Declare Function getservbyname Lib "ws2_32.dll" (ByVal serv_name As String, ByVal proto As String) As Long
Public Declare Function getprotobynumber Lib "ws2_32.dll" (ByVal proto As Long) As Long
Public Declare Function getprotobyname Lib "ws2_32.dll" (ByVal proto_name As String) As Long
Public Declare Function getservbyport Lib "ws2_32.dll" (ByVal Port As Integer, ByVal proto As Long) As Long
Public Declare Function inet_addr Lib "ws2_32.dll" (ByVal cp As String) As Long
Public Declare Function inet_ntoa Lib "ws2_32.dll" (ByVal inn As Long) As Long
Public Declare Function htons Lib "ws2_32.dll" (ByVal hostshort As Integer) As Integer
Public Declare Function htonl Lib "ws2_32.dll" (ByVal hostlong As Long) As Long
Public Declare Function ntohl Lib "ws2_32.dll" (ByVal netlong As Long) As Long
Public Declare Function ntohs Lib "ws2_32.dll" (ByVal netshort As Integer) As Integer
Public Declare Function api_socket Lib "ws2_32.dll" Alias "socket" (ByVal af As Long, ByVal s_type As Long, ByVal Protocol As Long) As Long
Public Declare Function api_closesocket Lib "ws2_32.dll" Alias "closesocket" (ByVal s As Long) As Long
Public Declare Function api_connect Lib "ws2_32.dll" Alias "connect" (ByVal s As Long, ByRef name As sockaddr_in, ByVal namelen As Long) As Long
Public Declare Function getsockname Lib "ws2_32.dll" (ByVal s As Long, ByRef name As sockaddr_in, ByRef namelen As Long) As Long
Public Declare Function getpeername Lib "ws2_32.dll" (ByVal s As Long, ByRef name As sockaddr_in, ByRef namelen As Long) As Long
Public Declare Function api_bind Lib "ws2_32.dll" Alias "bind" (ByVal s As Long, ByRef name As sockaddr_in, ByRef namelen As Long) As Long
Public Declare Function api_select Lib "ws2_32.dll" Alias "select" (ByVal nfds As Long, ByRef readfds As Any, ByRef writefds As Any, ByRef exceptfds As Any, ByRef TimeOut As Long) As Long
Public Declare Function recv Lib "ws2_32.dll" (ByVal s As Long, ByRef buf As Any, ByVal buflen As Long, ByVal flags As Long) As Long
Public Declare Function send Lib "ws2_32.dll" (ByVal s As Long, ByRef buf As Any, ByVal buflen As Long, ByVal flags As Long) As Long
Public Declare Function shutdown Lib "ws2_32.dll" (ByVal s As Long, ByVal how As Long) As Long
Public Declare Function api_listen Lib "ws2_32.dll" Alias "listen" (ByVal s As Long, ByVal backlog As Long) As Long
Public Declare Function api_accept Lib "ws2_32.dll" Alias "accept" (ByVal s As Long, ByRef addr As sockaddr_in, ByRef addrlen As Long) As Long
Public Declare Function setsockopt Lib "ws2_32.dll" (ByVal s As Long, ByVal level As Long, ByVal optname As Long, optval As Any, ByVal optlen As Long) As Long
Public Declare Function getsockopt Lib "ws2_32.dll" (ByVal s As Long, ByVal level As Long, ByVal optname As Long, optval As Any, optlen As Long) As Long
Public Declare Function sendto Lib "ws2_32.dll" (ByVal s As Long, ByRef buf As Any, ByVal buflen As Long, ByVal flags As Long, ByRef toaddr As sockaddr_in, ByVal tolen As Long) As Long
Public Declare Function recvfrom Lib "ws2_32.dll" (ByVal s As Long, ByRef buf As Any, ByVal buflen As Long, ByVal flags As Long, ByRef from As sockaddr_in, ByRef fromlen As Long) As Long

Public Declare Function WSAAsyncSelect Lib "ws2_32.dll" (ByVal s As Long, ByVal hwnd As Long, ByVal wMsg As Long, ByVal lEvent As Long) As Long
Public Declare Function WSAAsyncGetHostByAddr Lib "ws2_32.dll" (ByVal hwnd As Long, ByVal wMsg As Long, ByRef lngAddr As Long, ByVal lngLenght As Long, ByVal lngType As Long, buf As Any, ByVal lngBufLen As Long) As Long
Public Declare Function WSAAsyncGetHostByName Lib "ws2_32.dll" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal strHostName As String, buf As Any, ByVal buflen As Long) As Long
Public Declare Function WSAStartup Lib "ws2_32.dll" (ByVal wVR As Long, lpWSAD As WSAData) As Long
Public Declare Function WSACleanup Lib "ws2_32.dll" () As Long
'
Private Const GWL_WNDPROC = -4
Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function CreateWindowEx Lib "user32" Alias "CreateWindowExA" (ByVal dwExStyle As Long, ByVal lpClassName As String, ByVal lpWindowName As String, ByVal dwStyle As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hWndParent As Long, ByVal hMenu As Long, ByVal hInstance As Long, lpParam As Any) As Long
Private Declare Function DestroyWindow Lib "user32" (ByVal hwnd As Long) As Long
'Added: 04-MAR-2002
Private Declare Function RegisterWindowMessage Lib "user32" Alias "RegisterWindowMessageA" (ByVal lpString As String) As Long
'Added: 17-OCT-2002
Private Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc&, ByVal hwnd&, ByVal Msg&, ByVal wParam&, ByVal lParam&) As Long

Private Declare Function lstrcpy Lib "kernel32" Alias "lstrcpyA" (ByVal lpString1 As String, ByVal lpString2 As Long) As Long
Private Declare Function lstrlen Lib "kernel32" Alias "lstrlenA" (ByVal lpString As Any) As Long
Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (lpvDest As Any, lpvSource As Any, ByVal cbCopy As Long)
Private Declare Sub RtlMoveMemory Lib "kernel32" (hpvDest As Any, ByVal hpvSource As Long, ByVal cbCopy As Long)
'
Public Const GMEM_FIXED = &H0
Public Const GMEM_MOVEABLE = &H2
'
Public Declare Function GlobalAlloc Lib "kernel32" (ByVal wFlags As Long, ByVal dwBytes As Long) As Long
Public Declare Function GlobalFree Lib "kernel32" (ByVal hMem As Long) As Long
Public Declare Function GlobalLock Lib "kernel32" (ByVal hMem As Long) As Long
Public Declare Function GlobalUnlock Lib "kernel32" (ByVal hMem As Long) As Long
'---------------------------------------------
'Modified: 23-AUG-2002
'---------------------------------------------
'The variable scope has been changed to Public to be
'visible from the CSocket class module
'Private m_lngWindowHandle   As Long
Public p_lngWindowHandle   As Long
'---------------------------------------------
Private m_colSockets        As Collection
Private m_colResolvers      As Collection
Private m_colMemoryBlocks   As Collection
Private m_lngPreviousValue  As Long

Private m_blnGetHostRecv    As Boolean
Private m_blnWinsockInit    As Boolean
Private m_lngMaxMsgSize     As Long

Private Const WM_USER = &H400
'
'Private Const RESOLVE_MESSAGE = WM_USER + 1
'Private Const SOCKET_MESSAGE = WM_USER + 2
'
Private m_lngResolveMessage As Long 'Added: 04-MAR-2002
'---------------------------------------------
'Modified: 23-AUG-2002
'---------------------------------------------
'The variable scope has been changed to Public to be
'visible from the CSocket class module
'Private m_lngWinsockMessage As Long 'Added: 04-MAR-2002
Public p_lngWinsockMessage As Long
'---------------------------------------------
'
Private Const OFFSET_4 = 4294967296#
Private Const MAXINT_4 = 2147483647
Private Const OFFSET_2 = 65536
Private Const MAXINT_2 = 32767



Private Function WindowProc(ByVal hwnd As Long, ByVal uMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    '
    'This the callback function of the window created to hook
    'messages sent by the Winsock service. It handles only two
    'types of messages - network events for the sockets the
    'WSAAsyncSelect fucntion was called for, and the messages
    'sent in response to the WSAAsyncGetHostByName and
    'WSAAsyncGetHostByAddress Winsock API functions.
    '
    'Then the message is received, this function creates illegal
    'reference to the instance of the CSocket class and calls
    'either the PostSocketEvent or PostGetHostEvent method of the
    'class to pass that message to the class.
    '
    Dim objSocket           As cSocket  'the illegal reference to an
                                        'instance of the CSocket class
    Dim lngObjPointer       As Long     'pointer to the existing instance
                                        'of the CSocket class
    Dim lngEventID          As Long     'network event
    Dim lngErrorCode        As Long     'code of the error message
    Dim lngMemoryHandle     As Long     'descriptor of the allocated
                                        'memory object
    Dim lngMemoryPointer    As Long     'pointer to the allocated memory
    Dim lngHostAddress      As Long     '32-bit host address
    Dim strHostName         As String   'a host hame
    Dim udtHost             As HOSTENT  'structure of the data in the
                                        'allocated memory block
    Dim lngIpAddrPtr        As Long     'pointer to the IP address string
    '
    On Error GoTo ERORR_HANDLER
    '
    If uMsg = p_lngWinsockMessage Then  'Modified: 04-MAR-2002
        '
        'All the pointers to the existing instances of the CSocket class
        'are stored in the m_colSockets collection. Key of the collection's
        'item contains a value of the socket handle, and a value of the
        'collection item is the Long value that is a pointer the object,
        'instance of the CSocket class. Since the wParam argument of the
        'callback function contains a value of the socket handle the
        'function has received the network event message for, we can use
        'that value to get the object's pointer. With the pointer value
        'we can create the illegal reference to the object to be able to
        'call any Public or Friend subroutine of that object.
        '
        Set objSocket = SocketObjectFromPointer(CLng(m_colSockets("S" & wParam)))
        '
        'Retrieve the network event ID
        lngEventID = LoWord(lParam)
        'Retrieve the error code
        lngErrorCode = HiWord(lParam)
        '
        'Forward the message to the instance of the CSocket class
        objSocket.PostSocketEvent lngEventID, lngErrorCode
        '
    ElseIf uMsg = m_lngResolveMessage Then  'Modified: 04-MAR-2002
        '
        'A message has been received in response to the call of
        'the WSAAsyncGetHostByName or WSAAsyncGetHostByAddress.
        '
        'Retrieve the error code
        lngErrorCode = HiWord(lParam)
        '
        'The wParam parameter of the callback function contains
        'the task handle returned by the original function call
        '(see the ResolveHost function for more info). This value
        'is used as a key of the m_colResolvers collection item.
        'The item of that collection contains a pointer to the
        'instance of the CSocket class. So, if we know a value
        'of the task handle, we can find out the pointer to the
        'object which called the ResolveHost function in this module.
        '
        'Get the object pointer by the task handle value
        lngObjPointer = CLng(m_colResolvers("R" & wParam))
        '
        'A value of the pointer to the instance of the CSocket class
        'is used also as a key for the m_colMemoryBlocks collection
        'item that contains a handle of the allocated memory block
        'object. That memory block is the buffer where the
        'WSAAsyncGetHostByName and WSAAsyncGetHostByAddress functions
        'store the result HOSTENT structure.
        '
        'Get the handle of the allocated memory block object by the
        'pointer to the instance of the CSocket class.
        lngMemoryHandle = CLng(m_colMemoryBlocks("S" & lngObjPointer))
        '
        'Lock the memory block and get address of the buffer where
        'the HOSTENT structure data is stored.
        lngMemoryPointer = GlobalLock(lngMemoryHandle)
        '
        'Create an illegal reference to the instance of the
        'CSocket class
        Set objSocket = SocketObjectFromPointer(lngObjPointer)
        '
        'Now we can forward the message to that instance.
        '
        If lngErrorCode <> 0 Then
            '
            'If the host was not resolved, pass the error code value
            objSocket.PostGetHostEvent 0, 0, "", lngErrorCode
            '
        Else
            '
            'Move data from the allocated memory block to the
            'HOSTENT structure - udtHost
            CopyMemory udtHost, ByVal lngMemoryPointer, Len(udtHost)
            '
            'Get a 32-bit host address
            CopyMemory lngIpAddrPtr, ByVal udtHost.hAddrList, 4
            CopyMemory lngHostAddress, ByVal lngIpAddrPtr, 4
            '
            'Get a host name
            strHostName = StringFromPointer(udtHost.hName)
            '
            'Call the PostGetHostEvent friend method of the objSocket
            'to forward the retrieved information.
            objSocket.PostGetHostEvent wParam, lngHostAddress, strHostName
            '
        End If
        '
        'The task to resolve the host name is completed, thus we don't
        'need the allocated memory block anymore and corresponding items
        'in the m_colMemoryBlocks and m_colResolvers collections as well.
        '
        'Unlock the memory block
        Call GlobalUnlock(lngMemoryHandle)
        'Free that memory
        Call GlobalFree(lngMemoryHandle)
        '
        'Rremove the items from the collections
        m_colMemoryBlocks.Remove "S" & lngObjPointer
        m_colResolvers.Remove "R" & wParam
        '
        'If there are no more resolving tasks in progress,
        'destroy the collection objects to free resources.
        If m_colResolvers.Count = 0 Then
            Set m_colMemoryBlocks = Nothing
            Set m_colResolvers = Nothing
        End If
        '
    '---------------------------------------------------------------------
    'Added: 17-OCT-2002
    Else
        'Pass other messages to the original window procedure
        WindowProc = CallWindowProc(m_lngPreviousValue, hwnd, uMsg, wParam, lParam)
    '---------------------------------------------------------------------
    End If
    '
EXIT_LABEL:
    '
    Exit Function
    '
ERORR_HANDLER:
    '
    'Err.Raise Err.Number, "CSocket.WindowProc", Err.Description
    '
    'GoTo EXIT_LABEL
    '
End Function

Public Function RegisterSocket(ByVal lngSocketHandle As Long, ByVal lngObjectPointer As Long) As Boolean
'********************************************************************************
'Author    :Oleg Gdalevich
'Date/Time :17-12-2001
'Purpose   :Adds the socket to the m_colSockets collection, and
'           registers that socket with WSAAsyncSelect Winsock API
'           function to receive network events for the socket.
'           If this socket is the first one to be registered, the
'           window and collection will be created in this function as well.
'Arguments :lngSocketHandle  - the socket handle
'           lngObjectPointer - pointer to an object, instance of the CSocket class
'Returns   :If the argument is valid and no error occurred - True.
'********************************************************************************
    '
    On Error GoTo ERROR_HANDLER     'Added: 04-JUNE-2002
    '
    Dim lngEvents   As Long
    Dim lngRetValue As Long
    '
    If p_lngWindowHandle = 0 Then
        '
        'We have no window to catch the network events.
        'Create a new one.
        p_lngWindowHandle = CreateWinsockMessageWindow
        '
        If p_lngWindowHandle = 0 Then
            '
            'Cannot create a new window.
            '---------------------------------------------------
            'Added: 04-JUNE-2002
            '---------------------------------------------------
            'Set the error info to pass to the caller subroutine
            Err.Number = sckOpCanceled
            Err.Description = "The operation was canceled."
            Err.Source = "MSocketSupport.RegisterSocket"
            '---------------------------------------------------
            'Just exit to return False
            Exit Function
            '
        End If
        '
    End If
    '
    'The m_colSockets collection holds information
    'about all the sockets. If the current socket is
    'the first one, create the collection object.
    If m_colSockets Is Nothing Then
        Set m_colSockets = New Collection
        'Debug.Print "The m_colSockets is created"
    End If
    '
    'Add a new item to the m_colSockets collection.
    'The item key contains the socket handle, and the item's data
    'is the pointer to the instance of the CSocket class.
    m_colSockets.Add lngObjectPointer, "S" & lngSocketHandle
    '
    'The lngEvents variable contains a bitmask of events we are
    'going to catch with the window callback function.
    lngEvents = FD_CONNECT Or FD_READ Or FD_WRITE Or FD_CLOSE Or FD_ACCEPT
    '
    'Force the Winsock service to send the network event notifications
    'to the window which handle is p_lngWindowHandle.
    lngRetValue = WSAAsyncSelect(lngSocketHandle, p_lngWindowHandle, p_lngWinsockMessage, lngEvents)    'Modified:04-MAR-2002
    '
    '------------------------------------------------------------------
    'Added: 04-JUNE-2002
    '------------------------------------------------------------------
    If lngRetValue = SOCKET_ERROR Then
        '
        'If the WSAAsyncSelect call failed this function must
        'return False. In this case, the caller subroutine will
        'raise an error. Let's pass the error info with the Err object.
        '
        RegisterSocket = False
        '
        Err.Number = Err.LastDllError
        Err.Description = GetErrorDescription(Err.LastDllError)
        Err.Source = "MSocketSupport.RegisterSocket"
        '
    Else
        '
        RegisterSocket = True
        '
    End If
    '-------------------------------------------------------------------
    'Debug.Print lngSocketHandle & ": registered"
    '
    Exit Function           'Added: 04-JUNE-2002
    '
ERROR_HANDLER:              'Added: 04-JUNE-2002
    '
    RegisterSocket = False  'Added: 04-JUNE-2002
    '
End Function

Public Function UnregisterSocket(ByVal lngSocketHandle As Long) As Boolean
'********************************************************************************
'Author    :Oleg Gdalevich
'Date/Time :17-12-2001
'Purpose   :Removes the socket from the m_colSockets collection
'           If it is the last socket in that collection, the window
'           and colection will be destroyed as well.
'Returns   :If the argument is valid and no error occurred - True.
'********************************************************************************
    '
    If (lngSocketHandle = INVALID_SOCKET) Or (m_colSockets Is Nothing) Then
        '
        'Something wrong with the caller of this function :)
        'Return False
        Exit Function
        '
    End If
    '
    Call WSAAsyncSelect(lngSocketHandle, p_lngWindowHandle, 0&, 0&)
    '
    'Remove the socket from the collection
    m_colSockets.Remove "S" & lngSocketHandle
    '
    UnregisterSocket = True
    '
    'Debug.Print lngSocketHandle & ": unregistered"
    '
    If m_colSockets.Count = 0 Then
        '
        'If there are no more sockets in the collection
        'destroy the collection object and the window
        '
        Set m_colSockets = Nothing
        '
        'Debug.Print "m_colSockets destroyed"
        '
        UnregisterSocket = DestroyWinsockMessageWindow
        '
    End If
    '
End Function

Public Function ResolveHost(strHostAddress As String, ByVal lngObjectPointer As Long) As Long
'********************************************************************************
'Author    :Oleg Gdalevich
'Date/Time :17-12-2001
'Purpose   :Receives requests to resolve a host address from the CSocket class.
'Returns   :If no errors occurred - ID of the request. Otherwise - 0.
'********************************************************************************
    '
    'Since this module is supposed to serve several instances of the
    'CSocket class, this function can be called to start several
    'resolving tasks that could be executed simultaneously. To
    'distinguish the resolving tasks the m_colResolvers collection
    'is used. The key of the collection's item contains a pointer to
    'the instance of the CSocket class and the item's data is the
    'Request ID, the value returned by the WSAAsyncGetHostByXXXX
    'Winsock API function. So in order to get the pointer to the
    'instance of the CSocket class by the task ID value the following
    'line of code can be used:
    '
    'lngObjPointer = CLng(m_colResolvers("R" & lngTaskID))
    '
    'The WSAAsyncGetHostByXXXX function needs the buffer (the buf argument)
    'where the data received from DNS server will be stored. We cannot use
    'a local byte array for this purpose as this buffer must be available
    'from another subroutine in this module - WindowProc, also we cannot
    'use a module level array as several tasks can be executed simultaneously
    'At least, we need a dynamic module level array of arrays - too complicated.
    'I decided to use Windows API functions for allocation some memory for
    'each resolving task: GlobalAlloc, GlobalLock, GlobalUnlock, and GlobalFree.
    '
    'To distinguish those memory blocks, the m_colMemoryBlocks collection is
    'used. The key of the collection's item contains value of the object
    'pointer, and the item's value is a handle of the allocated memory
    'block object, value returned by the GlobalAlloc function. So in order to
    'get value of the handle of the allocated memory block object by the
    'pointer to the instance of CSocket class we can use the following code:
    '
    'lngMemoryHandle = CLng(m_colMemoryBlocks("S" & lngObjPointer))
    '
    'Why do we need all this stuff?
    '
    'The problem is that the callback function give us only the resolving task
    'ID value, but we need information about:
    '   - where the data returned from the DNS server is stored
    '   - which instance of the CSocket class we need to post the info to
    '
    'So, if we know the task ID value, we can find out the object pointer:
    '   lngObjPointer = CLng(m_colResolvers("R" & lngTaskID))
    '
    'If we know the object pointer value we can find out where the data is strored:
    '   lngMemoryHandle = CLng(m_colMemoryBlocks("S" & lngObjPointer))
    '
    'That's it. :))
    '
    Dim lngAddress          As Long '32-bit host address
    Dim lngRequestID        As Long 'value returned by WSAAsyncGetHostByXXX
    Dim lngMemoryHandle     As Long 'handle of the allocated memory block object
    Dim lngMemoryPointer    As Long 'address of the memory block
    '
    'Allocate some memory
    lngMemoryHandle = GlobalAlloc(GMEM_FIXED, MAXGETHOSTSTRUCT)
    '
    If lngMemoryHandle > 0 Then
        '
        'Lock the memory block just to get the address
        'of that memory into the lngMemoryPointer variable
        lngMemoryPointer = GlobalLock(lngMemoryHandle)
        '
        If lngMemoryPointer = 0 Then
            '
            'Memory allocation error
            Call GlobalFree(lngMemoryHandle)
            Exit Function
            '
        Else
            'Unlock the memory block
            GlobalUnlock (lngMemoryHandle)
            '
        End If
        '
    Else
        '
        'Memory allocation error
        Exit Function
        '
    End If
    '
    'If this request is the first one, create the collections
    If m_colResolvers Is Nothing Then
        Set m_colMemoryBlocks = New Collection
        Set m_colResolvers = New Collection
    End If
    '
    '------------------------------------------------------------------
    'Added: 09-JULY-2002
    '------------------------------------------------------------------
    Dim strKey As String
    '
    strKey = "S" & CStr(lngObjectPointer)
    '
    Call RemoveIfExists(strKey)
    '------------------------------------------------------------------
    'Remember the memory block location
    m_colMemoryBlocks.Add lngMemoryHandle, strKey
    '
    '------------------------------------------------------------------
    'Modified: 08-JULY-2002
    '------------------------------------------------------------------
    'Here is a major change. Since version 1.0.6 (08-JULY-2002) the
    'SCocket class doesn't try to resolve the IP address into a
    'domain name while connecting.
    '------------------------------------------------------------------
    '
    'Try to get 32-bit address
    'lngAddress = inet_addr(strHostAddress)
    '
    'If lngAddress = INADDR_NONE Then
        '
        'If strHostAddress is not an IP address, try to resolve by name
        lngRequestID = WSAAsyncGetHostByName(p_lngWindowHandle, m_lngResolveMessage, strHostAddress, ByVal lngMemoryPointer, MAXGETHOSTSTRUCT)  'Modified: 04-MAR-2002
        '
    'Else
        '
        'strHostAddress contains an IP address, resolve by address to get a host name
    '    lngRequestID = WSAAsyncGetHostByAddr(p_lngWindowHandle, m_lngResolveMessage, lngAddress, 4&, AF_INET, ByVal lngMemoryPointer, MAXGETHOSTSTRUCT) 'Modified: 04-MAR-2002
        '
    'End If
    '
    '------------------------------------------------------------------
    '
    If lngRequestID <> 0 Then
        '
        'If the call of the WSAAsyncGetHostByXXXX is successful, the
        'lngRequestID variable contains the task ID value.
        'Remember it.
        m_colResolvers.Add lngObjectPointer, "R" & CStr(lngRequestID)
        '
        'Return value
        ResolveHost = lngRequestID
        '
    Else
        '
        'If the call of the WSAAsyncGetHostByXXXX is not successful,
        'remove the item from the m_colMemoryBlocks collection.
        m_colMemoryBlocks.Remove ("S" & CStr(lngObjectPointer))
        '
        'Free allocated memory block
        Call GlobalFree(lngMemoryHandle)
        '
        'If there are no more resolving tasks in progress,
        'destroy the collection objects.
        If m_colResolvers.Count = 0 Then
            Set m_colResolvers = Nothing
            Set m_colMemoryBlocks = Nothing
        End If
        '
        'Set the error info.
        Err.Number = Err.LastDllError
        Err.Description = GetErrorDescription(Err.LastDllError)
        Err.Source = "MSocketSupport.ResolveHost"
        '
    End If
    '
End Function

Private Function CreateWinsockMessageWindow() As Long
'********************************************************************************
'Author    :Oleg Gdalevich
'Date/Time :17-12-2001
'Purpose   :Creates a window to hook the winsock messages
'Returns   :The window handle
'********************************************************************************
    '
    'Create a window. It will be used for hooking messages for registered
    'sockets, and we'll not see this window as the ShowWindow is never called.
    p_lngWindowHandle = CreateWindowEx(0&, "STATIC", "SOCKET_WINDOW", 0&, 0&, 0&, 0&, 0&, 0&, 0&, App.hInstance, ByVal 0&)
    '
    If p_lngWindowHandle = 0 Then
        '
        'I really don't know - is this possible? Probably - yes,
        'due the lack of the system resources, for example.
        '
        'In this case the function returns 0.
        '
    Else
        '
        'Register a callback function for the window created a moment ago in this function
        'm_lngPreviousValue - stores the returned value that is the pointer to the previous
        'callback window function. We'll need this value to destroy the window.
        m_lngPreviousValue = SetWindowLong(p_lngWindowHandle, GWL_WNDPROC, AddressOf WindowProc)
        '
        'Just to let the caller know that the function was executed successfully
        CreateWinsockMessageWindow = p_lngWindowHandle
        '
        'Debug.Print "The window is created: " & p_lngWindowHandle
        '
    End If
    '
End Function


Private Function DestroyWinsockMessageWindow() As Boolean
'********************************************************************************
'Author    :Oleg Gdalevich
'Date/Time :17-12-2001
'Purpose   :Destroyes the window
'Returns   :If the window was destroyed successfully - True.
'********************************************************************************
    '
    On Error GoTo ERR_HANDLER
    '
    'Return the previous window procedure
    SetWindowLong p_lngWindowHandle, GWL_WNDPROC, m_lngPreviousValue
    'Destroy the window
    DestroyWindow p_lngWindowHandle
    '
    'Debug.Print "The window " & p_lngWindowHandle & " is destroyed"
    '
    'Reset the window handle variable
    p_lngWindowHandle = 0
    'If no errors occurred, the function returns True
    DestroyWinsockMessageWindow = True
    '
ERR_HANDLER:

End Function

Private Function SocketObjectFromPointer(ByVal lngPointer As Long) As cSocket
    '
    Dim objSocket As cSocket
    '
    CopyMemory objSocket, lngPointer, 4&
    Set SocketObjectFromPointer = objSocket
    CopyMemory objSocket, 0&, 4&
    '
End Function

Private Function LoWord(lngValue As Long) As Long
   LoWord = (lngValue And &HFFFF&)
End Function

Private Function HiWord(lngValue As Long) As Long
    '
    If (lngValue And &H80000000) = &H80000000 Then
        HiWord = ((lngValue And &H7FFF0000) \ &H10000) Or &H8000&
    Else
        HiWord = (lngValue And &HFFFF0000) \ &H10000
    End If
    '
End Function

Public Function GetErrorDescription(ByVal lngErrorCode As Long) As String
    '
    Dim strDesc As String
    '
    Select Case lngErrorCode
        '
        Case WSAEACCES
            strDesc = "Permission denied."
        Case WSAEADDRINUSE
            strDesc = "Address already in use."
        Case WSAEADDRNOTAVAIL
            strDesc = "Cannot assign requested address."
        Case WSAEAFNOSUPPORT
            strDesc = "Address family not supported by protocol family."
        Case WSAEALREADY
            strDesc = "Operation already in progress."
        Case WSAECONNABORTED
            strDesc = "Software caused connection abort."
        Case WSAECONNREFUSED
            strDesc = "Connection refused."
        Case WSAECONNRESET
            strDesc = "Connection reset by peer."
        Case WSAEDESTADDRREQ
            strDesc = "Destination address required."
        Case WSAEFAULT
            strDesc = "Bad address."
        Case WSAEHOSTDOWN
            strDesc = "Host is down."
        Case WSAEHOSTUNREACH
            strDesc = "No route to host."
        Case WSAEINPROGRESS
            strDesc = "Operation now in progress."
        Case WSAEINTR
            strDesc = "Interrupted function call."
        Case WSAEINVAL
            strDesc = "Invalid argument."
        Case WSAEISCONN
            strDesc = "Socket is already connected."
        Case WSAEMFILE
            strDesc = "Too many open files."
        Case WSAEMSGSIZE
            strDesc = "Message too long."
        Case WSAENETDOWN
            strDesc = "Network is down."
        Case WSAENETRESET
            strDesc = "Network dropped connection on reset."
        Case WSAENETUNREACH
            strDesc = "Network is unreachable."
        Case WSAENOBUFS
            strDesc = "No buffer space available."
        Case WSAENOPROTOOPT
            strDesc = "Bad protocol option."
        Case WSAENOTCONN
            strDesc = "Socket is not connected."
        Case WSAENOTSOCK
            strDesc = "Socket operation on nonsocket."
        Case WSAEOPNOTSUPP
            strDesc = "Operation not supported."
        Case WSAEPFNOSUPPORT
            strDesc = "Protocol family not supported."
        Case WSAEPROCLIM
            strDesc = "Too many processes."
        Case WSAEPROTONOSUPPORT
            strDesc = "Protocol not supported."
        Case WSAEPROTOTYPE
            strDesc = "Protocol wrong type for socket."
        Case WSAESHUTDOWN
            strDesc = "Cannot send after socket shutdown."
        Case WSAESOCKTNOSUPPORT
            strDesc = "Socket type not supported."
        Case WSAETIMEDOUT
            strDesc = "Connection timed out."
        Case WSATYPE_NOT_FOUND
            strDesc = "Class type not found."
        Case WSAEWOULDBLOCK
            strDesc = "Resource temporarily unavailable."
        Case WSAHOST_NOT_FOUND
            strDesc = "Host not found."
        Case WSANOTINITIALISED
            strDesc = "Successful WSAStartup not yet performed."
        Case WSANO_DATA
            strDesc = "Valid name, no data record of requested type."
        Case WSANO_RECOVERY
            strDesc = "This is a nonrecoverable error."
        Case WSASYSCALLFAILURE
            strDesc = "System call failure."
        Case WSASYSNOTREADY
            strDesc = "Network subsystem is unavailable."
        Case WSATRY_AGAIN
            strDesc = "Nonauthoritative host not found."
        Case WSAVERNOTSUPPORTED
            strDesc = "Winsock.dll version out of range."
        Case WSAEDISCON
            strDesc = "Graceful shutdown in progress."
        Case Else
            strDesc = "Unknown error."
    End Select
    '
    GetErrorDescription = strDesc
    '
End Function

Public Function InitWinsockService() As Long
    '
    'This functon does two things; it initializes the Winsock
    'service and returns value of maximum size of the UDP
    'message. Since this module is supposed to serve multiple
    'instances of the CSocket class, this function can be
    'called several times. But we need to call the WSAStartup
    'Winsock API function only once when the first instance of
    'the CSocket class is created.
    '
    Dim lngRetVal       As Long     'value returned by WSAStartup
    Dim strErrorMsg     As String   'error description string
    Dim udtWinsockData  As WSAData  'structure to pass to WSAStartup as an argument
    '
    If Not m_blnWinsockInit Then
        '
        'start up winsock service
        lngRetVal = WSAStartup(&H101, udtWinsockData)
        '
        If lngRetVal <> 0 Then
            '
            'The system cannot load the Winsock library.
            '
            Select Case lngRetVal
                Case WSASYSNOTREADY
                    strErrorMsg = "The underlying network subsystem is not " & _
                                  "ready for network communication."
                Case WSAVERNOTSUPPORTED
                    strErrorMsg = "The version of Windows Sockets API support " & _
                                  "requested is not provided by this particular " & _
                                  "Windows Sockets implementation."
                Case WSAEINVAL
                    strErrorMsg = "The Windows Sockets version specified by the " & _
                                  "application is not supported by this DLL."
            End Select
            '
            Err.Raise Err.LastDllError, "MSocketSupport.InitWinsockService", strErrorMsg
            '
        Else
            '
            'The Winsock library is loaded successfully.
            '
            m_blnWinsockInit = True
            '
            'This function returns returns value of
            'maximum size of the UDP message
            m_lngMaxMsgSize = IntegerToUnsigned(udtWinsockData.iMaxUdpDg)
            InitWinsockService = m_lngMaxMsgSize
            '
            m_lngResolveMessage = RegisterWindowMessage(App.EXEName & ".ResolveMessage")    'Added: 04-MAR-2002
            p_lngWinsockMessage = RegisterWindowMessage(App.EXEName & ".WinsockMessage")    'Added: 04-MAR-2002
            '
            '
        End If
        '
    Else
        '
        'If this function has been called before by another
        'instance of the CSocket class, the code to init the
        'Winsock service must not be executed, but the function
        'returns maximum size of the UDP message anyway.
        InitWinsockService = m_lngMaxMsgSize
        '
    End If
    '
End Function

Public Sub CleanupWinsock()
'********************************************************************************
'This subroutine is called from the Class_Terminate() event
'procedure of any instance of the CSocket class. But the WSACleanup
'Winsock API function is called only if the calling object is the
'last instance of the CSocket class within the current process.
'********************************************************************************
    '
    'If the Winsock library was loaded
    'before and there are no more sockets.
    If m_blnWinsockInit And m_colSockets Is Nothing Then
        '
        'Unload library and free the system resources
        Call WSACleanup
        '
        'Turn off the m_blnWinsockInit flag variable
        m_blnWinsockInit = False
        '
    End If
    '
End Sub

Public Function StringFromPointer(ByVal lPointer As Long) As String
    '
    Dim strTemp As String
    Dim lRetVal As Long
    '
    'prepare the strTemp buffer
    strTemp = String$(lstrlen(ByVal lPointer), 0)
    '
    'copy the string into the strTemp buffer
    lRetVal = lstrcpy(ByVal strTemp, ByVal lPointer)
    '
    'return a string
    If lRetVal Then StringFromPointer = strTemp
    '
End Function

Public Function UnsignedToLong(Value As Double) As Long
    '
    'The function takes a Double containing a value in the 
    'range of an unsigned Long and returns a Long that you 
    'can pass to an API that requires an unsigned Long
    '
    If Value < 0 Or Value >= OFFSET_4 Then Error 6 ' Overflow
    '
    If Value <= MAXINT_4 Then
        UnsignedToLong = Value
    Else
        UnsignedToLong = Value - OFFSET_4
    End If
    '
End Function

Public Function LongToUnsigned(Value As Long) As Double
    '
    'The function takes an unsigned Long from an API and 
    'converts it to a Double for display or arithmetic purposes
    '
    If Value < 0 Then
        LongToUnsigned = Value + OFFSET_4
    Else
        LongToUnsigned = Value
    End If
    '
End Function

Public Function UnsignedToInteger(Value As Long) As Integer
    '
    'The function takes a Long containing a value in the range 
    'of an unsigned Integer and returns an Integer that you 
    'can pass to an API that requires an unsigned Integer
    '
    If Value < 0 Or Value >= OFFSET_2 Then Error 6 ' Overflow
    '
    If Value <= MAXINT_2 Then
        UnsignedToInteger = Value
    Else
        UnsignedToInteger = Value - OFFSET_2
    End If
    '
End Function

Public Function IntegerToUnsigned(Value As Integer) As Long
    '
    'The function takes an unsigned Integer from and API and 
    'converts it to a Long for display or arithmetic purposes
    '
    If Value < 0 Then
        IntegerToUnsigned = Value + OFFSET_2
    Else
        IntegerToUnsigned = Value
    End If
    '
End Function

Private Sub RemoveIfExists(ByVal strKey As String)
    '
    On Error Resume Next
    '
    m_colMemoryBlocks.Remove strKey
    '
End Sub

