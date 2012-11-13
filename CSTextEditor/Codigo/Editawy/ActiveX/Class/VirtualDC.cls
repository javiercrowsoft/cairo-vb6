VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VirtualDC"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

Private Const LOGPIXELSX As Long = 88
Private Const LOGPIXELSY As Long = 90
Private Const LF_FACESIZE As Long = 32

Private Const CLIP_DEFAULT_PRECIS As Long = 0
Private Const OUT_DEFAULT_PRECIS As Long = 0
Private Const DEFAULT_PITCH As Long = 0
Private Const DEFAULT_QUALITY As Long = 0

Private Const FW_NORMAL As Long = 400

'Private Type POINTAPI
'    X As Long
'    Y As Long
'End Type

Private Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

Private Type LOGFONT
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

Private Type DRAWTEXTPARAMS
    cbSize As Long
    iTabLength As Long
    iLeftMargin As Long
    iRightMargin As Long
    uiLengthDrawn As Long
End Type

Private Type TEXTMETRIC
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

Private Type PALETTEENTRY
    peRed As Byte
    peGreen As Byte
    peBlue As Byte
    peFlags As Byte
End Type

Private Type LOGPALETTE
    palVersion As Integer
    palNumEntries As Integer
    palPalEntry(255) As PALETTEENTRY
End Type

Private Const RASTERCAPS As Long = 38
Private Const RC_PALETTE As Long = &H100
Private Const SIZEPALETTE As Long = 104

'Private Const BS_TRANSPARENT As Long = 0
'Private Const BS_OPAQUE As Long = 1

Public Enum BackStyles
    BS_TRANSPARENT = 0
    BS_OPAQUE = 1
End Enum

Private Declare Function GetSysColor Lib "user32" (ByVal nIndex As Long) As Long

Private Declare Function GetTextColor Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function SetTextColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
Private Declare Function GetBkColor Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function SetBkColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long

'Private Declare Function DrawText Lib "user32" Alias "DrawTextA" (ByVal hDC As Long, ByVal lpStr As String, ByVal nCount As Long, lpRect As RECT, ByVal wFormat As Long) As Long
Private Declare Function DrawTextEx Lib "user32" Alias "DrawTextExA" (ByVal hdc As Long, ByVal lpsz As String, ByVal n As Long, lpRect As RECT, ByVal un As Long, lpDrawTextParams As DRAWTEXTPARAMS) As Long

Private Declare Function GetBkMode Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function SetBkMode Lib "gdi32" (ByVal hdc As Long, ByVal nBkMode As Long) As Long

Private Declare Function CreateFontIndirect Lib "gdi32" Alias "CreateFontIndirectA" (lpLogFont As LOGFONT) As Long
Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal nIndex As Long) As Long
Private Declare Function MulDiv Lib "kernel32" (ByVal nNumber As Long, ByVal nNumerator As Long, ByVal nDenominator As Long) As Long
Private Declare Function GetTextFace Lib "gdi32" Alias "GetTextFaceA" (ByVal hdc As Long, ByVal nCount As Long, ByVal lpFacename As String) As Long
Private Declare Function GetTextMetrics Lib "gdi32" Alias "GetTextMetricsA" (ByVal hdc As Long, lpMetrics As TEXTMETRIC) As Long

Private Declare Function GetSystemPaletteEntries Lib "gdi32" (ByVal hdc As Long, ByVal wStartIndex As Long, ByVal wNumEntries As Long, lpPaletteEntries As PALETTEENTRY) As Long
Private Declare Function CreatePalette Lib "gdi32" (lpLogPalette As LOGPALETTE) As Long
Private Declare Function RealizePalette Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function SelectPalette Lib "gdi32" (ByVal hdc As Long, ByVal hPalette As Long, ByVal bForceBackground As Long) As Long

Private Declare Function GetObjectAPI Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long

Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hdc As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Private Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long

Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long

Private Declare Function CreateSolidBrush Lib "gdi32" (ByVal crColor As Long) As Long
Private Declare Function FillRect Lib "user32" (ByVal hdc As Long, lpRect As RECT, ByVal hBrush As Long) As Long

Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal XSrc As Long, ByVal YSrc As Long, ByVal dwRop As Long) As Long

Private Const SRCCOPY = &HCC0020

