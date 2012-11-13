Attribute VB_Name = "Module1"
Option Explicit

Public m_hBr As Long

Public Const CLR_NONE = -1
Private Const FW_NORMAL = 400
Private Const LF_FACESIZE = 32
Public Type LOGFONT
   lfHeight As Long ' The font size (see below)
   lfWidth As Long ' Normally you don't set this, just let Windows create the Default
   lfEscapement As Long ' The angle, in 0.1 degrees, of the font
   lfOrientation As Long ' Leave as default
   lfWeight As Long ' Bold, Extra Bold, Normal etc
   lfItalic As Byte ' As it says
   lfUnderline As Byte ' As it says
   lfStrikeOut As Byte ' As it says
   lfCharSet As Byte ' As it says
   lfOutPrecision As Byte ' Leave for default
   lfClipPrecision As Byte ' Leave for default
   lfQuality As Byte ' Leave for default
   lfPitchAndFamily As Byte ' Leave for default
   lfFaceName(LF_FACESIZE) As Byte ' The font name converted to a byte array
End Type

' /* State type */
Private Const DSS_NORMAL = &H0
Private Const DSS_UNION = &H10
Private Const DSS_DISABLED = &H20
Private Const DSS_MONO = &H80
Private Const DSS_RIGHT = &H8000

Private Const DST_COMPLEX = &H0
Private Const DST_TEXT = &H1
Private Const DST_PREFIXTEXT = &H2
Private Const DST_ICON = &H3
Private Const DST_BITMAP = &H4

Private Const FW_BOLD = 700

' Built in ImageList drawing methods:
Private Const ILD_NORMAL = 0
Private Const ILD_TRANSPARENT = 1
Private Const ILD_BLEND25 = 2
Private Const ILD_SELECTED = 4
Private Const ILD_FOCUS = 4
Private Const ILD_OVERLAYMASK = 3840

Private Const LOGPIXELSY = 90    '  Logical pixels/inch in Y
Public Type RECT
   Left As Long
   Top As Long
   Right As Long
   Bottom As Long
End Type

Private Declare Function ImageList_GetIcon Lib "COMCTL32.DLL" ( _
        ByVal hIml As Long, _
        ByVal i As Long, _
        ByVal diIgnore As Long _
    ) As Long
Private Declare Function DestroyIcon Lib "user32" (ByVal hIcon As Long) As Long
Private Declare Function ImageList_DrawEx Lib "COMCTL32.DLL" ( _
      ByVal hIml As Long, _
      ByVal i As Long, _
      ByVal hdcDst As Long, _
      ByVal x As Long, _
      ByVal y As Long, _
      ByVal dx As Long, _
      ByVal dy As Long, _
      ByVal rgbBk As Long, _
      ByVal rgbFg As Long, _
      ByVal fStyle As Long _
   ) As Long
Private Declare Function ImageList_Draw Lib "COMCTL32.DLL" ( _
        ByVal hIml As Long, _
        ByVal i As Long, _
        ByVal hdcDst As Long, _
        ByVal x As Long, _
        ByVal y As Long, _
        ByVal fStyle As Long _
    ) As Long
Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal nIndex As Long) As Long
Private Declare Function DrawState Lib "user32" Alias "DrawStateA" _
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
Private Declare Function MulDiv Lib "kernel32" (ByVal nNumber As Long, ByVal nNumerator As Long, ByVal nDenominator As Long) As Long
Public Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Public Declare Function InflateRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
Public Declare Function FillRect Lib "user32" (ByVal hdc As Long, lpRect As RECT, ByVal hBrush As Long) As Long
Public Declare Function SetTextColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
Public Declare Function GetSysColorBrush Lib "user32" (ByVal nIndex As Long) As Long
Public Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Public Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
Public Declare Function FrameRect Lib "user32" (ByVal hdc As Long, lpRect As RECT, ByVal hBrush As Long) As Long
Public Declare Function DrawFocusRect Lib "user32" (ByVal hdc As Long, lpRect As RECT) As Long
Private Declare Function OleTranslateColor Lib "OLEPRO32.DLL" (ByVal OLE_COLOR As Long, ByVal HPALETTE As Long, pccolorref As Long) As Long
Private Const CLR_INVALID = -1
Public Declare Function DrawText Lib "user32" Alias "DrawTextA" (ByVal hdc As Long, ByVal lpStr As String, ByVal nCount As Long, lpRect As RECT, ByVal wFormat As Long) As Long
Public Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
Public Declare Function GetClientRect Lib "user32" (ByVal hWnd As Long, lpRect As RECT) As Long
Public Declare Function ImageList_GetIconSize Lib "COMCTL32" (ByVal hImageList As Long, cx As Long, cy As Long) As Long
Public Declare Function SetBkColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
Public Declare Function CreateFontIndirect Lib "gdi32" Alias "CreateFontIndirectA" (lpLogFont As LOGFONT) As Long
Public Const OPAQUE = 2
Public Const TRANSPARENT = 1
Public Declare Function SetBkMode Lib "gdi32" (ByVal hdc As Long, ByVal nBkMode As Long) As Long


