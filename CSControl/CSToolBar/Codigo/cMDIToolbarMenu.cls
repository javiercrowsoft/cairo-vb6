VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMDIToolbarMenu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
' =========================================================================
' cMDIToolbarMenu.cls
'
' vbAccelerator Toolbar control
' Copyright © 1998-2000 Steve McMahon (steve@vbaccelerator.com)
'
' Removes the menu and child control non-client area from an
' MDI form and determines when an MDI child is activated
' and/or maximized.
'
' -------------------------------------------------------------------------
' Visit vbAccelerator at http://vbaccelerator.com
' =========================================================================

Implements cISubclass

Private m_hWnd As Long
Private m_hWndMDIClient As Long
Private m_bActive As Boolean
Private m_lPtr As Long
Private m_bState As Boolean
Private m_hDC As Long
Private m_hBmp As Long
Private m_hBmpOld As Long

Private Declare Function GetForegroundWindow Lib "user32" () As Long

Friend Sub Attach(ByVal hWndA As Long, ByRef tBH As cToolbarHost)
Dim lHDC As Long
   Detach
   m_hWndMDIClient = FindWindowEx(hWndA, 0, "MDIClient", ByVal 0&)
   If m_hWndMDIClient <> 0 Then
      m_hWnd = hWndA
      m_bActive = (GetForegroundWindow() = m_hWnd)
      AttachMessage Me, m_hWnd, WM_NCCALCSIZE
'      AttachMessage Me, m_hWnd, WM_NCPAINT
'      AttachMessage Me, m_hWnd, WM_SETCURSOR
'      AttachMessage Me, m_hWnd, WM_STYLECHANGED
      AttachMessage Me, m_hWnd, WM_ACTIVATE
      AttachMessage Me, m_hWnd, WM_DESTROY
      AttachMessage Me, m_hWnd, WM_MDISETMENU
      
      lHDC = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
      m_hDC = CreateCompatibleDC(lHDC)
      m_hBmp = CreateCompatibleBitmap(lHDC, Screen.width \ Screen.TwipsPerPixelX, GetSystemMetrics(SM_CYCAPTION) * 4)
      DeleteDC lHDC
      m_hBmpOld = SelectObject(m_hDC, m_hBmp)
      
      m_lPtr = ObjPtr(tBH)
   End If
End Sub
Friend Sub Detach()
   If m_hWnd <> 0 Then
      DetachMessage Me, m_hWnd, WM_NCCALCSIZE
'      DetachMessage Me, m_hWnd, WM_NCPAINT
'      DetachMessage Me, m_hWnd, WM_SETCURSOR
'      DetachMessage Me, m_hWnd, WM_STYLECHANGED
      DetachMessage Me, m_hWnd, WM_ACTIVATE
      DetachMessage Me, m_hWnd, WM_MDISETMENU
      DetachMessage Me, m_hWnd, WM_DESTROY
   End If
   If m_hDC <> 0 Then
      If m_hBmpOld <> 0 Then
         SelectObject m_hDC, m_hBmp
         m_hBmpOld = 0
      End If
      If m_hBmp <> 0 Then
         DeleteObject m_hBmp
         m_hBmp = 0
      End If
      If m_hDC <> 0 Then
         DeleteDC m_hDC
         m_hDC = 0
      End If
   End If
   m_hWnd = 0
   m_hWndMDIClient = 0
   m_lPtr = 0
End Sub

Private Property Get Toolbarhost() As cToolbarHost
Dim cT As cToolbarHost
   If m_lPtr <> 0 Then
      CopyMemory cT, m_lPtr, 4
      Set Toolbarhost = cT
      CopyMemory cT, 0&, 4
   End If
End Property

Private Sub pShowMDIButtons(ByVal hwnd As Long, ByVal bState As Boolean)
Dim cT As cToolbarHost
Dim lS As Long
Dim lNewS As Long

   m_bState = bState
   Set cT = Toolbarhost
   If Not cT Is Nothing Then
      cT.MDIButtons hwnd, bState
   End If
   lS = GetWindowLong(m_hWndMDIClient, GWL_EXSTYLE)
   If bState Then
      ' removing the MDI Border:
      lNewS = lS And Not WS_EX_CLIENTEDGE
   Else
      ' putting MDI border back again:
      lNewS = lS Or WS_EX_CLIENTEDGE
   End If
   ' Set the new style:
   If Not (lS = lNewS) Then
      SetWindowLong m_hWndMDIClient, GWL_EXSTYLE, lNewS
      ' Ensure the style 'takes'
      SetWindowPos m_hWndMDIClient, 0, 0, 0, 0, 0, SWP_FRAMECHANGED Or SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOOWNERZORDER Or SWP_NOZORDER
   End If
End Sub

Private Sub Class_Initialize()
   debugmsg "cMDIToolbarMenu:Initialize"
End Sub

Private Sub Class_Terminate()
   Detach
   debugmsg "cMDIToolbarMenu:Terminate"
End Sub

Private Property Let cISubclass_MsgResponse(ByVal RHS As EMsgResponse)
   '
End Property

