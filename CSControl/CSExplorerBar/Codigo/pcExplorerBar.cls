VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "pcExplorerBar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Declare Function SelectObject Lib "gdi32" (ByVal hdc As Long, ByVal hObject As Long) As Long
Private Declare Function DeleteObject Lib "gdi32" (ByVal hObject As Long) As Long
Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal x As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long

Public ID As Long
Public Title As String
Public ToolTipText As String
Public Key As String
Public Tag As String
Public ItemData As Long
Public TitleBackColorLight As OLE_COLOR
Public TitleBackColorDark As OLE_COLOR
Public PanelBackColor As OLE_COLOR
Public TitleFont As IFont
Public TitleForeColor As OLE_COLOR
Public TitleForeColorOver As OLE_COLOR
Public CanExpand As Boolean
Public State As EExplorerBarStates
Public IsSpecial As Boolean
Public IconIndex As Long

Public TitleHeightWithScroll As Long
Public TitleTextHeightWithScroll As Long
Public SingleLineTitleWithScroll As Boolean
Public TitleHeightWithoutScroll As Long
Public TitleTextHeightWithoutScroll As Long
Public SingleLineTitleWithoutScroll As Boolean
Public HeightWithScroll As Long
Public HeightWithoutScroll As Long
Public Top As Long
Public MouseOver As Boolean
Public MouseDown As Boolean
Public Expanding As Boolean
Public Collapsing As Boolean
Public Alpha As Long
Public CollapseOffset As Long
Public Height As Long

Public HasFocus As Boolean

Private Watermark As pcAlphaDibSection
Public WatermarkHAlign As Long
Public WatermarkVAlign As Long
Public WatermarkMode As Long
Private WatermarkhDIB As Long

' Items is a collection of pcBarItems keyed on ID
' in the order they appear within the bar:
Private m_colItems As Collection
' A collection of the Ids keyed by the Item Key:
Private m_colItemKeys As Collection

Public Function GetWatermarkPicture() As IPicture
   If Not (WatermarkhDIB = 0) Then
      Set GetWatermarkPicture = Watermark.Picture
   End If
End Function

Public Sub RenderWatermark( _
      ByVal outputdc As Long, _
      ByVal workDC As Long, _
      ByVal lLeft As Long, _
      ByVal lTop As Long, _
      ByVal lRight As Long, _
      ByVal lBottom As Long, _
      ByVal lMargin As Long, _
      ByVal lItemSpacing As Long _
   )
Dim x As Long
Dim y As Long
Dim iWidth As Long
Dim iHeight As Long
Dim hBmpOld As Long

   If Not (WatermarkhDIB = 0) Then
      hBmpOld = SelectObject(workDC, WatermarkhDIB)
      
      x = lLeft + lMargin
      y = lTop + lItemSpacing
      iWidth = Watermark.Width
      iHeight = Watermark.Height
      
      If (WatermarkHAlign = eWaterMarkAlignHCentre) Then
         x = ((lRight - lLeft) - iWidth) \ 2
      ElseIf (WatermarkHAlign = eWaterMarkAlignRight) Then
         x = lRight - iWidth
      End If
      If (x < lLeft) Then
         x = lLeft
      End If
      If (x + iWidth > lRight) Then
         iWidth = lRight - x
      End If
      
      If (WatermarkVAlign = eWaterMarkAlignVCentre) Then
         y = ((lBottom - lTop) - iHeight) \ 2
      ElseIf (WatermarkVAlign = eWaterMarkAlignBottom) Then
         y = lBottom - lItemSpacing - iHeight
      End If
      If (Collapsing) Then
         y = y + CollapseOffset
      End If
      If (y + iHeight > lBottom) Then
         iHeight = lBottom - y
      End If
      BitBlt outputdc, x, y, iWidth, iHeight, workDC, 0, 0, vbSrcCopy
      
      SelectObject workDC, hBmpOld
   End If

End Sub

