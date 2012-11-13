VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cFlatControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'' =================================================================
'' Filename: cFlatControl.cls
'' Author:   Steve McMahon (steve@dogma.demon.co.uk)
'' Date:     20 January 1999
'' Requires: SSUBMTMR.DLL
''
'' Turns combo boxes and other VB controls without borders into a
'' Office 97 style flat controls.
'' Thanks to Peter Siebling and Paul Wilde for modification
'' suggestions.
''
'' Originally Based on  MFC code by Kirk Stowell (see below)
''
'' Visit vbAccelerator - the vb Programmer's resource
'' http://vbaccelerator.com
'' =================================================================
'
''
''// Copyright © 1998 Kirk Stowell
''// All Rights Reserved.
''//
''// Email: kstowel@sprynet.com
''// URL:   www.geocities.com/SiliconValley/Haven/8230
''//
''// This code may be used in compiled form in any way you desire. This
''// file may be redistributed unmodified by any means PROVIDING it is
''// not sold for profit without the authors written consent, and
''// providing that this notice and the authors name and all copyright
''// notices remains intact. If the source code in this file is used in
''// any  commercial application then a statement along the lines of
''// "Portions Copyright © 1998 Kirk Stowell" must be included in
''// the startup banner, "About" box or printed documentation. An email
''// letting me know that you are using it would be nice as well. That's
''// not much to ask considering the amount of work that went into this.
''//
''// This file is provided "as is" with no expressed or implied warranty.
''// The author accepts no liability for any damage/loss of business that
''// this product may cause.
''//
''/////////////////////////////////////////////////////////////////////////////
'
'
Implements cISubclass
'
'Private m_hWnd             As Long
'Private m_hWndEdit         As Long
'Private m_hWndParent       As Long
'Private m_bSubclass        As Boolean
'Private m_bMouseOver       As Boolean
'
'Private Enum EDrawStyle
'   FC_DRAWNORMAL = &H1
'   FC_DRAWRAISED = &H2
'   FC_DRAWPRESSED = &H4
'End Enum
'
'Private m_bLBtnDown As Boolean
'Private m_bCombo As Boolean
'
'Private Const WM_COMMAND = &H111
'Private Const WM_PAINT = &HF
'Private Const WM_TIMER = &H113
'Private Const WM_MOUSEMOVE = &H200
'Private Const WM_LBUTTONDOWN = &H201
'Private Const WM_LBUTTONUP = &H202
'Private Const SM_CXHTHUMB = 10
'
'Private Const WM_SETFOCUS = &H7
'Private Const WM_KILLFOCUS = &H8
'Private Const WM_MOUSEACTIVATE = &H21
'
'
'Private Type POINTAPI
'   x As Long
'   y As Long
'End Type
'Private Type RECT
'   Left     As Long
'   Top      As Long
'   Right    As Long
'   Bottom   As Long
'End Type
'Private Declare Function GetClientRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
'Private Declare Function ScreenToClient Lib "user32" (ByVal hwnd As Long, lpPoint As POINTAPI) As Long
'Private Declare Function GetDC Lib "user32" (ByVal hwnd As Long) As Long
'Private Declare Function DeleteDC Lib "gdi32" (ByVal hdc As Long) As Long
'Private Declare Function GetParent Lib "user32" (ByVal hwnd As Long) As Long
'Private Declare Function InflateRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
'Private Declare Function OffsetRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
'Private Declare Function IsWindowEnabled Lib "user32" (ByVal hwnd As Long) As Long
'Private Declare Function GetSystemMetrics Lib "user32" (ByVal nIndex As Long) As Long
'Private Declare Function InvalidateRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT, ByVal bErase As Long) As Long
'Private Declare Function SetTimer Lib "user32" (ByVal hwnd As Long, ByVal nIDEvent As Long, ByVal uElapse As Long, ByVal lpTimerFunc As Long) As Long
'Private Declare Function KillTimer Lib "user32" (ByVal hwnd As Long, ByVal nIDEvent As Long) As Long
'Private Declare Function GetCursorPos Lib "user32" (lpPoint As POINTAPI) As Long
'Private Declare Function GetWindowRect Lib "user32" (ByVal hwnd As Long, lpRect As RECT) As Long
'Private Declare Function PtInRect Lib "user32" (lpRect As RECT, ByVal x As Long, ByVal y As Long) As Long
'Private Declare Function CreatePen Lib "gdi32" (ByVal nPenStyle As Long, ByVal nWidth As Long, ByVal crColor As Long) As Long
'Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
'Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
'Private Const PS_SOLID = 0
'Private Declare Function MoveToEx Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long, lpPoint As POINTAPI) As Long
'Private Declare Function LineTo Lib "gdi32" (ByVal hdc As Long, ByVal x As Long, ByVal y As Long) As Long
'Private Declare Function OleTranslateColor Lib "olepro32.dll" (ByVal OLE_COLOR As Long, ByVal HPALETTE As Long, pccolorref As Long) As Long
'Private Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long
'Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
'Private Const GWL_EXSTYLE = (-20)
'Private Const GWL_STYLE = (-16)
'Private Const WS_EX_CLIENTEDGE = &H200&
'Private Const CBS_DROPDOWN = &H2&
'Private Const CBS_DROPDOWNLIST = &H3&
'Private Declare Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal hWnd1 As Long, ByVal hWnd2 As Long, ByVal lpsz1 As String, lpsz2 As Any) As Long
'Private Const CBN_DROPDOWN = 7
'Private Const CBN_CLOSEUP = 8
'Private Const CB_GETDROPPEDSTATE = &H157
'Private Declare Function SendMessageLong Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
'Private Declare Function GetWindow Lib "user32" (ByVal hwnd As Long, ByVal wCmd As Long) As Long
'Private Const GW_CHILD = 5
'Private Declare Function GetFocus Lib "user32" () As Long
'
Public Sub Attach(ByRef objthis As Object)

