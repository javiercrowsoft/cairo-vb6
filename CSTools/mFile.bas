Attribute VB_Name = "mFile"
Option Explicit

' Proposito: Rutinas de manejo de archivos.

Private Declare Function GetTempPath2 Lib "kernel32" Alias "GetTempPathA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long
' constantes
Private Const C_Module = "mAux"

Private Const gstrSEP_DIR$ = "\"                         ' Directory separator character
Private Const gstrSEP_DIRALT$ = "/"                      ' Alternate directory separator character

Public Function FileGetValidPath(ByVal Path As String)
  If Right(Path, 1) = "\" Then
    FileGetValidPath = Path
  Else
    FileGetValidPath = Path & "\"
  End If
End Function

Public Function FileGetPath(ByVal PathAndFile As String) As String
  Dim Path As String
  FileGetPathAndName PathAndFile, Path
  FileGetPath = Path
End Function

Public Sub FileGetPathAndName(PathAndName As String, _
                              Optional ByRef Path As String, _
                              Optional ByRef FileName As String)

  Dim seppos  As Integer
  Dim sep     As String
  
  seppos = Len(PathAndName)
  
  If seppos = 0 Then
    Path = PathAndName
    FileName = PathAndName
    Exit Sub
  End If
  sep = Mid$(PathAndName, seppos, 1)
  Do Until Iseparator(sep)
    seppos = seppos - 1
    If seppos = 0 Then Exit Do
    sep = Mid$(PathAndName, seppos, 1)
  Loop
  
  Select Case seppos
    Case Len(PathAndName)
      'Si el separador es encontrado al final entonces, se trata de un directorio raiz ej. c:\, d:\, etc.
      Path = Left$(PathAndName, seppos - 1)
      FileName = ""
    Case 0
      'Si el separador no es encontrado entonces, se trata de un directorio raiz ej. c:, d:, etc.
      If Mid(PathAndName, 2, 1) = ":" Then
        Path = PathAndName
        FileName = ""
      Else
        Path = ""
        FileName = PathAndName
      End If
    Case Else
      Path = Left$(PathAndName, seppos - 1)
      FileName = Mid$(PathAndName, seppos + 1)
  End Select
End Sub

'Determines if a character is a path separator (\ or /).
Private Function Iseparator(Character As String) As Boolean
    Select Case Character
        Case gstrSEP_DIR
            Iseparator = True
        Case gstrSEP_DIRALT
            Iseparator = True
    End Select
End Function

Public Function FileGetNameWithoutExt(ByVal PathAndName As String) As String
    Dim Path As String
    Dim FileName As String
    Dim seppos As Long
    Dim sep As String

    FileGetPathAndName PathAndName, Path, FileName
    
    seppos = Len(FileName)
    
    If seppos = 0 Then
      FileGetNameWithoutExt = FileName
      Exit Function
    End If
    
    sep = Mid$(FileName, seppos, 1)
    Do Until sep = "."
      seppos = seppos - 1
      If seppos = 0 Then Exit Do
      sep = Mid$(FileName, seppos, 1)
    Loop

    Select Case seppos
        Case 0
            'Si el separador no es encontrado entonces es un archivo sin extencion
            FileGetNameWithoutExt = FileName
        Case Else
            FileGetNameWithoutExt = Left$(FileName, seppos - 1)
    End Select
End Function

Public Function FileGetName(ByVal PathAndName As String) As String
    Dim Path As String
    Dim FileName As String

    FileGetPathAndName PathAndName, Path, FileName
    
    FileGetName = FileName
End Function


Public Function FileGetType(ByVal PathAndName As String) As String
  Dim Path As String
  Dim FileName As String
  Dim seppos As Long
  Dim sep As String
  
  FileGetPathAndName PathAndName, Path, FileName
  
  seppos = Len(FileName)
  
  If seppos = 0 Then
    FileGetType = ""
    Exit Function
  End If
  
  sep = Mid(FileName, seppos, 1)
  Do Until sep = "."
    seppos = seppos - 1
    If seppos = 0 Then Exit Do
    sep = Mid(FileName, seppos, 1)
  Loop
  
  Select Case seppos
    Case 0
      'Si el separador no es encontrado entonces es un archivo sin extencion
      FileGetType = ""
    Case Else
      ' Devuelvo la extension
      FileGetType = Mid(FileName, seppos + 1)
  End Select
End Function

Public Function FileIsWriteable(ByVal File As String) As Boolean
  FileIsWriteable = GetAttr(File) <> vbReadOnly
End Function

