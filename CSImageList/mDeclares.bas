Attribute VB_Name = "mDeclares"
Option Explicit
    
' General:
Declare Function GetWindowWord Lib "user32" (ByVal hwnd As Long, ByVal nIndex As Long) As Integer
    Public Const GWW_HINSTANCE = (-6)
    
' GDI object functions:
Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Declare Function GetObjectAPI Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long
Declare Function GetDC Lib "user32" (ByVal hwnd As Long) As Long
Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
Declare Function ReleaseDC Lib "user32" (ByVal hwnd As Long, ByVal hdc As Long) As Long
Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long
Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hdc As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal nIndex As Long) As Long
    Public Const BITSPIXEL = 12
    Public Const LOGPIXELSX = 88    '  Logical pixels/inch in X
    Public Const LOGPIXELSY = 90    '  Logical pixels/inch in Y
' System metrics:
Declare Function GetSystemMetrics Lib "user32" (ByVal nIndex As Long) As Long
    Public Const SM_CXICON = 11
    Public Const SM_CYICON = 12
    Public Const SM_CXFRAME = 32
    Public Const SM_CYCAPTION = 4
    Public Const SM_CYFRAME = 33
    Public Const SM_CYBORDER = 6
    Public Const SM_CXBORDER = 5

' Region paint and fill functions:
Declare Function PaintRgn Lib "gdi32" (ByVal hdc As Long, ByVal hRgn As Long) As Long
Declare Function ExtFloodFill Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long, ByVal wFillType As Long) As Long
    Public Const FLOODFILLBORDER = 0
    Public Const FLOODFILLSURFACE = 1
Declare Function GetPixel Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long

' Pen functions:
Declare Function CreatePen Lib "gdi32" (ByVal nPenStyle As Long, ByVal nWidth As Long, ByVal crColor As Long) As Long
    Public Const PS_DASH = 1
    Public Const PS_DASHDOT = 3
    Public Const PS_DASHDOTDOT = 4
    Public Const PS_DOT = 2
    Public Const PS_SOLID = 0
    Public Const PS_NULL = 5

' Brush functions:
Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
Declare Function CreatePatternBrush Lib "gdi32" (ByVal hBitmap As Long) As Long

' Line functions:
Declare Function LineTo Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long
Type POINTAPI
        x As Long
        y As Long
End Type
Declare Function MoveToEx Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, lpPoint As POINTAPI) As Long

' Colour functions:
Declare Function SetTextColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
Declare Function SetBkColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
Declare Function SetBkMode Lib "gdi32" (ByVal hdc As Long, ByVal nBkMode As Long) As Long
    Public Const OPAQUE = 2
    Public Const TRANSPARENT = 1
Declare Function GetSysColor Lib "user32" (ByVal nIndex As Long) As Long
    Public Const COLOR_ACTIVEBORDER = 10
    Public Const COLOR_ACTIVECAPTION = 2
    Public Const COLOR_ADJ_MAX = 100
    Public Const COLOR_ADJ_MIN = -100
    Public Const COLOR_APPWORKSPACE = 12
    Public Const COLOR_BACKGROUND = 1
    Public Const COLOR_BTNFACE = 15
    Public Const COLOR_BTNHIGHLIGHT = 20
    Public Const COLOR_BTNSHADOW = 16
    Public Const COLOR_BTNTEXT = 18
    Public Const COLOR_CAPTIONTEXT = 9
    Public Const COLOR_GRAYTEXT = 17
    Public Const COLOR_HIGHLIGHT = 13
    Public Const COLOR_HIGHLIGHTTEXT = 14
    Public Const COLOR_INACTIVEBORDER = 11
    Public Const COLOR_INACTIVECAPTION = 3
    Public Const COLOR_INACTIVECAPTIONTEXT = 19
    Public Const COLOR_MENU = 4
    Public Const COLOR_MENUTEXT = 7
    Public Const COLOR_SCROLLBAR = 0
    Public Const COLOR_WINDOW = 5
    Public Const COLOR_WINDOWFRAME = 6
    Public Const COLOR_WINDOWTEXT = 8
    Public Const COLORONCOLOR = 3

