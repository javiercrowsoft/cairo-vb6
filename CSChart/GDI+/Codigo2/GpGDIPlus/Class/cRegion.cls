VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRegion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cRegion.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusTypes.h:Microsoft Platform SDK February 2003
'
' A Rect object stores the upper-left corner, width, and height of a rectangle.
' ==================================================================================

Private m_lngRegion As Long
Private m_uLastStatus As GpStatus

' makes a copy of this Region object and returns the address of the new Region object.
Public Function Clone() As cRegion
    Dim lngRegion       As Long
    Dim clsClone        As cRegion
    
    m_uLastStatus = GdipCloneRegion(m_lngRegion, lngRegion)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cRegion
    clsClone.fInitialize (lngRegion)
    Set Clone = clsClone
End Function

' updates this region to the portion of the specified path's interior that
' does not intersect this region.
Public Function ComplementGraphicsPath(ByVal path As cGraphicsPath) As GpStatus
    If path Is Nothing Then m_uLastStatus = InvalidParameter: ComplementGraphicsPath = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionPath(m_lngRegion, path.NativePath, CombineModeComplement)
    ComplementGraphicsPath = m_uLastStatus
End Function

' updates this region to the portion of the specified rectangle's interior
' that does not intersect this region
Public Function ComplementRectF(ByVal rect As cRectF) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: ComplementRectF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRect(m_lngRegion, rect.ToType, CombineModeComplement)
    ComplementRectF = m_uLastStatus
End Function

' updates this region to the portion of the specified rectangle's interior
' that does not intersect this region
Public Function ComplementRectL(ByVal rect As cRect) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: ComplementRectL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRectI(m_lngRegion, rect.ToType, CombineModeComplement)
    ComplementRectL = m_uLastStatus
End Function

' updates this region to the portion of another region that does not intersect this region.
Public Function ComplementRegion(ByVal region As cRegion) As GpStatus
    If region Is Nothing Then m_uLastStatus = InvalidParameter: ComplementRegion = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRegion(m_lngRegion, region.NativeRegion, CombineModeComplement)
    ComplementRegion = m_uLastStatus
End Function

'Public Function CreateFromData() As GpStatus
    'GdipCreateRegionRgnData
'End Function

' Creates a region that is defined by a path (a GraphicsPath object)
' and has a fill mode that is contained in the GraphicsPath object.
Public Function CreateFromGraphicsPath(ByVal path As cGraphicsPath) As GpStatus
    If path Is Nothing Then m_uLastStatus = InvalidParameter: CreateFromGraphicsPath = m_uLastStatus: Exit Function
    Call DisposeRegion
    m_uLastStatus = GdipCreateRegionPath(path.NativePath, m_lngRegion)
    CreateFromGraphicsPath = m_uLastStatus
End Function

' Creates a region that is identical to the region that is specified by a handle to a GDI region
Public Function CreateFromHRGN(ByVal hRgn As Long) As GpStatus
    Call DisposeRegion
    m_uLastStatus = GdipCreateRegionHrgn(hRgn, m_lngRegion)
    CreateFromHRGN = m_uLastStatus
End Function

' Creates a region that is defined by a rectangle.
Public Function CreateFromRectF(ByVal rect As cRectF)
    Call DisposeRegion
    m_uLastStatus = GdipCreateRegionRect(rect.ToType, m_lngRegion)
    CreateFromRectF = m_uLastStatus
End Function

' Creates a region that is defined by a rectangle.
Public Function CreateFromRectL(ByVal rect As cRect)
    Call DisposeRegion
    m_uLastStatus = GdipCreateRegionRectI(rect.ToType, m_lngRegion)
    CreateFromRectL = m_uLastStatus
End Function

Public Sub DisposeRegion()
    If m_lngRegion <> 0 Then m_uLastStatus = GdipDeleteRegion(m_lngRegion): m_lngRegion = 0
End Sub

