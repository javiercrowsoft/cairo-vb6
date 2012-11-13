VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "GDIPGraphics"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_gfx As Long
Private m_lastResult As GpStatus

Friend Property Get nativeGraphics() As Long
   nativeGraphics = m_gfx
End Property

Public Sub FromHDC(ByVal lhDC As Long)
   Dispose
   SetStatus GdipCreateFromHDC(lhDC, m_gfx)
End Sub

Public Sub FromHDCDevice(ByVal lhDC As Long, ByVal hDevice As Long)
   Dispose
   SetStatus GdipCreateFromHDC2(lhDC, hDevice, m_gfx)
End Sub

Public Sub FromHWnd(ByVal lhWnd As Long)
   Dispose
   SetStatus GdipCreateFromHWND(lhWnd, m_gfx)
End Sub

Public Sub FromImage(image As GDIPImage)
   Dispose
   SetStatus GdipGetImageGraphicsContext(image.nativeImage, m_gfx)
End Sub

Public Sub Flush(ByVal intention As FlushIntention)
   GdipFlush m_gfx, intention
End Sub

Public Function GetHDC() As Long
Dim lhDC As Long
   m_lastResult = GdipGetDC(m_gfx, lhDC)
   GetHDC = lhDC
End Function

Public Function ReleaseHDC(ByVal hDC As Long)
   m_lastResult = GdipReleaseDC(m_gfx, hDC)
End Function

Public Function SetRenderingOrigin(ByVal x As Long, ByVal y As Long) As GpStatus
   SetRenderingOrigin = SetStatus( _
            GdipSetRenderingOrigin( _
                m_gfx, x, y) _
            )
End Function
Public Function GetRenderingOrigin(ByRef x As Long, ByRef y As Long) As GpStatus
   GetRenderingOrigin = SetStatus( _
            GdipGetRenderingOrigin( _
                m_gfx, x, y) _
            )
End Function

Public Property Let CompositingMode(ByVal value As CompositingMode)
   SetStatus GdipSetCompositingMode(m_gfx, value)
End Property
Public Property Get CompositingMode() As CompositingMode
Dim mode As CompositingMode
   SetStatus GdipGetCompositingMode(m_gfx, mode)
   CompositingMode = mode
End Property

Public Property Let CompositingQuality(ByVal value As CompositingQuality)
   SetStatus GdipSetCompositingQuality(m_gfx, value)
End Property
Public Property Get CompositingQuality() As CompositingQuality
Dim value As CompositingQuality
   SetStatus GdipGetCompositingQuality(m_gfx, value)
   CompositingQuality = value
End Property

Public Property Let TextRenderingHint(ByVal value As TextRenderingHint)
   SetStatus GdipSetTextRenderingHint(m_gfx, value)
End Property
Public Property Get TextRenderingHint() As TextRenderingHint
Dim value As TextRenderingHint
   SetStatus GdipGetTextRenderingHint(m_gfx, value)
   TextRenderingHint = value
End Property

Public Property Let TextContrast(ByVal value As Long)
   SetStatus GdipSetTextContrast(m_gfx, value)
End Property
Public Property Get TextContrast() As Long
Dim value As Long
   SetStatus GdipGetTextContrast(m_gfx, value)
   TextContrast = value
End Property

Public Property Let InterpolationMode(ByVal value As InterpolationMode)
   SetStatus GdipSetInterpolationMode(m_gfx, value)
End Property
Public Property Get InterpolationMode() As InterpolationMode
Dim value As InterpolationMode
   SetStatus GdipGetInterpolationMode(m_gfx, value)
   InterpolationMode = value
End Property

Public Property Let SmoothingMode(ByVal value As SmoothingMode)
   SetStatus GdipSetSmoothingMode(m_gfx, value)
End Property
Public Property Get SmoothingMode() As SmoothingMode
Dim value As SmoothingMode
   SetStatus GdipGetSmoothingMode(m_gfx, value)
   SmoothingMode = value
End Property

Public Property Let PixelOffsetMode(ByVal value As PixelOffsetMode)
   SetStatus GdipSetPixelOffsetMode(m_gfx, value)
