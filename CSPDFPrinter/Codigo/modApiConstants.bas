Attribute VB_Name = "modApiConstants"
Option Explicit

Public Const ERROR_SHARING_VIOLATION         As Long = &H20
Public Const ERROR_INSUFFICIENT_BUFFER       As Long = 122
Public Const ERROR_MORE_DATA                 As Long = 234
Public Const ERROR_NO_MORE_ITEMS             As Long = &H103
Public Const ERROR_KEY_NOT_FOUND             As Long = &H2
Public Const ERROR_ALREADY_EXISTS            As Long = 183&
Public Const ERROR_ACCESS_DENIED             As Long = 5&

Public Const GENERIC_EXECUTE                 As Long = &H20000000
Public Const GENERIC_WRITE                   As Long = &H40000000
Public Const GENERIC_READ                    As Long = &H80000000
Public Const INVALID_HANDLE_VALUE            As Long = -1
Public Const OPEN_EXISTING                   As Long = &H3


Public Const FORMAT_MESSAGE_FROM_SYSTEM      As Long = &H1000
Public Const FORMAT_MESSAGE_IGNORE_INSERTS   As Long = &H200
Public Const LANG_NEUTRAL                    As Long = &H0

Public Const FOF_MULTIDESTFILES              As Long = &H1
Public Const FOF_CONFIRMMOUSE                As Long = &H2
Public Const FOF_SILENT                      As Long = &H4
Public Const FOF_NOCONFIRMATION              As Long = &H10
Public Const FOF_ALLOWUNDO                   As Long = &H40
Public Const FOF_NOCONFIRMMKDIR              As Long = &H200

Public Const FO_MOVE                         As Long = &H1
Public Const FO_COPY                         As Long = &H2
Public Const FO_DELETE                       As Long = &H3
Public Const FO_RENAME                       As Long = &H4

Public Const STANDARD_RIGHTS_REQUIRED        As Long = &HF0000
Public Const PRINTER_ACCESS_ADMINISTER       As Long = &H4
Public Const PRINTER_ACCESS_USE              As Long = &H8
Public Const PRINTER_ALL_ACCESS              As Long = (STANDARD_RIGHTS_REQUIRED Or PRINTER_ACCESS_ADMINISTER Or PRINTER_ACCESS_USE)

Public Const PRINTER_ATTRIBUTE_DEFAULT       As Long = &H4
Public Const PRINTER_ATTRIBUTE_DIRECT        As Long = &H2
Public Const PRINTER_ATTRIBUTE_ENABLE_BIDI   As Long = &H800
Public Const PRINTER_ATTRIBUTE_LOCAL         As Long = &H40
Public Const PRINTER_ATTRIBUTE_NETWORK       As Long = &H10
Public Const PRINTER_ATTRIBUTE_QUEUED        As Long = &H1
Public Const PRINTER_ATTRIBUTE_SHARED        As Long = &H8
Public Const PRINTER_ATTRIBUTE_WORK_OFFLINE  As Long = &H400
Public Const PRINTER_ENUM_CONNECTIONS        As Long = &H4
Public Const PRINTER_ENUM_CONTAINER          As Long = &H8000&
Public Const PRINTER_ENUM_DEFAULT            As Long = &H1
Public Const PRINTER_ENUM_EXPAND             As Long = &H4000
Public Const PRINTER_ENUM_LOCAL              As Long = &H2
Public Const PRINTER_ENUM_ICON1              As Long = &H10000
Public Const PRINTER_ENUM_ICON2              As Long = &H20000
Public Const PRINTER_ENUM_ICON3              As Long = &H40000
Public Const PRINTER_ENUM_ICON4              As Long = &H80000
Public Const PRINTER_ENUM_ICON5              As Long = &H100000
Public Const PRINTER_ENUM_ICON6              As Long = &H200000
Public Const PRINTER_ENUM_ICON7              As Long = &H400000
Public Const PRINTER_ENUM_ICON8              As Long = &H800000
Public Const PRINTER_ENUM_NAME               As Long = &H8
Public Const PRINTER_ENUM_NETWORK            As Long = &H40
Public Const PRINTER_ENUM_REMOTE             As Long = &H10
Public Const PRINTER_ENUM_SHARED             As Long = &H20
Public Const PRINTER_LEVEL1                  As Long = &H1
Public Const PRINTER_LEVEL4                  As Long = &H4
Public Const SIZEOFMONITOR_INFO_1            As Long = 4
Public Const SIZEOFPORT_INFO_2               As Long = 20
Public Const SIZEOFPRINTER_INFO_1            As Long = 16
Public Const SIZEOFPRINTER_INFO_4            As Long = 12
Public Const PRINTER_LEVEL2                  As Long = &H2
Public Const SIZEOFPRINTER_INFO_2            As Long = 84