' determines whether this region is equal to a specified region.
Public Function Equals(ByVal R As cRegion, ByVal g As cGraphics) As Boolean
    Dim lResult As Long
    
    If R Is Nothing Then m_uLastStatus = InvalidParameter: Exit Function
    If g Is Nothing Then m_uLastStatus = InvalidParameter: Exit Function
    m_uLastStatus = GdipIsEqualRegion(m_lngRegion, R.NativeRegion, g.NativeGraphics, lResult)
    Equals = lResult
End Function

' updates this region to the portion of itself that does not intersect
' the specified path's interior.
Public Function ExcludeGraphicsPath(ByVal path As cGraphicsPath) As GpStatus
    If path Is Nothing Then m_uLastStatus = InvalidParameter: ExcludeGraphicsPath = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionPath(m_lngRegion, path.NativePath, CombineModeExclude)
    ExcludeGraphicsPath = m_uLastStatus
End Function

' updates this region to the portion of itself that does not intersect
' the specified rectangle's interior.
Public Function ExcludeRectF(ByVal rect As cRectF) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: ExcludeRectF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRect(m_lngRegion, rect.ToType, CombineModeExclude)
    ExcludeRectF = m_uLastStatus
End Function

' updates this region to the portion of itself that does not intersect
' the specified rectangle's interior.
Public Function ExcludeRectL(ByVal rect As cRect) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: ExcludeRectL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRectI(m_lngRegion, rect.ToType, CombineModeExclude)
    ExcludeRectL = m_uLastStatus
End Function

' updates this region to the portion of itself that does not intersect another region.
Public Function ExcludeRegion(ByVal region As cRegion) As GpStatus
    If region Is Nothing Then m_uLastStatus = InvalidParameter: ExcludeRegion = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRegion(m_lngRegion, region.NativeRegion, CombineModeExclude)
    ExcludeRegion = m_uLastStatus
End Function

Friend Sub fInitialize(ByVal lRegion As Long)
    Call DisposeRegion
    m_lngRegion = lRegion
End Sub

' creates a Region object from a GDI region.
Public Function FromHRGN(ByVal hRgn As Long) As cRegion
    Dim clsR As cRegion
    Dim lngR As Long
    
    m_uLastStatus = GdipCreateRegionHrgn(hRgn, lngR)
    If m_uLastStatus <> Ok Then Set clsR = Nothing: Exit Function
    Set clsR = New cRegion
    clsR.fInitialize lngR
    Set FromHRGN = clsR
End Function

' gets a rectangle that encloses this region
Public Function GetBoundsRectF(ByVal rect As cRectF, ByVal g As cGraphics) As GpStatus
    Dim uR As RECTF
    
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: GetBoundsRectF = m_uLastStatus: Exit Function
    If g Is Nothing Then m_uLastStatus = InvalidParameter: GetBoundsRectF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipGetRegionBounds(m_lngRegion, g.NativeGraphics, uR)
    rect.CreateFromType uR
    GetBoundsRectF = m_uLastStatus
End Function

' gets a rectangle that encloses this region
Public Function GetBoundsRectL(ByVal rect As cRect, ByVal g As cGraphics) As GpStatus
    Dim uR As RECTL
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: GetBoundsRectL = m_uLastStatus: Exit Function
    If g Is Nothing Then m_uLastStatus = InvalidParameter: GetBoundsRectL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipGetRegionBoundsI(m_lngRegion, g.NativeGraphics, uR)
    rect.CreateFromType uR
    GetBoundsRectL = m_uLastStatus
End Function

' gets the number of bytes of data that describes this region
Public Function GetDataSize() As Long
    Dim lBufferSize As Long
    m_uLastStatus = GdipGetRegionDataSize(m_lngRegion, lBufferSize)
    GetDataSize = lBufferSize
End Function

' creates a GDI region from this region.
Public Function GetHRGN(ByVal g As cGraphics) As Long
    Dim hRgn As Long
    
    If g Is Nothing Then m_uLastStatus = InvalidParameter: Exit Function
    m_uLastStatus = GdipGetRegionHRgn(m_lngRegion, g.NativeGraphics, hRgn)
    GetHRGN = hRgn
