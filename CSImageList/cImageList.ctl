VERSION 5.00
Begin VB.UserControl cImageList 
   ClientHeight    =   915
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   1020
   ClipControls    =   0   'False
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   6.75
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   InvisibleAtRuntime=   -1  'True
   PropertyPages   =   "cImageList.ctx":0000
   ScaleHeight     =   915
   ScaleWidth      =   1020
   ToolboxBitmap   =   "cImageList.ctx":001D
   Begin VB.PictureBox picImage 
      AutoRedraw      =   -1  'True
      Height          =   555
      Left            =   420
      Picture         =   "cImageList.ctx":0117
      ScaleHeight     =   495
      ScaleWidth      =   495
      TabIndex        =   0
      Top             =   300
      Visible         =   0   'False
      Width           =   555
   End
End
Attribute VB_Name = "cImageList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "PropPageWizardRun" ,"Yes"
Option Explicit

' =========================================================================
' vbAccelerator Image List Control Demonstrator
' Copyright © 1998-1999 Steve McMahon (steve@vbaccelerator.com)
'
' Implements an Image List control in VB using COMCTL32.DLL
'
' Visit vbAccelerator at http://vbaccelerator.com
'
' Date      Who   What
' 29/12/99  SPM   Fixes
' Thanks to Richard Deeming for noting these problems and their fixes
' 1) Moving Images in the property page list using the buttons, keys
'    were not swapped.
' 2) Subscript out of range (9) error when trying to retrieve the
'    index of the first image in the list by key.
' Plus these fixes & improvements:
' 1) Key property not always set for new images - fixed logic.
' 2) Put images into a PictureBox so it can get focus and you
'    can navigate through them using the cursor keys.
' 3) Smaller binary (p-code compile).
'
' 19/03/99  SPM   Fixes & improvements:
' 1) When loading an icon, choose the icon resource with the size most
'    closely matching the image list.
' 2) Allow multiple files to be selected when adding images.
' 3) Allow keys to be set up in the property page and persisted.
' 4) Keys can be automatically set up based on the filename of
'    the items being added.
' 5) Allow load of GIF, CUR and ANI from the property page.  For .ANIs,
'    you can choose whether to load just the first frame or import
'    all frames.
' 6) Allow bitmap transparent colour to be automatically determined
'    for bitmaps and GIFs (nb: use of JPG is not recommended because
'    JPGs do not maintain colour stability - any area of transparent
'    colour will vary approx +/- 3 colour values from the actual colour)
' 7) Bugs causing the control to crash when clicking buttons on the
'    property page have been fixed.  Also, an error causing images to
'    load in the wrong order has been fixed.
'
' =========================================================================

' -----------
' ENUMS
' -----------
Public Enum eilIconState
  Normal = 0
  Disabled = 1
End Enum

Public Enum ImageTypes
  IMAGE_BITMAP = 0
  IMAGE_ICON = 1
  IMAGE_CURSOR = 2
End Enum

Public Enum eilColourDepth
    ILC_COLOR = &H0
    ILC_COLOR4 = &H4
    ILC_COLOR8 = &H8
    ILC_COLOR16 = &H10
    ILC_COLOR24 = &H18
    ILC_COLOR32 = &H20
End Enum

Public Enum eilSwapTypes
   eilCopy = ILCF_MOVE
   eilSwap = ILCF_SWAP
End Enum

' ------------------
' Private variables:
' ------------------
Private m_hIml As Long
Private m_lIconSizeX As Long
Private m_lIconSizeY As Long
Private m_eColourDepth As eilColourDepth
Private m_sKey() As String

Public Property Get SystemColourDepth() As eilColourDepth
Attribute SystemColourDepth.VB_Description = "Returns the current system colour depth.  Use it to determine whether to load 16 or 256 colour icons from a resource file at run-time."
Dim lR As Long
Dim lHDC As Long
   lHDC = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
   lR = GetDeviceCaps(lHDC, BITSPIXEL)
   DeleteDC lHDC
   SystemColourDepth = lR
End Property

Public Sub SwapOrCopyImage( _
      ByVal vKeySrc As Variant, _
      ByVal vKeyDst As Variant, _
      Optional ByVal eSwap As eilSwapTypes = eilSwap _
   )
Attribute SwapOrCopyImage.VB_Description = "Swaps two images or copies an image to another position in the image list."
Dim lDst As Long
Dim lSrc As Long
Dim sKeyDst As String
Dim sKeySrc As String

   If (m_hIml <> 0) Then
      lDst = ItemIndex(vKeySrc)
      If (lDst > -1) Then
         lSrc = ItemIndex(vKeyDst)
         If (lSrc > -1) Then
            ImageList_Copy m_hIml, lDst, m_hIml, lSrc, eSwap
            sKeyDst = m_sKey(lDst)
            sKeySrc = m_sKey(lSrc)
            m_sKey(lDst) = sKeySrc
            m_sKey(lSrc) = sKeyDst
            PropertyChanged "Images"
            PropertyChanged "Size"
         End If
      End If
   End If
