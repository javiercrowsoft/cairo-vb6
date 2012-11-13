VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSize"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cSize.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusTypes.h:Microsoft Platform SDK February 2003
'
' The Size class encapsulates a Width and Height dimension in a 2-D coordinate system.
' ==================================================================================

Private m_lngWidth As Long
Private m_lngHeight As Long

Public Function Add(ByVal size As cSize) As cSize
    Dim clsTmp As New cSize
    
    clsTmp.Create m_lngWidth + size.Width, m_lngHeight + size.Height
    Set Add = clsTmp
End Function

Public Sub Create(ByVal Width As Long, ByVal Height As Long)
    m_lngWidth = Width: m_lngHeight = Height
End Sub

Public Sub CreateFromSize(ByVal size As cSize)
    With size
         m_lngWidth = .Width
         m_lngHeight = .Height
    End With
End Sub

Public Sub CreateFromType(ByRef size As SIZEL)
    m_lngWidth = size.cx
    m_lngHeight = size.cy
End Sub

Public Function Equals(ByVal size As cSize) As Boolean
    With size
         Equals = (m_lngWidth = .Width) And (m_lngHeight = .Height)
    End With
End Function

Public Property Get Height() As Long
    Height = m_lngHeight
End Property

Public Property Let Height(ByVal NewValue As Long)
    m_lngHeight = NewValue
End Property

Public Function IsEmpty() As Boolean
    IsEmpty = (m_lngWidth = 0) And (m_lngHeight = 0)
End Function

Public Function Subtract(ByVal size As cSize) As cSize
    Dim clsTmp As New cSize
    
    clsTmp.Create m_lngWidth - size.Width, m_lngHeight - size.Height
    Set Subtract = clsTmp
End Function

Public Function ToType() As SIZEL
    ToType.cx = m_lngWidth
    ToType.cy = m_lngHeight
End Function

Public Property Get Width() As Long
    Width = m_lngWidth
End Property

Public Property Let Width(ByVal NewValue As Long)
    m_lngWidth = NewValue
End Property

Private Sub Class_Initialize()
    m_lngWidth = 0: m_lngHeight = 0
End Sub
