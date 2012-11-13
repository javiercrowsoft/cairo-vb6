VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cExplorerBarItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private m_lID As Long
Private m_lBarId As Long
Private m_hWnd As Long

Friend Sub fInit(ByVal hWnd As Long, ByVal lBarId As Long, ByVal lId As Long)
   m_hWnd = hWnd
   m_lBarId = lBarId
   m_lID = lId
End Sub

Public Property Get ItemType() As EExplorerBarItemTypes
Attribute ItemType.VB_Description = "Gets/sets the type of this item.  The default type is a Link, which can be clicked.  Other types are Text, which is like a link but can't be clicked, and Control place holder, which only displays the control set using the Control property."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      ItemType = itm.ItemType
   End If
End Property
Public Property Let ItemType(ByVal eType As EExplorerBarItemTypes)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      itm.ItemType = eType
      ctl.fBarChanged itm.BarID, False, False
   End If
End Property

Public Property Get IconIndex() As Long
Attribute IconIndex.VB_Description = "Gets/sets the index of the icon to display for this item.  Note icon indexes are 0-based unlike other indexes in this control."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      IconIndex = itm.IconIndex
   End If
End Property
Public Property Let IconIndex(ByVal lIconIndex As Long)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      Dim lIconIndexBefore As Long
      lIconIndexBefore = itm.IconIndex
      Dim bHeightChange As Boolean
      If (lIconIndexBefore = -1) And (lIconIndex > -1) Then
         bHeightChange = True
      ElseIf (lIconIndexBefore > -1) And (lIconIndex = -1) Then
         bHeightChange = True
      End If
      itm.IconIndex = lIconIndex
      ctl.fBarChanged itm.BarID, bHeightChange, False
   End If
End Property
Public Property Get Text() As String
Attribute Text.VB_Description = "Gets/sets the text for this item."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      Text = itm.Text
   End If
End Property
Public Property Let Text(ByVal sText As String)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      If (itm.Text <> sText) Then
         ctl.fTextChanged itm.Text, sText
         itm.Text = sText
         ctl.fBarChanged itm.BarID, True, False
      End If
   End If
End Property
Public Property Get ToolTipText() As String
Attribute ToolTipText.VB_Description = "Gets/sets the tooltip text for this item."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      ToolTipText = itm.ToolTipText
   End If
End Property
Public Property Let ToolTipText(ByVal sToolTipText As String)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      itm.ToolTipText = sToolTipText
   End If
End Property
Public Property Get Font() As IFont
Attribute Font.VB_Description = "Gets/sets the font this item is drawn in. Set to Nothing to use the default font."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      Set Font = itm.Font
   End If
End Property
Public Property Let Font(iFnt As IFont)
   pSetFont iFnt
End Property
Public Property Set Font(iFnt As IFont)
   pSetFont iFnt
End Property
Private Sub pSetFont(iFnt As IFont)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      Set itm.Font = iFnt
      ctl.fBarChanged itm.BarID, True, False
   End If
End Sub
Public Property Get Bold() As Boolean
Attribute Bold.VB_Description = "Gets/sets whether this item is drawn using a bold version of the font or not."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      Bold = itm.Bold
   End If
End Property
Public Property Let Bold(ByVal bState As Boolean)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      If Not (itm.Bold = bState) Then
         itm.Bold = bState
         ctl.fBarChanged itm.BarID, True, False
      End If
   End If
End Property
Public Property Get SpacingAfter() As Long
Attribute SpacingAfter.VB_Description = "Gets/sets the spacing after this item in the control, in pixels.  Defaults to 0."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      SpacingAfter = itm.SpacingAfter
   End If
End Property
Public Property Let SpacingAfter(ByVal lPixels As Long)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      If Not (itm.SpacingAfter = lPixels) Then
         itm.SpacingAfter = lPixels
         ctl.fBarChanged itm.BarID, True, False
      End If
   End If
