VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGraphicsPath"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cGraphicsPath.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusPath.h:Microsoft Platform SDK February 2003
'
' A GraphicsPath object stores a sequence of lines, curves, and shapes. You can draw
' the entire sequence by calling the DrawPath method of a Graphics object. You can
' partition the sequence of lines, curves, and shapes into figures, and with the help
' of a GraphicsPathIterator object, you can draw selected figures. You can also place
' markers in the sequence, so that you can draw selected portions of the path.
' ==================================================================================

Private m_lngPath As Long
Private m_uLastStatus As GpStatus

' adds an elliptical arc to the current figure of this path.
Public Function AddArcF(ByVal x As Single, _
                        ByVal y As Single, _
                        ByVal Width As Single, _
                        ByVal Height As Single, _
                        ByVal startAngle As Single, _
                        ByVal sweepAngle As Single) As GpStatus
    m_uLastStatus = GdipAddPathArc(m_lngPath, x, y, Width, Height, startAngle, sweepAngle)
    AddArcF = m_uLastStatus
End Function

'  adds an elliptical arc to the current figure of this path.
Public Function AddArcL(ByVal x As Long, _
                        ByVal y As Long, _
                        ByVal Width As Long, _
                        ByVal Height As Long, _
                        ByVal startAngle As Single, _
                        ByVal sweepAngle As Single) As GpStatus
    m_uLastStatus = GdipAddPathArcI(m_lngPath, x, y, Width, Height, startAngle, sweepAngle)
    AddArcL = m_uLastStatus
End Function

' adds an elliptical arc to the current figure of this path.
Public Function AddArcRectF(ByVal rect As cRectF, _
                            ByVal startAngle As Single, _
                            ByVal sweepAngle As Single) As GpStatus
    AddArcRectF = AddArcF(rect.Left, rect.Top, rect.Width, rect.Height, startAngle, sweepAngle)
End Function

' adds an elliptical arc to the current figure of this path.
Public Function AddArcRectL(ByVal rect As cRect, _
                            ByVal startAngle As Single, _
                            ByVal sweepAngle As Single) As GpStatus
    AddArcRectL = AddArcL(rect.Left, rect.Top, rect.Width, rect.Height, startAngle, sweepAngle)
End Function

' adds a Bézier spline to the current figure of this path.
Public Function AddBezierF(ByVal x1 As Single, ByVal y1 As Single, _
                           ByVal x2 As Single, ByVal y2 As Single, _
                           ByVal x3 As Single, ByVal y3 As Single, _
                           ByVal x4 As Single, ByVal y4 As Single) As GpStatus
    m_uLastStatus = GdipAddPathBezier(m_lngPath, x1, y1, x2, y2, x3, y3, x4, y4)
    AddBezierF = m_uLastStatus
End Function

' adds a Bézier spline to the current figure of this path.
Public Function AddBezierL(ByVal x1 As Long, ByVal y1 As Long, _
                           ByVal x2 As Long, ByVal y2 As Long, _
                           ByVal x3 As Long, ByVal y3 As Long, _
                           ByVal x4 As Long, ByVal y4 As Long) As GpStatus
    m_uLastStatus = GdipAddPathBezierI(m_lngPath, x1, y1, x2, y2, x3, y3, x4, y4)
    AddBezierL = m_uLastStatus
End Function

' adds a Bézier spline to the current figure of this path.
Public Function AddBezierPointF(ByVal pt1 As cPointF, ByVal pt2 As cPointF, _
                                ByVal pt3 As cPointF, ByVal pt4 As cPointF) As GpStatus
    AddBezierPointF = AddBezierF(pt1.x, pt1.y, pt2.x, pt2.y, pt3.x, pt3.y, pt4.x, pt4.y)
End Function

' adds a Bézier spline to the current figure of this path.
Public Function AddBezierPointL(ByVal pt1 As cPoint, ByVal pt2 As cPoint, _
                                ByVal pt3 As cPoint, ByVal pt4 As cPoint) As GpStatus
    AddBezierPointL = AddBezierL(pt1.x, pt1.y, pt2.x, pt2.y, pt3.x, pt3.y, pt4.x, pt4.y)
End Function

' adds a sequence of connected Bézier splines to the current figure of this path.
Public Function AddBeziersPointF(ByRef uPoints() As cPointF, ByVal lCount As Long) As GpStatus
    Dim uP() As POINTF
    
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipAddPathBeziers(m_lngPath, uP(LBound(uP)), lCount)
    Erase uP
    AddBeziersPointF = m_uLastStatus
End Function

