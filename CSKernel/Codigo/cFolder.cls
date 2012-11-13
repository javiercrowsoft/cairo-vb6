VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFolder"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cFolder
' 25-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cFolder"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades privadas
' funciones publicas
Public Sub FolderCreate(ByVal sPath As String)
  MkDir sPath
End Sub

Public Function FileExists(ByVal FileName As String) As Boolean
  FileExists = Dir(FileName, vbNormal) <> ""
End Function

Public Function FolderExists(ByVal sPath As String) As Boolean
  If Dir(sPath, vbDirectory) <> "" Then
    FolderExists = GetAttr(sPath) = vbDirectory
  End If
End Function

Public Sub FolderCreateEx(ByVal sPath As String)
  Dim Vector() As String
  Dim i As Integer
  sPath = Replace(sPath, "\\", "//")
  ConvertStringtoArray sPath, Vector(), "\"
  sPath = ""
  
  For i = 1 To UBound(Vector())
    sPath = sPath & Replace(Vector(i), "\\", "//") & "\"
    
    If Not FolderExists(sPath) Then
      If Left(Vector(i), 2) <> "//" Then
        MkDir sPath
      End If
    End If
  Next i
  
End Sub

' funciones privadas
' construccion - destruccion

