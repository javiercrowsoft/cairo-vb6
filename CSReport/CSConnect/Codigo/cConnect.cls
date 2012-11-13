VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cConnect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cConnect
' 30-10-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cConnect"
' estructuras
' variables privadas
Private m_StrConnect As String
Private m_DataBase As String
Private m_Server As String
Private m_User As String
Private m_Password As String
Private m_DataSource As String
Private m_DataSourceType As csDataSourceType
Private m_ColumnsInfo As cColumnsInfo
Private m_Parameters As cParameters

' eventos
' propiedades publicas
Public Property Get StrConnect() As String
  StrConnect = m_StrConnect
End Property

Public Property Let StrConnect(ByVal rhs As String)
  m_StrConnect = rhs
End Property

Public Property Get DataBase() As String
  DataBase = m_DataBase
End Property

Public Property Let DataBase(ByVal rhs As String)
  m_DataBase = rhs
End Property

Public Property Get Server() As String
  Server = m_Server
End Property

Public Property Let Server(ByVal rhs As String)
  m_Server = rhs
End Property

Public Property Get User() As String
  User = m_User
End Property

Public Property Let User(ByVal rhs As String)
  m_User = rhs
End Property

Public Property Get Password() As String
  Password = m_Password
End Property

Public Property Let Password(ByVal rhs As String)
  m_Password = rhs
End Property

Public Property Get DataSource() As String
  DataSource = m_DataSource
End Property

Public Property Let DataSource(ByVal rhs As String)
  m_DataSource = rhs
End Property

Public Property Get DataSourceType() As csDataSourceType
  DataSourceType = m_DataSourceType
End Property

Public Property Let DataSourceType(ByVal rhs As csDataSourceType)
  m_DataSourceType = rhs
End Property

Public Property Get ColumnsInfo() As cColumnsInfo
  Set ColumnsInfo = m_ColumnsInfo
End Property

Public Property Let ColumnsInfo(ByVal rhs As cColumnsInfo)
  Set m_ColumnsInfo = rhs
End Property

Public Property Get Parameters() As cParameters
  Set Parameters = m_Parameters
End Property

Public Property Let Parameters(ByVal rhs As cParameters)
  Set m_Parameters = rhs
End Property

' propiedades privadas
' funciones publicas
Public Function ShowOpenConnection() As Boolean
  On Error GoTo ControlError

  Dim f As fDBInfo

  Set f = New fDBInfo

  f.Show vbModal

  If Not f.Ok Then GoTo ExitProc

  With f
    m_DataBase = .DataBase
    m_DataSource = .DataSource
    m_DataSourceType = .DataSourceType
    m_Password = .Password
    m_Server = .Server
    m_StrConnect = .StrConnect
    m_User = .User
  End With


  ShowOpenConnection = True
  GoTo ExitProc
ControlError:
  MngError Err(), "ShowOpenConnection", C_Module, ""
ExitProc:
  Unload f
End Function

Public Function GetDataSourceColumnsInfo(ByVal DataSource As String, ByVal DataSourceType As csDataSourceType) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt As String

  Dim f As fSPLaunch
  If DataSourceType = csDataSourceType.cdDTProcedure Then
    If Not FillParameters(DataSource) Then GoTo ExitProc

    Set f = New fSPLaunch

    Set f.Parameters = m_Parameters
    f.Show vbModal

    If Not f.Ok Then GoTo ExitProc

    With f

      sqlstmt = Trim("[" & DataSource & "] " & .sqlParameters)

    End With

  ElseIf DataSourceType = csDataSourceType.cdDTSqlstmt Then
    
    sqlstmt = DataSource
  
  Else
  
    ' Tabla
    sqlstmt = "select * from [" & DataSource & "]"

  End If

  If Not FillColumns(sqlstmt) Then GoTo ExitProc

  GetDataSourceColumnsInfo = True

  GoTo ExitProc
ControlError:
  MngError Err(), "GetDataSourceColumnsInfo", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload f
End Function

Public Function FillColumns(ByVal sqlstmt As String) As Boolean
  On Error GoTo ControlError

  Dim c As ADODB.Field
  Dim i As Integer
  Dim rs As ADODB.Recordset
  Dim db As CSDataBaseClient2.cDataBase

  Set db = New CSDataBaseClient2.cDataBase
  If Not db.InitDB(, , , , m_StrConnect) Then GoTo ExitProc

  If Not db.OpenRs(sqlstmt, rs) Then GoTo ExitProc

  Set m_ColumnsInfo = New cColumnsInfo

  For i = 0 To rs.Fields.Count - 1
    With m_ColumnsInfo.Add()
      Set c = rs.Fields(i)
      .Name = c.Name
      .Position = i
      .TypeColumn = c.Type
    End With
  Next

  FillColumns = True

  GoTo ExitProc
ControlError:
  MngError Err(), "FillColumns", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  rs.Close
  db.CloseDb
  Set db = Nothing
  Set rs = Nothing
End Function

Public Function GetDataBaseFromStrConnect(ByVal StrConnect As String) As String
  GetDataBaseFromStrConnect = GetToken(StrConnect, "Initial Catalog")
