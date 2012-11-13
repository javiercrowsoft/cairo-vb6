Attribute VB_Name = "mImage"
Option Explicit

'--------------------------------------------------------------------------------
' mImage
' 22-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    Private Const BITSPIXEL = 12
    Private Const BI_RGB = 0&
    Private Const BI_RLE4 = 2&
    Private Const BI_RLE8 = 1&
    Private Const DIB_RGB_COLORS = 0 '  color table in RGBs
    ' estructuras
    Private Type BITMAP '14 bytes
      bmType As Long
      bmWidth As Long
      bmHeight As Long
      bmWidthBytes As Long
      bmPlanes As Integer
      bmBitsPixel As Integer
      bmBits As Long
    End Type
    
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
    ' funciones
    Private Declare Function GetObjectAPI Lib "gdi32" Alias "GetObjectA" (ByVal hObject As Long, ByVal nCount As Long, lpObject As Any) As Long
    Private Declare Sub CopyMemory Lib "KERNEL32" Alias "RtlMoveMemory" (lpvDest As Any, lpvSource As Any, ByVal cbCopy As Long)
    Private Declare Function GetDIBits Lib "gdi32" (ByVal aHDC As Long, ByVal hBitmap As Long, ByVal nStartScan As Long, ByVal nNumScans As Long, lpBits As Any, lpBI As Any, ByVal wUsage As Long) As Long
    Private Declare Function SetDIBits Lib "gdi32" (ByVal hDC As Long, ByVal hBitmap As Long, ByVal nStartScan As Long, ByVal nNumScans As Long, lpBits As Any, lpBI As Any, ByVal wUsage As Long) As Long
    Private Declare Function GetLastError Lib "KERNEL32" () As Long
    Private Declare Function CreateCompatibleDC Lib "gdi32" (ByVal hDC As Long) As Long
    Private Declare Function CreateCompatibleBitmap Lib "gdi32" (ByVal hDC As Long, ByVal nWidth As Long, ByVal nHeight As Long) As Long
    Private Declare Function CreateDCAsNull Lib "gdi32" Alias "CreateDCA" (ByVal lpDriverName As String, lpDeviceName As Any, lpOutput As Any, lpInitData As Any) As Long
    Private Declare Function SelectObject Lib "gdi32" (ByVal hDC As Long, ByVal hObject As Long) As Long
    Private Declare Function CreateBitmapIndirect Lib "gdi32" (lpBitmap As BITMAP) As Long
    Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
    Private Declare Function GetDeviceCaps Lib "gdi32" (ByVal hDC As Long, ByVal nIndex As Long) As Long
    Public Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mImage"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function SerialiseBitmap(ByVal hBmp As Long, _
                                ByRef vBytes() As Byte) As Boolean
  Dim tBM     As BITMAP
  Dim tBI1    As BITMAPINFO_1BPP
  Dim tBI4    As BITMAPINFO_4BPP
  Dim tBI8    As BITMAPINFO_8BPP
  Dim tBI     As BITMAPINFO_ABOVE8
  Dim lSize   As Long
  Dim lR      As Long
  Dim hDC     As Long
  Dim hDCNULL As Long
  Dim hOldBmp As Long
   
  ' Get the BITMAP structure:
  lR = GetObjectAPI(hBmp, Len(tBM), tBM)
  If (lR <> 0) Then
  
    ' Create a bitmap info structure:
    With tBI.bmiHeader
      .biSize = Len(tBI.bmiHeader)
      .biWidth = tBM.bmWidth
      .biHeight = tBM.bmHeight
      .biPlanes = 1
      .biBitCount = 24
      .biCompression = BI_RGB
    End With
    
    ' Get the Bitmap bits into the byte array:
    lSize = (((tBI.bmiHeader.biWidth * tBI.bmiHeader.biBitCount + 31) \ 32) * 4) * tBI.bmiHeader.biHeight
    ReDim Preserve vBytes(Len(tBM) + lSize)
    
    ' Store the BITMAP structure:
    CopyMemory vBytes(0), tBM, Len(tBM)

    hDCNULL = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
    hDC = CreateCompatibleDC(hDCNULL)
    DeleteDC hDCNULL
    
    hOldBmp = SelectObject(hDC, hBmp)
    lR = GetDIBits(hDC, hBmp, 0, tBM.bmHeight, vBytes(Len(tBM)), tBI, DIB_RGB_COLORS)
    
    SelectObject hDC, hOldBmp
    DeleteDC hDC
    
    ' Succes
    SerialiseBitmap = lR <> 0
  End If
End Function

Public Function CopyBitmap(ByVal hBmp As Long, _
                           ByVal Width As Long, ByVal Height As Long, _
                           ByVal hCurrentBmp As Long) As Long
  Dim hDCDest   As Long
  Dim hBmpOld   As Long
  Dim hDCSource As Long
  Dim hDCNULL   As Long
  
  hDCNULL = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
  hDCSource = CreateCompatibleDC(hDCNULL)
  DeleteObject SelectObject(hDCSource, hBmp)
  DeleteDC hDCNULL
  
  hDCDest = CreateCompatibleDC(hDCSource)
  hBmp = CreateCompatibleBitmap(hDCSource, Width, Height)
  hBmpOld = SelectObject(hDCDest, hBmp)
  
  BitBlt hDCDest, 0, 0, Width, Height, hDCSource, 0, 0, vbSrcCopy
  
  SelectObject hDCDest, hBmpOld
  DeleteObject hDCDest
  
  If hCurrentBmp <> 0 Then
    DeleteObject hCurrentBmp
  End If
  
  CopyBitmap = hBmp
End Function

Public Function DeSerialiseBitmap(ByRef hBmp As Long, _
                                  ByRef vBytes() As Byte) As Boolean
  Dim tBM   As BITMAP
  Dim tBI1  As BITMAPINFO_1BPP
  Dim tBI4  As BITMAPINFO_4BPP
  Dim tBI8  As BITMAPINFO_8BPP
  Dim tBI   As BITMAPINFO_ABOVE8
  Dim lR    As Long
  Dim hDC   As Long
  Dim hDCNULL     As Long
  Dim hOldBmp     As Long
  Dim bitsXpixel  As Long
  
  ' Get the BITMAP structure:
  CopyMemory tBM, vBytes(0), Len(tBM)
  
  hDCNULL = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
  hDC = CreateCompatibleDC(hDCNULL)
  DeleteDC hDCNULL
  
  ' Modificamos la estructura BITMAP para
  ' que se adapte a la resolucion actual
  bitsXpixel = GetDeviceCaps(hDC, BITSPIXEL)
  
  tBM.bmBitsPixel = bitsXpixel
  tBM.bmWidthBytes = (Fix(((tBM.bmWidth * (bitsXpixel / 8)) + 1) / 2)) * 2
  
  ' Create the bitmap:
  hBmp = CreateBitmapIndirect(tBM)
  If (hBmp <> 0) Then
    ' Get the Bitmap bits from the byte array:
    With tBI.bmiHeader
      .biSize = Len(tBI.bmiHeader)
      .biWidth = tBM.bmWidth
      .biHeight = tBM.bmHeight
      .biPlanes = 1
      .biBitCount = 24
      .biCompression = BI_RGB
    End With
    
    lR = SetDIBits(hDC, hBmp, 0, tBM.bmHeight, vBytes(Len(tBM)), tBI, DIB_RGB_COLORS)
    
    If (lR <> 0) Then
      DeSerialiseBitmap = True
    Else
      DeleteObject hBmp
    End If
  End If
  
  DeleteDC hDC
End Function
          
' funciones friend
' funciones privadas
' construccion - destruccion
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