Private mMemoryDC As Long       ' DC handle of the created Device Context
Private mMemoryWidth As Long    ' Width of the bitmap
Private mMemoryHeight As Long   ' Height of the bitmap

Private mMemoryBitmap As Long   ' Handle of the created bitmap
Private mOrginalBitmap As Long  ' Used in Destroy

Private mMemoryPal As Long      ' Handle of the created palette
Private mOrginalPal As Long     ' Used in Destroy

Private mMemoryFont As Long     ' Font handle in use (last set)
Private mOrginalFont As Long    ' Previously selected font

Private mParentDC As Long       ' Used in Copy method as default value

Private Sub Class_Initialize()
    mMemoryDC = 0
End Sub

Private Sub Class_Terminate()
    Destroy
End Sub

Private Function GetColor(ByVal nColor As Long) As Long
    Const SYSCOLOR_BIT As Long = &H80000000
    If (nColor And SYSCOLOR_BIT) = SYSCOLOR_BIT Then
        nColor = nColor And (Not SYSCOLOR_BIT)
        GetColor = GetSysColor(nColor)
    Else
        GetColor = nColor
    End If
End Function

Public Function IsCreated() As Boolean
    IsCreated = (mMemoryDC <> 0)
End Function

Public Function Create(hParentDC As Long, Optional PixelWidth As Long = 1024, Optional PixelHeight As Long = 768) As Long
    Dim nHasPalette As Long
    Dim nPaletteSize As Long
    Dim LogPal As LOGPALETTE
    Dim tm As TEXTMETRIC
    Dim sFaceName As String * 80
    Dim fFont As StdFont

    If IsCreated Then Destroy

    mParentDC = hParentDC
    mMemoryWidth = PixelWidth
    mMemoryHeight = PixelHeight

    ' Create a memory device context to use
    mMemoryDC = CreateCompatibleDC(mParentDC)

    ' Tell'em it's a picture (so drawings can be done on the DC)
    mMemoryBitmap = CreateCompatibleBitmap(mParentDC, mMemoryWidth, mMemoryHeight)
    mOrginalBitmap = SelectObject(mMemoryDC, mMemoryBitmap)

    ' Get screen properties
    nHasPalette = GetDeviceCaps(mParentDC, RASTERCAPS) And RC_PALETTE   ' Palette support
    nPaletteSize = GetDeviceCaps(mParentDC, SIZEPALETTE)                ' Size of palette
    ' If the screen has a palette make a copy and realize it
    If nHasPalette And (nPaletteSize = 256) Then
        ' Create a copy of the system palette
        LogPal.palVersion = &H300
        LogPal.palNumEntries = 256
        Call GetSystemPaletteEntries(mParentDC, 0&, 256, LogPal.palPalEntry(0))
        mMemoryPal = CreatePalette(LogPal)
        ' Select the new palette into the memory DC and realize it
        mOrginalPal = SelectPalette(mMemoryDC, mMemoryPal, 0&)
        Call RealizePalette(mMemoryDC)
    End If

    ' Set attributes. Take from parent.
    Call SetBkColor(mMemoryDC, GetBkColor(mParentDC))
    Call SetTextColor(mMemoryDC, GetTextColor(mParentDC))
    Call SetBkMode(mMemoryDC, GetBkMode(mParentDC))

    Call GetTextMetrics(mParentDC, tm)
    Call GetTextFace(mParentDC, 79, sFaceName)
    Set fFont = New StdFont
    With fFont
        .Bold = (tm.tmWeight > FW_NORMAL)
        .Charset = tm.tmCharSet
        .Italic = (tm.tmItalic <> 0)
        .Name = sFaceName
        .Strikethrough = (tm.tmStruckOut <> 0)
        .Underline = (tm.tmUnderlined <> 0)
        .Weight = tm.tmWeight
        .Size = (tm.tmMemoryHeight / tm.tmDigitizedAspectY) * 72 ' Size has to be calculated
    End With
    Set Font = fFont
    Set fFont = Nothing

    Create = mMemoryDC
End Function

