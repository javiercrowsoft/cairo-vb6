VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFolder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cFolder
' 23-07-2003

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    Private Const MAX_PATH = 255
    Private Const BIF_RETURNONLYFSDIRS = 1
    ' estructuras
    Private Type BrowseInfo
        hwndOwner As Long
        pIDLRoot As Long
        pszDisplayName As Long
        lpszTitle As Long
        ulFlags As Long
        lpfnCallback As Long
        lParam As Long
        Image As Long
    End Type
    ' funciones
    Private Declare Sub CoTaskMemFree Lib "ole32.dll" (ByVal hMem As Long)
    Private Declare Function SHGetPathFromIDList Lib "shell32" (ByVal pidList As Long, ByVal lpBuffer As String) As Long
    Private Declare Function SHBrowseForFolder Lib "shell32" (lpbi As BrowseInfo) As Long
    Private Declare Function lstrcat Lib "kernel32" Alias "lstrcatA" (ByVal lpString1 As String, ByVal lpString2 As String) As Long

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cFolder"
' estructuras
' variables privadas
' eventos
' propiedades publicas
' propiedades friend
' propiedades privadas
' funciones publicas
Public Function SelectFolder(ByVal hWnd As Long, Optional ByVal Descript As String) As String
    On Error GoTo ControlError
    Dim iNull       As Integer
    Dim lpIdList    As Long
    Dim lResult     As Long
    Dim strFolder   As String
    Dim udtBI       As BrowseInfo
    
    If Descript = "" Then Descript = "Seleccione una carpeta"
    
    strFolder = ""
    With udtBI
        .hwndOwner = hWnd
        .lpszTitle = lstrcat(Descript, "")
        .ulFlags = BIF_RETURNONLYFSDIRS
    End With
    lpIdList = SHBrowseForFolder(udtBI)
    If lpIdList Then
        strFolder = String$(MAX_PATH, 0)
        lResult = SHGetPathFromIDList(lpIdList, strFolder)
        Call CoTaskMemFree(lpIdList)
        iNull = InStr(strFolder, vbNullChar)
        If iNull Then
            strFolder = Left$(strFolder, iNull - 1)
        End If
    End If
    If Trim$(strFolder) <> "" Then
        SelectFolder = strFolder
    End If
    Exit Function

ControlError:
    Select Case Err.Number
        Case Else
            SelectFolder = ""
            Exit Function
    End Select
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
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