' adds a sequence of connected Bézier splines to the current figure of this path.
Public Function AddBeziersPointL(ByRef uPoints() As cPoint, ByVal lCount As Long) As GpStatus
    Dim uP() As POINTL
    
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipAddPathBeziersI(m_lngPath, uP(LBound(uP)), lCount)
    Erase uP
    AddBeziersPointL = m_uLastStatus
End Function

' adds a closed cardinal spline to this path.
Public Function AddClosedCurveF(ByRef uPoints() As cPointF, _
                                ByVal lCount As Long) As GpStatus
    Dim uP() As POINTF
    
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipAddPathClosedCurve(m_lngPath, uP(LBound(uP)), lCount)
    Erase uP
    AddClosedCurveF = m_uLastStatus
End Function

' adds a closed cardinal spline to this path.
Public Function AddClosedCurveF2(ByRef uPoints() As cPointF, _
                                 ByVal lCount As Long, _
                                 ByVal tension As Single) As GpStatus
    Dim uP() As POINTF
    
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipAddPathClosedCurve2(m_lngPath, uP(LBound(uP)), lCount, tension)
    Erase uP
    AddClosedCurveF2 = m_uLastStatus
End Function

' adds a closed cardinal spline to this path.
Public Function AddClosedCurveL(ByRef uPoints() As cPoint, _
                                ByVal lCount As Long) As GpStatus
    Dim uP() As POINTL
    
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipAddPathClosedCurveI(m_lngPath, uP(LBound(uP)), lCount)
    Erase uP
    AddClosedCurveL = m_uLastStatus
End Function

' adds a closed cardinal spline to this path.
Public Function AddClosedCurveL2(ByRef uPoints() As cPoint, _
                                 ByVal lCount As Long, _
                                 ByVal tension As Single) As GpStatus
    Dim uP() As POINTL
    
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipAddPathClosedCurve2I(m_lngPath, uP(LBound(uP)), lCount, tension)
    Erase uP
    AddClosedCurveL2 = m_uLastStatus
End Function

' adds a cardinal spline to the current figure of this path.
Public Function AddCurveF(ByRef uPoints() As cPointF, _
                          ByVal lCount As Long) As GpStatus
    Dim uP() As POINTF
    
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipAddPathCurve(m_lngPath, uP(LBound(uP)), lCount)
    Erase uP
    AddCurveF = m_uLastStatus
End Function

' adds a cardinal spline to the current figure of this path.
Public Function AddCurveF2(ByRef uPoints() As cPointF, _
                           ByVal lCount As Long, _
                           ByVal tension As Single) As GpStatus
    Dim uP() As POINTF
    
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipAddPathCurve2(m_lngPath, uP(LBound(uP)), lCount, tension)
    Erase uP
    AddCurveF2 = m_uLastStatus
End Function

' adds a cardinal spline to the current figure of this path.
Public Function AddCurveF3(ByRef uPoints() As cPointF, _
                           ByVal lCount As Long, _
                           ByVal Offset As Long, _
                           ByVal numberOfSegments As Long, _
                           ByVal tension As Single) As GpStatus
    Dim uP() As POINTF
    
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipAddPathCurve3(m_lngPath, uP(LBound(uP)), lCount, Offset, numberOfSegments, tension)
    Erase uP
    AddCurveF3 = m_uLastStatus
End Function

' adds a cardinal spline to the current figure of this path.
Public Function AddCurveL(ByRef uPoints() As cPoint, _
                          ByVal lCount As Long) As GpStatus
    Dim uP() As POINTL
    
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipAddPathCurveI(m_lngPath, uP(LBound(uP)), lCount)
    Erase uP
    AddCurveL = m_uLastStatus
End Function

' adds a cardinal spline to the current figure of this path.
Public Function AddCurveL2(ByRef uPoints() As cPoint, _
                           ByVal lCount As Long, _
                           ByVal tension As Single) As GpStatus
    Dim uP() As POINTL
    
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipAddPathCurve2I(m_lngPath, uP(LBound(uP)), lCount, tension)
    Erase uP
    AddCurveL2 = m_uLastStatus
End Function

' adds a cardinal spline to the current figure of this path.
Public Function AddCurveL3(ByRef uPoints() As cPoint, _
                           ByVal lCount As Long, _
                           ByVal Offset As Long, _
                           ByVal numberOfSegments As Long, _
                           ByVal tension As Single) As GpStatus
    Dim uP() As POINTL
    
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipAddPathCurve3I(m_lngPath, uP(LBound(uP)), lCount, Offset, numberOfSegments, tension)
    Erase uP
    AddCurveL3 = m_uLastStatus
End Function

