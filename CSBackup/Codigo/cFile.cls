VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cFile
' 29-01-06

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
'    ' constantes

'--------------------------------------------------------------------------------

' constantes

Public Enum csFile
    csRead = 1
    csWrite
    csAppend
    csBinaryRead
    csBinaryWrite
End Enum

Public Enum csFileAcces
    csShared = 1
    csLockRead
    csLockWrite
    csLockReadWrite
End Enum

' estructuras
' variables privadas
Private mFile       As Integer
Private m_Function  As String
Private m_Module    As String
Private m_Open      As Boolean
Private m_CurPath   As String
Private m_Name      As String
Private m_Path      As String
Private m_BinaryMode As Boolean

Private m_CommDialog As Object

Private m_Filter                        As String

' propiedades publicas
Public Property Get IsEOF() As Boolean
    If Not m_Open Then
        IsEOF = True
        Exit Property
    End If
    
    If m_BinaryMode Then
        IsEOF = LOF(mFile) <= Loc(mFile)
    Else
        IsEOF = EOF(mFile)
    End If
End Property

Public Property Get Filter() As String
   Filter = m_Filter
End Property

Public Property Let Filter(ByVal rhs As String)
   m_Filter = rhs
End Property

' propiedades privadas
' Funciones publicas
Public Property Get Name() As String
    Name = m_Name
End Property
Public Property Get Path() As String
    Path = m_Path
End Property
Public Property Get FullName() As String
    FullName = m_Path + "\" + m_Name
End Property

Public Property Get File() As Integer
    File = mFile
End Property

Public Sub Init(ByVal FunctionName As String, _
                ByVal Module As String, _
                ByRef CommDialog As Object)
    
    m_Function = FunctionName
    m_Module = Module
    Set m_CommDialog = CommDialog
End Sub

