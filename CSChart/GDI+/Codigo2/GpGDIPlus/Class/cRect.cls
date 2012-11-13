VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cRect.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusTypes.h:Microsoft Platform SDK February 2003
'
' A Rect object stores the upper-left corner, width, and height of a rectangle.
' ==================================================================================

Private m_lngLeft As Long
Private m_lngTop As Long
Private m_lngWidth As Long
Private m_lngHeight As Long

Public Property Get Bottom() As Long
    Bottom = m_lngTop + m_lngHeight
End Property

' creates a new Rect object and initializes it with the contents of this Rect object.
Public Function Clone() As cRect
    Dim clsTmp As New cRect
    
    clsTmp.Create m_lngLeft, m_lngTop, m_lngWidth, m_lngHeight
    Set Clone = clsTmp
End Function

' determines whether the point ( x, y) is inside this rectangle.
Public Function Contains(ByVal x As Long, ByVal y As Long) As Boolean
    Contains = (x >= m_lngLeft) And _
               (x <= m_lngLeft + m_lngWidth) And _
               (y >= m_lngTop) And _
               (y <= m_lngTop + m_lngHeight)
End Function

' determines whether a point is inside this rectangle.
Public Function ContainsPoint(ByVal pt As cPoint) As Boolean
    ContainsPoint = Contains(pt.x, pt.y)
End Function

' determines whether another rectangle is inside this rectangle.
Public Function ContainsRect(ByVal rect As cRect) As Boolean
    ContainsRect = (m_lngLeft <= rect.Left) And (rect.Right <= Me.Right) & _
                   (m_lngTop <= rect.Top) And (rect.Bottom <= Me.Bottom)
End Function

Public Sub Create(ByVal Left As Long, ByVal Top As Long, ByVal Width As Long, ByVal Height As Long)
    m_lngLeft = Left
    m_lngTop = Top
    m_lngWidth = Width
    m_lngHeight = Height
End Sub

Public Sub CreateFromPointSize(ByVal point As cPoint, ByVal size As cSize)
    m_lngLeft = point.x
    m_lngTop = point.y
    m_lngWidth = size.Width
    m_lngHeight = size.Height
End Sub

Public Sub CreateFromType(ByRef uR As RECTL)
    With uR
         m_lngLeft = .Left
         m_lngTop = .Top
         m_lngWidth = .Right - .Left
         m_lngHeight = .Bottom - .Top
    End With
End Sub

' determines whether two rectangles are the same.
Public Function Equals(ByVal rect As cRect) As Boolean
    With rect
         Equals = (m_lngLeft = .Left) And (m_lngTop = .Top) And _
                  (m_lngWidth = .Width) And (m_lngHeight = .Height)
    End With
End Function

' makes a copy of this rectangle.
Public Sub GetBounds(ByRef rect As cRect)
    rect.Create m_lngLeft, m_lngTop, m_lngWidth, m_lngHeight
End Sub

' gets the coordinates of the upper-left corner of the rectangle.
Public Sub GetLocation(ByRef pt As cPoint)
    pt.Create m_lngLeft, m_lngTop
End Sub

' gets the width and height of the rectangle.
Public Sub GetSize(ByRef size As cSize)
    size.Create m_lngWidth, m_lngHeight
End Sub

Public Property Get Height() As Long
    Height = m_lngHeight
End Property

Public Property Let Height(ByVal NewValue As Long)
    m_lngHeight = NewValue
End Property

' expands the rectangle by dx on the left and right edges,
' and by dy on the top and bottom edges.
Public Sub Inflate(ByVal dx As Long, ByVal dy As Long)
    m_lngLeft = m_lngLeft - dx
    m_lngTop = m_lngTop - dy
    m_lngWidth = m_lngWidth + dx * 2
    m_lngHeight = m_lngHeight + dy * 2
End Sub

Public Sub InflatePoint(ByVal pt As cPoint)
    Call Inflate(pt.x, pt.y)
End Sub

' replaces this rectangle with the intersection of itself and another rectangle.
Public Function Intersect(ByVal rect As cRect) As Boolean
    Intersect = Intersect3(Me, Me, rect)
End Function

' determines the intersection of two rectangles and stores the result in a Rect object.
Public Function Intersect3(ByRef c As cRect, ByVal a As cRect, ByVal b As cRect) As Boolean
    Dim lLeft As Long, lTop As Long, lRight As Long, lBottom As Long
    
    lRight = Min(a.Right, b.Right)
    lBottom = Min(a.Bottom, b.Bottom)
    lLeft = Max(a.Left, b.Left)
    lTop = Max(a.Top, b.Top)
    c.Create lLeft, lTop, lRight - lLeft, lBottom - lTop
    Intersect3 = Not c.IsEmptyArea
End Function

' determines whether this rectangle intersects another rectangle.
Public Function IntersectsWith(ByVal rect As cRect) As Boolean
    IntersectsWith = (m_lngLeft < rect.Right) And _
                     (m_lngTop < rect.Bottom) And _
                     (Me.Right > rect.Left) And _
                     (Me.Bottom > rect.Top)
End Function

' determines whether this rectangle is empty.
Public Function IsEmptyArea() As Boolean
    IsEmptyArea = (m_lngWidth <= 0) Or (m_lngHeight <= 0)
End Function

Public Property Get Left() As Long
    Left = m_lngLeft
End Property

Public Property Let Left(ByVal NewValue As Long)
    m_lngLeft = NewValue
End Property

Private Function Max(ByVal a As Long, ByVal b As Long) As Long
    If a >= b Then
       Max = a
    Else
       Max = b
    End If
End Function

Private Function Min(ByVal a As Long, ByVal b As Long) As Long
    If a <= b Then
       Min = a
    Else
       Min = b
    End If
End Function

' moves the rectangle by dx horizontally and by dy vertically.
Public Sub Offset(ByVal dx As Long, ByVal dy As Long)
    m_lngLeft = m_lngLeft + dx
    m_lngTop = m_lngTop + dy
End Sub

' moves this rectangle horizontally a distance of point.X and vertically a distance of point.Y.
Public Sub OffsetPoint(pt As cPoint)
    Call Offset(pt.x, pt.y)
End Sub

Public Property Get Right() As Long
    Right = m_lngLeft + m_lngWidth
End Property

Public Property Get Top() As Long
    Top = m_lngTop
End Property

Public Property Let Top(ByVal NewValue As Long)
    m_lngTop = NewValue
End Property

Public Function ToType() As RECTL
    With ToType
         .Left = m_lngLeft
         .Top = m_lngTop
         .Right = Me.Right
         .Bottom = Me.Bottom
    End With
End Function

' determines the union of two rectangles and stores the result in a Rect object.
Public Function Union(ByRef c As cRect, ByVal a As cRect, ByVal b As cRect) As Boolean
    Dim lLeft As Long, lTop As Long, lRight As Long, lBottom As Long
    
    lRight = Max(a.Right, b.Right)
    lBottom = Max(a.Bottom, b.Bottom)
    lLeft = Min(a.Left, b.Left)
    lTop = Min(a.Top, b.Top)
    c.Create lLeft, lTop, lRight - lLeft, lBottom - lTop
    Union = Not c.IsEmptyArea
End Function

Public Property Get Width() As Long
    Width = m_lngWidth
End Property

Public Property Let Width(ByVal NewValue As Long)
    m_lngWidth = NewValue
End Property

Private Sub Class_Initialize()
    m_lngLeft = 0: m_lngTop = 0: m_lngWidth = 0: m_lngHeight = 0
End Sub
