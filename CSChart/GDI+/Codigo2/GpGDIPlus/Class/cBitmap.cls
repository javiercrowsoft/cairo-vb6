VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cBitmap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Attribute VB_Ext_KEY = "Member0" ,"cGraphicstest"
Option Explicit

' ==================================================================================
' cBitmap.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiPlusBitmap.h:Microsoft Platform SDK February 2003
'
' The Image class provides methods for loading and
' saving vector images (metafiles) and raster images (bitmaps).
' ==================================================================================

Private m_clsImage As cImage
Private m_uLastStatus As GpStatus

Public Function Clone() As cBitmap
    Dim lImage          As Long
    Dim clsClone        As cBitmap
    
    m_uLastStatus = GdipCloneImage(m_clsImage.NativeImage, lImage)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cBitmap
    clsClone.Image.fInitialize lImage
    Set Clone = clsClone
End Function

Public Function CloneRectF(ByVal rect As cRectF, _
                           Optional ByVal format As GpPixelFormat = PixelFormat24bppRGB) _
                           As cBitmap
    With rect
         Set CloneRectF = CloneSizeF(.Left, .Top, .Width, .Height, format)
    End With
End Function

Public Function CloneRectL(ByVal rect As cRect, _
                           Optional ByVal format As GpPixelFormat = PixelFormat24bppRGB) _
                           As cBitmap
    With rect
         Set CloneRectL = CloneSizeL(.Left, .Top, .Width, .Height, format)
    End With
End Function

Public Function CloneSizeF(ByVal x As Single, _
                           ByVal y As Single, _
                           ByVal Width As Single, _
                           ByVal Height As Single, _
                           Optional ByVal format As GpPixelFormat = PixelFormat24bppRGB) _
                           As cBitmap

    Dim clsClone           As cBitmap
    Dim lBM                As Long
    
    m_uLastStatus = GdipCloneBitmapArea(x, y, Width, Height, format, m_clsImage.NativeImage, lBM)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cBitmap
    clsClone.Image.fInitialize lBM
    Set CloneSizeF = clsClone
End Function

Public Function CloneSizeL(ByVal x As Long, _
                           ByVal y As Long, _
                           ByVal Width As Long, _
                           ByVal Height As Long, _
                           Optional ByVal format As GpPixelFormat = PixelFormat24bppRGB) _
                           As cBitmap
    Dim clsClone           As cBitmap
    Dim lBM                As Long
    
    m_uLastStatus = GdipCloneBitmapAreaI(x, y, Width, Height, format, m_clsImage.NativeImage, lBM)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cBitmap
    clsClone.Image.fInitialize lBM
    Set CloneSizeL = clsClone
End Function

Public Sub DisposeBitmap()
    m_clsImage.DisposeImage
    m_uLastStatus = m_clsImage.GetLastStatus
End Sub

' creates a Bitmap object based on a BITMAPINFO structure and an array of pixel data.
Public Function FromBITMAPINFO(gdiBitmapInfo As BITMAPINFO, ByVal gdiBitmapData As Long) As GpStatus
    Dim lBM As Long
    
    Call DisposeBitmap
    m_uLastStatus = GdipCreateBitmapFromGdiDib(gdiBitmapInfo, gdiBitmapData, lBM)
    If lBM <> 0 Then m_clsImage.fInitialize lBM
    FromBITMAPINFO = m_uLastStatus
End Function

' creates a Bitmap object based on an image file.
Public Function FromFile(ByVal filename As String, _
                         Optional ByVal useEmbeddedColorManagement As Boolean = False) _
                         As GpStatus
    Dim lBM As Long
    
    Call DisposeBitmap
    If useEmbeddedColorManagement Then
       m_uLastStatus = GdipCreateBitmapFromFileICM(StrConv(filename, vbUnicode), lBM)
    Else
       m_uLastStatus = GdipCreateBitmapFromFile(StrConv(filename, vbUnicode), lBM)
    End If
    If lBM <> 0 Then m_clsImage.fInitialize lBM
    FromFile = m_uLastStatus
End Function

' Creates a Bitmap object based on a Graphics object, a width, and a height.
Public Function FromGrpaphics(ByVal Width As Long, _
                              ByVal Height As Long, _
                              ByVal target As cGraphics) As GpStatus
    Dim lBM As Long
    
    Call DisposeBitmap
    m_uLastStatus = GdipCreateBitmapFromGraphics(Width, Height, target.NativeGraphics, lBM)
    If lBM <> 0 Then m_clsImage.fInitialize lBM
    FromGrpaphics = m_uLastStatus
End Function

' creates a Bitmap object based on a handle to a GDI bitmap and a handle to a GDI palette.
Public Function FromHBITMAP(ByVal hbm As Long, ByVal hpal As Long) As GpStatus
    Dim lBM As Long
    
    Call DisposeBitmap
    m_uLastStatus = GdipCreateBitmapFromHBITMAP(hbm, hpal, lBM)
    If lBM <> 0 Then m_clsImage.fInitialize lBM
    FromHBITMAP = m_uLastStatus
End Function

' creates a Bitmap object based on a handle to an icon.
Public Function FromHICON(ByVal hicon As Long) As GpStatus
    Dim lBM As Long
    
    Call DisposeBitmap
    m_uLastStatus = GdipCreateBitmapFromHICON(hicon, lBM)
    If lBM <> 0 Then m_clsImage.fInitialize lBM
    FromHICON = m_uLastStatus
End Function

' creates a Bitmap object based on an application or dynamic-link library (DLL)
' instance handle and the name of a bitmap resource.
Public Function FromResource(ByVal hInstance As Long, ByVal bitmapName As String) As GpStatus
    Dim lBM As Long
    
    Call DisposeBitmap
    m_uLastStatus = GdipCreateBitmapFromResource(hInstance, bitmapName, lBM)
    If lBM <> 0 Then m_clsImage.fInitialize lBM
    FromResource = m_uLastStatus
