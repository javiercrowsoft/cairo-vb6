Attribute VB_Name = "mWinGeneral"
Option Explicit
' =========================================================================
' mWinGeneral.bas
'
' vbAccelerator Toolbar control
' Copyright © 1998-2000 Steve McMahon (steve@vbaccelerator.com)
'
' Contains all the Windows declares required for the
' Rebar/Toolbar/CoolMenu control.
'
' -------------------------------------------------------------------------
' Visit vbAccelerator at http://vbaccelerator.com
' =========================================================================

Public Type RECT
    left As Long
    top As Long
    right As Long
    bottom As Long
End Type
Public Type POINTAPI
    x As Long
    y As Long
End Type
Public Type Msg
    hwnd As Long
    message As Long
    wParam As Long
    lParam As Long
    time As Long
    pt As POINTAPI
End Type
Public Type WINDOWPOS
   hwnd As Long
   hWndInsertAfter As Long
   x As Long
   y As Long
   cx As Long
   cy As Long
   flags As Long
End Type
Public Type NCCALCSIZE_PARAMS
   rgrc(0 To 2) As RECT
   lppos As Long 'WINDOWPOS
End Type
Public Type DRAWITEMSTRUCT
   CtlType As Long
   CtlID As Long
   itemID As Long
   itemAction As Long
   itemState As Long
   hwndItem As Long
   hdc As Long
   rcItem As RECT
   itemData As Long
End Type
Public Type MOUSEHOOKSTRUCT
    pt As POINTAPI
    hwnd As Long
    wHitTestCode As Long
    dwExtraInfo As Long
End Type

Public Declare Function CreateWindowEX Lib "user32" Alias "CreateWindowExA" (ByVal dwExStyle As Long, ByVal lpClassName As String, ByVal lpWindowName As String, ByVal dwStyle As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hWndParent As Long, ByVal hMenu As Long, ByVal hInstance As Long, lpParam As Any) As Long
Public Declare Function DestroyWindow Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Any) As Long
Public Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Public Declare Function GetClassLong Lib "user32" Alias "GetClassLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Public Declare Function ShowWindow Lib "user32" (ByVal hwnd As Long, ByVal nCmdShow As Long) As Long
Public Declare Function MoveWindow Lib "user32" (ByVal hwnd As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal bRepaint As Long) As Long
Public Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Public Declare Function getActiveWindow Lib "user32" Alias "GetActiveWindow" () As Long
Public Declare Function GetWindow Lib "user32" (ByVal hwnd As Long, ByVal wCmd As Long) As Long
Public Const GW_OWNER = 4
Public Const GW_HWNDNEXT = 2
Public Const GW_CHILD = 5

Public Declare Function UpdateWindow Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function InvalidateRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT, ByVal bErase As Long) As Long
Public Declare Function InvalidateRectAsNull Lib "user32" Alias "InvalidateRect" (ByVal hwnd As Long, lpRect As Any, ByVal bErase As Long) As Long
Public Declare Function LockWindowUpdate Lib "user32" (ByVal hwndLock As Long) As Long
Public Declare Function RedrawWindowAsNull Lib "user32" Alias "RedrawWindow" (ByVal hwnd As Long, lprcUpdate As Any, ByVal hrgnUpdate As Long, ByVal fuRedraw As Long) As Long
Public Const RDW_ALLCHILDREN = &H80
Public Const RDW_ERASE = &H4
Public Const RDW_ERASENOW = &H200
Public Const RDW_FRAME = &H400
Public Const RDW_INTERNALPAINT = &H2
Public Const RDW_INVALIDATE = &H1
Public Const RDW_NOCHILDREN = &H40
Public Const RDW_NOERASE = &H20
Public Const RDW_NOFRAME = &H800
Public Const RDW_NOINTERNALPAINT = &H10
Public Const RDW_UPDATENOW = &H100
Public Const RDW_VALIDATE = &H8

Public Declare Function GetParent Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function SetParent Lib "user32" (ByVal hWndCHild As Long, ByVal hWndNewParent As Long) As Long

