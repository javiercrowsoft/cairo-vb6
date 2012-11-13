VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDataSource"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cDataSource
' 26-07-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDataSource"

Private Const c_TblTemp = "TblTmp"

Private Const csErrorVal = -2147221499


Public Enum crTipoServer
  SERVER_ACCESS = 1
  SERVER_SQL = 2
End Enum
' estructuras
' variables privadas
Private m_cn        As Connection
Private m_connect   As String
' eventos
' propiedadades publicas
Public Property Get ConnectString() As String
  On Error Resume Next
  ConnectString = m_cn.ConnectionString
End Property

Public Property Get StrConnect() As String
  If m_cn Is Nothing Then
    StrConnect = ""
  Else
    If LCase$(m_cn.ConnectionString) = "provider=msdasql.1;" Then
      StrConnect = m_connect
    Else
      StrConnect = m_cn.ConnectionString
    End If
  End If
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function sqlDate(ByVal sValue As String) As String
    sqlDate = Format(sValue, csSqlDateString)
End Function

Public Function sqlString(ByVal sValue As String) As String
    sqlString = "'" & Replace(sValue, "'", "''") & "'"
End Function

Public Function sqlNumber(ByVal sValue As Variant) As String
    Dim i As Integer
    
    If Not IsNumeric(sValue) Then
      sValue = 0
    End If
    
    If CDbl(sValue) = 0 Then
      sqlNumber = "0"
    Else
      sValue = Format(sValue, "0.000000")
      i = InStr(1, sValue, GetSepDecimal)
      
      ' Reemplazo el separador decimal por punto
      If i > 0 Then
          sqlNumber = Left(sValue, i - 1) + "." + Mid(sValue, i + 1)
      End If
    End If
End Function

Public Function GetData(ByVal Table As String, ByVal FieldId As String, ByVal IdValue As Long, ByVal FieldData As String, ByRef rtn As Variant) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  rtn = Empty
  
  sqlstmt = "select " & FieldData & " from " & Table & " where " & FieldId & " = " & IdValue
  
  If Not OpenRs(rs, sqlstmt) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  rtn = ValField(rs.fields(0))
  
  GetData = True
End Function

Public Function GetTables(ByRef rs As Recordset) As Boolean
  On Error GoTo ControlError

  Set rs = m_cn.OpenSchema(adSchemaTables)

  GetTables = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "GetTables", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function GetConnetString(ByVal Server As String, ByVal Database As String, _
                                ByVal User As String, ByVal Password As String, _
                                ByVal UseNTSecurity As Boolean) As String
  Dim Connect As String

  If Not UseNTSecurity Then
    Connect = "Provider=SQLOLEDB.1;" _
              & "Password=" & Password & ";" _
              & "Persist Security Info=True;" _
              & "User ID=" & User & ";" _
              & "Initial Catalog=" & Database & ";" _
              & "Data Source=" & Server

  Else
    Connect = "Provider=SQLOLEDB.1;" _
              & "Initial Catalog=" & Database & ";" _
              & "Data Source=" & Server & ";" _
              & "Persist Security Info=False;Integrated Security=SSPI;"
  End If

  GetConnetString = Connect

End Function

Public Function OpenConnection(ByVal Server As String, ByVal Database As String, _
                               ByVal User As String, ByVal Password As String, _
                               ByVal UseNTSecurity As Boolean, _
                               Optional ByVal Connect As String) As Boolean
  On Error GoTo ControlError
  
#If PREPROC_INSTALL = 0 And PREPROC_MONITOR = 0 And PREPROC_CSSERVER = 0 And PREPROC_CSTOOLS = 0 Then
  SaveLog LNGGetText(3326, vbNullString) 'Abriendo conexión
#ElseIf PREPROC_CSSERVER Then
  SaveLog "Abriendo conexión", True
#End If

  If Connect = "" Then
  
    Connect = GetConnetString(Server, Database, User, Password, UseNTSecurity)
    
  End If
  
#If PREPROC_INSTALL = 0 And PREPROC_MONITOR = 0 And PREPROC_CSTOOLS = 0 And PREPROC_IMPSQL = 0 And PREPROC_PRINT_SRV = 0 Then
  If gLogTrafic Then
    SaveLog "String de conexión: " & Encript(Connect, c_LoginSignature), False
  End If
#End If

  m_connect = Connect
  m_cn.Open Connect
  
#If PREPROC_INSTALL = 0 And PREPROC_MONITOR = 0 And PREPROC_CSTOOLS = 0 And PREPROC_CSSERVER = 0 Then
  SaveLog LNGGetText(3327, vbNullString), True 'Conexión exitosa