Public Function FileExists(ByVal File As String) As Boolean
  On Error Resume Next

  Err = 0
  If File = "" Then Exit Function
  If Dir(File) = "" Then Exit Function
  ' En NT da un error cuando el path es invalido
  If Err.Number <> 0 Then Exit Function
  If GetAttr(File) = vbDirectory Then Exit Function
  
  FileExists = True
End Function

Public Function FileDelete(ByVal File As String) As Boolean
  On Error Resume Next

  Err = 0
  If Dir(File) <> "" Then
  
    If Err = 0 Then
  
      On Error GoTo ControlError
      
      Kill File
  
    Else
      Exit Function
    End If
  End If
  
  FileDelete = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "FileDelete", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function FileSaveTextTofile(ByRef File As String, ByVal Text As String, Optional ByVal ShowOpenDialog As Boolean = False, Optional ByRef cd As CommonDialog, Optional ByVal AskIfChoiceAnotherFileName As Boolean) As Boolean
  On Error GoTo ControlError

  Dim Filter    As String
  Dim FileName  As String
  
  FileName = File
  
  If ShowOpenDialog Then
    Filter = FileGetType(File)
    If Filter = "" Then
      Filter = "Todos los archivos|*.*"
    Else
      Filter = "Archivos *." & Filter & "|*." & Filter
    End If
    
    Do
      FileName = File
      If Not ShowSaveFileDLG(cd, FileName, Filter) Then Exit Function
      
      If AskIfChoiceAnotherFileName Then
        If File <> FileName Then
          If FileExists(FileName) Then
            If Not Ask("El archivo " & FileName & " ya existe./n/n¿Desea reemplazarlo?") Then
              FileName = ""
            End If
          End If
        End If
      End If
    Loop Until FileName <> ""
  End If
  
  Dim f As Integer
  f = FreeFile()
  
  Open FileName For Output Access Write As f
  
  Print #f, Text
  
  File = FileName
  FileSaveTextTofile = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "FileReadFullFile", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Close f
End Function

Public Function FileReadFullFile(ByVal File As String, ByRef buffer As String, Optional ByVal ShowOpenDialog As Boolean = False, Optional ByRef cd As CommonDialog) As Boolean
  On Error GoTo ControlError
  
  Dim Filter As String
  
  If Not FileExists(File) Then
    If Not ShowOpenDialog Then Exit Function
      
    Filter = FileGetType(File)
    If Filter = "" Then
      Filter = "Todos los archivos|*.*"
    Else
      Filter = "Archivos *." & Filter & "|" & Filter
    End If
    If Not ShowOpenFileDLG(cd, File, Filter) Then Exit Function
    
  End If
    
  Dim f As Integer
  Dim Sizef As Long
  
  Sizef = FileLen(File)
  f = FreeFile()
  
  Open File For Input Access Read As f
  
  buffer = Input(Sizef, #f)

  FileReadFullFile = True
  
  GoTo ExitProc
ControlError:
  MngError Err, "FileReadFullFile", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  
  Close f
End Function

Public Function GetTempPath() As String
  On Error GoTo ControlError
  
  Dim buffer As String
  Dim length As Long
  
  buffer = String(255, " ")
  
  length = GetTempPath2(255, buffer)
  
  If length > 0 Then buffer = Left(buffer, length)
  
  GetTempPath = buffer
  
  GoTo ExitProc
ControlError:
  MngError Err, "GetTempPath", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function ShowOpenFileDLG(ByRef cd As CommonDialog, ByRef FileName As String, Optional ByVal Filter As String = "Todos los archivos|*.*", Optional ByVal Title As String = "Abrir") As Boolean
  On Error GoTo ControlError
  With cd
    cd.CancelError = True
    cd.FileName = FileName
    cd.DialogTitle = Title
    cd.Filter = Filter

    cd.ShowOpen
    
    FileName = cd.FileName
  End With
  
  ShowOpenFileDLG = True
  
  GoTo ExitProc
ControlError:
  '32755 cancel pressed
  If Err.Number <> 32755 Then MngError Err, "ShowOpenFileDLG", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Function ShowSaveFileDLG(ByRef cd As CommonDialog, ByRef FileName As String, Optional ByVal Filter As String = "Todos los archivos|*.*", Optional ByVal Title As String = "Guardar") As Boolean
  On Error GoTo ControlError
  With cd
    cd.CancelError = True
    cd.FileName = FileName
    cd.DialogTitle = Title
    cd.Filter = Filter
    
    cd.ShowSave
    
    FileName = cd.FileName
  End With
  
  ShowSaveFileDLG = True
  
  GoTo ExitProc
ControlError:
  '32755 cancel pressed
  If Err.Number <> 32755 Then MngError Err, "ShowSaveFileDLG", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

