Attribute VB_Name = "mIni"
Option Explicit

Private Const C_Module = "mIni"

Private Declare Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" _
                                (ByVal lpApplicationName As String, _
                                 ByVal lpKeyName As Any, _
                                 ByVal lpDefault As String, _
                                 ByVal lpReturnedString As String, _
                                 ByVal nSize As Long, _
                                 ByVal lpFileName As String) As Long
                                
Private Declare Function WritePrivateProfileString Lib "kernel32" Alias "WritePrivateProfileStringA" _
                                (ByVal lpApplicationName As String, _
                                 ByVal lpKeyName As Any, _
                                 ByVal lpString As Any, _
                                 ByVal lpFileName As String) As Long

Public Function GetIniValue(ByVal Section As String, _
                            ByVal Item As String, _
                            ByVal default As String, _
                            ByVal File As String) As String
  
  On Error GoTo ControlError

  Dim buffer As String
  Dim length As Integer
  Dim rtn    As String
 
  buffer = String$(256, " ")
  length = GetPrivateProfileString(Section, Item, default, buffer, Len(buffer), File)
  rtn = Mid$(buffer, 1, length)
  
  GetIniValue = rtn
  
  GoTo ExitProc
ControlError:
  MngError Err, "GetIniValue", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Sub SetIniValue(ByVal Section, _
                       ByVal Item As String, _
                       ByVal Value As String, _
                       ByVal File As String)
                       
  On Error GoTo ControlError
  
  WritePrivateProfileString Section, Item, Value, File

  GoTo ExitProc
ControlError:
  MngError Err, "SetIniValue", C_Module, vbNullString
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Public Function GetIniFullFile(ByVal FileName As String)
  GetIniFullFile = (App.Path & "\" & FileName)
End Function

Public Sub GetMainIniLogin(ByRef Servers As String, ByRef Users As String, ByRef SecurityType As String, ByRef LastServer As String)
  LastServer = GetIniValue(csSecSQLServer, c_K_LoginLastServer, LastServer, GetIniFullFile(csIniFile))
  Servers = GetIniValue(csSecSQLServer, c_K_LoginServers, Servers, GetIniFullFile(csIniFile))
  Users = GetIniValue(csSecSQLServer, c_K_LoginUsers, Users, GetIniFullFile(csIniFile))
  SecurityType = GetIniValue(csSecSQLServer, c_K_SecurityType, SecurityType, GetIniFullFile(csIniFile))
End Sub

Public Sub SaveMainIniLogin(ByVal Servers As String, ByVal Users As String, ByVal SecurityType As String, ByRef LastServer As String)
  SetIniValue csSecSQLServer, c_K_LoginLastServer, LastServer, GetIniFullFile(csIniFile)
  SetIniValue csSecSQLServer, c_K_LoginServers, Servers, GetIniFullFile(csIniFile)
  SetIniValue csSecSQLServer, c_K_LoginUsers, Users, GetIniFullFile(csIniFile)
  SetIniValue csSecSQLServer, c_K_SecurityType, SecurityType, GetIniFullFile(csIniFile)
End Sub

