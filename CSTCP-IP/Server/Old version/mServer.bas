Attribute VB_Name = "mTcpIpServer"
Option Explicit

'--------------------------------------------------------------------------------
' mServer
' 29-08-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mServer"
' estructuras
' variables privadas
Private m_Sockets()     As Integer
Private m_Socket        As Integer
Private m_SocketBuffer  As SockAddr
Private m_Counter       As Integer
Private m_HostName      As String

Private m_TimerRefresh   As Integer
Private m_TimerRefresh2  As Integer
Private m_TimerRefresh3  As Integer

Private m_Form          As fAux
' Timers
Private m_Timer As cInternalTimer

' eventos
' propiedadades publicas
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function Start(ByRef f As fAux) As Boolean
  On Error GoTo ControlError
  
  m_TimerRefresh = 50
  m_TimerRefresh2 = 6500
  m_TimerRefresh3 = 500
  
  Set m_Form = f
  
  SaveLog "Starting connection to winsock"
  
  Set m_Timer = New cInternalTimer
  
  If Not pStartServer() Then Exit Function
  
  Start = True

  GoTo ExitProc
ControlError:
  MngError Err, "Start", C_Module, ""
  If Err.number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Sub CloseApp()
  On Error GoTo ControlError
    
  Dim i As Integer
  
  SaveLog "destroying timers"
  
  Set m_Timer = Nothing
  
  SaveLog "clossing connection to winsock"
  
  closesocket m_Socket
  
  For i = 0 To UBound(m_Sockets)
    If m_Sockets(i) > 0 Then closesocket m_Sockets(i)
  Next
  
  GoTo ExitProc
ControlError:
  MngError Err, "CloseApp", C_Module, ""
  If Err.number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  SaveLog "clossing service"
  
  Set m_Form = Nothing
End Sub

Public Sub ServerContinue()
  m_Timer.Timer1.Interval = 0
  m_Timer.Timer2.Interval = 0
End Sub

Public Sub ServerPause()
  m_Timer.Timer1.Interval = m_TimerRefresh
End Sub

Public Sub doTimer1()
  Dim rc As Integer
  Dim StartupData As WSADataType
  Dim MsgBuffer As String * 2048
  Dim Regel As String
  Dim MustStop As Boolean
  
  ReDim Preserve m_Sockets(m_Counter + 1)
  m_Sockets(m_Counter + 1) = accept(m_Socket, m_SocketBuffer, Len(m_SocketBuffer))
  DoEvents
  
  If m_Sockets(m_Counter + 1) > 0 Then
    
    m_Counter = m_Counter + 1
      
    m_Timer.Timer1.Interval = m_TimerRefresh2
    m_Timer.Timer2.Interval = m_TimerRefresh3
    
    SaveLog "Socket is Socket2"
    
    If m_Sockets(m_Counter) < 1 Then
      SaveLog "Cannot accept() ..." & _
                          Chr$(13) & Chr$(10) & _
                          GetWSAErrorString(WSAGetLastError())
      closesocket m_Socket
      rc = WSACleanup()
      Exit Sub
    End If

    Regel = "Connected to Server at: " & Time() & Chr(13) & Chr(10)
    rc = send(m_Sockets(m_Counter), ByVal Regel, Len(Regel), 0)
    SaveLog Regel

    Regel = "Attached on machine name: " & pGetHostName() & Chr(13) & Chr(10)
    rc = send(m_Sockets(m_Counter), ByVal Regel, Len(Regel), 0)
    SaveLog Regel
  End If
End Sub

Public Sub doTimer2()
  Dim rc As Integer
  Dim StartupData As WSADataType
  Dim MsgBuffer As String * 2048
  Dim Regel As String
  Dim RegelUit As String
  Dim MustStop As Boolean
  Dim i As Integer
  
  For i = 0 To UBound(m_Sockets)

    If m_Sockets(i) > 0 Then
      Regel = pReadLineFromSocket(m_Sockets(i))
      If Len(Regel) > 0 Then
        SaveLog "<<< " & Regel & vbCrLf
      End If
      Select Case UCase(Left$(Regel, 4))
        Case "DIAL"
            Regel = "DIAL, Dial request. " & Regel
        Case "RSST"
            Regel = "RSST, Ras Status updatae request. " & Regel
        Case "HNGR"
            Regel = "HNGR, Hang up RAS Request. " & Regel
        Case "QUIT"
            Regel = "QUIT, was requested, socket will terminate " & Regel
            MustStop = True
        Case Else
      End Select
    
      If (MustStop = True) Then
        Regel = "We MUST be STOPPED!"
  
        RegelUit = "The Client Disconnected: " & Regel & Chr(13) & Chr(10)
        rc = send(m_Sockets(i), ByVal RegelUit, Len(RegelUit), 0)
        SaveLog RegelUit
        DoEvents
    
        closesocket m_Sockets(i)
      End If
    End If
  Next
