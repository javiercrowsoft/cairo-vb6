VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDataBase"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cDataBase
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
Private Const C_Module = "cDataBase"

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

Private m_Start As Integer
Private Const ERROR_IN_GET_NOMBRE = 2222222

' eventos
Public Event BeforeResult()
Public Event ScriptError(ByVal Descrip As String, ByVal ErrNumber As Long, ByVal sqlstmt As String, ByRef Continue As Boolean)
Public Event Progress(ByVal Percent As Integer, ByVal Descrip As String, ByRef Cancel As Boolean)
' propiedadades publicas
Public Property Get ConnectString() As String
  On Error Resume Next
  ConnectString = m_cn.ConnectionString
End Property
' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function sqlString(ByVal sValue As String) As String
    sqlString = "'" & Replace(sValue, "'", "''") & "'"
End Function

Public Function sqlNumber(ByVal sValue As String) As String
  If IsNumeric(sValue) Then
    sqlNumber = Replace(CDbl(sValue), ",", ".")
  Else
    sqlNumber = 0
  End If
End Function

Public Function GetData(ByVal Table As String, ByVal FieldId As String, ByVal IdValue As Long, ByVal FieldData As String, ByRef rtn As Variant) As Boolean
  Dim sqlstmt As String
  Dim rs      As Recordset
  
  rtn = Empty
  
  sqlstmt = "select " & FieldData & " from " & Table & " where " & FieldId & " = " & IdValue
  
  If Not OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  rtn = ValField(rs.fields, 0)
  
  GetData = True
End Function

Public Function GetTables(ByRef rs As Recordset) As Boolean
  On Error GoTo ControlError

  Set rs = m_cn.OpenSchema(adSchemaTables)

  GetTables = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "GetTables", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function GetConnetString(ByVal server As String, ByVal DataBase As String, _
                                ByVal User As String, ByVal Password As String, _
                                ByVal UseNTSecurity As Boolean) As String
  Dim Connect As String

  If Not UseNTSecurity Then
    Connect = "Provider=SQLOLEDB.1;" _
              & "Password=" & Password & ";" _
              & "Persist Security Info=True;" _
              & "User ID=" & User & ";" _
              & "Initial Catalog=" & DataBase & ";" _
              & "Data Source=" & server

  Else
    Connect = "Provider=SQLOLEDB.1;" _
              & "Initial Catalog=" & DataBase & ";" _
              & "Data Source=" & server & ";" _
              & "Persist Security Info=False;Integrated Security=SSPI;"
  End If

  GetConnetString = Connect

End Function

Public Function InitDB(Optional ByVal sNameDb As String, _
                       Optional ByVal sServer As String = "Access", _
                       Optional ByVal sUser As String = "sa", _
                       Optional ByVal sPassword = "", _
                       Optional ByVal sConnect As Variant) As Boolean
  
  If IsMissing(sConnect) Then sConnect = ""
  InitDB = OpenConnection(sServer, sNameDb, sUser, sPassword, False, sConnect)
End Function

Public Function OpenConnection(ByVal server As String, ByVal DataBase As String, _
                               ByVal User As String, ByVal Password As String, _
                               ByVal UseNTSecurity As Boolean, _
                               Optional ByVal Connect As String) As Boolean
  On Error GoTo ControlError

  If Connect = "" Then
  
    Connect = GetConnetString(server, DataBase, User, Password, UseNTSecurity)
    
  End If
  
TryAgain:
  
  m_connect = Connect
  m_cn.Open Connect
  
  OpenConnection = True

  GoTo ExitProc
ControlError:

  If Err.Number <> 0 Then
    
    If g_connectAux <> vbNullString Then
      Connect = g_connectAux
      g_connectAux = vbNullString
      Resume TryAgain
    Else
    
      If Ask("No fue posible conectarse al servidor sql por un error de login.;;" & _
             "¿Desea indicar los parametros de conexion?", vbYes) Then
      
        fLogin2.Show vbModal
        
        If fLogin2.Ok Then
          server = fLogin2.txServer.Text
          DataBase = fLogin2.txDatabase.Text
          User = fLogin2.txUser.Text
          Password = fLogin2.TxPassword.Text
          UseNTSecurity = fLogin2.chkNTSecurity.Value = vbChecked
          
          If server <> vbNullString And _
             DataBase <> vbNullString And _
             User <> vbNullString Then
             
            Connect = GetConnetString(server, DataBase, User, Password, UseNTSecurity)
            g_connectAux = Connect
          End If
          Resume TryAgain
        End If
        
        Unload fLogin2
        
      End If
    End If
  End If

  MngError Err, "OpenConnection", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload fLogin2
