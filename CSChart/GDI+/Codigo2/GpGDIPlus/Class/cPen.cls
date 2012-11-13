VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPen"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cPen.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiPlusPen.h:Microsoft Platform SDK February 2003
'
' A Pen object is a Microsoft® Windows® GDI+ object used to draw lines and curves.
' ==================================================================================

Private m_lngPen As Long
Private m_uLastStatus As GpStatus

' copies a Pen object.
Public Function Clone() As cPen
    Dim clsClone        As cPen
    Dim lngNew          As Long
    
    m_uLastStatus = GdipClonePen(m_lngPen, lngNew)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cPen
    clsClone.fInitialize lngNew
    Set Clone = clsClone
End Function

' Creates a Pen object that uses the attributes of a brush and a real number to set the width of this Pen object.
Public Function CreateFromBrush(ByVal lBrush As Long, Optional Width As Single = 1) As GpStatus
    Call DisposePen
    m_uLastStatus = GdipCreatePen2(lBrush, Width, UnitWorld, m_lngPen)
    CreateFromBrush = m_uLastStatus
End Function

' Creates a Pen object that uses a specified color and width.
Public Function CreateFromColor(ByVal color As cColor, Optional Width As Single = 1) As GpStatus
    Call DisposePen
    m_uLastStatus = GdipCreatePen1(color.GetValue(), Width, UnitWorld, m_lngPen)
    CreateFromColor = m_uLastStatus
End Function

Public Sub DisposePen()
    If m_lngPen <> 0 Then m_uLastStatus = GdipDeletePen(m_lngPen): m_lngPen = 0
End Sub

Friend Sub fInitialize(ByVal lPen As Long)
    Call DisposePen
    m_lngPen = lPen
End Sub

' gets the alignment currently set for this Pen object.
Public Function GetAlignment() As PenAlignment
    Dim uAlign As PenAlignment
    
    m_uLastStatus = GdipGetPenMode(m_lngPen, uAlign)
    GetAlignment = uAlign
End Function

' sets the alignment for this Pen object relative to the line.
Public Function SetAlignment(ByVal upenAlignment As PenAlignment)
    m_uLastStatus = GdipSetPenMode(m_lngPen, upenAlignment)
    SetAlignment = m_uLastStatus
End Function

' gets the Brush object that is currently set for this Pen object.
Public Function GetBrush() As cBrush
    Dim lBrush As Long
    Dim clsBrush As cBrush
    
    m_uLastStatus = GdipGetPenBrushFill(m_lngPen, lBrush)
    If m_uLastStatus <> Ok Then Set clsBrush = Nothing: Exit Function
    Set clsBrush = New cBrush
    clsBrush.fInitialize lBrush
    Set GetBrush = clsBrush
End Function

' sets the Brush object that a pen uses to fill a line.
Public Function SetBrush(ByVal Brush As cBrush) As GpStatus
    If Brush Is Nothing Then m_uLastStatus = InvalidParameter: SetBrush = m_uLastStatus: Exit Function
    m_uLastStatus = GdipSetPenBrushFill(m_lngPen, Brush.NativeBrush)
    SetBrush = m_uLastStatus
End Function

' gets the color currently set for this Pen object.
Public Function GetColor(ByRef color As cColor) As GpStatus
    Dim lArgb As Long
    Dim uType As PenType
    
    m_uLastStatus = GdipGetPenFillType(m_lngPen, uType)
    If m_uLastStatus <> Ok Then Exit Function
    If uType <> PenTypeSolidColor Then m_uLastStatus = WrongState: Exit Function
    m_uLastStatus = GdipGetPenColor(m_lngPen, lArgb)
    If m_uLastStatus = Ok Then
       If color Is Nothing Then Set color = New cColor
       color.SetValue lArgb
    End If
    GetColor = m_uLastStatus
End Function

' sets the color for this Pen object.
Public Function SetColor(ByVal color As cColor) As GpStatus
    If color Is Nothing Then m_uLastStatus = InvalidParameter: SetColor = m_uLastStatus: Exit Function
    m_uLastStatus = GdipSetPenColor(m_lngPen, color.GetValue())
    SetColor = m_uLastStatus
End Function

' gets the compound array currently set for this Pen object.
Public Function GetCompoundArray(ByRef compoundArray() As Single, ByVal lCount As Long) As GpStatus
    If lCount <= 0 Then m_uLastStatus = InvalidParameter: GetCompoundArray = m_uLastStatus: Exit Function
    ReDim compoundArray(0 To lCount - 1) As Single
    m_uLastStatus = GdipGetPenCompoundArray(m_lngPen, compoundArray(0), lCount)
    GetCompoundArray = m_uLastStatus
End Function

' gets the number of elements in a compound array.
Public Function GetCompoundArrayCount() As Long
    Dim lCount As Long
    
    m_uLastStatus = GdipGetPenCompoundCount(m_lngPen, lCount)
    GetCompoundArrayCount = lCount
End Function

