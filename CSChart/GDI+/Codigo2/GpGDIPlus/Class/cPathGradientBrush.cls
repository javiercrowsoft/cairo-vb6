VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPathGradientBrush"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cPathGradientBrush.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusPath.h:Microsoft Platform SDK February 2003
'
' A PathGradientBrush object stores the attributes of a color gradient that you can
' use to fill the interior of a path with a gradually changing color.
' A path gradient brush has a boundary path, a boundary color, a center point,
' and a center color. When you paint an area with a path gradient brush,
' the color changes gradually from the boundary color to the center color as you
' move from the boundary path to the center point.
' ==================================================================================

Private m_clsBrush As cBrush
Private m_uLastStatus As GpStatus

Public Property Get Brush() As cBrush
    Set Brush = m_clsBrush
End Property

Public Function Clone() As cPathGradientBrush
    Dim lClone As Long
    Dim clsCs As cPathGradientBrush
    
    m_uLastStatus = GdipCloneBrush(m_clsBrush.NativeBrush, lClone)
    If m_uLastStatus <> Ok Then Exit Function
    Set clsCs = New cPathGradientBrush
    clsCs.Brush.fInitialize (lClone)
    Set Clone = clsCs
End Function

' Creates a PathGradientBrush object based on a GraphicsPath object.
Public Function Create(ByVal path As cGraphicsPath) As GpStatus
    Dim lBrush As Long
    
    If path Is Nothing Then m_uLastStatus = InvalidParameter: Create = m_uLastStatus: Exit Function
    Call DisposePathGradientBrush
    m_uLastStatus = GdipCreatePathGradientFromPath(path.NativePath, lBrush)
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize (lBrush)
    Create = m_uLastStatus
End Function

' Creates a PathGradientBrush object based on an array of points.
' Initializes the wrap mode of the path gradient brush.
Public Function CreatePointF(ByRef uPoints() As cPointF, _
                             ByVal lCount As Long, _
                             Optional ByVal uWrapMode As WrapMode = WrapModeClamp) As GpStatus
    Dim lBrush As Long
    Dim uP() As POINTF
    
    Call DisposePathGradientBrush
    Call ConvertPointFToType(uPoints, uP)
    m_uLastStatus = GdipCreatePathGradient(uP(LBound(uP)), lCount, uWrapMode, lBrush)
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize (lBrush)
    CreatePointF = m_uLastStatus
End Function

' Creates a PathGradientBrush object based on an array of points.
' Initializes the wrap mode of the path gradient brush.
Public Function CreatePointL(ByRef uPoints() As cPoint, _
                             ByVal lCount As Long, _
                             Optional ByVal uWrapMode As WrapMode = WrapModeClamp) As GpStatus
    Dim lBrush As Long
    Dim uP() As POINTL
    
    Call DisposePathGradientBrush
    Call ConvertPointLToType(uPoints, uP)
    m_uLastStatus = GdipCreatePathGradientI(uP(LBound(uP)), lCount, uWrapMode, lBrush)
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize (lBrush)
    CreatePointL = m_uLastStatus
End Function

Public Sub DisposePathGradientBrush()
    m_clsBrush.DisposeBrush
    m_uLastStatus = m_clsBrush.GetLastStatus
End Sub

' gets the blend factors and the corresponding blend positions currently set for this path gradient brush.
Public Function GetBlend(ByRef blendFactors() As Single, _
                         ByRef blendPositions() As Single, _
                         ByVal lCount As Long) As GpStatus
    ReDim blendFactors(0 To lCount - 1)
    ReDim blendPositions(0 To lCount - 1)
    m_uLastStatus = GdipGetPathGradientBlend(m_clsBrush.NativeBrush, _
                                             blendFactors(0), _
                                             blendPositions(0), _
                                             lCount)
    GetBlend = m_uLastStatus
End Function

' gets the number of blend factors currently set for this path gradient brush.
Public Function GetBlendCount() As Long
    Dim lCount As Long
    
    m_uLastStatus = GdipGetPathGradientBlendCount(m_clsBrush.NativeBrush, lCount)
    GetBlendCount = lCount
