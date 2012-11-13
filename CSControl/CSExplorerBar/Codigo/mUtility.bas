Attribute VB_Name = "mUtility"
Option Explicit

Public Type RECT
   left As Long
   Top As Long
   right As Long
   bottom As Long
End Type

Private Declare Function GetProp Lib "user32" Alias "GetPropA" (ByVal hWnd As Long, ByVal lpString As String) As Long
Private Declare Function IsWindow Lib "user32" (ByVal hWnd As Long) As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Destination As Any, Source As Any, ByVal Length As Long)
Private Declare Function OleTranslateColor Lib "OLEPRO32.DLL" (ByVal OLE_COLOR As Long, ByVal HPALETTE As Long, pccolorref As Long) As Long
Public Const CLR_INVALID = -1
Public Const CLR_NONE = CLR_INVALID
Private Declare Function GetVersion Lib "kernel32" () As Long

Private Type OSVERSIONINFO
   dwVersionInfoSize As Long
   dwMajorVersion As Long
   dwMinorVersion As Long
   dwBuildNumber As Long
   dwPlatformId As Long
   szCSDVersion(0 To 127) As Byte
End Type
Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" (lpVersionInfo As OSVERSIONINFO) As Long
Private Const VER_PLATFORM_WIN32_NT = 2

Private Type TRIVERTEX
   x As Long
   y As Long
   Red As Integer
   Green As Integer
   Blue As Integer
   Alpha As Integer
End Type
Private Type GRADIENT_RECT
    UpperLeft As Long
    LowerRight As Long
End Type
Private Type GRADIENT_TRIANGLE
    Vertex1 As Long
    Vertex2 As Long
    Vertex3 As Long
End Type
Private Declare Function GradientFill Lib "msimg32" ( _
   ByVal hdc As Long, _
   pVertex As TRIVERTEX, _
   ByVal dwNumVertex As Long, _
   pMesh As GRADIENT_RECT, _
   ByVal dwNumMesh As Long, _
   ByVal dwMode As Long) As Long
Private Declare Function GradientFillTriangle Lib "msimg32" Alias "GradientFill" ( _
   ByVal hdc As Long, _
   pVertex As TRIVERTEX, _
   ByVal dwNumVertex As Long, _
   pMesh As GRADIENT_TRIANGLE, _
   ByVal dwNumMesh As Long, _
   ByVal dwMode As Long) As Long
Private Const GRADIENT_FILL_TRIANGLE = &H2&

Public Enum GradientFillRectType
   GRADIENT_FILL_RECT_H = 0
   GRADIENT_FILL_RECT_V = 1
End Enum

Private Type BITMAP '24 bytes
   bmType As Long
   bmWidth As Long
   bmHeight As Long
   bmWidthBytes As Long
   bmPlanes As Integer
   bmBitsPixel As Integer
   bmBits As Long
End Type

Private Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
Private Declare Function FillRect Lib "user32" (ByVal hdc As Long, lpRect As RECT, ByVal hBrush As Long) As Long
Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function InflateRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
Private Declare Function DrawFocusRectAPI Lib "user32" Alias "DrawFocusRect" (ByVal hdc As Long, lpRect As RECT) As Long
Private Declare Function PatBlt Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal dwRop As Long) As Long
Private Declare Function CreateBitmapIndirect Lib "gdi32" (lpBitmap As BITMAP) As Long
Private Declare Function CreatePatternBrush Lib "gdi32" (ByVal hBitmap As Long) As Long
Private Declare Function DrawTextA Lib "user32" (ByVal hdc As Long, ByVal lpStr As String, ByVal nCount As Long, lpRect As RECT, ByVal wFormat As Long) As Long
Private Declare Function DrawTextW Lib "user32" (ByVal hdc As Long, ByVal lpStr As Long, ByVal nCount As Long, lpRect As RECT, ByVal wFormat As Long) As Long

Private Const PATCOPY = &HF00021     ' (DWORD) dest = pattern

Private m_lID As Long
Private m_bIsXp As Boolean
Private m_bIsNt As Boolean
Private m_bHasGradientAndTransparency As Boolean

Public Sub DrawText( _
      ByVal lHDC As Long, _
      ByVal sText As String, _
      ByVal lLength As Long, _
      tR As RECT, _
      ByVal lFlags As Long _
   )
