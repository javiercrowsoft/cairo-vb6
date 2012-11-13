Attribute VB_Name = "mIcon"
Option Explicit

'--------------------------------------------------------------------------------
' cWindow
' -08-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    Private Const DIB_PAL_COLORS = 1 '  color table in palette indices
    Private Const DIB_PAL_INDICES = 2 '  No color table indices into surf palette
    Private Const DIB_PAL_LOGINDICES = 4 '  No color table indices into DC palette
    Private Const DIB_PAL_PHYSINDICES = 2 '  No color table indices into surf palette
    Private Const DIB_RGB_COLORS = 0 '  color table in RGBs
    Private Const BI_RGB = 0&
    Private Const BI_RLE4 = 2&
    Private Const BI_RLE8 = 1&
    
    Private Const LR_LOADMAP3DCOLORS = &H1000
    Private Const LR_LOADFROMFILE = &H10
    Private Const LR_LOADTRANSPARENT = &H20
    Private Const LR_LOADREALSIZE As Long = &H80
    Private Const LR_DEFAULTSIZE = &H40

    Private Const SM_CXICON = 11 'Width of standard icon
    Private Const SM_CYICON = 12 'Height of standard icon
    
    Private Const hNull = 0
    ' estructuras
    Private Type ICONINFO
       fIcon As Long
       xHotspot As Long
       yHotspot As Long
       hBmMask As Long
       hbmColor As Long
    End Type
    Private Type BITMAP '14 bytes
        bmType As Long
        bmWidth As Long
        bmHeight As Long
        bmWidthBytes As Long
        bmPlanes As Integer
        bmBitsPixel As Integer
        bmBits As Long
    End Type
    Private Const BITSPIXEL = 12         '  Number of bits per pixel
    
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
    
    Public Type ICONDIRENTRY
      bWidth As Byte '// Width, in pixels, of the image
      bHeight As Byte '// Height, in pixels, of the image
      bColorCount As Byte '// Number of colors in image (0 if >=8bpp)
      bReserved As Byte '// Reserved ( must be 0)
      wPlanes As Integer '// Color Planes
      wBitCount As Integer '// Bits per pixel
      dwBytesInRes As Long '// How many bytes in this resource?
      dwImageOffset As Long '// Where in the file is this image?
    End Type
    
    Public Type ICONDIR
      idReserved As Integer '// Reserved (must be 0)
      idType As Integer '// Resource Type (1 for icons)
      idCount As Integer '// How many images?
      idEntries() As ICONDIRENTRY '// An entry for each image (idCount of em)
    End Type
    
    Private Type PictDesc
      cbSizeofStruct As Long
      picType As Long
      hImage As Long
      xExt As Long
      yExt As Long
    End Type
    Private Type Guid
      Data1 As Long
      Data2 As Integer
      Data3 As Integer
      Data4(0 To 7) As Byte
    End Type
    
    ' funciones
    Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
    Private Declare Function GetIconInfo Lib "user32" (ByVal hIcon As Long, piconinfo As ICONINFO) As Long
    Private Declare Function GetObjectAPI Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long
    Private Declare Function CreateIconIndirect Lib "user32" (piconinfo As ICONINFO) As Long
    Private Declare Function CreateBitmapIndirect Lib "gdi32" (lpBitmap As BITMAP) As Long
    Private Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hDC As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
    Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal hDC As Long, ByVal nIndex As Long) As Long
    Private Declare Function GetDIBits Lib "gdi32" (ByVal aHDC As Long, ByVal hBitmap As Long, ByVal nStartScan As Long, ByVal nNumScans As Long, lpBits As Any, lpBI As Any, ByVal wUsage As Long) As Long
    Private Declare Function SetDIBits Lib "gdi32" (ByVal hDC As Long, ByVal hBitmap As Long, ByVal nStartScan As Long, ByVal nNumScans As Long, lpBits As Any, lpBI As Any, ByVal wUsage As Long) As Long
    Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (lpvDest As Any, lpvSource As Any, ByVal cbCopy As Long)
    Private Declare Function CreateDCAsNull Lib "gdi32" Alias "CreateDCA" (ByVal lpDriverName As String, lpDeviceName As Any, lpOutput As Any, lpInitData As Any) As Long
    Private Declare Function DeleteDC Lib "gdi32" (ByVal hDC As Long) As Long
    Private Declare Function LoadImage Lib "user32" Alias "LoadImageA" (ByVal hInst As Long, ByVal lpsz As String, ByVal un1 As Long, ByVal n1 As Long, ByVal n2 As Long, ByVal un2 As Long) As Long
    Private Declare Function GetSystemMetrics Lib "user32" (ByVal nIndex As Long) As Long
    Private Declare Function OleCreatePictureIndirect Lib "olepro32.dll" (lpPictDesc As PictDesc, riid As Guid, ByVal fPictureOwnsHandle As Long, ipic As IPicture) As Long

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cWindow"

Public Enum EIconSize
  eisSmall
  eisHuge
  eisImage
  eisShell
  eisDefault
End Enum

