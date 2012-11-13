Attribute VB_Name = "mApi"
Option Explicit
'--------------------------------------------------------------------------------
' mApi
' 08-04-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
      Public Const SO_RCVBUF = &H1002
      Public Const SO_SNDBUF = &H1001
      Public Const AF_INET = 2
      Public Const INVALID_SOCKET = -1
      Public Const SOCKET_ERROR = -1
      Public Const FD_READ = &H1&
      Public Const FD_WRITE = &H2&
      Public Const FD_CONNECT = &H10&
      Public Const FD_CLOSE = &H20&
      Public Const PF_INET = 2
      Public Const SOCK_STREAM = 1
      Public Const IPPROTO_TCP = 6
      Public Const GWL_WNDPROC = (-4)
      Public Const WINSOCKMSG = 1025
      Public Const WSA_DESCRIPTIONLEN = 256
      Public Const WSA_DescriptionSize = WSA_DESCRIPTIONLEN + 1
      Public Const WSA_SYS_STATUS_LEN = 128
      Public Const WSA_SysStatusSize = WSA_SYS_STATUS_LEN + 1
      Public Const INADDR_NONE = &HFFFF
      Public Const SOL_SOCKET = &HFFFF&
      Public Const SO_LINGER = &H80&
      Public Const hostent_size = 16
      Public Const sockaddr_size = 16
          
          
    ' estructuras
      Type WSADataType
        wVersion As Integer
        wHighVersion As Integer
        szDescription As String * WSA_DescriptionSize
        szSystemStatus As String * WSA_SysStatusSize
        iMaxSockets As Integer
        iMaxUdpDg As Integer
        lpVendorInfo As Long
      End Type
      Type HostEnt
        h_name As Long
        h_aliases As Long
        h_addrtype As Integer
        h_length As Integer
        h_addr_list As Long
      End Type
      Type sockaddr
        sin_family As Integer
        sin_port As Integer
        sin_addr As Long
        sin_zero As String * 8
      End Type
      Type LingerType
        l_onoff As Integer
        l_linger As Integer
      End Type
    ' funciones
      Public Declare Function setsockopt Lib "wsock32.dll" (ByVal s As Long, ByVal Level As Long, ByVal optname As Long, optval As Any, ByVal optlen As Long) As Long
      Public Declare Function getsockopt Lib "wsock32.dll" (ByVal s As Long, ByVal Level As Long, ByVal optname As Long, optval As Any, optlen As Long) As Long
      Public Declare Function WSAGetLastError Lib "wsock32.dll" () As Long
      Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal Hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
      Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal Hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
      Public Declare Function WSAIsBlocking Lib "wsock32.dll" () As Long
      Public Declare Function WSACleanup Lib "wsock32.dll" () As Long
      Public Declare Function Send Lib "wsock32.dll" Alias "send" (ByVal s As Long, buf As Any, ByVal buflen As Long, ByVal flags As Long) As Long
      Public Declare Function recv Lib "wsock32.dll" (ByVal s As Long, buf As Any, ByVal buflen As Long, ByVal flags As Long) As Long
      Public Declare Function WSAStartup Lib "wsock32.dll" (ByVal wVR As Long, lpWSAD As WSADataType) As Long
      Public Declare Function htons Lib "wsock32.dll" (ByVal hostshort As Long) As Integer
      Public Declare Function ntohs Lib "wsock32.dll" (ByVal netshort As Long) As Integer
      Public Declare Function Socket Lib "wsock32.dll" Alias "socket" (ByVal af As Long, ByVal s_type As Long, ByVal protocol As Long) As Long
      Public Declare Function closesocket Lib "wsock32.dll" (ByVal s As Long) As Long
      Public Declare Function Connect Lib "wsock32.dll" Alias "connect" (ByVal s As Long, addr As sockaddr, ByVal namelen As Long) As Long
      Public Declare Function WSAAsyncSelect Lib "wsock32.dll" (ByVal s As Long, ByVal Hwnd As Long, ByVal wMsg As Long, ByVal lEvent As Long) As Long
      Public Declare Function inet_addr Lib "wsock32.dll" (ByVal cp As String) As Long
      Public Declare Function gethostbyname Lib "wsock32.dll" (ByVal host_name As String) As Long
      Public Declare Sub MemCopy Lib "kernel32" Alias "RtlMoveMemory" (Dest As Any, Src As Any, ByVal cb&)
      Public Declare Function inet_ntoa Lib "wsock32.dll" (ByVal inn As Long) As Long
      Public Declare Function lstrlen Lib "kernel32" Alias "lstrlenA" (ByVal lpString As Any) As Long
      Public Declare Function WSACancelBlockingCall Lib "wsock32.dll" () As Long
      Public Declare Function GetProp Lib "user32" Alias "GetPropA" (ByVal Hwnd As Long, ByVal lpString As String) As Long
      Public Declare Function SetProp Lib "user32" Alias "SetPropA" (ByVal Hwnd As Long, ByVal lpString As String, ByVal hData As Long) As Long
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mApi"


