VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTextureBrush"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' ==================================================================================
' cTextureBrush.cls
' Copyright © 2003 Genghis Khan(GuangJian Guo)
' Website: http://www.itkhan.com
'
' from GdiPlusBrush.h:Microsoft Platform SDK February 2003
'
' The TextureBrush class defines a Brush object that contains an Image object that
' is used for the fill. The fill image can be transformed by using the local Matrix
' object contained in the Brush object.
' ==================================================================================

Private m_clsBrush As cBrush
Private m_uLastStatus As GpStatus

Public Property Get Brush() As cBrush
    Set Brush = m_clsBrush
End Property

Public Function Clone() As cTextureBrush
    Dim lClone As Long
    Dim clsCs As cTextureBrush
    
    m_uLastStatus = GdipCloneBrush(m_clsBrush.NativeBrush, lClone)
    If m_uLastStatus <> Ok Then Exit Function
    Set clsCs = New cTextureBrush
    clsCs.Brush.fInitialize (lClone)
    Set Clone = clsCs
End Function

' Creates a TextureBrush object based on an image and a wrap mode.
' The size of the brush defaults to the size of the image,
' so the entire image is used by the brush
Public Function Create(ByVal Image As cImage, _
                       Optional uWrapMode As WrapMode = WrapModeTile) As GpStatus
    Dim lBrush As Long
    
    Call DisposeTextureBrush
    If Image Is Nothing Then m_uLastStatus = InvalidParameter: Create = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCreateTexture(Image.NativeImage, uWrapMode, lBrush)
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize (lBrush)
    Create = m_uLastStatus
End Function

' Creates a TextureBrush object based on an image, a wrap mode, and a defining set of coordinates.
Public Function CreateSizeF(ByVal Image As cImage, _
                            ByVal uWrapMode As WrapMode, _
                            ByVal dstX As Single, _
                            ByVal dstY As Single, _
                            ByVal dstWidth As Single, _
                            ByVal dstHeight As Single) As GpStatus
    Dim lBrush As Long
    
    Call DisposeTextureBrush
    If Image Is Nothing Then m_uLastStatus = InvalidParameter: CreateSizeF = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCreateTexture2(Image.NativeImage, uWrapMode, dstX, dstY, _
                                       dstWidth, dstHeight, lBrush)
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize (lBrush)
    CreateSizeF = m_uLastStatus
End Function

' Creates a TextureBrush object based on an image, a wrap mode, and a defining set of coordinates.
Public Function CreateSizeL(ByVal Image As cImage, _
                            ByVal uWrapMode As WrapMode, _
                            ByVal dstX As Long, _
                            ByVal dstY As Long, _
                            ByVal dstWidth As Long, _
                            ByVal dstHeight As Long) As GpStatus
    Dim lBrush As Long
    
    Call DisposeTextureBrush
    If Image Is Nothing Then m_uLastStatus = InvalidParameter: CreateSizeL = m_uLastStatus: Exit Function
    m_uLastStatus = GdipCreateTexture2I(Image.NativeImage, uWrapMode, dstX, dstY, _
                                       dstWidth, dstHeight, lBrush)
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize (lBrush)
    CreateSizeL = m_uLastStatus
End Function

' Creates a TextureBrush object based on an image, a wrap mode, and a defining rectangle.
Public Function CreateRectF(ByVal Image As cImage, _
                            ByVal uWrapMode As WrapMode, _
                            ByVal dstRect As cRectF) As GpStatus
    If dstRect Is Nothing Then m_uLastStatus = InvalidParameter: CreateRectF = m_uLastStatus: Exit Function
    CreateRectF = CreateSizeF(Image, uWrapMode, _
                              dstRect.Left, _
                              dstRect.Top, _
                              dstRect.Width, _
                              dstRect.Height)
End Function

