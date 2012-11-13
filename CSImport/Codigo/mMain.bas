Attribute VB_Name = "mMain"
Option Explicit

Public Const LOG_NAME = "\log\CSImport.log"
Public Const LOG_NAME2 = "\log\CSImport"

Private Const C_Module = "mMain"
Private m_InitCSImport As cInitCSImport
Private m_db           As cDataBase

Public Sub Main()
  SaveLog "----------------------------------"
  SaveLog "Iniciando importación desatendida"
  SaveLog "Parametros: " & Command
  If Not pOpenDb() Then pDestroyObjects: Exit Sub
  If Not pInitDlls() Then pDestroyObjects: Exit Sub
  If Not pImport() Then pDestroyObjects: Exit Sub
  pDestroyObjects
  SaveLog "Terminando importación desatendida"
  SaveLog "----------------------------------"
End Sub

Private Sub pDestroyObjects()
  On Error Resume Next
  m_db.CloseDb
  Set m_db = Nothing
  Set m_InitCSImport = Nothing
End Sub

Private Function pOpenDb() As Boolean
  On Error GoTo ControlError
  
  Set m_db = New cDataBase
  
  m_db.UserId = 1
  
  If Not m_db.InitDB(, , , , App.Path & "\CSImportUnAt.udl") Then Exit Function
  
  pOpenDb = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pOpenDb", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pInitDlls() As Boolean
  On Error GoTo ControlError
  
  Set m_InitCSImport = New CSImportUnAttended2.cInitCSImport
  
  If Not m_InitCSImport.Init(m_db) Then Exit Function
  
  pInitDlls = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pInitDlls", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pImport() As Boolean
  On Error GoTo ControlError
  
  Dim oImport As cImportForm
  Set oImport = New cImportForm
  Dim impp_id As Long
  
  If Not pGetImppIdFromCodigo(impp_id, pGetImppCodigoFromCmdLine()) Then Exit Function
  oImport.RunImport impp_id
  
  pImport = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "pImport", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function pGetImppIdFromCodigo(ByRef impp_id As Long, ByVal impp_codigo As String) As Boolean
  Dim rs      As Recordset
  Dim sqlstmt As String
  
  sqlstmt = "select impp_id from ImportacionProceso where impp_codigo = " & m_db.sqlString(impp_codigo)
  If Not m_db.OpenRs(sqlstmt, rs) Then Exit Function
  
  If rs.EOF Then Exit Function
  
  impp_id = m_db.ValField(rs.Fields, 0)
  
  pGetImppIdFromCodigo = True
End Function

Private Sub MngError(ByRef ErrObj As Object, ByVal FunctionName As String, ByVal Module As String, ByVal InfoAdd As String)
  SaveLog "Error: " & Err.Description
  SaveLog "Error number: " & Err.Number
End Sub

Private Function pGetImppCodigoFromCmdLine() As String
  pGetImppCodigoFromCmdLine = Command
End Function

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

