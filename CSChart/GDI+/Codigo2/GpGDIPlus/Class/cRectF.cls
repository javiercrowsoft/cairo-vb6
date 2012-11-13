VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRectF"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cRectF.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusTypes.h:Microsoft Platform SDK February 2003
'
' A RectF object stores the upper-left corner, width, and height of a rectangle.
' ==================================================================================
Private Const REAL_EPSILON = 1.192092896E-07
Private m_sngLeft As Single
Private m_sngTop As Single
Private m_sngWidth As Single
Private m_sngHeight As Single

Public Property Get Bottom() As Single
    Bottom = m_sngTop + m_sngHeight
End Property

' creates a new Rect object and initializes it with the contents of this Rect object.
Public Function Clone() As cRectF
    Dim clsTmp As New cRectF
    
    clsTmp.Create m_sngLeft, m_sngTop, m_sngWidth, m_sngHeight
    Set Clone = clsTmp
End Function

' determines whether the point ( x, y) is inside this rectangle.
Public Function Contains(ByVal x As Single, ByVal y As Single) As Boolean
    Contains = (x >= m_sngLeft) And _
               (x <= m_sngLeft + m_sngWidth) And _
               (y >= m_sngTop) And _
               (y <= m_sngTop + m_sngHeight)
End Function

' determines whether a point is inside this rectangle.
Public Function ContainsPoint(ByVal pt As cPointF) As Boolean
    ContainsPoint = Contains(pt.x, pt.y)
End Function

' determines whether another rectangle is inside this rectangle.
Public Function ContainsRect(ByVal rect As cRectF) As Boolean
    ContainsRect = (m_sngLeft <= rect.Left) And (rect.Right <= Me.Right) & _
                   (m_sngTop <= rect.Top) And (rect.Bottom <= Me.Bottom)
End Function

Public Sub Create(ByVal Left As Single, ByVal Top As Single, ByVal Width As Single, ByVal Height As Single)
    m_sngLeft = Left
    m_sngTop = Top
    m_sngWidth = Width
    m_sngHeight = Height
End Sub

Public Sub CreateFromPointSize(ByVal point As cPointF, ByVal size As cSizeF)
    m_sngLeft = point.x
    m_sngTop = point.y
    m_sngWidth = size.Width
    m_sngHeight = size.Height
End Sub

Public Sub CreateFromType(ByRef uR As RECTF)
    With uR
         m_sngLeft = .Left
         m_sngTop = .Top
         m_sngWidth = .Right - .Left
         m_sngHeight = .Bottom - .Top
    End With
End Sub

' determines whether two rectangles are the same.
Public Function Equals(ByVal rect As cRectF) As Boolean
    With rect
         Equals = (m_sngLeft = .Left) And (m_sngTop = .Top) And _
                  (m_sngWidth = .Width) And (m_sngHeight = .Height)
    End With
End Function

' makes a copy of this rectangle.
Public Sub GetBounds(ByRef rect As cRectF)
    rect.Create m_sngLeft, m_sngTop, m_sngWidth, m_sngHeight
End Sub

' gets the coordinates of the upper-left corner of the rectangle.
Public Sub GetLocation(ByRef pt As cPointF)
    pt.Create m_sngLeft, m_sngTop
End Sub

' gets the width and height of the rectangle.
Public Sub GetSize(ByRef size As cSize)
    size.Create m_sngWidth, m_sngHeight
End Sub

Public Property Get Height() As Single
    Height = m_sngHeight
End Property

Public Property Let Height(ByVal NewValue As Single)
    m_sngHeight = NewValue
End Property

' expands the rectangle by dx on the left and right edges,
' and by dy on the top and bottom edges.
Public Sub Inflate(ByVal dx As Single, ByVal dy As Single)
    m_sngLeft = m_sngLeft - dx
    m_sngTop = m_sngTop - dy
    m_sngWidth = m_sngWidth + dx * 2
    m_sngHeight = m_sngHeight + dy * 2