Public Const REG_OPTION_VOLATILE             As Long = &H1
Public Const REG_OPTION_NON_VOLATILE         As Long = &H0
Public Const SYNCHRONIZE                     As Long = &H100000
Public Const READ_CONTROL                    As Long = &H20000
Public Const STANDARD_RIGHTS_READ            As Long = (READ_CONTROL)
Public Const STANDARD_RIGHTS_WRITE           As Long = (READ_CONTROL)
Public Const STANDARD_RIGHTS_ALL             As Long = &H1F0000
Public Const KEY_QUERY_VALUE                 As Long = &H1
Public Const KEY_SET_VALUE                   As Long = &H2
Public Const KEY_CREATE_SUB_KEY              As Long = &H4
Public Const KEY_ENUMERATE_SUB_KEYS          As Long = &H8
Public Const KEY_NOTIFY                      As Long = &H10
Public Const KEY_CREATE_LINK                 As Long = &H20
Public Const KEY_READ                        As Long = ((STANDARD_RIGHTS_READ Or KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY) And (Not SYNCHRONIZE))
Public Const KEY_WRITE                       As Long = ((STANDARD_RIGHTS_WRITE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY) And (Not SYNCHRONIZE))
Public Const KEY_EXECUTE                     As Long = (KEY_READ)
Public Const KEY_ALL_ACCESS                  As Long = ((STANDARD_RIGHTS_ALL Or KEY_QUERY_VALUE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY Or KEY_CREATE_LINK) And (Not SYNCHRONIZE))

Public Const SMTO_NORMAL                     As Long = &H0
Public Const SMTO_BLOCK                      As Long = &H1
Public Const SMTO_ABORTIFHUNG                As Long = &H2
Public Const HWND_BROADCAST                  As Long = &HFFFF
Public Const WM_SETTINGCHANGE                As Long = &H1A

Public Const HH_DISPLAY_TOPIC                As Long = &H0

Public Const MAX_PATH                        As Long = 512

Public Const MF_BYCOMMAND                    As Long = &H0&
Public Const MF_BITMAP                       As Long = &H4&
Public Const MF_BYPOSITION                   As Long = &H400
Public Const MF_REMOVE                       As Long = &H1000

Public Const SW_HIDE                         As Long = 0
Public Const SW_SHOWMINIMIZED                As Long = 2
Public Const SW_MAXIMIZE                     As Long = 3
Public Const SW_MINIMIZE                     As Long = 6
Public Const SW_RESTORE                      As Long = 9
Public Const SW_SHOWMINNOACTIVE              As Long = 7
Public Const SW_SHOW                         As Long = 5

Public Const STARTF_USESHOWWINDOW            As Long = &H1
Public Const NORMAL_PRIORITY_CLASS           As Long = &H20&
Public Const STILL_ACTIVE                    As Long = &H103

Public Const ICU_ESCAPE                      As Long = &H80000000
Public Const ICU_USERNAME                    As Long = &H40000000

Public Const ICU_NO_ENCODE                   As Long = &H20000000
Public Const ICU_DECODE                      As Long = &H10000000
Public Const ICU_NO_META                     As Long = &H8000000
Public Const ICU_ENCODE_SPACES_ONLY          As Long = &H4000000
Public Const ICU_BROWSER_MODE                As Long = &H2000000

