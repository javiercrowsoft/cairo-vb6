Attribute VB_Name = "mToolbar"
Option Explicit
' =========================================================================
' mToolbar.bas
'
' vbAccelerator Toolbar control
' Copyright © 1998-2000 Steve McMahon (steve@vbaccelerator.com)
'
' Contains all the Common Control declares required for more than
' one file in the Rebar/Toolbar/CoolMenu control, plus supporting
' functions:
' 1) Windows Hooks Installation and Callbacks
' 2) Tooltips definition
' 3) Rebar resizing code to account for multiple resizable areas
'    on the same form
' 4) COMCTL version
'
' -------------------------------------------------------------------------
' Visit vbAccelerator at http://vbaccelerator.com
' =========================================================================

Public Const TOOLWINDOWPARENTWINDOWHWND = "vbal:ToolWindow:ParenthWnd"
Public Const VBALCHEVRONMENUCONST = &H56291024
Public Const VBALREBARCHILDSIZECONST = &H56291025

Public Const REBARCLASSNAME = "ReBarWindow32"

Public Type NMHDR
   hwndFrom As Long
   idfrom As Long
   code As Long
End Type
Public Type NMHDRRECT
   hwndFrom As Long
   idfrom As Long
   code As Long
   rcBand As RECT
End Type
Public Type NMCUSTOMDRAW
   hdr As NMHDR
   dwDrawStage As Long
   hdc As Long
   rc As RECT
   dwItemSpec As Long
   uItemState As Long
   lItemlParam As Long
End Type

Public Type TOOLINFO
   cbSize As Long
   uFlags As Long
   hwnd As Long
   uId As Long
   rct As RECT
   hInst As Long
   lpszText As Long
End Type

Public Type ToolTipText
   hdr As NMHDR
   lpszText As Long
   szText As String * 80
   hInst As Long
   uFlags As Long
End Type

Public Type TBBUTTONINFO
   cbSize As Long
   dwMask As Long
   idCommand As Long
   iImage As Long
   fsState As Byte
   fsStyle As Byte
   cx As Integer
   lParam As Long
   pszText As Long
   cchText As Long
End Type


Public Const H_MAX As Long = &HFFFF + 1

Public Const TTM_RELAYEVENT = (WM_USER + 7)
'Tool Tip messages
Public Const TTM_ACTIVATE = (WM_USER + 1)
'#If UNICODE Then
'   Public Const TTM_ADDTOOLW = (WM_USER + 50)
'   Public Const TTM_ADDTOOL = TTM_ADDTOOLW
'   Public Const TTM_DELTOOLW = (WM_USER + 51)
'   Public Const TTM_DELTOOL = TTM_DELTOOLW
'#Else
   Public Const TTM_ADDTOOLA = (WM_USER + 4)
   Public Const TTM_ADDTOOL = TTM_ADDTOOLA
   Public Const TTM_DELTOOLA = (WM_USER + 5)
   Public Const TTM_DELTOOL = TTM_DELTOOLA
'#End If

'ToolTip Notification
Public Const TTN_FIRST = (H_MAX - 520&)
'#If UNICODE Then
'   Public Const TTN_NEEDTEXTW = (TTN_FIRST - 10&)
'   Public Const TTN_NEEDTEXT = TTN_NEEDTEXTW
'#Else
   Public Const TTN_NEEDTEXTA = (TTN_FIRST - 0&)
   Public Const TTN_NEEDTEXT = TTN_NEEDTEXTA
'#End If
Private Const TOOLTIPS_CLASS = "tooltips_class32"
Private Const TTF_IDISHWND = &H1
Private Const LPSTR_TEXTCALLBACK As Long = -1

Public Declare Sub InitCommonControls Lib "Comctl32.dll" ()
Public Type CommonControlsEx
    dwSize As Long
    dwICC As Long
End Type
Public Declare Function InitCommonControlsEx Lib "Comctl32.dll" (iccex As CommonControlsEx) As Boolean
Public Const ICC_BAR_CLASSES = &H4
Public Const ICC_COOL_CLASSES = &H400
Public Const ICC_USEREX_CLASSES = &H200& '// comboex
Public Const ICC_WIN95_CLASSES = &HFF&

'//Common Control Constants
Public Const CCS_TOP = &H1&
Public Const CCS_NOMOVEY = &H2&
Public Const CCS_BOTTOM = &H3&
Public Const CCS_NORESIZE = &H4&
Public Const CCS_NOPARENTALIGN = &H8&
Public Const CCS_ADJUSTABLE = &H20&
Public Const CCS_NODIVIDER = &H40&
Public Const CCS_VERT = &H80&
Public Const CCS_LEFT = (CCS_VERT Or CCS_TOP)
Public Const CCS_RIGHT = (CCS_VERT Or CCS_BOTTOM)
Public Const CCS_NOMOVEX = (CCS_VERT Or CCS_NOMOVEY)

