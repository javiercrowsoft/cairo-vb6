Attribute VB_Name = "mAPI"
'==========================================================
'           Copyright Information
'==========================================================
'Program Name: Mewsoft Editawy
'Program Author   : Elsheshtawy, A. A.
'Home Page        : http://www.mewsoft.com
'Copyrights © 2006 Mewsoft Corporation. All rights reserved.
'==========================================================
'==========================================================
Option Explicit

'http://scintilla.sourceforge.net/ScintillaDoc.html
'----------------------------------------------------------

'----------------------------------------------------------

Public Const WM_NULL = &H0
Public Const WM_CREATE = &H1
Public Const WM_DESTROY = &H2
Public Const WM_MOVE = &H3
Public Const WM_SIZE = &H5

Public Const WM_CHAR = &H102

Public Const WM_SETFOCUS = &H7
Public Const WM_KILLFOCUS = &H8
Public Const WM_ENABLE = &HA
Public Const WM_SETREDRAW = &HB
Public Const WM_SETTEXT = &HC
Public Const WM_GETTEXT = &HD
Public Const WM_GETTEXTLENGTH = &HE
Public Const WM_PAINT = &HF
Public Const WM_CLOSE = &H10
Public Const WM_QUERYENDSESSION = &H11
Public Const WM_QUIT = &H12
Public Const WM_QUERYOPEN = &H13
Public Const WM_ERASEBKGND = &H14
Public Const WM_SYSCOLORCHANGE = &H15
Public Const WM_ENDSESSION = &H16
Public Const WM_SHOWWINDOW = &H18
Public Const WM_WININICHANGE = &H1A

Public Const WM_NOTIFY = &H4E
Public Const WM_COMMAND = &H111
Public Const WM_ACTIVATE = &H6

Public Const WM_PARENTNOTIFY = &H210

' Window Styles
Public Const WS_OVERLAPPED = &H0
Public Const WS_POPUP = &H80000000
Public Const WS_CHILD = &H40000000
Public Const WS_MINIMIZE = &H20000000
Public Const WS_VISIBLE = &H10000000
Public Const WS_DISABLED = &H8000000
Public Const WS_CLIPSIBLINGS = &H4000000
Public Const WS_CLIPCHILDREN = &H2000000
Public Const WS_MAXIMIZE = &H1000000
Public Const WS_CAPTION = &HC00000    ' WS_BORDER | WS_DLGFRAME
Public Const WS_BORDER = &H800000
Public Const WS_DLGFRAME = &H400000
Public Const WS_VSCROLL = &H200000
Public Const WS_HSCROLL = &H100000
Public Const WS_SYSMENU = &H80000
Public Const WS_THICKFRAME = &H40000
Public Const WS_GROUP = &H20000
Public Const WS_TABSTOP = &H10000
Public Const WS_MINIMIZEBOX = &H20000
Public Const WS_MAXIMIZEBOX = &H10000
Public Const WM_CONTEXTMENU = &H7B

'Structures that contain the information of the message of Scintilla
Public Type NMHDR
    hwndFrom As Long
    idFrom As Long
    code As Long
End Type

Public Type SCNotification
    NotifyHeader As NMHDR
    Position As Long
    ch As Long
    Modifiers As Long
    modificationType As Long
    Text As Long
    length As Long
    linesAdded As Long
    Message As Long
    wParam As Long
    lParam As Long
    Line As Long
    foldLevelNow As Long
    foldLevelPrev As Long
    Margin As Long
    listType As Long
    X As Long
    Y As Long
End Type

' Types for search and text fragment recovery
Public Type CharacterRange
    cpMin As Long
    cpMax As Long
End Type

Public Type TextRange
    chrg As CharacterRange
    lpstrText As String
End Type

Type TextToFind
    chrg As CharacterRange
    lpstrText As String
    chrgText As CharacterRange
End Type

Public Type CBTACTIVATESTRUCT
    fMouse As Long
    hWndActive As Long
End Type

Public Type RECT
   Left As Long
   Top As Long
   Right As Long
   Bottom As Long
End Type

Public Type POINTAPI
    X As Long
    Y As Long
End Type

Public OldWindowProc As Long
Public Const GWL_WNDPROC = (-4)

'-------------------COLORS-------------------------------------------
Public Const BLACK = &H0
Public Const WHITE = &HFFFFFF
Public Const BLUE = &HC00000
Public Const RED = &HFF&
Public Const GREEN = &HC000&