#ElseIf PREPROC_CSSERVER Then
  SaveLog "Conexión exitosa", True
#End If
  OpenConnection = True

  GoTo ExitProc
ControlError:
  MngError Err, "OpenConnection", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function Execute(ByVal sqlstmt As String, ByRef ErrDescription As String) As Boolean
  On Error GoTo ControlError
  
  Dim bErrorTraped As Boolean

#If PREPROC_INSTALL = 0 And PREPROC_MONITOR = 0 And PREPROC_CSTOOLS = 0 And PREPROC_IMPSQL = 0 Then
  If gLogTrafic Then
    SaveLog "Ejecutando: " & sqlstmt, True
  End If
#End If

TryAgain:
  m_cn.Execute sqlstmt

#If PREPROC_INSTALL = 0 And PREPROC_MONITOR = 0 And PREPROC_CSTOOLS = 0 And PREPROC_IMPSQL = 0 And PREPROC_CSSERVER = 0 Then
  If gLogTrafic Then
    SaveLog LNGGetText(3328, vbNullString) 'Ejecución exitosa
  End If
#ElseIf PREPROC_CSSERVER Then
  If gLogTrafic Then
    SaveLog "Ejecución exitosa", True
  End If
#End If

  Execute = True

  GoTo ExitProc
ControlError:
  
  If pReconect(bErrorTraped) Then
    GoTo TryAgain
  Else
    
    If Not bErrorTraped Then
      ErrDescription = Err.Description
      MngError Err, "Execute", C_Module, sqlstmt
    End If
  End If
  
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function OpenRs(ByRef rs As Recordset, ByVal sqlstmt As String) As Boolean
  On Error GoTo ControlError
  Dim bErrorTraped As Boolean
  
#If PREPROC_INSTALL = 0 And PREPROC_MONITOR = 0 And PREPROC_CSTOOLS = 0 And PREPROC_IMPSQL = 0 Then
  
  If gLogTrafic Then
    SaveLog "Abriendo RS: " & sqlstmt, True
  End If
#End If

  If rs Is Nothing Then
    Set rs = New Recordset
  Else
    If rs.State <> adStateClosed Then rs.Close
  End If
  
TryAgain:

  Err.Clear

  rs.CursorLocation = adUseClient
  rs.Open sqlstmt, m_cn, adOpenDynamic, adLockOptimistic

#If PREPROC_INSTALL = 0 And PREPROC_MONITOR = 0 And PREPROC_CSTOOLS = 0 And PREPROC_IMPSQL = 0 And PREPROC_CSSERVER = 0 Then
  If gLogTrafic Then
    SaveLog LNGGetText(3329, vbNullString) 'RS Abierto exitosamente
  End If
#ElseIf PREPROC_CSSERVER Then
  If gLogTrafic Then
    SaveLog "RS Abierto exitosamente", True
  End If
#End If

  OpenRs = True

  GoTo ExitProc
ControlError:
  ' Error de conexion
  
  If pReconect(bErrorTraped) Then
    GoTo TryAgain
  Else
    If Not bErrorTraped Then
      MngError Err, "OpenRs", C_Module, sqlstmt
    End If
  End If
  
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function CloseConnection() As Boolean
  On Error GoTo ControlError
  
  If m_cn.State <> adStateClosed Then m_cn.Close

  CloseConnection = True
  GoTo ExitProc
ControlError:
  MngError Err, "CloseConnection", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

#If PREPROC_INSTALL = 0 And PREPROC_MONITOR = 0 And PREPROC_IMPSQL = 0 And PREPROC_PRINT_SRV = 0 Then

Public Function GetRecordsetInSqlstmt(ByVal sqlstmt As String, ByRef ret As String) As Boolean
  On Error GoTo ControlError
  
  Dim sqlvalues As String
  Dim sqlcreate As String
  Dim sqlinsert As String
  Dim rs        As ADODB.Recordset
  Dim rtn       As String
  Dim wasSelect As Boolean
  
  If Trim(sqlstmt) = "" Then Exit Function
  
  If Not GetInfoTabla(sqlstmt, c_TblTemp, sqlcreate, sqlinsert, SERVER_ACCESS, rs, wasSelect) Then Exit Function
  If wasSelect Then If Not OpenRs(rs, sqlstmt) Then Exit Function
  rtn = "drop table " & c_TblTemp & c_TCPSep1 & vbCrLf
  rtn = rtn & sqlcreate
    
  While Not rs.EOF
    sqlvalues = GetSqlValues(rs, SERVER_ACCESS)
    rtn = rtn & c_TCPSep1 & vbCrLf & sqlinsert & " " & sqlvalues
    rs.MoveNext
  Wend
  
