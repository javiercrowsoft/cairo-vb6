Attribute VB_Name = "mPublic"
Option Explicit

Public Const csNoDate                           As Date = #1/1/1900#
Public Const C_PSqlFechaHora                    As String = "\'yyyymmdd HH:nn:ss\'"   'MS SQLServer

Public Function GetMacAddressFromServer(ByRef strCode As String, ByRef ErrorMsg As String) As Boolean
  Dim Buffer        As String
  Dim Message       As String
  Dim DataReceived  As String
  
  Buffer = TCPGetMessage(cTCPCommandCodigoMacAddress, ClientProcessId, Message)
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  DataReceived = fMain.Client.DataReceived
  
  If TCPError(DataReceived) Then
    MsgError GetErrorMessage(DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(DataReceived)
  If TCPGetFail(DataReceived) Then
    ErrorMsg = Buffer
    Exit Function
  End If
  
  strCode = Buffer
  
  GetMacAddressFromServer = True
End Function

Public Function GetConnstrToDomain(ByRef strConnect As String, ByRef ErrorMsg As String) As Boolean
  Dim Buffer        As String
  Dim Message       As String
  Dim DataReceived  As String
  
  Buffer = TCPGetMessage(cTCPCommandGetConnectStrDom2, ClientProcessId, Message)
  If Not fMain.Client.SendAndReciveText(Buffer, SRV_ID_SERVER) Then Exit Function
  
  DataReceived = fMain.Client.DataReceived
  
  If TCPError(DataReceived) Then
    MsgError GetErrorMessage(DataReceived)
    Exit Function
  End If
  
  Buffer = TCPGetResponse(DataReceived)
  If TCPGetFail(DataReceived) Then
    ErrorMsg = Buffer
    Exit Function
  End If
  
  strConnect = Decript(Buffer, c_LoginSignature)
  
  GetConnstrToDomain = True
End Function

Public Function GetDataBase() As cDataBase
  Dim db        As cDataBase
  Dim Connstr   As String
  Dim ErrorMsg  As String
  
  If Not GetConnstrToDomain(Connstr, ErrorMsg) Then
    CSKernelClient2.MsgWarning ErrorMsg, "Empresas"
  End If

  Set db = New cDataBase
  If Not db.InitDB(, , , , Connstr) Then Exit Function

  Set GetDataBase = db
End Function

Public Function GetActiveCode(ByRef strCode As String) As Boolean
  Dim sqlstmt   As String
  Dim db        As cDataBase
  Dim Connstr   As String
  Dim ErrorMsg  As String
  Dim rs        As ADODB.Recordset

  If Not GetConnstrToDomain(Connstr, ErrorMsg) Then
    CSKernelClient2.MsgWarning ErrorMsg, "Código de Activación"
    Exit Function
  Else
    Set db = New cDataBase
    
    If Not db.InitDB(, , , , Connstr) Then Exit Function
    sqlstmt = "select si_valor from sistema where si_clave = " & db.sqlString(c_CodigoActivacion)
    
    If Not db.OpenRs(sqlstmt, rs) Then Exit Function
    
    If rs.EOF Then Exit Function
      
    strCode = rs.Fields.Item(0).Value
  End If
  
  GetActiveCode = True
End Function