End Function

' returns a value that indicates the nature of this Region object's most recent method failure.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' gets an array of rectangles that approximate this region.
' The region is transformed by a specified matrix before the rectangles are calculated
Public Function GetRegionScansRectF(ByVal matrix As cMatrix, _
                                    ByRef rect() As cRectF, _
                                    ByRef lCount As Long) As GpStatus
    Dim lngI As Long
    Dim uR() As RECTF
    If matrix Is Nothing Then m_uLastStatus = InvalidParameter: GetRegionScansRectF = m_uLastStatus: Exit Function
    ReDim uR(0 To lCount - 1)
    m_uLastStatus = GdipGetRegionScans(m_lngRegion, uR(0), lCount, matrix.NativeMatrix)
    ReDim rect(0 To lCount - 1)
    For lngI = 0 To lCount - 1
        Set rect(lngI) = New cRectF
        rect(lngI).CreateFromType uR(lngI)
    Next lngI
    GetRegionScansRectF = m_uLastStatus
End Function

' gets an array of rectangles that approximate this region.
' The region is transformed by a specified matrix before the rectangles are calculated
Public Function GetRegionScansRectL(ByVal matrix As cMatrix, _
                                    ByRef rect() As cRect, _
                                    ByRef lCount As Long) As GpStatus
    Dim lngI As Long
    Dim uR() As RECTL
    If matrix Is Nothing Then m_uLastStatus = InvalidParameter: GetRegionScansRectL = m_uLastStatus: Exit Function
    ReDim uR(0 To lCount - 1)
    m_uLastStatus = GdipGetRegionScansI(m_lngRegion, uR(0), lCount, matrix.NativeMatrix)
    ReDim rect(0 To lCount - 1)
    For lngI = 0 To lCount - 1
        Set rect(lngI) = New cRect
        rect(lngI).CreateFromType uR(lngI)
    Next lngI
    GetRegionScansRectL = m_uLastStatus
End Function

' gets the number of rectangles that approximate this region.
Public Function GetRegionScansCount(ByVal matrix As cMatrix) As Long
    Dim lCount As Long
    
    If matrix Is Nothing Then m_uLastStatus = InvalidParameter: Exit Function
    m_uLastStatus = GdipGetRegionScansCount(m_lngRegion, lCount, matrix.NativeMatrix)
    GetRegionScansCount = m_uLastStatus
End Function

' updates this region to the portion of itself that intersects the specified path's interior.
Public Function IntersectGraphicsPath(ByVal path As cGraphicsPath) As GpStatus
    If path Is Nothing Then m_uLastStatus = InvalidParameter: IntersectGraphicsPath = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionPath(m_lngRegion, path.NativePath, CombineModeIntersect)
    IntersectGraphicsPath = m_uLastStatus
End Function

' updates this region to the portion of itself that intersects the specified rectangle's interior.
Public Function IntersectRectF(ByVal rect As cRectF) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: IntersectRectF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRect(m_lngRegion, rect.ToType, CombineModeIntersect)
    IntersectRectF = m_uLastStatus
End Function

' updates this region to the portion of itself that intersects the specified rectangle's interior.
Public Function IntersectRectL(ByVal rect As cRect) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: IntersectRectL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRectI(m_lngRegion, rect.ToType, CombineModeIntersect)
    IntersectRectL = m_uLastStatus
End Function

' updates this region to the portion of itself that intersects another region.
Public Function IntersectRegion(ByVal region As cRegion) As GpStatus
    If region Is Nothing Then m_uLastStatus = InvalidParameter: IntersectRegion = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRegion(m_lngRegion, region.NativeRegion, CombineModeIntersect)
    IntersectRegion = m_uLastStatus
End Function

' determines whether this region is empty.
Public Function IsEmpty(ByVal g As cGraphics) As Boolean
    Dim lR As Long
    
    If g Is Nothing Then m_uLastStatus = InvalidParameter: Exit Function
    m_uLastStatus = GdipIsEmptyRegion(m_lngRegion, g.NativeGraphics, lR)
    IsEmpty = lR