Private Declare Function CreatePatternBrush Lib "gdi32" (ByVal hBitmap As Long) As Long
Private Declare Function CreateBitmap Lib "gdi32" (ByVal nWidth As Long, ByVal nHeight As Long, ByVal nPlanes As Long, ByVal nBitCount As Long, lpBits As Any) As Long
Private Declare Function SetPixel Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, ByVal crColor As Long) As Long
Private Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hdc As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long



Private m_hIml As Long
Private m_lIconSizeX As Long
Private m_lIconSizeY As Long

Private m_Fnt() As StdFont
Private m_hFnt() As Long
Private m_iFontCount As Long

Public Enum ECGTextAlignFlags
   DT_TOP = &H0&
   DT_LEFT = &H0&
   DT_CENTER = &H1&
   DT_RIGHT = &H2&
   DT_VCENTER = &H4&
   DT_BOTTOM = &H8&
   DT_WORDBREAK = &H10&
   DT_SINGLELINE = &H20&
   DT_EXPANDTABS = &H40&
   DT_TABSTOP = &H80&
   DT_NOCLIP = &H100&
   DT_EXTERNALLEADING = &H200&
   DT_CALCRECT = &H400&
   DT_NOPREFIX = &H800&
   DT_INTERNAL = &H1000&
   DT_EDITCONTROL = &H2000&
   DT_PATH_ELLIPSIS = &H4000&
   DT_END_ELLIPSIS = &H8000&
   DT_MODIFYSTRING = &H10000
   DT_RTLREADING = &H20000
   DT_WORD_ELLIPSIS = &H40000
End Enum

Private m_bBitmap As Boolean
Private m_hDCSrc As Long
Private m_lBitmapW As Long
Private m_lBitmapH As Long

Public Sub Draw3(ByRef f As Object)
  Dim tR As RECT, tTR As RECT, tBR As RECT, tFR As RECT
  Dim lHDC As Long, lHDCC As Long
  Dim hBrGrid As Long
  Dim hBr As Long
  Dim hFntOld As Long

' Relleno a blanco
'  GetClientRect f.hWnd, tR
'  lHDC = f.hdc
'  pFillBackground lHDC, tR, 0, 0, f
  
' Grilla
  Dim hbmp As Long
  Dim hMemDC  As Long

  Dim bBrushBits(4) As Integer '// bitmap bits
  Dim i As Integer
  For i = 0 To 4
    bBrushBits(i) = 255
  Next

  GetClientRect f.hWnd, tR

  Dim lResult As Long         ' lResults of our API calls

'  hMemDC = CreateCompatibleDC(lHDC)
'  hbmp = CreateBitmap(5, 5, 1, 1, bBrushBits(0))
'  'hBmp = CreateCompatibleBitmap(hMemDC, 8, 8)
'  lResult = SelectObject(hMemDC, hbmp)
'  SetPixel hMemDC, 1, 1, TranslateColor(vbBlack)
'
'  hBr = CreatePatternBrush(hbmp)
'  lHDC = f.hdc
'
'  DeleteObject hMemDC
'  DeleteObject hbmp
'
'  FillRect lHDC, tR, hBr
'  DeleteObject hBr
'
  
  
' Image
  tTR.Left = 1
  tTR.Top = 1
  tTR.Bottom = tR.Bottom
  tTR.Right = tR.Right
  Dim pic As StdPicture
  Set pic = LoadPicture("D:\Proyectos\CSImagenes\Iconos CrowSoft\New Bitmap Image.bmp")
  
  'DeleteObject SelectObject(f.hdc, pic.Handle)
  'Set Form2.Picture1.Picture = pic
  'Exit Sub
  Dim hdc As Long
  Dim hbmp2 As Long
  hdc = CreateCompatibleDC(0&)
  hbmp2 = SelectObject(hdc, pic.Handle)
  BitBlt Form2.Picture1.hdc, 0, 0, 32, 32, hdc, 0, 0, vbSrcCopy
  SelectObject hdc, hbmp2
  DeleteObject hdc
  Exit Sub

