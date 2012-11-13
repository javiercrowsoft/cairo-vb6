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
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDataBase
' 04-01-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' FunctionNamees

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDataBase"

Private Const c_ErrorSqlInfoAdd = "@@ErrorSqlInfoAdd@@"

' estructuras
' variables privadas
Private WithEvents m_fCancelQuery As fCancelQuery
Attribute m_fCancelQuery.VB_VarHelpID = -1
Private WithEvents m_cn           As ADODB.Connection
Attribute m_cn.VB_VarHelpID = -1
Private m_connect                 As String

Private m_Rs              As ADODB.Recordset
Private m_EOF_Field       As Boolean
Private m_NextField       As Integer
Private m_fieldtype       As csFieldType

Private m_UserId          As Long

Private m_Transactionlevel As Integer

Private m_serverName  As String
Private m_userName    As String
Private m_password    As String

Private m_OriginalStrConnect  As String

Private m_OpenRsCancel        As Boolean
Private m_OpenRsComplete      As Boolean
Private m_OpenRSExDescrip     As String
Private m_ShowCancelQuery     As Boolean

Private m_CommandTimeout      As Long
Private m_ConnectionTimeout   As Long

Private m_MaxTryOpenRs        As Long
Private m_MaxTryExecute       As Long

Private m_LastDBError         As String

' eventos
Public Event OpenRSProgress()
' propiedades publicas
Public Property Get Silent() As Boolean
  Silent = gbSilent
End Property
Public Property Let Silent(ByVal rhs As Boolean)
  gbSilent = rhs
End Property
Public Property Get DBIsOpen() As Boolean
  If m_cn Is Nothing Then Exit Property
  DBIsOpen = m_cn.State = adStateOpen
End Property
Public Property Get CommandTimeout() As Long
  CommandTimeout = m_CommandTimeout
End Property

Public Property Let CommandTimeout(ByVal rhs As Long)
  m_CommandTimeout = rhs
  If m_cn Is Nothing Then Exit Property
  m_cn.CommandTimeout = rhs
End Property

Public Property Get ConnectionTimeout() As Long
  ConnectionTimeout = m_ConnectionTimeout
End Property

Public Property Let ConnectionTimeout(ByVal rhs As Long)
  m_ConnectionTimeout = rhs
  If m_cn Is Nothing Then Exit Property
  m_cn.ConnectionTimeout = rhs
End Property

Public Property Get OpenRsCancel() As Boolean
  OpenRsCancel = m_OpenRsCancel
End Property

Public Property Let OpenRsCancel(ByVal rhs As Boolean)
  m_OpenRsCancel = rhs
  If rhs Then m_OpenRsComplete = True
End Property

Public Property Get OriginalStrConnect() As String
  OriginalStrConnect = m_OriginalStrConnect
End Property

Public Property Let OriginalStrConnect(ByVal rhs As String)
  m_OriginalStrConnect = rhs
End Property

Public Property Let UserId(ByVal rhs As Long)
  m_UserId = rhs
End Property
Public Property Get UserId() As Long
  UserId = m_UserId
End Property

Public Property Get Transactionlevel() As Integer
  Transactionlevel = m_Transactionlevel
End Property

Public Property Set Rs(rhs As ADODB.Recordset)
  Set m_Rs = rhs
  m_EOF_Field = False
  m_NextField = 0
End Property
Public Property Get EOF() As Boolean
  EOF = m_Rs.EOF
End Property
Public Property Get EOF_Field() As Boolean
  EOF_Field = m_EOF_Field
End Property
Public Property Get ServerVersion() As csServerVersion
  Dim sver As String
  
  sver = Mid(m_cn.Properties("DBMS Version").Value, 1, 2)
  
  If sver = "06" Then
    ServerVersion = csVSql65
  ElseIf sver = "07" Then
    ServerVersion = csVSql70
  ElseIf sver = "03" Then
    ServerVersion = csVSAccess
  End If
End Property
Public Property Get FieldType() As csFieldType
  FieldType = m_fieldtype
End Property
Public Property Get TypeServidor() As crServerType
  If InStr(1, m_cn.ConnectionString, "Microsoft.Jet", vbTextCompare) Then
    TypeServidor = SERVER_ACCESS
  Else
    TypeServidor = SERVER_SQL
  End If
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

Public Property Get LastStrConnectUsed() As String
  LastStrConnectUsed = m_connect
End Property

Public Property Get dbName() As String
  If m_cn Is Nothing Then Exit Property
  dbName = m_cn.DefaultDatabase
End Property

Public Property Get ServerName() As String
  If m_cn Is Nothing Then Exit Property
  ServerName = m_serverName
End Property

Public Property Get UserName() As String
  If m_cn Is Nothing Then Exit Property
  UserName = m_userName
End Property

Public Property Get OpenRSExDescrip() As String
  OpenRSExDescrip = m_OpenRSExDescrip
End Property

Public Property Let OpenRSExDescrip(ByVal rhs As String)
  m_OpenRSExDescrip = rhs
End Property

Public Property Get MaxTryOpenRs() As Long
  MaxTryOpenRs = m_MaxTryOpenRs
End Property
Public Property Let MaxTryOpenRs(ByVal rhs As Long)
  m_MaxTryOpenRs = rhs
End Property

Public Property Get MaxTryExecute() As Long
  MaxTryExecute = m_MaxTryExecute
End Property
Public Property Let MaxTryExecute(ByVal rhs As Long)
  m_MaxTryExecute = rhs
End Property

Public Property Get LastDBError() As String
  LastDBError = m_LastDBError
End Property

' propiedades friend
Public Property Get Password() As String
  Password = m_password
End Property
' propiedades privadas
' funciones publicas
Public Function SaveSp(ByRef sqlstmt As String, _
                       ByRef Rs As ADODB.Recordset, _
                       Optional ByVal TimeOut As Long = -1, _
                       Optional ByVal FunctionName As String = "", _
                       Optional ByVal Module As String = "", _
                       Optional ByVal Title As String = "Error", _
                       Optional ByVal Level As Integer) As Boolean
  
  Dim oldCommandTimeout As Long
  
  oldCommandTimeout = m_CommandTimeout
  
  If TimeOut <> -1 Then
    m_CommandTimeout = TimeOut
    m_cn.CommandTimeout = TimeOut
  End If
  
  SaveSp = OpenRs(sqlstmt, Rs, , , , _
                FunctionName, Module, Title, Level)
  
  m_cn.CommandTimeout = oldCommandTimeout
  m_CommandTimeout = oldCommandTimeout

End Function

Public Function OpenSchema(ByVal Schema As SchemaEnum, Optional ByVal Restrictions, Optional ByVal SchemaID)
  
  If Not IsMissing(Restrictions) And Not IsMissing(SchemaID) Then
    Set OpenSchema = m_cn.OpenSchema(Schema, Restrictions, SchemaID)
  ElseIf Not IsMissing(Restrictions) Then
    Set OpenSchema = m_cn.OpenSchema(Schema, Restrictions)
  ElseIf Not IsMissing(SchemaID) Then
    Set OpenSchema = m_cn.OpenSchema(Schema, , SchemaID)
  Else
    Set OpenSchema = m_cn.OpenSchema(Schema)
  End If
