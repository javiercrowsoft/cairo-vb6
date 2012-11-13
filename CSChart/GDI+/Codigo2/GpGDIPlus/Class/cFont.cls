VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFont"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cFont.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusFont.h:Microsoft Platform SDK February 2003
'
' The Font class encapsulates the characteristics, such as family, height, size,
' and style (or combination of styles), of a specific font. A Font object is used
' when drawing strings.
' ==================================================================================

Private m_lngFont As Long
Private m_uLastStatus As GpStatus

' creates a new Font object based on this Font object.
Public Function Clone() As cFont
    Dim lngF            As Long
    Dim clsClone        As cFont
    
    m_uLastStatus = GdipCloneFont(m_lngFont, lngF)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cFont
    clsClone.fInitialize (lngF)
    Set Clone = clsClone
End Function

' Creates a Font object based on a font family, a size, a font style, a unit of measurement, and a FontCollection object.
Public Function Create(ByVal familyName As String, _
                       ByVal emSize As Single, _
                       ByVal style As Long, _
                       Optional ByVal unit As GpUnit = UnitPoint, _
                       Optional ByVal fontCollection As cFontCollection = Nothing) As GpStatus
    Dim clsFamily As New cFontFamily
    Dim clsSans As cFontFamily
    Call DisposeFont
    m_uLastStatus = clsFamily.Create(familyName, fontCollection)
    If m_uLastStatus <> Ok Then
       Set clsSans = clsFamily.GenericSansSerif
       m_uLastStatus = GdipCreateFont(clsSans.NativeFontFamily, emSize, style, unit, m_lngFont)
    Else
       m_uLastStatus = GdipCreateFont(clsFamily.NativeFontFamily, emSize, style, unit, m_lngFont)
    End If
    Set clsFamily = Nothing
    Set clsSans = Nothing
    Create = m_uLastStatus
End Function

' Creates a Font object based on a FontFamily object, a size, a font style, and a unit of measurement.
Public Function CreateFromFamily(ByVal emSize As Single, _
                                 ByVal style As Long, _
                                 Optional ByVal family As cFontFamily, _
                                 Optional ByVal unit As GpUnit = UnitPoint) As GpStatus
    Call DisposeFont
    If family Is Nothing Then
       m_uLastStatus = GdipCreateFont(ByVal 0&, emSize, style, unit, m_lngFont)
    Else
       m_uLastStatus = GdipCreateFont(family.NativeFontFamily, emSize, style, unit, m_lngFont)
    End If
    CreateFromFamily = m_uLastStatus
End Function

' Creates a Font object based on the GDI font object that is currently selected into a specified device context.
Public Function CreateFromHDC(ByVal hDC As Long) As GpStatus
    Call DisposeFont
    m_uLastStatus = GdipCreateFontFromDC(hDC, m_lngFont)
    CreateFromHDC = m_uLastStatus
End Function

' Creates a Font object indirectly from a GDI logical font by using a handle to a GDI LOGFONT structure.
Public Function CreateFromHFONT(ByVal hDC As Long, ByVal hfont As Long)
    Dim lf As LOGFONTA
    
    Call DisposeFont
    If hfont <> 0 Then
       If GetObjectAPI(hfont, Len(lf), lf) <> 0 Then
          m_uLastStatus = GdipCreateFontFromLogfontA(hDC, lf, m_lngFont)
       Else
          m_uLastStatus = GdipCreateFontFromDC(hDC, m_lngFont)
       End If
    Else
       m_uLastStatus = GdipCreateFontFromDC(hDC, m_lngFont)
    End If
    CreateFromHFONT = m_uLastStatus
End Function

Public Function CreateFromLOGFONTA(ByVal hDC As Long, lf As LOGFONTA) As GpStatus
    Call DisposeFont
    m_uLastStatus = GdipCreateFontFromLogfontA(hDC, lf, m_lngFont)
    CreateFromLOGFONTA = m_uLastStatus