Public Declare Function ScreenToClient Lib "user32" (ByVal hwnd As Long, lpPoint As POINTAPI) As Long
Public Declare Function ClientToScreen Lib "user32" (ByVal hwnd As Long, lpPoint As POINTAPI) As Long
Public Declare Function MapWindowPoints Lib "user32" (ByVal hwndFrom As Long, ByVal hWndTo As Long, lppt As Any, ByVal cPoints As Long) As Long
Public Declare Function WindowFromPoint Lib "user32" (ByVal xPoint As Long, ByVal yPoint As Long) As Long

Public Declare Function IsWindow Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function IsWindowVisible Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function IsZoomed Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function GetWindowRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
Public Declare Function GetClientRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
Public Declare Function InflateRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
Public Declare Function OffsetRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
Public Declare Function UnionRect Lib "user32" (lpDestRect As RECT, lpSrc1Rect As RECT, lpSrc2Rect As RECT) As Long
Public Declare Function FillRect Lib "user32" (ByVal hdc As Long, lpRect As RECT, ByVal hBrush As Long) As Long
Public Declare Function SetFocusAPI Lib "user32" Alias "SetFocus" (ByVal hwnd As Long) As Long

Public Declare Function GetProp Lib "user32" Alias "GetPropA" (ByVal hwnd As Long, ByVal lpString As String) As Long
Public Declare Function SetProp Lib "user32" Alias "SetPropA" (ByVal hwnd As Long, ByVal lpString As String, ByVal hData As Long) As Long
Public Declare Function RemoveProp Lib "user32" Alias "RemovePropA" (ByVal hwnd As Long, ByVal lpString As String) As Long

Public Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Public Declare Function SendMessageLong Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Declare Function PostMessage Lib "user32" Alias "PostMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long

Public Declare Function ReleaseCapture Lib "user32" () As Long

Declare Function GetSystemMetrics Lib "user32" (ByVal nIndex As Long) As Long

Public Const SM_CYSMSIZE = 31
Public Const SM_CXSMSIZE = 30
Public Const SM_CXSMICON = 49
Public Const SM_CYSMICON = 50

Public Type TPMPARAMS
    cbSize As Long
    rcExclude As RECT
End Type

Public Type MENUITEMINFO
    cbSize As Long
    fMask As Long
    fType As Long
    fState As Long
    wId As Long
    hSubMenu As Long
    hbmpChecked As Long
    hbmpUnchecked As Long
    dwItemData As Long
    dwTypeData As Long
    cch As Long
End Type

Public Declare Function GetMenu Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function SetMenu Lib "user32" (ByVal hwnd As Long, ByVal hMenu As Long) As Long
Public Declare Function GetSubMenu Lib "user32" (ByVal hMenu As Long, ByVal nPos As Long) As Long
Public Declare Function TrackPopupMenu Lib "user32" (ByVal hMenu As Long, ByVal wFlags As Long, ByVal x As Long, ByVal y As Long, ByVal nReserved As Long, ByVal hwnd As Long, lprc As Any) As Long
Public Declare Function TrackPopupMenuEx Lib "user32" (ByVal hMenu As Long, ByVal un As Long, ByVal n1 As Long, ByVal n2 As Long, ByVal hwnd As Long, lpTPMParams As TPMPARAMS) As Long
Public Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
Public Declare Function PtInRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
Public Declare Function GetMenuItemCount Lib "user32" (ByVal hMenu As Long) As Long
Public Declare Function GetMenuItemInfo Lib "user32" Alias "GetMenuItemInfoA" (ByVal hMenu As Long, ByVal un As Long, ByVal b As Boolean, lpMenuItemInfo As MENUITEMINFO) As Long
Public Declare Function InsertMenuItem Lib "user32" Alias "InsertMenuItemA" (ByVal hMenu As Long, ByVal un As Long, ByVal bool As Boolean, lpMenuItemInfo As MENUITEMINFO) As Long
Public Declare Function GetSystemMenu Lib "user32" (ByVal hwnd As Long, ByVal bRevert As Long) As Long
Public Declare Function RemoveMenu Lib "user32" (ByVal hMenu As Long, ByVal nPosition As Long, ByVal wFlags As Long) As Long
Public Const MF_STRING = &H0&
Public Const MF_POPUP = &H10&
Public Const MF_BYPOSITION = &H400&
Public Const MF_DISABLED = &H2&
Public Const MFS_GRAYED = &H3&
Public Const MFS_DISABLED = MFS_GRAYED
Public Const MIIM_STATE = &H1&
Public Const MIIM_ID = &H2&
Public Const MIIM_SUBMENU = &H4&
Public Const MIIM_CHECKMARKS = &H8&
Public Const MIIM_TYPE = &H10&
Public Const MIIM_DATA = &H20&
Public Const TPM_CENTERALIGN = &H4&
Public Const TPM_LEFTALIGN = &H0&
Public Const TPM_LEFTBUTTON = &H0&
Public Const TPM_RIGHTALIGN = &H8&
Public Const TPM_RIGHTBUTTON = &H2&
Public Const TPM_TOPALIGN = &H0
Public Const TPM_VCENTERALIGN = &H10
Public Const TPM_BOTTOMALIGN = &H20
Public Const TPM_HORIZONTAL = &H0             '/* Horz alignment matters more */
Public Const TPM_VERTICAL = &H40              '/* Vert alignment matters more */
Public Const TPM_NONOTIFY = &H80              '/* Don't send any notification msgs */
Public Const TPM_RETURNCMD = &H100

Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (pDest As Any, pSrc As Any, ByVal ByteLen As Long)