End Function

Public Function GetChunk(ByRef Field As ADODB.Field, ByVal Size As Long, ByRef Chunk() As Byte) As Boolean
  On Error GoTo ControlError

  If Field.Attributes And adFldLong Then
    Chunk = Field.GetChunk(Size)
  Else
    Exit Function
  End If
  
  GetChunk = True

  GoTo ExitProc
ControlError:
  MngError Err, "GetChunk", C_Module, vbNullString, Nothing
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function AppendChunk(ByRef Field As ADODB.Field, ByRef Chunk() As Byte) As Boolean
  On Error GoTo ControlError
  
  If Field.Attributes And adFldLong Then
    Field.AppendChunk Chunk
  Else
    Exit Function
  End If
  
  AppendChunk = True

  GoTo ExitProc
ControlError:
  MngError Err, "AppendChunk", C_Module, vbNullString, Nothing
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function InitDB(Optional ByVal sNameDb As String, _
                       Optional ByVal sServer As String = "Access", _
                       Optional ByVal sUser As String = "sa", _
                       Optional ByVal sPassword = "", _
                       Optional ByVal sConnect As Variant) As Boolean
  
  If IsMissing(sConnect) Then sConnect = ""
  InitDB = InitDBEx(sNameDb, sServer, sUser, sPassword, sConnect, False)
End Function

Public Function InitDBEx(Optional ByVal sNameDb As String, _
                         Optional ByVal sServer As String = "Access", _
                         Optional ByVal sUser As String = "sa", _
                         Optional ByVal sPassword = "", _
                         Optional ByVal sConnect As String, _
                         Optional ByVal UseOlDB As Boolean) As Boolean

    On Error GoTo ControlError
    
    Dim MouseWait As New cMouseWait
    MouseWait.Wait
    
    If m_cn Is Nothing Then Set m_cn = New ADODB.Connection
    
    CloseDb
    
    m_OriginalStrConnect = IIf(IsMissing(sConnect), "", sConnect)
    
    If sConnect = "" Then
    
        If sServer = "Access" Then
            ' Access
            sConnect = "PROVIDER=Microsoft.Jet.OLEDB.4.0;Data Source=" & sNameDb
        
            'DEFINO EL Type DE CURSOR
            m_cn.CursorLocation = adUseClient
        
        Else
            ' sql
            If VBA.Val(IniGet(c_DB_USESQLOLEDB, 1)) <> 0 Or UseOlDB Then
              If VBA.Val(IniGet(c_DB_USENTSECURITY, 1)) <> 0 Or (sUser = "" And sPassword = "") Then
                sConnect = "Provider=SQLOLEDB.1;"
                sConnect = sConnect & "Integrated Security=SSPI;"
                sConnect = sConnect & "Persist Security Info=False;"
                sConnect = sConnect & "Initial Catalog=" & sNameDb & ";"
                sConnect = sConnect & "Data Source=" & sServer & ";"
              Else
                sConnect = "Provider=SQLOLEDB.1;"
                sConnect = sConnect & "Persist Security Info=True;"
                sConnect = sConnect & "Data Source=" & sServer & ";"
                sConnect = sConnect & "User ID=" & sUser & ";"
                sConnect = sConnect & "Password=" & sPassword & ";"
                sConnect = sConnect & "Initial Catalog=" & sNameDb & ";"
              End If
            Else
              If VBA.Val(IniGet(c_DB_USENTSECURITY, 1)) <> 0 Then
                sConnect = "PROVIDER=MSDASQL;"
                sConnect = sConnect & "driver={SQL Server};"
                sConnect = sConnect & "server=" & sServer & ";"
                sConnect = sConnect & "Trusted_Connection=yes" & ";"
                sConnect = sConnect & "database=" & sNameDb & ";"
              Else
                sConnect = "PROVIDER=MSDASQL;"
                sConnect = sConnect & "driver={SQL Server};"
                sConnect = sConnect & "server=" & sServer & ";"
                sConnect = sConnect & "uid=" & sUser & ";"
                sConnect = sConnect & "pwd=" & sPassword & ";"
                sConnect = sConnect & "database=" & sNameDb & ";"
              End If
            End If
        End If
        
        m_serverName = sServer
        m_userName = sUser
        m_password = sPassword
    Else
      m_serverName = GetToken("server=", sConnect)
      m_userName = GetToken("uid=", sConnect)
      m_password = GetToken("pwd=", sConnect)
    End If
    
    m_connect = sConnect
    
    If LCase$(Right$(sConnect, 4)) = ".udl" _
       And LCase$(Left$(sConnect, 10)) <> "file name=" Then
      sConnect = "file name=" & sConnect
    End If
    
    m_cn.ConnectionTimeout = m_ConnectionTimeout
    
    m_cn.Open sConnect
    
    m_cn.CommandTimeout = m_CommandTimeout
    
    InitDBEx = True
    Exit Function
ControlError:
    MngError Err, "InitDBEx", _
             "mDBGeneral", _
             "Si se esta conectando a un servidor SQL verifique el servidor, el UID y el Pasword para ese UID" & vbCrLf & vbCrLf & sConnect, _
             Nothing, _
             "Error al iniciar la base", csErrorFatal, csErrorAdo, m_cn
End Function

Public Sub CloseDb()
  On Error Resume Next
  
  If m_Transactionlevel Then
    RollBackTransaction
  End If
  
  m_Transactionlevel = 0
  m_cn.Close
  m_userName = ""
  m_serverName = ""

  ' Sino destruimos el objeto
  ' y lo volvemos a crear adodb usa
  ' el cache y nos hace pito furelete
  '
  Set m_cn = Nothing
  Set m_cn = New ADODB.Connection

End Sub


Public Function AddNew(ByRef Rs As ADODB.Recordset) As Boolean
  On Error GoTo ControlError
  
  Rs.AddNew
  
  AddNew = True
  GoTo ExitProc
ControlError:
  MngError Err, "AddNew", C_Module, vbNullString, Nothing
ExitProc:
End Function

Public Function Update(ByRef Rs As ADODB.Recordset) As Boolean
  On Error GoTo ControlError
  
  Rs.Update
  
  Update = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "Update", C_Module, vbNullString, Nothing
ExitProc:
End Function

Public Function Delete(ByRef Rs As ADODB.Recordset) As Boolean
  On Error GoTo ControlError
  
  Rs.Delete
  
  Delete = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "Delete", C_Module, vbNullString, Nothing
ExitProc:
End Function

