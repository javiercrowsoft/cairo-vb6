Attribute VB_Name = "mFile"
Option Explicit

'--------------------------------------------------------------------------------
' mFile
' 29-01-06

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones
    Private Declare Function GetWindowsDirectory Lib "kernel32" Alias "GetWindowsDirectoryA" (ByVal lpBuffer As String, ByVal nSize As Long) As Long
    
'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "mFile"

Public Const gstrSEP_DIR$ = "\"                         ' Directory separator character
Public Const gstrSEP_DIRALT$ = "/"                      ' Alternate directory separator character
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function GetFileName_(ByVal FullPath As String) As String
  GetFileName_ = GetFileNameWithoutExt_(FullPath) + "." + GetFileExt_(FullPath)
End Function

Public Function GetFileNameWithoutExt_(ByVal FullPath As String) As String
    Dim Path As String
    Dim FileName As String
    Dim nSepPos As Long
    Dim sSEP As String

    SeparatePathAndFileName_ FullPath, Path, FileName
    
    nSepPos = Len(FileName)
    
    If nSepPos = 0 Then
        GetFileNameWithoutExt_ = FullPath
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
            GetFileNameWithoutExt_ = FileName
        Case Else
            GetFileNameWithoutExt_ = Left$(FileName, nSepPos - 1)
    End Select
End Function

Public Function GetPath_(ByVal FullPath As String) As String
    Dim Path As String
    Dim FileName As String

    SeparatePathAndFileName_ FullPath, Path, FileName
    
    GetPath_ = Path
End Function

Public Function GetFileExt_(ByVal FullPath As String) As String
    Dim Path As String
    Dim FileName As String
    Dim nSepPos As Long
    Dim sSEP As String

    SeparatePathAndFileName_ FullPath, Path, FileName
    
    nSepPos = Len(FileName)
    
    If nSepPos = 0 Then
        GetFileExt_ = ""
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
            GetFileExt_ = ""
        Case Else
            ' Devuelvo la extension
            GetFileExt_ = Mid$(FileName, nSepPos + 1)
    End Select
End Function

Public Sub SeparatePathAndFileName_(FullPath As String, _
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

Public Function CopyFile_(ByVal Fuente As String, ByVal Destino As String) As Boolean
  On Error GoTo ControlError
  FileCopy Fuente, Destino
  CopyFile_ = True
  Exit Function
ControlError:
  MngError Err, "CopyFile_", C_Module, ""
End Function

Public Function Delete_(ByVal File As String) As Boolean

  On Error Resume Next

  Err = 0

  If Dir(File) <> "" Then

    If Err = 0 Then

      On Error GoTo ControlError

100            SetAttr File, vbNormal
101            Kill File

    Else
      Exit Function
    End If

  End If

  Delete_ = True

  GoTo ExitProc
ControlError:
  MngError Err, "Delete_", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function FileGetValidPath(ByVal Path As String)
  If Right(Path, 1) = "\" Then
    FileGetValidPath = Path
  Else
    FileGetValidPath = Path & "\"
  End If
End Function

Public Function FileCreateFolder(ByVal Folder As String)
  If Not FileFolderExists_(Folder) Then
    MkDir Folder
  End If
End Function

Public Function FileFolderExists_(ByVal File As String) As Boolean
  On Error Resume Next
  Err.Clear
  FileFolderExists_ = Dir(File, vbDirectory) <> ""
  If Err.Number <> 0 Then
    FileFolderExists_ = False
  End If
End Function

Public Function FileExists_(ByVal File As String) As Boolean
  On Error Resume Next
  Err.Clear
  FileExists_ = Dir(File) <> ""
  If Err.Number <> 0 Then
    FileExists_ = False
  End If
End Function

Public Function GetWindowsDir_() As String
  Dim strFolder As String
  Dim N As Integer
  strFolder = String$(255, " ")
  N = GetWindowsDirectory(strFolder, Len(strFolder))
  GetWindowsDir_ = Left$(strFolder, N)
End Function
' funciones friend
' funciones privadas

' Determines if a character is a path separator (\ or /).
Private Function IsSeparator(Character As String) As Boolean
    Select Case Character
        Case gstrSEP_DIR
            IsSeparator = True
        Case gstrSEP_DIRALT
            IsSeparator = True
    End Select
End Function
' construccion - destruccion
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next