Public Type BITMAP
    bmType As Long
    bmWidth As Long
    bmHeight As Long
    bmWidthBytes As Long
    bmPlanes As Integer
    bmBitsPixel As Integer
    bmBits As Long
End Type
Public Declare Function GetObjectAPI Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long
Public Declare Function CreateDCAsNull Lib "gdi32" Alias "CreateDCA" (ByVal lpDriverName As String, lpDeviceName As Any, lpOutput As Any, lpInitData As Any) As Long
Public Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long
Public Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hdc As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Public Declare Function GetWindowDC Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Public Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Public Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
Public Declare Function GetDC Lib "user32" (ByVal hwnd As Long) As Long
Public Declare Function ReleaseDC Lib "user32" (ByVal hwnd As Long, ByVal hdc As Long) As Long
Public Declare Function CreateRectRgn Lib "gdi32" (ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
Public Declare Function LoadImage Lib "user32" Alias "LoadImageA" (ByVal hInst As Long, ByVal lpsz As String, ByVal un1 As Long, ByVal n1 As Long, ByVal n2 As Long, ByVal un2 As Long) As Long
Public Declare Function LoadImageLong Lib "user32" Alias "LoadImageA" (ByVal hInst As Long, ByVal lpsz As Long, ByVal un1 As Long, ByVal n1 As Long, ByVal n2 As Long, ByVal un2 As Long) As Long
Public Const CF_BITMAP = 2
Public Const LR_LOADMAP3DCOLORS = &H1000&
Public Const LR_LOADFROMFILE = &H10
Public Const LR_LOADTRANSPARENT = &H20
Public Const IMAGE_BITMAP = 0
Public Declare Function DrawIconEx Lib "user32" (ByVal hdc As Long, ByVal xLeft As Long, ByVal yTop As Long, ByVal hIcon As Long, ByVal cxWidth As Long, ByVal cyWidth As Long, ByVal istepIfAniCur As Long, ByVal hbrFlickerFreeDraw As Long, ByVal diFlags As Long) As Long
Public Const DI_MASK = &H1&
Public Const DI_IMAGE = &H2&
Public Const DI_NORMAL = &H3&
Public Const DI_COMPAT = &H4&
Public Const DI_DEFAULTSIZE = &H8&
Public Declare Function MoveToEx Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, lpPoint As POINTAPI) As Long
Public Declare Function LineTo Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long
Public Declare Function DrawFrameControl Lib "user32" (ByVal lHDC As Long, tR As RECT, ByVal eFlag As Long, ByVal eStyle As Long) As Long
Public Declare Function DrawEdge Lib "user32" (ByVal hdc As Long, qrc As RECT, ByVal edge As Long, ByVal grfFlags As Long) As Long
Public Declare Function DrawCaption Lib "user32" (ByVal hwnd As Long, ByVal hdc As Long, pcRect As RECT, ByVal un As Long) As Long
Public Declare Function CreatePen Lib "gdi32" (ByVal nPenStyle As Long, ByVal nWidth As Long, ByVal crColor As Long) As Long
Public Const PS_SOLID = 0
Public Declare Function SetTextColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
Public Const TRANSPARENT = 1
Public Const OPAQUE = 2
Public Declare Function SetBkMode Lib "gdi32" (ByVal hdc As Long, ByVal nBkMode As Long) As Long
Public Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
Public Declare Function GetSysColorBrush Lib "user32" (ByVal nIndex As Long) As Long
Public Declare Function OleTranslateColor Lib "oleaut32.dll" (ByVal lOleColor As Long, ByVal lHPalette As Long, lColorRef As Long) As Long
Public Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Public Declare Function DrawText Lib "user32" Alias "DrawTextA" (ByVal hdc As Long, ByVal lpStr As String, ByVal nCount As Long, lpRect As RECT, ByVal wFormat As Long) As Long
' General Win declares:
Public Declare Function GetSysColor Lib "user32" (ByVal nIndex As Long) As Long
' Sys colours:
Public Const COLOR_WINDOWFRAME = 6
Public Const COLOR_BTNFACE = 15
Public Const COLOR_BTNTEXT = 18
Public Const COLOR_INACTIVECAPTION = 3
Public Const COLOR_ACTIVEBORDER = 10
Public Const COLOR_ACTIVECAPTION = 2
Public Const COLOR_INACTIVEBORDER = 11
Public Const COLOR_GRADIENTACTIVECAPTION = 27
Public Const COLOR_GRADIENTINACTIVECAPTION = 28
Public Declare Function SetWindowTheme Lib "uxtheme.dll" (ByVal hwnd As Long, ByVal pszSubAppName As Long, ByVal pszSubIdList As Long) As Long

