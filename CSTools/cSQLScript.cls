VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSQLScript"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cSQLScript
' 15-05-2002

'--------------------------------------------------------------------------------
' notas:
' Proposito:   Correr los scripts y manejar los diferentes errores

'   - Ejecutar sentencias
'   - Abrir recordsets

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cSQLScript"
' estructuras
' variables privadas
Private m_Connection  As cConnection

' eventos
Public Event Progress(ByVal Percent As Integer, ByVal Descrip As String, ByRef Cancel As Boolean)
Public Event ScriptError(ByVal Descrip As String, ByVal ErrNumber As Long, ByVal sqlstmt As String, ByRef Continue As Boolean)
Public Event ResultAndMessage(ByRef Result As Object, ByVal Message As String)
Public Event BeforeResult()
Public Event ErrorOccurs(ByVal Messages As String)
' propiedades publicas
' propiedades friend
Friend Property Set Conn(ByRef rhs As cConnection)
  Set m_Connection = rhs
End Property

' propiedades privadas
' funciones publicas
Public Function ExecuteBatch(ByVal sqlstmt As String, _
                             ByVal DataBaseName As String, _
                             Optional ByVal DataBaseWasChecked As Boolean = False) As Boolean
  On Error GoTo ControlError
  
  Dim sqlunit As String
  
  Dim i As Long
  Dim j As Long
  
  Dim Cancel  As Boolean
  Dim Percent As Integer
  Dim Descrip As String
  Dim LenSqlstmt As Long
  
  If Not DataBaseWasChecked Then
    DBCheckExists m_Connection, DataBaseName, C_Module & "ExecuteBatch"
  End If
  
  i = 1
  LenSqlstmt = Len(sqlstmt)
  
  While i < LenSqlstmt
    j = InStr(i, sqlstmt, chr(13) & chr(10) & "GO", vbTextCompare)
    If j = 0 Then j = Len(sqlstmt)
    
    Cancel = False
    Descrip = GetDescriptSqlstmt(sqlunit)
    RaiseEvent Progress(Percent, Descrip, Cancel)
    
    sqlunit = Mid$(sqlstmt, i, j - i)
    If Not Execute(sqlunit, DataBaseName, True) Then Exit Function
    
    Percent = (j / LenSqlstmt) * 100
    Cancel = False
    RaiseEvent Progress(Percent, Descrip, Cancel)
    
    If Cancel Then Exit Function
    
    i = j + 4
  Wend
  
  ExecuteBatch = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "ExecuteBatch", C_Module, ""
ExitProc:
End Function

Public Function Execute(ByVal sqlstmt As String, _
                        ByVal DataBaseName As String, _
                        Optional ByVal DataBaseWasChecked As Boolean = False) As Boolean
  On Error GoTo ControlError
  
  If Not DataBaseWasChecked Then
    DBCheckExists m_Connection, DataBaseName, C_Module & "Execute"
  End If
  
  m_Connection.Server.Databases(DataBaseName).ExecuteImmediate sqlstmt, SQLDMOExec_Default
  
  DoEvents
  
Success:
  Execute = True
  
  GoTo ExitProc
ControlError:
  Dim Continue As Boolean
  RaiseEvent ScriptError(Err.Description, Err.Number, sqlstmt, Continue)
  
  If Continue Then Resume Success
  
  MngError Err, "Execute", C_Module, ""
ExitProc:
End Function

Public Function ExecuteWithResult(ByVal sqlstmt As String, _
                                  ByVal DataBaseName As String, _
                                  ByRef Rslt As Object) As Boolean
  On Error GoTo ControlError
  
  DBCheckExists m_Connection, DataBaseName, C_Module & "ExecuteWithResult"
  
  Dim qrslt As QueryResults
  Set qrslt = m_Connection.Server.Databases(DataBaseName).ExecuteWithResults(sqlstmt)
  
  Set Rslt = qrslt
  
  ExecuteWithResult = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "ExecuteWithResult", C_Module, ""
ExitProc:
End Function

Public Function ExecuteWithResultAndMsg(ByVal sqlstmt As String, _
                                  ByVal DataBaseName As String, _
                                  ByRef Rslt As Object, _
                                  ByRef Msg As String, _
                                  Optional ByVal WithOutError As Boolean) As Boolean
  On Error GoTo ControlError
  
  DBCheckExists m_Connection, DataBaseName, C_Module & "ExecuteWithResultAndMsg"
  
  Dim qrslt As QueryResults
  Dim Messages As String
  
  If WithOutError Then
    On Error Resume Next
    Err.Clear
  End If
  
  Set qrslt = m_Connection.Server.Databases(DataBaseName).ExecuteWithResultsAndMessages(sqlstmt, , Messages)
  
  If Err.Number <> 0 Then
    RaiseEvent ErrorOccurs(Messages)
  Else
    Msg = Messages
    Set Rslt = qrslt
    ExecuteWithResultAndMsg = True
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "ExecuteWithResultAndMsg", C_Module, ""
ExitProc:
End Function

