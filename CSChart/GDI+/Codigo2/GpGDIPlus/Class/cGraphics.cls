VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGraphics"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

' ==================================================================================
' cGraphics.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from Microsoft Platform SDK February 2003
'
' The Graphics class provides methods for drawing lines, curves, figures, images,
' and text. A Graphics object stores attributes of the display device and attributes
' of the items to be drawn.
' ==================================================================================

Private m_lngGraphics As Long
Private m_uLastStatus As GpStatus

' begins a new graphics container.
Public Function BeginContainer() As Long
    Dim lState As Long
    m_uLastStatus = GdipBeginContainer2(m_lngGraphics, lState)
    BeginContainer = lState
End Function

' begins a new graphics container.
Public Function BeginContainerRectF(ByVal dstRect As cRectF, _
                                    ByVal srcRect As cRectF, _
                                    ByVal uUnit As GpUnit) As Long
    Dim lState As Long
    m_uLastStatus = GdipBeginContainer(m_lngGraphics, dstRect.ToType, srcRect.ToType, uUnit, lState)
    BeginContainerRectF = lState
End Function

' begins a new graphics container.
Public Function BeginContainerRectL(ByVal dstRect As cRect, _
                                    ByVal srcRect As cRect, _
                                    ByVal uUnit As GpUnit) As Long
    Dim lState As Long
    m_uLastStatus = GdipBeginContainerI(m_lngGraphics, dstRect.ToType, srcRect.ToType, uUnit, lState)
    BeginContainerRectL = lState
End Function

' clears a Graphics object to a specified color.
Public Function Clear(ByVal color As cColor) As GpStatus
    m_uLastStatus = GdipGraphicsClear(m_lngGraphics, color.GetValue())
    Clear = m_uLastStatus
End Function

Public Sub DisposeGraphics()
    If m_lngGraphics <> 0 Then Call GdipDeleteGraphics(m_lngGraphics): m_lngGraphics = 0
End Sub

' draws an arc. The arc is part of an ellipse.
Public Function DrawArcF(ByVal pen As cPen, _
                         ByVal x As Single, _
                         ByVal y As Single, _
                         ByVal Width As Single, _
                         ByVal Height As Single, _
                         ByVal startAngle As Single, _
                         ByVal sweepAngle As Single) As GpStatus
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawArcF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipDrawArc(m_lngGraphics, pen.NativePen, _
                                x, y, Width, Height, startAngle, sweepAngle)
    DrawArcF = m_uLastStatus
End Function

Public Function DrawArcL(ByVal pen As cPen, _
                         ByVal x As Long, _
                         ByVal y As Long, _
                         ByVal Width As Long, _
                         ByVal Height As Long, _
                         ByVal startAngle As Single, _
                         ByVal sweepAngle As Single) As GpStatus
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawArcL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipDrawArcI(m_lngGraphics, pen.NativePen, _
                                x, y, Width, Height, startAngle, sweepAngle)
    DrawArcL = m_uLastStatus
End Function

Public Function DrawArcRectF(ByVal pen As cPen, _
                             ByVal rect As cRectF, _
                             ByVal startAngle As Single, _
                             ByVal sweepAngle As Single) As GpStatus
    DrawArcRectF = DrawArcF(pen, rect.Left, rect.Top, rect.Width, rect.Height, startAngle, sweepAngle)
End Function

Public Function DrawArcRectL(ByVal pen As cPen, _
                             ByVal rect As cRect, _
                             ByVal startAngle As Single, _
                             ByVal sweepAngle As Single) As GpStatus
    DrawArcRectL = DrawArcL(pen, rect.Left, rect.Top, rect.Width, rect.Height, startAngle, sweepAngle)
End Function

' draws a B¨¦zier spline.
Public Function DrawBezierF(ByVal pen As cPen, _
                            ByVal x1 As Single, ByVal y1 As Single, _
                            ByVal x2 As Single, ByVal y2 As Single, _
                            ByVal x3 As Single, ByVal y3 As Single, _
                            ByVal x4 As Single, ByVal y4 As Single) As GpStatus
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawBezierF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipDrawBezier(m_lngGraphics, pen.NativePen, x1, y1, x2, y2, x3, y3, x4, y4)
    DrawBezierF = m_uLastStatus
End Function

Public Function DrawBezierL(ByVal pen As cPen, _
                            ByVal x1 As Long, ByVal y1 As Long, _
                            ByVal x2 As Long, ByVal y2 As Long, _
                            ByVal x3 As Long, ByVal y3 As Long, _
                            ByVal x4 As Long, ByVal y4 As Long) As GpStatus
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawBezierL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipDrawBezierI(m_lngGraphics, pen.NativePen, x1, y1, x2, y2, x3, y3, x4, y4)
    DrawBezierL = m_uLastStatus
End Function

Public Function DrawBezierPointF(ByVal pen As cPen, _
                                 ByVal pt1 As cPointF, _
                                 ByVal pt2 As cPointF, _
                                 ByVal pt3 As cPointF, _
                                 ByVal pt4 As cPointF) As GpStatus
    DrawBezierPointF = DrawBezierF(pen, pt1.x, pt1.y, _
                                   pt2.x, pt2.y, _
                                   pt3.x, pt3.y, _
                                   pt4.x, pt4.y)
End Function

Public Function DrawBezierPointL(ByVal pen As cPen, _
                                 ByVal pt1 As cPoint, _
                                 ByVal pt2 As cPoint, _
                                 ByVal pt3 As cPoint, _
                                 ByVal pt4 As cPoint) As GpStatus
    DrawBezierPointL = DrawBezierL(pen, pt1.x, pt1.y, _
                                   pt2.x, pt2.y, _
                                   pt3.x, pt3.y, _
                                   pt4.x, pt4.y)
End Function

' draws a sequence of connected B¨¦zier splines
Public Function DrawBeziersPointF(ByVal pen As cPen, _
                                  ByRef uPoints() As cPointF, _
                                  ByVal lCount As Long) As GpStatus
    Dim uP() As POINTF
    
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipDrawBeziers(m_lngGraphics, pen.NativePen, uP(LBound(uP)), lCount)
    Erase uP
    DrawBeziersPointF = m_uLastStatus
End Function

Public Function DrawBeziersPointL(ByVal pen As cPen, _
                                  ByRef uPoints() As cPoint, _
                                  ByVal lCount As Long) As GpStatus
    Dim uP() As POINTL
    
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipDrawBeziersI(m_lngGraphics, pen.NativePen, uP(LBound(uP)), lCount)
    Erase uP
    DrawBeziersPointL = m_uLastStatus
End Function

' draws the image stored in a CachedBitmap object.
Public Function DrawCachedBitmap(ByVal cb As cCachedBitmap, _
                                 ByVal x As Long, _
                                 ByVal y As Long) As GpStatus
    m_uLastStatus = GdipDrawCachedBitmap(m_lngGraphics, cb.NativeCachedBitmap, x, y)
    DrawCachedBitmap = m_uLastStatus
End Function

' draws a closed cardinal spline.
Public Function DrawClosedCurveF(ByVal pen As cPen, _
                                 ByRef uPoints() As cPointF, _
                                 ByVal lCount As Long) As GpStatus
    Dim uP() As POINTF
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawClosedCurveF = m_uLastStatus: Exit Function
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipDrawClosedCurve(m_lngGraphics, pen.NativePen, uP(LBound(uP)), lCount)
    Erase uP
    DrawClosedCurveF = m_uLastStatus
End Function

Public Function DrawClosedCurveF2(ByVal pen As cPen, _
                                  ByRef uPoints() As cPointF, _
                                  ByVal lCount As Long, _
                                  ByVal tension As Single) As GpStatus
    Dim uP() As POINTF
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawClosedCurveF2 = m_uLastStatus: Exit Function
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipDrawClosedCurve2(m_lngGraphics, pen.NativePen, _
                                         uP(LBound(uP)), lCount, tension)
    Erase uP
    DrawClosedCurveF2 = m_uLastStatus
End Function

Public Function DrawClosedCurveL(ByVal pen As cPen, _
                                 ByRef uPoints() As cPoint, _
                                 ByVal lCount As Long) As GpStatus
    Dim uP() As POINTL
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawClosedCurveL = m_uLastStatus: Exit Function
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipDrawClosedCurveI(m_lngGraphics, pen.NativePen, uP(LBound(uP)), lCount)
    Erase uP
    DrawClosedCurveL = m_uLastStatus
End Function

Public Function DrawClosedCurveL2(ByVal pen As cPen, _
                                  ByRef uPoints() As cPoint, _
                                  ByVal lCount As Long, _
                                  ByVal tension As Single) As GpStatus
    Dim uP() As POINTL
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawClosedCurveL2 = m_uLastStatus: Exit Function
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipDrawClosedCurve2I(m_lngGraphics, pen.NativePen, _
                                         uP(LBound(uP)), lCount, tension)
    Erase uP
    DrawClosedCurveL2 = m_uLastStatus
End Function

' draws a cardinal spline.
Public Function DrawCurveF(ByVal pen As cPen, _
                           ByRef uPoints() As cPointF, _
                           ByVal lCount As Long) As GpStatus
    Dim uP() As POINTF
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawCurveF = m_uLastStatus: Exit Function
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipDrawCurve(m_lngGraphics, pen.NativePen, uP(LBound(uP)), lCount)
    Erase uP
    DrawCurveF = m_uLastStatus
End Function

Public Function DrawCurveF2(ByVal pen As cPen, _
                            ByRef uPoints() As cPointF, _
                            ByVal lCount As Long, _
                            ByVal tension As Single) As GpStatus
    Dim uP() As POINTF
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawCurveF2 = m_uLastStatus: Exit Function
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipDrawCurve2(m_lngGraphics, pen.NativePen, uP(LBound(uP)), lCount, tension)
    Erase uP
    DrawCurveF2 = m_uLastStatus
End Function

Public Function DrawCurveF3(ByVal pen As cPen, _
                            ByRef uPoints() As cPointF, _
                            ByVal lCount As Long, _
                            ByVal Offset As Long, _
                            ByVal numberOfSegments As Long, _
                            ByVal tension As Single) As GpStatus
    Dim uP() As POINTF
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawCurveF3 = m_uLastStatus: Exit Function
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipDrawCurve3(m_lngGraphics, pen.NativePen, uP(LBound(uP)), _
                                   lCount, Offset, numberOfSegments, tension)
    Erase uP
    DrawCurveF3 = m_uLastStatus
End Function

