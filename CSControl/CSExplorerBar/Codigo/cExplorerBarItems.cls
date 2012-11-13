VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cExplorerBarItems"
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

Public Property Get Count() As Long
Attribute Count.VB_Description = "Gets the number of items associated with this bar."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      Count = pc.ItemCount
   End If
End Property
Public Sub Clear()
Attribute Clear.VB_Description = "Clears all items from this bar."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      pc.ClearItems
      ctl.fBarChanged m_lID, True, False
   End If
End Sub
Public Sub Remove(Key As Variant)
Attribute Remove.VB_Description = "Removes the item with the specified index or key."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      ctl.fRemoveItem m_lID, Key
   End If
End Sub
Public Function Add( _
      Optional Index As Variant, _
      Optional Key As Variant, _
      Optional Text As Variant, _
      Optional IconIndex As Variant, _
      Optional ItemType As Variant _
   ) As cExplorerBarItem
Attribute Add.VB_Description = "Adds or inserts a new item to this bar."
Dim ctl As ExplorerBar
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Set Add = ctl.fAddItem(m_lID, Index, Key, Text, IconIndex, ItemType)
   End If
End Function
Public Property Get Item( _
      Key As Variant _
   ) As cExplorerBarItem
Attribute Item.VB_Description = "Gets the Item with the specified index or key."
Attribute Item.VB_UserMemId = 0
Dim ctl As ExplorerBar
Dim lBarId As Long
Dim lItemId As Long
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      lItemId = pc.IDForKey(Key)
      Dim itm As New cExplorerBarItem
      itm.fInit m_hWnd, m_lID, lItemId
      Set Item = itm
   End If
End Property
Public Property Get Exists( _
      Key As Variant _
   ) As Boolean
Dim ctl As ExplorerBar
Dim lBarId As Long
Dim lItemId As Long
   If (Verify(ctl, m_hWnd, m_lID, 1)) Then
      Dim pc As pcExplorerBar
      Set pc = ctl.fGetBarInternal(m_lID)
      On Error Resume Next
      lItemId = pc.IDForKey(Key)
      Exists = (lItemId > 0) And (Err.Number = 0)
      On Error GoTo 0
   End If
End Property