Public Sub Destroy()
    If Not IsCreated Then Exit Sub

    If mMemoryFont <> 0 Then
        ' Reset font environment
        Call SelectObject(mMemoryDC, mOrginalFont)
        Call DeleteObject(mMemoryFont)
        mMemoryFont = 0
    End If
    If mMemoryPal <> 0 Then
        ' Reset palette
        Call SelectPalette(mMemoryDC, mOrginalPal, 0&)
        Call RealizePalette(mMemoryDC)
        Call DeleteObject(mMemoryPal)
        mMemoryPal = 0
    End If
    '
    Call SelectObject(mMemoryDC, mOrginalBitmap)
    Call DeleteObject(mMemoryBitmap)
    Call DeleteDC(mMemoryDC)
    '
    mMemoryDC = -1
End Sub

Public Property Get hdc() As Long
    hdc = mMemoryDC
End Property

Public Property Get Width() As Long
    Width = mMemoryWidth
End Property

Public Property Get Height() As Long
    Height = mMemoryHeight
End Property

Public Sub Cls()
    Dim hBrush As Long
    Dim tRect As RECT

    hBrush = CreateSolidBrush(GetBkColor(mMemoryDC))
    With tRect
        .Left = 0
        .Top = 0
        .Right = mMemoryWidth
        .Bottom = mMemoryHeight
    End With

    Call FillRect(mMemoryDC, tRect, hBrush)
    Call DeleteObject(hBrush)
End Sub

Public Sub FillArea(ByVal LeftX As Long, ByVal TopY As Long, ByVal rightX As Long, ByVal bottomY As Long, ByVal RGBColor As Long)
    Dim hBrush As Long
    Dim tRect As RECT

    hBrush = CreateSolidBrush(GetColor(RGBColor))
    With tRect
        .Left = LeftX
        .Top = TopY
        .Right = rightX
        .Bottom = bottomY
    End With

    Call FillRect(mMemoryDC, tRect, hBrush)
    Call DeleteObject(hBrush)
End Sub

' Parameters:
'   X            = Left coordinate on target DC to copy to
'   Y            = Top coordinate on target DC to copy to
'   TargetWidth  = Width to use on target DC
'   TargetHeight = Height to use on target DC
'   OffsetX      = Left coordinate on virtual DC to copy from
'   OffsetY      = Top coordinate on virtual DC to copy from
'
Public Sub Paint(Optional ByVal TargetDC As Long = -1, Optional ByVal X As Long = 0, Optional ByVal Y As Long = 0, Optional ByVal TargetWidth As Long = -1, Optional ByVal TargetHeight As Long = -1, Optional ByVal OffsetX As Long = 0, Optional ByVal OffsetY As Long = 0)
    If Not IsCreated Then Exit Sub
    If TargetDC < 0 Then TargetDC = mParentDC
    If TargetWidth < 0 Then TargetWidth = mMemoryWidth
    If TargetHeight < 0 Then TargetHeight = mMemoryHeight

    BitBlt TargetDC, X, Y, TargetWidth, TargetHeight, mMemoryDC, OffsetX, OffsetY, vbSrcCopy
End Sub

Public Sub PrintText(ByVal Text As String, ByVal LeftX As Long, ByVal TopY As Long, ByVal rightX As Long, ByVal bottomY As Long, ByVal dtFlags As Long)
    Dim wTextParams As DRAWTEXTPARAMS
    Dim rc As RECT

    With rc
        .Left = LeftX
        .Top = TopY
        .Right = rightX
        .Bottom = bottomY
    End With
    wTextParams.cbSize = Len(wTextParams)

    Call DrawTextEx(mMemoryDC, Text, Len(Text), rc, dtFlags, wTextParams)
End Sub

Public Function FontHeight() As Long
    If Not IsCreated Then Exit Function

    On Local Error Resume Next

    Dim tm As TEXTMETRIC

    Call GetTextMetrics(mMemoryDC, tm)

    FontHeight = tm.tmMemoryHeight
End Function

Public Property Get Font() As StdFont
    If Not IsCreated Then Exit Property

    On Local Error Resume Next

    Dim tm As TEXTMETRIC
    Dim sFaceName As String * 80

    Call GetTextMetrics(mMemoryDC, tm)
    Call GetTextFace(mMemoryDC, 79, sFaceName)

    Set Font = New StdFont

    With Font
        .Bold = (tm.tmWeight > FW_NORMAL)
        .Charset = tm.tmCharSet
        .Italic = (tm.tmItalic <> 0)
        .Name = sFaceName 'StrConv(sFaceName, vbUnicode)
        .Strikethrough = (tm.tmStruckOut <> 0)
        .Underline = (tm.tmUnderlined <> 0)
        .Weight = tm.tmWeight
        .Size = (tm.tmMemoryHeight / tm.tmDigitizedAspectY) * 72 ' Size has to be calculated
    End With
