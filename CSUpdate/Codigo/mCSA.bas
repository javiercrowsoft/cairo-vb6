Attribute VB_Name = "mCSA"
Option Explicit

' constantes
Private Const C_Module = "mCSA"

Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpString As Any, ByVal lpFileName As String) As Long

Public Const c_ini_sec_config = "CONFIG"
Public Const c_ini_sec_scripts = "SCRIPTS"
Public Const c_ini_sec_files = "FILES"
Public Const c_ini_sec_reports = "REPORTS"

Public Const c_ini_key_IdCliente = "IdCliente"
Public Const c_ini_key_Version = "Version"
Public Const c_ini_key_Description = "Description"
Public Const c_ini_key_DB_MIN_Version = "DB_MIN_Version"
Public Const c_ini_key_EXE_MIN_Version = "EXE_MIN_Version"
Public Const c_ini_key_APP_MIN_Version = "APP_MIN_Version"
Public Const c_ini_key_OS_Version = "OS_Version"
Public Const c_ini_key_SQL_Version = "SQL_Version"
Public Const c_ini_key_DataBases = "DataBases"
Public Const c_ini_key_DB_BackUp = "DB_BackUp"
Public Const c_ini_key_StopCairo = "StopCairo"

Public Const c_ini_key_Files = "Files"
Public Const c_ini_key_FileName = "FileName"
Public Const c_ini_key_FolderTarget = "FolderTarget"
Public Const c_ini_key_FileVersion = "FileVersion"
Public Const c_ini_key_CreateShortCut = "CreateShortCut"
Public Const c_ini_key_FolderShortCut = "FolderShortCut"
Public Const c_ini_key_Run = "Run"
Public Const c_ini_key_DeleteAfterRun = "DeleteAfterRun"
Public Const c_ini_key_Register = "Register"
Public Const c_ini_key_AsocToDoc = "AsocToDoc"
Public Const c_ini_key_Doct_id = "doct_id"
Public Const c_ini_key_AsocToTbl = "AsocToTbl"
Public Const c_ini_key_tbl_id = "tbl_id"

' estructuras
Public Type T_ScriptFile
  idFile              As Long
  SourcePath          As String
  
  name                As String
  Filename            As String
  Description         As String
  DataBases           As String
  
  vDataBases()        As String
End Type

Public Type T_File
  idFile              As Long
  SourcePath          As String
  
  name                As String
  Filename            As String
  Description         As String
  FolderTarget        As String
  FileVersion         As String
  CreateShortCut      As Boolean
  FolderShortCut      As String
  Run                 As Boolean
  DeleteAfterRun      As Boolean
  Register            As Boolean
End Type

Public Type T_Report
  idFile              As Long
  SourcePath          As String
  
  name                As String
  Filename            As String
  Description         As String
  AsocToDoc           As Boolean
  doct_id             As Long
  AsocToTbl           As Boolean
  tbl_id              As Long
End Type

Public Type T_SetupCfg
  CSA_File            As String
  IdCliente           As String
  Version             As String
  Description         As String
  DB_MIN_Version      As String
  EXE_MIN_Version     As String
  APP_MIN_Version     As String
  OS_Version          As String
  SQL_Version         As String
  DataBases           As String
  DB_BackUp           As Boolean
  StopCairo           As Boolean
  Scripts()           As T_ScriptFile
  Files()             As T_File
  Reports()           As T_Report
End Type

Public Type t_Database
  Empresa  As String
  Version  As String
  DataBase As String
  server   As String
  db_id    As Long
  User     As String
  Pwd      As String
  UseNT    As Boolean
  bBackup  As Boolean
End Type

Public Sub CSASaveValue(ByVal Section, _
                        ByVal Item As String, _
                        ByVal Value As String, _
                        ByVal File As String)
  On Error GoTo ControlError
  
  WritePrivateProfileString Section, _
                            Item, _
                            Value, _
                            File

  GoTo ExitProc
ControlError:
  MngError Err, "CSASaveValue", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

