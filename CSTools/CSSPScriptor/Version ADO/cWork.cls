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

Private Const c_LoginSignature As String = "pirulo"

Private WithEvents m_SQLServer As cSQLServer
Attribute m_SQLServer.VB_VarHelpID = -1
Private m_bCancel As Boolean

Public Sub Run(ByRef Server As String, _
               ByRef DataBase As String, _
               ByRef User As String, _
               ByRef Password As String, _
               ByRef File As String, _
               ByRef LogFile As String, _
               ByVal bEncryptAll As Boolean)
                  
  Set m_SQLServer = New cSQLServer
  If Not m_SQLServer.OpenConnectionEx(Server, User, Password, False, DataBase) Then
    LogError "No fue posible conectarse al servidor", "Run", C_Module, ""
    Exit Sub
  End If
  
  pRunScriptFile DataBase, File
  
  If bEncryptAll Then pEncryptAll DataBase
  
End Sub

Private Sub m_SQLServer_Msg(ByVal Msg As String)
  sbMsg Msg
End Sub

Private Sub m_SQLServer_ShowProgress(ByVal Percent As Single)
  ShowProgress Percent
End Sub

Private Sub m_SQLServer_ShowProgress2(ByVal Percent As Single, ByVal Msg As String, Cancel As Boolean)
  If Msg <> "" Then sbMsg Msg
  Cancel = m_bCancel
End Sub

Private Sub pRunScriptFile(ByVal Db As String, ByVal sqlFile As String)
  On Error GoTo ControlError

  Dim File   As cFile

  Set File = New cFile
  File.Init "popSpCreateScript", C_Module, Nothing
  
  File.Filter = "SQL Files|*.sql"
  
  If Not File.FOpen(sqlFile, csRead, False, True, csShared, False, False) Then Exit Sub
  
  Dim Encrypt As cEncrypt
  Set Encrypt = New cEncrypt
  
  Dim script     As String
  
  m_bCancel = False
  
  While Not File.IsEOF
  
    DoEvents: DoEvents: DoEvents: DoEvents
  
    If Not File.FRead(script, False) Then Exit Sub
    script = Encrypt.Decrypt(script, c_LoginSignature)
    pExecuteScript script, Db
    
    If m_bCancel Then
      MsgWarning "Proceso cancelado por el usuario"
      Exit Sub
    End If
  Wend
  
  MsgInfo "Proceso terminado con éxito"

  GoTo ExitProc
ControlError:
  MngError Err, "pRunScriptFile", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Function pExecuteScript(ByVal script As String, ByVal dbName As String) As Boolean
#If PREPROC_ADO Then
  pExecuteScript = m_SQLServer.SQLScript.ExecuteBatchWithResultAndMessage(script, dbName)
#Else
  pExecuteScript = m_SQLServer.SQLScript.ExecuteBatchWithResultAndMessage(script, dbName)
#End If
End Function

Private Sub Class_Terminate()
  Set m_SQLServer = Nothing
End Sub

Private Sub pEncryptAll(ByVal dbName As String)
  Dim coll    As Collection
  Dim i       As Integer
  Dim spName  As String
  Dim script  As String
  
  m_SQLServer.GetSps dbName, coll
  
  For i = 1 To coll.Count
    
    DoEvents: DoEvents: DoEvents: DoEvents
    
    spName = coll(i)

    script = m_SQLServer.GetSpCode(dbName, spName, True)
    
    If pHaveToEncrypt(script) Then
    
      pExecuteScript script, dbName
    End If
    
    If m_bCancel Then
      MsgWarning "Proceso cancelado por el usuario"
      Exit Sub
    End If
    
  Next
End Sub

Private Function pHaveToEncrypt(ByVal spCode As String) As Boolean
  pHaveToEncrypt = Len(spCode) > 0
End Function