End Function

Public Function CreateFromLOGFONTW(ByVal hDC As Long, lf As LOGFONTW) As GpStatus
    Call DisposeFont
    m_uLastStatus = GdipCreateFontFromLogfontW(hDC, lf, m_lngFont)
    CreateFromLOGFONTW = m_uLastStatus
End Function

Public Sub DisposeFont()
    If m_lngFont <> 0 Then m_uLastStatus = GdipDeleteFont(m_lngFont): m_lngFont = 0
End Sub

Friend Sub fInitialize(ByVal lFont As Long)
    Call DisposeFont
    m_lngFont = lFont
End Sub

' gets the font family on which this font is based.
Public Function GetFamily(ByRef family As cFontFamily) As GpStatus
    Dim lFamily As Long
    
    m_uLastStatus = GdipGetFamily(m_lngFont, lFamily)
    If m_uLastStatus = Ok Then
       If family Is Nothing Then Set family = New cFontFamily
       family.fInitialize (lFamily)
    End If
    GetFamily = m_uLastStatus
End Function

' gets the line spacing, in pixels, of this font.
Public Function GetHeight(ByVal dpi As Single) As Single
    Dim sHeight As Single
    m_uLastStatus = GdipGetFontHeightGivenDPI(m_lngFont, dpi, sHeight)
    GetHeight = sHeight
End Function

' gets the line spacing of this font in the current unit of a specified Graphics object.
Public Function GetHeightFromGraphics(ByVal graphics As cGraphics) As Single
    Dim sHeight As Single
    
    If graphics Is Nothing Then m_uLastStatus = InvalidParameter: Exit Function
    m_uLastStatus = GdipGetFontHeight(m_lngFont, graphics.NativeGraphics, sHeight)
    GetHeightFromGraphics = sHeight
End Function

' returns a value that indicates the nature of this CustomLineCap object's most recent method failure.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' uses a LOGFONTA structure to get the attributes of this Font object.
Public Function GetLogFontA(lfA As LOGFONTA, Optional ByVal g As cGraphics = Nothing) As GpStatus
    If g Is Nothing Then
       m_uLastStatus = GdipGetLogFontA(m_lngFont, ByVal 0&, lfA)
    Else
       m_uLastStatus = GdipGetLogFontA(m_lngFont, g.NativeGraphics, lfA)
    End If
    GetLogFontA = m_uLastStatus
End Function

' uses a LOGFONTA structure to get the attributes of this Font object.
Public Function GetLogFontW(lfW As LOGFONTW, Optional ByVal g As cGraphics = Nothing) As GpStatus
    If g Is Nothing Then
       m_uLastStatus = GdipGetLogFontW(m_lngFont, ByVal 0&, lfW)
    Else
       m_uLastStatus = GdipGetLogFontW(m_lngFont, g.NativeGraphics, lfW)
    End If
    GetLogFontW = m_uLastStatus
End Function

' returns the font size (commonly called the em size) of this Font object.
' The size is in the units of this Font object.
Public Function GetSize() As Single
    Dim sSize As Single
    
    m_uLastStatus = GdipGetFontSize(m_lngFont, sSize)
    GetSize = sSize
End Function

' gets the style of this font's typeface.
Public Function GetStyle() As Long
    Dim lStyle As Long
    
    m_uLastStatus = GdipGetFontStyle(m_lngFont, lStyle)
    GetStyle = lStyle
End Function

' returns the unit of measure of this Font object.
Public Function GetUnit() As GpUnit
    Dim uU As GpUnit
    
    m_uLastStatus = GdipGetFontUnit(m_lngFont, uU)
    GetUnit = uU
End Function

Public Property Get NativeFont() As Long
    NativeFont = m_lngFont
End Property

Private Sub Class_Initialize()
    Call DisposeFont
End Sub

Private Sub Class_Terminate()
    Call DisposeFont
End Sub