End Sub

Public Function Create() As Boolean
Attribute Create.VB_Description = "Clears the existing image list (if any) and creates a new one."
     
     ' Do we already have an image list?  Kill it if we have:
    Destroy

    'Create the Imagelist:
    m_hIml = ImageList_Create(m_lIconSizeX, m_lIconSizeY, ILC_MASK Or m_eColourDepth, 4, 4)
    If (m_hIml <> 0) And (m_hIml <> -1) Then
      ' Ok
      Create = True
    Else
      m_hIml = 0
    End If
    
End Function
Public Sub Destroy()
Attribute Destroy.VB_Description = "Deletes the image list (if any) from memory."
   ' Kill the image list if we have one:
    If (hIml <> 0) Then
        ImageList_Destroy hIml
        m_hIml = 0
        Erase m_sKey
    End If
End Sub
Public Sub DrawImage( _
        ByVal vKey As Variant, _
        ByVal hdc As Long, _
        ByVal xPixels As Integer, _
        ByVal yPixels As Integer, _
        Optional ByVal bSelected = False, _
        Optional ByVal bCut = False, _
        Optional ByVal bDisabled = False, _
        Optional ByVal oCutDitherColour As OLE_COLOR = vbWindowBackground, _
        Optional ByVal hExternalIml As Long = 0 _
    )
Attribute DrawImage.VB_Description = "Draws an Image from the image list onto a device context."
Dim hIcon As Long
Dim lFlags As Long
Dim lhIml As Long
Dim lColor As Long
Dim iImgIndex As Long

   ' Draw the image at 1 based index or key supplied in vKey.
   ' on the hDC at xPixels,yPixels with the supplied options.
   ' You can even draw an ImageList from another ImageList control
   ' if you supply the handle to hExternalIml with this function.
   
   iImgIndex = ItemIndex(vKey)
   If (iImgIndex > -1) Then
      If (hExternalIml <> 0) Then
          lhIml = hExternalIml
      Else
          lhIml = hIml
      End If
      
      lFlags = ILD_TRANSPARENT
      If (bSelected) Or (bCut) Then
          lFlags = lFlags Or ILD_SELECTED
      End If
      
      If (bCut) Then
        ' Draw dithered:
        lColor = TranslateColor(oCutDitherColour)
        If (lColor = -1) Then lColor = GetSysColor(COLOR_WINDOW)
        ImageList_DrawEx _
              lhIml, _
              iImgIndex, _
              hdc, _
              xPixels, yPixels, 0, 0, _
              CLR_NONE, lColor, _
              lFlags
      ElseIf (bDisabled) Then
        ' extract a copy of the icon:
        hIcon = ImageList_GetIcon(hIml, iImgIndex, 0)
        ' Draw it disabled at x,y:
        DrawState hdc, 0, 0, hIcon, 0, xPixels, yPixels, m_lIconSizeX, m_lIconSizeY, DST_ICON Or DSS_DISABLED
        ' Clear up the icon:
        DestroyIcon hIcon
              
      Else
        ' Standard draw:
        ImageList_Draw _
            lhIml, _
            iImgIndex, _
            hdc, _
            xPixels, _
            yPixels, _
            lFlags
      End If
   End If
End Sub

Public Property Get IconSizeX() As Long
Attribute IconSizeX.VB_Description = "Gets/sets the width of the images in the list.  Has no effect a runtime unless you call the Create method."
Attribute IconSizeX.VB_ProcData.VB_Invoke_Property = "ppgControl"
   ' Returns the icon width
    IconSizeX = m_lIconSizeX
End Property
Public Property Let IconSizeX(ByVal lSizeX As Long)
   ' Sets the icon width.  NB no change at runtime unless you
   ' call Create and add all the images in again.
    m_lIconSizeX = lSizeX
    PropertyChanged "IconSizeX"
End Property
Public Property Get IconSizeY() As Long
Attribute IconSizeY.VB_Description = "Gets/sets the height of the images in the list.  Has no effect a runtime unless you call the Create method."
   ' Returns the icon height:
    IconSizeY = m_lIconSizeY
End Property
Public Property Let IconSizeY(ByVal lSizeY As Long)
   ' Sets the icon height.  NB no change at runtime unless you
   ' call Create and add all the images in again.
    m_lIconSizeY = lSizeY
    PropertyChanged "IconSizeY"
End Property
Public Property Get ColourDepth() As eilColourDepth
Attribute ColourDepth.VB_Description = "Gets/sets the number of colours the image list will suport."
Attribute ColourDepth.VB_ProcData.VB_Invoke_Property = "ppgControl"
   ' Returns the ColourDepth:
    ColourDepth = m_eColourDepth
