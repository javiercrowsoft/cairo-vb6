VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGraphicsPathIterator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cGraphicsPathIterator.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusPath.h:Microsoft Platform SDK February 2003
'
' This GraphicsPathIterator class provides methods for isolating selected subsets of
' the path stored in a GraphicsPath object. A path consists of one or more figures.
' You can use a GraphicsPathIterator to isolate one or more of those figures.
' A path can also have markers that divide the path into sections. You can use a
' GraphicsPathIterator object to isolate one or more of those sections.
' ==================================================================================

Private m_lngIterator As Long
Private m_uLastStatus As GpStatus

Public Sub DisposePathIterator()
    If m_lngIterator <> 0 Then m_uLastStatus = GdipDeletePathIter(m_lngIterator): m_lngIterator = 0
End Sub

' returns a value that indicates whether this CachedBitmap object was constructed successfully.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

Private Sub Class_Initialize()
    Call DisposePathIterator
End Sub

Private Sub Class_Terminate()
    Call DisposePathIterator
End Sub
