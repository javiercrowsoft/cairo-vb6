Attribute VB_Name = "modGDIPlus"
Option Explicit

' Translated by Avery P. - 7/29/2002
' NOTES:
'   - All GDI+ Strings expect and return ONLY Unicode - you'll need to use StrConv when using them or convert the APIs to use StrPtr.
'     As always, there are a few exceptions to a rule, and ImageTitles are one string that uses only ANSI strings.
'   - Functions with an I (i) at the end are non-floating point declarations.
'   - If a function without the I (i) at the end doesn't work, try the one with (if any).
'     If neither version worked, then you did something wrong, or the API *may* be misdeclared.
'   - The word (ALL) next to an API set mean all of the functions are declared. (ALL GDI+ functions are now declared 8/12/2002)
'   - Search for "TODO:" (no quotes) to see what still needs done within the file. If there is no TODO, there is nothing to do!
'   - If you want to get all of the encoder or decoder file extensions, MIME type, or other values, try to use the Get__Clsid functions as a base.
'   - If you don't like the idea of converting strings to and from Unicode, change all As String occurances in the API declarations
'     to As Long, and pass the StrPtr() result there instead. I opted to use the As String for clarity, especially since the GDI+ docs are
'     geared toward how to use the C++ classes.
'   - I may have misdeclared the IStream functions as I'm not too familiar with them. Do a "TODO:" or "IStream" search (no quotes) to see the
'     IStream functions. All parameters except one where declared as 'IStream* stream' in C++. The exception has a comment above it. The possible
'     problem is that the IStream parameters should be passed ByRef instead of ByVal. If they are wrong, please tell me!
'   - APIs are in ordered groups, just like the C++ header, but the groups themselves are not in the same order as in the C++ headers.
'
' WARNINGS:
'   - Some of the structs may not work, though I didn't test them all fully.
'   - If a function causes a GPF or performs unexpectedly, make sure you are passing correct arguments.
'     It also couldn't hurt to double-check the declarations as there is a chance they could be a bit off and looking in the MSDN can't hurt either.
'   - Some APIs that have a ByRef parameter may expect an array; check the MSDN to find out if unsure.
'
'-----------------------------------------------
' 2/6/2003
' - I suppose I should put change notifications here in case you missed them on PSC.
' - Altered the ColorPalette to have 256 color palette entries regardless and the flags member is mapped to the PaletteFlags enum.
' - ImageCodecInfo now has the flags member mapped to the ImageCodecFlags enum.
' - GdipBitmapLockBits flags parameter changed to the ImageLockMode enum instead of a Long.
' - Altered the LOGFONTW lfFaceName member to be a String, which is twice as long as the ANSI to adjust for unicode.
'   You'll want to use a StrConv on it to get the ANSI text. Also introduced a new constant to ease maintainance: LF_FACESIZEW
'-----------------------------------------------


Public Declare Function GetObjectAPI Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long

'-----------------------------------------------
' String Pointer Related APIs (For the String Utilities)
'-----------------------------------------------
Public Declare Function CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (Dest As Any, Src As Any, ByVal cb As Long) As Long
Private Declare Function lstrlenW Lib "kernel32" (ByVal psString As Any) As Long
Private Declare Function lstrlenA Lib "kernel32" (ByVal psString As Any) As Long


'-----------------------------------------------
' CLSID Generation Related APIs
'-----------------------------------------------
Private Declare Function CLSIDFromString Lib "ole32.dll" (ByVal lpszProgID As Long, pCLSID As Clsid) As Long


'-----------------------------------------------
' GDI+ Constants
'-----------------------------------------------
Public Const LF_FACESIZE As Long = 32
Public Const LF_FACESIZEW As Long = LF_FACESIZE * 2

Public Const FlatnessDefault As Single = 1# / 4#

' In-memory pixel data formats:
' bits 0-7 = format index
' bits 8-15 = pixel size (in bits)
' bits 16-23 = flags
' bits 24-31 = reserved
Public Const PixelFormatIndexed = &H10000           ' Indexes into a palette
Public Const PixelFormatGDI = &H20000               ' Is a GDI-supported format
Public Const PixelFormatAlpha = &H40000             ' Has an alpha component
Public Const PixelFormatPAlpha = &H80000            ' Pre-multiplied alpha
Public Const PixelFormatExtended = &H100000         ' Extended color 16 bits/channel
Public Const PixelFormatCanonical = &H200000

Public Const PixelFormatUndefined = 0
Public Const PixelFormatDontCare = 0

Public Const PixelFormatMax = 15 '&HF



'//---------------------------------------------------------------------------
'// Image file format identifiers
'//---------------------------------------------------------------------------
Public Const ImageFormatSuffix        As String = "-0728-11D3-9D7B-0000F81EF32E}"
Public Const ImageFormatUndefined     As String = "{B96B3CA9" & ImageFormatSuffix
Public Const ImageFormatMemoryBMP     As String = "{B96B3CAA" & ImageFormatSuffix
Public Const ImageFormatBMP           As String = "{B96B3CAB" & ImageFormatSuffix
Public Const ImageFormatEMF           As String = "{B96B3CAC" & ImageFormatSuffix
Public Const ImageFormatWMF           As String = "{B96B3CAD" & ImageFormatSuffix
Public Const ImageFormatJPEG          As String = "{B96B3CAE" & ImageFormatSuffix
Public Const ImageFormatPNG           As String = "{B96B3CAF" & ImageFormatSuffix
Public Const ImageFormatGIF           As String = "{B96B3CB0" & ImageFormatSuffix
Public Const ImageFormatTIFF          As String = "{B96B3CB1" & ImageFormatSuffix
Public Const ImageFormatEXIF          As String = "{B96B3CB2" & ImageFormatSuffix
Public Const ImageFormatIcon          As String = "{B96B3CB5" & ImageFormatSuffix
'//---------------------------------------------------------------------------
'// Predefined multi-frame dimension IDs
'//---------------------------------------------------------------------------
Public Const FrameDimensionTime       As String = "{6AEDBD6D-3FB5-418A-83A6-7F45229DC872}"
Public Const FrameDimensionResolution As String = "{84236F7B-3BD3-428F-8DAB-4EA1439CA315}"
Public Const FrameDimensionPage       As String = "{7462DC86-6180-4C7E-8E3F-EE7333A7A483}"

'//---------------------------------------------------------------------------
'// Property sets
'//---------------------------------------------------------------------------
Public Const FormatIDImageInformation As String = "{E5836CBE-5EEF-0F1D-ACDE-AE4C43B608CE}"
Public Const FormatIDJpegAppHeaders   As String = "{1C4AFDCD-6177-43CF-ABC7-5F51AF39EE85}"
'//---------------------------------------------------------------------------
'// Encoder parameter sets
'//---------------------------------------------------------------------------
Public Const EncoderCompression       As String = "{E09D739D-CCD4-44EE-8EBA-3FBF8BE4FC58}"
Public Const EncoderColorDepth        As String = "{66087055-AD66-4C7C-9A18-38A2310B8337}"
Public Const EncoderScanMethod        As String = "{3A4E2661-3109-4E56-8536-42C156E7DCFA}"
Public Const EncoderVersion           As String = "{24D18C76-814A-41A4-BF53-1C219CCCF797}"
Public Const EncoderRenderMethod      As String = "{6D42C53A-229A-4825-8BB7-5C99E2B9A8B8}"
Public Const EncoderQuality           As String = "{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}"
Public Const EncoderTransformation    As String = "{8D0EB2D1-A58E-4EA8-AA14-108074B7B6F9}"
Public Const EncoderLuminanceTable    As String = "{EDB33BCE-0266-4A77-B904-27216099E717}"
Public Const EncoderChrominanceTable  As String = "{F2E455DC-09B3-4316-8260-676ADA32481C}"
Public Const EncoderSaveFlag          As String = "{292266FC-AC40-47BF-8CFC-A85B89A655DE}"
Public Const CodecIImageBytes         As String = "{025D1823-6C7D-447B-BBDB-A3CBC3DFA2FC}"

'-----------------------------------------------
' GDI+ Structs/Types
'-----------------------------------------------

Public Type GdiplusStartupInput
   GdiplusVersion As Long              ' Must be 1 for GDI+ v1.0, the current version as of this writing.
   DebugEventCallback As Long          ' Ignored on free builds
   SuppressBackgroundThread As Long    ' FALSE unless you're prepared to call
                                       ' the hook/unhook functions properly
   SuppressExternalCodecs As Long      ' FALSE unless you want GDI+ only to use
                                       ' its internal image codecs.
End Type

' Custom types
Public Type COLORBYTES
   BlueByte As Byte
   GreenByte As Byte
   RedByte As Byte
   AlphaByte As Byte
End Type

Public Type COLORLONG
   longval As Long
End Type

'Public Type LOGFONTA
'   lfHeight As Long
'   lfWidth As Long
'   lfEscapement As Long
'   lfOrientation As Long
'   lfWeight As Long
'   lfItalic As Byte
'   lfUnderline As Byte
'   lfStrikeOut As Byte
'   lfCharSet As Byte
'   lfOutPrecision As Byte
'   lfClipPrecision As Byte
'   lfQuality As Byte
'   lfPitchAndFamily As Byte
'   lfFaceName As String * LF_FACESIZE
'End Type

'Public Type LOGFONTW
'   lfHeight As Long
'   lfWidth As Long
'   lfEscapement As Long
'   lfOrientation As Long
'   lfWeight As Long
'   lfItalic As Byte
'   lfUnderline As Byte
'   lfStrikeOut As Byte
'   lfCharSet As Byte
'   lfOutPrecision As Byte
'   lfClipPrecision As Byte
'   lfQuality As Byte
'   lfPitchAndFamily As Byte
'   lfFaceName As String * LF_FACESIZEW
'End Type

'-----------------------------------------------
' GDI+ Enums
'-----------------------------------------------

'-----------------------------------------------
' APIs
'-----------------------------------------------

Public Declare Function GdiplusStartup Lib "gdiplus" (token As Long, inputbuf As GdiplusStartupInput, Optional ByVal outputbuf As Long = 0) As GpStatus
Public Declare Function GdiplusShutdown Lib "gdiplus" (ByVal token As Long) As GpStatus