Public Const INTERNET_MAX_HOST_NAME_LENGTH   As Long = 256
Public Const INTERNET_MAX_USER_NAME_LENGTH   As Long = 128
Public Const INTERNET_MAX_PASSWORD_LENGTH    As Long = 128
Public Const INTERNET_MAX_PORT_NUMBER_LENGTH As Long = 5
Public Const INTERNET_MAX_PORT_NUMBER_VALUE  As Long = 65535
Public Const INTERNET_MAX_PATH_LENGTH        As Long = 2048
Public Const INTERNET_MAX_SCHEME_LENGTH      As Long = 32
Public Const INTERNET_MAX_URL_LENGTH         As Long = INTERNET_MAX_SCHEME_LENGTH + 3 + INTERNET_MAX_PATH_LENGTH

Public Const INTERNET_OPEN_TYPE_PRECONFIG    As Long = 0
Public Const INTERNET_SERVICE_HTTP           As Long = 3
Public Const INTERNET_FLAG_RELOAD            As Long = &H80000000
Public Const HTTP_QUERY_CONTENT_LENGTH       As Long = 5
Public Const HTTP_QUERY_STATUS_CODE          As Long = 19
Public Const HTTP_QUERY_FILE_URL             As Long = 904

Public Const SE_ERR_NOASSOC                  As Long = 31
Public Const SE_ERR_NOTFOUND                 As Long = 2

Public Const STD_INPUT_HANDLE                As Long = -10&
Public Const STD_OUTPUT_HANDLE               As Long = -11&
Public Const STD_ERROR_HANDLE                As Long = -12&

Public Const MAXIMUM_ALLOWED                 As Long = &H2000000

Public Const PROCESS_QUERY_INFORMATION       As Long = &H400
Public Const PROCESS_VM_READ                 As Long = &H10
Public Const TOKEN_ASSIGN_PRIMARY            As Long = &H1
Public Const TOKEN_DUPLICATE                 As Long = &H2
Public Const TOKEN_IMPERSONATE               As Long = &H4
Public Const TOKEN_QUERY                     As Long = &H8
Public Const TOKEN_QUERY_SOURCE              As Long = &H10
Public Const TOKEN_ADJUST_GROUPS             As Long = &H40
Public Const TOKEN_ADJUST_PRIVILEGES         As Long = &H20
Public Const TOKEN_ADJUST_SESSIONID          As Long = &H100
Public Const TOKEN_ADJUST_DEFAULT            As Long = &H80
Public Const TOKEN_ALL_ACCESS                As Long = (STANDARD_RIGHTS_REQUIRED Or TOKEN_ASSIGN_PRIMARY Or TOKEN_DUPLICATE Or TOKEN_IMPERSONATE Or TOKEN_QUERY Or TOKEN_QUERY_SOURCE Or TOKEN_ADJUST_PRIVILEGES Or TOKEN_ADJUST_GROUPS Or TOKEN_ADJUST_SESSIONID Or TOKEN_ADJUST_DEFAULT)
Public Const TOKEN_ALL_ACCESS_NT4            As Long = (STANDARD_RIGHTS_REQUIRED Or TOKEN_ASSIGN_PRIMARY Or TOKEN_DUPLICATE Or TOKEN_IMPERSONATE Or TOKEN_QUERY Or TOKEN_QUERY_SOURCE Or TOKEN_ADJUST_PRIVILEGES Or TOKEN_ADJUST_GROUPS Or TOKEN_ADJUST_DEFAULT)

Public Const CREATE_DEFAULT_ERROR_MODE       As Long = &H4000000

Public Const PI_NOUI                         As Long = 1
Public Const PI_APPLYPOLICY                  As Long = 2

Public Const WTS_CURRENT_SERVER_HANDLE       As Long = 0&

Public Const WAIT_FAILED                     As Long = &HFFFFFFFF
Public Const WAIT_OBJECT_0                   As Long = &H0

Public Const SM_CXDLGFRAME                   As Long = 7
Public Const SM_CYDLGFRAME                   As Long = 8
Public Const SM_CYCAPTION                    As Long = 4