End Function

Public Function ExecuteBatch( _
                              ByVal sqlstmt As String, _
                              ByVal DataBaseName As String, _
                              Optional ByVal DataBaseWasChecked As Boolean = False) As Boolean
  On Error GoTo ControlError
  
  Dim sqlunit As String
  
  Dim i As Long
  Dim j As Long
  Dim j1 As Long
  Dim j2 As Long
  Dim j3 As Long
  Dim j4 As Long
  Dim j5 As Long
  Dim j6 As Long
  Dim j7 As Long
  Dim j8 As Long
  Dim j9 As Long
  
  Dim Cancel  As Boolean
  Dim Percent As Integer
  Dim Descrip As String
  Dim LenSqlstmt As Long
  Dim Message As String
 
  i = 1
  LenSqlstmt = Len(sqlstmt)
  
  RaiseEvent BeforeResult

  While i < LenSqlstmt
    j1 = InStr(i, sqlstmt, Chr(13) & Chr(10) & "GO ", vbTextCompare)
    j2 = InStr(i, sqlstmt, Chr(13) & Chr(10) & "GO" & Chr(13) & Chr(10), vbTextCompare)
    j3 = InStr(i, sqlstmt, Chr(13) & Chr(10) & "GO" & Chr(9), vbTextCompare)
    j4 = InStr(i, sqlstmt, " GO ", vbTextCompare)
    j5 = InStr(i, sqlstmt, " GO" & Chr(13) & Chr(10), vbTextCompare)
    j6 = InStr(i, sqlstmt, " GO" & Chr(9), vbTextCompare)
    j7 = InStr(i, sqlstmt, Chr(9) & "GO" & Chr(13) & Chr(10), vbTextCompare)
    j8 = InStr(i, sqlstmt, Chr(9) & "GO ", vbTextCompare)
    j9 = InStr(i, sqlstmt, Chr(9) & "GO" & Chr(9), vbTextCompare)
    
    
    If j1 = 0 Then j1 = Len(sqlstmt) + 1
    If j2 = 0 Then j2 = Len(sqlstmt) + 1
    If j3 = 0 Then j3 = Len(sqlstmt) + 1
    If j4 = 0 Then j4 = Len(sqlstmt) + 1
    If j5 = 0 Then j5 = Len(sqlstmt) + 1
    If j6 = 0 Then j6 = Len(sqlstmt) + 1
    If j7 = 0 Then j7 = Len(sqlstmt) + 1
    If j8 = 0 Then j8 = Len(sqlstmt) + 1
    If j9 = 0 Then j9 = Len(sqlstmt) + 1
    
    j2 = IIf(j1 < j2, j1, j2)
    j3 = IIf(j2 < j3, j2, j3)
    j4 = IIf(j3 < j4, j3, j4)
    j5 = IIf(j4 < j5, j4, j5)
    j6 = IIf(j5 < j6, j5, j6)
    j7 = IIf(j6 < j7, j6, j7)
    j8 = IIf(j7 < j8, j7, j8)
    j = IIf(j8 < j9, j8, j9)

    If j = 0 Then j = Len(sqlstmt) + 1
    
    Cancel = False
    Descrip = GetDescriptSqlstmt(sqlunit)
    RaiseEvent Progress(Percent, Descrip, Cancel)
    
    sqlunit = Mid$(sqlstmt, i, j - i)
    
    If UCase(Right$(sqlunit, 2)) = "GO" Then sqlunit = (Mid(sqlunit, 1, Len(sqlunit) - 2))
    
    If IsSqlstmt(sqlunit) Then
      
      m_cn.BeginTrans
      
      If pExecuteBatch(sqlunit, DataBaseName, True) Then
        m_cn.CommitTrans
      Else
        m_cn.RollbackTrans
      End If
      
      Percent = DivideByCero(j, LenSqlstmt) * 100
      Cancel = False
      RaiseEvent Progress(Percent, Descrip, Cancel)
    End If
    
    If Cancel Then Exit Function
    
    i = j + 4
  Wend
  
  ExecuteBatch = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "ExecuteBatch", C_Module, ""
ExitProc:
End Function

Public Function Execute(ByVal sqlstmt As String, ByRef ErrDescription As String) As Boolean
  On Error GoTo ControlError
  
  Dim bErrorTraped As Boolean

TryAgain:
  m_cn.Execute sqlstmt

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

Public Function OpenRs(ByVal sqlstmt As String, _
                       ByRef rs As Recordset) As Boolean
                       
  On Error GoTo ControlError
  Dim bErrorTraped As Boolean

  If rs Is Nothing Then
    Set rs = New Recordset
  Else
    If rs.State <> adStateClosed Then rs.Close
  End If
  
