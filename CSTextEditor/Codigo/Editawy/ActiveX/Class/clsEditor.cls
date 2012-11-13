VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsEditor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
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

Private Sci As Long
Implements ISubclass
'====================================================================

Public Event RaiseEvents(ByVal hwnd As Long, ByVal iMsg As Long, ByVal wParam As Long, ByVal lParam As Long)
Public Event RaiseWindowsEvents(ByVal hwnd As Long, ByVal iMsg As Long, ByVal wParam As Long, ByVal lParam As Long)

Private Declare Function GetLastError Lib "KERNEL32" () As Long

'====================================================================
'====================================================================
Private Function ISubclass_WindowProc(ByVal hwnd As Long, ByVal iMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
        
    Select Case iMsg
        Case WM_NOTIFY:
            RaiseEvent RaiseEvents(hwnd, iMsg, wParam, lParam)
            'Debug.Print "WM_NOTIFY: "; hwnd, iMsg
            
        Case Else:
            RaiseEvent RaiseWindowsEvents(hwnd, iMsg, wParam, lParam)
            'Debug.Print "WM_NOTIFY: "; hwnd, Sci, iMsg
            
    End Select
End Function

Private Property Let ISubclass_MsgResponse(ByVal RHS As EMsgResponse)
'
End Property

Private Property Get ISubclass_MsgResponse() As EMsgResponse

'    emrConsume      ' Process instead of original WindowProc
'    emrPostProcess  ' Process after original WindowProc
'    emrPreprocess   ' Process before original WindowProc
    Select Case CurrentMessage
        Case WM_NOTIFY, _
             WM_KEYDOWN, _
             WM_KEYUP, _
             WM_MOUSEMOVE, _
             WM_LBUTTONDOWN, _
             WM_LBUTTONUP, _
             WM_LBUTTONDBLCLK, _
             WM_RBUTTONDOWN, _
             WM_RBUTTONUP, _
             WM_RBUTTONDBLCLK, _
             WM_MBUTTONDOWN, _
             WM_MBUTTONUP, _
             WM_MBUTTONDBLCLK, _
             WM_MOUSEWHEEL, _
             WM_CHAR:
        
           ISubclass_MsgResponse = emrPreprocess
             'WM_SETFOCUS
             'WM_KILLFOCUS
             'WM_COMMAND
             'WM_SIZE
           
        Case Else
           ISubclass_MsgResponse = emrConsume
        
    End Select

End Property
  
Public Sub Attach(frm As Long)
    Detach frm
    
    AttachMessage Me, frm, WM_NOTIFY
    
    AttachMessage Me, Sci, WM_KEYDOWN
    AttachMessage Me, Sci, WM_KEYUP
    
    AttachMessage Me, Sci, WM_MOUSEMOVE
    AttachMessage Me, Sci, WM_LBUTTONDOWN
    AttachMessage Me, Sci, WM_LBUTTONUP
    AttachMessage Me, Sci, WM_LBUTTONDBLCLK
    AttachMessage Me, Sci, WM_RBUTTONDOWN
    AttachMessage Me, Sci, WM_RBUTTONUP
    AttachMessage Me, Sci, WM_RBUTTONDBLCLK
    AttachMessage Me, Sci, WM_MBUTTONDOWN
    AttachMessage Me, Sci, WM_MBUTTONUP
    AttachMessage Me, Sci, WM_MBUTTONDBLCLK
    AttachMessage Me, Sci, WM_MOUSEWHEEL
    
    
    AttachMessage Me, Sci, WM_CHAR

    'AttachMessage Me, frm, WM_SETFOCUS
    'AttachMessage Me, frm, WM_KILLFOCUS
    'AttachMessage Me, Sci, WM_COMMAND
    'AttachMessage Me, frm, WM_SIZE
    
    
End Sub

Public Sub Detach(frm As Long)
    DetachMessage Me, frm, WM_NOTIFY
       
    DetachMessage Me, Sci, WM_KEYDOWN
    DetachMessage Me, Sci, WM_KEYUP
    
    DetachMessage Me, Sci, WM_MOUSEMOVE
    DetachMessage Me, Sci, WM_LBUTTONDOWN
    DetachMessage Me, Sci, WM_LBUTTONUP
    DetachMessage Me, Sci, WM_LBUTTONDBLCLK
    DetachMessage Me, Sci, WM_RBUTTONDOWN
    DetachMessage Me, Sci, WM_RBUTTONUP
    DetachMessage Me, Sci, WM_RBUTTONDBLCLK
    DetachMessage Me, Sci, WM_MBUTTONDOWN
    DetachMessage Me, Sci, WM_MBUTTONUP
    DetachMessage Me, Sci, WM_MBUTTONDBLCLK
    DetachMessage Me, Sci, WM_MOUSEWHEEL
    
    DetachMessage Me, Sci, WM_CHAR
    'DetachMessage Me, frm, WM_SETFOCUS
    'DetachMessage Me, frm, WM_KILLFOCUS
    'DetachMessage Me, Sci, WM_COMMAND
    'DetachMessage Me, frm, WM_SIZE
    
End Sub
  
Public Function CreateEditor(frm As Long) As Long
    Dim hReslt As Long
    hReslt = LoadLibrary("SciLexer.DLL")
    
    'If hReslt Then
    '  MsgBox "SciLexer.dll Loaded successfull"
      
      Sci = CreateWindowEx(WS_EX_CLIENTEDGE, "Scintilla", "Editawy", WS_CHILD Or WS_VISIBLE, 0, 0, 200, 200, frm, 0, App.hInstance, 0)
      'Debug.Print "Sci Class: "; Sci
      'RemoveHotKeys
      'SetFocusAPI Sci
      CreateEditor = Sci
    'Else
    '  MsgBox "Can't Load SciLexer.dll"
    'End If
  
End Function
'====================================================================
'====================================================================
Public Property Get ObjectFromPtr(ByVal lPtr As Long) As Object
    Dim objT As Object
    If Not (lPtr = 0) Then
       ' Turn the pointer into an illegal, uncounted interface
       CopyMemory objT, lPtr, 4
       ' Do NOT hit the End button here! You will crash!
       ' Assign to legal reference
       Set ObjectFromPtr = objT
       ' Still do NOT hit the End button here! You will still crash!
       ' Destroy the illegal reference
       CopyMemory objT, 0&, 4
    End If
End Property