Public Sub ColouriseWatermark(ctl As ExplorerBar)
   If Not (Watermark Is Nothing) Then
      
      If (Not (WatermarkhDIB) = 0) Then
         DeleteObject WatermarkhDIB
      End If
   
      Dim cCopy As New pcAlphaDibSection
      cCopy.Create Watermark.Width, Watermark.Height
      cCopy.LoadPictureBlt Watermark.hdc
   
      If (WatermarkMode = eWaterMarkColourise) Then
         Dim lBackColor As Long
         lBackColor = PanelBackColor
         If (lBackColor = -1) Then
            lBackColor = ctl.DefaultPanelColor(IsSpecial)
         End If
         mColouriseGlyph.ColouriseWatermark cCopy, lBackColor
      End If
   
      WatermarkhDIB = cCopy.ExtractDib
      Set cCopy = Nothing
   
   End If
End Sub

Public Sub SetWatermarkPicture(ctl As ExplorerBar, ipic As IPicture)
      
   If (Not (WatermarkhDIB) = 0) Then
      DeleteObject WatermarkhDIB
   End If
      
   If (ipic Is Nothing) Then
      
      Set Watermark = Nothing
      
   Else
      
      Set Watermark = New pcAlphaDibSection
      
      Watermark.CreateFromPicture ipic
      
      ColouriseWatermark ctl
   
   End If

End Sub

Public Function HasMnemonic(ByVal sMnemonic As String) As Boolean
   HasMnemonic = (InStr(LCase(Title), "&" & LCase(sMnemonic)) > 0)
End Function

Public Property Get ItemCount() As Long
   ItemCount = m_colItems.Count
End Property
Public Property Get ItemIndex(Key As Variant) As Long
Dim i As Long
   If (IsNumeric(Key)) Then
      For i = 1 To ItemCount
         If (i = Key) Then
            ItemIndex = i
            Exit For
         End If
      Next i
   Else
      For i = 1 To ItemCount
         If (m_colItems(i).Key = Key) Then
            ItemIndex = i
            Exit For
         End If
      Next i
   End If
End Property
Public Property Let ItemIndex(Key As Variant, ByVal lIndex As Long)
   '
Dim itmSwap As pcExplorerBarItem
Dim i As Long
Dim lIndexNow As Long
Dim colItemsTmp As New Collection
Dim colItemKeysTmp As New Collection

   If (lIndex < 0) Or (lIndex > m_colItems.Count) Then
      gErr 9, "cExplorerBarItems"
   Else
      lIndexNow = ItemIndex(Key)
      If Not (lIndex = lIndexNow) Then
         If (lIndex > lIndexNow) Then
            ' Moving the item down
            For i = 1 To m_colItems.Count
               If (i < lIndexNow) Then
                  colItemsTmp.Add m_colItems(i), "C:" & m_colItems(i).ID
                  colItemKeysTmp.Add m_colItems(i).ID, m_colItems(i).Key
               ElseIf (i < lIndex) Then
                  colItemsTmp.Add m_colItems(i + 1), "C:" & m_colItems(i + 1).ID
                  colItemKeysTmp.Add m_colItems(i + 1).ID, m_colItems(i + 1).Key
               ElseIf (i = lIndex) Then
                  colItemsTmp.Add m_colItems(lIndexNow), "C:" & m_colItems(lIndexNow).ID
                  colItemKeysTmp.Add m_colItems(lIndexNow).ID, m_colItems(lIndexNow).Key
                  Set itmSwap = m_colItems(lIndexNow)
               Else
                  colItemsTmp.Add m_colItems(i), "C:" & m_colItems(i).ID
                  colItemKeysTmp.Add m_colItems(i).ID, m_colItems(i).Key
               End If
            Next i
            Set m_colItems = colItemsTmp
            Set m_colItemKeys = colItemKeysTmp
         
         Else
            ' Moving the bar up
            For i = 1 To m_colItems.Count
               If (i < lIndex) Then
                  colItemsTmp.Add m_colItems(i), "C:" & m_colItems(i).ID
                  colItemKeysTmp.Add m_colItems(i).ID, m_colItems(i).Key
               ElseIf (i = lIndex) Then
                  colItemsTmp.Add m_colItems(lIndexNow), "C:" & m_colItems(lIndexNow).ID
                  colItemKeysTmp.Add m_colItems(lIndexNow).ID, m_colItems(lIndexNow).Key
                  Set itmSwap = m_colItems(lIndexNow)
               ElseIf (i <= lIndexNow) Then
                  colItemsTmp.Add m_colItems(i + 1), "C:" & m_colItems(i + 1).ID
                  colItemKeysTmp.Add m_colItems(i + 1).ID, m_colItems(i + 1).Key
               Else
                  colItemsTmp.Add m_colItems(i), "C:" & m_colItems(i).ID
                  colItemKeysTmp.Add m_colItems(i).ID, m_colItems(i).Key
               End If
            Next i
            Set m_colItems = colItemsTmp
            Set m_colItemKeys = colItemKeysTmp
            
         End If
      
      End If
   End If
   
   '
