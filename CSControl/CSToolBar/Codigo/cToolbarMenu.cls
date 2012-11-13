VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTbarMenu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

' =========================================================================
' cTbarMenu.cls
'
' vbAccelerator Toolbar control
' Copyright © 1998-2000 Steve McMahon (steve@vbaccelerator.com)
'
' Code to implement menu tracking against a toolbar
' rather than a menu bar.
'
' Based on code written by Paul DiLascia for Microsoft Systems
' Journal, C++ Q&A, January 1998.  Converted to VB and
' MDI form support added.
'
' -------------------------------------------------------------------------
' Visit vbAccelerator at http://vbaccelerator.com
' =========================================================================

Private Enum TRACKINGSTATE   '{ // menubar has three states:
   TRACK_NONE = 0 ',   // * normal, not tracking anything
   TRACK_BUTTON ',     // * tracking buttons (F10/Alt mode)
   TRACK_POPUP       '// * tracking popups
End Enum

Private Const CONTROLWIN_BUTTON = &H7FFF&

Private m_iTrackingState As TRACKINGSTATE
Private m_bProcessRightArrow As Boolean
Private m_bProcessLeftArrow  As Boolean
Private m_hMenuTracking As Long
Private m_iPopupTracking As Long
Private m_bEscapeWasPressed As Boolean
Private m_tPMouse As POINTAPI
Private m_iNewPopup As Long

Private m_hWnd As Long
Private m_hWndOwner As Long
Private m_hMenu As Long
Private m_lPtrMenu As Long
Private m_bResetHideInfrequentlyUsed As Boolean
Private m_bAlignMenuLeft As Boolean

Private Type NMTOOLBAR_SHORT
    hdr As NMHDR
    iItem As Long
End Type

Implements cISubclass

Friend Sub CoolMenuAttach(ByVal hWndA As Long, ByVal hWndToolbar As Long, ByVal hMenu As Long, ByVal lPtrMenu As Long)
   CoolMenuDetach
   m_hWndOwner = hWndA
   m_hWnd = hWndToolbar
   m_hMenu = hMenu
   m_lPtrMenu = lPtrMenu
   SendMessage m_hWndOwner, WM_ENTERMENULOOP, 0, 0
   AttachMessage Me, m_hWndOwner, WM_MENUSELECT
   AttachMessage Me, m_hWndOwner, WM_DESTROY
End Sub
Friend Sub hMenuChange(ByVal hMenu As Long)
   m_hMenu = hMenu
End Sub
Friend Sub CoolMenuDetach()
   If (m_hWndOwner <> 0) Then
      SendMessage m_hWndOwner, WM_EXITMENULOOP, 0, 0
      DetachMessage Me, m_hWndOwner, WM_MENUSELECT
      DetachMessage Me, m_hWndOwner, WM_DESTROY
      m_hWndOwner = 0
   End If
   m_hWnd = 0
End Sub
Private Property Get GetMDIChildIsMaximized() As Boolean
Dim hwnd As Long
   hwnd = FindWindowEx(m_hWndOwner, 0, "MDIClient", ByVal 0&) 'GetWindow(m_hWndOwner, GW_CHILD)
   If hwnd <> 0 Then
      hwnd = SendMessageLong(hwnd, WM_MDIGETACTIVE, 0, 0)
      If IsZoomed(hwnd) Then
         If Not (GetSystemMenu(hwnd, 0) = 0) Then
            GetMDIChildIsMaximized = True
         End If
      End If
   End If
End Property

'/////////////////
'// When user selects a new menu item, note whether it has a submenu
'// and/or parent menu, so I know whether right/left arrow should
'// move to the next popup.
'//
Private Sub MenuSelect(ByVal hMenu As Long, ByVal iItem As Long)
   
   If (m_iTrackingState > 0) Then
      '// process right-arrow if item is NOT a submenu
      
      ' SPM: .. and the menu item with the sub-menu is enabled!
      m_bProcessRightArrow = True
      
      Dim tMII As MENUITEMINFO
      Dim lR As Long
      tMII.fMask = MIIM_STATE Or MIIM_SUBMENU
      tMII.cbSize = LenB(tMII)
      lR = GetMenuItemInfo(hMenu, iItem, True, tMII)
      
      If Not (tMII.hSubMenu = 0) Then
         m_bProcessRightArrow = False
         
         'Debug.Print "Checking enabled state"
         'Debug.Print lR, tMII.fState, tMII.hSubMenu
         If ((tMII.fState And MF_DISABLED) = MF_DISABLED) Then
            'Debug.Print "Item is disabled, allow right arrow"
            m_bProcessRightArrow = True
         Else
            'Debug.Print "Item is enabled"
         End If
         
      End If
      '// process left-arrow if curent menu is one I'm tracking
      m_bProcessLeftArrow = (hMenu = m_hMenuTracking)
   End If
   