Public Declare Function SystemParametersInfo Lib "user32" Alias "SystemParametersInfoA" (ByVal uAction As Long, ByVal uParam As Long, ByRef lpvParam As Any, ByVal fuWinIni As Long) As Long
Public Const SPI_GETGRADIENTCAPTIONS = &H1008&

Public Declare Function GetAsyncKeyState Lib "user32" (ByVal vKey As Long) As Integer
Public Declare Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal hWnd1 As Long, ByVal hWnd2 As Long, ByVal lpsz1 As String, lpsz2 As Any) As Long
Public Declare Function GetClassName Lib "user32" Alias "GetClassNameA" (ByVal hwnd As Long, ByVal lpClassName As String, ByVal nMaxCount As Long) As Long

Public Const ICON_SMALL = 0
Public Const ICON_BIG = 1
Public Const WM_GETICON = &H7F&

Public Const ODT_BUTTON = 4

' Syscommand values:
Public Const SC_MOVE = &HF012&
Public Const SC_MINIMIZE = &HF020&
Public Const SC_CLOSE = &HF060&
Public Const SC_KEYMENU = &HF100&

'Window Styles:
Public Const WS_OVERLAPPED = &H0&
Public Const WS_MINIMIZE = &H20000000
Public Const WS_DISABLED = &H8000000
Public Const WS_MAXIMIZE = &H1000000
Public Const WS_CAPTION = &HC00000           '     /* WS_BORDER | WS_DLGFRAME  */
Public Const WS_VSCROLL = &H200000
Public Const WS_HSCROLL = &H100000
Public Const WS_SYSMENU = &H80000
Public Const WS_THICKFRAME = &H40000
Public Const WS_GROUP = &H20000
Public Const WS_TABSTOP = &H10000
Public Const WS_MINIMIZEBOX = &H20000
Public Const WS_MAXIMIZEBOX = &H10000

Public Const WS_POPUP = &H80000000
Public Const WS_CHILD = &H40000000
Public Const WS_VISIBLE = &H10000000
Public Const WS_CLIPCHILDREN = &H2000000
Public Const WS_CLIPSIBLINGS = &H4000000
Public Const WS_BORDER = &H800000
Public Const WS_DLGFRAME = &H400000

