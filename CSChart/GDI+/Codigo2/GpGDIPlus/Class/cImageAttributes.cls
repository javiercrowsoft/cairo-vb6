VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cImageAttributes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cImageAttributes.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiPlusimageAttributes.h:Microsoft Platform SDK February 2003
'
' An ImageAttributes object contains information about how bitmap and metafile colors
' are manipulated during rendering. An ImageAttributes object maintains several
' color-adjustment settings, including color-adjustment matrices, grayscale-adjustment
' matrices, gamma-correction values, color-map tables, and color-threshold values.
' ==================================================================================

Private m_lngImageAttr As Long
Private m_uLastStatus As GpStatus

' clears the brush color-remap table of this ImageAttributes object.
Public Function ClearBrushRemapTable() As GpStatus
    ClearBrushRemapTable = ClearRemapTable(ColorAdjustTypeBrush)
End Function

' sets the color remap table for the brush category.
Public Function SetBrushRemapTable(ByVal mapSize As Long, ByRef map() As ColorMap) As GpStatus
    SetBrushRemapTable = SetRemapTable(mapSize, map, ColorAdjustTypeBrush)
End Function

' clears the color key (transparency range) for a specified category.
Public Function ClearColorKey(Optional uType As ColorAdjustType = ColorAdjustTypeDefault) As GpStatus
    m_uLastStatus = GdipSetImageAttributesColorKeys(m_lngImageAttr, uType, False, ByVal 0&, ByVal 0&)
    ClearColorKey = m_uLastStatus
End Function

' sets the color key (transparency range) for a specified category.
Public Function SetColorKey(ByVal colorLow As cColor, _
                            ByVal colorHigh As cColor, _
                            Optional uType As ColorAdjustType = ColorAdjustTypeDefault) _
                            As GpStatus
    m_uLastStatus = GdipSetImageAttributesColorKeys(m_lngImageAttr, _
                                                    uType, _
                                                    True, _
                                                    colorLow.GetValue(), _
                                                    colorHigh.GetValue())
    SetColorKey = m_uLastStatus
End Function

' clears the color-adjustment matrix and the grayscale-adjustment matrix for a specified category.
Public Function ClearColorMatrices(Optional uType As ColorAdjustType = ColorAdjustTypeDefault) As GpStatus
    m_uLastStatus = GdipSetImageAttributesColorMatrix(m_lngImageAttr, _
                                                      uType, _
                                                      False, _
                                                      ByVal 0&, _
                                                      ByVal 0&, _
                                                      ColorMatrixFlagsDefault)
    ClearColorMatrices = m_uLastStatus
End Function

' sets the color-adjustment matrix and the grayscale-adjustment matrix for a specified category.
Public Function SetColorMatrices(ByRef ucolorMatrix As ColorMatrix, _
                                 ByRef ugrayMatrix As ColorMatrix, _
                                 Optional uMode As ColorMatrixFlags = ColorMatrixFlagsDefault, _
                                 Optional uType As ColorAdjustType = ColorAdjustTypeDefault) _
                                 As GpStatus
    m_uLastStatus = GdipSetImageAttributesColorMatrix(m_lngImageAttr, _
                                                      uType, _
                                                      True, _
                                                      ucolorMatrix, _
                                                      ugrayMatrix, _
                                                      uMode)
    SetColorMatrices = m_uLastStatus
End Function

' clears the color-adjustment matrix for a specified category.
Public Function ClearColorMatrix(Optional uType As ColorAdjustType = ColorAdjustTypeDefault) As GpStatus
    m_uLastStatus = GdipSetImageAttributesColorMatrix(m_lngImageAttr, _
                                                      uType, _
                                                      False, _
                                                      ByVal 0&, _
                                                      ByVal 0&, _
                                                      ColorMatrixFlagsDefault)
    ClearColorMatrix = m_uLastStatus
End Function

