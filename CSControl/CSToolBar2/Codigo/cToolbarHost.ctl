VERSION 5.00
Begin VB.UserControl cToolbarHost 
   Alignable       =   -1  'True
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   ClipControls    =   0   'False
   ControlContainer=   -1  'True
   ScaleHeight     =   3600
   ScaleWidth      =   4800
   ToolboxBitmap   =   "cToolbarHost.ctx":0000
   Begin VB.PictureBox picIcon 
      BorderStyle     =   0  'None
      Height          =   255
      Left            =   0
      ScaleHeight     =   255
      ScaleWidth      =   255
      TabIndex        =   3
      TabStop         =   0   'False
      Top             =   60
      Visible         =   0   'False
      Width           =   255
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "r"
      BeginProperty Font 
         Name            =   "Marlett"
         Size            =   8.25
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   225
      Left            =   4500
      Style           =   1  'Graphical
      TabIndex        =   2
      TabStop         =   0   'False
      Top             =   0
      Visible         =   0   'False
      Width           =   285
   End
   Begin VB.CommandButton cmdRestore 
      Caption         =   "2"
      BeginProperty Font 
         Name            =   "Marlett"
         Size            =   8.25
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   225
      Left            =   4200
      Style           =   1  'Graphical
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   0
      Visible         =   0   'False
      Width           =   285
   End
   Begin VB.CommandButton cmdMinimize 
      Caption         =   "0"
      BeginProperty Font 
         Name            =   "Marlett"
         Size            =   8.25
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   225
      Left            =   3900
      Style           =   1  'Graphical
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   0
      Visible         =   0   'False
      Width           =   285
   End
End
Attribute VB_Name = "cToolbarHost"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' =========================================================================
' vbAccelerator Toolbar Host control v2.1
' Copyright © 1998-2000 Steve McMahon (steve@vbaccelerator.com)
'
' A control for hosting a toolbar outside a rebar.
' Also includes min/restore/close and child form menu to show for
' an MDI toolbar menu when the child window is maximised.
'
' -------------------------------------------------------------------------
' Visit vbAccelerator at http://vbaccelerator.com
' =========================================================================

Private Declare Function OpenThemeData Lib "uxtheme.dll" _
   (ByVal hwnd As Long, ByVal pszClassList As Long) As Long
Private Declare Function CloseThemeData Lib "uxtheme.dll" _
   (ByVal hTheme As Long) As Long
Private Declare Function DrawThemeParentBackground Lib "uxtheme.dll" _
   (ByVal hwnd As Long, ByVal hdc As Long, prc As RECT) As Long
Private Declare Function DrawThemeBackground Lib "uxtheme.dll" _
   (ByVal hTheme As Long, ByVal lHDC As Long, _
    ByVal iPartId As Long, ByVal iStateId As Long, _
    pRect As RECT, pClipRect As RECT) As Long

Private Const WP_MDISYSBUTTON = 14
Private Const WP_MDIMINBUTTON = 16
Private Const WP_MDICLOSEBUTTON = 20
Private Const WP_MDIRESTOREBUTTON = 22
Private Const WP_MDIHELPBUTTON = 24
Private Const MDIBS_NORMAL = 1
Private Const MDIBS_HOT = 2
Private Const MDIBS_PUSHED = 3
Private Const MDIBS_DISABLED = 4


Implements cISubclass
Private m_bSubClass As Boolean

Public Enum ETBHBorderStyleConstants
   etbhBorderStyleNone = 0
   etbhBorderStyleSingle = 1
End Enum

Private Type tCaptureWindow
   bIsToolbar As Boolean
   hwnd As Long
   hWndParentOrig As Long
   lPtrObj As Long
   lMinWidth As Long
End Type
Private m_tCaptureWin() As tCaptureWindow
Private m_iWinCount As Long
Private Type tThisRow
   hwnd As Long
   lLeft As Long
   lTop As Long
   lWidth As Long
   lHeight As Long
   bToolbar As Boolean
End Type
Private m_tThisRow() As tThisRow
Private m_iThisRowCount As Long

Private m_lHeight As Long
Private m_lHOffset As Long

Private m_hWnd As Long
Private m_hWndParent As Long
Private m_bMDIToolbar As Boolean
Private m_bHideButtons As Boolean
Private m_bMDIButtonstate As Boolean
Private m_cMDIToolbarMenu As cMDIToolbarMenu
Private m_hwndMDIChild As Long
Private m_hWndMdi As Long

Private m_eBorderStyle As ETBHBorderStyleConstants

' Background imaage:
Private m_sPicture As String
Private m_lResourceID As Long
Private m_hInstance As Long
Private m_pic As StdPicture
Private m_eImageSourceType As ECRBImageSourceTypes
Private m_hDC As Long
Private m_hBmp As Long
Private m_hBmpOld As Long
Private m_lPicWidth As Long
Private m_lPicHeight As Long

Private m_sCtlName As String

Public Event Resize()

Public Sub Refresh()
Attribute Refresh.VB_Description = "Refreshes and resizes the contents of the control."
Dim tR As RECT
   GetWindowRect UserControl.hwnd, tR
   pResize tR.right - tR.left, tR.bottom - tR.top