'  Form2.ImageList1.ListImages.Clear
'  Form2.ImageList1.ListImages.Add , , LoadPicture("D:\Proyectos\CSImagenes\04740.jpg")
'  m_hIml = Form2.ImageList1.hImageList
'  ImageList_GetIconSize m_hIml, m_lIconSizeX, m_lIconSizeY
'
'  DrawImage m_hIml, 0, lHDC, tTR.Left, tTR.Top, m_lIconSizeX, m_lIconSizeY, False, False, False
'  tTR.Left = 100
'  tTR.Top = 100
'  tTR.Bottom = tR.Bottom
'  tTR.Right = tR.Right
'  Form2.ImageList1.ListImages.Clear
'  Form2.ImageList1.ListImages.Add , , LoadPicture("D:\Proyectos\CSImagenes\Iconos CrowSoft\32x32-256.ico")
'  m_hIml = Form2.ImageList1.hImageList
'  ImageList_GetIconSize m_hIml, m_lIconSizeX, m_lIconSizeY
'  DrawImage m_hIml, 1, lHDC, tTR.Left, tTR.Top, 16, 16, False, False, False
'  tTR.Left = 150
'  tTR.Top = 150
'  tTR.Bottom = tR.Bottom
'  tTR.Right = tR.Right
'  Form2.ImageList1.ListImages.Clear
'  Form2.ImageList1.ListImages.Add , , LoadPicture("D:\Proyectos\CSImagenes\Iconos CrowSoft\16161.ico")
'  m_hIml = Form2.ImageList1.hImageList
'  ImageList_GetIconSize m_hIml, m_lIconSizeX, m_lIconSizeY
'  DrawImage m_hIml, 2, lHDC, tTR.Left, tTR.Top, 32, 32, False, False, False

  Exit Sub
  ' Texto
'  hFntOld = SelectObject(lHDC, m_hFnt(1))
'  SetTextColor lHDC, TranslateColor(vbHighlightText)
'  tTR.Left = 100
'  tTR.Bottom = 300
'  tTR.Right = 150
'                                              '= eTextAlign Or DT_NOPREFIX
'  DrawText lHDC, "Ja" & vbNullChar, -1, tTR, DT_SINGLELINE Or DT_WORD_ELLIPSIS Or DT_LEFT Or DT_NOPREFIX

' Cuadrado
'  hBrGrid = GetSysColorBrush(vbGrayText And &H1F&)
'  tTR.Bottom = 300
'  tTR.Right = 300
'
'  FrameRect lHDC, tTR, hBrGrid
'
  InflateRect tTR, -2, -2
'  FrameRect lHDC, tTR, hBrGrid
'
'  InflateRect tTR, -2, -2
'  FrameRect lHDC, tTR, hBrGrid
'
'  InflateRect tTR, -2, -2
'  FrameRect lHDC, tTR, hBrGrid
'
'

' Cuadrado con puntitos
'  hBrGrid = GetSysColorBrush(vbGrayText And &H1F&)

'  tFR.Left = 10
'  tFR.Top = 20
'  tFR.Bottom = 300
'  tFR.Right = 300
'  InflateRect tFR, 1, 1
'  DrawFocusRect lHDC, tFR

End Sub