Public Const WS_EX_CLIENTEDGE = &H200
Public Const GMEM_MOVEABLE = &H2
Public Const GMEM_ZEROINIT = &H40
Public Const HWND_TOPMOST = -1
Public Const HWND_NOTOPMOST = -2
Public Const SWP_NOMOVE = &H2
Public Const SWP_NOSIZE = &H1

Public Const WM_MOUSEMOVE = &H200
Public Const WM_LBUTTONDOWN = &H201
Public Const WM_LBUTTONUP = &H202
Public Const WM_LBUTTONDBLCLK = &H203
Public Const WM_RBUTTONDOWN = &H204
Public Const WM_RBUTTONUP = &H205
Public Const WM_RBUTTONDBLCLK = &H206
Public Const WM_MBUTTONDOWN = &H207
Public Const WM_MBUTTONUP = &H208
Public Const WM_MBUTTONDBLCLK = &H209
Public Const WM_MOUSEWHEEL = &H20A
Public Const WM_KEYDOWN = &H100
Public Const WM_KEYUP = &H101
Public Const WH_JOURNALRECORD = 0

Public Const MK_LBUTTON = &H1&
Public Const MK_RBUTTON = &H2&
Public Const MK_SHIFT = &H4&
Public Const MK_CONTROL = &H8&
Public Const MK_MBUTTON = &H10&

Public Declare Function CreateWindowEx Lib "user32" Alias "CreateWindowExA" (ByVal dwExStyle As Long, ByVal lpClassName As String, ByVal lpWindowName As String, ByVal dwStyle As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hWndParent As Long, ByVal hMenu As Long, ByVal hInstance As Long, lpParam As Any) As Long
Public Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Public Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
Public Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal m As Long, ByVal Left As Long, ByVal Top As Long, ByVal Width As Long, ByVal Height As Long, ByVal flags As Long) As Long

Public Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Declare Function SendMessageString Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Any) As Long
Public Declare Function SendMessageStrings Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As String, ByVal lParam As String) As Long
Public Declare Function SendMessageAny Lib "user32.dll" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Any, ByRef lParam As Any) As Long
Public Declare Function SendMessageStruct Lib "user32.dll" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
     
Public Declare Function LoadLibrary Lib "kernel32" Alias "LoadLibraryA" (ByVal lpLibFileName As String) As Integer
Public Declare Function FreeLibrary Lib "kernel32" (ByVal hLibModule As Long) As Long

Public Declare Sub CopyMemory Lib "kernel32.dll" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal length As Long)
Public Declare Function SetFocusAPI Lib "user32" Alias "SetFocus" (ByVal hwnd As Long) As Long
Public Declare Function ShellExecute& Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long)