' adds an ellipse to this path.
Public Function AddEllipseF(ByVal x As Single, ByVal y As Single, _
                            ByVal Width As Single, ByVal Height As Single) As GpStatus
    m_uLastStatus = GdipAddPathEllipse(m_lngPath, x, y, Width, Height)
    AddEllipseF = m_uLastStatus
End Function

' adds an ellipse to this path.
Public Function AddEllipseL(ByVal x As Long, ByVal y As Long, _
                            ByVal Width As Long, ByVal Height As Long) As GpStatus
    m_uLastStatus = GdipAddPathEllipseI(m_lngPath, x, y, Width, Height)
    AddEllipseL = m_uLastStatus
End Function

' adds an ellipse to this path.
Public Function AddEllipseRectF(ByVal rect As cRectF) As GpStatus
    AddEllipseRectF = AddEllipseF(rect.Left, rect.Top, rect.Width, rect.Height)
End Function

' adds an ellipse to this path.
Public Function AddEllipseRectL(ByVal rect As cRect) As GpStatus
    AddEllipseRectL = AddEllipseL(rect.Left, rect.Top, rect.Width, rect.Height)
End Function

' adds a line to the current figure of this path.
Public Function AddLineF(ByVal x1 As Single, ByVal y1 As Single, _
                         ByVal x2 As Single, ByVal y2 As Single) As GpStatus
    m_uLastStatus = GdipAddPathLine(m_lngPath, x1, y1, x2, y2)
    AddLineF = m_uLastStatus
End Function

' adds a line to the current figure of this path.
Public Function AddLineL(ByVal x1 As Long, ByVal y1 As Long, _
                         ByVal x2 As Long, ByVal y2 As Long) As GpStatus
    m_uLastStatus = GdipAddPathLineI(m_lngPath, x1, y1, x2, y2)
    AddLineL = m_uLastStatus
End Function

' adds a line to the current figure of this path.
Public Function AddLinePointF(ByVal pt1 As cPointF, ByVal pt2 As cPointF) As GpStatus
    AddLinePointF = AddLineF(pt1.x, pt1.y, pt2.x, pt2.y)
End Function

' adds a line to the current figure of this path.
Public Function AddLinePointL(ByVal pt1 As cPoint, ByVal pt2 As cPoint) As GpStatus
    AddLinePointL = AddLineL(pt1.x, pt1.y, pt2.x, pt2.y)
End Function

' adds a sequence of connected lines to the current figure of this path.
Public Function AddLinesF(ByRef uPoints() As cPointF, ByVal lCount As Long) As GpStatus
    Dim uP() As POINTF
    
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipAddPathLine2(m_lngPath, uP(LBound(uP)), lCount)
    Erase uP
    AddLinesF = m_uLastStatus
End Function

' adds a sequence of connected lines to the current figure of this path.
Public Function AddLinesL(ByRef uPoints() As cPoint, ByVal lCount As Long) As GpStatus
    Dim uP() As POINTL
    
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipAddPathLine2I(m_lngPath, uP(LBound(uP)), lCount)
    Erase uP
    AddLinesL = m_uLastStatus
End Function

' adds a path to this path.
Public Function AddPath(ByVal addingPath As cGraphicsPath, bConnect As Boolean) As GpStatus
    If addingPath Is Nothing Then m_uLastStatus = InvalidParameter: AddPath = m_uLastStatus: Exit Function
    m_uLastStatus = GdipAddPathPath(m_lngPath, addingPath.NativePath, bConnect)
    AddPath = m_uLastStatus
End Function

' The AddPie method adds a pie to this path. An arc is a portion of an ellipse,
' and a pie is a portion of the area enclosed by an ellipse. A pie is bounded
' by an arc and two lines (edges) that go from the center of the ellipse to the
' endpoints of the arc
Public Function AddPieF(ByVal x As Single, _
                        ByVal y As Single, _
                        ByVal Width As Single, _
                        ByVal Height As Single, _
                        ByVal startAngle As Single, _
                        ByVal sweepAngle As Single) As GpStatus
    m_uLastStatus = GdipAddPathPie(m_lngPath, x, y, Width, Height, startAngle, sweepAngle)
    AddPieF = m_uLastStatus
End Function

Public Function AddPieL(ByVal x As Long, _
                        ByVal y As Long, _
                        ByVal Width As Long, _
                        ByVal Height As Long, _
                        ByVal startAngle As Single, _
                        ByVal sweepAngle As Single) As GpStatus
    m_uLastStatus = GdipAddPathPieI(m_lngPath, x, y, Width, Height, startAngle, sweepAngle)
    AddPieL = m_uLastStatus
End Function