Public Const WM_GETTEXT                      As Long = &HD
Public Const WM_GETTEXTLENGTH                As Long = &HE
Public Const WM_SETTEXT                      As Long = &HC

Public Const BIF_RETURNONLYFSDIRS            As Long = 1
Public Const BIF_BROWSEINCLUDEFILES          As Long = &H4000

Public Const DEFAULT_CHARSET                 As Long = 1
Public Const OUT_DEFAULT_PRECIS              As Long = 0
Public Const CLIP_DEFAULT_PRECIS             As Long = 0
Public Const DEFAULT_QUALITY                 As Long = 0
Public Const DEFAULT_PITCH                   As Long = 0
Public Const FF_ROMAN                        As Long = 16
Public Const CF_PRINTERFONTS                 As Long = &H2
Public Const CF_SCREENFONTS                  As Long = &H1
Public Const CF_BOTH                         As Long = (CF_SCREENFONTS Or CF_PRINTERFONTS)
Public Const CF_EFFECTS                      As Long = &H100&
Public Const CF_FORCEFONTEXIST               As Long = &H10000
Public Const CF_INITTOLOGFONTSTRUCT          As Long = &H40&
Public Const CF_LIMITSIZE                    As Long = &H2000&
Public Const REGULAR_FONTTYPE                As Long = &H400
Public Const LF_FACESIZE                     As Long = 32
Public Const CCHDEVICENAME                   As Long = 32
Public Const CCHFORMNAME                     As Long = 32
Public Const GMEM_MOVEABLE                   As Long = &H2
Public Const GMEM_ZEROINIT                   As Long = &H40
Public Const DM_DUPLEX                       As Long = &H1000&
Public Const DM_ORIENTATION                  As Long = &H1&
Public Const PD_PRINTSETUP                   As Long = &H40
Public Const PD_DISABLEPRINTTOFILE           As Long = &H80000

Public Const DT_PATH_ELLIPSIS                As Long = &H4000
Public Const DT_END_ELLIPSIS                 As Long = &H8000
Public Const DT_MODIFYSTRING                 As Long = &H10000
Public Const DT_SINGLELINE                   As Long = &H20

Public Const MOUSEEVENTF_MOVE                As Long = &H1
Public Const MOUSEEVENTF_LEFTDOWN            As Long = &H2
Public Const MOUSEEVENTF_LEFTUP              As Long = &H4
Public Const MOUSEEVENTF_RIGHTDOWN           As Long = &H8
Public Const MOUSEEVENTF_RIGHTUP             As Long = &H10
Public Const MOUSEEVENTF_MIDDLEDOWN          As Long = &H20
Public Const MOUSEEVENTF_MIDDLEUP            As Long = &H40
Public Const MOUSEEVENTF_ABSOLUTE            As Long = &H8000

Public Const SM_CXSCREEN                     As Long = 0
Public Const SM_CYSCREEN                     As Long = 1

Public Const LVM_FIRST                       As Long = &H1000
Public Const LVHT_ONITEM                     As Long = &HE
Public Const LVM_GETSUBITEMRECT              As Long = (LVM_FIRST + &H38)
Public Const LVM_SUBITEMHITTEST              As Long = (LVM_FIRST + &H39)
Public Const LVIR_LABEL                      As Long = &H2

Public Const ABM_GETSTATE                    As Long = &H4
Public Const ABS_ALWAYSONTOP                 As Long = &H2
Public Const ABM_GETTASKBARPOS               As Long = &H5

Public Const SHCNE_ASSOCCHANGED              As Long = &H8000000
Public Const SHCNF_IDLIST                    As Long = &H0&

Public Const ANYSIZE_ARRAY                   As Long = 1500

Public Const TokenUser                       As Long = 1
Public Const TokenGroups                     As Long = 2
Public Const TokenPrivileges                 As Long = 3
Public Const TokenOwner                      As Long = 4
Public Const TokenPrimaryGroup               As Long = 5
Public Const TokenDefaultDacl                As Long = 6
Public Const TokenSource                     As Long = 7
Public Const TokenType                       As Long = 8
Public Const TokenImpersonationLevel         As Long = 9
Public Const TokenStatistics                 As Long = 10
Public Const TokenRead                       As Long = &H20008

