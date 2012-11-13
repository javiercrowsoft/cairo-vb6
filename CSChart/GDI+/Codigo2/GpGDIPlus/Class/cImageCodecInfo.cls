VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImageCodecInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

' ==================================================================================
' cImageCodecInfo.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiPlusImageCodec.h:Microsoft Platform SDK February 2003
'
' An ImageCodecInfo object stores information about an image codec (encoder/decoder).
' GDI+ provides several built-in image codecs.
' ==================================================================================

Private m_Clsid                 As Clsid
Private m_FormatID              As Clsid
Private m_lngFlags              As Long
Private m_lngVersion            As Long
Private m_lngSigCount           As Long
Private m_lngSigSize            As Long
Private m_lngSigPattern         As Long
Private m_lngSigMask            As Long
Private m_strCodecName          As String
Private m_strDllName            As String
Private m_strMimeType           As String
Private m_strFormatDescription  As String
Private m_strFilenameExtension  As String

Public Property Get Clsid() As Clsid
    LSet Clsid = m_Clsid
End Property

Public Property Get CodecName() As String
    CodecName = m_strCodecName
End Property

Public Property Get DllName() As String
    DllName = m_strDllName
End Property

Public Property Get FilenameExtension() As String
    FilenameExtension = m_strFilenameExtension
End Property

Friend Sub fInit(CodecInfo As ImageCodecInfo)
    With CodecInfo
         LSet m_Clsid = .ClassID
         LSet m_FormatID = .FormatID
         m_lngFlags = .Flags
         m_lngVersion = .Version
         m_lngSigCount = .SigCount
         m_lngSigSize = .SigSize
         m_lngSigPattern = .SigPattern
         m_lngSigMask = .SigMask
         m_strCodecName = PtrToStrW(.CodecName)
         m_strDllName = PtrToStrW(.DllName)
         m_strMimeType = PtrToStrW(.MimeType)
         m_strFormatDescription = PtrToStrW(.FormatDescription)
         m_strFilenameExtension = PtrToStrW(.FilenameExtension)
    End With
End Sub

Public Property Get Flags() As Long
    Flags = m_lngFlags
End Property

Public Property Get FormatDescription() As String
    FormatDescription = m_strFormatDescription
End Property

Public Property Get FormatID() As Clsid
    LSet FormatID = m_FormatID
End Property

Public Property Get MimeType() As String
    MimeType = m_strMimeType
End Property

Public Property Get SigCount() As Long
    SigCount = m_lngSigCount
End Property

Public Property Get SigMask() As Long
    SigMask = m_lngSigMask
End Property

Public Property Get SigPattern() As Long
    SigPattern = m_lngSigPattern
End Property

Public Property Get SigSize() As Long
    SigSize = m_lngSigSize
End Property

Public Property Get Version() As Long
    Version = m_lngVersion
End Property