Public Function AddPieRectF(ByVal rect As cRectF, _
                            ByVal startAngle As Single, _
                            ByVal sweepAngle As Single) As GpStatus
    AddPieRectF = AddPieF(rect.Left, rect.Top, rect.Width, rect.Height, startAngle, sweepAngle)
End Function

Public Function AddPieRectL(ByVal rect As cRect, _
                            ByVal startAngle As Single, _
                            ByVal sweepAngle As Single) As GpStatus
    AddPieRectL = AddPieL(rect.Left, rect.Top, rect.Width, rect.Height, startAngle, sweepAngle)
End Function

' adds a polygon to this path.
Public Function AddPolygonF(ByRef uPoints() As cPointF, ByVal lCount As Long) As GpStatus
    Dim uP() As POINTF
    
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipAddPathPolygon(m_lngPath, uP(LBound(uP)), lCount)
    Erase uP
    AddPolygonF = m_uLastStatus
End Function

' adds a polygon to this path.
Public Function AddPolygonL(ByRef uPoints() As cPoint, ByVal lCount As Long) As GpStatus
    Dim uP() As POINTL
    
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipAddPathPolygonI(m_lngPath, uP(LBound(uP)), lCount)
    Erase uP
    AddPolygonL = m_uLastStatus
End Function

' adds a rectangle to this path.
Public Function AddRectangleF(ByVal x As Single, ByVal y As Single, _
                              ByVal Width As Single, ByVal Height As Single) As GpStatus
    m_uLastStatus = GdipAddPathRectangle(m_lngPath, x, y, Width, Height)
    AddRectangleF = m_uLastStatus
End Function

' adds a rectangle to this path.
Public Function AddRectangleL(ByVal x As Long, ByVal y As Long, _
                              ByVal Width As Long, ByVal Height As Long) As GpStatus
    m_uLastStatus = GdipAddPathRectangleI(m_lngPath, x, y, Width, Height)
    AddRectangleL = m_uLastStatus
End Function

Public Function AddRectangleRectF(ByVal rect As cRectF) As GpStatus
    AddRectangleRectF = AddRectangleF(rect.Left, rect.Top, rect.Width, rect.Height)
End Function

Public Function AddRectangleRectL(ByVal rect As cRect) As GpStatus
    AddRectangleRectL = AddRectangleL(rect.Left, rect.Top, rect.Width, rect.Height)
End Function

' adds a sequence of rectangles to this path
Public Function AddRectanglesF(ByRef uRects() As cRectF, ByVal lCount As Long)
    Dim uRt() As RECTF
    
    Call ConvertRectFToType(uRects, uRt)
    m_uLastStatus = GdipAddPathRectangles(m_lngPath, uRt(LBound(uRt)), lCount)
    Erase uRt
    AddRectanglesF = m_uLastStatus
End Function

' adds a sequence of rectangles to this path
Public Function AddRectanglesL(ByRef uRects() As cRect, ByVal lCount As Long)
    Dim uRt() As RECTL
    
    Call ConvertRectLToType(uRects, uRt)
    m_uLastStatus = GdipAddPathRectanglesI(m_lngPath, uRt(LBound(uRt)), lCount)
    Erase uRt
    AddRectanglesL = m_uLastStatus
End Function

' adds the outline of a string to this path
Public Function AddStringPointF(ByVal StrAdd As String, _
                                ByVal Length As Long, _
                                ByVal style As Long, _
                                ByVal emSize As Single, _
                                ByVal origin As cPointF, _
                                Optional ByVal family As cFontFamily = Nothing, _
                                Optional ByVal format As cStringFormat = Nothing) As GpStatus
    Dim clsRect                 As New cRectF
    Dim lFamily                 As Long
    Dim lFormat                 As Long
    If origin Is Nothing Then m_uLastStatus = InvalidParameter: AddStringPointF = m_uLastStatus: Exit Function
    If family Is Nothing Then
       lFamily = 0&
    Else
       lFamily = family.NativeFontFamily
    End If
    If format Is Nothing Then
       lFormat = 0&
    Else
       lFormat = format.NativeStringFormat
    End If
    clsRect.Create origin.x, origin.y, 0#, 0#
    
    m_uLastStatus = GdipAddPathString(m_lngPath, StrConv(StrAdd, vbUnicode), Length, lFamily, _
                                      style, emSize, clsRect.ToType, lFormat)
    Set clsRect = Nothing
    AddStringPointF = m_uLastStatus
End Function