End Sub


'//////////////////
'// Handle menu input event: Look for left/right to change popup menu,
'// mouse movement over over a different menu button for "hot" popup effect.
'// Returns TRUE if message handled (to eat it).
'//
Friend Function MenuInput(m As Msg) As Boolean
Dim iMsg As Long
Dim vKey As Long
Dim tP As POINTAPI
Dim iButton As Long

   'ASSERT_VALID(this);
   Debug.Assert m_iTrackingState = TRACK_POPUP  '; // sanity check
   iMsg = m.message

   If (iMsg = WM_KEYDOWN) Then
      
      '// handle left/right-arow.
      vKey = m.wParam
      If ((vKey = vbKeyLeft And m_bProcessLeftArrow) Or _
         (vKey = vbKeyRight And m_bProcessRightArrow)) Then

         'MBTRACE(_T("CMenuBar::OnMenuInput: handle VK_LEFT/RIGHT\n"));
         CancelMenuAndTrackNewOne _
            GetNextOrPrevButton(m_iPopupTracking, vKey = vbKeyLeft)
         MenuInput = True ' // eat it
      
      ' // escape:
      ElseIf (vKey = vbKeyEscape) Then
         m_bEscapeWasPressed = True ';    // (menu will abort itself)
      End If
      
   ElseIf (iMsg = WM_MOUSEMOVE Or iMsg = WM_LBUTTONDOWN) Then
      '// handle mouse move or click
      LSet tP = m.pt
      ScreenToClient m_hWnd, tP

      If (iMsg = WM_MOUSEMOVE) Then
           ' fixes by James Mihelich.
         ' If the mouse was over a menu button while the menu is displayed
         ' and the user pressed the left or right arrow keys, the menu
         ' changed to the new menu but then immediately moved back
         ' to the menu the mouse was over.  The logic change fixes this
         ' problem.
         iButton = hitTest(tP)
         If (tP.x <> m_tPMouse.x) Or (tP.y <> m_tPMouse.y) Then
            If iButton <> GetHotItem() Then
               If IsValidButton(iButton) Then
                  'Debug.Print "CMTN", iButton
                  If iButton <> m_iPopupTracking Then
                     '// user moved mouse over a different button: track its popup
                     'Debug.Print "CMTN" & iButton, m_iPopupTracking
                     CancelMenuAndTrackNewOne iButton
                  End If
               End If
            End If
            LSet m_tPMouse = tP
         End If
      ElseIf iMsg = WM_LBUTTONDOWN Then
         'Debug.Print HitTest(tP)
         If (hitTest(tP) = m_iPopupTracking) Then
            '// user clicked on same button I am tracking: cancel menu
            'MBTRACE(_T("CMenuBar:OnMenuInput: handle mouse click to exit popup\n"));
            'Debug.Print "CMTN-1", m_iPopupTracking
            CancelMenuAndTrackNewOne -1
            MenuInput = True ' // eat it
         End If
      End If
   
   End If

End Function

Private Function hitTest(pt As POINTAPI) As Long
Dim iHit As Long
Dim rc As RECT

   'int iHit = CFlatToolBar::HitTest(p);
   'if (iHit>0) {
   '   GetClientRect(&rc);
   '   if (!rc.PtInRect(p)) // if point is outside window
   '      iHit = -1;        // can't be a hit!
   '}
   
   GetClientRect m_hWnd, rc
   If (PtInRect(rc, pt.x, pt.y) = 0) Then
      iHit = -1
      If GetMDIChildIsMaximized Then
         GetRect CONTROLWIN_BUTTON, rc
         If pt.x >= rc.left And pt.x <= rc.right Then
            If pt.y >= rc.top And pt.y <= rc.bottom Then
               ' In sys menu...
               'Debug.Print "HitTest in SysMenu"
               iHit = CONTROLWIN_BUTTON
            End If
         End If
      End If
   Else
      Dim iT As Long
      iHit = -1
      For iT = 0 To GetButtonCount - 1
         GetRect iT, rc
         If pt.x >= rc.left And pt.x <= rc.right Then
            If pt.y >= rc.top And pt.y <= rc.bottom Then
               iHit = iT
               Exit For
            End If
         End If
      Next iT
   End If
   hitTest = iHit
   