' Shell Extract icon functions:
Declare Function FindExecutable Lib "shell32.dll" Alias "FindExecutableA" (ByVal lpFile As String, ByVal lpDirectory As String, ByVal lpResult As String) As Long
Declare Function ExtractIcon Lib "shell32.dll" Alias "ExtractIconA" (ByVal hInst As Long, ByVal lpszExeFileName As String, ByVal nIconIndex As Long) As Long

' Icon functions:
Declare Function DrawIcon Lib "user32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal hIcon As Long) As Long
Declare Function DestroyIcon Lib "user32" (ByVal hIcon As Long) As Long
Declare Function DrawIconEx Lib "user32" (ByVal hdc As Long, ByVal xLeft As Long, ByVal yTop As Long, ByVal hIcon As Long, ByVal cxWidth As Long, ByVal cyWidth As Long, ByVal istepIfAniCur As Long, ByVal hbrFlickerFreeDraw As Long, ByVal diFlags As Long) As Boolean
Public Const DI_MASK = &H1&
Public Const DI_IMAGE = &H2&
Public Const DI_NORMAL = &H3&
Public Const DI_COMPAT = &H4&
Public Const DI_DEFAULTSIZE = &H8&

Declare Function LoadImage Lib "user32" Alias "LoadImageA" (ByVal hInst As Long, ByVal lpsz As String, ByVal un1 As Long, ByVal n1 As Long, ByVal n2 As Long, ByVal un2 As Long) As Long
Declare Function LoadImageLong Lib "user32" Alias "LoadImageA" (ByVal hInst As Long, ByVal lpsz As Long, ByVal un1 As Long, ByVal n1 As Long, ByVal n2 As Long, ByVal un2 As Long) As Long
    Public Const LR_LOADMAP3DCOLORS = &H1000
    Public Const LR_LOADFROMFILE = &H10
    Public Const LR_LOADTRANSPARENT = &H20
Declare Function DestroyCursor Lib "user32" (ByVal hCursor As Long) As Long

' Blitting functions
Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
    Public Const SRCAND = &H8800C6
    Public Const SRCCOPY = &HCC0020
    Public Const SRCERASE = &H440328
    Public Const SRCINVERT = &H660046
    Public Const SRCPAINT = &HEE0086
    Public Const BLACKNESS = &H42
    Public Const WHITENESS = &HFF0062
Declare Function PatBlt Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal dwRop As Long) As Long
Declare Function LoadBitmapBynum Lib "user32" Alias "LoadBitmapA" (ByVal hInstance As Long, ByVal lpBitmapName As Long) As Long
Type BITMAP '14 bytes
    bmType As Long
    bmWidth As Long
    bmHeight As Long
    bmWidthBytes As Long
    bmPlanes As Integer
    bmBitsPixel As Integer
    bmBits As Long
End Type
Declare Function CreateBitmapIndirect Lib "gdi32" (lpBitmap As BITMAP) As Long

' Text functions:
Type RECT
    left As Long
    tOp As Long
    Right As Long
    Bottom As Long
End Type
Declare Function PtInRect Lib "user32" (lpRect As RECT, ByVal ptX As Long, ByVal ptY As Long) As Long
Declare Function DrawText Lib "user32" Alias "DrawTextA" (ByVal hdc As Long, ByVal lpStr As String, ByVal nCount As Long, lpRect As RECT, ByVal wFormat As Long) As Long
    Public Const DT_BOTTOM = &H8&
    Public Const DT_CENTER = &H1&
    Public Const DT_LEFT = &H0&
    Public Const DT_CALCRECT = &H400&
    Public Const DT_WORDBREAK = &H10&
    Public Const DT_VCENTER = &H4&
    Public Const DT_TOP = &H0&
    Public Const DT_TABSTOP = &H80&
    Public Const DT_SINGLELINE = &H20&
    Public Const DT_RIGHT = &H2&
    Public Const DT_NOCLIP = &H100&
    Public Const DT_INTERNAL = &H1000&
    Public Const DT_EXTERNALLEADING = &H200&
    Public Const DT_EXPANDTABS = &H40&
    Public Const DT_CHARSTREAM = 4&
    Public Const DT_NOPREFIX = &H800&