' adds the outline of a string to this path
Public Function AddStringPointL(ByVal StrAdd As String, _
                                ByVal Length As Long, _
                                ByVal style As Long, _
                                ByVal emSize As Single, _
                                ByVal origin As cPoint, _
                                Optional ByVal family As cFontFamily = Nothing, _
                                Optional ByVal format As cStringFormat = Nothing) As GpStatus
    Dim clsRect                 As New cRect
    Dim lFamily                 As Long
    Dim lFormat                 As Long
    If origin Is Nothing Then m_uLastStatus = InvalidParameter: AddStringPointL = m_uLastStatus: Exit Function
    If family Is Nothing Then
       lFamily = 0&
    Else
       lFamily = family.NativeFontFamily
    End If
    If format Is Nothing Then
       lFormat = 0&
    Else
       lFormat = format.NativeStringFormat
    End If
    clsRect.Create origin.x, origin.y, 0, 0
    
    m_uLastStatus = GdipAddPathStringI(m_lngPath, StrConv(StrAdd, vbUnicode), Length, lFamily, _
                                      style, emSize, clsRect.ToType, lFormat)
    Set clsRect = Nothing
    AddStringPointL = m_uLastStatus
End Function

' adds the outline of a string to this path
Public Function AddStringRectF(ByVal StrAdd As String, _
                               ByVal Length As Long, _
                               ByVal style As Long, _
                               ByVal emSize As Single, _
                               ByVal layoutRect As cRectF, _
                               Optional ByVal family As cFontFamily = Nothing, _
                               Optional ByVal format As cStringFormat = Nothing) As GpStatus
    Dim lFamily                As Long
    Dim lFormat                As Long
    If layoutRect Is Nothing Then m_uLastStatus = InvalidParameter: AddStringRectF = m_uLastStatus: Exit Function
    If family Is Nothing Then
       lFamily = 0&
    Else
       lFamily = family.NativeFontFamily
    End If
    If format Is Nothing Then
       lFormat = 0&
    Else
       lFormat = format.NativeStringFormat
    End If
    m_uLastStatus = GdipAddPathString(m_lngPath, StrConv(StrAdd, vbUnicode), Length, lFamily, _
                                      style, emSize, layoutRect.ToType, lFormat)
    AddStringRectF = m_uLastStatus
End Function

' adds the outline of a string to this path
Public Function AddStringRectL(ByVal StrAdd As String, _
                               ByVal Length As Long, _
                               ByVal style As Long, _
                               ByVal emSize As Single, _
                               ByVal layoutRect As cRect, _
                               Optional ByVal family As cFontFamily = Nothing, _
                               Optional ByVal format As cStringFormat = Nothing) As GpStatus
    Dim lFamily                As Long
    Dim lFormat                As Long
    If layoutRect Is Nothing Then m_uLastStatus = InvalidParameter: AddStringRectL = m_uLastStatus: Exit Function
    If family Is Nothing Then
       lFamily = 0&
    Else
       lFamily = family.NativeFontFamily
    End If
    If format Is Nothing Then
       lFormat = 0&
    Else
       lFormat = format.NativeStringFormat
    End If
    m_uLastStatus = GdipAddPathStringI(m_lngPath, StrConv(StrAdd, vbUnicode), Length, lFamily, _
                                      style, emSize, layoutRect.ToType, lFormat)
    AddStringRectL = m_uLastStatus
End Function

' clears the markers from this path
Public Function ClearMarkers() As GpStatus
    m_uLastStatus = GdipClearPathMarkers(m_lngPath)
    ClearMarkers = m_uLastStatus
End Function

' creates a new GraphicsPath object, and initializes it with the contents of this GraphicsPath object
Public Function Clone() As cGraphicsPath
    Dim lngPath         As Long
    Dim clsClone        As cGraphicsPath
    
    m_uLastStatus = GdipClonePath(m_lngPath, lngPath)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cGraphicsPath
    clsClone.fInitialize (lngPath)
    Set Clone = clsClone
End Function

' closes all open figures in this path
Public Function CloseAllFigures() As GpStatus
    m_uLastStatus = GdipClosePathFigures(m_lngPath)
    CloseAllFigures = m_uLastStatus
End Function

' closes the current figure of this path.
Public Function CloseFigure() As GpStatus
    m_uLastStatus = GdipClosePathFigure(m_lngPath)
    CloseFigure = m_uLastStatus
End Function

' Creates a GraphicsPath object and initializes the fill mode.
Public Function CreatePath(Optional ByVal uFillMode As FillMode = FillModeAlternate) As GpStatus
    Call DisposePath
    m_uLastStatus = GdipCreatePath(uFillMode, m_lngPath)
    CreatePath = m_uLastStatus
End Function

'Public Function CreatePathPointF(ByRef uPoints() As cPointF, _
                                 uTypes() As Byte, _
                                 ByVal lCount As Long, _
                                 Optional uFillMode As FillMode = FillModeAlternate) _
                                 As GpStatus
    
