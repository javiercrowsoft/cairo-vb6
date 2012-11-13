Attribute VB_Name = "modApiTypesEnums"
Option Explicit

Public Type SHFILEOPSTRUCT
 hwnd As Long
 wFunc As Long
 pFrom As String
 pTo As String
 fFlags As Integer
 fAnyOperationAborted As Long
 hNameMaps As Long
 sProgress As String
End Type

Public Type PRINTER_DEFAULTS
 pDatatype As Long
 pDevMode As Long
 DesiredAccess As Long
End Type

Public Type PRINTER_INFO_2
 pServerName As Long
 pPrinterName As Long
 pShareName As Long
 pPortName As Long
 pDriverName As Long
 pComment As Long
 pLocation As Long
 pDevMode As Long
 pSepFile As Long
 pPrintProcessor As Long
 pDatatype As Long
 pParameters As Long
 pSecurityDescriptor As Long
 Attributes As Long
 Priority As Long
 DefaultPriority As Long
 StartTime As Long
 UntilTime As Long
 Status As Long
 cJobs As Long
 AveragePPM As Long
End Type

Public Type DRIVER_INFO_3
 cVersion As Long
 pName As String
 pEnvironment As String
 pDriverPath As String
 pDataFile As String
 pConfigFile As String
 pHelpFile As String
 pDependentFiles As String
 pMonitorName As String
 pDefaultDataType As String
End Type
    
Public Type MONITOR_INFO_2
 pName As String
 pEnvironment As String
 pDLLName As String
End Type

Public Type DRIVER_INFO_1
 pName As Long
End Type

Public Type MONITOR_INFO_1
 pName As Long
End Type

Public Type PORT_INFO_2
 pPortName    As Long
 pMonitorName As Long
 pDescription As Long
 fPortType    As Long
 Reserved     As Long
End Type

Public Enum PortTypes
 PORT_TYPE_WRITE = &H1
 PORT_TYPE_READ = &H2
 PORT_TYPE_REDIRECTED = &H4
 PORT_TYPE_NET_ATTACHED = &H8
End Enum

Public Type PRINTER_INFO_1
 Flags As Long
 prescription As Long
 Pane As Long
 Comment As Long
End Type

Public Type PRINTER_INFO_4
 pPrinterName As Long
 pServerName As Long
 Attributes As Long
End Type

Public Type ACL
 AclRevision As Byte
 Sbz1 As Byte
 AclSize As Integer
 AceCount As Integer
 Sbz2 As Integer
End Type

Public Type SECURITY_DESCRIPTOR
 Revision As Byte
 Sbz1 As Byte
 Control As Long
 Owner As Long
 Group As Long
 Sacl As ACL
 Dacl As ACL
End Type

Public Type SECURITY_ATTRIBUTES
 nLength As Long
 lpSecurityDescriptor As SECURITY_DESCRIPTOR
 bInheritHandle As Long
End Type

Public Type FILETIME
 dwLowDateTime As Long
 dwHighDateTime As Long
End Type

Public Enum DataType
 REG_SZ = &H1
 REG_EXPAND_SZ = &H2
 REG_BINARY = &H3
 REG_DWORD = &H4
 REG_MULTI_SZ = &H7
End Enum

Public Enum hkey
 HKEY_CLASSES_ROOT = &H80000000
 HKEY_CURRENT_USER = &H80000001
 HKEY_LOCAL_MACHINE = &H80000002
 HKEY_USERS = &H80000003
 HKEY_PERFORMANCE_DATA = &H80000004
 HKEY_CURRENT_CONFIG = &H80000005
 HKEY_DYN_DATA = &H80000006
End Enum

Public Type OSVERSIONINFO
 OSVSize       As Long
 dwVerMajor    As Long
 dwVerMinor    As Long
 dwBuildNumber As Long
 PlatformID    As Long
 szCSDVersion  As String * 128
End Type

Public Type OSVERSIONINFOEX
 OSVSize            As Long
 dwVerMajor         As Long
 dwVerMinor         As Long
 dwBuildNumber      As Long
 PlatformID         As Long
 szCSDVersion       As String * 128
 wServicePackMajor  As Integer
 wServicePackMinor  As Integer
 wSuiteMask         As Integer
 wProductType       As Byte
 wReserved          As Byte
End Type