Public Function DrawCurveL(ByVal pen As cPen, _
                           ByRef uPoints() As cPoint, _
                           ByVal lCount As Long) As GpStatus
    Dim uP() As POINTL
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawCurveL = m_uLastStatus: Exit Function
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipDrawCurveI(m_lngGraphics, pen.NativePen, uP(LBound(uP)), lCount)
    Erase uP
    DrawCurveL = m_uLastStatus
End Function

Public Function DrawCurveL2(ByVal pen As cPen, _
                            ByRef uPoints() As cPoint, _
                            ByVal lCount As Long, _
                            ByVal tension As Single) As GpStatus
    Dim uP() As POINTL
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawCurveL2 = m_uLastStatus: Exit Function
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipDrawCurve2I(m_lngGraphics, pen.NativePen, uP(LBound(uP)), lCount, tension)
    Erase uP
    DrawCurveL2 = m_uLastStatus
End Function

Public Function DrawCurveL3(ByVal pen As cPen, _
                            ByRef uPoints() As cPoint, _
                            ByVal lCount As Long, _
                            ByVal Offset As Long, _
                            ByVal numberOfSegments As Long, _
                            ByVal tension As Single) As GpStatus
    Dim uP() As POINTL
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawCurveL3 = m_uLastStatus: Exit Function
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipDrawCurve3I(m_lngGraphics, pen.NativePen, uP(LBound(uP)), _
                                   lCount, Offset, numberOfSegments, tension)
    Erase uP
    DrawCurveL3 = m_uLastStatus
End Function

' draws characters at the specified positions. The method gives the client complete
' control over the appearance of text. The method assumes that the client has already
' set up the format and layout to be applied.
Public Function DrawDriverString(ByVal Text As String, _
                                 ByVal lLength As Long, _
                                 ByVal font As cFont, _
                                 ByVal Brush As cBrush, _
                                 ByVal positions As cPointF, _
                                 ByVal flags As Long, _
                                 ByVal matrix As cMatrix) As GpStatus
    Dim lFont                    As Long
    Dim lBrush                   As Long
    Dim lMatrix                  As Long
    
    If font Is Nothing Then lFont = 0& Else lFont = font.NativeFont
    If Brush Is Nothing Then lBrush = 0& Else lBrush = Brush.NativeBrush
    If matrix Is Nothing Then lMatrix = 0& Else lMatrix = matrix.NativeMatrix
    m_uLastStatus = GdipDrawDriverString(m_lngGraphics, StrConv(Text, vbUnicode), _
                                         lLength, lFont, lBrush, positions.ToType, flags, lMatrix)
                                                    
    DrawDriverString = m_uLastStatus
End Function

' draws an ellipse
Public Function DrawEllipseF(ByVal pen As cPen, _
                             ByVal x As Single, ByVal y As Single, _
                             ByVal Width As Single, ByVal Height As Single) As GpStatus
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawEllipseF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipDrawEllipse(m_lngGraphics, pen.NativePen, x, y, Width, Height)
    DrawEllipseF = m_uLastStatus
End Function

Public Function DrawEllipseL(ByVal pen As cPen, _
                             ByVal x As Long, ByVal y As Long, _
                             ByVal Width As Long, ByVal Height As Long) As GpStatus
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawEllipseL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipDrawEllipseI(m_lngGraphics, pen.NativePen, x, y, Width, Height)
    DrawEllipseL = m_uLastStatus
End Function

Public Function DrawEllipseRectF(ByVal pen As cPen, ByVal rect As cRectF) As GpStatus
    DrawEllipseRectF = DrawEllipseF(pen, rect.Left, rect.Top, rect.Width, rect.Height)
End Function

Public Function DrawEllipseRectL(ByVal pen As cPen, ByVal rect As cRect) As GpStatus
    DrawEllipseRectL = DrawEllipseL(pen, rect.Left, rect.Top, rect.Width, rect.Height)
End Function

' draws an image at a specified location.
Public Function DrawImagePointFv(ByVal Image As cImage, _
                                 ByVal x As Single, _
                                 ByVal y As Single) As GpStatus
    Dim lImage                   As Long
    
    If Image Is Nothing Then lImage = 0& Else lImage = Image.NativeImage
    m_uLastStatus = GdipDrawImage(m_lngGraphics, lImage, x, y)
    DrawImagePointFv = m_uLastStatus
End Function

Public Function DrawImagePointLv(ByVal Image As cImage, _
                                 ByVal x As Long, _
                                 ByVal y As Long) As GpStatus
    Dim lImage                   As Long
    
    If Image Is Nothing Then lImage = 0& Else lImage = Image.NativeImage
    m_uLastStatus = GdipDrawImage(m_lngGraphics, lImage, x, y)
    DrawImagePointLv = m_uLastStatus
End Function

Public Function DrawImagePointF(ByVal Image As cImage, ByVal pt As cPointF) As GpStatus
    DrawImagePointF = DrawImagePointFv(Image, pt.x, pt.y)
End Function

Public Function DrawImagePointL(ByVal Image As cImage, ByVal pt As cPoint) As GpStatus
    DrawImagePointL = DrawImagePointLv(Image, pt.x, pt.y)
End Function

'    // Affine Draw Image
'    // destPoints.length = 3: rect => parallelogram
'    //     destPoints[0] <=> top-left corner of the source rectangle
'    //     destPoints[1] <=> top-right corner
'    //     destPoints[2] <=> bottom-left corner
'    // destPoints.length = 4: rect => quad
'    //     destPoints[3] <=> bottom-right corner
Public Function DrawImageAffineF(ByVal Image As cImage, _
                                 ByRef destPoints() As cPointF, _
                                 ByVal lCount As Long) As GpStatus
    Dim uP()                     As POINTF
    Dim lImage                   As Long
    
    If (lCount <> 3) And (lCount <> 4) Then m_uLastStatus = InvalidParameter: DrawImageAffineF = m_uLastStatus: Exit Function
    If Image Is Nothing Then lImage = 0& Else lImage = Image.NativeImage
    Call ConvertPointFToType(destPoints, uP)
    m_uLastStatus = GdipDrawImagePoints(m_lngGraphics, lImage, uP(LBound(uP)), lCount)
    DrawImageAffineF = m_uLastStatus
End Function

Public Function DrawImageAffineL(ByVal Image As cImage, _
                                 ByRef destPoints() As cPoint, _
                                 ByVal lCount As Long) As GpStatus
    Dim uP()                     As POINTL
    Dim lImage                   As Long
    
    If (lCount <> 3) And (lCount <> 4) Then m_uLastStatus = InvalidParameter: DrawImageAffineL = m_uLastStatus: Exit Function
    If Image Is Nothing Then lImage = 0& Else lImage = Image.NativeImage
    Call ConvertPointLToType(destPoints, uP)
    m_uLastStatus = GdipDrawImagePointsI(m_lngGraphics, lImage, uP(LBound(uP)), lCount)
    DrawImageAffineL = m_uLastStatus
End Function

Public Function DrawImageRectFv(ByVal Image As cImage, _
                                ByVal x As Single, _
                                ByVal y As Single, _
                                ByVal Width As Single, _
                                ByVal Height As Single) As GpStatus
    Dim lImage                  As Long
    
    If Image Is Nothing Then lImage = 0& Else lImage = Image.NativeImage
    m_uLastStatus = GdipDrawImageRect(m_lngGraphics, lImage, x, y, Width, Height)
    DrawImageRectFv = m_uLastStatus
End Function

Public Function DrawImageRectLv(ByVal Image As cImage, _
                                ByVal x As Long, _
                                ByVal y As Long, _
                                ByVal Width As Long, _
                                ByVal Height As Long) As GpStatus
    Dim lImage                  As Long
    
    If Image Is Nothing Then lImage = 0& Else lImage = Image.NativeImage
    m_uLastStatus = GdipDrawImageRectI(m_lngGraphics, lImage, x, y, Width, Height)
    DrawImageRectLv = m_uLastStatus
End Function

Public Function DrawImageRectF(ByVal Image As cImage, ByVal rect As cRectF) As GpStatus
    DrawImageRectF = DrawImageRectFv(Image, rect.Left, rect.Top, rect.Width, rect.Height)
End Function

Public Function DrawImageRectL(ByVal Image As cImage, ByVal rect As cRect) As GpStatus
    DrawImageRectL = DrawImageRectLv(Image, rect.Left, rect.Top, rect.Width, rect.Height)
End Function

Public Function DrawImagePointRectF(ByVal Image As cImage, _
                                    ByVal x As Single, _
                                    ByVal y As Single, _
                                    ByVal srcx As Single, _
                                    ByVal srcy As Single, _
                                    ByVal srcwidth As Single, _
                                    ByVal srcheight As Single, _
                                    Optional ByVal uUnit As GpUnit = UnitPixel) As GpStatus
    Dim lImage                      As Long
    
    If Image Is Nothing Then lImage = 0& Else lImage = Image.NativeImage
    m_uLastStatus = GdipDrawImagePointRect(m_lngGraphics, lImage, x, y, _
                                           srcx, srcy, srcwidth, srcheight, uUnit)
    DrawImagePointRectF = m_uLastStatus
End Function

Public Function DrawImagePointRectL(ByVal Image As cImage, _
                                    ByVal x As Long, _
                                    ByVal y As Long, _
                                    ByVal srcx As Long, _
                                    ByVal srcy As Long, _
                                    ByVal srcwidth As Long, _
                                    ByVal srcheight As Long, _
                                    Optional ByVal uUnit As GpUnit = UnitPixel) As GpStatus
    Dim lImage                      As Long
    
    If Image Is Nothing Then lImage = 0& Else lImage = Image.NativeImage
    m_uLastStatus = GdipDrawImagePointRectI(m_lngGraphics, lImage, x, y, _
                                            srcx, srcy, srcwidth, srcheight, uUnit)
    DrawImagePointRectL = m_uLastStatus
End Function

Public Function DrawImagePointsRectF(ByVal Image As cImage, _
                                     ByRef destPoints() As cPointF, _
                                     ByVal lCount As Long, _
                                     ByVal srcx As Single, _
                                     ByVal srcy As Single, _
                                     ByVal srcwidth As Single, _
                                     ByVal srcheight As Single, _
                                     Optional ByVal srcUnit As GpUnit = UnitPixel, _
                                     Optional ByVal imageAttributes As cImageAttributes = Nothing, _
                                     Optional ByVal callback As Long = 0&, _
                                     Optional ByVal callbackData As Long = 0&) _
                                     As GpStatus
    Dim lImage                       As Long
    Dim lImageAttr                   As Long
    Dim uP()                         As POINTF
    
    If Image Is Nothing Then lImage = 0& Else lImage = Image.NativeImage
    If imageAttributes Is Nothing Then lImageAttr = 0& Else lImageAttr = imageAttributes.NativeImageAttributes
    Call ConvertPointFToType(destPoints, uP)
    m_uLastStatus = GdipDrawImagePointsRect(m_lngGraphics, lImage, uP(LBound(uP)), _
                                            lCount, srcx, srcy, srcwidth, srcheight, _
                                            srcUnit, lImageAttr, callback, callbackData)
    Erase uP
    DrawImagePointsRectF = m_uLastStatus
