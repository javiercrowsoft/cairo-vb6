VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImportExcel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cImportExcel
' 30-01-2003

'--------------------------------------------------------------------------------
' notas:
' Proposito:  Implementar rutinas de backup y restore

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cImportExcel"
' estructuras
' variables privadas
Private m_Connection  As cConnection

Private m_DataBase As String

Private WithEvents m_fImportExcel As fImportExcel
Attribute m_fImportExcel.VB_VarHelpID = -1
' eventos
' propiedades publicas
Friend Property Set Conn(ByRef rhs As cConnection)
  Set m_Connection = rhs
End Property
' propiedades privadas
' funciones publicas
Public Function Import(ByVal Database As String) As Boolean
  On Error GoTo ControlError

  m_DataBase = Database

  Set m_fImportExcel = New fImportExcel
  m_fImportExcel.Show vbModal

  Import = m_fImportExcel.Ok

  Unload m_fImportExcel

  GoTo ExitProc
ControlError:
  MngError Err, "Import", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  Unload m_fImportExcel
End Function

' funciones friend
' funciones privadas
Private Sub m_fImportExcel_FindFile(File As String, Cancel As Boolean)
  On Error GoTo ControlError
  
  Cancel = Not ShowOpenFileDLG(m_fImportExcel.cd, File, "Planillas de calculo|*.xls")
  
  GoTo ExitProc
ControlError:
  MngError Err, "m_fImportExcel_FindFile", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fImportExcel_OpenExcel(Success As Boolean)
  On Error GoTo ControlError
  
  Dim strconnect As String
  Dim Db As cDataSource
  Set Db = New cDataSource
  
  With m_fImportExcel.txFile
    strconnect = "Driver={Microsoft Excel Driver (*.xls)};" & _
                 "DriverId=790;" & _
                 "Dbq=" & .Text & ";" & _
                 "DefaultDir=" & FileGetPath(.Text) & ";"
  End With
  
  Db.OpenConnection "", "", "", "", False, strconnect
  
  With m_fImportExcel.lsTables
    .Clear
    
    Dim rs As Recordset
    If Not Db.GetTables(rs) Then Exit Sub
    
    While Not rs.EOF
      .AddItem rs.Fields("TABLE_NAME")
      rs.MoveNext
    Wend
  End With

  GoTo ExitProc
ControlError:
  MngError Err, "m_fImportExcel_OpenExcel", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub m_fImportExcel_ImportExcel(Success As Boolean)
  On Error GoTo ControlError
  
  Dim strconnect As String
  Dim Db As cDataSource
  Set Db = New cDataSource
  
  Dim dbDes As cDataSource
  Set dbDes = New cDataSource
  
  With m_fImportExcel.txFile
    strconnect = "Driver={Microsoft Excel Driver (*.xls)};" & _
                 "DriverId=790;" & _
                 "Dbq=" & .Text & ";" & _
                 "DefaultDir=" & FileGetPath(.Text) & ";"
  End With
  
  Db.OpenConnection "", "", "", "", False, strconnect
  
  Dim rs As Recordset
  Dim sqlstmt As String
  Dim fld As Field
  Dim sqlstmtfld As String
  Dim sqlstmtval As String
  
  sqlstmt = "select * from [" & m_fImportExcel.lsTables.Text & "]"
  
  If Not Db.OpenRs(rs, sqlstmt) Then Exit Sub
  
  With m_Connection
    If Not dbDes.OpenConnection(.ServerName, m_DataBase, .UserName, .Password, .NTSecurity) Then Exit Sub
  End With
  
  If Not pCreateTable(rs, m_fImportExcel.txTable.Text, m_DataBase) Then Exit Sub
  
  Dim oQuery As cSQLScript
  
  Set oQuery = New cSQLScript
  Set oQuery.Conn = m_Connection
  
  With m_fImportExcel.prgbProgress
  
    If Not rs.EOF Then
      rs.MoveLast
      rs.MoveFirst
      
      .Min = 0
      .Max = rs.RecordCount
      
      sqlstmtfld = ""
      For Each fld In rs.Fields
        sqlstmtfld = sqlstmtfld & "[" & fld.Name & "],"
      Next
      sqlstmtfld = RemoveLastColon(sqlstmtfld)
    End If
    
    
    While Not rs.EOF
      sqlstmtval = ""
      For Each fld In rs.Fields
        If fld.Type = adDate Or fld.Type = adDBTimeStamp Then
          sqlstmtval = sqlstmtval & "'" & Format(fld.Value, "yyyymmdd") & "',"
        Else
          sqlstmtval = sqlstmtval & "'" & fld.Value & "',"
        End If
      Next
      
      sqlstmtval = RemoveLastColon(sqlstmtval)
      
      sqlstmt = "insert into " & m_fImportExcel.txTable.Text
      sqlstmt = sqlstmt & "(" & sqlstmtfld & ") "
      sqlstmt = sqlstmt & "values (" & sqlstmtval & ") "
      
      
      If Not oQuery.Execute(sqlstmt, m_DataBase, False) Then Exit Sub
    
      .Value = rs.AbsolutePosition
      
      rs.MoveNext
    Wend
    
  End With
  Success = True

  GoTo ExitProc
ControlError:
  MngError Err, "m_fImportExcel_ImportExcel", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pCreateTable(ByRef rs As Recordset, ByVal Table As String, ByRef Db As String) As Boolean
  On Error GoTo ControlError

  Dim fld As Field
  Dim sqlstmt As String
  Dim oQuery As cSQLScript
  
  Set oQuery = New cSQLScript
  Set oQuery.Conn = m_Connection
  
  sqlstmt = "if exists (select * from dbo.sysobjects where id = object_id(N'[" & Table & "]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)" & vbCrLf
  sqlstmt = sqlstmt & "drop table [" & Table & "]"
  
  If Not oQuery.Execute(sqlstmt, Db, False) Then Exit Function
  
  sqlstmt = ""
  For Each fld In rs.Fields
    sqlstmt = sqlstmt & "[" & fld.Name & "] varchar (255),"
  Next
  
  sqlstmt = RemoveLastColon(sqlstmt)
  sqlstmt = "Create table [" & Table & "] (" & sqlstmt & ")"
  
  If Not oQuery.Execute(sqlstmt, Db, False) Then Exit Function
  
  pCreateTable = True

  GoTo ExitProc
ControlError:
  MngError Err, "pCreateTable", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError
  
  Set m_Connection = Nothing
  
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
