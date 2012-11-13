Attribute VB_Name = "mImage"
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

Public Type PALETTEENTRY
    peRed   As Byte
    peGreen As Byte
    peBlue  As Byte
    peFlags As Byte
End Type

Public Type LOGPALETTE
    palVersion       As Integer
    palNumEntries    As Integer
    palPalEntry(255) As PALETTEENTRY  ' Enough for 256 colors
End Type
         
Public Type GUID
    Data1    As Long
    Data2    As Integer
    Data3    As Integer
    Data4(7) As Byte
End Type

Public Type RECT
    Left   As Long
    Top    As Long
    Right  As Long
    Bottom As Long
End Type

Public Type tRect
    Left   As Long
    Top    As Long
    Right  As Long
    Bottom As Long
End Type

Public Type PicBmp
    Size As Long
    Type As Long
    hBmp As Long
    hPal As Long
    Reserved As Long
End Type

' Structure used to hold bitmap information about Bitmaps
' created using GDI in memory:
Public Type Bitmap
    bmType As Long
    bmWidth As Long
    bmHeight As Long
    bmWidthBytes As Long
    bmPlanes As Integer
    bmBitsPixel As Integer
    bmBits As Long
End Type

Public Type DRAWTEXTPARAMS
    cbSize As Long
    iTabLength As Long
    iLeftMargin As Long
    iRightMargin As Long
    uiLengthDrawn As Long
End Type

Public Type TEXTMETRIC
    tmMemoryHeight As Long
    tmAscent As Long
    tmDescent As Long
    tmInternalLeading As Long
    tmExternalLeading As Long
    tmAveCharWidth As Long
    tmMaxCharWidth As Long
    tmWeight As Long
    tmOverhang As Long
    tmDigitizedAspectX As Long
    tmDigitizedAspectY As Long
    tmFirstChar As Byte
    tmLastChar As Byte
    tmDefaultChar As Byte
    tmBreakChar As Byte
    tmItalic As Byte
    tmUnderlined As Byte
    tmStruckOut As Byte
    tmPitchAndFamily As Byte
    tmCharSet As Byte
End Type

'Public Const RASTERCAPS As Long = 38
Public Const RC_PALETTE As Long = &H100
'Public Const SIZEPALETTE As Long = 104
Public Const SRCCOPY = &HCC0020

'
' DC = Device Context
'
' Creates a bitmap compatible with the device associated
' with the specified DC.
Public Declare Function CreateCompatibleBitmap Lib "gdi32" ( _
    ByVal hdc As Long, ByVal nWidth As Long, _
    ByVal nHeight As Long) As Long

' Retrieves device-specific information about a specified device.
Public Declare Function GetDeviceCaps Lib "gdi32" ( _
    ByVal hdc As Long, ByVal iCapabilitiy As Long) As Long

' Retrieves a range of palette entries from the system palette
' associated with the specified DC.
Public Declare Function GetSystemPaletteEntries Lib "gdi32" ( _
    ByVal hdc As Long, ByVal wStartIndex As Long, _
    ByVal wNumEntries As Long, lpPaletteEntries As PALETTEENTRY) _
    As Long

' Creates a memory DC compatible with the specified device.
'hDc: [in] Handle to an existing DC. If this handle is NULL,
'the function creates a memory DC compatible with the application's
'current screen.
Public Declare Function CreateCompatibleDC Lib "gdi32" ( _
    ByVal hdc As Long) As Long

' Creates a logical color palette.
Public Declare Function CreatePalette Lib "gdi32" ( _
    lpLogPalette As LOGPALETTE) As Long

' Selects the specified logical palette into a DC.
Public Declare Function SelectPalette Lib "gdi32" ( _
    ByVal hdc As Long, ByVal hPalette As Long, _
    ByVal bForceBackground As Long) As Long

' Maps palette entries from the current logical
' palette to the system palette.
Public Declare Function RealizePalette Lib "gdi32" ( _
    ByVal hdc As Long) As Long

' Selects an object into the specified DC. The new
' object replaces the previous object of the same type.
' Returned is the handle of the replaced object.
Public Declare Function SelectObject Lib "gdi32" ( _
    ByVal hdc As Long, ByVal hObject As Long) As Long

Public Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long

