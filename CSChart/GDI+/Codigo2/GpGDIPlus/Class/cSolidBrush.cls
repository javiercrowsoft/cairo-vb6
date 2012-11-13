VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSolidBrush"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cSolidBrush.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiPlusBrush.h:Microsoft Platform SDK February 2003
' ==================================================================================

Private m_clsBrush As cBrush
Private m_uLastStatus As GpStatus

Public Property Get Brush() As cBrush
    Set Brush = m_clsBrush
End Property

Public Function Clone() As cSolidBrush
    Dim lClone As Long
    Dim clsCs As cSolidBrush
    
    m_uLastStatus = GdipCloneBrush(m_clsBrush.NativeBrush, lClone)
    If m_uLastStatus <> Ok Then Exit Function
    Set clsCs = New cSolidBrush
    clsCs.Brush.fInitialize (lClone)
    Set Clone = clsCs
End Function

Public Function CreateSolidBrush(ByVal color As cColor) As GpStatus
    Dim lBrush As Long
    
    If color Is Nothing Then m_uLastStatus = InvalidParameter: CreateSolidBrush = m_uLastStatus: Exit Function
    Call DisposeSolidBrush
    m_uLastStatus = GdipCreateSolidFill(color.GetValue(), lBrush)
    CreateSolidBrush = m_uLastStatus
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize lBrush
End Function

Public Sub DisposeSolidBrush()
    m_clsBrush.DisposeBrush
    m_uLastStatus = m_clsBrush.GetLastStatus
End Sub

' gets the color of this solid brush.
Public Function GetColor(ByRef color As cColor) As GpStatus
    Dim lArgb As Long
    
    m_uLastStatus = GdipGetSolidFillColor(m_clsBrush.NativeBrush, lArgb)
    If m_uLastStatus = Ok Then
       If color Is Nothing Then Set color = New cColor
       color.SetValue (lArgb)
    End If
    GetColor = m_uLastStatus
End Function

Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

Public Function GetType() As BrushType
    GetType = m_clsBrush.GetType
End Function

Public Property Get NativeBrush() As Long
    NativeBrush = m_clsBrush.NativeBrush
End Property

Public Sub SetBrush(ByVal cBrush As cBrush)
    Set m_clsBrush = Nothing
    Set m_clsBrush = cBrush
End Sub

' sets the color of this solid brush.
Public Function SetColor(ByVal color As cColor) As GpStatus
    If color Is Nothing Then m_uLastStatus = InvalidParameter: SetColor = m_uLastStatus: Exit Function
    m_uLastStatus = GdipSetSolidFillColor(m_clsBrush.NativeBrush, color.GetValue())
    SetColor = m_uLastStatus
End Function

Private Sub Class_Initialize()
    Set m_clsBrush = New cBrush
End Sub

Private Sub Class_Terminate()
    Set m_clsBrush = Nothing
End Sub
