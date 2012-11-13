VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'//////////////////////////////////////////////
' CONSTANTES PRIVADOS
Private Const OPEN_READ     As Integer = 1
Private Const OPEN_WRITE    As Integer = 2
Private Const OPEN_APPEND   As Integer = 3
Private Const OPEN_BINARY_READ     As Integer = 4
Private Const OPEN_BINARY_WRITE    As Integer = 5

Private Const gstrSEP_DIR = "\"
Private Const gstrSEP_DIRALT = "/"

'//////////////////////////////////////////////
' MIEMBROS PRIVADOS

' Indica si la inicializacion de la clase tuvo exito
Private mFileOpen    As Boolean

Private mIdArchivo  As Integer

Private mPathScript As String

Private mFullFileName As String

Private m_ModoOpen As Integer

'//////////////////////////////////////////////
' INTERFAZ
Public Property Get FullFileName() As String
    FullFileName = mFullFileName
End Property

Public Property Get IsOpenFile() As Boolean
  IsOpenFile = mFileOpen
End Property

Public Property Get PathFile() As String
  Dim Path As String
  FileSeparatePathAndName mFullFileName, Path
  PathFile = Path
End Property

Public Property Get FileName() As String
  Dim name As String
  FileSeparatePathAndName mFullFileName, , name
  FileName = name
End Property
'//////////////////////////////////////////////
' FUNCIONES PUBLICAS


'//////////////////////////////////////////////
' ARCHIVO

Public Function IsEof() As Boolean
    If mFileOpen Then
    
      If m_ModoOpen = OPEN_BINARY_READ Then
        IsEof = Loc(mIdArchivo) = LOF(mIdArchivo)
      ElseIf m_ModoOpen = OPEN_READ Then
        IsEof = EOF(mIdArchivo)
      End If
    Else
        IsEof = True
    End If
End Function

Public Function PorcentajeLeido() As Integer
  PorcentajeLeido = (Loc(mIdArchivo) / LOF(mIdArchivo)) * 100
End Function