' estructuras
' variables privadas
Private m_NextKey As Long
Private m_CollObjects As Collection
Private m_NumObjects As Long
' eventos
' propiedadades publicas
Public saZero         As sockaddr
Public WSAStartedUp   As Boolean
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Sub UnHookForm(f As Form, ByRef PrevProc As Long)
  Dim c As Long
  
  c = GetProp(f.Hwnd, "Client_" & f.Hwnd)
  
  Debug.Assert c <> 0
  
  m_CollObjects.Remove GetKey(c)

  If PrevProc <> 0 Then
    SetWindowLong f.Hwnd, GWL_WNDPROC, PrevProc
    PrevProc = 0
  End If
End Sub

Public Function HookForm(f As Form, ByRef Obj As cTCPIPClient, ByRef PrevProc As Long) As Boolean
  
  If Obj Is Nothing Then Exit Function
  
  If m_CollObjects Is Nothing Then Set m_CollObjects = New Collection

  PrevProc = SetWindowLong(f.Hwnd, GWL_WNDPROC, AddressOf WindowProc)
  
  If PrevProc = 0 Then ErrRaise csCantSubclass
  
  m_NextKey = m_NextKey + 1
  m_CollObjects.Add Obj, GetKey(m_NextKey)
  
  ' Associate old procedure with handle
  Dim c As Long
  c = SetProp(f.Hwnd, "Client_" & f.Hwnd, m_NextKey)
  Debug.Assert c <> 0
  
  HookForm = True
End Function

Public Sub ErrRaise(ByVal ErrorCode As csClientErrors)
  Select Case ErrorCode
    Case csCantSubclass
      Err.Raise ErrorCode, App.EXEName, "No se puede utilizar el metodo de 'SubClassing'."
    Case Else
      Err.Raise ErrorCode, App.EXEName, "Error no definido"
  End Select
End Sub

Public Sub OpenWinsock()
  If m_NumObjects = 0 Then
    'create a new winsock session
    StartWinsock ""
  End If
  m_NumObjects = m_NumObjects + 1
End Sub

Public Sub CloseWinsock()
  m_NumObjects = m_NumObjects - 1

  If m_NumObjects = 0 Then
    'end winsock session
    EndWinsock
  End If
End Sub

Public Function WindowProc(ByVal Hwnd As Long, ByVal uMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    If uMsg = WINSOCKMSG Then
        pGetObject(Hwnd).ProcessMessage wParam, lParam
    Else
        WindowProc = CallWindowProc(pGetObject(Hwnd).PrevProc, Hwnd, uMsg, wParam, lParam)
    End If
End Function

'the following functions are standard WinSock functions
'from the wsksock.bas-file
Public Function StartWinsock(sDescription As String) As Boolean
    Dim StartupData As WSADataType
    If Not WSAStartedUp Then
        If Not WSAStartup(&H101, StartupData) Then
            WSAStartedUp = True
            sDescription = StartupData.szDescription
        Else
            WSAStartedUp = False
        End If
    End If
    StartWinsock = WSAStartedUp
End Function

Sub EndWinsock()
    Dim Ret&
    If WSAIsBlocking() Then
        Ret = WSACancelBlockingCall()
    End If
    Ret = WSACleanup()
    WSAStartedUp = False
End Sub

Public Function SendData(ByVal s&, vMessage As Variant) As Long
    Dim TheMsg() As Byte, sTemp$
    TheMsg = ""
    Select Case VarType(vMessage)
        Case 8209   'byte array
            sTemp = vMessage
            TheMsg = sTemp
        Case 8      'string, if we recieve a string, its assumed we are linemode
            sTemp = StrConv(vMessage, vbFromUnicode)
        Case Else
            sTemp = CStr(vMessage)
            sTemp = StrConv(vMessage, vbFromUnicode)
    End Select
    TheMsg = sTemp
    
    If UBound(TheMsg) > -1 Then
        SendData = Send(s, TheMsg(0), (UBound(TheMsg) - LBound(TheMsg) + 1), 0)
    End If
End Function

Public Function ConnectSock(ByVal Host As String, ByVal Port As Long, retIpPort As String, ByVal HWndToMsg As Long, ByVal Async As Integer) As Long
    Dim s               As Long
    Dim SelectOps       As Long
    Dim Dummy           As Long
    Dim sockin          As sockaddr
    Dim SockReadBuffer  As String
    
    SaveLog "Connection to server: " & Host & " port: " & Port
    
    SockReadBuffer = ""
    sockin = saZero
    sockin.sin_family = AF_INET
    sockin.sin_port = htons(Port)
    If sockin.sin_port = INVALID_SOCKET Then
        ConnectSock = INVALID_SOCKET
        Exit Function
    End If

    SaveLog "Sin Port: " & sockin.sin_port

    sockin.sin_addr = GetHostByNameAlias(Host$)

    If sockin.sin_addr = INADDR_NONE Then
        ConnectSock = INVALID_SOCKET
        Exit Function
    End If
    
    SaveLog "Sin Address: " & sockin.sin_addr
    
    retIpPort$ = getascip$(sockin.sin_addr) & ":" & ntohs(sockin.sin_port)
    
    SaveLog "IpPort: " & retIpPort$

    s = Socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)
    If s < 0 Then
        ConnectSock = INVALID_SOCKET
        Exit Function
    End If
    
    SaveLog "Socket successfuly created"
    
    If SetSockLinger(s, 1, 0) = SOCKET_ERROR Then
        If s > 0 Then
            Dummy = closesocket(s)
        End If
        ConnectSock = INVALID_SOCKET
        Exit Function
    End If
    
    If Not Async Then
        If Connect(s, sockin, sockaddr_size) <> 0 Then
            If s > 0 Then
                Dummy = closesocket(s)
            End If
            ConnectSock = INVALID_SOCKET
            Exit Function
        End If
        SelectOps = FD_READ Or FD_WRITE Or FD_CONNECT Or FD_CLOSE
        If WSAAsyncSelect(s, HWndToMsg, ByVal 1025, ByVal SelectOps) Then
            If s > 0 Then
                Dummy = closesocket(s)
            End If
            ConnectSock = INVALID_SOCKET
            Exit Function
        End If
    Else
        SelectOps = FD_READ Or FD_WRITE Or FD_CONNECT Or FD_CLOSE
        If WSAAsyncSelect(s, HWndToMsg, ByVal 1025, ByVal SelectOps) Then
            If s > 0 Then
                Dummy = closesocket(s)
            End If
            ConnectSock = INVALID_SOCKET
            Exit Function
        End If
        If Connect(s, sockin, sockaddr_size) <> -1 Then
            If s > 0 Then
                Dummy = closesocket(s)
            End If
            ConnectSock = INVALID_SOCKET
            Exit Function
        End If
    End If
    
    SaveLog "Connect success"
    
    ConnectSock = s