End Property
Public Property Set Font(ByVal NewFont As StdFont)
    If Not IsCreated Then Exit Property

    On Local Error Resume Next

    Dim nName() As Byte, i As Byte, nSize As Byte
    Dim tFont As LOGFONT

    ' Font name is a byte array and is in ANSI (DOS) format (1 byte = 1 character)
    nName = StrConv(NewFont.Name & Chr$(0), vbFromUnicode)
    nSize = UBound(nName)
    If nSize > LF_FACESIZE Then nSize = LF_FACESIZE
    For i = 0 To nSize
        tFont.lfFaceName(i) = nName(i)
    Next

    With tFont
        .lfCharSet = NewFont.Charset
        .lfClipPrecision = CLIP_DEFAULT_PRECIS
        .lfEscapement = 0                       ' Angle to print
        .lfOrientation = .lfEscapement
        .lfWidth = 0#
        .lfItalic = IIf(NewFont.Italic, 1, 0)
        .lfOutPrecision = OUT_DEFAULT_PRECIS
        .lfPitchAndFamily = DEFAULT_PITCH
        .lfQuality = DEFAULT_QUALITY
        .lfStrikeOut = IIf(NewFont.Strikethrough, 1, 0)
        .lfUnderline = IIf(NewFont.Underline, 1, 0)
        .lfWeight = NewFont.Weight
        ' Font size (height) has to be calculated
        .lfHeight = MulDiv(NewFont.Size, GetDeviceCaps(mMemoryDC, LOGPIXELSY), 72)
    End With

    ' Set environment (remember previous settings)
    If mMemoryFont <> 0 Then
        ' Reset environment
        Call SelectObject(mMemoryDC, mOrginalFont)
        Call DeleteObject(mMemoryFont)
    End If
    mMemoryFont = CreateFontIndirect(tFont)
    mOrginalFont = SelectObject(mMemoryDC, mMemoryFont)
End Property

Public Sub SetFontAttributes(Optional Bold As Boolean = False, Optional Italic As Boolean = False, Optional Strikethru As Boolean = False, Optional Underline As Boolean = False)
    With Font
        .Bold = Bold
        .Italic = Italic
        .Strikethrough = Strikethru
        .Underline = Underline
    End With
End Sub

Public Property Get FontBold() As Boolean
    FontBold = Font.Bold
End Property
Public Property Let FontBold(ByVal NewValue As Boolean)
    Font.Bold = NewValue
End Property

Public Property Get FontItalic() As Boolean
    FontItalic = Font.Italic
End Property
Public Property Let FontItalic(ByVal NewValue As Boolean)
    Font.Italic = NewValue
End Property

Public Property Get FontUnderline() As Boolean
    FontUnderline = Font.Underline
End Property
Public Property Let FontUnderline(ByVal NewValue As Boolean)
    Font.Underline = NewValue
End Property

Public Property Get FontStrikethru() As Boolean
    FontStrikethru = Font.Strikethrough
End Property
Public Property Let FontStrikethru(ByVal NewValue As Boolean)
    Font.Strikethrough = NewValue
End Property

Public Property Get ForeColor() As Long
    If Not IsCreated Then Exit Property
    ForeColor = GetTextColor(mMemoryDC)
End Property
Public Property Let ForeColor(ByVal NewValue As Long)
    If Not IsCreated Then Exit Property
    Call SetTextColor(mMemoryDC, GetColor(NewValue))
End Property

Public Property Get BackColor() As Long
    If Not IsCreated Then Exit Property
    BackColor = GetBkColor(mMemoryDC)
End Property
Public Property Let BackColor(ByVal NewValue As Long)
    If Not IsCreated Then Exit Property
    Call SetBkColor(mMemoryDC, GetColor(NewValue))
End Property

Public Property Get BackStyle() As BackStyles
    If Not IsCreated Then Exit Property
    BackStyle = GetBkMode(mMemoryDC)
End Property
Public Property Let BackStyle(ByVal NewValue As BackStyles)
    If Not IsCreated Then Exit Property
    Call SetBkMode(mMemoryDC, (NewValue + 1))
End Property
