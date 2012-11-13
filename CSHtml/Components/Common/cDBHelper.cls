VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 3  'UsesTransaction
END
Attribute VB_Name = "cDBHelper"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements IObjectConstruct
'--------------------------------------------------------------------------------
' cDBHelper
' 21-04-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "CSWebDataBase.cDBHelper"


' Tablas
Private Const cscActivo                          As String = "activo"

' estructuras
' variables privadas
Private m_DBServer As String
Private m_ConnectionString As String
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function GetConnectionString() As String
  If m_ConnectionString <> "" Then
    GetConnectionString = m_ConnectionString
  Else
    'assume that we want to use a SQL Server connection through OLDEB
    If Dir(App.Path & "\debug.ini") <> "" Then
      GetConnectionString = "PROVIDER=MSDASQL;driver={SQL Server};server=souyirozeta;uid=sa;pwd=;database=cairo;"
    Else
      GetConnectionString = "file name=" & App.Path & "\CrowSoftWeb.UDL"
    End If
  End If
  'GetConnectionString = "Provider=SQLOLEDB.1;Password=CairoGn2005Gn;Persist Security Info=True;User ID=sa;Initial Catalog=cairoGN;Data Source=servercairo"
End Function

Public Function RunSPReturnRS(ByVal strSP As String, ParamArray params() As Variant) As ADODB.Recordset
  On Error GoTo ControlError
  
  ' Create the ADO objects
  Dim Rs As ADODB.Recordset, cmd As ADODB.Command
  Set Rs = New ADODB.Recordset
  Set cmd = New ADODB.Command
  
  ' Init the ADO objects  & the stored proc parameters
  cmd.ActiveConnection = GetConnectionString()
  cmd.CommandText = strSP
  cmd.CommandType = adCmdStoredProc
  cmd.CommandTimeout = 600
  
  collectParams cmd, params
  
  ' Execute the query for readonly
  Rs.CursorLocation = adUseClient
  Rs.Open cmd, , adOpenForwardOnly, adLockReadOnly
  
  ' Disconnect the recordset
  Set cmd.ActiveConnection = Nothing
  Set cmd = Nothing
  Set Rs.ActiveConnection = Nothing

  ' Return the resultant recordset
  Set RunSPReturnRS = Rs
  Exit Function
  
ControlError:
  Set Rs = Nothing
  Set cmd = Nothing
  RaiseError C_Module, "RunSPReturnRS(" & strSP & ", ...)"
End Function

' RunSQLReturnRS differs from RunSPReturnRS only on the line that
' sets the cmd.CommandType = adCmdText vs. adCmdStoredProc
'
Public Function RunSQLReturnRS(ByVal strSP As String, ParamArray params() As Variant) As ADODB.Recordset
  On Error GoTo ControlError
  
  ' Set up Command and Connection objects
  Dim Rs As ADODB.Recordset, cmd As ADODB.Command
  Set Rs = New ADODB.Recordset
  Set cmd = New ADODB.Command

  'Run the procedure
  cmd.ActiveConnection = GetConnectionString()
  cmd.CommandText = strSP
  cmd.CommandType = adCmdText
  cmd.CommandTimeout = 600
  
  If UBound(params) Then
    collectParams cmd, params
  End If
  
  Rs.CursorLocation = adUseClient
  Rs.Open cmd, , adOpenForwardOnly, adLockReadOnly
  
  On Error Resume Next
  
  ' Disconnect the recordsets and cleanup
  Set cmd.ActiveConnection = Nothing
  Set cmd = Nothing
  Set Rs.ActiveConnection = Nothing
  
  Set RunSQLReturnRS = Rs
  Exit Function
  
ControlError:
  Set Rs = Nothing
  Set cmd = Nothing
  RaiseError C_Module, "RunSQLReturnRS(" & strSP & ", ...)"
End Function

Public Function RunSPReturnRS_RW(ByVal strSP As String, ParamArray params() As Variant) As ADODB.Recordset
  On Error GoTo ControlError
  
  ' Create the ADO objects
  Dim Rs As ADODB.Recordset, cmd As ADODB.Command
  Set Rs = New ADODB.Recordset
  Set cmd = New ADODB.Command
  
  ' Init the ADO objects & the stored proc parameters
  cmd.ActiveConnection = GetConnectionString()
  cmd.CommandText = strSP
  cmd.CommandType = adCmdStoredProc
  cmd.CommandTimeout = 600
    
  collectParams cmd, params
  Rs.CursorLocation = adUseClient
  
  ' Execute the query as an updatable recordset and stay connected
  Rs.Open cmd, , adOpenDynamic, adLockBatchOptimistic
  Set cmd = Nothing
  
  ' Return and quit
  Set RunSPReturnRS_RW = Rs
  Exit Function
  