Public Function OpenRsEX(ByVal ShowWindowCancel As Boolean, _
                         ByVal RaiseEventProgress As Boolean, _
                         ByVal ShowModal As Boolean, _
                         ByRef sqlstmt As String, _
                         ByRef Rs As ADODB.Recordset, _
                         Optional ByVal cursorType As csTypeCursor = csRsStatic, _
                         Optional ByVal lockType As csTypeLock = csLockGrpOptimistic, _
                         Optional ByVal nOptiones As csCommandType = csCmdUnknown, _
                         Optional ByVal FunctionName As String = "", _
                         Optional ByVal Module As String = "", _
                         Optional ByVal Title As String = "Error", _
                         Optional ByVal Level As Integer) As Boolean
  
  On Error GoTo ControlError
  
  Dim Mouse As cMouse
  Set Mouse = New cMouse
  
  Mouse.MouseSet vbArrowHourglass
  
  If Rs Is Nothing Then Set Rs = New ADODB.Recordset
  
  If Rs.State <> adStateClosed Then Rs.Close
  
  Rs.CursorLocation = adUseClient
  
  Rs.Open sqlstmt, m_cn, adOpenStatic, adLockReadOnly, adAsyncExecute
  
  m_OpenRsComplete = False
  m_OpenRsCancel = False
  
  If ShowWindowCancel Then
  
    If gbSilent Then
      
      m_ShowCancelQuery = False
      pOpenRSEx Rs, RaiseEventProgress
    
    Else
    
      Set m_fCancelQuery = New fCancelQuery
      Load m_fCancelQuery
      
      With m_fCancelQuery
        If m_OpenRSExDescrip <> "" Then
          .lbDescrip.Caption = "Obteniendo datos para" & vbCrLf & vbCrLf & m_OpenRSExDescrip
          .Height = (.Height - .ScaleHeight) + .lbDescrip.Top + .lbDescrip.Height + 30
        Else
          .Height = (.Height - .ScaleHeight) + .lbDescrip.Top - 10
        End If
        
        If ShowModal Then
          .RaiseEventProgress = RaiseEventProgress
          Set .Rs = Rs
          .HaveToRaiseEvent = True
          m_ShowCancelQuery = False
          .Show vbModal
        Else
          m_ShowCancelQuery = True
          pOpenRSEx Rs, RaiseEventProgress
        End If
      End With
    
    End If
  End If
  
  ' Si llego hasta aqui y no cancelo todo OK
  If Not m_OpenRsCancel Then
  
    If Rs.State <> adStateOpen Then
      Err.Raise vbObjectError + 1522, "CSDataBase", "Error al obtener el recordset asincronicamente"
    Else
    
      If Not Rs.EOF Then
        If Rs.fields(0).Name = "error_in_sp_id" Then
          Err.Raise vbObjectError + 1522, "CSDataBase", Rs.fields(0).Value
        End If
      End If
    
      OpenRsEX = True
    End If
  End If
  
  Exit Function
ControlError:
  MngError Err, FunctionName, Module, sqlstmt, Rs, _
           Title, Level, csErrorAdo, m_cn
  Resume ExitProc
ExitProc:
  On Error Resume Next
  Rs.Close
  Set Rs = Nothing
  
  If Not m_fCancelQuery Is Nothing Then
    Unload m_fCancelQuery
    Set m_fCancelQuery = Nothing
  End If
End Function

Private Sub pOpenRSEx(ByRef Rs As Recordset, ByVal RaiseEventProgress As Boolean)
  Dim n As Long
  
  Do
    DoEvents
    DoEvents
    DoEvents

    If m_OpenRsCancel Then
      If Rs.State = adStateOpen Then Rs.Close
      If Rs.State = adStateExecuting Then Rs.Cancel
      GoTo ExitProc
    End If
    
    If RaiseEventProgress Then
      RaiseEvent OpenRSProgress
    End If
    
    If Not m_fCancelQuery Is Nothing Then
      m_fCancelQuery.ShowTime
    End If
    
    Sleep 100
    
    If m_ShowCancelQuery Then
      If n = 10 Then
        
        If pShowCancelQuery() Then
        
          m_ShowCancelQuery = False
          
        End If
      Else
        n = n + 1
      End If
    End If
  Loop Until m_OpenRsComplete

ExitProc:
  On Error Resume Next
  If Not m_fCancelQuery Is Nothing Then
    m_fCancelQuery.Hide
  End If
End Sub

Private Function pShowCancelQuery() As Boolean
  On Error Resume Next
  
  Err.Clear
  
  m_fCancelQuery.Show vbModeless
  
  pShowCancelQuery = Err.Number = 0
  
  Err.Clear
End Function

Private Sub m_cn_InfoMessage(ByVal pError As ADODB.Error, adStatus As ADODB.EventStatusEnum, ByVal pConnection As ADODB.Connection)
'
End Sub

Private Sub m_fCancelQuery_Cancel(ByRef bClose As Boolean)
  If Ask("Desea cancelar el comando", vbNo, "Obteniendo datos") Then
    OpenRsCancel = True
    bClose = True
  End If
End Sub

Private Sub m_fCancelQuery_OpenRs()
  pOpenRSEx m_fCancelQuery.Rs, m_fCancelQuery.RaiseEventProgress
End Sub

' DEVUELVE UN RECORDSET
Public Function OpenRs(ByRef sqlstmt As String, _
                       ByRef Rs As ADODB.Recordset, _
                       Optional ByVal cursorType As csTypeCursor = csRsStatic, _
                       Optional ByVal lockType As csTypeLock = csLockGrpOptimistic, _
                       Optional ByVal nOptiones As csCommandType = csCmdUnknown, _
                       Optional ByVal FunctionName As String = "", _
                       Optional ByVal Module As String = "", _
                       Optional ByVal Title As String = "Error", _
                       Optional ByVal Level As Integer) As Boolean
    
  On Error GoTo ControlError

  Dim bErrorTraped  As Boolean
  Dim nTryCount     As Long

  If Screen.MousePointer = vbDefault Then
    Dim MouseWait As cMouseWait
    Set MouseWait = New cMouseWait
  End If
  
  If Rs Is Nothing Then Set Rs = New ADODB.Recordset

  If Rs.State <> adStateClosed Then Rs.Close

  Rs.CursorLocation = adUseClient

TryAgain:

  On Error GoTo ControlError
  
  Rs.Open sqlstmt, m_cn, cursorType, lockType, nOptiones
  
  OpenRs = True
  Exit Function

ControlError:
  pSaveError sqlstmt
  Resume ProcessError
ProcessError:

  If InStr(1, CSKernelClient2.ErrorDB, "@@ERROR_SP") Then
    nTryCount = m_MaxTryOpenRs + 1
  End If

  If nTryCount < m_MaxTryOpenRs Then
    nTryCount = nTryCount + 1

    If pReConnect(bErrorTraped, False) Then
      On Error GoTo 0
      GoTo TryAgain
    Else
      
      If Not bErrorTraped Then
        
        ' Si tuve un error me reconecto para que se cierre cualquier transaccion que
        ' pueda haber quedado abierta
        '
        pReConnect2
        
        MngError Err, FunctionName, Module, sqlstmt, Rs, _
                 Title, Level, csErrorAdo, m_cn
        
      End If
    End If
  Else
    
    pSaveError sqlstmt
    
    ' Si tuve un error me reconecto para que se cierre cualquier transaccion que
    ' pueda haber quedado abierta
    '
    pReConnect2
    
    MngError Err, FunctionName, Module, sqlstmt, Rs, _
             Title, Level, csErrorAdo, m_cn
  
  End If
  
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  If Rs.State <> adStateClosed Then Rs.Close
  Set Rs = Nothing
End Function

Public Sub DisconnectRecordset(ByRef Rs As ADODB.Recordset)
    Set Rs.ActiveConnection = Nothing
End Sub

Public Sub ConnectRecordset(ByRef Rs As ADODB.Recordset)
    Set Rs.ActiveConnection = m_cn
