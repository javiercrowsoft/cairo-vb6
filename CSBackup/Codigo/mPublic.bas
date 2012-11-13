Attribute VB_Name = "mPublic"
Option Explicit

Public Const LOG_NAME             As String = "CSBackup.log"

Public Const csIniFile            As String = "CSBackup.ini"
Public Const csDbPath             As String = "db_path"
Public Const csSecConfig          As String = "Config"
Public Const csSecWindows         As String = "Windows"
Public Const csSecSQLServer       As String = "SQLServer"
Public Const csPasswordFiles      As String = "PasswordFiles"
Public Const csPasswordTestValue  As String = "PasswordTestValue"
Public Const csUseMasterPassword  As String = "UseMasterPassword"
Public Const csInitWithWindows    As String = "InitWithWindows"

Public Const c_testvalue = "kamekamehaaa"

Public Const c_K_LoginServers = "SERVERS"
Public Const c_K_LoginLastServer = "LAST_SERVER"
Public Const c_K_LoginUsers = "USERS"
Public Const c_K_SecurityType = "TYPE_SECURITY"

Public Const c_close_folder = 1
Public Const c_open_folder = 2
Public Const c_file = 3
Public Const c_close_folder_selected = 4
Public Const c_open_folder_selected = 5

Public Enum csETaskTypeBackup
  c_TaskTypeBackupFile = 1
  c_TaskTypeBackupDB = 2
End Enum

Private Const c_CRLF = "@;"
Private Const c_CRLF2 = ";"

Public Enum csErrorLevel
    csErrorWarning = 1
    csErrorFatal = 2
    csErrorInformation = 3
End Enum

Public Enum csErrorType
    csErrorAdo = 1
    csErrorVba = 2
End Enum

Public Enum csTypes
  csInteger = 2
  csDouble = 5
  csCurrency = 6
  csText = 200
  csId = -1
  csCuit = -100
  csBoolean = -200
  csSingle = -300
  csVariant = -400
  csLong = -500
  csDate = -600
  csDateOrNull = -700
End Enum

Private m_MasterPassword    As String
Private m_PasswordFiles     As String

Private Sub Main()

  fMainMDI.Show

  If App.PrevInstance Then

    MsgBox "Ya existe una instancia de CSBackup ejecutandose", vbInformation

    Unload fMainMDI
    End

  Else
  
    If pValidateInstall() Then
    
      If LoadMasterPassword() Then
    
        pSetInitWithWindows
    
        pLoadIniValues
      
        fMain.Show
        LoadTask fMain.lvTask
        LoadSchedule fMain.lvSchedule
      
        fBackup.Show
        fMain.ZOrder
        
        If Command$ = "-r" Then
          fMainMDI.WindowState = vbMinimized
          fMainMDI.Hide
        End If
      
      Else
      
        Unload fMainMDI
        End
        
      End If
    
    Else
    
      Unload fMainMDI
      End
      
    End If
  End If
End Sub