End Function

Public Function DrawImagePointsRectL(ByVal Image As cImage, _
                                     ByRef destPoints() As cPoint, _
                                     ByVal lCount As Long, _
                                     ByVal srcx As Long, _
                                     ByVal srcy As Long, _
                                     ByVal srcwidth As Long, _
                                     ByVal srcheight As Long, _
                                     Optional ByVal srcUnit As GpUnit = UnitPixel, _
                                     Optional ByVal imageAttributes As cImageAttributes = Nothing, _
                                     Optional ByVal callback As Long = 0&, _
                                     Optional ByVal callbackData As Long = 0&) _
                                     As GpStatus
    Dim lImage                       As Long
    Dim lImageAttr                   As Long
    Dim uP()                         As POINTL
    
    If Image Is Nothing Then lImage = 0& Else lImage = Image.NativeImage
    If imageAttributes Is Nothing Then lImageAttr = 0& Else lImageAttr = imageAttributes.NativeImageAttributes
    Call ConvertPointLToType(destPoints, uP)
    m_uLastStatus = GdipDrawImagePointsRectI(m_lngGraphics, lImage, uP(LBound(uP)), _
                                             lCount, srcx, srcy, srcwidth, srcheight, _
                                             srcUnit, lImageAttr, callback, callbackData)
    Erase uP
    DrawImagePointsRectL = m_uLastStatus
End Function

Public Function DrawImageRectRectFv(ByVal Image As cImage, _
                                    ByVal dstX As Single, _
                                    ByVal dstY As Single, _
                                    ByVal dstWidth As Single, _
                                    ByVal dstHeight As Single, _
                                    ByVal srcx As Single, _
                                    ByVal srcy As Single, _
                                    ByVal srcwidth As Single, _
                                    ByVal srcheight As Single, _
                                    Optional ByVal srcUnit As GpUnit = UnitPixel, _
                                    Optional ByVal imageAttributes As cImageAttributes = Nothing, _
                                    Optional ByVal callback As Long = 0&, _
                                    Optional ByVal callbackData As Long = 0&) _
                                    As GpStatus
    Dim lImage                      As Long
    Dim lImageAttr                  As Long
    
    If Image Is Nothing Then lImage = 0& Else lImage = Image.NativeImage
    If imageAttributes Is Nothing Then lImageAttr = 0& Else lImageAttr = imageAttributes.NativeImageAttributes
    m_uLastStatus = GdipDrawImageRectRect(m_lngGraphics, lImage, _
                                          dstX, dstY, dstWidth, dstHeight, _
                                          srcx, srcy, srcwidth, srcheight, _
                                          srcUnit, lImageAttr, callback, callbackData)
    DrawImageRectRectFv = m_uLastStatus
End Function

Public Function DrawImageRectRectLv(ByVal Image As cImage, _
                                   ByVal dstX As Long, _
                                   ByVal dstY As Long, _
                                   ByVal dstWidth As Long, _
                                   ByVal dstHeight As Long, _
                                   ByVal srcx As Long, _
                                   ByVal srcy As Long, _
                                   ByVal srcwidth As Long, _
                                   ByVal srcheight As Long, _
                                   Optional ByVal srcUnit As GpUnit = UnitPixel, _
                                   Optional ByVal imageAttributes As cImageAttributes = Nothing, _
                                   Optional ByVal callback As Long = 0&, _
                                   Optional ByVal callbackData As Long = 0&) _
                                   As GpStatus
    Dim lImage                     As Long
    Dim lImageAttr                 As Long
    
    If Image Is Nothing Then lImage = 0& Else lImage = Image.NativeImage
    If imageAttributes Is Nothing Then lImageAttr = 0& Else lImageAttr = imageAttributes.NativeImageAttributes
    m_uLastStatus = GdipDrawImageRectRectI(m_lngGraphics, lImage, _
                                           dstX, dstY, dstWidth, dstHeight, _
                                           srcx, srcy, srcwidth, srcheight, _
                                           srcUnit, lImageAttr, callback, callbackData)
    DrawImageRectRectLv = m_uLastStatus
End Function

Public Function DrawImageRectRectF(ByVal Image As cImage, _
                                   ByVal destRect As cRectF, _
                                   ByVal srcx As Single, _
                                   ByVal srcy As Single, _
                                   ByVal srcwidth As Single, _
                                   ByVal srcheight As Single, _
                                   Optional ByVal srcUnit As GpUnit = UnitPixel, _
                                   Optional ByVal imageAttributes As cImageAttributes = Nothing, _
                                   Optional ByVal callback As Long = 0&, _
                                   Optional ByVal callbackData As Long = 0&) _
                                   As GpStatus
    DrawImageRectRectF = DrawImageRectRectFv(Image, destRect.Left, destRect.Top, _
                                             destRect.Width, destRect.Height, _
                                             srcx, srcy, srcwidth, srcheight, _
                                             srcUnit, imageAttributes, callback, callbackData)
End Function

Public Function DrawImageRectRectL(ByVal Image As cImage, _
                                   ByVal destRect As cRect, _
                                   ByVal srcx As Long, _
                                   ByVal srcy As Long, _
                                   ByVal srcwidth As Long, _
                                   ByVal srcheight As Long, _
                                   Optional ByVal srcUnit As GpUnit = UnitPixel, _
                                   Optional ByVal imageAttributes As cImageAttributes = Nothing, _
                                   Optional ByVal callback As Long = 0&, _
                                   Optional ByVal callbackData As Long = 0&) _
                                   As GpStatus
    DrawImageRectRectL = DrawImageRectRectLv(Image, destRect.Left, destRect.Top, _
                                             destRect.Width, destRect.Height, _
                                             srcx, srcy, srcwidth, srcheight, _
                                             srcUnit, imageAttributes, callback, callbackData)
End Function

' draws a line that connects two points.
Public Function DrawLineF(ByVal pen As cPen, _
                          ByVal x1 As Single, _
                          ByVal y1 As Single, _
                          ByVal x2 As Single, _
                          ByVal y2 As Single) As GpStatus
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawLineF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipDrawLine(m_lngGraphics, pen.NativePen, x1, y1, x2, y2)
    DrawLineF = m_uLastStatus
End Function

' draws a line that connects two points.
Public Function DrawLineL(ByVal pen As cPen, _
                          ByVal x1 As Long, _
                          ByVal y1 As Long, _
                          ByVal x2 As Long, _
                          ByVal y2 As Long) As GpStatus
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawLineL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipDrawLineI(m_lngGraphics, pen.NativePen, x1, y1, x2, y2)
    DrawLineL = m_uLastStatus
End Function

Public Function DrawLinePointF(ByVal pen As cPen, _
                               ByVal pt1 As cPointF, _
                               ByVal pt2 As cPointF) As GpStatus
    If pt1 Is Nothing Or pt2 Is Nothing Then
       m_uLastStatus = InvalidParameter: DrawLinePointF = m_uLastStatus: Exit Function
    End If
    DrawLinePointF = DrawLineF(pen, pt1.x, pt1.y, pt2.x, pt2.y)
End Function

Public Function DrawLinePointL(ByVal pen As cPen, _
                               ByVal pt1 As cPoint, _
                               ByVal pt2 As cPoint) As GpStatus
    If pt1 Is Nothing Or pt2 Is Nothing Then
       m_uLastStatus = InvalidParameter: DrawLinePointL = m_uLastStatus: Exit Function
    End If
    DrawLinePointL = DrawLineL(pen, pt1.x, pt1.y, pt2.x, pt2.y)
End Function

' draws a sequence of connected lines.
Public Function DrawLinesPointF(ByVal pen As cPen, _
                                ByRef uPoints() As cPointF, _
                                ByVal lCount As Long) As GpStatus
    Dim uP() As POINTF
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawLinesPointF = m_uLastStatus: Exit Function
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipDrawLines(m_lngGraphics, pen.NativePen, uP(LBound(uP)), lCount)
    Erase uP
    DrawLinesPointF = m_uLastStatus
End Function

Public Function DrawLinesPointL(ByVal pen As cPen, _
                                ByRef uPoints() As cPoint, _
                                ByVal lCount As Long) As GpStatus
    Dim uP()                    As POINTL
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawLinesPointL = m_uLastStatus: Exit Function
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipDrawLinesI(m_lngGraphics, pen.NativePen, uP(LBound(uP)), lCount)
    Erase uP
    DrawLinesPointL = m_uLastStatus
End Function

' draws a sequence of lines and curves defined by a GraphicsPath object.
Public Function DrawPath(ByVal pen As cPen, ByVal path As cGraphicsPath) As GpStatus
    Dim lPen As Long, lPath As Long
    
    If pen Is Nothing Then lPen = 0& Else lPen = pen.NativePen
    If path Is Nothing Then lPath = 0& Else lPath = path.NativePath
    m_uLastStatus = GdipDrawPath(m_lngGraphics, lPen, lPath)
    DrawPath = m_uLastStatus
End Function

' draws a pie.
Public Function DrawPieF(ByVal pen As cPen, _
                         ByVal x As Single, _
                         ByVal y As Single, _
                         ByVal Width As Single, _
                         ByVal Height As Single, _
                         ByVal startAngle As Single, _
                         ByVal sweepAngle As Single) As GpStatus
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawPieF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipDrawPie(m_lngGraphics, pen.NativePen, x, y, Width, Height, startAngle, sweepAngle)
    DrawPieF = m_uLastStatus
End Function

Public Function DrawPieL(ByVal pen As cPen, _
                         ByVal x As Long, _
                         ByVal y As Long, _
                         ByVal Width As Long, _
                         ByVal Height As Long, _
                         ByVal startAngle As Single, _
                         ByVal sweepAngle As Single) As GpStatus
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawPieL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipDrawPieI(m_lngGraphics, pen.NativePen, x, y, Width, Height, startAngle, sweepAngle)
    DrawPieL = m_uLastStatus
End Function

Public Function DrawPieRectF(ByVal pen As cPen, _
                             ByVal rect As cRectF, _
                             ByVal startAngle As Single, _
                             ByVal sweepAngle As Single) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: DrawPieRectF = m_uLastStatus: Exit Function
    DrawPieRectF = DrawPieF(pen, rect.Left, rect.Top, rect.Width, rect.Height, startAngle, sweepAngle)