End Sub

Public Function ExistsInRecordset(ByVal Rs As ADODB.Recordset, ByVal Field As String, _
                        ByVal Value As String, ByRef Founded As Boolean, _
                        Optional ByVal FunctionName As String = "", _
                        Optional ByVal Module As String = "", _
                        Optional ByVal Title As String = "Error", _
                        Optional ByVal Level As csErrorLevel = csErrorInformation) As Boolean

    Dim filter As String
    
    On Error GoTo ControlError
        
    
    If Rs.EOF And Rs.BOF Then
        Founded = False
    Else
        Rs.MoveFirst
        
        filter = Field & " = " & Value
        Rs.Find filter, 0, adSearchForward
        
        If Rs.EOF Or Rs.BOF Then
            Founded = False
        Else
            Founded = UCase(Trim(Rs(Field))) = UCase(Trim(Value))
        End If
    End If
    ExistsInRecordset = True
    Exit Function
ControlError:
    MngError Err, FunctionName, Module, filter, Nothing, Title, Level
End Function

Public Function ExistsEnRecord(ByVal Rs As ADODB.Recordset, ByVal Value As String, ByRef Founded As Boolean, _
                        Optional ByVal FunctionName As String = "", _
                        Optional ByVal Module As String = "", _
                        Optional ByVal Title As String = "Error", _
                        Optional ByVal Level As csErrorLevel = csErrorInformation) As Boolean
  ExistsEnRecord = pExistsEnRecord(Rs, Value, Founded, True, FunctionName, Module, Title, Level)
End Function

Public Function ExistsEnRecordEx(ByVal Rs As ADODB.Recordset, ByVal Value As String, ByRef Founded As Boolean, _
                                 ByVal bLike As Boolean, _
                                 Optional ByVal FunctionName As String = "", _
                                 Optional ByVal Module As String = "", _
                                 Optional ByVal Title As String = "Error", _
                                 Optional ByVal Level As csErrorLevel = csErrorInformation) As Boolean
  ExistsEnRecordEx = pExistsEnRecord(Rs, Value, Founded, bLike, FunctionName, Module, Title, Level)
End Function

Private Function pExistsEnRecord(ByVal Rs As ADODB.Recordset, ByVal Value As String, ByRef Founded As Boolean, _
                                 ByVal bLike As Boolean, _
                                 Optional ByVal FunctionName As String = "", _
                                 Optional ByVal Module As String = "", _
                                 Optional ByVal Title As String = "Error", _
                                 Optional ByVal Level As csErrorLevel = csErrorInformation) As Boolean
    
    On Error GoTo ControlError
    
    Dim q As Integer
    
    Founded = False
    
    Value = LCase(Value)
    
    If Rs.EOF Or Rs.BOF Then
        Founded = False
    Else
    
        Dim f As ADODB.Field
        
        For q = 0 To Rs.fields.Count - 1
          Set f = Rs.fields(q)
      
          If Not IsNull(f.Value) Then
          
            Select Case f.Type
            
                Case adLongVarChar, adLongVarWChar, adChar, adVarChar, adVarWChar, adWChar
                  If bLike Then
                    Founded = InStr(1, f.Value, Value, vbTextCompare)
                  Else
                    Founded = LCase(Mid(f.Value, 1, Len(Value))) = Value
                  End If
                Case adBigInt, adBinary, adInteger, adLongVarBinary, adNumeric, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
                    If IsNumeric(Value) Then
                        Founded = f.Value = Value
                    End If
                Case adBoolean
                    ' Nunca contesto que si
                Case adCurrency, adSingle, adDecimal, adDouble
                    If IsNumeric(Value) Then
                        Founded = f.Value = Value
                    End If
                Case adDBTime, adDate, adDBDate, adDBTimeStamp
                    If IsDate(Value) Then
                        Founded = f.Value = Value
                    End If
            End Select
          
          End If
          
          If Founded Then Exit For
        Next
    
    End If
    
    pExistsEnRecord = True
    Exit Function
ControlError:
    MngError Err, FunctionName, Module, "Filtro: " & Value, Nothing, Title, Level
End Function

Public Function Execute(ByVal sqlstmt As String, _
                        Optional ByVal FunctionName As String = "", _
                        Optional ByVal Module As String = "", _
                        Optional ByVal Title As String = "Error", _
                        Optional ByVal Level As csErrorLevel = csErrorInformation) As Boolean
  On Error GoTo ControlError
  
  Dim bErrorTraped  As Boolean
  Dim nTryCount     As Long
  
  If Screen.MousePointer = vbDefault Then
    Dim MouseWait As cMouseWait
    Set MouseWait = New cMouseWait
  End If

TryAgain:
  
  On Error GoTo ControlError
  
  m_cn.Execute sqlstmt

  Execute = True
  
  GoTo ExitProc

ControlError:
  pSaveError sqlstmt
  Resume ProcessError
ProcessError:
  
  If InStr(1, CSKernelClient2.ErrorDB, "@@ERROR_SP") Then
    nTryCount = m_MaxTryExecute + 1
  End If
  
  If nTryCount < m_MaxTryExecute Then
    nTryCount = nTryCount + 1
    
    If pReConnect(bErrorTraped, False) Then
      On Error GoTo 0
      GoTo TryAgain
    Else
      If Not bErrorTraped Then
        
        ' Si tuve un error me reconecto para que se cierre cualquier transaccion que
        ' pueda haber quedado abierta
        '
        pReConnect2
        
        MngError Err, FunctionName, Module, sqlstmt, Nothing, Title, Level, csErrorAdo, m_cn
      
      End If
    End If
  Else
    
    pSaveError sqlstmt
    
    ' Si tuve un error me reconecto para que se cierre cualquier transaccion que
    ' pueda haber quedado abierta
    '
    pReConnect2
    
    MngError Err, FunctionName, Module, sqlstmt, Nothing, Title, Level, csErrorAdo, m_cn
  End If
  
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function sqlString(ByVal sValue As String) As String
    sqlString = "'" & Replace(sValue, "'", "''") & "'"
End Function

Public Function sqlDate(ByVal sValue As String) As String
    sqlDate = Format(sValue, csSqlDateString)
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

' Responde si un field esta activo
Public Function IsActive(ByRef retValue As Boolean, _
                            ByVal Table As String, _
                            ByVal Condition As String, _
                            Optional ByVal FunctionName As String = "", _
                            Optional ByVal Module As String = "", _
                            Optional ByVal Title As String = "Error", _
                            Optional ByVal Level As csErrorLevel = csErrorInformation) As Boolean
    Dim sqlstmt As String
    Dim Rs As ADODB.Recordset
    
    sqlstmt = "SELECT " + cscActivo + " FROM " + Table + " WHERE " + Condition
                         
    If Not OpenRs(sqlstmt, Rs, adOpenForwardOnly, adLockOptimistic, adCmdText, FunctionName, Module, Title, Level) Then GoTo ExitProc
                             
    If Not Rs.EOF Then
        retValue = ValField(Rs.fields, cscActivo) <> 0
    End If
    
    IsActive = True
ExitProc:
    On Error Resume Next
    Rs.Close
    Set Rs = Nothing
End Function