Public Function FOpen(ByVal sFile As String, _
                      ByVal Mode As csFile, _
                      Optional bNew As Boolean = False, _
                      Optional bSilens As Boolean = True, _
                      Optional TypeAccess As csFileAcces = csFileAcces.csShared, _
                      Optional ByVal WithDialog As Boolean = False, _
                      Optional ByVal CanOpenOther As Boolean) As Boolean
    Dim Exists As Boolean
    
    FClose
    
    m_BinaryMode = False
    
    If sFile <> "" Then
        ' Primero busco si existe en el path original
        Exists = Dir(sFile) <> ""
    Else
        sFile = " "
        Exists = False
    End If
    
    ' si no existe y no hay que crearlo
    If (Not Exists And Not bNew) Or WithDialog Then
    
        ' busco en el ultimo path en que tuve exito
        Exists = Dir(m_CurPath + "\" + GetFileName(sFile)) <> ""
        
        ' Si existe continuo con este file
        If Exists And Not WithDialog Then
            sFile = m_CurPath + "\" + GetFileName(sFile)
        ' y tengo que mantener silencio todo mal
        ElseIf (bSilens = True) Then
            Exit Function
        
        ' Le permito al usuario ubicar el archivo
        ElseIf Not UserUbicFile(sFile, False, "Abrir archivo", False, CanOpenOther) Then
            Exit Function
        End If
    End If
    
    
    On Error Resume Next
   
    If bNew Then
        Kill sFile
    End If
    
    ' 53 no se encontro el archivo
    If Err <> 0 And Err <> 53 Then
        MngError Err, m_Function, m_Module, "", "Error al borrar el archivo"
        Exit Function
    End If
    
    mFile = FreeFile
    
    On Error GoTo 0
    On Error GoTo ControlError
    
    Select Case Mode
        Case csAppend
            Select Case TypeAccess
            Case csShared
                Open sFile For Append Access Write Shared As mFile
            Case csLockRead
                Open sFile For Append Access Write Lock Read As mFile
            Case csLockReadWrite
                Open sFile For Append Access Write Lock Read Write As mFile
            Case csLockWrite
                Open sFile For Append Access Write Lock Write As mFile
            End Select
        Case csWrite
            Select Case TypeAccess
            Case csShared
                Open sFile For Output Access Write Shared As mFile
            Case csLockRead
                Open sFile For Output Access Write Lock Read As mFile
            Case csLockReadWrite
                Open sFile For Output Access Write Lock Read Write As mFile
            Case csLockWrite
                Open sFile For Output Access Write Lock Write As mFile
            End Select
        Case csRead
            Select Case TypeAccess
            Case csShared
                Open sFile For Input Access Read Shared As mFile
            Case csLockRead
                Open sFile For Input Access Read Lock Read As mFile
            Case csLockReadWrite
                Open sFile For Input Access Read Lock Read Write As mFile
            Case csLockWrite
                Open sFile For Input Access Read Lock Write As mFile
            End Select
        Case csBinaryRead
            Select Case TypeAccess
            Case csShared
                Open sFile For Binary Access Read Shared As mFile
            Case csLockRead
                Open sFile For Binary Access Read Lock Read As mFile
            Case csLockReadWrite
                Open sFile For Binary Access Read Lock Read Write As mFile
            Case csLockWrite
                Open sFile For Binary Access Read Lock Write As mFile
            End Select
            m_BinaryMode = True
        Case csBinaryWrite
            Select Case TypeAccess
            Case csShared
                Open sFile For Binary Access Write Shared As mFile
            Case csLockRead
                Open sFile For Binary Access Write Lock Read As mFile
            Case csLockReadWrite
                Open sFile For Binary Access Write Lock Read Write As mFile
            Case csLockWrite
                Open sFile For Binary Access Write Lock Write As mFile
            End Select
            m_BinaryMode = True
        Case Else
            Exit Function
    End Select
    m_Open = True
    FOpen = True
    Exit Function
ControlError:
    MngError Err, "FOpen", "clsFile - " + m_Module, "llamada por " + m_Function, "Error al abrir el archivo"
End Function

Public Function FSave(ByVal sFile As String, ByRef Exists As Boolean, ByRef bReadOnly As Boolean, Optional ByVal Descrip As String = "Guardar") As Boolean
    ' Le permito al usuario ubicar el archivo
    If sFile = "" Then sFile = " "
    
    
    If Not UserUbicFile(sFile, True, Descrip, True) Then Exit Function
    
    If sFile <> "" Then
        ' Primero busco si existe en el path original
        Exists = Dir(sFile, vbNormal) <> ""
        If Exists Then
          If GetAttr(sFile) And vbNormal Or GetAttr(sFile) And vbReadOnly Or GetAttr(sFile) And vbArchive Then
            If GetAttr(sFile) And vbReadOnly Then
              bReadOnly = True
            End If
          Else
            Exists = False
          End If
        End If
    Else
        sFile = " "
        Exists = False
    End If
    
    FSave = True
    Exit Function
ControlError:
    MngError Err, "FSave", "clsFile - " + m_Module, "llamada por " + m_Function, "Error al guardar el archivo"
End Function

Public Function FWrite(ByVal sText As String) As Boolean
    On Error GoTo ControlError
    If Not m_Open Then Exit Function
    
    Print #mFile, sText
    FWrite = True
    Exit Function
ControlError:
    MngError Err, "FWrite", "clsFile - " + m_Module, "llamada por " + m_Function, "Error al escribir el archivo"
End Function

Public Function FRead(ByRef sText As String, ByRef bEof As Boolean) As Boolean
    On Error GoTo ControlError
    If Not m_Open Then Exit Function
    
    If EOF(mFile) Then
        bEof = True
    Else
        Line Input #mFile, sText
        bEof = False
    End If
    FRead = True
    Exit Function
ControlError:
    MngError Err, "FRead", "clsFile - " + m_Module, "llamada por " + m_Function, "Error al leer del archivo"
End Function

Public Function FBinaryWrite(ByRef bBuffer() As Byte) As Boolean
    On Error GoTo ControlError
    If Not m_Open Then Exit Function
    
    Put #mFile, , bBuffer()
    FBinaryWrite = True
    Exit Function
ControlError:
    MngError Err, "FBinaryWrite", "clsFile - " + m_Module, "llamada por " + m_Function, "Error al escribir el archivo"
End Function
Public Function FBinaryRead(ByRef bBuffer() As Byte, ByRef bEof As Boolean) As Boolean
    On Error GoTo ControlError
    If Not m_Open Then Exit Function
    
    If IsEOF Then
        bEof = True
    Else
        If LOF(mFile) - Loc(mFile) < UBound(bBuffer) Then ReDim bBuffer(LOF(mFile) - Loc(mFile))
        Get #mFile, , bBuffer()
        bEof = False
    End If
    FBinaryRead = True
    Exit Function
ControlError:
    MngError Err, "FBinaryRead", "clsFile - " + m_Module, "llamada por " + m_Function, "Error al leer del archivo"
End Function

Public Sub FClose()
    On Error Resume Next
    Close mFile
    mFile = 0
    m_Open = False
End Sub

'////////////////////////////////////
' Manejo de nombres de archivos
Public Function GetFileName(ByVal FullPath As String) As String
  GetFileName = GetFileName_(FullPath)
End Function

Public Function GetFileNameWithoutExt(ByVal FullPath As String) As String
  GetFileNameWithoutExt = GetFileNameWithoutExt_(FullPath)
End Function

Public Function GetPath(ByVal FullPath As String) As String
  GetPath = GetPath_(FullPath)
End Function

Public Function GetFileExt(ByVal FullPath As String) As String
  GetFileExt = GetFileExt_(FullPath)
End Function

Public Sub SeparatePathAndFileName(FullPath As String, _
                                    Optional ByRef Path As String, _
                                    Optional ByRef FileName As String)

  SeparatePathAndFileName_ FullPath, Path, FileName
End Sub

Public Function CopyFile(ByVal Fuente As String, ByVal Destino As String) As Boolean
  CopyFile = CopyFile_(Fuente, Destino)
End Function

' Funciones privadas
Private Function UserUbicFile(ByRef sFile As String, Optional SiNoExisteDaIgual As Boolean = False, Optional ByVal Descrip As String = "Abrir archivo", Optional ByVal Guardando As Boolean = False, Optional ByVal CanOpenOther As Boolean) As Boolean
    Dim sFile2 As String
    Dim bExtValid As Boolean
    Dim bNameValid As Boolean
    Dim Exists As Boolean
    
    Do
        If ShowOpenFileDLG(sFile2, GetFileExt(sFile), GetFileName(sFile), GetPath(sFile), Descrip, Guardando) Then
            
            
            Exists = Dir(sFile2) <> ""
            
            ' si no existe no sirve
            If Not Exists And Not SiNoExisteDaIgual Then
                GoTo continuar
            End If
            
            If GetFileNameWithoutExt(sFile) = "*" Or sFile = " " Then
                bNameValid = True
            Else
                ' Compruebo que el archivo que abrio el usuario sea el mismo que
                ' me pidio el programa que abra.
                If (GetFileNameWithoutExt(sFile) = GetFileNameWithoutExt(sFile2)) Or SiNoExisteDaIgual Or CanOpenOther Then
                    bNameValid = True
                Else
                    bNameValid = False
                    
                    GoTo continuar
                End If
            End If
            
            If GetFileExt(sFile) = "*" Or sFile = " " Then
                bExtValid = True
            Else
                If (GetFileExt(sFile) = GetFileExt(sFile2)) Or SiNoExisteDaIgual Then
                    bExtValid = True
                Else
                    bExtValid = False
                End If
            End If
            
            If bExtValid And bNameValid And (Exists Or SiNoExisteDaIgual) Then Exit Do
continuar:
        Else
            Exit Function
        End If
    Loop
    
    ' Guardo el path para la proxima vez que busque
    m_CurPath = GetPath(sFile2)
    
    sFile = sFile2
    m_Name = GetFileName(sFile)
    m_Path = GetPath(sFile)
    UserUbicFile = True
End Function

'//////////////////////////////
' show common dialog
Private Function ShowOpenFileDLG(ByRef srtvalFile As String, _
                        Optional ByVal sFilter As Variant, _
                        Optional ByVal sFileToSearch As Variant, _
                        Optional ByVal sCurDir As Variant, _
                        Optional ByVal sTitle As String = "Abrir", _
                        Optional ByVal Guardando As Boolean = False) As Boolean
                        
  On Error GoTo ControlError
  
  With m_CommDialog
    
    .CancelError = True
    
    If Not IsMissing(sFileToSearch) Then
        ' Este Name de archivo es usado cuando quiero que el usuario elija un archivo
        If sFileToSearch <> " ." And Left(sFileToSearch, 2) <> "*." Then
          .FileName = sFileToSearch
        Else
          .FileName = ""
        End If
    End If
    
    If m_Filter <> "" Then
      .Filter = m_Filter
    Else
      If Not IsMissing(sFilter) Then
        .Filter = sFilter & "|" & sFilter
      End If
    End If
    
    If Not IsMissing(sCurDir) And Not Trim(sCurDir) = "" Then
        If Dir(sCurDir, vbDirectory) <> "" Then
            .InitDir = Dir(sCurDir, vbDirectory)
        End If
    End If
    
    .DialogTitle = sTitle

    If Not Guardando Then
      .ShowOpen
    Else
      .ShowSave
    End If
    
    If GetFileExt(.FileName) <> "" Then
        srtvalFile = GetPath(.FileName) + "\" + GetFileNameWithoutExt(.FileName) + "." + GetFileExt(.FileTitle)
    Else
        srtvalFile = GetFileNameWithoutExt(.FileName)
    End If
  End With
  
  ShowOpenFileDLG = True
  
  Exit Function
ControlError:
  If Err.Number = 32755 Then Exit Function
    
  Err.Raise Err.Number, Err.Source, Err.Description, Err.HelpFile, Err.HelpContext
End Function

' construccion - destruccion
Private Sub Class_Terminate()
    FClose
    Set m_CommDialog = Nothing
End Sub




