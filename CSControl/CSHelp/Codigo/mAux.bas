Attribute VB_Name = "mAux"
Option Explicit
'--------------------------------------------------------------------------------
' mAux
' 02-08-04

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
   
    ' estructuras
    Private Type PictDesc
      cbSizeofStruct As Long
      picType As Long
      hImage As Long
      xExt As Long
      yExt As Long
    End Type
    
    Private Type Guid
      Data1 As Long
      Data2 As Integer
      Data3 As Integer
      Data4(0 To 7) As Byte
    End Type
    
    ' funciones

    ' declare for loading icon from resource
    Private Declare Function LoadImageBynum& Lib "user32" Alias "LoadImageA" (ByVal hInst&, _
                        ByVal lpszName&, ByVal uType&, ByVal cxDesired&, ByVal cyDesired&, ByVal fuLoad&)
    
    Private Declare Function OleCreatePictureIndirect Lib "olepro32.dll" (lpPictDesc As PictDesc, riid As Guid, ByVal fPictureOwnsHandle As Long, ipic As IPicture) As Long
    
    Private Const IMAGE_ICON As Long = 1&
    Private Const LR_DEFAULTCOLOR As Long = 0&
'--------------------------------------------------------------------------------
' constantes
Public Sub CreateImage(ByRef Img As Image, ByVal ResId As Long)
  If Img.Picture.Handle = 0 Then
    Set Img.Picture = CreateImage2(ResId)
  End If
End Sub

Public Function CreateImage2(ByVal ResId As Long) As IPictureDisp
  Dim hIcon  As Long
  
  ' load icon resource #101 from the app resource file.
  hIcon = LoadImageBynum(App.hInstance, ResId, IMAGE_ICON, 16&, 16&, LR_DEFAULTCOLOR)
  
  Set CreateImage2 = IconToPicture(hIcon)
End Function

Public Function IconToPicture(ByVal hIcon As Long) As IPicture
   If hIcon = 0 Then Exit Function
   
   Dim oNewPic As Picture
   Dim tPicConv As PictDesc
   Dim IGuid As Guid
   
   With tPicConv
   .cbSizeofStruct = Len(tPicConv)
   .picType = vbPicTypeIcon
   .hImage = hIcon
   End With
   
   ' Fill in magic IPicture GUID {7BF80980-BF32-101A-8BBB-00AA00300CAB}
   With IGuid
    .Data1 = &H7BF80980
    .Data2 = &HBF32
    .Data3 = &H101A
    .Data4(0) = &H8B
    .Data4(1) = &HBB
    .Data4(2) = &H0
    .Data4(3) = &HAA
    .Data4(4) = &H0
    .Data4(5) = &H30
    .Data4(6) = &HC
    .Data4(7) = &HAB
   End With
   OleCreatePictureIndirect tPicConv, IGuid, True, oNewPic
   
   Set IconToPicture = oNewPic
End Function