' Proposito devuelve un dato en particular de cualquier Table
Public Function GetData(ByVal Table As String, _
                        ByVal fieldId As String, _
                        ByVal ID As Long, _
                        ByVal Field As String, _
                        ByRef Data As Variant, _
                        Optional ByVal FunctionName As String = "", _
                        Optional ByVal Module As String = "", _
                        Optional ByVal Title As String = "Error", _
                        Optional ByVal Level As csErrorLevel = csErrorInformation) As Boolean
                        
    Dim sqlstmt As String
    Dim Rs As ADODB.Recordset
    
    Data = Empty
        
    sqlstmt = "SELECT " + Field + " FROM " + Table + " WHERE " + fieldId + " = " + Trim(ID)
                         
    If Not OpenRs(sqlstmt, Rs, adOpenForwardOnly, adLockOptimistic, adCmdText, FunctionName, Module, Title, Level) Then GoTo ExitProc
                             
    If Not Rs.EOF Then
        Data = ValField(Rs.fields, Field)
    End If
    
    GetData = True
ExitProc:
    On Error Resume Next
    Rs.Close
    Set Rs = Nothing
End Function

Public Function GetDataWithCondition(ByVal Table As String, _
                            ByVal Field As String, _
                            ByVal Condition As String, _
                            ByRef Dato As Variant, _
                            ByRef bExists As Boolean, _
                            Optional ByVal ExigirActivo As Boolean = False, _
                            Optional ByVal FunctionName As String = "", _
                            Optional ByVal Module As String = "", _
                            Optional ByVal Title As String = "Error", _
                            Optional ByVal Level As csErrorLevel = csErrorInformation) As Boolean
    Dim sqlstmt As String
    Dim Rs As ADODB.Recordset
    
    sqlstmt = "SELECT " + Field + " FROM " + Table + " WHERE (" + Condition + ")"
    
    If ExigirActivo Then sqlstmt = sqlstmt + " AND (" + cscActivo + " <> 0)"
    
    Set Rs = New ADODB.Recordset
                         
    If Not OpenRs(sqlstmt, Rs, adOpenForwardOnly, adLockOptimistic, adCmdText, FunctionName, Module, Title, Level) Then GoTo ExitProc
                             
    If Not Rs.EOF Then
        Dato = ValField(Rs.fields, Field)
        bExists = True
    End If
    
    GetDataWithCondition = True
ExitProc:
    On Error Resume Next
    Rs.Close
    Set Rs = Nothing
End Function

Public Function GetNewId(ByVal Table As String, _
                          ByVal fieldId As String, _
                          ByRef lId As Long, _
                          Optional ByVal FunctionName As String = "", _
                          Optional ByVal Module As String = "", _
                          Optional ByVal Title As String = "Error", _
                          Optional ByVal Level As csErrorLevel = csErrorInformation) As Boolean
    On Error GoTo ControlError
    
    Dim MouseWait As New cMouseWait
    MouseWait.Wait
    
    'ABRO EL RECORDSET
    lId = GetNewId_(Table, fieldId)

    GetNewId = True
    Exit Function
ControlError:
    MngError Err, FunctionName, Module, _
             "Fallo al obtener New Id para la Table [" + Table + "] field id [" + fieldId + "]", _
             Nothing, _
             Title, Level, csErrorAdo, m_cn
End Function

Public Function SaveEx(ByRef Register As cRegister, _
                      Optional ByVal IsNew As Boolean = False, _
                      Optional ByVal fieldCodigo As String = vbNullString, _
                      Optional ByVal FunctionName As String = vbNullString, _
                      Optional ByVal Module As String = vbNullString, _
                      Optional ByVal Title As String = "Error", _
                      Optional ByVal Level As csErrorLevel = csErrorInformation) As Boolean
    On Error GoTo ControlError
    
    Const c_get_codigo_from_id = "'(@@get_codigo_from_id@@)'"
    
    Register.EsNew = False
    Register.fields.UserId = m_UserId
    If Register.ID = csNO_ID Then
        ' Obtengo un New id solo si no usa identity y se definio el field id
        If Not Register.UtilizaIdentity And LenB(Trim$(Register.fieldId)) Then
          Register.ID = GetNewId_(Register.Table, Register.fieldId)
        End If
        IsNew = True
    End If
    
    Dim fld As cField
    
    For Each fld In Register.fields
      If fld.Name = fieldCodigo Then
        If fld.Value = c_get_codigo_from_id Then
          fld.Value = Format(Register.ID, "00000")
        End If
        Exit For
      End If
    Next
    
    Register.EsNew = IsNew
    SaveEx = Execute(Register.GetSqlSave, FunctionName, Module, Title, Level)
    
    Exit Function
ControlError:
    MngError Err, FunctionName, Module, _
             "Fallo al obtener New Id para la Table [" + Register.Table + "] field id [" + Register.fieldId + "]", _
             Nothing, Title, Level, csErrorAdo, m_cn
End Function

Public Function Save(ByRef Register As cRegister, _
                          Optional ByVal IsNew As Boolean = False, _
                          Optional ByVal FunctionName As String = "", _
                          Optional ByVal Module As String = "", _
                          Optional ByVal Title As String = "Error", _
                          Optional ByVal Level As csErrorLevel = csErrorInformation) As Boolean
    On Error GoTo ControlError
    
    Register.EsNew = False
    Register.fields.UserId = m_UserId
    If Register.ID = csNO_ID Then
        ' Obtengo un New id solo si no usa identity y se definio el field id
        If Not Register.UtilizaIdentity And Trim(Register.fieldId) <> "" Then
          Register.ID = GetNewId_(Register.Table, Register.fieldId)
        End If
        IsNew = True
    End If
    Register.EsNew = IsNew
    Save = Execute(Register.GetSqlSave, FunctionName, Module, Title, Level)
    
    Exit Function
ControlError:
    MngError Err, FunctionName, Module, _
             "Fallo al obtener New Id para la Table [" + Register.Table + "] field id [" + Register.fieldId + "]", _
             Nothing, Title, Level, csErrorAdo, m_cn
End Function

Public Function Val(Field As String) As Variant
    On Error GoTo ControlError
    
    If m_Rs Is Nothing Then
        Err.Raise csErrorVal, "VAL function CSOAPI", "No se paso un field y el RS es nothing. Error interno"
    End If
    Val = ValField(m_Rs.fields, Field)
    Exit Function
ControlError:
  If Err.Number = 3265 Then
    MngError Err, "Val", C_Module, "Campo: " & Field, Nothing
  End If
End Function

Public Function ValField(ByRef fields As ADODB.fields, ByVal FieldName As String) As Variant
  ValField = ValField_(fields, FieldName, m_fieldtype)
End Function

Public Sub MoveNext()
    m_Rs.MoveNext
    m_EOF_Field = False
    m_NextField = 0
End Sub
Public Function Field() As String
    If LCase(m_Rs.fields(m_NextField).Name) = cscActivo Then
        m_fieldtype = csFieldBoolean
    Else
        Select Case m_Rs.fields(m_NextField).Type
            Case adVarChar, adChar
                m_fieldtype = csFieldChar
            Case adDate, adDBDate, adDBTime
                m_fieldtype = csFieldDate
            Case Else
                m_fieldtype = csFieldNumeric
        End Select
    End If
    Field = CStr(Val(Trim(m_NextField)))
    m_NextField = m_NextField + 1
    If m_Rs.fields.Count - 1 < m_NextField Then m_EOF_Field = True
