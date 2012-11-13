Attribute VB_Name = "mSaveIcon"
Option Explicit

Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Type ICONINFO
   fIcon As Long
   xHotspot As Long
   yHotspot As Long
   hBmMask As Long
   hbmColor As Long
End Type
Private Declare Function GetIconInfo Lib "user32" (ByVal hIcon As Long, piconinfo As ICONINFO) As Long
Private Declare Function GetObjectAPI Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long
Private Type BITMAP '14 bytes
    bmType As Long
    bmWidth As Long
    bmHeight As Long
    bmWidthBytes As Long
    bmPlanes As Integer
    bmBitsPixel As Integer
    bmBits As Long
End Type
Private Declare Function CreateIconIndirect Lib "user32" (piconinfo As ICONINFO) As Long
Private Declare Function CreateBitmapIndirect Lib "gdi32" (lpBitmap As BITMAP) As Long
Private Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hdc As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal hdc As Long, ByVal nIndex As Long) As Long
Private Const BITSPIXEL = 12         '  Number of bits per pixel

'Private Declare Function GetBitmapBits Lib "gdi32" (ByVal hBitmap As Long, ByVal dwCount As Long, lpBits As Any) As Long
'Private Declare Function SetBitmapBits Lib "gdi32" (ByVal hBitmap As Long, ByVal dwCount As Long, lpBits As Any) As Long
Type RGBQUAD
   rgbBlue As Byte
   rgbGreen As Byte
   rgbRed As Byte
   rgbReserved As Byte
End Type
Private Type BITMAPINFOHEADER '40 bytes
   biSize As Long
   biWidth As Long
   biHeight As Long
   biPlanes As Integer
   biBitCount As Integer
   biCompression As Long
   biSizeImage As Long
   biXPelsPerMeter As Long
   biYPelsPerMeter As Long
   biClrUsed As Long
   biClrImportant As Long
End Type
Private Type BITMAPINFO_1BPP
   bmiHeader As BITMAPINFOHEADER
   bmiColors(0 To 1) As RGBQUAD
End Type
Private Type BITMAPINFO_4BPP
   bmiHeader As BITMAPINFOHEADER
   bmiColors(0 To 15) As RGBQUAD
End Type
Private Type BITMAPINFO_8BPP
   bmiHeader As BITMAPINFOHEADER
   bmiColors(0 To 255) As RGBQUAD
End Type
Private Type BITMAPINFO_ABOVE8
   bmiHeader As BITMAPINFOHEADER
End Type

Private Const DIB_PAL_COLORS = 1 '  color table in palette indices
Private Const DIB_PAL_INDICES = 2 '  No color table indices into surf palette
Private Const DIB_PAL_LOGINDICES = 4 '  No color table indices into DC palette
Private Const DIB_PAL_PHYSINDICES = 2 '  No color table indices into surf palette
Private Const DIB_RGB_COLORS = 0 '  color table in RGBs
Private Declare Function GetDIBits Lib "gdi32" (ByVal aHDC As Long, ByVal hBitmap As Long, ByVal nStartScan As Long, ByVal nNumScans As Long, lpBits As Any, lpBI As Any, ByVal wUsage As Long) As Long
Private Declare Function SetDIBits Lib "gdi32" (ByVal hdc As Long, ByVal hBitmap As Long, ByVal nStartScan As Long, ByVal nNumScans As Long, lpBits As Any, lpBI As Any, ByVal wUsage As Long) As Long
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" ( _
    lpvDest As Any, lpvSource As Any, ByVal cbCopy As Long)
Private Declare Function CreateDCAsNull Lib "gdi32" Alias "CreateDCA" (ByVal lpDriverName As String, lpDeviceName As Any, lpOutput As Any, lpInitData As Any) As Long
Private Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
Private Const BI_RGB = 0&
Private Const BI_RLE4 = 2&
Private Const BI_RLE8 = 1&

