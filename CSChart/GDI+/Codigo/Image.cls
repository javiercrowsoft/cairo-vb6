VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "GDIPImage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Declare Function LocalGdipSaveImageToFile Lib "gdiplus.dll" Alias "GdipSaveImageToFile" _
   (ByVal Image As Long, _
   ByVal fileName As Long, _
   clsidEncoder As CLSID, _
   ByVal lPtrBuff As Long) As Long

Private Declare Function LocalGdipGetPropertyItem Lib "gdiplus.dll" Alias "GdipGetPropertyItem" _
   (ByVal img As Long, _
   ByVal lId As Long, _
   ByVal lSize As Long, _
   ByVal lPtrBuff As Long) As Long
   
Private Declare Function GdipAlloc Lib "gdiplus.dll" (ByVal size As Long) As Long
Private Declare Function GdipFree Lib "gdiplus.dll" (ByVal ptr As Long) As Long
   
Private m_bUseEmbeddedColorManagement As Boolean
Private m_img As Long
Private m_lastResult As GpStatus

Private m_cEncoderParams() As GDIPEncoderParameterList
Private m_iEncoderParameterListCount As Long

Friend Sub fInit(ByVal nativeImage As Long, ByVal lastResult)
   Dispose
   m_img = nativeImage
   m_lastResult = lastResult
End Sub

Friend Property Get nativeImage() As Long
   nativeImage = m_img
End Property

Private Sub SetStatus(ByVal status As GpStatus)
   m_lastResult = SetStatusHelper(status)
End Sub

Public Sub FromFile(ByVal sFile As String)
   Dispose
   If (m_bUseEmbeddedColorManagement) Then
      SetStatus GdipLoadImageFromFileICM( _
            sFile, _
            m_img _
        )
   Else
      SetStatus GdipLoadImageFromFile( _
            sFile, _
            m_img _
        )
   End If
End Sub
Public Sub FromStream(stream As MemoryStream)
   
   Dim istr As VBStrm.IStream
   Set istr = stream.IStreamOf
   
   Dispose
   If (m_bUseEmbeddedColorManagement) Then
      SetStatus GdipLoadImageFromStreamICM( _
            ByVal ObjPtr(istr), _
            m_img _
        )
   Else
      SetStatus GdipLoadImageFromStream( _
            ByVal ObjPtr(istr), _
            m_img _
        )
   End If

End Sub

Public Function Clone() As GDIPImage
Dim cloneimage As Long

   SetStatus GdipCloneImage(m_img, cloneimage)
   If Not (cloneimage = 0) Then
      Dim cloneR As New GDIPImage
      cloneR.fInit cloneimage, m_lastResult
      Set Clone = cloneR
   End If

End Function

Public Property Get EncoderParameterList( _
      clsidEncoder As CLSID _
   )
Dim i As Long
Dim iFoundIndex As Long
   ' see if we need to add this item:
   For i = 1 To m_iEncoderParameterListCount
      If matchCLSID(m_cEncoderParams(i).clsidEncoder, clsidEncoder) Then
         iFoundIndex = i
         Exit For
      End If
   Next i
   If (iFoundIndex = 0) Then
      m_iEncoderParameterListCount = m_iEncoderParameterListCount + 1
      ReDim Preserve m_cEncoderParams(1 To m_iEncoderParameterListCount) As GDIPEncoderParameterList
      Set m_cEncoderParams(m_iEncoderParameterListCount) = New GDIPEncoderParameterList
      m_cEncoderParams(m_iEncoderParameterListCount).fInit Me, clsidEncoder
      iFoundIndex = m_iEncoderParameterListCount
   End If
   Set EncoderParameterList = m_cEncoderParams(iFoundIndex)
End Property

Private Function matchCLSID( _
      clsId1 As CLSID, _
      clsId2 As CLSID _
   ) As Boolean
Dim i As Long
   If (clsId1.Data1 = clsId2.Data1) Then
      If (clsId1.Data2 = clsId2.Data2) Then
         If (clsId1.Data3 = clsId2.Data3) Then
            For i = 0 To 7
               If Not (clsId1.Data4(i) = clsId2.Data4(i)) Then
                  Exit Function
               End If
            Next i
            matchCLSID = True
         End If
      End If
   End If
End Function

Public Function Save( _
    ByVal fileName As String, _
    clsidEncoder As CLSID _
    )
