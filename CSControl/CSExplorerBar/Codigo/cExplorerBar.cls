VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cExplorerBar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_lID As Long
Private m_hWnd As Long

Friend Sub fInit(ByVal hWnd As Long, ByVal lId As Long)
   m_lID = lId
   m_hWnd = hWnd
End Sub

Public Property Get IsSpecial() As Boolean
Attribute IsSpecial.VB_Description = "Gets/sets whether this bar contains 'special' items (i.e. drawn with a dark title bar) or is a standard bar (i.e. drawn with a lighter title bar)."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      IsSpecial = pc.IsSpecial
   End If
End Property
Public Property Let IsSpecial(ByVal bState As Boolean)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.IsSpecial = bState
      ctl.fBarChanged m_lID, False, False
   End If
End Property
Public Property Get WatermarkPicture() As IPicture
Attribute WatermarkPicture.VB_Description = "Not supported in this release."
   '
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      Set WatermarkPicture = pc.GetWatermarkPicture
   End If
   '
End Property
Public Property Set WatermarkPicture(ipic As IPicture)
   '
   pSetWatermarkPicture ipic
   '
End Property
Public Property Let WatermarkPicture(ipic As IPicture)
   '
   pSetWatermarkPicture ipic
   '
End Property
Private Sub pSetWatermarkPicture(ipic As IPicture)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      
      pc.SetWatermarkPicture ctl, ipic
      
   End If
End Sub
Public Property Get WatermarkMode() As EExplorerBarWatermarkModes
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      WatermarkMode = pc.WatermarkMode
   End If
End Property
Public Property Let WatermarkMode(ByVal eMode As EExplorerBarWatermarkModes)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.WatermarkMode = eMode
   End If
End Property
Public Property Get WatermarkHAlign() As EExplorerBarWatermarkHAlign
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      WatermarkHAlign = pc.WatermarkHAlign
   End If
End Property
Public Property Let WatermarkHAlign(ByVal eHAlign As EExplorerBarWatermarkHAlign)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.WatermarkHAlign = eHAlign
      ctl.fBarChanged m_lID, False, True
   End If
End Property
Public Property Get WatermarkVAlign() As EExplorerBarWatermarkVAlign
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      WatermarkVAlign = pc.WatermarkVAlign
   End If
End Property
Public Property Let WatermarkVAlign(ByVal eVAlign As EExplorerBarWatermarkVAlign)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.WatermarkVAlign = eVAlign
      ctl.fBarChanged m_lID, False, True
   End If
End Property

Public Property Get IconIndex() As Long
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      IconIndex = pc.IconIndex
   End If
End Property
Public Property Let IconIndex(ByVal lIconIndex As Long)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.IconIndex = lIconIndex
      ctl.fBarChanged m_lID, True, False
   End If
End Property

Public Property Get Title() As String
Attribute Title.VB_Description = "Gets/sets the title of this bar."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      Title = pc.Title
   End If
End Property
Public Property Let Title(ByVal sTitle As String)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      If (pc.Title <> sTitle) Then
         ctl.fTextChanged pc.Title, sTitle
         pc.Title = sTitle
         ctl.fBarChanged m_lID, True, False
      End If
   End If
End Property
Public Property Get ToolTipText() As String
Attribute ToolTipText.VB_Description = "Gets/sets the tooltip shown when the mouse hovers over this bar's title."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      ToolTipText = pc.ToolTipText
   End If
End Property
Public Property Let ToolTipText(ByVal sToolTipText As String)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.ToolTipText = sToolTipText
   End If
End Property
Public Property Get TitleBackColorLight() As OLE_COLOR
Attribute TitleBackColorLight.VB_Description = "Gets/sets the colour to use at the end of the title of this bar.  Set to -1 to use the default colour.  Has no effect when the control's UseExplorerStyle flag is set."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      TitleBackColorLight = pc.TitleBackColorLight
   End If
End Property
Public Property Let TitleBackColorLight(ByVal oColor As OLE_COLOR)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.TitleBackColorLight = oColor
      ctl.fBarChanged m_lID, False, True
   End If
End Property
Public Property Get TitleBackColorDark() As OLE_COLOR
Attribute TitleBackColorDark.VB_Description = "Gets/sets the colour to use at the start of the title of this bar.  Set to -1 to use the default colour.  Has no effect when the control's UseExplorerStyle flag is set."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      TitleBackColorDark = pc.TitleBackColorDark
   End If