End Function
Private Property Get IsValidButton(ByVal iButton As Long) As Boolean
   If (iButton > -1) Then
      If GetButtonVisible(iButton) Then
         IsValidButton = True
      End If
   End If
End Property

'//////////////////
'// Cancel the current popup menu by posting WM_CANCELMODE, and track a new
'// menu. iNewPopup is which new popup to track (-1 to quit).
'//
Private Sub CancelMenuAndTrackNewOne(ByVal iNewPopup As Long)

   'MBTRACE(_T("CMenuBar::CancelMenuAndTrackNewOne: %d\n"), iNewPopup);
   'ASSERT_VALID(this);
   If (iNewPopup <> m_iPopupTracking) Then
      PostMessage m_hWndOwner, WM_CANCELMODE, 0, 0 ' // quit menu loop
      m_iNewPopup = iNewPopup                '// go to this popup (-1 = quit)
   End If
End Sub

Private Sub PressButton(ByVal iButton As Long, ByVal bState As Boolean)
Dim tBB As TBBUTTON
Dim fState As Long
Dim hWndTo As Long
Dim lPtr As Long

   If iButton >= 0 And iButton < GetButtonCount() Then
      SendMessage m_hWnd, TB_GETBUTTON, iButton, tBB
      Dim tBI As TBBUTTONINFO
      tBI.cbSize = LenB(tBI)
      tBI.dwMask = TBIF_STYLE
      SendMessage m_hWnd, TB_GETBUTTONINFO, tBB.idCommand, tBI
      If (tBI.fsStyle And TBSTYLE_DROPDOWN) = TBSTYLE_DROPDOWN Or _
         (tBI.fsStyle And BTNS_WHOLEDROPDOWN) = BTNS_WHOLEDROPDOWN Then
         fState = Abs(bState)
         lPtr = GetProp(m_hWnd, "vbalTbar:ControlPtr")
         If Not (lPtr = 0) Then
            Dim ctl As cToolbar
            Set ctl = ObjectFromPtr(lPtr)
            ctl.setDroppedButton iButton, bState
         End If
         SendMessageLong m_hWnd, TB_PRESSBUTTON, tBB.idCommand, fState
         If (bState) Then
            SendMessageLong m_hWnd, TB_SETHOTITEM, iButton, 0
         End If
      Else
         fState = Abs(bState)
         SendMessageLong m_hWnd, TB_PRESSBUTTON, tBB.idCommand, fState
      End If
   End If

End Sub

Friend Property Get EscapeWasPressed() As Boolean
   EscapeWasPressed = m_bEscapeWasPressed
End Property