Public Sub Draw2(ByRef f As Object)
  Dim tR As RECT, tTR As RECT, tBR As RECT, tFR As RECT
  Dim lHDC As Long, lHDCC As Long
  Dim hBrGrid As Long
  Dim hBr As Long
  Dim hFntOld As Long
  
  m_hIml = f.ImageList1.hImageList
  ImageList_GetIconSize m_hIml, m_lIconSizeX, m_lIconSizeY
  
  GetClientRect f.hWnd, tR
  lHDC = f.hdc
  pFillBackground lHDC, tR, 0, 0
  
  hBrGrid = GetSysColorBrush(vbGrayText And &H1F&)
  SetTextColor lHDC, TranslateColor(vbGrayText)
  
  hBr = GetSysColorBrush(vbButtonFace And &H1F&)
  InflateRect tTR, -1, -1
  FillRect lHDC, tFR, hBr
  DeleteObject hBr
                          
  hBr = CreateSolidBrush(TranslateColor(vbWhite))
  FillRect lHDC, tTR, hBr
  DeleteObject hBr
                          
  SetTextColor lHDC, TranslateColor(vbBlack)
  SetTextColor lHDC, TranslateColor(f.ForeColor)

  FrameRect lHDC, tTR, hBrGrid
  InflateRect tTR, -2, -2
  InflateRect tTR, -1, -1
  InflateRect tFR, 1, 1
  DrawFocusRect lHDC, tFR
                       
  DrawImage m_hIml, 1, lHDC, tTR.Left, tTR.Top, m_lIconSizeX, m_lIconSizeY, False, , False

  hFntOld = SelectObject(lHDC, m_hFnt(1))
                             
  SetTextColor lHDC, TranslateColor(vbHighlightText)
                                              '=
                                              'eAlign Or DT_NOPREFIX And Not DT_CALCRECT
                                              '= eTextAlign Or DT_NOPREFIX
  DrawText lHDC, "Jaja" & vbNullChar, -1, tTR, DT_SINGLELINE Or DT_WORD_ELLIPSIS Or DT_LEFT Or DT_NOPREFIX
  SetTextColor lHDC, TranslateColor(f.ForeColor)
  SetBkMode lHDC, OPAQUE
  SetBkColor lHDC, TranslateColor(f.BackColor)
  SetTextColor lHDC, TranslateColor(f.ForeColor)
  DrawText lHDC, "jaja" & vbNullChar, -1, tTR, DT_SINGLELINE Or DT_WORD_ELLIPSIS Or DT_LEFT Or DT_NOPREFIX
  SetBkMode lHDC, TRANSPARENT
  SelectObject lHDC, hFntOld
  hFntOld = 0
                          
  FrameRect lHDC, tTR, hBrGrid
  DrawFocusRect lHDC, tTR
  hBr = CreateSolidBrush(TranslateColor(vbWindowBackground))
  FillRect lHDC, tTR, hBr
  DeleteObject hBr
  DrawFocusRect lHDC, tTR
  SetTextColor lHDC, TranslateColor(vbHighlightText)
  hBr = CreateSolidBrush(TranslateColor(vbWhite))
  FillRect lHDC, tTR, hBr
  DeleteObject hBr
  SetTextColor lHDC, TranslateColor(vbBlack)
  SetTextColor lHDC, TranslateColor(f.ForeColor)
  hBr = CreateSolidBrush(TranslateColor(vbWhite))
  FillRect lHDC, tTR, hBr
  DeleteObject hBr
  SetTextColor lHDC, TranslateColor(vbBlack)
  SetTextColor lHDC, TranslateColor(vbBlack)
                    
  DrawImage m_hIml, 2, lHDC, tTR.Left, tTR.Top, m_lIconSizeX, m_lIconSizeY, False, , False
  hFntOld = SelectObject(lHDC, m_hFnt(1))
  SetTextColor lHDC, TranslateColor(vbHighlightText)
  DrawText lHDC, "Jaja", Len("Jaja"), tTR, DT_SINGLELINE Or DT_WORD_ELLIPSIS Or DT_LEFT Or DT_NOPREFIX
  SetTextColor lHDC, TranslateColor(f.ForeColor)
  SelectObject lHDC, hFntOld
  hFntOld = 0
              
  BitBlt lHDCC, 0, 0, 100, 100, lHDC, 0, 0, vbSrcCopy
  pFillBackground lHDCC, tR, 0, 0
  DeleteObject hBrGrid
  SetTextColor lHDC, TranslateColor(f.ForeColor)
End Sub

Private Sub pFillBackground( _
                            ByVal lHDC As Long, _
                            ByRef tR As RECT, _
                            ByVal lOffsetX As Long, _
                            ByVal lOffsetY As Long)
  
  TileArea lHDC, tR.Left, tR.Top, tR.Right - tR.Left, tR.Bottom - tR.Top, _
           m_hDCSrc, m_lBitmapW, m_lBitmapH, lOffsetX, lOffsetY
End Sub