End Function

Public Function DrawPieRectL(ByVal pen As cPen, _
                             ByVal rect As cRect, _
                             ByVal startAngle As Single, _
                             ByVal sweepAngle As Single) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: DrawPieRectL = m_uLastStatus: Exit Function
    DrawPieRectL = DrawPieL(pen, rect.Left, rect.Top, rect.Width, rect.Height, startAngle, sweepAngle)
End Function

' draws a polygon.
Public Function DrawPolygonF(ByVal pen As cPen, _
                             ByRef uPoints() As cPointF, _
                             ByVal lCount As Long) As GpStatus
    Dim uP()                 As POINTF
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawPolygonF = m_uLastStatus: Exit Function
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipDrawPolygon(m_lngGraphics, pen.NativePen, uP(LBound(uP)), lCount)
    DrawPolygonF = m_uLastStatus
End Function

Public Function DrawPolygonL(ByVal pen As cPen, _
                             ByRef uPoints() As cPoint, _
                             ByVal lCount As Long) As GpStatus
    Dim uP()                 As POINTL
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawPolygonL = m_uLastStatus: Exit Function
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipDrawPolygonI(m_lngGraphics, pen.NativePen, uP(LBound(uP)), lCount)
    DrawPolygonL = m_uLastStatus
End Function

' draws a rectangle.
Public Function DrawRectangleF(ByVal pen As cPen, _
                               ByVal x As Single, _
                               ByVal y As Single, _
                               ByVal Width As Single, _
                               ByVal Height As Single) As GpStatus
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawRectangleF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipDrawRectangle(m_lngGraphics, pen.NativePen, x, y, Width, Height)
    DrawRectangleF = m_uLastStatus
End Function

Public Function DrawRectangleL(ByVal pen As cPen, _
                               ByVal x As Long, _
                               ByVal y As Long, _
                               ByVal Width As Long, _
                               ByVal Height As Long) As GpStatus
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawRectangleL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipDrawRectangleI(m_lngGraphics, pen.NativePen, x, y, Width, Height)
    DrawRectangleL = m_uLastStatus
End Function

Public Function DrawRectangleRectF(ByVal pen As cPen, ByVal rect As cRectF) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: DrawRectangleRectF = m_uLastStatus: Exit Function
    DrawRectangleRectF = DrawRectangleF(pen, rect.Left, rect.Top, rect.Width, rect.Height)
End Function

Public Function DrawRectangleRectL(ByVal pen As cPen, ByVal rect As cRect) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: DrawRectangleRectL = m_uLastStatus: Exit Function
    DrawRectangleRectL = DrawRectangleL(pen, rect.Left, rect.Top, rect.Width, rect.Height)
End Function

' draws a sequence of rectangles.
Public Function DrawRectanglesRectF(ByVal pen As cPen, _
                                    ByRef uRects() As cRectF, _
                                    ByVal lCount As Long) As GpStatus
    Dim uR()                        As RECTF
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawRectanglesRectF = m_uLastStatus: Exit Function
    Call ConvertRectFToType(uRects, uR)
    m_uLastStatus = GdipDrawRectangles(m_lngGraphics, pen.NativePen, uR(LBound(uR)), lCount)
    Erase uR
    DrawRectanglesRectF = m_uLastStatus
End Function

Public Function DrawRectanglesRectL(ByVal pen As cPen, _
                                    ByRef uRects() As cRect, _
                                    ByVal lCount As Long) As GpStatus
    Dim uR()                        As RECTL
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: DrawRectanglesRectL = m_uLastStatus: Exit Function
    Call ConvertRectLToType(uRects, uR)
    m_uLastStatus = GdipDrawRectanglesI(m_lngGraphics, pen.NativePen, uR(LBound(uR)), lCount)
    Erase uR
    DrawRectanglesRectL = m_uLastStatus
End Function

' draws a string based on a font and an origin for the string.
Public Function DrawStringPointF(ByVal sText As String, _
                                 ByVal lLength As Long, _
                                 ByVal font As cFont, _
                                 ByVal origin As cPointF, _
                                 ByVal Brush As cBrush) As GpStatus
    Dim lFont                    As Long
    Dim lBrush                   As Long
    Dim clsRect                  As New cRectF

    clsRect.Create origin.x, origin.y, &HFFFFF, &HFFFFF
    If font Is Nothing Then lFont = 0& Else lFont = font.NativeFont
    If Brush Is Nothing Then lBrush = 0& Else lBrush = Brush.NativeBrush
    m_uLastStatus = GdipDrawString(m_lngGraphics, _
                                   StrConv(sText, vbUnicode), _
                                   lLength, _
                                   lFont, _
                                   clsRect.ToType, _
                                   ByVal 0&, _
                                   lBrush)
    Set clsRect = Nothing
    DrawStringPointF = m_uLastStatus
End Function

' draws a string based on a font, a string origin, and a format.
Public Function DrawStringPointF2(ByVal sText As String, _
                                 ByVal lLength As Long, _
                                 ByVal font As cFont, _
                                 ByVal origin As cPointF, _
                                 ByVal StringFormat As cStringFormat, _
                                 ByVal Brush As cBrush) As GpStatus
    Dim lFont                    As Long
    Dim lBrush                   As Long
    Dim lFormat                  As Long
    Dim clsRect                  As New cRectF
    
    clsRect.Create origin.x, origin.y, 0#, 0#
    If font Is Nothing Then lFont = 0& Else lFont = font.NativeFont
    If Brush Is Nothing Then lBrush = 0& Else lBrush = Brush.NativeBrush
    If StringFormat Is Nothing Then lFormat = 0& Else lFormat = StringFormat.NativeStringFormat
    m_uLastStatus = GdipDrawString(m_lngGraphics, _
                                   StrConv(sText, vbUnicode), _
                                   lLength, _
                                   lFont, _
                                   clsRect.ToType, _
                                   lFormat, _
                                   lBrush)
    Set clsRect = Nothing
    DrawStringPointF2 = m_uLastStatus
End Function

' draws a string based on a font, a layout rectangle, and a format.
Public Function DrawStringRectF(ByVal sText As String, _
                                ByVal lLength As Long, _
                                ByVal font As cFont, _
                                ByVal layoutRect As cRectF, _
                                ByVal StringFormat As cStringFormat, _
                                ByVal Brush As cBrush) As GpStatus
    Dim lFont                   As Long
    Dim lBrush                  As Long
    Dim lFormat                 As Long
    
    If font Is Nothing Then lFont = 0& Else lFont = font.NativeFont
    If Brush Is Nothing Then lBrush = 0& Else lBrush = Brush.NativeBrush
    If StringFormat Is Nothing Then lFormat = 0& Else lFormat = StringFormat.NativeStringFormat
    m_uLastStatus = GdipDrawString(m_lngGraphics, _
                                   StrConv(sText, vbUnicode), _
                                   lLength, _
                                   lFont, _
                                   layoutRect.ToType, _
                                   lFormat, _
                                   lBrush)
    DrawStringRectF = m_uLastStatus
End Function

' closes a graphics container that was previously opened by the BeginContainer method.
Public Function EndContainer(ByVal lState As Long) As GpStatus
    m_uLastStatus = GdipEndContainer(m_lngGraphics, lState)
    EndContainer = m_uLastStatus
End Function

' updates the clipping region to the portion of itself that does not intersect the specified rectangle.
Public Function ExcludeClipSizeF(ByVal x As Single, ByVal y As Single, _
                                 ByVal Width As Single, ByVal Height As Single) As GpStatus
    m_uLastStatus = GdipSetClipRect(m_lngGraphics, x, y, Width, Height, CombineModeExclude)
    ExcludeClipSizeF = m_uLastStatus
End Function

Public Function ExcludeClipSizeL(ByVal x As Long, ByVal y As Long, _
                                 ByVal Width As Long, ByVal Height As Long) As GpStatus
    m_uLastStatus = GdipSetClipRectI(m_lngGraphics, x, y, Width, Height, CombineModeExclude)
    ExcludeClipSizeL = m_uLastStatus
End Function

Public Function ExcludeClipRectF(ByVal rect As cRectF) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: ExcludeClipRectF = m_uLastStatus: Exit Function
    ExcludeClipRectF = ExcludeClipSizeF(rect.Left, rect.Top, rect.Width, rect.Height)
End Function

Public Function ExcludeClipRectL(ByVal rect As cRect) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: ExcludeClipRectL = m_uLastStatus: Exit Function
    ExcludeClipRectL = ExcludeClipSizeL(rect.Left, rect.Top, rect.Width, rect.Height)
End Function

' updates the clipping region with the portion of itself that does not overlap the specified region.
Public Function ExcludeClipRegion(ByVal region As cRegion) As GpStatus
    If region Is Nothing Then m_uLastStatus = InvalidParameter: ExcludeClipRegion = m_uLastStatus: Exit Function
    m_uLastStatus = GdipSetClipRegion(m_lngGraphics, region.NativeRegion, CombineModeExclude)
    ExcludeClipRegion = m_uLastStatus
End Function

' creates a closed cardinal spline from an array of points and uses a brush to fill the interior of the spline.
Public Function FillClosedCurveF(ByVal Brush As cBrush, _
                                 ByRef uPoints() As cPointF, _
                                 ByVal lCount As Long) As GpStatus
    Dim uP()                     As POINTF
    
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillClosedCurveF = m_uLastStatus: Exit Function
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipFillClosedCurve(m_lngGraphics, _
                                        Brush.NativeBrush, _
                                        uP(LBound(uP)), _
                                        lCount)
    Erase uP
    FillClosedCurveF = m_uLastStatus
End Function

' creates a closed cardinal spline from an array of points and uses a brush to fill,
' according to a specified mode, the interior of the spline.
Public Function FillClosedCurveF2(ByVal Brush As cBrush, _
                                 ByRef uPoints() As cPointF, _
                                 ByVal lCount As Long, _
                                 ByVal uFillMode As FillMode, _
                                 Optional ByVal tension As Single = 0.5) As GpStatus
    Dim uP()                     As POINTF
    
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillClosedCurveF2 = m_uLastStatus: Exit Function
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipFillClosedCurve2(m_lngGraphics, _
                                         Brush.NativeBrush, _
                                         uP(LBound(uP)), _
                                         lCount, _
                                         tension, _
                                         uFillMode)
    Erase uP
    FillClosedCurveF2 = m_uLastStatus
End Function