'//////////////////
'// Track the popup submenu associated with the i'th button in the menu bar.
'// This fn actually goes into a loop, tracking different menus until the user
'// selects a command or exits the menu.
'//
Friend Function TrackPopup(ByVal iButton As Long) As Long
Dim nMenuItems As Long
Dim tPM As TPMPARAMS
Dim rcButton As RECT
Dim pt As POINTAPI
Dim hMenuPopup As Long
Dim lR As Long
Dim hwnd As Long
Dim lRtnID As Long
Dim lParam As Long

   'Debug.Print "BeginTrackPopup"
   Debug.Assert m_hMenu <> 0
   m_bEscapeWasPressed = False
   
   nMenuItems = GetMenuItemCount(m_hMenu)

   Do While (iButton >= 0)                '// while user selects another menu
      
      lRtnID = 0

      m_iNewPopup = -1                '// assume quit after this
      PressButton iButton, True       '// press the button
      UpdateWindow m_hWnd             '// and force repaint now

      '// post a simulated arrow-down into the message stream
      '// so TrackPopupMenu will read it and move to the first item
         ' SPM:  this isn't done in the IE/Office menu bar.
      'PostMessage m_hWndOwner, WM_KEYDOWN, vbKeyDown, 1
      'PostMessage m_hWndOwner, WM_KEYUP, vbKeyDown, 1

      SetTrackingState TRACK_POPUP, iButton '// enter tracking state

      '// Need to install a hook to trap menu input in order to make
      '// left/right-arrow keys and "hot" mouse tracking work.
      '//
      AttachMsgHook Me

      '// get submenu and display it beneath button
      GetRect iButton, rcButton
      ClientRectToScreen m_hWnd, rcButton
      tPM.cbSize = Len(tPM)
      ComputeMenuTrackPoint rcButton, tPM, pt
      
      ' MDI menu:
      If iButton = CONTROLWIN_BUTTON Then
         ' Get the system menu for this MDI client...
         hwnd = GetProp(m_hWnd, "vbalTbar:MDIClient")
         If hwnd <> 0 Then
            hwnd = SendMessageLong(hwnd, WM_MDIGETACTIVE, 0, 0)
            hMenuPopup = GetSystemMenu(hwnd, 0)
         End If
         'Debug.Print "Control Button;"; hWnd, hMenuPopup
         lParam = &HFFFFFFFF
         'Debug.Print hMenuPopup
      Else
         hMenuPopup = GetSubMenu(m_hMenu, iButton)
         lParam = 0
      End If
      If hMenuPopup <> 0 Then
         ' Show the menu:
         m_hMenuTracking = hMenuPopup
         ' Make sure the correct Init popup menu message is called:
         
         ' SPM: Removing this, it causes a duplicate!
         ' SendMessageLong m_hWndOwner, WM_INITMENUPOPUP, hMenuPopup, lParam
         
         lR = TrackPopupMenuEx(hMenuPopup, _
            TPM_LEFTALIGN Or TPM_LEFTBUTTON Or TPM_VERTICAL Or TPM_RETURNCMD, _
            pt.x, pt.y, m_hWndOwner, tPM)
         If iButton = CONTROLWIN_BUTTON Then
            SendMessageLong hwnd, WM_SYSCOMMAND, lR, 0
         Else
            'lR is the ID of the menu
            lRtnID = lR
            checkForChevron lRtnID
         End If
      End If
      
      '// uninstall hook.
      DetachMsgHook

      PressButton iButton, False    ';   // un-press button
      UpdateWindow m_hWnd                '// and force repaint now
      
      '// If the user exited the menu loop by pressing Escape,
      '// return to track-button state; otherwise normal non-tracking state.
      If (m_bEscapeWasPressed) Then
         SetTrackingState TRACK_BUTTON, iButton
      Else
         SetTrackingState TRACK_NONE, iButton
      End If
      
      '// If the user moved mouse to a new top-level popup (eg from File to
      '// Edit button), I will have posted a WM_CANCELMODE to quit
      '// the first popup, and set m_iNewPopup to the new menu to show.
      '// Otherwise, m_iNewPopup will be -1 as set above.
      '// So just set iButton to the next popup menu and keep looping...
      iButton = m_iNewPopup
   Loop

   ' Set hot button if mouse is over, otherwise not:
   
   ' The ID of the selected menu
   TrackPopup = lRtnID
   
   If m_bResetHideInfrequentlyUsed Then
      If (m_lPtrMenu <> 0) And (IsWindow(m_hWndOwner) <> 0) Then
         Dim oMenu As Object
         Set oMenu = ObjectFromPtr(m_lPtrMenu)
         oMenu.HideInfrequentlyUsed = True
      End If
   End If
   
   'Debug.Print "EndTrackPopup"
   
End Function

Private Sub checkForChevron(ByVal lID As Long)