End Property
Public Property Get Item(ByVal lIndex As Long) As pcExplorerBarItem
   Set Item = m_colItems(lIndex)
End Property

Public Sub SetHeightFromItems()
Dim itm As pcExplorerBarItem
   
   HeightWithScroll = 12
   HeightWithoutScroll = 12
   
   For Each itm In m_colItems
      HeightWithScroll = HeightWithScroll + itm.HeightWithScroll + itm.SpacingAfter
      HeightWithoutScroll = HeightWithoutScroll + itm.HeightWithoutScroll + itm.SpacingAfter
   Next
   
End Sub

Public Property Get ContainsControl() As Boolean
Dim i As Long
   For i = 1 To ItemCount
      If Not (m_colItems(i).lPtrPanel = 0) Then
         ContainsControl = True
         Exit For
      End If
   Next i
End Property

Public Sub ClearItems()
   Set m_colItems = New Collection
   'Set m_colItemKeys = New Collection
   HeightWithScroll = 0
   HeightWithoutScroll = 0
End Sub
Public Property Get IDForKey(Key As Variant) As Long
Dim vId As Variant
   
   '
   ' If you get an error here, then you're
   ' running the control as code, and you
   ' have to select
   '     Toggle -> Break on Unhandled errors
   '
   vId = m_colItemKeys(Key)
   '
   '
   
   IDForKey = CLng(vId)
   
End Property
Public Sub RemoveItem(ByVal lId As Long)
Dim itm As pcExplorerBarItem
   Set itm = m_colItems.Item("C:" & lId)
   m_colItems.Remove "C:" & lId
   m_colItemKeys.Remove itm.Key
End Sub
Public Sub AddItem(itm As pcExplorerBarItem, ByVal lIndex As Long, Optional Index As Variant)
   If (lIndex > 0) Then
      m_colItems.Add itm, "C:" & itm.ID, Index
      m_colItemKeys.Add itm.ID, itm.Key, Index
   Else
      m_colItems.Add itm, "C:" & itm.ID
      m_colItemKeys.Add itm.ID, itm.Key
   End If
End Sub

Private Sub Class_Initialize()
   
   ' Set defaults:
   IconIndex = -1
   TitleBackColorLight = CLR_NONE
   TitleBackColorDark = CLR_NONE
   PanelBackColor = CLR_NONE
   TitleForeColor = CLR_NONE
   TitleForeColorOver = CLR_NONE
   CanExpand = True
   Randomize Timer
   HeightWithoutScroll = 12
   HeightWithScroll = 12
   TitleHeightWithoutScroll = 24
   TitleHeightWithScroll = 24
   State = eBarExpanded
   Alpha = 255
   WatermarkMode = eWaterMarkColourise
   WatermarkHAlign = eWaterMarkAlignRight
   WatermarkVAlign = eWaterMarkAlignBottom
   Set m_colItems = New Collection
   Set m_colItemKeys = New Collection
   
End Sub

Private Sub Class_Terminate()
   If Not (WatermarkhDIB = 0) Then
      DeleteObject WatermarkhDIB
   End If
   Set Watermark = Nothing
End Sub