' Added 2003-07-05.  Allows Unicode rendering of text under NT/2000/XP
Dim lPtr As Long
   If (m_bIsNt) Then
      lPtr = StrPtr(sText)
      If Not (lPtr = 0) Then ' NT4 crashes with ptr = 0
         DrawTextW lHDC, lPtr, -1, tR, lFlags
      End If
   Else
      DrawTextA lHDC, sText, -1, tR, lFlags
   End If
End Sub

Public Sub DrawFocusRect( _
      ByVal lHDC As Long, _
      tR As RECT _
   )
Dim tWorkR As RECT
Dim i As Long
Dim lPattern(0 To 3) As Long
Dim tbm As BITMAP
Dim hBm As Long
Dim hBrush As Long
Dim hOldBrush As Long
Dim xPixels As Long
Dim yPixels As Long
Dim widthRectPixels As Long
Dim heightRectPixels As Long

   ' Set up rect to draw:
   LSet tWorkR = tR
   InflateRect tWorkR, -2, -2

   ' Create brush:
   For i = 0 To 3
      lPattern(i) = &HAAAA5555
   Next i
   tbm.bmType = 0
   tbm.bmWidth = 16
   tbm.bmHeight = 8
   tbm.bmWidthBytes = 2
   tbm.bmPlanes = 1
   tbm.bmBitsPixel = 1
   tbm.bmBits = VarPtr(lPattern(0))
   hBm = CreateBitmapIndirect(tbm)
   hBrush = CreatePatternBrush(hBm)
   DeleteObject hBm
      
   ' Select brush:
   hOldBrush = SelectObject(lHDC, hBrush)
   
   ' Draw the rect:
   xPixels = tWorkR.left
   yPixels = tWorkR.Top
   widthRectPixels = tWorkR.right - tWorkR.left
   heightRectPixels = tWorkR.bottom - tWorkR.Top
   PatBlt lHDC, xPixels, yPixels, widthRectPixels, 1, PATCOPY
   PatBlt lHDC, xPixels + widthRectPixels, yPixels, 1, heightRectPixels, PATCOPY
   PatBlt lHDC, xPixels, yPixels + heightRectPixels, widthRectPixels, 1, PATCOPY
   PatBlt lHDC, xPixels, yPixels, 1, heightRectPixels, PATCOPY
   
   SelectObject lHDC, hOldBrush
   DeleteObject hBrush
   
End Sub

Public Sub GradientFillRect( _
      ByVal lHDC As Long, _
      tR As RECT, _
      ByVal oStartColor As OLE_COLOR, _
      ByVal oEndColor As OLE_COLOR, _
      ByVal eDir As GradientFillRectType _
   )
Dim hBrush As Long
Dim lStartColor As Long
Dim lEndColor As Long
Dim lR As Long
   
   ' Use GradientFill:
   If (HasGradientAndTransparency) Then
      lStartColor = TranslateColor(oStartColor)
      lEndColor = TranslateColor(oEndColor)
   
      Dim tTV(0 To 1) As TRIVERTEX
      Dim tGR As GRADIENT_RECT
      
      setTriVertexColor tTV(0), lStartColor
      tTV(0).x = tR.left
      tTV(0).y = tR.Top
      setTriVertexColor tTV(1), lEndColor
      tTV(1).x = tR.right
      tTV(1).y = tR.bottom
      
      tGR.UpperLeft = 0
      tGR.LowerRight = 1
      
      GradientFill lHDC, tTV(0), 2, tGR, 1, eDir
      
   Else
      ' Fill with solid brush:
      hBrush = CreateSolidBrush(TranslateColor(oEndColor))
      FillRect lHDC, tR, hBrush
      DeleteObject hBrush
   End If
   
End Sub

Private Sub setTriVertexColor(tTV As TRIVERTEX, lColor As Long)
Dim lRed As Long
Dim lGreen As Long
Dim lBlue As Long
   lRed = (lColor And &HFF&) * &H100&
   lGreen = (lColor And &HFF00&)
   lBlue = (lColor And &HFF0000) \ &H100&
   setTriVertexColorComponent tTV.Red, lRed
   setTriVertexColorComponent tTV.Green, lGreen
   setTriVertexColorComponent tTV.Blue, lBlue
End Sub
Private Sub setTriVertexColorComponent(ByRef iColor As Integer, ByVal lComponent As Long)
   If (lComponent And &H8000&) = &H8000& Then
      iColor = (lComponent And &H7F00&)
      iColor = iColor Or &H8000
   Else
      iColor = lComponent
   End If
End Sub