Dim lIndex As Long
Dim sCaption As String
Dim lClickedIndex As Long
Dim i As Long

   If (m_lPtrMenu <> 0) And (IsWindow(m_hWndOwner) <> 0) Then
      Dim oMenu As Object
      Set oMenu = ObjectFromPtr(m_lPtrMenu)
      
      lIndex = oMenu.ItemForID(lID)
      If (lIndex > 0) Then
         lClickedIndex = lIndex
         sCaption = oMenu.Caption(lIndex)
         If (sCaption = "v-chevron-v") Then
            ' work up towards the parent until we find
            ' the toolbar
            i = lIndex
            Do
               i = oMenu.ItemParentIndex(i)
               If i > 0 Then
                  lIndex = i
                  If oMenu.hMenu(lIndex) = m_hMenu Then
                     ' temporarily show infrequent items:
                     If oMenu.HideInfrequentlyUsed Then
                        oMenu.HideInfrequentlyUsed = False
                        m_bResetHideInfrequentlyUsed = True
                     End If
                     ' then we set the next menu to show to be the current menu
                     ' again:
                     'Debug.Print "MENU DECIDED TO DO IT"
                     m_iNewPopup = m_iPopupTracking
                     On Error Resume Next
                     oMenu.ToolbarMenuChevronPress
                     Exit Do
                  End If
               End If
            Loop While i > 0
            
         End If
      End If
   End If
End Sub

Private Sub ComputeMenuTrackPoint(ByRef rc As RECT, tPM As TPMPARAMS, tP As POINTAPI)
   'Debug.Print rc.left, rc.bottom
   If m_bAlignMenuLeft Then
      tP.x = rc.right
      tP.y = rc.top
   Else
      tP.x = rc.left
      tP.y = rc.bottom
   End If
   LSet tPM.rcExclude = rc
End Sub


Private Sub GetRect(ByVal iButton As Long, ByRef tR As RECT)
Dim tBB As TBBUTTON
Dim iB
   If iButton = CONTROLWIN_BUTTON Then
      ' The system menu?
      iB = 0
   Else
      iB = iButton
   End If
   SendMessage m_hWnd, TB_GETBUTTON, iB, tBB
   SendMessage m_hWnd, TB_GETRECT, tBB.idCommand, tR
   If iButton = CONTROLWIN_BUTTON Then
      OffsetRect tR, -(GetSystemMetrics(SM_CXSMICON) + 2), 0
   End If
End Sub
Private Function GetHotItem() As Long
   GetHotItem = SendMessageLong(m_hWnd, TB_GETHOTITEM, 0, 0)
End Function
Private Function SetHotItem(ByVal iButton As Long) As Long
   Dim tBB As TBBUTTON
   If iButton >= 0 And iButton < GetButtonCount() Then
      SendMessage m_hWnd, TB_GETBUTTON, iButton, tBB
     
      Dim tBI As TBBUTTONINFO
      tBI.cbSize = LenB(tBI)
      tBI.dwMask = TBIF_STYLE
      SendMessage m_hWnd, TB_GETBUTTONINFO, tBB.idCommand, tBI
      If (tBI.fsStyle And TBSTYLE_DROPDOWN) = TBSTYLE_DROPDOWN Then
         'SendMessageLong m_hWnd, TB_SETHOTITEM, iButton, 0
      End If
   Else
      SendMessageLong m_hWnd, TB_SETHOTITEM, -1, 0
   End If
   
End Function
Private Function GetButtonVisible(ByVal iButton As Long) As Boolean
Dim tBB As TBBUTTON
Dim bButtonVisible As Boolean
Dim bButtonEnabled As Boolean
Dim tR As RECT
Dim tRT As RECT
   If iButton = CONTROLWIN_BUTTON Then
      GetButtonVisible = GetMDIChildIsMaximized
   Else
      SendMessage m_hWnd, TB_GETBUTTON, iButton, tBB
      bButtonVisible = (SendMessageLong(m_hWnd, TB_ISBUTTONHIDDEN, tBB.idCommand, 0) = 0)
      If bButtonVisible Then
         SendMessage m_hWnd, TB_GETRECT, tBB.idCommand, tR
         GetClientRect m_hWnd, tRT
          bButtonVisible = (tR.right <= tRT.right) And (tR.bottom <= tRT.bottom)
          If (bButtonVisible) Then
            bButtonEnabled = (SendMessageLong(m_hWnd, TB_ISBUTTONENABLED, tBB.idCommand, 0) <> 0)
            GetButtonVisible = bButtonEnabled
          End If
      End If
   End If
End Function
Private Function GetButtonCount() As Long
   GetButtonCount = SendMessageLong(m_hWnd, TB_BUTTONCOUNT, 0, 0)
End Function

