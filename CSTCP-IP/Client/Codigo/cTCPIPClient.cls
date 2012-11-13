VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTCPIPClient"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cTCPIPClient
' 00-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cTCPIPClient"

Private Const c_BOP = "[BOP]"
Private Const c_EOP = "[EOP]"
Private Const c_EOP2 = "[   ]"

Private Const csNoPort = 0

Private Const csMaxBufferSize = 8096
Private Const csMinBufferSize = 1024

Private Const WAIT_TIMEOUT = 258&

Public Enum csSocketStatus
  csSocketClosed = 0
  csSocketOpen = 1
End Enum
' estructuras
' variables privadas
Private m_ServerPort          As Integer
Private m_CommandTimeOut      As Integer
Private m_ServerName          As String
Private m_ClientId            As Integer
Private m_ConnectStatus       As csSocketStatus
Private m_Buffer              As String
Private m_errDescription      As String
Private m_ServerSock          As Long
Private m_fAux                As fAux
Private m_PrevProc            As Long
Private m_ShowLog             As Boolean
Private m_ServiceMng          As cTCPIPManager
Private m_MessageId           As Long
#If Not PREPROC_U Then
  Private m_Received            As Boolean
#End If
Private m_hStopPendingEvent   As Long

Private m_SessionOpen         As Boolean

Private m_PendingPackets      As cPendingPackets

Private m_NoEop2              As Boolean

' eventos
Public Event ReciveText(ByVal buffer As String)

' propiedadades publicas
Public Property Let ShowLog(ByVal rhs As Boolean)
  m_ShowLog = rhs
  If m_ShowLog Then
    m_fAux.Show
  Else
    m_fAux.Hide
  End If
End Property

Public Property Get ShowLog() As Boolean
  ShowLog = m_ShowLog
End Property

Public Property Let NoEOP2(ByVal rhs As Boolean)
  m_NoEop2 = rhs
End Property

Public Property Get NoEOP2() As Boolean
  NoEOP2 = m_NoEop2
End Property

Public Property Get PrevProc() As Long
  PrevProc = m_PrevProc
End Property


Public Property Get ServerPort() As Integer
  ServerPort = m_ServerPort
End Property

Public Property Let ServerPort(ByVal rhs As Integer)
  m_ServerPort = rhs
End Property

Public Property Get ServerName() As String
  ServerName = m_ServerName
End Property

Public Property Let ServerName(ByRef rhs As String)
  m_ServerName = rhs
End Property

Public Property Get DataReceived() As String
  DataReceived = m_Buffer
End Property

Public Property Get CommandTimeOut() As Integer
  CommandTimeOut = m_CommandTimeOut
End Property

Public Property Let CommandTimeOut(ByVal rhs As Integer)
  m_CommandTimeOut = rhs
End Property

Public Property Get ErrDescription() As String
   ErrDescription = m_errDescription
End Property

Public Property Get ConnectStatus() As csSocketStatus
  ConnectStatus = m_ConnectStatus
End Property

Public Property Get ClientId() As Integer
  ClientId = m_ClientId
End Property

' propiedadades friend
' propiedades privadas
Private Property Let ClientId(ByVal rhs As Integer)
  m_ClientId = rhs
  SaveLog "ClientID = " & m_ClientId
End Property

Public Property Let ErrDescription(ByVal rhs As String)
   m_errDescription = rhs
   If m_errDescription <> "" Then
      If m_ShowLog Then
        m_fAux.txLog.Text = m_fAux.txLog.Text & vbCrLf & String(4, ">>") & "Error" & vbCrLf & m_errDescription
      End If
   End If
End Property

' funciones publicas
Public Sub ClearResponse()
  m_Buffer = ""
End Sub

