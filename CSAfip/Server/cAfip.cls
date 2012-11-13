VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAfip"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cAfip
' 01-11-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' Interfaces
Implements cIService

' constantes
Private Const C_Module = "cAfip"
' estructuras
' variables privadas
Private m_ServiceID           As Long
Private m_Server              As cIServer
Private m_StatusCode          As Long
Private m_DateActive          As Date
Private m_logFile             As String
Private m_bInProcess          As Boolean

Private WithEvents m_Timer    As cTimer
Attribute m_Timer.VB_VarHelpID = -1

' eventos
' propiedadades publicas
Private Property Let cIService_ServiceID(ByVal rhs As Long)
  m_ServiceID = rhs
End Property

Private Property Get cIService_ServiceID() As Long
  cIService_ServiceID = m_ServiceID
End Property

Private Property Set cIService_Server(rhs As CSIService.cIServer)
  Set m_Server = rhs
End Property

Private Property Get cIService_Server() As CSIService.cIServer
  Set cIService_Server = m_Server
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub cIService_ClientShutDown(ByVal ClientId As Long)
End Sub

Private Sub cIService_WndProc(ByVal ClientId As Long, Message() As Byte, Response() As Byte)
  On Error GoTo ControlError

  Dim sMessage          As String
  Dim ErrDescription    As String
  Dim ClientProcess     As Long
  
  m_Server.ByteArrayToString sMessage, Message

  ClientProcess = pGetClientProcess(sMessage)
  
  Select Case TCPGetTypeMessage(sMessage)
    
    Case Else
            
      ' No esta implementado
  
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIService_WndProc", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
  m_Server.StringToByteArray c_ErrorCode & gErrorInfo, Response
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetClientProcess(ByVal sMessage As String) As Long
  pGetClientProcess = Val(Right$(sMessage, c_Len_ProcessId))
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  m_ServiceID = SRV_ID_SERVER

  m_logFile = IniGet(c_K_Log, pGetPath(App.path) & "CSAFIP.log")

  pSaveLog "Server Start"

  Set m_Timer = New cTimer
  m_Timer.Interval = 3000

  Set m_Server = gServer
  gServiceCreated = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_Timer_ThatTime()
  On Error GoTo ControlError
  
  If m_bInProcess Then Exit Sub
  
  m_bInProcess = True
  
  pProcess

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  m_bInProcess = False
End Sub

Private Sub pProcess()
  Dim rs As ADODB.Recordset
  Dim cn As ADODB.Connection
  Dim sqlstmt As String
  Dim connstr As String
  
  connstr = IniGet(c_K_connstr, "")
  If connstr = "" Then
    pSaveLog "No se indico un string de conexion en el archivo " & GetFullIniFileName()
    Exit Sub
  End If
  
  Set cn = New ADODB.Connection
  cn.Open connstr
  
  sqlstmt = "sp_srv_afip_getCuits"
  
  Set rs = New ADODB.Recordset
  rs.CursorLocation = adUseClient
  rs.Open sqlstmt, cn, adOpenStatic
  
  Set rs.ActiveConnection = Nothing
  
  If rs.EOF Then Exit Sub
  
  Dim errormsg As String
  
  While Not rs.EOF
    If pGetConstancia(rs.Fields("cuit"), rs.Fields("folder"), errormsg) Then
      sqlstmt = "sp_srv_afip_updateCuit " & rs.Fields("id") & ",1,''"
    Else
      sqlstmt = "sp_srv_afip_updateCuit " & rs.Fields("id") & ",0,'" & Replace(errormsg, "'", "''") & "'"
    End If
    cn.Execute sqlstmt
    rs.MoveNext
  Wend
  
End Sub

Private Function pGetConstancia(ByVal cuit As String, ByVal folder As String, ByRef errormsg As String) As Boolean
  On Error GoTo ControlError
  
  errormsg = ""
  
  Dim o
  Set o = CreateObject("CSGetConstanciaAFIP.cAfipPage")

  o.GetAFIPConstacia cuit, folder

  pGetConstancia = True

  GoTo ExitProc
ControlError:
  errormsg = Err.Description
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub Class_Terminate()
  On Error GoTo ControlError

  pSaveLog "Server Stop"
  
  Set m_Server = Nothing
  Set m_Timer = Nothing
  gServiceCreated = False
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSaveLog(ByVal msg As String)
  On Error Resume Next
  Dim f As Integer
  f = FreeFile
  Open m_logFile For Append As f
  Print #f, Now & " " & msg
  Close f
End Sub

Private Function pGetPath(ByVal path As String) As String
  If Right(path, 1) <> "\" Then path = path & "\"
  pGetPath = path
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
