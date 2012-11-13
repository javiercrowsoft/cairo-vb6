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
Option Explicit

'--------------------------------------------------------------------------------
' cImage
' 17-10-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cImage"
' estructuras
' variables privadas
' eventos
' propiedades publicas
Public Function LoadImageFromFile(ByVal FullFileName As String, ByRef picImage As Object, Optional ByRef shImage As Object) As Boolean
  On Error GoTo ControlError

  LoadImageFromFile = pLoadImageAux(FullFileName, picImage, shImage)

  GoTo ExitProc
ControlError:
  MngError Err, "LoadImageFromFile", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function LoadImage(ByRef CommDialog As Object, ByRef picImage As Object, Optional ByRef shImage As Object, Optional ByRef FullFileName As String) As Boolean
  On Error GoTo ControlError
  
  Dim File As CSKernelFile.cFile
  Set File = New CSKernelFile.cFile
  
  File.Init "txImageFile_ButtonClick", C_Module, CommDialog
  File.Filter = "Todas las imagenes|*.bmp;*.jpg;*.gif;*.ico|Mapas de bits|*.bmp|Iconos|*.ico|Archivos JPG|*.jpg|Archivos GIF|*.gif"
  If Not File.FOpen(vbNullString, csBinaryRead, False, False, csShared, True, True) Then GoTo ExitProc
  
  File.FClose
  
  FullFileName = File.FullName
  
  LoadImage = pLoadImageAux(File.FullName, picImage, shImage)
  
  GoTo ExitProc
ControlError:
  MngError Err, "LoadImage", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
  File.FClose
  Set File = Nothing
End Function
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Function pLoadImageAux(ByVal FullName As String, ByRef picImage As Object, Optional ByRef shImage As Object) As Boolean
  Dim File As cFile
  Set File = New cFile
  
  If LCase$(File.GetFileExt(FullName)) = "ico" Then
    Set picImage.Picture = pSelectImage(FullName, picImage)
  Else
    Set picImage.Picture = LoadPicture(FullName)
  End If
  
  With picImage
    If TypeOf picImage Is Control Then
      .Move .Left, .Top, .ScaleX(.Picture.Width, vbHimetric, vbTwips), .ScaleY(.Picture.Height, vbHimetric, vbTwips)
    End If
    If Not shImage Is Nothing Then
      shImage.Width = .Width + 40
      shImage.Height = .Height + 40
    End If
  End With
  
  pLoadImageAux = True
End Function

Private Function pSelectImage(ByVal FullFileIco As String, ByRef picImage As Object) As IPictureDisp
  On Error GoTo ControlError
  
  Dim f As fIcon
  Set f = New fIcon
  
  Load f
  f.ShowImages FullFileIco
  
  f.Show vbModal
  
  Dim Index As Long
  
  Index = f.SelectedImage
  
  If Index > 0 Then
    Dim oIcon As cFileIcon
    Set oIcon = New cFileIcon
    If Not oIcon.LoadIcon(FullFileIco) Then
      Set pSelectImage = LoadPicture()
    Else
      Set pSelectImage = oIcon.BitmapPicture(picImage.hDC, Index)
    End If
  Else
    Set pSelectImage = LoadPicture()
  End If
  GoTo ExitProc
ControlError:
  MngError Err, "pSelectImage", C_Module, vbNullString
ExitProc:
  Unload f
End Function

' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