' sets the compound array for this Pen object.
Public Function SetCompoundArray(ByRef compoundArray() As Single, ByVal lCount As Long) As GpStatus
    Dim lngL As Long
    
    lngL = LBound(compoundArray)
    m_uLastStatus = GdipSetPenCompoundArray(m_lngPen, compoundArray(lngL), lCount)
    SetCompoundArray = m_uLastStatus
End Function

' gets the custom end cap currently set for this Pen object
Public Function GetCustomEndCap(ByRef customCap As cCustomLineCap) As GpStatus
    Dim lCap As Long
    m_uLastStatus = GdipGetPenCustomEndCap(m_lngPen, lCap)
    If m_uLastStatus = Ok Then
       If customCap Is Nothing Then Set customCap = New cCustomLineCap
       customCap.fInitialize (lCap)
    End If
    GetCustomEndCap = m_uLastStatus
End Function

' sets the custom end cap for this Pen object.
Public Function SetCustomEndCap(ByVal customCap As cCustomLineCap) As GpStatus
    Dim lCap As Long
    
    If customCap Is Nothing Then lCap = 0& Else lCap = customCap.NativeCap
    m_uLastStatus = GdipSetPenCustomEndCap(m_lngPen, lCap)
    SetCustomEndCap = m_uLastStatus
End Function

' gets the custom start cap currently set for this Pen object.
Public Function GetCustomStartCap(ByRef customCap As cCustomLineCap) As GpStatus
    Dim lCap As Long
    m_uLastStatus = GdipGetPenCustomStartCap(m_lngPen, lCap)
    If m_uLastStatus = Ok Then
       If customCap Is Nothing Then Set customCap = New cCustomLineCap
       customCap.fInitialize (lCap)
    End If
    GetCustomStartCap = m_uLastStatus
End Function

' sets the custom end cap for this Pen object.
Public Function SetCustomStartCap(ByVal customCap As cCustomLineCap) As GpStatus
    Dim lCap As Long
    
    If customCap Is Nothing Then lCap = 0& Else lCap = customCap.NativeCap
    m_uLastStatus = GdipSetPenCustomStartCap(m_lngPen, lCap)
    SetCustomStartCap = m_uLastStatus
End Function

' gets the dash cap style currently set for this Pen object.
Public Function GetDashCap() As DashCap
    Dim uDashCap As DashCap
    m_uLastStatus = GdipGetPenDashCap(m_lngPen, uDashCap)
    GetDashCap = uDashCap
End Function

' sets the dash cap style for this Pen object.
Public Function SetDashCap(ByVal dcap As DashCap) As GpStatus
    m_uLastStatus = GdipSetPenDashCap(m_lngPen, dcap)
    SetDashCap = m_uLastStatus
End Function

' gets the distance from the start of the line to the start of the first space in a dashed line.
Public Function GetDashOffset() As Single
    Dim dashOffset As Single
    m_uLastStatus = GdipGetPenDashOffset(m_lngPen, dashOffset)
    GetDashOffset = dashOffset
End Function

' sets the distance from the start of the line to the start of the first dash in a dashed line.
Public Function SetDashOffset(ByVal dashOffset As Single) As GpStatus
    m_uLastStatus = GdipSetPenDashOffset(m_lngPen, dashOffset)
    SetDashOffset = m_uLastStatus
End Function

' gets an array of custom dashes and spaces currently set for this Pen object.
Public Function GetDashPattern(ByRef dashArray() As Single, ByVal lCount As Long) As GpStatus
    If lCount <= 0 Then
       m_uLastStatus = InvalidParameter
    Else
       ReDim dashArray(0 To lCount - 1)
       m_uLastStatus = GdipGetPenDashArray(m_lngPen, dashArray(0), lCount)
    End If
    GetDashPattern = m_uLastStatus
End Function

' gets the number of elements in a dash pattern array.
Public Function GetDashPatternCount() As Long
    Dim lCount As Long
    
    m_uLastStatus = GdipGetPenDashCount(m_lngPen, lCount)
    GetDashPatternCount = lCount
End Function

' sets an array of custom dashes and spaces for this Pen object.
Public Function SetDashPattern(ByRef dashArray() As Single, ByVal lCount As Long) As GpStatus
    m_uLastStatus = GdipSetPenDashArray(m_lngPen, dashArray(LBound(dashArray)), lCount)
    SetDashPattern = m_uLastStatus
End Function

' gets the dash style currently set for this Pen object.
Public Function GetDashStyle() As DashStyle
    Dim dStyle As DashStyle
    m_uLastStatus = GdipGetPenDashStyle(m_lngPen, dStyle)
    GetDashStyle = dStyle
End Function

' sets the dash style for this Pen object.
Public Function SetDashStyle(ByVal dStyle As DashStyle) As GpStatus
    m_uLastStatus = GdipSetPenDashStyle(m_lngPen, dStyle)
    SetDashStyle = m_uLastStatus
End Function

' gets the end cap currently set for this Pen object.
Public Function GetEndCap() As LineCap
    Dim endCap As LineCap
    m_uLastStatus = GdipGetPenEndCap(m_lngPen, endCap)
    GetEndCap = endCap
