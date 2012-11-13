Attribute VB_Name = "mPublic"
Option Explicit

    Public Const SW_SHOWNORMAL = 1

    Private Const ERROR_PATH_NOT_FOUND = 3&
    Private Const ERROR_BAD_FORMAT = 11&
    Private Const SE_ERR_ACCESSDENIED = 5            '  access denied
    Private Const SE_ERR_ASSOCINCOMPLETE = 27
    Private Const SE_ERR_DDEBUSY = 30
    Private Const SE_ERR_DDEFAIL = 29
    Private Const SE_ERR_DDETIMEOUT = 28
    Private Const SE_ERR_DLLNOTFOUND = 32
    Private Const SE_ERR_FNF = 2                     '  file not found
    Private Const SE_ERR_NOASSOC = 31
    Private Const SE_ERR_OOM = 8                     '  out of memory
    Private Const SE_ERR_PNF = 3                     '  path not found
    Private Const SE_ERR_SHARE = 26

'Public Const CSIDL_DESKTOP = &H0 '// The Desktop - virtual folder
'Public Const CSIDL_PROGRAMS = 2 '// Program Files
'Public Const CSIDL_CONTROLS = 3 '// Control Panel - virtual folder
'Public Const CSIDL_PRINTERS = 4 '// Printers - virtual folder
'Public Const CSIDL_DOCUMENTS = 5 '// My Documents
'Public Const CSIDL_FAVORITES = 6 '// Favourites
'Public Const CSIDL_STARTUP = 7 '// Startup Folder
'Public Const CSIDL_RECENT = 8 '// Recent Documents
'Public Const CSIDL_SENDTO = 9 '// Send To Folder
'Public Const CSIDL_BITBUCKET = 10 '// Recycle Bin - virtual folder
'Public Const CSIDL_STARTMENU = 11 '// Start Menu
Public Const CSIDL_DESKTOPFOLDER = 16 '// Desktop folder
'Public Const CSIDL_DRIVES = 17 '// My Computer - virtual folder
'Public Const CSIDL_NETWORK = 18 '// Network Neighbourhood - virtual folder
'Public Const CSIDL_NETHOOD = 19 '// NetHood Folder
'Public Const CSIDL_FONTS = 20 '// Fonts folder
'Public Const CSIDL_SHELLNEW = 21 '// ShellNew folder

Declare Function SHGetSpecialFolderLocation Lib "shell32.dll" (ByVal hwndOwner As Long, ByVal nFolder As Long, pidl As ITEMIDLIST) As Long
Declare Function SHGetPathFromIDList Lib "shell32.dll" Alias "SHGetPathFromIDListA" (ByVal pidl As Long, ByVal pszPath As String) As Long

Private Declare Function ShellExecute2 Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long



Public Type SHITEMID
    cb As Long
    abID As Byte
End Type

Public Type ITEMIDLIST
    mkid As SHITEMID
End Type

Public Const MAX_PATH As Integer = 260

Public Function GetSpecialFolder(CSIDL As Long, ByVal hwnd As Long) As String
    Dim sPath As String
    Dim IDL As ITEMIDLIST
    '
    ' Retrieve info about system folders such as the "Recent Documents" folder.
    ' Info is stored in the IDL structure.
    '
    GetSpecialFolder = ""
    If SHGetSpecialFolderLocation(hwnd, CSIDL, IDL) = 0 Then
        '
        ' Get the path from the ID list, and return the folder.
        '
        sPath = Space$(MAX_PATH)
        If SHGetPathFromIDList(ByVal IDL.mkid.cb, ByVal sPath) Then
            GetSpecialFolder = Left$(sPath, InStr(sPath, vbNullChar) - 1) & ""
        End If
    End If
End Function

Public Sub Center(ByRef f As Form)
    With f
        .Move (Screen.Width - .Width) * 0.5, (Screen.Height - .Height) * 0.5
    End With
End Sub

Public Sub MngError(ByRef objErr As Object, ByVal functionName As String)
    MsgBox objErr.Description & vbCrLf & vbCrLf & "Funcion: " & functionName
End Sub

Public Sub EditFile(ByVal strFile As String, ByVal hwnd As Long)
  Dim Hresult As Long
  
  
  Hresult = ShellExecute2(hwnd, "open", strFile + Chr(0), 0, strFile + Chr(0), SW_SHOWNORMAL)
  
  Select Case Hresult
    Case ERROR_PATH_NOT_FOUND '= 3&
        MsgBox "La ruta de acceso no se encuentra"
    Case ERROR_BAD_FORMAT '= 11&
        MsgBox "Formato no reconocido"
    Case SE_ERR_ACCESSDENIED '= 5 '  access denied
        MsgBox "Error a intentar acceder al archivo. Acceso Denegado."
    Case SE_ERR_ASSOCINCOMPLETE '= 27
        MsgBox "Acceso Incompleto"
    Case SE_ERR_DDEBUSY '= 30
        
    Case SE_ERR_DDEFAIL '= 29
        MsgBox "Falla al intentar editar el archivo"
    Case SE_ERR_DDETIMEOUT '= 28
        
    Case SE_ERR_DLLNOTFOUND '= 32
        MsgBox "El archivo no se encuentra"
    Case SE_ERR_FNF '= 2                     '  file not found
        MsgBox "Archivo no encontrado"
    Case SE_ERR_NOASSOC '= 31
    Case SE_ERR_OOM '= 8                     '  out of memory
        MsgBox "Error de Memoria "
    Case SE_ERR_PNF '= 3                     '  path not found
        MsgBox "La ruta de acceso no se encuentra"
    Case SE_ERR_SHARE '= 26
        
  End Select
End Sub