'    m_uLastStatus = GdipCreatePath2(uP(lngL), uTypes, lCount, uFillMode, m_lngPath)
'    CreatePathPointF = m_uLastStatus
'End Function

'Public Function CreatePathPointL(uPoints As POINTL, _
'                                 uTypes() As PathPointType, _
'                                 ByVal lCount As Long, _
'                                 Optional uFillMode As FillMode = FillModeAlternate) _
'                                 As GpStatus
'    'GdipCreatePath2i
'End Function

Public Sub DisposePath()
    If m_lngPath <> 0 Then m_uLastStatus = GdipDeletePath(m_lngPath): m_lngPath = 0
End Sub

Friend Sub fInitialize(ByVal lPath As Long)
    Call DisposePath
    m_lngPath = lPath
End Sub

' applies a transformation to this path and converts each curve in the path to a sequence of connected lines
Public Function Flatten(Optional ByVal matrix As cMatrix = Nothing, _
                        Optional ByVal flatness As Single = FlatnessDefault) As GpStatus
    If matrix Is Nothing Then
       m_uLastStatus = GdipFlattenPath(m_lngPath, matrix.NativeMatrix, flatness)
    Else
       m_uLastStatus = GdipFlattenPath(m_lngPath, , flatness)
    End If
    Flatten = m_uLastStatus
End Function

' gets a bounding rectangle for this path.
Public Function GetBoundsF(ByRef bounds As cRectF, _
                           Optional ByVal matrix As cMatrix = Nothing, _
                           Optional ByVal pen As cPen = Nothing) As GpStatus
    Dim lMatrix As Long
    Dim lPen As Long
    Dim uR As RECTF
    
    If matrix Is Nothing Then lMatrix = 0& Else lMatrix = matrix.NativeMatrix
    If pen Is Nothing Then lPen = 0& Else lPen = pen.NativePen
    m_uLastStatus = GdipGetPathWorldBounds(m_lngPath, uR, lMatrix, lPen)
    If m_uLastStatus = Ok Then
       If bounds Is Nothing Then Set bounds = New cRectF
       bounds.CreateFromType uR
    End If
    GetBoundsF = m_uLastStatus
End Function

' gets a bounding rectangle for this path.
Public Function GetBoundsL(ByRef bounds As cRect, _
                           Optional ByVal matrix As cMatrix = Nothing, _
                           Optional ByVal pen As cPen = Nothing) As GpStatus
    Dim lMatrix As Long
    Dim lPen As Long
    Dim uR As RECTL
    
    If matrix Is Nothing Then lMatrix = 0& Else lMatrix = matrix.NativeMatrix
    If pen Is Nothing Then lPen = 0& Else lPen = pen.NativePen
    m_uLastStatus = GdipGetPathWorldBoundsI(m_lngPath, uR, lMatrix, lPen)
    If m_uLastStatus = Ok Then
       If bounds Is Nothing Then Set bounds = New cRect
       bounds.CreateFromType uR
    End If
    GetBoundsL = m_uLastStatus
End Function

' gets the fill mode of this path.
Public Function GetFillMode() As FillMode
    Dim uFill As FillMode
    uFill = FillModeAlternate
    m_uLastStatus = GdipGetPathFillMode(m_lngPath, uFill)
    GetFillMode = uFill
End Function

' gets the ending point of the last figure in this path
Public Function GetLastPoint(ByRef lastPoint As cPointF) As GpStatus
    Dim uP As POINTF
    
    m_uLastStatus = GdipGetPathLastPoint(m_lngPath, uP)
    If m_uLastStatus = Ok Then
       If lastPoint Is Nothing Then Set lastPoint = New cPointF
       lastPoint.CreateFromType uP
    End If
    GetLastPoint = m_uLastStatus
End Function

' returns a value that indicates the nature of this GraphicsPath object's most recent method failure.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' gets an array of points and an array of point types from this path. Together, these two arrays define the lines, curves, figures, and markers of this path
'Public Function GetPathData(ByRef uData As PathData) As GpStatus
    '
'End Function

' The array contains the endpoints and control points of the lines
' and Bézier splines that are used to draw the path.
Public Function GetPathPointsF(ByRef uPoints() As cPointF, ByVal lCount As Long) As GpStatus
    Dim lngI As Long
    Dim uP() As POINTF
    
    ReDim uP(0 To lCount - 1)
    m_uLastStatus = GdipGetPathPoints(m_lngPath, uP(0), lCount)
    ReDim uPoints(0 To lCount - 1)
    For lngI = 0 To lCount - 1
        Set uPoints(lngI) = New cPointF
        uPoints(lngI).CreateFromType uP(lngI)
    Next lngI
    Erase uP
    GetPathPointsF = m_uLastStatus