Public Function SetColorMatrix(ByRef ucolorMatrix As ColorMatrix, _
                               Optional uMode As ColorMatrixFlags = ColorMatrixFlagsDefault, _
                               Optional uType As ColorAdjustType = ColorAdjustTypeDefault) _
                               As GpStatus
    m_uLastStatus = GdipSetImageAttributesColorMatrix(m_lngImageAttr, _
                                                      uType, _
                                                      True, _
                                                      ucolorMatrix, _
                                                      ByVal 0&, _
                                                      uMode)
    SetColorMatrix = m_uLastStatus
End Function

' clears the color-remap table for a specified category
Public Function ClearRemapTable(Optional uType As ColorAdjustType = ColorAdjustTypeDefault) As GpStatus
    m_uLastStatus = GdipSetImageAttributesRemapTable(m_lngImageAttr, uType, False, 0, ByVal 0&)
    ClearRemapTable = m_uLastStatus
End Function

' sets the color-remap table for a specified category
Public Function SetRemapTable(ByVal mapSize As Long, _
                              ByRef map() As ColorMap, _
                              Optional uType As ColorAdjustType = ColorAdjustTypeDefault) _
                              As GpStatus
    m_uLastStatus = GdipSetImageAttributesRemapTable(m_lngImageAttr, uType, True, _
                                                     mapSize, map(LBound(map)))
    SetRemapTable = m_uLastStatus
End Function

