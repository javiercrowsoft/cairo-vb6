VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cGDIPlusGlobal"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
Attribute VB_Ext_KEY = "Top_Level" ,"Yes"
Option Explicit


' ======================================================================================
' Enums:
' ======================================================================================

' Image file format identifiers
Public Enum GpImageFormatIdentifiers
    GpImageFormatUndefined = 0
    GpImageFormatMemoryBMP = 1
    GpImageFormatBMP = 2
    GpImageFormatEMF = 3
    GpImageFormatWMF = 4
    GpImageFormatJPEG = 5
    GpImageFormatPNG = 6
    GpImageFormatGIF = 7
    GpImageFormatTIFF = 8
    GpImageFormatEXIF = 9
    GpImageFormatIcon = 10
End Enum

' NOTE: Enums evaluate to a Long
Public Enum GpStatus   ' aka Status
   Ok = 0
   GenericError = 1
   InvalidParameter = 2
   OutOfMemory = 3
   ObjectBusy = 4
   InsufficientBuffer = 5
   NotImplemented = 6
   Win32Error = 7
   WrongState = 8
   Aborted = 9
   FileNotFound = 10
   ValueOverflow = 11
   AccessDenied = 12
   UnknownImageFormat = 13
   FontFamilyNotFound = 14
   FontStyleNotFound = 15
   NotTrueTypeFont = 16
   UnsupportedGdiplusVersion = 17
   GdiplusNotInitialized = 18
   PropertyNotFound = 19
   PropertyNotSupported = 20
End Enum

Public Enum GpPixelFormat
    PixelFormat1bppIndexed = &H30101
    PixelFormat4bppIndexed = &H30402
    PixelFormat8bppIndexed = &H30803
    PixelFormat16bppGreyScale = &H101004
    PixelFormat16bppRGB555 = &H21005
    PixelFormat16bppRGB565 = &H21006
    PixelFormat16bppARGB1555 = &H61007
    PixelFormat24bppRGB = &H21808
    PixelFormat32bppRGB = &H22009
    PixelFormat32bppARGB = &H26200A
    PixelFormat32bppPARGB = &HE200B
    PixelFormat48bppRGB = &H10300C
    PixelFormat64bppARGB = &H34400D
    PixelFormat64bppPARGB = &H1C400E
End Enum

Public Enum Image_Type
   ImageTypeUnknown = 0
   ImageTypeBitmap = 1
   ImageTypeMetafile = 2
End Enum

' Image property types
Public Enum Image_Property_Types
    PropertyTagTypeByte = 1
    PropertyTagTypeASCII = 2
    PropertyTagTypeShort = 3
    PropertyTagTypeLong = 4
    PropertyTagTypeRational = 5
    PropertyTagTypeUndefined = 7
    PropertyTagTypeSLONG = 9
    PropertyTagTypeSRational = 10
End Enum

' Image property ID tags
Public Enum Image_Property_ID_Tags
    PropertyTagExifIFD = &H8769
    PropertyTagGpsIFD = &H8825

    PropertyTagNewSubfileType = &HFE
    PropertyTagSubfileType = &HFF
    PropertyTagImageWidth = &H100
    PropertyTagImageHeight = &H101
    PropertyTagBitsPerSample = &H102
    PropertyTagCompression = &H103
    PropertyTagPhotometricInterp = &H106
    PropertyTagThreshHolding = &H107
    PropertyTagCellWidth = &H108
    PropertyTagCellHeight = &H109
    PropertyTagFillOrder = &H10A
    PropertyTagDocumentName = &H10D
    PropertyTagImageDescription = &H10E
    PropertyTagEquipMake = &H10F
    PropertyTagEquipModel = &H110
    PropertyTagStripOffsets = &H111
    PropertyTagOrientation = &H112
    PropertyTagSamplesPerPixel = &H115
    PropertyTagRowsPerStrip = &H116
    PropertyTagStripBytesCount = &H117
    PropertyTagMinSampleValue = &H118
    PropertyTagMaxSampleValue = &H119
    PropertyTagXResolution = &H11A            ' Image resolution in width direction
    PropertyTagYResolution = &H11B            ' Image resolution in height direction
    PropertyTagPlanarConfig = &H11C           ' Image data arrangement
    PropertyTagPageName = &H11D
    PropertyTagXPosition = &H11E
    PropertyTagYPosition = &H11F
    PropertyTagFreeOffset = &H120
    PropertyTagFreeByteCounts = &H121
    PropertyTagGrayResponseUnit = &H122
    PropertyTagGrayResponseCurve = &H123
    PropertyTagT4Option = &H124
    PropertyTagT6Option = &H125
    PropertyTagResolutionUnit = &H128         ' Unit of X and Y resolution
    PropertyTagPageNumber = &H129
    PropertyTagTransferFuncition = &H12D
    PropertyTagSoftwareUsed = &H131
    PropertyTagDateTime = &H132
    PropertyTagArtist = &H13B
    PropertyTagHostComputer = &H13C
    PropertyTagPredictor = &H13D
    PropertyTagWhitePoint = &H13E
    PropertyTagPrimaryChromaticities = &H13F
    PropertyTagColorMap = &H140
    PropertyTagHalftoneHints = &H141
    PropertyTagTileWidth = &H142
    PropertyTagTileLength = &H143
    PropertyTagTileOffset = &H144
    PropertyTagTileByteCounts = &H145
    PropertyTagInkSet = &H14C
    PropertyTagInkNames = &H14D
    PropertyTagNumberOfInks = &H14E
    PropertyTagDotRange = &H150
    PropertyTagTargetPrinter = &H151
    PropertyTagExtraSamples = &H152
    PropertyTagSampleFormat = &H153
    PropertyTagSMinSampleValue = &H154
    PropertyTagSMaxSampleValue = &H155
    PropertyTagTransferRange = &H156

    PropertyTagJPEGProc = &H200
    PropertyTagJPEGInterFormat = &H201
    PropertyTagJPEGInterLength = &H202
    PropertyTagJPEGRestartInterval = &H203
    PropertyTagJPEGLosslessPredictors = &H205
    PropertyTagJPEGPointTransforms = &H206
    PropertyTagJPEGQTables = &H207
    PropertyTagJPEGDCTables = &H208
    PropertyTagJPEGACTables = &H209

    PropertyTagYCbCrCoefficients = &H211
    PropertyTagYCbCrSubsampling = &H212
    PropertyTagYCbCrPositioning = &H213
    PropertyTagREFBlackWhite = &H214

    PropertyTagICCProfile = &H8773            ' This TAG is defined by ICC
                                                ' for embedded ICC in TIFF
    PropertyTagGamma = &H301
    PropertyTagICCProfileDescriptor = &H302
    PropertyTagSRGBRenderingIntent = &H303

    PropertyTagImageTitle = &H320
    PropertyTagCopyright = &H8298

' Extra TAGs (Like Adobe Image Information tags etc.)

    PropertyTagResolutionXUnit = &H5001
    PropertyTagResolutionYUnit = &H5002
    PropertyTagResolutionXLengthUnit = &H5003
    PropertyTagResolutionYLengthUnit = &H5004
    PropertyTagPrintFlags = &H5005
    PropertyTagPrintFlagsVersion = &H5006
    PropertyTagPrintFlagsCrop = &H5007
    PropertyTagPrintFlagsBleedWidth = &H5008
    PropertyTagPrintFlagsBleedWidthScale = &H5009
    PropertyTagHalftoneLPI = &H500A
    PropertyTagHalftoneLPIUnit = &H500B
    PropertyTagHalftoneDegree = &H500C
    PropertyTagHalftoneShape = &H500D
    PropertyTagHalftoneMisc = &H500E
    PropertyTagHalftoneScreen = &H500F
    PropertyTagJPEGQuality = &H5010
    PropertyTagGridSize = &H5011
    PropertyTagThumbnailFormat = &H5012            ' 1 = JPEG, 0 = RAW RGB
    PropertyTagThumbnailWidth = &H5013
    PropertyTagThumbnailHeight = &H5014
    PropertyTagThumbnailColorDepth = &H5015
    PropertyTagThumbnailPlanes = &H5016
    PropertyTagThumbnailRawBytes = &H5017
    PropertyTagThumbnailSize = &H5018
    PropertyTagThumbnailCompressedSize = &H5019
    PropertyTagColorTransferFunction = &H501A
    PropertyTagThumbnailData = &H501B            ' RAW thumbnail bits in
                                                   ' JPEG format or RGB format
                                                   ' depends on
                                                   ' PropertyTagThumbnailFormat

