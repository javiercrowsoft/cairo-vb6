VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSQLTaskCommandBackup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' cSQLTaskCommandBackup
' 17-05-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' interfaces

' constantes
Private Const C_Module = "cSQLTaskCommandBackup"

' estructuras
' variables privadas
Private m_Name     As String
Private m_File     As String
Private m_Descrip  As String
Private m_Code     As String
Private m_ZipFiles As Long

Private m_FtpAddress As String
Private m_FtpUser    As String
Private m_FtpPwd     As String
Private m_FtpPort    As Long

Private m_DataBase      As String
Private m_IsFull        As Boolean    ' Hace un backup de data
Private m_IsLog         As Boolean    ' Hace un backup del log
Private m_InitLog       As Boolean    ' Inicializa el Log
Private m_FileDataBase                  As String
Private m_FileLog                       As String
Private m_ServerFolder                  As String
Private m_OverWrite                     As Boolean
Private m_LogUseDefaultPath             As Boolean
Private m_DataBaseUseDefaultPath        As Boolean
Private m_Server                        As String
Private m_User                          As String
Private m_Pwd                           As String
Private m_SecurityType                  As csSQLSecurityType

Private m_Connection  As cConnection

' eventos
' propiedadades publicas
Public Property Get OverWrite() As Boolean
   OverWrite = m_OverWrite
End Property

Public Property Let OverWrite(ByVal rhs As Boolean)
   m_OverWrite = rhs
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

Public Property Get Pwd() As String
   Pwd = m_Pwd
End Property

Public Property Let Pwd(ByVal rhs As String)
   m_Pwd = rhs
End Property

Public Property Get SecurityType() As csSQLSecurityType
   SecurityType = m_SecurityType
End Property

Public Property Let SecurityType(ByVal rhs As csSQLSecurityType)
   m_SecurityType = rhs
End Property

Public Property Get DataBase() As String
   DataBase = m_DataBase
End Property

Public Property Let DataBase(ByVal rhs As String)
   m_DataBase = rhs
End Property

Public Property Get IsFull() As Boolean
   IsFull = m_IsFull
End Property

Public Property Let IsFull(ByVal rhs As Boolean)
   m_IsFull = rhs
End Property

Public Property Get IsLog() As Boolean
   IsLog = m_IsLog
End Property

Public Property Let IsLog(ByVal rhs As Boolean)
   m_IsLog = rhs
End Property

Public Property Get InitLog() As Boolean
   InitLog = m_InitLog
End Property

Public Property Let InitLog(ByVal rhs As Boolean)
   m_InitLog = rhs
End Property

Public Property Get FileDataBase() As String
   FileDataBase = m_FileDataBase
End Property

Public Property Let FileDataBase(ByVal rhs As String)
   m_FileDataBase = rhs
End Property

Public Property Get FileLog() As String
   FileLog = m_FileLog
End Property

Public Property Let FileLog(ByVal rhs As String)
   m_FileLog = rhs
End Property

Public Property Get ServerFolder() As String
   ServerFolder = m_ServerFolder
End Property

Public Property Let ServerFolder(ByVal rhs As String)
   m_ServerFolder = rhs
End Property

Public Property Get ZipFiles() As String
  ZipFiles = m_ZipFiles
End Property

Public Property Let ZipFiles(ByVal rhs As String)
  m_ZipFiles = rhs
End Property

Public Property Get LogUseDefaultPath() As Boolean
   LogUseDefaultPath = m_LogUseDefaultPath
End Property

Public Property Let LogUseDefaultPath(ByVal rhs As Boolean)
   m_LogUseDefaultPath = rhs
End Property

Public Property Get DataBaseUseDefaultPath() As Boolean
   DataBaseUseDefaultPath = m_DataBaseUseDefaultPath
End Property

Public Property Let DataBaseUseDefaultPath(ByVal rhs As Boolean)
   m_DataBaseUseDefaultPath = rhs
End Property

