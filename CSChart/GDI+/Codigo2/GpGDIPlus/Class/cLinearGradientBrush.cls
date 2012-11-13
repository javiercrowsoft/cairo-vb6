VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cLinearGradientBrush"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cLinearGradientBrush.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiPlusBrush.h:Microsoft Platform SDK February 2003
'
' The LinearGradientBrush class defines a brush that paints a color gradient in
' which the color changes evenly from the starting boundary line of the linear
' gradient brush to the ending boundary line of the linear gradient brush.
' The boundary lines of a linear gradient brush are two parallel straight lines.
' The color gradient is perpendicular to the boundary lines of the linear gradient
' brush, changing gradually across the stroke from the starting boundary line to
' the ending boundary line. The color gradient has one color at the starting
' boundary line and another color at the ending boundary line.
' ==================================================================================

Private m_clsBrush As cBrush
Private m_uLastStatus As GpStatus

Public Property Get Brush() As cBrush
    Set Brush = m_clsBrush
End Property

Public Function Clone() As cLinearGradientBrush
    Dim lClone As Long
    Dim clsCs As cLinearGradientBrush
    
    m_uLastStatus = GdipCloneBrush(m_clsBrush.NativeBrush, lClone)
    If m_uLastStatus <> Ok Then Exit Function
    Set clsCs = New cLinearGradientBrush
    clsCs.Brush.fInitialize (lClone)
    Set Clone = clsCs
End Function

' Creates a LinearGradientBrush object from a set of boundary points and boundary colors.
Public Function CreateLineBrushF(ByVal Point1 As cPointF, _
                                 ByVal Point2 As cPointF, _
                                 ByVal color1 As cColor, _
                                 ByVal color2 As cColor) _
                                 As GpStatus
    Dim lBrush As Long
    
    Call DisposeLinearGradientBrush
    If Point1 Is Nothing Or Point2 Is Nothing Or color1 Is Nothing Or color2 Is Nothing Then
       m_uLastStatus = InvalidParameter: CreateLineBrushF = m_uLastStatus: Exit Function
    End If
    m_uLastStatus = GdipCreateLineBrush(Point1.ToType, Point2.ToType, color1.GetValue(), color2.GetValue(), WrapModeTile, lBrush)
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize lBrush
    CreateLineBrushF = m_uLastStatus
End Function

' Creates a LinearGradientBrush object from a set of boundary points and boundary colors.
Public Function CreateLineBrushL(ByVal Point1 As cPoint, _
                                 ByVal Point2 As cPoint, _
                                 ByVal color1 As cColor, _
                                 ByVal color2 As cColor) _
                                 As GpStatus
    Dim lBrush As Long
    
    Call DisposeLinearGradientBrush
    If Point1 Is Nothing Or Point2 Is Nothing Or color1 Is Nothing Or color2 Is Nothing Then
       m_uLastStatus = InvalidParameter: CreateLineBrushL = m_uLastStatus: Exit Function
    End If
    m_uLastStatus = GdipCreateLineBrushI(Point1.ToType, Point2.ToType, color1.GetValue(), color2.GetValue(), WrapModeTile, lBrush)
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize lBrush
    CreateLineBrushL = m_uLastStatus
End Function

' Creates a LinearGradientBrush object based on a rectangle and mode of direction.
Public Function CreateLineBrushFromRectF(ByVal rect As cRectF, _
                                         ByVal color1 As cColor, _
                                         ByVal color2 As cColor, _
                                         ByVal uMode As LinearGradientMode) _
                                         As GpStatus
    Dim lBrush As Long
    
    Call DisposeLinearGradientBrush
    If rect Is Nothing Or color1 Is Nothing Or color2 Is Nothing Then
       m_uLastStatus = InvalidParameter: CreateLineBrushFromRectF = m_uLastStatus: Exit Function
    End If
    m_uLastStatus = GdipCreateLineBrushFromRect(rect.ToType, color1.GetValue(), color2.GetValue(), uMode, WrapModeTile, lBrush)
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize lBrush
    CreateLineBrushFromRectF = m_uLastStatus
End Function

