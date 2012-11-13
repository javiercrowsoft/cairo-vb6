VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "pcStoreMenu"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private m_tMI() As tMenuItem
Private m_iMenuCount As Long
Private m_sKey As String
Private m_sFailure As String

Friend Property Get Error() As String
   Error = m_sFailure
End Property

Friend Function Serialise(ByVal iFile As Integer) As Boolean
Dim sHeader As String
Dim tMI As tMenuItem
Dim iItem As Long

On Error GoTo ErrorHandler
   Put #iFile, , "cStoreMenu"
   sHeader = App.Major & ":" & App.Minor & "," & LenB(tMI)
   Put #iFile, , Len(sHeader)
   Put #iFile, , sHeader
   Put #iFile, , Len(m_sKey)
   If Len(m_sKey) > 0 Then
      Put #iFile, , m_sKey
   End If
   Put #iFile, , m_iMenuCount
   For iItem = 1 To m_iMenuCount
      Put #iFile, , m_tMI(iItem)
   Next iItem
   Serialise = True
   Exit Function

ErrorHandler:
   m_sFailure = Err.Description
   Serialise = False
   Exit Function
End Function
Friend Function Deserialise(ByVal iFile As Integer) As Boolean
Dim sInfo As String
Dim iLen As Long
Dim iCount As Long
Dim iItem As Long

On Error GoTo ErrorHandler
   sInfo = Space$(10)
   Get #iFile, , sInfo
   If sInfo = "cStoreMenu" Then
      Get #iFile, , iLen
      sInfo = Space$(iLen)
      Get #iFile, , sInfo
      ' This returns the app version & length of the tMI structure.  In future
      ' versions this will inform us how to read old data streams, for now
      ' we can just read it as this is the first version which supports serialisation
      Get #iFile, , iLen
      If iLen > 0 Then
         sInfo = Space$(iLen)
         Get #iFile, , sInfo
      End If
      Get #iFile, , iCount
      ' Check not stupid...
      If iCount > -1 And iCount < 32767 Then
         m_iMenuCount = iCount
         If iCount = 0 Then
            Erase m_tMI
         Else
            ReDim m_tMI(1 To m_iMenuCount) As tMenuItem
            For iItem = 1 To m_iMenuCount
               Get #iFile, , m_tMI(iItem)
            Next iItem
            Deserialise = True
         End If
         m_sKey = sInfo
      Else
         m_sFailure = "Invalid number of Menu items"
      End If
   Else
      m_sFailure = "Not a cNewMenu data stream"
   End If
   Exit Function

ErrorHandler:
   m_sFailure = Err.Description
   Deserialise = False
   Exit Function
End Function

Friend Property Get Key() As String
   Key = m_sKey
End Property
Friend Property Let Key(ByVal sKey As String)
   m_sKey = sKey
End Property

Friend Sub Store(ByRef tMI() As tMenuItem, ByVal iMenuCount As Long)
Dim iItem As Long
Dim iRealCount As Long
Dim lSeek As Long
Dim lOrigParent As Long
Dim lIdx() As Long
   
   m_iMenuCount = iMenuCount
   If m_iMenuCount > 0 Then
      ReDim Preserve m_tMI(1 To m_iMenuCount) As tMenuItem
      For iItem = 1 To m_iMenuCount
         LSet m_tMI(iItem) = tMI(iItem)
      Next iItem
   Else
      m_iMenuCount = 0
      Erase m_tMI
   End If
   
End Sub
Friend Sub Restore(ByRef cMenu As cPopupMenu)
Dim iItem As Long
Dim iSubItem As Long
Dim iAdded As Long
   With cMenu
      For iItem = 1 To m_iMenuCount
         iAdded = .AddItem(m_tMI(iItem).sInputCaption, m_tMI(iItem).sHelptext, m_tMI(iItem).lItemData, m_tMI(iItem).lParentIndex, m_tMI(iItem).lIconIndex, m_tMI(iItem).bChecked, m_tMI(iItem).bEnabled, m_tMI(iItem).sKey)
         .Header(iAdded) = m_tMI(iItem).bTitle
         .Default(iAdded) = m_tMI(iItem).bDefault
         .OwnerDraw(iAdded) = m_tMI(iItem).bOwnerDraw
         .RadioCheck(iAdded) = m_tMI(iItem).bRadioCheck
         .Visible(iAdded) = m_tMI(iItem).bVisible
         .ItemInfrequentlyUsed(iAdded) = m_tMI(iItem).bInfrequent
         .ShowCheckAndIcon(iAdded) = m_tMI(iItem).bShowCheckAndIcon
         .RedisplayMenuOnClick(iAdded) = m_tMI(iItem).bChevronBehaviour
      Next iItem
   End With
End Sub