' Thumbnail related TAGs
    PropertyTagThumbnailImageWidth = &H5020        ' Thumbnail width
    PropertyTagThumbnailImageHeight = &H5021       ' Thumbnail height
    PropertyTagThumbnailBitsPerSample = &H5022     ' Number of bits per
                                                     ' component
    PropertyTagThumbnailCompression = &H5023       ' Compression Scheme
    PropertyTagThumbnailPhotometricInterp = &H5024 ' Pixel composition
    PropertyTagThumbnailImageDescription = &H5025  ' Image Tile
    PropertyTagThumbnailEquipMake = &H5026         ' Manufacturer of Image
                                                     ' Input equipment
    PropertyTagThumbnailEquipModel = &H5027        ' Model of Image input
                                                     ' equipment
    PropertyTagThumbnailStripOffsets = &H5028      ' Image data location
    PropertyTagThumbnailOrientation = &H5029       ' Orientation of image
    PropertyTagThumbnailSamplesPerPixel = &H502A   ' Number of components
    PropertyTagThumbnailRowsPerStrip = &H502B      ' Number of rows per strip
    PropertyTagThumbnailStripBytesCount = &H502C   ' Bytes per compressed
                                                     ' strip
    PropertyTagThumbnailResolutionX = &H502D       ' Resolution in width
                                                     ' direction
    PropertyTagThumbnailResolutionY = &H502E       ' Resolution in height
                                                     ' direction
    PropertyTagThumbnailPlanarConfig = &H502F      ' Image data arrangement
    PropertyTagThumbnailResolutionUnit = &H5030    ' Unit of X and Y
                                                     ' Resolution
    PropertyTagThumbnailTransferFunction = &H5031  ' Transfer function
    PropertyTagThumbnailSoftwareUsed = &H5032      ' Software used
    PropertyTagThumbnailDateTime = &H5033          ' File change date and
                                                     ' time
    PropertyTagThumbnailArtist = &H5034            ' Person who created the
                                                     ' image
    PropertyTagThumbnailWhitePoint = &H5035        ' White point chromaticity
    PropertyTagThumbnailPrimaryChromaticities = &H5036
                                                     ' Chromaticities of
                                                     ' primaries
    PropertyTagThumbnailYCbCrCoefficients = &H5037 ' Color space transforma-
                                                     ' tion coefficients
    PropertyTagThumbnailYCbCrSubsampling = &H5038  ' Subsampling ratio of Y
                                                     ' to C
    PropertyTagThumbnailYCbCrPositioning = &H5039  ' Y and C position
    PropertyTagThumbnailRefBlackWhite = &H503A     ' Pair of black and white
                                                     ' reference values
    PropertyTagThumbnailCopyRight = &H503B         ' CopyRight holder

    PropertyTagLuminanceTable = &H5090
    PropertyTagChrominanceTable = &H5091

    PropertyTagFrameDelay = &H5100
    PropertyTagLoopCount = &H5101

    PropertyTagPixelUnit = &H5110          ' Unit specifier for pixel/unit
    PropertyTagPixelPerUnitX = &H5111      ' Pixels per unit in X
    PropertyTagPixelPerUnitY = &H5112      ' Pixels per unit in Y
    PropertyTagPaletteHistogram = &H5113   ' Palette histogram

' EXIF specific tag

    PropertyTagExifExposureTime = &H829A
    PropertyTagExifFNumber = &H829D

    PropertyTagExifExposureProg = &H8822
    PropertyTagExifSpectralSense = &H8824
    PropertyTagExifISOSpeed = &H8827
    PropertyTagExifOECF = &H8828

    PropertyTagExifVer = &H9000
    PropertyTagExifDTOrig = &H9003         ' Date & time of original
    PropertyTagExifDTDigitized = &H9004    ' Date & time of digital data generation

    PropertyTagExifCompConfig = &H9101
    PropertyTagExifCompBPP = &H9102

    PropertyTagExifShutterSpeed = &H9201
    PropertyTagExifAperture = &H9202
    PropertyTagExifBrightness = &H9203
    PropertyTagExifExposureBias = &H9204
    PropertyTagExifMaxAperture = &H9205
    PropertyTagExifSubjectDist = &H9206
    PropertyTagExifMeteringMode = &H9207
    PropertyTagExifLightSource = &H9208
    PropertyTagExifFlash = &H9209
    PropertyTagExifFocalLength = &H920A
    PropertyTagExifMakerNote = &H927C
    PropertyTagExifUserComment = &H9286
    PropertyTagExifDTSubsec = &H9290        ' Date & Time subseconds
    PropertyTagExifDTOrigSS = &H9291        ' Date & Time original subseconds
    PropertyTagExifDTDigSS = &H9292         ' Date & TIme digitized subseconds

    PropertyTagExifFPXVer = &HA000
    PropertyTagExifColorSpace = &HA001
    PropertyTagExifPixXDim = &HA002
    PropertyTagExifPixYDim = &HA003
    PropertyTagExifRelatedWav = &HA004      ' related sound file
    PropertyTagExifInterop = &HA005
    PropertyTagExifFlashEnergy = &HA20B
    PropertyTagExifSpatialFR = &HA20C       ' Spatial Frequency Response
    PropertyTagExifFocalXRes = &HA20E       ' Focal Plane X Resolution
    PropertyTagExifFocalYRes = &HA20F       ' Focal Plane Y Resolution
    PropertyTagExifFocalResUnit = &HA210    ' Focal Plane Resolution Unit
    PropertyTagExifSubjectLoc = &HA214
    PropertyTagExifExposureIndex = &HA215
    PropertyTagExifSensingMethod = &HA217
    PropertyTagExifFileSource = &HA300
    PropertyTagExifSceneType = &HA301
    PropertyTagExifCfaPattern = &HA302

    PropertyTagGpsVer = &H0
    PropertyTagGpsLatitudeRef = &H1
    PropertyTagGpsLatitude = &H2
    PropertyTagGpsLongitudeRef = &H3
    PropertyTagGpsLongitude = &H4
    PropertyTagGpsAltitudeRef = &H5
    PropertyTagGpsAltitude = &H6
    PropertyTagGpsGpsTime = &H7
    PropertyTagGpsGpsSatellites = &H8
    PropertyTagGpsGpsStatus = &H9
    PropertyTagGpsGpsMeasureMode = &HA
    PropertyTagGpsGpsDop = &HB              ' Measurement precision
    PropertyTagGpsSpeedRef = &HC
    PropertyTagGpsSpeed = &HD
    PropertyTagGpsTrackRef = &HE
    PropertyTagGpsTrack = &HF
    PropertyTagGpsImgDirRef = &H10
    PropertyTagGpsImgDir = &H11
    PropertyTagGpsMapDatum = &H12
    PropertyTagGpsDestLatRef = &H13
    PropertyTagGpsDestLat = &H14
    PropertyTagGpsDestLongRef = &H15
    PropertyTagGpsDestLong = &H16
    PropertyTagGpsDestBearRef = &H17
    PropertyTagGpsDestBear = &H18
    PropertyTagGpsDestDistRef = &H19
    PropertyTagGpsDestDist = &H1A
End Enum

Public Enum PaletteFlags
   PaletteFlagsHasAlpha = &H1
   PaletteFlagsGrayScale = &H2
   PaletteFlagsHalftone = &H4
End Enum

Public Enum GpUnit  ' aka Unit
   UnitWorld      ' 0 -- World coordinate (non-physical unit)
   UnitDisplay    ' 1 -- Variable -- for PageTransform only
   UnitPixel      ' 2 -- Each unit is one device pixel.
   UnitPoint      ' 3 -- Each unit is a printer's point, or 1/72 inch.
   UnitInch       ' 4 -- Each unit is 1 inch.
   UnitDocument   ' 5 -- Each unit is 1/300 inch.
   UnitMillimeter ' 6 -- Each unit is 1 millimeter.