Type DRAWTEXTPARAMS
    cbSize As Long
    iTabLength As Long
    iLeftMargin As Long
    iRightMargin As Long
    uiLengthDrawn As Long
End Type
Declare Function DrawTextEx Lib "user32" Alias "DrawTextExA" (ByVal hdc As Long, ByVal lpsz As String, ByVal n As Long, lpRect As RECT, ByVal un As Long, lpDrawTextParams As DRAWTEXTPARAMS) As Long
Declare Function DrawTextExAsNull Lib "user32" Alias "DrawTextExA" (ByVal hdc As Long, ByVal lpsz As String, ByVal n As Long, lpRect As RECT, ByVal un As Long, ByVal lpDrawTextParams As Long) As Long
    Public Const DT_EDITCONTROL = &H2000&
    Public Const DT_PATH_ELLIPSIS = &H4000&
    Public Const DT_END_ELLIPSIS = &H8000&
    Public Const DT_MODIFYSTRING = &H10000
    Public Const DT_RTLREADING = &H20000
    Public Const DT_WORD_ELLIPSIS = &H40000

Type SIZEAPI
    cx As Long
    cy As Long
End Type
Public Declare Function GetTextExtentPoint32 Lib "gdi32" Alias "GetTextExtentPoint32A" (ByVal hdc As Long, ByVal lpsz As String, ByVal cbString As Long, lpSize As SIZEAPI) As Long
Public Declare Function GetStockObject Lib "gdi32" (ByVal nIndex As Long) As Long
    Public Const ANSI_FIXED_FONT = 11
    Public Const ANSI_VAR_FONT = 12
    Public Const SYSTEM_FONT = 13
    Public Const DEFAULT_GUI_FONT = 17 'win95 only
Declare Function FillRect Lib "user32" (ByVal hdc As Long, lpRect As RECT, ByVal hBrush As Long) As Long
Declare Function Rectangle Lib "gdi32" (ByVal hdc As Long, ByVal X1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long) As Long
Declare Function DrawEdge Lib "user32" (ByVal hdc As Long, qrc As RECT, ByVal edge As Long, ByVal grfFlags As Long) As Long
    Public Const BF_LEFT = 1
    Public Const BF_TOP = 2
    Public Const BF_RIGHT = 4
    Public Const BF_BOTTOM = 8
    Public Const BF_RECT = BF_LEFT Or BF_TOP Or BF_RIGHT Or BF_BOTTOM
    Public Const BF_MIDDLE = 2048
    Public Const BDR_SUNKENINNER = 8
    Public Const BDR_SUNKENOUTER = 2
    Public Const BDR_RAISEDOUTER = 1
    Public Const BDR_RAISEDINNER = 4

Declare Function ShowWindow Lib "user32" (ByVal hwnd As Long, ByVal nCmdShow As Long) As Long
    Public Const SW_SHOWNOACTIVATE = 4

