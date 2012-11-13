VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cBrush"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cBrush.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiPlusBrush.h:Microsoft Platform SDK February 2003
'
' A Brush object is used to paint the interior of graphics shapes, such as
' rectangles, ellipses, pies, polygons, and paths.
' ==================================================================================

Private m_lngBrush As Long
Private m_uLastStatus As GpStatus

' creates a new Brush object based on this brush.
Public Function Clone() As cBrush
    Dim clsClone        As cBrush
    Dim lngNew          As Long
    
    m_uLastStatus = GdipCloneBrush(m_lngBrush, lngNew)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cBrush
    clsClone.fInitialize lngNew
    Set Clone = clsClone
End Function

Public Sub DisposeBrush()
    If m_lngBrush <> 0 Then m_uLastStatus = GdipDeleteBrush(m_lngBrush): m_lngBrush = 0
End Sub

' returns a value that indicates the nature of this Brush object's most recent method failure.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' gets the type of this brush.
Public Function GetType() As BrushType
    Dim uType As BrushType
    
    m_uLastStatus = GdipGetBrushType(m_lngBrush, uType)
    GetType = uType
End Function

Public Property Get NativeBrush() As Long
    NativeBrush = m_lngBrush
End Property

Friend Sub fInitialize(ByVal lBrush As Long)
    Call DisposeBrush
    m_lngBrush = lBrush
End Sub

Private Sub Class_Initialize()
    Call DisposeBrush
End Sub

Private Sub Class_Terminate()
    Call DisposeBrush
End Sub