End Enum

Public Enum PathPointType
    PathPointTypeStart = 0             ' Indicates that the point is the start of a figure.
    PathPointTypeLine = 1              ' Indicates that the point is one of the two endpoints of a line.
    PathPointTypeBezier = 3            ' Indicates that the point is an endpoint or control point of a cubic Bézier spline.
    PathPointTypePathTypeMask = &H7    ' Masks all bits except for the three low-order bits, which indicate the point type.
    PathPointTypePathDashMode = &H10   ' Not used.
    PathPointTypePathMarker = &H20     ' Specifies that the point is a marker.
    PathPointTypeCloseSubpath = &H80   ' Specifies that the point is the last point in a closed subpath (figure).
    PathPointTypeBezier3 = 3           ' Indicates that the point is an endpoint or control point of a cubic Bézier spline.
End Enum

' Information flags about image codecs
Public Enum ImageCodecFlags
   ImageCodecFlagsEncoder = &H1
   ImageCodecFlagsDecoder = &H2
   ImageCodecFlagsSupportBitmap = &H4
   ImageCodecFlagsSupportVector = &H8
   ImageCodecFlagsSeekableEncode = &H10
   ImageCodecFlagsBlockingDecode = &H20

   ImageCodecFlagsBuiltin = &H10000
   ImageCodecFlagsSystem = &H20000
   ImageCodecFlagsUser = &H40000
End Enum

Public Enum RotateFlipType
   RotateNoneFlipNone = 0
   Rotate90FlipNone = 1
   Rotate180FlipNone = 2
   Rotate270FlipNone = 3

   RotateNoneFlipX = 4
   Rotate90FlipX = 5
   Rotate180FlipX = 6
   Rotate270FlipX = 7

   RotateNoneFlipY = Rotate180FlipX
   Rotate90FlipY = Rotate270FlipX
   Rotate180FlipY = RotateNoneFlipX
   Rotate270FlipY = Rotate90FlipX

   RotateNoneFlipXY = Rotate180FlipNone
   Rotate90FlipXY = Rotate270FlipNone
   Rotate180FlipXY = RotateNoneFlipNone
   Rotate270FlipXY = Rotate90FlipNone
End Enum


' Common color constants
' NOTE: Oringinal enum was unnamed
Public Enum colors
   AliceBlue = &HFFF0F8FF
   AntiqueWhite = &HFFFAEBD7
   Aqua = &HFF00FFFF
   Aquamarine = &HFF7FFFD4
   Azure = &HFFF0FFFF
   Beige = &HFFF5F5DC
   Bisque = &HFFFFE4C4
   Black = &HFF000000
   BlanchedAlmond = &HFFFFEBCD
   Blue = &HFF0000FF
   BlueViolet = &HFF8A2BE2
   Brown = &HFFA52A2A
   BurlyWood = &HFFDEB887
   CadetBlue = &HFF5F9EA0
   Chartreuse = &HFF7FFF00
   Chocolate = &HFFD2691E
   Coral = &HFFFF7F50
   CornflowerBlue = &HFF6495ED
   Cornsilk = &HFFFFF8DC
   Crimson = &HFFDC143C
   Cyan = &HFF00FFFF
   DarkBlue = &HFF00008B
   DarkCyan = &HFF008B8B
   DarkGoldenrod = &HFFB8860B
   DarkGray = &HFFA9A9A9
   DarkGreen = &HFF006400
   DarkKhaki = &HFFBDB76B
   DarkMagenta = &HFF8B008B
   DarkOliveGreen = &HFF556B2F
   DarkOrange = &HFFFF8C00
   DarkOrchid = &HFF9932CC
   DarkRed = &HFF8B0000
   DarkSalmon = &HFFE9967A
   DarkSeaGreen = &HFF8FBC8B
   DarkSlateBlue = &HFF483D8B
   DarkSlateGray = &HFF2F4F4F
   DarkTurquoise = &HFF00CED1
   DarkViolet = &HFF9400D3
   DeepPink = &HFFFF1493
   DeepSkyBlue = &HFF00BFFF
   DimGray = &HFF696969
   DodgerBlue = &HFF1E90FF
   Firebrick = &HFFB22222
   FloralWhite = &HFFFFFAF0
   ForestGreen = &HFF228B22
   Fuchsia = &HFFFF00FF
   Gainsboro = &HFFDCDCDC
   GhostWhite = &HFFF8F8FF
   Gold = &HFFFFD700
   Goldenrod = &HFFDAA520
   Gray = &HFF808080
   Green = &HFF008000
   GreenYellow = &HFFADFF2F
   Honeydew = &HFFF0FFF0
   HotPink = &HFFFF69B4
   IndianRed = &HFFCD5C5C
   Indigo = &HFF4B0082
   Ivory = &HFFFFFFF0
   Khaki = &HFFF0E68C
   Lavender = &HFFE6E6FA
   LavenderBlush = &HFFFFF0F5
   LawnGreen = &HFF7CFC00
   LemonChiffon = &HFFFFFACD
   LightBlue = &HFFADD8E6
   LightCoral = &HFFF08080
   LightCyan = &HFFE0FFFF
   LightGoldenrodYellow = &HFFFAFAD2
   LightGray = &HFFD3D3D3
   LightGreen = &HFF90EE90
   LightPink = &HFFFFB6C1
   LightSalmon = &HFFFFA07A
   LightSeaGreen = &HFF20B2AA
   LightSkyBlue = &HFF87CEFA
   LightSlateGray = &HFF778899
   LightSteelBlue = &HFFB0C4DE
   LightYellow = &HFFFFFFE0
   Lime = &HFF00FF00
   LimeGreen = &HFF32CD32
   Linen = &HFFFAF0E6
   Magenta = &HFFFF00FF
   Maroon = &HFF800000
   MediumAquamarine = &HFF66CDAA
   MediumBlue = &HFF0000CD
   MediumOrchid = &HFFBA55D3
   MediumPurple = &HFF9370DB
   MediumSeaGreen = &HFF3CB371
   MediumSlateBlue = &HFF7B68EE
   MediumSpringGreen = &HFF00FA9A
   MediumTurquoise = &HFF48D1CC
   MediumVioletRed = &HFFC71585
   MidnightBlue = &HFF191970
   MintCream = &HFFF5FFFA
   MistyRose = &HFFFFE4E1
   Moccasin = &HFFFFE4B5
   NavajoWhite = &HFFFFDEAD
   Navy = &HFF000080
   OldLace = &HFFFDF5E6
   Olive = &HFF808000
   OliveDrab = &HFF6B8E23
   Orange = &HFFFFA500
   OrangeRed = &HFFFF4500
   Orchid = &HFFDA70D6
   PaleGoldenrod = &HFFEEE8AA
   PaleGreen = &HFF98FB98
   PaleTurquoise = &HFFAFEEEE
   PaleVioletRed = &HFFDB7093
   PapayaWhip = &HFFFFEFD5
   PeachPuff = &HFFFFDAB9
   Peru = &HFFCD853F
   Pink = &HFFFFC0CB
   Plum = &HFFDDA0DD
   PowderBlue = &HFFB0E0E6
   Purple = &HFF800080
   Red = &HFFFF0000
   RosyBrown = &HFFBC8F8F
   RoyalBlue = &HFF4169E1
   SaddleBrown = &HFF8B4513
   Salmon = &HFFFA8072
   SandyBrown = &HFFF4A460
   SeaGreen = &HFF2E8B57
   SeaShell = &HFFFFF5EE
   Sienna = &HFFA0522D
   Silver = &HFFC0C0C0
   SkyBlue = &HFF87CEEB
   SlateBlue = &HFF6A5ACD
   SlateGray = &HFF708090
   Snow = &HFFFFFAFA
   SpringGreen = &HFF00FF7F
   SteelBlue = &HFF4682B4
   Tan = &HFFD2B48C
   Teal = &HFF008080
   Thistle = &HFFD8BFD8
   Tomato = &HFFFF6347
   Transparent = &HFFFFFF
   Turquoise = &HFF40E0D0
   Violet = &HFFEE82EE
   Wheat = &HFFF5DEB3
   White = &HFFFFFFFF
   WhiteSmoke = &HFFF5F5F5
   Yellow = &HFFFFFF00
   YellowGreen = &HFF9ACD32