' Creates a LinearGradientBrush object based on a rectangle and mode of direction.
Public Function CreateLineBrushFromRectL(ByVal rect As cRect, _
                                         ByVal color1 As cColor, _
                                         ByVal color2 As cColor, _
                                         ByVal uMode As LinearGradientMode) _
                                         As GpStatus
    Dim lBrush As Long
    
    Call DisposeLinearGradientBrush
    If rect Is Nothing Or color1 Is Nothing Or color2 Is Nothing Then
       m_uLastStatus = InvalidParameter: CreateLineBrushFromRectL = m_uLastStatus: Exit Function
    End If
    m_uLastStatus = GdipCreateLineBrushFromRectI(rect.ToType, color1.GetValue(), color2.GetValue(), uMode, WrapModeTile, lBrush)
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize lBrush
    CreateLineBrushFromRectL = m_uLastStatus
End Function

' Creates a LinearGradientBrush object from a set of boundary points and boundary colors.
Public Function CreateLineBrushFromRectWithAngleF(ByVal rect As cRectF, _
                                                  ByVal color1 As cColor, _
                                                  ByVal color2 As cColor, _
                                                  ByVal angle As Single, _
                                                  Optional ByVal isAngleScalable As Boolean = False) _
                                                  As GpStatus
    Dim lBrush As Long
    
    Call DisposeLinearGradientBrush
    If rect Is Nothing Or color1 Is Nothing Or color2 Is Nothing Then
       m_uLastStatus = InvalidParameter: CreateLineBrushFromRectWithAngleF = m_uLastStatus: Exit Function
    End If
    m_uLastStatus = GdipCreateLineBrushFromRectWithAngle(rect.ToType, color1.GetValue(), color2.GetValue(), angle, isAngleScalable, WrapModeTile, lBrush)
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize lBrush
    CreateLineBrushFromRectWithAngleF = m_uLastStatus
End Function

' Creates a LinearGradientBrush object from a set of boundary points and boundary colors.
Public Function CreateLineBrushFromRectWithAngleL(ByVal rect As cRect, _
                                                  ByVal color1 As cColor, _
                                                  ByVal color2 As cColor, _
                                                  ByVal angle As Single, _
                                                  Optional ByVal isAngleScalable As Boolean = False) _
                                                  As GpStatus
    Dim lBrush As Long
    
    Call DisposeLinearGradientBrush
    If rect Is Nothing Or color1 Is Nothing Or color2 Is Nothing Then
       m_uLastStatus = InvalidParameter: CreateLineBrushFromRectWithAngleL = m_uLastStatus: Exit Function
    End If
    m_uLastStatus = GdipCreateLineBrushFromRectWithAngleI(rect.ToType, color1.GetValue(), color2.GetValue(), angle, isAngleScalable, WrapModeTile, lBrush)
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize lBrush
    CreateLineBrushFromRectWithAngleL = m_uLastStatus
End Function

Public Sub DisposeLinearGradientBrush()
    m_clsBrush.DisposeBrush
    m_uLastStatus = m_clsBrush.GetLastStatus
End Sub

' gets the blend factors and their corresponding blend positions from a LinearGradientBrush object.
Public Function GetBlend(ByRef blendFactors() As Single, _
                         ByRef blendPositions() As Single, _
                         ByVal lCount As Long) As GpStatus
    ReDim blendFactors(0 To lCount - 1)
    ReDim blendPositions(0 To lCount - 1)
    m_uLastStatus = GdipGetLineBlend(m_clsBrush.NativeBrush, blendFactors(0), blendPositions(0), lCount)
    GetBlend = m_uLastStatus
End Function

' gets the number of blend factors currently set for this LinearGradientBrush object.
Public Function GetBlendCount() As Long
    Dim lCount As Long
    
    m_uLastStatus = GdipGetLineBlendCount(m_clsBrush.NativeBrush, lCount)
    GetBlendCount = lCount
End Function

' determines whether gamma correction is enabled for this LinearGradientBrush object.
Public Function GetGammaCorrection() As Boolean
    Dim useGammaCorrection As Long
    
    m_uLastStatus = GdipGetLineGammaCorrection(m_clsBrush.NativeBrush, useGammaCorrection)
    GetGammaCorrection = useGammaCorrection
End Function

