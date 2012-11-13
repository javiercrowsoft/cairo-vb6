Attribute VB_Name = "mGeneral"
'==========================================================
'           Copyright Information
'==========================================================
'Program Name: Mewsoft Editawy
'Program Author   : Elsheshtawy, A. A.
'Home Page        : http://www.mewsoft.com
'Copyrights © 2006 Mewsoft Corporation. All rights reserved.
'==========================================================
'==========================================================
Option Explicit

Public Declare Function GetTickCount Lib "kernel32.dll" () As Long

' Sub to sleep x seconds
Public Sub Sleep(lngSleep As Long)
   Dim lngSleepEnd As Long
   lngSleepEnd = GetTickCount + lngSleep * 1000
   While GetTickCount <= lngSleepEnd
      DoEvents
   Wend
End Sub

' Sub to freeze x seconds
Public Sub Freeze(lngFreeze As Long)
   Dim lngFreezeEnd As Long
   lngFreezeEnd = GetTickCount + lngFreeze * 1000
   While GetTickCount <= lngFreezeEnd
   Wend
End Sub

Public Function TrimNull(sString As String) As String
    If InStr(1, sString, vbNullChar) > 0 Then
        TrimNull = Left(sString, InStr(1, sString, vbNullChar) - 0)
    Else
        TrimNull = sString
    End If
End Function

' For put a windows in the middle of the screen
' FrmChild  = Windows to center
' FrmParent = MDI Windows (Optional)
Public Sub CenterForm(FrmChild As Form, Optional FrmParent As Variant)
    Dim iTop As Integer, iLeft As Integer
    
    If Not IsMissing(FrmParent) Then
        iTop = FrmParent.Top + (FrmParent.ScaleHeight - FrmChild.Height) \ 2
        iLeft = FrmParent.Left + (FrmParent.ScaleWidth - FrmChild.Width) \ 2
    Else
        iTop = (Screen.Height - FrmChild.Height) \ 2
        iLeft = (Screen.Width - FrmChild.Width) \ 2
    End If
    If iTop And iLeft Then
        FrmChild.Move iLeft, iTop
    End If
End Sub

Public Sub OnTop(TheForm As Form)
    '** Put window on top
    SetWindowPos TheForm.hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
End Sub

'-----------------------------------------------------------------------------------------
'http://vbnet.mvps.org/index.html?code/core/isinide.htm
'Returns True if the application is running in the development environment
'-----------------------------------------------------------------------------------------
Public Function IsInIDE() As Boolean
   Dim X As Long
   Debug.Assert Not TestIDE(X)
   IsInIDE = X = 1
End Function

Public Function TestIDE(X As Long) As Boolean
   X = 1
End Function

Public Function DirExists(ByVal sDir As String) As Boolean

    On Local Error GoTo ERR_Handler
    
    Dim strDir As String

    strDir = Dir(sDir, vbDirectory)
    If (strDir = "") Then
        DirExists = False
    Else
        DirExists = True
    End If
    Exit Function

ERR_Handler:
    DirExists = False
End Function

Public Function FileExists(ByVal sFile As String) As Boolean
  Dim lLength As Long

  If sFile <> vbNullString Then
    On Error Resume Next
    lLength = Len(Dir$(sFile))
    On Error GoTo err_routine
    FileExists = (Not Err And lLength > 0)
  Else
    FileExists = False
  End If

exit_routine:
  Exit Function

err_routine:
  FileExists = False
  Resume exit_routine

End Function

Public Function GET_X_LPARAM(ByVal lParam As Long) As Long
    Dim hexstr As String
    hexstr = Right("00000000" & Hex(lParam), 8)
    GET_X_LPARAM = CLng("&H" & Right(hexstr, 4))
End Function

Public Function GET_Y_LPARAM(ByVal lParam As Long) As Long
    Dim hexstr As String
    hexstr = Right("00000000" & Hex(lParam), 8)
    GET_Y_LPARAM = CLng("&H" & Left(hexstr, 4))
End Function

Public Function HiWord(ByVal dwValue As Long) As Long
    Dim hexstr As String
    hexstr = Right("00000000" & Hex(dwValue), 8)
    HiWord = CLng("&H" & Left(hexstr, 4))
End Function

Public Function LoWord(ByVal dwValue As Long) As Long
    Dim hexstr As String
    hexstr = Right("00000000" & Hex(dwValue), 8)
    LoWord = CLng("&H" & Right(hexstr, 4))
End Function

Public Function HIBYTE(ByVal wValue As Integer) As Byte
    HIBYTE = Val("&H" & Left(Right("0000" & Hex(wValue), 4), 2))
End Function

Public Function LOBYTE(ByVal wValue As Integer) As Byte
    LOBYTE = Val("&H" & Right("00" & Hex(wValue), 2))
End Function

Public Function MAKEWORD(ByVal bLow As Byte, ByVal bHigh As Byte) As Integer
    MAKEWORD = Val("&H" & Right("00" & Hex(bHigh), 2) & Right("00" & Hex(bLow), 2))
End Function