End Function

' The array contains the endpoints and control points of the lines
' and Bézier splines that are used to draw the path.
Public Function GetPathPointsL(ByRef uPoints() As cPoint, ByVal lCount As Long) As GpStatus
    Dim lngI As Long
    Dim uP() As POINTL
    
    ReDim uP(0 To lCount - 1)
    m_uLastStatus = GdipGetPathPointsI(m_lngPath, uP(0), lCount)
    ReDim uPoints(0 To lCount - 1)
    For lngI = 0 To lCount - 1
        Set uPoints(lngI) = New cPoint
        uPoints(lngI).CreateFromType uP(lngI)
    Next lngI
    Erase uP
    GetPathPointsL = m_uLastStatus
End Function

' gets the number of points in this path's array of data points.
' This is the same as the number of types in the path's array of point types.
Public Function GetPointCount() As Long
    Dim lCount As Long
    
    m_uLastStatus = GdipGetPointCount(m_lngPath, lCount)
    GetPointCount = lCount
End Function

' determines whether a specified point touches the outline of this path when
' the path is drawn by a specified Graphics object and a specified pen.
Public Function IsOutlineVisibleF(ByVal x As Single, _
                                  ByVal y As Single, _
                                  ByVal pen As cPen, _
                                  Optional ByVal g As cGraphics = Nothing) As Boolean
    Dim lR As Long
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: Exit Function
    If g Is Nothing Then
       m_uLastStatus = GdipIsOutlineVisiblePathPoint(m_lngPath, x, y, pen.NativePen, ByVal 0&, lR)
    Else
       m_uLastStatus = GdipIsOutlineVisiblePathPoint(m_lngPath, x, y, pen.NativePen, g.NativeGraphics, lR)
    End If
    IsOutlineVisibleF = lR
End Function

Public Function IsOutlineVisibleL(ByVal x As Long, _
                                  ByVal y As Long, _
                                  ByVal pen As cPen, _
                                  Optional ByVal g As cGraphics = Nothing) As Boolean
    Dim lR As Long
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: Exit Function
    If g Is Nothing Then
       m_uLastStatus = GdipIsOutlineVisiblePathPointI(m_lngPath, x, y, pen.NativePen, ByVal 0&, lR)
    Else
       m_uLastStatus = GdipIsOutlineVisiblePathPointI(m_lngPath, x, y, pen.NativePen, g.NativeGraphics, lR)
    End If
    IsOutlineVisibleL = lR
End Function

Public Function IsOutlineVisiblePointF(ByVal P As cPointF, _
                                       ByVal pen As cPen, _
                                       Optional ByVal g As cGraphics = Nothing) As Boolean
    IsOutlineVisiblePointF = IsOutlineVisibleF(P.x, P.y, pen, g)
End Function

Public Function IsOutlineVisiblePointL(ByVal P As cPoint, _
                                       ByVal pen As cPen, _
                                       Optional ByVal g As cGraphics = Nothing) As Boolean
    IsOutlineVisiblePointL = IsOutlineVisibleL(P.x, P.y, pen, g)
End Function

' determines whether a specified point lies in the area that is filled when this path
' is filled by a specified Graphics object
Public Function IsVisibleF(ByVal x As Single, _
                           ByVal y As Single, _
                           Optional ByVal g As cGraphics = Nothing) As Boolean
    Dim lR As Long
    If g Is Nothing Then
       m_uLastStatus = GdipIsVisiblePathPoint(m_lngPath, x, y, ByVal 0&, lR)
    Else
       m_uLastStatus = GdipIsVisiblePathPoint(m_lngPath, x, y, g.NativeGraphics, lR)
    End If
    IsVisibleF = lR
End Function

Public Function IsVisibleL(ByVal x As Long, _
                           ByVal y As Long, _
                           Optional ByVal g As cGraphics = Nothing) As Boolean
    Dim lR As Long
    If g Is Nothing Then
       m_uLastStatus = GdipIsVisiblePathPointI(m_lngPath, x, y, ByVal 0&, lR)
    Else
       m_uLastStatus = GdipIsVisiblePathPointI(m_lngPath, x, y, g.NativeGraphics, lR)
    End If
    IsVisibleL = lR
End Function

Public Function IsVisiblePointF(ByVal P As cPointF, _
                                Optional ByVal g As cGraphics = Nothing) As Boolean
    IsVisiblePointF = IsVisibleF(P.x, P.y, g)
End Function