End Function

Public Function GetServerFromStrConnect(ByVal StrConnect As String) As String
  GetServerFromStrConnect = GetToken(StrConnect, "Data Source")
End Function

Public Function GetUserFromStrConnect(ByVal StrConnect As String) As String
  GetUserFromStrConnect = GetToken(StrConnect, "User ID=")
End Function

Public Function GetPasswordFromStrConnect(ByVal StrConnect As String) As String
  GetPasswordFromStrConnect = GetToken(StrConnect, "Password=")
End Function

Public Function GetNewConnect(Optional ByVal StrConnect As String = "") As String
  On Error GoTo ControlError

  Dim oDataLink As MSDASC.DataLinks
  Dim oResult As ADODB.Connection

  StrConnect = Trim(StrConnect)

  If StrConnect = "" Then
    Set oDataLink = New MSDASC.DataLinks
    Set oResult = oDataLink.PromptNew()
  Else
    Set oResult = New ADODB.Connection
    oResult.Open StrConnect
  End If

  If oResult Is Nothing Then Exit Function

  m_StrConnect = oResult.ConnectionString
  m_DataBase = GetDataBaseFromStrConnect(m_StrConnect)
  m_Server = GetServerFromStrConnect(m_StrConnect)
  m_User = GetUserFromStrConnect(m_StrConnect)
  m_Password = GetPasswordFromStrConnect(m_StrConnect)

  GetNewConnect = m_StrConnect
  GoTo ExitProc
ControlError:
  MngError Err(), "GetNewConnect", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Set oDataLink = Nothing
  oResult.Close
  Set oResult = Nothing
End Function

Public Function FillParameters(ByVal ProcedureName As String) As Boolean
  On Error GoTo ControlError

  Dim rs As ADODB.Recordset
  Dim cn As ADODB.Connection

  Dim mouse As CSKernelClient2.cMouseWait
  Set mouse = New CSKernelClient2.cMouseWait

  On Error Resume Next

  Set cn = New ADODB.Connection
  Err.Clear

  cn.Open m_StrConnect

  If Err.Number <> 0 Then
    If m_Password = "" Then
      MngError Err(), "FillParameters", C_Module, "Fallo la conexion. Si ud esta conectandose a SQL Server debe marcar el checkbox 'Allow saving password'", "Fallo de conexión", , CSKernelClient2.csErrorType.csErrorAdo, cn
    End If
    GoTo ExitProc
  End If

  On Error GoTo ControlError

  Set rs = cn.OpenSchema(adSchemaProcedureParameters, Array(Empty, Empty, ProcedureName, Empty))
  
  If m_Parameters Is Nothing Then Set m_Parameters = New cParameters
  
  Dim Param       As cParameter
  Dim Parameters  As cParameters
  
  ' Para borrar los parametros
  ' que ya no estan en el sp
  ' Nota: no limpio la coleccion de parametros para no perder los valores por defecto
  '

'  For Each Param In m_Parameters
'    Param.Position = -100
'  Next
  
  Set Parameters = New cParameters
  
  Do While Not rs.EOF
    If ValField(rs(5)) <> 4 Then
    
      For Each Param In m_Parameters
        If Param.Name = ValField(rs(3)) Then
          Exit For
        End If
      Next
    
      Set Param = Parameters.Add(Param)
      'If Param Is Nothing Then Set Param = m_Parameters.Add()
    
      With Param
        .Name = ValField(rs(3))
        .Position = ValField(rs(4))
        .TypeColumn = ValField(rs(9))
        .HasDefault = ValField(rs(6))
        .DefaultValue = ValField(rs(7))
        .MaxLength = ValField(rs(10))
        .IsNullable = ValField(rs(8))
      End With
    End If
    rs.MoveNext
  Loop


'  For Each Param In m_Parameters
'    If Param.Position <> -100 Then
'      Parameters.Add Param
'    End If
'  Next
  
  Set m_Parameters = Parameters
  Set Parameters = Nothing

  FillParameters = True

  GoTo ExitProc
ControlError:
  MngError Err(), "FillParameters", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  rs.Close
  cn.Close
  Set rs = Nothing
  Set cn = Nothing
End Function

' funciones friend
' funciones privadas
Private Function GetToken(ByVal Source As String, ByVal Token As String, Optional ByVal Delimiter As String = ";") As String
  Source = Trim(Source)
  If Source = "" Then Exit Function

  Dim p As Integer
  Dim p2 As Integer

  p = InStr(1, Source, Token, vbTextCompare)
  If p = 0 Then Exit Function

  p = InStr(p + Len(Token), Source, "=", vbTextCompare)
  If p = 0 Then Exit Function

  p2 = InStr(p, Source, Delimiter, vbTextCompare)
  If p2 = 0 Then p2 = Len(Source) + 1

  GetToken = Mid(Source, p + 1, p2 - p - 1)
End Function

Private Sub Class_Initialize()
  Set m_Parameters = New cParameters
End Sub

' construccion - destruccion
Private Sub Class_Terminate()
  On Error Resume Next
  Set m_ColumnsInfo = Nothing
  Set m_Parameters = Nothing
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