Public Function SerialiseIcon( _
      ByVal lHDC As Long, _
      ByVal hIcon As Long, _
      ByRef b() As Byte, _
      ByVal lByteStart As Long, _
      ByRef lArraySize As Long _
   ) As Boolean
Dim tII As ICONINFO
Dim lR As Long
Dim lMonoSize As Long
Dim lColourSize As Long
   
   ' decompose icon:
   lR = GetIconInfo(hIcon, tII)
   If (lR <> 0) Then
      ' store fIcon, xHotspot, yHotspot:
      CopyMemory b(lByteStart), tII, 12
      ' store the colour bitmap:
      lByteStart = lByteStart + 12
      If (SerialiseBitmap(lHDC, tII.hbmColor, False, b(), lByteStart, lColourSize)) Then
         lByteStart = lByteStart + lColourSize
         If (SerialiseBitmap(lHDC, tII.hBmMask, True, b(), lByteStart, lMonoSize)) Then
            lByteStart = lByteStart + lMonoSize
            lArraySize = lColourSize + lMonoSize + 12
            SerialiseIcon = True
         End If
      End If
      DeleteObject tII.hbmColor
      DeleteObject tII.hBmMask
   End If
End Function
Private Function SerialiseBitmap( _
      ByVal lHDC As Long, _
      ByVal hBm As Long, _
      ByVal bMono As Boolean, _
      ByRef b() As Byte, _
      ByVal lByteStart As Long, _
      ByRef lByteSize As Long _
   ) As Boolean
Dim tBM As BITMAP
Dim tBI1 As BITMAPINFO_1BPP
Dim tBI4 As BITMAPINFO_4BPP
Dim tBI8 As BITMAPINFO_8BPP
Dim tBI As BITMAPINFO_ABOVE8
Dim lSize As Long
Dim lR As Long
   
   ' Get the BITMAP structure:
   lR = GetObjectAPI(hBm, Len(tBM), tBM)
   If (lR <> 0) Then
      ' Store the BITMAP structure:
      CopyMemory b(lByteStart), tBM, Len(tBM)
      ' Create a bitmap info structure:
      If (bMono) Then
         With tBI1.bmiHeader
            .biSize = Len(tBI1.bmiHeader)
            .biWidth = tBM.bmWidth
            .biHeight = tBM.bmHeight
            .biPlanes = 1
            .biBitCount = 1
            .biCompression = BI_RGB
         End With
         lSize = (tBI1.bmiHeader.biWidth + 7) / 8
         lSize = ((lSize + 3) \ 4) * 4
         lSize = lSize * tBI1.bmiHeader.biHeight
         lR = GetDIBits(lHDC, hBm, 0, tBM.bmHeight, b(lByteStart + Len(tBM)), tBI1, DIB_RGB_COLORS)
      Else
         With tBI.bmiHeader
            .biSize = Len(tBI.bmiHeader)
            .biWidth = tBM.bmWidth
            .biHeight = tBM.bmHeight
            .biPlanes = 1
            .biBitCount = 24
            .biCompression = BI_RGB
         End With
         ' Get the Bitmap bits into the byte array:
         lSize = tBI.bmiHeader.biWidth
         lSize = lSize * 3
         lSize = ((lSize + 3) / 4) * 4
         lSize = lSize * tBI.bmiHeader.biHeight
         'lR = GetBitmapBits(hBm, lSize, b(lByteStart + Len(tBM)))
         lR = GetDIBits(lHDC, hBm, 0, tBM.bmHeight, b(lByteStart + Len(tBM)), tBI, DIB_RGB_COLORS)
      End If
      
      If (lR <> 0) Then
         ' Success.  Return size:
         lByteSize = lSize + Len(tBM)
         SerialiseBitmap = True
      End If
   End If

End Function
Public Function DeSerialiseIcon( _
      ByVal lHDC As Long, _
      ByRef hIcon As Long, _
      ByRef b() As Byte, _
      ByVal lByteStart As Long, _
      ByRef lArraySize As Long _
   )