Public Sub pSetInitWithWindows()
  Dim s As String
  Dim InitWithWindows As Boolean
  Dim Key As String
  
  Set mReg = New cRegistry
  
  Key = App.Title & "(" & App.Path & ")"
  InitWithWindows = Val(GetIniValue(csSecConfig, _
                    csInitWithWindows, _
                    1, _
                    GetIniFullFile(csIniFile)))
                    
  s = mReg.GetRegString(cvRun, Key)
  If s <> "" Then
    If Not InitWithWindows Then
      RemoveFromRegistry Key
    End If
  Else
    InsertInRegistry Key, """" & App.Path & "\" & App.EXEName & ".exe"" -r"
  End If
End Sub

Private Function pValidateInstall() As Boolean
  Dim dbPath   As String
  
  dbPath = GetIniValue(csSecConfig, _
                       csDbPath, _
                       vbNullString, _
                       GetIniFullFile(csIniFile))

  If LenB(dbPath) = 0 Then
    dbPath = FileGetValidPath(App.Path) & "database"
    FileCreateFolder dbPath
    EditPreferences vbModal, dbPath
  End If
  
  dbPath = GetIniValue(csSecConfig, _
                       csDbPath, _
                       vbNullString, _
                       GetIniFullFile(csIniFile))

  Dim bValid As Boolean
  
  If LenB(dbPath) <> 0 Then
    bValid = FileFolderExists_(dbPath)
  End If
  
  If Not bValid Then
    MsgBox "Debe indicar una carpeta donde se guardaran las definiciones de tareas de CSBackup"
    Exit Function
  Else
    pValidateInstall = True
  End If
  
End Function

Private Sub pLoadIniValues()
  LoadPasswordFiles
End Sub

Public Sub LoadPasswordFiles()

  Dim Password As String
  Password = GetProgramPassword()
  
  m_PasswordFiles = GetIniValue(csSecConfig, _
                              csPasswordFiles, _
                              vbNullString, _
                              GetIniFullFile(csIniFile))
  m_PasswordFiles = DecryptData(m_PasswordFiles, Password)
  
End Sub

Public Function LoadMasterPassword() As Boolean
  Dim bUseMasterPassword As Boolean
  
  bUseMasterPassword = Val(GetIniValue(csSecConfig, _
                              csUseMasterPassword, _
                              0, _
                              GetIniFullFile(csIniFile)))
  If bUseMasterPassword Then
  
    LoadMasterPassword = RequestMasterPassword(False)
  
  Else
    
    LoadMasterPassword = True
  
  End If

End Function

Public Sub EditPreferences(ByVal ShowMode As FormShowConstants, Optional ByVal dbPath As String)
  Load fPreferences
  If LenB(dbPath) Then
    fPreferences.txPath.Text = dbPath
  End If
  fPreferences.Show ShowMode
End Sub

Public Sub FormLoad(ByRef f As Form, ByVal bSize As Boolean)
  On Error Resume Next
  
  With f
    
    .Top = GetIniValue(csSecWindows, .Name & "_top", 2000, GetIniFullFile(csIniFile))
    .Left = GetIniValue(csSecWindows, .Name & "_left", 3000, GetIniFullFile(csIniFile))
    
    If bSize Then
      .Width = GetIniValue(csSecWindows, .Name & "_width", 6000, GetIniFullFile(csIniFile))
      .Height = GetIniValue(csSecWindows, .Name & "_height", 4000, GetIniFullFile(csIniFile))
    End If
  End With
End Sub

Public Sub FormUnload(ByRef f As Form, ByVal bSize As Boolean)
  With f
    If .WindowState = vbNormal Then
      SetIniValue csSecWindows, .Name & "_top", .Top, GetIniFullFile(csIniFile)
      SetIniValue csSecWindows, .Name & "_left", .Left, GetIniFullFile(csIniFile)
      
      If bSize Then
        SetIniValue csSecWindows, .Name & "_width", .Width, GetIniFullFile(csIniFile)
        SetIniValue csSecWindows, .Name & "_height", .Height, GetIniFullFile(csIniFile)
      End If
    End If
  End With
End Sub

Public Sub MngError(ByRef ErrObj As Object, _
                    ByVal FunctionName As String, _
                    ByVal Module As String, _
                    ByVal InfoAdd As String, _
                    Optional ByVal Title As String = "@@@@@")
  
  Title = pGetTitle(Title)
  MsgBox "Error: " & Err.Description & vbCrLf _
                   & "Funcion: " & Module & "." & FunctionName & vbCrLf _
                   & InfoAdd, _
         vbCritical, _
         Title
End Sub

Public Sub MsgWarning(ByVal msg As String, Optional ByVal Title As String = "@@@@@")
    pMsgAux msg, vbExclamation, Title
End Sub

Private Sub pMsgAux(ByVal msg As String, ByVal Style As VbMsgBoxStyle, ByVal Title As String)
  msg = pGetMessage(msg)
  Title = pGetTitle(Title)
  MsgBox msg, Style, Title
End Sub

Private Function pGetMessage(ByVal msg As String) As String
  msg = Replace(msg, c_CRLF, vbCrLf)
  msg = Replace(msg, c_CRLF2, vbCrLf)

  pGetMessage = msg
End Function

Private Function pGetTitle(ByVal Title As String) As String
  If Title = "" Then Title = "CrowSoft"
  If Title = "@@@@@" Then Title = "CrowSoft"
  pGetTitle = Title
End Function

Public Function Ask(ByVal msg As String, ByVal default As VbMsgBoxResult, Optional ByVal Title As String) As Boolean
  Dim N As Integer
  msg = pGetMessage(msg)
  If InStr(1, msg, "?") = 0 Then msg = "¿" & msg & "?"
  If default = vbNo Then N = vbDefaultButton2
  pGetTitle Title
  Ask = vbYes = MsgBox(msg, vbYesNo + N + vbQuestion, Title)
  
End Function

Public Function TaskType(ByVal TaskFile As String, _
                         ByVal bSilent As Boolean, _
                         Optional ByRef strError As String) As csETaskTypeBackup
  Dim DocXml As cXml
  Set DocXml = New cXml
  
  DocXml.Init Nothing
  DocXml.Name = GetFileName_(TaskFile)
  DocXml.Path = GetPath_(TaskFile)
  
  If Not DocXml.OpenXml(bSilent, strError) Then Exit Function
  
  
  Dim Root  As Object
  
  Set Root = DocXml.GetRootNode()

  TaskType = Val(pGetChildNodeProperty(Root, DocXml, "TaskType", "Value"))
  
End Function

Public Function GetPasswordFiles() As String
  GetPasswordFiles = m_PasswordFiles
End Function

Public Function RequestMasterPassword(ByVal bWithConfirm As Boolean) As Boolean
  If Not bWithConfirm Then
    fMasterPassword.txPassword2.Visible = False
    fMasterPassword.lbConfirm.Visible = False
  End If
  fMasterPassword.Show vbModal
  
  If fMasterPassword.Ok Then
  
    m_MasterPassword = fMasterPassword.txPassword.Text
    RequestMasterPassword = True
  End If
  Unload fMasterPassword
End Function

Public Function ValidateMasterPassword(ByVal Password As String) As Boolean
  Dim testValue As String
  testValue = GetIniValue(csSecConfig, _
                          csPasswordTestValue, _
                          vbNullString, _
                          GetIniFullFile(csIniFile))
  ValidateMasterPassword = DecryptData(testValue, Password) = c_testvalue
End Function

Public Function GetMasterPassword() As String
  GetMasterPassword = m_MasterPassword
End Function

Public Sub ChangeMasterPassword(ByVal OldMasterPassword As String, _
                                ByVal NewMasterPassword As String)

  ' Tengo que levantar todas las tareas
  ' y grabar con la nueva password
  '
  Dim i As Long
  Dim Task As Object
  
  With fMain.lvTask.ListItems
    For i = 1 To .Count
      If TaskType(.Item(i).SubItems(1), False) = c_TaskTypeBackupFile Then
        Set Task = New cTask
      Else
        Set Task = New cSQLTaskCommandBackup
      End If
      
      Dim oTask As cSQLTaskCommandBackup
      m_MasterPassword = OldMasterPassword
      
      If Task.Load(.Item(i).SubItems(1), False) Then
        
        m_MasterPassword = NewMasterPassword
        Task.Save
      End If
    
    Next
  End With
  
  m_MasterPassword = NewMasterPassword
End Sub

Public Function GetDriveSerialNumber(Optional ByVal DriveLetter As String) As Long

  Dim fso As Object, Drv As Object
  Dim DriveSerial As Long
  
  'Create a FileSystemObject object
  Set fso = CreateObject("Scripting.FileSystemObject")
  
  'Assign the current drive letter if not specified
  If DriveLetter <> "" Then
    Set Drv = fso.GetDrive(DriveLetter)
  Else
    Set Drv = fso.GetDrive(fso.GetDriveName(App.Path))
  End If

  With Drv
    If .IsReady Then
      DriveSerial = Abs(.SerialNumber)
    Else  '"Drive Not Ready!"
      DriveSerial = -1
    End If
  End With
  
  'Clean up
  Set Drv = Nothing
  Set fso = Nothing
  
  GetDriveSerialNumber = DriveSerial
  
End Function

Public Function GetProgramPassword() As String
  Dim Pwd As String
  
  Pwd = GetDriveSerialNumber("c")
  
  If LenB(m_MasterPassword) Then
    Pwd = EncryptData(Pwd, m_MasterPassword)
  End If
  
  GetProgramPassword = Pwd
End Function

Public Function NotUnloadFromAppOrWindows(ByVal UnloadMode As Integer) As Boolean
  NotUnloadFromAppOrWindows = UnloadMode <> vbFormCode _
                          And UnloadMode <> vbFormMDIForm _
                          And UnloadMode <> vbAppWindows _
                          And UnloadMode <> vbAppTaskManager
End Function