Public Const WS_EX_DLGMODALFRAME = &H1&
Public Const WS_EX_NOPARENTNOTIFY = &H4&
Public Const WS_EX_TOPMOST = &H8&
Public Const WS_EX_ACCEPTFILES = &H10&
Public Const WS_EX_TRANSPARENT = &H20&
Public Const WS_EX_MDICHILD = &H40&
Public Const WS_EX_TOOLWINDOW = &H80&
Public Const WS_EX_WINDOWEDGE = &H100&
Public Const WS_EX_CLIENTEDGE = &H200&
Public Const WS_EX_CONTEXTHELP = &H400&
Public Const WS_EX_RIGHT = &H1000&
Public Const WS_EX_LEFT = &H0&
Public Const WS_EX_RTLREADING = &H2000&
Public Const WS_EX_LTRREADING = &H0&
Public Const WS_EX_LEFTSCROLLBAR = &H4000&
Public Const WS_EX_RIGHTSCROLLBAR = &H0&
Public Const WS_EX_CONTROLPARENT = &H10000
Public Const WS_EX_STATICEDGE = &H20000
Public Const WS_EX_APPWINDOW = &H40000
Public Const WS_EX_OVERLAPPEDWINDOW = WS_EX_WINDOWEDGE Or WS_EX_CLIENTEDGE
Public Const WS_EX_PALETTEWINDOW = (WS_EX_WINDOWEDGE Or WS_EX_TOOLWINDOW Or WS_EX_TOPMOST)
Public Const WS_EX_NOACTIVATE = &H8000000

Public Const CW_USEDEFAULT = &H80000000

' Class long values:
Public Const GCL_HICON = (-14)
Public Const GCL_HICONSM = (-34)

' Messages:
Public Const WM_DESTROY = &H2
Public Const WM_CLOSE = &H10
Public Const WM_SIZE = &H5
Public Const WM_ACTIVATE = &H6
Public Const WM_SETFOCUS = &H7
Public Const WM_KILLFOCUS = &H8
Public Const WM_PAINT = &HF
Public Const WM_ERASEBKGND = &H14
Public Const WM_SHOWWINDOW = &H18
Public Const WM_ACTIVATEAPP = &H1C
Public Const WM_CANCELMODE = &H1F
Public Const WM_SETCURSOR = &H20
Public Const WM_GETMINMAXINFO = &H24
Public Const WM_DRAWITEM = &H2B
Public Const WM_WINDOWPOSCHANGING = &H46
Public Const WM_WINDOWPOSCHANGED = &H47
Public Const WM_NOTIFY = &H4E
Public Const WM_NCHITTEST = &H84
Public Const WM_STYLECHANGED = &H7D
Public Const WM_NCCALCSIZE = &H83
Public Const WM_NCPAINT = &H85
Public Const WM_NCACTIVATE = &H86
Public Const WM_NCLBUTTONDOWN = &HA1
Public Const WM_NCMBUTTONDOWN = &HA7
Public Const WM_NCRBUTTONDOWN = &HA4
Public Const WM_KEYDOWN = &H100
Public Const WM_KEYUP = &H101
Public Const WM_COMMAND = &H111
Public Const WM_SYSCOMMAND = &H112
Public Const WM_INITMENU = &H116
Public Const WM_INITMENUPOPUP = &H117
Public Const WM_MENUSELECT = &H11F
Public Const WM_MENUCHAR = &H120
Public Const WM_EXITSIZEMOVE = &H232
Public Const WM_MOUSEMOVE = &H200
Public Const WM_LBUTTONDOWN = &H201
Public Const WM_LBUTTONUP = &H202
Public Const WM_RBUTTONDOWN = &H204
Public Const WM_RBUTTONUP = &H205
Public Const WM_MBUTTONDOWN = &H207
Public Const WM_MBUTTONUP = &H208
Public Const WM_PARENTNOTIFY = &H210
Public Const WM_ENTERMENULOOP = &H211
Public Const WM_EXITMENULOOP = &H212
Public Const WM_MDIACTIVATE = &H222
Public Const WM_MDIRESTORE = &H223
Public Const WM_MDIMAXIMIZE = &H225
Public Const WM_MDIGETACTIVE = &H229
Public Const WM_MDISETMENU = &H230
Public Const WM_USER = &H400