Public Sub DrawImage(ByVal hIml As Long, _
                     ByVal iIndex As Long, _
                     ByVal hdc As Long, _
                     ByVal xPixels As Integer, _
                     ByVal yPixels As Integer, _
                     ByVal lIconSizeX As Long, ByVal lIconSizeY As Long, _
                     Optional ByVal bSelected = False, _
                     Optional ByVal bCut = False, _
                     Optional ByVal bDisabled = False, _
                     Optional ByVal oCutDitherColour As OLE_COLOR = vbWindowBackground, _
                     Optional ByVal hExternalIml As Long = 0)
  Dim hIcon As Long
  Dim lFlags As Long
  Dim lhIml As Long
  Dim lColor As Long
  Dim iImgIndex As Long

  ' Draw the image at 1 based index or key supplied in vKey.
  ' on the hDC at xPixels,yPixels with the supplied options.
  ' You can even draw an ImageList from another ImageList control
  ' if you supply the handle to hExternalIml with this function.
  
  iImgIndex = iIndex
  If iImgIndex > -1 Then
    If hExternalIml <> 0 Then
       lhIml = hExternalIml
    Else
       lhIml = hIml
    End If
    
    lFlags = ILD_TRANSPARENT
    If bSelected Or bCut Then
       lFlags = lFlags Or ILD_SELECTED
    End If
    
    If bCut Then
      ' Draw dithered:
      lColor = TranslateColor(oCutDitherColour)
      If lColor = -1 Then lColor = TranslateColor(vbWindowBackground)
      ImageList_DrawEx _
          lhIml, _
          iImgIndex, _
          hdc, _
          xPixels, yPixels, 0, 0, _
          CLR_NONE, lColor, _
          lFlags
    ElseIf (bDisabled) Then
      ' extract a copy of the icon:
      hIcon = ImageList_GetIcon(hIml, iImgIndex, 0)
      ' Draw it disabled at x,y:
      DrawState hdc, 0, 0, hIcon, 0, xPixels, yPixels, lIconSizeX, lIconSizeY, DST_ICON Or DSS_DISABLED
      ' Clear up the icon:
      DestroyIcon hIcon
          
    Else
      ' Standard draw:
      ImageList_Draw _
        lhIml, _
        iImgIndex, _
        hdc, _
        xPixels, _
        yPixels, _
        lFlags
    End If
  End If
End Sub

Public Function TranslateColor(ByVal oClr As OLE_COLOR, _
                        Optional hPal As Long = 0) As Long
    ' Convert Automation color to Windows color
    If OleTranslateColor(oClr, hPal, TranslateColor) Then
        TranslateColor = CLR_INVALID
    End If
End Function

Private Function plAddFontIfRequired(ByVal oFont As StdFont, ByRef f As Object) As Long
Dim iFnt As Long
Dim tULF As LOGFONT
   For iFnt = 1 To m_iFontCount
      If (oFont.Name = m_Fnt(iFnt).Name) And (oFont.Bold = m_Fnt(iFnt).Bold) And (oFont.Italic = m_Fnt(iFnt).Italic) And (oFont.Underline = m_Fnt(iFnt).Underline) And (oFont.Size = m_Fnt(iFnt).Size) And (oFont.Strikethrough = m_Fnt(iFnt).Strikethrough) Then
         plAddFontIfRequired = iFnt
         Exit Function
      End If
   Next iFnt
   m_iFontCount = m_iFontCount + 1
   ReDim Preserve m_Fnt(1 To m_iFontCount) As StdFont
   ReDim Preserve m_hFnt(1 To m_iFontCount) As Long
   Set m_Fnt(m_iFontCount) = New StdFont
   With m_Fnt(m_iFontCount)
      .Name = oFont.Name
      .Size = oFont.Size
      .Bold = oFont.Bold
      .Italic = oFont.Italic
      .Underline = oFont.Underline
      .Strikethrough = oFont.Strikethrough
   End With
   pOLEFontToLogFont m_Fnt(m_iFontCount), f.hdc, tULF
   m_hFnt(m_iFontCount) = CreateFontIndirect(tULF)
   plAddFontIfRequired = m_iFontCount
End Function

Public Sub TileArea( _
        ByVal hdc As Long, _
        ByVal x As Long, _
        ByVal y As Long, _
        ByVal Width As Long, _
        ByVal Height As Long, _
        ByVal lSrcDC As Long, _
        ByVal lBitmapW As Long, _
        ByVal lBitmapH As Long, _
        ByVal lSrcOffsetX As Long, _
        ByVal lSrcOffsetY As Long _
    )