End Property
Public Property Get Control() As Object
Attribute Control.VB_Description = "Gets/sets the control associated with this item."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      If Not (itm.lPtrPanel = 0) Then
         Set Control = ObjectFromPtr(itm.lPtrPanel)
      End If
   End If
End Property
Public Property Let Control(ctl As Object)
   pSetControl ctl
End Property
Public Property Set Control(ctl As Object)
   pSetControl ctl
End Property
Private Sub pSetControl(ctlItem As Object)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      If (ctlItem Is Nothing) Then
         If Not (itm.lPtrPanel = 0) Then
            On Error Resume Next
            ObjectFromPtr(itm.lPtrPanel).Visible = False
         End If
         itm.lPtrPanel = 0
      Else
         ' 2003-07-05: Is there already something there
         If Not (itm.lPtrPanel = 0) Then
            On Error Resume Next
            ObjectFromPtr(itm.lPtrPanel).Visible = False
         End If
         itm.lPtrPanel = 0
         
         itm.lPtrPanel = ObjPtr(ctlItem)
         If TypeName(ctlItem) = "PictureBox" Then
            Dim pc As pcExplorerBar
            Set pc = ctl.fGetBarInternal(itm.BarID)
            ctlItem.BackColor = ctl.DefaultPanelColor(pc.IsSpecial)
         End If
         ctl.fContainControl ctlItem
         
      End If
      ctl.fBarChanged itm.BarID, True, False
   End If
End Sub
Public Property Get TextColor() As OLE_COLOR
Attribute TextColor.VB_Description = "Gets/sets the colour this item's text is drawn in.  Use -1 for the default colour."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      TextColor = itm.TextColor
   End If
End Property
Public Property Let TextColor(ByVal oColor As OLE_COLOR)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      itm.TextColor = oColor
      ctl.fBarChanged m_lBarId, False, False
   End If
End Property
Public Property Get TextColorOver() As OLE_COLOR
Attribute TextColorOver.VB_Description = "Gets/sets the colour this item's text is drawn in when the mouse is over.  Use -1 for the default colour."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      TextColorOver = itm.TextColorOver
   End If
End Property
Public Property Let TextColorOver(ByVal oColor As OLE_COLOR)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      itm.TextColorOver = oColor
      ctl.fBarChanged m_lBarId, False, False
   End If
End Property
Public Property Get CanClick() As Boolean
Attribute CanClick.VB_Description = "Gets/sets whether this item can be clicked or not."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      CanClick = itm.CanClick
   End If
End Property
Public Property Let CanClick(ByVal bState As Boolean)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      itm.CanClick = bState
   End If
End Property
Public Property Get Key() As String
Attribute Key.VB_Description = "Gets the key for this item."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      Key = itm.Key
   End If
End Property
Public Property Get Tag() As String
Attribute Tag.VB_Description = "Gets/sets a string value associated with this item."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      Tag = itm.Tag
   End If
End Property
Public Property Let Tag(ByVal sTag As String)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      itm.Tag = sTag
   End If
End Property
Public Property Get ItemData() As Long
Attribute ItemData.VB_Description = "Gets/sets a long value associated with this item."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      ItemData = itm.ItemData
   End If
End Property
Public Property Let ItemData(ByVal lItemData As Long)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      itm.ItemData = lItemData
   End If
End Property
Public Property Get Index() As Long
Attribute Index.VB_Description = "Gets/sets the index (order) of this item within its bar."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(itm.BarID)
      Index = pc.ItemIndex(itm.Key)
   End If
End Property
Public Property Let Index(ByVal lIndex As Long)
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(itm.BarID)
      pc.ItemIndex(itm.Key) = lIndex
   End If
End Property
Public Sub EnsureVisible()
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 2)) Then
      Dim itm As pcExplorerBarItem
      Set itm = ctl.fGetItemInternal(m_lID)
      ctl.fEnsureItemVisible itm.BarID, m_lID
   End If
End Sub