End Sub

Public Function MngError(ByRef ErrObj As Object, ByVal FunctionName As String, ByVal Module As String, ByVal InfoAdd As String)
  SaveLog ">>ERROR: " & Err.number & " - " & Err.Description & ";>>FUNCTION: " & FunctionName & ";>>MODULE: " & Module & ";>>INFOADD: " & InfoAdd & ";"
End Function

Public Sub InitLog()
  On Error Resume Next
  FileCopy App.Path & "\CSTCP-IPServer.log", App.Path & "\CSTCP-IPServer-" & Format(Now, "dd-mm-yy hh.nn.ss") & ".log"
  Kill App.Path & "\CSTCP-IPServer.log"
End Sub

Public Sub SaveLog(ByVal Message As String)
  On Error Resume Next
  Dim f As Integer
  f = FreeFile
  Open App.Path & "\CSTCP-IPServer.log" For Append Access Write Shared As #f
  Print #f, Format(Now, "dd/mm/yy hh:nn:ss   ") & Message
  Close f
End Sub
' funciones friend
' funciones privadas
Private Function pStartServer() As Boolean
  On Error GoTo ControlError
  
  Dim rc            As Integer
  Dim StartupData   As WSADataType
  Dim IPAddr        As Long
  Dim SelectOps     As Long
  
  SaveLog "pStartServer working"
  rc = WSAStartup(&H101, StartupData)
  If rc = SOCKET_ERROR Then Exit Function
  
  IPAddr = GetHostByNameAlias(m_HostName)
  If IPAddr = -1 Then
    SaveLog "Unknown m_HostName: " & m_HostName
    Exit Function
  End If
  
  m_Socket = Socket(PF_INET, SOCK_STREAM, 0)  ' AF_INET of PF_INET?
  If m_Socket < 0 Then
    SaveLog "Cannot socket() ..."
    Exit Function
  End If
  
  SaveLog "Number of socket() for Sock = " & m_Socket
  
  m_SocketBuffer.sin_family = AF_INET
  
  ' alternative method GetServiceByName doesn't
  ' seem to work very well ' GetServiceByName("smtp", "TCP")
  m_SocketBuffer.sin_port = htons(4000)
  m_SocketBuffer.sin_addr = htonl(INADDR_ANY)
  
  rc = bind(m_Socket, m_SocketBuffer, Len(m_SocketBuffer))
  If rc Then
    SaveLog "Cannot bind() " & rc & WSAGetLastError() & "..." & _
                        Chr$(13) + Chr$(10) & _
                        GetWSAErrorString(WSAGetLastError())

    closesocket m_Socket
    rc = WSACleanup()
    Exit Function
  End If
  
  SaveLog "bind success"
  
  ' Establish a socket to listen for incoming connection.
  ' listen (ByVal s As Integer, ByVal backlog As Integer) As Integer
  rc = listen(m_Socket, 1)

  If rc Then
    SaveLog "Cannot listen() ..." & _
                        Chr$(13) & Chr$(10) & _
                        GetWSAErrorString(WSAGetLastError())

    closesocket m_Socket
    rc = WSACleanup()
    Exit Function
  End If
  
  SaveLog "listen success"
  
  SelectOps = FD_READ Or FD_WRITE Or FD_CLOSE Or FD_ACCEPT

  'If WSAAsyncSelect(m_Socket, m_Form.hWnd, ByVal 1025, ByVal SelectOps) Then
  If WSAAsyncSelect(m_Socket, 0&, ByVal 1025, ByVal SelectOps) Then
    If m_Socket > 0 Then
      rc = closesocket(m_Socket)
    End If
    SaveLog "Asynchronous error occurred"
    Exit Function
  End If
  
  ' TODO: Prender el timer1
  m_Timer.Timer1.Interval = m_TimerRefresh

  pStartServer = True

  GoTo ExitProc