Dim tII As ICONINFO
Dim lColourSize As Long
Dim lMonoSize As Long

   hIcon = 0
   ' get fIcon, xHotspot, yHotspot:
   CopyMemory tII, b(lByteStart), 12
   tII.fIcon = 1
   lByteStart = lByteStart + 12
   ' get the colour bitmap:
   If (DeSerialiseBitmap(lHDC, tII.hbmColor, False, b(), lByteStart, lColourSize)) Then
      lByteStart = lByteStart + lColourSize
      ' get the mono bitmap:
      If (DeSerialiseBitmap(lHDC, tII.hBmMask, True, b(), lByteStart, lMonoSize)) Then
         ' Set the size:
         lArraySize = lColourSize + lMonoSize + 12
         
         ' Create the icon from the structure:
         hIcon = CreateIconIndirect(tII)
         DeSerialiseIcon = (hIcon <> 0)
        
         DeleteObject tII.hbmColor
         DeleteObject tII.hBmMask
        
      Else
         DeleteObject tII.hbmColor
      End If
   End If
   
End Function
Private Function DeSerialiseBitmap( _
      ByVal lHDC As Long, _
      ByRef hBm As Long, _
      ByVal bMono As Boolean, _
      ByRef b() As Byte, _
      ByVal lByteStart As Long, _
      ByRef lByteSize As Long _
   ) As Boolean
Dim tBM As BITMAP
Dim tBI1 As BITMAPINFO_1BPP
Dim tBI4 As BITMAPINFO_4BPP
Dim tBI8 As BITMAPINFO_8BPP
Dim tBI As BITMAPINFO_ABOVE8
Dim lSize As Long
Dim lR As Long
   
   'Debug.Print lByteStart, lByteSize
   ' Get the BITMAP structure:
   CopyMemory tBM, b(lByteStart), Len(tBM)
   ' Create the bitmap:
   If Not (bMono) Then
      hBm = CreateCompatibleBitmap(lHDC, tBM.bmWidth, tBM.bmHeight)
   Else
      hBm = CreateBitmapIndirect(tBM)
   End If
   If (hBm <> 0) Then
      ' Get the Bitmap bits from the byte array:
      'lSize = tBM.bmWidthBytes * tBM.bmHeight
      'lR = SetBitmapBits(hBm, lSize, b(lByteStart + Len(tBM)))
      If (bMono) Then
         With tBI1.bmiHeader
            .biSize = Len(tBI1.bmiHeader)
            .biWidth = tBM.bmWidth
            .biHeight = tBM.bmHeight
            .biPlanes = 1
            .biBitCount = 1
            .biCompression = BI_RGB
         End With
         lSize = (tBI1.bmiHeader.biWidth + 7) / 8
         lSize = ((lSize + 3) \ 4) * 4
         lSize = lSize * tBI1.bmiHeader.biHeight

         tBI1.bmiColors(1).rgbBlue = 255
         tBI1.bmiColors(1).rgbGreen = 255
         tBI1.bmiColors(1).rgbRed = 255
         lR = SetDIBits(lHDC, hBm, 0, tBM.bmHeight, b(lByteStart + Len(tBM)), tBI1, DIB_RGB_COLORS)
      Else
         With tBI.bmiHeader
            .biSize = Len(tBI.bmiHeader)
            .biWidth = tBM.bmWidth
            .biHeight = tBM.bmHeight
            .biPlanes = 1
            .biBitCount = 24
            .biCompression = BI_RGB
         End With
         
         lSize = tBI.bmiHeader.biWidth
         lSize = lSize * 3
         lSize = ((lSize + 3) / 4) * 4
         lSize = lSize * tBI.bmiHeader.biHeight
         
         lR = SetDIBits(lHDC, hBm, 0, tBM.bmHeight, b(lByteStart + Len(tBM)), tBI, DIB_RGB_COLORS)
      End If
      
      lByteSize = lSize + Len(tBM)
      If (lR <> 0) Then
         DeSerialiseBitmap = True
      Else
         DeleteObject hBm
      End If
   End If
   
End Function