Public Function ExecuteBatchWithResultAndMessage( _
                              ByVal sqlstmt As String, _
                              ByVal DataBaseName As String, _
                              Optional ByVal DataBaseWasChecked As Boolean = False) As Boolean
  On Error GoTo ControlError
  
  Dim sqlunit As String
  
  Dim i As Long
  Dim j As Long
  
  Dim Cancel  As Boolean
  Dim Percent As Integer
  Dim Descrip As String
  Dim LenSqlstmt As Long
  Dim Result  As SQLDMO.QueryResults
  Dim Message As String
  
  If Not DataBaseWasChecked Then
    DBCheckExists m_Connection, DataBaseName, C_Module & "ExecuteBatch"
  End If
  
  i = 1
  LenSqlstmt = Len(sqlstmt)
  
  RaiseEvent BeforeResult

  While i < LenSqlstmt
    j = InStr(i, sqlstmt, chr(13) & chr(10) & "GO", vbTextCompare)
    If j = 0 Then j = Len(sqlstmt) + 1
    
    Cancel = False
    Descrip = GetDescriptSqlstmt(sqlunit)
    RaiseEvent Progress(Percent, Descrip, Cancel)
    
    sqlunit = Mid$(sqlstmt, i, j - i)
    If IsSqlstmt(sqlunit) Then
      
      If ExecuteWithResultAndMsg(sqlunit, DataBaseName, Result, Message, True) Then
        RaiseEvent ResultAndMessage(Result, Message)
      End If
      
      Percent = (j / LenSqlstmt) * 100
      Cancel = False
      RaiseEvent Progress(Percent, Descrip, Cancel)
    End If
    
    If Cancel Then Exit Function
    
    i = j + 4
  Wend
  
  ExecuteBatchWithResultAndMessage = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "ExecuteBatchWithResultAndMessage", C_Module, ""
ExitProc:
End Function

' funciones friend
' funciones privadas
Private Function IsSqlstmt(ByVal sqlstmt As String) As Boolean
  Select Case Trim(sqlstmt)
    Case "", vbCrLf
      Exit Function
  End Select
  IsSqlstmt = True
End Function
Private Function GetDescriptSqlstmt(ByVal sqlstmt As String)
  Dim rtn As String
  
  If Trim(Replace(sqlstmt, vbCrLf, "")) = "" Then Exit Function
  If Trim(Replace(sqlstmt, vbCrLf, "")) = "SET ANSI_NULLS ON" Then Exit Function
  If Trim(Replace(sqlstmt, vbCrLf, "")) = "SET QUOTED_IDENTIFIER OFF" Then Exit Function
  If Trim(Replace(sqlstmt, vbCrLf, "")) = "SET QUOTED_IDENTIFIER ON" Then Exit Function
  
  rtn = GetSQLObjectName(sqlstmt, "CREATE", "PROCEDURE")
  If rtn = "" Then rtn = GetSQLObjectName(sqlstmt, "CREATE", "TABLE")
  If rtn = "" Then rtn = GetSQLObjectName(sqlstmt, "CREATE", "TRIGGER")
  If rtn = "" Then rtn = GetSQLObjectName(sqlstmt, "DROP", "PROCEDURE")
  If rtn = "" Then rtn = GetSQLObjectName(sqlstmt, "DROP", "TABLE")
  If rtn = "" Then rtn = GetSQLObjectName(sqlstmt, "DROP", "CONSTRAINT")
  If rtn = "" Then rtn = GetSQLObjectName(sqlstmt, "DROP", "TRIGGER")
  If rtn = "" Then rtn = GetSQLObjectName(sqlstmt, "ALTER", "TABLE")
  If rtn = "" Then rtn = GetSQLObjectName(sqlstmt, "ALTER", "PROCEDURE")
  If rtn = "" Then rtn = GetSQLObjectName(sqlstmt, "CLUSTERED", "INDEX")
  If rtn = "" Then rtn = GetSQLObjectName(sqlstmt, "CREATE", "INDEX")
  If rtn = "" Then rtn = GetSQLObjectName(sqlstmt, "INSERT", "INTO")

  GetDescriptSqlstmt = rtn
End Function
' construccion - destruccion
Private Sub Class_Terminate()
  Set m_Connection = Nothing
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