End Function

' determines whether this region is infinite.
Public Function IsInfinite(ByVal g As cGraphics) As Boolean
    Dim lR As Long
    
    If g Is Nothing Then m_uLastStatus = InvalidParameter: Exit Function
    m_uLastStatus = GdipIsInfiniteRegion(m_lngRegion, g.NativeGraphics, lR)
    IsInfinite = lR
End Function

' determines whether a point is inside this region
Public Function IsVisibleF(ByVal x As Single, _
                           ByVal y As Single, _
                           ByVal g As cGraphics) As Boolean
    Dim lR As Long
    If g Is Nothing Then m_uLastStatus = InvalidParameter: Exit Function
    m_uLastStatus = GdipIsVisibleRegionPoint(m_lngRegion, x, y, g.NativeGraphics, lR)
    IsVisibleF = lR
End Function

' determines whether a point is inside this region
Public Function IsVisibleL(ByVal x As Long, _
                           ByVal y As Long, _
                           ByVal g As cGraphics) As Boolean
    Dim lR As Long
    If g Is Nothing Then m_uLastStatus = InvalidParameter: Exit Function
    m_uLastStatus = GdipIsVisibleRegionPointI(m_lngRegion, x, y, g.NativeGraphics, lR)
    IsVisibleL = lR
End Function

' determines whether a point is inside this region
Public Function IsVisiblePointF(ByVal pt As cPointF, _
                                ByVal g As cGraphics) As Boolean
    IsVisiblePointF = IsVisibleF(pt.x, pt.y, g)
End Function

' determines whether a point is inside this region
Public Function IsVisiblePointL(ByVal pt As cPoint, _
                                ByVal g As cGraphics) As Boolean
    IsVisiblePointL = IsVisibleL(pt.x, pt.y, g)
End Function

' determines whether a rectangle intersects this region.
Public Function IsVisibleRectF(ByVal rect As cRectF, ByVal g As cGraphics) As Boolean
    IsVisibleRectF = IsVisibleSizeF(rect.Left, rect.Top, _
                                    rect.Width, rect.Height, g)
End Function

' determines whether a rectangle intersects this region.
Public Function IsVisibleRectL(ByVal rect As cRect, ByVal g As cGraphics) As Boolean
    IsVisibleRectL = IsVisibleSizeL(rect.Left, rect.Top, _
                                    rect.Width, rect.Height, g)
End Function

' determines whether a rectangle intersects this region.
Public Function IsVisibleSizeF(ByVal x As Single, _
                               ByVal y As Single, _
                               ByVal Width As Single, _
                               ByVal Height As Single, _
                               ByVal g As cGraphics) As Boolean
    Dim lR As Long
    If g Is Nothing Then m_uLastStatus = InvalidParameter: Exit Function
    m_uLastStatus = GdipIsVisibleRegionRect(m_lngRegion, x, y, Width, Height, g.NativeGraphics, lR)
    IsVisibleSizeF = lR
End Function

' determines whether a rectangle intersects this region.
Public Function IsVisibleSizeL(ByVal x As Long, _
                               ByVal y As Long, _
                               ByVal Width As Long, _
                               ByVal Height As Long, _
                               ByVal g As cGraphics) As Boolean
    Dim lR As Long
    If g Is Nothing Then m_uLastStatus = InvalidParameter: Exit Function
    m_uLastStatus = GdipIsVisibleRegionRectI(m_lngRegion, x, y, Width, Height, g.NativeGraphics, lR)
    IsVisibleSizeL = lR
End Function

' updates this region to an empty region. In other words,
' the region occupies no space on the display device
Public Function MakeEmpty() As GpStatus
    m_uLastStatus = GdipSetEmpty(m_lngRegion)
    MakeEmpty = m_uLastStatus
End Function

' updates this region to an infinite region.
Public Function MakeInfinite() As GpStatus
    m_uLastStatus = GdipSetInfinite(m_lngRegion)
    MakeInfinite = m_uLastStatus
