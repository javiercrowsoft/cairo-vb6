Attribute VB_Name = "mShortCut2"
Option Explicit

'Module Code
Public Enum CSIDL_FOLDERS
    CSIDL_DESKTOP = &H0 '// The Desktop - virtual folder
    CSIDL_PROGRAMS = 2 '// Program Files
    CSIDL_CONTROLS = 3 '// Control Panel - virtual folder
    CSIDL_PRINTERS = 4 '// Printers - virtual folder
    CSIDL_DOCUMENTS = 5 '// My Documents
    CSIDL_FAVORITES = 6 '// Favourites
    CSIDL_STARTUP = 7 '// Startup Folder
    CSIDL_RECENT = 8 '// Recent Documents
    CSIDL_SENDTO = 9 '// Send To Folder
    CSIDL_BITBUCKET = 10 '// Recycle Bin - virtual folder
    CSIDL_STARTMENU = 11 '// Start Menu
    CSIDL_DESKTOPFOLDER = 16 '// Desktop folder
    CSIDL_DRIVES = 17 '// My Computer - virtual folder
    CSIDL_NETWORK = 18 '// Network Neighbourhood - virtual folder
    CSIDL_NETHOOD = 19 '// NetHood Folder
    CSIDL_FONTS = 20 '// Fonts folder
    CSIDL_SHELLNEW = 21 '// ShellNew folder
End Enum
Private Const FO_MOVE = &H1
Private Const FO_RENAME = &H4
Private Const FOF_SILENT = &H4
Private Const FOF_NOCONFIRMATION = &H10
Private Const FOF_RENAMEONCOLLISION = &H8
Private Const MAX_PATH As Integer = 260
Private Const SHARD_PATH = &H2&
Private Const SHCNF_IDLIST = &H0
Private Const SHCNE_ALLEVENTS = &H7FFFFFFF
Private Type SHFILEOPSTRUCT
    hwnd  As Long
    wFunc As Long
    pFrom As String
    pTo    As String
    fFlags  As Integer
    fAborted      As Boolean
    hNameMaps As Long
    sProgress      As String
End Type
Private Type SHITEMID
    cb As Long
    abID As Byte
End Type
Private Type ITEMIDLIST
    mkid As SHITEMID
End Type
Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
Private Declare Function SHGetSpecialFolderLocation Lib "Shell32.dll" _
        (ByVal hwndOwner As Long, ByVal nFolder As Long, pidl As ITEMIDLIST) As Long
Private Declare Function SHGetSpecialFolderLocationD Lib "Shell32.dll" Alias _
        "SHGetSpecialFolderLocation" (ByVal hwndOwner As Long, ByVal nFolder As Long, _
        ByRef ppidl As Long) As Long
Private Declare Function SHAddToRecentDocs Lib "Shell32.dll" (ByVal dwflags As Long, _
        ByVal dwdata As String) As Long
Private Declare Function SHFileOperation Lib "Shell32.dll" Alias "SHFileOperationA" _
        (lpFileOp As SHFILEOPSTRUCT) As Long
Private Declare Function SHChangeNotify Lib "Shell32.dll" (ByVal wEventID As Long, _
        ByVal uFlags As Long, ByVal dwItem1 As Long, ByVal dwItem2 As Long) As Long
Private Declare Function SHGetPathFromIDList Lib "Shell32.dll" Alias "SHGetPathFromIDListA" _
        (ByVal pidl As Long, ByVal pszPath As String) As Long

Private Function fGetSpecialFolder(CSIDL As Long) As String
Dim sPath As String
Dim IDL As ITEMIDLIST
'
' Retrieve info about system folders such as the "Recent Documents" folder.
' Info is stored in the IDL structure.
'
fGetSpecialFolder = ""
If SHGetSpecialFolderLocation(fMain.hwnd, CSIDL, IDL) = 0 Then
    '
    ' Get the path from the ID list, and return the folder.
    '
    sPath = Space$(MAX_PATH)
    If SHGetPathFromIDList(ByVal IDL.mkid.cb, ByVal sPath) Then
        fGetSpecialFolder = Left$(sPath, InStr(sPath, vbNullChar) - 1) & "\"
    End If
