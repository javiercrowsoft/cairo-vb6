VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPoint"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cPoint.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusTypes.h:Microsoft Platform SDK February 2003
'
' The Point class encapsulates a point in a 2-D coordinate system.
' ==================================================================================

Private m_lngX As Long
Private m_lngY As Long

' adds the X and Y data members of two Point objects.
Public Function Add(ByVal point As cPoint) As cPoint
    Dim clsTmp As New cPoint
    clsTmp.Create m_lngX + point.x, m_lngY + point.y
    Set Add = clsTmp
End Function

' using two longs to initialize the X and Y data members.
Public Sub Create(ByVal x As Long, ByVal y As Long)
    m_lngX = x: m_lngY = y
End Sub

' Creates a new Point object and copies the data members from another Point object.
Public Sub CreateFromPoint(ByVal point As cPoint)
    With point
         m_lngX = .x
         m_lngY = .y
    End With
End Sub

' Creates a Point object using a Size object to initialize the X and Y data members.
Public Sub CreateFromSize(ByVal size As cSize)
    With size
         m_lngX = .Width
         m_lngY = .Height
    End With
End Sub

Public Sub CreateFromType(ByRef pt As POINTL)
    m_lngX = pt.x
    m_lngY = pt.y
End Sub

' determines whether two Point objects are equal.
' Two points are considered equal if they have the same X and Y data members.
Public Function Equals(ByVal point As cPoint) As Boolean
    With point
         Equals = (m_lngX = .x) And (m_lngY = .y)
    End With
End Function

' subtracts the X and Y data members of two Point objects.
Public Function Subtract(ByVal point As cPoint) As cPoint
    Dim clsTmp As New cPoint
    clsTmp.Create m_lngX - point.x, m_lngY - point.y
    Set Subtract = clsTmp
End Function

Public Function ToType() As POINTL
    ToType.x = m_lngX
    ToType.y = m_lngY
End Function

Public Property Get x() As Long
    x = m_lngX
End Property

Public Property Let x(ByVal NewValue As Long)
    m_lngX = NewValue
End Property

Public Property Get y() As Long
    y = m_lngY
End Property

Public Property Let y(ByVal NewValue As Long)
    m_lngY = NewValue
End Property

Private Sub Class_Initialize()
    m_lngX = 0: m_lngY = 0
End Sub