End Property
Public Property Get PixelOffsetMode() As PixelOffsetMode
Dim value As PixelOffsetMode
   SetStatus GdipGetPixelOffsetMode(m_gfx, value)
   PixelOffsetMode = value
End Property



Public Sub DrawImagePointF( _
      image As GDIPImage, _
      point As POINTF _
   )
   DrawImagePointFv image, point.x, point.y
End Sub
Public Sub DrawImagePointFv( _
      image As GDIPImage, _
      ByVal x As Single, _
      ByVal y As Single _
   )
   SetStatus GdipDrawImage(m_gfx, image.nativeImage, x, y)
End Sub
Public Sub DrawImageRectF( _
      image As GDIPImage, _
      rect As RECTF _
   )
   DrawImageRectFv image, rect.Left, rect.Top, rect.width, rect.height
End Sub
Public Sub DrawImageRectFv( _
      image As GDIPImage, _
      ByVal x As Single, _
      ByVal y As Single, _
      ByVal width As Single, _
      ByVal height As Single _
   )
   SetStatus GdipDrawImageRect(m_gfx, _
         image.nativeImage, _
         x, _
         y, _
         width, _
         height)
End Sub
Public Sub DrawImagePointL( _
      image As GDIPImage, _
      point As POINTL _
   )
   DrawImagePointLv image, point.x, point.y
End Sub
Public Sub DrawImagePointLv( _
      image As GDIPImage, _
      ByVal x As Long, _
      ByVal y As Long _
   )
   SetStatus GdipDrawImageI(m_gfx, _
         image.nativeImage, _
         x, _
         y)
End Sub

Public Sub DrawImageRectL( _
      image As GDIPImage, _
      rect As RECTL)
   DrawImageRectLv image, rect.Left, rect.Top, rect.width, rect.height
End Sub

Public Sub DrawImageRectLv( _
      image As GDIPImage, _
      ByVal x As Long, _
      ByVal y As Long, _
      ByVal width As Long, _
      ByVal height As Long _
   )
   SetStatus GdipDrawImageRectI(m_gfx, _
      image.nativeImage, _
      x, _
      y, _
      width, _
      height)

End Sub
'
'    // Affine Draw Image
'    // destPoints.length = 3: rect => parallelogram
'    //     destPoints[0] <=> top-left corner of the source rectangle
'    //     destPoints[1] <=> top-right corner
'    //     destPoints[2] <=> bottom-left corner
'    // destPoints.length = 4: rect => quad
'    //     destPoints[3] <=> bottom-right corner
'
Public Sub DrawImageAffineF( _
      image As GDIPImage, _
      destPoints() As POINTF, _
      ByVal count As Long _
   )
   If (count <> 3 And count <> 4) Then
      SetStatus InvalidParameter
   Else
      SetStatus GdipDrawImagePoints(m_gfx, _
         image.nativeImage, _
         destPoints(0), count)
   End If
End Sub

Public Sub DrawImageAffineL( _
      image As GDIPImage, _
      destPoints() As POINTL, _
      ByVal count As Long _
   )
   If (count <> 3 And count <> 4) Then
      SetStatus InvalidParameter
   Else
      SetStatus GdipDrawImagePointsI(m_gfx, _
         image.nativeImage, _
         destPoints(0), count)
   End If

End Sub

Public Sub DrawImageStretchF( _
      image As GDIPImage, _
      ByVal x As Single, _
      ByVal y As Single, _
      ByVal srcx As Single, _
      ByVal srcy As Single, _
      ByVal srcwidth As Single, _
      ByVal srcheight As Single, _
      ByVal srcUnit As GpUnit)

   SetStatus GdipDrawImagePointRect(m_gfx, _
         image.nativeImage, _
         x, y, _
         srcx, srcy, _
         srcwidth, srcheight, srcUnit)

