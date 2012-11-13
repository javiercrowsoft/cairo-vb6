VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cWork"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Const C_Module As String = "cWork"

Private Const c_LoginSignature As String = "Virginia Said-Neron-Catalina-la belleza"

Private WithEvents m_SQLServer As cSQLServer
Attribute m_SQLServer.VB_VarHelpID = -1
Private m_bCancel As Boolean

Public Sub Run(ByRef server As String, _
               ByRef database As String, _
               ByRef user As String, _
               ByRef password As String, _
               ByRef File As String, _
               ByRef logFile As String)
                  
  Set m_SQLServer = New cSQLServer
  If Not m_SQLServer.OpenConnectionEx(server, user, password, False) Then
    LogError "No fue posible conectarse al servidor"
    Exit Sub
  End If
  
  pRunScriptFile database, File
  
End Sub

Private Sub m_SQLServer_Msg(ByVal msg As String)
  sbMsg msg
End Sub

Private Sub m_SQLServer_ShowProgress(ByVal percent As Single)
  ShowProgress percent
End Sub

Private Sub m_SQLServer_ShowProgress2(ByVal percent As Single, ByVal msg As String, Cancel As Boolean)
  If msg <> "" Then sbMsg msg
  Cancel = m_bCancel
End Sub

Private Sub pRunScriptFile(ByVal db As String, ByVal sqlFile As String)
  On Error GoTo ControlError

  Dim File   As cFile

  Set File = New cFile
  File.Init "popSpCreateScript", C_Module, Nothing
  
  File.Filter = "SQL Files|*.sql"
  
  If Not File.FOpen(sqlFile, csRead, False, True, csShared, False, False) Then Exit Sub
  
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  
  Dim Script     As String
  
  m_bCancel = False
  
  While Not File.IsEOF
  
    DoEvents: DoEvents: DoEvents: DoEvents
  
    If Not File.FRead(Script, False) Then Exit Sub
    Script = Encrypt.Decrypt(Script, c_LoginSignature)
    pExecuteScript Script, db
    
    If m_bCancel Then
      MsgWarning "Proceso cancelado por el usuario"
      Exit Sub
    End If
  Wend
  
  MsgInfo "Proceso terminado con éxito"

  GoTo ExitProc
ControlError:
  MngError err, "pRunScriptFile", C_Module, ""
  If err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pExecuteScript(ByVal Script As String, ByVal dbName As String) As Boolean
  pExecuteScript = m_SQLServer.SQLScript.ExecuteBatchWithResultAndMessage(Script, dbName)
End Function

Private Sub Class_Terminate()
  Set m_SQLServer = Nothing
End Sub