Public Const CCM_FIRST = &H2000&                  '// Common control shared messages
Public Const CCM_SETCOLORSCHEME = (CCM_FIRST + 2)     '// lParam is color scheme
Public Const CCM_GETCOLORSCHEME = (CCM_FIRST + 3)     '// fills in COLORSCHEME pointed to by lParam
Type COLORSCHEME
   dwSize As Long
   clrBtnHighlight As Long       '// highlight color
   clrBtnShadow As Long          '// shadow color
End Type

' Custom draw codes:
Public Const CDDS_PREPAINT = &H1
Public Const CDDS_POSTPAINT = &H2
Public Const CDDS_PREERASE = &H3
Public Const CDDS_POSTERASE = &H4
Public Const CDDS_ITEM = &H10000
Public Const CDDS_ITEMPREPAINT = (CDDS_ITEM Or CDDS_PREPAINT)
Public Const CDDS_ITEMPOSTPAINT = (CDDS_ITEM Or CDDS_POSTPAINT)
Public Const CDDS_ITEMPREERASE = (CDDS_ITEM Or CDDS_PREERASE)
Public Const CDDS_ITEMPOSTERASE = (CDDS_ITEM Or CDDS_POSTERASE)
Public Const CDDS_SUBITEM = &H20000

Public Const CDRF_DODEFAULT = 0
Public Const CDRF_NEWFONT = &H2
Public Const CDRF_SKIPDEFAULT = &H4
Public Const CDRF_NOTIFYPOSTPAINT = &H10
Public Const CDRF_NOTIFYITEMDRAW = &H20
Public Const CDRF_NOTIFYSUBITEMDRAW = &H20
Public Const CDRF_NOTIFYPOSTERASE = &H40

Public Const CDIS_SELECTED = &H1
Public Const CDIS_GRAYED = &H2
Public Const CDIS_DISABLED = &H4
Public Const CDIS_CHECKED = &H8
Public Const CDIS_FOCUS = &H10
Public Const CDIS_DEFAULT = &H20
Public Const CDIS_HOT = &H40
Public Const CDIS_MARKED = &H80
Public Const CDIS_INDETERMINATE = &H100


Private Const NM_FIRST = H_MAX               '(0U-  0U)       '// generic to all controls
Private Const NM_LAST = H_MAX - 99              '(0U- 99U)

'//====== Generic WM_NOTIFY notification codes =================================

Public Const NM_OUTOFMEMORY = (NM_FIRST - 1)
Public Const NM_CLICK = (NM_FIRST - 2)                ' // uses NMCLICK struct
Public Const NM_DBLCLK = (NM_FIRST - 3)
Public Const NM_RETURN = (NM_FIRST - 4)
Public Const NM_RCLICK = (NM_FIRST - 5)               ' // uses NMCLICK struct
Public Const NM_RDBLCLK = (NM_FIRST - 6)
Public Const NM_SETFOCUS = (NM_FIRST - 7)
Public Const NM_KILLFOCUS = (NM_FIRST - 8)
'#if (_WIN32_IE >= 0x0300)
Public Const NM_CUSTOMDRAW = (NM_FIRST - 12)
Public Const NM_HOVER = (NM_FIRST - 13)
'#End If
'#if (_WIN32_IE >= 0x0400)
Public Const NM_NCHITTEST = (NM_FIRST - 14)           ' // uses NMMOUSE struct
Public Const NM_KEYDOWN = (NM_FIRST - 15)             ' // uses NMKEY struct
Public Const NM_RELEASEDCAPTURE = (NM_FIRST - 16)
Public Const NM_SETCURSOR = (NM_FIRST - 17)           ' // uses NMMOUSE struct
Public Const NM_CHAR = (NM_FIRST - 18)                ' // uses NMCHAR struct

'//====== Generic WM_NOTIFY notification structures ============================
Public Type NMMOUSE
   hdr As NMHDR
   dwItemSpec As Long
   dwItemData As Long
   pt As POINTAPI
   dwHitInfo As Long '// any specifics about where on the item or control the mouse is
End Type
' NMCLICK = NMMOUSE

'// Generic structure for a key
Type NMKEY
   hdr As NMHDR
   nVKey As Long
   uFlags As Long
End Type

'// Generic structure for a character
Type NMCHAR
   hdr As NMHDR
   ch As Long
   dwItemPrev As Long     '// Item previously selected
   dwItemNext As Long     '// Item to be selected
End Type

Public Const HINST_COMMCTRL = -1&

Private Const S_OK = &H0
Private Type DLLVERSIONINFO
    cbSize As Long
    dwMajor As Long
    dwMinor As Long
    dwBuildNumber As Long
    dwPlatformID As Long
End Type
Private Declare Function LoadLibrary Lib "kernel32" Alias "LoadLibraryA" (ByVal lpLibFileName As String) As Long
Private Declare Function FreeLibrary Lib "kernel32" (ByVal hLibModule As Long) As Long
Private Declare Function GetProcAddress Lib "kernel32" (ByVal hModule As Long, ByVal lpProcName As String) As Long
Private Declare Function DllGetVersion Lib "comctl32" (pdvi As DLLVERSIONINFO) As Long

Public Type TBBUTTON
   iBitmap As Long
   idCommand As Long
   fsState As Byte
   fsStyle As Byte
   bReserved1 As Byte
   bReserved2 As Byte
   dwData As Long
   iString As Long