' Performs a bit-block transfer of color data corresponding to
' a rectangle of pixels from the source DC into a destination DC.
Public Declare Function BitBlt Lib "gdi32" ( _
    ByVal hDCDest As Long, ByVal XDest As Long, _
    ByVal YDest As Long, ByVal nWidth As Long, _
    ByVal nHeight As Long, ByVal hDCSrc As Long, _
    ByVal XSrc As Long, ByVal YSrc As Long, ByVal dwRop As Long) _
    As Long

' Retrieves the DC for the entire window, including title bar,
' menus, and scroll bars. A window DC permits painting anywhere
' in a window, because the origin of the DC is the upper-left
' corner of the window instead of the client area.
Public Declare Function GetWindowDC Lib "user32" ( _
    ByVal hwnd As Long) As Long

' Retrieves a handle to a display DC for the Client area of
' a specified window or for the entire screen.  You can use
' the returned handle in subsequent GDI functions to draw in
' the DC.
Public Declare Function GetDC Lib "user32" ( _
    ByVal hwnd As Long) As Long

' Releases a DC, freeing it for use by other applications.
' The effect of the ReleaseDC function depends on the type
' of DC.  It frees only common and window DCs.  It has no
' effect on class or private DCs.
Public Declare Function ReleaseDC Lib "user32" ( _
    ByVal hwnd As Long, ByVal hdc As Long) As Long

' Deletes the specified DC.
Public Declare Function DeleteDC Lib "gdi32" ( _
    ByVal hdc As Long) As Long

' Retrieves the dimensions of the bounding rectangle of the
' specified window. The dimensions are given in screen
' coordinates that are relative to the upper-left corner
' of the screen.
Public Declare Function GetWindowRect Lib "user32" ( _
    ByVal hwnd As Long, lpRect As RECT) As Long

Public Declare Function GetClientRect Lib "user32" ( _
    ByVal hwnd As Long, lpRect As RECT) As Long

' Returns a handle to the Desktop window.  The desktop
' window covers the entire screen and is the area on top
' of which all icons and other windows are painted.
Public Declare Function GetDesktopWindow Lib "user32" () As Long

' Returns a handle to the foreground window (the window
' the user is currently working). The system assigns a
' slightly higher priority to the thread that creates the
' foreground window than it does to other threads.
Public Declare Function GetForegroundWindow Lib "user32" () As Long

' Creates a new picture object initialized according to a PICTDESC
' structure, which can be NULL, to create an uninitialized object if
' the caller wishes to have the picture initialize itself through
' IPersistStream::Load.  The fOwn parameter indicates whether the
' picture is to own the GDI picture handle for the picture it contains,
' so that the picture object will destroy its picture when the object
' itself is destroyed.  The function returns an interface pointer to the
' new picture object specified by the caller in the riid parameter.
' A QueryInterface is built into this call.  The caller is responsible
' for calling Release through the interface pointer returned - phew!
Public Declare Function OleCreatePictureIndirect _
    Lib "olepro32.dll" (PicDesc As PicBmp, RefIID As GUID, _
    ByVal fPictureOwnsHandle As Long, IPic As IPicture) As Long


Public Declare Function DrawTextEx Lib "user32" Alias "DrawTextExA" (ByVal hdc As Long, ByVal lpsz As String, ByVal n As Long, lpRect As Any, ByVal un As Long, lpDrawTextParams As DRAWTEXTPARAMS) As Long

Public Declare Function GetBkMode Lib "gdi32" (ByVal hdc As Long) As Long
Public Declare Function SetBkMode Lib "gdi32" (ByVal hdc As Long, ByVal nBkMode As Long) As Long
Public Declare Function SetBkColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
Public Declare Function GetBkColor Lib "gdi32" (ByVal hdc As Long) As Long

Public Declare Function StretchBlt Lib "gdi32" (ByVal hdc As Long, _
       ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, _
       ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal XSrc As Long, _
       ByVal YSrc As Long, ByVal nSrcWidth As Long, _
       ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long

' Get information relating to a GDI Object
Public Declare Function GetObjectAPI Lib "gdi32" Alias "GetObjectA" ( _
        ByVal hObject As Long, _
        ByVal nCount As Long, _
        lpObject As Any _
        ) As Long


Public Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
Public Declare Function FillRect Lib "user32" (ByVal hdc As Long, lpRect As Any, ByVal hBrush As Long) As Long