Public Sub TerminateSession()
  On Error GoTo ControlError

  If m_SessionOpen Then

    Disconnect
    CloseWinsock
    
    'stop subclassing
    UnHookForm m_fAux, m_PrevProc
    
    Unload m_fAux
    Set m_fAux = Nothing
    
    Set gfAux = Nothing
    
    Set m_ServiceMng = Nothing
    
    CloseHandle m_hStopPendingEvent
  
    m_SessionOpen = False
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "TerminateSession", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Function SendText(ByVal buffer As String, ByVal ServiceID As Long) As Boolean

  Dim msgErr As String
  
  If m_ShowLog Then
    m_fAux.txLog.Text = m_fAux.txLog.Text & vbCrLf & String(50, "-") & vbCrLf & "Sending" & vbCrLf & buffer
  End If
  
  Dim From      As Long
  Dim TCPIP_ID  As Long
  Dim Msg       As String
  
  m_MessageId = m_MessageId + 1
  
  Do
    Msg = m_ServiceMng.CreateMessageToSend(buffer, From, m_ClientId, m_MessageId, ServiceID, TCPIP_ID)
    
    SaveLog "Sending" & Msg
    
    If SendData(m_ServerSock, Msg) = SOCKET_ERROR Then
      msgErr = "Ha ocurrido una excepcion al enviar datos al servidor. Descripción Tecnica: "
      msgErr = msgErr & WSAGetLastError()
      ErrDescription = msgErr
      If m_ShowLog Then
        m_fAux.txLog.Text = m_fAux.txLog.Text & vbCrLf & String(4, "*") & vbCrLf & "Sending Fail" & vbCrLf & m_errDescription
      End If
      Exit Function
    End If
  
  Loop Until From = 0
  
  If m_ShowLog Then
    m_fAux.txLog.Text = m_fAux.txLog.Text & vbCrLf & String(4, "*") & vbCrLf & "Sending Success"
  End If

  SendText = True
End Function

Public Function SendAndReciveText(ByVal buffer As String, ByVal ServiceID As Long) As Boolean
  If Not SendText(buffer, ServiceID) Then Exit Function
  
  m_Buffer = ""
  
  If Not pReceiveText() Then
    SaveLog "SendAndReciveText: No se recibio respuesta del server, y se esperaba recibir el ClientId"
    Exit Function
  End If
  
  SendAndReciveText = True
End Function

Public Function ConnectToServer(Optional ByVal strServer As String, Optional ByVal iPort As Integer) As Boolean

  If strServer <> "" Then m_ServerName = strServer
  If iPort > 0 Then m_ServerPort = iPort

  Dim msgErr As String

  If m_ConnectStatus <> csSocketClosed Then Exit Function
  If m_ServerPort = csNoPort Then Exit Function

  ErrDescription = ""
  
  SaveLog "Connecting to " & strServer & "-" & iPort
  
  m_ServerSock = ConnectSock(m_ServerName, m_ServerPort, 0, m_fAux.Hwnd, False)

  If m_ServerSock = SOCKET_ERROR Then
    msgErr = "Ha ocurrido una excepción al conectarce al servidor. Descripción técnica: "
    msgErr = msgErr & WSAGetLastError()
    ErrDescription = msgErr
    
    closesocket m_ServerSock
    Exit Function
  End If

  If Not pReceiveText() Then
    SaveLog "ConnectToServer: No se recibio respuesta del server, y se esperaba recibir el ClientId"
    Exit Function
  End If
  
  m_ClientId = Val(m_Buffer)

  m_ConnectStatus = csSocketOpen

  SaveLog "Saliendo con True"
  
  ConnectToServer = True
End Function

Public Function Disconnect() As Boolean
  
  If m_ConnectStatus <> csSocketOpen Then Exit Function

  closesocket m_ServerSock

  m_ConnectStatus = csSocketClosed

  Disconnect = True
End Function

Public Function ReceiveData() As Boolean
  If Not pReceiveText() Then
    SaveLog "ReceiveData: No se recibio respuesta del server, y se esperaba recibir el ClientId"
    Exit Function
  End If
  ReceiveData = True
End Function

