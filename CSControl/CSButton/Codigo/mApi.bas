Attribute VB_Name = "mApi"
Option Explicit

'--------------------------------------------------------------------------------
' mApi
' 26-05-2006

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32

  ' constantes
  Public Const CLR_INVALID = -1
'  Public Const LF_FACESIZE = 32
'  Public Const LOGPIXELSX = 88
'  Public Const LOGPIXELSY = 90    '  Logical pixels/inch in Y
'  Public Const FW_BOLD = 700
'  Public Const FW_NORMAL = 400
'
'  Public Const BLACKONWHITE = 1
'  Public Const WHITEONBLACK = 2
'  Public Const COLORONCOLOR = 3
'  Public Const HALFTONE = 4
'
'  Public Const STRETCH_ANDSCANS = 1
'  Public Const STRETCH_ORSCANS = 2
'  Public Const STRETCH_DELETESCANS = 3
'  Public Const STRETCH_HALFTONE = 4

  'used with SetBkMode
'  Public Const C_OPAQUE = 2
'  Public Const C_TRANSPARENT = 1
'
'  Public Enum ECGTextAlignFlags
'     DT_TOP = &H0&
'     DT_LEFT = &H0&
'     DT_CENTER = &H1&
'     DT_RIGHT = &H2&
'     DT_VCENTER = &H4&
'     DT_BOTTOM = &H8&
'     DT_WORDBREAK = &H10&
'     DT_SINGLELINE = &H20&
'     DT_EXPANDTABS = &H40&
'     DT_TABSTOP = &H80&
'     DT_NOCLIP = &H100&
'     DT_EXTERNALLEADING = &H200&
'     DT_CALCRECT = &H400&
'     DT_NOPREFIX = &H800&
'     DT_INTERNAL = &H1000&
'     DT_EDITCONTROL = &H2000&
'     DT_PATH_ELLIPSIS = &H4000&
'     DT_END_ELLIPSIS = &H8000&
'     DT_MODIFYSTRING = &H10000
'     DT_RTLREADING = &H20000
'     DT_WORD_ELLIPSIS = &H40000
'  End Enum
'  Public Const SRCAND = &H8800C6 ' used to determine how a blit will turn out
'  Public Const SRCCOPY = &HCC0020  ' used to determine how a blit will turn out
'  Public Const SRCPAINT = &HEE0086   ' used to determine how a blit will turn out
'
  Public Const PS_DOT = 2
  Public Const PS_SOLID = 0

  ' estructuras
'  Public Type POINTAPI
'    x As Long
'    y As Long
'  End Type
'
  Public Type RECT
     Left   As Long
     Top    As Long
     Right  As Long
     Bottom As Long
  End Type

'  Public Type LOGFONT
'     lfHeight As Long ' The font size (see below)
'     lfWidth As Long ' Normally you don't set this, just let Windows create the Default
'     lfEscapement As Long ' The angle, in 0.1 degrees, of the font
'     lfOrientation As Long ' Leave as default
'     lfWeight As Long ' Bold, Extra Bold, Normal etc
'     lfItalic As Byte ' As it says
'     lfUnderline As Byte ' As it says
'     lfStrikeOut As Byte ' As it says
'     lfCharSet As Byte ' As it says
'     lfOutPrecision As Byte ' Leave for default
'     lfClipPrecision As Byte ' Leave for default
'     lfQuality As Byte ' Leave for default
'     lfPitchAndFamily As Byte ' Leave for default
'     lfFaceName(LF_FACESIZE) As Byte ' The font name converted to a byte array
'  End Type
'  Type BITMAP '14 bytes
'    bmType As Long
'    bmWidth As Long
'    bmHeight As Long
'    bmWidthBytes As Long
'    bmPlanes As Integer
'    bmBitsPixel As Integer
'    bmBits As Long
'  End Type
  
  ' funciones
  Public Declare Function OleTranslateColor Lib "OLEPRO32.DLL" (ByVal OLE_COLOR As Long, ByVal HPALETTE As Long, pccolorref As Long) As Long
'  Public Declare Function FrameRect Lib "user32" (ByVal hDC As Long, lpRect As RECT, ByVal hBrush As Long) As Long
  Public Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
  Public Declare Function FillRect Lib "user32" (ByVal hDC As Long, lptR As RECT, ByVal hBrush As Long) As Long
'  Public Declare Function Ellipse Lib "gdi32" (ByVal hDC As Long, ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
  Public Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