' Graphics Functions (ALL)
Public Declare Function GdipFlush Lib "gdiplus" (ByVal graphics As Long, ByVal intention As FlushIntention) As GpStatus
Public Declare Function GdipCreateFromHDC Lib "gdiplus" (ByVal hDC As Long, graphics As Long) As GpStatus
Public Declare Function GdipCreateFromHDC2 Lib "gdiplus" (ByVal hDC As Long, ByVal hDevice As Long, graphics As Long) As GpStatus
Public Declare Function GdipCreateFromHWND Lib "gdiplus" (ByVal hwnd As Long, graphics As Long) As GpStatus
Public Declare Function GdipCreateFromHWNDICM Lib "gdiplus" (ByVal hwnd As Long, graphics As Long) As GpStatus
Public Declare Function GdipDeleteGraphics Lib "gdiplus" (ByVal graphics As Long) As GpStatus
Public Declare Function GdipGetDC Lib "gdiplus" (ByVal graphics As Long, hDC As Long) As GpStatus
Public Declare Function GdipReleaseDC Lib "gdiplus" (ByVal graphics As Long, ByVal hDC As Long) As GpStatus
Public Declare Function GdipSetCompositingMode Lib "gdiplus" (ByVal graphics As Long, ByVal CompositingMd As CompositingMode) As GpStatus
Public Declare Function GdipGetCompositingMode Lib "gdiplus" (ByVal graphics As Long, CompositingMd As CompositingMode) As GpStatus
Public Declare Function GdipSetRenderingOrigin Lib "gdiplus" (ByVal graphics As Long, ByVal x As Long, ByVal y As Long) As GpStatus
Public Declare Function GdipGetRenderingOrigin Lib "gdiplus" (ByVal graphics As Long, x As Long, y As Long) As GpStatus
Public Declare Function GdipSetCompositingQuality Lib "gdiplus" (ByVal graphics As Long, ByVal CompositingQlty As CompositingQuality) As GpStatus
Public Declare Function GdipGetCompositingQuality Lib "gdiplus" (ByVal graphics As Long, CompositingQlty As CompositingQuality) As GpStatus
Public Declare Function GdipSetSmoothingMode Lib "gdiplus" (ByVal graphics As Long, ByVal SmoothingMd As SmoothingMode) As GpStatus
Public Declare Function GdipGetSmoothingMode Lib "gdiplus" (ByVal graphics As Long, SmoothingMd As SmoothingMode) As GpStatus
Public Declare Function GdipSetPixelOffsetMode Lib "gdiplus" (ByVal graphics As Long, ByVal PixOffsetMode As PixelOffsetMode) As GpStatus
Public Declare Function GdipGetPixelOffsetMode Lib "gdiplus" (ByVal graphics As Long, PixOffsetMode As PixelOffsetMode) As GpStatus
Public Declare Function GdipSetTextRenderingHint Lib "gdiplus" (ByVal graphics As Long, ByVal Mode As TextRenderingHint) As GpStatus
Public Declare Function GdipGetTextRenderingHint Lib "gdiplus" (ByVal graphics As Long, Mode As TextRenderingHint) As GpStatus
Public Declare Function GdipSetTextContrast Lib "gdiplus" (ByVal graphics As Long, ByVal contrast As Long) As GpStatus
Public Declare Function GdipGetTextContrast Lib "gdiplus" (ByVal graphics As Long, contrast As Long) As GpStatus
Public Declare Function GdipSetInterpolationMode Lib "gdiplus" (ByVal graphics As Long, ByVal interpolation As InterpolationMode) As GpStatus
Public Declare Function GdipGetInterpolationMode Lib "gdiplus" (ByVal graphics As Long, interpolation As InterpolationMode) As GpStatus
Public Declare Function GdipSetWorldTransform Lib "gdiplus" (ByVal graphics As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipResetWorldTransform Lib "gdiplus" (ByVal graphics As Long) As GpStatus
Public Declare Function GdipMultiplyWorldTransform Lib "gdiplus" (ByVal graphics As Long, ByVal matrix As Long, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipTranslateWorldTransform Lib "gdiplus" (ByVal graphics As Long, ByVal dx As Single, ByVal dy As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipScaleWorldTransform Lib "gdiplus" (ByVal graphics As Long, ByVal sx As Single, ByVal sy As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipRotateWorldTransform Lib "gdiplus" (ByVal graphics As Long, ByVal angle As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipGetWorldTransform Lib "gdiplus" (ByVal graphics As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipResetPageTransform Lib "gdiplus" (ByVal graphics As Long) As GpStatus
Public Declare Function GdipGetPageUnit Lib "gdiplus" (ByVal graphics As Long, unit As GpUnit) As GpStatus
Public Declare Function GdipGetPageScale Lib "gdiplus" (ByVal graphics As Long, sScale As Single) As GpStatus
Public Declare Function GdipSetPageUnit Lib "gdiplus" (ByVal graphics As Long, ByVal unit As GpUnit) As GpStatus
Public Declare Function GdipSetPageScale Lib "gdiplus" (ByVal graphics As Long, ByVal sScale As Single) As GpStatus
Public Declare Function GdipGetDpiX Lib "gdiplus" (ByVal graphics As Long, dpi As Single) As GpStatus
Public Declare Function GdipGetDpiY Lib "gdiplus" (ByVal graphics As Long, dpi As Single) As GpStatus
Public Declare Function GdipTransformPoints Lib "gdiplus" (ByVal graphics As Long, ByVal destSpace As CoordinateSpace, ByVal srcSpace As CoordinateSpace, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipTransformPointsI Lib "gdiplus" (ByVal graphics As Long, ByVal destSpace As CoordinateSpace, ByVal srcSpace As CoordinateSpace, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipGetNearestColor Lib "gdiplus" (ByVal graphics As Long, argb As Long) As GpStatus
' Creates the Win9x Halftone Palette (even on NT) with correct Desktop colors
Public Declare Function GdipCreateHalftonePalette Lib "gdiplus" () As Long
Public Declare Function GdipDrawLine Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x1 As Single, ByVal y1 As Single, ByVal x2 As Single, ByVal y2 As Single) As GpStatus
Public Declare Function GdipDrawLineI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long) As GpStatus
Public Declare Function GdipDrawLines Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawLinesI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawArc Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single, ByVal startAngle As Single, ByVal sweepAngle As Single) As GpStatus
Public Declare Function GdipDrawArcI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, ByVal startAngle As Single, ByVal sweepAngle As Single) As GpStatus
Public Declare Function GdipDrawBezier Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x1 As Single, ByVal y1 As Single, ByVal x2 As Single, ByVal y2 As Single, ByVal x3 As Single, ByVal y3 As Single, ByVal x4 As Single, ByVal y4 As Single) As GpStatus
Public Declare Function GdipDrawBezierI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long, ByVal x3 As Long, ByVal y3 As Long, ByVal x4 As Long, ByVal y4 As Long) As GpStatus
Public Declare Function GdipDrawBeziers Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawBeziersI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawRectangle Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single) As GpStatus
Public Declare Function GdipDrawRectangleI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long) As GpStatus
Public Declare Function GdipDrawRectangles Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, rects As RECTF, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawRectanglesI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, rects As RECTL, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawEllipse Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single) As GpStatus
Public Declare Function GdipDrawEllipseI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long) As GpStatus
Public Declare Function GdipDrawPie Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single, ByVal startAngle As Single, ByVal sweepAngle As Single) As GpStatus
Public Declare Function GdipDrawPieI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, ByVal startAngle As Single, ByVal sweepAngle As Single) As GpStatus
Public Declare Function GdipDrawPolygon Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawPolygonI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawPath Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, ByVal path As Long) As GpStatus
Public Declare Function GdipDrawCurve Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawCurveI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawCurve2 Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTF, ByVal count As Long, ByVal tension As Single) As GpStatus
Public Declare Function GdipDrawCurve2I Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTL, ByVal count As Long, ByVal tension As Single) As GpStatus
Public Declare Function GdipDrawCurve3 Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTF, ByVal count As Long, ByVal Offset As Long, ByVal numberOfSegments As Long, ByVal tension As Single) As GpStatus
Public Declare Function GdipDrawCurve3I Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTL, ByVal count As Long, ByVal Offset As Long, ByVal numberOfSegments As Long, ByVal tension As Single) As GpStatus
Public Declare Function GdipDrawClosedCurve Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawClosedCurveI Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawClosedCurve2 Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTF, ByVal count As Long, ByVal tension As Single) As GpStatus
Public Declare Function GdipDrawClosedCurve2I Lib "gdiplus" (ByVal graphics As Long, ByVal pen As Long, Points As POINTL, ByVal count As Long, ByVal tension As Single) As GpStatus
Public Declare Function GdipGraphicsClear Lib "gdiplus" (ByVal graphics As Long, ByVal lColor As Long) As GpStatus
Public Declare Function GdipFillRectangle Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single) As GpStatus
Public Declare Function GdipFillRectangleI Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long) As GpStatus
Public Declare Function GdipFillRectangles Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, rects As RECTF, ByVal count As Long) As GpStatus
Public Declare Function GdipFillRectanglesI Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, rects As RECTL, ByVal count As Long) As GpStatus
Public Declare Function GdipFillPolygon Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, Points As POINTF, ByVal count As Long, ByVal FillMd As FillMode) As GpStatus
Public Declare Function GdipFillPolygonI Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, Points As POINTL, ByVal count As Long, ByVal FillMd As FillMode) As GpStatus
Public Declare Function GdipFillPolygon2 Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipFillPolygon2I Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipFillEllipse Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single) As GpStatus
Public Declare Function GdipFillEllipseI Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long) As GpStatus
Public Declare Function GdipFillPie Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single, ByVal startAngle As Single, ByVal sweepAngle As Single) As GpStatus
Public Declare Function GdipFillPieI Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, ByVal startAngle As Single, ByVal sweepAngle As Single) As GpStatus
Public Declare Function GdipFillPath Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, ByVal path As Long) As GpStatus
Public Declare Function GdipFillClosedCurve Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipFillClosedCurveI Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipFillClosedCurve2 Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, Points As POINTF, ByVal count As Long, ByVal tension As Single, ByVal FillMd As FillMode) As GpStatus
Public Declare Function GdipFillClosedCurve2I Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, Points As POINTL, ByVal count As Long, ByVal tension As Single, ByVal FillMd As FillMode) As GpStatus
Public Declare Function GdipFillRegion Lib "gdiplus" (ByVal graphics As Long, ByVal Brush As Long, ByVal region As Long) As GpStatus
Public Declare Function GdipDrawImage Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, ByVal x As Single, ByVal y As Single) As GpStatus
Public Declare Function GdipDrawImageI Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, ByVal x As Long, ByVal y As Long) As GpStatus
Public Declare Function GdipDrawImageRect Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single) As GpStatus
Public Declare Function GdipDrawImageRectI Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long) As GpStatus
Public Declare Function GdipDrawImagePoints Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, dstpoints As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawImagePointsI Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, dstpoints As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipDrawImagePointRect Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, ByVal x As Single, _
                     ByVal y As Single, ByVal srcx As Single, ByVal srcy As Single, ByVal srcwidth As Single, ByVal srcheight As Single, ByVal srcUnit As GpUnit) As GpStatus
Public Declare Function GdipDrawImagePointRectI Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, ByVal x As Long, _
                     ByVal y As Long, ByVal srcx As Long, ByVal srcy As Long, ByVal srcwidth As Long, ByVal srcheight As Long, ByVal srcUnit As GpUnit) As GpStatus
Public Declare Function GdipDrawImageRectRect Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, ByVal dstX As Single, _
                     ByVal dstY As Single, ByVal dstWidth As Long, ByVal dstHeight As Single, _
                     ByVal srcx As Single, ByVal srcy As Single, ByVal srcwidth As Single, ByVal srcheight As Single, _
                     ByVal srcUnit As GpUnit, Optional ByVal imageAttributes As Long = 0, _
                     Optional ByVal callback As Long = 0, Optional ByVal callbackData As Long = 0) As GpStatus
' Callback declaration: Public Function DrawImageAbort(ByVal lpData as Long) as Long
Public Declare Function GdipDrawImageRectRectI Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, ByVal dstX As Long, _
                     ByVal dstY As Long, ByVal dstWidth As Long, ByVal dstHeight As Long, _
                     ByVal srcx As Long, ByVal srcy As Long, ByVal srcwidth As Long, ByVal srcheight As Long, _
                     ByVal srcUnit As GpUnit, Optional ByVal imageAttributes As Long = 0, _
                     Optional ByVal callback As Long = 0, Optional ByVal callbackData As Long = 0) As GpStatus
Public Declare Function GdipDrawImagePointsRect Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, _
                     Points As POINTF, ByVal count As Long, _
                     ByVal srcx As Single, ByVal srcy As Single, ByVal srcwidth As Single, ByVal srcheight As Single, _
                     ByVal srcUnit As GpUnit, Optional ByVal imageAttributes As Long = 0, _
                     Optional ByVal callback As Long = 0, Optional ByVal callbackData As Long = 0) As GpStatus
Public Declare Function GdipDrawImagePointsRectI Lib "gdiplus" (ByVal graphics As Long, ByVal Image As Long, _
                     Points As POINTL, ByVal count As Long, _
                     ByVal srcx As Long, ByVal srcy As Long, ByVal srcwidth As Long, ByVal srcheight As Long, _
                     ByVal srcUnit As GpUnit, Optional ByVal imageAttributes As Long = 0, _
                     Optional ByVal callback As Long = 0, Optional ByVal callbackData As Long = 0) As GpStatus
Public Declare Function GdipEnumerateMetafileDestPoint Lib "gdiplus" (ByVal graphics As Long, ByVal metafile As Long, destPoint As POINTF, lpEnumerateMetafileProc As Long, ByVal callbackData As Long, imageAttributes As Long) As GpStatus
' Callback declaration: Public Function EnumMetafilesProc(Byval rtype as EmfPlusRecordType, byval _ as Long, byval _ as Long, bytes as Any, byval callbackData as long) as long
Public Declare Function GdipEnumerateMetafileDestPointI Lib "gdiplus" (graphics As Long, ByVal metafile As Long, destPoint As POINTL, ByVal lpEnumerateMetafileProc As Long, ByVal callbackData As Long, ByVal imageAttributes As Long) As GpStatus
Public Declare Function GdipEnumerateMetafileDestRect Lib "gdiplus" (ByVal graphics As Long, ByVal metafile As Long, destRect As RECTF, lpEnumerateMetafileProc As Long, ByVal callbackData As Long, imageAttributes As Long) As GpStatus
Public Declare Function GdipEnumerateMetafileDestRectI Lib "gdiplus" (ByVal graphics As Long, ByVal metafile As Long, destRect As RECTL, lpEnumerateMetafileProc As Long, ByVal callbackData As Long, imageAttributes As Long) As GpStatus
Public Declare Function GdipEnumerateMetafileDestPoints Lib "gdiplus" (ByVal graphics As Long, ByVal metafile As Long, destPoint As POINTF, ByVal count As Long, lpEnumerateMetafileProc As Long, ByVal callbackData As Long, imageAttributes As Long) As GpStatus
Public Declare Function GdipEnumerateMetafileDestPointsI Lib "gdiplus" (ByVal graphics As Long, ByVal metafile As Long, destPoint As POINTL, ByVal count As Long, lpEnumerateMetafileProc As Long, ByVal callbackData As Long, imageAttributes As Long) As GpStatus
Public Declare Function GdipEnumerateMetafileSrcRectDestPoint Lib "gdiplus" (ByVal graphics As Long, ByVal metafile As Long, destPoint As POINTF, srcRect As RECTF, ByVal srcUnit As GpUnit, _
                     ByVal lpEnumerateMetafileProc As Long, ByVal callbackData As Long, ByVal imageAttributes As Long) As GpStatus
Public Declare Function GdipEnumerateMetafileSrcRectDestPointI Lib "gdiplus" (ByVal graphics As Long, ByVal metafile As Long, destPoint As POINTL, srcRect As RECTL, ByVal srcUnit As GpUnit, _
                     ByVal lpEnumerateMetafileProc As Long, ByVal callbackData As Long, ByVal imageAttributes As Long) As GpStatus
Public Declare Function GdipEnumerateMetafileSrcRectDestRect Lib "gdiplus" (ByVal graphics As Long, ByVal metafile As Long, destRect As RECTF, srcRect As RECTF, ByVal srcUnit As GpUnit, _
                     ByVal lpEnumerateMetafileProc As Long, ByVal callbackData As Long, ByVal imageAttributes As Long) As GpStatus
Public Declare Function GdipEnumerateMetafileSrcRectDestRectI Lib "gdiplus" (ByVal graphics As Long, ByVal metafile As Long, destRect As RECTL, srcRect As RECTL, ByVal srcUnit As GpUnit, _
                     ByVal lpEnumerateMetafileProc As Long, ByVal callbackData As Long, ByVal imageAttributes As Long) As GpStatus
Public Declare Function GdipEnumerateMetafileSrcRectDestPoints Lib "gdiplus" (ByVal graphics As Long, ByVal metafile As Long, destPoints As POINTF, ByVal count As Long, srcRect As RECTF, ByVal srcUnit As GpUnit, _
                     ByVal lpEnumerateMetafileProc As Long, ByVal callbackData As Long, ByVal imageAttributes As Long) As GpStatus
Public Declare Function GdipEnumerateMetafileSrcRectDestPointsI Lib "gdiplus" (ByVal graphics As Long, ByVal metafile As Long, destPoints As POINTL, ByVal count As Long, srcRect As RECTL, ByVal srcUnit As GpUnit, _
                     ByVal lpEnumerateMetafileProc As Long, ByVal callbackData As Long, ByVal imageAttributes As Long) As GpStatus
