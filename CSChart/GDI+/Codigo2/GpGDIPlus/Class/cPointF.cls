VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cPointF"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cPointF.cls
' Copyright ?2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiplusTypes.h:Microsoft Platform SDK February 2003
'
' The PointF class encapsulates a point in a 2-D coordinate system.
' ==================================================================================

Private m_sngX As Single
Private m_sngY As Single

Public Function Add(ByVal point As cPointF) As cPointF
    Dim clsTmp As New cPointF
    clsTmp.Create m_sngX + point.x, m_sngY + point.y
    Set Add = clsTmp
End Function

Public Sub Create(ByVal x As Single, ByVal y As Single)
    m_sngX = x: m_sngY = y
End Sub

Public Sub CreateFromPoint(ByVal point As cPointF)
    With point
         m_sngX = .x
         m_sngY = .y
    End With
End Sub

Public Sub CreateFromSize(ByVal size As cSizeF)
    With size
         m_sngX = .Width
         m_sngY = .Height
    End With
End Sub

Public Sub CreateFromType(ByRef pt As POINTF)
    m_sngX = pt.x
    m_sngY = pt.y
End Sub

Public Function Equals(ByVal point As cPointF) As Boolean
    With point
         Equals = (m_sngX = .x) And (m_sngY = .y)
    End With
End Function

Public Function Subtract(ByVal point As cPointF) As cPointF
    Dim clsTmp As New cPointF
    clsTmp.Create m_sngX - point.x, m_sngY - point.y
    Set Subtract = clsTmp
End Function

Public Function ToType() As POINTF
    ToType.x = m_sngX
    ToType.y = m_sngY
End Function

Public Property Get x() As Single
    x = m_sngX
End Property

Public Property Let x(ByVal NewValue As Single)
    m_sngX = NewValue
End Property

Public Property Get y() As Single
    y = m_sngY
End Property

Public Property Let y(ByVal NewValue As Single)
    m_sngY = NewValue
End Property

Private Sub Class_Initialize()
    m_sngX = 0#: m_sngY = 0#
End Sub