' disables gamma correction for a specified category
Public Function ClearGamma(Optional uType As ColorAdjustType = ColorAdjustTypeDefault) As GpStatus
    m_uLastStatus = GdipSetImageAttributesGamma(m_lngImageAttr, uType, False, 0#)
    ClearGamma = m_uLastStatus
End Function

' sets the gamma value for a specified category
Public Function SetGamma(ByVal gamma As Single, _
                         Optional uType As ColorAdjustType = ColorAdjustTypeDefault) _
                         As GpStatus
    m_uLastStatus = GdipSetImageAttributesGamma(m_lngImageAttr, uType, True, gamma)
    SetGamma = m_uLastStatus
End Function

' clears the NoOp setting for a specified category.
Public Function ClearNoOp(Optional uType As ColorAdjustType = ColorAdjustTypeDefault) As GpStatus
    m_uLastStatus = GdipSetImageAttributesNoOp(m_lngImageAttr, uType, False)
    ClearNoOp = m_uLastStatus
End Function

' turns off color adjustment for a specified category.
Public Function SetNoOp(Optional uType As ColorAdjustType = ColorAdjustTypeDefault) As GpStatus
    m_uLastStatus = GdipSetImageAttributesNoOp(m_lngImageAttr, uType, True)
    SetNoOp = m_uLastStatus
End Function

' clears the cyan-magenta-yellow-black (CMYK) output channel setting for a specified category.
Public Function ClearOutputChannel(Optional uType As ColorAdjustType = ColorAdjustTypeDefault) As GpStatus
    m_uLastStatus = GdipSetImageAttributesOutputChannel(m_lngImageAttr, uType, False, ColorChannelFlagsLast)
    ClearOutputChannel = m_uLastStatus
End Function

' sets the CMYK output channel for a specified category.
Public Function SetOutputChannel(ByVal channelFlags As ColorChannelFlags, _
                                 Optional uType As ColorAdjustType = ColorAdjustTypeDefault) _
                                 As GpStatus
    m_uLastStatus = GdipSetImageAttributesOutputChannel(m_lngImageAttr, uType, True, channelFlags)
    SetOutputChannel = m_uLastStatus
End Function

' clears the output channel color profile setting for a specified category.
Public Function ClearOutputChannelColorProfile(Optional uType As ColorAdjustType = ColorAdjustTypeDefault) As GpStatus
    m_uLastStatus = GdipSetImageAttributesOutputChannelColorProfile(m_lngImageAttr, _
                                                                    uType, _
                                                                    False, _
                                                                    ByVal 0&)
    ClearOutputChannelColorProfile = m_uLastStatus
End Function

' sets the output channel color-profile file for a specified category.
Public Function SetOutputChannelColorProfile(ByVal colorProfileFilename As String, _
                                             Optional uType As ColorAdjustType = ColorAdjustTypeDefault) _
                                             As GpStatus
    m_uLastStatus = GdipSetImageAttributesOutputChannelColorProfile(m_lngImageAttr, _
                                                                  uType, _
                                                                  True, _
                                                                  StrConv(colorProfileFilename, vbUnicode))
    SetOutputChannelColorProfile = m_uLastStatus
End Function

' clears the threshold value for a specified category
Public Function ClearThreshold(Optional uType As ColorAdjustType = ColorAdjustTypeDefault) As GpStatus
    m_uLastStatus = GdipSetImageAttributesThreshold(m_lngImageAttr, uType, False, 0#)
    ClearThreshold = m_uLastStatus
End Function

' sets the threshold (transparency range) for a specified category.
Public Function SetThreshold(ByVal threshold As Single, _
                             Optional uType As ColorAdjustType = ColorAdjustTypeDefault) _
                             As GpStatus
    m_uLastStatus = GdipSetImageAttributesThreshold(m_lngImageAttr, uType, True, threshold)
    SetThreshold = m_uLastStatus
End Function

' makes a copy of this ImageAttributes object.
Public Function Clone() As cImageAttributes
    Dim lngImageAttr    As Long
    Dim clsClone        As cImageAttributes
    
    m_uLastStatus = GdipCloneImageAttributes(m_lngImageAttr, lngImageAttr)
    If m_uLastStatus <> Ok Then Set clsClone = Nothing: Exit Function
    Set clsClone = New cImageAttributes
    clsClone.fInitialize (lngImageAttr)
    Set Clone = clsClone
End Function

Public Sub DisposeImageAttributes()
    If m_lngImageAttr <> 0 Then m_uLastStatus = GdipDisposeImageAttributes(m_lngImageAttr): m_lngImageAttr = 0
End Sub

Friend Sub fInitialize(lImageAttr As Long)
    m_lngImageAttr = lImageAttr
End Sub

' adjusts the colors in a palette according to the adjustment settings of a specified category.
Public Function GetAdjustedPalette(ByRef colorPal As ColorPalette, _
                                   Optional uType As ColorAdjustType = ColorAdjustTypeDefault) _
                                   As GpStatus
    m_uLastStatus = GdipGetImageAttributesAdjustedPalette(m_lngImageAttr, colorPal, uType)
    GetAdjustedPalette = m_uLastStatus
End Function

' returns a value that indicates the nature of this ImageAttributes object's most recent method failure.
Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

' clears all color- and grayscale-adjustment settings for a specified category.
Public Function Reset(Optional uType As ColorAdjustType = ColorAdjustTypeDefault) As GpStatus
    m_uLastStatus = GdipResetImageAttributes(m_lngImageAttr, uType)
    Reset = m_uLastStatus
End Function

Public Property Get NativeImageAttributes() As Long
    NativeImageAttributes = m_lngImageAttr
End Property

' sets the color-adjustment matrix of a specified category to identity matrix.
Public Function SetToIdentity(Optional uType As ColorAdjustType = ColorAdjustTypeDefault) As GpStatus
    m_uLastStatus = GdipSetImageAttributesToIdentity(m_lngImageAttr, uType)
    SetToIdentity = m_uLastStatus
End Function

' sets the wrap mode of this ImageAttributes object.
Public Function SetWrapMode(ByVal uWrap As WrapMode, _
                            Optional ByVal color As cColor = Nothing, _
                            Optional ByVal clamp As Boolean = False) As GpStatus
    Dim lArgb As Long
    
    If color Is Nothing Then lArgb = 0 Else lArgb = color.GetValue()
    m_uLastStatus = GdipSetImageAttributesWrapMode(m_lngImageAttr, uWrap, lArgb, clamp)
    SetWrapMode = m_uLastStatus
End Function

Private Sub Class_Initialize()
    Call DisposeImageAttributes
    m_uLastStatus = GdipCreateImageAttributes(m_lngImageAttr)
End Sub

Private Sub Class_Terminate()
    Call DisposeImageAttributes
End Sub