End Property
Public Property Let TitleBackColorDark(ByVal oColor As OLE_COLOR)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.TitleBackColorDark = oColor
      ctl.fBarChanged m_lID, False, True
   End If
End Property
Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_Description = "Gets/sets the background colour for this bar.  Set to -1 for the default colour."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      BackColor = pc.PanelBackColor
   End If
End Property
Public Property Let BackColor(ByVal oColor As OLE_COLOR)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.PanelBackColor = oColor
      ctl.fBarChanged m_lID, False, False
   End If
End Property
Public Property Get TitleFont() As IFont
Attribute TitleFont.VB_Description = "Gets/sets the font used to draw the title of this bar.  Set to Nothing for the default font."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      Set TitleFont = pc.TitleFont
   End If
End Property
Public Property Let TitleFont(iFnt As IFont)
   pSetTitleFont iFnt
End Property
Public Property Set TitleFont(iFnt As IFont)
   pSetTitleFont iFnt
End Property
Private Sub pSetTitleFont(iFnt As IFont)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      Set pc.TitleFont = iFnt
      ctl.fBarChanged m_lID, False, False
   End If
End Sub
Public Property Get TitleForeColor() As OLE_COLOR
Attribute TitleForeColor.VB_Description = "Gets/sets the standard foreground colour of the title of the bar. Set to -1 to use the default colour.  Has no effect when the control's UseExplorerStyle flag is set."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      TitleForeColor = pc.TitleForeColor
   End If
End Property
Public Property Let TitleForeColor(ByVal oColor As OLE_COLOR)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.TitleForeColor = oColor
      ctl.fBarChanged m_lID, False, False
   End If
End Property
Public Property Get TitleForeColorOver() As OLE_COLOR
Attribute TitleForeColorOver.VB_Description = "Gets/sets the foreground colour of the title of the bar when the mouse is hovering over it. Set to -1 to use the default colour.  Has no effect when the control's UseExplorerStyle flag is set."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      TitleForeColorOver = pc.TitleForeColorOver
   End If
End Property
Public Property Let TitleForeColorOver(ByVal oColor As OLE_COLOR)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.TitleForeColorOver = oColor
   End If
End Property
Public Property Get CanExpand() As Boolean
Attribute CanExpand.VB_Description = "Gets/sets whether this bar can be expanded and collapsed by clicking on it.  Default is True."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      CanExpand = pc.CanExpand
   End If
End Property
Public Property Let CanExpand(ByVal bState As Boolean)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.CanExpand = bState
      ctl.fBarChanged m_lID, False, False
   End If
End Property
Public Property Get State() As EExplorerBarStates
Attribute State.VB_Description = "Gets/sets whether this bar is expanded or collapsed."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      State = pc.State
   End If
End Property
Public Property Let State(ByVal eState As EExplorerBarStates)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      If Not (pc.State = eState) Then
         ctl.fExpandBar pc, IIf(eState = eBarCollapsed, -1, 1)
      End If
   End If
End Property
Public Sub EnsureVisible()
Attribute EnsureVisible.VB_Description = "Ensures this bar is visible in the control, scrolling if necessary."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      ctl.fEnsureBarVisible m_lID
   End If
End Sub
Public Property Get Key() As String
Attribute Key.VB_Description = "Gets the Key for this bar."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      Key = pc.Key
   End If
End Property
Public Property Get Tag() As String
Attribute Tag.VB_Description = "Gets/sets a string value associated with this bar."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      Tag = pc.Tag
   End If
End Property
Public Property Let Tag(ByVal sTag As String)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.Tag = sTag
   End If
End Property
Public Property Get ItemData() As Long
Attribute ItemData.VB_Description = "Gets/sets a long value associated with this bar."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      ItemData = pc.ItemData
   End If
End Property
Public Property Let ItemData(ByVal lItemData As Long)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.ItemData = lItemData
   End If
End Property
Public Property Get Index() As Long
Attribute Index.VB_Description = "Gets/sets the index (order) of this bar within the control."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Index = ctl.fBarIndex(m_lID)
   End If
End Property
Public Property Let Index(ByVal lIndex As Long)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      ctl.fBarIndex(m_lID) = lIndex
   End If
End Property
Public Property Get Items() As cExplorerBarItems
Attribute Items.VB_Description = "Gets the collection of Items associated with this bar."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim itms As New cExplorerBarItems
      itms.fInit m_hWnd, m_lID
      Set Items = itms
   End If
End Property