End Type

' Toolbar and button styles:
Public Const TBSTYLE_BUTTON = &H0
Public Const TBSTYLE_SEP = &H1
Public Const TBSTYLE_CHECK = &H2
Public Const TBSTYLE_GROUP = &H4
Public Const TBSTYLE_CHECKGROUP = (TBSTYLE_GROUP Or TBSTYLE_CHECK)
Public Const TBSTYLE_DROPDOWN = &H8
Public Const TBSTYLE_TOOLTIPS = &H100
Public Const TBSTYLE_WRAPABLE = &H200
Public Const TBSTYLE_ALTDRAG = &H400
Public Const TBSTYLE_FLAT = &H800
Public Const TBSTYLE_LIST = &H1000
Public Const TBSTYLE_AUTOSIZE = &H10         '// automatically calculate the cx of the button
Public Const TBSTYLE_NOPREFIX = &H20         '// if this button should not have accel prefix
Public Const BTNS_WHOLEDROPDOWN = &H80 '??? IE5 only
Public Const TBSTYLE_REGISTERDROP = &H4000&
Public Const TBSTYLE_TRANSPARENT = &H8000&

Public Const TBIF_IMAGE = &H1&
Public Const TBIF_TEXT = &H2&
Public Const TBIF_STATE = &H4&
Public Const TBIF_STYLE = &H8&
Public Const TBIF_LPARAM = &H10&
Public Const TBIF_COMMAND = &H20&
Public Const TBIF_SIZE = &H40&

'/* Toolbar messages */
Public Const TB_ENABLEBUTTON = (WM_USER + 1)
Public Const TB_CHECKBUTTON = (WM_USER + 2)
Public Const TB_PRESSBUTTON = (WM_USER + 3)
Public Const TB_HIDEBUTTON = (WM_USER + 4)
Public Const TB_INDETERMINATE = (WM_USER + 5)
Public Const TB_MARKBUTTON = (WM_USER + 6)

Public Const TB_BUTTONCOUNT = (WM_USER + 24)
Public Const TB_GETITEMRECT = (WM_USER + 29)
Public Const TB_GETHOTITEM = (WM_USER + 71)
Public Const TB_SETHOTITEM = (WM_USER + 72)           '// wParam == iHotItem
Public Const TB_GETBUTTON = (WM_USER + 23)
Public Const TB_GETRECT = (WM_USER + 51)             '// wParam is the Cmd instead of index
Public Const TB_GETBUTTONINFO = (WM_USER + 65)
Public Const TB_SETBUTTONINFO = (WM_USER + 66)

Public Const TB_ISBUTTONENABLED = (WM_USER + 9)
Public Const TB_ISBUTTONCHECKED = (WM_USER + 10)
Public Const TB_ISBUTTONPRESSED = (WM_USER + 11)
Public Const TB_ISBUTTONHIDDEN = (WM_USER + 12)
Public Const TB_ISBUTTONINDETERMINATE = (WM_USER + 13)
Public Const TB_ISBUTTONHIGHLIGHTED = (WM_USER + 14)

' Toolbar notification messages:
Public Const TBN_LAST = &H720
Public Const TBN_FIRST = -700&
Public Const TBN_GETBUTTONINFOA = (TBN_FIRST - 0)
Public Const TBN_GETBUTTONINFOW = (TBN_FIRST - 20)
Public Const TBN_GETBUTTONINFO = TBN_GETBUTTONINFOA
Public Const TBN_BEGINDRAG = (TBN_FIRST - 1)
Public Const TBN_ENDDRAG = (TBN_FIRST - 2)
Public Const TBN_BEGINADJUST = (TBN_FIRST - 3)
Public Const TBN_ENDADJUST = (TBN_FIRST - 4)
Public Const TBN_RESET = (TBN_FIRST - 5)
Public Const TBN_QUERYINSERT = (TBN_FIRST - 6)
Public Const TBN_QUERYDELETE = (TBN_FIRST - 7)
Public Const TBN_TOOLBARCHANGE = (TBN_FIRST - 8)
Public Const TBN_CUSTHELP = (TBN_FIRST - 9)
Public Const TBN_DROPDOWN = (TBN_FIRST - 10)
Public Const TBN_CLOSEUP = (TBN_FIRST - 11)
Public Const TBN_GETOBJECT = (TBN_FIRST - 12)
Public Const TBN_HOTITEMCHANGE = (TBN_FIRST - 13)
Public Const TBN_DELETINGBUTTON = (TBN_FIRST - 15)
Public Const TBN_GETDISPINFO = (TBN_FIRST - 16)
Public Const TBN_GETINFOTIP = (TBN_FIRST - 18)
Public Const TBN_RESTORE = (TBN_FIRST - 21)
Public Const TBN_SAVE = (TBN_FIRST - 22)
Public Const TBN_INITCUSTOMISE = (TBN_FIRST - 23)

