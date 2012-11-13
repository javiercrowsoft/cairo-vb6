Attribute VB_Name = "mFiles"
Option Explicit

Private Const C_Module = "mFiles"

Public Const gstrSEP_DIR$ = "\"                         ' Directory separator character
Public Const gstrSEP_DIRALT$ = "/"                      ' Alternate directory separator character

Private m_last      As Integer
Private m_last2     As Integer

Public Sub InitLoadFiles(ByRef files() As String)
  m_last = 400
  m_last2 = 1
  ReDim files(m_last)
End Sub

Public Sub AddFile(ByVal FileName As String, ByRef files() As String)
  If m_last2 > m_last Then
    m_last = m_last + 100
    ReDim Preserve files(m_last)
  End If
  files(m_last2) = FileName
  m_last2 = m_last2 + 1
End Sub

Public Sub LoadFiles(ByVal Path As String, ByRef files() As String)
  On Error Resume Next
  
  Dim path2   As String
  Dim Ext     As String
  Dim s       As String
  Dim vDirs() As String
  
  ReDim vDirs(0)
  
  Dim q As Long
  
  For q = Len(Path) To 1 Step -1
    If Mid(Path, q, 1) = "\" Then Exit For
  Next
  
  path2 = Mid(Path, 1, q)
  Ext = Mid(Path, q + 1)
  
  s = Dir(path2, vbDirectory)
  Do
    If s = "" Then Exit Do
    If GetAttr(path2 & s) = vbDirectory And s <> ".." And s <> "." Then
      ReDim Preserve vDirs(UBound(vDirs) + 1)
      vDirs(UBound(vDirs)) = path2 & s
    End If
    s = Dir
  Loop
  
  Dim i As Integer
  For i = 1 To UBound(vDirs)
    
    If m_last2 > m_last Then
      m_last = m_last + 100
      ReDim Preserve files(m_last)
    End If
    files(m_last2) = vDirs(i)
    m_last2 = m_last2 + 1
  Next
  
  s = Dir(Path)
  
  Do
    If s = "" Then Exit Do
    If m_last2 > m_last Then
      m_last = m_last + 100
      ReDim Preserve files(m_last)
    End If
    files(m_last2) = path2 & s
    m_last2 = m_last2 + 1
    
    s = Dir
  Loop Until s = ""
End Sub

Public Function ExistsFolder(ByVal Folder As String) As Boolean
  On Error Resume Next
  Dim rslt As String
  rslt = Dir(Folder, vbDirectory)
  If rslt <> "" Then
    If Not GetAttr(Folder) And vbDirectory Then
      rslt = ""
    End If
  End If
  ExistsFolder = rslt <> ""
End Function

Public Function GetFileName(ByVal FullPath As String) As String
  Dim FileName As String
  Dim fileExt  As String
  
  fileExt = GetFileExt(FullPath)
  FileName = GetFileNameSinExt(FullPath)
  
  If fileExt <> vbNullString Then
    FileName = FileName & "." & fileExt
  End If
  
  GetFileName = FileName
End Function

Public Function GetFileNameSinExt(ByVal FullPath As String) As String
  Dim Path As String
  Dim FileName As String
  Dim nSepPos As Long
  Dim sSEP As String

  SeparatePathAndFileName FullPath, Path, FileName
  
  nSepPos = Len(FileName)
  
  If nSepPos = 0 Then
    GetFileNameSinExt = FullPath
    Exit Function
  End If
  
  sSEP = Mid$(FileName, nSepPos, 1)
  Do Until sSEP = "."
    nSepPos = nSepPos - 1
    If nSepPos = 0 Then Exit Do
    sSEP = Mid$(FileName, nSepPos, 1)
  Loop

  Select Case nSepPos
    Case 0
      'Si el separador no es encontrado entonces es un archivo sin extencion
      GetFileNameSinExt = FileName
    Case Else
      GetFileNameSinExt = Left$(FileName, nSepPos - 1)
  End Select
End Function

Public Function GetPath(ByVal FullPath As String) As String
  Dim Path As String
  Dim FileName As String

  SeparatePathAndFileName FullPath, Path, FileName
  
  GetPath = Path
End Function

Public Function GetFileExt(ByVal FullPath As String) As String
  Dim Path As String
  Dim FileName As String
  Dim nSepPos As Long
  Dim sSEP As String

  SeparatePathAndFileName FullPath, Path, FileName
  
  nSepPos = Len(FileName)
  
  If nSepPos = 0 Then
    GetFileExt = ""
    Exit Function
  End If
  
  sSEP = Mid$(FileName, nSepPos, 1)
  Do Until sSEP = "."
    nSepPos = nSepPos - 1
    If nSepPos = 0 Then Exit Do
    sSEP = Mid$(FileName, nSepPos, 1)
  Loop

  Select Case nSepPos
    Case 0
      'Si el separador no es encontrado entonces es un archivo sin extencion
      GetFileExt = ""
    Case Else
      ' Devuelvo la extension
      GetFileExt = Mid$(FileName, nSepPos + 1)
  End Select
End Function

Public Sub SeparatePathAndFileName(FullPath As String, _
                                   Optional ByRef Path As String, _
                                   Optional ByRef FileName As String)
  Dim nSepPos As Long
  Dim sSEP As String

  nSepPos = Len(FullPath)
  
  If nSepPos = 0 Then
    Path = FullPath
    FileName = FullPath
    Exit Sub
  End If
  sSEP = Mid$(FullPath, nSepPos, 1)
  Do Until IsSeparator(sSEP)
    nSepPos = nSepPos - 1
    If nSepPos = 0 Then Exit Do
    sSEP = Mid$(FullPath, nSepPos, 1)
  Loop

  Select Case nSepPos
    Case Len(FullPath)
      'Si el separador es encontrado al final entonces, se trata de un directorio raiz ej. c:\, d:\, etc.
      Path = Left$(FullPath, nSepPos - 1)
      FileName = FullPath
    Case 0
      'Si el separador no es encontrado entonces, se trata de un directorio raiz ej. c:, d:, etc.
      Path = FullPath
      FileName = FullPath
    Case Else
      Path = Left$(FullPath, nSepPos - 1)
      FileName = Mid$(FullPath, nSepPos + 1)
  End Select
End Sub

Public Function CopyFile(ByVal Fuente As String, ByVal Destino As String) As Boolean
  On Error GoTo ControlError
  FileCopy Fuente, Destino
  CopyFile = True
  Exit Function
ControlError:
  MngError Err, "CopyFile", C_Module, ""
End Function

Public Function Delete(ByVal File As String) As Boolean

  On Error Resume Next

  Err = 0

  If Dir(File) <> "" Then

    If Err = 0 Then
  
      On Error GoTo ControlError
  
100   SetAttr File, vbNormal
101   Kill File
  
    Else
      Exit Function
    End If

  End If

  Delete = True

  GoTo ExitProc
ControlError:
  MngError Err, "Delete", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Function IsSeparator(Character As String) As Boolean
  Select Case Character
    Case gstrSEP_DIR
      IsSeparator = True
    Case gstrSEP_DIRALT
      IsSeparator = True
  End Select
End Function