End Function

' Creates a Bitmap object of a specified size and pixel format.
' The pixel data must be provided after the Bitmap object is constructed.
Public Function FromSizeFormat(ByVal Width As Long, _
                               ByVal Height As Long, _
                               Optional ByVal format As GpPixelFormat = PixelFormat32bppARGB) _
                               As GpStatus
    Dim lBM As Long
    
    Call DisposeBitmap
    m_uLastStatus = GdipCreateBitmapFromScan0(Width, Height, 0, format, ByVal 0&, lBM)
    If lBM <> 0 Then m_clsImage.fInitialize lBM
    FromSizeFormat = m_uLastStatus
End Function

' Creates a Bitmap object based on an array of bytes along with size and format information.
Public Function FromSizeFormatData(ByVal Width As Long, _
                                   ByVal Height As Long, _
                                   ByVal stride As Long, _
                                   ByVal scan0 As Long, _
                                   Optional ByVal format As GpPixelFormat = PixelFormat24bppRGB) _
                                   As GpStatus
    Dim lBM As Long
    
    Call DisposeBitmap
    m_uLastStatus = GdipCreateBitmapFromScan0(Width, Height, stride, format, ByVal scan0, lBM)
    If lBM <> 0 Then m_clsImage.fInitialize lBM
    FromSizeFormatData = m_uLastStatus
End Function

' creates a GDI bitmap from this Bitmap object.
Public Function GetHBITMAP(ByVal colorBackground As cColor, hbmReturn As Long) As GpStatus
    If colorBackground Is Nothing Then m_uLastStatus = InvalidParameter: GetHBITMAP = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCreateHBITMAPFromBitmap(m_clsImage.NativeImage, hbmReturn, colorBackground.GetValue())
    GetHBITMAP = m_uLastStatus
End Function

' creates an icon from this Bitmap object
Public Function GetHICON(hicon As Long) As GpStatus
    m_uLastStatus = GdipCreateHICONFromBitmap(m_clsImage.NativeImage, hicon)
    GetHICON = m_uLastStatus
End Function

' returns a value that indicates the nature of this Bitmap object's most recent method failure.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' gets the color of a specified pixel in this bitmap.
Public Function GetPixel(ByVal x As Long, ByVal y As Long, ByRef color As cColor) As GpStatus
    Dim lArgb As Long
    
    m_uLastStatus = GdipBitmapGetPixel(m_clsImage.NativeImage, x, y, lArgb)
    If m_uLastStatus = Ok Then
       If color Is Nothing Then Set color = New cColor
       color.SetValue (lArgb)
    End If
    GetPixel = m_uLastStatus
End Function

' gets a thumbnail bitmap from this bitmap object.
Public Function GetThumbnailBitmap(ByVal thumbWidth As Long, _
                                   ByVal thumbHeight As Long, _
                                   Optional ByVal callback As Long = 0, _
                                   Optional ByVal callbackData As Long = 0) As cBitmap
    Dim lngThumbnail               As Long
    Dim clsThumbnail               As cBitmap
    
    m_uLastStatus = GdipGetImageThumbnail(m_clsImage.NativeImage, thumbWidth, thumbHeight, _
                                         lngThumbnail, callback, callbackData)
    If m_uLastStatus <> Ok Then Exit Function
    Set clsThumbnail = New cBitmap
    clsThumbnail.Image.fInitialize lngThumbnail
    Set GetThumbnailBitmap = clsThumbnail
End Function

Public Property Get Image() As cImage
    Set Image = m_clsImage
End Property

' locks a rectangular portion of this bitmap and provides a temporary buffer
' that you can use to read or write pixel data in a specified format.
' Any pixel data that you write to the buffer is copied to the Bitmap object
' when you call UnlockBits.
Public Function LockBits(ByVal rect As cRect, _
                         ByVal flags As ImageLockMode, _
                         ByVal format As GpPixelFormat, _
                         lockedBitmapData As BitmapData) As GpStatus
    m_uLastStatus = GdipBitmapLockBits(m_clsImage.NativeImage, rect.ToType, flags, format, lockedBitmapData)
    LockBits = m_uLastStatus
End Function

Public Property Get NativeImage() As Long
    NativeImage = m_clsImage.NativeImage
End Property

' sets the color of a specified pixel in this bitmap.
Public Function SetPixel(ByVal x As Long, ByVal y As Long, ByVal color As cColor) As GpStatus
    If color Is Nothing Then m_uLastStatus = InvalidParameter: SetPixel = m_uLastStatus: Exit Function
    m_uLastStatus = GdipBitmapSetPixel(m_clsImage.NativeImage, x, y, color.GetValue())
    SetPixel = m_uLastStatus
End Function

' sets the resolution of this Bitmap object.
Public Function SetResolution(ByVal xdpi As Single, ByVal ydpi As Single) As GpStatus
    m_uLastStatus = GdipBitmapSetResolution(m_clsImage.NativeImage, xdpi, ydpi)
    SetResolution = m_uLastStatus
End Function

' unlocks a portion of this bitmap that was previously locked by a call to Bitmap::LockBits.
Public Function UnlockBits(lockedBitmapData As BitmapData) As GpStatus
    m_uLastStatus = GdipBitmapUnlockBits(m_clsImage.NativeImage, lockedBitmapData)
    UnlockBits = m_uLastStatus
End Function

Private Sub Class_Initialize()
    Set m_clsImage = New cImage
End Sub

Private Sub Class_Terminate()
    Set m_clsImage = Nothing
End Sub