Public Declare Function GdipPlayMetafileRecord Lib "gdiplus" (ByVal metafile As Long, ByVal recordType As EmfPlusRecordType, ByVal flags As Long, ByVal dataSize As Long, byteData As Any) As GpStatus
Public Declare Function GdipSetClipGraphics Lib "gdiplus" (ByVal graphics As Long, ByVal srcgraphics As Long, ByVal CombineMd As CombineMode) As GpStatus
Public Declare Function GdipSetClipRect Lib "gdiplus" (ByVal graphics As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single, ByVal CombineMd As CombineMode) As GpStatus
Public Declare Function GdipSetClipRectI Lib "gdiplus" (ByVal graphics As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, ByVal CombineMd As CombineMode) As GpStatus
Public Declare Function GdipSetClipPath Lib "gdiplus" (ByVal graphics As Long, ByVal path As Long, ByVal CombineMd As CombineMode) As GpStatus
Public Declare Function GdipSetClipRegion Lib "gdiplus" (ByVal graphics As Long, ByVal region As Long, ByVal CombineMd As CombineMode) As GpStatus
Public Declare Function GdipSetClipHrgn Lib "gdiplus" (ByVal graphics As Long, ByVal hRgn As Long, ByVal CombineMd As CombineMode) As GpStatus
Public Declare Function GdipResetClip Lib "gdiplus" (ByVal graphics As Long) As GpStatus
Public Declare Function GdipTranslateClip Lib "gdiplus" (ByVal graphics As Long, ByVal dx As Single, ByVal dy As Single) As GpStatus
Public Declare Function GdipTranslateClipI Lib "gdiplus" (ByVal graphics As Long, ByVal dx As Long, ByVal dy As Long) As GpStatus
Public Declare Function GdipGetClip Lib "gdiplus" (ByVal graphics As Long, ByVal region As Long) As GpStatus
Public Declare Function GdipGetClipBounds Lib "gdiplus" (ByVal graphics As Long, rect As RECTF) As GpStatus
Public Declare Function GdipGetClipBoundsI Lib "gdiplus" (ByVal graphics As Long, rect As RECTL) As GpStatus
Public Declare Function GdipIsClipEmpty Lib "gdiplus" (ByVal graphics As Long, result As Long) As GpStatus
Public Declare Function GdipGetVisibleClipBounds Lib "gdiplus" (ByVal graphics As Long, rect As RECTF) As GpStatus
Public Declare Function GdipGetVisibleClipBoundsI Lib "gdiplus" (ByVal graphics As Long, rect As RECTL) As GpStatus
Public Declare Function GdipIsVisibleClipEmpty Lib "gdiplus" (ByVal graphics As Long, result As Long) As GpStatus
Public Declare Function GdipIsVisiblePoint Lib "gdiplus" (ByVal graphics As Long, ByVal x As Single, ByVal y As Single, result As Long) As GpStatus
Public Declare Function GdipIsVisiblePointI Lib "gdiplus" (ByVal graphics As Long, ByVal x As Long, ByVal y As Long, result As Long) As GpStatus
Public Declare Function GdipIsVisibleRect Lib "gdiplus" (ByVal graphics As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single, result As Long) As GpStatus
Public Declare Function GdipIsVisibleRectI Lib "gdiplus" (ByVal graphics As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, result As Long) As GpStatus
Public Declare Function GdipSaveGraphics Lib "gdiplus" (ByVal graphics As Long, state As Long) As GpStatus
Public Declare Function GdipRestoreGraphics Lib "gdiplus" (ByVal graphics As Long, ByVal state As Long) As GpStatus
Public Declare Function GdipBeginContainer Lib "gdiplus" (ByVal graphics As Long, dstRect As RECTF, srcRect As RECTF, ByVal unit As GpUnit, state As Long) As GpStatus
Public Declare Function GdipBeginContainerI Lib "gdiplus" (ByVal graphics As Long, dstRect As RECTL, srcRect As RECTL, ByVal unit As GpUnit, state As Long) As GpStatus
Public Declare Function GdipBeginContainer2 Lib "gdiplus" (ByVal graphics As Long, state As Long) As GpStatus
Public Declare Function GdipEndContainer Lib "gdiplus" (ByVal graphics As Long, ByVal state As Long) As GpStatus
Public Declare Function GdipGetMetafileHeaderFromWmf Lib "gdiplus" (ByVal hWmf As Long, WmfPlaceableFileHdr As WmfPlaceableFileHeader, header As MetafileHeader) As GpStatus
Public Declare Function GdipGetMetafileHeaderFromEmf Lib "gdiplus" (ByVal hEmf As Long, header As MetafileHeader) As GpStatus
Public Declare Function GdipGetMetafileHeaderFromFile Lib "gdiplus" (ByVal filename As String, header As MetafileHeader) As GpStatus
' TODO: Uncomment if you have the IStream object declared, or equivalent
'Public Declare Function GdipGetMetafileHeaderFromStream Lib "gdiplus" (ByVal stream As IStream, header As MetafileHeader) As GpStatus
Public Declare Function GdipGetMetafileHeaderFromMetafile Lib "gdiplus" (ByVal metafile As Long, header As MetafileHeader) As GpStatus
Public Declare Function GdipGetHemfFromMetafile Lib "gdiplus" (ByVal metafile As Long, hEmf As Long) As GpStatus
' TODO: Uncomment if you have the IStream object declared, or equivalent
' NOTE: The C++ stream parameter was declared as IStream** stream
'Public Declare Function GdipCreateStreamOnFile Lib "gdiplus" (ByVal filename As String, ByVal access As Long, stream As IStream) As GpStatus
Public Declare Function GdipCreateMetafileFromWmf Lib "gdiplus" (ByVal hWmf As Long, ByVal bDeleteWmf As Long, WmfPlaceableFileHdr As WmfPlaceableFileHeader, ByVal metafile As Long) As GpStatus
Public Declare Function GdipCreateMetafileFromEmf Lib "gdiplus" (ByVal hEmf As Long, ByVal bDeleteEmf As Long, metafile As Long) As GpStatus
Public Declare Function GdipCreateMetafileFromFile Lib "gdiplus" (byvalfile As String, metafile As Long) As GpStatus
Public Declare Function GdipCreateMetafileFromWmfFile Lib "gdiplus" (ByVal file As String, WmfPlaceableFileHdr As WmfPlaceableFileHeader, metafile As Long) As GpStatus
' TODO: Uncomment if you have the IStream object declared, or equivalent
'Public Declare Function GdipCreateMetafileFromStream Lib "gdiplus" (ByVal stream As IStream, metafile As Long) As GpStatus
Public Declare Function GdipRecordMetafile Lib "gdiplus" (ByVal referenceHdc As Long, etype As EmfType, frameRect As RECTF, ByVal frameUnit As MetafileFrameUnit, ByVal description As String, metafile As Long) As GpStatus
Public Declare Function GdipRecordMetafileI Lib "gdiplus" (ByVal referenceHdc As Long, etype As EmfType, frameRect As RECTL, ByVal frameUnit As MetafileFrameUnit, ByVal description As String, metafile As Long) As GpStatus
Public Declare Function GdipRecordMetafileFileName Lib "gdiplus" (ByVal filename As String, ByVal referenceHdc As Long, etype As EmfType, frameRect As RECTF, ByVal frameUnit As MetafileFrameUnit, ByVal description As String, metafile As Long) As GpStatus
Public Declare Function GdipRecordMetafileFileNameI Lib "gdiplus" (ByVal filename As String, ByVal referenceHdc As Long, etype As EmfType, frameRect As RECTL, ByVal frameUnit As MetafileFrameUnit, ByVal description As String, metafile As Long) As GpStatus
' TODO: Uncomment if you have the IStream object declared, or equivalent
'Public Declare Function GdipRecordMetafileStream Lib "gdiplus" (ByVal stream As IStream, ByVal referenceHdc As Long, etype As EmfType, frameRect As RECTF, ByVal frameUnit As MetafileFrameUnit, ByVal description As String, metafile As Long) As GpStatus
'Public Declare Function GdipRecordMetafileStreamI Lib "gdiplus" (ByVal stream As IStream, ByVal referenceHdc As Long, etype As EmfType, frameRect As RECTL, ByVal frameUnit As MetafileFrameUnit, ByVal description As String, metafile As Long) As GpStatus
Public Declare Function GdipSetMetafileDownLevelRasterizationLimit Lib "gdiplus" (ByVal metafile As Long, ByVal metafileRasterizationLimitDpi As Long) As GpStatus
Public Declare Function GdipGetMetafileDownLevelRasterizationLimit Lib "gdiplus" (ByVal metafile As Long, metafileRasterizationLimitDpi As Long) As GpStatus
' NOTE: These encoders/decoders functions expect an ImageCodecInfo array
Public Declare Function GdipGetImageDecodersSize Lib "gdiplus" (numDecoders As Long, size As Long) As GpStatus
Public Declare Function GdipGetImageDecoders Lib "gdiplus" (ByVal numDecoders As Long, ByVal size As Long, decoders As Any) As GpStatus
Public Declare Function GdipGetImageEncodersSize Lib "gdiplus" (numEncoders As Long, size As Long) As GpStatus
Public Declare Function GdipGetImageEncoders Lib "gdiplus" (ByVal numEncoders As Long, ByVal size As Long, encoders As Any) As GpStatus
Public Declare Function GdipComment Lib "gdiplus" (ByVal graphics As Long, ByVal sizeData As Long, data As Any) As GpStatus

' Image Functions (ALL)
Public Declare Function GdipLoadImageFromFile Lib "gdiplus" (ByVal filename As String, Image As Long) As GpStatus
Public Declare Function GdipLoadImageFromFileICM Lib "gdiplus" (ByVal filename As String, Image As Long) As GpStatus
' TODO: Uncomment if you have the IStream object declared, or equivalent
'Public Declare Function GdipLoadImageFromStream Lib "gdiplus" (ByVal stream As IStream, Image As Long) As GpStatus
'Public Declare Function GdipLoadImageFromStreamICM Lib "gdiplus" (ByVal stream As IStream, Image As Long) As GpStatus
Public Declare Function GdipDisposeImage Lib "gdiplus" (ByVal Image As Long) As GpStatus
Public Declare Function GdipCloneImage Lib "gdiplus" (ByVal Image As Long, cloneImage As Long) As GpStatus
' NOTE: The encoderParams parameter expects a EncoderParameters struct or a NULL
Public Declare Function GdipSaveImageToFile Lib "gdiplus" (ByVal Image As Long, ByVal filename As String, clsidEncoder As Clsid, encoderParams As Any) As GpStatus
' TODO: Uncomment if you have the IStream object declared, or equivalent
'Public Declare Function GdipSaveImageToStream Lib "gdiplus" (ByVal Image As Long, ByVal stream As IStream, clsidEncoder As Clsid, encoderParams As Any) As GpStatus
Public Declare Function GdipSaveAdd Lib "gdiplus" (ByVal Image As Long, encoderParams As EncoderParameters) As GpStatus
Public Declare Function GdipSaveAddImage Lib "gdiplus" (ByVal Image As Long, ByVal newImage As Long, encoderParams As EncoderParameters) As GpStatus
Public Declare Function GdipGetImageGraphicsContext Lib "gdiplus" (ByVal Image As Long, graphics As Long) As GpStatus
Public Declare Function GdipGetImageBounds Lib "gdiplus" (ByVal Image As Long, srcRect As RECTF, srcUnit As GpUnit) As GpStatus
Public Declare Function GdipGetImageDimension Lib "gdiplus" (ByVal Image As Long, Width As Single, Height As Single) As GpStatus
Public Declare Function GdipGetImageType Lib "gdiplus" (ByVal Image As Long, itype As Image_Type) As GpStatus
Public Declare Function GdipGetImageWidth Lib "gdiplus" (ByVal Image As Long, Width As Long) As GpStatus
Public Declare Function GdipGetImageHeight Lib "gdiplus" (ByVal Image As Long, Height As Long) As GpStatus
Public Declare Function GdipGetImageHorizontalResolution Lib "gdiplus" (ByVal Image As Long, resolution As Single) As GpStatus
Public Declare Function GdipGetImageVerticalResolution Lib "gdiplus" (ByVal Image As Long, resolution As Single) As GpStatus
Public Declare Function GdipGetImageFlags Lib "gdiplus" (ByVal Image As Long, flags As Long) As GpStatus
Public Declare Function GdipGetImageRawFormat Lib "gdiplus" (ByVal Image As Long, format As Clsid) As GpStatus
Public Declare Function GdipGetImagePixelFormat Lib "gdiplus" (ByVal Image As Long, PixelFormat As Long) As GpStatus
Public Declare Function GdipGetImageThumbnail Lib "gdiplus" (ByVal Image As Long, ByVal thumbWidth As Long, ByVal thumbHeight As Long, thumbImage As Long, _
                        Optional ByVal callback As Long = 0, Optional ByVal callbackData As Long = 0) As GpStatus
Public Declare Function GdipGetEncoderParameterListSize Lib "gdiplus" (ByVal Image As Long, clsidEncoder As Clsid, size As Long) As GpStatus
Public Declare Function GdipGetEncoderParameterList Lib "gdiplus" (ByVal Image As Long, clsidEncoder As Clsid, ByVal size As Long, buffer As EncoderParameters) As GpStatus
Public Declare Function GdipImageGetFrameDimensionsCount Lib "gdiplus" (ByVal Image As Long, count As Long) As GpStatus
Public Declare Function GdipImageGetFrameDimensionsList Lib "gdiplus" (ByVal Image As Long, dimensionIDs As Clsid, ByVal count As Long) As GpStatus
Public Declare Function GdipImageGetFrameCount Lib "gdiplus" (ByVal Image As Long, dimensionID As Clsid, count As Long) As GpStatus
Public Declare Function GdipImageSelectActiveFrame Lib "gdiplus" (ByVal Image As Long, dimensionID As Clsid, ByVal frameIndex As Long) As GpStatus
Public Declare Function GdipImageRotateFlip Lib "gdiplus" (ByVal Image As Long, ByVal rfType As RotateFlipType) As GpStatus
Public Declare Function GdipGetImagePalette Lib "gdiplus" (ByVal Image As Long, palette As ColorPalette, ByVal size As Long) As GpStatus
Public Declare Function GdipSetImagePalette Lib "gdiplus" (ByVal Image As Long, palette As ColorPalette) As GpStatus
Public Declare Function GdipGetImagePaletteSize Lib "gdiplus" (ByVal Image As Long, size As Long) As GpStatus
Public Declare Function GdipGetPropertyCount Lib "gdiplus" (ByVal Image As Long, numOfProperty As Long) As GpStatus
Public Declare Function GdipGetPropertyIdList Lib "gdiplus" (ByVal Image As Long, ByVal numOfProperty As Long, list As Long) As GpStatus
Public Declare Function GdipGetPropertyItemSize Lib "gdiplus" (ByVal Image As Long, ByVal propId As Long, size As Long) As GpStatus
Public Declare Function GdipGetPropertyItem Lib "gdiplus" (ByVal Image As Long, ByVal propId As Long, ByVal propSize As Long, buffer As PropertyItem) As GpStatus
Public Declare Function GdipGetPropertySize Lib "gdiplus" (ByVal Image As Long, totalBufferSize As Long, numProperties As Long) As GpStatus
Public Declare Function GdipGetAllPropertyItems Lib "gdiplus" (ByVal Image As Long, ByVal totalBufferSize As Long, ByVal numProperties As Long, allItems As PropertyItem) As GpStatus
Public Declare Function GdipRemovePropertyItem Lib "gdiplus" (ByVal Image As Long, ByVal propId As Long) As GpStatus
Public Declare Function GdipSetPropertyItem Lib "gdiplus" (ByVal Image As Long, Item As PropertyItem) As GpStatus
Public Declare Function GdipImageForceValidation Lib "gdiplus" (ByVal Image As Long) As GpStatus