End Sub

'Dim lStyle As Long
'Dim lhWnd As Long
'
'   pRelease
'
'   On Error Resume Next
'   lhWnd = objthis.hwnd
'   If (Err.Number <> 0) Then
'      Err.Raise vbObjectError + 1048 + 1, _
'                App.EXEName & ".cFlatControl", _
'                "Incorrect control type passed to 'Attach' parameter - must be a control with a hWnd property."
'      Exit Sub
'   End If
'
'   m_bCombo = False
'
'   ' Check for standard VB types:
'   If TypeName(objthis) = "ImageCombo" Then
'      ' Support VB6 ImageCombos.  Thanks to Paul Wilde for the tip.
'      ' WM_COMMAND notifications to the control:
'      m_hWndParent = lhWnd
'      ' Get the actual ComboBox in the control:
'      lhWnd = FindWindowEx(lhWnd, 0&, "ComboBox", ByVal 0&)
'      m_bCombo = True
'   ElseIf TypeName(objthis) = "ComboBox" Then
'      ' WM_COMMAND notifications go to the parent:
'      m_hWndParent = GetParent(objthis.hwnd)
'      m_bCombo = True
'   ElseIf TypeName(objthis) = "OwnerDrawComboList" Then
'      ' WM_COMMAND notifications to the control:
'      m_hWndParent = lhWnd
'      m_bCombo = True
'   Else
'      lStyle = GetWindowLong(lhWnd, GWL_STYLE)
'      If ((lStyle And CBS_DROPDOWN) = CBS_DROPDOWN) Or ((lStyle And CBS_DROPDOWNLIST) = CBS_DROPDOWNLIST) Then
'         ' An API combo box of some sort.
'         ' Assume WM_COMMAND notifications go to the parent form:
'         m_hWndParent = objthis.Parent.hwnd
'         m_bCombo = True
'      Else
'         ' Assume a standard VB control with no border.
'         ' Shrink...
'         With objthis
'            .Move .Left + 2 * Screen.TwipsPerPixelX, .Top + 2 * Screen.TwipsPerPixelY, .Width - 4 * Screen.TwipsPerPixelX, .Height - 4 * Screen.TwipsPerPixelY
'         End With
'      End If
'   End If
'
'   pAttach lhWnd
'
'End Sub
'Private Sub pAttach(ByRef hWndA As Long)
'Dim lStyle As Long
'
'   m_hWnd = hWndA
'   If (m_hWnd <> 0) Then
'      lStyle = GetWindowLong(m_hWnd, GWL_STYLE)
'      If (lStyle And CBS_DROPDOWN) = CBS_DROPDOWN Then
'         m_hWndEdit = GetWindow(m_hWnd, GW_CHILD)
'      End If
'      AttachMessage Me, m_hWnd, WM_PAINT
'      AttachMessage Me, m_hWnd, WM_MOUSEACTIVATE
'      AttachMessage Me, m_hWnd, WM_SETFOCUS
'      AttachMessage Me, m_hWnd, WM_KILLFOCUS
'      AttachMessage Me, m_hWnd, WM_MOUSEMOVE
'      AttachMessage Me, m_hWnd, WM_TIMER
'      If (m_hWndEdit <> 0) Then
'         AttachMessage Me, m_hWndEdit, WM_MOUSEACTIVATE
'         AttachMessage Me, m_hWndEdit, WM_SETFOCUS
'         AttachMessage Me, m_hWndEdit, WM_KILLFOCUS
'         AttachMessage Me, m_hWndEdit, WM_MOUSEMOVE
'      End If
'      If (m_bCombo) Then
'         AttachMessage Me, m_hWndParent, WM_COMMAND
'      End If
'      m_bSubclass = True
'   End If
'End Sub
'Private Sub pRelease()
'   If (m_bSubclass) Then
'      DetachMessage Me, m_hWnd, WM_PAINT
'      DetachMessage Me, m_hWnd, WM_SETFOCUS
'      DetachMessage Me, m_hWnd, WM_KILLFOCUS
'      DetachMessage Me, m_hWnd, WM_MOUSEACTIVATE
'      DetachMessage Me, m_hWnd, WM_MOUSEMOVE
'      DetachMessage Me, m_hWnd, WM_TIMER
'      If (m_hWndEdit <> 0) Then
'         DetachMessage Me, m_hWndEdit, WM_MOUSEACTIVATE
'         DetachMessage Me, m_hWndEdit, WM_SETFOCUS
'         DetachMessage Me, m_hWndEdit, WM_KILLFOCUS
'         DetachMessage Me, m_hWndEdit, WM_MOUSEMOVE
'      End If
'      If (m_bCombo) Then
'         DetachMessage Me, m_hWndParent, WM_COMMAND
'      End If
'   End If
'   m_hWnd = 0: m_hWndEdit = 0: m_hWndParent = 0
'End Sub
'
'Private Sub Draw( _
'      ByVal dwStyle As EDrawStyle, _
'      clrTopLeft As OLE_COLOR, _
'      clrBottomRight As OLE_COLOR _
'   )
'   If m_hWnd = 0 Then Exit Sub
'   If (m_bCombo) Then
'      DrawCombo dwStyle, clrTopLeft, clrBottomRight
'   Else
'      DrawEdit dwStyle, clrTopLeft, clrBottomRight
'   End If
'End Sub
'
'Private Sub DrawEdit( _
'      ByVal dwStyle As EDrawStyle, _
'      clrTopLeft As OLE_COLOR, _
'      clrBottomRight As OLE_COLOR _
'   )
'Dim rcItem As RECT
'Dim rcItem2 As RECT
'Dim pDC As Long
'Dim hWndFocus As Long
'Dim tP As POINTAPI
'Dim hWndP As Long
'
'   ' Thanks to Peter Siebler for providing code to do this.
'
'   hWndP = GetParent(m_hWnd)
'   GetWindowRect m_hWnd, rcItem
'   tP.x = rcItem.Left: tP.y = rcItem.Top
'   ScreenToClient hWndP, tP
'   rcItem.Left = tP.x: rcItem.Top = tP.y
'   tP.x = rcItem.Right: tP.y = rcItem.Bottom
'   ScreenToClient hWndP, tP
'   rcItem.Right = tP.x: rcItem.Bottom = tP.y
'   InflateRect rcItem, 2, 2
'   pDC = GetDC(hWndP)
'
'   Draw3DRect pDC, rcItem, clrTopLeft, clrBottomRight
'   InflateRect rcItem, -1, -1
'
'   If (IsWindowEnabled(m_hWnd) = 0) Then
'      Draw3DRect pDC, rcItem, vb3DHighlight, vb3DHighlight
'   Else
'      Draw3DRect pDC, rcItem, vbButtonFace, vbButtonFace
'   End If
'
'   If (IsWindowEnabled(m_hWnd) = 0) Then
'      DeleteDC pDC
'      Exit Sub
'   End If
'
'   Select Case dwStyle
'   Case FC_DRAWNORMAL
''      rcItem.Top = rcItem.Top - 1
''      rcItem.Bottom = rcItem.Bottom + 1
''      Draw3DRect pDC, rcItem, vb3DHighlight, vb3DHighlight
''      rcItem.Left = rcItem.Left - 1
''      rcItem.Right = rcItem.Right
''      Draw3DRect pDC, rcItem, vbWindowBackground, vbButtonShadow
'   Case FC_DRAWRAISED, FC_DRAWPRESSED
'      InflateRect rcItem, -1, -1
'      Draw3DRect pDC, rcItem, vb3DHighlight, vb3DHighlight
'      InflateRect rcItem, -1, -1
'      Draw3DRect pDC, rcItem, vb3DHighlight, vb3DHighlight
'      InflateRect rcItem, -1, -1
'      Draw3DRect pDC, rcItem, vb3DHighlight, vb3DHighlight
'   'Case FC_DRAWPRESSED
'   '   rcItem.Top = rcItem.Top - 1
'   '   rcItem.Bottom = rcItem.Bottom
'   '   Draw3DRect pDC, rcItem, vbButtonShadow, vb3DHighlight
'   End Select
'   DeleteDC pDC  'ReleaseDC(pDC);
'
'End Sub
'Private Function Draw3DRect( _
'      ByVal hdc As Long, _
'      ByRef rcItem As RECT, _
'      ByVal oTopLeftColor As OLE_COLOR, _
'      ByVal oBottomRightColor As OLE_COLOR _
'   )
'Dim hPen As Long
'Dim hPenOld As Long
'Dim tP As POINTAPI
'   hPen = CreatePen(PS_SOLID, 1, TranslateColor(oTopLeftColor))
'   hPenOld = SelectObject(hdc, hPen)
'   MoveToEx hdc, rcItem.Left, rcItem.Bottom - 1, tP
'   LineTo hdc, rcItem.Left, rcItem.Top
'   LineTo hdc, rcItem.Right - 1, rcItem.Top
'   SelectObject hdc, hPenOld
'   DeleteObject hPen
'   If (rcItem.Left <> rcItem.Right) Then
'      hPen = CreatePen(PS_SOLID, 1, TranslateColor(oBottomRightColor))
'      hPenOld = SelectObject(hdc, hPen)
'      LineTo hdc, rcItem.Right - 1, rcItem.Bottom - 1
'      LineTo hdc, rcItem.Left, rcItem.Bottom - 1
'      SelectObject hdc, hPenOld
'      DeleteObject hPen
'   End If
'End Function
'
'Private Function TranslateColor(ByVal clr As OLE_COLOR, _
'                        Optional hPal As Long = 0) As Long
'    If OleTranslateColor(clr, hPal, TranslateColor) Then
'        TranslateColor = -1
'    End If
'End Function
'
'
'Private Sub DrawCombo( _
'      ByVal dwStyle As EDrawStyle, _
'      clrTopLeft As OLE_COLOR, _
'      clrBottomRight As OLE_COLOR _
'   )
'Dim rcItem As RECT
'Dim rcItem2 As RECT
'Dim pDC As Long
'Dim hWndFocus As Long
'Dim tP As POINTAPI
'
'
'   GetClientRect m_hWnd, rcItem
'   'CDC* pDC = GetDC();
'   pDC = GetDC(m_hWnd)
'
'   '// Cover up dark 3D shadow.
'   'pDC->Draw3dRect(rcItem, clrTopLeft, clrBottomRight);
'   Draw3DRect pDC, rcItem, vbWindowBackground, vbWindowBackground 'clrTopLeft, clrBottomRight
'   'rcItem.DeflateRect(1,1);
'   InflateRect rcItem, -1, -1
'
'   'if (!IsWindowEnabled()) {
'   If (IsWindowEnabled(m_hWnd) = 0) Then
'      'pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNHIGHLIGHT),
'      '   ::GetSysColor(COLOR_BTNHIGHLIGHT));
'      Draw3DRect pDC, rcItem, vb3DHighlight, vb3DHighlight
'   '}
'   Else
'   'else {
'      'pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNFACE),
'      '   ::GetSysColor(COLOR_BTNFACE));
'      Draw3DRect pDC, rcItem, vbButtonShadow, vbButtonShadow
'   '}
'   End If
'
'   '// Cover up dark 3D shadow on drop arrow.
'   'rcItem.DeflateRect(1,1);
'   InflateRect rcItem, -1, -1
'   rcItem.Left = rcItem.Right - Offset()
'   'pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNFACE),
'   '   ::GetSysColor(COLOR_BTNFACE));
'   Draw3DRect pDC, rcItem, vbButtonFace, vbButtonFace
'
'   '// Cover up normal 3D shadow on drop arrow.
'   'rcItem.DeflateRect(1,1);
'   InflateRect rcItem, -1, -1
'   'pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNFACE),
'   '   ::GetSysColor(COLOR_BTNFACE));
'   Draw3DRect pDC, rcItem, vbButtonFace, vbButtonFace
'
'   'if (!IsWindowEnabled()) {
'   '   return;
'   '}
'   If (IsWindowEnabled(m_hWnd) = 0) Then
'      DeleteDC pDC
'      Exit Sub
'   End If
'
'   'Switch (dwStyle)
'   '{
'   Select Case dwStyle
'   Case FC_DRAWNORMAL
'      'rcItem.top -= 1;
'      'rcItem.bottom += 1;
'      'pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNHIGHLIGHT),
'      '   ::GetSysColor(COLOR_BTNHIGHLIGHT));
'      'rcItem.left -= 1;
'      'pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNHIGHLIGHT),
'      '   ::GetSysColor(COLOR_BTNHIGHLIGHT));
'      'break;
'      rcItem.Top = rcItem.Top - 1
'      rcItem.Bottom = rcItem.Bottom + 1
'      Draw3DRect pDC, rcItem, vb3DHighlight, vb3DHighlight
'      rcItem.Left = rcItem.Left - 1
'      rcItem.Right = rcItem.Left
'      Draw3DRect pDC, rcItem, vbWindowBackground, &H0
'
'   Case FC_DRAWRAISED
'      'rcItem.top -= 1;
'      'rcItem.bottom += 1;
'      'pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNHIGHLIGHT),
'      '   ::GetSysColor(COLOR_BTNSHADOW));
'      'break;
'      rcItem.Top = rcItem.Top - 1
'      rcItem.Bottom = rcItem.Bottom + 1
'      rcItem.Right = rcItem.Right + 1
'      Draw3DRect pDC, rcItem, vb3DHighlight, vbButtonShadow
'
'   Case FC_DRAWPRESSED
'      'rcItem.top -= 1;
'      'rcItem.bottom += 1;
'      'rcItem.OffsetRect(1,1);
'      'pDC->Draw3dRect(rcItem, ::GetSysColor(COLOR_BTNSHADOW),
'      '   ::GetSysColor(COLOR_BTNHIGHLIGHT));
'      'break;
'      rcItem.Left = rcItem.Left - 1
'      rcItem.Top = rcItem.Top - 2
'      OffsetRect rcItem, 1, 1
'      Draw3DRect pDC, rcItem, vbButtonShadow, vb3DHighlight
'   '}
'   End Select
'   'ReleaseDC(pDC);
'   DeleteDC pDC
''}
'End Sub
'
'Private Function Offset() As Long
''{
''   // Thanks to Todd Brannam for this suggestion...
''   return ::GetSystemMetrics(SM_CXHTHUMB);
''}
'   Offset = GetSystemMetrics(SM_CXHTHUMB)
'
'End Function
'
Public Property Get DroppedDown() As Boolean

