Attribute VB_Name = "mMain"
Option Explicit

Private Const C_Module = "mMain"

Public Enum csE_CopyFileError
  csEIgnore = 1
  csETryAgain = 2
  csECancel = 3
End Enum

' estructuras
' variables privadas
Private m_ClientProcessId               As Long

' eventos
' propiedadades publicas
Public g_connectAux As String

Public Function ClientProcessId() As Long
  ClientProcessId = m_ClientProcessId
End Function

Private Sub Main()
  On Error GoTo ControlError
  
  Dim db As cDataBase
  Set db = New cDataBase
  
  If Not pCopyFiles() Then Exit Sub
  
  Dim server    As String
  Dim DataBase  As String
  Dim User      As String
  Dim Password  As String
  
  Dim AppPath   As String
  Dim IniFile   As String
  
  AppPath = ValidPath(App.Path)
  IniFile = AppPath & "update.ini"
  
  server = GetIniValue("CONNECT", "server", "", IniFile)
  DataBase = GetIniValue("CONNECT", "database", "", IniFile)
  User = GetIniValue("CONNECT", "user", "", IniFile)
  Password = GetIniValue("CONNECT", "password", "", IniFile)
  
  server = Decrypt(server, "Virginia Said-Neron-Catalina-la belleza")
  DataBase = Decrypt(DataBase, "Virginia Said-Neron-Catalina-la belleza")
  User = Decrypt(User, "Virginia Said-Neron-Catalina-la belleza")
  Password = Decrypt(Password, "Virginia Said-Neron-Catalina-la belleza")

  If Not db.OpenConnection(server, _
                           DataBase, _
                           User, _
                           Password, _
                           False) Then
    Exit Sub
  End If
  
  If pExecuteScript(ValidPath(App.Path) & "script.sql", db) Then
    MsgInfo "Actualización realizada con éxito"
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "GetTables", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Sub MngError(ByRef Err As Object, _
                    ByVal FunctionName As String, _
                    ByVal Module As String, _
                    Optional ByVal infoAdd As String)
                    
  If infoAdd <> vbNullString Then infoAdd = vbCrLf & vbCrLf & infoAdd
                    
  MsgBox "Error en funcion " & Module & "." _
         & FunctionName & vbCrLf & vbCrLf _
         & Err.Description & infoAdd
End Sub

Private Function pExecuteScript(ByVal scriptFile As String, _
                                ByRef db As cDataBase) As Boolean

  Dim sqlstmt     As String
  Dim iFile       As Long
  Dim scriptLen   As Long
  
  iFile = FreeFile
  
  Open scriptFile For Input As #iFile
  
  scriptLen = FileLen(scriptFile)
  
  If scriptLen Then
    
    sqlstmt = Input$(LOF(iFile), iFile)
    
    Close iFile
    
    If Not db.ExecuteBatch(sqlstmt, "") Then Exit Function
  
  Else
      
    Close iFile

  End If
  
  pExecuteScript = True
End Function

Public Function ValidPath(ByVal Path As String) As String
  If Right$(Path, 1) <> "\" Then
    Path = Path & "\"
  End If
  ValidPath = Path
End Function

Private Function pCopyFile(ByVal FileSource As String, ByVal FileTo As String) As Boolean
  Dim strError As String
  Dim rslt     As csE_CopyFileError
  
  rslt = csETryAgain
  
  Do While rslt = csETryAgain
    
    DoEvents
    
    If Not pCopyFileAux(FileSource, FileTo, strError) Then

      rslt = pContinue(FileSource, strError)
      
      If rslt = csECancel Then Exit Function
    Else
      
      pSetAttribute FileTo
      Exit Do
    End If
  Loop
  
  pCopyFile = True
End Function

Private Function pCopyFileAux(ByVal FileSource As String, ByVal FileTo As String, ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If Not pDeleteFile(FileTo, strError) Then Exit Function
  
  FileCopy FileSource, FileTo
  
  strError = Err.Description
  
  pCopyFileAux = Err.Number = 0
End Function

Private Function pDeleteFile(ByVal File As String, ByRef strError As String) As Boolean
  On Error Resume Next
  
  Err.Clear
  
  If FileExists(File) Then
    SetAttr File, vbNormal
    Kill File
  End If
  
  strError = Err.Description

  pDeleteFile = Err.Number = 0
End Function

Private Function pContinue(ByVal File As String, ByVal strError As String) As csE_CopyFileError
  Dim rslt As VbMsgBoxResult
  Dim msg  As String
  
  msg = "Ha ocurrido un error copiando el archivo '" & File & "'." & vbCrLf & vbCrLf
  msg = msg & "Error: " & strError & vbCrLf & vbCrLf
  rslt = MsgBox(msg, vbAbortRetryIgnore)
  
  Select Case rslt
    Case vbIgnore
      pContinue = csEIgnore
    Case vbRetry
      pContinue = csETryAgain
    Case vbAbort
      pContinue = csECancel
  End Select
End Function

Private Sub pSetAttribute(ByVal File As String)
  SetAttr File, vbNormal
End Sub

Private Function pCopyFiles() As Boolean
  Dim strFile   As String
  Dim AppPath   As String
  Dim IniFile   As String
  Dim path_csr  As String
  
  AppPath = ValidPath(App.Path)
  IniFile = AppPath & "update.ini"
  path_csr = GetIniValue("REPORTES", "path", "", IniFile)
  path_csr = ValidPath(Decrypt(path_csr, "Virginia Said-Neron-Catalina-la belleza"))
  
  strFile = Dir(AppPath & "*.csr")
  
  Do While strFile <> ""
    If Not pCopyFile(AppPath & strFile, _
                     path_csr & strFile) Then
      Exit Function
    End If
    strFile = Dir()
  Loop
  
  pCopyFiles = True
End Function

Public Function DivideByCero(ByVal x1 As Double, ByVal x2 As Double) As Double
  If x2 = 0 Then
    DivideByCero = 0
  Else
    DivideByCero = x1 / x2
  End If
End Function