End Property
Public Property Let ColourDepth(ByVal eDepth As eilColourDepth)
   ' Sets the ColourDepth.  NB no change at runtime unless you
   ' call Create and rebuild the image list.
    m_eColourDepth = eDepth
    PropertyChanged "ColourDepth"
End Property

Public Property Get ImageCount() As Integer
Attribute ImageCount.VB_Description = "Gets the number of images in the Image List."
Attribute ImageCount.VB_ProcData.VB_Invoke_Property = "ppgImages;Behavior"
   ' Returns the number of images in the ImageList:
   If (hIml <> 0) Then
      ImageCount = ImageList_GetImageCount(hIml)
   End If
End Property
Public Sub RemoveImage(ByVal vKey As Variant)
Attribute RemoveImage.VB_Description = "Removes an image from the image list."
Dim lIndex As Long
Dim i As Long
   ' Removes an image from the ImageList:
   If (hIml <> 0) Then
      lIndex = ItemIndex(vKey)
      ImageList_Remove hIml, lIndex
      ' Fix up the keys:
      For i = lIndex To ImageCount - 1
         m_sKey(i) = m_sKey(i + 1)
      Next i
      pEnsureKeys
      PropertyChanged "Images"
      PropertyChanged "Size"
      PropertyChanged "Keys"
      PropertyChanged "KeyCount"
      If Not (UserControl.Ambient.UserMode) Then
         UserControl_Paint
      End If
   End If
End Sub
Public Property Get ItemIndex(ByVal vKey As Variant) As Long
Attribute ItemIndex.VB_Description = "Returns the API index (0 based) for the image with a specified key."
Attribute ItemIndex.VB_MemberFlags = "400"
Dim lR As Long
Dim i As Long
   ' Returns the 0 based Index for the selected
   ' Image list item:
   If (IsNumeric(vKey)) Then
      lR = vKey
      If (lR > 0) And (lR <= ImageCount) Then
         ItemIndex = lR - 1
      Else
         ' error
         Err.Raise 9, App.EXEName & ".vbalImageList"
         ItemIndex = -1
      End If
   Else
      lR = -1
      For i = 0 To ImageCount - 1
         If (m_sKey(i) = vKey) Then
            lR = i
            Exit For
         End If
      Next i
      ' 2) 29/11/99 Thanks to Richard Deeming for pointing
      '    out this error
      If (lR >= 0) And (lR < ImageCount) Then
         ItemIndex = lR
      Else
         Err.Raise 9, App.EXEName & ".vbalImageList"
         ItemIndex = -1
      End If
   End If
End Property
Public Property Get ItemKey(ByVal iIndex As Long) As Variant
Attribute ItemKey.VB_Description = "Returns the key for an image with the specified index."
   ' Returns the Key for an image:
   If (iIndex > 0) And (iIndex <= ImageCount) Then
      ItemKey = m_sKey(iIndex - 1)
   Else
      Err.Raise 9, App.EXEName & ".vbalImageList"
   End If
End Property
Public Property Let ItemKey(ByVal iIndex As Long, ByVal vKey As Variant)
   ' Sets the Key for the an image:
   If (iIndex > 0) And (iIndex <= ImageCount) Then
      iIndex = iIndex - 1
      SetKey iIndex, vKey
      PropertyChanged "KeyCount"
      PropertyChanged "Keys"
   Else
      Err.Raise 9, App.EXEName & ".vbalImageList"
   End If
End Property
Public Property Get KeyExists(ByVal sKey As String) As Boolean
Dim iL As Long
Dim iU As Long
   If ImageCount > 0 Then
      On Error Resume Next
      iU = UBound(m_sKey)
      If Err.Number <> 0 Then
         iU = 0
      End If
      If (iU <> ImageCount - 1) Then
         pEnsureKeys
      End If
      For iL = 0 To ImageCount - 1
         If m_sKey(iL) = sKey Then
            KeyExists = True
            Exit For
         End If
      Next iL
   End If
End Property
Public Property Get ItemPicture(ByVal vKey As Variant) As IPicture
Attribute ItemPicture.VB_Description = "Returns a Picture object containing an image in the Image List."
Dim lIndex As Long
Dim hIcon As Long
   ' Returns a StdPicture for an image in the ImageList:
   lIndex = ItemIndex(vKey)
   If (lIndex > -1) Then
      hIcon = ImageList_GetIcon(m_hIml, lIndex, ILD_TRANSPARENT)
      If (hIcon <> 0) Then
         Set ItemPicture = IconToPicture(hIcon)
         ' Don't destroy the icon - it is now owned by
         ' the picture object
      End If
   End If
   
End Property
Public Property Get ItemCopyOfIcon(ByVal vKey As Variant) As Long
Attribute ItemCopyOfIcon.VB_Description = "Makes a copy of a specified image in the image list into an icon and returns the hIcon handle.  You must use DestroyIcon to free this handle."
Dim lIndex As Long
   ' Returns a hIcon for an image in the ImageList.  User must
   ' call DestroyIcon on the returned handle.
   lIndex = ItemIndex(vKey)
   If (lIndex > -1) Then
      ItemCopyOfIcon = ImageList_GetIcon(m_hIml, lIndex, ILD_TRANSPARENT)
   End If
