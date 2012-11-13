VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cHatchBrush"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cHatchBrush.cls
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

Public Function Clone() As cHatchBrush
    Dim lClone As Long
    Dim clsCs As cHatchBrush
    
    m_uLastStatus = GdipCloneBrush(m_clsBrush.NativeBrush, lClone)
    If m_uLastStatus <> Ok Then Exit Function
    Set clsCs = New cHatchBrush
    clsCs.Brush.fInitialize (lClone)
    Set Clone = clsCs
End Function

' Creates a HatchBrush object based on a hatch style, a foreground color, and a background color.
Public Function CreateHatchBrush(ByVal uhatchStyle As HatchStyle, _
                                 ByVal foreColor As cColor, _
                                 ByVal backColor As cColor) As GpStatus
    Dim lBrush As Long
    
    If foreColor Is Nothing Then m_uLastStatus = InvalidParameter: CreateHatchBrush = m_uLastStatus: Exit Function
    If backColor Is Nothing Then m_uLastStatus = InvalidParameter: CreateHatchBrush = m_uLastStatus: Exit Function
    Call DisposeHatchBrush
    m_uLastStatus = GdipCreateHatchBrush(uhatchStyle, foreColor.GetValue(), backColor.GetValue(), lBrush)
    CreateHatchBrush = m_uLastStatus
    If m_uLastStatus <> Ok Then Exit Function
    m_clsBrush.fInitialize lBrush
End Function

Public Sub DisposeHatchBrush()
    m_clsBrush.DisposeBrush
    m_uLastStatus = m_clsBrush.GetLastStatus
End Sub

' gets the background color of this hatch brush.
Public Function GetBackgroundColor(ByRef backColor As cColor) As GpStatus
    Dim lColor As Long
    
    m_uLastStatus = GdipGetHatchBackgroundColor(m_clsBrush.NativeBrush, lColor)
    If m_uLastStatus = Ok Then
       If backColor Is Nothing Then Set backColor = New cColor
       backColor.SetValue (lColor)
    End If
    GetBackgroundColor = m_uLastStatus
End Function

' gets the foreground color of this hatch brush.
Public Function GetForegroundColor(ByRef foreColor As cColor) As GpStatus
    Dim lColor As Long
    
    m_uLastStatus = GdipGetHatchForegroundColor(m_clsBrush.NativeBrush, lColor)
    If m_uLastStatus = Ok Then
       If foreColor Is Nothing Then Set foreColor = New cColor
       foreColor.SetValue (lColor)
    End If
    GetForegroundColor = m_uLastStatus
End Function

' gets the hatch style of this hatch brush.
Public Function GetHatchStyle() As HatchStyle
    Dim uStyle As HatchStyle
    
    m_uLastStatus = GdipGetHatchStyle(m_clsBrush.NativeBrush, uStyle)
    GetHatchStyle = uStyle
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

Private Sub Class_Initialize()
    Set m_clsBrush = New cBrush
End Sub

Private Sub Class_Terminate()
    Set m_clsBrush = Nothing
End Sub