End Function

Public Property Get NativeRegion() As Long
    NativeRegion = m_lngRegion
End Property

' transforms this region by multiplying each of its data points by a specified matrix.
Public Function Transform(ByVal matrix As cMatrix) As GpStatus
    m_uLastStatus = GdipTransformRegion(m_lngRegion, matrix.NativeMatrix)
    Transform = m_uLastStatus
End Function

' offsets this region by specified amounts in the horizontal and vertical directions.
Public Function TranslateF(ByVal dx As Single, ByVal dy As Single) As GpStatus
    m_uLastStatus = GdipTranslateRegion(m_lngRegion, dx, dy)
    TranslateF = m_uLastStatus
End Function

' offsets this region by specified amounts in the horizontal and vertical directions.
Public Function TranslateL(ByVal dx As Single, ByVal dy As Single) As GpStatus
    m_uLastStatus = GdipTranslateRegion(m_lngRegion, dx, dy)
    TranslateL = m_uLastStatus
End Function

' updates this region to all portions (intersecting and nonintersecting) of itself and all portions of the specified path's interior
Public Function UnionGraphicsPath(ByVal path As cGraphicsPath) As GpStatus
    If path Is Nothing Then m_uLastStatus = InvalidParameter: UnionGraphicsPath = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionPath(m_lngRegion, path.NativePath, CombineModeUnion)
    UnionGraphicsPath = m_uLastStatus
End Function

' updates this region to all portions (intersecting and nonintersecting) of itself and all portions of the specified rectangle's interior
Public Function UnionRectF(ByVal rect As cRectF) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: UnionRectF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRect(m_lngRegion, rect.ToType, CombineModeUnion)
    UnionRectF = m_uLastStatus
End Function

' updates this region to all portions (intersecting and nonintersecting) of itself and all portions of the specified rectangle's interior.
Public Function UnionRectL(ByVal rect As cRect) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: UnionRectL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRectI(m_lngRegion, rect.ToType, CombineModeUnion)
    UnionRectL = m_uLastStatus
End Function

' updates this region to all portions (intersecting and nonintersecting) of itself and all portions of another region.
Public Function UnionRegion(ByVal region As cRegion) As GpStatus
    If region Is Nothing Then m_uLastStatus = InvalidParameter: UnionRegion = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRegion(m_lngRegion, region.NativeRegion, CombineModeUnion)
    UnionRegion = m_uLastStatus
End Function

' updates this region to the nonintersecting portions of itself and the specified path's interior.
Public Function XorGraphicsPath(ByVal path As cGraphicsPath) As GpStatus
    If path Is Nothing Then m_uLastStatus = InvalidParameter: XorGraphicsPath = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionPath(m_lngRegion, path.NativePath, CombineModeXor)
    XorGraphicsPath = m_uLastStatus
End Function

' updates this region to the nonintersecting portions of itself and the specified rectangle's interior.
Public Function XorRectF(ByVal rect As cRectF) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: XorRectF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRect(m_lngRegion, rect.ToType, CombineModeXor)
    XorRectF = m_uLastStatus
End Function

' updates this region to the nonintersecting portions of itself and the specified rectangle's interior.
Public Function XorRectL(ByVal rect As cRect) As GpStatus
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: XorRectL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRectI(m_lngRegion, rect.ToType, CombineModeXor)
    XorRectL = m_uLastStatus
End Function

' updates this region to the nonintersecting portions of itself and another region.
Public Function XorRegion(ByVal region As cRegion) As GpStatus
    If region Is Nothing Then m_uLastStatus = InvalidParameter: XorRegion = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCombineRegionRegion(m_lngRegion, region.NativeRegion, CombineModeXor)
    XorRegion = m_uLastStatus
End Function

Private Sub Class_Initialize()
    Call DisposeRegion
    m_uLastStatus = GdipCreateRegion(m_lngRegion)
End Sub

Private Sub Class_Terminate()
    Call DisposeRegion
End Sub