Public Function FillClosedCurveL(ByVal Brush As cBrush, _
                                 ByRef uPoints() As cPoint, _
                                 ByVal lCount As Long) As GpStatus
    Dim uP()                     As POINTL
    
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillClosedCurveL = m_uLastStatus: Exit Function
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipFillClosedCurveI(m_lngGraphics, _
                                        Brush.NativeBrush, _
                                        uP(LBound(uP)), _
                                        lCount)
    Erase uP
    FillClosedCurveL = m_uLastStatus
End Function

Public Function FillClosedCurveL2(ByVal Brush As cBrush, _
                                 ByRef uPoints() As cPoint, _
                                 ByVal lCount As Long, _
                                 ByVal uFillMode As FillMode, _
                                 Optional ByVal tension As Single = 0.5) As GpStatus
    Dim uP()                     As POINTL
    
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillClosedCurveL2 = m_uLastStatus: Exit Function
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipFillClosedCurve2I(m_lngGraphics, _
                                         Brush.NativeBrush, _
                                         uP(LBound(uP)), _
                                         lCount, _
                                         tension, _
                                         uFillMode)
    Erase uP
    FillClosedCurveL2 = m_uLastStatus
End Function

' uses a brush to fill the interior of an ellipse that is specified by coordinates and dimensions.
Public Function FillEllipseF(ByVal Brush As cBrush, _
                             ByVal x As Single, _
                             ByVal y As Single, _
                             ByVal Width As Single, _
                             ByVal Height As Single) As GpStatus
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillEllipseF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipFillEllipse(m_lngGraphics, Brush.NativeBrush, _
                                    x, y, Width, Height)
    FillEllipseF = m_uLastStatus
End Function

Public Function FillEllipseL(ByVal Brush As cBrush, _
                             ByVal x As Long, _
                             ByVal y As Long, _
                             ByVal Width As Long, _
                             ByVal Height As Long) As GpStatus
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillEllipseL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipFillEllipseI(m_lngGraphics, Brush.NativeBrush, _
                                    x, y, Width, Height)
    FillEllipseL = m_uLastStatus
End Function

' uses a brush to fill the interior of an ellipse that is specified by a rectangle.
Public Function FillEllipseRectF(ByVal Brush As cBrush, ByVal rect As cRectF) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: FillEllipseRectF = m_uLastStatus: Exit Function
    FillEllipseRectF = FillEllipseF(Brush, rect.Left, rect.Top, rect.Width, rect.Height)
End Function

Public Function FillEllipseRectL(ByVal Brush As cBrush, ByVal rect As cRect) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: FillEllipseRectL = m_uLastStatus: Exit Function
    FillEllipseRectL = FillEllipseL(Brush, rect.Left, rect.Top, rect.Width, rect.Height)
End Function

' uses a brush to fill the interior of a path. If a figure in the path is not closed,
' this method treats the nonclosed figure as if it were closed by a straight line
' that connects the figure's starting and ending points.
Public Function fillPath(ByVal Brush As cBrush, ByVal path As cGraphicsPath) As GpStatus
    If Brush Is Nothing Or path Is Nothing Then m_uLastStatus = InvalidParameter: fillPath = m_uLastStatus: Exit Function
    m_uLastStatus = GdipFillPath(m_lngGraphics, Brush.NativeBrush, path.NativePath)
    fillPath = m_uLastStatus
End Function

' uses a brush to fill the interior of a pie.
Public Function FillPieF(ByVal Brush As cBrush, _
                         ByVal x As Single, _
                         ByVal y As Single, _
                         ByVal Width As Single, _
                         ByVal Height As Single, _
                         ByVal startAngle As Single, _
                         ByVal sweepAngle As Single) As GpStatus
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillPieF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipFillPie(m_lngGraphics, Brush.NativeBrush, _
                                x, y, Width, Height, startAngle, sweepAngle)
    FillPieF = m_uLastStatus
End Function

Public Function FillPieL(ByVal Brush As cBrush, _
                         ByVal x As Long, _
                         ByVal y As Long, _
                         ByVal Width As Long, _
                         ByVal Height As Long, _
                         ByVal startAngle As Single, _
                         ByVal sweepAngle As Single) As GpStatus
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillPieL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipFillPieI(m_lngGraphics, Brush.NativeBrush, _
                                x, y, Width, Height, startAngle, sweepAngle)
    FillPieL = m_uLastStatus
End Function

Public Function FillPieRectF(ByVal Brush As cBrush, _
                             ByVal rect As cRectF, _
                             ByVal startAngle As Single, _
                             ByVal sweepAngle As Single) As GpStatus
    FillPieRectF = FillPieF(Brush, rect.Left, rect.Top, _
                            rect.Width, rect.Height, _
                            startAngle, sweepAngle)
End Function

Public Function FillPieRectL(ByVal Brush As cBrush, _
                             ByVal rect As cRect, _
                             ByVal startAngle As Single, _
                             ByVal sweepAngle As Single) As GpStatus
    FillPieRectL = FillPieL(Brush, rect.Left, rect.Top, _
                            rect.Width, rect.Height, _
                            startAngle, sweepAngle)
End Function

' uses a brush to fill the interior of a polygon.
Public Function FillPolygonF(ByVal Brush As cBrush, _
                             ByRef uPoints() As cPointF, _
                             ByVal lCount As Long, _
                             Optional uFillMode As FillMode = FillModeAlternate) _
                             As GpStatus
    Dim uP()                 As POINTF
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillPolygonF = m_uLastStatus: Exit Function
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipFillPolygon(m_lngGraphics, Brush.NativeBrush, _
                                    uP(LBound(uP)), lCount, uFillMode)
    FillPolygonF = m_uLastStatus
End Function

Public Function FillPolygonL(ByVal Brush As cBrush, _
                             ByRef uPoints() As cPoint, _
                             ByVal lCount As Long, _
                             Optional uFillMode As FillMode = FillModeAlternate) _
                             As GpStatus
    Dim uP()                 As POINTL
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillPolygonL = m_uLastStatus: Exit Function
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipFillPolygonI(m_lngGraphics, Brush.NativeBrush, _
                                    uP(LBound(uP)), lCount, uFillMode)
    FillPolygonL = m_uLastStatus
End Function

' uses a brush to fill the interior of a rectangle.
Public Function FillRectangleF(ByVal Brush As cBrush, _
                               ByVal x As Single, _
                               ByVal y As Single, _
                               ByVal Width As Single, _
                               ByVal Height As Single) As GpStatus
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillRectangleF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipFillRectangle(m_lngGraphics, Brush.NativeBrush, x, y, Width, Height)
    FillRectangleF = m_uLastStatus
End Function

Public Function FillRectangleL(ByVal Brush As cBrush, _
                               ByVal x As Long, _
                               ByVal y As Long, _
                               ByVal Width As Long, _
                               ByVal Height As Long) As GpStatus
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillRectangleL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipFillRectangleI(m_lngGraphics, Brush.NativeBrush, x, y, Width, Height)
    FillRectangleL = m_uLastStatus
End Function

Public Function FillRectangleRectF(ByVal Brush As cBrush, ByVal rect As cRectF) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: FillRectangleRectF = m_uLastStatus: Exit Function
    FillRectangleRectF = FillRectangleF(Brush, rect.Left, rect.Top, rect.Width, rect.Height)
End Function

Public Function FillRectangleRectL(ByVal Brush As cBrush, ByVal rect As cRect) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: FillRectangleRectL = m_uLastStatus: Exit Function
    FillRectangleRectL = FillRectangleL(Brush, rect.Left, rect.Top, rect.Width, rect.Height)
End Function

' draws a sequence of rectangles.
Public Function FillRectanglesRectF(ByVal Brush As cBrush, _
                                    ByRef uRects() As cRectF, _
                                    ByVal lCount As Long) As GpStatus
    Dim uR()                        As RECTF
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillRectanglesRectF = m_uLastStatus: Exit Function
    Call ConvertRectFToType(uRects, uR)
    m_uLastStatus = GdipFillRectangles(m_lngGraphics, Brush.NativeBrush, uR(LBound(uR)), lCount)
    Erase uR
    FillRectanglesRectF = m_uLastStatus
End Function

Public Function FillRectanglesRectL(ByVal Brush As cBrush, _
                                    ByRef uRects() As cRect, _
                                    ByVal lCount As Long) As GpStatus
    Dim uR()                        As RECTL
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: FillRectanglesRectL = m_uLastStatus: Exit Function
    Call ConvertRectLToType(uRects, uR)
    m_uLastStatus = GdipFillRectanglesI(m_lngGraphics, Brush.NativeBrush, uR(LBound(uR)), lCount)
    Erase uR
    FillRectanglesRectL = m_uLastStatus
End Function

' uses a brush to fill a specified region.
Public Function FillRegion(ByVal Brush As cBrush, ByVal region As cRegion) As GpStatus
    If Brush Is Nothing Or region Is Nothing Then m_uLastStatus = InvalidParameter: FillRegion = m_uLastStatus: Exit Function
    m_uLastStatus = GdipFillRegion(m_lngGraphics, Brush.NativeBrush, region.NativeRegion)
    FillRegion = m_uLastStatus
End Function

' flushes all pending graphics operations.
Public Sub Flush(Optional ByVal intention As FlushIntention = FlushIntentionFlush)
    Call GdipFlush(m_lngGraphics, intention)
End Sub

' Creates a Graphics object that is associated with a specified device context.
Public Function FromHDC(ByVal lhDC As Long) As GpStatus
    Call DisposeGraphics
    m_uLastStatus = GdipCreateFromHDC(lhDC, m_lngGraphics)
    FromHDC = m_uLastStatus
End Function

' Creates a Graphics object that is associated with
' a specified device context and a specified device.
Public Function FromHDCDevice(ByVal lhDC As Long, ByVal hDevice As Long) As GpStatus
   Call DisposeGraphics
   m_uLastStatus = GdipCreateFromHDC2(lhDC, hDevice, m_lngGraphics)
   FromHDCDevice = m_uLastStatus
End Function

' Creates a Graphics object that is associated with a specified window.
Public Function FromHWnd(ByVal lhWnd As Long) As GpStatus
   Call DisposeGraphics
   m_uLastStatus = GdipCreateFromHWND(lhWnd, m_lngGraphics)
   FromHWnd = m_uLastStatus
End Function

' Creates a Graphics object that is associated with an Image object.
Public Function FromImage(ByVal Image As cImage) As GpStatus
   Call DisposeGraphics
   m_uLastStatus = GdipGetImageGraphicsContext(Image.NativeImage, m_lngGraphics)
   FromImage = m_uLastStatus
End Function