End Function

' sets the end cap for this Pen object.
Public Function SetEndCap(ByVal endCap As LineCap) As GpStatus
    m_uLastStatus = GdipSetPenEndCap(m_lngPen, endCap)
    SetEndCap = m_uLastStatus
End Function

' returns a value that indicates the nature of this Pen object's most recent method failure.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' gets the line join style currently set for this Pen object.
Public Function GetLineJoin() As LineJoin
    Dim uLineJoin As LineJoin
    m_uLastStatus = GdipGetPenLineJoin(m_lngPen, uLineJoin)
    GetLineJoin = uLineJoin
End Function

' sets the line join for this Pen object.
Public Function SetLineJoin(ByVal lnJoin As LineJoin) As GpStatus
    m_uLastStatus = GdipSetPenLineJoin(m_lngPen, lnJoin)
    SetLineJoin = m_uLastStatus
End Function

' gets the miter length currently set for this Pen object.
Public Function GetMiterLimit() As Single
    Dim miterLimit As Single
    m_uLastStatus = GdipGetPenMiterLimit(m_lngPen, miterLimit)
    GetMiterLimit = miterLimit
End Function

' sets the miter limit of this Pen object.
Public Function SetMiterLimit(ByVal miterLimit As Single) As GpStatus
    m_uLastStatus = GdipSetPenMiterLimit(m_lngPen, miterLimit)
    SetMiterLimit = m_uLastStatus
End Function

' gets the type currently set for this Pen object.
Public Function GetPenType() As PenType
    Dim uType As PenType
    
    m_uLastStatus = GdipGetPenFillType(m_lngPen, uType)
    GetPenType = uType
End Function

' gets the start cap currently set for this Pen object.
Public Function GetStartCap() As LineCap
    Dim startCap As LineCap
    m_uLastStatus = GdipGetPenStartCap(m_lngPen, startCap)
    GetStartCap = startCap
End Function

' sets the start cap for this Pen object.
Public Function SetStartCap(ByVal startCap As LineCap) As GpStatus
    m_uLastStatus = GdipSetPenStartCap(m_lngPen, startCap)
    SetStartCap = m_uLastStatus
End Function

' gets the world transformation matrix currently set for this Pen object.
Public Function GetTransform(ByRef matrix As cMatrix) As GpStatus
    Dim lMatrix As Long
    m_uLastStatus = GdipGetPenTransform(m_lngPen, lMatrix)
    If m_uLastStatus = Ok Then
       If matrix Is Nothing Then Set matrix = New cMatrix
       matrix.fInitialize (lMatrix)
    End If
    GetTransform = m_uLastStatus
End Function

' sets the world transformation of this Pen object.
Public Function SetTransform(ByVal matrix As cMatrix) As GpStatus
    If matrix Is Nothing Then
       m_uLastStatus = InvalidParameter
    Else
       m_uLastStatus = GdipSetPenTransform(m_lngPen, matrix.NativeMatrix)
    End If
    SetTransform = m_uLastStatus
End Function

' gets the width currently set for this Pen object.
Public Function GetWidth() As Single
    Dim sWidth As Single
    m_uLastStatus = GdipGetPenWidth(m_lngPen, sWidth)
    GetWidth = sWidth
End Function

' sets the width for this Pen object.
Public Function SetWidth(ByVal Width As Single) As GpStatus
    m_uLastStatus = GdipSetPenWidth(m_lngPen, Width)
    SetWidth = m_uLastStatus
End Function

' updates the world transformation matrix of this Pen object with the product of itself and another matrix.
Public Function MultiplyTransform(ByVal matrix As cMatrix, _
                                  Optional uOrder As MatrixOrder = MatrixOrderPrepend) As GpStatus
    If matrix Is Nothing Then
       m_uLastStatus = InvalidParameter
    Else
       m_uLastStatus = GdipMultiplyPenTransform(m_lngPen, matrix.NativeMatrix, uOrder)
    End If
    MultiplyTransform = m_uLastStatus
End Function

Public Property Get NativePen() As Long
    NativePen = m_lngPen
End Property

' sets the world transformation matrix of this Pen object to the identity matrix.
Public Function ResetTransform() As GpStatus
    m_uLastStatus = GdipResetPenTransform(m_lngPen)
    ResetTransform = m_uLastStatus
End Function

' updates the world transformation matrix of this Pen object with the product of itself and a rotation matrix.
Public Function RotateTransform(ByVal angle As Single, _
                                Optional uOrder As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipRotatePenTransform(m_lngPen, angle, uOrder)
    RotateTransform = m_uLastStatus
End Function

' sets the Pen object's world transformation matrix equal to the product of itself and a scaling matrix.
Public Function ScaleTransform(ByVal sx As Single, _
                               ByVal sy As Single, _
                               Optional uOrder As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipScalePenTransform(m_lngPen, sx, sy, uOrder)
    ScaleTransform = m_uLastStatus
End Function

Private Sub Class_Initialize()
    Call DisposePen
End Sub

Private Sub Class_Terminate()
    Call DisposePen
End Sub