Public Const SECURITY_DIALUP_RID             As Long = &H1
Public Const SECURITY_NETWORK_RID            As Long = &H2
Public Const SECURITY_BATCH_RID              As Long = &H3
Public Const SECURITY_INTERACTIVE_RID        As Long = &H4
Public Const SECURITY_SERVICE_RID            As Long = &H6
Public Const SECURITY_ANONYMOUS_LOGON_RID    As Long = &H7
Public Const SECURITY_LOGON_IDS_RID          As Long = &H5
Public Const SECURITY_LOCAL_SYSTEM_RID       As Long = &H12
Public Const SECURITY_NT_NON_UNIQUE          As Long = &H15
Public Const SECURITY_BUILTIN_DOMAIN_RID     As Long = &H20

Public Const DOMAIN_ALIAS_RID_ADMINS         As Long = &H220
Public Const DOMAIN_ALIAS_RID_USERS          As Long = &H221
Public Const DOMAIN_ALIAS_RID_GUESTS         As Long = &H222
Public Const DOMAIN_ALIAS_RID_POWER_USERS    As Long = &H223
Public Const DOMAIN_ALIAS_RID_ACCOUNT_OPS    As Long = &H224
Public Const DOMAIN_ALIAS_RID_SYSTEM_OPS     As Long = &H225
Public Const DOMAIN_ALIAS_RID_PRINT_OPS      As Long = &H226
Public Const DOMAIN_ALIAS_RID_BACKUP_OPS     As Long = &H227
Public Const DOMAIN_ALIAS_RID_REPLICATOR     As Long = &H228

Public Const SECURITY_NT_AUTHORITY           As Long = &H5

Public Const THREAD_BASE_PRIORITY_IDLE       As Long = -15
Public Const THREAD_BASE_PRIORITY_LOWRT      As Long = 15
Public Const THREAD_BASE_PRIORITY_MIN        As Long = -2
Public Const THREAD_BASE_PRIORITY_MAX        As Long = 2
Public Const THREAD_PRIORITY_LOWEST          As Long = THREAD_BASE_PRIORITY_MIN
Public Const THREAD_PRIORITY_HIGHEST         As Long = THREAD_BASE_PRIORITY_MAX
Public Const THREAD_PRIORITY_BELOW_NORMAL    As Long = (THREAD_PRIORITY_LOWEST + 1)
Public Const THREAD_PRIORITY_ABOVE_NORMAL    As Long = (THREAD_PRIORITY_HIGHEST - 1)
Public Const THREAD_PRIORITY_IDLE            As Long = THREAD_BASE_PRIORITY_IDLE
Public Const THREAD_PRIORITY_NORMAL          As Long = 0
Public Const THREAD_PRIORITY_TIME_CRITICAL   As Long = THREAD_BASE_PRIORITY_LOWRT
Public Const HIGH_PRIORITY_CLASS             As Long = &H80
Public Const IDLE_PRIORITY_CLASS             As Long = &H40
Public Const REALTIME_PRIORITY_CLASS         As Long = &H100

Public Const SPI_GETICONTITLELOGFONT         As Long = 31
Public Const SPI_GETNONCLIENTMETRICS         As Long = 41
Public Const LOGPIXELSY                      As Long = 90

Public Const CB_SHOWDROPDOWN                 As Long = &H14F
Public Const CB_GETITEMHEIGHT                As Long = &H154

Public Const SHGFI_USEFILEATTRIBUTES         As Long = &H10

Public Const FILE_ATTRIBUTE_ARCHIVE          As Long = &H20
Public Const FILE_ATTRIBUTE_COMPRESSED       As Long = &H800
Public Const FILE_ATTRIBUTE_DIRECTORY        As Long = &H10
Public Const FILE_ATTRIBUTE_HIDDEN           As Long = &H2
Public Const FILE_ATTRIBUTE_NORMAL           As Long = &H80
Public Const FILE_ATTRIBUTE_READONLY         As Long = &H1
Public Const FILE_ATTRIBUTE_SYSTEM           As Long = &H4