End Enum

' Color mode
Public Enum ColorMode
    ColorModeARGB32 = 0
    ColorModeARGB64 = 1
End Enum

' Color Channel flags
Public Enum ColorChannelFlags
   ColorChannelFlagsC = 0
   ColorChannelFlagsM
   ColorChannelFlagsY
   ColorChannelFlagsK
   ColorChannelFlagsLast
End Enum

' Shift count and bit mask for A, R, G, B components
Public Enum ColorShiftComponents
    AlphaShift = 24
    RedShift = 16
    GreenShift = 8
    BlueShift = 0
End Enum

Public Enum ColorMaskComponents
    AlphaMask = &HFF000000
    RedMask = &HFF0000
    GreenMask = &HFF00
    BlueMask = &HFF
End Enum

' Quality mode constants
Public Enum QualityMode
   QualityModeInvalid = -1
   QualityModeDefault = 0
   QualityModeLow = 1       ' Best performance
   QualityModeHigh = 2       ' Best rendering quality
End Enum

' Alpha Compositing mode constants
Public Enum CompositingMode
   CompositingModeSourceOver    ' 0
   CompositingModeSourceCopy    ' 1
End Enum

' Alpha Compositing quality constants
Public Enum CompositingQuality
   CompositingQualityInvalid = QualityModeInvalid
   CompositingQualityDefault = QualityModeDefault
   CompositingQualityHighSpeed = QualityModeLow
   CompositingQualityHighQuality = QualityModeHigh
   CompositingQualityGammaCorrected
   CompositingQualityAssumeLinear
End Enum

' Generic font families
Public Enum GenericFontFamily
   GenericFontFamilySerif
   GenericFontFamilySansSerif
   GenericFontFamilyMonospace
End Enum

' FontStyle: face types and common styles
Public Enum FontStyle
   FontStyleRegular = 0
   FontStyleBold = 1
   FontStyleItalic = 2
   FontStyleBoldItalic = 3
   FontStyleUnderline = 4
   FontStyleStrikeout = 8
End Enum

Public Enum SmoothingMode
   SmoothingModeInvalid = QualityModeInvalid
   SmoothingModeDefault = QualityModeDefault
   SmoothingModeHighSpeed = QualityModeLow
   SmoothingModeHighQuality = QualityModeHigh
   SmoothingModeNone
   SmoothingModeAntiAlias
End Enum

Public Enum FillMode
   FillModeAlternate        ' 0
   FillModeWinding           ' 1
End Enum

Public Enum InterpolationMode
   InterpolationModeInvalid = QualityModeInvalid
   InterpolationModeDefault = QualityModeDefault
   InterpolationModeLowQuality = QualityModeLow
   InterpolationModeHighQuality = QualityModeHigh
   InterpolationModeBilinear
   InterpolationModeBicubic
   InterpolationModeNearestNeighbor
   InterpolationModeHighQualityBilinear
   InterpolationModeHighQualityBicubic
End Enum

' Various wrap modes for brushes
Public Enum WrapMode
   WrapModeTile         ' 0
   WrapModeTileFlipX    ' 1
   WrapModeTileFlipY    ' 2
   WrapModeTileFlipXY   ' 3
   WrapModeClamp        ' 4
End Enum

Public Enum LinearGradientMode
   LinearGradientModeHorizontal          ' 0
   LinearGradientModeVertical            ' 1
   LinearGradientModeForwardDiagonal     ' 2
   LinearGradientModeBackwardDiagonal    ' 3
End Enum

' Various Hatch Styles
Public Enum HatchStyle
   HatchStyleHorizontal                   ' 0
   HatchStyleVertical                     ' 1
   HatchStyleForwardDiagonal              ' 2
   HatchStyleBackwardDiagonal             ' 3
   HatchStyleCross                        ' 4
   HatchStyleDiagonalCross                ' 5
   HatchStyle05Percent                    ' 6
   HatchStyle10Percent                    ' 7
   HatchStyle20Percent                    ' 8
   HatchStyle25Percent                    ' 9
   HatchStyle30Percent                    ' 10
   HatchStyle40Percent                    ' 11
   HatchStyle50Percent                    ' 12
   HatchStyle60Percent                    ' 13
   HatchStyle70Percent                    ' 14
   HatchStyle75Percent                    ' 15
   HatchStyle80Percent                    ' 16
   HatchStyle90Percent                    ' 17
   HatchStyleLightDownwardDiagonal        ' 18
   HatchStyleLightUpwardDiagonal          ' 19
   HatchStyleDarkDownwardDiagonal         ' 20
   HatchStyleDarkUpwardDiagonal           ' 21
   HatchStyleWideDownwardDiagonal         ' 22
   HatchStyleWideUpwardDiagonal           ' 23
   HatchStyleLightVertical                ' 24
   HatchStyleLightHorizontal              ' 25
   HatchStyleNarrowVertical               ' 26
   HatchStyleNarrowHorizontal             ' 27
   HatchStyleDarkVertical                 ' 28
   HatchStyleDarkHorizontal               ' 29
   HatchStyleDashedDownwardDiagonal       ' 30
   HatchStyleDashedUpwardDiagonal         ' 31
   HatchStyleDashedHorizontal             ' 32
   HatchStyleDashedVertical               ' 33
   HatchStyleSmallConfetti                ' 34
   HatchStyleLargeConfetti                ' 35
   HatchStyleZigZag                       ' 36
   HatchStyleWave                         ' 37
   HatchStyleDiagonalBrick                ' 38
   HatchStyleHorizontalBrick              ' 39
   HatchStyleWeave                        ' 40
   HatchStylePlaid                        ' 41
   HatchStyleDivot                        ' 42
   HatchStyleDottedGrid                   ' 43
   HatchStyleDottedDiamond                ' 44
   HatchStyleShingle                      ' 45
   HatchStyleTrellis                      ' 46
   HatchStyleSphere                       ' 47
   HatchStyleSmallGrid                    ' 48
   HatchStyleSmallCheckerBoard            ' 49
   HatchStyleLargeCheckerBoard            ' 50
   HatchStyleOutlinedDiamond              ' 51
   HatchStyleSolidDiamond                 ' 52

   HatchStyleTotal
   HatchStyleLargeGrid = HatchStyleCross  ' 4

   HatchStyleMin = HatchStyleHorizontal
   HatchStyleMax = HatchStyleTotal - 1
End Enum

Public Enum MatrixOrder
   MatrixOrderPrepend = 0
   MatrixOrderAppend = 1
End Enum

Public Enum ColorAdjustType
   ColorAdjustTypeDefault
   ColorAdjustTypeBitmap
   ColorAdjustTypeBrush
   ColorAdjustTypePen
   ColorAdjustTypeText
   ColorAdjustTypeCount
   ColorAdjustTypeAny      ' Reserved
End Enum

Public Enum ColorMatrixFlags
   ColorMatrixFlagsDefault = 0
   ColorMatrixFlagsSkipGrays = 1
   ColorMatrixFlagsAltGray = 2
End Enum

Public Enum PenAlignment
    PenAlignmentCenter = 0
    PenAlignmentInset = 1
End Enum

Public Enum BrushType
   BrushTypeSolidColor = 0
   BrushTypeHatchFill = 1
   BrushTypeTextureFill = 2
   BrushTypePathGradient = 3
   BrushTypeLinearGradient = 4
End Enum

Public Enum DashStyle
   DashStyleSolid          ' 0
   DashStyleDash           ' 1
   DashStyleDot            ' 2
   DashStyleDashDot        ' 3
   DashStyleDashDotDot     ' 4
   DashStyleCustom         ' 5
End Enum

' Dash cap constants
Public Enum DashCap
   DashCapFlat = 0
   DashCapRound = 2
   DashCapTriangle = 3
End Enum

