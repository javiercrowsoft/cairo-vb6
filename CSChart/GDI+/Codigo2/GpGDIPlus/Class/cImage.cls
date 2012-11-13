VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit

' ==================================================================================
' cImage.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiPlusImaging.h,GdiPlusBitmap.h:Microsoft Platform SDK February 2003
'
' The Image class provides methods for loading and saving raster images (bitmaps)
' and vector images (metafiles). An Image object encapsulates a bitmap or a metafile
' and stores attributes that you can retrieve by calling various Get methods.
' You can construct Image objects from a variety of file types including BMP,
' ICON, GIF, JPEG, Exif, PNG, TIFF, WMF, and EMF.
' ==================================================================================

Private m_lngImage As Long
Private m_uLastStatus As GpStatus

' creates a new Image object and initializes it with the contents of this Image object
Public Function Clone() As cImage
    Dim lngImage        As Long
    Dim clsClone        As cImage
    
    m_uLastStatus = GdipCloneImage(m_lngImage, lngImage)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cImage
    clsClone.fInitialize (lngImage)
    Set Clone = clsClone
End Function

Public Sub DisposeImage()
    If m_lngImage <> 0 Then m_uLastStatus = GdipDisposeImage(m_lngImage): m_lngImage = 0
End Sub

' Creates an Image object based on a file
Public Function FromFile(ByVal filename As String, _
                         Optional ByVal useEmbeddedColorManagement As Boolean = False) _
                         As GpStatus
    If Trim$(filename) = "" Then m_uLastStatus = InvalidParameter: FromFile = m_uLastStatus: Exit Function
    Call DisposeImage
    If useEmbeddedColorManagement Then
       m_uLastStatus = GdipLoadImageFromFileICM(StrConv(filename, vbUnicode), m_lngImage)
    Else
       m_uLastStatus = GdipLoadImageFromFile(StrConv(filename, vbUnicode), m_lngImage)
    End If
    FromFile = m_uLastStatus
End Function

Friend Sub fInitialize(ByVal Image As Long)
    Call DisposeImage
    m_lngImage = Image
End Sub

' gets all the property items (metadata) stored in this Image object
'Public Function GetAllPropertyItems(ByVal totalBufferSize As GpUnit, _
                                    ByVal numProperties As GpUnit, _
                                    allItems() As PropertyItem) As GpStatus
    '
'End Function

' The GetBounds method gets the bounding rectangle for this image
Public Function GetBounds(ByRef srcRect As cRectF, ByRef srcUnit As GpUnit) As GpStatus
    Dim uR As RECTF
    
    m_uLastStatus = GdipGetImageBounds(m_lngImage, uR, srcUnit)
    If m_uLastStatus = Ok Then
       If srcRect Is Nothing Then Set srcRect = Nothing
       srcRect.CreateFromType uR
    End If
    GetBounds = m_uLastStatus
End Function

Public Function GetEncoderParameterList() As GpStatus
    'GdipGetEncoderParameterList
End Function

Public Function GetEncoderParameterListSize() As Long
    'GdipGetEncoderParameterListSize
End Function

' gets the number of frames in a specified dimension of this Image object.
Public Function GetFrameCount(ByRef dimensionID As Clsid) As Long
    Dim lngCount As Long
    
    m_uLastStatus = GdipImageGetFrameCount(m_lngImage, dimensionID, lngCount)
    GetFrameCount = lngCount
End Function

' gets the number of frame dimensions in this Image object.
Public Function GetFrameDimensionsCount() As Long
    Dim lngCount As Long
    
    m_uLastStatus = GdipImageGetFrameDimensionsCount(m_lngImage, lngCount)
    GetFrameDimensionsCount = lngCount
End Function

' gets the identifiers for the frame dimensions of this Image object.
Public Function GetFrameDimensionsList(ByRef dimensionIDs() As Clsid, ByVal count As Long) As GpStatus
    ReDim dimensionIDs(0 To count - 1)
    m_uLastStatus = GdipImageGetFrameDimensionsList(m_lngImage, dimensionIDs(0), count)
    GetFrameDimensionsList = m_uLastStatus
End Function

' gets the image height, in pixels, of this image.
Public Function GetHeight() As Long
    Dim lngHeight As Long
    
    m_uLastStatus = GdipGetImageHeight(m_lngImage, lngHeight)
    GetHeight = lngHeight
End Function

' gets the horizontal resolution, in dots per inch, of this image
Public Function GetHorizontalResolution() As Single
    Dim sngRes As Single
    
    m_uLastStatus = GdipGetImageHorizontalResolution(m_lngImage, sngRes)
    GetHorizontalResolution = sngRes