End Function

Function GetHostByNameAlias(ByVal hostname$) As Long
    On Error Resume Next
    Dim phe&
    Dim heDestHost As HostEnt
    Dim addrList&
    Dim retIP&
    retIP = inet_addr(hostname)
    If retIP = INADDR_NONE Then
        phe = gethostbyname(hostname)
        If phe <> 0 Then
            MemCopy heDestHost, ByVal phe, hostent_size
            MemCopy addrList, ByVal heDestHost.h_addr_list, 4
            MemCopy retIP, ByVal addrList, heDestHost.h_length
        Else
            retIP = INADDR_NONE
        End If
    End If
    GetHostByNameAlias = retIP
    If Err Then GetHostByNameAlias = INADDR_NONE
End Function

Function getascip(ByVal inn As Long) As String
    On Error Resume Next
    Dim lpStr&
    Dim nStr&
    Dim retString$
    retString = String(32, 0)
    lpStr = inet_ntoa(inn)
    If lpStr = 0 Then
        getascip = "255.255.255.255"
        Exit Function
    End If
    nStr = lstrlen(lpStr)
    If nStr > 32 Then nStr = 32
    MemCopy ByVal retString, ByVal lpStr, nStr
    retString = Left(retString, nStr)
    getascip = retString
    If Err Then getascip = "255.255.255.255"
End Function

Public Function SetSockLinger(ByVal SockNum&, ByVal OnOff%, ByVal LingerTime%) As Long
    Dim Linger As LingerType
    Linger.l_onoff = OnOff
    Linger.l_linger = LingerTime
    If setsockopt(SockNum, SOL_SOCKET, SO_LINGER, Linger, 4) Then
        Debug.Print "Error setting linger info: " & WSAGetLastError()
        SetSockLinger = SOCKET_ERROR
    Else
        If getsockopt(SockNum, SOL_SOCKET, SO_LINGER, Linger, 4) Then
            Debug.Print "Error getting linger info: " & WSAGetLastError()
            SetSockLinger = SOCKET_ERROR
        End If
    End If
End Function

Public Function Min(ByVal a As Long, ByVal b As Long) As Long
  If a < b Then
    Min = a
  Else
    Min = b
  End If
End Function
' funciones friend
' funciones privadas
Private Function pGetObject(ByVal Hwnd As Long) As cTCPIPClient
  Dim c As Long
  
  c = GetProp(Hwnd, "Client_" & Hwnd)
  
  Debug.Assert c <> 0
  
  Set pGetObject = m_CollObjects(GetKey(c))
End Function
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