Private Sub ClientRectToScreen(ByVal hwnd As Long, ByRef tR As RECT)
Dim tP As POINTAPI
   tP.x = tR.left: tP.y = tR.top
   ClientToScreen m_hWnd, tP
   tR.left = tP.x: tR.top = tP.y
   tP.x = tR.right: tP.y = tR.bottom
   ClientToScreen m_hWnd, tP
   tR.right = tP.x: tR.bottom = tP.y
End Sub
Private Sub SetTrackingState(ByVal iState As TRACKINGSTATE, ByVal iButton As Long)
   If (iState <> m_iTrackingState) Then
      If (iState = TRACK_NONE) Then
         iButton = -1
      End If
'#ifdef _DEBUG
'      static LPCTSTR StateName[] = { _T("NONE"), _T("BUTTON"), _T("POPUP") };
'      MBTRACE(_T("CMenuBar::SetTrackingState to %s, button=%d\n"),
'         StateName[iState], iButton);
'#End If

      SetHotItem iButton              '// could be none (-1)

      If (iState = TRACK_POPUP) Then
         '// set related state stuff
         m_bEscapeWasPressed = False 'FALSE;   // assume Esc key not pressed
         m_bProcessRightArrow = True        '// assume left/right arrow..
         m_bProcessLeftArrow = True         '; // ..will move to prev/next popup
         m_iPopupTracking = iButton          '// which popup I'm tracking
      End If
      m_iTrackingState = iState
   End If
End Sub


Private Function GetNextOrPrevButton(ByVal iButton As Long, ByVal bPrev As Boolean) As Long
Dim iSB As Long
Dim bfound As Boolean

   If (bPrev) Then
      iSB = iButton
      Do While Not bfound
         
         If GetMDIChildIsMaximized Then
            
            If iButton = 0 Then
               iButton = CONTROLWIN_BUTTON
            ElseIf iButton >= CONTROLWIN_BUTTON Then
               iButton = GetButtonCount() - 1
            Else
               iButton = iButton - 1
            End If
            
         Else
            iButton = iButton - 1
            If iButton < 0 Then
               iButton = GetButtonCount() - 1
            End If
         End If
         
         If Not (GetButtonVisible(iButton)) Then
            If iButton = iSB Then
               iButton = -1
               Exit Do
            End If
         Else
            bfound = True
         End If
         
      Loop
      
   Else
      iSB = iButton
      Do While Not bfound
         If GetMDIChildIsMaximized Then
            If iButton >= GetButtonCount() And iButton < CONTROLWIN_BUTTON Then
               iButton = CONTROLWIN_BUTTON
            ElseIf iButton = CONTROLWIN_BUTTON Then
               iButton = 0
            Else
               iButton = iButton + 1
            End If
         Else
            iButton = iButton + 1
            If (iButton >= GetButtonCount()) Then
               iButton = 0
            End If
         End If
         
         If Not GetButtonVisible(iButton) Then
            If iButton = iSB Then
               iButton = -1
               Exit Do
            End If
         Else
            bfound = True
         End If
         
      Loop
      
   End If
   'Debug.Print iButton
   GetNextOrPrevButton = iButton
   
End Function
'//////////////////
'// Toggle state from home state to button-tracking and back
'//
Private Sub ToggleTrackButtonMode()
   If (m_iTrackingState = TRACK_NONE Or m_iTrackingState = TRACK_BUTTON) Then
      If m_iTrackingState = TRACK_NONE Then
         SetTrackingState TRACK_BUTTON, 0
      Else
         SetTrackingState TRACK_NONE, 0
     End If
   End If
End Sub

Public Property Let MenuAlignLeft(ByVal bState As Boolean)
   m_bAlignMenuLeft = bState
End Property

Private Sub Class_Initialize()
   debugmsg "cTbarMenu:Initialize"
End Sub

Private Sub Class_Terminate()
   CoolMenuDetach
   debugmsg "cTbarMenu:Terminate"
End Sub

Private Property Let cISubclass_MsgResponse(ByVal RHS As EMsgResponse)
   '
End Property

Private Property Get cISubclass_MsgResponse() As EMsgResponse
   cISubclass_MsgResponse = emrPreprocess
End Property

Private Function cISubclass_WindowProc(ByVal hwnd As Long, ByVal iMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
   Select Case iMsg
   Case WM_MENUSELECT
      MenuSelect lParam, (wParam And &HFFFF&)
   Case WM_DESTROY
      CoolMenuDetach
   End Select
End Function