Public Property Get Command() As String
  Dim rtn As String
  
  If m_IsFull Then
    
    rtn = "BACKUP DATABASE " & m_DataBase & " TO DISK='"
    If m_DataBaseUseDefaultPath Then
      rtn = rtn & FileGetValidPath(m_Connection.Server.Registry.SQLRootPath) & "Backup\" & m_FileDataBase & "'"
    Else
      rtn = rtn & m_FileDataBase & "'"
    End If
    rtn = rtn & " WITH NOUNLOAD ,  NOSKIP"
    If m_OverWrite Then
      rtn = rtn & ",  INIT"
    End If
  End If
  
  If m_IsLog Then
    rtn = rtn & "BACKUP LOG " & m_DataBase & " TO DISK '"
    If m_LogUseDefaultPath Then
      rtn = rtn & FileGetValidPath(m_Connection.Server.Registry.SQLRootPath) & "Backup\" & m_FileLog & "'"
    Else
      rtn = rtn & m_FileLog & "'"
    End If
    rtn = rtn & "WITH NOINIT , NOUNLOAD"
    If m_InitLog Then
      rtn = rtn & "NOSKIP"
    End If
  End If
  
  Command = rtn
End Property

Public Property Get Conn() As cConnection
  Set Conn = m_Connection
End Property

Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get File() As String
  File = m_File
End Property

Public Property Let File(ByVal rhs As String)
  m_File = rhs
End Property

Public Property Get Descrip() As String
  Descrip = m_Descrip
End Property

Public Property Let Descrip(ByVal rhs As String)
  m_Descrip = rhs
End Property

Public Property Get Code() As String
  Code = m_Code
End Property

Public Property Let Code(ByVal rhs As String)
  m_Code = rhs
End Property

Public Property Get FtpAddress() As String
  FtpAddress = m_FtpAddress
End Property

Public Property Let FtpAddress(ByVal rhs As String)
  m_FtpAddress = rhs
End Property

Public Property Get FtpUser() As String
  FtpUser = m_FtpUser
End Property

Public Property Let FtpUser(ByVal rhs As String)
  m_FtpUser = rhs
End Property

Public Property Get FtpPwd() As String
  FtpPwd = m_FtpPwd
End Property

Public Property Let FtpPwd(ByVal rhs As String)
  m_FtpPwd = rhs
End Property

Public Property Get FtpPort() As Long
  FtpPort = m_FtpPort
End Property

Public Property Let FtpPort(ByVal rhs As Long)
  m_FtpPort = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function Connect(ByVal Server As String, _
                        ByVal User As String, _
                        ByVal Pwd As String, _
                        ByVal SecurityType As csSQLSecurityType, _
                        ByVal bSilent As Boolean, _
                        Optional ByRef strError As String) As Boolean

  Set m_Connection = Nothing
  Set m_Connection = New cConnection
  
  Connect = m_Connection.OpenConnectionEx(Server, _
                                          User, _
                                          Pwd, _
                                          SecurityType = csTSNT, _
                                          "master", _
                                          bSilent, _
                                          strError)

End Function

Public Function Load(ByVal TaskFile As String, _
                     ByVal bSilent As Boolean, _
                     Optional ByRef strError As String) As Boolean
  Dim DocXml As cXml
  Set DocXml = New cXml
  
  DocXml.Init Nothing
  DocXml.Name = GetFileName_(TaskFile)
  DocXml.Path = GetPath_(TaskFile)
  
  If Not DocXml.OpenXml(bSilent, strError) Then Exit Function
  
  m_Name = ""
  m_Code = ""
  m_File = ""
  m_Descrip = ""
  
  Dim Root  As Object
  Dim Node  As Object
  Dim Prop  As Object
  
  Set Root = DocXml.GetRootNode()

  m_Name = pGetChildNodeProperty(Root, DocXml, "Name", "Value")
  m_Code = pGetChildNodeProperty(Root, DocXml, "Code", "Value")
  m_File = pGetChildNodeProperty(Root, DocXml, "File", "Value")
  m_ZipFiles = Val(pGetChildNodeProperty(Root, DocXml, "ZipFiles", "Value"))
  m_Descrip = pGetChildNodeProperty(Root, DocXml, "Descrip", "Value")
      
  m_FtpAddress = pGetChildNodeProperty(Root, DocXml, "FtpAddress", "Value")
  m_FtpUser = pGetChildNodeProperty(Root, DocXml, "FtpUser", "Value")
  m_FtpPwd = pGetChildNodeProperty(Root, DocXml, "FtpPwd", "Value")
  m_FtpPwd = DecryptData(m_FtpPwd, GetProgramPassword())
  m_FtpPort = Val(pGetChildNodeProperty(Root, DocXml, "FtpPort", "Value"))
      
  m_DataBase = pGetChildNodeProperty(Root, DocXml, "DataBase", "Value")
  m_IsFull = Val(pGetChildNodeProperty(Root, DocXml, "IsFull", "Value"))
  m_IsLog = Val(pGetChildNodeProperty(Root, DocXml, "IsLog", "Value"))
  m_InitLog = Val(pGetChildNodeProperty(Root, DocXml, "InitLog", "Value"))
  m_FileDataBase = pGetChildNodeProperty(Root, DocXml, "FileDataBase", "Value")
  m_FileLog = pGetChildNodeProperty(Root, DocXml, "FileLog", "Value")
  m_ServerFolder = pGetChildNodeProperty(Root, DocXml, "ServerFolder", "Value")
  m_OverWrite = Val(pGetChildNodeProperty(Root, DocXml, "OverWrite", "Value"))
  m_DataBaseUseDefaultPath = Val(pGetChildNodeProperty(Root, DocXml, "DataBaseUseDefaultPath", "Value"))
  m_LogUseDefaultPath = Val(pGetChildNodeProperty(Root, DocXml, "LogUseDefaultPath", "Value"))
  m_Server = pGetChildNodeProperty(Root, DocXml, "Server", "Value")
  m_User = pGetChildNodeProperty(Root, DocXml, "User", "Value")
  m_Pwd = pGetChildNodeProperty(Root, DocXml, "Pwd", "Value")
  m_Pwd = DecryptData(m_Pwd, GetProgramPassword())
  m_SecurityType = Val(pGetChildNodeProperty(Root, DocXml, "SecurityType", "Value"))
      
  Load = True
