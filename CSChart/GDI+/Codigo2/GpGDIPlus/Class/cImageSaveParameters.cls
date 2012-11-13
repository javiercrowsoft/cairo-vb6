VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImageSaveParameters"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

' ==================================================================================
' cImageEncoderList.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from Microsoft Platform SDK February 2003
' ==================================================================================

Public Enum GpImageSaveFormat
    GpSaveBMP = 0
    GpSaveJPEG = 1
    GpSaveGIF = 2
    GpSavePNG = 3
    GpSaveTIFF = 4
End Enum

Private m_lngJPEGQuality As Long
Private m_ImageSaveFormat As GpImageSaveFormat

Friend Function GetEncoderCLSID(ByRef clsidEncoder As Clsid) As Boolean
    Dim blnOk As Boolean
    Dim clsEncodeList As New cImageEncoderList
    
    If Not clsEncodeList.Init Then Set clsEncodeList = Nothing: Exit Function
    Select Case m_ImageSaveFormat
           Case GpSaveBMP
             blnOk = clsEncodeList.GetEncoderClsidFromMimeType("image/bmp", clsidEncoder)
           Case GpSaveJPEG
             blnOk = clsEncodeList.GetEncoderClsidFromMimeType("image/jpeg", clsidEncoder)
           Case GpSaveGIF
             blnOk = clsEncodeList.GetEncoderClsidFromMimeType("image/gif", clsidEncoder)
           Case GpSavePNG
             blnOk = clsEncodeList.GetEncoderClsidFromMimeType("image/png", clsidEncoder)
           Case GpSaveTIFF
             blnOk = clsEncodeList.GetEncoderClsidFromMimeType("image/tiff", clsidEncoder)
    End Select
    Set clsEncodeList = Nothing
    GetEncoderCLSID = blnOk
End Function

Friend Function GetEncoderParameters(ByRef EncParams As EncoderParameters) As Boolean
    Select Case m_ImageSaveFormat
           Case GpSaveBMP
             GetEncoderParameters = False
           Case GpSaveJPEG
             With EncParams
                  .count = 1
                  .Parameter.NumberOfValues = 1
                  .Parameter.type = EncoderParameterValueTypeLong
                  .Parameter.Guid = DEFINE_GUID(EncoderQuality)
                  .Parameter.value = VarPtr(m_lngJPEGQuality)
             End With
'             With EncParams(1)
'                  .Count = 1
'                  .Parameter.NumberOfValues = 1
'                  .Parameter.type = EncoderParameterValueTypeLong
'                  .Parameter.Guid = DEFINE_GUID(EncoderTransformation)
'                  .Parameter.value = VarPtr(EncoderValueTransformRotate270)
'             End With
             GetEncoderParameters = True
           Case GpSaveGIF
             GetEncoderParameters = False
           Case GpSavePNG
             GetEncoderParameters = False
           Case GpSaveTIFF
             With EncParams
                  .count = 1
                  .Parameter.NumberOfValues = 1
                  .Parameter.type = EncoderParameterValueTypeLong
                  .Parameter.Guid = DEFINE_GUID(EncoderQuality)
                  .Parameter.value = VarPtr(m_lngJPEGQuality)
             End With
             GetEncoderParameters = True
    End Select
End Function

Public Property Get JPEGQuality() As Long
    JPEGQuality = m_lngJPEGQuality
End Property

Public Property Let JPEGQuality(ByVal NewValue As Long)
    m_lngJPEGQuality = NewValue
End Property

Public Property Get ImageSaveFormat() As GpImageSaveFormat
    ImageSaveFormat = m_ImageSaveFormat
End Property

Public Property Let ImageSaveFormat(ByVal NewValue As GpImageSaveFormat)
    m_ImageSaveFormat = NewValue
End Property

Private Sub Class_Initialize()
    m_ImageSaveFormat = GpSaveJPEG
    m_lngJPEGQuality = 65
End Sub