ControlError:
  Set Rs = Nothing
  Set cmd = Nothing
  RaiseError C_Module, "RunSPReturnRS_RW(" & strSP & ", ...)"
End Function

Public Function RunSQLReturnRS_RW(ByVal strSP As String, ParamArray params() As Variant) As ADODB.Recordset
  On Error GoTo ControlError
  
  ' Create the ADO objects
  Dim Rs As ADODB.Recordset, cmd As ADODB.Command
  Set Rs = New ADODB.Recordset
  Set cmd = New ADODB.Command
     
  ' Init the ADO objects & the stored proc parameters
  cmd.ActiveConnection = GetConnectionString()
  cmd.CommandText = strSP
  cmd.CommandType = adCmdText
  cmd.CommandTimeout = 600
    
  collectParams cmd, params
  Rs.CursorLocation = adUseClient
  
  ' Execute the query as an updatable recordset and stay connected
  Rs.Open cmd, , adOpenDynamic, adLockBatchOptimistic
  Set cmd = Nothing
  
  ' Return and quit
  Set RunSQLReturnRS_RW = Rs
  Exit Function
  
ControlError:
  Set Rs = Nothing
  Set cmd = Nothing
  RaiseError C_Module, "RunSQLReturnRS_RW(" & strSP & ", ...)"
End Function

Public Function RunSP(ByVal strSP As String, ParamArray params() As Variant)
  On Error GoTo ControlError
  
  ' Create the ADO objects
  Dim cmd As ADODB.Command
  Set cmd = New ADODB.Command
  
  ' Init the ADO objects & the stored proc parameters
  cmd.ActiveConnection = GetConnectionString()
  cmd.CommandText = strSP
  cmd.CommandType = adCmdStoredProc
  cmd.CommandTimeout = 600
  
  collectParams cmd, params
  
  ' Execute the query without returning a recordset
  cmd.Execute , , adExecuteNoRecords
  
  ' Disconnect the recordset and clean up
  Set cmd.ActiveConnection = Nothing
  Set cmd = Nothing
  
  Exit Function
  
ControlError:
  Set cmd = Nothing
  RaiseError C_Module, "RunSP(" & strSP & ", ...)"
End Function

Public Function RunSQL(ByVal strSP As String, ParamArray params() As Variant)
  On Error GoTo ControlError
  
  ' Create the ADO objects
  Dim cmd As ADODB.Command
  Set cmd = New ADODB.Command

  ' Init the ADO objects & the stored proc parameters
  cmd.ActiveConnection = GetConnectionString()
  cmd.CommandText = strSP
  cmd.CommandType = adCmdText
  cmd.CommandTimeout = 600
  
  If UBound(params) Then
    collectParams cmd, params
  End If
  
  ' Execute the query without returning a recordset
  cmd.Execute , , adExecuteNoRecords
  
  ' Cleanup
  Set cmd.ActiveConnection = Nothing
  Set cmd = Nothing
  
  Exit Function
  
ControlError:
  Set cmd = Nothing
  RaiseError C_Module, "RunSQL(" & strSP & ", ...)"
End Function

Public Function RunSPReturnInteger(ByVal strSP As String, ParamArray params() As Variant) As Long 'adInterger is really a VB Long
  On Error GoTo ControlError
  
  ' Create the ADO objects
  Dim cmd As ADODB.Command
  Set cmd = New ADODB.Command
  
  ' Init the ADO objects & the stored proc parameters
  cmd.ActiveConnection = GetConnectionString()
  
  cmd.CommandText = strSP
  cmd.CommandType = adCmdStoredProc
  cmd.CommandTimeout = 600
  
  collectParams cmd, params
  
  ' Assume the last parameter is outgoing
  cmd.Parameters.Append cmd.CreateParameter("@@rtn", adInteger, adParamOutput, 4)
  
  ' Execute without a resulting recordset and pull out the "return value" parameter
  cmd.Execute , , adExecuteNoRecords
  RunSPReturnInteger = cmd.Parameters("@@rtn").Value
  
  ' Disconnect the recordset, and clean up
  Set cmd.ActiveConnection = Nothing
  Set cmd = Nothing
  
  Exit Function
  
ControlError:
  Set cmd = Nothing
  RaiseError C_Module, "RunSPReturnInteger(" & strSP & ", ...)"
End Function

