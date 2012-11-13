Attribute VB_Name = "mWinApi"
Option Explicit

Private Declare Function SendMessageLong Lib "user32" Alias _
"SendMessageA" (ByVal hWnd As Long, ByVal msg As Long, _
ByVal wParam As Long, ByVal lParam As Long) As Long

Private Declare Function GetWindowLong Lib "user32" _
 Alias "GetWindowLongA" (ByVal hWnd As Long, _
 ByVal nIndex As Long) As Long

Private Declare Function SetWindowLong Lib "user32" _
  Alias "SetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As _
   Long, ByVal dwNewLong As Long) As Long

Private Declare Function SetWindowPos Lib "user32" _
  (ByVal hWnd As Long, ByVal hWndInsertAfter As Long, _
  ByVal x As Long, ByVal y As Long, ByVal CX As Long, _
  ByVal CY As Long, ByVal wFlags As Long) As Long

Const GWL_STYLE = (-16)

Private Const LVM_FIRST = &H1000

Private Const LVM_GETHEADER = _
  (LVM_FIRST + 31)
Private Const HDS_BUTTONS = &H2
Private Const SWP_DRAWFRAME = &H20
Private Const SWP_NOMOVE = &H2
Private Const SWP_NOSIZE = &H1
Private Const SWP_NOZORDER = &H4
Private Const SWP_FLAGS = SWP_NOZORDER _
  Or SWP_NOSIZE Or SWP_NOMOVE Or SWP_DRAWFRAME
    
' La versión simple
Private Type OSVERSIONINFO
    dwOSVersionInfoSize As Long
    dwMajorVersion As Long
    dwMinorVersion As Long
    dwBuildNumber As Long
    dwPlatformId As Long
    szCSDVersion As String * 128
End Type

Private Declare Function GetVersionEx Lib "kernel32" Alias "GetVersionExA" _
    (lpVersionInformation As OSVERSIONINFO) As Long


Public Sub LV_FlatHeaders(hWndParent As Long, _
   hWndListView As Long)

 Dim r As Long, Style As Long, hHeader As Long
 hHeader = SendMessageLong(hWndListView, _
    LVM_GETHEADER, 0, ByVal 0&)
 Style = GetWindowLong(hHeader, GWL_STYLE)
 Style = Style Xor HDS_BUTTONS
 If Style Then
  r = SetWindowLong(hHeader, GWL_STYLE, Style)
  r = SetWindowPos(hWndListView, hWndParent, _
     0, 0, 0, 0, SWP_FLAGS)
 End If
End Sub

Public Function GetWindowsVersion() As Long
  Dim OSInfo As OSVERSIONINFO
  Dim ret As Long
  
  OSInfo.szCSDVersion = Space$(128)
  OSInfo.dwOSVersionInfoSize = Len(OSInfo)
  ret = GetVersionEx(OSInfo)
  
  GetWindowsVersion = OSInfo.dwMajorVersion
End Function