End Function

' returns a value that indicates the nature of this Image object's most recent method failure.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' gets the color palette of this Image object
Public Function GetPalette(ByRef palette As ColorPalette, ByVal size As Long) As GpStatus
    m_uLastStatus = GdipGetImagePalette(m_lngImage, palette, size)
    GetPalette = m_uLastStatus
End Function

' gets the size, in bytes, of the color palette of this Image object.
Public Function GetPaletteSize() As Long
    Dim lngSize As Long
    
    m_uLastStatus = GdipGetImagePaletteSize(m_lngImage, lngSize)
    GetPaletteSize = lngSize
End Function

' gets the width and height of this image.
Public Function GetPhysicalDimension(uSizef As SIZEF) As GpStatus
    m_uLastStatus = GdipGetImageDimension(m_lngImage, uSizef.cx, uSizef.cy)
    GetPhysicalDimension = m_uLastStatus
End Function

' gets the pixel format of this Image object.
Public Function GetPixelFormat() As GpPixelFormat
    Dim uFormat As GpPixelFormat
    
    m_uLastStatus = GdipGetImagePixelFormat(m_lngImage, uFormat)
    GetPixelFormat = uFormat
End Function

' gets the number of properties (pieces of metadata) stored in this Image object.
Public Function GetPropertyCount() As Long
    Dim lngCount As Long
    
    m_uLastStatus = GdipGetPropertyCount(m_lngImage, lngCount)
    GetPropertyCount = lngCount
End Function

' gets a list of the property identifiers used in the metadata of this Image object.
Public Function GetPropertyIdList(PropertyIdList() As Long) As GpStatus
    Dim lngCount As Long
    Dim lPtr As Long
    
    m_uLastStatus = GdipGetPropertyCount(m_lngImage, lngCount)
    If m_uLastStatus = Ok Then
       ReDim PropertyIdList(0 To lngCount - 1)
       lPtr = VarPtr(PropertyIdList(0))
       m_uLastStatus = GdipGetPropertyIdList(m_lngImage, lngCount, lPtr)
    End If
    GetPropertyIdList = m_uLastStatus
End Function

'gets a specified property item (piece of metadata) from this Image object.
Public Function GetPropertyItem(ByVal propId As Long, ByVal propSize As Long) As cPropertyItem
    Dim uP                      As PropertyItem
    Dim clsItem                 As cPropertyItem
    
    m_uLastStatus = GdipGetPropertyItem(m_lngImage, propId, propSize, uP)
    If m_uLastStatus <> Ok Then Exit Function
    Set clsItem = New cPropertyItem
    With uP
         clsItem.fInitialize .propId, .Length, .type, .value, propSize
    End With
    Set GetPropertyItem = clsItem
End Function

' gets the size, in bytes, of a specified property item of this Image object.
Public Function GetPropertyItemSize(ByVal propId As Long) As Long
    Dim lngSize As Long
    
    m_uLastStatus = GdipGetPropertyItemSize(m_lngImage, propId, lngSize)
    GetPropertyItemSize = lngSize
End Function

' The GetPropertySize method gets the total size, in bytes,
' of all the property items stored in this Image object.
' The GetPropertySize method also gets the number of property
' items stored in this Image object.
Public Function GetPropertySize(totalBufferSize As Long, numProperties As Long) As GpStatus
    m_uLastStatus = GdipGetPropertySize(m_lngImage, totalBufferSize, numProperties)
    GetPropertySize = m_uLastStatus
End Function

'gets identifies the format of this Image object.
Public Function GetRawFormat() As GpImageFormatIdentifiers
    Dim FormatID As Clsid
    m_uLastStatus = GdipGetImageRawFormat(m_lngImage, FormatID)
    Select Case GetGuidString(FormatID)
           Case ImageFormatUndefined
             GetRawFormat = GpImageFormatUndefined
           Case ImageFormatMemoryBMP
             GetRawFormat = GpImageFormatMemoryBMP
           Case ImageFormatBMP
             GetRawFormat = GpImageFormatBMP
           Case ImageFormatEMF
             GetRawFormat = GpImageFormatEMF
           Case ImageFormatWMF
             GetRawFormat = GpImageFormatWMF
           Case ImageFormatJPEG
             GetRawFormat = GpImageFormatJPEG
           Case ImageFormatPNG
             GetRawFormat = GpImageFormatPNG
           Case ImageFormatGIF
             GetRawFormat = GpImageFormatGIF
           Case ImageFormatTIFF
             GetRawFormat = GpImageFormatTIFF
           Case ImageFormatEXIF
             GetRawFormat = GpImageFormatEXIF
           Case ImageFormatIcon
             GetRawFormat = GpImageFormatIcon
    End Select