End Property
Public Sub Clear()
Attribute Clear.VB_Description = "Clears all images in the list and creates a new image list."
   ' Recreates the image list.  Used by the control property page to
   ' change the size/depth:
   Create
   Erase m_sKey
   PropertyChanged "Images"
   PropertyChanged "Size"
   If Not (UserControl.Ambient.UserMode) Then
      UserControl_Paint
   End If

End Sub
Public Function AddFromFile( _
        ByVal sFileName As String, _
        ByVal iType As ImageTypes, _
        Optional ByVal vKey As Variant, _
        Optional ByVal bMapSysColors As Boolean = False, _
        Optional ByVal lBackColor As OLE_COLOR = -1, _
        Optional ByVal vKeyAfter As Variant _
    ) As Long
Attribute AddFromFile.VB_Description = "Adds an image or series of images to the image list from a bitmap or icon file."
Dim hImage As Long
Dim un2 As Long
Dim lR As Long
Dim iX As Long, iY As Long
    
   ' Adds an image or series of images from a file:
   If (hIml <> 0) Then
      un2 = LR_LOADFROMFILE
      ' Load the image from file:
      If bMapSysColors Then
          un2 = un2 Or LR_LOADMAP3DCOLORS
      End If
      ' Choose the icon closest to the image list size:
      If iType <> IMAGE_BITMAP Then
         iX = m_lIconSizeX
         iY = m_lIconSizeY
      End If
      hImage = LoadImage(App.hInstance, sFileName, iType, iX, iY, un2)
      AddFromFile = AddFromHandle(hImage, iType, vKey, lBackColor, vKeyAfter)
      Select Case iType
      Case IMAGE_ICON
         DestroyIcon hImage
      Case IMAGE_CURSOR
         DestroyCursor hImage
      Case IMAGE_BITMAP
         DeleteObject hImage
      End Select
   Else
      ' no image list...
      AddFromFile = False
   End If
                  
   PropertyChanged "Images"
   PropertyChanged "Size"
   PropertyChanged "Keys"
   PropertyChanged "KeyCount"
   If Not (UserControl.Ambient.UserMode) Then
      UserControl_Paint
   End If
   
End Function
Public Function AddFromResourceID( _
      ByVal lID As Long, _
      ByVal hInst As Long, _
      ByVal iType As ImageTypes, _
      Optional ByVal vKey As Variant, _
      Optional ByVal bMapSysColors As Boolean = False, _
      Optional ByVal lBackColor As OLE_COLOR = -1, _
      Optional ByVal vKeyAfter As Variant _
    ) As Long
Attribute AddFromResourceID.VB_Description = "Adds an image or series of images to the image list from a resource identifier."
Dim hImage As Long
Dim un2 As Long
Dim lR As Long
Dim iX As Long, iY As Long
    
   ' Adds an image or series of images from a resource id.  Note this will
   ' only work when working on a resource in a compiled executable:
   If (hIml <> 0) Then
      ' Load the image from file:
      If bMapSysColors Then
          un2 = un2 Or LR_LOADMAP3DCOLORS
      End If
      ' Choose the icon closest to the image list size:
      If iType <> IMAGE_BITMAP Then
         iX = m_lIconSizeX
         iY = m_lIconSizeY
      End If
      hImage = LoadImageLong(hInst, lID, iType, 0, 0, un2)
      AddFromResourceID = AddFromHandle(hImage, iType, vKey, lBackColor, vKeyAfter)
      Select Case iType
      Case IMAGE_ICON
         DestroyIcon hImage
      Case IMAGE_CURSOR
         DestroyCursor hImage
      Case IMAGE_BITMAP
         DeleteObject hImage
      End Select
   Else
      ' no image list...
      AddFromResourceID = False
   End If
End Function

Public Function AddFromHandle( _
      ByVal hImage As Long, _
      ByVal iType As ImageTypes, _
      Optional ByVal vKey As Variant, _
      Optional ByVal lBackColor As OLE_COLOR = -1, _
      Optional ByVal vKeyAfter As Variant _
   ) As Boolean