' funciones friend
'our Winsock-message handler
Friend Sub ProcessMessage(ByVal lFromSocket As Long, ByVal lParam As Long)

    Dim X As Long, ReadBuffer(1 To 1024) As Byte, strCommand As String
    Select Case lParam
        Case FD_CONNECT 'we are connected to microsoft.com
        Case FD_WRITE 'we can write to our connection
        Case FD_READ 'we have data waiting to be processed
            m_Buffer = ""
            'start reading the data
            Do
                X = recv(lFromSocket, ReadBuffer(1), 1024, 0)
                If X > 0 Then
                    m_Buffer = m_Buffer + Left$(StrConv(ReadBuffer, vbUnicode), X)
                End If
                If X <> 1024 Then Exit Do
            Loop
            
            If m_ShowLog Then
              m_fAux.txLog.Text = m_fAux.txLog.Text & vbCrLf & String(50, "-") & vbCrLf & "Receive" & vbCrLf & m_Buffer
            End If
            
            'MsgBox "haha"
            
            ' Lo primero que recibo es el id de cliente
            If m_ClientId = 0 Then
              
              ClientId = Val(m_Buffer)
              
              RaiseEvent ReciveText(m_Buffer)
            Else
            
              ' Resuelve mensajes partidos
              pReciveText m_Buffer
              
              ' Mantengo en lo posible m_Buffer con el
              ' contenido del ultimo mensaje
              ' Esto se usa para aquellas funciones que consultan
              ' la propiedad DataReceived. Por ejemplo cLogin al
              ' cargar empresas.
              Dim ByteArray() As Byte
              StringToByteArray m_Buffer, ByteArray
              
              If Not m_ServiceMng.IsValid(ByteArray) Then
                SaveLog "Invalid Message: " & m_Buffer
              
              Else
                m_ServiceMng.GetMessage ByteArray
                ByteArrayToString m_Buffer, ByteArray
              End If
            End If
            
            'MsgBox "haha 2"
            
#If Not PREPROC_U Then
            m_Received = True
#Else
            'MsgBox "haha 3"
            gReceived = True
#End If
            
        Case FD_CLOSE 'the connection with microsoft.com is closed
    End Select
End Sub

Private Sub pReciveTextAux(ByRef ByteArray() As Byte)
  Dim Buff As String
  
  If Not m_ServiceMng.IsValid(ByteArray) Then
    ByteArrayToString Buff, ByteArray
    SaveLog "Invalid Message: " & Buff
  
  Else
    m_ServiceMng.GetMessage ByteArray
    
    ByteArrayToString Buff, ByteArray
    
    If m_ShowLog Then
      m_fAux.txLog.Text = m_fAux.txLog.Text & vbCrLf & String(50, "-") & vbCrLf & "Enviando al cliente" & vbCrLf & Buff
    End If
    RaiseEvent ReciveText(Buff)
  End If
End Sub

Private Sub pReciveText(ByVal Buff As String)
  On Error GoTo ControlError
  
' [BOP][id cliente][id mensaje][id de secuencia TCP-IP][id de servicio]mensaje[   ]
' [BOP][id cliente][id mensaje][id de secuencia TCP-IP]mensaje[   ]
' [BOP][id cliente][id mensaje][id de secuencia TCP-IP]mensaje[EOP]
' 1    2           3           4                        5
'     1           2           3                     4               5
  
  Dim v()      As String
  Dim i        As Integer
  Dim endstr   As String
  Dim beginstr As String
  Dim c        As cPendingPacket
  Dim ByteArrayAux() As Byte
  
  Const c_splitchar = "||@@"
  
  Buff = Replace(Buff, c_BOP, c_splitchar & c_BOP, , , vbTextCompare)
  v = Split(Buff, c_splitchar)
    
  'Debug.Print "jaja"
    
  For i = 0 To UBound(v)
  
    If LenB(v(i)) Then
  
      beginstr = Left(v(i), Len(c_BOP))
      endstr = Right$(v(i), Len(c_EOP))
      
      ' Si no contiene el principio es por
      ' que se trata de la cola de un bloque
      ' que esta en m_PendingPackets
            
      If beginstr <> c_BOP Then
        
        If m_PendingPackets.Count = 0 Then
          SaveLog "Se recibio un mensaje sin principio"
          SaveLog "y no se encuentra el principio en m_PendingPackets"
          SaveLog "Mensaje recibido:" & v(i)
          Exit For
        Else
          v(i) = c.strBuff
        End If
      End If
      
      If endstr = c_EOP Or (endstr = c_EOP2 And m_NoEop2 = False) Then
        
        If m_PendingPackets.Count Then
        
          Dim tmpBuff As String
          
          Debug.Print v(i)
          
          tmpBuff = pDiscardBeginMessage(v(i))
          v(i) = vbNullString
          
          For Each c In m_PendingPackets
          
            v(i) = v(i) & c.strBuff
            
            Debug.Print c.strBuff
          Next
          
          v(i) = v(i) & tmpBuff
          m_PendingPackets.Clear
          
        End If
        
        StringToByteArray v(i), ByteArrayAux
        pReciveTextAux ByteArrayAux
        
        '
        ' NOTA: 2009-09-25
        '
        ' SI OCURRE UN BUG ESTE ES EL CULPABLE
        '
        ' WARNING BUG
        '
        ' Si el mensaje estaba partido
        ' actualizo m_Buffer para que
        ' contenga el bloque completo
        '
        m_Buffer = v(i)
        
      Else
      
        If m_PendingPackets.Count Then
          v(i) = pDiscardBeginMessage(v(i))
        End If
      
        Set c = m_PendingPackets.Add(Nothing)
        If endstr = c_EOP2 Then
          c.strBuff = Left$(v(i), Len(v(i)) - Len(c_EOP))
        Else
          c.strBuff = v(i)
        End If
      End If
    End If
  Next
  
  GoTo ExitProc