Dim cEncoderParameters As GDIPEncoderParameterList
Dim lSize As Long
Dim lPtrBuff As Long
Dim b() As Byte
Dim cEncoderParam As GDIPEncoderParameter
Dim pP As EncoderParameter
Dim p As EncoderParameters
Dim lStart As Long
Dim i As Long
Dim j As Long
Dim l() As Long
Dim s() As Integer
Dim lCount As Long
Dim lPtr() As Long
Dim lBufCount As Long
Dim status As GpStatus

   Set cEncoderParameters = EncoderParameterList(clsidEncoder)
   lSize = cEncoderParameters.fGetEncoderParameterBufSize()
   If (lSize > 0) Then
   
      ' Now prepare the parameters:
      ReDim b(0 To lSize - 1) As Byte
      lStart = 4
      
      For i = 1 To cEncoderParameters.count
         Set cEncoderParam = cEncoderParameters.Parameter(i)
         If (cEncoderParam.ValueCount > 0) Then
            Debug.Print "Writing parameter", cEncoderParam.Name, cEncoderParam.value(1)
            lCount = lCount + 1
         
            LSet pP.Guid = cEncoderParam.Guid
            pP.NumberOfValues = cEncoderParam.ValueCount
            pP.Type = cEncoderParam.ParamType
            If (pP.Type = EncoderParameterValueTypeLongRange) Then
               pP.Type = EncoderParameterValueTypeLong
            End If
         
            lBufCount = lBufCount + 1
            ReDim Preserve lPtr(1 To lBufCount) As Long
            lPtr(lBufCount) = GdipAlloc(pP.NumberOfValues * 4)
            
            Select Case pP.Type
            Case EncoderParameterValueTypeLong, EncoderParameterValueTypeLongRange
               ReDim l(0 To pP.NumberOfValues - 1) As Long
               For j = 1 To pP.NumberOfValues
                  l(j - 1) = cEncoderParam.value(j)
               Next j
               RtlMoveMemory ByVal lPtr(lBufCount), l(0), pP.NumberOfValues * 4
               
            Case EncoderParameterValueTypeShort
               ReDim s(0 To pP.NumberOfValues - 1) As Integer
               For j = 1 To pP.NumberOfValues
                  s(j - 1) = cEncoderParam.value(j)
               Next j
               RtlMoveMemory ByVal lPtr(lBufCount), s(0), pP.NumberOfValues * 2
               
            End Select
            pP.ValuePtr = lPtr(lBufCount)
         
            RtlMoveMemory b(lStart), pP, Len(pP)
            lStart = lStart + Len(pP)
            
         End If
      Next i
      
      ' Write out the number of parameters:
      RtlMoveMemory b(0), lCount, 4

      lPtrBuff = VarPtr(b(0))
      status = LocalGdipSaveImageToFile(m_img, _
            StrPtr(fileName), _
            clsidEncoder, _
            lPtrBuff)
      
      For i = 1 To lBufCount
         GdipFree lPtr(i)
      Next i
      
      SetStatus status
   Else
      SetStatus LocalGdipSaveImageToFile(m_img, _
            StrPtr(fileName), _
            clsidEncoder, _
            ByVal 0&)
   End If
End Function


Public Property Get ImgType() As ImageType
Dim itype  As ImageType
   itype = ImageTypeUnknown
   SetStatus GdipGetImageType(m_img, itype)
   ImgType = itype

End Property

Public Property Get PhysicalDimension() As SIZEF
Dim size As SIZEF

   SetStatus GdipGetImageDimension(m_img, _
         size.width, size.height)
         
End Property

Public Property Get width() As Long
Dim lWidth As Long
   
   SetStatus GdipGetImageWidth(m_img, lWidth)
   width = lWidth
   
End Property

Public Property Get height() As Long
Dim lHeight As Long
   
   SetStatus GdipGetImageHeight(m_img, lHeight)
   height = lHeight

End Property

Public Property Get HorizontalResolution() As Single
Dim resolution As Single

   SetStatus GdipGetImageHorizontalResolution(m_img, resolution)
   HorizontalResolution = resolution

End Property

Public Property Get VerticalResolution() As Single
Dim resolution As Single

   SetStatus GdipGetImageVerticalResolution(m_img, resolution)
   VerticalResolution = resolution

End Property

Public Property Get Flags() As Long
    Dim lFlags As Long
    SetStatus GdipGetImageFlags(m_img, lFlags)
    Flags = lFlags
End Property

Public Property Get RawFormat() As CLSID
Dim format As CLSID
   SetStatus GdipGetImageRawFormat(m_img, format)
   RawFormat = format
