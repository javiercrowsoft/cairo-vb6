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
Attribute VB_Creatable = True
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

' constantes
Private Const C_Module = "cAfip"
' estructuras
' variables privadas
Private m_bInProcess          As Boolean
Private m_id                  As Long
Private m_bComplete           As Boolean

Private m_bSuccess            As Boolean
Private m_errorMsg            As String

Private WithEvents m_Timer    As cTimer
Attribute m_Timer.VB_VarHelpID = -1

' eventos
' propiedadades publicas
Public Property Get ErrorMsg() As String
  ErrorMsg = m_errorMsg
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function GetConstancia(ByVal cuit As String, ByVal folder As String)
  On Error GoTo ControlError
  
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  m_bSuccess = False
  
  sqlstmt = "sp_srv_afip_insertCuit '" & Replace(cuit, "'", "''") & "','" & Replace(folder, "'", "''") & "'"
  
  pSaveLog "Buscando constancia para " & sqlstmt
  
  If Not pOpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  m_id = rs.Fields("id").Value
  
  Set m_Timer = New cTimer
  m_Timer.Interval = 2000

  Dim t As Single
  t = Timer

  Do
    DoEvents: DoEvents: DoEvents
    If Timer - t > 120 Then
      Set m_Timer = Nothing
      m_errorMsg = "Time out. Pasaron los 2 minutos de espera."
      Exit Do
    End If
  Loop Until m_bComplete
  
  Sleep 1500
  
  GetConstancia = m_bSuccess

  GoTo ExitProc
ControlError:
  m_errorMsg = Err.Description
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' funciones friend
' funciones privadas
Private Function pOpenRs(ByVal sqlstmt As String, ByRef rs As ADODB.Recordset) As Boolean
  Dim cn As ADODB.Connection
  Dim connstr As String
  
  pSaveLog "Llamada a Process"
  
  connstr = IniGet(c_K_connstr, "")
  If connstr = "" Then
    pSaveLog "No se indico un string de conexion en el archivo " & GetFullIniFileName()
    Exit Function
  End If
  
  pSaveLog "Abriendo conexion a " & connstr
  
  Set cn = New ADODB.Connection
  cn.Open connstr
  
  Set rs = New ADODB.Recordset
  rs.CursorLocation = adUseClient
  rs.Open sqlstmt, cn, adOpenStatic
  
  Set rs.ActiveConnection = Nothing
  
  pOpenRs = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  m_logFile = IniGet(c_K_Log, pGetPath(App.path) & "CSAfipWebClient.log")

  pSaveLog "Server Start"

  GoTo ExitProc
ControlError:
  m_errorMsg = Err.Description
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
  m_errorMsg = Err.Description
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  m_bInProcess = False
End Sub

Private Sub pProcess()
  Dim rs As ADODB.Recordset
  Dim sqlstmt As String
  
  pSaveLog "Llamada a Process"
  
  sqlstmt = "sp_srv_afip_getCuit " & m_id
  
  If Not pOpenRs(sqlstmt, rs) Then Exit Sub
  
  If rs.EOF Then Exit Sub
  
  If rs.Fields("pendiente").Value <> 0 Then Exit Sub
  
  m_bSuccess = rs.Fields("success").Value
  m_errorMsg = rs.Fields("error").Value
  m_bComplete = True
  Set m_Timer = Nothing
  
End Sub

Private Function pGetConstancia(ByVal cuit As String, ByVal folder As String, ByRef ErrorMsg As String) As Boolean
  On Error GoTo ControlError
  
  ErrorMsg = ""
  
  Dim o
  Set o = CreateObject("CSGetConstanciaAFIP.cAfipPage")

  o.GetAFIPConstacia cuit, folder

  pGetConstancia = True

  GoTo ExitProc
ControlError:
  m_errorMsg = Err.Description
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub Class_Terminate()
  On Error GoTo ControlError

  pSaveLog "Server Stop"
  
  Set m_Timer = Nothing
  
  GoTo ExitProc
ControlError:
  m_errorMsg = Err.Description
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

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