Private Declare Function SetWindowsHookEx Lib "user32" Alias "SetWindowsHookExA" (ByVal idHook As Long, ByVal lpFn As Long, ByVal hmod As Long, ByVal dwThreadId As Long) As Long
Private Declare Function UnhookWindowsHookEx Lib "user32" (ByVal hHook As Long) As Long
Private Declare Function CallNextHookEx Lib "user32" (ByVal hHook As Long, ByVal nCode As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Private Declare Function GetCurrentThreadId Lib "kernel32" () As Long
Private Const WH_MSGFILTER As Long = (-1)
Private Const WH_KEYBOARD As Long = 2
Private Const WH_MOUSE = 7
Private Const MSGF_MENU = 2
Private Const HC_ACTION = 0

Public Type REBARBANDINFO_NOTEXT
    cbSize As Long
    fMask As Long
    fStyle As Long
    clrFore As Long
    clrBack As Long
    lpText As Long
    cch As Long
    iImage As Integer 'Image
    hWndCHild As Long
    cxMinChild As Long
    cyMinChild As Long
    cx As Long
    hbmBack As Long 'hBitmap
    wId As Long
End Type
Public Const RB_GETBANDCOUNT = (WM_USER + 12)
Public Const RBBIM_CHILD = &H10
Public Const RBBIM_STYLE = &H1
Public Const RB_GETBANDINFO = (WM_USER + 5)
Public Const RB_GETBANDBORDERS = (WM_USER + 34) '// returns in lparam = lprc the amount of edges added to band wparam
Public Const RBBS_HIDDEN = &H8              ' don't show

' =========================================================================


' Tooltips:
Private m_hWndToolTip As Long
Private m_iRef As Long
Public msToolTipBuffer As String         'Tool tip text; This string must have
                                         'module or global level scope, because
                                         'a pointer to it is copied into a
                                         'ToolTipText structure

' Next Control ID:
Private m_iID As Long

' Rebar Resizing information
Private Type tRebarInter
   hWndRebar As Long
   hWndParent As Long
End Type
Private m_tRebarInter() As tRebarInter
Private m_iRebarCount As Long
' Padding between rebars & edges
Private m_lPad As Long

' Message filter hook:
Private m_hMsgHook As Long
Private m_lMsgHookPtr As Long

' Keyboard hook (for accelerators):
Private m_hKeyHook As Long
Private m_lKeyHookPtr() As Long
Private m_lKeyHookhWnd() As Long
Private m_iKeyHookCount As Long

' Mouse hook (for chevrons):
Private m_hMouseHook As Long
Private m_lMouseHookPtr() As Long
Private m_lMouseHookhWnd() As Long
Private m_iMouseHookCount As Long

Public g_lCustomiseResponse As Long
Public g_bTitleBarModifier As Boolean

Private Property Get TbarMenuFromPtr(ByVal lPtr As Long) As cTbarMenu
Dim oTemp As Object
   ' Turn the pointer into an illegal, uncounted interface
   CopyMemory oTemp, lPtr, 4
   ' Do NOT hit the End button here! You will crash!
   ' Assign to legal reference
   Set TbarMenuFromPtr = oTemp
   ' Still do NOT hit the End button here! You will still crash!
   ' Destroy the illegal reference
   CopyMemory oTemp, 0&, 4
   ' OK, hit the End button if you must--you'll probably still crash,
   ' but it will be because of the subclass, not the uncounted reference
End Property
Private Property Get TbarFromPtr(ByVal lPtr As Long) As cToolbar
Dim oTemp As Object
   ' Turn the pointer into an illegal, uncounted interface
   CopyMemory oTemp, lPtr, 4
   ' Do NOT hit the End button here! You will crash!
   ' Assign to legal reference
   Set TbarFromPtr = oTemp
   ' Still do NOT hit the End button here! You will still crash!
   ' Destroy the illegal reference
   CopyMemory oTemp, 0&, 4
   ' OK, hit the End button if you must--you'll probably still crash,
   ' but it will be because of the subclass, not the uncounted reference
End Property
Public Property Get ObjectFromPtr(ByVal lPtr As Long) As Object
Dim oTemp As Object
   ' Turn the pointer into an illegal, uncounted interface
   CopyMemory oTemp, lPtr, 4
   ' Do NOT hit the End button here! You will crash!
   ' Assign to legal reference
   Set ObjectFromPtr = oTemp
   ' Still do NOT hit the End button here! You will still crash!
   ' Destroy the illegal reference
   CopyMemory oTemp, 0&, 4
   ' OK, hit the End button if you must--you'll probably still crash,
   ' but it will be because of the subclass, not the uncounted reference
End Property

'////////////////
'// Menu filter hook just passes to virtual CMenuBar function
'//
Private Function MenuInputFilter(ByVal nCode As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Dim cM As cTbarMenu
Dim lpMsg As Msg

   If nCode = MSGF_MENU Then
      Set cM = TbarMenuFromPtr(m_lMsgHookPtr)
      CopyMemory lpMsg, ByVal lParam, Len(lpMsg)
      If (cM.MenuInput(lpMsg)) Then
         MenuInputFilter = 1
         Exit Function
      End If
   End If
   MenuInputFilter = CallNextHookEx(m_hMsgHook, nCode, wParam, lParam)
   
End Function
Public Sub AttachMsgHook(cThis As cTbarMenu)
Dim lpFn As Long
   DetachMsgHook
   m_lMsgHookPtr = ObjPtr(cThis)
   lpFn = HookAddress(AddressOf MenuInputFilter)
   m_hMsgHook = SetWindowsHookEx(WH_MSGFILTER, lpFn, 0&, GetCurrentThreadId())
   Debug.Assert (m_hMsgHook <> 0)
End Sub
Public Sub DetachMsgHook()
   If (m_hMsgHook <> 0) Then
      UnhookWindowsHookEx m_hMsgHook
      m_hMsgHook = 0
   End If
End Sub

Private Function KeyboardFilter(ByVal nCode As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Dim bKeyUp As Boolean
Dim bCheck As Boolean
Dim bAlt As Boolean, bCtrl As Boolean, bShift As Boolean
Dim bTrackMode As Boolean
Dim cT As cToolbar
Dim i As Long
Dim bConsume As Boolean

On Error GoTo ErrorHandler

   If nCode = HC_ACTION And m_iKeyHookCount > 0 Then
      ' Key up or down:
      bKeyUp = ((lParam And &H80000000) = &H80000000)
      ' Alt pressed?
      bAlt = ((lParam And &H20000000) = &H20000000)
      bCtrl = (GetAsyncKeyState(vbKeyControl) <> 0)
      bShift = (GetAsyncKeyState(vbKeyShift) <> 0)
      'Debug.Print "Key", bAlt, bCtrl, bShift, bKeyUp, wParam
      
      If Not (bCtrl) Then
         ' Alt- key pressed:
         For i = 1 To m_iKeyHookCount
            If Not (m_lKeyHookPtr(i) = 0) Then
               If Not (IsWindow(m_lKeyHookhWnd(i)) = 0) Then
                  If GetProp(m_lKeyHookhWnd(i), "vbalTbar:ControlPtr") = m_lKeyHookPtr(i) Then
                     Set cT = TbarFromPtr(m_lKeyHookPtr(i))
                     If Not cT Is Nothing Then
                        bConsume = cT.AltKeyPress(wParam, bKeyUp, bAlt, bShift)
                        If bConsume Then
                           Exit For
                        End If
                     End If
                  End If
               End If
            End If
         Next i
      End If
   End If
   If (bConsume) Then
      KeyboardFilter = 1
   Else
      KeyboardFilter = CallNextHookEx(m_hKeyHook, nCode, wParam, lParam)
   End If

   Exit Function
   
ErrorHandler:
   Exit Function

End Function
Private Function MouseFilter(ByVal nCode As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Dim tMHS As MOUSEHOOKSTRUCT
Dim i As Long
Dim cCW As cChevronWindow

On Error GoTo ErrorHandler

   CopyMemory tMHS, ByVal lParam, Len(tMHS)
   For i = 1 To m_iMouseHookCount
      If Not (m_lMouseHookPtr(i) = 0) Then
         If Not (IsWindow(m_lMouseHookhWnd(i)) = 0) Then
            If GetProp(m_lMouseHookhWnd(i), "vbalTbar:ChevronPtr") = m_lMouseHookPtr(i) Then
               Set cCW = ObjectFromPtr(m_lMouseHookPtr(i))
               If Not cCW Is Nothing Then
                  cCW.MouseEvent wParam, tMHS.hwnd, tMHS.pt.x, tMHS.pt.y, tMHS.wHitTestCode
               End If
            End If
         End If
      End If
   Next i

   MouseFilter = CallNextHookEx(m_hMouseHook, nCode, wParam, lParam)
   Exit Function

ErrorHandler:
   Exit Function
End Function


Public Sub AttachKeyboardHook(cThis As cToolbar)
Dim lpFn As Long
Dim lPtr As Long
Dim i As Long
   
   If m_iKeyHookCount = 0 Then
      lpFn = HookAddress(AddressOf KeyboardFilter)
      m_hKeyHook = SetWindowsHookEx(WH_KEYBOARD, lpFn, 0&, GetCurrentThreadId())
      Debug.Assert (m_hKeyHook <> 0)
   End If
   lPtr = ObjPtr(cThis)
   For i = 1 To m_iKeyHookCount
      If lPtr = m_lKeyHookPtr(i) Then
         ' we already have it:
         Debug.Assert False
         Exit Sub
      End If
   Next i
   ReDim Preserve m_lKeyHookPtr(1 To m_iKeyHookCount + 1) As Long
   ReDim Preserve m_lKeyHookhWnd(1 To m_iKeyHookCount + 1) As Long
   m_iKeyHookCount = m_iKeyHookCount + 1
   m_lKeyHookPtr(m_iKeyHookCount) = lPtr
   m_lKeyHookhWnd(m_iKeyHookCount) = cThis.hwnd
   
End Sub
Public Sub DetachKeyboardHook(cThis As cToolbar)
Dim i As Long
Dim lPtr As Long
Dim iThis As Long
   
   lPtr = ObjPtr(cThis)
   For i = 1 To m_iKeyHookCount
      If m_lKeyHookPtr(i) = lPtr Then
         iThis = i
         Exit For
      End If
   Next i
   If iThis <> 0 Then
      If m_iKeyHookCount > 1 Then
         For i = iThis To m_iKeyHookCount - 1
            m_lKeyHookPtr(i) = m_lKeyHookPtr(i + 1)
         Next i
      End If
      m_iKeyHookCount = m_iKeyHookCount - 1
      If m_iKeyHookCount >= 1 Then
         ReDim Preserve m_lKeyHookPtr(1 To m_iKeyHookCount) As Long
      Else
         Erase m_lKeyHookPtr
      End If
   Else
      ' Trying to detach a toolbar which was never attached...
      ' This will happen at design time
   End If
   
   If m_iKeyHookCount <= 0 Then
      If (m_hKeyHook <> 0) Then
         UnhookWindowsHookEx m_hKeyHook
         m_hKeyHook = 0
      End If
   End If
   
End Sub
Public Sub AttachMouseHook(cThis As cChevronWindow)
Dim lpFn As Long
Dim lPtr As Long
Dim i As Long
   
   If m_iMouseHookCount = 0 Then
      lpFn = HookAddress(AddressOf MouseFilter)
      m_hMouseHook = SetWindowsHookEx(WH_MOUSE, lpFn, 0&, GetCurrentThreadId())
      Debug.Assert (m_hMouseHook <> 0)
   End If
   lPtr = ObjPtr(cThis)
   For i = 1 To m_iMouseHookCount
      If lPtr = m_lMouseHookPtr(i) Then
         ' we already have it:
         Debug.Assert False
         Exit Sub
      End If
   Next i
   ReDim Preserve m_lMouseHookPtr(1 To m_iMouseHookCount + 1) As Long
   ReDim Preserve m_lMouseHookhWnd(1 To m_iMouseHookCount + 1) As Long
   m_iMouseHookCount = m_iMouseHookCount + 1
   m_lMouseHookPtr(m_iMouseHookCount) = lPtr
   m_lMouseHookhWnd(m_iMouseHookCount) = cThis.hwnd
   
End Sub
Public Sub DetachMouseHook(cThis As cChevronWindow)
Dim i As Long
Dim lPtr As Long
Dim iThis As Long
   
   lPtr = ObjPtr(cThis)
   For i = 1 To m_iMouseHookCount
      If m_lMouseHookPtr(i) = lPtr Then
         iThis = i
         Exit For
      End If
   Next i
   If iThis <> 0 Then
      If m_iMouseHookCount > 1 Then
         For i = iThis To m_iMouseHookCount - 1
            m_lMouseHookPtr(i) = m_lMouseHookPtr(i + 1)
         Next i
      End If
      m_iMouseHookCount = m_iMouseHookCount - 1
      If m_iMouseHookCount >= 1 Then
         ReDim Preserve m_lMouseHookPtr(1 To m_iMouseHookCount) As Long
      Else
         Erase m_lMouseHookPtr
      End If
   Else
      ' Trying to detach a toolbar which was never attached...
      ' This will happen at design time
   End If
   
   If m_iMouseHookCount <= 0 Then
      If (m_hMouseHook <> 0) Then
         UnhookWindowsHookEx m_hMouseHook
         m_hMouseHook = 0
      End If
   End If
   
End Sub
Private Function HookAddress(ByVal lPtr As Long) As Long
   HookAddress = lPtr
End Function

Public Sub AddRebar( _
      ByVal hwnd As Long, _
      ByVal hWndParent As Long _
   )
   m_iRebarCount = m_iRebarCount + 1
   ReDim Preserve m_tRebarInter(1 To m_iRebarCount) As tRebarInter
   With m_tRebarInter(m_iRebarCount)
      .hWndParent = hWndParent
      .hWndRebar = hwnd
   End With
End Sub
Public Sub RemoveRebar( _
      ByVal hwnd As Long _
   )
Dim i As Long
Dim iT As Long
   For i = 1 To m_iRebarCount
      If m_tRebarInter(i).hWndRebar = hwnd Then
      Else
         iT = iT + 1
         If (iT <> i) Then
            LSet m_tRebarInter(iT) = m_tRebarInter(i)
         End If
      End If
   Next i
   
   If iT <> m_iRebarCount Then
      m_iRebarCount = iT
      If iT = 0 Then
         Erase m_tRebarInter
      Else
         ReDim Preserve m_tRebarInter(1 To m_iRebarCount) As tRebarInter
      End If
   End If
End Sub
Public Sub AdjustForOtherRebars( _
      ByVal hwnd As Long, _
      ByRef lLeft As Long, ByRef lTop As Long, _
      ByRef lWidth As Long, ByRef lHeight As Long _
   )
Dim i As Long
Dim iIndex As Long
Dim hWndP As Long
Dim lThisP As Long
Dim lP As Long
Dim rc As RECT, rcP As RECT

   m_lPad = 2
   
   For i = 1 To m_iRebarCount
      If m_tRebarInter(i).hWndRebar = hwnd Then
         iIndex = i
         hWndP = m_tRebarInter(i).hWndParent
         lThisP = GetProp(hwnd, "vbal:cRebarPosition")
         Exit For
      End If
   Next i
   
   If iIndex >= 1 Then
      GetWindowRect hWndP, rcP
      For i = 1 To iIndex - 1
         If m_tRebarInter(i).hWndParent = hWndP Then
            If IsWindowVisible(m_tRebarInter(i).hWndRebar) Then
               GetWindowRect m_tRebarInter(i).hWndRebar, rc
               lP = GetProp(m_tRebarInter(i).hWndRebar, "vbal:cRebarPosition")
               Select Case lThisP
               Case 0 'top
                  Select Case lP
                  Case 0
                     lTop = lTop + rc.bottom - rc.top + m_lPad
                  Case 1
                     lLeft = lLeft + rc.right - rc.left + m_lPad
                     lWidth = lWidth - (rc.right - rc.left + m_lPad)
                  Case 2
                     lWidth = lWidth - (rc.right - rc.left + m_lPad)
                  End Select
               Case 1 'left
                  Select Case lP
                  Case 0
                     lTop = lTop + rc.bottom - rc.top + m_lPad
                     lHeight = lHeight - (rc.bottom - rc.top + m_lPad)
                  Case 1
                     lLeft = lLeft + rc.right - rc.left + m_lPad
                  Case 3
                     lHeight = lHeight - (rc.bottom - rc.top + m_lPad)
                  End Select
               Case 2 'right
                  Select Case lP
                  Case 0
                     lTop = lTop + rc.bottom - rc.top + m_lPad
                     lHeight = lHeight - (rc.bottom - rc.top + m_lPad)
                  Case 2
                     lLeft = lLeft - (rc.right - rc.left + m_lPad)
                  Case 3
                     lHeight = lHeight - (rc.bottom - rc.top + m_lPad)
                  End Select
               Case 3 'bottom
                  Select Case lP
                  Case 1
                     lLeft = lLeft + (rc.right - rc.left + m_lPad)
                     lWidth = lWidth - (rc.right - rc.left + m_lPad)
                  Case 2
                     lWidth = lWidth - (rc.right - rc.left + m_lPad)
                  Case 3
                     lTop = lTop - (rc.bottom - rc.top + m_lPad)
                  End Select
               End Select
            End If
         End If
      Next i
   End If
   
End Sub

Public Function ComCtlVersion( _
        ByRef lMajor As Long, _
        ByRef lMinor As Long, _
        Optional ByRef lBuild As Long _
    ) As Boolean
Dim hmod As Long
Dim lR As Long
Dim lptrDLLVersion As Long
Dim tDVI As DLLVERSIONINFO

   lMajor = 0: lMinor = 0: lBuild = 0
   
   hmod = LoadLibrary("comctl32.dll")
   If (hmod <> 0) Then
      lR = S_OK
      '/*
      ' You must get this function explicitly because earlier versions of the DLL
      ' don't implement this function. That makes the lack of implementation of the
      ' function a version marker in itself. */
      lptrDLLVersion = GetProcAddress(hmod, "DllGetVersion")
      If (lptrDLLVersion <> 0) Then
         tDVI.cbSize = Len(tDVI)
         lR = DllGetVersion(tDVI)
         If (lR = S_OK) Then
            lMajor = tDVI.dwMajor
            lMinor = tDVI.dwMinor
            lBuild = tDVI.dwBuildNumber
         End If
      Else
         'If GetProcAddress failed, then the DLL is a version previous to the one
         'shipped with IE 3.x.
         lMajor = 4
      End If
      FreeLibrary hmod
      ComCtlVersion = True
   End If

End Function

Public Property Get NewButtonID() As Long
   m_iID = m_iID + 1
   NewButtonID = m_iID
End Property

Public Property Get hwndToolTip() As Long
   If m_hWndToolTip = 0 Then
      Create
   End If
   hwndToolTip = m_hWndToolTip
End Property
Public Sub AddToToolTip(ByVal hwnd As Long)
Dim tTi As TOOLINFO

   If m_hWndToolTip = 0 Then
      Create
   End If
    
   With tTi
      .cbSize = Len(tTi)
      .uId = hwnd
      .hwnd = hwnd
      .hInst = App.hInstance
      .uFlags = TTF_IDISHWND
      .lpszText = LPSTR_TEXTCALLBACK
   End With
   
   SendMessage m_hWndToolTip, TTM_ADDTOOL, 0, tTi
   SendMessageLong m_hWndToolTip, TTM_ACTIVATE, 1, 0
   m_iRef = m_iRef + 1

End Sub
Public Sub RemoveFromToolTip(ByVal hwnd As Long)
Dim tTi As TOOLINFO
Dim lR As Long
   If m_hWndToolTip <> 0 Then
      With tTi
         .cbSize = Len(tTi)
         .uId = hwnd
         .hwnd = hwnd
      End With
      lR = SendMessage(m_hWndToolTip, TTM_DELTOOL, 0, tTi)
      
      m_iRef = m_iRef - 1
      If m_iRef <= 0 Then
         DestroyWindow m_hWndToolTip
         m_hWndToolTip = 0
         m_iRef = 0
      End If
   End If
End Sub
 
Public Sub Create()
   ' Create the tooltip:
   InitCommonControls
   m_hWndToolTip = CreateWindowEX(WS_EX_TOPMOST, TOOLTIPS_CLASS, vbNullString, 0, _
             CW_USEDEFAULT, CW_USEDEFAULT, _
             CW_USEDEFAULT, CW_USEDEFAULT, _
             0, 0, _
             App.hInstance, _
             ByVal 0)
   SendMessage m_hWndToolTip, TTM_ACTIVATE, 1, ByVal 0
End Sub

Public Function hBmpFromPicture(iPic As IPicture) As Long
Dim lhDC1 As Long
Dim lhBmp1 As Long
Dim lhBmpOld1 As Long
Dim lhDC2 As Long
Dim lhBmp2 As Long
Dim lhBmpOld2 As Long
Dim lhDCDesktop As Long
Dim tBMP As BITMAP
   
   GetObjectAPI iPic.handle, Len(tBMP), tBMP
   
   lhDCDesktop = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
   If (lhDCDesktop <> 0) Then
      lhDC1 = CreateCompatibleDC(lhDCDesktop)
      If lhDC1 <> 0 Then
         lhBmpOld1 = SelectObject(lhDC1, iPic.handle)
      End If
      
      lhDC2 = CreateCompatibleDC(lhDCDesktop)
      If lhDC2 <> 0 Then
         lhBmp2 = CreateCompatibleBitmap(lhDCDesktop, tBMP.bmWidth, tBMP.bmHeight)
         lhBmpOld2 = SelectObject(lhDC2, lhBmp2)
      End If
      
      If lhDC1 <> 0 And lhBmp2 <> 0 Then
         BitBlt lhDC2, 0, 0, tBMP.bmWidth, tBMP.bmHeight, lhDC1, 0, 0, vbSrcCopy
      End If
      
      If lhBmp2 <> 0 Then
         SelectObject lhDC2, lhBmpOld2
         DeleteDC lhDC2
         hBmpFromPicture = lhBmp2
      End If
      
      If lhDC1 <> 0 Then
         SelectObject lhDC1, lhBmpOld1
         DeleteDC lhDC1
      End If
      
      DeleteDC lhDCDesktop
      
   End If

End Function
Public Sub TileArea( _
        ByVal hdcTo As Long, _
        ByVal x As Long, _
        ByVal y As Long, _
        ByVal width As Long, _
        ByVal height As Long, _
        ByVal hdcSrc As Long, _
        ByVal srcWidth As Long, _
        ByVal srcHeight As Long, _
        ByVal lOffsetX As Long, _
        ByVal lOffsetY As Long _
    )
Dim lSrcX As Long
Dim lSrcY As Long
Dim lSrcStartX As Long
Dim lSrcStartY As Long
Dim lSrcStartWidth As Long
Dim lSrcStartHeight As Long
Dim lDstX As Long
Dim lDstY As Long
Dim lDstWidth As Long
Dim lDstHeight As Long

   If (srcWidth = 0 Or srcHeight = 0) Then Exit Sub
   
    lSrcStartX = ((x + lOffsetX) Mod srcWidth)
    lSrcStartY = ((y + lOffsetY) Mod srcHeight)
    'Debug.Print lSrcStartX, lSrcStartY
    lSrcStartWidth = (srcWidth - lSrcStartX)
    lSrcStartHeight = (srcHeight - lSrcStartY)
    lSrcX = lSrcStartX
    lSrcY = lSrcStartY
    
    lDstY = y
    lDstHeight = lSrcStartHeight
    
    Do While lDstY < (y + height)
        If (lDstY + lDstHeight) > (y + height) Then
            lDstHeight = y + height - lDstY
        End If
        lDstWidth = lSrcStartWidth
        lDstX = x
        lSrcX = lSrcStartX
        Do While lDstX < (x + width)
            If (lDstX + lDstWidth) > (x + width) Then
                lDstWidth = x + width - lDstX
                If (lDstWidth = 0) Then
                    lDstWidth = 4
                End If
            End If
            'If (lDstWidth > Width) Then lDstWidth = Width
            'If (lDstHeight > Height) Then lDstHeight = Height
            BitBlt hdcTo, lDstX, lDstY, lDstWidth, lDstHeight, hdcSrc, lSrcX, lSrcY, vbSrcCopy
            lDstX = lDstX + lDstWidth
            lSrcX = 0
            lDstWidth = srcWidth
        Loop
        lDstY = lDstY + lDstHeight
        lSrcY = 0
        lDstHeight = srcHeight
    Loop
End Sub


Public Function getFormParenthWnd(ByVal hWndControl As Long) As Long
Dim lhWnd As Long
Dim lhWndTest As Long
   lhWndTest = GetParent(hWndControl)
   Do
      lhWnd = lhWndTest
      lhWndTest = GetParent(lhWnd)
   Loop While Not (lhWndTest = 0)
   getFormParenthWnd = lhWnd
End Function

