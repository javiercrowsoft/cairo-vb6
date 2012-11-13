Attribute VB_Name = "mMain"
'==========================================================
'           Copyright Infomation
'==========================================================
'Program Name: Mewsoft Editawy
'Program Author   : Elsheshtawy, A. A.
'Home Page        : http://www.mewsoft.com
'Copyrights © 2006 Mewsoft Corporation. All rights reserved.
'==========================================================
'==========================================================
Option Explicit

Public fMainForm As frmMain
Public frmActiveDocument As frmDocument

Public lBookmarkMarker As Long
Public lBookmarkMarkerMask As Long

Public bMacroRecording As Boolean
Public lCurentMacro As Long
Public sMacros(5) As String

Public Declare Function SetParent Lib "user32" (ByVal hWndChild As Long, ByVal hWndNewParent As Long) As Long
Public Declare Function GetParent Lib "user32" (ByVal hWnd As Long) As Long
Public Const HWND_TOPMOST = -1
Public Const HWND_NOTOPMOST = -2
Public Const SWP_NOMOVE = &H2
Public Const SWP_NOSIZE = &H1
Public Declare Function SetWindowPos Lib "user32" (ByVal hWnd As Long, ByVal m As Long, ByVal left As Long, ByVal top As Long, ByVal width As Long, ByVal height As Long, ByVal Flags As Long) As Long
Public Declare Function LockWindowUpdate Lib "user32" (ByVal hwndLock As Long) As Long

Public sLastSearchTerm As String
Public lLastSearchFlags As Long
Public sNewFileExt As String

Public ActiveSpliterEditor As Long

Public rectMargins As RECT


Sub Main()
    
    'frmSplash.Show
    'frmSplash.Refresh
    
    Set fMainForm = New frmMain
    
    sNewFileExt = "txt"
    
    ActiveSpliterEditor = 0
    
    Load fMainForm
    'Unload frmSplash
    fMainForm.Show
            
End Sub

Public Sub OnTop(TheForm As Form)
    '** Put window on top
    SetWindowPos TheForm.hWnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
End Sub