Public Type STARTUPINFO
 cb As Long
 lpReserved As String
 lpDesktop As String
 lpTitle As String
 dwX As Long
 dwY As Long
 dwXSize As Long
 dwYSize As Long
 dwXCountChars As Long
 dwYCountChars As Long
 dwFillAttribute As Long
 dwFlags As Long
 wShowWindow As Integer
 cbReserved2 As Integer
 lpReserved2 As Long
 hStdInput As Long
 hStdOutput As Long
 hStdError As Long
End Type

Public Type PROCESS_INFORMATION
 hProcess As Long
 hThread As Long
 dwProcessId As Long
 dwThreadID As Long
End Type

Public Enum InetSchemes
 InternetSchemePartial = -2
 InternetSchemeUnknown = -1
 InternetSchemeDefault = 0
 InternetSchemeFtp
 InternetSchemeGopher
 InternetSchemeHttp
 InternetSchemeHttps
 InternetSchemeFile
 InternetSchemeNews
 InternetSchemeMailto
 InternetSchemeSocks
 InternetSchemeFirst = InternetSchemeFtp
 InternetSchemeLast = InternetSchemeSocks
End Enum

Public Type URL_COMPONENTS
 StructSize As Long
 Scheme As String
 SchemeLength As Long
 nScheme As InetSchemes
 HostName As String
 HostNameLength As Long
 nPort As Long
 UserName As String
 UserNameLength As Long
 Password As String
 PasswordLength As Long
 URLPath As String
 UrlPathLength As Long
 ExtraInfo As String
 ExtraInfoLength As Long
End Type
 
Private Enum eTOKEN_INFORMATION_CLASS
 TokenUser = 1
 TokenGroups = 2
 TokenPrivileges = 3
 TokenOwner = 4
 TokenPrimaryGroup = 5
 TokenDefaultDacl = 6
 TokenSource = 7
 TokenType = 8
 TokenImpersonationLevel = 9
 TokenStatistics = 10
 TokenRestrictedSids = 11
 TokenSessionId = 12
 TokenGroupsAndPrivileges = 13
 TokenSessionReference = 14
 TokenSandBoxInert = 15
 TokenAuditPolicy = 16
 TokenOrigin = 17
End Enum

Public Type PROFILEINFO
 dwSize As Long
 dwFlags As Long
 lpUserName As Long
 lpProfilePath As Long
 lpDefaultPath As Long
 lpServerName As Long
 lpPolicyPath As Long
 hProfile As Long
End Type

Public Type WTS_PROCESS_INFO
 SessionID As Long
 ProcessID As Long
 pProcessName As Long
 pUserSid As Long
End Type

Public Type SHELLEXECUTEINFO
 cbSize As Long
 fMask As Long
 hwnd As Long
 lpVerb As String
 lpFile As String
 lpParameters As String
 lpDirectory As String
 nShow As Long
 hInstApp As Long
 lpIDList As Long
 lpClass As String
 hkeyClass As Long
 dwHotKey As Long
 hIcon As Long
 hProcess As Long
End Type

Public Enum WaitConstants
 WCNone = 0
 WCInitialisiert = 1
 WCTermination = 2
End Enum

Public Enum ShowConstants
 wHidden = 0
 wNormal = 1
 wMax = 3
 wMin = 6
End Enum

Public Type Rect
 Left As Long
 Top As Long
 Right As Long
 Bottom As Long
End Type

Public Type BrowseInfo
 hWndOwner As Long
 pIDLRoot As Long
 pszDisplayName As Long
 lpszTitle As Long
 ulFlags As Long
 lpfnCallback As Long
 lParam As Long
 iImage As Long
End Type

Public Enum OpenSaveFlags
 OFN_ALLOWMULTISELECT = &H200
 OFN_CREATEPROMPT = &H2000
 OFN_ENABLEHOOK = &H20
 OFN_ENABLETEMPLATE = &H40
 OFN_ENABLETEMPLATEHANDLE = &H80
 OFN_EXPLORER = &H80000
 OFN_EXTENSIONDIFFERENT = &H400
 OFN_FILEMUSTEXIST = &H1000
 OFN_HIDEREADONLY = &H4
 OFN_LONGNAMES = &H200000
 OFN_NOCHANGEDIR = &H8
 OFN_NODEREFERENCELINKS = &H100000
 OFN_NOLONGNAMES = &H40000
 OFN_NONETWORKBUTTON = &H20000
 OFN_NOREADONLYRETURN = &H8000&
 OFN_NOTESTFILECREATE = &H10000
 OFN_NOVALIDATE = &H100
 OFN_OVERWRITEPROMPT = &H2
 OFN_PATHMUSTEXIST = &H800
 OFN_READONLY = &H1
 OFN_SHAREAWARE = &H4000
 OFN_SHAREFALLTHROUGH = 2
 OFN_SHAREWARN = 0
 OFN_SHARENOWARN = 1
 OFN_SHOWHELP = &H10
 OFS_MAXPATHNAME = 260
