VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCustomLineCap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cCustomLineCap.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiPlusLineCaps.h:Microsoft Platform SDK February 2003
'
' The CustomLineCap class encapsulates a custom line cap. A line cap defines the
' style of graphic used to draw the ends of a line. It can be various shapes, such
' as a square, circle, or diamond. A custom line cap is defined by the path that
' draws it. The path is drawn by using a Pen object to draw the outline of a shape
' or by using a Brush object to fill the interior. The cap can be used on either or
' both ends of the line. Spacing can be adjusted between the end caps and the line.
' ==================================================================================

Private m_lngCap As Long
Private m_uLastStatus As GpStatus

' copies the contents of the existing object into a new CustomLineCap object.
Public Function Clone() As cCustomLineCap
    Dim lngCap        As Long
    Dim clsClone        As cCustomLineCap
    
    m_uLastStatus = GdipCloneCustomLineCap(m_lngCap, lngCap)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cCustomLineCap
    clsClone.fInitialize (lngCap)
    Set Clone = clsClone
End Function

Public Function CreateFill(ByVal fillPath As cGraphicsPath, _
                           Optional ByVal baseCap As LineCap = LineCapFlat, _
                           Optional ByVal baseInset As Single = 0) As GpStatus
    Call DisposeCustomLineCap
    m_uLastStatus = GdipCreateCustomLineCap(fillPath.NativePath, ByVal 0&, _
                                            baseCap, baseInset, m_lngCap)
    CreateFill = m_uLastStatus
End Function

Public Function CreateStroke(ByVal strokePath As cGraphicsPath, _
                             Optional ByVal baseCap As LineCap = LineCapFlat, _
                             Optional ByVal baseInset As Single = 0) As GpStatus
    Call DisposeCustomLineCap
    m_uLastStatus = GdipCreateCustomLineCap(ByVal 0&, strokePath.NativePath, _
                                            baseCap, baseInset, m_lngCap)
    CreateStroke = m_uLastStatus
End Function

Public Sub DisposeCustomLineCap()
    If m_lngCap <> 0 Then m_uLastStatus = GdipDeleteCustomLineCap(m_lngCap): m_lngCap = 0
End Sub

Friend Sub fInitialize(ByVal lCap As Long)
    Call DisposeCustomLineCap
    m_lngCap = lCap
End Sub

' gets the style of the base cap. The base cap is a LineCap object used as a cap at
' the end of a line along with this CustomLineCap object.
Public Function GetBaseCap() As LineCap
    Dim uLine As LineCap
    
    m_uLastStatus = GdipGetCustomLineCapBaseCap(m_lngCap, uLine)
    GetBaseCap = uLine
End Function

' gets the distance between the base cap to the start of the line.
Public Function GetBaseInset() As Single
    Dim sInset As Single
    
    m_uLastStatus = GdipGetCustomLineCapBaseInset(m_lngCap, sInset)
    GetBaseInset = sInset
End Function

' returns a value that indicates the nature of this CustomLineCap object's most recent method failure.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' gets the end cap styles for both the start line cap and the end line cap. Line caps
' are LineCap objects that end the individual lines within a path
Public Function GetStrokeCaps(ByRef startCap As LineCap, ByRef endCap As LineCap) As GpStatus
    m_uLastStatus = GdipGetCustomLineCapStrokeCaps(m_lngCap, startCap, endCap)
    GetStrokeCaps = m_uLastStatus
End Function

' returns the style of LineJoin used to join multiple lines in the same GraphicsPath object.
Public Function GetStrokeJoin() As LineJoin
    Dim uLine As LineJoin
    
    m_uLastStatus = GdipGetCustomLineCapStrokeJoin(m_lngCap, uLine)
    GetStrokeJoin = uLine
End Function

' gets the value of the scale width. This is the amount to scale the custom line cap
' relative to the width of the Pen object used to draw a line.
' The default value of 1.0 does not scale the line cap.
Public Function GetWidthScale() As Single
    Dim sWidthScale As Single
    
    m_uLastStatus = GdipGetCustomLineCapWidthScale(m_lngCap, sWidthScale)
    GetWidthScale = sWidthScale
End Function

Public Property Get NativeCap() As Long
    NativeCap = m_lngCap
End Property

' sets the LineCap that appears as part of this CustomLineCap at the end of a line.
Public Function SetBaseCap(ByVal baseCap As LineCap) As GpStatus
    m_uLastStatus = GdipSetCustomLineCapBaseCap(m_lngCap, baseCap)
    SetBaseCap = m_uLastStatus
End Function

' sets the base inset value of this custom line cap.
' This is the distance between the end of a line and the base cap.
Public Function SetBaseInset(ByVal inset As Single) As GpStatus
    m_uLastStatus = GdipSetCustomLineCapBaseInset(m_lngCap, inset)
    SetBaseInset = m_uLastStatus
End Function

' sets the LineCap objects used to start and end lines within the GraphicsPath
' object that defines this CustomLineCap object.
Public Function SetStrokeCaps(ByVal startCap As LineCap, ByVal endCap As LineCap) As GpStatus
    m_uLastStatus = GdipSetCustomLineCapStrokeCaps(m_lngCap, startCap, endCap)
    SetStrokeCaps = m_uLastStatus
End Function

' sets the style of line join for the stroke. The line join specifies how two lines
' that intersect within the GraphicsPath object that makes up the custom line cap are joined
Public Function SetStrokeJoin(ByVal uLineJoin As LineJoin) As GpStatus
    m_uLastStatus = GdipSetCustomLineCapStrokeJoin(m_lngCap, uLineJoin)
    SetStrokeJoin = m_uLastStatus
End Function

' sets the value of the scale width. This is the amount to scale the custom line cap relative
' to the width of the Pen used to draw lines.
' The default value of 1.0 does not scale the line cap.
Public Function SetWidthScale(ByVal widthScale As Single) As GpStatus
    m_uLastStatus = GdipSetCustomLineCapWidthScale(m_lngCap, widthScale)
    SetWidthScale = m_uLastStatus
End Function

Private Sub Class_Initialize()
    Call DisposeCustomLineCap
End Sub

Private Sub Class_Terminate()
    Call DisposeCustomLineCap
End Sub
