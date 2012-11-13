Attribute VB_Name = "mFileIcons"
Option Explicit

' =================================================================================
' Declares and types
' =================================================================================
Private Const MAX_PATH = 260
Private Type SHFILEINFO
    hIcon As Long
    iIcon As Long
    dwAttributes As Long
    szDisplayName As String * MAX_PATH
    szTypeName As String * 80
End Type
Private Declare Function SHGetFileInfo Lib "shell32.dll" Alias "SHGetFileInfoA" _
    (ByVal pszPath As String, ByVal dwAttributes As Long, psfi As SHFILEINFO, ByVal cbSizeFileInfo As Long, ByVal uFlags As Long) As Long
Private Enum EShellGetFileInfoConstants
        SHGFI_ICON = &H100                ' // get icon
        SHGFI_DISPLAYNAME = &H200            ' // get display name
        SHGFI_TYPENAME = &H400            ' // get type name
        SHGFI_ATTRIBUTES = &H800            ' // get attributes
        SHGFI_ICONLOCATION = &H1000        ' // get icon location
        SHGFI_EXETYPE = &H2000            ' // return exe type
        SHGFI_SYSICONINDEX = &H4000        ' // get system icon index
        SHGFI_LINKOVERLAY = &H8000        ' // put a link overlay on icon
        SHGFI_SELECTED = &H10000            ' // show icon in selected state
        SHGFI_ATTR_SPECIFIED = &H20000    ' // get only specified attributes
        SHGFI_LARGEICON = &H0                ' // get large icon
        SHGFI_SMALLICON = &H1                ' // get small icon
        SHGFI_OPENICON = &H2                ' // get open icon
        SHGFI_SHELLICONSIZE = &H4            ' // get shell size icon
        SHGFI_PIDL = &H8                    ' // pszPath is a pidl
        SHGFI_USEFILEATTRIBUTES = &H10    ' // use passed dwFileAttribute
End Enum
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
Private Declare Function OleCreatePictureIndirect Lib "olepro32.dll" ( _
      lpPictDesc As PictDesc, _
      riid As Guid, _
      ByVal fPictureOwnsHandle As Long, _
      ipic As IPicture _
   ) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long

Private Declare Function GetTempPath Lib "kernel32" Alias "GetTempPathA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long
Private Declare Function GetTempFileName Lib "kernel32" Alias "GetTempFileNameA" (ByVal lpszPath As String, ByVal lpPrefixString As String, ByVal wUnique As Long, ByVal lpTempFileName As String) As Long

' =================================================================================
' Interface
' =================================================================================
Public Enum EGetIconTypeConstants
    egitSmallIcon = 1
    egitLargeIcon = 2
End Enum


Private Function GetIcon( _
        ByVal sFIle As String, _
        Optional ByVal EIconType As EGetIconTypeConstants = egitLargeIcon _
    ) As Object
Dim lR As Long
Dim hIcon As Long
Dim tSHI As SHFILEINFO
Dim lFlags As Long
    
    ' Prepare flags for SHGetFileInfo to get the icon:
    If (EIconType = egitLargeIcon) Then
        lFlags = SHGFI_ICON Or SHGFI_LARGEICON
    Else
        lFlags = SHGFI_ICON Or SHGFI_SMALLICON
    End If
    lFlags = lFlags And Not SHGFI_LINKOVERLAY
    lFlags = lFlags And Not SHGFI_OPENICON
    lFlags = lFlags And Not SHGFI_SELECTED
    ' Call to get icon:
    lR = SHGetFileInfo(sFIle, 0&, tSHI, Len(tSHI), lFlags)
    If (lR <> 0) Then
        ' If we succeeded, the hIcon member will be filled in:
        hIcon = tSHI.hIcon
        ' If we have an icon, convert it to a VB picture and return it:
        If Not (hIcon = 0) Then
            Set GetIcon = IconToPicture(hIcon)
        End If
    End If
    
End Function
Private Function IconToPicture(ByVal hIcon As Long) As IPicture
    
    If hIcon = 0 Then Exit Function
        
    ' This is all magic if you ask me:
    Dim NewPic As Picture, PicConv As PictDesc, IGuid As Guid
    
    PicConv.cbSizeofStruct = Len(PicConv)
    PicConv.picType = vbPicTypeIcon
    PicConv.hImage = hIcon
    
    'IGuid.Data1 = &H20400
    'IGuid.Data4(0) = &HC0
    'IGuid.Data4(7) = &H46
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
    OleCreatePictureIndirect PicConv, IGuid, True, NewPic
    
    Set IconToPicture = NewPic
    
End Function
Private Function GetFileTypeName( _
        ByVal sFIle As String _
    ) As String
Dim lR As Long
Dim tSHI As SHFILEINFO
Dim iPos As Long

    lR = SHGetFileInfo(sFIle, 0&, tSHI, Len(tSHI), SHGFI_TYPENAME)
    If (lR <> 0) Then
        iPos = InStr(tSHI.szTypeName, Chr$(0))
        If (iPos = 0) Then
            GetFileTypeName = tSHI.szTypeName
        ElseIf (iPos > 1) Then
            GetFileTypeName = Left$(tSHI.szTypeName, (iPos - 1))
        Else
            GetFileTypeName = ""
        End If
    End If
    
End Function
Public Function AddIconToImageList( _
      ByVal sFIle As String, _
      ByRef ilsThis As ImageList, _
      ByVal sDefault As String _
   ) As String
Dim sExt As String
Dim sTempFile As String
Dim i As Long
Dim iFile As Long
Dim iIndex As Long

   For i = Len(sFIle) To 1 Step -1
      If (Mid$(sFIle, i, 1) = ".") Then
         sExt = Mid$(sFIle, i)
         Exit For
      End If
   Next i
   sExt = UCase$(sExt)
   If (sExt <> "") And (sExt <> "EXE") Then
      On Error Resume Next
      iIndex = ilsThis.ListImages(sExt).Index
      If (Err.Number = 0) Then
         AddIconToImageList = sExt
      Else
         On Error GoTo ErrorHandler
         sTempFile = TempDir
         If (Right$(sTempFile, 1) <> "\") Then sTempFile = sTempFile & "\"
         sTempFile = sTempFile & "VBUZTEMP" & sExt
         KillFileIfExists sTempFile
         iFile = FreeFile
         Open sTempFile For Binary Access Write As #iFile
         Put #iFile, , "TEMP"
         Close #iFile
         ilsThis.ListImages.Add , sExt, GetIcon(sTempFile, egitSmallIcon)
         ilsThis.ListImages(sExt).Tag = GetFileTypeName(sTempFile)
         KillFileIfExists sTempFile
         AddIconToImageList = sExt
      End If
   Else
      AddIconToImageList = sDefault
   End If
   Exit Function
   
ErrorHandler:
   KillFileIfExists sTempFile
   AddIconToImageList = sDefault
   Exit Function
End Function

Public Sub KillFileIfExists(ByVal sFIle As String)
   On Error Resume Next
   Kill sFIle
End Sub

Public Property Get TempDir() As String
Dim sRet As String, c As Long
    sRet = String$(MAX_PATH, 0)
    c = GetTempPath(MAX_PATH, sRet)
    If c = 0 Then Err.Raise Err.LastDllError
    TempDir = Left$(sRet, c)
End Property