End Enum

Public Type POINTAPI
 x As Long
 Y As Long
End Type

Public Type OPENFILENAME
 nStructSize    As Long
 hWndOwner      As Long
 hInstance      As Long
 sFilter        As String
 sCustomFilter  As String
 nMaxCustFilter As Long
 nFilterIndex   As Long
 sFile          As String
 nMaxFile       As Long
 sFileTitle     As String
 nMaxTitle      As Long
 sInitialDir    As String
 sDialogTitle   As String
 Flags          As Long
 nFileOffset    As Integer
 nFileExtension As Integer
 sDefFileExt    As String
 nCustData      As Long
 fnHook         As Long
 sTemplateName  As String
End Type

Public Type PAGESETUPDLG
 lStructSize As Long
 hWndOwner As Long
 hDevMode As Long
 hDevNames As Long
 Flags As Long
 ptPaperSize As POINTAPI
 rtMinMargin As Rect
 rtMargin As Rect
 hInstance As Long
 lCustData As Long
 lpfnPageSetupHook As Long
 lpfnPagePaintHook As Long
 lpPageSetupTemplateName As String
 hPageSetupTemplate As Long
End Type

Public Type tCHOOSECOLOR
 lStructSize As Long
 hWndOwner As Long
 hInstance As Long
 rgbResult As Long
 lpCustColors As Long
 Flags As Long
 lCustData As Long
 lpfnHook As Long
 lpTemplateName As Long
End Type

Public Type LOGFONT
 lfHeight As Long
 lfWidth As Long
 lfEscapement As Long
 lfOrientation As Long
 lfWeight As Long
 lfItalic As Byte
 lfUnderline As Byte
 lfStrikeOut As Byte
 lfCharSet As Byte
 lfOutPrecision As Byte
 lfClipPrecision As Byte
 lfQuality As Byte
 lfPitchAndFamily As Byte
 lfFaceName(LF_FACESIZE) As Byte
' lfFaceName As String * LF_FACESIZE
End Type

Public Type tCHOOSEFONT
 lStructSize As Long
 hWndOwner As Long
 hdc As Long
 lpLogFont As Long
 iPointSize As Long
 Flags As Long
 rgbColors As Long
 lCustData As Long
 lpfnHook As Long
 lpTemplateName As String
 hInstance As Long
 lpszStyle As String
 nFontType As Integer
 MISSING_ALIGNMENT As Integer
 nSizeMin As Long
 nSizeMax As Long
End Type

Public Type PRINTDLG_TYPE
 lStructSize As Long
 hWndOwner As Long
 hDevMode As Long
 hDevNames As Long
 hdc As Long
 Flags As Long
 nFromPage As Integer
 nToPage As Integer
 nMinPage As Integer
 nMaxPage As Integer
 nCopies As Integer
 hInstance As Long
 lCustData As Long
 lpfnPrintHook As Long
 lpfnSetupHook As Long
 lpPrintTemplateName As String
 lpSetupTemplateName As String
 hPrintTemplate As Long
 hSetupTemplate As Long
End Type

Public Type DEVNAMES_TYPE
 wDriverOffset As Integer
 wDeviceOffset As Integer
 wOutputOffset As Integer
 wDefault As Integer
 extra As String * 100
End Type

Public Type DEVMODE_TYPE
 dmDeviceName As String * CCHDEVICENAME
 dmSpecVersion As Integer
 dmDriverVersion As Integer
 dmSize As Integer
 dmDriverExtra As Integer
 dmFields As Long
 dmOrientation As Integer
 dmPaperSize As Integer
 dmPaperLength As Integer
 dmPaperWidth As Integer
 dmScale As Integer
 dmCopies As Integer
 dmDefaultSource As Integer
 dmPrintQuality As Integer
 dmColor As Integer
 dmDuplex As Integer
 dmYResolution As Integer
 dmTTOption As Integer
 dmCollate As Integer
 dmFormName As String * CCHFORMNAME
 dmUnusedPadding As Integer
 dmBitsPerPel As Integer
 dmPelsWidth As Long
 dmPelsHeight As Long
 dmDisplayFlags As Long
 dmDisplayFrequency As Long