' gets the clipping region of this Graphics object.
Public Function GetClip(ByRef region As cRegion) As GpStatus
    Dim lRegion As Long
    
    m_uLastStatus = GdipGetClip(m_lngGraphics, lRegion)
    If m_uLastStatus = Ok Then
       If region Is Nothing Then Set region = New cRegion
       region.fInitialize (lRegion)
    End If
    GetClip = m_uLastStatus
End Function

' gets a rectangle that encloses the clipping region of this Graphics object.
Public Function GetClipBoundsRectF(ByRef rect As cRectF) As GpStatus
    Dim uR As RECTF
    
    m_uLastStatus = GdipGetClipBounds(m_lngGraphics, uR)
    If m_uLastStatus = Ok Then
       If rect Is Nothing Then Set rect = New cRectF
       rect.CreateFromType uR
    End If
    GetClipBoundsRectF = m_uLastStatus
End Function

Public Function GetClipBoundsRectL(ByRef rect As cRect) As GpStatus
    Dim uR As RECTL
    
    m_uLastStatus = GdipGetClipBoundsI(m_lngGraphics, uR)
    If m_uLastStatus = Ok Then
       If rect Is Nothing Then Set rect = New cRect
       rect.CreateFromType uR
    End If
    GetClipBoundsRectL = m_uLastStatus
End Function

' gets the compositing mode currently set for this Graphics object.
Public Function GetCompositingMode() As CompositingMode
    Dim uMode As CompositingMode
    m_uLastStatus = GdipGetCompositingMode(m_lngGraphics, uMode)
    GetCompositingMode = uMode
End Function

' gets the compositing quality currently set for this Graphics object.
Public Function GetCompositingQuality() As CompositingQuality
    Dim uQuality As CompositingQuality
    
    m_uLastStatus = GdipGetCompositingQuality(m_lngGraphics, uQuality)
    GetCompositingQuality = uQuality
End Function

' gets the horizontal resolution, in dots per inch, of the display device associated with this Graphics object.
Public Function GetDpiX() As Single
    Dim dpi As Single
    m_uLastStatus = GdipGetDpiX(m_lngGraphics, dpi)
    GetDpiX = dpi
End Function

' gets the vertical resolution, in dots per inch, of the display device associated with this Graphics object.
Public Function GetDpiY() As Single
    Dim dpi As Single
    m_uLastStatus = GdipGetDpiY(m_lngGraphics, dpi)
    GetDpiY = dpi
End Function

' gets a handle to a Windows halftone palette.
Public Function GetHalftonePalette() As Long
    GetHalftonePalette = GdipCreateHalftonePalette
End Function

' gets a handle to the device context associated with this Graphics object.
Public Function GetHDC() As Long
    Dim hDC As Long
    
    hDC = 0: m_uLastStatus = GdipGetDC(m_lngGraphics, hDC)
    GetHDC = hDC
End Function

' gets the interpolation mode currently set for this Graphics object.
' The interpolation mode determines the algorithm that is used when images are scaled or rotated.
Public Function GetInterpolationMode() As InterpolationMode
    Dim uMode As InterpolationMode
    
    uMode = InterpolationModeInvalid
    m_uLastStatus = GdipGetInterpolationMode(m_lngGraphics, uMode)
    GetInterpolationMode = uMode
End Function

' returns a value that indicates the nature of this Graphics object's most recent method failure.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' GetNearestColor (for <= 8bpp surfaces).  Note: Alpha is ignored.
' gets the nearest color to the color that is passed in.
' This method works on 8-bits per pixel or lower display devices for which
' there is an 8-bit color palette.
Public Function GetNearestColor(ByRef color As cColor) As GpStatus
    Dim lArgb As Long
    
    If color Is Nothing Then
       m_uLastStatus = InvalidParameter
    Else
       lArgb = color.GetValue()
       m_uLastStatus = GdipGetNearestColor(m_lngGraphics, lArgb)
       If m_uLastStatus = Ok Then color.SetValue lArgb
    End If
    GetNearestColor = m_uLastStatus
End Function

' gets the scaling factor currently set for the page transformation of this Graphics object.
'The page transformation converts page coordinates to device coordinates.
Public Function GetPageScale() As Single
    Dim sScale As Single
    
    m_uLastStatus = GdipGetPageScale(m_lngGraphics, sScale)
    GetPageScale = sScale
End Function

' gets the unit of measure currently set for this Graphics object.
Public Function GetPageUnit() As GpUnit
    Dim uUnit As GpUnit
    
    m_uLastStatus = GdipGetPageUnit(m_lngGraphics, uUnit)
    GetPageUnit = uUnit
End Function

' gets the pixel offset mode currently set for this Graphics object.
Public Function GetPixelOffsetMode() As PixelOffsetMode
    Dim uMode As PixelOffsetMode
    
    uMode = PixelOffsetModeInvalid
    m_uLastStatus = GdipGetPixelOffsetMode(m_lngGraphics, uMode)
    GetPixelOffsetMode = uMode
End Function

' gets the rendering origin currently set for this Graphics object.
' The rendering origin is used to set the dither origin for 8-bits per pixel
' and 16-bits per pixel dithering and is also used to set the origin for hatch brushes.
Public Function GetRenderingOrigin(ByRef x As Long, ByRef y As Long) As GpStatus
    m_uLastStatus = GdipGetRenderingOrigin(m_lngGraphics, x, y)
    GetRenderingOrigin = m_uLastStatus
End Function

' determines whether smoothing (antialiasing) is applied to the Graphics object.
Public Function GetSmoothingMode() As SmoothingMode
    Dim uMode As SmoothingMode
    
    uMode = SmoothingModeInvalid
    m_uLastStatus = GdipGetSmoothingMode(m_lngGraphics, uMode)
    GetSmoothingMode = uMode
End Function

' gets the contrast value currently set for this Graphics object.
' The contrast value is used for antialiasing text
Public Function GetTextContrast() As Long
    Dim lContrast As Long
    m_uLastStatus = GdipGetTextContrast(m_lngGraphics, lContrast)
    GetTextContrast = lContrast
End Function

' returns the text rendering mode currently set for this Graphics object.
Public Function GetTextRenderingHint() As TextRenderingHint
    Dim uHint As TextRenderingHint
    m_uLastStatus = GdipGetTextRenderingHint(m_lngGraphics, uHint)
    GetTextRenderingHint = uHint
End Function

' gets the world transformation matrix of this Graphics object.
Public Function GetTransform(ByRef matrix As cMatrix) As GpStatus
    Dim lMatrix As Long
    m_uLastStatus = GdipGetWorldTransform(m_lngGraphics, lMatrix)
    If m_uLastStatus = Ok Then
       If matrix Is Nothing Then Set matrix = New cMatrix
       matrix.fInitialize lMatrix
    End If
    GetTransform = m_uLastStatus
End Function

' gets a rectangle that encloses the visible clipping region of this Graphics object.
' The visible clipping region is the intersection of the clipping region of this Graphics
' object and the clipping region of the window.
Public Function GetVisibleClipBoundsRectF(ByRef rect As cRectF) As GpStatus
    Dim uR As RECTF
    
    m_uLastStatus = GdipGetVisibleClipBounds(m_lngGraphics, uR)
    If m_uLastStatus = Ok Then
       If rect Is Nothing Then Set rect = New cRectF
       rect.CreateFromType uR
    End If
    GetVisibleClipBoundsRectF = m_uLastStatus
End Function

Public Function GetVisibleClipBoundsRectL(ByRef rect As cRect) As GpStatus
    Dim uR As RECTL
    
    m_uLastStatus = GdipGetVisibleClipBoundsI(m_lngGraphics, uR)
    If m_uLastStatus = Ok Then
       If rect Is Nothing Then Set rect = New cRect
       rect.CreateFromType uR
    End If
    GetVisibleClipBoundsRectL = m_uLastStatus
End Function

' updates the clipping region of this Graphics object to the portion of the specified rectangle
' that intersects with the current clipping region of this Graphics object.
Public Function IntersectClipSizeF(ByVal x As Single, ByVal y As Single, _
                                   ByVal Width As Single, ByVal Height As Single) As GpStatus
    m_uLastStatus = GdipSetClipRect(m_lngGraphics, x, y, Width, Height, CombineModeIntersect)
    IntersectClipSizeF = m_uLastStatus
End Function

Public Function IntersectClipSizeL(ByVal x As Long, ByVal y As Long, _
                                   ByVal Width As Long, ByVal Height As Long) As GpStatus
    m_uLastStatus = GdipSetClipRectI(m_lngGraphics, x, y, Width, Height, CombineModeIntersect)
    IntersectClipSizeL = m_uLastStatus
End Function

Public Function IntersectClipRectF(ByVal rect As cRectF) As GpStatus
    IntersectClipRectF = IntersectClipSizeF(rect.Left, rect.Top, rect.Width, rect.Height)
End Function

Public Function IntersectClipRectL(ByVal rect As cRect) As GpStatus
    IntersectClipRectL = IntersectClipSizeL(rect.Left, rect.Top, rect.Width, rect.Height)
End Function

' updates the clipping region of this Graphics object to the portion of the specified region
' that intersects with the current clipping region of this Graphics object.
Public Function IntersectClipRegion(ByVal region As cRegion) As GpStatus
    If region Is Nothing Then
       m_uLastStatus = InvalidParameter
    Else
       m_uLastStatus = GdipSetClipRegion(m_lngGraphics, region.NativeRegion, CombineModeIntersect)
    End If
End Function

' determines whether the clipping region of this Graphics object is empty.
Public Function IsClipEmpty() As Boolean
    Dim lR As Long
    m_uLastStatus = GdipIsClipEmpty(m_lngGraphics, lR)
    IsClipEmpty = lR
End Function

' determines whether the specified point is inside the visible clipping region of this Graphics object.
' The visible clipping region is the intersection of the clipping region of this Graphics object and the clipping region of the window.
Public Function IsVisibleF(ByVal x As Single, ByVal y As Single) As Boolean
    Dim lR As Long
    m_uLastStatus = GdipIsVisiblePoint(m_lngGraphics, x, y, lR)
    IsVisibleF = lR
End Function

Public Function IsVisibleL(ByVal x As Long, ByVal y As Long) As Boolean
    Dim lR As Long
    m_uLastStatus = GdipIsVisiblePointI(m_lngGraphics, x, y, lR)
    IsVisibleL = lR
End Function

Public Function IsVisiblePointF(ByVal pt As cPointF) As Boolean
    IsVisiblePointF = IsVisibleF(pt.x, pt.y)
End Function

Public Function IsVisiblePointL(ByVal pt As cPoint) As Boolean
    IsVisiblePointL = IsVisibleL(pt.x, pt.y)