Public Function IsVisiblePointL(ByVal P As cPoint, _
                                Optional ByVal g As cGraphics = Nothing) As Boolean
    IsVisiblePointL = IsVisibleL(P.x, P.y, g)
End Function

Public Property Get NativePath() As Long
    NativePath = m_lngPath
End Property

' transforms and flattens this path, and then converts this path's data points
' so that they represent only the outline of the path.
Public Function Outline(Optional ByVal matrix As cMatrix = Nothing, _
                        Optional ByVal flatness As Single = FlatnessDefault) As GpStatus
    If matrix Is Nothing Then
       m_uLastStatus = GdipWindingModeOutline(m_lngPath, ByVal 0&, flatness)
    Else
       m_uLastStatus = GdipWindingModeOutline(m_lngPath, matrix.NativeMatrix, flatness)
    End If
    Outline = m_uLastStatus
End Function

' empties the path and sets the fill mode to FillModeAlternate.
Public Function Reset() As GpStatus
    Reset = CreatePath
End Function

' reverses the order of the points that define this path's lines and curves.
Public Function Reverse() As GpStatus
    m_uLastStatus = GdipReversePath(m_lngPath)
    Reverse = m_uLastStatus
End Function

' sets the fill mode of this path
Public Function SetFillMode(uFill As FillMode) As GpStatus
    m_uLastStatus = GdipSetPathFillMode(m_lngPath, uFill)
    SetFillMode = m_uLastStatus
End Function

' designates the last point in this path as a marker point.
Public Function SetMarker() As GpStatus
    m_uLastStatus = GdipSetPathMarker(m_lngPath)
    SetMarker = m_uLastStatus
End Function

' starts a new figure without closing the current figure.
' Subsequent points added to this path are added to the new figure.
Public Function StartFigure() As GpStatus
    m_uLastStatus = GdipStartPathFigure(m_lngPath)
    StartFigure = m_uLastStatus
End Function

' multiplies each of this path's data points by a specified matrix
Public Function Transform(ByVal matrix As cMatrix) As GpStatus
    If matrix Is Nothing Then m_uLastStatus = InvalidParameter: Transform = m_uLastStatus: Exit Function
    m_uLastStatus = GdipTransformPath(m_lngPath, matrix.NativeMatrix)
    Transform = m_uLastStatus
End Function

' applies a warp transformation to this path. The Warp method also flattens
' (converts to a sequence of straight lines) the path.
Public Function Warp(ByRef destPoints() As cPointF, _
                     ByVal lCount As Long, _
                     ByVal srcRect As cRectF, _
                     Optional matrix As cMatrix = Nothing, _
                     Optional uWarpMode As WarpMode = WarpModePerspective, _
                     Optional flatness As Single = FlatnessDefault) As GpStatus
    Dim uPts()       As POINTF
    
    If srcRect Is Nothing Then m_uLastStatus = InvalidParameter: Warp = m_uLastStatus: Exit Function
    ReDim uPts(0 To lCount - 1)
    Call ConvertPointFToType(destPoints, uPts)
    If matrix Is Nothing Then
       m_uLastStatus = GdipWarpPath(m_lngPath, ByVal 0&, uPts(LBound(uPts)), lCount, _
                                    srcRect.Left, srcRect.Top, srcRect.Width, srcRect.Height, _
                                    uWarpMode, flatness)
    Else
       m_uLastStatus = GdipWarpPath(m_lngPath, matrix.NativeMatrix, uPts(LBound(uPts)), lCount, _
                                    srcRect.Left, srcRect.Top, srcRect.Width, srcRect.Height, _
                                    uWarpMode, flatness)
    End If
    Erase uPts
    Warp = m_uLastStatus
End Function

' replaces this path with curves that enclose the area that is filled when this path is drawn
' by a specified pen. The Widen method also flattens the path.
Public Function Widen(ByVal pen As cPen, _
                      Optional ByVal matrix As cMatrix = Nothing, _
                      Optional flatness As Single = FlatnessDefault) As GpStatus
    
    If pen Is Nothing Then m_uLastStatus = InvalidParameter: Widen = m_uLastStatus: Exit Function
    If matrix Is Nothing Then
       m_uLastStatus = GdipWidenPath(m_lngPath, pen.NativePen, ByVal 0&, flatness)
    Else
       m_uLastStatus = GdipWidenPath(m_lngPath, pen.NativePen, matrix.NativeMatrix, flatness)
    End If
    Widen = m_uLastStatus
End Function

Private Sub Class_Initialize()
    Call DisposePath
    Call CreatePath
End Sub

Private Sub Class_Terminate()
    Call DisposePath
End Sub