End Type

Public Type APPBARDATA
 cbSize As Long
 hwnd As Long
 uCallbackMessage As Long
 uEdge As Long
 rc As Rect
 lParam As Long
End Type

Public Type SID_IDENTIFIER_AUTHORITY
 Value(0 To 5) As Byte
End Type

Public Type NMLOGFONT
 lfHeight As Long
 lfWidth As Long
 lfEscapement As Long
 lfOrientation As Long
 lfWeight As Long
 lfItalic As Byte
 lfUnderline As Byte
 lfStrikeOut As Byte
 lfCharSet As Byte
 lfOutPrecision As Byte
 lfClipPrecision As Byte
 lfQuality As Byte
 lfPitchAndFamily As Byte
 lfFaceName(LF_FACESIZE - 4) As Byte
End Type

Public Type NONCLIENTMETRICS
 cbSize As Long
 iBorderWidth As Long
 iScrollWidth As Long
 iScrollHeight As Long
 iCaptionWidth As Long
 iCaptionHeight As Long
 lfCaptionFont As NMLOGFONT
 iSMCaptionWidth As Long
 iSMCaptionHeight As Long
 lfSMCaptionFont As NMLOGFONT
 iMenuWidth As Long
 iMenuHeight As Long
 lfMenuFont As NMLOGFONT
 lfStatusFont As NMLOGFONT
 lfMessageFont As NMLOGFONT
End Type

Public Enum IconSize
 Large = &H100&
 Small = &H101&
End Enum

Public Enum ShellAction
 Aopen = 0
 APrint = 1
 AExplore = 2
End Enum

Public Type IconType
 cbSize As Long
 picType As PictureTypeConstants
 hIcon As Long
End Type

Public Type CLSIdType
 ID(16) As Byte
End Type

Public Type ShellFileInfoType
 hIcon As Long
 iIcon As Long
 dwAttributes As Long
 szDisplayName As String * 260
 szTypeName As String * 80
End Type

Public Type WIN32_FIND_DATA
 dwFileAttributes As Long
 ftCreationTime As FILETIME
 ftLastAccessTime As FILETIME
 ftLastWriteTime As FILETIME
 nFileSizeHigh As Long
 nFileSizeLow As Long
 dwReserved0 As Long
 dwReserved1 As Long
 cFileName As String * MAX_PATH
 cAlternate As String * 14
End Type

Public Enum ShellNamespaceName
 DESKTOP_CLSID = 0
 INTERNET_CLSID = 1
 MYCOMPUTER_CLSID = 2
 MYFILES_CLSID = 3
 NETHOOD_CLSID = 4
 PRINTERS_CLSID = 5
 RECYCLEBIN_CLSID = 6
End Enum

Public Enum Systemfont
 Caption = 0
 SMCaption = 1
 Menu = 2
 Status = 3
 message = 4
 Icon = 5
End Enum

Public Type RGB_WINVER
 PlatformID      As Long
 VersionName     As String
 VersionNo       As String
 ServicePack     As String
 BuildNo         As String
End Type

Public Enum ResAnimateConstants
 ranOpen = 1
 ranPlay = 2
 ranSeek = 3
 ranStop = 4
 ranClose = 5
End Enum

Public Type BITMAPINFOHEADER
 biSize As Long
 biWidth As Long
 biHeight As Long
 biPlanes As Integer
 biBitCount As Integer
 biCompression As Long
 biSizeImage As Long
 biXPelsPerMeter As Long
 biYPelsPerMeter As Long
 biClrUsed As Long
 biClrImportant As Long
End Type

Public Type RGBQUAD
 rgbBlue As Byte
 rgbGreen As Byte
 rgbRed As Byte
 rgbReserved As Byte
End Type

Public Type BITMAPINFO
 bmiHeader As BITMAPINFOHEADER
 bmiColors As RGBQUAD
End Type

Public Enum tProcessPriority
 RealTime = REALTIME_PRIORITY_CLASS
 High = HIGH_PRIORITY_CLASS
 Normal = NORMAL_PRIORITY_CLASS
 Idle = IDLE_PRIORITY_CLASS