' Pen Functions (ALL)
Public Declare Function GdipCreatePen1 Lib "gdiplus" (ByVal color As Long, ByVal Width As Single, ByVal unit As GpUnit, pen As Long) As GpStatus
Public Declare Function GdipCreatePen2 Lib "gdiplus" (ByVal Brush As Long, ByVal Width As Single, ByVal unit As GpUnit, pen As Long) As GpStatus
Public Declare Function GdipClonePen Lib "gdiplus" (ByVal pen As Long, clonepen As Long) As GpStatus
Public Declare Function GdipDeletePen Lib "gdiplus" (ByVal pen As Long) As GpStatus
Public Declare Function GdipSetPenWidth Lib "gdiplus" (ByVal pen As Long, ByVal Width As Single) As GpStatus
Public Declare Function GdipGetPenWidth Lib "gdiplus" (ByVal pen As Long, Width As Single) As GpStatus
Public Declare Function GdipSetPenUnit Lib "gdiplus" (ByVal pen As Long, ByVal unit As GpUnit) As GpStatus
Public Declare Function GdipGetPenUnit Lib "gdiplus" (ByVal pen As Long, unit As GpUnit) As GpStatus
Public Declare Function GdipSetPenLineCap Lib "gdiplus" Alias "GdipSetPenLineCap197819" (ByVal pen As Long, ByVal startCap As LineCap, ByVal endCap As LineCap, ByVal dcap As DashCap) As GpStatus
Public Declare Function GdipSetPenStartCap Lib "gdiplus" (ByVal pen As Long, ByVal startCap As LineCap) As GpStatus
Public Declare Function GdipSetPenEndCap Lib "gdiplus" (ByVal pen As Long, ByVal endCap As LineCap) As GpStatus
Public Declare Function GdipSetPenDashCap Lib "gdiplus" Alias "GdipSetPenDashCap197819" (ByVal pen As Long, ByVal dcap As DashCap) As GpStatus
Public Declare Function GdipGetPenStartCap Lib "gdiplus" (ByVal pen As Long, startCap As LineCap) As GpStatus
Public Declare Function GdipGetPenEndCap Lib "gdiplus" (ByVal pen As Long, endCap As LineCap) As GpStatus
Public Declare Function GdipGetPenDashCap Lib "gdiplus" Alias "GdipGetPenDashCap197819" (ByVal pen As Long, dcap As DashCap) As GpStatus
Public Declare Function GdipSetPenLineJoin Lib "gdiplus" (ByVal pen As Long, ByVal lnJoin As LineJoin) As GpStatus
Public Declare Function GdipGetPenLineJoin Lib "gdiplus" (ByVal pen As Long, lnJoin As LineJoin) As GpStatus
Public Declare Function GdipSetPenCustomStartCap Lib "gdiplus" (ByVal pen As Long, ByVal customCap As Long) As GpStatus
Public Declare Function GdipGetPenCustomStartCap Lib "gdiplus" (ByVal pen As Long, customCap As Long) As GpStatus
Public Declare Function GdipSetPenCustomEndCap Lib "gdiplus" (ByVal pen As Long, ByVal customCap As Long) As GpStatus
Public Declare Function GdipGetPenCustomEndCap Lib "gdiplus" (ByVal pen As Long, customCap As Long) As GpStatus
Public Declare Function GdipSetPenMiterLimit Lib "gdiplus" (ByVal pen As Long, ByVal miterLimit As Single) As GpStatus
Public Declare Function GdipGetPenMiterLimit Lib "gdiplus" (ByVal pen As Long, miterLimit As Single) As GpStatus
Public Declare Function GdipSetPenMode Lib "gdiplus" (ByVal pen As Long, ByVal penMode As PenAlignment) As GpStatus
Public Declare Function GdipGetPenMode Lib "gdiplus" (ByVal pen As Long, penMode As PenAlignment) As GpStatus
Public Declare Function GdipSetPenTransform Lib "gdiplus" (ByVal pen As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipGetPenTransform Lib "gdiplus" (ByVal pen As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipResetPenTransform Lib "gdiplus" (ByVal pen As Long) As GpStatus
Public Declare Function GdipMultiplyPenTransform Lib "gdiplus" (ByVal pen As Long, ByVal matrix As Long, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipTranslatePenTransform Lib "gdiplus" (ByVal pen As Long, ByVal dx As Single, ByVal dy As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipScalePenTransform Lib "gdiplus" (ByVal pen As Long, ByVal sx As Single, ByVal sy As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipRotatePenTransform Lib "gdiplus" (ByVal pen As Long, ByVal angle As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipSetPenColor Lib "gdiplus" (ByVal pen As Long, ByVal argb As Long) As GpStatus
Public Declare Function GdipGetPenColor Lib "gdiplus" (ByVal pen As Long, argb As Long) As GpStatus
Public Declare Function GdipSetPenBrushFill Lib "gdiplus" (ByVal pen As Long, ByVal Brush As Long) As GpStatus
Public Declare Function GdipGetPenBrushFill Lib "gdiplus" (ByVal pen As Long, Brush As Long) As GpStatus
Public Declare Function GdipGetPenFillType Lib "gdiplus" (ByVal pen As Long, ptype As PenType) As GpStatus
Public Declare Function GdipGetPenDashStyle Lib "gdiplus" (ByVal pen As Long, dStyle As DashStyle) As GpStatus
Public Declare Function GdipSetPenDashStyle Lib "gdiplus" (ByVal pen As Long, ByVal dStyle As DashStyle) As GpStatus
Public Declare Function GdipGetPenDashOffset Lib "gdiplus" (ByVal pen As Long, Offset As Single) As GpStatus
Public Declare Function GdipSetPenDashOffset Lib "gdiplus" (ByVal pen As Long, ByVal Offset As Single) As GpStatus
Public Declare Function GdipGetPenDashCount Lib "gdiplus" (ByVal pen As Long, count As Long) As GpStatus
Public Declare Function GdipSetPenDashArray Lib "gdiplus" (ByVal pen As Long, dash As Single, ByVal count As Long) As GpStatus
Public Declare Function GdipGetPenDashArray Lib "gdiplus" (ByVal pen As Long, dash As Single, ByVal count As Long) As GpStatus
Public Declare Function GdipGetPenCompoundCount Lib "gdiplus" (ByVal pen As Long, count As Long) As GpStatus
Public Declare Function GdipSetPenCompoundArray Lib "gdiplus" (ByVal pen As Long, dash As Single, ByVal count As Long) As GpStatus
Public Declare Function GdipGetPenCompoundArray Lib "gdiplus" (ByVal pen As Long, dash As Single, ByVal count As Long) As GpStatus

' CustomLineCap Functions (ALL)
Public Declare Function GdipCreateCustomLineCap Lib "gdiplus" (ByVal fillPath As Long, ByVal strokePath As Long, ByVal baseCap As LineCap, ByVal baseInset As Single, customCap As Long) As GpStatus
Public Declare Function GdipDeleteCustomLineCap Lib "gdiplus" (ByVal customCap As Long) As GpStatus
Public Declare Function GdipCloneCustomLineCap Lib "gdiplus" (ByVal customCap As Long, clonedCap As Long) As GpStatus
Public Declare Function GdipGetCustomLineCapType Lib "gdiplus" (ByVal customCap As Long, capType As CustomLineCapType) As GpStatus
Public Declare Function GdipSetCustomLineCapStrokeCaps Lib "gdiplus" (ByVal customCap As Long, ByVal startCap As LineCap, ByVal endCap As LineCap) As GpStatus
Public Declare Function GdipGetCustomLineCapStrokeCaps Lib "gdiplus" (ByVal customCap As Long, startCap As LineCap, endCap As LineCap) As GpStatus
Public Declare Function GdipSetCustomLineCapStrokeJoin Lib "gdiplus" (ByVal customCap As Long, ByVal lnJoin As LineJoin) As GpStatus
Public Declare Function GdipGetCustomLineCapStrokeJoin Lib "gdiplus" (ByVal customCap As Long, lnJoin As LineJoin) As GpStatus
Public Declare Function GdipSetCustomLineCapBaseCap Lib "gdiplus" (ByVal customCap As Long, ByVal baseCap As LineCap) As GpStatus
Public Declare Function GdipGetCustomLineCapBaseCap Lib "gdiplus" (ByVal customCap As Long, baseCap As LineCap) As GpStatus
Public Declare Function GdipSetCustomLineCapBaseInset Lib "gdiplus" (ByVal customCap As Long, ByVal inset As Single) As GpStatus
Public Declare Function GdipGetCustomLineCapBaseInset Lib "gdiplus" (ByVal customCap As Long, inset As Single) As GpStatus
Public Declare Function GdipSetCustomLineCapWidthScale Lib "gdiplus" (ByVal customCap As Long, ByVal widthScale As Single) As GpStatus
Public Declare Function GdipGetCustomLineCapWidthScale Lib "gdiplus" (ByVal customCap As Long, widthScale As Single) As GpStatus

' AdjustableArrowCap Functions (ALL)
Public Declare Function GdipCreateAdjustableArrowCap Lib "gdiplus" (ByVal Height As Single, ByVal Width As Single, ByVal isFilled As Long, cap As Long) As GpStatus
Public Declare Function GdipSetAdjustableArrowCapHeight Lib "gdiplus" (ByVal cap As Long, ByVal Height As Single) As GpStatus
Public Declare Function GdipGetAdjustableArrowCapHeight Lib "gdiplus" (ByVal cap As Long, Height As Single) As GpStatus
Public Declare Function GdipSetAdjustableArrowCapWidth Lib "gdiplus" (ByVal cap As Long, ByVal Width As Single) As GpStatus
Public Declare Function GdipGetAdjustableArrowCapWidth Lib "gdiplus" (ByVal cap As Long, Width As Single) As GpStatus
Public Declare Function GdipSetAdjustableArrowCapMiddleInset Lib "gdiplus" (ByVal cap As Long, ByVal middleInset As Single) As GpStatus
Public Declare Function GdipGetAdjustableArrowCapMiddleInset Lib "gdiplus" (ByVal cap As Long, middleInset As Single) As GpStatus
Public Declare Function GdipSetAdjustableArrowCapFillState Lib "gdiplus" (ByVal cap As Long, ByVal bFillState As Long) As GpStatus
Public Declare Function GdipGetAdjustableArrowCapFillState Lib "gdiplus" (ByVal cap As Long, bFillState As Long) As GpStatus

' Bitmap Functions (ALL)
' KhanChanged
'Public Declare Function GdipCreateBitmapFromFile Lib "gdiplus" (ByVal filename As Long, bitmap As Long) As GpStatus
'Public Declare Function GdipCreateBitmapFromFileICM Lib "gdiplus" (ByVal filename As Long, bitmap As Long) As GpStatus
Public Declare Function GdipCreateBitmapFromFile Lib "gdiplus" (ByVal filename As String, bitmap As Long) As GpStatus
Public Declare Function GdipCreateBitmapFromFileICM Lib "gdiplus" (ByVal filename As String, bitmap As Long) As GpStatus
' TODO: Uncomment if you have the IStream object declared, or equivalent
'Public Declare Function GdipCreateBitmapFromStream Lib "gdiplus" (ByVal stream As IStream, bitmap As Long) As GpStatus
'Public Declare Function GdipCreateBitmapFromStreamICM Lib "gdiplus" (ByVal stream As IStream, bitmap As Long) As GpStatus
' NOTE: The scan0 parameter is treated as a byte array
Public Declare Function GdipCreateBitmapFromScan0 Lib "gdiplus" (ByVal Width As Long, ByVal Height As Long, ByVal stride As Long, ByVal PixelFormat As Long, scan0 As Any, bitmap As Long) As GpStatus
Public Declare Function GdipCreateBitmapFromGraphics Lib "gdiplus" (ByVal Width As Long, ByVal Height As Long, ByVal graphics As Long, bitmap As Long) As GpStatus
' TODO: Uncomment if DirectX is in your program
'Public Declare Function GdipCreateBitmapFromDirectDrawSurface Lib "gdiplus" (surface As DirectDrawSurface7, bitmap As Long) As GpStatus
Public Declare Function GdipCreateBitmapFromGdiDib Lib "gdiplus" (gdiBitmapInfo As BITMAPINFO, ByVal gdiBitmapData As Long, bitmap As Long) As GpStatus
Public Declare Function GdipCreateBitmapFromHBITMAP Lib "gdiplus" (ByVal hbm As Long, ByVal hpal As Long, bitmap As Long) As GpStatus
Public Declare Function GdipCreateHBITMAPFromBitmap Lib "gdiplus" (ByVal bitmap As Long, hbmReturn As Long, ByVal background As Long) As GpStatus
Public Declare Function GdipCreateBitmapFromHICON Lib "gdiplus" (ByVal hicon As Long, bitmap As Long) As GpStatus
Public Declare Function GdipCreateHICONFromBitmap Lib "gdiplus" (ByVal bitmap As Long, hbmReturn As Long) As GpStatus
Public Declare Function GdipCreateBitmapFromResource Lib "gdiplus" (ByVal hInstance As Long, ByVal lpBitmapName As String, bitmap As Long) As GpStatus
Public Declare Function GdipCloneBitmapArea Lib "gdiplus" (ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single, ByVal PixelFormat As Long, ByVal srcBitmap As Long, dstBitmap As Long) As GpStatus
Public Declare Function GdipCloneBitmapAreaI Lib "gdiplus" (ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, ByVal PixelFormat As Long, ByVal srcBitmap As Long, dstBitmap As Long) As GpStatus
Public Declare Function GdipBitmapLockBits Lib "gdiplus" (ByVal bitmap As Long, rect As RECTL, ByVal flags As ImageLockMode, ByVal PixelFormat As Long, lockedBitmapData As BitmapData) As GpStatus
Public Declare Function GdipBitmapUnlockBits Lib "gdiplus" (ByVal bitmap As Long, lockedBitmapData As BitmapData) As GpStatus
Public Declare Function GdipBitmapGetPixel Lib "gdiplus" (ByVal bitmap As Long, ByVal x As Long, ByVal y As Long, color As Long) As GpStatus
Public Declare Function GdipBitmapSetPixel Lib "gdiplus" (ByVal bitmap As Long, ByVal x As Long, ByVal y As Long, ByVal color As Long) As GpStatus
Public Declare Function GdipBitmapSetResolution Lib "gdiplus" (ByVal bitmap As Long, ByVal xdpi As Single, ByVal ydpi As Single) As GpStatus

' CachedBitmap Functions (ALL)
Public Declare Function GdipCreateCachedBitmap Lib "gdiplus" (ByVal bitmap As Long, ByVal graphics As Long, cachedBitmap As Long) As GpStatus
Public Declare Function GdipDeleteCachedBitmap Lib "gdiplus" (ByVal cachedBitmap As Long) As GpStatus
Public Declare Function GdipDrawCachedBitmap Lib "gdiplus" (ByVal graphics As Long, ByVal cachedBitmap As Long, ByVal x As Long, ByVal y As Long) As GpStatus

' Brush Functions (ALL)
Public Declare Function GdipCloneBrush Lib "gdiplus" (ByVal Brush As Long, cloneBrush As Long) As GpStatus
Public Declare Function GdipDeleteBrush Lib "gdiplus" (ByVal Brush As Long) As GpStatus
Public Declare Function GdipGetBrushType Lib "gdiplus" (ByVal Brush As Long, brshType As BrushType) As GpStatus

' HatchBrush Functions (ALL)
Public Declare Function GdipCreateHatchBrush Lib "gdiplus" (ByVal style As HatchStyle, ByVal forecolr As Long, ByVal backcolr As Long, Brush As Long) As GpStatus
Public Declare Function GdipGetHatchStyle Lib "gdiplus" (ByVal Brush As Long, style As HatchStyle) As GpStatus
Public Declare Function GdipGetHatchForegroundColor Lib "gdiplus" (ByVal Brush As Long, forecolr As Long) As GpStatus
Public Declare Function GdipGetHatchBackgroundColor Lib "gdiplus" (ByVal Brush As Long, backcolr As Long) As GpStatus

' SolidBrush Functions (ALL)
Public Declare Function GdipCreateSolidFill Lib "gdiplus" (ByVal argb As Long, Brush As Long) As GpStatus
Public Declare Function GdipSetSolidFillColor Lib "gdiplus" (ByVal Brush As Long, ByVal argb As Long) As GpStatus
Public Declare Function GdipGetSolidFillColor Lib "gdiplus" (ByVal Brush As Long, argb As Long) As GpStatus

' LineBrush Functions (ALL)
Public Declare Function GdipCreateLineBrush Lib "gdiplus" (Point1 As POINTF, Point2 As POINTF, ByVal color1 As Long, ByVal color2 As Long, ByVal WrapMd As WrapMode, lineGradient As Long) As GpStatus
Public Declare Function GdipCreateLineBrushI Lib "gdiplus" (Point1 As POINTL, Point2 As POINTL, ByVal color1 As Long, ByVal color2 As Long, ByVal WrapMd As WrapMode, lineGradient As Long) As GpStatus
Public Declare Function GdipCreateLineBrushFromRect Lib "gdiplus" (rect As RECTF, ByVal color1 As Long, ByVal color2 As Long, ByVal Mode As LinearGradientMode, ByVal WrapMd As WrapMode, lineGradient As Long) As GpStatus
Public Declare Function GdipCreateLineBrushFromRectI Lib "gdiplus" (rect As RECTL, ByVal color1 As Long, ByVal color2 As Long, ByVal Mode As LinearGradientMode, ByVal WrapMd As WrapMode, lineGradient As Long) As GpStatus
Public Declare Function GdipCreateLineBrushFromRectWithAngle Lib "gdiplus" (rect As RECTF, ByVal color1 As Long, ByVal color2 As Long, ByVal angle As Single, ByVal isAngleScalable As Long, ByVal WrapMd As WrapMode, lineGradient As Long) As GpStatus
Public Declare Function GdipCreateLineBrushFromRectWithAngleI Lib "gdiplus" (rect As RECTL, ByVal color1 As Long, ByVal color2 As Long, ByVal angle As Single, ByVal isAngleScalable As Long, ByVal WrapMd As WrapMode, lineGradient As Long) As GpStatus
Public Declare Function GdipSetLineColors Lib "gdiplus" (ByVal Brush As Long, ByVal color1 As Long, ByVal color2 As Long) As GpStatus
Public Declare Function GdipGetLineColors Lib "gdiplus" (ByVal Brush As Long, lColors As Long) As GpStatus
Public Declare Function GdipGetLineRect Lib "gdiplus" (ByVal Brush As Long, rect As RECTF) As GpStatus
Public Declare Function GdipGetLineRectI Lib "gdiplus" (ByVal Brush As Long, rect As RECTL) As GpStatus
Public Declare Function GdipSetLineGammaCorrection Lib "gdiplus" (ByVal Brush As Long, ByVal useGammaCorrection As Long) As GpStatus
Public Declare Function GdipGetLineGammaCorrection Lib "gdiplus" (ByVal Brush As Long, useGammaCorrection As Long) As GpStatus
Public Declare Function GdipGetLineBlendCount Lib "gdiplus" (ByVal Brush As Long, count As Long) As GpStatus
Public Declare Function GdipGetLineBlend Lib "gdiplus" (ByVal Brush As Long, blend As Single, positions As Single, ByVal count As Long) As GpStatus
Public Declare Function GdipSetLineBlend Lib "gdiplus" (ByVal Brush As Long, blend As Single, positions As Single, ByVal count As Long) As GpStatus
Public Declare Function GdipGetLinePresetBlendCount Lib "gdiplus" (ByVal Brush As Long, count As Long) As GpStatus
Public Declare Function GdipGetLinePresetBlend Lib "gdiplus" (ByVal Brush As Long, blend As Long, positions As Single, ByVal count As Long) As GpStatus
Public Declare Function GdipSetLinePresetBlend Lib "gdiplus" (ByVal Brush As Long, blend As Long, positions As Single, ByVal count As Long) As GpStatus
Public Declare Function GdipSetLineSigmaBlend Lib "gdiplus" (ByVal Brush As Long, ByVal focus As Single, ByVal theScale As Single) As GpStatus
Public Declare Function GdipSetLineLinearBlend Lib "gdiplus" (ByVal Brush As Long, ByVal focus As Single, ByVal theScale As Single) As GpStatus
Public Declare Function GdipSetLineWrapMode Lib "gdiplus" (ByVal Brush As Long, ByVal WrapMd As WrapMode) As GpStatus
Public Declare Function GdipGetLineWrapMode Lib "gdiplus" (ByVal Brush As Long, WrapMd As WrapMode) As GpStatus
Public Declare Function GdipGetLineTransform Lib "gdiplus" (ByVal Brush As Long, matrix As Long) As GpStatus
Public Declare Function GdipSetLineTransform Lib "gdiplus" (ByVal Brush As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipResetLineTransform Lib "gdiplus" (ByVal Brush As Long) As GpStatus
Public Declare Function GdipMultiplyLineTransform Lib "gdiplus" (ByVal Brush As Long, ByVal matrix As Long, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipTranslateLineTransform Lib "gdiplus" (ByVal Brush As Long, ByVal dx As Single, ByVal dy As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipScaleLineTransform Lib "gdiplus" (ByVal Brush As Long, ByVal sx As Single, ByVal sy As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipRotateLineTransform Lib "gdiplus" (ByVal Brush As Long, ByVal angle As Single, ByVal order As MatrixOrder) As GpStatus

' TextureBrush Functions (ALL)
Public Declare Function GdipCreateTexture Lib "gdiplus" (ByVal Image As Long, ByVal WrapMd As WrapMode, texture As Long) As GpStatus
Public Declare Function GdipCreateTexture2 Lib "gdiplus" (ByVal Image As Long, ByVal WrapMd As WrapMode, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single, texture As Long) As GpStatus
Public Declare Function GdipCreateTextureIA Lib "gdiplus" (ByVal Image As Long, ByVal imageAttributes As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single, texture As Long) As GpStatus
Public Declare Function GdipCreateTexture2I Lib "gdiplus" (ByVal Image As Long, ByVal WrapMd As WrapMode, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, texture As Long) As GpStatus
Public Declare Function GdipCreateTextureIAI Lib "gdiplus" (ByVal Image As Long, ByVal imageAttributes As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, texture As Long) As GpStatus
Public Declare Function GdipGetTextureTransform Lib "gdiplus" (ByVal Brush As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipSetTextureTransform Lib "gdiplus" (ByVal Brush As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipResetTextureTransform Lib "gdiplus" (ByVal Brush As Long) As GpStatus
Public Declare Function GdipTranslateTextureTransform Lib "gdiplus" (ByVal Brush As Long, ByVal dx As Single, ByVal dy As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipMultiplyTextureTransform Lib "gdiplus" (ByVal Brush As Long, ByVal matrix As Long, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipScaleTextureTransform Lib "gdiplus" (ByVal Brush As Long, ByVal sx As Single, ByVal sy As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipRotateTextureTransform Lib "gdiplus" (ByVal Brush As Long, ByVal angle As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipSetTextureWrapMode Lib "gdiplus" (ByVal Brush As Long, ByVal WrapMd As WrapMode) As GpStatus
Public Declare Function GdipGetTextureWrapMode Lib "gdiplus" (ByVal Brush As Long, WrapMd As WrapMode) As GpStatus
Public Declare Function GdipGetTextureImage Lib "gdiplus" (ByVal Brush As Long, Image As Long) As GpStatus

' PathGradientBrush Functions (ALL)
Public Declare Function GdipCreatePathGradient Lib "gdiplus" (Points As POINTF, ByVal count As Long, ByVal WrapMd As WrapMode, polyGradient As Long) As GpStatus
Public Declare Function GdipCreatePathGradientI Lib "gdiplus" (Points As POINTL, ByVal count As Long, ByVal WrapMd As WrapMode, polyGradient As Long) As GpStatus
Public Declare Function GdipCreatePathGradientFromPath Lib "gdiplus" (ByVal path As Long, polyGradient As Long) As GpStatus
Public Declare Function GdipGetPathGradientCenterColor Lib "gdiplus" (ByVal Brush As Long, lColors As Long) As GpStatus
Public Declare Function GdipSetPathGradientCenterColor Lib "gdiplus" (ByVal Brush As Long, ByVal lColors As Long) As GpStatus
Public Declare Function GdipGetPathGradientSurroundColorsWithCount Lib "gdiplus" (ByVal Brush As Long, argb As Long, count As Long) As GpStatus
Public Declare Function GdipSetPathGradientSurroundColorsWithCount Lib "gdiplus" (ByVal Brush As Long, argb As Long, count As Long) As GpStatus
Public Declare Function GdipGetPathGradientPath Lib "gdiplus" (ByVal Brush As Long, ByVal path As Long) As GpStatus
Public Declare Function GdipSetPathGradientPath Lib "gdiplus" (ByVal Brush As Long, ByVal path As Long) As GpStatus
Public Declare Function GdipGetPathGradientCenterPoint Lib "gdiplus" (ByVal Brush As Long, Points As POINTF) As GpStatus
Public Declare Function GdipGetPathGradientCenterPointI Lib "gdiplus" (ByVal Brush As Long, Points As POINTL) As GpStatus
Public Declare Function GdipSetPathGradientCenterPoint Lib "gdiplus" (ByVal Brush As Long, Points As POINTF) As GpStatus
Public Declare Function GdipSetPathGradientCenterPointI Lib "gdiplus" (ByVal Brush As Long, Points As POINTL) As GpStatus
Public Declare Function GdipGetPathGradientRect Lib "gdiplus" (ByVal Brush As Long, rect As RECTF) As GpStatus
Public Declare Function GdipGetPathGradientRectI Lib "gdiplus" (ByVal Brush As Long, rect As RECTL) As GpStatus
Public Declare Function GdipGetPathGradientPointCount Lib "gdiplus" (ByVal Brush As Long, count As Long) As GpStatus
Public Declare Function GdipGetPathGradientSurroundColorCount Lib "gdiplus" (ByVal Brush As Long, count As Long) As GpStatus
Public Declare Function GdipSetPathGradientGammaCorrection Lib "gdiplus" (ByVal Brush As Long, ByVal useGammaCorrection As Long) As GpStatus
Public Declare Function GdipGetPathGradientGammaCorrection Lib "gdiplus" (ByVal Brush As Long, useGammaCorrection As Long) As GpStatus
Public Declare Function GdipGetPathGradientBlendCount Lib "gdiplus" (ByVal Brush As Long, count As Long) As GpStatus
Public Declare Function GdipGetPathGradientBlend Lib "gdiplus" (ByVal Brush As Long, blend As Single, positions As Single, ByVal count As Long) As GpStatus
Public Declare Function GdipSetPathGradientBlend Lib "gdiplus" (ByVal Brush As Long, blend As Single, positions As Single, ByVal count As Long) As GpStatus
Public Declare Function GdipGetPathGradientPresetBlendCount Lib "gdiplus" (ByVal Brush As Long, count As Long) As GpStatus
Public Declare Function GdipGetPathGradientPresetBlend Lib "gdiplus" (ByVal Brush As Long, blend As Long, positions As Single, ByVal count As Long) As GpStatus
Public Declare Function GdipSetPathGradientPresetBlend Lib "gdiplus" (ByVal Brush As Long, blend As Long, positions As Single, ByVal count As Long) As GpStatus
Public Declare Function GdipSetPathGradientSigmaBlend Lib "gdiplus" (ByVal Brush As Long, ByVal focus As Single, ByVal sScale As Single) As GpStatus
Public Declare Function GdipSetPathGradientLinearBlend Lib "gdiplus" (ByVal Brush As Long, ByVal focus As Single, ByVal sScale As Single) As GpStatus
Public Declare Function GdipGetPathGradientWrapMode Lib "gdiplus" (ByVal Brush As Long, WrapMd As WrapMode) As GpStatus
Public Declare Function GdipSetPathGradientWrapMode Lib "gdiplus" (ByVal Brush As Long, ByVal WrapMd As WrapMode) As GpStatus
Public Declare Function GdipGetPathGradientTransform Lib "gdiplus" (ByVal Brush As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipSetPathGradientTransform Lib "gdiplus" (ByVal Brush As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipResetPathGradientTransform Lib "gdiplus" (ByVal Brush As Long) As GpStatus
Public Declare Function GdipMultiplyPathGradientTransform Lib "gdiplus" (ByVal Brush As Long, ByVal matrix As Long, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipTranslatePathGradientTransform Lib "gdiplus" (ByVal Brush As Long, ByVal dx As Single, ByVal dy As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipScalePathGradientTransform Lib "gdiplus" (ByVal Brush As Long, ByVal sx As Single, ByVal sy As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipRotatePathGradientTransform Lib "gdiplus" (ByVal Brush As Long, ByVal angle As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipGetPathGradientFocusScales Lib "gdiplus" (ByVal Brush As Long, xScale As Single, yScale As Single) As GpStatus
Public Declare Function GdipSetPathGradientFocusScales Lib "gdiplus" (ByVal Brush As Long, ByVal xScale As Single, ByVal yScale As Single) As GpStatus

' GraphicsPath Functions (ALL)
Public Declare Function GdipCreatePath Lib "gdiplus" (ByVal brushmode As FillMode, path As Long) As GpStatus
' NOTE: The types parameter is treated as a byte array
Public Declare Function GdipCreatePath2 Lib "gdiplus" (Points As POINTF, types As Any, ByVal count As Long, brushmode As FillMode, path As Long) As GpStatus
Public Declare Function GdipCreatePath2I Lib "gdiplus" (Points As POINTL, types As Any, ByVal count As Long, brushmode As FillMode, path As Long) As GpStatus
Public Declare Function GdipClonePath Lib "gdiplus" (ByVal path As Long, clonePath As Long) As GpStatus
Public Declare Function GdipDeletePath Lib "gdiplus" (ByVal path As Long) As GpStatus
Public Declare Function GdipResetPath Lib "gdiplus" (ByVal path As Long) As GpStatus
Public Declare Function GdipGetPointCount Lib "gdiplus" (ByVal path As Long, count As Long) As GpStatus
' NOTE: The types parameter is treated as a byte array
Public Declare Function GdipGetPathTypes Lib "gdiplus" (ByVal path As Long, types As Any, ByVal count As Long) As GpStatus
Public Declare Function GdipGetPathPoints Lib "gdiplus" (ByVal path As Long, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipGetPathPointsI Lib "gdiplus" (ByVal path As Long, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipGetPathFillMode Lib "gdiplus" (ByVal path As Long, ByVal brushmode As FillMode) As GpStatus
Public Declare Function GdipSetPathFillMode Lib "gdiplus" (ByVal path As Long, ByVal brushmode As FillMode) As GpStatus
Public Declare Function GdipGetPathData Lib "gdiplus" (ByVal path As Long, pdata As PathData) As GpStatus
Public Declare Function GdipStartPathFigure Lib "gdiplus" (ByVal path As Long) As GpStatus
Public Declare Function GdipClosePathFigure Lib "gdiplus" (ByVal path As Long) As GpStatus
Public Declare Function GdipClosePathFigures Lib "gdiplus" (ByVal path As Long) As GpStatus
Public Declare Function GdipSetPathMarker Lib "gdiplus" (ByVal path As Long) As GpStatus
Public Declare Function GdipClearPathMarkers Lib "gdiplus" (ByVal path As Long) As GpStatus
Public Declare Function GdipReversePath Lib "gdiplus" (ByVal path As Long) As GpStatus
Public Declare Function GdipGetPathLastPoint Lib "gdiplus" (ByVal path As Long, lastPoint As POINTF) As GpStatus
Public Declare Function GdipAddPathLine Lib "gdiplus" (ByVal path As Long, ByVal x1 As Single, ByVal y1 As Single, ByVal x2 As Single, ByVal y2 As Single) As GpStatus
Public Declare Function GdipAddPathLine2 Lib "gdiplus" (ByVal path As Long, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipAddPathArc Lib "gdiplus" (ByVal path As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single, ByVal startAngle As Single, ByVal sweepAngle As Single) As GpStatus
Public Declare Function GdipAddPathBezier Lib "gdiplus" (ByVal path As Long, ByVal x1 As Single, ByVal y1 As Single, ByVal x2 As Single, ByVal y2 As Single, ByVal x3 As Single, ByVal y3 As Single, ByVal x4 As Single, ByVal y4 As Single) As GpStatus
Public Declare Function GdipAddPathBeziers Lib "gdiplus" (ByVal path As Long, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipAddPathCurve Lib "gdiplus" (ByVal path As Long, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipAddPathCurve2 Lib "gdiplus" (ByVal path As Long, Points As POINTF, ByVal count As Long, ByVal tension As Single) As GpStatus
Public Declare Function GdipAddPathCurve3 Lib "gdiplus" (ByVal path As Long, Points As POINTF, ByVal count As Long, ByVal Offset As Long, ByVal numberOfSegments As Long, ByVal tension As Single) As GpStatus
Public Declare Function GdipAddPathClosedCurve Lib "gdiplus" (ByVal path As Long, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipAddPathClosedCurve2 Lib "gdiplus" (ByVal path As Long, Points As POINTF, ByVal count As Long, ByVal tension As Single) As GpStatus
Public Declare Function GdipAddPathRectangle Lib "gdiplus" (ByVal path As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single) As GpStatus
Public Declare Function GdipAddPathRectangles Lib "gdiplus" (ByVal path As Long, rect As RECTF, ByVal count As Long) As GpStatus
Public Declare Function GdipAddPathEllipse Lib "gdiplus" (ByVal path As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single) As GpStatus
Public Declare Function GdipAddPathPie Lib "gdiplus" (ByVal path As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single, ByVal startAngle As Single, ByVal sweepAngle As Single) As GpStatus
Public Declare Function GdipAddPathPolygon Lib "gdiplus" (ByVal path As Long, Points As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipAddPathPath Lib "gdiplus" (ByVal path As Long, ByVal addingPath As Long, ByVal bConnect As Long) As GpStatus
Public Declare Function GdipAddPathString Lib "gdiplus" (ByVal path As Long, ByVal str As String, ByVal Length As Long, ByVal family As Long, ByVal style As Long, ByVal emSize As Single, layoutRect As RECTF, ByVal StringFormat As Long) As GpStatus
Public Declare Function GdipAddPathStringI Lib "gdiplus" (ByVal path As Long, ByVal str As String, ByVal Length As Long, ByVal family As Long, ByVal style As Long, ByVal emSize As Single, layoutRect As RECTL, ByVal StringFormat As Long) As GpStatus
Public Declare Function GdipAddPathLineI Lib "gdiplus" (ByVal path As Long, ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long) As GpStatus
Public Declare Function GdipAddPathLine2I Lib "gdiplus" (ByVal path As Long, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipAddPathArcI Lib "gdiplus" (ByVal path As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, ByVal startAngle As Single, ByVal sweepAngle As Single) As GpStatus
Public Declare Function GdipAddPathBezierI Lib "gdiplus" (ByVal path As Long, ByVal x1 As Long, ByVal y1 As Long, ByVal x2 As Long, ByVal y2 As Long, ByVal x3 As Long, ByVal y3 As Long, ByVal x4 As Long, ByVal y4 As Long) As GpStatus
Public Declare Function GdipAddPathBeziersI Lib "gdiplus" (ByVal path As Long, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipAddPathCurveI Lib "gdiplus" (ByVal path As Long, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipAddPathCurve2I Lib "gdiplus" (ByVal path As Long, Points As POINTL, ByVal count As Long, ByVal tension As Long) As GpStatus
Public Declare Function GdipAddPathCurve3I Lib "gdiplus" (ByVal path As Long, Points As POINTL, ByVal count As Long, ByVal Offset As Long, ByVal numberOfSegments As Long, ByVal tension As Single) As GpStatus
Public Declare Function GdipAddPathClosedCurveI Lib "gdiplus" (ByVal path As Long, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipAddPathClosedCurve2I Lib "gdiplus" (ByVal path As Long, Points As POINTL, ByVal count As Long, ByVal tension As Single) As GpStatus
Public Declare Function GdipAddPathRectangleI Lib "gdiplus" (ByVal path As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long) As GpStatus
Public Declare Function GdipAddPathRectanglesI Lib "gdiplus" (ByVal path As Long, rects As RECTL, ByVal count As Long) As GpStatus
Public Declare Function GdipAddPathEllipseI Lib "gdiplus" (ByVal path As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long) As GpStatus
Public Declare Function GdipAddPathPieI Lib "gdiplus" (ByVal path As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, ByVal startAngle As Single, ByVal sweepAngle As Single) As GpStatus
Public Declare Function GdipAddPathPolygonI Lib "gdiplus" (ByVal path As Long, Points As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipFlattenPath Lib "gdiplus" (ByVal path As Long, Optional ByVal matrix As Long = 0, Optional ByVal flatness As Single = FlatnessDefault) As GpStatus
Public Declare Function GdipWindingModeOutline Lib "gdiplus" (ByVal path As Long, ByVal matrix As Long, ByVal flatness As Single) As GpStatus
Public Declare Function GdipWidenPath Lib "gdiplus" (ByVal NativePath As Long, ByVal pen As Long, ByVal matrix As Long, ByVal flatness As Single) As GpStatus
Public Declare Function GdipWarpPath Lib "gdiplus" (ByVal path As Long, ByVal matrix As Long, Points As POINTF, ByVal count As Long, ByVal srcx As Single, ByVal srcy As Single, ByVal srcwidth As Single, ByVal srcheight As Single, ByVal WarpMd As WarpMode, ByVal flatness As Single) As GpStatus
Public Declare Function GdipTransformPath Lib "gdiplus" (ByVal path As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipGetPathWorldBounds Lib "gdiplus" (ByVal path As Long, bounds As RECTF, ByVal matrix As Long, ByVal pen As Long) As GpStatus
Public Declare Function GdipGetPathWorldBoundsI Lib "gdiplus" (ByVal path As Long, bounds As RECTL, ByVal matrix As Long, ByVal pen As Long) As GpStatus
Public Declare Function GdipIsVisiblePathPoint Lib "gdiplus" (ByVal path As Long, ByVal x As Single, ByVal y As Single, ByVal graphics As Long, result As Long) As GpStatus
Public Declare Function GdipIsVisiblePathPointI Lib "gdiplus" (ByVal path As Long, ByVal x As Long, ByVal y As Long, ByVal graphics As Long, result As Long) As GpStatus
Public Declare Function GdipIsOutlineVisiblePathPoint Lib "gdiplus" (ByVal path As Long, ByVal x As Single, ByVal y As Single, ByVal pen As Long, ByVal graphics As Long, result As Long) As GpStatus
Public Declare Function GdipIsOutlineVisiblePathPointI Lib "gdiplus" (ByVal path As Long, ByVal x As Long, ByVal y As Long, ByVal pen As Long, ByVal graphics As Long, result As Long) As GpStatus

' PathIterator Functions (ALL)
Public Declare Function GdipCreatePathIter Lib "gdiplus" (iterator As Long, ByVal path As Long) As GpStatus
Public Declare Function GdipDeletePathIter Lib "gdiplus" (ByVal iterator As Long) As GpStatus
Public Declare Function GdipPathIterNextSubpath Lib "gdiplus" (ByVal iterator As Long, resultCount As Long, startIndex As Long, endIndex As Long, isClosed As Long) As GpStatus
Public Declare Function GdipPathIterNextSubpathPath Lib "gdiplus" (ByVal iterator As Long, resultCount As Long, ByVal path As Long, isClosed As Long) As GpStatus
Public Declare Function GdipPathIterNextPathType Lib "gdiplus" (ByVal iterator As Long, resultCount As Long, pathType As Any, startIndex As Long, endIndex As Long) As GpStatus
Public Declare Function GdipPathIterNextMarker Lib "gdiplus" (ByVal iterator As Long, resultCount As Long, startIndex As Long, endIndex As Long) As GpStatus
Public Declare Function GdipPathIterNextMarkerPath Lib "gdiplus" (ByVal iterator As Long, resultCount As Long, ByVal path As Long) As GpStatus
Public Declare Function GdipPathIterGetCount Lib "gdiplus" (ByVal iterator As Long, count As Long) As GpStatus
Public Declare Function GdipPathIterGetSubpathCount Lib "gdiplus" (ByVal iterator As Long, count As Long) As GpStatus
Public Declare Function GdipPathIterIsValid Lib "gdiplus" (ByVal iterator As Long, valid As Long) As GpStatus
Public Declare Function GdipPathIterHasCurve Lib "gdiplus" (ByVal iterator As Long, hasCurve As Long) As GpStatus
Public Declare Function GdipPathIterRewind Lib "gdiplus" (ByVal iterator As Long) As GpStatus
' NOTE: The types parameter is treated as a byte array
Public Declare Function GdipPathIterEnumerate Lib "gdiplus" (ByVal iterator As Long, resultCount As Long, Points As POINTF, types As Any, ByVal count As Long) As GpStatus
Public Declare Function GdipPathIterCopyData Lib "gdiplus" (ByVal iterator As Long, resultCount As Long, Points As POINTF, types As Any, ByVal startIndex As Long, ByVal endIndex As Long) As GpStatus

' Matrix Functions (ALL)
Public Declare Function GdipCreateMatrix Lib "gdiplus" (matrix As Long) As GpStatus
Public Declare Function GdipCreateMatrix2 Lib "gdiplus" (ByVal m11 As Single, ByVal m12 As Single, ByVal m21 As Single, ByVal m22 As Single, ByVal dx As Single, ByVal dy As Single, matrix As Long) As GpStatus
Public Declare Function GdipCreateMatrix3 Lib "gdiplus" (rect As RECTF, dstplg As POINTF, matrix As Long) As GpStatus
Public Declare Function GdipCreateMatrix3I Lib "gdiplus" (rect As RECTL, dstplg As POINTL, matrix As Long) As GpStatus
Public Declare Function GdipCloneMatrix Lib "gdiplus" (ByVal matrix As Long, cloneMatrix As Long) As GpStatus
Public Declare Function GdipDeleteMatrix Lib "gdiplus" (ByVal matrix As Long) As GpStatus
Public Declare Function GdipSetMatrixElements Lib "gdiplus" (ByVal matrix As Long, ByVal m11 As Single, ByVal m12 As Single, ByVal m21 As Single, ByVal m22 As Single, ByVal dx As Single, ByVal dy As Single) As GpStatus
Public Declare Function GdipMultiplyMatrix Lib "gdiplus" (ByVal matrix As Long, ByVal matrix2 As Long, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipTranslateMatrix Lib "gdiplus" (ByVal matrix As Long, ByVal offsetX As Single, ByVal offsetY As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipScaleMatrix Lib "gdiplus" (ByVal matrix As Long, ByVal scaleX As Single, ByVal scaleY As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipRotateMatrix Lib "gdiplus" (ByVal matrix As Long, ByVal angle As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipShearMatrix Lib "gdiplus" (ByVal matrix As Long, ByVal shearX As Single, ByVal shearY As Single, ByVal order As MatrixOrder) As GpStatus
Public Declare Function GdipInvertMatrix Lib "gdiplus" (ByVal matrix As Long) As GpStatus
Public Declare Function GdipTransformMatrixPoints Lib "gdiplus" (ByVal matrix As Long, pts As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipTransformMatrixPointsI Lib "gdiplus" (ByVal matrix As Long, pts As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipVectorTransformMatrixPoints Lib "gdiplus" (ByVal matrix As Long, pts As POINTF, ByVal count As Long) As GpStatus
Public Declare Function GdipVectorTransformMatrixPointsI Lib "gdiplus" (ByVal matrix As Long, pts As POINTL, ByVal count As Long) As GpStatus
Public Declare Function GdipGetMatrixElements Lib "gdiplus" (ByVal matrix As Long, matrixOut As Single) As GpStatus
Public Declare Function GdipIsMatrixInvertible Lib "gdiplus" (ByVal matrix As Long, result As Long) As GpStatus
Public Declare Function GdipIsMatrixIdentity Lib "gdiplus" (ByVal matrix As Long, result As Long) As GpStatus
Public Declare Function GdipIsMatrixEqual Lib "gdiplus" (ByVal matrix As Long, ByVal matrix2 As Long, result As Long) As GpStatus

' Region Functions (ALL)
Public Declare Function GdipCreateRegion Lib "gdiplus" (region As Long) As GpStatus
Public Declare Function GdipCreateRegionRect Lib "gdiplus" (rect As RECTF, region As Long) As GpStatus
Public Declare Function GdipCreateRegionRectI Lib "gdiplus" (rect As RECTL, region As Long) As GpStatus
Public Declare Function GdipCreateRegionPath Lib "gdiplus" (ByVal path As Long, region As Long) As GpStatus
' NOTE: The regionData parameter is treated as a byte array
Public Declare Function GdipCreateRegionRgnData Lib "gdiplus" (regionData As Any, ByVal size As Long, region As Long) As GpStatus
Public Declare Function GdipCreateRegionHrgn Lib "gdiplus" (ByVal hRgn As Long, region As Long) As GpStatus
Public Declare Function GdipCloneRegion Lib "gdiplus" (ByVal region As Long, cloneRegion As Long) As GpStatus
Public Declare Function GdipDeleteRegion Lib "gdiplus" (ByVal region As Long) As GpStatus
Public Declare Function GdipSetInfinite Lib "gdiplus" (ByVal region As Long) As GpStatus
Public Declare Function GdipSetEmpty Lib "gdiplus" (ByVal region As Long) As GpStatus
Public Declare Function GdipCombineRegionRect Lib "gdiplus" (ByVal region As Long, rect As RECTF, ByVal CombineMd As CombineMode) As GpStatus
' Khan Changed
'Public Declare Function GdipCombineRegionRectI Lib "gdiplus" (ByVal region As Long, rect As RECTF, ByVal CombineMd As CombineMode) As GpStatus
Public Declare Function GdipCombineRegionRectI Lib "gdiplus" (ByVal region As Long, rect As RECTL, ByVal CombineMd As CombineMode) As GpStatus
Public Declare Function GdipCombineRegionPath Lib "gdiplus" (ByVal region As Long, ByVal path As Long, ByVal CombineMd As CombineMode) As GpStatus
Public Declare Function GdipCombineRegionRegion Lib "gdiplus" (ByVal region As Long, ByVal region2 As Long, ByVal CombineMd As CombineMode) As GpStatus
Public Declare Function GdipTranslateRegion Lib "gdiplus" (ByVal region As Long, ByVal dx As Single, ByVal dy As Single) As GpStatus
Public Declare Function GdipTranslateRegionI Lib "gdiplus" (ByVal region As Long, ByVal dx As Long, ByVal dy As Long) As GpStatus
Public Declare Function GdipTransformRegion Lib "gdiplus" (ByVal region As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipGetRegionBounds Lib "gdiplus" (ByVal region As Long, ByVal graphics As Long, rect As RECTF) As GpStatus
Public Declare Function GdipGetRegionBoundsI Lib "gdiplus" (ByVal region As Long, ByVal graphics As Long, rect As RECTL) As GpStatus
Public Declare Function GdipGetRegionHRgn Lib "gdiplus" (ByVal region As Long, ByVal graphics As Long, hRgn As Long) As GpStatus
Public Declare Function GdipIsEmptyRegion Lib "gdiplus" (ByVal region As Long, ByVal graphics As Long, result As Long) As GpStatus
Public Declare Function GdipIsInfiniteRegion Lib "gdiplus" (ByVal region As Long, ByVal graphics As Long, result As Long) As GpStatus
Public Declare Function GdipIsEqualRegion Lib "gdiplus" (ByVal region As Long, ByVal region2 As Long, ByVal graphics As Long, result As Long) As GpStatus
Public Declare Function GdipGetRegionDataSize Lib "gdiplus" (ByVal region As Long, bufferSize As Long) As GpStatus
' NOTE: The buffer parameter is treated as a byte array
Public Declare Function GdipGetRegionData Lib "gdiplus" (ByVal region As Long, buffer As Any, ByVal bufferSize As Long, sizeFilled As Long) As GpStatus
Public Declare Function GdipIsVisibleRegionPoint Lib "gdiplus" (ByVal region As Long, ByVal x As Single, ByVal y As Single, ByVal graphics As Long, result As Long) As GpStatus
Public Declare Function GdipIsVisibleRegionPointI Lib "gdiplus" (ByVal region As Long, ByVal x As Long, ByVal y As Long, ByVal graphics As Long, result As Long) As GpStatus
Public Declare Function GdipIsVisibleRegionRect Lib "gdiplus" (ByVal region As Long, ByVal x As Single, ByVal y As Single, ByVal Width As Single, ByVal Height As Single, ByVal graphics As Long, result As Long) As GpStatus
Public Declare Function GdipIsVisibleRegionRectI Lib "gdiplus" (ByVal region As Long, ByVal x As Long, ByVal y As Long, ByVal Width As Long, ByVal Height As Long, ByVal graphics As Long, result As Long) As GpStatus
Public Declare Function GdipGetRegionScansCount Lib "gdiplus" (ByVal region As Long, Ucount As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipGetRegionScans Lib "gdiplus" (ByVal region As Long, rects As RECTF, count As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipGetRegionScansI Lib "gdiplus" (ByVal region As Long, rects As RECTL, count As Long, ByVal matrix As Long) As GpStatus

' ImageAttributes APIs (ALL)
Public Declare Function GdipCreateImageAttributes Lib "gdiplus" (imageattr As Long) As GpStatus
Public Declare Function GdipCloneImageAttributes Lib "gdiplus" (ByVal imageattr As Long, cloneImageattr As Long) As GpStatus
Public Declare Function GdipDisposeImageAttributes Lib "gdiplus" (ByVal imageattr As Long) As GpStatus
Public Declare Function GdipSetImageAttributesToIdentity Lib "gdiplus" (ByVal imageattr As Long, ByVal ClrAdjType As ColorAdjustType) As GpStatus
Public Declare Function GdipResetImageAttributes Lib "gdiplus" (ByVal imageattr As Long, ByVal ClrAdjType As ColorAdjustType) As GpStatus
' NOTE: The colourMatrix and grayMatrix parameters expect a ColorMatrix structure or NULL
' KhanChanged
'Public Declare Function GdipSetImageAttributesColorMatrix Lib "gdiplus" (ByVal imageattr As Long, ByVal ClrAdjType As ColorAdjustType, ByVal enableFlag As Long, colourMatrix As ColorMatrix, grayMatrix As Any, ByVal flags As ColorMatrixFlags) As GpStatus
Public Declare Function GdipSetImageAttributesColorMatrix Lib "gdiplus" (ByVal imageattr As Long, ByVal ClrAdjType As ColorAdjustType, ByVal enableFlag As Long, colourMatrix As Any, grayMatrix As Any, ByVal flags As ColorMatrixFlags) As GpStatus
Public Declare Function GdipSetImageAttributesThreshold Lib "gdiplus" (ByVal imageattr As Long, ByVal ClrAdjType As ColorAdjustType, ByVal enableFlag As Long, ByVal threshold As Single) As GpStatus
Public Declare Function GdipSetImageAttributesGamma Lib "gdiplus" (ByVal imageattr As Long, ByVal ClrAdjType As ColorAdjustType, ByVal enableFlag As Long, ByVal gamma As Single) As GpStatus
Public Declare Function GdipSetImageAttributesNoOp Lib "gdiplus" (ByVal imageattr As Long, ByVal ClrAdjType As ColorAdjustType, ByVal enableFlag As Long) As GpStatus
Public Declare Function GdipSetImageAttributesColorKeys Lib "gdiplus" (ByVal imageattr As Long, ByVal ClrAdjType As ColorAdjustType, ByVal enableFlag As Long, ByVal colorLow As Long, ByVal colorHigh As Long) As GpStatus
Public Declare Function GdipSetImageAttributesOutputChannel Lib "gdiplus" (ByVal imageattr As Long, ByVal ClrAdjstType As ColorAdjustType, ByVal enableFlag As Long, ByVal channelFlags As ColorChannelFlags) As GpStatus
Public Declare Function GdipSetImageAttributesOutputChannelColorProfile Lib "gdiplus" (ByVal imageattr As Long, ByVal ClrAdjType As ColorAdjustType, ByVal enableFlag As Long, ByVal colorProfileFilename As String) As GpStatus
' KhanChanged
'Public Declare Function GdipSetImageAttributesRemapTable Lib "gdiplus" (ByVal imageattr As Long, ByVal ClrAdjType As ColorAdjustType, ByVal enableFlag As Long, ByVal mapSize As Long, map As ColorMap) As GpStatus
Public Declare Function GdipSetImageAttributesRemapTable Lib "gdiplus" (ByVal imageattr As Long, ByVal ClrAdjType As ColorAdjustType, ByVal enableFlag As Long, ByVal mapSize As Long, map As Any) As GpStatus
Public Declare Function GdipSetImageAttributesWrapMode Lib "gdiplus" (ByVal imageattr As Long, ByVal wrap As WrapMode, ByVal argb As Long, ByVal bClamp As Long) As GpStatus
Public Declare Function GdipSetImageAttributesICMMode Lib "gdiplus" (ByVal imageattr As Long, ByVal bOn As Long) As GpStatus
Public Declare Function GdipGetImageAttributesAdjustedPalette Lib "gdiplus" (ByVal imageattr As Long, colorPal As ColorPalette, ByVal ClrAdjType As ColorAdjustType) As GpStatus

' FontFamily Functions (ALL)
Public Declare Function GdipCreateFontFamilyFromName Lib "gdiplus" (ByVal name As String, ByVal fontCollection As Long, fontFamily As Long) As GpStatus
Public Declare Function GdipDeleteFontFamily Lib "gdiplus" (ByVal fontFamily As Long) As GpStatus
Public Declare Function GdipCloneFontFamily Lib "gdiplus" (ByVal fontFamily As Long, clonedFontFamily As Long) As GpStatus
Public Declare Function GdipGetGenericFontFamilySansSerif Lib "gdiplus" (nativeFamily As Long) As GpStatus
Public Declare Function GdipGetGenericFontFamilySerif Lib "gdiplus" (nativeFamily As Long) As GpStatus
Public Declare Function GdipGetGenericFontFamilyMonospace Lib "gdiplus" (nativeFamily As Long) As GpStatus
' NOTE: name must be LF_FACESIZE in length or less
Public Declare Function GdipGetFamilyName Lib "gdiplus" (ByVal family As Long, ByVal name As String, ByVal language As Integer) As GpStatus
Public Declare Function GdipIsStyleAvailable Lib "gdiplus" (ByVal family As Long, ByVal style As Long, IsStyleAvailable As Long) As GpStatus
Public Declare Function GdipFontCollectionEnumerable Lib "gdiplus" (ByVal fontCollection As Long, ByVal graphics As Long, numFound As Long) As GpStatus
Public Declare Function GdipFontCollectionEnumerate Lib "gdiplus" (ByVal fontCollection As Long, ByVal numSought As Long, gpFamilies As Long, ByVal numFound As Long, ByVal graphics As Long) As GpStatus
Public Declare Function GdipGetEmHeight Lib "gdiplus" (ByVal family As Long, ByVal style As Long, EmHeight As Integer) As GpStatus
Public Declare Function GdipGetCellAscent Lib "gdiplus" (ByVal family As Long, ByVal style As Long, CellAscent As Integer) As GpStatus
Public Declare Function GdipGetCellDescent Lib "gdiplus" (ByVal family As Long, ByVal style As Long, CellDescent As Integer) As GpStatus
Public Declare Function GdipGetLineSpacing Lib "gdiplus" (ByVal family As Long, ByVal style As Long, LineSpacing As Integer) As GpStatus

' Font Functions (ALL)
Public Declare Function GdipCreateFontFromDC Lib "gdiplus" (ByVal hDC As Long, createdfont As Long) As GpStatus
Public Declare Function GdipCreateFontFromLogfontA Lib "gdiplus" (ByVal hDC As Long, logfont As LOGFONTA, createdfont As Long) As GpStatus
Public Declare Function GdipCreateFontFromLogfontW Lib "gdiplus" (ByVal hDC As Long, logfont As LOGFONTW, createdfont As Long) As GpStatus
' KhanChanged
'Public Declare Function GdipCreateFont Lib "gdiplus" (ByVal fontFamily As Long, ByVal emSize As Single, ByVal style As FontStyle, ByVal unit As GpUnit, createdfont As Long) As GpStatus
Public Declare Function GdipCreateFont Lib "gdiplus" (ByVal fontFamily As Long, ByVal emSize As Single, ByVal style As Long, ByVal unit As GpUnit, createdfont As Long) As GpStatus
Public Declare Function GdipCloneFont Lib "gdiplus" (ByVal curFont As Long, cloneFont As Long) As GpStatus
Public Declare Function GdipDeleteFont Lib "gdiplus" (ByVal curFont As Long) As GpStatus
Public Declare Function GdipGetFamily Lib "gdiplus" (ByVal curFont As Long, family As Long) As GpStatus
Public Declare Function GdipGetFontStyle Lib "gdiplus" (ByVal curFont As Long, style As Long) As GpStatus
Public Declare Function GdipGetFontSize Lib "gdiplus" (ByVal curFont As Long, size As Single) As GpStatus
Public Declare Function GdipGetFontUnit Lib "gdiplus" (ByVal curFont As Long, unit As GpUnit) As GpStatus
Public Declare Function GdipGetFontHeight Lib "gdiplus" (ByVal curFont As Long, ByVal graphics As Long, Height As Single) As GpStatus
Public Declare Function GdipGetFontHeightGivenDPI Lib "gdiplus" (ByVal curFont As Long, ByVal dpi As Single, Height As Single) As GpStatus
Public Declare Function GdipGetLogFontA Lib "gdiplus" (ByVal curFont As Long, ByVal graphics As Long, logfont As LOGFONTA) As GpStatus
Public Declare Function GdipGetLogFontW Lib "gdiplus" (ByVal curFont As Long, ByVal graphics As Long, logfont As LOGFONTW) As GpStatus
Public Declare Function GdipNewInstalledFontCollection Lib "gdiplus" (fontCollection As Long) As GpStatus
Public Declare Function GdipNewPrivateFontCollection Lib "gdiplus" (fontCollection As Long) As GpStatus
Public Declare Function GdipDeletePrivateFontCollection Lib "gdiplus" (fontCollection As Long) As GpStatus
Public Declare Function GdipGetFontCollectionFamilyCount Lib "gdiplus" (ByVal fontCollection As Long, numFound As Long) As GpStatus
Public Declare Function GdipGetFontCollectionFamilyList Lib "gdiplus" (ByVal fontCollection As Long, ByVal numSought As Long, gpFamilies As Long, numFound As Long) As GpStatus
Public Declare Function GdipPrivateAddFontFile Lib "gdiplus" (ByVal fontCollection As Long, ByVal filename As String) As GpStatus
Public Declare Function GdipPrivateAddMemoryFont Lib "gdiplus" (ByVal fontCollection As Long, ByVal memory As Long, ByVal Length As Long) As GpStatus

' Text Functions (ALL)
Public Declare Function GdipDrawString Lib "gdiplus" (ByVal graphics As Long, ByVal str As String, ByVal Length As Long, ByVal thefont As Long, layoutRect As RECTF, ByVal StringFormat As Long, ByVal Brush As Long) As GpStatus
Public Declare Function GdipMeasureString Lib "gdiplus" (ByVal graphics As Long, ByVal str As String, ByVal Length As Long, ByVal thefont As Long, layoutRect As RECTF, ByVal StringFormat As Long, boundingBox As RECTF, codepointsFitted As Long, linesFilled As Long) As GpStatus
Public Declare Function GdipMeasureCharacterRanges Lib "gdiplus" (ByVal graphics As Long, ByVal str As String, ByVal Length As Long, ByVal thefont As Long, layoutRect As RECTF, ByVal StringFormat As Long, ByVal regionCount As Long, regions As Long) As GpStatus
Public Declare Function GdipDrawDriverString Lib "gdiplus" (ByVal graphics As Long, ByVal str As String, ByVal Length As Long, ByVal thefont As Long, ByVal Brush As Long, positions As POINTF, ByVal flags As Long, ByVal matrix As Long) As GpStatus
Public Declare Function GdipMeasureDriverString Lib "gdiplus" (ByVal graphics As Long, ByVal str As String, ByVal Length As Long, ByVal thefont As Long, positions As POINTF, ByVal flags As Long, ByVal matrix As Long, boundingBox As RECTF) As GpStatus

' String format Functions (ALL)
Public Declare Function GdipCreateStringFormat Lib "gdiplus" (ByVal formatAttributes As Long, ByVal language As Integer, StringFormat As Long) As GpStatus
Public Declare Function GdipStringFormatGetGenericDefault Lib "gdiplus" (StringFormat As Long) As GpStatus
Public Declare Function GdipStringFormatGetGenericTypographic Lib "gdiplus" (StringFormat As Long) As GpStatus
Public Declare Function GdipDeleteStringFormat Lib "gdiplus" (ByVal StringFormat As Long) As GpStatus
Public Declare Function GdipCloneStringFormat Lib "gdiplus" (ByVal StringFormat As Long, newFormat As Long) As GpStatus
Public Declare Function GdipSetStringFormatFlags Lib "gdiplus" (ByVal StringFormat As Long, ByVal flags As Long) As GpStatus
Public Declare Function GdipGetStringFormatFlags Lib "gdiplus" (ByVal StringFormat As Long, flags As Long) As GpStatus
Public Declare Function GdipSetStringFormatAlign Lib "gdiplus" (ByVal StringFormat As Long, ByVal align As StringAlignment) As GpStatus
Public Declare Function GdipGetStringFormatAlign Lib "gdiplus" (ByVal StringFormat As Long, align As StringAlignment) As GpStatus
Public Declare Function GdipSetStringFormatLineAlign Lib "gdiplus" (ByVal StringFormat As Long, ByVal align As StringAlignment) As GpStatus
Public Declare Function GdipGetStringFormatLineAlign Lib "gdiplus" (ByVal StringFormat As Long, align As StringAlignment) As GpStatus
Public Declare Function GdipSetStringFormatTrimming Lib "gdiplus" (ByVal StringFormat As Long, ByVal trimming As StringTrimming) As GpStatus
Public Declare Function GdipGetStringFormatTrimming Lib "gdiplus" (ByVal StringFormat As Long, trimming As Long) As GpStatus
Public Declare Function GdipSetStringFormatHotkeyPrefix Lib "gdiplus" (ByVal StringFormat As Long, ByVal hkPrefix As HotkeyPrefix) As GpStatus
Public Declare Function GdipGetStringFormatHotkeyPrefix Lib "gdiplus" (ByVal StringFormat As Long, hkPrefix As HotkeyPrefix) As GpStatus
Public Declare Function GdipSetStringFormatTabStops Lib "gdiplus" (ByVal StringFormat As Long, ByVal firstTabOffset As Single, ByVal count As Long, tabStops As Single) As GpStatus
Public Declare Function GdipGetStringFormatTabStops Lib "gdiplus" (ByVal StringFormat As Long, ByVal count As Long, firstTabOffset As Single, tabStops As Single) As GpStatus
Public Declare Function GdipGetStringFormatTabStopCount Lib "gdiplus" (ByVal StringFormat As Long, count As Long) As GpStatus
Public Declare Function GdipSetStringFormatDigitSubstitution Lib "gdiplus" (ByVal StringFormat As Long, ByVal language As Integer, ByVal substitute As StringDigitSubstitute) As GpStatus
Public Declare Function GdipGetStringFormatDigitSubstitution Lib "gdiplus" (ByVal StringFormat As Long, language As Integer, substitute As StringDigitSubstitute) As GpStatus
Public Declare Function GdipGetStringFormatMeasurableCharacterRangeCount Lib "gdiplus" (ByVal StringFormat As Long, count As Long) As GpStatus
Public Declare Function GdipSetStringFormatMeasurableCharacterRanges Lib "gdiplus" (ByVal StringFormat As Long, ByVal rangeCount As Long, ranges As CharacterRange) As GpStatus

' GDI+ Memory Management Functions (ALL)
Public Declare Function GdipAlloc Lib "gdiplus" (ByVal size As Long) As Long
Public Declare Sub GdipFree Lib "gdiplus" (ByVal ptr As Long)





' ======================================================================================
' Private variables:
' ======================================================================================
Private m_lngToken As Long

'-----------------------------------------------
' Helper Functions
'-----------------------------------------------

' Courtesy of: Dana Seaman
' Helper routine to convert a CLSID(aka GUID) string to a structure
Public Function DEFINE_GUID(ByVal sGuid As String) As Clsid
   ' Example ImageFormatBMP = {B96B3CAB-0728-11D3-9D7B-0000F81EF32E}
   Call CLSIDFromString(StrPtr(sGuid), DEFINE_GUID)
End Function

' From www.mvps.org/vbnet...i think
'   Dereferences an ANSI or Unicode string pointer
'   and returns a normal VB BSTR
Public Function PtrToStrW(ByVal lpsz As Long) As String
    Dim sOut As String
    Dim lLen As Long

    lLen = lstrlenW(lpsz)

    If (lLen > 0) Then
        sOut = StrConv(String$(lLen, vbNullChar), vbUnicode)
        Call CopyMemory(ByVal sOut, ByVal lpsz, lLen * 2)
        PtrToStrW = StrConv(sOut, vbFromUnicode)
    End If
End Function

Public Function PtrToStrA(ByVal lpsz As Long) As String
    Dim sOut As String
    Dim lLen As Long

    lLen = lstrlenA(lpsz)

    If (lLen > 0) Then
        sOut = String$(lLen, vbNullChar)
        Call CopyMemory(ByVal sOut, ByVal lpsz, lLen)
        PtrToStrA = sOut
    End If
End Function

Private Function hexPad(ByVal value As Long, ByVal padSize As Long) As String
Dim sRet As String
Dim lMissing As Long
   sRet = Hex$(value)
   lMissing = padSize - Len(sRet)
   If (lMissing > 0) Then
      sRet = String$(lMissing, "0") & sRet
   ElseIf (lMissing < 0) Then
      sRet = Mid$(sRet, -lMissing + 1)
   End If
   hexPad = sRet
End Function

Public Function GetGuidString(Guid As Clsid) As String
    Dim i As Long
    Dim sGuid As String

    sGuid = "{" & hexPad(Guid.Data1, 8) & "-" & hexPad(Guid.Data2, 4) & "-" & hexPad(Guid.Data3, 4) & "-"
    sGuid = sGuid & hexPad(Guid.Data4(0), 2) & hexPad(Guid.Data4(1), 2) & "-"
    For i = 2 To 7
        sGuid = sGuid & hexPad(Guid.Data4(i), 2)
    Next i
    sGuid = sGuid & "}"
    GetGuidString = sGuid
End Function

' This should hopefully simplify property item value retrieval
' NOTE: We are raising errors in this function; ensure the caller has error handing code.
'       The resulting arrays are using a base of one.
Public Function GetPropValue(Item As PropertyItem) As Variant
   ' We need a valid pointer and length
   If Item.value = 0 Or Item.Length = 0 Then Err.Raise 5, "GetPropValue"

   Select Case Item.type
      ' We'll make Undefined types a Btye array as it seems the safest choice...
      Case PropertyTagTypeByte, PropertyTagTypeUndefined:
         Dim bte() As Byte: ReDim bte(1 To Item.Length)
         CopyMemory bte(1), ByVal Item.value, Item.Length
         GetPropValue = bte
         Erase bte

      Case PropertyTagTypeASCII:
         GetPropValue = PtrToStrA(Item.value)
         
      Case PropertyTagTypeShort:
         Dim short() As Integer: ReDim short(1 To (Item.Length / 2))
         CopyMemory short(1), ByVal Item.value, Item.Length
         GetPropValue = short
         Erase short
         
      Case PropertyTagTypeLong, PropertyTagTypeSLONG:
         Dim lng() As Long: ReDim lng(1 To (Item.Length / 4))
         CopyMemory lng(1), ByVal Item.value, Item.Length
         GetPropValue = lng
         Erase lng
         
      Case PropertyTagTypeRational, PropertyTagTypeSRational:
         Dim lngpair() As Long: ReDim lngpair(1 To (Item.Length / 8), 1 To 2)
         CopyMemory lngpair(1, 1), ByVal Item.value, Item.Length
         GetPropValue = lngpair
         Erase lngpair

      Case Else: Err.Raise 461, "GetPropValue"
   End Select
End Function

Public Function GDIPlusInitialize() As Boolean
    Dim GpInput As GdiplusStartupInput
    Dim lToken As Long
    
    GpInput.GdiplusVersion = 1
    If GdiplusStartup(lToken, GpInput) = Ok Then
       m_lngToken = lToken
       GDIPlusInitialize = True
    End If
End Function

Public Sub GDIPlusTerminate()
   If m_lngToken <> 0 Then
      Call GdiplusShutdown(m_lngToken)
      m_lngToken = 0
   End If
End Sub

Public Sub ConvertPointFToType(uPoints() As cPointF, uPT() As POINTF)
    Dim i As Long
    Dim lngL As Long
    Dim lngU As Long
    
    lngL = LBound(uPoints)
    lngU = UBound(uPoints)
    ReDim uPT(lngL To lngU)
    For i = lngL To lngU
       LSet uPT(i) = uPoints(i).ToType
    Next i
End Sub

Public Sub ConvertPointLToType(uPoints() As cPoint, uPT() As POINTL)
    Dim i As Long
    Dim lngL As Long
    Dim lngU As Long
    
    lngL = LBound(uPoints)
    lngU = UBound(uPoints)
    ReDim uPT(lngL To lngU)
    For i = lngL To lngU
       LSet uPT(i) = uPoints(i).ToType
    Next i
End Sub

Public Sub ConvertRectFToType(uRects() As cRectF, uR() As RECTF)
    Dim i As Long
    Dim lngL As Long
    Dim lngU As Long
    
    lngL = LBound(uRects)
    lngU = UBound(uRects)
    ReDim uR(lngL To lngU)
    For i = lngL To lngU
       LSet uR(i) = uRects(i).ToType
    Next i
End Sub

Public Sub ConvertRectLToType(uRects() As cRect, uR() As RECTL)
    Dim i As Long
    Dim lngL As Long
    Dim lngU As Long
    
    lngL = LBound(uRects)
    lngU = UBound(uRects)
    ReDim uR(lngL To lngU)
    For i = lngL To lngU
       LSet uR(i) = uRects(i).ToType
    Next i
End Sub

Public Sub ConvertRangeToType(uRanges() As cCharacterRange, uR() As CharacterRange)
    Dim i As Long
    Dim lngL As Long
    Dim lngU As Long
    
    lngL = LBound(uRanges)
    lngU = UBound(uRanges)
    ReDim uR(lngL To lngU)
    For i = lngL To lngU
       LSet uR(i) = uRanges(i).ToType
    Next i
End Sub