Public Const WAIT_TIMEOUT                    As Long = &H102

Public Const CB_SETDROPPEDWIDTH              As Long = &H160

Public Const BF_LEFT                         As Long = &H1
Public Const BF_TOP                          As Long = &H2
Public Const BF_RIGHT                        As Long = &H4
Public Const BF_BOTTOM                       As Long = &H8
Public Const BF_RECT = (BF_LEFT Or BF_TOP Or BF_RIGHT Or BF_BOTTOM)

Public Const BDR_RAISEDOUTER                 As Long = &H1
Public Const BDR_SUNKENOUTER                 As Long = &H2
Public Const BDR_RAISEDINNER                 As Long = &H4
Public Const BDR_SUNKENINNER                 As Long = &H8
Public Const EDGE_RAISED = (BDR_RAISEDOUTER Or BDR_RAISEDINNER)
Public Const EDGE_SUNKEN = (BDR_SUNKENOUTER Or BDR_SUNKENINNER)
Public Const EDGE_ETCHED = (BDR_SUNKENOUTER Or BDR_RAISEDINNER)
Public Const EDGE_BUMP = (BDR_RAISEDOUTER Or BDR_SUNKENINNER)

Public Const SHGFI_DISPLAYNAME               As Long = &H200

'dwPlatformId
Public Const VER_PLATFORM_WIN32s             As Long = 0
Public Const VER_PLATFORM_WIN32_WINDOWS      As Long = 1
Public Const VER_PLATFORM_WIN32_NT           As Long = 2

'os product type values
Public Const VER_NT_WORKSTATION              As Long = &H1
Public Const VER_NT_DOMAIN_CONTROLLER        As Long = &H2
Public Const VER_NT_SERVER                   As Long = &H3

'product types
Public Const VER_SERVER_NT                   As Long = &H80000000
Public Const VER_WORKSTATION_NT              As Long = &H40000000

Public Const VER_SUITE_SMALLBUSINESS         As Long = &H1
Public Const VER_SUITE_ENTERPRISE            As Long = &H2
Public Const VER_SUITE_BACKOFFICE            As Long = &H4
Public Const VER_SUITE_COMMUNICATIONS        As Long = &H8
Public Const VER_SUITE_TERMINAL              As Long = &H10
Public Const VER_SUITE_SMALLBUSINESS_RESTRICTED As Long = &H20
Public Const VER_SUITE_EMBEDDEDNT            As Long = &H40
Public Const VER_SUITE_DATACENTER            As Long = &H80
Public Const VER_SUITE_SINGLEUSERTS          As Long = &H100
Public Const VER_SUITE_PERSONAL              As Long = &H200
Public Const VER_SUITE_BLADE                 As Long = &H400

Public Const OSV_LENGTH                      As Long = 148
Public Const OSVEX_LENGTH                    As Long = 156

Public Const CAPS1                           As Long = 94
Public Const C1_TRANSPARENT                  As Long = &H1
Public Const NEWTRANSPARENT                  As Long = 3
Public Const OBJ_BITMAP                      As Long = 7

Public Const SRCCOPY                         As Long = &HCC0020
Public Const SRCPAINT                        As Long = &HEE0086
Public Const SRCAND                          As Long = &H8800C6
Public Const NOTSRCCOPY                      As Long = &H330008

Public Const WM_USER                         As Long = &H400
Public Const ACM_OPEN                        As Long = (WM_USER + 100)
Public Const ACM_PLAY                        As Long = (WM_USER + 101)
Public Const ACM_STOP                        As Long = (WM_USER + 102)

Public Const RGN_OR                          As Long = 2
Public Const BI_RGB                          As Long = 0&
Public Const DIB_RGB_COLORS                  As Long = 0
Public Const LWA_COLORKEY                    As Long = &H1
Public Const GWL_EXSTYLE                     As Long = (-20)
Public Const GWL_USERDATA                    As Long = (-21)
Public Const GWL_HWNDPARENT                  As Long = (-8)
Public Const WS_EX_LAYERED                   As Long = &H80000
Public Const WS_EX_DLGMODALFRAME             As Long = &H1&