' Scrolling and region functions:
Declare Function ScrollDC Lib "user32" (ByVal hdc As Long, ByVal dx As Long, ByVal dy As Long, lprcScroll As RECT, lprcClip As RECT, ByVal hrgnUpdate As Long, lprcUpdate As RECT) As Long
Declare Function SetWindowRgn Lib "user32" (ByVal hwnd As Long, ByVal hRgn As Long, ByVal bRedraw As Long) As Long
Declare Function SelectClipRgn Lib "gdi32" (ByVal hdc As Long, ByVal hRgn As Long) As Long
Declare Function CreateRectRgn Lib "gdi32" (ByVal X1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long) As Long
Declare Function CreateRectRgnIndirect Lib "gdi32" (lpRect As RECT) As Long
Declare Function CreatePolyPolygonRgn Lib "gdi32" (lpPoint As POINTAPI, lpPolyCounts As Long, ByVal nCount As Long, ByVal nPolyFillMode As Long) As Long
Declare Function CreatePolygonRgn Lib "gdi32" (lpPoint As POINTAPI, ByVal nCount As Long, ByVal nPolyFillMode As Long)
Declare Function SaveDC Lib "gdi32" (ByVal hdc As Long) As Long
Declare Function RestoreDC Lib "gdi32" (ByVal hdc As Long, ByVal hSavedDC As Long) As Long
Declare Function CreateDCAsNull Lib "gdi32" Alias "CreateDCA" (ByVal lpDriverName As String, lpDeviceName As Any, lpOutput As Any, lpInitData As Any) As Long

Public Const LF_FACESIZE = 32
Type LOGFONT
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
End Type
Public Const FW_NORMAL = 400
Public Const FW_BOLD = 700
Public Const FF_DONTCARE = 0
Public Const DEFAULT_QUALITY = 0
Public Const DEFAULT_PITCH = 0
Public Const DEFAULT_CHARSET = 1
Declare Function CreateFontIndirect& Lib "gdi32" Alias "CreateFontIndirectA" (lpLogFont As LOGFONT)
Declare Function MulDiv Lib "kernel32" (ByVal nNumber As Long, ByVal nNumerator As Long, ByVal nDenominator As Long) As Long
Declare Function DrawFocusRect Lib "user32" (ByVal hdc As Long, lpRect As RECT) As Long

Declare Function DrawState Lib "user32" Alias "DrawStateA" _
    (ByVal hdc As Long, _
    ByVal hBrush As Long, _
    ByVal lpDrawStateProc As Long, _
    ByVal lParam As Long, _
    ByVal wParam As Long, _
    ByVal x As Long, _
    ByVal y As Long, _
    ByVal cx As Long, _
    ByVal cy As Long, _
    ByVal fuFlags As Long) As Long

'/* Image type */
Public Const DST_COMPLEX = &H0&
Public Const DST_TEXT = &H1&
Public Const DST_PREFIXTEXT = &H2&
Public Const DST_ICON = &H3&
Public Const DST_BITMAP = &H4&

' /* State type */
Public Const DSS_NORMAL = &H0&
Public Const DSS_UNION = &H10& ' Dither
Public Const DSS_DISABLED = &H20&
Public Const DSS_MONO = &H80& ' Draw in colour of brush specified in hBrush
Public Const DSS_RIGHT = &H8000&

Declare Function OleTranslateColor Lib "olepro32.dll" (ByVal OLE_COLOR As Long, ByVal HPALETTE As Long, pccolorref As Long) As Long
Public Const CLR_INVALID = -1

' Image list functions:
Public Declare Function ImageList_GetBkColor Lib "COMCTL32" (ByVal hImageList As Long) As Long
Public Declare Function ImageList_ReplaceIcon Lib "COMCTL32" (ByVal hImageList As Long, ByVal i As Long, ByVal hIcon As Long) As Long
Public Declare Function ImageList_Convert Lib "COMCTL32" Alias "ImageList_Draw" (ByVal hImageList As Long, ByVal ImgIndex As Long, ByVal hDCDest As Long, ByVal x As Long, ByVal y As Long, ByVal flags As Long) As Long
Public Declare Function ImageList_Create Lib "COMCTL32" (ByVal MinCx As Long, ByVal MinCy As Long, ByVal flags As Long, ByVal cInitial As Long, ByVal cGrow As Long) As Long
Public Declare Function ImageList_AddMasked Lib "COMCTL32" (ByVal hImageList As Long, ByVal hbmImage As Long, ByVal crMask As Long) As Long
Public Declare Function ImageList_Replace Lib "COMCTL32" (ByVal hImageList As Long, ByVal ImgIndex As Long, ByVal hbmImage As Long, ByVal hBmMask As Long) As Long
Public Declare Function ImageList_Add Lib "COMCTL32" (ByVal hImageList As Long, ByVal hbmImage As Long, hBmMask As Long) As Long
Public Declare Function ImageList_Remove Lib "COMCTL32" (ByVal hImageList As Long, ByVal ImgIndex As Long) As Long
Public Type IMAGEINFO
    hBitmapImage As Long
    hBitmapMask As Long
    cPlanes As Long
    cBitsPerPixel As Long
    rcImage As RECT