'  Public Declare Function GetClientRect Lib "user32" (ByVal hwnd As Long, lptR As RECT) As Long
'  Public Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hDC As Long) As Long
'  Public Declare Function CreateDCAsNull Lib "gdi32" Alias "CreateDCA" (ByVal lpDriverName As String, lpDeviceName As Any, lpOutput As Any, lpInitData As Any) As Long
'  Public Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hDC As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
'  Public Declare Function CreateRoundRectRgn Lib "gdi32" (ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long, ByVal X3 As Long, ByVal Y3 As Long) As Long
  Public Declare Function RoundRect Lib "gdi32" (ByVal hDC As Long, ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long, ByVal X3 As Long, ByVal Y3 As Long) As Long
'  Public Declare Function FrameRgn Lib "gdi32" (ByVal hDC As Long, ByVal hRgn As Long, ByVal hBrush As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
'  Public Declare Function CreateBitmap Lib "gdi32" (ByVal nWidth As Long, ByVal nHeight As Long, ByVal nPlanes As Long, ByVal nBitCount As Long, lpBits As Any) As Long
  Public Declare Function SelectObject Lib "gdi32" (ByVal hDC As Long, ByVal hObject As Long) As Long
'  Public Declare Function SetPixel Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long
'  Public Declare Function CreatePatternBrush Lib "gdi32" (ByVal hBitmap As Long) As Long
  Public Declare Function InflateRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