Public Function ReadFileLine(ByRef sLine As String) As Boolean
    On Error GoTo ControlError
    If Not mFileOpen Then Exit Function
    
    If m_ModoOpen = OPEN_READ Then
    
      If Not EOF(mIdArchivo) Then
          Line Input #mIdArchivo, sLine
          ReadFileLine = True
      End If
    
    ElseIf m_ModoOpen = OPEN_BINARY_READ Then

      If Not LOF(mIdArchivo) = Loc(mIdArchivo) Then
          sLine = Input(1, #mIdArchivo)
          ReadFileLine = True
      End If
    Else
      Exit Function
    End If
        
    GoTo ExitProc
ControlError:

ExitProc:
End Function

Public Function WriteFileLine(ByVal sLine As String) As Boolean
    On Error GoTo ControlError
    If Not mFileOpen Then Exit Function
    
    
    If m_ModoOpen = OPEN_WRITE Then
    
      Print #mIdArchivo, sLine
      
    ElseIf m_ModoOpen = OPEN_BINARY_WRITE Then

      Put #mIdArchivo, , sLine
    
    Else
      Exit Function
    End If
    
    WriteFileLine = True
    GoTo ExitProc
ControlError:

ExitProc:
End Function

Public Function WriteFileSeparator(Optional iCantChar As Integer) As Boolean
    WriteFileSeparator = WriteFileLine(String(iCantChar, "-"))
End Function

Public Function OpenArchivoRead(ByVal sFile As String, Optional ByVal MostrarError As Boolean = True, Optional MostrarDialogoSioSi As Boolean = False, Optional ByVal Filtro As String) As Boolean
    OpenArchivoRead = OpenArchivo(sFile, OPEN_READ, , , MostrarError, MostrarDialogoSioSi, Filtro)
End Function

Public Function OpenArchivoReadBinary(ByVal sFile As String, Optional ByVal MostrarError As Boolean = True, Optional MostrarDialogoSioSi As Boolean = False) As Boolean
    OpenArchivoReadBinary = OpenArchivo(sFile, OPEN_BINARY_READ, , , MostrarError, MostrarDialogoSioSi)
End Function

Public Function OpenArchivoWrite(ByVal sFile As String, Optional ByVal bCreate As Boolean = False, Optional ByVal bNew As Boolean = False, Optional ByVal MostrarError As Boolean = True, Optional MostrarDialogoSioSi As Boolean = False) As Boolean
    OpenArchivoWrite = OpenArchivo(sFile, OPEN_WRITE, bCreate, bNew, MostrarError, MostrarDialogoSioSi)
End Function

Public Function OpenArchivoWriteBinary(ByVal sFile As String, Optional ByVal bCreate As Boolean = False, Optional ByVal bNew As Boolean = False, Optional ByVal MostrarError As Boolean = True, Optional MostrarDialogoSioSi As Boolean = False) As Boolean
    OpenArchivoWriteBinary = OpenArchivo(sFile, OPEN_BINARY_WRITE, bCreate, bNew, MostrarError, MostrarDialogoSioSi)
End Function

Public Function OpenArchivoAppend(ByVal sFile As String, Optional ByVal bCreate As Boolean = False, Optional ByVal MostrarError As Boolean = True, Optional MostrarDialogoSioSi As Boolean = False) As Boolean
    OpenArchivoAppend = OpenArchivo(sFile, OPEN_APPEND, bCreate, , MostrarError, MostrarDialogoSioSi)
End Function

Private Function OpenArchivo(ByVal sFile As String, _
                             ByVal modo As Integer, _
                             Optional ByVal bCreate As Boolean = False, _
                             Optional ByVal bNew As Boolean = False, _
                             Optional ByVal MostrarError As Boolean = True, _
                             Optional MostrarDialogoSioSi As Boolean = False, _
                             Optional ByVal Filtro As String) As Boolean
    Const PressCancel = 32755

    Dim sFileFullName As String
    Dim sFile2 As String
    Dim sPath As String

    On Error GoTo ControlError

    ' Antes de abrir otro archivo cierro cualquier archivo que
    ' pueda tener abierto
    CloseArchivo
    
    F_Main.Dialog.CancelError = True

    If mFileOpen = False Then
        mIdArchivo = FreeFile()

        ' Si esta vacio lo inicializo
        mPathScript = IIf(mPathScript = "", App.Path, mPathScript)

        ' Obtengo el nombre completo del archivo
        
        ' si el nombre que me pasaron tiene path
        If FileGetPath(sFile) <> "" Then
          sFileFullName = sFile
        Else
          sFileFullName = mPathScript + "\" + sFile
        End If
        
        ' Compruebo si hay que crearlo
        If bCreate Then
        
            ' Si tiene que ser nuevo lo borro si existe
            If bNew Then
                If Dir(sFileFullName) <> "" Then
                    Kill sFileFullName
                End If
            End If
            If Not MostrarDialogoSioSi Then
              ' Lo creo
              Open sFileFullName For Output Access Write As mIdArchivo
              Close mIdArchivo
            End If
        End If

        ' Compruebo que el archivo exista en el directorio esperado
        If Dir(sFileFullName) = "" Or MostrarDialogoSioSi Then

            ' Obtengo el nombre del archivo
            FileSeparatePathAndName sFile, sPath, sFile2

            ' Lo busco en el directorio actual
            sFileFullName = CurDir$ + "\" + sFile2

            If Dir(sFileFullName) = "" Or MostrarDialogoSioSi Then


                If Vacio(Filtro) Then
                  F_Main.Dialog.Filter = "Archivos " & FileGetExtension(sFile2) + "|*." + FileGetExtension(sFile2)
                Else
                  F_Main.Dialog.Filter = Filtro
                End If
                F_Main.Dialog.FilterIndex = 1
                F_Main.Dialog.FileName = IIf(Vacio(FileGetNameSinExt(sFile2)), "", sFile2)
                
                ' si no existe le permito al usuario buscarlo con CommonDialog
                On Error GoTo 0
                On Error Resume Next
                Do
                    sFileFullName = ""

                    If modo = OPEN_WRITE Then
                      F_Main.Dialog.ShowSave
                    Else
                      F_Main.Dialog.ShowOpen
                    End If

                    ' si cerro el dialgo con cancelar
                    If Err.Number = PressCancel Then
                        Err = 0
                        If Not MostrarError Then GoTo ExitProc
                        If ScAsk2("No es posible continuar sin encontrar el archivo" + IIf(Vacio(FileGetNameSinExt(sFile2)), "", " " + sFile2) + ". ¿Desea cancelar?") Then
                            GoTo ExitProc
                        End If
                    Else
                        With F_Main.Dialog
                            If (UCase(sFile2) = UCase(.FileTitle)) Or Vacio(FileGetNameSinExt(sFile2)) Then
                                sFileFullName = .FileName
                                
                                If Dir(sFileFullName) = "" Then
                                  
                                  If bCreate Then
                                    ' Si tiene que ser nuevo lo borro si existe
                                    If bNew Then
                                        If Dir(sFileFullName) <> "" Then
                                            Kill sFileFullName
                                        End If
                                    End If
                                    
                                    Open sFileFullName For Output Access Write As mIdArchivo
                                    Close mIdArchivo
                                  
                                    ' Obtengo el nombre del archivo
                                    FileSeparatePathAndName sFileFullName, sPath, sFile2
    
                                    ChDir sPath
                                  Else
                                    sFileFullName = ""
                                  End If

                                Else
                                  ' Obtengo el nombre del archivo
                                  FileSeparatePathAndName sFileFullName, sPath, sFile2
  
                                  ChDir sPath
                                End If
                            Else
                                ScInfo "El archivo es invalido"
                            End If
                        End With
                    End If
                Loop Until sFileFullName <> ""
            End If
        End If

        On Error GoTo 0
        On Error GoTo ControlError

        mFullFileName = sFileFullName
        
        Select Case modo
            Case OPEN_READ
                Open sFileFullName For Input Access Read As mIdArchivo
            Case OPEN_WRITE
                Open sFileFullName For Output Access Write As mIdArchivo
            Case OPEN_APPEND
                Open sFileFullName For Append Access Write As mIdArchivo
            
            Case OPEN_BINARY_READ
                Open sFileFullName For Binary Access Read As mIdArchivo
            Case OPEN_BINARY_WRITE
                Open sFileFullName For Binary Access Write As mIdArchivo
            Case Else
                GoTo ExitProc
        End Select
        m_ModoOpen = modo

    End If

    OpenArchivo = True
    mFileOpen = True
    GoTo ExitProc
ControlError:
    If MostrarError Then ScShowError "OpenArchivo", 0
    Resume ExitProc
ExitProc:
End Function

Public Sub CloseArchivo()
    On Error GoTo ControlError

    If mFileOpen Then Close mIdArchivo
    
    
    GoTo ExitProc
ControlError:
    ScShowError "CloseArchivo", 0
ExitProc:
    mFileOpen = False
End Sub


Public Function GetFileSize() As Long
    On Error Resume Next
    
    GetFileSize = 0
    If mFileOpen Then
        GetFileSize = FileLen(mFullFileName)
    End If
End Function

Private Sub Class_Terminate()
  CloseArchivo
End Sub

'------------------------------------------------------------------------------------------------------------------------------------------
Public Function FileGetPath(ByVal fullpath As String) As String
  Dim Path As String
  FileSeparatePathAndName fullpath, Path
  FileGetPath = Path
End Function

Public Sub FileSeparatePathAndName(fullpath As String, _
                                    Optional ByRef Path As String, _
                                    Optional ByRef FileName As String)

    Dim nSepPos As Long
    Dim sSEP As String

    nSepPos = Len(fullpath)
    
    If nSepPos = 0 Then
        Path = fullpath
        FileName = fullpath
        Exit Sub
    End If
    sSEP = Mid$(fullpath, nSepPos, 1)
    Do Until IsSeparator(sSEP)
        nSepPos = nSepPos - 1
        If nSepPos = 0 Then Exit Do
        sSEP = Mid$(fullpath, nSepPos, 1)
    Loop

    Select Case nSepPos
        Case Len(fullpath)
            'Si el separador es encontrado al final entonces, se trata de un directorio raiz ej. c:\, d:\, etc.
            Path = Left$(fullpath, nSepPos - 1)
            FileName = fullpath
        Case 0
            'Si el separador no es encontrado entonces, se trata de un directorio raiz ej. c:, d:, etc.
            If Mid(fullpath, 2, 1) = ":" Then Path = fullpath
            FileName = fullpath
        Case Else
            Path = Left$(fullpath, nSepPos - 1)
            FileName = Mid$(fullpath, nSepPos + 1)
    End Select
End Sub

'Determines if a character is a path separator (\ or /).
Private Function IsSeparator(Character As String) As Boolean
    Select Case Character
        Case gstrSEP_DIR
            IsSeparator = True
        Case gstrSEP_DIRALT
            IsSeparator = True
    End Select
End Function

Public Function FileGetNameSinExt(ByVal fullpath As String) As String
    Dim Path As String
    Dim FileName As String
    Dim nSepPos As Long
    Dim sSEP As String

    FileSeparatePathAndName fullpath, Path, FileName
    
    nSepPos = Len(FileName)
    
    If nSepPos = 0 Then
        FileGetNameSinExt = FileName
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
            FileGetNameSinExt = FileName
        Case Else
            FileGetNameSinExt = Left$(FileName, nSepPos - 1)
    End Select
End Function

Public Function FileGetName(ByVal fullpath As String) As String
    Dim Path As String
    Dim FileName As String

    FileSeparatePathAndName fullpath, Path, FileName
    
    FileGetName = FileName
End Function


Public Function FileGetExtension(ByVal fullpath As String) As String
    Dim Path As String
    Dim FileName As String
    Dim nSepPos As Long
    Dim sSEP As String

    FileSeparatePathAndName fullpath, Path, FileName
    
    nSepPos = Len(FileName)
    
    If nSepPos = 0 Then
        FileGetExtension = ""
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
            FileGetExtension = ""
        Case Else
            ' Devuelvo la extension
            FileGetExtension = Mid$(FileName, nSepPos + 1)
    End Select
End Function

Public Function FileBorrarArchivo(ByVal File As String) As Boolean

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
  
  FileBorrarArchivo = True
  
  Exit Function
ControlError:
  ScShowError "General.FileBorrarArchivo", 1
End Function


Function Vacio(valor As Variant) As Boolean
'*** START FAILSAFE ***
     On Error GoTo FailSafe_Error
'*** STOP FAILSAFE ********************************************************************************************************************************
  Dim retval As Integer
  retval = False
  If IsNull(valor) Or IsEmpty(valor) Then
    retval = True
  ElseIf IsNumeric(valor) Then
    retval = (valor = 0)
  ElseIf IsDate(valor) Then
    retval = (CVDate(valor) = 0)
  Else
    retval = (Len(Trim(valor)) = 0)
  End If
  Vacio = retval
'*** START FAILSAFE ********************************************************************************************************************************
FailSafe_Exit:
Exit Function
FailSafe_Error:
    
    
     ScShowError "Function Vacio", vbCritical
    
     Resume FailSafe_Exit             'default is to exit this procedure
'*** STOP FAILSAFE ***
End Function

Public Function ScAsk2(ByVal sMensaje As String, Optional ByRef ConCancel As Boolean = False) As Boolean
  If 0 = InStr(sMensaje, "?") Then sMensaje = "¿" + Trim(sMensaje) + "?"
  If ConCancel Then
    
    Dim Que As Integer
    Que = MsgBox(sMensaje, vbQuestion + vbYesNoCancel)
    
    Select Case Que
      Case vbYes
        ScAsk2 = True
        ConCancel = False
      Case vbCancel
        ScAsk2 = False
        ConCancel = True
      Case Else
        ScAsk2 = False
        ConCancel = False
    End Select
    
  Else
    ScAsk2 = vbYes = MsgBox(sMensaje, vbQuestion + vbYesNo)
  End If
End Function

Sub ScInfo(mensaje As String)

  On Error GoTo FailSafe_Error

  DoBeep
  mensaje = StrTran(mensaje, ";", Chr(13) + Chr(10))
  MsgBox mensaje, vbInformation

FailSafe_Exit:
Exit Sub
FailSafe_Error:
    
    
     ScShowError "Sub ScInfo", vbCritical
    
     Resume FailSafe_Exit

End Sub

Private Sub ScShowError(ByVal s As String, Optional ByVal i As Integer)
  MsgBox "Funcion:" & s & vbCrLf & vbCrLf & Err.Description, vbCritical
End Sub

Private Sub DoBeep()
  Beep
End Sub

Private Function StrTran(ByVal s As String, ByVal s2 As String, ByVal s3 As String)
  StrTran = Replace(s, s2, s3, 1, , vbTextCompare)
End Function