' Creates a TextureBrush object based on an image, a wrap mode, and a defining rectangle.
Public Function CreateRectL(ByVal Image As cImage, _
                            ByVal uWrapMode As WrapMode, _
                            ByVal dstRect As cRect) As GpStatus
    If dstRect Is Nothing Then m_uLastStatus = InvalidParameter: CreateRectL = m_uLastStatus: Exit Function
    CreateRectL = CreateSizeL(Image, uWrapMode, _
                              dstRect.Left, _
                              dstRect.Top, _
                              dstRect.Width, _
                              dstRect.Height)
End Function

' Creates a TextureBrush object based on an image, a defining rectangle, and a set of image properties.
Public Function CreateImageAttributesF(ByVal Image As cImage, _
                                       ByVal dstRect As cRectF, _
                                       Optional imageAttributes As cImageAttributes = Nothing) _
                                       As GpStatus
    Dim lBrush As Long
    
    If Image Is Nothing Then m_uLastStatus = InvalidParameter: CreateImageAttributesF = m_uLastStatus: Exit Function
    If dstRect Is Nothing Then m_uLastStatus = InvalidParameter: CreateImageAttributesF = m_uLastStatus: Exit Function
    Call DisposeTextureBrush
    If imageAttributes Is Nothing Then
       m_uLastStatus = GdipCreateTextureIA(Image.NativeImage, ByVal 0&, _
                                         dstRect.Left, dstRect.Top, _
                                         dstRect.Width, dstRect.Height, _
                                         lBrush)
    Else
       m_uLastStatus = GdipCreateTextureIA(Image.NativeImage, _
                                           imageAttributes.NativeImageAttributes, _
                                           dstRect.Left, dstRect.Top, _
                                           dstRect.Width, dstRect.Height, _
                                           lBrush)
    End If
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize (lBrush)
    CreateImageAttributesF = m_uLastStatus
End Function

' Creates a TextureBrush object based on an image, a defining rectangle, and a set of image properties.
Public Function CreateImageAttributesL(ByVal Image As cImage, _
                                       ByVal dstRect As cRect, _
                                       Optional imageAttributes As cImageAttributes = Nothing) _
                                       As GpStatus
    Dim lBrush As Long
    
    If Image Is Nothing Then m_uLastStatus = InvalidParameter: CreateImageAttributesL = m_uLastStatus: Exit Function
    If dstRect Is Nothing Then m_uLastStatus = InvalidParameter: CreateImageAttributesL = m_uLastStatus: Exit Function
    Call DisposeTextureBrush
    If imageAttributes Is Nothing Then
       m_uLastStatus = GdipCreateTextureIAI(Image.NativeImage, ByVal 0&, _
                                         dstRect.Left, dstRect.Top, _
                                         dstRect.Width, dstRect.Height, _
                                         lBrush)
    Else
       m_uLastStatus = GdipCreateTextureIAI(Image.NativeImage, _
                                           imageAttributes.NativeImageAttributes, _
                                           dstRect.Left, dstRect.Top, _
                                           dstRect.Width, dstRect.Height, _
                                           lBrush)
    End If
    If m_uLastStatus = Ok Then m_clsBrush.fInitialize (lBrush)
    CreateImageAttributesL = m_uLastStatus
End Function

Public Sub DisposeTextureBrush()
    m_clsBrush.DisposeBrush
    m_uLastStatus = m_clsBrush.GetLastStatus
End Sub

' gets a Bitmap object that is defined by this texture brush.
Public Function GetBitmap() As cBitmap
    Dim lImage              As Long
    Dim clsBitmap           As cBitmap
    
    m_uLastStatus = GdipGetTextureImage(m_clsBrush.NativeBrush, lImage)
    If m_uLastStatus <> Ok Then Exit Function
    Set clsBitmap = New cBitmap
    clsBitmap.Image.fInitialize (lImage)
    Set GetBitmap = clsBitmap
End Function

' gets a Image object that is defined by this texture brush.
Public Function GetImage() As cImage
    Dim lImage             As Long
    Dim clsImage           As cImage
    
    m_uLastStatus = GdipGetTextureImage(m_clsBrush.NativeBrush, lImage)
    If m_uLastStatus <> Ok Then Exit Function
    Set clsImage = New cImage
    clsImage.fInitialize (lImage)
    Set GetImage = clsImage