Public Const SEE_MASK_CLASSKEY               As Long = &H3
Public Const SEE_MASK_CLASSNAME              As Long = &H1
Public Const SEE_MASK_CONNECTNETDRV          As Long = &H80
Public Const SEE_MASK_DOENVSUBST             As Long = &H200
Public Const SEE_MASK_FLAG_DDEWAIT           As Long = &H100
Public Const SEE_MASK_FLAG_NO_UI             As Long = &H400
Public Const SEE_MASK_HOTKEY                 As Long = &H20
Public Const SEE_MASK_ICON                   As Long = &H10
Public Const SEE_MASK_IDLIST                 As Long = &H4
Public Const SEE_MASK_INVOKEIDLIST           As Long = &HC
Public Const SEE_MASK_NOCLOSEPROCESS         As Long = &H40

Public Const CP_ACP                          As Long = 0
Public Const NERR_Success                    As Long = 0
Public Const NERR_BASE                       As Long = 2100
Public Const NERR_InvalidComputer = (NERR_BASE + 251)
Public Const NERR_UseNotFound = (NERR_BASE + 150)

Public Const TH32CS_SNAPPROCESS              As Long = 2&

Public Const BITSPIXEL                       As Long = 12

Public Const VS_FFI_SIGNATURE                As Long = &HFEEF04BD
Public Const VS_FFI_STRUCVERSION             As Long = &H10000
Public Const VS_FFI_FILEFLAGSMASK            As Long = &H3F&

Public Const VS_FF_DEBUG                     As Long = &H1
Public Const VS_FF_PRERELEASE                As Long = &H2
Public Const VS_FF_PATCHED                   As Long = &H4
Public Const VS_FF_PRIVATEBUILD              As Long = &H8
Public Const VS_FF_INFOINFERRED              As Long = &H10
Public Const VS_FF_SPECIALBUILD              As Long = &H20

Public Const VOS_UNKNOWN                     As Long = &H0
Public Const VOS_DOS                         As Long = &H10000
Public Const VOS_OS216                       As Long = &H20000
Public Const VOS_OS232                       As Long = &H30000
Public Const VOS_NT                          As Long = &H40000
Public Const VOS__BASE                       As Long = &H0
Public Const VOS__WINDOWS16                  As Long = &H1
Public Const VOS__PM16                       As Long = &H2
Public Const VOS__PM32                       As Long = &H3
Public Const VOS__WINDOWS32                  As Long = &H4

Public Const VOS_DOS_WINDOWS16               As Long = &H10001
Public Const VOS_DOS_WINDOWS32               As Long = &H10004
Public Const VOS_OS216_PM16                  As Long = &H20002
Public Const VOS_OS232_PM32                  As Long = &H30003
Public Const VOS_NT_WINDOWS32                As Long = &H40004

Public Const VFT_UNKNOWN                     As Long = &H0
Public Const VFT_APP                         As Long = &H1
Public Const VFT_DLL                         As Long = &H2
Public Const VFT_DRV                         As Long = &H3
Public Const VFT_FONT                        As Long = &H4
Public Const VFT_VXD                         As Long = &H5
Public Const VFT_STATIC_LIB                  As Long = &H7

Public Const VFT2_UNKNOWN                    As Long = &H0
Public Const VFT2_DRV_PRINTER                As Long = &H1
Public Const VFT2_DRV_KEYBOARD               As Long = &H2
Public Const VFT2_DRV_LANGUAGE               As Long = &H3
Public Const VFT2_DRV_DISPLAY                As Long = &H4
Public Const VFT2_DRV_MOUSE                  As Long = &H5
Public Const VFT2_DRV_NETWORK                As Long = &H6
Public Const VFT2_DRV_SYSTEM                 As Long = &H7
Public Const VFT2_DRV_INSTALLABLE            As Long = &H8
Public Const VFT2_DRV_SOUND                  As Long = &H9
Public Const VFT2_DRV_COMM                   As Long = &HA