End Function

Public Function Save() As Boolean
  Dim DocXml    As cXml
  Dim dbPath    As String
  Dim Root      As Object
  
  Set DocXml = New cXml
  
  dbPath = GetIniValue(csSecConfig, _
                       csDbPath, _
                       vbNullString, _
                       GetIniFullFile(csIniFile))
  
  DocXml.Init Nothing
  DocXml.Name = m_Code & "_def.xml"
  DocXml.Path = dbPath

  If Not DocXml.NewXml() Then Exit Function
  
  Set Root = DocXml.GetRootNode()
  
  pAddTag DocXml, Root, "Name", m_Name
  pAddTag DocXml, Root, "Code", m_Code
  pAddTag DocXml, Root, "File", m_File
  pAddTag DocXml, Root, "ZipFiles", m_ZipFiles
  pAddTag DocXml, Root, "Descrip", m_Descrip
  pAddTag DocXml, Root, "TaskType", c_TaskTypeBackupDB
  
  Dim Password As String
  Password = GetProgramPassword()
  
  pAddTag DocXml, Root, "FtpAddress", m_FtpAddress
  pAddTag DocXml, Root, "FtpUser", m_FtpUser
  pAddTag DocXml, Root, "FtpPwd", EncryptData(m_FtpPwd, Password)
  pAddTag DocXml, Root, "FtpPort", m_FtpPort
  
  pAddTag DocXml, Root, "DataBase", m_DataBase
  pAddTag DocXml, Root, "IsFull", CInt(m_IsFull)
  pAddTag DocXml, Root, "IsLog", CInt(m_IsLog)
  pAddTag DocXml, Root, "InitLog", CInt(m_InitLog)
  pAddTag DocXml, Root, "FileDataBase", m_FileDataBase
  pAddTag DocXml, Root, "FileLog", m_FileLog
  pAddTag DocXml, Root, "ServerFolder", m_ServerFolder
  pAddTag DocXml, Root, "OverWrite", CInt(m_OverWrite)
  pAddTag DocXml, Root, "DataBaseUseDefaultPath", CInt(m_DataBaseUseDefaultPath)
  pAddTag DocXml, Root, "LogUseDefaultPath", CInt(m_LogUseDefaultPath)
  pAddTag DocXml, Root, "Server", m_Server
  pAddTag DocXml, Root, "User", m_User
  pAddTag DocXml, Root, "Pwd", EncryptData(m_Pwd, Password)
  pAddTag DocXml, Root, "SecurityType", CInt(m_SecurityType)
  
  pAddTag DocXml, Root, "Command", Command
  
  Save = DocXml.Save(False)
End Function

Public Function ShowFindFileBackup(ByVal DataBase As String, ByVal File As String, ByVal Title As String) As String
  fExplorer.LoadDrives
  fExplorer.tvDir.Checkboxes = False
  fExplorer.Show vbModal
  If fExplorer.Ok Then
    If Not fExplorer.tvDir.SelectedItem Is Nothing Then
      ShowFindFileBackup = FileGetValidPath(fExplorer.tvDir.SelectedItem.FullPath) & DataBase
    End If
  End If
  Unload fExplorer
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
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