End Sub
Public Property Get MDIToolbarMinWidth() As Long
Dim lW As Long
Dim lH As Long
   pToolbarSize m_tCaptureWin(1).hwnd, lW, lH
   lW = lW + GetSystemMetrics(SM_CXSMICON) + 2
   lW = lW + 3 * (GetSystemMetrics(SM_CYMENU) + 1)
   MDIToolbarMinWidth = lW
End Property
Public Property Get MDIToolbar() As Boolean
Attribute MDIToolbar.VB_Description = "Gets/sets whether the toolbar host control should act as an MDI Toolbar in a CoolMenu style application."
   MDIToolbar = m_bMDIToolbar
End Property
Public Property Let MDIToolbar(ByVal bState As Boolean)
   m_bMDIToolbar = bState
   If UserControl.Ambient.UserMode Then
      If m_bMDIToolbar Then
         Set m_cMDIToolbarMenu = New cMDIToolbarMenu
         m_cMDIToolbarMenu.Attach getFormParenthWnd(UserControl.hwnd), Me
      Else
         Set m_cMDIToolbarMenu = Nothing
      End If
      UserControl.Extender.height = (GetSystemMetrics(SM_CYMENU) + 2) * Screen.TwipsPerPixelY
   End If
   PropertyChanged "MDIToolbar"
End Property
Public Property Get MDIToolbarHideButtons() As Boolean
   MDIToolbarHideButtons = m_bHideButtons
End Property
Public Property Let MDIToolbarHideButtons(ByVal bState As Boolean)
   m_bHideButtons = bState
End Property

Friend Sub MDIChildIcon(ByVal hwnd As Long)
   m_hWndMdi = hwnd
   picIcon_Paint
End Sub
Friend Sub MDIButtons(ByVal hwnd As Long, ByVal bState As Boolean)
Dim tR As RECT
Dim i As Long

   If m_bMDIToolbar Then
      'Debug.Print "MDIButtons:", bState
      If bState = m_bMDIButtonstate Then
         If hwnd <> m_hwndMDIChild Then
            MDIChildIcon hwnd
         End If
         m_hwndMDIChild = hwnd
      Else
         m_hwndMDIChild = hwnd
         m_bMDIButtonstate = bState
         
         ' Show/hide the buttons:
         If bState And Not m_bHideButtons Then
            'Debug.Print "Attempting to show buttons"
            m_iWinCount = m_iWinCount + 1
            ReDim Preserve m_tCaptureWin(1 To m_iWinCount) As tCaptureWindow
            For i = m_iWinCount - 1 To 1 Step -1
               LSet m_tCaptureWin(i + 1) = m_tCaptureWin(i)
            Next i
            m_hWndMdi = m_hWnd
            picIcon.width = (GetSystemMetrics(SM_CXSMICON)) * Screen.TwipsPerPixelX
            picIcon.height = (GetSystemMetrics(SM_CYSMICON)) * Screen.TwipsPerPixelY
            picIcon.Visible = True
                        
            MDIChildIcon hwnd
                        
            GetWindowRect picIcon.hwnd, tR
            With m_tCaptureWin(1)
               .bIsToolbar = False
               .hWndParentOrig = UserControl.hwnd
               .hwnd = picIcon.hwnd
               .lMinWidth = tR.right - tR.left
               .lPtrObj = ObjPtr(picIcon)
            End With
            'cmdClose.width = (GetSystemMetrics(SM_CXSMICON)) * Screen.TwipsPerPixelX
            'cmdClose.height = (GetSystemMetrics(SM_CYSMICON)) * Screen.TwipsPerPixelY
            cmdClose.Visible = True
            cmdMinimize.width = cmdClose.width
            cmdMinimize.height = cmdClose.height
            cmdMinimize.Visible = True
            cmdRestore.width = cmdClose.width
            cmdRestore.height = cmdClose.height
            cmdRestore.Visible = True
         Else
            ' Debug.Print "Attempting to hide buttons"
            picIcon.Visible = False
            cmdClose.Visible = False
            cmdMinimize.Visible = False
            cmdRestore.Visible = False
            If m_iWinCount > 0 Then
               If m_tCaptureWin(1).hwnd = picIcon.hwnd Then
                  If m_iWinCount > 1 Then
                     For i = 1 To m_iWinCount - 1
                        LSet m_tCaptureWin(i) = m_tCaptureWin(i + 1)
                     Next i
                     m_iWinCount = m_iWinCount - 1
                     ReDim Preserve m_tCaptureWin(1 To m_iWinCount) As tCaptureWindow
                  Else
                     m_iWinCount = 0
                     Erase m_tCaptureWin
                  End If
               End If
            End If
         End If
         
         ' Resize in to bring them in effect:
         GetWindowRect UserControl.hwnd, tR
         pResize tR.right - tR.left, tR.bottom - tR.top
         
         If Not bState Then
            InvalidateRectAsNull UserControl.hwnd, ByVal 0&, 1
            UpdateWindow UserControl.hwnd
         End If
      End If
      
   End If