End Function

Public Function IsVisibleSizeF(ByVal x As Single, ByVal y As Single, _
                               ByVal Width As Single, ByVal Height As Single) As Boolean
    Dim lR As Long
    m_uLastStatus = GdipIsVisibleRect(m_lngGraphics, x, y, Width, Height, lR)
    IsVisibleSizeF = lR
End Function

Public Function IsVisibleSizeL(ByVal x As Long, ByVal y As Long, _
                               ByVal Width As Long, ByVal Height As Long) As Boolean
    Dim lR As Long
    m_uLastStatus = GdipIsVisibleRectI(m_lngGraphics, x, y, Width, Height, lR)
    IsVisibleSizeL = lR
End Function

Public Function IsVisibleRectF(ByVal rect As cRectF) As Boolean
    IsVisibleRectF = IsVisibleSizeF(rect.Left, rect.Top, rect.Width, rect.Height)
End Function

Public Function IsVisibleRectL(ByVal rect As cRect) As Boolean
    IsVisibleRectL = IsVisibleSizeL(rect.Left, rect.Top, rect.Width, rect.Height)
End Function

' determines whether the visible clipping region of this Graphics object is empty.
' The visible clipping region is the intersection of the clipping region of this Graphics object and the clipping region of the window.
Public Function IsVisibleClipEmpty() As Boolean
    Dim lR As Long
    m_uLastStatus = GdipIsVisibleClipEmpty(m_lngGraphics, lR)
    IsVisibleClipEmpty = lR
End Function

' gets a set of regions each of which bounds a range of character positions within a string.
Public Function MeasureCharacterRanges(ByVal sText As String, _
                                       ByVal lLength As Long, _
                                       ByVal font As cFont, _
                                       ByVal layoutRect As cRectF, _
                                       ByVal StringFormat As cStringFormat, _
                                       ByVal regionCount As Long, _
                                       ByRef regions() As cRegion) As GpStatus
    Dim lFont                          As Long
    Dim lFormat                        As Long
    Dim lngI                           As Long
    Dim aryRegion()                    As Long
    
    If regionCount <= 0 Then m_uLastStatus = InvalidParameter: MeasureCharacterRanges = m_uLastStatus: Exit Function
    ReDim aryRegion(0 To regionCount - 1)
    m_uLastStatus = GdipMeasureCharacterRanges(m_lngGraphics, StrConv(sText, vbUnicode), _
                                               lLength, lFont, layoutRect.ToType, lFormat, _
                                               regionCount, aryRegion(0))
    If m_uLastStatus = Ok Then
       ReDim regions(0 To regionCount - 1)
       For lngI = 0 To regionCount - 1
           Set regions(lngI) = New cRegion
           regions(lngI).fInitialize (aryRegion(lngI))
       Next lngI
    End If
    MeasureCharacterRanges = m_uLastStatus
End Function

' measures the extent of the string in the specified font and layout rectangle.
Public Function MeasureStringPoint(ByVal sText As String, _
                                   ByVal lLength As Long, _
                                   ByVal font As cFont, _
                                   ByVal origin As cPointF, _
                                   ByRef boundingBox As cRectF) As GpStatus
    Dim uR                         As RECTF
    Dim lFont                      As Long
    Dim clsRect                    As New cRectF
    
    If origin Is Nothing Then m_uLastStatus = InvalidParameter: MeasureStringPoint = m_uLastStatus: Exit Function
    If font Is Nothing Then lFont = 0& Else lFont = font.NativeFont
    clsRect.Create origin.x, origin.y, 0#, 0#
    m_uLastStatus = GdipMeasureString(m_lngGraphics, StrConv(sText, vbUnicode), _
                                      lLength, lFont, clsRect.ToType, ByVal 0&, _
                                      uR, 0, 0)
    If m_uLastStatus = Ok Then
       If boundingBox Is Nothing Then Set boundingBox = New cRectF
       boundingBox.CreateFromType uR
    End If
    Set clsRect = Nothing
    MeasureStringPoint = m_uLastStatus
End Function

' measures the extent of the string in the specified font, format, and layout rectangle.
Public Function MeasureStringPointFormat(ByVal sText As String, _
                                         ByVal lLength As Long, _
                                         ByVal font As cFont, _
                                         ByVal origin As cPointF, _
                                         ByVal StringFormat As cStringFormat, _
                                         ByRef boundingBox As cRectF) As GpStatus
    Dim uR                               As RECTF
    Dim lFont                            As Long
    Dim lFormat                          As Long
    Dim clsRect                          As New cRectF
    
    If origin Is Nothing Then m_uLastStatus = InvalidParameter: MeasureStringPointFormat = m_uLastStatus: Exit Function
    If font Is Nothing Then lFont = 0& Else lFont = font.NativeFont
    If StringFormat Is Nothing Then lFormat = 0& Else lFormat = StringFormat.NativeStringFormat
    clsRect.Create origin.x, origin.y, 0#, 0#
    m_uLastStatus = GdipMeasureString(m_lngGraphics, StrConv(sText, vbUnicode), _
                                      lLength, lFont, clsRect.ToType, lFormat, _
                                      uR, 0, 0)
    If m_uLastStatus = Ok Then
       If boundingBox Is Nothing Then Set boundingBox = New cRectF
       boundingBox.CreateFromType uR
    End If
    Set clsRect = Nothing
    MeasureStringPointFormat = m_uLastStatus
End Function

' measures the extent of the string in the specified font and layout rectangle.
Public Function MeasureStringRect(ByVal sText As String, _
                                  ByVal lLength As Long, _
                                  ByVal font As cFont, _
                                  ByVal layoutRect As cRectF, _
                                  ByRef boundingBox As cRectF) As GpStatus
    Dim uR                        As RECTF
    Dim lFont                     As Long
    
    If layoutRect Is Nothing Then m_uLastStatus = InvalidParameter: MeasureStringRect = m_uLastStatus: Exit Function
    If font Is Nothing Then lFont = 0& Else lFont = font.NativeFont
    m_uLastStatus = GdipMeasureString(m_lngGraphics, StrConv(sText, vbUnicode), _
                                      lLength, lFont, layoutRect.ToType, ByVal 0&, _
                                      uR, 0, 0)
    If m_uLastStatus = Ok Then
       If boundingBox Is Nothing Then Set boundingBox = New cRectF
       boundingBox.CreateFromType uR
    End If
    MeasureStringRect = m_uLastStatus
End Function

Public Function MeasureStringRectFormat(ByVal sText As String, _
                                        ByVal lLength As Long, _
                                        ByVal font As cFont, _
                                        ByVal layoutRect As cRectF, _
                                        ByVal StringFormat As cStringFormat, _
                                        ByRef boundingBox As cRectF, _
                                        Optional ByRef codepointsFitted As Long = 0, _
                                        Optional ByRef linesFilled As Long = 0) As GpStatus
    Dim uR                              As RECTF
    Dim lFont                           As Long
    Dim lFormat                         As Long
    
    If layoutRect Is Nothing Then m_uLastStatus = InvalidParameter: MeasureStringRectFormat = m_uLastStatus: Exit Function
    If font Is Nothing Then lFont = 0& Else lFont = font.NativeFont
    If StringFormat Is Nothing Then lFormat = 0& Else lFormat = StringFormat.NativeStringFormat
    m_uLastStatus = GdipMeasureString(m_lngGraphics, StrConv(sText, vbUnicode), _
                                      lLength, lFont, layoutRect.ToType, lFormat, _
                                      uR, codepointsFitted, linesFilled)
    If m_uLastStatus = Ok Then
       If boundingBox Is Nothing Then Set boundingBox = New cRectF
       boundingBox.CreateFromType uR
    End If
    MeasureStringRectFormat = m_uLastStatus
End Function

Public Function MeasureStringSizeFormat(ByVal sText As String, _
                                        ByVal lLength As Long, _
                                        ByVal font As cFont, _
                                        ByVal layoutRectSize As cSizeF, _
                                        ByVal StringFormat As cStringFormat, _
                                        ByRef size As cSizeF, _
                                        Optional ByRef codepointsFitted As Long = 0, _
                                        Optional ByRef linesFilled As Long = 0) As GpStatus
    Dim uR                              As RECTF
    Dim lFont                           As Long
    Dim lFormat                         As Long
    Dim clsRect                         As cRectF
    
    If layoutRectSize Is Nothing Then m_uLastStatus = InvalidParameter: MeasureStringSizeFormat = m_uLastStatus: Exit Function
    If font Is Nothing Then lFont = 0& Else lFont = font.NativeFont
    If StringFormat Is Nothing Then lFormat = 0& Else lFormat = StringFormat.NativeStringFormat
    Set clsRect = New cRectF
    clsRect.Create 0#, 0#, layoutRectSize.Width, layoutRectSize.Height
    m_uLastStatus = GdipMeasureString(m_lngGraphics, StrConv(sText, vbUnicode), _
                                      lLength, lFont, clsRect.ToType, lFormat, _
                                      uR, codepointsFitted, linesFilled)
    If m_uLastStatus = Ok Then
       If size Is Nothing Then Set size = New cSizeF
       size.Create uR.Right - uR.Left, uR.Bottom - uR.Top
    End If
    Set clsRect = Nothing
    MeasureStringSizeFormat = m_uLastStatus
End Function

' updates this Graphics object's world transformation matrix with the product of itself and another matrix.
Public Function MultiplyTransform(ByVal matrix As cMatrix, _
                                  Optional uOrder As MatrixOrder = MatrixOrderPrepend) _
                                  As GpStatus
    If matrix Is Nothing Then
       m_uLastStatus = InvalidParameter
    Else
       m_uLastStatus = GdipMultiplyWorldTransform(m_lngGraphics, matrix.NativeMatrix, uOrder)
    End If
    MultiplyTransform = m_uLastStatus
End Function

Public Property Get NativeGraphics() As Long
Attribute NativeGraphics.VB_UserMemId = 0
    NativeGraphics = m_lngGraphics
End Property

' releases a device context handle obtained by a previous call to the
' Graphics::GetHDC method of this Graphics object.
Public Sub ReleaseHDC(ByVal hDC As Long)
    m_uLastStatus = GdipReleaseDC(m_lngGraphics, hDC)
End Sub

' sets the clipping region of this Graphics object to an infinite region.
Public Function ResetClip() As GpStatus
    m_uLastStatus = GdipResetClip(m_lngGraphics)
    ResetClip = m_uLastStatus
End Function

' sets the world transformation matrix of this Graphics object to the identity matrix.
Public Function ResetTransform() As GpStatus
    m_uLastStatus = GdipResetWorldTransform(m_lngGraphics)
    ResetTransform = m_uLastStatus