End Type
Public Declare Function ImageList_GetImageInfo Lib "COMCTL32.DLL" ( _
        ByVal hIml As Long, _
        ByVal i As Long, _
        pImageInfo As IMAGEINFO _
    ) As Long
Public Declare Function ImageList_AddIcon Lib "COMCTL32" (ByVal hIml As Long, ByVal hIcon As Long) As Long
Public Declare Function ImageList_GetIcon Lib "COMCTL32" (ByVal hImageList As Long, ByVal ImgIndex As Long, ByVal fuFlags As Long) As Long
Public Declare Function ImageList_SetImageCount Lib "COMCTL32" (ByVal hImageList As Long, uNewCount As Long)
Public Declare Function ImageList_GetImageCount Lib "COMCTL32" (ByVal hImageList As Long) As Long
Public Declare Function ImageList_Destroy Lib "COMCTL32" (ByVal hImageList As Long) As Long
Public Declare Function ImageList_GetIconSize Lib "COMCTL32" (ByVal hImageList As Long, cx As Long, cy As Long) As Long
Public Declare Function ImageList_SetIconSize Lib "COMCTL32" (ByVal hImageList As Long, cx As Long, cy As Long) As Long

' ImageList functions:
' Draw:
Public Declare Function ImageList_Draw Lib "COMCTL32.DLL" ( _
        ByVal hIml As Long, _
        ByVal i As Long, _
        ByVal hdcDst As Long, _
        ByVal x As Long, _
        ByVal y As Long, _
        ByVal fStyle As Long _
    ) As Long
Public Const ILD_NORMAL = 0&
Public Const ILD_TRANSPARENT = 1&
Public Const ILD_BLEND25 = 2&
Public Const ILD_SELECTED = 4&
Public Const ILD_FOCUS = 4&
Public Const ILD_MASK = &H10&
Public Const ILD_IMAGE = &H20&
Public Const ILD_ROP = &H40&
Public Const ILD_OVERLAYMASK = 3840&
Public Declare Function ImageList_GetImageRect Lib "COMCTL32.DLL" ( _
        ByVal hIml As Long, _
        ByVal i As Long, _
        prcImage As RECT _
    ) As Long
' Messages:
Public Declare Function ImageList_DrawEx Lib "COMCTL32" (ByVal hIml As Long, ByVal i As Long, ByVal hdcDst As Long, ByVal x As Long, ByVal y As Long, ByVal dx As Long, ByVal dy As Long, ByVal rgbBk As Long, ByVal rgbFg As Long, ByVal fStyle As Long) As Long
Public Declare Function ImageList_LoadImage Lib "COMCTL32" Alias "ImageList_LoadImageA" (ByVal hInst As Long, ByVal lpbmp As String, ByVal cx As Long, ByVal cGrow As Long, ByVal crMask As Long, ByVal uType As Long, ByVal uFlags As Long)
Public Declare Function ImageList_SetBkColor Lib "COMCTL32" (ByVal hImageList As Long, ByVal clrBk As Long) As Long

Public Const ILC_MASK = &H1&
 
Public Const CLR_DEFAULT = -16777216
Public Const CLR_HILIGHT = -16777216
Public Const CLR_NONE = -1

Public Const ILCF_MOVE = &H0&
Public Const ILCF_SWAP = &H1&
Public Declare Function ImageList_Copy Lib "COMCTL32" (ByVal himlDst As Long, ByVal iDst As Long, ByVal himlSrc As Long, ByVal iSrc As Long, ByVal uFlags As Long) As Long

