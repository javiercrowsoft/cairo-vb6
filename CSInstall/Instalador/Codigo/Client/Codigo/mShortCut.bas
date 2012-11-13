Attribute VB_Name = "mShortCut"
Option Explicit

' Api
Private Declare Function CreateLink Lib "asschortcut.dll" (ByVal lpszPathObj As String, ByVal lpszPathLink As String, ByVal lpszDesc As String) As Long

Public Enum SpecialFolderIDs
    sfidDESKTOP = &H0
    sfidPROGRAMS = &H2
    sfidPERSONAL = &H5
    sfidFAVORITES = &H6
    sfidSTARTUP = &H7
    sfidRECENT = &H8
    sfidSENDTO = &H9
    sfidSTARTMENU = &HB
    sfidDESKTOPDIRECTORY = &H10
    sfidNETHOOD = &H13
    sfidFONTS = &H14
    sfidTEMPLATES = &H15
    sfidCOMMON_STARTMENU = &H16
    sfidCOMMON_PROGRAMS = &H17
    sfidCOMMON_STARTUP = &H18
    sfidCOMMON_DESKTOPDIRECTORY = &H19
    sfidAPPDATA = &H1A
    sfidPRINTHOOD = &H1B
    sfidPROGRAMS_FILES = &H26
    sfidProgramFiles = &H10000
    sfidCommonFiles = &H10001
End Enum

Public Declare Function SHGetSpecialFolderLocation Lib "shell32" (ByVal hwndOwner As Long, ByVal nFolder As SpecialFolderIDs, ByRef pidl As Long) As Long
Public Declare Function SHGetPathFromIDListA Lib "shell32" (ByVal pidl As Long, ByVal pszPath As String) As Long

Public Const NOERROR = 0

Private Const OF_EXIST = &H4000

'OFSTRUCT structure used by the OpenFile API function
Private Type OFSTRUCT            '136 bytes in length
  cBytes As String * 1
  fFixedDisk As String * 1
  nErrCode As Integer
  Reserved As String * 4
  szPathName As String * 128
End Type

Private Declare Function OpenFile Lib "kernel32" (ByVal lpFileName As String, lpReOpenBuff As OFSTRUCT, ByVal wStyle As Long) As Long

' Fin Api

Public Enum csE_ShortCutLocation
  csEDeskTop = 1
  csEStartUp
  csEPrograms
End Enum

Public Function CreateShortcut(ByVal Nombre As String, ByVal Command As String, ByVal Donde As csE_ShortCutLocation) As Boolean
  On Error Resume Next
  
  Dim lReturn         As Long
  Dim StartUpFolder   As String
  Dim DesktopFolder   As String
  Dim ProgramsFolder  As String
  Dim sFileLnk        As String
  'Dim vTarget         As CSIDL_FOLDERS
  
  Select Case Donde
    Case csEDeskTop
      'Add to Desktop
      DesktopFolder = GetEspecialFolders(sfidDESKTOP)
      sFileLnk = DesktopFolder & "\" & Nombre & ".lnk"
      'vTarget = CSIDL_DESKTOP
      
    Case csEPrograms
      'Add to Program Menu Group
      ProgramsFolder = GetEspecialFolders(sfidPROGRAMS)
      sFileLnk = ProgramsFolder & "\" & Nombre & ".lnk"
      'vTarget = CSIDL_PROGRAMS
    
    Case csEStartUp
      'Add to Startup Group
      'Note that on Windows NT, the shortcut will not actually appear
      'in the Startup group until your next reboot.
      StartUpFolder = GetEspecialFolders(sfidSTARTUP)
      sFileLnk = StartUpFolder & "\" & Nombre & ".lnk"
      'vTarget = CSIDL_STARTUP

  End Select
  
  CreateLink Command, sFileLnk, Nombre
  'CreateShortcutEx Command, Nombre, vTarget
  
  CreateShortcut = FileExists(sFileLnk)
End Function

Public Function GetEspecialFolders(ByVal nFolder As SpecialFolderIDs) As String
  Dim sPath   As String
  Dim strPath As String
  Dim lngPos  As Long
  Dim IDL     As Long
  
  ' Fill the item id list with the pointer of each folder item, rtns 0 on success
  If SHGetSpecialFolderLocation(0, nFolder, IDL) = NOERROR Then
      sPath = String$(255, 0)
      SHGetPathFromIDListA IDL, sPath

      lngPos = InStr(sPath, Chr(0))
      If lngPos > 0 Then
          strPath = Left$(sPath, lngPos - 1)
      End If
  End If
  
  GetEspecialFolders = strPath
End Function

Public Function FileExists(ByVal TestFile As String) As Boolean
  On Error GoTo ControlError
  
  Dim wStyle As Integer
  Dim Buffer As OFSTRUCT
  
  If OpenFile(TestFile, Buffer, OF_EXIST) < 0 Then Exit Function
  
  FileExists = True
  
  Exit Function
ControlError:
End Function