' WM_NCHITTEST return values:
Public Const HTBORDER = 18
Public Const HTBOTTOM = 15
Public Const HTBOTTOMLEFT = 16
Public Const HTBOTTOMRIGHT = 17
Public Const HTCAPTION = 2
Public Const HTCLIENT = 1
Public Const HTERROR = (-2)
Public Const HTGROWBOX = 4
Public Const HTHSCROLL = 6
Public Const HTLEFT = 10
Public Const HTMAXBUTTON = 9
Public Const HTMENU = 5
Public Const HTMINBUTTON = 8
Public Const HTNOWHERE = 0
Public Const HTRIGHT = 11
Public Const HTSYSMENU = 3
Public Const HTTOP = 12
Public Const HTTOPLEFT = 13
Public Const HTTOPRIGHT = 14
Public Const HTTRANSPARENT = (-1)
Public Const HTVSCROLL = 7
Public Const HTREDUCE = HTMINBUTTON
Public Const HTSIZE = HTGROWBOX
Public Const HTSIZEFIRST = HTLEFT
Public Const HTSIZELAST = HTBOTTOMRIGHT
Public Const HTZOOM = HTMAXBUTTON

' WM_NCCALCSIZE return values;
Public Const WVR_ALIGNBOTTOM = &H40
Public Const WVR_ALIGNLEFT = &H20
Public Const WVR_ALIGNRIGHT = &H80
Public Const WVR_ALIGNTOP = &H10
Public Const WVR_HREDRAW = &H100
Public Const WVR_VALIDRECTS = &H400
Public Const WVR_VREDRAW = &H200
Public Const WVR_REDRAW = (WVR_HREDRAW Or WVR_VREDRAW)

' Window Long:
Public Const GWL_STYLE = (-16)
Public Const GWL_EXSTYLE = (-20)
Public Const GWL_USERDATA = (-21)
Public Const GWL_WNDPROC = -4
Public Const GWL_HWNDPARENT = (-8)

' WM_ACTIVATE wParam LoWords:
Public Const WA_INACTIVE = 0
Public Const WA_CLICKACTIVE = 2
Public Const WA_ACTIVE = 1

' Show window
Public Const SW_SHOW = 5
Public Const SW_HIDE = 0
Public Const SW_SHOWNORMAL = 1

' SetWIndowPos
Public Const HWND_TOPMOST = -1
Public Const HWND_DESKTOP = 0
Public Const SWP_NOSIZE = &H1
Public Const SWP_NOMOVE = &H2
Public Const SWP_NOREDRAW = &H8
Public Const SWP_SHOWWINDOW = &H40
Public Const SWP_FRAMECHANGED = &H20        '  The frame changed: send WM_NCCALCSIZE
Public Const SWP_DRAWFRAME = SWP_FRAMECHANGED
Public Const SWP_HIDEWINDOW = &H80
Public Const SWP_NOACTIVATE = &H10
Public Const SWP_NOCOPYBITS = &H100
Public Const SWP_NOOWNERZORDER = &H200      '  Don't do owner Z ordering
Public Const SWP_NOREPOSITION = SWP_NOOWNERZORDER
Public Const SWP_NOZORDER = &H4

' DrawFrameControl:
Public Const DFC_CAPTION = 1
Public Const DFC_MENU = 2
Public Const DFC_SCROLL = 3
Public Const DFC_BUTTON = 4
'#if(WINVER >= =&H0500)
Public Const DFC_POPUPMENU = 5
'#endif /* WINVER >= =&H0500 */

Public Const DFCS_CAPTIONCLOSE = &H0
Public Const DFCS_CAPTIONMIN = &H1
Public Const DFCS_CAPTIONMAX = &H2
Public Const DFCS_CAPTIONRESTORE = &H3
Public Const DFCS_CAPTIONHELP = &H4

Public Const DFCS_INACTIVE = &H100
Public Const DFCS_PUSHED = &H200
Public Const DFCS_CHECKED = &H400

' DrawEdge:
Public Const BDR_RAISEDOUTER = &H1
Public Const BDR_SUNKENOUTER = &H2
Public Const BDR_RAISEDINNER = &H4
Public Const BDR_SUNKENINNER = &H8