Attribute AddFromHandle.VB_Description = "Adds an image or series of images to the image list from a bitmap or icon GDI handle."
Dim lR As Long
Dim lDst As Long
Dim bOk As Boolean
Dim bInsert As Boolean
Dim i As Long, j As Long
Dim iOrigCount As Long
Dim iCount As Long
Dim sSwapKey As String

   ' Adds an image or series of images from a GDI image handle.
   If (m_hIml <> 0) Then
      If (hImage <> 0) Then
         iOrigCount = ImageCount
         
         bOk = True
         If Not IsMissing(vKeyAfter) Then
            If (ImageCount > 0) Then
               If vKeyAfter = 0 Then
                  bInsert = False
                  lDst = 0
               Else
                  bInsert = True
                  bOk = False
                  lDst = ItemIndex(vKeyAfter)
                  If (lDst > -1) Then
                     bOk = True
                  End If
               End If
            End If
         End If
         
         If (bOk) Then
            If (iType = IMAGE_BITMAP) Then
               ' And add it to the image list:
               If (lBackColor = -1) Then
                   ' Ideally Determine the top left pixel of the
                   ' bitmap and use as back colour...
                   Dim lHDCDisp As Long, lHDC As Long, hBmpOld As Long
                   lHDCDisp = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
                   If lHDCDisp <> 0 Then
                     lHDC = CreateCompatibleDC(lHDCDisp)
                     DeleteDC lHDCDisp
                     If lHDC <> 0 Then
                        hBmpOld = SelectObject(lHDC, hImage)
                        If hBmpOld <> 0 Then
                           ' Get the colour of the 0,0 pixel:
                           lBackColor = GetPixel(lHDC, 0, 0)
                           SelectObject lHDC, hBmpOld
                        End If
                        DeleteDC lHDC
                     End If
                  End If
               End If
               lR = ImageList_AddMasked(hIml, hImage, lBackColor)
            ElseIf (iType = IMAGE_ICON) Or (iType = IMAGE_CURSOR) Then
               ' Add the icon:
               lR = ImageList_AddIcon(hIml, hImage)
            End If
         End If
         
         If (lR > -1) Then
            If (bInsert) Then
               If (lDst < ImageCount - 1) Then
                  ' We are inserting and have to swap all
                  ' the images.
                  pEnsureKeys
                  iCount = ImageCount
                  For i = iOrigCount - 1 To lDst Step -1
                     For j = i To i + iCount - iOrigCount - 1
                        ImageList_Copy m_hIml, j + 1, m_hIml, j, eilSwap
                        sSwapKey = m_sKey(j)
                        m_sKey(j) = m_sKey(j + 1)
                        m_sKey(j + 1) = sSwapKey
                     Next j
                  Next i
                  
               End If
            End If
         End If
         
      Else
          lR = -1
      End If
   Else
      lR = -1
   End If
   
   If (lR <> -1) Then
      If bInsert Then
         SetKey lDst, vKey
      Else
         SetKey lR, vKey
      End If
      AddFromHandle = (lR <> -1)
   End If
   pEnsureKeys
   
End Function
Public Function AddFromPictureBox( _
        ByVal hdc As Long, _
        pic As Object, _
        Optional ByVal vKey As Variant, _
        Optional ByVal LeftPixels As Long = 0, _
        Optional ByVal TopPixels As Long = 0, _
        Optional ByVal lBackColor As OLE_COLOR = -1 _
    ) As Long
Dim lHDC As Long
Dim lhBmp As Long, lhBmpOld As Long
Dim tBM As BITMAP
Dim lAColor As Long
Dim lW As Long, lH As Long
Dim hBrush As Long
Dim tR As RECT
Dim lR As Long
Dim lBPixel As Long
   
   ' Adds an image or series of images from an area of a PictureBox
   ' or other Device Context:
   lR = -1
   If (hIml <> 0) Then
      ' Create a DC to hold the bitmap to transfer into the image list:
      lHDC = CreateCompatibleDC(hdc)
      If (lHDC <> 0) Then
          lhBmp = CreateCompatibleBitmap(hdc, m_lIconSizeX, m_lIconSizeY)
          If (lhBmp <> 0) Then
              ' Get the backcolor to use:
              If (lBackColor = -1) Then
                  ' None specified, use the colour at 0,0:
                  lBackColor = GetPixel(pic.hdc, 0, 0)
              Else
                  ' Try to get the specified backcolor:
                  If OleTranslateColor(lBackColor, 0, lAColor) Then
                      ' Failed- use default of silver
                      lBackColor = &HC0C0C0
                  Else
                      ' Set to GDI version of OLE Color
                      lBackColor = lAColor
                  End If
              End If
              ' Select the bitmap into the DC
              lhBmpOld = SelectObject(lHDC, lhBmp)
              ' Clear the background:
              hBrush = CreateSolidBrush(lBackColor)
              tR.Right = m_lIconSizeX: tR.Bottom = m_lIconSizeY
              FillRect lHDC, tR, hBrush
              DeleteObject hBrush
              
              ' Get the source picture's dimension:
              GetObjectAPI pic.Picture.Handle, LenB(tBM), tBM
              lW = 16
              lH = 16
              If (lW + LeftPixels > tBM.bmWidth) Then
                  lW = tBM.bmWidth - LeftPixels
              End If
              If (lH + TopPixels > tBM.bmHeight) Then
                  lH = tBM.bmHeight - TopPixels
              End If
              If (lW > 0) And (lH > 0) Then
                  ' Blt from the picture into the bitmap:
                  lR = BitBlt(lHDC, 0, 0, lW, lH, hdc, LeftPixels, TopPixels, SRCCOPY)
                  Debug.Assert (lR <> 0)
              End If
              
              ' We now have the image in the bitmap, so select it out of the DC:
              SelectObject lHDC, lhBmpOld
              ' And add it to the image list:
              'lR = ImageList_AddMasked(hIml, lhBmp, lBackColor)
              'Debug.Assert (lR <> -1)
              AddFromHandle lhBmp, IMAGE_BITMAP, vKey, lBackColor
                  
              DeleteObject lhBmp
          End If
          ' Clear up the DC:
          DeleteDC lHDC
      End If
   End If

   If (lR <> -1) Then
        SetKey lR, vKey
   End If
   pEnsureKeys
   AddFromPictureBox = lR + 1
   
