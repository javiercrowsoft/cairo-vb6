VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cCachedBitmap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cCachedBitmap.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiPlusCachedBitmap.h:Microsoft Platform SDK February 2003
'
' A CachedBitmap object stores a bitmap in a format that is optimized for display
' on a particular device. To display a cached bitmap, call the Graphics::DrawCachedBitmap method
' ==================================================================================

Private m_uLastStatus As GpStatus
Private m_lngCachedBitmap As Long

' Creates a CachedBitmap object based on a Bitmap object and a Graphics object.
' The cached bitmap takes the pixel data from the Bitmap object and stores it in
' a format that is optimized for the display device associated with the Graphics object.
Public Function CreateCachedBitmap(ByVal bitmap As cBitmap, ByVal graphics As cGraphics) As GpStatus
    m_uLastStatus = Aborted
    If bitmap Is Nothing Then m_uLastStatus = InvalidParameter: CreateCachedBitmap = m_uLastStatus: Exit Function
    If graphics Is Nothing Then m_uLastStatus = InvalidParameter: CreateCachedBitmap = m_uLastStatus: Exit Function
    Call DisposeCachedBitmap
    m_uLastStatus = GdipCreateCachedBitmap(bitmap.NativeImage, graphics.NativeGraphics, m_lngCachedBitmap)
    CreateCachedBitmap = m_uLastStatus
End Function

Public Sub DisposeCachedBitmap()
    If m_lngCachedBitmap <> 0 Then m_uLastStatus = GdipDeleteCachedBitmap(m_lngCachedBitmap): m_lngCachedBitmap = 0
End Sub

' returns a value that indicates whether this CachedBitmap object was constructed successfully.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

Public Property Get NativeCachedBitmap() As Long
    NativeCachedBitmap = m_lngCachedBitmap
End Property

Private Sub Class_Initialize()
    Call DisposeCachedBitmap
End Sub

Private Sub Class_Terminate()
    Call DisposeCachedBitmap
End Sub