Public Const BDR_OUTER = &H3
Public Const BDR_INNER = &HC
Public Const BDR_RAISED = &H5
Public Const BDR_SUNKEN = &HA

Public Const EDGE_RAISED = (BDR_RAISEDOUTER Or BDR_RAISEDINNER)
Public Const EDGE_SUNKEN = (BDR_SUNKENOUTER Or BDR_SUNKENINNER)
Public Const EDGE_ETCHED = (BDR_SUNKENOUTER Or BDR_RAISEDINNER)
Public Const EDGE_BUMP = (BDR_RAISEDOUTER Or BDR_SUNKENINNER)

Public Const BF_LEFT = &H1
Public Const BF_TOP = &H2
Public Const BF_RIGHT = &H4
Public Const BF_BOTTOM = &H8

Public Const BF_TOPLEFT = (BF_TOP Or BF_LEFT)
Public Const BF_TOPRIGHT = (BF_TOP Or BF_RIGHT)
Public Const BF_BOTTOMLEFT = (BF_BOTTOM Or BF_LEFT)
Public Const BF_BOTTOMRIGHT = (BF_BOTTOM Or BF_RIGHT)
Public Const BF_RECT = (BF_LEFT Or BF_TOP Or BF_RIGHT Or BF_BOTTOM)

Public Const BF_MIDDLE = &H800         '/* Fill in the middle */
Public Const BF_SOFT = &H1000          '/* For softer buttons */
Public Const BF_ADJUST = &H2000        '/* Calculate the space left over */
Public Const BF_FLAT = &H4000          '/* For flat rather than 3D borders */
Public Const BF_MONO = &H8000&          '/* For monochrome borders */

' Button control:
Public Const BM_GETCHECK = &HF0&
Public Const BM_GETSTATE = &HF2&
Public Const BST_UNCHECKED = &H0&
Public Const BST_CHECKED = &H1&
Public Const BST_INDETERMINATE = &H2&
Public Const BST_PUSHED = &H4&
Public Const BST_FOCUS = &H8&

' flags for DrawCaption
Public Const DC_ACTIVE = &H1
Public Const DC_SMALLCAP = &H2
Public Const DC_ICON = &H4
Public Const DC_TEXT = &H8
Public Const DC_INBUTTON = &H10
'#if(WINVER >= 0x0500)
Public Const DC_GRADIENT = &H20
'#endif /* WINVER >= 0x0500 */

' Draw text
Public Const DT_LEFT = &H0
Public Const DT_CENTER = &H1
Public Const DT_VCENTER = &H4
Public Const DT_SINGLELINE = &H20
Public Const DT_BOTTOM = &H8

#Const DEBUGMSGBOX = 0
 
 
Public Declare Function VkKeyScanEx Lib "user32" _
    Alias "VkKeyScanExA" (ByVal ch As Byte, _
    ByVal dwhkl As Long) As Integer
Public Declare Function GetKeyboardLayoutList Lib "user32" _
    (ByVal nBuff As Long, lpList As Long) As Long
'Public Declare Function SystemParametersInfo Lib "user32" _
    Alias "SystemParametersInfoA" (ByVal uAction As Long, _
    ByVal uParam As Long, lpvParam As Any, ByVal fuWinIni As Long) As Long
Public Const SPI_GETDEFAULTINPUTLANG = 89


'<CSCM>
'--------------------------------------------------------------------------------
' Project    :       ABToolBar3
' Procedure  :       CharToKeyCode
' Created by :       Sergey Pitutin
' Machine    :       ATHLONXP
' Date-Time  :       19.01.2003-22:48:51
'
' Parameters :       ch
'                    iLang
'--------------------------------------------------------------------------------
'</CSCM>
Public Function CharToKeyCode(ch As String, _
    Optional iLang As Integer = &H409) As Integer
Static nLayouts As Long, Layouts() As Long
Dim i As Long, bChar As Byte, iKey As Integer, iLay As Long, DefLay As Long

If Len(ch) <> 1& Then Exit Function
bChar = Asc(ch)
If bChar >= 65 And bChar <= 122 Then 'between 'A' and 'z' - english
    CharToKeyCode = Asc(UCase$(ch))
    Exit Function