#If PREPROC_INSTALL = 0 And PREPROC_MONITOR = 0 And PREPROC_CSTOOLS = 0 Then
  If gLogTrafic Then
    SaveLog "Sentencia generada: " & rtn, True
  End If
#End If

  ret = rtn
  GetRecordsetInSqlstmt = True

  GoTo ExitProc
ControlError:
  MngError Err, "GetRecordsetInSqlstmt", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
#End If

' funciones friend
' funciones privadas
#If PREPROC_INSTALL = 0 And PREPROC_MONITOR = 0 And PREPROC_IMPSQL = 0 And PREPROC_PRINT_SRV = 0 Then
Private Function GetSqlValues(rs As ADODB.Recordset, ByVal TipoServer As crTipoServer) As String
  ' Con los datos del recordset tengo que armar la
  ' sentencia SQL
  Dim CantFields  As Integer
  Dim i           As Integer
  Dim ColA        As String

  CantFields = rs.fields.Count
  GetSqlValues = "VALUES ("
  For i = 0 To CantFields - 1
    'Hago esto porque sino da error al hacer remove last coma
    'cuando hay memos muy largos
    If i = CantFields - 1 Then
      ColA = ")"
    Else
      ColA = ","
    End If
    If TipoServer = crTipoServer.SERVER_ACCESS Then
      GetSqlValues = GetSqlValues + AccessFieldToString(rs.fields(i)) + ColA
    Else
      GetSqlValues = GetSqlValues + SQLFieldToString(rs.fields(i)) + ColA
    End If
  Next
End Function
#End If

#If PREPROC_PRINT_SRV = 0 Then

Private Function GetInfoTabla(ByVal sqlstmt As String, _
                              ByVal NombreTabla As String, _
                              ByRef sqlstmtCreate As String, _
                              ByRef sqlstmtInsert As String, _
                              ByVal TipoServer As crTipoServer, _
                              ByRef rs As Recordset, _
                              ByRef wasSelect As Boolean) As Boolean
  Dim f   As ADODB.field
  Dim sqlstmt2 As String
  
  ' Si no se trata de un sp
  If Mid(UCase(sqlstmt), 1, 6) = "SELECT" Then
    wasSelect = True
    ' para no obtener valores inecesarios, agrego una condicion que nunca se cumple
    sqlstmt2 = GetSelect(sqlstmt) + GetFrom(sqlstmt) + GetWhere(sqlstmt)
    If GetWhere(sqlstmt) <> "" Then
      sqlstmt2 = sqlstmt2 + " AND 1=2 "
    Else
      sqlstmt2 = sqlstmt2 + " WHERE 1=2 "
    End If
    sqlstmt = sqlstmt2 + GetGroup(sqlstmt) + GetOrder(sqlstmt)
  Else
    wasSelect = False
  End If
  
  sqlstmtCreate = "CREATE TABLE " + NombreTabla + " ("
  sqlstmtInsert = "INSERT INTO " + NombreTabla + " ("
  
  If Not OpenRs(rs, sqlstmt) Then Exit Function
  
  Dim fieldName As String
  Dim NextFieldNameAux As Integer
  
  For Each f In rs.fields
    fieldName = Trim(f.Name)
    
    If fieldName = "" Then
      NextFieldNameAux = NextFieldNameAux + 1
      fieldName = "CCCC" & NextFieldNameAux
    End If
    
    If TipoServer = SERVER_ACCESS Then
      sqlstmtCreate = sqlstmtCreate + "[" + fieldName + "] " + AccessTextForType(f.Type, f.DefinedSize) + " ,"
    Else
      sqlstmtCreate = sqlstmtCreate + "[" + fieldName + "] " + SQLTextForType(f.Type, f.DefinedSize) + " ,"
    End If
    sqlstmtInsert = sqlstmtInsert + "[" + fieldName + "] ,"
  Next

  sqlstmtCreate = RemoveLastColon(sqlstmtCreate) + ")"
  sqlstmtInsert = RemoveLastColon(sqlstmtInsert) + ")"
  
  GetInfoTabla = True
End Function