End Sub

Public Property Get hwnd() As Long
Attribute hwnd.VB_Description = "Gets the hWnd of the control."
   hwnd = UserControl.hwnd
End Property

Public Property Get BorderStyle() As ETBHBorderStyleConstants
Attribute BorderStyle.VB_Description = "Gets/sets the border style of the control."
   BorderStyle = m_eBorderStyle
End Property
Public Property Let BorderStyle(ByVal eStyle As ETBHBorderStyleConstants)
   UserControl.BorderStyle() = eStyle
   m_eBorderStyle = eStyle
   PropertyChanged "BorderStyle"
End Property

Public Property Get RequiredHeight() As Long
Attribute RequiredHeight.VB_Description = "Returns the height the height required to display the items in the control at the current width."
   RequiredHeight = m_lHeight
End Property

Private Function TranslateColor(ByVal oClr As OLE_COLOR, _
                                   Optional hPal As Long = 0) As Long
   ' Convert Automation color to Windows color
   If OleTranslateColor(oClr, hPal, TranslateColor) Then
       TranslateColor = -1
   End If
   
End Function

Public Sub Autosize()
Attribute Autosize.VB_Description = "Attempts to size the toolbar host control to best fit the contained controls."
   SendMessageLong Me.hwnd, WM_SIZE, 0, 0
End Sub

Private Function pResize(ByVal lWidth As Long, ByVal lHeight As Long)
Dim tR As RECT, tP As POINTAPI
Dim tRD As RECT
Dim i As Long
Dim lS As Long
Dim bWrappable As Boolean, bFits As Boolean
Dim iBtn As Long, lBtns As Long
Dim tB As TBBUTTON
Dim wId As Long
Dim lW As Long, lH As Long
Dim lLeft As Long, lTop As Long
Dim lBLeft As Long, lBTop As Long
Dim lRowHeight As Long
Dim bFirstTime As Boolean

   bFirstTime = True
   
   If m_bMDIButtonstate Then
      GetWindowRect UserControl.hwnd, tRD
      lBLeft = (tRD.right - tRD.left) * Screen.TwipsPerPixelX - (cmdMinimize.width) * 3 - 2 * Screen.TwipsPerPixelX
      lBTop = ((tRD.bottom - tRD.top) - cmdMinimize.height \ Screen.TwipsPerPixelY) \ 2
   End If
   
   lLeft = 2: lTop = m_lHOffset
   ' Debug.Print m_iWinCount
   
   For i = 1 To m_iWinCount
   
      If m_tCaptureWin(i).bIsToolbar Then
         ' Determine whether the toolbar is wrappable or not:
         lS = GetWindowLong(m_tCaptureWin(i).hwnd, GWL_STYLE)
         bWrappable = ((lS And TBSTYLE_WRAPABLE) = TBSTYLE_WRAPABLE)
         
         ' Determine what the width of the toolbar is going to be:
         pToolbarSize m_tCaptureWin(i).hwnd, lW, lH
         
         ' Now check whether this fits into the available space:
         bFits = (lLeft + lW < lWidth)
         
         If bWrappable Then
            If bFits Or m_bMDIButtonstate Or m_bMDIToolbar Then
               ' use this row:
               If m_bMDIButtonstate Then
                  If lLeft + lW > lBLeft \ Screen.TwipsPerPixelX Then
                     lW = lBLeft \ Screen.TwipsPerPixelX - lLeft
                  End If
               End If
               MoveWindow m_tCaptureWin(i).hwnd, lLeft, lTop, lW, lH + m_lHOffset, 1
               GetWindowRect m_tCaptureWin(i).hwnd, tR
               pAddToRow m_tCaptureWin(i).hwnd, lLeft, lTop, lW, lH + m_lHOffset, True
            Else
               ' start a new row:
               pFlushRow
               lLeft = 2
               lTop = lTop + lRowHeight
               MoveWindow m_tCaptureWin(i).hwnd, lLeft, lTop, lWidth, lHeight - lTop, 1
               pAddToRow m_tCaptureWin(i).hwnd, lLeft, lTop, lWidth, lH + m_lHOffset, True
            End If
         
            If Not m_bMDIButtonstate Then
               SendMessage m_tCaptureWin(i).hwnd, TB_GETRECT, tB.idCommand, tR
               MoveWindow m_tCaptureWin(i).hwnd, lLeft, lTop, lWidth, tR.bottom + m_lHOffset, 1
               lLeft = lLeft + tR.right + 4
               lTop = tR.top
               lRowHeight = tR.bottom - tR.top
            End If
         Else
            If Not (bFits Or bFirstTime) Then
               lLeft = 2
               If Not bFirstTime Then
                  pFlushRow
                  lTop = lTop + lRowHeight
               End If
            End If
            MoveWindow m_tCaptureWin(i).hwnd, lLeft, lTop, lW, lH, 1
            pAddToRow m_tCaptureWin(i).hwnd, lLeft, lTop, lLeft + tR.right, lH + m_lHOffset, True
            lLeft = lLeft + tR.right + 4
            lTop = tR.top
            lRowHeight = tR.bottom - tR.top
            bFirstTime = False
         End If
      
      Else
         GetWindowRect m_tCaptureWin(i).hwnd, tR
         
         If lLeft + m_tCaptureWin(i).lMinWidth < lWidth Then
            ' use this row:
            'Debug.Print "Use This Row"
            If tR.bottom - tR.top < lRowHeight Then
               'SetWindowPos m_tCaptureWin(i).hWnd, 0, lLeft, lTop + 1 + ((lRowHeight - (tR.Bottom - tR.tOp)) \ 2), 0, 0, SWP_NOSIZE Or SWP_FRAMECHANGED Or SWP_NOACTIVATE Or SWP_NOOWNERZORDER Or SWP_NOZORDER
               pAddToRow m_tCaptureWin(i).hwnd, lLeft, lTop + 1, 0, 0, False
            Else
               lRowHeight = tR.bottom - tR.top
               'SetWindowPos m_tCaptureWin(i).hWnd, 0, lLeft, lTop + 1, 0, 0, SWP_NOSIZE Or SWP_FRAMECHANGED Or SWP_NOACTIVATE Or SWP_NOOWNERZORDER Or SWP_NOZORDER
               pAddToRow m_tCaptureWin(i).hwnd, lLeft, lTop + 1, 0, 0, False
            End If
         Else
            ' start a new row:
            'Debug.Print "New Row"
            pFlushRow
            lTop = lTop + lRowHeight + 3
            lLeft = 2
            lRowHeight = tR.bottom - tR.top
            'SetWindowPos m_tCaptureWin(i).hWnd, 0, lLeft, lTop + 1, 0, 0, SWP_NOSIZE Or SWP_FRAMECHANGED Or SWP_NOACTIVATE Or SWP_NOOWNERZORDER Or SWP_NOZORDER
            pAddToRow m_tCaptureWin(i).hwnd, lLeft, lTop + 1, 0, 0, False
         End If
         lLeft = lLeft + tR.right - tR.left + 2
      End If
      
   Next i
   pFlushRow
      
   If m_iWinCount <= 0 Then
      m_lHeight = 0
   Else
      GetWindowRect m_tCaptureWin(m_iWinCount).hwnd, tR
      tP.x = tR.left: tP.y = tR.bottom
      ScreenToClient UserControl.hwnd, tP
      m_lHeight = tP.y + m_eBorderStyle * 2
   End If
   
   If m_bMDIButtonstate Then
      cmdMinimize.Move lBLeft, lBTop * Screen.TwipsPerPixelY
      cmdRestore.Move lBLeft + cmdMinimize.width + Screen.TwipsPerPixelX, cmdMinimize.top
      cmdClose.Move cmdRestore.left + cmdRestore.width + Screen.TwipsPerPixelX, cmdMinimize.top
      cmdMinimize.ZOrder
      cmdRestore.ZOrder
      cmdClose.ZOrder
   End If
   