End Function
Private Sub pEnsureKeys()
Dim iCount As Long
Dim iU As Long
   If m_hIml <> 0 Then
      iCount = ImageCount
      On Error Resume Next
      iU = UBound(m_sKey)
      If (Err.Number <> 0) Then iU = -1
      Err.Clear
      If (iU <> iCount - 1) Then
         ReDim Preserve m_sKey(0 To iCount - 1) As String
      End If
   End If
End Sub
Private Sub SetKey(ByVal lIndex As Long, ByVal vKey As Variant)
Dim sKey As String
Dim lI As Long

   If (IsEmpty(vKey) Or IsMissing(vKey)) Then
      sKey = ""
   Else
      sKey = vKey
   End If
    
   If (m_hIml <> 0) Then
      
      On Error Resume Next
      lI = UBound(m_sKey)
      If (Err.Number = 0) Then
         If (lIndex > lI) Then
            ReDim Preserve m_sKey(0 To lIndex) As String
         End If
      Else
         ReDim Preserve m_sKey(0 To lIndex) As String
      End If
      
      For lI = 0 To UBound(m_sKey)
         If Not lI = lIndex Then
            If Trim$(m_sKey(lI)) <> "" Then
               If m_sKey(lI) = vKey Then
                  Err.Raise 457
                  Exit Sub
               End If
            End If
         End If
      Next lI
      m_sKey(lIndex) = vKey
   End If
End Sub
Public Property Get hIml() As Long
Attribute hIml.VB_Description = "Gets the COMCTL32 hImageList handle to the current image list, or 0 if there is no image list."
Attribute hIml.VB_UserMemId = 0
   ' Returns the ImageList handle:
    hIml = m_hIml
End Property
Public Property Get ImagePictureStrip( _
      Optional ByVal vStartKey As Variant, _
      Optional ByVal vEndKey As Variant, _
      Optional ByVal oBackColor As OLE_COLOR = vbButtonFace _
   ) As IPicture
Attribute ImagePictureStrip.VB_Description = "Returns a Picture object containing a bitmap with all the image list images in a horizontal strip."
Dim iStart As Long
Dim iEnd As Long
Dim iImgIndex As Long
Dim lHDC As Long
Dim lParenthDC As Long
Dim lhBmp As Long
Dim lhBmpOld As Long
Dim lSizeX As Long
Dim hBr As Long
Dim tR As RECT
Dim lColor As Long
   
   If (m_hIml <> 0) Then
      If (IsMissing(vStartKey)) Then
         iStart = 0
      Else
         iStart = ItemIndex(vStartKey)
      End If
      If (IsMissing(vEndKey)) Then
         iEnd = ImageCount - 1
      Else
         iEnd = ItemIndex(vEndKey)
      End If
      
      If (iEnd > iStart) And (iEnd > -1) Then
         lParenthDC = UserControl.Parent.hdc
         lHDC = CreateCompatibleDC(lParenthDC)
         If (lHDC <> 0) Then
            lSizeX = ImageCount * m_lIconSizeX
            lhBmp = CreateCompatibleBitmap(lParenthDC, lSizeX, m_lIconSizeY)
            If (lhBmp <> 0) Then
               lhBmpOld = SelectObject(lHDC, lhBmp)
               If (lhBmpOld <> 0) Then
                  lColor = TranslateColor(oBackColor)
                  tR.Bottom = m_lIconSizeY
                  tR.Right = lSizeX
                  hBr = CreateSolidBrush(lColor)
                  FillRect lHDC, tR, hBr
                  DeleteObject hBr
                  For iImgIndex = iStart To iEnd
                     ImageList_Draw m_hIml, iImgIndex, lHDC, iImgIndex * m_lIconSizeX, 0, ILD_TRANSPARENT
                  Next iImgIndex
                  SelectObject lHDC, lhBmpOld
                  Set ImagePictureStrip = BitmapToPicture(lhBmp)
               Else
                  DeleteObject lhBmp
               End If
            End If
            DeleteDC lHDC
         End If
      End If
   End If
   
End Property