End Function
Public Function GetFieldType(Field As ADODB.Field) As csFieldType
  GetFieldType = GetFieldType_(Field)
End Function

' FunctionNamees privadas
Private Function GetNewId_(ByVal Table As String, ByVal fieldId As String) As Long
  On Error GoTo ControlError
  
  Dim Rs            As ADODB.Recordset
  Dim sqlstmt       As String
  Dim errNumber     As Long
  Dim errDescrip    As String
  Dim errSource     As String
  Dim errHelp       As Long
  Dim errHelpFile   As String
  Dim bErrorTraped  As Boolean
  
  Set Rs = New ADODB.Recordset
  
  sqlstmt = "SP_DBGetNewId " & Table & ", " & fieldId & ", 0"
  
TryAgain:
  Rs.Open sqlstmt, m_cn, adOpenDynamic, adLockPessimistic
  
  GetNewId_ = Rs.fields(0)
  
  GoTo ExitProc
ControlError:
  
  If pReConnect(bErrorTraped, True) Then
    GoTo TryAgain
  Else
    errDescrip = Err.Description
    errSource = Err.Source
    errHelp = Err.HelpContext
    errHelpFile = Err.HelpFile
    errNumber = Err.Number
    
    If Err.Number <> 0 Then Resume RaiseError
  End If
  
RaiseError:
  On Error GoTo 0
  Err.Raise errNumber, errSource, errDescrip, errHelpFile, errHelp

ExitProc:
  On Error Resume Next
  Rs.Close
  Set Rs = Nothing
End Function

' construccion - destruccion
Private Sub Class_Initialize()
#If PREPROC_DEBUG Then
  gdbInitInstance C_Module
#End If
  
  m_Transactionlevel = 0
  m_ConnectionTimeout = 180 ' 3 minutos
  m_CommandTimeout = 180 ' 3 minutos
  
  m_MaxTryOpenRs = 2
  m_MaxTryExecute = 2
End Sub

Private Sub Class_Terminate()
  On Error Resume Next
  CloseDb
  Set m_cn = Nothing
  
#If PREPROC_DEBUG Then
  gdbTerminateInstance C_Module
#End If
End Sub

'-----------------------------------------------------------------------------------

Public Function BeginTransaction(Optional ByRef Level As Long) As Boolean
  On Error GoTo ControlError
  
  If m_Transactionlevel = 0 Then
    Level = m_cn.BeginTrans()
    m_Transactionlevel = 1
  Else
    m_Transactionlevel = m_Transactionlevel + 1
  End If
  
  BeginTransaction = True
  Exit Function
ControlError:
  MngError Err, "BeginTransaction", "cDataBase", vbNullString, Nothing, , , csErrorAdo, m_cn
End Function

Public Function RollBackTransaction() As Boolean
  
  If m_Transactionlevel Then
    On Error GoTo ControlError
  Else
    On Error Resume Next
  End If
  
  m_cn.RollBackTrans
  m_Transactionlevel = 0
  
  RollBackTransaction = True
  
  Exit Function
ControlError:
  MngError Err, "RollBacktTransaction", "cDataBase", vbNullString, Nothing, , , csErrorAdo, m_cn
End Function

Public Function CommitTransaction() As Boolean
  On Error GoTo ControlError
  
  If m_Transactionlevel = 1 Then
    m_cn.CommitTrans
    m_Transactionlevel = 0
  Else
    m_Transactionlevel = m_Transactionlevel - 1
  End If
  
  If m_Transactionlevel < 0 Then
    m_Transactionlevel = 0
  End If
  
  CommitTransaction = True
  Exit Function
ControlError:
  MngError Err, "CommitTransaction", "cDataBase", vbNullString, Nothing, , , csErrorAdo, m_cn
End Function

'--------------------------------------------------------------------------------------------
Public Function GetSelect(ByVal sqlstmt As String) As String
  If InStr(UCase(sqlstmt), "FROM") > 0 Then
    GetSelect = Mid(sqlstmt, 1, InStr(UCase(sqlstmt), "FROM") - 1)
  Else
    GetSelect = sqlstmt
  End If
End Function
Public Function GetFrom(ByVal sqlstmt As String) As String
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
Public Function GetWhere(ByVal sqlstmt As String) As String
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
Public Function GetGroup(ByVal sqlstmt As String) As String
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
Public Function GetOrder(ByVal sqlstmt As String) As String
  sqlstmt = UCase(sqlstmt)
  If InStr(sqlstmt, "ORDER BY") > 0 Then
    GetOrder = Mid(sqlstmt, InStr(sqlstmt, "ORDER BY"))
  Else
    GetOrder = ""
  End If
End Function

Private Function SQLFieldToString(Field As ADODB.Field) As String
  Dim retval As String
  If IsNull(Field.Value) Then
    retval = "NULL"
  Else
    Select Case Field.Type
    Case adBoolean, adBigInt, adInteger, adSmallInt, adSingle, adDouble
      retval = Trim(Field.Value)
    Case adCurrency
      retval = Trim(Field.Value)
    Case adDBTime, adDBTimeStamp, adDBDate
      retval = Format$(Field.Value, C_PSqlDateTime)
    Case adChar, adVarChar, adWChar, adVarWChar, adLongVarChar, adLongVarWChar
      retval = "'" + Replace(Field.Value, "'", "''") + "'"
    Case adBinary
      retval = Trim(Field.Value)
    End Select
  End If
  SQLFieldToString = retval
End Function

Private Function SQLTextForType(ByVal VarType As csDataType, ByVal Width As Long)
  'los Texts correspondientes para Access
  Dim retval As String
  Select Case VarType
  Case adChar, adVarChar, adWChar, adVarWChar, adLongVarChar, adLongVarWChar
    If Width < 8000 Then
      retval = "VARCHAR(" + Trim(Width) + ")"
    Else
      retval = "TEXT"
    End If
  Case adNumeric
    retval = "NUMERIC"
  Case adDecimal
    retval = "DECIMAL"
  Case adDouble
    retval = "FLOAT"
  Case adSingle
    retval = "REAL"
  Case adInteger, adBigInt
    retval = "INTEGER"
  Case adSmallInt
    retval = "SMALLINT"
  Case adTinyInt
    retval = "TINYINT"
  Case adDBTime, adDBDate, adDate
    retval = "DATETIME"
  Case adBoolean
    retval = "BIT"
  Case adDBTimeStamp
    retval = "DATETIME"
  Case adBinary
    retval = "BINARY"
  Case adVarBinary
    retval = "VARBINARY"
  Case Else
    Debug.Print "No esta previsto el Type " + Trim(VarType)
    retval = "VARCHAR(50)"
  End Select
  SQLTextForType = retval
End Function