End Function
Private Sub pToolbarSize( _
      ByVal lhWnd As Long, _
      ByRef lW As Long, _
      ByRef lH As Long _
   )
Dim lBtns As Long
Dim iBtn As Long
Dim tB As TBBUTTON
Dim tR As RECT
   lW = 0: lH = 0
   lBtns = SendMessageLong(lhWnd, TB_BUTTONCOUNT, 0, 0)
   For iBtn = 0 To lBtns - 1
      SendMessage lhWnd, TB_GETBUTTON, iBtn, tB
      If SendMessageLong(lhWnd, TB_ISBUTTONHIDDEN, tB.idCommand, 0) = 0 Then
         SendMessage lhWnd, (WM_USER + 29), iBtn, tR ' TB_GETITEMRECT
         lW = lW + tR.right - tR.left
         lH = tR.bottom - tR.top
      End If
   Next iBtn
End Sub
Private Sub pAddToRow( _
      ByVal lhWnd As Long, _
      ByVal lLeft As Long, ByVal lTop As Long, _
      ByVal lWidth As Long, ByVal lHeight As Long, _
      ByVal bToolbar As Boolean _
   )
Dim tR As RECT
   m_iThisRowCount = m_iThisRowCount + 1
   ReDim Preserve m_tThisRow(1 To m_iThisRowCount) As tThisRow
   With m_tThisRow(m_iThisRowCount)
      .hwnd = lhWnd
      .lLeft = lLeft
      .lTop = lTop
      If Not bToolbar Then
         GetWindowRect lhWnd, tR
         .lHeight = tR.bottom - tR.top
      Else
         .lWidth = lWidth
         .lHeight = lHeight
         .bToolbar = True
      End If
   End With
