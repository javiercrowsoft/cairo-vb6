VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSizeF"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cSizeF.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusTypes.h:Microsoft Platform SDK February 2003
'
' The SizeF class encapsulates a Width and Height dimension in a 2-D coordinate system.
' ==================================================================================

Private m_sngWidth As Single
Private m_sngHeight As Single

Public Function Add(ByVal size As cSizeF) As cSizeF
    Dim clsTmp As New cSizeF
    
    clsTmp.Create m_sngWidth + size.Width, m_sngHeight + size.Height
    Set Add = clsTmp
End Function

Public Sub Create(ByVal Width As Single, ByVal Height As Single)
    m_sngWidth = Width: m_sngHeight = Height
End Sub

Public Sub CreateFromSize(ByVal size As cSizeF)
    With size
         m_sngWidth = .Width
         m_sngHeight = .Height
    End With
End Sub

Public Sub CreateFromType(ByRef size As SIZEF)
    m_sngWidth = size.cx
    m_sngHeight = size.cy
End Sub

Public Function Equals(ByVal size As cSizeF) As Boolean
    With size
         Equals = (m_sngWidth = .Width) And (m_sngHeight = .Height)
    End With
End Function

Public Property Get Height() As Single
    Height = m_sngHeight
End Property

Public Property Let Height(ByVal NewValue As Single)
    m_sngHeight = NewValue
End Property

Public Function IsEmpty() As Boolean
    IsEmpty = (m_sngWidth = 0#) And (m_sngHeight = 0#)
End Function

Public Function Subtract(ByVal size As cSizeF) As cSizeF
    Dim clsTmp As New cSizeF
    
    clsTmp.Create m_sngWidth - size.Width, m_sngHeight - size.Height
    Set Subtract = clsTmp
End Function

Public Function ToType() As SIZEF
    ToType.cx = m_sngWidth
    ToType.cy = m_sngHeight
End Function

Public Property Get Width() As Single
    Width = m_sngWidth
End Property

Public Property Let Width(ByVal NewValue As Single)
    m_sngWidth = NewValue
End Property

Private Sub Class_Initialize()
    m_sngWidth = 0#: m_sngHeight = 0#
End Sub