End Property

Private Property Let cISubclass_MsgResponse(ByVal RHS As CSSubclass.EMsgResponse)

End Property

'   If (m_bCombo) And (m_hWnd <> 0) Then
'      DroppedDown = (SendMessageLong(m_hWnd, CB_GETDROPPEDSTATE, 0, 0) <> 0)
'   End If
'End Property
'
'Private Sub OnPaint(ByVal bFocus As Boolean, ByVal bDropped As Boolean)
' 'used for paint
'   If bFocus Then
'      If (bDropped) Then
'         Draw FC_DRAWPRESSED, vbButtonShadow, vb3DHighlight
'      Else
'         Draw FC_DRAWRAISED, vbButtonShadow, vb3DHighlight
'      End If
'   Else
'      Draw FC_DRAWNORMAL, vbButtonFace, vbButtonFace
'   End If
'
'End Sub
'
'
'Private Sub Class_Terminate()
'   pRelease
'End Sub
'
'Private Sub OnTimer(ByVal bCheckMouse As Boolean)
'Dim bOver As Boolean
'Dim rcItem As RECT
'Dim tP As POINTAPI
'
'   If (bCheckMouse) Then
'      bOver = True
'      GetCursorPos tP
'      GetWindowRect m_hWnd, rcItem
'      If (PtInRect(rcItem, tP.x, tP.y) = 0) Then
'         bOver = False
'      End If
'   End If
'
'   If Not (bOver) Then
'      KillTimer m_hWnd, 1
'      m_bMouseOver = False
'   End If
'
'End Sub
'
'Private Property Let cISubclass_MsgResponse(ByVal RHS As CSSubclass.EMsgResponse)
'   ' do not remove this comment
'End Property
'
'Private Property Get cISubclass_MsgResponse() As CSSubclass.EMsgResponse
'   If (CurrentMessage = WM_PAINT) Then
'      cISubclass_MsgResponse = emrPreprocess
'   Else
'      cISubclass_MsgResponse = emrPostProcess
'   End If
'End Property
'
'Private Function cISubclass_WindowProc(ByVal hwnd As Long, ByVal iMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
'Dim bDown As Boolean
'Dim bFocus As Boolean
'
'   Select Case iMsg
'   Case WM_COMMAND
'      If (m_hWnd = lParam) Then
'         ' Type of notification is in the hiword of wParam:
'         Select Case wParam \ &H10000
'         Case CBN_CLOSEUP
'            OnPaint (m_hWnd = GetFocus() Or m_hWndEdit = GetFocus() Or bDown), bDown
'         End Select
'         OnTimer False
'      End If
'
'   Case WM_PAINT
'      bDown = DroppedDown()
'      bFocus = (m_hWnd = GetFocus() Or m_hWndEdit = GetFocus() Or bDown)
'      OnPaint (bFocus), bDown
'      If (bFocus) Then
'         OnTimer False
'      End If
'
'   Case WM_SETFOCUS
'      OnPaint True, False
'      OnTimer False
'
'   Case WM_KILLFOCUS
'      OnPaint False, False
'
'   Case WM_MOUSEMOVE
'      If Not (m_bMouseOver) Then
'         bDown = DroppedDown()
'         If Not (m_hWnd = GetFocus() Or m_hWndEdit = GetFocus() Or bDown) Then
'            OnPaint True, False
'            m_bMouseOver = True
'            ' Start checking to see if mouse is no longer over.
'            SetTimer m_hWnd, 1, 10, 0
'         End If
'      End If
'
'   Case WM_TIMER
'      OnTimer True
'      If Not (m_bMouseOver) Then
'         OnPaint False, False
'      End If
'
'   End Select
'
'End Function
'
'
'
Private Property Get cISubclass_MsgResponse() As CSSubclass.EMsgResponse

End Property

Private Function cISubclass_WindowProc(ByVal hwnd As Long, ByVal iMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long

End Function
