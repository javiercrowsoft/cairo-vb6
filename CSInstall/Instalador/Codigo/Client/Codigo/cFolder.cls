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
Attribute VB_Exposed = False
Option Explicit
Private Declare Sub CoTaskMemFree _
        Lib "ole32.dll" _
        (ByVal hMem As Long)
Private Declare Function SHGetPathFromIDList _
        Lib "shell32" _
        (ByVal pidList As Long, _
        ByVal lpBuffer As String) _
        As Long
Private Const MAX_PATH = 255
Private Declare Function SHBrowseForFolder _
        Lib "shell32" _
        (lpbi As BrowseInfo) _
        As Long
Private Const BIF_RETURNONLYFSDIRS = 1
Private Declare Function lstrcat _
        Lib "kernel32" Alias "lstrcatA" _
        (ByVal lpString1 As String, _
        ByVal lpString2 As String) _
        As Long
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

Public Function SeleccionarDirectorio(ByRef F As Form, Optional ByVal Descripcion As String) As String
  On Error GoTo ControlError
  Dim iNull       As Integer
  Dim lpIDLista     As Long
  Dim lResultado    As Long
  Dim strDirectorio   As String
  Dim udtBI       As BrowseInfo
  
  If Descripcion = "" Then Descripcion = "Seleccionar directorio"
  
  strDirectorio = ""
  With udtBI
    .hwndOwner = F.hWnd
    .lpszTitle = lstrcat(Descripcion, "")
    .ulFlags = BIF_RETURNONLYFSDIRS
  End With
  lpIDLista = SHBrowseForFolder(udtBI)
  If lpIDLista Then
    strDirectorio = String$(MAX_PATH, 0)
    lResultado = SHGetPathFromIDList(lpIDLista, strDirectorio)
    Call CoTaskMemFree(lpIDLista)
    iNull = InStr(strDirectorio, vbNullChar)
    If iNull Then
      strDirectorio = Left$(strDirectorio, iNull - 1)
    End If
  End If
  If Trim$(strDirectorio) <> "" Then
    SeleccionarDirectorio = strDirectorio
  End If
  Exit Function
ControlError:
  Select Case Err.Number
    Case Else
      SeleccionarDirectorio = ""
      Exit Function
  End Select
End Function


