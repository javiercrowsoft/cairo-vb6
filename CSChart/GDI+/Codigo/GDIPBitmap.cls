VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "GDIPBitmap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit


Private m_bUseEmbeddedColorManagement As Boolean
Private m_img As GDIPImage
Private m_lastResult As GpStatus

Friend Sub fInit(ByVal nativeImage As Long, ByVal lastResult)
   Dispose
   m_img.fInit nativeImage, lastResult
   m_lastResult = lastResult
End Sub

Friend Property Get nativeImage() As Long
   nativeImage = m_img.nativeImage
End Property

Private Sub SetStatus(ByVal status As GpStatus)
   m_lastResult = SetStatusHelper(status)
End Sub

Public Property Get Image() As GDIPImage
   Set Image = m_img
End Property

Public Sub FromBITMAPINFO( _
      gdiBitmapInfo As BITMAPINFO, _
      ByVal ptrBitmapData As Long _
   )
Dim bm As Long
   Dispose
   SetStatus GdipCreateBitmapFromGdiDib(gdiBitmapInfo, ptrBitmapData, bm)
   m_img.fInit bm, m_lastResult
End Sub

Public Sub CreateFromSizeFormatData( _
      ByVal width As Long, _
      ByVal height As Long, _
      ByVal stride As Long, _
      ByVal format As Long, _
      ByVal ptrBitmapData As Long _
   )
Dim bm As Long
   Dispose
   SetStatus GdipCreateBitmapFromScan0(width, height, stride, format, ByVal ptrBitmapData, bm)
   m_img.fInit bm, m_lastResult
End Sub

Public Sub CreateFromSize( _
      ByVal width As Long, _
      ByVal height As Long _
   )
   CreateFromSizeFormat width, height, 0 ' don't care
End Sub

Public Sub CreateFromSizeFormat( _
      ByVal width As Long, _
      ByVal height As Long, _
      ByVal format As Long _
   )
Dim bm As Long
   Dispose
   SetStatus GdipCreateBitmapFromScan0(width, height, 0, format, ByVal 0&, bm)
   m_img.fInit bm, m_lastResult
End Sub

Public Sub CreateFromGraphics( _
      ByVal width As Long, _
      ByVal height As Long, _
      gfx As GDIPGraphics _
   )
Dim bm As Long
   Dispose
   SetStatus GdipCreateBitmapFromGraphics(width, height, gfx.nativeGraphics, bm)
   m_img.fInit bm, m_lastResult
End Sub

Public Sub CreateFromHICON( _
      ByVal HICON As Long _
   )
Dim bm As Long
   Dispose
   SetStatus GdipCreateBitmapFromHICON(HICON, bm)
   m_img.fInit bm, m_lastResult
End Sub

Public Sub CreateFromHBITMAP( _
      ByVal hBmp As Long, _
      ByVal hPal As Long _
   )
Dim bm As Long
   Dispose
   SetStatus GdipCreateBitmapFromHBITMAP(bm, hPal, bm)
   m_img.fInit bm, m_lastResult
End Sub

Public Sub CreateFromResource( _
      ByVal hInstance As Long, _
      ByVal sBitmapName As String _
   )
Dim bm As Long
   Dispose
   SetStatus GdipCreateBitmapFromResource(hInstance, sBitmapName, bm)
   m_img.fInit bm, m_lastResult
End Sub

Public Sub CreateFromStdPicture( _
      sPic As IPicture _
   )
Dim hBmp As Long
Dim hPal As Long
   hBmp = sPic.Handle
   hPal = sPic.hPal
   Dispose
   CreateFromHBITMAP hBmp, hPal
End Sub

Public Property Get HBITMAP( _
      ByVal colorBackground As Long _
    ) As Long
Dim hBmReturn As Long
   SetStatus GdipCreateHBITMAPFromBitmap(m_img.nativeImage, hBmReturn, colorBackground)
   HBITMAP = hBmReturn
End Function

Public Property Get HICON() As Long
Dim hIconReturn As Long
   SetStatus GdipCreateHICONFromBitmap( _
         m_img.nativeImage, _
         hIconReturn)
   HICON = hIconReturn
End Property

Public Property Get Picture() As IPicture
   
End Property

Public Function CloneSizeL( _
      rect As RECTL, _
      ByVal PixelFormat As Long _
   ) As GDIPBitmap
   Set CloneSizeL = CloneSizeLv(rect.Left, rect.Top, rect.width, rect.height, PixelFormat)
End Function

Public Function CloneSizeLv( _
      ByVal x As Long, _
      ByVal y As Long, _
      ByVal width As Long, _
      ByVal height As Long, _
      ByVal PixelFormat As Long _
   ) As GDIPBitmap
   Dim c As New GDIPBitmap
   Dim bmNew As Long
   SetStatus GdipCloneBitmapAreaI(x, y, width, height, PixelFormat, m_img.nativeImage, bmNew)
   If (m_lastResult = Ok) Then
      c.fInit bmNew, m_lastResult
   End If
   Set CloneSizeLv = c
End Function

Public Function CloneSizeF( _
      rect As RECTF, _
      ByVal PixelFormat As Long _
   ) As GDIPBitmap
   Set CloneSizeF = CloneSizeFv(rect.Left, rect.Top, rect.width, rect.height, PixelFormat)
End Function

Public Function CloneSizeFv( _
      ByVal x As Single, _
      ByVal y As Single, _
      ByVal width As Single, _
      ByVal height As Single, _
      ByVal PixelFormat As Long _
   ) As GDIPBitmap
   Dim c As New GDIPBitmap
   Dim bmNew As Long
   SetStatus GdipCloneBitmapArea(x, y, width, height, PixelFormat, m_img.nativeImage, bmNew)
   If (m_lastResult = Ok) Then
      c.fInit bmNew, m_lastResult
   End If
   Set CloneSizeFv = c
End Function

'inline status
'Bitmap::LockBits(
'    IN const Rect* rect,
'    IN UINT flags,
'    IN PixelFormat format,
'    OUT BitmapData * lockedBitmapData
')
'{
'    return SetStatus(DllExports::GdipBitmapLockBits(
'                                    static_cast<GpBitmap*>(nativeImage),
'                                    rect,
'                                    flags,
'                                    format,
'                                    lockedBitmapData));
'}
'
'inline status
'Bitmap::UnlockBits(
'    IN BitmapData* lockedBitmapData
'    )
'{
'    return SetStatus(DllExports::GdipBitmapUnlockBits(
'                                    static_cast<GpBitmap*>(nativeImage),
'                                    lockedBitmapData));
'}

Public Function GetPixel( _
      ByVal x As Long, _
      ByVal y As Long _
   ) As Long
Dim argb As Long
   SetStatus GdipBitmapGetPixel(m_img.nativeImage, x, y, argb)
   GetPixel = argb
End Function

Public Function SetPixel( _
      ByVal x As Long, _
      ByVal y As Long, _
      ByVal argb As Long _
   )
   SetStatus GdipBitmapSetPixel(m_img.nativeImage, x, y, argb)
End Function

Public Sub SetResolution( _
      ByVal xdpi As Single, _
      ByVal ydpi As Single _
   )
   SetStatus GdipBitmapSetResolution(m_img.nativeImage, xdpi, ydpi)
End Sub

Public Sub Dispose()
   m_img.Dispose
End Sub

Private Sub Class_Initialize()
   Set m_img = New GDIPImage
End Sub

Private Sub Class_Terminate()
   Dispose
End Sub