Public Const VFT2_FONT_RASTER                As Long = &H1
Public Const VFT2_FONT_VECTOR                As Long = &H2
Public Const VFT2_FONT_TRUETYPE              As Long = &H3

Public Const NIF_ICON                        As Long = &H2
Public Const NIF_MESSAGE                     As Long = &H1
Public Const NIF_TIP                         As Long = &H4
Public Const NIF_STATE                       As Long = &H8
Public Const NIF_INFO                        As Long = &H10

Public Const NIM_ADD                         As Long = &H0
Public Const NIM_MODIFY                      As Long = &H1
Public Const NIM_DELETE                      As Long = &H2
Public Const NIM_SETFOCUS                    As Long = &H3
Public Const NIM_SETVERSION                  As Long = &H4

Public Const NOTIFYICON_VERSION              As Long = 3

Public Const WM_MOUSEMOVE                    As Long = &H200
Public Const WM_LBUTTONDBLCLK                As Long = &H203
Public Const WM_LBUTTONDOWN                  As Long = &H201
Public Const WM_LBUTTONUP                    As Long = &H202
Public Const WM_RBUTTONDBLCLK                As Long = &H206
Public Const WM_RBUTTONDOWN                  As Long = &H204
Public Const WM_RBUTTONUP                    As Long = &H205

Public Const NIN_SELECT                      As Long = WM_USER
Public Const NINF_KEY                        As Long = &H1
Public Const NIN_KEYSELECT                   As Long = (NIN_SELECT Or NINF_KEY)
Public Const NIN_BALLOONSHOW                 As Long = (WM_USER + 2)
Public Const NIN_BALLOONHIDE                 As Long = (WM_USER + 3)
Public Const NIN_BALLOONTIMEOUT              As Long = (WM_USER + 4)
Public Const NIN_BALLOONUSERCLICK            As Long = (WM_USER + 5)

Public Const TIME_ZONE_ID_UNKNOWN            As Long = &H0&
Public Const TIME_ZONE_ID_STANDARD           As Long = &H1&
Public Const TIME_ZONE_ID_DAYLIGHT           As Long = &H2&

Public Const WSADescription_Len              As Long = 256
Public Const WSASYS_Status_Len               As Long = 128
Public Const WS_VERSION_REQD                 As Long = &H101
Public Const IP_SUCCESS                      As Long = 0
Public Const SOCKET_ERROR                    As Long = -1
Public Const AF_INET                         As Long = 2

Public Const ssfAPPDATA                      As Long = &H1A
Public Const CSIDL_FLAG_CREATE               As Long = &H8000&

Public Const WM_CHANGEUISTATE                As Long = &H127&

Public Const UIS_SET                         As Long = 1&
Public Const UIS_CLEAR                       As Long = 2&

Public Const UISF_HIDEACCEL                  As Integer = &H2

Public Const FW_DONTCARE                     As Long = 0
Public Const FW_THIN                         As Long = 100
Public Const FW_EXTRALIGHT                   As Long = 200
Public Const FW_LIGHT                        As Long = 300
Public Const FW_NORMAL                       As Long = 400
Public Const FW_MEDIUM                       As Long = 500
Public Const FW_SEMIBOLD                     As Long = 600
Public Const FW_BOLD                         As Long = 700
Public Const FW_EXTRABOLD                    As Long = 800
Public Const FW_HEAVY                        As Long = 900

Public Const CC_ANYCOLOR                     As Long = &H100
Public Const CC_ENABLEHOOK                   As Long = &H10
Public Const CC_ENABLETEMPLATE               As Long = &H20
Public Const CC_ENABLETEMPLATEHANDLE         As Long = &H40
Public Const CC_FULLOPEN                     As Long = &H2
Public Const CC_PREVENTFULLOPEN              As Long = &H4
Public Const CC_RGBINIT                      As Long = &H1
Public Const CC_SHOWHELP                     As Long = &H8
Public Const CC_SOLIDCOLOR                   As Long = &H80