End Sub

Public Sub InflatePoint(ByVal pt As cPointF)
    Call Inflate(pt.x, pt.y)
End Sub

' replaces this rectangle with the intersection of itself and another rectangle.
Public Function Intersect(ByVal rect As cRectF) As Boolean
    Intersect = Intersect3(Me, Me, rect)
End Function

' determines the intersection of two rectangles and stores the result in a Rect object.
Public Function Intersect3(ByRef c As cRectF, ByVal a As cRectF, ByVal b As cRectF) As Boolean
    Dim lLeft As Single, lTop As Single, lRight As Single, lBottom As Single
    
    lRight = Min(a.Right, b.Right)
    lBottom = Min(a.Bottom, b.Bottom)
    lLeft = Max(a.Left, b.Left)
    lTop = Max(a.Top, b.Top)
    c.Create lLeft, lTop, lRight - lLeft, lBottom - lTop
    Intersect3 = Not c.IsEmptyArea
End Function

' determines whether this rectangle intersects another rectangle.
Public Function IntersectsWith(ByVal rect As cRectF) As Boolean
    IntersectsWith = (m_sngLeft < rect.Right) And _
                     (m_sngTop < rect.Bottom) And _
                     (Me.Right > rect.Left) And _
                     (Me.Bottom > rect.Top)
End Function

' determines whether this rectangle is empty.
Public Function IsEmptyArea() As Boolean
    IsEmptyArea = (m_sngWidth <= REAL_EPSILON) Or (m_sngHeight <= REAL_EPSILON)
End Function

Public Property Get Left() As Single
    Left = m_sngLeft
End Property

Public Property Let Left(ByVal NewValue As Single)
    m_sngLeft = NewValue
End Property

Private Function Max(ByVal a As Single, ByVal b As Single) As Single
    If a >= b Then
       Max = a
    Else
       Max = b
    End If
End Function

Private Function Min(ByVal a As Single, ByVal b As Single) As Single
    If a <= b Then
       Min = a
    Else
       Min = b
    End If
End Function

' moves the rectangle by dx horizontally and by dy vertically.
Public Sub Offset(ByVal dx As Single, ByVal dy As Single)
    m_sngLeft = m_sngLeft + dx
    m_sngTop = m_sngTop + dy
End Sub

' moves this rectangle horizontally a distance of point.X and vertically a distance of point.Y.
Public Sub OffsetPoint(ByVal pt As cPointF)
    Call Offset(pt.x, pt.y)
End Sub

Public Property Get Right() As Single
    Right = m_sngLeft + m_sngWidth
End Property

Public Property Get Top() As Single
    Top = m_sngTop
End Property

Public Property Let Top(ByVal NewValue As Single)
    m_sngTop = NewValue
End Property

Public Function ToType() As RECTF
    With ToType
         .Left = m_sngLeft
         .Top = m_sngTop
         .Right = Me.Right
         .Bottom = Me.Bottom
    End With
End Function

' determines the union of two rectangles and stores the result in a Rect object.
Public Function Union(ByRef c As cRectF, ByVal a As cRectF, ByVal b As cRectF) As Boolean
    Dim lLeft As Single, lTop As Single, lRight As Single, lBottom As Single
    
    lRight = Max(a.Right, b.Right)
    lBottom = Max(a.Bottom, b.Bottom)
    lLeft = Min(a.Left, b.Left)
    lTop = Min(a.Top, b.Top)
    c.Create lLeft, lTop, lRight - lLeft, lBottom - lTop
    Union = Not c.IsEmptyArea
End Function

Public Property Get Width() As Single
    Width = m_sngWidth
End Property

Public Property Let Width(ByVal NewValue As Single)
    m_sngWidth = NewValue
End Property

Private Sub Class_Initialize()
    m_sngLeft = 0#: m_sngTop = 0#: m_sngWidth = 0#: m_sngHeight = 0#
End Sub


