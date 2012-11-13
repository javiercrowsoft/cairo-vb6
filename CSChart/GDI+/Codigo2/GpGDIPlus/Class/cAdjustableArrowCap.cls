VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cAdjustableArrowCap"
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
' This class builds a line cap that looks like an arrow.
' ==================================================================================

Private m_uLastStatus As GpStatus
Private m_clsLineCap As cCustomLineCap

' Creates an adjustable arrow line cap with the specified height and width.
' The arrow line cap can be filled or nonfilled. The middle inset defaults to zero.
Public Function Create(ByVal Height As Single, _
                       ByVal Width As Single, _
                       Optional ByVal isFilled As Boolean = True) As GpStatus
    m_uLastStatus = GdipCreateAdjustableArrowCap(Height, Width, isFilled, m_clsLineCap.NativeCap)
    Create = m_uLastStatus
End Function

Public Property Get CustomLineCap() As cCustomLineCap
    Set CustomLineCap = m_clsLineCap
End Property

Public Sub DisposeAdjustableArrowCap()
    m_clsLineCap.DisposeCustomLineCap
    m_uLastStatus = m_clsLineCap.GetLastStatus
End Sub

' gets the height of the arrow cap. The height is the distance from the base of the arrow to its vertex.
Public Function GetHeight() As Single
    Dim sHeight As Single
    
    m_uLastStatus = GdipGetAdjustableArrowCapHeight(m_clsLineCap.NativeCap, sHeight)
    GetHeight = sHeight
End Function

' gets the value of the inset. The middle inset is the number of units that the midpoint of the base shifts towards the vertex.
Public Function GetMiddleInset() As Single
    Dim sInset As Single
    
    m_uLastStatus = GdipGetAdjustableArrowCapMiddleInset(m_clsLineCap.NativeCap, sInset)
    GetMiddleInset = sInset
End Function

' gets the width of the arrow cap. The width is the distance between the endpoints of the base of the arrow.
Public Function GetWidth() As Single
    Dim sWidth As Single
    
    m_uLastStatus = GdipGetAdjustableArrowCapWidth(m_clsLineCap.NativeCap, sWidth)
    GetWidth = sWidth
End Function

' determines whether the arrow cap is filled
Public Function isFilled() As Boolean
    Dim lngFilled As Long
    
    m_uLastStatus = GdipGetAdjustableArrowCapFillState(m_clsLineCap.NativeCap, lngFilled)
    isFilled = lngFilled
End Function

Public Property Get NativeCap() As Long
    NativeCap = m_clsLineCap.NativeCap
End Property

' sets the fill state of the arrow cap. If the arrow cap is not filled, only the outline is drawn.
Public Function SetFillState(ByVal isFilled As Boolean) As GpStatus
    m_uLastStatus = GdipSetAdjustableArrowCapFillState(m_clsLineCap.NativeCap, isFilled)
    SetFillState = m_uLastStatus
End Function

' sets the height of the arrow cap. This is the distance from the base of the arrow to its vertex.
Public Function SetHeight(ByVal Height As Single) As GpStatus
    m_uLastStatus = GdipSetAdjustableArrowCapHeight(m_clsLineCap.NativeCap, Height)
    SetHeight = m_uLastStatus
End Function

' sets the number of units that the midpoint of the base shifts towards the vertex.
Public Function SetMiddleInset(ByVal middleInset As Single) As GpStatus
    m_uLastStatus = GdipSetAdjustableArrowCapMiddleInset(m_clsLineCap.NativeCap, middleInset)
    SetMiddleInset = m_uLastStatus
End Function

' sets the width of the arrow cap. The width is the distance between the endpoints of the base of the arrow
Public Function SetWidth(ByVal Width As Single) As GpStatus
    m_uLastStatus = GdipSetAdjustableArrowCapWidth(m_clsLineCap.NativeCap, Width)
    SetWidth = m_uLastStatus
End Function

Private Sub Class_Initialize()
    Set m_clsLineCap = New cCustomLineCap
End Sub

Private Sub Class_Terminate()
    Set m_clsLineCap = Nothing
End Sub