End Property

Public Property Get ImgPixelFormat() As Long
Dim format As Long ' Should be PixelFormat

   SetStatus GdipGetImagePixelFormat(m_img, format)
   ImgPixelFormat = format

End Property

Public Property Get PaletteSize() As Long
Dim size As Long
   SetStatus GdipGetImagePaletteSize(m_img, size)
   PaletteSize = size
End Property

Public Property Get Palette(ByVal size As Long) As ColorPalette
Dim pal As ColorPalette
   SetStatus GdipGetImagePalette(m_img, pal, size)
   Palette = pal
End Property

Public Sub SetPalette( _
      pal As ColorPalette _
   )
   SetStatus GdipSetImagePalette(m_img, pal)
End Sub

Public Function GetThumbnailImage( _
    ByVal thumbWidth As Long, _
    ByVal thumbHeight As Long, _
    ByVal callback As Long, _
    ByVal callbackData As Long _
   ) As GDIPImage
   Dim thumbimage As Long

   SetStatus GdipGetImageThumbnail(m_img, _
         thumbWidth, thumbHeight, _
         thumbimage, _
         callback, callbackData)

    Dim newImage As New GDIPImage
    newImage.fInit thumbimage, m_lastResult

    Set GetThumbnailImage = newImage

End Function


Public Property Get FrameDimensionsList() As GDIPFrameDimensionsList
   Dim cDimensionList As New GDIPFrameDimensionsList
   cDimensionList.fInit m_img
   Set FrameDimensionsList = cDimensionList
End Property


Public Sub SelectActiveFrame( _
    dimensionId As CLSID, _
    ByVal frameIndex As Long _
    )
   SetStatus GdipImageSelectActiveFrame(m_img, _
      dimensionId, _
      frameIndex)

End Sub
Public Sub RotateFlip( _
    ByVal rotFlipType As RotateFlipType _
    )
   SetStatus GdipImageRotateFlip(m_img, rotFlipType)

End Sub

Public Property Get PropertyCount() As Long
Dim numProperty As Long
   SetStatus GdipGetPropertyCount(m_img, _
      numProperty)
   PropertyCount = numProperty
End Property

Public Property Get PropertyItemForID(ByVal lId As Long) As GDIPPropertyItem
Dim lSize As Long
   SetStatus GdipGetPropertyItemSize(m_img, lId, lSize)
   If (lSize > 0) Then
      ReDim b(0 To lSize - 1) As Byte
      Dim lPtrBuff As Long
      lPtrBuff = VarPtr(b(0))
      SetStatus LocalGdipGetPropertyItem(m_img, lId, lSize, lPtrBuff)
      Dim p As GdiPlus.PropertyItem
      Dim cItem As New GDIPPropertyItem
      Dim lDataSize As Long
      If Not (lPtrBuff = 0) And (lSize > 0) Then
         RtlMoveMemory p, ByVal lPtrBuff, Len(p)
         cItem.fInit p.Id, p.Length, p.Type, p.ValuePtr, lSize
      End If
      Set PropertyItemForID = cItem
   End If
End Property

Public Property Get PropertyItem(ByVal index As Long) As GDIPPropertyItem
Dim lCount As Long
   lCount = PropertyCount
   If (index > 0) And (index <= lCount) Then
      ' Get all property items :
      ReDim lPropId(0 To lCount - 1) As Long
      
      Dim lPtrList As Long
      lPtrList = VarPtr(lPropId(0))
      SetStatus GdipGetPropertyIdList(m_img, lCount, lPtrList)
      
      Set PropertyItem = PropertyItemForID(lPropId(index - 1))
   Else
      SetStatus InvalidParameter
   End If
End Property

Public Sub RemovePropertyItem(ByVal propId As Long)
   SetStatus GdipRemovePropertyItem(m_img, propId)
End Sub

Public Sub SetPropertyItem(item As GDIPPropertyItem)
   Dim p As GdiPlus.PropertyItem
   p.Id = item.Id
   p.Length = item.Length
   p.Type = item.ItemType
   ReDim b(0 To item.DataBufferSize - 1) As Byte
   item.GetData b()
   p.ValuePtr = VarPtr(b(0))
   SetStatus GdipSetPropertyItem(m_img, p)
End Sub

Public Sub Dispose()
   If Not (m_img = 0) Then
      GdipDisposeImage m_img
      m_img = 0
   End If
End Sub

Private Sub Class_Terminate()
   Dispose
End Sub