Public Function SaveToFile(ByVal sFile As String) As Boolean
Attribute SaveToFile.VB_Description = "Saves the current image list image data to a file. This can be read in at another point with LoadFromFile."
Dim b() As Byte
Dim lSize As Long
Dim iFile As Long
Dim lStart As Long
Dim i As Long
Dim hIcon As Long
Dim lHDC As Long
Dim sKeys As String

On Error GoTo SaveToFileError
   
   ' Saves the image data to a file:

   If (m_hIml <> 0) Then
      ReDim b(0 To 8096# * ImageCount) As Byte
      
      lHDC = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
      For i = 1 To ImageCount
         hIcon = ImageList_GetIcon(m_hIml, i - 1, ILD_TRANSPARENT)
         If (hIcon <> 0) And (hIcon <> -1) Then
            SerialiseIcon lHDC, hIcon, b(), lStart, lSize
            lStart = lStart + lSize
            DestroyIcon hIcon
            sKeys = sKeys & m_sKey(i - 1) & Chr$(255)
         End If
      Next i
      DeleteDC lHDC
      sKeys = sKeys & Chr$(255)
            
      ReDim Preserve b(0 To lStart - 1) As Byte
         
      iFile = FreeFile
      Open sFile For Binary Access Write As #iFile
      Put #iFile, , lStart
      Put #iFile, , b()
      Put #iFile, , Len(sKeys)
      Put #iFile, , sKeys
      Close #iFile
      
      SaveToFile = True
   End If
   
   Exit Function
   
SaveToFileError:
   Dim lErr As Long, sErr As String
   lErr = Err.Number: sErr = Err.Description
   If (iFile <> 0) Then
      Close #iFile
   End If
   Err.Raise lErr, App.EXEName & ".vbalImageList", sErr
   Exit Function
End Function
Public Function LoadFromFile(ByVal sFile As String) As Boolean
Attribute LoadFromFile.VB_Description = "Loads a set of  images from a file previously created with the SaveToFile method."
Dim b() As Byte
Dim iFile As Integer
Dim lSize As Long
Dim lStart As Long
Dim lItemSize As Long
Dim hIcon As Long
Dim lHDC As Long
Dim iKeySize As Long
Dim sKeys As String
Dim iOrigCount As Long

On Error GoTo LoadFileError
   
   ' Loads the image data to a file:
   
   If (m_hIml <> 0) Then
      iFile = FreeFile
      Open sFile For Binary Access Read As #iFile
      Get #iFile, , lSize
      ReDim b(0 To lSize - 1) As Byte
      Get #iFile, , b()
      If Not LOF(iFile) Then
         Get #iFile, , iKeySize
         If (iKeySize > 0) Then
            sKeys = String$(iKeySize, 255)
            Get #iFile, , sKeys
         End If
      End If
      Close #iFile
         
      iOrigCount = ImageCount
      lHDC = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
      Do While lStart < lSize
         DeSerialiseIcon lHDC, hIcon, b(), lStart, lItemSize
         ImageList_AddIcon m_hIml, hIcon
         DestroyIcon hIcon
         lStart = lStart + lItemSize
      Loop
      DeleteDC lHDC
      
      pEnsureKeys
      pDeserialiseKeys iOrigCount - 1, sKeys
      
      LoadFromFile = True
   End If
   
   Exit Function

LoadFileError:
   Dim lErr As Long, sErr As String
   lErr = Err.Number: sErr = Err.Description
   If (iFile <> 0) Then
      Close #iFile
   End If
   Err.Raise lErr, App.EXEName & ".vbalImageList", sErr
   Exit Function
End Function
Private Sub pDeserialiseKeys(ByVal lStart As Long, ByVal sKeys As String)
Dim iPos As Long
Dim iLastPos As Long
Dim lKey As Long
Dim lKeyCount As Long

   lKey = lStart
   On Error Resume Next
   lKeyCount = UBound(m_sKey)
   If (Err.Number <> 0) Then lKeyCount = 0
   
   If (sKeys <> "") Then
      iLastPos = 1
      Do
         iPos = InStr(iLastPos, sKeys, Chr$(255))
         If (iPos > 0) Then
            If iPos - iLastPos > 1 Then
               m_sKey(lKey) = Mid$(sKeys, iLastPos, iPos - iLastPos)
            End If
            lKey = lKey + 1
            iLastPos = iPos + 1
         End If
      Loop While iPos <> 0 And lKey < lKeyCount
      If (lKey <= lKeyCount) Then
         If iPos = 0 Or iPos < iLastPos Then
            If Len(sKeys) - iLastPos > 0 Then
               m_sKey(lKey) = Mid$(sKeys, iLastPos)
            End If
         Else
            m_sKey(lKey) = Mid$(sKeys, iLastPos, iPos - iLastPos)
         End If
      End If
   End If
End Sub

Private Sub UserControl_Initialize()
   m_lIconSizeX = 16
   m_lIconSizeY = 16
   m_eColourDepth = ILC_COLOR
End Sub

Private Sub UserControl_InitProperties()
    If (Create()) Then
        ' ok
    End If
End Sub

Private Sub UserControl_Paint()
Dim tR As RECT
Dim sC As String
Dim hBr As Long
Dim lHDC As Long

   tR.Right = 36
   tR.Bottom = 36
   lHDC = UserControl.hdc
   
   ' Clear
   hBr = CreateSolidBrush(GetSysColor(COLOR_BTNFACE))
   FillRect lHDC, tR, hBr
   DeleteObject hBr
   
   ' Draw piccy:
   BitBlt lHDC, 2, 2, 32, 32, picImage.hdc, 0, 0, vbSrcCopy
   
   ' Draw border:
   DrawEdge lHDC, tR, BDR_RAISEDOUTER Or BDR_RAISEDINNER, BF_RECT
   
   ' Draw number of images if any:
   sC = ImageCount
   If (ImageCount > 0) Then
      tR.left = 3
      tR.Right = 34
      tR.Bottom = 34
      tR.tOp = 22
      DrawText lHDC, sC, Len(sC), tR, DT_LEFT
   End If
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
Dim b() As Byte
Dim lSize As Long
Dim lStart As Long
Dim lItemSize As Long
Dim hIcon As Long
Dim lHDC As Long
Dim lKeyCount As Long
Dim sKeys As String

   ' Read the image size:
   IconSizeX = PropBag.ReadProperty("IconSizeX", 16)
   IconSizeY = PropBag.ReadProperty("IconSizeY", 16)
   ColourDepth = PropBag.ReadProperty("ColourDepth", ILC_COLOR)
   
   ' Create the image list:
   If Create() Then
      ' Read the image list pictures:
      lSize = PropBag.ReadProperty("Size", 0)
      If (lSize > 0) Then
         Debug.Print "ReadImages"
         b() = PropBag.ReadProperty("Images")
         lHDC = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
         Do While lStart < lSize
            If (DeSerialiseIcon(lHDC, hIcon, b(), lStart, lItemSize)) Then
               ImageList_AddIcon m_hIml, hIcon
               DestroyIcon hIcon
            End If
            lStart = lStart + lItemSize
         Loop
         DeleteDC lHDC
         Erase b
         
         ReDim m_sKey(0 To ImageCount - 1) As String
         lKeyCount = PropBag.ReadProperty("KeyCount", 0)
         sKeys = PropBag.ReadProperty("Keys", "")
         pDeserialiseKeys 0, sKeys
      End If
   End If
   
End Sub

Private Sub UserControl_Resize()
   UserControl.Width = 36 * Screen.TwipsPerPixelX
   UserControl.Height = 36 * Screen.TwipsPerPixelY
End Sub

Private Sub UserControl_Terminate()
    Destroy
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
Dim i As Long
Dim iCount As Long
Dim b() As Byte
Dim lSize As Long
Dim lStart As Long
Dim hIcon As Long
Dim bEmpty As Boolean
Dim lHDC As Long
Dim sKeys As String

   ' Write out the image size:
   PropBag.WriteProperty "IconSizeX", IconSizeX, 16
   PropBag.WriteProperty "IconSizeY", IconSizeY, 16
   PropBag.WriteProperty "ColourDepth", ColourDepth, ILC_COLOR
   
   ' Write out the icons in the image list:
   bEmpty = True
   If (m_hIml > 0) Then
      iCount = ImageCount
      If (iCount > 0) Then
         ReDim b(0 To 16384& * ImageCount) As Byte
      
         lHDC = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
         For i = 1 To ImageCount
            hIcon = ImageList_GetIcon(m_hIml, i - 1, 0)
            If (hIcon <> 0) And (hIcon <> -1) Then
               SerialiseIcon lHDC, hIcon, b(), lStart, lSize
               DestroyIcon hIcon
            End If
            lStart = lStart + lSize
         Next i
         DeleteDC lHDC
         If (lStart > 0) Then
            Debug.Print "WriteImages"
            ReDim Preserve b(0 To lStart - 1) As Byte
            PropBag.WriteProperty "Size", lStart
            PropBag.WriteProperty "Images", b
            Erase b
            bEmpty = False
         End If
      End If
   End If
      
   If (bEmpty) Then
      PropBag.WriteProperty "Size", 0, 0
      PropBag.WriteProperty "Images", 0, 0
      PropBag.WriteProperty "KeyCount", 0, 0
      PropBag.WriteProperty "Keys", "", ""
   Else
      ' Write out the keys:
      PropBag.WriteProperty "KeyCount", ImageCount
      For i = 1 To iCount
         sKeys = sKeys & m_sKey(i - 1) & Chr$(255)
      Next i
      If Len(sKeys) > 0 Then
         sKeys = left$(sKeys, Len(sKeys) - 1)
      End If
      PropBag.WriteProperty "Keys", sKeys
   End If
End Sub