Public Function GetInfoTable(ByVal sqlstmt As String, ByVal NameTable As String, ByRef sqlstmtCreate As String, _
                             ByRef sqlstmtInsert As String, ByVal ServerType As crServerType) As Boolean
  Dim Rs  As ADODB.Recordset
  Dim f   As ADODB.Field
  Dim sqlstmt2 As String
  
  ' Si no se trata de un sp
  If Mid(UCase(sqlstmt), 1, 6) = "SELECT" Then
    ' para no obtener valuees inecesarios, agrego una Condition que nunca se cumple
    sqlstmt2 = GetSelect(sqlstmt) + GetFrom(sqlstmt) + GetWhere(sqlstmt)
    If GetWhere(sqlstmt) <> "" Then
      sqlstmt2 = sqlstmt2 + " AND 1=2 "
    Else
      sqlstmt2 = sqlstmt2 + " WHERE 1=2 "
    End If
    sqlstmt = sqlstmt2 + GetGroup(sqlstmt) + GetOrder(sqlstmt)
  End If
  sqlstmtCreate = "CREATE TABLE " + NameTable + " ("
  sqlstmtInsert = "INSERT INTO " + NameTable + " ("
  
  If Not OpenRs(sqlstmt, Rs, , , , "GetInfoTable", "cDataBase") Then Exit Function
  
  For Each f In Rs.fields
    If ServerType = SERVER_ACCESS Then
      Dim dbAccess As cDataBaseAccess
      Set dbAccess = New cDataBaseAccess
      
      sqlstmtCreate = sqlstmtCreate + f.Name + " " + dbAccess.AccessTextForType(f.Type, f.DefinedSize) + " ,"
    Else
      sqlstmtCreate = sqlstmtCreate + f.Name + " " + SQLTextForType(f.Type, f.DefinedSize) + " ,"
    End If
    sqlstmtInsert = sqlstmtInsert + f.Name + " ,"
  Next

  sqlstmtCreate = RemoveLastColon(sqlstmtCreate) + ")"
  sqlstmtInsert = RemoveLastColon(sqlstmtInsert) + ")"
  
  GetInfoTable = True
End Function

Public Function ExistTable(ByVal NameTable As String) As Boolean
  On Error Resume Next
  
  Err = 0
  m_cn.Execute "SELECT * FROM " + NameTable + " WHERE 1 = 2"
  ExistTable = (Err = 0)
End Function

Public Function ExistField(ByVal NameTable As String, ByVal Namefield As String) As Boolean
  On Error Resume Next
  
  Err = 0
  m_cn.Execute "SELECT " + Namefield + " FROM " + NameTable + " WHERE 1 = 2"
  ExistField = (Err = 0)
End Function

Public Function GetSqlValues(ByRef Rs As ADODB.Recordset, ByVal ServerType As crServerType) As String
  ' Con los datos del recordset tengo que armar la
  ' sentencia SQL
  Dim CantFields  As Integer
  Dim i           As Integer
  Dim Cola        As String

  CantFields = Rs.fields.Count
  GetSqlValues = "VALUES ("
  For i = 0 To CantFields - 1
    'Hago esto porque sino da error al hacer remove last coma
    'WHEN hay memos muy largos
    If i = CantFields - 1 Then
      Cola = ")"
    Else
      Cola = ","
    End If
    If ServerType = crServerType.SERVER_ACCESS Then
      Dim dbAccess As cDataBaseAccess
      Set dbAccess = New cDataBaseAccess

      GetSqlValues = GetSqlValues + dbAccess.AccessFieldToString(Rs.fields(i)) + Cola
    Else
      GetSqlValues = GetSqlValues + SQLFieldToString(Rs.fields(i)) + Cola
    End If
  Next
End Function

Public Function GetStringForFieldType(ByVal Text As String, ByVal VarType As csDataType) As String
  Dim retval As String
  Select Case VarType
    Case adBoolean, adBigInt, adInteger, adSmallInt, adSingle, adDouble, adCurrency, adBinary
      retval = Trim(Text)
    Case adDBTime, adDBTimeStamp, adDBDate
      If IsDate(Text) Then
        retval = Format$(CVDate(Text), C_PSqlDate)
      Else
        retval = Format$(DateSerial(1990, 1, 1), C_PSqlDate)
      End If
    Case adChar, adVarChar, adWChar, adVarWChar, adLongVarChar, adLongVarWChar
      retval = "'" + Trim(Text) + "'"
    Case Else
      retval = Trim(Text)
  End Select
  GetStringForFieldType = retval
End Function

Public Function GetSqlstmtSearch(ByVal sqlstmt As String, ByVal ToSearch As String) As String
  On Error GoTo ControlError
  
  Dim SqlSelect$, SqlFrom$, SqlWhere$, SqlGroup$, SqlORder$, AddSqlWhere$
  
  ' Parto la sentencia en sus clausulas
  SqlSelect = GetSelect(sqlstmt)
  SqlFrom = GetFrom(sqlstmt)
  SqlWhere = GetWhere(sqlstmt)
  SqlGroup = GetGroup(sqlstmt)
  SqlORder = GetOrder(sqlstmt)
  
  
  ToSearch = Trim(ToSearch)
  If ToSearch = "" Then
    AddSqlWhere = ""
  Else
    If Trim(SqlWhere) = "" Then
      AddSqlWhere = " WHERE ("
    Else
      AddSqlWhere = " AND ("
    End If
    
    Dim i         As Integer
    Dim Namefield As String
    Do
      i = i + 1
      Namefield = GetNextCode(SqlSelect, i)
      If Namefield = "" Then Exit Do
      AddSqlWhere = AddSqlWhere + GetStmtForField(Namefield, ToSearch, SqlSelect) + " OR "
    Loop
    'retiro el último OR y pongo un perentesis
    AddSqlWhere = Mid(AddSqlWhere, 1, Len(AddSqlWhere) - 3) + ")"
  End If
  
  GetSqlstmtSearch = SqlSelect + " " + SqlFrom + " " + SqlWhere + " " + AddSqlWhere + " " + SqlGroup + " " + SqlORder
ControlError:
End Function

Private Sub m_cn_ExecuteComplete(ByVal RecordsAffected As Long, ByVal pError As ADODB.Error, adStatus As ADODB.EventStatusEnum, ByVal pCommand As ADODB.Command, ByVal pRecordset As ADODB.Recordset, ByVal pConnection As ADODB.Connection)
  m_OpenRsComplete = True
End Sub

Private Function GetStmtForField(ByVal Namefield As String, ByVal TextABuscar As String, ByVal SelectStmt As String) As String
  Dim RealNameField As String
  
  RealNameField = SqlGetRealName(Namefield, SelectStmt)
  
  GetStmtForField = "CharIndex('" + TextABuscar + "', Convert(Varchar(4000)," + RealNameField + ")) > 0"
End Function

