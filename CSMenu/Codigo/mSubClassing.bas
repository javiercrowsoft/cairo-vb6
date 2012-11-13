Attribute VB_Name = "mSubClassing"
Option Explicit

'--------------------------------------------
' SubClassing
Private Declare Function GetProp Lib "user32" Alias "GetPropA" (ByVal hwnd As Long, ByVal lpString As String) As Long
Private Declare Function SetProp Lib "user32" Alias "SetPropA" (ByVal hwnd As Long, ByVal lpString As String, ByVal hData As Long) As Long
Private Declare Function IsWindow Lib "user32" (ByVal hwnd As Long) As Long
Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Private Declare Function GetWindowThreadProcessId Lib "user32" (ByVal hwnd As Long, lpdwProcessId As Long) As Long
Private Declare Function GetCurrentProcessId Lib "kernel32" () As Long
Private Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hwnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Declare Function RemoveProp Lib "user32" Alias "RemovePropA" (ByVal hwnd As Long, ByVal lpString As String) As Long

Private Const GWL_WNDPROC = (-4)
Private Const WM_COMMAND = &H111

'--------------------------------------------


'---------------------------------------------------------------------------------------------

Function AttachMessage(ByVal hwnd As Long) As Boolean
    
    Dim F As Long, c As Long
    Dim iC As Long, bFail As Boolean
    Dim procOld As Long
    
    ' Validate window
    If IsWindow(hwnd) = False Then Exit Function
    If IsWindowLocal(hwnd) = False Then Exit Function

    ' Get the message count
    ' Subclass window by installing window procecure
    procOld = SetWindowLong(hwnd, GWL_WNDPROC, AddressOf WindowProc)
    If procOld = 0 Then Exit Function
    ' Associate old procedure with handle
    F = SetProp(hwnd, hwnd, procOld)
End Function

' Cheat! Cut and paste from MWinTool rather than reusing
' file because reusing file would cause many unneeded dependencies
Function IsWindowLocal(ByVal hwnd As Long) As Boolean
    Dim idWnd As Long
    Call GetWindowThreadProcessId(hwnd, idWnd)
    IsWindowLocal = (idWnd = GetCurrentProcessId())
End Function

Sub DetachMessage(ByVal hwnd As Long)
    Dim F As Long, c As Long
    Dim iC As Long, iP As Long, lPtr As Long
    
    Dim procOld As Long
    procOld = GetProp(hwnd, hwnd)

    Debug.Assert procOld <> 0
    
    ' Unsubclass by reassigning old window procedure
    Call SetWindowLong(hwnd, GWL_WNDPROC, procOld)
    
    ' Remove unneeded handle (oldProc)
    RemoveProp hwnd, hwnd
End Sub

Private Function WindowProc(ByVal hwnd As Long, ByVal iMsg As Long, _
                            ByVal wParam As Long, ByVal lParam As Long) _
                            As Long
    Dim procOld As Long, pSubclass As Long, F As Long
    Dim iPC As Long, iP As Long, bNoProcess As Long
    Dim bCalled As Boolean
    
    ' Get the old procedure from the window
    procOld = GetProp(hwnd, hwnd)
    
    Debug.Assert procOld <> 0
    
    If iMsg = WM_COMMAND Then
        ProcessMenu wParam
    End If
        
    
    ' This message not handled, so pass on to old procedure
    WindowProc = CallWindowProc(procOld, hwnd, iMsg, _
                                wParam, ByVal lParam)
End Function