Private Function AccessTextForType(ByVal Tipo As ADODB.DataTypeEnum, ByVal Ancho As Long)
  'los textos correspondientes para Access
  Dim Retval As String
  Select Case Tipo
  Case adChar, adVarChar, adLongVarChar, adLongVarWChar, adWChar, adVarWChar
    If Ancho > 255 Then
      Retval = "TEXT" '"MEMO" en windows ce el MEMO da error
    Else
      Retval = "TEXT" '"STRING(" + Trim(Ancho) + ")"
    End If
  Case adDecimal, adNumeric, adDouble, adSingle, adCurrency
    Retval = "FLOAT"
  Case adInteger, adBigInt
    Retval = "INT"
  Case adSmallInt, adTinyInt
    Retval = "SMALLINT"
  Case adDBTime, adDBTimeStamp, adDBDate, adDate
    Retval = "DATETIME"
  Case adBoolean
    Retval = "BIT"
  Case adBinary, adLongVarBinary
    Retval = "VARBINARY"
  Case Else
    'Debug.Print "No esta previsto el tipo " + Trim(Tipo)
    Retval = "TEXT" '"STRING(50)"
  End Select
  AccessTextForType = Retval
End Function

#End If

Public Function ValField(field As ADODB.field) As Variant
    If field Is Nothing Then
#If PREPROC_CSSERVER = 0 And PREPROC_CSTOOLS = 0 And PREPROC_INSTALL = 0 And PREPROC_MONITOR = 0 Then
        Err.Raise vbObjectError + csErrorVal, "VAL function CSOAPI", LNGGetText(3330, vbNullString)
                                                                      'No se pasó un field. Error interno
#Else
        Err.Raise vbObjectError + csErrorVal, "VAL function CSOAPI", "No se pasó un field. Error interno"
#End If

    End If
    If IsNull(field.value) Then
        Select Case field.Type
            Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
                ValField = ""
            Case adBigInt, adBinary, adInteger, adLongVarBinary, adNumeric, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
                ValField = 0
            Case adBoolean
                ValField = False
            Case adCurrency, adSingle, adDecimal, adDouble
                ValField = 0
            Case adDBTime, adDate, adDBDate
                ValField = csNoDate
            Case adDBTimeStamp
                ValField = csNoDate
        End Select
    Else
        ValField = field.value
    End If
End Function

Private Function SQLFieldToString(Campo As ADODB.field) As String
  Dim Retval As String
  If IsNull(Campo.value) Then
    Retval = "NULL"
  Else
    Select Case Campo.Type
    Case adBigInt, adInteger, adSmallInt, adSingle, adDouble
      Retval = Trim(Campo)
    Case adBoolean
      Retval = Trim(CInt(Campo))
    Case adCurrency
      Retval = Trim(Campo)
    Case adDBTime, adDBTimeStamp, adDBDate, adDate
      Retval = Format$(Campo, C_PSqlFechaHora)
    Case adChar, adVarChar, adWChar, adVarWChar, adLongVarChar, adLongVarWChar
      Retval = "'" + Replace(Campo.value, "'", "''") + "'"
    Case adBinary
      Retval = Trim(Campo)
    End Select
  End If
  SQLFieldToString = Retval
End Function

Private Function SQLTextForType(ByVal Tipo As ADODB.DataTypeEnum, ByVal Ancho As Long)
  'los textos correspondientes para Access
  Dim Retval As String
  Select Case Tipo
  Case adChar, adVarChar, adWChar, adVarWChar, adLongVarChar, adLongVarWChar
    If Ancho < 8000 Then
      Retval = "VARCHAR(" + Trim(Ancho) + ")"
    Else
      Retval = "TEXT"
    End If
  Case adNumeric
    Retval = "NUMERIC"
  Case adDecimal
    Retval = "DECIMAL"
  Case adDouble
    Retval = "FLOAT"
  Case adSingle
    Retval = "REAL"
  Case adInteger, adBigInt
    Retval = "INTEGER"
  Case adSmallInt
    Retval = "SMALLINT"
  Case adTinyInt
    Retval = "TINYINT"
  Case adDBTime, adDBDate, adDate, adDBTimeStamp
    Retval = "DATETIME"
  Case adBoolean
    Retval = "BIT"
  Case adBinary
    Retval = "BINARY"
  Case adVarBinary
    Retval = "VARBINARY"
  Case Else
    'Debug.Print "No esta previsto el tipo " + Trim(Tipo)
    Retval = "VARCHAR(50)"
  End Select
  SQLTextForType = Retval