Private Declare Function GetTempFileName Lib "kernel32" Alias "GetTempFileNameA" (ByVal lpszPath As String, ByVal lpPrefixString As String, ByVal wUnique As Long, ByVal lpTempFileName As String) As Long
Private Declare Function GetTempPath Lib "kernel32" Alias "GetTempPathA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long
Private Const MAX_PATH = 260
Private Declare Function lstrlen Lib "kernel32" Alias "lstrlenA" (ByVal lpString As String) As Long

Private Type PictDesc
    cbSizeofStruct As Long
    picType As Long
    hImage As Long
    xExt As Long
    yExt As Long
End Type
Private Type Guid
    Data1 As Long
    Data2 As Integer
    Data3 As Integer
    Data4(0 To 7) As Byte
End Type
Private Declare Function OleCreatePictureIndirect Lib "olepro32.dll" (lpPictDesc As PictDesc, riid As Guid, ByVal fPictureOwnsHandle As Long, ipic As IPicture) As Long

Public Function IconToPicture(ByVal hIcon As Long) As IPicture
    
    If hIcon = 0 Then Exit Function
        
    ' This is all magic if you ask me:
    Dim NewPic As Picture, PicConv As PictDesc, IGuid As Guid
    
    PicConv.cbSizeofStruct = Len(PicConv)
    PicConv.picType = vbPicTypeIcon
    PicConv.hImage = hIcon
    
    ' Fill in magic IPicture GUID {7BF80980-BF32-101A-8BBB-00AA00300CAB}
    With IGuid
        .Data1 = &H7BF80980
        .Data2 = &HBF32
        .Data3 = &H101A
        .Data4(0) = &H8B
        .Data4(1) = &HBB
        .Data4(2) = &H0
        .Data4(3) = &HAA
        .Data4(4) = &H0
        .Data4(5) = &H30
        .Data4(6) = &HC
        .Data4(7) = &HAB
    End With
    OleCreatePictureIndirect PicConv, IGuid, True, NewPic
    
    Set IconToPicture = NewPic
    
End Function

Public Function BitmapToPicture(ByVal hBmp As Long) As IPicture

   If (hBmp = 0) Then Exit Function
   
   Dim NewPic As Picture, tPicConv As PictDesc, IGuid As Guid
   
   ' Fill PictDesc structure with necessary parts:
   With tPicConv
      .cbSizeofStruct = Len(tPicConv)
      .picType = vbPicTypeBitmap
      .hImage = hBmp
   End With
   
   ' Fill in IDispatch Interface ID
   With IGuid
      .Data1 = &H20400
      .Data4(0) = &HC0
      .Data4(7) = &H46
   End With
   
   ' Create a picture object:
   OleCreatePictureIndirect tPicConv, IGuid, True, NewPic
   
   ' Return it:
   Set BitmapToPicture = NewPic
      

End Function

Public Function TranslateColor(ByVal clr As OLE_COLOR, _
                        Optional hPal As Long = 0) As Long
   If OleTranslateColor(clr, hPal, TranslateColor) Then
      TranslateColor = CLR_INVALID
   End If
End Function


Public Function GetTempFile(Optional Prefix As String) As String
Dim PathName As String
Dim sRet As String

    If Prefix = "" Then Prefix = ""
    PathName = GetTempDir
    
    sRet = String(MAX_PATH, 0)
    GetTempFileName PathName, Prefix, 0, sRet
    GetTempFile = StrZToStr(sRet)
    
End Function

Private Function GetTempDir() As String
Dim sRet As String, c As Long
    sRet = String(MAX_PATH, 0)
    c = GetTempPath(MAX_PATH, sRet)
    If c = 0 Then
        GetTempDir = App.Path
    Else
        GetTempDir = left$(sRet, c)
    End If
End Function
Private Function StrZToStr(s As String) As String
    StrZToStr = left$(s, lstrlen(s))
End Function