End Sub
Private Sub pFlushRow()
Dim i As Long
Dim lH As Long
Dim tR As RECT
Dim lTop As Long
Dim bSkip As Boolean
   
   For i = 1 To m_iThisRowCount
      If m_tThisRow(i).lHeight > lH Then
         lH = m_tThisRow(i).lHeight
      End If
   Next i
   
   If lH > 0 Then
      For i = 1 To m_iThisRowCount
         bSkip = False
         If m_bMDIToolbar Then
            If m_tThisRow(i).bToolbar Then
               bSkip = True
            End If
         End If
         If Not bSkip Then
            lTop = m_tThisRow(i).lTop + (lH - m_tThisRow(i).lHeight) \ 2
            SetWindowPos m_tThisRow(i).hwnd, 0, m_tThisRow(i).lLeft, lTop, 0, 0, SWP_NOSIZE Or SWP_FRAMECHANGED Or SWP_NOACTIVATE Or SWP_NOOWNERZORDER Or SWP_NOZORDER
         End If
      Next i
   End If
   
   Erase m_tThisRow
   m_iThisRowCount = 0
   
End Sub
Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_Description = "Gets/sets the background colour of the toolbar host control."
   BackColor = UserControl.BackColor
End Property
Public Property Let BackColor(ByVal oColor As OLE_COLOR)
   UserControl.BackColor = oColor
   picIcon.BackColor = oColor
   SendMessageLong UserControl.hwnd, WM_SIZE, 0, 0
   PropertyChanged "BackColor"
End Property
Public Property Get HasBitmap() As Boolean
   HasBitmap = (m_hBmp <> 0)
End Property
Public Property Let ImageSource( _
        ByVal eType As ECRBImageSourceTypes _
    )
    m_eImageSourceType = eType
End Property
Public Property Let ImageResourceID(ByVal lResourceId As Long)
   ClearPicture
   m_lResourceID = lResourceId
End Property
Public Property Let ImageResourcehInstance(ByVal hInstance As Long)
   m_hInstance = hInstance
End Property
Public Property Let ImageFile(ByVal sFile As String)
   ClearPicture
   m_sPicture = sFile
End Property
Public Property Let ImagePicture(ByVal picThis As StdPicture)
   ClearPicture
   Set m_pic = picThis
End Property
Public Property Set ImagePicture(ByVal picThis As StdPicture)
   ClearPicture
   Set m_pic = picThis
End Property
Public Property Get BackgroundBitmap() As String
   BackgroundBitmap = m_sPicture
End Property
Public Property Let BackgroundBitmap(ByVal sFile As String)
   ImageSource = CRBLoadFromFile
   ImageFile = Trim$(sFile)
End Property
Private Sub GetBackgroundBitmapHandle()
Dim lhDCC As Long
Dim tBMP As BITMAP
      
   ' Set up the picture if we don't already have one:
   If (m_hBmp = 0) Then
      Select Case m_eImageSourceType
      Case CRBPicture
         If Not (m_pic Is Nothing) Then
            m_hBmp = hBmpFromPicture(m_pic)
         End If
      Case CTBLoadFromFile
         If Len(m_sPicture) > 0 Then
            m_hBmp = LoadImage(0, m_sPicture, IMAGE_BITMAP, 0, 0, _
                     LR_LOADFROMFILE Or LR_LOADMAP3DCOLORS)
         End If
      Case CTBResourceBitmap
         If m_hInstance <> 0 Then
            m_hBmp = LoadImageLong(m_hInstance, m_lResourceID, IMAGE_BITMAP, 0, 0, _
                     LR_LOADMAP3DCOLORS)
         End If
      End Select
         
      If m_hBmp <> 0 Then
         
         GetObjectAPI m_hBmp, Len(tBMP), tBMP
         m_lPicWidth = tBMP.bmWidth
         m_lPicHeight = tBMP.bmHeight

         lhDCC = CreateDCAsNull("DISPLAY", ByVal 0&, ByVal 0&, ByVal 0&)
         m_hDC = CreateCompatibleDC(lhDCC)
         m_hBmpOld = SelectObject(m_hDC, m_hBmp)
         DeleteDC lhDCC
      End If
      
   End If
   
End Sub
Public Sub ClearPicture()
   If (m_hDC <> 0) Then
      SelectObject m_hDC, m_hBmpOld
   End If
   If (m_hBmp <> 0) Then
      DeleteObject m_hBmp
      m_hBmp = 0
   End If
   DeleteDC m_hDC
   m_sPicture = ""
   m_lResourceID = 0
   Set m_pic = Nothing