End Function
Private Function GetSelect(ByVal sqlstmt As String) As String
  If InStr(UCase(sqlstmt), "FROM") > 0 Then
    GetSelect = Mid(sqlstmt, 1, InStr(UCase(sqlstmt), "FROM") - 1)
  Else
    GetSelect = sqlstmt
  End If
End Function
Private Function GetFrom(ByVal sqlstmt As String) As String
  sqlstmt = UCase(sqlstmt)
  If InStr(sqlstmt, "FROM") > 0 Then
    sqlstmt = Mid(sqlstmt, InStr(sqlstmt, "FROM"))
  End If
  If InStr(sqlstmt, "WHERE") > 0 Then
    GetFrom = Mid(sqlstmt, 1, InStr(sqlstmt, "WHERE") - 1)
  ElseIf InStr(sqlstmt, "ORDER BY") > 0 Then
    GetFrom = Mid(sqlstmt, 1, InStr(sqlstmt, "ORDER BY") - 1)
  ElseIf InStr(sqlstmt, "GROUP BY") > 0 Then
    GetFrom = Mid(sqlstmt, 1, InStr(sqlstmt, "GROUP BY") - 1)
  Else
    GetFrom = sqlstmt
  End If
End Function
Private Function GetWhere(ByVal sqlstmt As String) As String
  sqlstmt = UCase(sqlstmt)
  If InStr(sqlstmt, "WHERE") > 0 Then
    sqlstmt = Mid(sqlstmt, InStr(sqlstmt, "WHERE"))
    If InStr(sqlstmt, "GROUP BY") > 0 Then
      sqlstmt = Mid(sqlstmt, 1, InStr(sqlstmt, "GROUP BY") - 1)
    End If
    If InStr(sqlstmt, "ORDER BY") > 0 Then
      sqlstmt = Mid(sqlstmt, 1, InStr(sqlstmt, "ORDER BY") - 1)
    End If
  Else
    sqlstmt = ""
  End If
  GetWhere = sqlstmt
End Function
Private Function GetGroup(ByVal sqlstmt As String) As String
  sqlstmt = UCase(sqlstmt)
  If InStr(sqlstmt, "GROUP BY") > 0 Then
    sqlstmt = Mid(sqlstmt, InStr(sqlstmt, "GROUP BY"))
    If InStr(sqlstmt, "ORDER BY") > 0 Then
      GetGroup = Mid(sqlstmt, 1, InStr(sqlstmt, "ORDER BY") - 1)
    Else
      GetGroup = sqlstmt
    End If
  Else
    GetGroup = ""
  End If
End Function
Private Function GetOrder(ByVal sqlstmt As String) As String
  sqlstmt = UCase(sqlstmt)
  If InStr(sqlstmt, "ORDER BY") > 0 Then
    GetOrder = Mid(sqlstmt, InStr(sqlstmt, "ORDER BY"))
  Else
    GetOrder = ""
  End If
End Function

#If PREPROC_INSTALL = 0 And PREPROC_MONITOR = 0 And PREPROC_IMPSQL = 0 And PREPROC_PRINT_SRV = 0 Then
Public Function AccessFieldToString(Campo As ADODB.field) As String
  Dim Retval As String, valor As String
  If IsNull(Campo.value) Then
    Retval = "NULL"
  Else
    Select Case Campo.Type
    Case adBinary, adSmallInt, adInteger, adSingle, adDouble, adCurrency, adNumeric, adLongVarBinary
      Retval = Trim(Campo.value)
    Case adBoolean
      If CBool(Campo.value) Then
        Retval = "1"
      Else
        Retval = "0"
      End If
    Case adDate, adDBTime, adDBDate, adDBTimeStamp
      Retval = c_TCPSep2 + Format$(Campo, "mm/dd/yyyy HH:nn:ss") + c_TCPSep2
    Case adChar, adVarChar, adWChar, adVarWChar, adLongVarChar, adLongVarWChar
      valor = Replace(Campo.value, c_TCPSep1, "")
      valor = Replace(valor, "'", "''")
      Retval = "'" + valor + "'"
    End Select
  End If
  AccessFieldToString = Retval
End Function
#End If

Private Function pReconect(ByRef bErrorTraped As Boolean) As Boolean
  
  bErrorTraped = False
  
  Select Case Err.Number
    Case -2147467259, 3709
    Case Else
      Exit Function
  End Select
  
  On Error GoTo ControlError
  CloseConnection
  
  m_cn.Open m_connect
  
  pReconect = True
  
  GoTo ExitProc
ControlError:
  bErrorTraped = True
  MngError Err, "pReconect", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_cn = New Connection

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  CloseConnection
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
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