TryAgain:

  Err.Clear

  rs.CursorLocation = adUseClient
  rs.Open sqlstmt, m_cn, adOpenDynamic, adLockOptimistic

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
  MngError Err, "CloseConnection", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' funciones friend
' funciones privadas
Private Function GetInfoTabla(ByVal sqlstmt As String, _
                              ByVal NombreTabla As String, _
                              ByRef sqlstmtCreate As String, _
                              ByRef sqlstmtInsert As String, _
                              ByVal TipoServer As crTipoServer, _
                              ByRef rs As Recordset, _
                              ByRef wasSelect As Boolean) As Boolean
  Dim F   As ADODB.Field
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
  
  If Not OpenRs(sqlstmt, rs) Then Exit Function
  
  Dim FieldName As String
  Dim NextFieldNameAux As Integer
  
  For Each F In rs.fields
    FieldName = Trim(F.name)
    
    If FieldName = "" Then
      NextFieldNameAux = NextFieldNameAux + 1
      FieldName = "CCCC" & NextFieldNameAux
    End If
    
    If TipoServer = SERVER_ACCESS Then
      sqlstmtCreate = sqlstmtCreate + "[" + FieldName + "] " + AccessTextForType(F.Type, F.DefinedSize) + " ,"
    Else
      sqlstmtCreate = sqlstmtCreate + "[" + FieldName + "] " + SQLTextForType(F.Type, F.DefinedSize) + " ,"
    End If
    sqlstmtInsert = sqlstmtInsert + "[" + FieldName + "] ,"
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
    Debug.Print "No esta previsto el tipo " + Trim(Tipo)
    Retval = "TEXT" '"STRING(50)"
  End Select
  AccessTextForType = Retval
End Function

Public Function ValField(ByRef fields As ADODB.fields, _
                         ByVal FieldName As String) As Variant
  On Error GoTo ControlError
  
  Dim Field As ADODB.Field
  
  If IsNumeric(FieldName) Then
    Set Field = fields(CInt(FieldName))
  Else
    Set Field = fields(FieldName)
  End If
  
  If Field Is Nothing Then
    Err.Raise vbObjectError + csErrorVal, "VAL function CSOAPI", "No se paso un campo. Error interno"
  End If
  
  If IsNull(Field.Value) Then
    Select Case Field.Type
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
    ValField = Field.Value
  End If

  Exit Function
ControlError:
  If Err.Number = 3265 Then Err.Description = "Falto el campo " & FieldName & vbCrLf & "Descripción original:" & Err.Description
  Err.Raise Err.Number, Err.source, Err.Description, Err.HelpFile, Err.HelpContext
End Function

Private Function SQLFieldToString(Campo As ADODB.Field) As String
  Dim Retval As String
  If IsNull(Campo.Value) Then
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
      Retval = "'" + Replace(Campo.Value, "'", "''") + "'"
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
    Debug.Print "No esta previsto el tipo " + Trim(Tipo)
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
  MngError Err, "pReconect", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function pExecuteBatch(ByVal sqlstmt As String, _
                              ByVal DataBaseName As String, _
                              Optional ByVal DataBaseWasChecked As Boolean = False) As Boolean
  On Error GoTo ControlError
  
  
  m_cn.Execute sqlstmt
  
  DoEvents
  
Success:
  pExecuteBatch = True
  
  GoTo ExitProc
ControlError:
  Dim Continue As Boolean
  RaiseEvent ScriptError(Err.Description, Err.Number, sqlstmt, Continue)
  
  If Continue Then Resume Success
  
  MngError Err, "Execute", C_Module, vbCrLf & vbCrLf & sqlstmt & vbCrLf & vbCrLf
ExitProc:
End Function

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

Public Function GetSQLObjectName(ByVal sqlstmt As String, ByVal sWordToSearch1 As String, ByVal sWordToSearch2 As String) As String
    On Error GoTo ControlError
    m_Start = 1
    GetSQLObjectName = FindCreate(sqlstmt, sWordToSearch1, sWordToSearch2)
    Exit Function
ControlError:
    GetSQLObjectName = ""
End Function

Private Function FindCreate(ByVal sqlstmt As String, ByVal sWordToSearch1 As String, ByVal sWordToSearch2 As String) As String
    Dim word As String
    Dim Nombre As String
    
    Do
        word = GetWord(sqlstmt)
        
        If UCase(word) = sWordToSearch1 Then
            Nombre = FindProcedure(sqlstmt, sWordToSearch2)
        End If
    Loop Until Nombre <> ""
    FindCreate = Nombre
End Function