' gets the number of colors currently set to be interpolated for this linear gradient brush.
Public Function GetInterpolationColorCount() As Long
    Dim lCount As Long
    
    m_uLastStatus = GdipGetLinePresetBlendCount(m_clsBrush.NativeBrush, lCount)
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
    m_uLastStatus = GdipGetLinePresetBlend(m_clsBrush.NativeBrush, argbs(0), _
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

' gets the starting color and ending color of this linear gradient brush.
Public Function GetLinearColors(ByRef colors() As cColor) As GpStatus
    Dim lngI                    As Long
    Dim argbs(0 To 1)           As Long
    
    m_uLastStatus = GdipGetLineColors(m_clsBrush.NativeBrush, argbs(0))
    If m_uLastStatus <> Ok Then GetLinearColors = m_uLastStatus: Exit Function
    ReDim colors(0 To 1)
    Set colors(0) = New cColor
    colors(0).SetValue (argbs(0))
    Set colors(1) = New cColor
    colors(1).SetValue (argbs(1))
    GetLinearColors = m_uLastStatus
End Function

' gets the rectangle that defines the boundaries of the gradient.
Public Function GetRectangleF(ByVal rect As cRectF) As GpStatus
    Dim uR As RECTF
    
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: GetRectangleF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipGetLineRect(m_clsBrush.NativeBrush, uR)
    rect.CreateFromType uR
    GetRectangleF = m_uLastStatus
End Function

' gets the rectangle that defines the boundaries of the gradient.
Public Function GetRectangleL(ByVal rect As cRect) As GpStatus
    Dim uR As RECTL
    
    If rect Is Nothing Then m_uLastStatus = InvalidParameter: GetRectangleL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipGetLineRectI(m_clsBrush.NativeBrush, uR)
    rect.CreateFromType uR
    GetRectangleL = m_uLastStatus
End Function

' gets the transformation matrix of this linear gradient brush.
Public Function GetTransform(ByVal matrix As cMatrix) As GpStatus
    Dim lMatrix As Long
    
    If matrix Is Nothing Then m_uLastStatus = InvalidParameter: GetTransform = m_uLastStatus: Exit Function
    m_uLastStatus = GdipGetLineTransform(m_clsBrush.NativeBrush, lMatrix)
    matrix.fInitialize lMatrix
    GetTransform = m_uLastStatus
End Function

Public Function GetType() As BrushType
    GetType = m_clsBrush.GetType
End Function

' gets the wrap mode for this brush. The wrap mode determines how an area is tiled when
' it is painted with a brush.
Public Function GetWrapMode() As WrapMode
    Dim uWrap As WrapMode
    
    m_uLastStatus = GdipGetLineWrapMode(m_clsBrush.NativeBrush, uWrap)
    GetWrapMode = m_uLastStatus
End Function

' updates this brush's transformation matrix with the product of itself and another matrix.
Public Function MultiplyTransform(ByVal matrix As cMatrix, _
                                  Optional order As MatrixOrder = MatrixOrderPrepend) As GpStatus
    If matrix Is Nothing Then m_uLastStatus = InvalidParameter: MultiplyTransform = m_uLastStatus: Exit Function
    m_uLastStatus = GdipMultiplyLineTransform(m_clsBrush.NativeBrush, matrix.NativeMatrix, order)
    MultiplyTransform = m_uLastStatus
End Function

Public Property Get NativeBrush() As Long
    NativeBrush = m_clsBrush.NativeBrush
End Property

' resets the transformation matrix of this linear gradient brush to the identity matrix.
' This means that no transformation takes place.
Public Function ResetTransform() As GpStatus
    m_uLastStatus = GdipResetLineTransform(m_clsBrush.NativeBrush)
    ResetTransform = m_uLastStatus
End Function

' updates this brush's current transformation matrix with the product of itself and a rotation matrix.
Public Function RotateTransform(ByVal angle As Single, _
                                Optional order As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipRotateLineTransform(m_clsBrush.NativeBrush, angle, order)
    RotateTransform = m_uLastStatus
End Function

' updates this brush's current transformation matrix with the product of itself and a scaling matrix.
Public Function ScaleTransform(ByVal sx As Single, _
                               ByVal sy As Single, _
                               Optional order As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipScaleLineTransform(m_clsBrush.NativeBrush, sx, sy, order)
    ScaleTransform = m_uLastStatus
End Function

' sets the blend factors and the blend positions of this linear gradient brush to create a custom blend.
Public Function SetBlend(ByRef blendFactors() As Single, _
                         ByRef blendPositions() As Single, _
                         ByVal lCount As Long) As GpStatus
    m_uLastStatus = GdipSetLineBlend(m_clsBrush.NativeBrush, blendFactors(LBound(blendFactors)), _
                                   blendPositions(LBound(blendPositions)), lCount)
    SetBlend = m_uLastStatus
End Function

' sets the blend shape of this linear gradient brush to create a custom blend based on a bell-shaped curve.
Public Function SetBlendBellShape(ByVal focus As Single, _
                                  Optional ByVal sScale As Single = 1#) As GpStatus
    m_uLastStatus = GdipSetLineSigmaBlend(m_clsBrush.NativeBrush, focus, sScale)
    SetBlendBellShape = m_uLastStatus
End Function

' sets the blend shape of this linear gradient brush to create a custom blend based on a triangular shape.
Public Function SetBlendTriangularShape(ByVal focus As Single, _
                                        Optional ByVal sScale As Single = 1#) As GpStatus
    m_uLastStatus = GdipSetLineLinearBlend(m_clsBrush.NativeBrush, focus, sScale)
    SetBlendTriangularShape = m_uLastStatus
End Function

Public Sub SetBrush(ByVal cBrush As cBrush)
    Set m_clsBrush = Nothing
    Set m_clsBrush = cBrush
End Sub

' specifies whether gamma correction is enabled for this linear gradient brush.
Public Function SetGammaCorrection(ByVal useGammaCorrection As Boolean) As GpStatus
    m_uLastStatus = GdipSetLineGammaCorrection(m_clsBrush.NativeBrush, useGammaCorrection)
    SetGammaCorrection = m_uLastStatus
End Function

' sets the colors to be interpolated for this linear gradient brush and their corresponding blend positions.
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
    m_uLastStatus = GdipSetLinePresetBlend(m_clsBrush.NativeBrush, argbs(lngL), _
                                           blendPositions(LBound(blendPositions)), lCount)
    SetInterpolationColors = m_uLastStatus
End Function

' sets the starting color and ending color of this linear gradient brush.
Public Function SetLinearColors(ByVal color1 As cColor, ByVal color2 As cColor) As GpStatus
    If color1 Is Nothing Then m_uLastStatus = InvalidParameter: SetLinearColors = m_uLastStatus: Exit Function
    If color2 Is Nothing Then m_uLastStatus = InvalidParameter: SetLinearColors = m_uLastStatus: Exit Function
    m_uLastStatus = GdipSetLineColors(m_clsBrush.NativeBrush, color1.GetValue(), color2.GetValue())
    SetLinearColors = m_uLastStatus
End Function

' sets the transformation matrix of this linear gradient brush.
Public Function SetTransform(ByVal matrix As cMatrix) As GpStatus
    If matrix Is Nothing Then m_uLastStatus = InvalidParameter: SetTransform = m_uLastStatus: Exit Function
    m_uLastStatus = GdipSetLineTransform(m_clsBrush.NativeBrush, matrix.NativeMatrix)
    SetTransform = m_uLastStatus
End Function

' sets the wrap mode of this linear gradient brush.
Public Function SetWrapMode(ByVal uWrap As WrapMode) As GpStatus
    m_uLastStatus = GdipSetLineWrapMode(m_clsBrush.NativeBrush, uWrap)
    SetWrapMode = m_uLastStatus
End Function

' updates this brush's current transformation matrix with the product of itself and a translation matrix.
Public Function TranslateTransform(ByVal dx As Single, _
                                   ByVal dy As Single, _
                                   Optional order As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipTranslateLineTransform(m_clsBrush.NativeBrush, dx, dy, order)
    TranslateTransform = m_uLastStatus
End Function

Private Sub Class_Initialize()
    Set m_clsBrush = New cBrush
End Sub

Private Sub Class_Terminate()
    Set m_clsBrush = Nothing
End Sub