End Function

' gets the color of the center point of this path gradient brush.
Public Function GetCenterColor(ByRef color As cColor) As GpStatus
    Dim lColor As Long
    
    m_uLastStatus = GdipGetPathGradientCenterColor(m_clsBrush.NativeBrush, lColor)
    If m_uLastStatus = Ok Then
       If color Is Nothing Then Set color = New cColor
       color.SetValue (lColor)
    End If
    GetCenterColor = m_uLastStatus
End Function

' gets the center point of this path gradient brush.
Public Function GetCenterPointF(ByRef pt As cPointF) As GpStatus
    Dim uP As POINTF
    
    m_uLastStatus = GdipGetPathGradientCenterPoint(m_clsBrush.NativeBrush, uP)
    If m_uLastStatus = Ok Then
       If pt Is Nothing Then Set pt = New cPointF
       pt.CreateFromType uP
    End If
    GetCenterPointF = m_uLastStatus
End Function

' gets the center point of this path gradient brush.
Public Function GetCenterPointL(ByRef pt As cPoint) As GpStatus
    Dim uP As POINTL
    
    m_uLastStatus = GdipGetPathGradientCenterPointI(m_clsBrush.NativeBrush, uP)
    If m_uLastStatus = Ok Then
       If pt Is Nothing Then Set pt = New cPoint
       pt.CreateFromType uP
    End If
    GetCenterPointL = m_uLastStatus
End Function

' gets the focus scales of this path gradient brush.
Public Function GetFocusScales(ByRef xScale As Single, ByRef yScale As Single) As GpStatus
    m_uLastStatus = GdipGetPathGradientFocusScales(m_clsBrush.NativeBrush, xScale, yScale)
    GetFocusScales = m_uLastStatus
End Function

' determines whether gamma correction is enabled for this path gradient brush.
Public Function GetGammaCorrection() As Boolean
    Dim useGammaCorrection As Long
    
    m_uLastStatus = GdipGetPathGradientGammaCorrection(m_clsBrush.NativeBrush, useGammaCorrection)
    GetGammaCorrection = useGammaCorrection
End Function

Public Function GetGraphicsPath(ByRef path As cGraphicsPath) As GpStatus
    Dim lPath As Long
    
    m_uLastStatus = GdipGetPathGradientPath(m_clsBrush.NativeBrush, lPath)
    If m_uLastStatus = Ok Then
       If path Is Nothing Then Set path = New cGraphicsPath
       path.fInitialize (lPath)
    End If
    GetGraphicsPath = m_uLastStatus
End Function

' gets the number of preset colors currently specified for this path gradient brush.
Public Function GetInterpolationColorCount() As Long
    Dim lCount As Long
    
    m_uLastStatus = GdipGetPathGradientPresetBlendCount(m_clsBrush.NativeBrush, lCount)
    GetInterpolationColorCount = lCount
End Function

' gets the colors currently set to be interpolated for this linear gradient brush and their corresponding blend positions
Public Function GetInterpolationColors(ByRef presetColors() As cColor, _
                                       ByRef blendPositions() As Single, _
                                       ByVal lCount As Long) As GpStatus
    Dim lngI                           As Long
    Dim argbs()                        As Long
    
    If lCount <= 0 Then m_uLastStatus = InvalidParameter: GetInterpolationColors = m_uLastStatus: Exit Function
    ReDim argbs(0 To lCount - 1)
    ReDim blendPositions(0 To lCount - 1)
    m_uLastStatus = GdipGetPathGradientPresetBlend(m_clsBrush.NativeBrush, argbs(0), _
                                                   blendPositions(0), lCount)
    If m_uLastStatus <> Ok Then GetInterpolationColors = m_uLastStatus: Exit Function
    ReDim presetColors(0 To lCount - 1)
    For lngI = 0 To lCount - 1
        Set presetColors(lngI) = New cColor
        presetColors(lngI).SetValue argbs(lngI)
    Next lngI
    GetInterpolationColors = m_uLastStatus