End Function

' sets the state of this Graphics object to the state stored by a previous
' call to the Graphics::Save method of this Graphics object.
Public Function Restore(ByVal gstate As Long) As GpStatus
    m_uLastStatus = GdipRestoreGraphics(m_lngGraphics, gstate)
    Restore = m_uLastStatus
End Function

' updates the world transformation matrix of this Graphics object with the product of itself and a rotation matrix.
Public Function RotateTransform(ByVal angle As Single, _
                                Optional ByVal uOrder As MatrixOrder = MatrixOrderPrepend) _
                                As GpStatus
    m_uLastStatus = GdipRotateWorldTransform(m_lngGraphics, angle, uOrder)
    RotateTransform = m_uLastStatus
End Function

' saves the current state (transformations, clipping region, and quality settings) of this Graphics object.
' You can restore the state later by calling the Graphics::Restore method.
Public Function Save() As Long
    Dim lState As Long
    
    m_uLastStatus = GdipSaveGraphics(m_lngGraphics, lState)
    Save = m_uLastStatus
End Function

' updates this Graphics object's world transformation matrix with the product of itself and a scaling matrix.
Public Function ScaleTransform(ByVal sx As Single, _
                               ByVal sy As Single, _
                               Optional uOrder As MatrixOrder = MatrixOrderPrepend) _
                               As GpStatus
    m_uLastStatus = GdipScaleWorldTransform(m_lngGraphics, sx, sy, uOrder)
    ScaleTransform = m_uLastStatus
End Function

' updates the clipping region of this Graphics object to a region that is the combination of itself and the clipping region of another Graphics object.
Public Function SetClipGraphics(ByVal g As cGraphics, _
                                Optional uMode As CombineMode = CombineModeReplace) As GpStatus
    If g Is Nothing Then
       m_uLastStatus = InvalidParameter
    Else
       m_uLastStatus = GdipSetClipGraphics(m_lngGraphics, g.NativeGraphics, uMode)
    End If
    SetClipGraphics = m_uLastStatus
End Function

' updates the clipping region of this Graphics object to a region that is the combination of itself and the region specified by a graphics path.
Public Function SetClipGraphicsPath(ByVal path As cGraphicsPath, _
                                    Optional uMode As CombineMode = CombineModeReplace) As GpStatus
    If path Is Nothing Then
       m_uLastStatus = InvalidParameter
    Else
       m_uLastStatus = GdipSetClipPath(m_lngGraphics, path.NativePath, uMode)
    End If
    SetClipGraphicsPath = m_uLastStatus
End Function

' updates the clipping region of this Graphics object to a region that is the combination of itself and the region specified by a Region object.
Public Function SetClipRegion(ByVal region As cRegion, _
                              Optional uMode As CombineMode = CombineModeReplace) As GpStatus
    If region Is Nothing Then
       m_uLastStatus = InvalidParameter
    Else
       m_uLastStatus = GdipSetClipRegion(m_lngGraphics, region.NativeRegion, uMode)
    End If
    SetClipRegion = m_uLastStatus
End Function

' updates the clipping region of this Graphics object to a region that is the combination of itself and a rectangle.
Public Function SetClipRect(ByVal rect As cRect, _
                            Optional uMode As CombineMode = CombineModeReplace) As GpStatus
    If rect Is Nothing Then
       m_uLastStatus = InvalidParameter
    Else
       m_uLastStatus = GdipSetClipRectI(m_lngGraphics, rect.Left, rect.Top, rect.Width, rect.Height, uMode)
    End If
    SetClipRect = m_uLastStatus
End Function

Public Function SetClipRectF(ByVal rect As cRectF, _
                             Optional uMode As CombineMode = CombineModeReplace) As GpStatus
    If rect Is Nothing Then
       m_uLastStatus = InvalidParameter
    Else
       m_uLastStatus = GdipSetClipRect(m_lngGraphics, rect.Left, rect.Top, rect.Width, rect.Height, uMode)
    End If
    SetClipRectF = m_uLastStatus
End Function

' updates the clipping region of this Graphics object to a region that is the combination of itself and a GDI region.
Public Function SetClipHRGN(ByVal hRgn As Long, _
                            Optional uMode As CombineMode = CombineModeReplace) As GpStatus
    m_uLastStatus = GdipSetClipHrgn(m_lngGraphics, hRgn, uMode)
    SetClipHRGN = m_uLastStatus
End Function

' sets the compositing mode of this Graphics object.
Public Function SetCompositingMode(ByVal uMode As CompositingMode) As GpStatus
    m_uLastStatus = GdipSetCompositingMode(m_lngGraphics, uMode)
    SetCompositingMode = m_uLastStatus
End Function

' sets the compositing quality of this Graphics object.
Public Function SetCompositingQuality(ByVal uQuality As CompositingQuality) As GpStatus
    m_uLastStatus = GdipSetCompositingQuality(m_lngGraphics, uQuality)
    SetCompositingQuality = m_uLastStatus
End Function

' sets the interpolation mode of this Graphics object. The interpolation mode determines the algorithm that is used when images are scaled or rotated.
Public Function SetInterpolationMode(ByVal uMode As InterpolationMode) As GpStatus
    m_uLastStatus = GdipSetInterpolationMode(m_lngGraphics, uMode)
    SetInterpolationMode = m_uLastStatus
End Function

' sets the scaling factor for the page transformation of this Graphics object. The page transformation converts page coordinates to device coordinates.
Public Function SetPageScale(ByVal sScale As Single) As GpStatus
    m_uLastStatus = GdipSetPageScale(m_lngGraphics, sScale)
    SetPageScale = m_uLastStatus
End Function

' sets the unit of measure for this Graphics object. The page unit belongs to the page transformation, which converts page coordinates to device coordinates.
Public Function SetPageUnit(ByVal uUnit As GpUnit) As GpStatus
    m_uLastStatus = GdipSetPageUnit(m_lngGraphics, uUnit)
    SetPageUnit = m_uLastStatus
End Function

' sets the pixel offset mode of this Graphics object.
Public Function SetPixelOffsetMode(ByVal uMode As PixelOffsetMode) As GpStatus
    m_uLastStatus = GdipSetPixelOffsetMode(m_lngGraphics, uMode)
    SetPixelOffsetMode = m_uLastStatus
End Function

' sets the rendering origin of this Graphics object.
Public Function SetRenderingOrigin(ByVal x As Long, ByVal y As Long) As GpStatus
    m_uLastStatus = GdipSetRenderingOrigin(m_lngGraphics, x, y)
    SetRenderingOrigin = m_uLastStatus
End Function

' sets the render quality of the Graphics object.
Public Function SetSmoothingMode(ByVal uMode As SmoothingMode) As GpStatus
    m_uLastStatus = GdipSetSmoothingMode(m_lngGraphics, uMode)
    SetSmoothingMode = m_uLastStatus
End Function

' sets the contrast value of this Graphics object.
' The contrast value is used for antialiasing text.
Public Function SetTextContrast(ByVal lContrast As Long) As GpStatus
    m_uLastStatus = GdipSetTextContrast(m_lngGraphics, lContrast)
    SetTextContrast = m_uLastStatus
End Function

' sets the text rendering mode of this Graphics object.
Public Function SetTextRenderingHint(ByVal Hint As TextRenderingHint) As GpStatus
    m_uLastStatus = GdipSetTextRenderingHint(m_lngGraphics, Hint)
    SetTextRenderingHint = m_uLastStatus
End Function

' sets the world transformation of this Graphics object.
Public Function SetTransform(ByVal matrix As cMatrix) As GpStatus
    If matrix Is Nothing Then
       m_uLastStatus = InvalidParameter
    Else
       m_uLastStatus = GdipSetWorldTransform(m_lngGraphics, matrix.NativeMatrix)
    End If
    SetTransform = m_uLastStatus
End Function

' converts an array of points from one coordinate space to another.
' The conversion is based on the current world and page transformations of this Graphics object.
Public Function TransformPointsF(ByVal destSpace As CoordinateSpace, _
                                 ByVal srcSpace As CoordinateSpace, _
                                 ByRef pts() As cPointF, _
                                 ByVal lCount As Long) As GpStatus
    Dim lngI                     As Long
    Dim uP()                     As POINTF
    
    Call ConvertPointFToType(pts, uP)
    m_uLastStatus = GdipTransformPoints(m_lngGraphics, destSpace, srcSpace, uP(LBound(uP)), lCount)
    If m_uLastStatus = Ok Then
       For lngI = LBound(pts) To UBound(pts)
           pts(lngI).CreateFromType uP(lngI)
       Next lngI
    End If
    Erase uP
    TransformPointsF = m_uLastStatus
End Function

Public Function TransformPointsL(ByVal destSpace As CoordinateSpace, _
                                 ByVal srcSpace As CoordinateSpace, _
                                 ByRef pts() As cPoint, _
                                 ByVal lCount As Long) As GpStatus
    Dim lngI                     As Long
    Dim uP()                     As POINTL
    
    Call ConvertPointLToType(pts, uP)
    m_uLastStatus = GdipTransformPointsI(m_lngGraphics, destSpace, srcSpace, uP(LBound(uP)), lCount)
    If m_uLastStatus = Ok Then
       For lngI = LBound(pts) To UBound(pts)
           pts(lngI).CreateFromType uP(lngI)
       Next lngI
    End If
    Erase uP
    TransformPointsL = m_uLastStatus
End Function

' translates the clipping region of this Graphics object.
Public Function TranslateClipF(ByVal dx As Single, ByVal dy As Single) As GpStatus
    m_uLastStatus = GdipTranslateClip(m_lngGraphics, dx, dy)
    TranslateClipF = m_uLastStatus
End Function

Public Function TranslateClipL(ByVal dx As Long, ByVal dy As Long) As GpStatus
    m_uLastStatus = GdipTranslateClipI(m_lngGraphics, dx, dy)
    TranslateClipL = m_uLastStatus
End Function

' updates this Graphics object's world transformation matrix with the product of itself and a translation matrix.
Public Function TranslateTransform(ByVal dx As Single, _
                                   ByVal dy As Single, _
                                   Optional ByVal uOrder As MatrixOrder = MatrixOrderPrepend) _
                                   As GpStatus
    m_uLastStatus = GdipTranslateWorldTransform(m_lngGraphics, dx, dy, uOrder)
    TranslateTransform = m_uLastStatus
End Function

Private Sub Class_Initialize()
    Call DisposeGraphics
End Sub

Private Sub Class_Terminate()
    Call DisposeGraphics
End Sub