Public Declare Function SetWindowsHookEx Lib "user32" Alias "SetWindowsHookExA" (ByVal idHook As Long, ByVal lpfn As Long, ByVal hmod As Long, ByVal dwThreadId As Long) As Long
Public Declare Function CallNextHookEx Lib "user32" (ByVal hHook As Long, ByVal nCode As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Declare Function UnhookWindowsHookEx Lib "user32" (ByVal hHook As Long) As Long
Public Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long

Public Declare Function GetAsyncKeyState Lib "user32" (ByVal vKey As Long) As Integer
Public Declare Function GetKeyboardState Lib "user32" (pbKeyState As Byte) As Long

Public Const WM_USER As Long = &H400
Public Const EM_FORMATRANGE As Long = WM_USER + 57
Public Const EM_SETTARGETDEVICE As Long = WM_USER + 72

Public Const LOCALE_USER_DEFAULT As Long = &H400
Public Const LOCALE_IMEASURE = &HD          '  0 = metric, 1 = US

'Device Parameters for GetDeviceCaps()
Public Const DRIVERVERSION = 0      'Device driver version                    */
Public Const TECHNOLOGY = 2         'Device classification                    */
Public Const HORZSIZE = 4           'Horizontal size in millimeters
Public Const VERTSIZE = 6           'Vertical size in millimeters
Public Const HORZRES = 8            'Horizontal width in pixels
Public Const VERTRES = 10           'Vertical width in pixels
Public Const BITSPIXEL = 12         'Number of bits per pixel                 */
Public Const PLANES = 14            'Number of planes                         */
Public Const NUMBRUSHES = 16        'Number of brushes the device has         */
Public Const NUMPENS = 18           'Number of pens the device has            */
Public Const NUMMARKERS = 20        'Number of markers the device has         */
Public Const NUMFONTS = 22          'Number of fonts the device has           */
Public Const NUMCOLORS = 24         'Number of colors the device supports     */
Public Const PDEVICESIZE = 26       'Size required for device descriptor      */
Public Const CURVECAPS = 28         'Curve capabilities                       */
Public Const LINECAPS = 30          'Line capabilities                        */
Public Const POLYGONALCAPS = 32     'Polygonal capabilities                   */
Public Const TEXTCAPS = 34          'Text capabilities                        */
Public Const CLIPCAPS = 36          'Clipping capabilities                    */
Public Const RASTERCAPS = 38        'Bitblt capabilities                      */
Public Const ASPECTX = 40           'Length of the X leg                      */
Public Const ASPECTY = 42           'Length of the Y leg                      */
Public Const ASPECTXY = 44          'Length of the hypotenuse                 */

Public Const LOGPIXELSX = 88        '  Logical pixels/inch in X
Public Const LOGPIXELSY = 90        '  Logical pixels/inch in Y

Public Const SIZEPALETTE = 104      'Number of entries in physical palette    */
Public Const NUMRESERVED = 106      'Number of reserved entries in palette    */
Public Const COLORRES = 108         'Actual color resolution                  */

'Printing related DeviceCaps. These replace the appropriate Escapes
Public Const PHYSICALWIDTH As Long = 110    'Physical Width in device units
Public Const PHYSICALHEIGHT As Long = 111   'Physical Height in device units
Public Const PHYSICALOFFSETX As Long = 112  'Physical Printable Area x margin
Public Const PHYSICALOFFSETY As Long = 113  'Physical Printable Area y margin
Public Const SCALINGFACTORX As Long = 114   'Scaling factor x                         */
Public Const SCALINGFACTORY As Long = 115   'Scaling factor y                         */

Public Declare Function GetLocaleInfo Lib "kernel32" Alias "GetLocaleInfoA" (ByVal Locale As Long, ByVal LCType As Long, ByVal lpLCData As String, ByVal cchData As Long) As Long
Public Declare Function MulDiv Lib "kernel32" (ByVal nNumber As Long, ByVal nNumerator As Long, ByVal nDenominator As Long) As Long
Public Declare Function DPtoLP Lib "gdi32" (ByVal hdc As Long, lpPoint As Any, ByVal nCount As Long) As Long
Public Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal nIndex As Long) As Long
Public Declare Function CreateDC Lib "gdi32" Alias "CreateDCA" (ByVal lpDriverName As String, ByVal lpDeviceName As Any, ByVal lpOutput As Any, ByVal lpInitData As Any) As Long

Public Type PageSetupDlg
    lStructSize As Long
    hWndOwner As Long
    hDevMode As Long
    hDevNames As Long
    flags As Long
    ptPaperSize As POINTAPI
    rtMinMargin As RECT
    rtMargin As RECT
    hInstance As Long
    lCustData As Long
    lpfnPageSetupHook As Long
    lpfnPagePaintHook As Long
    lpPageSetupTemplateName As String
    hPageSetupTemplate As Long
End Type
Public Declare Function PageSetupDlg Lib "comdlg32.dll" Alias "PageSetupDlgA" (PPageSetupDlg As Any) As Long
Public Const PSD_MINMARGINS = &H1
Public Const PSD_MARGINS = &H2

Public Declare Function SetParent Lib "user32.dll" (ByVal hWndChild As Long, ByVal hWndNewParent As Long) As Long

Public Type DOCINFO
    cbSize As Long
    lpszDocName As String
    lpszOutput As String
    lpszDatatype As String
    fwType As Long
End Type

'http://www.experts-exchange.com/Programming/Programming_Languages/Visual_Basic/Q_10052753.html
'Dim di As DOCINFO        'Structure for Print Document info
'di.cbSize = 20                  'Size of DOCINFO structure
'di.lpszDocName = "My Document"  'Set name of print job (Optional)
'result = StartDoc(hPrintDc, di) 'Start a new print document
'result = StartPage(hPrintDc)    'Start a new page
'inform the device that the application has finished writing to a page
'result = EndPage(hPrintDc)      'End the page
'end the print job
'result = EndDoc(hPrintDc)       'End the print job

Public Declare Function StartDoc Lib "gdi32" Alias "StartDocA" _
                            (ByVal hdc As Long, lpdi As DOCINFO) As Long

Public Declare Function EndDoc Lib "gdi32" (ByVal hdc As Long) As Long

Public Declare Function StartPage Lib "gdi32" (ByVal hdc As Long) As Long

Public Declare Function EndPage Lib "gdi32" (ByVal hdc As Long) As Long