End Enum

Public Type USER_INFO_3
 usri3_name As Long
 usri3_password As Long
 usri3_password_age As Long
 usri3_priv As Long
 usri3_home_dir As Long
 usri3_comment As Long
 usri3_flags As Long
 usri3_script_path As Long
 usri3_auth_flags As Long
 usri3_full_name As Long
 usri3_usr_comment As Long
 usri3_parms As Long
 usri3_workstations As Long
 usri3_last_logon As Long
 usri3_last_logoff As Long
 usri3_acct_expires As Long
 usri3_max_storage As Long
 usri3_units_per_week As Long
 usri3_logon_hours As Byte
 usri3_bad_pw_count As Long
 usri3_num_logons As Long
 usri3_logon_server As String
 usri3_country_code As Long
 usri3_code_page As Long
 usri3_user_id As Long
 usri3_primary_group_id As Long
 usri3_profile As Long
 usri3_home_dir_drive As Long
 usri3_password_expired As Long
End Type

Public Type PROCESSENTRY32
 dwSize As Long
 cntUsage As Long
 th32ProcessID As Long
 th32DefaultHeapID As Long
 th32ModuleID As Long
 cntThreads As Long
 th32ParentProcessID As Long
 pcPriClassBase As Long
 dwFlags As Long
 szexeFile As String * MAX_PATH
End Type

Public Type SID_AND_ATTRIBUTES
 Sid As Long
 Attributes As Long
End Type

Public Type TOKEN_GROUPS
 GroupCount As Long
 Groups(ANYSIZE_ARRAY) As SID_AND_ATTRIBUTES
End Type

Public Type TOKEN_USER
 User As SID_AND_ATTRIBUTES
End Type

Public Type VS_FIXEDFILEINFO
 dwSignature As Long
 dwStrucVersionl As Integer
 dwStrucVersionh As Integer
 dwFileVersionMSl As Integer
 dwFileVersionMSh As Integer
 dwFileVersionLSl As Integer
 dwFileVersionLSh As Integer
 dwProductVersionMSl As Integer
 dwProductVersionMSh As Integer
 dwProductVersionLSl As Integer
 dwProductVersionLSh As Integer
 dwFileFlagsMask As Long
 dwFileFlags As Long
 dwFileOS As Long
 dwFileType As Long
 dwFileSubtype As Long
 dwFileDateMS As Long
 dwFileDateLS As Long
End Type

Public Type NOTIFYICONDATAA
 cbSize As Long
 hwnd As Long
 uID As Long
 uFlags As Long
 uCallbackMessage As Long
 hIcon As Long
 szTip As String * 128
 dwState As Long
 dwStateMask As Long
 szInfo As String * 256
 uTimeOutOrVersion As Long
 szInfoTitle As String * 64
 dwInfoFlags As Long
 guidItem As Long
End Type

Public Type NOTIFYICONDATAW
 cbSize As Long
 hwnd As Long
 uID As Long
 uFlags As Long
 uCallbackMessage As Long
 hIcon As Long
 szTip(0 To 255) As Byte
 dwState As Long
 dwStateMask As Long
 szInfo(0 To 511) As Byte
 uTimeOutOrVersion As Long
 szInfoTitle(0 To 127) As Byte
 dwInfoFlags As Long
 guidItem As Long
End Type

Public Type SYSTEMTIME
 wYear As Integer
 wMonth As Integer
 wDayOfWeek As Integer
 wDay As Integer
 wHour As Integer
 wMinute As Integer
 wSecond As Integer
 wMilliseconds As Integer
End Type

Public Type TIME_ZONE_INFORMATION
 Bias As Long
 StandardName(1 To 64) As Byte
 StandardDate As SYSTEMTIME
 StandardBias As Long
 DaylightName(1 To 64) As Byte
 DaylightDate As SYSTEMTIME
 DaylightBias As Long
End Type

Public Type WSADATA
 wVersion As Integer
 wHighVersion As Integer
 szDescription(0 To WSADescription_Len) As Byte
 szSystemStatus(0 To WSASYS_Status_Len) As Byte
 imaxsockets As Integer
 imaxudp As Integer
 lpszvenderinfo As Long
End Type

Public Enum SHGFP_TYPE
 SHGFP_TYPE_CURRENT = 0
 SHGFP_TYPE_DEFAULT = 1
End Enum
