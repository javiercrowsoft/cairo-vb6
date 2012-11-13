Attribute VB_Name = "mFindNewMenuWindow"
Option Explicit


Private Declare Function EnumWindows Lib "user32" (ByVal lpEnumFunc As Long, ByVal lparam As Long) As Long
Private Declare Function IsWindowVisible Lib "user32" (ByVal hWnd As Long) As Long
Private Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hWnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
Private Declare Function GetWindowTextLength Lib "user32" Alias "GetWindowTextLengthA" (ByVal hWnd As Long) As Long
Private Declare Function BringWindowToTop Lib "user32" (ByVal hWnd As Long) As Long
Private Declare Function SetForegroundWindow Lib "user32" (ByVal hWnd As Long) As Long
Private Declare Function GetClassName Lib "user32" Alias "GetClassNameA" (ByVal hWnd As Long, ByVal lpClassName As String, ByVal nMaxCount As Long) As Long
Private Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type
Private Declare Function GetWindowRect Lib "user32" (ByVal hWnd As Long, lpRect As RECT) As Long
Private Const WM_COMMAND = &H111

Private m_iCount As Long
Private m_hWnd() As Long

Private Function EnumWindowsProc( _
        ByVal hWnd As Long, _
        ByVal lparam As Long _
    ) As Long
Dim sClass As String
   sClass = ClassName(hWnd)
   If sClass = "#32768" Then ' Menu Window Class Name
      If IsWindowVisible(hWnd) Then
         m_iCount = m_iCount + 1
         ReDim Preserve m_hWnd(1 To m_iCount) As Long
         m_hWnd(m_iCount) = hWnd
         ' Debug.Print "Menu:", hWnd
      End If
   End If
End Function

Public Function EnumerateWindows() As Long
   m_iCount = 0
   Erase m_hWnd
   EnumWindows AddressOf EnumWindowsProc, 0
End Function
Public Property Get EnumerateWindowsCount() As Long
   EnumerateWindowsCount = m_iCount
End Property
Public Property Get EnumerateWindowshWnd(ByVal iIndex As Long) As Long
   EnumerateWindowshWnd = m_hWnd(iIndex)
End Property

Private Function WindowTitle(ByVal lhWnd As Long) As String
Dim lLen As Long
Dim sBuf As String

    ' Get the Window Title:
    lLen = GetWindowTextLength(lhWnd)
    If (lLen > 0) Then
        sBuf = String$(lLen + 1, 0)
        lLen = GetWindowText(lhWnd, sBuf, lLen + 1)
        WindowTitle = Left$(sBuf, lLen)
    End If
    
End Function
Private Function ClassName(ByVal lhWnd As Long) As String
Dim lLen As Long
Dim sBuf As String
    lLen = 260
    sBuf = String$(lLen, 0)
    lLen = GetClassName(lhWnd, sBuf, lLen)
    If (lLen <> 0) Then
        ClassName = Left$(sBuf, lLen)
    End If
End Function