' Line cap constants (only the lowest 8 bits are used).
Public Enum LineCap
   LineCapFlat = 0
   LineCapSquare = 1
   LineCapRound = 2
   LineCapTriangle = 3

   LineCapNoAnchor = &H10         ' corresponds to flat cap
   LineCapSquareAnchor = &H11     ' corresponds to square cap
   LineCapRoundAnchor = &H12      ' corresponds to round cap
   LineCapDiamondAnchor = &H13    ' corresponds to triangle cap
   LineCapArrowAnchor = &H14      ' no correspondence

   LineCapCustom = &HFF           ' custom cap

   LineCapAnchorMask = &HF0        ' mask to check for anchor or not.
End Enum

' Custom Line cap type constants
Public Enum CustomLineCapType
   CustomLineCapTypeDefault = 0
   CustomLineCapTypeAdjustableArrow = 1
End Enum

' Line join constants
Public Enum LineJoin
   LineJoinMiter = 0
   LineJoinBevel = 1
   LineJoinRound = 2
   LineJoinMiterClipped = 3
End Enum

' Pen's Fill types
Public Enum PenType
   PenTypeSolidColor = BrushTypeSolidColor
   PenTypeHatchFill = BrushTypeHatchFill
   PenTypeTextureFill = BrushTypeTextureFill
   PenTypePathGradient = BrushTypePathGradient
   PenTypeLinearGradient = BrushTypeLinearGradient
   PenTypeUnknown = -1
End Enum

Public Enum WarpMode
   WarpModePerspective     ' 0
   WarpModeBilinear        ' 1
End Enum

' Region Comine Modes
Public Enum CombineMode
   CombineModeReplace      ' 0
   CombineModeIntersect    ' 1
   CombineModeUnion        ' 2
   CombineModeXor          ' 3
   CombineModeExclude      ' 4
   CombineModeComplement   ' 5 (Exclude From)
End Enum


' String format flags
'
'  DirectionRightToLeft          - For horizontal text, the reading order is
'                                  right to left. This value is called
'                                  the base embedding level by the Unicode
'                                  bidirectional engine.
'                                  For vertical text, columns are read from
'                                  right to left.
'                                  By default, horizontal or vertical text is
'                                  read from left to right.
'
'  DirectionVertical             - Individual lines of text are vertical. In
'                                  each line, characters progress from top to
'                                  bottom.
'                                  By default, lines of text are horizontal,
'                                  each new line below the previous line.
'
'  NoFitBlackBox                 - Allows parts of glyphs to overhang the
'                                  bounding rectangle.
'                                  By default glyphs are first aligned
'                                  inside the margines, then any glyphs which
'                                  still overhang the bounding box are
'                                  repositioned to avoid any overhang.
'                                  For example when an italic
'                                  lower case letter f in a font such as
'                                  Garamond is aligned at the far left of a
'                                  rectangle, the lower part of the f will
'                                  reach slightly further left than the left
'                                  edge of the rectangle. Setting this flag
'                                  will ensure the character aligns visually
'                                  with the lines above and below, but may
'                                  cause some pixels outside the formatting
'                                  rectangle to be clipped or painted.
'
'  DisplayFormatControl          - Causes control characters such as the
'                                  left-to-right mark to be shown in the
'                                  output with a representative glyph.
'
'  NoFontFallback                - Disables fallback to alternate fonts for
'                                  characters not supported in the requested
'                                  font. Any missing characters will be
'                                  be displayed with the fonts missing glyph,
'                                  usually an open square.
'
'  NoWrap                        - Disables wrapping of text between lines
'                                  when formatting within a rectangle.
'                                  NoWrap is implied when a point is passed
'                                  instead of a rectangle, or when the
'                                  specified rectangle has a zero line length.
'
'  NoClip                        - By default text is clipped to the
'                                  formatting rectangle. Setting NoClip
'                                  allows overhanging pixels to affect the
'                                  device outside the formatting rectangle.
'                                  Pixels at the end of the line may be
'                                  affected if the glyphs overhang their
'                                  cells, and either the NoFitBlackBox flag
'                                  has been set, or the glyph extends to far
'                                  to be fitted.
'                                  Pixels above/before the first line or
'                                  below/after the last line may be affected
'                                  if the glyphs extend beyond their cell
'                                  ascent / descent. This can occur rarely
'                                  with unusual diacritic mark combinations.
Public Enum StringFormatFlags
   StringFormatFlagsDirectionRightToLeft = &H1
   StringFormatFlagsDirectionVertical = &H2
   StringFormatFlagsNoFitBlackBox = &H4
   StringFormatFlagsDisplayFormatControl = &H20
   StringFormatFlagsNoFontFallback = &H400
   StringFormatFlagsMeasureTrailingSpaces = &H800
   StringFormatFlagsNoWrap = &H1000
   StringFormatFlagsLineLimit = &H2000

   StringFormatFlagsNoClip = &H4000
End Enum

Public Enum StringTrimming
   StringTrimmingNone = 0
   StringTrimmingCharacter = 1
   StringTrimmingWord = 2
   StringTrimmingEllipsisCharacter = 3
   StringTrimmingEllipsisWord = 4
   StringTrimmingEllipsisPath = 5
End Enum

' National language digit substitution
Public Enum StringDigitSubstitute
   StringDigitSubstituteUser = 0         ' As NLS setting
   StringDigitSubstituteNone = 1
   StringDigitSubstituteNational = 2
   StringDigitSubstituteTraditional = 3
End Enum

' Hotkey prefix interpretation
Public Enum HotkeyPrefix
   HotkeyPrefixNone = 0
   HotkeyPrefixShow = 1
   HotkeyPrefixHide = 2
End Enum

Public Enum StringAlignment
   ' Left edge for left-to-right text,
   ' right for right-to-left text,
   ' and top for vertical
   StringAlignmentNear = 0
   StringAlignmentCenter = 1
   StringAlignmentFar = 2
End Enum

Public Enum FlushIntention
   FlushIntentionFlush = 0         ' Flush all batched rendering operations
   FlushIntentionSync = 1          ' Flush all batched rendering operations
                                   ' and wait for them to complete
End Enum

' Image encoder parameter related types
Public Enum EncoderParameterValueType
   EncoderParameterValueTypeByte = 1              ' 8-bit unsigned int
   EncoderParameterValueTypeASCII = 2             ' 8-bit byte containing one 7-bit ASCII
                                                   ' code. NULL terminated.
   EncoderParameterValueTypeShort = 3             ' 16-bit unsigned int
   EncoderParameterValueTypeLong = 4              ' 32-bit unsigned int
   EncoderParameterValueTypeRational = 5          ' Two Longs. The first Long is the
                                                   ' numerator the second Long expresses the
                                                   ' denomintor.
   EncoderParameterValueTypeLongRange = 6         ' Two longs which specify a range of
                                                   ' integer values. The first Long specifies
                                                   ' the lower end and the second one
                                                   ' specifies the higher end. All values
                                                   ' are inclusive at both ends
   EncoderParameterValueTypeUndefined = 7         ' 8-bit byte that can take any value
                                                   ' depending on field definition
   EncoderParameterValueTypeRationalRange = 8      ' Two Rationals. The first Rational
                                                   ' specifies the lower end and the second
                                                   ' specifies the higher end. All values
                                                   ' are inclusive at both ends
End Enum

' Image encoder value types
Public Enum EncoderValue
   EncoderValueColorTypeCMYK
   EncoderValueColorTypeYCCK
   EncoderValueCompressionLZW
   EncoderValueCompressionCCITT3
   EncoderValueCompressionCCITT4
   EncoderValueCompressionRle
   EncoderValueCompressionNone
   EncoderValueScanMethodInterlaced
   EncoderValueScanMethodNonInterlaced
   EncoderValueVersionGif87
   EncoderValueVersionGif89
   EncoderValueRenderProgressive
   EncoderValueRenderNonProgressive
   EncoderValueTransformRotate90
   EncoderValueTransformRotate180
   EncoderValueTransformRotate270
   EncoderValueTransformFlipHorizontal
   EncoderValueTransformFlipVertical
   EncoderValueMultiFrame
   EncoderValueLastFrame
   EncoderValueFlush
   EncoderValueFrameDimensionTime
   EncoderValueFrameDimensionResolution
   EncoderValueFrameDimensionPage