End Sub
Public Sub Capture(ByRef ctlThis As Object)
Attribute Capture.VB_Description = "Adds a control to the list of contained controls within the toolbar host."
Dim hWndA As Long
Dim bHaveIt As Boolean
Dim iWin As Long
Dim tR As RECT

   On Error Resume Next
   hWndA = ctlThis.hwnd
   If hWndA = 0 Then
      ' Error, need a hwnd
   Else
      Err.Clear
      On Error GoTo 0
      For iWin = 1 To m_iWinCount
         If m_tCaptureWin(iWin).hwnd = hWndA Then
            bHaveIt = True
            Exit For
         End If
      Next iWin
   
      If Not bHaveIt Then
         m_iWinCount = m_iWinCount + 1
         ReDim Preserve m_tCaptureWin(1 To m_iWinCount) As tCaptureWindow
         m_tCaptureWin(m_iWinCount).hwnd = hWndA
         If TypeName(ctlThis) = "cToolbar" Then
            m_tCaptureWin(m_iWinCount).bIsToolbar = True
            m_tCaptureWin(m_iWinCount).hWndParentOrig = GetParent(hWndA)
            SetParent hWndA, UserControl.hwnd
            If Not (m_bSubClass) Then
               m_hWnd = UserControl.hwnd
               If m_bMDIToolbar Then
                  m_hWndParent = getFormParenthWnd(UserControl.hwnd)
               Else
                  m_hWndParent = m_hWnd
               End If
               AttachMessage Me, m_hWnd, WM_ERASEBKGND
               AttachMessage Me, m_hWnd, WM_SIZE
               AttachMessage Me, m_hWnd, WM_DRAWITEM
               AttachMessage Me, m_hWnd, WM_DESTROY
               m_bSubClass = True
            End If
         Else
            GetWindowRect hWndA, tR
            m_tCaptureWin(m_iWinCount).lMinWidth = tR.right - tR.left
            Set ctlThis.Container = UserControl.Extender
         End If
         m_tCaptureWin(m_iWinCount).lPtrObj = ObjPtr(ctlThis)
         pResize UserControl.ScaleWidth \ Screen.TwipsPerPixelX, UserControl.ScaleHeight \ Screen.TwipsPerPixelY
      End If
   End If
   
End Sub

Public Sub ReleaseCaptures()
Attribute ReleaseCaptures.VB_Description = "Frees any contained controls.  Called automatically before the control terminates."
Dim i As Long
   For i = 1 To m_iWinCount
      If m_tCaptureWin(i).bIsToolbar Then
         SetParent m_tCaptureWin(i).hwnd, m_tCaptureWin(i).hWndParentOrig
      Else
         ' nothing to do
      End If
   Next i
      
   If (m_bSubClass) Then
      DetachMessage Me, m_hWnd, WM_ERASEBKGND
      DetachMessage Me, m_hWnd, WM_SIZE
      DetachMessage Me, m_hWnd, WM_DRAWITEM
      DetachMessage Me, m_hWnd, WM_DESTROY
      m_bSubClass = False
   End If
End Sub

Private Sub cmdClose_Click()
   PostMessage m_hwndMDIChild, WM_SYSCOMMAND, SC_CLOSE, 0
End Sub

Private Sub cmdMinimize_Click()
   PostMessage m_hwndMDIChild, WM_SYSCOMMAND, SC_MINIMIZE, 0
End Sub

Private Sub cmdRestore_Click()
Dim lhWnd As Long
   lhWnd = FindWindowEx(m_hWndParent, 0, "MDIClient", ByVal 0&)
   PostMessage lhWnd, WM_MDIRESTORE, m_hwndMDIChild, 0
End Sub

Private Sub drawButton( _
      ByVal lhWnd As Long, _
      ByVal lHDC As Long, _
      rcItem As RECT, _
      ByVal lStyle As Long, _
      ByVal bEnabled As Boolean, _
      ByVal bPushed As Boolean, _
      ByVal bChecked As Boolean _
   )
Dim hTheme As Long
Dim iPartId As Long
Dim iStateId As Long

   On Error Resume Next
   hTheme = OpenThemeData(lhWnd, StrPtr("Window"))
   On Error GoTo 0
   If (hTheme = 0) Then
      DrawFrameControl lHDC, rcItem, DFC_CAPTION, (lStyle And Not &H1000)
   Else
      Select Case lStyle And &HF&
      Case DFCS_CAPTIONCLOSE
         iPartId = WP_MDICLOSEBUTTON
      Case DFCS_CAPTIONRESTORE
         iPartId = WP_MDIRESTOREBUTTON
      Case DFCS_CAPTIONMIN
         iPartId = WP_MDIMINBUTTON
      End Select
      If Not bEnabled Then
         iStateId = MDIBS_DISABLED
      ElseIf (bPushed Or bChecked) Then
         iStateId = MDIBS_PUSHED
         Debug.Print "Drawing with state", iStateId, " (pushed)", iPartId, hTheme, lHDC, lStyle, lStyle And &HF&
      Else
         iStateId = MDIBS_NORMAL
      End If
      DrawThemeParentBackground lhWnd, lHDC, rcItem
      DrawThemeBackground hTheme, lHDC, iPartId, iStateId, rcItem, rcItem
      CloseThemeData hTheme
   End If

End Sub

Private Property Let cISubclass_MsgResponse(ByVal RHS As EMsgResponse)
   '
End Property

Private Property Get cISubclass_MsgResponse() As EMsgResponse
   If CurrentMessage = WM_DRAWITEM Or CurrentMessage = WM_ERASEBKGND Then
      cISubclass_MsgResponse = emrConsume
   Else
      cISubclass_MsgResponse = emrPreprocess
   End If
End Property