Private Property Get cISubclass_MsgResponse() As EMsgResponse
   Select Case CurrentMessage
   Case WM_MDIGETACTIVE, WM_NCPAINT, WM_SETCURSOR, WM_MDISETMENU
      cISubclass_MsgResponse = emrConsume
   Case Else
      cISubclass_MsgResponse = emrPreprocess
   End Select
End Property

Private Function cISubclass_WindowProc(ByVal hwnd As Long, ByVal iMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Dim tNCR As NCCALCSIZE_PARAMS
Dim tWP As WINDOWPOS
Dim tR As RECT, ttR As RECT, tSR As RECT
Dim lhWnd As Long
Dim lpfMaximised As Long
Dim lPtr As Long
Dim hRgn As Long
Dim hBr As Long, hBrButton As Long
Dim hdc As Long
Dim lFlag As Long
Dim lStyle As Long
Dim lHasGradient As Long

   Select Case iMsg
   
   Case WM_DESTROY
      Detach
      
'   Case WM_NCPAINT
'      ' Get the non-client DC to draw in:
'      hdc = GetWindowDC(m_hWnd)
'
'      SystemParametersInfo SPI_GETGRADIENTCAPTIONS, 0, lHasGradient, 0
'      m_bActive = getTheActiveWindow()
'      If m_bActive Then
'         lFlag = DC_ACTIVE
'         ' if 98 or 2000 then we need to check for
'         ' gradient end color:
'         If Not (lHasGradient = 0) Then
'            lFlag = lFlag Or DC_GRADIENT
'            hBrButton = GetSysColorBrush(COLOR_GRADIENTACTIVECAPTION)
'         Else
'            hBrButton = GetSysColorBrush(COLOR_ACTIVECAPTION)
'         End If
'         hBr = GetSysColorBrush(COLOR_ACTIVEBORDER)
'      Else
'         If Not (lHasGradient = 0) Then
'            lFlag = lFlag Or DC_GRADIENT
'            hBrButton = GetSysColorBrush(COLOR_GRADIENTINACTIVECAPTION)
'         Else
'            hBrButton = GetSysColorBrush(COLOR_INACTIVECAPTION)
'         End If
'         hBr = GetSysColorBrush(COLOR_INACTIVEBORDER)
'      End If
'
'      ' Titlebar area:
'      GetWindowRect m_hWnd, tR
'      OffsetRect tR, -tR.left, -tR.top
'      ' Draw the part between the edge & the client:
'      LSet ttR = tR
'      ' left edge
'      ttR.top = GetSystemMetrics(SM_CYFRAME)
'      ttR.bottom = ttR.bottom - GetSystemMetrics(SM_CYFRAME)
'      ttR.right = GetSystemMetrics(SM_CXFRAME)
'      FillRect hdc, ttR, hBr
'      ' top
'      LSet ttR = tR
'      ttR.bottom = GetSystemMetrics(SM_CYFRAME)
'      FillRect hdc, ttR, hBr
'      ' right
'      LSet ttR = tR
'      ttR.top = GetSystemMetrics(SM_CYFRAME)
'      ttR.bottom = ttR.bottom - GetSystemMetrics(SM_CYFRAME)
'      ttR.left = ttR.right - GetSystemMetrics(SM_CXFRAME)
'      FillRect hdc, ttR, hBr
'      ' bottom
'      LSet ttR = tR
'      ttR.top = ttR.bottom - GetSystemMetrics(SM_CYFRAME)
'      FillRect hdc, ttR, hBr
'      ' top bit under titlebar:
'      LSet ttR = tR
'      ttR.top = GetSystemMetrics(SM_CXFRAME) + GetSystemMetrics(SM_CYCAPTION) - 1
'      ttR.bottom = ttR.top + 1
'      FillRect hdc, ttR, hBr
'      DeleteObject hBr
'
'      ' Edge 3d
'      DrawEdge hdc, tR, EDGE_RAISED, BF_RECT
'
'      ' Draw the titlebar into a work DC to prevent flicker:
'      lFlag = lFlag Or DC_ICON Or DC_TEXT
'      LSet ttR = tR
'      ttR.left = ttR.left + GetSystemMetrics(SM_CXFRAME)
'      ttR.right = ttR.right - GetSystemMetrics(SM_CXFRAME)
'      ttR.top = ttR.top + GetSystemMetrics(SM_CYFRAME)
'      ttR.bottom = ttR.top + GetSystemMetrics(SM_CYCAPTION) - 1
'      LSet tR = ttR
'      OffsetRect tR, -tR.left, -tR.top
'      LSet tSR = tR
'      tSR.right = tSR.right - (tR.bottom - tR.top) * 3 - 2
'      DrawCaption m_hWnd, m_hDC, tSR, lFlag
'
'      ' Draw the titlebar buttons:
'      tSR.left = tSR.right
'      tSR.right = tR.right
'      FillRect m_hDC, tSR, hBrButton
'      DeleteObject hBrButton
'
'      InflateRect tR, 0, -2
'      tR.right = tR.right - 2
'      tR.left = tR.right - (tR.bottom - tR.top) - 2
'      DrawFrameControl m_hDC, tR, DFC_CAPTION, DFCS_CAPTIONCLOSE
'      OffsetRect tR, -(tR.right - tR.left + 2), 0
'      If IsZoomed(m_hWnd) Then
'         DrawFrameControl m_hDC, tR, DFC_CAPTION, DFCS_CAPTIONRESTORE
'      Else
'         DrawFrameControl m_hDC, tR, DFC_CAPTION, DFCS_CAPTIONMAX
'      End If
'      OffsetRect tR, -(tR.right - tR.left), 0
'      DrawFrameControl m_hDC, tR, DFC_CAPTION, DFCS_CAPTIONMIN
'
'
'      ' Finished drawing the NC area:
'      BitBlt hdc, ttR.left, ttR.top, ttR.right - ttR.left, ttR.bottom - ttR.top, m_hDC, 0, 0, vbSrcCopy
'      ReleaseDC m_hWnd, hdc
'
   
   Case WM_NCCALCSIZE
      'Debug.Print "CalcSize"
      If wParam <> 0 Then
         CopyMemory tNCR, ByVal lParam, Len(tNCR)
         CopyMemory tWP, ByVal tNCR.lppos, Len(tWP)
         'pDebugCalcSize tNCR
         With tNCR.rgrc(0)
            .left = tWP.x + GetSystemMetrics(SM_CXFRAME)
            .top = tWP.y + GetSystemMetrics(SM_CYCAPTION) + GetSystemMetrics(SM_CYFRAME)
            .right = tWP.x + tWP.cx - GetSystemMetrics(SM_CXFRAME)
            .bottom = tWP.y + tWP.cy - GetSystemMetrics(SM_CYFRAME)
         End With
         LSet tNCR.rgrc(1) = tNCR.rgrc(0)
         CopyMemory ByVal lParam, tNCR, Len(tNCR)
         cISubclass_WindowProc = WVR_VALIDRECTS
      Else
         ' lParam points to a rectangle
         cISubclass_WindowProc = CallOldWindowProc(hwnd, iMsg, wParam, lParam)
      End If
         
      ' Check for the active window:
      lPtr = VarPtr(lpfMaximised)
      lhWnd = SendMessageLong(m_hWndMDIClient, WM_MDIGETACTIVE, 0, lPtr)
      'Debug.Print lhWnd, lPtr
      pShowMDIButtons lhWnd, (lpfMaximised <> 0)
      
   
'   Case WM_SETCURSOR
'      lStyle = GetWindowLong(m_hWnd, GWL_STYLE)
'      SetWindowLong m_hWnd, GWL_STYLE, lStyle And Not WS_VISIBLE
'      cISubclass_WindowProc = CallOldWindowProc(hWnd, iMsg, wParam, lParam)
'      SetWindowLong m_hWnd, GWL_STYLE, lStyle
   
   Case WM_ACTIVATE
      ' This message is fired when a form is activated or deactivated,
      ' normally immediately after the WM_NCACTIVATE message.
      ' Here we reset the safety check counter:
      m_bActive = (wParam <> 0)
      If m_bState Then
         'Debug.Print "cMDIToolbarMenu"; Hex$(hWnd)
         redrawToolbarHost
      End If
   End Select
            
End Function

Private Sub redrawToolbarHost()
Dim lhWnd As Long
   Dim cT As cToolbarHost
   Set cT = Toolbarhost
   If Not cT Is Nothing Then
      lhWnd = GetParent(cT.hwnd)
      lhWnd = GetParent(lhWnd)
      'Debug.Print "Redrawing: "; Hex$(lhWnd)
      RedrawWindowAsNull lhWnd, ByVal 0&, 0, RDW_INVALIDATE Or RDW_UPDATENOW Or RDW_ALLCHILDREN ' RDW_ERASE Or
   End If
End Sub

Private Function getTheActiveWindow() As Boolean
Dim lhWnd As Long
   lhWnd = getActiveWindow()
   If lhWnd = m_hWnd Then
      getTheActiveWindow = True
   Else
      lhWnd = GetProp(lhWnd, TOOLWINDOWPARENTWINDOWHWND)
      If lhWnd = m_hWnd Then
         ' is active
         getTheActiveWindow = True
      Else
         If g_bTitleBarModifier Then
            lhWnd = GetWindow(lhWnd, GW_OWNER)
            If lhWnd = m_hWnd Then
               getTheActiveWindow = True
            End If
         End If
      End If
   End If
End Function

Private Sub pDebugCalcSize(ByRef tNCR As NCCALCSIZE_PARAMS)
Dim i As Long
Dim tWP As WINDOWPOS
Dim sMsg As String
   ' Use to show what is happening:
   With tNCR
      For i = 1 To 3
         With .rgrc(i - 1)
            sMsg = sMsg & "rgrc(" & i - 1 & "):" & .left & "," & .top & "," & .right & "," & .bottom & vbCrLf
         End With
      Next i
      CopyMemory tWP, ByVal .lppos, Len(tWP)
      With tWP
         sMsg = sMsg & ".lppos:" & .x & "," & .y & "," & .x + .cx & "," & .y + .cy & vbCrLf
      End With
      debugmsg sMsg
   End With
End Sub