End Function

' gets the transformation matrix of this texture brush.
Public Function GetTransform(ByRef matrix As cMatrix) As GpStatus
    Dim lMatrix As Long
    
    m_uLastStatus = GdipGetTextureTransform(m_clsBrush.NativeBrush, lMatrix)
    If m_uLastStatus = Ok Then
       If matrix Is Nothing Then Set matrix = New cMatrix
       matrix.fInitialize (lMatrix)
    End If
    GetTransform = m_uLastStatus
End Function

' gets the wrap mode currently set for this texture brush.
Public Function GetWrapMode() As WrapMode
    Dim uWrap As WrapMode
    
    m_uLastStatus = GdipGetTextureWrapMode(m_clsBrush.NativeBrush, uWrap)
    GetWrapMode = uWrap
End Function

Public Function GetLastStatus() As GpStatus
    GetLastStatus = m_uLastStatus
End Function

Public Function GetType() As BrushType
    GetType = m_clsBrush.GetType
End Function

' updates this brush's transformation matrix with the product of itself and another matrix.
Public Function MultiplyTransform(ByVal matrix As cMatrix, _
                                  Optional order As MatrixOrder = MatrixOrderPrepend) As GpStatus
    If matrix Is Nothing Then
       m_uLastStatus = InvalidParameter
    Else
       m_uLastStatus = GdipMultiplyTextureTransform(m_clsBrush.NativeBrush, matrix.NativeMatrix, order)
    End If
    MultiplyTransform = m_uLastStatus
End Function

Public Property Get NativeBrush() As Long
    NativeBrush = m_clsBrush.NativeBrush
End Property

' resets the transformation matrix of this texture brush to the identity matrix.
' This means that no transformation takes place.
Public Function ResetTransform() As GpStatus
    m_uLastStatus = GdipResetTextureTransform(m_clsBrush.NativeBrush)
    ResetTransform = m_uLastStatus
End Function

' updates this texture brush's current transformation matrix with the product of itself and a rotation matrix.
Public Function RotateTransform(ByVal angle As Single, _
                                Optional ByVal order As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipRotateTextureTransform(m_clsBrush.NativeBrush, angle, order)
    RotateTransform = m_uLastStatus
End Function

' updates this texture brush's current transformation matrix with the product of itself and a scaling matrix.
Public Function ScaleTransform(ByVal sx As Single, _
                               ByVal sy As Single, _
                               Optional ByVal order As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipScaleTextureTransform(m_clsBrush.NativeBrush, sx, sy, order)
    ScaleTransform = m_uLastStatus
End Function

' sets the transformation matrix of this texture brush.
Public Function SetTransform(ByVal matrix As cMatrix) As GpStatus
    m_uLastStatus = GdipSetTextureTransform(m_clsBrush.NativeBrush, matrix.NativeMatrix)
    SetTransform = m_uLastStatus
End Function

'sets the wrap mode of this texture brush.
Public Function SetWrapMode(ByVal uWrapMode As WrapMode) As GpStatus
    m_uLastStatus = GdipSetTextureWrapMode(m_clsBrush.NativeBrush, uWrapMode)
    SetWrapMode = m_uLastStatus
End Function

' updates this brush's current transformation matrix with the product of itself and a translation matrix.
Public Function TranslateTransform(ByVal dx As Single, _
                                   ByVal dy As Single, _
                                   Optional ByVal order As MatrixOrder = MatrixOrderPrepend) As GpStatus
    m_uLastStatus = GdipTranslateTextureTransform(m_clsBrush.NativeBrush, dx, dy, order)
    TranslateTransform = m_uLastStatus
End Function

Public Sub SetBrush(ByVal cBrush As cBrush)
    Set m_clsBrush = Nothing
    Set m_clsBrush = cBrush
End Sub

Private Sub Class_Initialize()
    Set m_clsBrush = New cBrush
End Sub

Private Sub Class_Terminate()
    Set m_clsBrush = Nothing
End Sub