Public Sub VerInitialise()
  Dim tOSV As OSVERSIONINFO
  tOSV.dwVersionInfoSize = Len(tOSV)
  GetVersionEx tOSV
   
   m_bIsNt = ((tOSV.dwPlatformId And VER_PLATFORM_WIN32_NT) = VER_PLATFORM_WIN32_NT)
   If (tOSV.dwMajorVersion > 5) Then
      m_bHasGradientAndTransparency = True
      m_bIsXp = True
   ElseIf (tOSV.dwMajorVersion = 5) Then
      m_bHasGradientAndTransparency = True
      If (tOSV.dwMinorVersion >= 1) Then
         m_bIsXp = True
      End If
   ElseIf (tOSV.dwMajorVersion = 4) Then ' NT4 or 9x/ME/SE
      If (tOSV.dwMinorVersion >= 10) Then
         m_bHasGradientAndTransparency = True
      End If
   End If
   
End Sub

Public Property Get IsXp() As Boolean
   IsXp = m_bIsXp
End Property
Public Property Get IsNt() As Boolean
   IsNt = m_bIsNt
End Property
Public Property Get HasGradientAndTransparency()
   HasGradientAndTransparency = m_bHasGradientAndTransparency
End Property

Public Property Get NextId() As Long
   m_lID = m_lID + 1
   NextId = m_lID
   If (m_lID = &H7FFFFFFF) Then
      ' wrap around
      m_lID = &H80000000
   End If
End Property

Public Sub gErr(ByVal lErrNum As Long, ByVal sSource As String)
Dim sMsg As String
   '
   Select Case lErrNum
   Case 1
      ' Cannot find owner object
      lErrNum = 364
      sMsg = "Object has been unloaded."
      
   Case 9
      lErrNum = 9
      sMsg = "Subscript out of range."
   
   Case 13
      ' Invalid key: numeric
      lErrNum = 13
      sMsg = "Type Mismatch."
      
   Case 457
      ' Invalid Key: duplicate
      lErrNum = 457
      sMsg = "This key is already associated with an element of this collection."
      
   Case Else
      sMsg = "Unknown error"
   End Select
   '
   Err.Raise lErrNum, App.EXEName & "." & sSource, sMsg
End Sub
Public Function Verify(ctl As ExplorerBar, ByVal hWnd As Long, ByVal lId As Long, ByVal lIdType As Long) As Boolean
   If Not (IsWindow(hWnd) = 0) Then
      Dim lPtr As Long
      lPtr = GetProp(hWnd, "ExplorerBar")
      If Not (lPtr = 0) Then
         Set ctl = ObjectFromPtr(lPtr)
         If (ctl.fVerifyId(lId, lIdType)) Then
            Verify = True
            Exit Function
         Else
         
         End If
      End If
   End If
   gErr 1, "ExplorerBar"
End Function

Public Property Get ObjectFromPtr(ByVal lPtr As Long) As Object
Dim objT As Object
   If Not (lPtr = 0) Then
      ' Turn the pointer into an illegal, uncounted interface
      CopyMemory objT, lPtr, 4
      ' Do NOT hit the End button here! You will crash!
      ' Assign to legal reference
      Set ObjectFromPtr = objT
      ' Still do NOT hit the End button here! You will still crash!
      ' Destroy the illegal reference
      CopyMemory objT, 0&, 4
   End If
End Property
Public Function TranslateColor(ByVal oClr As OLE_COLOR, _
                        Optional hPal As Long = 0) As Long
    ' Convert Automation color to Windows color
    If OleTranslateColor(oClr, hPal, TranslateColor) Then
        TranslateColor = CLR_INVALID
    End If
End Function

Public Property Get BlendColor( _
      ByVal oColorFrom As OLE_COLOR, _
      ByVal oColorTo As OLE_COLOR, _
      Optional ByVal Alpha As Long = 128 _
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
      ((lSrcR * Alpha) / 255) + ((lDstR * (255 - Alpha)) / 255), _
      ((lSrcG * Alpha) / 255) + ((lDstG * (255 - Alpha)) / 255), _
      ((lSrcB * Alpha) / 255) + ((lDstB * (255 - Alpha)) / 255) _
      )
      
End Property

Public Function FileExists(ByVal sFile As String) As Boolean
Dim s As String
   On Error Resume Next
   s = Dir(sFile)
   FileExists = ((Err.Number = 0) And Len(s) > 0)
End Function