End Function

' gets a thumbnail image from this Image object.
Public Function GetThumbnailImage(ByVal thumbWidth As Long, _
                                  ByVal thumbHeight As Long, _
                                  Optional ByVal callback As Long = 0, _
                                  Optional ByVal callbackData As Long = 0) As cImage
    Dim lngThumbnail              As Long
    Dim clsThumbnail              As cImage
    
    m_uLastStatus = GdipGetImageThumbnail(m_lngImage, thumbWidth, thumbHeight, _
                                         lngThumbnail, callback, callbackData)
    If m_uLastStatus <> Ok Then Exit Function
    Set clsThumbnail = New cImage
    clsThumbnail.fInitialize lngThumbnail
    Set GetThumbnailImage = clsThumbnail
End Function

' gets the type (bitmap or metafile) of this Image object.
Public Function GetType() As Image_Type
    Dim uImageType As Image_Type
    
    uImageType = ImageTypeUnknown
    m_uLastStatus = GdipGetImageType(m_lngImage, uImageType)
    GetType = uImageType
End Function

' gets the vertical resolution, in dots per inch, of this image.
Public Function GetVerticalResolution() As Single
    Dim sngRes As Single
    
    m_uLastStatus = GdipGetImageVerticalResolution(m_lngImage, sngRes)
    GetVerticalResolution = sngRes
End Function

' gets the width, in pixels, of this image
Public Function GetWidth() As Long
    Dim lngWidth As Long
    
    m_uLastStatus = GdipGetImageWidth(m_lngImage, lngWidth)
    GetWidth = lngWidth
End Function

Public Property Get NativeImage() As Long
Attribute NativeImage.VB_UserMemId = 0
    NativeImage = m_lngImage
End Property

' removes a property item (piece of metadata) from this Image object.
Public Function RemovePropertyItem(ByVal propId As Long) As GpStatus
    m_uLastStatus = GdipRemovePropertyItem(m_lngImage, propId)
    RemovePropertyItem = m_uLastStatus
End Function

' rotates and flips this image
Public Function RotateFlip(ByVal RotateFlipValue As RotateFlipType) As GpStatus
    m_uLastStatus = GdipImageRotateFlip(m_lngImage, RotateFlipValue)
    RotateFlip = m_uLastStatus
End Function

Public Function SaveImageToFile(ByVal filename As String, Optional ByVal SaveParameters As cImageSaveParameters = Nothing) As Boolean
    Dim uclsidEncoder As Clsid
    Dim uencoderParams As EncoderParameters
    
    ' Esto esta dos veces por que la primera vez
    ' falla, asi que le agregue esta llamada
    ' parasita
    '
    SaveParameters.GetEncoderCLSID uclsidEncoder
    
    If SaveParameters.GetEncoderCLSID(uclsidEncoder) = False Then Exit Function
    If SaveParameters.GetEncoderParameters(uencoderParams) Then
       m_uLastStatus = GdipSaveImageToFile(m_lngImage, StrConv(filename, vbUnicode), uclsidEncoder, uencoderParams)
    Else
       m_uLastStatus = GdipSaveImageToFile(m_lngImage, StrConv(filename, vbUnicode), uclsidEncoder, ByVal 0&)
    End If
    If m_uLastStatus <> Ok Then Exit Function
    SaveImageToFile = True
End Function

'GdipSaveAdd
'GdipSaveAddImage
'public function GdipSaveAdd

' selects the frame in this Image object specified by a dimension and an index.
Public Function SelectActiveFrame(ByRef dimensionID As Clsid, ByVal frameIndex As Long) As GpStatus
    m_uLastStatus = GdipImageSelectActiveFrame(m_lngImage, dimensionID, frameIndex)
End Function

' sets the color palette of this Image object
Public Function SetPalette(ByRef palette As ColorPalette) As GpStatus
    m_uLastStatus = GdipSetImagePalette(m_lngImage, palette)
    SetPalette = m_uLastStatus
End Function

' sets a property item (piece of metadata) for this Image object.
' If the item already exists, then its contents are updated; otherwise, a new item is added.
Public Function SetPropertyItem(ByVal Item As cPropertyItem) As GpStatus
    '
End Function

Private Sub Class_Initialize()
    Call DisposeImage
End Sub

Private Sub Class_Terminate()
    Call DisposeImage
End Sub