ControlError:
  MngError Err, "pStartServer", C_Module, ""
  If Err.number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pSendMessage(ByVal Message As String) As Boolean
  On Error GoTo ControlError

  Dim rc          As Integer
  Dim MsgBuffer   As String * 2048
  Dim Regel       As String
  Dim RegelUit    As String
  Dim MustStop    As Boolean
  Dim i           As Integer
  
  For i = 0 To UBound(m_Sockets)
  
    If m_Sockets(i) > 0 Then
    
      Regel = pReadLineFromSocket(m_Sockets(i))
      SaveLog "<<< " & Regel & vbCrLf
      
      '  the following is where i put the ras conditions
      Select Case UCase(Left$(Regel, 4))
        Case "DIAL"
          Regel = "DIAL, Dial request. " & Regel
        Case "RSST"
          Regel = "RSST, Ras Status updatae request. " & Regel
        Case "HNGR"
          Regel = "HNGR, Hang up RAS Request. " & Regel
        Case "QUIT"
          Regel = "QUIT, was requested, socket will terminate " & Regel
          MustStop = True
        Case Else
      End Select
      
      If (MustStop = True) Then
        Regel = Message & " " & Regel
      End If
      
      RegelUit = "Server: " & Message & Chr(13) & Chr(10)
      rc = send(m_Sockets(i), ByVal RegelUit, Len(RegelUit), 0)
      SaveLog RegelUit
      
      DoEvents
      If MustStop Then closesocket m_Sockets(i)
    End If
  Next
    
  pSendMessage = True
    
  ' Esto que sigue no me convece, hay que ver si no esta demas
  
  Regel = pReadLineFromSocket(m_Socket)
  SaveLog "<<< " & Regel & vbCrLf
  
  '  the following is where i put the ras conditions
  Select Case UCase(Left$(Regel, 4))
    Case "DIAL"
      Regel = "DIAL, Dial request. " & Regel
    Case "RSST"
      Regel = "RSST, Ras Status updatae request. " & Regel
    Case "HNGR"
      Regel = "HNGR, Hang up RAS Request. " & Regel
    Case "QUIT"
      Regel = "QUIT, was requested, socket will terminate " & Regel
      MustStop = True
    Case Else
  End Select
  
  If (MustStop = True) Then
      Regel = Message & " " & Regel
  End If
  
  RegelUit = "Server: " & Message & Chr(13) & Chr(10)
  rc = send(m_Socket, ByVal RegelUit, Len(RegelUit), 0)
  SaveLog RegelUit
  
  DoEvents
  If (MustStop = False) Then Exit Function
  
  closesocket m_Socket
  
  GoTo ExitProc
ControlError:
  MngError Err, "pSendMessage", C_Module, ""
  If Err.number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pReadLineFromSocket(ByVal Sock As Integer) As String
  Dim Tekens        As String * 255
  Dim Aantal        As Integer
  Dim Character     As String * 1
  Dim rtn           As String
  
  Do
    Aantal = recv(Sock, ByVal Tekens, 1, 0)  ' Non-Blocking!
    If (Aantal > 0) Then
      Character = Left$(Tekens, Aantal)
      If (Asc(Character) >= Asc(" ")) Then
        rtn = rtn & Character
      End If
    End If
    If Character = "" Then
      Character = Chr(13)
    End If
  Loop While ((Aantal > 0) And (Asc(Character) <> 13))   ' looking for carriage return
  
  pReadLineFromSocket = rtn
End Function

Private Function pGetHostName() As String
  Dim tempstr       As String
  Dim strlen        As Integer
  Dim rtn           As Integer
  Dim StartupData   As WSADataType
  
  rtn = WSAStartup(&H101, StartupData)
  
  If rtn = SOCKET_ERROR Then Exit Function
  
  strlen = 128
  tempstr = Space$(strlen)
  rtn = 0
  rtn = gethostname(tempstr, strlen)
  If rtn = 0 Then
    pGetHostName = Left(Trim$(tempstr), (InStr(Trim$(tempstr), Chr(0)) - 1))
  Else
    pGetHostName = "get_hostname: ERROR"
  End If
  tempstr = ""
End Function

Public Function pGetUserName() As String
  Dim tempstr     As String
  Dim strlen      As Integer
  Dim rtn         As Integer
  Dim lname       As Long
  
  strlen = 128
  tempstr = Space$(strlen)
  rtn = WNetGetUser(lname, tempstr, 128)
  If rtn = 0 Then
    pGetUserName = Trim$(tempstr)
  Else
    pGetUserName = "getusername: ERROR"
  End If
  tempstr = ""
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


