VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRegister"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cRegister
' 04-01-99

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' FunctionNamees

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cRegister"
' estructuras
' variables privadas
Private m_ID                As Long
Private m_fieldId           As String
Private m_Table             As String
Private m_Fields            As cFields
Private m_IsNew             As Boolean
Private m_UtilizaIdentity   As Boolean
Private m_db                As cDataBase
Private m_TransactionOpened As Boolean
Private m_Filter            As String
' propiedades publicas
Public Property Let EsNew(ByVal rhs As Boolean)
    m_IsNew = rhs
End Property
Public Property Let UtilizaIdentity(ByVal rhs As Boolean)
    m_UtilizaIdentity = rhs
End Property
Public Property Get UtilizaIdentity() As Boolean
    UtilizaIdentity = m_UtilizaIdentity
End Property
Public Property Get ID() As Long
    ID = m_ID
End Property
Public Property Let ID(ByVal rhs As Long)
    m_ID = rhs
End Property
Public Property Get fieldId() As String
    fieldId = m_fieldId
End Property
Public Property Let fieldId(ByVal rhs As String)
    m_fieldId = rhs
End Property
Public Property Get Table() As String
    Table = m_Table
End Property
Public Property Let Table(ByVal rhs As String)
    m_Table = rhs
End Property
Public Property Get fields() As cFields
    Set fields = m_Fields
End Property

Public Property Get filter() As String
   filter = m_Filter
End Property

Public Property Let filter(ByVal rhs As String)
   m_Filter = rhs
End Property

' propiedades privadas
' FunctionNamees publicas
Public Function GetSqlSave(Optional ByVal FunctionName As String = "", _
                     Optional ByVal Module As String = "", _
                     Optional ByVal Title As String = "Error", _
                     Optional ByVal Level As csErrorLevel = csErrorInformation) As String
  If m_IsNew Then
    GetSqlSave = InsertSQL_()
  Else
    GetSqlSave = UpdateSQL_()
  End If
End Function

Public Function BeginTrans(ByRef db As cDataBase) As Boolean
  Set m_db = db
  If db.BeginTransaction Then
    m_TransactionOpened = True
    BeginTrans = True
  End If
End Function

Public Function CommitTrans() As Boolean
  If m_db Is Nothing Then Exit Function
  If m_db.CommitTransaction() Then
    m_TransactionOpened = False
    CommitTrans = True
  End If
End Function

Public Function RollBackTrans() As Boolean
  If m_db Is Nothing Then Exit Function
  If m_db.RollBackTransaction() Then
    m_TransactionOpened = False
    RollBackTrans = True
  End If
End Function

Public Function Exists(ByRef db As cDataBase, ByRef rtn As Boolean) As Boolean
  Dim sqlstmt As String
  Dim Rs      As Recordset
  
  sqlstmt = "select * from " & Trim(Table) & " where " & m_Filter
  
  If Not db.OpenRs(sqlstmt, Rs) Then Exit Function
  
  Exists = True
  
  rtn = Not Rs.EOF
End Function
' FunctionNamees privadas
Private Function UpdateSQL_() As String
  Dim sqlstmt As String
  
  sqlstmt = "UPDATE " & Trim(m_Table) & " SET " & m_Fields.GetUpdateFieldString()

  
  If m_fieldId <> "" And Trim(m_ID) <> "" Then
    sqlstmt = sqlstmt & " WHERE " & m_fieldId & " = " & Trim(m_ID)
  ElseIf m_Filter <> "" Then
    sqlstmt = sqlstmt & " WHERE " & m_Filter
  End If
  
  UpdateSQL_ = sqlstmt
End Function

' la clase DataBase en su FunctionName Save se encarga de obtener el New ID
Private Function InsertSQL_() As String
  If Not m_UtilizaIdentity Then
    If Not ExistsStandarTypeInColl(m_Fields, m_fieldId) Then m_Fields.Add2 m_fieldId, m_ID, csInteger
  End If
  
  InsertSQL_ = "INSERT INTO " & Trim(Table) & m_Fields.GetInsertFieldString()
End Function
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Fields = New cFields
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_Fields = Nothing

  If m_TransactionOpened Then
    If Not m_db Is Nothing Then
      m_db.RollBackTransaction
    End If
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, ""
  If Err.Number Then Resume ExitProc
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