Public Function RunSPReturnCurrency(ByVal strSP As String, ParamArray params() As Variant) As Currency
  On Error GoTo ControlError
  
  ' Create the ADO objects
  Dim cmd As ADODB.Command
  Set cmd = New ADODB.Command
  
  ' Init the ADO objects & the stored proc parameters
  cmd.ActiveConnection = GetConnectionString()
  cmd.CommandText = strSP
  cmd.CommandType = adCmdStoredProc
  cmd.CommandTimeout = 600
  
  collectParams cmd, params
  
  ' Assume the last parameter is outgoing
  cmd.Parameters.Append cmd.CreateParameter("@@rtn", adCurrency, adParamOutput, 4)
  
  ' Execute without a resulting recordset and pull out the "return value" parameter
  cmd.Execute , , adExecuteNoRecords
  RunSPReturnCurrency = cmd.Parameters("@@rtn").Value
  
  ' Disconnect the recordset, and clean up
  Set cmd.ActiveConnection = Nothing
  Set cmd = Nothing
  
  Exit Function
  
ControlError:
  Set cmd = Nothing
  RaiseError C_Module, "RunSPReturnCurrency(" & strSP & ", ...)"
End Function

Public Function GetColumnType(ByVal strTableName As String, ByVal strFieldName As String) As Long
  On Error GoTo ControlError
  
  ' Create the ADO objects
  Dim Rs As ADODB.Recordset, cmd As ADODB.Command
  Set Rs = New ADODB.Recordset
  Set cmd = New ADODB.Command
     
  ' Init the ADO objects & the stored proc parameters
  cmd.ActiveConnection = GetConnectionString()
  cmd.CommandText = "Select top 1 " & strFieldName & " FROM " & strTableName
  cmd.CommandType = adCmdText
  cmd.CommandTimeout = 600
  
  'collectParams cmd, params
  Rs.CursorLocation = adUseClient
  
  ' Execute the query as an updatable recordset and stay connected
  Rs.Open cmd, , adOpenDynamic, adLockBatchOptimistic
  Set cmd = Nothing
  
  ' Return and quit
  GetColumnType = Rs.Fields(0).Type
  Set Rs = Nothing
  Exit Function
  
ControlError:
  Set Rs = Nothing
  Set cmd = Nothing
  RaiseError C_Module, "GetColumnType"
End Function

Public Function GetDataWithCondition(ByVal Table As String, _
                                     ByVal Field As String, _
                                     ByVal Condition As String, _
                                     ByRef Dato As Variant, _
                                     ByRef bExists As Boolean) As Boolean

  Dim Rs As ADODB.Recordset
  
  Set Rs = RunSPReturnRS("sp_WebGetDataWithCondition", _
                         mp("@@field", adVarChar, 100, Field), _
                         mp("@@table", adVarChar, 100, Table), _
                         mp("@@condition", adVarChar, 100, Condition))
                         
  If Not Rs.EOF Then
    Dato = ValField(Rs.Fields, Field)
    bExists = True
  End If
  
  GetDataWithCondition = True
ExitProc:
  On Error Resume Next
  Rs.Close
  Set Rs = Nothing
End Function

' funciones friend
' funciones privadas
Private Sub IObjectConstruct_Construct(ByVal pCtorObj As Object)
  'eval construction string and find out what the admin wants us to do
  Dim arrParams, x As Integer, bUseServerCursors As Boolean
  
  arrParams = Split(pCtorObj.ConstructString, ",")
  For x = LBound(arrParams) To UBound(arrParams)
    Select Case UCase(GetKey(arrParams(x)))
      Case UCase("ConnectionString")
        m_ConnectionString = GetValue(arrParams(x))
      Case UCase("Server")
        m_DBServer = GetValue(arrParams(x))
    End Select
  Next
End Sub

Private Sub collectParams(ByRef cmd As ADODB.Command, ParamArray argparams() As Variant)
  Dim params As Variant, v As Variant
  Dim i As Integer, l As Integer, u As Integer
  
  params = argparams(0)
  For i = LBound(params) To UBound(params)
    l = LBound(params(i))
    u = UBound(params(i))
    ' Check for nulls.
    If u - l = 3 Then
      If VarType(params(i)(3)) = vbString Then
        v = IIf(params(i)(3) = "", Null, params(i)(3))
      Else
        v = params(i)(3)
      End If
      cmd.Parameters.Append cmd.CreateParameter(params(i)(0), params(i)(1), adParamInput, params(i)(2), v)
    Else
      CtxRaiseError C_Module, "collectParams(...): incorrect # of parameters"
    End If
  Next i
End Sub
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