Dim lSrcX As Long
Dim lSrcY As Long
Dim lSrcStartX As Long
Dim lSrcStartY As Long
Dim lSrcStartWidth As Long
Dim lSrcStartHeight As Long
Dim lDstX As Long
Dim lDstY As Long
Dim lDstWidth As Long
Dim lDstHeight As Long

    lSrcStartX = ((x + lSrcOffsetX) Mod lBitmapW)
    lSrcStartY = ((y + lSrcOffsetY) Mod lBitmapH)
    lSrcStartWidth = (lBitmapW - lSrcStartX)
    lSrcStartHeight = (lBitmapH - lSrcStartY)
    lSrcX = lSrcStartX
    lSrcY = lSrcStartY
    
    lDstY = y
    lDstHeight = lSrcStartHeight
    
    Do While lDstY < (y + Height)
        If (lDstY + lDstHeight) > (y + Height) Then
            lDstHeight = y + Height - lDstY
        End If
        lDstWidth = lSrcStartWidth
        lDstX = x
        lSrcX = lSrcStartX
        Do While lDstX < (x + Width)
            If (lDstX + lDstWidth) > (x + Width) Then
                lDstWidth = x + Width - lDstX
                If (lDstWidth = 0) Then
                    lDstWidth = 4
                End If
            End If
            'If (lDstWidth > Width) Then lDstWidth = Width
            'If (lDstHeight > Height) Then lDstHeight = Height
            BitBlt hdc, lDstX, lDstY, lDstWidth, lDstHeight, lSrcDC, lSrcX, lSrcY, vbSrcCopy
            lDstX = lDstX + lDstWidth
            lSrcX = 0
            lDstWidth = lBitmapW
        Loop
        lDstY = lDstY + lDstHeight
        lSrcY = 0
        lDstHeight = lBitmapH
    Loop
End Sub


Public Sub pOLEFontToLogFont(fntThis As StdFont, hdc As Long, tLF As LOGFONT)
Dim sFont As String
Dim iChar As Integer

   ' Convert an OLE StdFont to a LOGFONT structure:
   With tLF
       sFont = fntThis.Name
       ' There is a quicker way involving StrConv and CopyMemory, but
       ' this is simpler!:
       For iChar = 1 To Len(sFont)
           .lfFaceName(iChar - 1) = CByte(Asc(Mid$(sFont, iChar, 1)))
       Next iChar
       ' Based on the Win32SDK documentation:
       .lfHeight = -MulDiv((fntThis.Size), (GetDeviceCaps(hdc, LOGPIXELSY)), 72)
       .lfItalic = fntThis.Italic
       If (fntThis.Bold) Then
           .lfWeight = FW_BOLD
       Else
           .lfWeight = FW_NORMAL
       End If
       .lfUnderline = fntThis.Underline
       .lfStrikeOut = fntThis.Strikethrough
       .lfCharSet = fntThis.Charset
   End With

End Sub

Public Sub main()
  plAddFontIfRequired Form2.Label1.Font, Form2
  plAddFontIfRequired Form2.Label2.Font, Form2
  Draw3 Form2.Picture1
  Form2.Show
End Sub

Public Sub Terminate()
  Dim iFnt As Long
  For iFnt = 1 To m_iFontCount
    DeleteObject m_hFnt(iFnt)
  Next iFnt
  Draw23
End Sub

Public Sub draw(ByRef f As Object)
  Dim tR As RECT, tTR As RECT, tBR As RECT, tFR As RECT
  Dim lHDC As Long, lHDCC As Long
  
  lHDC = f.hdc
  GetClientRect f.hWnd, tR
  
  FillRect lHDC, tR, m_hBr
End Sub
Public Sub Draw23()
  DeleteObject m_hBr

End Sub
Public Sub Draw5(ByRef f As Object)
  Dim tR As RECT, tTR As RECT, tBR As RECT, tFR As RECT
  Dim lHDC As Long, lHDCC As Long
  Dim hBrGrid As Long
  Dim hBr As Long
  Dim hFntOld As Long

' Relleno a blanco
'  GetClientRect f.hWnd, tR
'  lHDC = f.hdc
'  pFillBackground lHDC, tR, 0, 0, f
  
' Grilla
  Dim hbmp As Long
  Dim hMemDC  As Long

  Dim bBrushBits(4) As Integer '// bitmap bits
  Dim i As Integer
  For i = 0 To 4
    bBrushBits(i) = 255
  Next

  Dim lResult As Long         ' lResults of our API calls

  hMemDC = CreateCompatibleDC(0)
  hbmp = CreateBitmap(5, 5, 1, 1, bBrushBits(0))
  'hBmp = CreateCompatibleBitmap(hMemDC, 8, 8)
  lResult = SelectObject(hMemDC, hbmp)
  SetPixel hMemDC, 1, 1, TranslateColor(vbBlack)

  m_hBr = CreatePatternBrush(hbmp)
  
  DeleteObject hMemDC
  DeleteObject hbmp
End Sub