End Sub
Public Sub DrawImageStretchAttrF( _
      image As GDIPImage, _
      destRect As RECTF, _
      ByVal srcx As Single, _
      ByVal srcy As Single, _
      ByVal srcwidth As Single, _
      ByVal srcheight As Single, _
      ByVal srcUnit As GpUnit, _
      ByVal imgAttributes As Long, _
      ByVal callback As Long, _
      ByVal callbackData As Long _
   )
   SetStatus GdipDrawImageRectRect(m_gfx, _
         image.nativeImage, _
         destRect.Left, _
         destRect.Top, _
         destRect.width, _
         destRect.height, _
         srcx, srcy, _
         srcwidth, srcheight, _
         srcUnit, _
         imgAttributes, _
         callback, _
         callbackData)
End Sub

'public sub DrawImage(IN Image* image,
'                     IN const PointF* destPoints,
'                     IN INT count,
'                     IN REAL srcx,
'                     IN REAL srcy,
'                     IN REAL srcwidth,
'                     IN REAL srcheight,
'                     IN Unit srcUnit,
'                     IN const ImageAttributes* imageAttributes = NULL,
'                     IN DrawImageAbort callback = NULL,
'                     IN VOID* callbackData = NULL)
'    {
'        return SetStatus(DllExports::GdipDrawImagePointsRect(nativeGraphics,
'                                                             image ? image->nativeImage
'                                                                   : NULL,
'                                                             destPoints, count,
'                                                             srcx, srcy,
'                                                             srcwidth,
'                                                             srcheight,
'                                                             srcUnit,
'                                                             imageAttributes
'                                                              ? imageAttributes->nativeImageAttr
'                                                              : NULL,
'                                                             callback,
'                                                             callbackData));
'    }
'
Public Sub DrawImageStretchL( _
      image As GDIPImage, _
      ByVal x As Long, _
      ByVal y As Long, _
      ByVal srcx As Long, _
      ByVal srcy As Long, _
      ByVal srcwidth As Long, _
      ByVal srcheight As Long, _
      ByVal srcUnit As GpUnit _
   )
   SetStatus GdipDrawImagePointRectI(m_gfx, _
         image.nativeImage, _
         x, y, _
         srcx, srcy, _
         srcwidth, srcheight, _
         srcUnit)
End Sub

Public Sub DrawImageStretchAttrL( _
      image As GDIPImage, _
      destRect As RECTL, _
      ByVal srcx As Long, _
      ByVal srcy As Long, _
      ByVal srcwidth As Long, _
      ByVal srcheight As Long, _
      ByVal srcUnit As GpUnit, _
      ByVal imgAttributes As Long, _
      ByVal callback As Long, _
      ByVal callbackData As Long _
   )
   SetStatus GdipDrawImageRectRectI(m_gfx, _
      image.nativeImage, _
      destRect.Left, destRect.Top, _
      destRect.width, destRect.height, _
      srcx, srcy, srcwidth, srcheight, _
      srcUnit, _
      imgAttributes, _
      callback, _
      callbackData)

End Sub
   
'
'    Status DrawImage(IN Image* image,
'                     IN const Point* destPoints,
'                     IN INT count,
'                     IN INT srcx,
'                     IN INT srcy,
'                     IN INT srcwidth,
'                     IN INT srcheight,
'                     IN Unit srcUnit,
'                     IN const ImageAttributes* imageAttributes = NULL,
'                     IN DrawImageAbort callback = NULL,
'                     IN VOID* callbackData = NULL)
'    {
'        return SetStatus(DllExports::GdipDrawImagePointsRectI(nativeGraphics,
'                                                              image ? image->nativeImage
'                                                                    : NULL,
'                                                              destPoints,
'                                                              count,
'                                                              srcx,
'                                                              srcy,
'                                                              srcwidth,
'                                                              srcheight,
'                                                              srcUnit,
'                                                              imageAttributes
'                                                               ? imageAttributes->nativeImageAttr
'                                                               : NULL,
'                                                              callback,
'                                                              callbackData));
'    }


Public Sub Dispose()
   If Not (m_gfx = 0) Then
      GdipDeleteGraphics m_gfx
      m_gfx = 0
   End If
End Sub

Private Function SetStatus(ByVal status As GpStatus) As GpStatus
   m_lastResult = SetStatusHelper(status)
End Function

Private Sub Class_Terminate()
   Dispose
End Sub