End If
End Function
'Thanks to Mike J for pointing out some errors
'and improving this routine
'Module Code
Public Function CreateShortcutEx(ByRef txtFilePath As String, _
                                 ByRef txtName As String, _
                                 ByRef vTarget As CSIDL_FOLDERS)
    Dim I As Integer
    Dim lResult As Long
    Dim lpil As Long
    Dim sFilePath As String
    Dim sFileName As String
    Dim sRecentPath As String
    Dim sDesktopPath As String
    Dim sFilePathOld As String
    Dim sFilePathNew As String
    Dim sShortCutName As String
    Dim SMsg As String
    Dim SHFileOp As SHFILEOPSTRUCT
    ' Add a shortcut to any path virtual folder.
    '
    ' Get the .exe path and display name associated with the
    ' button that was right clicked (determined by ptbrRightButton).
    '
    On Error GoTo cmdCreateError
    Screen.MousePointer = vbHourglass
    sFilePath = Trim$(txtFilePath)
    sShortCutName = Trim$(txtName) & ".lnk"
    '
    ' Get the paths of the folders to add the shortcuts to.
    ' The folders are the Recent Files List and the Desktop.
    '
    sRecentPath = fGetSpecialFolder(CSIDL_RECENT)
    '
    ' NOTE: to create the shortcut in another folder, set sDesktopPath
    ' to that folder.
    sDesktopPath = fGetSpecialFolder(vTarget)
    SMsg = "Error retrieving folder location."
    If sRecentPath <> "" And sDesktopPath <> "" Then
        '
        ' Create a shortcut in the Recent Files list.
        '
        SMsg = "Error adding shortcut to the Recent File list."
        lResult = SHAddToRecentDocs(SHARD_PATH, sFilePath)
        Call Sleep(1500)
        If lResult Then

            ' Extract the .exe name from the path.
            I = 1
            sFileName = sFilePath
            Do While I
                I = InStr(1, sFileName, "\")
                If I Then sFileName = Mid$(sFileName, I + 1)
            Loop


            ' Move the shortcut from the Recent folder to the Desktop.
            ' Since the shortcut now resides in the Recent folder,
            ' modify the file name to include the Recent folder
            ' path. Also, append ".lnk" to the original filename.
            '
            sFilePath = sRecentPath & "\" & sFileName & ".lnk" & _
                            vbNullChar & vbNullChar

            With SHFileOp
                .wFunc = FO_MOVE
                .pFrom = sFilePath
                .pTo = sDesktopPath
                .fFlags = FOF_SILENT
            End With

            SMsg = "Error creating desktop shortcut."
            lResult = SHFileOperation(SHFileOp)
            Sleep (1500)
            If lResult = 0 Then

                '
                ' Rename the link.

                sFilePathOld = sDesktopPath & "\" & sFileName & ".lnk" & _
                    vbNullChar & vbNullChar
                sFilePathNew = sDesktopPath & "\" & sShortCutName & _
                    vbNullChar & vbNullChar
                With SHFileOp
                  .wFunc = FO_RENAME
                  .pFrom = sFilePathOld
                  .pTo = sFilePathNew
                  .fFlags = FOF_SILENT Or FOF_RENAMEONCOLLISION
                End With
                SMsg = "Error renaming desktop shortcut."
                lResult = SHFileOperation(SHFileOp) '123 = can't rename.
                SMsg = ""
                '
                ' Refresh the desktop to display the shortcut.
                '
                Call SHGetSpecialFolderLocationD(0, CSIDL_DESKTOP, lpil)

                Call SHChangeNotify(SHCNE_ALLEVENTS, SHCNF_IDLIST, lpil, 0)

            End If
        End If
    End If
    Screen.MousePointer = vbDefault
    Exit Function

cmdCreateError:
    MsgBox "Error creating desktop shortcut. " & SMsg, vbExclamation, "Create Shortcut"
End Function