Private Function cISubclass_WindowProc(ByVal hwnd As Long, ByVal iMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Dim tR As RECT
Dim ttR As RECT
Dim tRO As RECT
Dim tP As POINTAPI
Dim hBr As Long
Dim i As Long
Dim lBtns As Long, iBtn As Long
Dim tB As TBBUTTON
Dim lhWnd As Long
Dim lStyle As Long
Dim lState As Long
Dim bPushed As Boolean, bChecked As Boolean, bEnabled As Boolean
Dim tDIS As DRAWITEMSTRUCT

   'Debug.Print "ERASEBKGND", wParam, lParam
   Select Case iMsg
   Case WM_DRAWITEM
      ' Debug.Print "Got WM_DRAWITEM"
      CopyMemory tDIS, ByVal lParam, Len(tDIS)
      If tDIS.CtlType = ODT_BUTTON Then
         lStyle = GetProp(tDIS.hwndItem, "vbalTBarBtn:Style")
      End If
      If Not lStyle = 0 Then
         'lState = SendMessageLong(tDIS.hwndItem, BM_GETSTATE, 0, 0)
         lState = tDIS.itemState
         Debug.Print Hex$(tDIS.itemState), Hex$(lState)
         bPushed = ((lState And BST_CHECKED) = BST_CHECKED) Or ((lState And BST_PUSHED) = BST_PUSHED)
         bChecked = (SendMessageLong(tDIS.hwndItem, BM_GETCHECK, 0, 0) <> 0)
         bEnabled = True
         If (bPushed) Or (bChecked) Then
            Debug.Print "PUSHED"
            lStyle = lStyle Or DFCS_PUSHED
         End If
         If Not (bEnabled) Then
            lStyle = lStyle Or DFCS_INACTIVE
         End If
         tDIS.rcItem.bottom = tDIS.rcItem.bottom - 1
         drawButton hwnd, tDIS.hdc, tDIS.rcItem, lStyle, bEnabled, bPushed, bChecked
      Else
         cISubclass_WindowProc = CallOldWindowProc(hwnd, iMsg, wParam, lParam)
      End If
   
   Case WM_SIZE
      ' VB does not cause _Resize event when for a UC window
      ' when it is resized using the API...
      GetWindowRect UserControl.hwnd, tR
      pResize tR.right - tR.left, tR.bottom - tR.top
      
   Case WM_ERASEBKGND
      lhWnd = UserControl.hwnd
      If m_hDC = 0 Then
         GetBackgroundBitmapHandle
      End If
      If m_hDC = 0 Then
         hBr = CreateSolidBrush(TranslateColor(UserControl.BackColor))
      End If
      For i = 1 To m_iWinCount
         If m_tCaptureWin(i).bIsToolbar Then
            GetClientRect m_tCaptureWin(i).hwnd, ttR
            MapWindowPoints m_tCaptureWin(i).hwnd, lhWnd, ttR, 2
            If m_hDC = 0 Then
               FillRect wParam, ttR, hBr
            Else
               GetClientRect lhWnd, tR
               MapWindowPoints lhWnd, GetParent(lhWnd), tR, 2
               TileArea wParam, ttR.left, ttR.top, ttR.right - ttR.left, ttR.bottom - ttR.top, m_hDC, m_lPicWidth, m_lPicHeight, tR.left, tR.top
            End If
         
            'lBtns = SendMessageLong(m_tCaptureWin(i).hWnd, TB_BUTTONCOUNT, 0, 0)
            'Debug.Print "TB:", lBtns
            'For iBtn = 0 To lBtns - 1
            '   SendMessage m_tCaptureWin(i).hWnd, TB_GETBUTTON, iBtn, tB
            '   SendMessage m_tCaptureWin(i).hWnd, TB_GETRECT, tB.idCommand, tR
            '   tR.bottom = tR.bottom + 1
            '   LSet ttR = tR
            '   MapWindowPoints m_tCaptureWin(i).hWnd, lhWnd, ttR, 2
            '   If m_hDC = 0 Then
            '      FillRect wParam, ttR, hBr
            '   Else
            '      GetClientRect lhWnd, tR
            '      MapWindowPoints lhWnd, GetParent(lhWnd), tR, 2
            '      Debug.Print tR.left, tR.top
            '      TileArea wParam, ttR.left, ttR.top, ttR.right - ttR.left, ttR.bottom - ttR.top, m_hDC, m_lPicWidth, m_lPicHeight, tR.left, tR.top
            '   End If
            'Next iBtn
         End If
      Next i
      If hBr <> 0 Then
         DeleteObject hBr
      End If
      cISubclass_WindowProc = 1
      
   Case WM_DESTROY
      ReleaseCaptures
   End Select
End Function

Private Sub picIcon_DblClick()
   ' Select default sys menu item:
   'PostMessage m_hWnd, WM_SYSCOMMAND, SC_DEFAULT, 0
End Sub

Private Sub picIcon_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
Dim hMenu As Long
Dim hwnd As Long
Dim tR As RECT
Dim tPM As TPMPARAMS
Dim tbrThis As cToolbar
Dim oTT As cToolbar
Dim lPtrTb As Long
Dim i As Long
Dim lR As Long
Dim bDone As Boolean
   
   If Button = vbLeftButton Then
      'Debug.Print "MouseDown?"
      If m_bMDIToolbar Then
         For i = 1 To m_iWinCount
            If m_tCaptureWin(i).bIsToolbar Then
               lPtrTb = GetProp(m_tCaptureWin(i).hwnd, "vbalTbar:ControlPtr")
               Exit For
            End If
         Next i
         
         ' Debug.Print "MDIToolbar:Click", lPtrTb
         If lPtrTb <> 0 Then
            CopyMemory oTT, lPtrTb, 4
            Set tbrThis = oTT
            CopyMemory oTT, 0&, 4
            If Not tbrThis Is Nothing Then
               'Debug.Print "Call pMenuClick..."
               ReleaseCapture
               tbrThis.pMenuClick tbrThis.hwnd, &H7FFF
               bDone = True
            End If
         End If
      End If
      
      If Not bDone Then
         'Debug.Print "MouseDown - menu?"
         hwnd = FindWindowEx(m_hWndParent, 0, "MDIClient", ByVal 0&)
         hwnd = SendMessageLong(hwnd, WM_MDIGETACTIVE, 0, 0)
         hMenu = GetSystemMenu(hwnd, 0) 'PostMessage(m_hWnd, WM_SYSCOMMAND, SC_KEYMENU, 0)
         'Debug.Print hMenu, hWnd
         GetWindowRect picIcon.hwnd, tR
         tPM.cbSize = Len(tPM)
         LSet tPM.rcExclude = tR
         lR = TrackPopupMenuEx( _
            hMenu, TPM_LEFTALIGN Or TPM_LEFTBUTTON Or TPM_VERTICAL Or TPM_RETURNCMD Or TPM_NONOTIFY, _
            tR.left + 1, tR.top + 1, m_hWnd, tPM)
         'Debug.Print lR
      End If
   End If
   
End Sub

Private Sub picIcon_Paint()
Dim hIcon As Long
Dim tR As RECT
Dim lHDC As Long
   
   lHDC = picIcon.hdc
   If m_hDC <> 0 Then
      GetClientRect UserControl.hwnd, tR
      TileArea lHDC, tR.left, tR.top, tR.right - tR.left, tR.bottom - tR.top, m_hDC, m_lPicWidth, m_lPicHeight, 0, 0
   End If
   
   hIcon = SendMessageLong(m_hWndMdi, WM_GETICON, ICON_SMALL, 0)
   If hIcon = 0 Then
      ' fix thanks to Kevin Tam
      hIcon = SendMessageLong(m_hWndMdi, WM_GETICON, ICON_BIG, 0)
   End If
   ' Debug.Print "HICON", hIcon
   ' ...
   
   DrawIconEx lHDC, 0, 0, hIcon, GetSystemMetrics(SM_CXSMICON), GetSystemMetrics(SM_CYSMICON), ByVal 0&, ByVal 0&, DI_NORMAL

End Sub

Private Sub UserControl_Initialize()
   m_lHOffset = 0
End Sub

Private Sub UserControl_Paint()
Dim ttR As RECT
Dim tR As RECT
Dim lHDC As Long
Dim lhWnd As Long
   If m_hDC <> 0 Then
      lHDC = UserControl.hdc
      lhWnd = UserControl.hwnd
      GetClientRect lhWnd, tR
      LSet ttR = tR
      MapWindowPoints lhWnd, GetParent(lhWnd), ttR, 2
      TileArea lHDC, tR.left, tR.top, tR.right - tR.left, tR.bottom - tR.top, m_hDC, m_lPicWidth, m_lPicHeight, ttR.left, ttR.top
   End If
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
   On Error Resume Next
   m_sCtlName = UserControl.Extender.Name
   Err.Clear
   On Error GoTo 0

   BackColor = PropBag.ReadProperty("BackColor", vbButtonFace)
   BorderStyle = PropBag.ReadProperty("BorderStyle", etbhBorderStyleSingle)
   MDIToolbar = PropBag.ReadProperty("MDIToolbar", False)
   SetProp cmdClose.hwnd, "vbalTBarBtn:Style", &H1000 Or DFCS_CAPTIONCLOSE
   SetProp cmdRestore.hwnd, "vbalTBarBtn:Style", &H1000 Or DFCS_CAPTIONRESTORE
   SetProp cmdMinimize.hwnd, "vbalTBarBtn:Style", &H1000 Or DFCS_CAPTIONMIN
End Sub

Private Sub UserControl_Resize()
   RaiseEvent Resize
End Sub

Private Sub UserControl_Terminate()
   ReleaseCaptures
   ClearPicture
   RemoveProp cmdClose.hwnd, "vbalTBarBtn:Style"
   RemoveProp cmdRestore.hwnd, "vbalTBarBtn:Style"
   RemoveProp cmdMinimize.hwnd, "vbalTBarBtn:Style"
   Set m_cMDIToolbarMenu = Nothing
   debugmsg m_sCtlName & ",cToolbarHost:Terminate"
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
   PropBag.WriteProperty "BackColor", BackColor, vbButtonFace
   PropBag.WriteProperty "BorderStyle", BorderStyle, etbhBorderStyleSingle
   PropBag.WriteProperty "MDIToolbar", MDIToolbar, False
End Sub