ControlError:
  MngError Err, "pReciveText", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' funciones privadas
Private Function pReceiveText() As Boolean
  
#If Not PREPROC_U Then
  m_Received = False
#Else
  gReceived = False
#End If

  m_hStopPendingEvent = CreateEvent(0, 1, 0, vbNullString)
  
  Dim Time As Single
  
  Time = Timer
  
  Do
      ' ******************
      ' It is main service loop. Here you may place statements
      ' which perform useful functionality of this service.
      ' ******************
      DoEvents: DoEvents: DoEvents
      
      If Not m_ShowLog Then
        m_fAux.txLog.Text = "1"
      End If
      
#If Not PREPROC_U Then
      If m_Received Then Exit Do
#Else
      If gReceived Then Exit Do
#End If
      If Timer - Time > m_CommandTimeOut Then GoTo ExitProc
      
      ' Loop repeats every second. You may change this interval.
  Loop While WaitForSingleObject(m_hStopPendingEvent, 100&) = WAIT_TIMEOUT
  
  'MsgBox "haha 5" & gReceived
  
  pReceiveText = True
  
ExitProc:
  
  CloseHandle m_hStopPendingEvent

  'MsgBox "haha 5" & gReceived
  
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  InitLog

  m_SessionOpen = True
  
  m_CommandTimeOut = 10
  
  Set m_ServiceMng = New cTCPIPManager
  Set m_PendingPackets = New cPendingPackets
  
  OpenWinsock
  Set m_fAux = New fAux
  Load m_fAux
  
  'ShowLog = True
  
  'start subclassing
  HookForm m_fAux, Me, m_PrevProc

  Set gfAux = m_fAux

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  TerminateSession

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pDiscardBeginMessage(ByVal buffer As String) As String
  Dim c As String
  Dim i As Long
  
  Dim nBlock        As Long
  Dim nBeginMessage As Long
  Dim endstr        As String
  Dim bFound        As Boolean
  
  Const c_fix_block = 4
  
  endstr = Right$(buffer, Len(c_EOP))
  
  If endstr = c_EOP Or endstr = c_EOP2 Then
    buffer = Mid$(buffer, 1, Len(buffer) - Len(c_EOP))
  Else
    endstr = vbNullString
  End If
  
  For i = 1 To Len(buffer)
    c = Mid$(buffer, i, 1)
    If c = "]" Then
      nBlock = nBlock + 1
      If nBlock = c_fix_block Then
        nBeginMessage = i + 1
        bFound = True
        Exit For
      End If
    End If
  Next
  
  If Not bFound Then nBeginMessage = 1
  pDiscardBeginMessage = Mid$(buffer, nBeginMessage, Len(buffer)) & endstr
  
End Function

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