End Enum

Public Enum PixelOffsetMode
   PixelOffsetModeInvalid = QualityModeInvalid
   PixelOffsetModeDefault = QualityModeDefault
   PixelOffsetModeHighSpeed = QualityModeLow
   PixelOffsetModeHighQuality = QualityModeHigh
   PixelOffsetModeNone    ' No pixel offset
   PixelOffsetModeHalf     ' Offset by -0.5 -0.5 for fast anti-alias perf
End Enum

Public Enum TextRenderingHint
   TextRenderingHintSystemDefault = 0            ' Glyph with system default rendering hint
   TextRenderingHintSingleBitPerPixelGridFit     ' Glyph bitmap with hinting
   TextRenderingHintSingleBitPerPixel            ' Glyph bitmap without hinting
   TextRenderingHintAntiAliasGridFit             ' Glyph anti-alias bitmap with hinting
   TextRenderingHintAntiAlias                    ' Glyph anti-alias bitmap without hinting
   TextRenderingHintClearTypeGridFit              ' Glyph CT bitmap with hinting
End Enum

Public Enum MetafileType
   MetafileTypeInvalid            ' Invalid metafile
   MetafileTypeWmf                ' Standard WMF
   MetafileTypeWmfPlaceable       ' Placeable WMF
   MetafileTypeEmf                ' EMF (not EMF+)
   MetafileTypeEmfPlusOnly        ' EMF+ without dual down-level records
   MetafileTypeEmfPlusDual         ' EMF+ with dual down-level records
End Enum

' Specifies the type of EMF to record
Public Enum EmfType
    EmfTypeEmfOnly = MetafileTypeEmf               ' no EMF+  only EMF
    EmfTypeEmfPlusOnly = MetafileTypeEmfPlusOnly   ' no EMF  only EMF+
    EmfTypeEmfPlusDual = MetafileTypeEmfPlusDual   ' both EMF+ and EMF
End Enum

' EMF+ Persistent object types
Public Enum ObjectType
    ObjectTypeInvalid
    ObjectTypeBrush
    ObjectTypePen
    ObjectTypePath
    ObjectTypeRegion
    ObjectTypeImage
    ObjectTypeFont
    ObjectTypeStringFormat
    ObjectTypeImageAttributes
    ObjectTypeCustomLineCap

    ObjectTypeMax = ObjectTypeCustomLineCap
    ObjectTypeMin = ObjectTypeBrush
End Enum

' The frameRect for creating a metafile can be specified in any of these
' units.  There is an extra frame unit value (MetafileFrameUnitGdi) so
' that units can be supplied in the same units that GDI expects for
' frame rects -- these units are in .01 (1/100ths) millimeter units
' as defined by GDI.
Public Enum MetafileFrameUnit
   MetafileFrameUnitPixel = UnitPixel
   MetafileFrameUnitPoint = UnitPoint
   MetafileFrameUnitInch = UnitInch
   MetafileFrameUnitDocument = UnitDocument
   MetafileFrameUnitMillimeter = UnitMillimeter
   MetafileFrameUnitGdi                        ' GDI compatible .01 MM units
End Enum

' Coordinate space identifiers
Public Enum CoordinateSpace
   CoordinateSpaceWorld     ' 0
   CoordinateSpacePage      ' 1
   CoordinateSpaceDevice     ' 2
End Enum