Private Function GetWord(ByVal sqlstmt As String) As String
    Dim word        As String
    
    ' leo una palabra
    word = GetWord2(sqlstmt)
    

    ' mientras sea un principio de comentario
    While EsBeginComentario(word)
        
        ' busco un fin de comentario
        Do
            word = GetWord2(sqlstmt)
            
            If word = "!!@@##$$" Then
                GetWord = word
                Exit Function
            End If
            
        Loop Until EsEndComentario(word)
        
        ' leo la proxima palabra
        word = GetWord2(sqlstmt)
    Wend
    ' devuelvo la palabra que obviamente no es un comentario
    GetWord = word
    
End Function

Private Function FindProcedure(ByVal sqlstmt As String, ByVal sWordToSearch As String) As String
    Dim word As String
    Dim parentesis As Integer
    word = GetWord(sqlstmt)
    If UCase(word) = sWordToSearch Then
        FindProcedure = GetWord(sqlstmt)
        
        ' quito los parentesis si es que hay
        parentesis = InStr(1, FindProcedure, "(")
        If parentesis Then
            FindProcedure = Mid(FindProcedure, 1, parentesis - 1)
        End If
    Else
        FindProcedure = ""
    End If
End Function

Private Function GetWord2(ByVal sqlstmt As String)
    Dim nespacio    As Integer
    Dim nreturn     As Integer
    Dim nfinWord    As Integer
    Dim nnextStart  As Integer
    Dim caracter    As String
    
    
    ' si ya no hay texto donde buscar disparo un error
    If m_Start = 0 Then
        Err.Raise vbObjectError + ERROR_IN_GET_NOMBRE
    End If
    
    ' una palabra comienza en donde estoy parado y termina en un espcio o char 13+ char 10
    nespacio = InStr(m_Start, sqlstmt, " ")
    nreturn = InStr(m_Start, sqlstmt, vbCrLf)
    
    ' cadena de ejemplo "hola"
    If nespacio = 0 And nreturn = 0 Then
        nfinWord = Len(sqlstmt)
        ' si no encuentro lo que busco en esta palabra, entonces
        ' la proxima vez que ejecute esta funcion se dispara un
        ' error por que ya no hay texto donde buscar
        nnextStart = 0
    
    ' cadena de ejemplo "hola<enter>"
    ElseIf nespacio = 0 Then
        nfinWord = nreturn
        ' es un fin de linea asi que avanzo dos caracteres
        nnextStart = nreturn + 2
        
    ' cadena de ejemplo "hola "
    ElseIf nreturn = 0 Then
        nfinWord = nespacio
        
        ' es un espacio asi que avanzo hasta el ultimo espacio
        ' ejemplo "hola   chau" nnextStart =7
        
        ' obtengo el proximo caracter
        caracter = Mid(sqlstmt, nfinWord + 1, 1)
        
        ' mientras sea un espacio, avanzo el limite
        Do While caracter = " "
            nfinWord = nfinWord + 1
            caracter = Mid(sqlstmt, nfinWord + 1, 1)
        Loop
        nnextStart = nfinWord + 1
        
    ' cadena de ejemplo "hola<enter> "
    ElseIf nreturn < nespacio Then
        nfinWord = nreturn
        ' es un fin de linea asi que avanzo dos caracteres
        nnextStart = nreturn + 2
        
    ' cadena de ejemplo "hola <enter>"
    Else
        nfinWord = nespacio
        
        ' es un espacio asi que avanzo hasta el ultimo espacio
        ' ejemplo "hola   chau" nnextStart =7
        
        ' obtengo el proximo caracter
        caracter = Mid(sqlstmt, nfinWord + 1, 1)
        
        ' mientras sea un espacio, avanzo el limite
        Do While caracter = " "
            nfinWord = nfinWord + 1
            caracter = Mid(sqlstmt, nfinWord + 1, 1)
        Loop
        nnextStart = nfinWord + 1
    End If
    
    ' obtengo la palabra sin espacios
    GetWord2 = Trim(Mid(sqlstmt, m_Start, nfinWord - m_Start))
    m_Start = nnextStart
End Function

Private Function EsBeginComentario(word As String) As Boolean
    If Not Mid(word, 1, 2) = "/*" Then Exit Function
    If Len(word) < 2 Then Exit Function
    If Mid(word, Len(word) - 1, 2) = "*/" Then Exit Function
    EsBeginComentario = True
End Function

Private Function EsEndComentario(word As String) As Boolean
    If Len(word) < 2 Then Exit Function
    If Not Mid(word, Len(word) - 1, 2) = "*/" Then Exit Function
    EsEndComentario = True
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError

  Set m_cn = New Connection

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  CloseConnection
  
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