End Function

Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' gets the number of points in the array of points that defines this brush's boundary path.
Public Function GetPointCount() As Long
    Dim lCount As Long
    
    m_uLastStatus = GdipGetPathGradientPointCount(m_clsBrush.NativeBrush, lCount)
    GetPointCount = lCount
End Function

' gets the smallest rectangle that encloses the boundary path of this path gradient brush.
Public Function GetRectangleF(ByVal rect As cRectF) As GpStatus
    Dim uR As RECTF
    
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: GetRectangleF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipGetPathGradientRect(m_clsBrush.NativeBrush, uR)
    rect.CreateFromType uR
    GetRectangleF = m_uLastStatus
End Function

' gets the smallest rectangle that encloses the boundary path of this path gradient brush.
Public Function GetRectangleL(ByVal rect As cRect) As GpStatus
    Dim uR As RECTL
    
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: GetRectangleL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipGetPathGradientRectI(m_clsBrush.NativeBrush, uR)
    rect.CreateFromType uR
    GetRectangleL = m_uLastStatus
End Function

' gets the number of colors that have been specified for the boundary path of this path gradient brush.
Public Function GetSurroundColorCount() As Long
    Dim lCount As Long
    
    m_uLastStatus = GdipGetPathGradientSurroundColorCount(m_clsBrush.NativeBrush, lCount)
    GetSurroundColorCount = lCount
End Function

' gets the surround colors currently specified for this path gradient brush.
Public Function GetSurroundColors(ByRef colors() As cColor, ByRef lCount As Long) As GpStatus
    Dim lngI    As Long
    Dim lCount1 As Long
    Dim argbs() As Long
    
    If lCount <= 0 Then m_uLastStatus = InvalidParameter: GetSurroundColors = m_uLastStatus: Exit Function
    m_uLastStatus = GdipGetPathGradientSurroundColorCount(m_clsBrush.NativeBrush, lCount1)
    If m_uLastStatus <> Ok Then GetSurroundColors = m_uLastStatus: Exit Function
    If lCount < lCount1 Or lCount1 <= 0 Then m_uLastStatus = InsufficientBuffer: GetSurroundColors = m_uLastStatus: Exit Function
    ReDim argbs(0 To lCount1 - 1)
    m_uLastStatus = GdipGetPathGradientSurroundColorsWithCount(m_clsBrush.NativeBrush, argbs(0), lCount1)
    If m_uLastStatus = Ok Then
       ReDim colors(0 To lCount1 - 1)
       For lngI = 0 To lCount1 - 1
           Set colors(lngI) = New cColor
           colors(lngI).SetValue (argbs(lngI))
       Next lngI
       lCount = lCount1
    End If
    Erase argbs
    GetSurroundColors = m_uLastStatus
End Function

' gets transformation matrix of this path gradient brush.
Public Function GetTransform(ByVal matrix As cMatrix) As GpStatus
    Dim lMatrix As Long
    
    If matrix Is Nothing Then m_uLastStatus = InvalidParameter: GetTransform = m_uLastStatus: Exit Function
    m_uLastStatus = GdipGetPathGradientTransform(m_clsBrush.NativeBrush, lMatrix)
    matrix.fInitialize (lMatrix)
    GetTransform = m_uLastStatus
End Function

Public Function GetType() As BrushType
    GetType = m_clsBrush.GetType
End Function

' gets the wrap mode currently set for this path gradient brush.
Public Function GetWrapMode() As WrapMode
    Dim uWrap As WrapMode
    
    m_uLastStatus = GdipGetPathGradientWrapMode(m_clsBrush.NativeBrush, uWrap)
    GetWrapMode = m_uLastStatus
End Function

' updates the brush's transformation matrix with the product of itself and another matrix.
Public Function MultiplyTransform(ByVal matrix As cMatrix, _
                                  Optional order As MatrixOrder = MatrixOrderPrepend) As GpStatus
    If matrix Is Nothing Then m_uLastStatus = InvalidParameter: MultiplyTransform = m_uLastStatus: Exit Function
    m_uLastStatus = GdipMultiplyPathGradientTransform(m_clsBrush.NativeBrush, matrix.NativeMatrix, order)
    MultiplyTransform = m_uLastStatus
End Function