'  Public Declare Function CreateFontIndirect Lib "gdi32" Alias "CreateFontIndirectA" (lpLogFont As LOGFONT) As Long
'  Public Declare Function GetDeviceCaps Lib "gdi32" (ByVal hDC As Long, ByVal nIndex As Long) As Long
'  Public Declare Function MulDiv Lib "KERNEL32" (ByVal nNumber As Long, ByVal nNumerator As Long, ByVal nDenominator As Long) As Long
'  Public Declare Function DrawText Lib "user32" Alias "DrawTextA" (ByVal hDC As Long, ByVal lpStr As String, ByVal nCount As Long, lpRect As RECT, ByVal wFormat As Long) As Long
'  Public Declare Function SetTextColor Lib "gdi32" (ByVal hDC As Long, ByVal crColor As Long) As Long
'  Public Declare Function SetBkColor Lib "gdi32" (ByVal hDC As Long, ByVal crColor As Long) As Long
'  Public Declare Function SetBkMode Lib "gdi32" (ByVal hDC As Long, ByVal nBkMode As Long) As Long
'  Public Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
'  Public Declare Function StretchBlt Lib "gdi32" (ByVal hDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal nSrcWidth As Long, ByVal nSrcHeight As Long, ByVal dwRop As Long) As Long
'  Public Declare Function SetBrushOrgEx Lib "gdi32" (ByVal hDC As Long, ByVal nXOrg As Long, ByVal nYOrg As Long, lppt As POINTAPI) As Long
  Public Declare Function CreatePen Lib "gdi32" (ByVal nPenStyle As Long, ByVal nWidth As Long, ByVal crColor As Long) As Long
  Public Declare Function Rectangle Lib "gdi32" (ByVal hDC As Long, ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
'  Public Declare Function GetObjectAPI Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long
'  Public Declare Function SetStretchBltMode Lib "gdi32" (ByVal hDC As Long, ByVal nStretchMode As Long) As Long
'--------------------------------------------------------------------------------

Public Enum csEBorderType
  csEBSNone = 0
  csEBSFixed = 1
  csEBS3d = 2
End Enum

' constantes
Private Const C_Module = "mApi"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function TranslateColor(ByVal oClr As OLE_COLOR, Optional hPal As Long = 0) As Long
  ' Convert Automation color to Windows color
  If OleTranslateColor(oClr, hPal, TranslateColor) Then
    TranslateColor = CLR_INVALID
  End If
End Function

Public Function NewRectangle(ByVal Left As Long, ByVal Top As Long, ByVal Right As Long, ByVal Bottom As Long) As RECT
  Dim tR As RECT
  
  If Left < 0 Then Left = 0
  If Top < 0 Then Top = 0
  If Right < Left Then Right = Left
  If Bottom < Top Then Bottom = Top
  
  tR.Left = Left
  tR.Top = Top
  tR.Right = Right
  tR.Bottom = Bottom
  
  NewRectangle = tR
End Function

Public Sub RectTwipsToPixel(ByRef tR As RECT, ByVal ScaleX As Single, ByVal ScaleY As Single)
  Dim Height As Integer
  Height = (tR.Bottom - tR.Top) / Screen.TwipsPerPixelX
  tR.Left = tR.Left / Screen.TwipsPerPixelX
  tR.Top = tR.Top / Screen.TwipsPerPixelY
  tR.Right = tR.Right / Screen.TwipsPerPixelX
  tR.Bottom = tR.Top + Height

  tR.Left = tR.Left * ScaleX
  tR.Top = tR.Top * ScaleY
  tR.Right = tR.Right * ScaleX
  tR.Bottom = tR.Top + (Height * ScaleY)
End Sub

Public Sub DrawObjBox(ByVal hDC As Long, _
                      ByVal X1 As Long, _
                      ByVal Y1 As Long, _
                      ByVal X2 As Long, _
                      ByVal Y2 As Long, _
                      ByVal Filled As Boolean, _
                      ByVal ColorIn As Long, _
                      ByVal ColorOut As Long, _
                      ByVal BorderWidth As Long, _
                      ByVal BorderColor3d As Long, _
                      ByVal BorderColor3dShadow As Long, _
                      ByVal BorderType As csEBorderType, _
                      ByVal BorderRounded As Boolean, _
                      Optional ByVal BorderColorRight As Long = -1)
  
  If BorderColorRight = -1 Then BorderColorRight = BorderColor3dShadow
      
  If BorderType = csEBS3d Then
    
    'PrintLine hDC, Filled, X1, Y1, X2, Y2, ColorIn, , , vbWhite
      
    ' Linea de arriba
    PrintLine hDC, False, X1, Y1, X2, Y1, , 1, , BorderColor3d
    ' Linea de abajo
    PrintLine hDC, False, X1, Y2 - 20, X2, Y2 - 20, , 1, , BorderColor3dShadow
    ' izquierda
    PrintLine hDC, False, X1, Y1, X1, Y2, , 1, , BorderColor3d
    ' derecha
    PrintLine hDC, False, X2 - 10, Y1, X2 - 10, Y2, , 1, , BorderColorRight

  ElseIf BorderRounded Then
  
    PrintLine hDC, Filled, X1, Y1, X2, Y2, ColorIn, BorderWidth, , ColorOut, True

  Else
    PrintLine hDC, Filled, X1, Y1, X2, Y2, ColorIn, , , ColorOut
  End If
End Sub

Private Sub PrintLine(ByVal hDC As Long, Optional ByVal Filled As Boolean = True, _
                      Optional ByVal X1 As Single = 0, Optional ByVal Y1 As Single = 0, _
                      Optional ByVal X2 As Single = 0, Optional ByVal Y2 As Single = 0, _
                      Optional ByVal ColorInside As Long = vbCyan, _
                      Optional ByVal Width As Long = 1, _
                      Optional ByVal Dash As Boolean = False, _
                      Optional ByVal ColorOut As Long = vbBlack, _
                      Optional ByVal Rounded As Boolean)

  Dim tR      As RECT
  Dim lResult As Long
  Dim hRPen   As Long
  Dim hOldPen As Long

  If Dash Then
    hRPen = CreatePen(PS_DOT, Width, TranslateColor(ColorOut))
  Else
    hRPen = CreatePen(PS_SOLID, Width, TranslateColor(ColorOut))
  End If
  hOldPen = SelectObject(hDC, hRPen)

  If Rounded Then
  
    X1 = X1 / Screen.TwipsPerPixelX
    X2 = X2 / Screen.TwipsPerPixelX
    
    Y1 = Y1 / Screen.TwipsPerPixelY
    Y2 = Y2 / Screen.TwipsPerPixelY
    
    RoundRect hDC, X1, Y1, X2, Y2, 20, 20
  Else

    tR = NewRectangle(X1, Y1, X2, Y2)
    RectTwipsToPixel tR, 1, 1
  
    If Y2 <> Y1 And X1 <> X2 Then
      
      Rectangle hDC, tR.Left, tR.Top, tR.Right, tR.Bottom
      
      If Filled Then
        Dim hBrush2 As Long
        InflateRect tR, -1, -1
        hBrush2 = CreateSolidBrush(TranslateColor(ColorInside))
        lResult = FillRect(hDC, tR, hBrush2)
        DeleteObject hBrush2
      End If
  
    Else
      If tR.Bottom = 0 Or tR.Bottom = tR.Top Then tR.Bottom = tR.Top + 1
      If tR.Right = 0 Or tR.Left = tR.Right Then tR.Right = tR.Left + 1
      Rectangle hDC, tR.Left, tR.Top, tR.Right, tR.Bottom
    End If
  End If
  
  DeleteObject SelectObject(hDC, hOldPen)
End Sub

' funciones friend
' funciones privadas
' construccion - destruccion
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
