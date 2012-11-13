VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "GDIPImageEncoderList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Declare Function LocalGdipGetImageEncoders Lib "gdiplus.dll" Alias "GdipGetImageEncoders" _
   (ByVal numEncoders As Long, ByVal size As Long, ByVal lPtrBuf As Long) As GpStatus

Private m_cCodec() As GDIPImageCodec
Private m_count As Long

Public Property Get count() As Long
   count = m_count
End Property

Public Property Get EncoderForExtension(ByVal sExtension As String) As GDIPImageCodec
Dim i As Long
   For i = 1 To m_count
      If (InStr(m_cCodec(i).FilenameExtension, sExtension) > 0) Then
         Set EncoderForExtension = m_cCodec(i)
         Exit For
      End If
   Next i
End Property

Public Property Get EncoderForMimeType(ByVal sMimeType As String) As GDIPImageCodec
Dim i As Long
   For i = 1 To m_count
      If (StrComp(m_cCodec(i).MimeType, sMimeType, vbTextCompare) = 0) Then
         Set EncoderForMimeType = m_cCodec(i)
         Exit For
      End If
   Next i
End Property

Public Property Get Item(ByVal index As Long) As GDIPImageCodec
   If (index > 0) And (index <= m_count) Then
      Set Item = m_cCodec(index)
   Else
      SetStatusHelper InvalidParameter
   End If
End Property

Private Sub Class_Initialize()
Dim num  As Long  ' number of image encoders
Dim size As Long  '// size of the image encoder array in bytes
Dim status As GpStatus
Dim lPtr As Long
Dim p As ImageCodecInfo
Dim lStart As Long
Dim i As Long

   status = GdipGetImageEncodersSize(num, size)
   If (size = 0) Then
      SetStatusHelper status
   Else
      m_count = num
      ReDim m_cCodec(1 To num) As GDIPImageCodec
   
      ReDim b(0 To size - 1) As Byte
      lPtr = VarPtr(b(0))
      status = LocalGdipGetImageEncoders(num, size, lPtr)
      If (SetStatusHelper(status) = Ok) Then
      
         lStart = 0
         For i = 1 To num
            RtlMoveMemory p, b(lStart), Len(p)
            Set m_cCodec(i) = New GDIPImageCodec
            m_cCodec(i).fInit _
               p.CLSID, _
               PtrToString(p.CodecNamePtr), _
               PtrToString(p.DllNamePtr), _
               PtrToString(p.FilenameExtensionPtr), _
               p.Flags, _
               PtrToString(p.FormatDescriptionPtr), _
               p.FormatID, _
               PtrToString(p.MimeTypePtr), _
               p.Version
            lStart = lStart + Len(p)
         Next i
      End If
   End If

End Sub