Public Property Get NativeBrush() As Long
    NativeBrush = m_clsBrush.NativeBrush
End Property

' resets the transformation matrix of this path gradient brush to the identity matrix.
' This means that no transformation will take place.
Public Function ResetTransform() As GpStatus
    m_uLastStatus = GdipResetPathGradientTransform(m_clsBrush.NativeBrush)
    ResetTransform = m_uLastStatus
End Function

' updates this brush's current transformation matrix with the product of itself and a rotation matrix.
Public Function RotateTransform(ByVal angle As Single, _
                                Optional order As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipRotatePathGradientTransform(m_clsBrush.NativeBrush, angle, order)
    RotateTransform = m_uLastStatus
End Function

' updates this brush's current transformation matrix with the product of itself and a scaling matrix.
Public Function ScaleTransform(ByVal sx As Single, _
                               ByVal sy As Single, _
                               Optional order As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipScalePathGradientTransform(m_clsBrush.NativeBrush, sx, sy, order)
    ScaleTransform = m_uLastStatus
End Function

' sets the blend factors and the blend positions of this path gradient brush.
Public Function SetBlend(ByRef blendFactors() As Single, _
                         ByRef blendPositions() As Single, _
                         ByVal lCount As Long) As GpStatus
    m_uLastStatus = GdipSetPathGradientBlend(m_clsBrush.NativeBrush, _
                                             blendFactors(LBound(blendFactors)), _
                                             blendPositions(LBound(blendPositions)), _
                                             lCount)
    SetBlend = m_uLastStatus
End Function

' sets the blend shape of this path gradient brush.
Public Function SetBlendBellShape(ByVal focus As Single, _
                                  Optional ByVal sScale As Single = 1#) As GpStatus
    m_uLastStatus = GdipSetPathGradientSigmaBlend(m_clsBrush.NativeBrush, focus, sScale)
    SetBlendBellShape = m_uLastStatus
End Function

' sets the blend shape of this path gradient brush.
Public Function SetBlendTriangularShape(ByVal focus As Single, _
                                        Optional ByVal sScale As Single = 1#) As GpStatus
    m_uLastStatus = GdipSetPathGradientLinearBlend(m_clsBrush.NativeBrush, focus, sScale)
    SetBlendTriangularShape = m_uLastStatus
End Function

Public Sub SetBrush(ByVal cBrush As cBrush)
    Set m_clsBrush = Nothing
    Set m_clsBrush = cBrush
End Sub

' sets the center color of this path gradient brush.
' The center color is the color that appears at the brush's center point.
Public Function SetCenterColor(ByVal color As cColor) As GpStatus
    m_uLastStatus = GdipSetPathGradientCenterColor(m_clsBrush.NativeBrush, color.GetValue())
    SetCenterColor = m_uLastStatus
End Function

' sets the center point of this path gradient brush. By default, the center point is at
' the centroid of the brush's boundary path, but you can set the center point to any location
' inside or outside the path.
Public Function SetCenterPointF(ByVal pt As cPointF) As GpStatus
    m_uLastStatus = GdipSetPathGradientCenterPoint(m_clsBrush.NativeBrush, pt.ToType)
    SetCenterPointF = m_uLastStatus
End Function

Public Function SetCenterPointL(ByVal pt As cPoint) As GpStatus
    m_uLastStatus = GdipSetPathGradientCenterPointI(m_clsBrush.NativeBrush, pt.ToType)
    SetCenterPointL = m_uLastStatus
End Function

' sets the focus scales of this path gradient brush.
Public Function SetFocusScales(ByVal xScale As Single, ByVal yScale As Single) As GpStatus
    m_uLastStatus = GdipSetPathGradientFocusScales(m_clsBrush.NativeBrush, xScale, yScale)
    SetFocusScales = m_uLastStatus
End Function

' specifies whether gamma correction is enabled for this path gradient brush.
Public Function SetGammaCorrection(ByVal useGammaCorrection As Boolean) As GpStatus
    m_uLastStatus = GdipSetPathGradientGammaCorrection(m_clsBrush.NativeBrush, useGammaCorrection)
    SetGammaCorrection = m_uLastStatus
End Function

Public Function SetGraphicsPath(ByVal path As cGraphicsPath) As GpStatus
    If path Is Nothing Then m_uLastStatus = InvalidParameter: SetGraphicsPath = m_uLastStatus: Exit Function
    m_uLastStatus = GdipSetPathGradientPath(m_clsBrush.NativeBrush, path.NativePath)
    SetGraphicsPath = m_uLastStatus
End Function

' sets the preset colors and the blend positions of this path gradient brush.
Public Function SetInterpolationColors(ByRef presetColors() As cColor, _
                                       ByRef blendPositions() As Single, _
                                       ByVal lCount As Long) As GpStatus
    Dim lngI                           As Long
    Dim lngL                           As Long
    Dim lngU                           As Long
    Dim argbs()                        As Long
    
    If lCount <= 0 Then m_uLastStatus = InvalidParameter: SetInterpolationColors = m_uLastStatus: Exit Function
    lngL = LBound(presetColors): lngU = UBound(presetColors)
    ReDim argbs(lngL To lngU)
    For lngI = lngI To lngU
        argbs(lngI) = presetColors(lngI).GetValue()
    Next lngI
    m_uLastStatus = GdipSetPathGradientPresetBlend(m_clsBrush.NativeBrush, argbs(lngL), _
                                                   blendPositions(LBound(blendPositions)), lCount)
    SetInterpolationColors = m_uLastStatus
End Function

' sets the surround colors of this path gradient brush.
' The surround colors are colors specified for discrete points on the brush's boundary path.
Public Function SetSurroundColors(ByRef colors() As cColor, ByRef lCount As Long) As GpStatus
    Dim lCount1 As Long
    Dim lngL As Long
    Dim lngU As Long
    Dim lngI As Long
    Dim argbs() As Long
    
    If lCount <= 0 Then m_uLastStatus = InvalidParameter: SetSurroundColors = m_uLastStatus: Exit Function
    m_uLastStatus = GdipGetPathGradientSurroundColorCount(m_clsBrush.NativeBrush, lCount1)
    If m_uLastStatus <> Ok Then SetSurroundColors = m_uLastStatus: Exit Function
    If lCount < lCount1 Or lCount1 <= 0 Then m_uLastStatus = InsufficientBuffer: SetSurroundColors = m_uLastStatus: Exit Function
    lngL = LBound(colors): lngU = UBound(colors)
    ReDim argbs(lngL To lngU)
    For lngI = lngL To lngU
        argbs(lngI) = colors(lngI).GetValue()
    Next lngI
    m_uLastStatus = GdipSetPathGradientSurroundColorsWithCount(m_clsBrush.NativeBrush, argbs(lngL), lCount1)
    If m_uLastStatus = Ok Then lCount = lCount1
    Erase argbs
    SetSurroundColors = m_uLastStatus
End Function

' sets the transformation matrix of this path gradient brush.
Public Function SetTransform(ByVal matrix As cMatrix) As GpStatus
    If matrix Is Nothing Then m_uLastStatus = InvalidParameter: SetTransform = m_uLastStatus: Exit Function
    m_uLastStatus = GdipSetPathGradientTransform(m_clsBrush.NativeBrush, matrix.NativeMatrix)
    SetTransform = m_uLastStatus
End Function

' sets the wrap mode of this path gradient brush.
Public Function SetWrapMode(ByVal uWrap As WrapMode) As GpStatus
    m_uLastStatus = GdipSetPathGradientWrapMode(m_clsBrush.NativeBrush, uWrap)
    SetWrapMode = m_uLastStatus
End Function

' updates this brush's current transformation matrix with the product of itself and a translation matrix.
Public Function TranslateTransform(ByVal dx As Single, _
                                   ByVal dy As Single, _
                                   Optional order As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipTranslatePathGradientTransform(m_clsBrush.NativeBrush, dx, dy, order)
    TranslateTransform = m_uLastStatus
End Function

Private Sub Class_Initialize()
    Set m_clsBrush = New cBrush
End Sub

Private Sub Class_Terminate()
    Set m_clsBrush = Nothing
End Sub