End If
SystemParametersInfo SPI_GETDEFAULTINPUTLANG, 0&, DefLay, 0&
If iLang = (DefLay And &HFFFF&) Then
' Specified language is on the default layout
    iKey = VkKeyScanEx(bChar, DefLay) And &HFF
    If iKey <> 255 Then
        CharToKeyCode = iKey
    End If
    Exit Function
End If
' Initialize Layouts array
If nLayouts = 0& Then
    nLayouts = GetKeyboardLayoutList(0&, ByVal 0&)
    ReDim Layouts(0& To nLayouts - 1&)
    GetKeyboardLayoutList nLayouts, Layouts(0&)
End If
' Search for layout with specified language
For i = 0& To nLayouts - 1&
    If iLang = (Layouts(i) And &HFFFF&) Then
        iKey = VkKeyScanEx(bChar, Layouts(i)) And &HFF
        If iKey <> 255 Then
            CharToKeyCode = iKey
        End If
        Exit Function
    End If
Next
' Not found - search char on default layout
iKey = VkKeyScanEx(bChar, DefLay) And &HFF
If (iKey <> 255) And (iKey <> 0) Then
    CharToKeyCode = iKey
    Exit Function
End If
' Not found - search char on any layout
For i = 0& To nLayouts - 1&
    iKey = VkKeyScanEx(bChar, Layouts(i)) And &HFF
    If (iKey <> 255) And (iKey <> 0) Then
        CharToKeyCode = iKey
        Exit Function
    End If
Next
End Function
 
Public Sub debugmsg(ByVal sMsg As String)
#If DEBUGMSGBOX = 1 Then
   MsgBox sMsg, vbInformation
#Else
   Debug.Print sMsg
#End If
End Sub

Public Property Get BlendColor( _
      ByVal oColorFrom As OLE_COLOR, _
      ByVal oColorTo As OLE_COLOR, _
      Optional ByVal alpha As Long = 128 _
   ) As Long
Dim lCFrom As Long
Dim lCTo As Long
   lCFrom = TranslateColor(oColorFrom)
   lCTo = TranslateColor(oColorTo)
Dim lSrcR As Long
Dim lSrcG As Long
Dim lSrcB As Long
Dim lDstR As Long
Dim lDstG As Long
Dim lDstB As Long
   lSrcR = lCFrom And &HFF
   lSrcG = (lCFrom And &HFF00&) \ &H100&
   lSrcB = (lCFrom And &HFF0000) \ &H10000
   lDstR = lCTo And &HFF
   lDstG = (lCTo And &HFF00&) \ &H100&
   lDstB = (lCTo And &HFF0000) \ &H10000
     
   
   BlendColor = RGB( _
      ((lSrcR * alpha) / 255) + ((lDstR * (255 - alpha)) / 255), _
      ((lSrcG * alpha) / 255) + ((lDstG * (255 - alpha)) / 255), _
      ((lSrcB * alpha) / 255) + ((lDstB * (255 - alpha)) / 255) _
      )
      
End Property

Public Property Get VSNetControlColor() As Long
   VSNetControlColor = BlendColor(vbButtonFace, VSNetBackgroundColor, 195)
End Property

Public Property Get VSNetBackgroundColor() As Long
   VSNetBackgroundColor = BlendColor(vbWindowBackground, vbButtonFace, 220)
End Property
Public Property Get VSNetCheckedColor() As Long
   VSNetCheckedColor = BlendColor(vbHighlight, vbWindowBackground, 30)
End Property
Public Property Get VSNetBorderColor() As Long
   VSNetBorderColor = TranslateColor(vbHighlight)
End Property
Public Property Get VSNetSelectionColor() As Long
   VSNetSelectionColor = BlendColor(vbHighlight, vbWindowBackground, 70)
End Property
Public Property Get VSNetPressedColor() As Long
   VSNetPressedColor = BlendColor(vbHighlight, VSNetSelectionColor, 70)
End Property
Public Function TranslateColor(ByVal oClr As OLE_COLOR, _
                        Optional hPal As Long = 0) As Long
    ' Convert Automation color to Windows color
    If OleTranslateColor(oClr, hPal, TranslateColor) Then
        TranslateColor = -1
    End If
End Function

