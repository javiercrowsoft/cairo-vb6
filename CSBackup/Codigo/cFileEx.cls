VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFileEx"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'--------------------------------------------------------------------------------
' cFileEx
' -01-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cFileEx"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function FileGetName(ByVal FullPath As String) As String
  FileGetName = GetFileName_(FullPath)
End Function

Public Function FileExists(ByVal File As String) As Boolean
  FileExists = FileExists_(File)
End Function

Public Function GetWindowsDir() As String
  GetWindowsDir = GetWindowsDir_()
End Function

Public Function FileGetNameWithoutExt(ByVal FullPath As String) As String
  FileGetNameWithoutExt = GetFileNameWithoutExt_(FullPath)
End Function

Public Function FileGetPath(ByVal FullPath As String) As String
  FileGetPath = GetPath_(FullPath)
End Function

Public Function FileGetFileExt(ByVal FullPath As String) As String
  FileGetFileExt = GetFileExt_(FullPath)
End Function

Public Sub FileGetPathAndFileName(FullPath As String, _
                                    Optional ByRef Path As String, _
                                    Optional ByRef FileName As String)

  SeparatePathAndFileName_ FullPath, Path, FileName
End Sub

Public Function FileCopyFile(ByVal Fuente As String, ByVal Destino As String) As Boolean
  FileCopyFile = CopyFile_(Fuente, Destino)
End Function

Public Function FileDelete(ByVal File As String) As Boolean
  FileDelete = Delete_(File)
End Function
' funciones friend
' funciones privadas
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