Public Enum ImageTypes
  IMAGE_BITMAP = 0
  IMAGE_ICON = 1
  IMAGE_CURSOR = 2
End Enum
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function SerialiseIcon(ByVal lHDC As Long, _
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

Public Function DeSerialiseIcon(ByVal lHDC As Long, _
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

'Public Function LoadAnyPicture(Optional sPicture As String, Optional eis As EIconSize = eisDefault) As Picture
'  Dim hIcon As Long, sExt As String, xy As Long, af As Long
'
'  ' If no picture, return Nothing (clears picture)
'  If sPicture = "" Then Exit Function
'
'  ' Use default LoadPicture for all except icons with argument
'  Dim File As cFile
'  Set File = New cFile
'
'  sExt = File.GetFileExt(sPicture)
'
'  If UCase$(sExt) <> "ICO" Or eis = -1 Then
'    Set LoadAnyPicture = VB.LoadPicture(sPicture)
'    Exit Function
'  End If
'
'  Select Case eis
'    Case eisSmall
'      xy = 16: af = LR_LOADFROMFILE
'    Case eisHuge
'      xy = 48: af = LR_LOADFROMFILE
'    Case eisImage
'      xy = 0: af = LR_LOADFROMFILE Or LR_LOADREALSIZE
'    Case eisShell 'Get icon size from system
'      xy = GetShellIconSize(): af = LR_LOADFROMFILE
'    Case eisDefault
'      xy = 32: af = LR_LOADFROMFILE
'    Case Is > 0   ' Use arbitrary specified size—72 by 72 or whatever
'      xy = eis: af = LR_LOADFROMFILE
'    Case Else     ' Includes eisDefault
'      xy = 0: af = LR_LOADFROMFILE Or LR_DEFAULTSIZE
'  End Select
'
'  hIcon = LoadImage(0&, sPicture, IMAGE_ICON, xy, xy, af)
'
'  ' If this fails, use original load
'  If hIcon <> hNull Then
'    Set LoadAnyPicture = IconToPicture(hIcon)
'  Else
'    Set LoadAnyPicture = VB.LoadPicture(sPicture)
'  End If
'End Function
' funciones friend
' funciones privadas
Private Function SerialiseBitmap(ByVal lHDC As Long, _
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
Private Function DeSerialiseBitmap(ByVal lHDC As Long, _
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
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
Public Function GetIconInfoEx(ByVal FullFileIcon As String) As ICONDIR
  Dim Filename As String
  Dim FNum As Integer
  Dim TempDir As ICONDIR
  Dim GetInfo As Integer
  Dim Msg As String

  ' Put the location of your icon in the next line
  
  FNum = FreeFile

  Filename = FullFileIcon
  
  Open Filename For Binary As #FNum
  With TempDir 'Read header
    Get #FNum, , .idReserved
    Get #FNum, , .idType
    Get #FNum, , .idCount
    If .idCount > 0 Then
      ReDim .idEntries(.idCount - 1) As ICONDIRENTRY
      'Read each entry
      For GetInfo = 0 To .idCount - 1
        Get #FNum, , .idEntries(GetInfo)
      Next GetInfo
    Else 'No images!
      MsgBox "No images defined in icon!"
      Close #FNum
      Exit Function
    End If
  End With
  
  Close #FNum
  
  GetIconInfoEx = TempDir
  
  
'  With TempDir 'Construct info message
'    Msg = .idCount & " image" & IIf(.idCount > 1, "s", "") & ":" & vbCrLf
'    For GetInfo = 0 To .idCount - 1
'      With .idEntries(GetInfo)
'        Msg = Msg & .bWidth & " by " & .bHeight & _
'              " pixels at " & .wBitCount & "bpp (" & _
'              .dwBytesInRes & " bytes)" & _
'              IIf(GetInfo = TempDir.idCount - 1, "", vbCrLf)
'      End With
'    Next GetInfo
'  End With
'
'  MsgBox Msg
End Function

Private Function IconToPicture(ByVal hIcon As Long) As IPicture
   If hIcon = 0 Then Exit Function
   
   Dim oNewPic As Picture
   Dim tPicConv As PictDesc
   Dim IGuid As Guid
   
   With tPicConv
   .cbSizeofStruct = Len(tPicConv)
   .picType = vbPicTypeIcon
   .hImage = hIcon
   End With
   
   ' Fill in magic IPicture GUID {7BF80980-BF32-101A-8BBB-00AA00300CAB}
   With IGuid
    .Data1 = &H7BF80980
    .Data2 = &HBF32
    .Data3 = &H101A
    .Data4(0) = &H8B
    .Data4(1) = &HBB
    .Data4(2) = &H0
    .Data4(3) = &HAA
    .Data4(4) = &H0
    .Data4(5) = &H30
    .Data4(6) = &HC
    .Data4(7) = &HAB
   End With
   OleCreatePictureIndirect tPicConv, IGuid, True, oNewPic
   
   Set IconToPicture = oNewPic
End Function

Private Function GetShellIconSize() As Long
  GetShellIconSize = GetSystemMetrics(SM_CXICON)
End Function

