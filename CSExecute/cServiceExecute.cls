VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cServiceExecute"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cServiceExecute
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
Private Const C_Module = "cServiceExecute"

Private Const c_SHELL = "SHELL:"
Private Const c_TARJETON = "TARJE:"
Private Const c_Len_Type = 6
' estructuras
' variables privadas
Private m_ServiceID   As Long
Private m_Server      As cIServer
Private m_db          As cDataSource
' eventos
' propiedadades publicas
Private Property Let cIService_ServiceID(ByVal RHS As Long)
  m_ServiceID = RHS
End Property

Private Property Get cIService_ServiceID() As Long
  cIService_ServiceID = m_ServiceID
End Property

Private Property Set cIService_Server(RHS As CSIService.cIServer)
  Set m_Server = RHS
End Property

Private Property Get cIService_Server() As CSIService.cIServer
  Set cIService_Server = m_Server
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas

Private Function pGetTipeMessage(ByVal Message As String) As String
  pGetTipeMessage = Mid(Message, 1, c_Len_Type)
End Function

Private Function pGetMessage(ByVal Message As String) As String
  pGetMessage = Mid(Message, c_Len_Type + 1)
End Function

Private Sub cIService_ClientShutDown(ByVal ClientID As Long)

End Sub

Private Sub cIService_WndProc(ByVal ClientID As Long, Message() As Byte, Response() As Byte)
  On Error GoTo ControlError

  Dim sMessage As String
  Dim ErrDescription As String
  
  m_Server.ByteArrayToString sMessage, Message

  Select Case pGetTipeMessage(sMessage)
    Case c_SHELL
      If ShellExecute(pGetMessage(sMessage), vbNormalNoFocus) Then
        sMessage = "-1"
        SaveLog "Impresion exitosa"
      Else
        sMessage = "0 - " & gErrorInfo
        SaveLog "Impresion Fallida"
      End If
      
      SaveLog "Respuesta: " & sMessage
      
      m_Server.StringToByteArray sMessage, Response
    
    Case c_TARJETON
      Dim shelstmt As String
      
      SaveLog "Imprimiendo el tarjeton"
      
      If pGetTarjeton(shelstmt, sMessage) Then
      
        If ShellExecute(shelstmt, vbNormalFocus) Then
'        Dim DriverName  As String
'        Dim PrinterName As String
'        Dim PortName    As String
'
'        DriverName = IniGet(c_k_DriverName, "")
'        PrinterName = IniGet(c_k_PrinterName, "")
'        PortName = IniGet(c_k_PortName, "")
'
'        If DllMain(shelstmt, DriverName, PrinterName, PortName) Then
          sMessage = "-1"
          SaveLog "Ejecutando: " & shelstmt
          SaveLog "Impresion exitosa"
        Else
          sMessage = "0 - " & gErrorInfo
          SaveLog "Impresion Fallida"
        End If
      Else
        sMessage = "0 - " & gErrorInfo
        SaveLog "Impresion Fallida"
      End If
      
      SaveLog "Respuesta: " & sMessage
      
      m_Server.StringToByteArray sMessage, Response
  End Select

  GoTo ExitProc
ControlError:
  MngError Err, "cIService_WndProc", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pGetTarjeton(ByRef shelstmt As String, ByVal sMessage As String) As Boolean
  Dim rs As Recordset
  Dim sqlstmt As String
  
  sqlstmt = IniGet(c_k_TarjetonSP, "") & " " & Val(pGetMessage(sMessage)) '"spPDAPalGetParametrosTarjeton "
  
  SaveLog "Ejecutando: " & sqlstmt
  
  If Not m_db.OpenRs(rs, sqlstmt) Then Exit Function
  
  SaveLog "Exe de tarjeton: " & IniGet(c_k_TarjetonPath, "")
  
  shelstmt = IniGet(c_k_TarjetonPath, "") & " " & rs.Fields(0)
  'shelstmt = rs.Fields(0)
  
  pGetTarjeton = True
End Function

Private Sub pOpenDB()
  On Error GoTo ControlError

  Dim Server    As String
  Dim Database  As String
  Dim User      As String
  Dim Password  As String
  Dim TrustedConnection As Boolean
  
  Server = IniGet(c_K_Server, "(Local)")
  Database = IniGet(c_k_DataBase, "Master")
  User = IniGet(c_k_User, "sa")
  Password = IniGet(c_k_Password, "")
  TrustedConnection = IniGet(c_k_TrustedConnection, "0")
  
  m_db.OpenConnection Server, Database, User, Password, TrustedConnection

  GoTo ExitProc
ControlError:
  MngError Err, "pOpenDB", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pExecuteSqlstmt(ByVal sqlstmt As String, ByRef ErrDescription As String) As Boolean
  On Error GoTo ControlError

  Dim vSqlstmt  As Variant
  Dim i         As Integer
  
  sqlstmt = Replace(sqlstmt, c_SHELL, "")
  
  vSqlstmt = Split(sqlstmt, "|")
  For i = 0 To UBound(vSqlstmt)
    If Not Trim(vSqlstmt(i)) = "" Then
      If Not m_db.Execute(vSqlstmt(i), ErrDescription) Then Exit Function
    End If
  Next
  
  pExecuteSqlstmt = True
  GoTo ExitProc
ControlError:
  MngError Err, "pExecuteSqlstmt", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  m_ServiceID = SRV_ID_EXECUTE

  Set m_Server = gServer
  gServiceCreated = True
  
  Set m_db = New cDataSource
  pOpenDB

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Server = Nothing
  gServiceCreated = False
  
  Set m_db = Nothing
  
  GoTo ExitProc
ControlError:
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


