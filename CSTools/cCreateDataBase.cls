VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCreateDataBase"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cCreateDataBase
' 15-06-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cCreateDataBase"
' estructuras
' variables privadas
Private m_DefDB                     As cDefDataBase
Private m_MngMacro                  As cMngMacro
Private m_MngScript                 As cMngScriptBatch
Private m_SQLServer                 As cSQLServer

Private WithEvents m_Script         As cSQLScript ' Para capturar eventos
Attribute m_Script.VB_VarHelpID = -1

Private m_MustDropDB                As Boolean
' eventos
' propiedadades publicas
Public Event DropingDataBase(ByVal message As String)
Public Event DropingDataBaseSuccess(ByVal message As String)
Public Event DropingDataBaseFail(ByVal message As String)
Public Event CreatingDataBase(ByVal message As String)
Public Event CreatingDataBaseSuccess(ByVal message As String)
Public Event CreatingDataBaseFail(ByVal message As String)
Public Event AddTask(ByVal message As String)
Public Event AddTaskSuccess(ByVal message As String)
Public Event AddTaskFail(ByVal message As String)

Public Event ScriptBegin(ByVal message As String)
Public Event ScriptSuccess(ByVal message As String)
Public Event ScriptFail(ByVal message As String)
Public Event ScriptProgress(ByVal Percent As Integer, ByVal Descrip As String, ByRef Cancel As Boolean)
Public Event ScriptError(ByVal Descrip As String, ByVal ErrNumber As Long, ByVal sqlstmt As String, ByRef Continue As Boolean)

' propiedadades friend
Friend Property Set SQLServer(ByRef rhs As cSQLServer)
  Set m_SQLServer = rhs
  If rhs Is Nothing Then
    Set m_Script = Nothing
  Else
    Set m_Script = m_SQLServer.SQLScript
  End If
End Property
' propiedades privadas
' funciones publicas
Public Function CreateDataBase(ByRef DefDB As cDefDataBase, ByRef MngMacro As cMngMacro, ByRef MngScript As cMngScriptBatch, ByVal MustDropDB As Boolean) As Boolean
  Set m_DefDB = DefDB
  Set m_MngMacro = MngMacro
  Set m_MngScript = MngScript
  m_MustDropDB = MustDropDB
  If Not DropDataBase() Then Exit Function
  If Not nCreateDataBase() Then Exit Function
  If Not RunScripts() Then Exit Function
  CreateDataBase = True
End Function
' funciones friend
' funciones privadas
Private Sub m_Script_Progress(ByVal Percent As Integer, ByVal Descrip As String, Cancel As Boolean)
  RaiseEvent ScriptProgress(Percent, Descrip, Cancel)
End Sub

Private Sub m_Script_ScriptError(ByVal Descrip As String, ByVal ErrNumber As Long, ByVal sqlstmt As String, Continue As Boolean)
  Descrip = SqlReplaceComments(Descrip)
  RaiseEvent ScriptError(Descrip, ErrNumber, sqlstmt, Continue)
End Sub

Private Function DropDataBase() As Boolean
  Dim Index As Integer
  
  If m_MustDropDB Then
    With m_SQLServer.Conn.Server
      For Index = 1 To .Databases.Count
        If .Databases(Index).Name = m_DefDB.Name Then
          
          On Error GoTo DropError
          RaiseEvent DropingDataBase(m_DefDB.Name)
          
          .Databases.Remove Index
          .Databases.Refresh
          
          RaiseEvent DropingDataBaseSuccess(m_DefDB.Name)
          Exit For
        End If
      Next
    End With
  End If

  DropDataBase = True
  Exit Function
DropError:
  RaiseEvent DropingDataBaseFail(m_DefDB.Name)
  Err.Raise Err.Number, Err.Source, Err.Description, Err.HelpFile, Err.HelpContext
End Function

Private Function nCreateDataBase() As Boolean
  Dim sqlstmt As String
  sqlstmt = "CREATE DATABASE " & m_DefDB.Name & _
            " ON ( NAME = " & FileGetNameWithoutExt(m_DefDB.DataPath) & "_data," & _
            " FILENAME = '" & m_DefDB.DataPath & "'," & _
            " SIZE = " & Trim(m_DefDB.DataSize) & "MB)" & _
            " LOG ON ( NAME = " & FileGetNameWithoutExt(m_DefDB.LogPath) & "_log," & _
            " FILENAME = '" & m_DefDB.LogPath & "'," & _
            " SIZE = " & Trim(m_DefDB.LogSize) & "MB)"

  RaiseEvent CreatingDataBase(m_DefDB.Name)
  
  If Not m_SQLServer.SQLScript.Execute(sqlstmt, "master", True) Then
    
    RaiseEvent CreatingDataBaseFail(m_DefDB.Name)
    Exit Function
  End If
  
  m_SQLServer.Conn.Server.Databases.Refresh
  
  RaiseEvent CreatingDataBaseSuccess(m_DefDB.Name)

  nCreateDataBase = True
End Function

Private Function RunScripts() As Boolean
  Dim scr     As cDefScript
  Dim sqlstmt As String
  Dim Task    As cSQLTask
  
  For Each scr In m_MngScript.Scripts
    If scr.ScrType = csScrTypeScript Then
    
      RaiseEvent ScriptBegin(scr.FileValid)
    
      If Not FileReadFullFile(scr.FileValid, sqlstmt) Then GoTo RunScriptError
      If Not m_SQLServer.SQLScript.ExecuteBatch(sqlstmt, m_DefDB.Name, True) Then GoTo RunScriptError
      
      RaiseEvent ScriptSuccess(scr.FileValid)
    Else
      
      On Error GoTo RunTaskError
      RaiseEvent AddTask(scr.FileValid)
      
      Set Task = m_SQLServer.LoadTaskFromIni(scr.FileValid)
      If Task Is Nothing Then GoTo RunTaskError
      Set Task.MngMacro = m_MngMacro
      If Not Task.Delete(Task.Name) Then GoTo RunTaskError
      If Not Task.Save() Then GoTo RunTaskError
      
      RaiseEvent AddTaskSuccess(scr.FileValid)
    End If
  Next
  
  RunScripts = True
  Exit Function
RunTaskError:
  RaiseEvent AddTaskFail(scr.FileValid)
  Exit Function
RunScriptError:
  RaiseEvent ScriptFail(scr.FileValid)
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

  Set m_SQLServer = Nothing
  Set m_DefDB = Nothing
  Set m_MngMacro = Nothing
  Set m_MngScript = Nothing
  Set m_Script = Nothing
  
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
