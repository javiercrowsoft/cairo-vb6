VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cChevronWindow"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Implements cISubclass

Private m_hWnd As Long
Private m_hWndParent As Long
Private m_bIsShown As Boolean

Public Sub MouseEvent(ByVal iMsg As Long, ByVal hwnd As Long, x As Long, y As Long, ByVal hitTest As Long)
Dim bOk As Boolean
   'Debug.Print "MOuseEvent", iMsg, hwnd, x, y
   bOk = True
   If (iMsg = WM_LBUTTONDOWN) Or (iMsg = WM_RBUTTONDOWN) Or (iMsg = WM_MBUTTONDOWN) Or _
      (iMsg = WM_NCLBUTTONDOWN) Or (iMsg = WM_NCRBUTTONDOWN) Or (iMsg = WM_NCLMBUTTONDOWN) Then
      hwnd = WindowFromPoint(x, y)
      'Debug.Print "Button Down on window", Hex(hwnd)
      
      bOk = False
      If (hwnd = m_hWnd) Or (GetParent(hwnd) = m_hWnd) Then
         'Debug.Print "Window is me"
         bOk = True
      Else
         Dim sBuf As String
         sBuf = String$(256, 0)
         GetClassName hwnd, sBuf, 255
         sBuf = UCase(sBuf)
         'Debug.Print sBuf
         If (InStr(sBuf, "#32768") > 0) Then
            bOk = True
         End If
      End If
   End If
   If Not bOk Then
      Destroy
   End If
End Sub

Public Property Get IsShown() As Boolean
   IsShown = m_bIsShown
End Property

Public Property Get hwnd() As Long
   hwnd = m_hWnd
End Property

Private Sub Capture(ByVal hwnd As Long)
Dim lC As Long
   If m_hWnd <> 0 Then
      lC = GetProp(m_hWnd, "vbal:CapturedCount")
      lC = lC + 1
      SetProp m_hWnd, "vbal:CapturedCount", lC
      SetProp m_hWnd, "vbal:Captured:" & lC, hwnd
      SetProp m_hWnd, "vbal:Parent:" & lC, GetParent(hwnd)
      SetParent hwnd, m_hWnd
   End If
End Sub
Public Sub Show(ByVal hWndParent As Long, ByVal hWndCapture As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long)
Dim tR As RECT
Dim lhWnd As Long

   Create hWndParent, cx + 4, cy + 4
   Capture hWndCapture

   SendMessageLong m_hWndParent, WM_ENTERMENULOOP, 1, 0
   SetWindowPos m_hWnd, 0, x, y, cx + 4, cy + 4, SWP_SHOWWINDOW Or SWP_FRAMECHANGED Or SWP_NOOWNERZORDER Or SWP_NOZORDER Or SWP_NOACTIVATE
   GetClientRect m_hWnd, tR
   lhWnd = GetProp(m_hWnd, "vbal:Captured:1")
   If lhWnd <> 0 Then
      MoveWindow lhWnd, tR.left + 2, tR.top + 2, tR.right - tR.left - 4, tR.bottom - tR.top - 4, 1
   End If
   m_bIsShown = True
   AttachMouseHook Me
         
   Do While m_bIsShown
      DoEvents
   Loop
   
End Sub
Private Sub Create(ByVal hWndParent As Long, ByVal width As Long, ByVal height As Long)
Dim lStyle As Long
Dim lExStyle As Long
   
   
   Destroy
   
   lStyle = WS_POPUP Or WS_CLIPSIBLINGS Or WS_CLIPSIBLINGS
   lExStyle = WS_EX_TOOLWINDOW Or WS_EX_TOPMOST Or WS_EX_CONTROLPARENT Or WS_EX_NOACTIVATE 'Or WS_EX_WINDOWEDGE WS_EX_DLGMODALFRAME
   m_hWnd = CreateWindowEX( _
      lExStyle, _
      "#32768", "", lStyle, _
      0, 0, width, height, _
      hWndParent, 0, App.hInstance, ByVal 0&)
      
   If m_hWnd <> 0 Then
      m_hWndParent = hWndParent
      AttachMessage Me, m_hWndParent, WM_CANCELMODE
      AttachMessage Me, m_hWndParent, WM_ACTIVATEAPP
      AttachMessage Me, m_hWnd, WM_PAINT
      
      SetProp m_hWnd, "vbalTbar:ChevronPtr", ObjPtr(Me)
   End If
   
End Sub

Public Sub Destroy()
Dim lC As Long, l As Long
Dim lhWnd As Long, lhWndParent As Long
Dim lR As Long

   DetachMouseHook Me
   If m_hWnd <> 0 Then
      DetachMessage Me, m_hWndParent, WM_CANCELMODE
      DetachMessage Me, m_hWndParent, WM_ACTIVATEAPP
      DetachMessage Me, m_hWnd, WM_PAINT
      lC = GetProp(m_hWnd, "vbal:CapturedCount")
      For l = 1 To lC
         lhWnd = GetProp(m_hWnd, "vbal:Captured:" & l)
         If lhWnd <> 0 Then
            lhWndParent = GetProp(m_hWnd, "vbal:Parent:" & l)
            SetParent lhWnd, lhWndParent
            RemoveProp m_hWnd, "vbal:Captured:" & l
            RemoveProp m_hWnd, "vbal:Parent:" & l
      
            ShowWindow lhWnd, SW_HIDE
            SetParent lhWnd, 0
            lR = DestroyWindow(lhWnd)
            'Debug.Assert (lR <> 0)
            
         End If
      Next l
      DestroyWindow m_hWnd
      m_hWnd = 0
      m_hWndParent = 0
   End If
   m_bIsShown = False
End Sub

Private Sub Class_Terminate()
   Destroy
End Sub

Private Property Let cISubclass_MsgResponse(ByVal RHS As EMsgResponse)
   '
End Property

Private Property Get cISubclass_MsgResponse() As EMsgResponse
   cISubclass_MsgResponse = emrPreprocess
End Property

Private Function cISubclass_WindowProc(ByVal hwnd As Long, ByVal iMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Static s_iRefCount As Long
Dim tR As RECT
Dim tJunk As POINTAPI
Dim hPen As Long
Dim hPenOld As Long
   '
   Select Case iMsg
   Case WM_PAINT
      ' Border
      hdc = GetDC(m_hWnd)
      GetWindowRect m_hWnd, tR
      OffsetRect tR, -tR.left, -tR.top
      MoveToEx hdc, tR.left, tR.top, tJunk
      hPen = CreatePen(PS_SOLID, 1, GetSysColor(vb3DShadow And &H1F&))
      hPenOld = SelectObject(hdc, hPen)
      LineTo hdc, tR.right - 1, 0
      LineTo hdc, tR.right - 1, tR.bottom - 1
      LineTo hdc, tR.left, tR.bottom - 1
      LineTo hdc, tR.left, tR.top
      SelectObject hdc, hPenOld
      DeleteObject hPen
      ReleaseDC m_hWnd, hdc
   
   Case WM_ACTIVATEAPP, WM_CANCELMODE
      If m_bIsShown Then
         Destroy
      End If
      
   End Select
   
End Function