' Added 12/4/2002
' This enum was translated by: Dana Seaman
Public Enum EmfPlusRecordType
   '//Since we have to enumerate GDI records right along with GDI+ records
   '//We list all the GDI records here so that they can be part of the
   '//same enumeration type which is used in the enumeration callback.
   WmfRecordTypeSetBkColor = &H10201
   WmfRecordTypeSetBkMode = &H10102
   WmfRecordTypeSetMapMode = &H10103
   WmfRecordTypeSetROP2 = &H10104
   WmfRecordTypeSetRelAbs = &H10105
   WmfRecordTypeSetPolyFillMode = &H10106
   WmfRecordTypeSetStretchBltMode = &H10107
   WmfRecordTypeSetTextCharExtra = &H10108
   WmfRecordTypeSetTextColor = &H10209
   WmfRecordTypeSetTextJustification = &H1020A
   WmfRecordTypeSetWindowOrg = &H1020B
   WmfRecordTypeSetWindowExt = &H1020C
   WmfRecordTypeSetViewportOrg = &H1020D
   WmfRecordTypeSetViewportExt = &H1020E
   WmfRecordTypeOffsetWindowOrg = &H1020F
   WmfRecordTypeScaleWindowExt = &H10410
   WmfRecordTypeOffsetViewportOrg = &H10211
   WmfRecordTypeScaleViewportExt = &H10412
   WmfRecordTypeLineTo = &H10213
   WmfRecordTypeMoveTo = &H10214
   WmfRecordTypeExcludeClipRect = &H10415
   WmfRecordTypeIntersectClipRect = &H10416
   WmfRecordTypeArc = &H10817
   WmfRecordTypeEllipse = &H10418
   WmfRecordTypeFloodFill = &H10419
   WmfRecordTypePie = &H1081A
   WmfRecordTypeRectangle = &H1041B
   WmfRecordTypeRoundRect = &H1061C
   WmfRecordTypePatBlt = &H1061D
   WmfRecordTypeSaveDC = &H1001E
   WmfRecordTypeSetPixel = &H1041F
   WmfRecordTypeOffsetClipRgn = &H10220
   WmfRecordTypeTextOut = &H10521
   WmfRecordTypeBitBlt = &H10922
   WmfRecordTypeStretchBlt = &H10B23
   WmfRecordTypePolygon = &H10324
   WmfRecordTypePolyline = &H10325
   WmfRecordTypeEscape = &H10626
   WmfRecordTypeRestoreDC = &H10127
   WmfRecordTypeFillRegion = &H10228
   WmfRecordTypeFrameRegion = &H10429
   WmfRecordTypeInvertRegion = &H1012A
   WmfRecordTypePaintRegion = &H1012B
   WmfRecordTypeSelectClipRegion = &H1012C
   WmfRecordTypeSelectObject = &H1012D
   WmfRecordTypeSetTextAlign = &H1012E
   WmfRecordTypeDrawText = &H1062F
   WmfRecordTypeChord = &H10830
   WmfRecordTypeSetMapperFlags = &H10231
   WmfRecordTypeExtTextOut = &H10A32
   WmfRecordTypeSetDIBToDev = &H10D33
   WmfRecordTypeSelectPalette = &H10234
   WmfRecordTypeRealizePalette = &H10035
   WmfRecordTypeAnimatePalette = &H10436
   WmfRecordTypeSetPalEntries = &H10037
   WmfRecordTypePolyPolygon = &H10538
   WmfRecordTypeResizePalette = &H10139
   WmfRecordTypeDIBBitBlt = &H10940
   WmfRecordTypeDIBStretchBlt = &H10B41
   WmfRecordTypeDIBCreatePatternBrush = &H10142
   WmfRecordTypeStretchDIB = &H10F43
   WmfRecordTypeExtFloodFill = &H10548
   WmfRecordTypeSetLayout = &H10149
   WmfRecordTypeResetDC = &H1014C
   WmfRecordTypeStartDoc = &H1014D
   WmfRecordTypeStartPage = &H1004F
   WmfRecordTypeEndPage = &H10050
   WmfRecordTypeAbortDoc = &H10052
   WmfRecordTypeEndDoc = &H1005E
   WmfRecordTypeDeleteObject = &H101F0
   WmfRecordTypeCreatePalette = &H100F7
   WmfRecordTypeCreateBrush = &H100F8
   WmfRecordTypeCreatePatternBrush = &H101F9
   WmfRecordTypeCreatePenIndirect = &H102FA
   WmfRecordTypeCreateFontIndirect = &H102FB
   WmfRecordTypeCreateBrushIndirect = &H102FC
   WmfRecordTypeCreateBitmapIndirect = &H102FD
   WmfRecordTypeCreateBitmap = &H106FE
   WmfRecordTypeCreateRegion = &H106FF
   EmfRecordTypeHeader = 1
   EmfRecordTypePolyBezier = 2
   EmfRecordTypePolygon = 3
   EmfRecordTypePolyline = 4
   EmfRecordTypePolyBezierTo = 5
   EmfRecordTypePolyLineTo = 6
   EmfRecordTypePolyPolyline = 7
   EmfRecordTypePolyPolygon = 8
   EmfRecordTypeSetWindowExtEx = 9
   EmfRecordTypeSetWindowOrgEx = 10
   EmfRecordTypeSetViewportExtEx = 11
   EmfRecordTypeSetViewportOrgEx = 12
   EmfRecordTypeSetBrushOrgEx = 13
   EmfRecordTypeEOF = 14
   EmfRecordTypeSetPixelV = 15
   EmfRecordTypeSetMapperFlags = 16
   EmfRecordTypeSetMapMode = 17
   EmfRecordTypeSetBkMode = 18
   EmfRecordTypeSetPolyFillMode = 19
   EmfRecordTypeSetROP2 = 20
   EmfRecordTypeSetStretchBltMode = 21
   EmfRecordTypeSetTextAlign = 22
   EmfRecordTypeSetColorAdjustment = 23
   EmfRecordTypeSetTextColor = 24
   EmfRecordTypeSetBkColor = 25
   EmfRecordTypeOffsetClipRgn = 26
   EmfRecordTypeMoveToEx = 27
   EmfRecordTypeSetMetaRgn = 28
   EmfRecordTypeExcludeClipRect = 29
   EmfRecordTypeIntersectClipRect = 30
   EmfRecordTypeScaleViewportExtEx = 31
   EmfRecordTypeScaleWindowExtEx = 32
   EmfRecordTypeSaveDC = 33
   EmfRecordTypeRestoreDC = 34
   EmfRecordTypeSetWorldTransform = 35
   EmfRecordTypeModifyWorldTransform = 36
   EmfRecordTypeSelectObject = 37
   EmfRecordTypeCreatePen = 38
   EmfRecordTypeCreateBrushIndirect = 39
   EmfRecordTypeDeleteObject = 40
   EmfRecordTypeAngleArc = 41
   EmfRecordTypeEllipse = 42
   EmfRecordTypeRectangle = 43
   EmfRecordTypeRoundRect = 44
   EmfRecordTypeArc = 45
   EmfRecordTypeChord = 46
   EmfRecordTypePie = 47
   EmfRecordTypeSelectPalette = 48
   EmfRecordTypeCreatePalette = 49
   EmfRecordTypeSetPaletteEntries = 50
   EmfRecordTypeResizePalette = 51
   EmfRecordTypeRealizePalette = 52
   EmfRecordTypeExtFloodFill = 53
   EmfRecordTypeLineTo = 54
   EmfRecordTypeArcTo = 55
   EmfRecordTypePolyDraw = 56
   EmfRecordTypeSetArcDirection = 57
   EmfRecordTypeSetMiterLimit = 58
   EmfRecordTypeBeginPath = 59
   EmfRecordTypeEndPath = 60
   EmfRecordTypeCloseFigure = 61
   EmfRecordTypeFillPath = 62
   EmfRecordTypeStrokeAndFillPath = 63
   EmfRecordTypeStrokePath = 64
   EmfRecordTypeFlattenPath = 65
   EmfRecordTypeWidenPath = 66
   EmfRecordTypeSelectClipPath = 67
   EmfRecordTypeAbortPath = 68
   EmfRecordTypeReserved_069 = 69
   EmfRecordTypeGdiComment = 70
   EmfRecordTypeFillRgn = 71
   EmfRecordTypeFrameRgn = 72
   EmfRecordTypeInvertRgn = 73
   EmfRecordTypePaintRgn = 74
   EmfRecordTypeExtSelectClipRgn = 75
   EmfRecordTypeBitBlt = 76
   EmfRecordTypeStretchBlt = 77
   EmfRecordTypeMaskBlt = 78
   EmfRecordTypePlgBlt = 79
   EmfRecordTypeSetDIBitsToDevice = 80
   EmfRecordTypeStretchDIBits = 81
   EmfRecordTypeExtCreateFontIndirect = 82
   EmfRecordTypeExtTextOutA = 83
   EmfRecordTypeExtTextOutW = 84
   EmfRecordTypePolyBezier16 = 85
   EmfRecordTypePolygon16 = 86
   EmfRecordTypePolyline16 = 87
   EmfRecordTypePolyBezierTo16 = 88
   EmfRecordTypePolylineTo16 = 89
   EmfRecordTypePolyPolyline16 = 90
   EmfRecordTypePolyPolygon16 = 91
   EmfRecordTypePolyDraw16 = 92
   EmfRecordTypeCreateMonoBrush = 93
   EmfRecordTypeCreateDIBPatternBrushPt = 94
   EmfRecordTypeExtCreatePen = 95
   EmfRecordTypePolyTextOutA = 96
   EmfRecordTypePolyTextOutW = 97
   EmfRecordTypeSetICMMode = 98
   EmfRecordTypeCreateColorSpace = 99
   EmfRecordTypeSetColorSpace = 100
   EmfRecordTypeDeleteColorSpace = 101
   EmfRecordTypeGLSRecord = 102
   EmfRecordTypeGLSBoundedRecord = 103
   EmfRecordTypePixelFormat = 104
   EmfRecordTypeDrawEscape = 105
   EmfRecordTypeExtEscape = 106
   EmfRecordTypeStartDoc = 107
   EmfRecordTypeSmallTextOut = 108
   EmfRecordTypeForceUFIMapping = 109
   EmfRecordTypeNamedEscape = 110
   EmfRecordTypeColorCorrectPalette = 111
   EmfRecordTypeSetICMProfileA = 112
   EmfRecordTypeSetICMProfileW = 113
   EmfRecordTypeAlphaBlend = 114
   EmfRecordTypeSetLayout = 115
   EmfRecordTypeTransparentBlt = 116
   EmfRecordTypeReserved_117 = 117
   EmfRecordTypeGradientFill = 118
   EmfRecordTypeSetLinkedUFIs = 119
   EmfRecordTypeSetTextJustification = 120
   EmfRecordTypeColorMatchToTargetW = 121
   EmfRecordTypeCreateColorSpaceW = 122
   EmfRecordTypeMax = 122
   EmfRecordTypeMin = 1
   '//That is the END of the GDI EMF records.
   '//Now we start the list of EMF+ records.  We leave quite
   '//a bit of room here for the addition of any new GDI
   '//records that may be added later.
   EmfPlusRecordTypeInvalid = 16384 '//GDIP_EMFPLUS_RECORD_BASE
   EmfPlusRecordTypeHeader = 16385
   EmfPlusRecordTypeEndOfFile = 16386
   EmfPlusRecordTypeComment = 16387
   EmfPlusRecordTypeGetDC = 16388
   EmfPlusRecordTypeMultiFormatStart = 16389
   EmfPlusRecordTypeMultiFormatSection = 16390
   EmfPlusRecordTypeMultiFormatEnd = 16391
   '//For all persistent objects
   EmfPlusRecordTypeObject = 16392
   '//Drawing Records
   EmfPlusRecordTypeClear = 16393
   EmfPlusRecordTypeFillRects = 16394
   EmfPlusRecordTypeDrawRects = 16395
   EmfPlusRecordTypeFillPolygon = 16396
   EmfPlusRecordTypeDrawLines = 16397
   EmfPlusRecordTypeFillEllipse = 16398
   EmfPlusRecordTypeDrawEllipse = 16399
   EmfPlusRecordTypeFillPie = 16400
   EmfPlusRecordTypeDrawPie = 16401
   EmfPlusRecordTypeDrawArc = 16402
   EmfPlusRecordTypeFillRegion = 16403
   EmfPlusRecordTypeFillPath = 16404
   EmfPlusRecordTypeDrawPath = 16405
   EmfPlusRecordTypeFillClosedCurve = 16406
   EmfPlusRecordTypeDrawClosedCurve = 16407
   EmfPlusRecordTypeDrawCurve = 16408
   EmfPlusRecordTypeDrawBeziers = 16409
   EmfPlusRecordTypeDrawImage = 16410
   EmfPlusRecordTypeDrawImagePoints = 16411
   EmfPlusRecordTypeDrawString = 16412
   '//Graphics State Records
   EmfPlusRecordTypeSetRenderingOrigin = 16413
   EmfPlusRecordTypeSetAntiAliasMode = 16414
   EmfPlusRecordTypeSetTextRenderingHint = 16415
   EmfPlusRecordTypeSetTextContrast = 16416
   EmfPlusRecordTypeSetInterpolationMode = 16417
   EmfPlusRecordTypeSetPixelOffsetMode = 16418
   EmfPlusRecordTypeSetCompositingMode = 16419
   EmfPlusRecordTypeSetCompositingQuality = 16420
   EmfPlusRecordTypeSave = 16421
   EmfPlusRecordTypeRestore = 16422
   EmfPlusRecordTypeBeginContainer = 16423
   EmfPlusRecordTypeBeginContainerNoParams = 16424
   EmfPlusRecordTypeEndContainer = 16425
   EmfPlusRecordTypeSetWorldTransform = 16426
   EmfPlusRecordTypeResetWorldTransform = 16427
   EmfPlusRecordTypeMultiplyWorldTransform = 16428
   EmfPlusRecordTypeTranslateWorldTransform = 16429
   EmfPlusRecordTypeScaleWorldTransform = 16430
   EmfPlusRecordTypeRotateWorldTransform = 16431
   EmfPlusRecordTypeSetPageTransform = 16432
   EmfPlusRecordTypeResetClip = 16433
   EmfPlusRecordTypeSetClipRect = 16434
   EmfPlusRecordTypeSetClipPath = 16435
   EmfPlusRecordTypeSetClipRegion = 16436
   EmfPlusRecordTypeOffsetClip = 16437
   EmfPlusRecordTypeDrawDriverString = 16438
   EmfPlusRecordTotal = 16439
   EmfPlusRecordTypeMax = 16438
   EmfPlusRecordTypeMin = 16385