Private Function GetNextCode(ByVal fields As String, ByVal i As Integer) As String
  Dim p As Integer
  Dim k As Integer
  Dim r As Integer
  Dim q As Integer
  Dim h As Integer
  Dim c As String
    
  q = 0
  For p = 1 To i
    ' Busco un =
    h = InStr(q + 1, fields, "=", vbTextCompare)
    ' Busco un coma
    r = InStr(q + 1, fields, ",", vbTextCompare)
    
    If h < r Then
      k = h
    Else
      k = r
    End If
    
    ' si no lo encuentro
    If k = 0 Then
      
      ' pruebo con el otro
      If h > r Then
        k = h
      Else
        k = r
      End If
      
      ' si no lo encuentro
      If k = 0 Then
        
        ' si el field en el que estoy no es menor al que me pidieron
        ' entonces me estan pidiendo un field que no existe.
        If p < i Then Exit Function
        
        ' el Text que tengo tiene que ser un Name de field
        Exit For
      End If
    End If
  
    If p = i Then
      fields = Mid(fields, 1, k - 1)
    Else
      
      ' si encontre un = tengo que usar la coma
      ' si la coma no existe entonces se acabaron los fields asi
      ' que me estan pidiendo un field que no existe
      If k = h Then
        If r = 0 Then Exit Function
        
        k = r
      End If
      
      fields = Mid(fields, k + 1)
    End If
  Next


  ' busco el primer espacio empesando desde atras
  fields = Trim(fields)
  q = Len(fields)
  Do
    c = Mid(fields, q, 1)
    
    If c = " " Then Exit Do
    
    q = q - 1
  Loop Until q = 0
  
  If q = 0 Then q = 1
  
  GetNextCode = Trim(Mid(fields, q))
  
  If LCase(GetNextCode) = "select" Or LCase(GetNextCode) = "distinct" Then GetNextCode = ""
End Function

Function SqlGetRealName(ByVal Namefield As String, ByVal sqlstmt As String) As String
  Dim retval As String, sep As String
  Dim SqlSelect As String, ToSearch As String
 
  SqlSelect = UCase(GetSelect(sqlstmt))
  Namefield = UCase(Namefield)
  ToSearch = Trim(Namefield)
  If Not InStr(SqlSelect, ToSearch) = 0 Then
    retval = Trim(Mid(SqlSelect, InStr(SqlSelect, ToSearch) + Len(ToSearch)))
    retval = Trim(Replace(retval, "'", " "))
    If Mid(retval, 1, 1) = "=" Then
      retval = Trim(Mid(retval, InStr(retval, "=") + 1))
      sep = ","
      If InStr(retval, ",") = 0 Then
        sep = " "
      ElseIf InStr(retval, " ") > 0 Then
        If InStr(retval, ",") > InStr(retval, " ") Then
          sep = " "
        End If
      End If
      If Not InStr(retval, sep) = 0 Then
        retval = Trim(Mid(retval, 1, InStr(retval, sep) - 1))
      End If
    Else
      retval = Namefield
    End If
  Else
    retval = Namefield
  End If
 
  SqlGetRealName = retval
End Function

Private Sub pReConnect2()
  
  On Error GoTo ControlError
  CloseDb
  
  m_cn.ConnectionTimeout = m_ConnectionTimeout
  m_cn.CommandTimeout = m_CommandTimeout
  
  m_cn.Open m_connect
  
  GoTo ExitProc
ControlError:
  
  MngError Err, "pReConnect2", C_Module, vbNullString, Nothing
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Sub

' Siempre que sql me da un error
' me reconecto para evitar que queden
' tablas temporales y otras boludeces
' como cursores o transacciones abiertas
'
Private Function pReConnect(ByRef bErrorTraped As Boolean, ByVal bNoTrapError As Boolean) As Boolean
  On Error GoTo ControlError
  
  bErrorTraped = False
  
  pSaveError ""
  
  CloseDb
  
  m_cn.ConnectionTimeout = m_ConnectionTimeout
  m_cn.CommandTimeout = m_CommandTimeout
  
  m_cn.Open m_connect
  
  pReConnect = True
  
  GoTo ExitProc
ControlError:
  
  If bNoTrapError Then Exit Function
  
  bErrorTraped = True
  MngError Err, "pReConnect", C_Module, vbNullString, Nothing
  If Err.Number Then Resume ExitProc

ExitProc:
  On Error Resume Next
End Function

Private Sub pSaveError(ByVal sqlstmt As String)
  Dim connTimeOut       As Long
  Dim TimeOut           As Long
  Dim errorAdo          As Object
  Dim strOriginalErr2   As String
  
  If Not m_cn Is Nothing Then
    
    connTimeOut = m_cn.ConnectionTimeout
    TimeOut = m_cn.CommandTimeout
    
    For Each errorAdo In m_cn.Errors
      strOriginalErr2 = strOriginalErr2 & errorAdo
    Next
  
  Else
    connTimeOut = -1
    TimeOut = -1
  End If
  
  strOriginalErr2 = strOriginalErr2 & c_ErrorSqlInfoAdd
  
  If sqlstmt <> vbNullString Then
    strOriginalErr2 = strOriginalErr2 & vbCrLf & vbCrLf & _
                      "Sentencia SQL: " & sqlstmt & vbCrLf & vbCrLf
  End If
  
  strOriginalErr2 = strOriginalErr2 & vbCrLf & _
                    "TimeOut: " & TimeOut & vbCrLf & _
                    "ConnTimeOut: " & connTimeOut & vbCrLf & vbCrLf
  
  CSKernelClient2.ErrorDB = strOriginalErr2

End Sub

Private Sub MngError(ByRef ErrObj As Object, _
                     ByVal NameFunction As String, _
                     ByVal Module As String, _
                     ByVal InfoAdd As String, _
                     ByVal Rs As ADODB.Recordset, _
                     Optional ByVal Title As String = "", _
                     Optional ByVal Level As csErrorLevel = csErrorWarning, _
                     Optional ByVal VarType As csErrorType = csErrorVba, _
                     Optional ByVal ConnectionObj As Object)
    
  Dim bHaveRsDetail As Boolean
  
  If Not ErrObj Is Nothing Then
    bHaveRsDetail = InStr(1, ErrObj.Description, "@@ERROR_SP_RS:")
  End If
  
  CSKernelClient2.MngError ErrObj, _
                           NameFunction, _
                           Module, _
                           InfoAdd, _
                           Title, _
                           Level, _
                           VarType, _
                           ConnectionObj
  
  m_LastDBError = LastErrorDescription _
                  & vbCrLf & "Funcion: " & LastErrorFunction _
                  & vbCrLf & "Modulo: " & LastErrorModule _
                  & vbCrLf & "Linea: " & LastErrorNumber

  Err.Clear

  If Not bHaveRsDetail Then Exit Sub

  On Error Resume Next
  
  Dim ErrorDetail As Object
  
  While Not Rs Is Nothing

    If Rs.State = adStateOpen Then
      
      If Not Rs.EOF Then
      
        Set ErrorDetail = CSKernelClient2.CreateObject("CSMessageAux.cMessageAux")
        ErrorDetail.ShowMessageFromRecordset "Info", Rs, Me
      End If
    End If
    
    Err.Clear
    Set Rs = Rs.NextRecordset
    If Err.Number Then Exit Sub
    
  Wend
End Sub

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

'////////////////////////////////////////////////////////////////////////////
' Util para detectar Bugs cuando corro desde IIS
'
  'Private Sub pSaveLog(ByVal Msg As String)
  '  On Error Resume Next
  '  Dim f As Integer
  '  f = FreeFile
  '  Open "D:\Proyectos\CSHtml\CrowSoft\Reports\webreport.log" For Append As f
  '  Print #f, Now & " " & Msg
  '  Close f
  'End Sub