End Enum

' Access modes used when calling Image::LockBits (GdipBitmapLockBits API)
Public Enum ImageLockMode
   ImageLockModeRead = &H1
   ImageLockModeWrite = &H2
   ImageLockModeUserInputBuf = &H4
End Enum

Public Enum DebugEventLevel
    DebugEventLevelFatal
    DebugEventLevelWarning
End Enum

' ======================================================================================
' Types:
' ======================================================================================

Public Type Clsid
   Data1 As Long
   Data2 As Integer
   Data3 As Integer
   Data4(0 To 7) As Byte
End Type

Public Type ImageCodecInfo
   ClassID As Clsid
   FormatID As Clsid
   CodecName As Long      ' String Pointer; const WCHAR*
   DllName As Long        ' String Pointer; const WCHAR*
   FormatDescription As Long ' String Pointer; const WCHAR*
   FilenameExtension As Long ' String Pointer; const WCHAR*
   MimeType As Long       ' String Pointer; const WCHAR*
   flags As ImageCodecFlags   ' Should be a Long equivalent
   Version As Long
   SigCount As Long
   SigSize As Long
   SigPattern As Long      ' Byte Array Pointer; BYTE*
   SigMask As Long         ' Byte Array Pointer; BYTE*
End Type

Public Type ColorPalette
   flags As PaletteFlags      ' Palette flags; should be a Long equivalent
   count As Long              ' Number of color entries used
   Entries(0 To 255) As Long  ' Palette color entries. WARNING: SDK defines as 1 entry, but I made it
                              ' contain 256 (a reasonable amount) for use with any palette count 256 or less
                              ' since VB can't malloc and do type casting like C/C++.
End Type

' Encoder Parameter structure
Public Type EncoderParameter
   Guid As Clsid                          ' GUID of the parameter
   NumberOfValues As Long                 ' Number of the parameter values; usually 1
   type As EncoderParameterValueType      ' Value type, like ValueTypeLONG  etc.
   value As Long                          ' A pointer to the parameter values
End Type

' Encoder Parameters structure
Public Type EncoderParameters
   count As Long                          ' Number of parameters in this structure; Should be 1
   Parameter As EncoderParameter          ' Parameter values; this CAN be an array!!!! (Use CopyMemory and a string or byte array as workaround)
End Type


Public Type ColorMap
   oldColor As Long       ' Color oldColor;
   newColor As Long       ' Color newColor;
End Type

Public Type ColorMatrix
   m(0 To 4, 0 To 4) As Single
End Type

' Information about image pixel data
Public Type BitmapData
   Width As Long
   Height As Long
   stride As Long
   PixelFormat As Long
   scan0 As Long
   Reserved As Long
End Type

Public Type PathData
   count As Long
   Points As Long    ' Pointer to POINTF array
   types As Long     ' Pointer to BYTE array
End Type

Public Type PropertyItem
   propId As Long              ' ID of this property
   Length As Long              ' Length of the property value, in bytes
   type As Integer             ' Type of the value, as one of TAG_TYPE_XXX
                               ' defined above
   value As Long               ' property value
End Type

Public Type CharacterRange
   First As Long
   Length As Long
End Type

Public Type PWMFRect16
   Left As Integer
   Top As Integer
   Right As Integer
   Bottom As Integer
End Type

Public Type WmfPlaceableFileHeader
   Key As Long                        ' GDIP_WMF_PLACEABLEKEY
   Hmf As Integer                     ' Metafile HANDLE number (always 0)
   boundingBox As PWMFRect16          ' Coordinates in metafile units
   Inch As Integer                    ' Number of metafile units per inch
   Reserved As Long                   ' Reserved (always 0)
   Checksum As Integer                ' Checksum value for previous 10 WORDs
End Type

Public Type ENHMETAHEADER3
   itype As Long               ' Record type EMR_HEADER
   nSize As Long               ' Record size in bytes.  This may be greater
                               ' than the sizeof(ENHMETAHEADER).
   rclBounds As RECTL        ' Inclusive-inclusive bounds in device units
   rclFrame As RECTL         ' Inclusive-inclusive Picture Frame .01mm unit
   dSignature As Long          ' Signature.  Must be ENHMETA_SIGNATURE.
   nVersion As Long            ' Version number
   nBytes As Long              ' Size of the metafile in bytes
   nRecords As Long            ' Number of records in the metafile
   nHandles As Integer         ' Number of handles in the handle table
                               ' Handle index zero is reserved.
   sReserved As Integer        ' Reserved.  Must be zero.
   nDescription As Long        ' Number of chars in the unicode desc string
                               ' This is 0 if there is no description string
   offDescription As Long      ' Offset to the metafile description record.
                               ' This is 0 if there is no description string
   nPalEntries As Long         ' Number of entries in the metafile palette.
   szlDevice As SIZEL           ' Size of the reference device in pels
   szlMillimeters As SIZEL      ' Size of the reference device in millimeters
End Type

Public Type METAHEADER
   mtType As Integer
   mtHeaderSize As Integer
   mtVersion As Integer
   mtSize As Long
   mtNoObjects As Integer
   mtMaxRecord As Long
   mtNoParameters As Integer
End Type

Public Type MetafileHeader
   mType As MetafileType
   size As Long                ' Size of the metafile (in bytes)
   Version As Long             ' EMF+, EMF, or WMF version
   EmfPlusFlags As Long
   DpiX As Single
   DpiY As Single
   x As Long                   ' Bounds in device units
   y As Long
   Width As Long
   Height As Long
   'Union
   '{
   '    METAHEADER WmfHeader
   '    ENHMETAHEADER3 EmfHeader
   '}
   EmfHeader As ENHMETAHEADER3 ' NOTE: You'll have to use CopyMemory to view the METAHEADER type
   EmfPlusHeaderSize As Long   ' size of the EMF+ header in file
   LogicalDpiX As Long         ' Logical Dpi of reference Hdc
   LogicalDpiY As Long         ' usually valid only for EMF+
End Type

Public Function GDIPlusInitialize() As Boolean
    GDIPlusInitialize = modGDIPlus.GDIPlusInitialize
End Function

Public Sub GDIPlusTerminate()
    modGDIPlus.GDIPlusTerminate
End Sub
