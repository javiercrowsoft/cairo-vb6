VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsScintilla"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Sci As Long
Implements ISubclass
'====================================================================
'====================================================================
' Events which will be called by scintilla's result code
Public Event OnModified()
Public Event StyleNeeded()
Public Event CharAdded()
Public Event SavePointReached()
Public Event SavePointLeft()
Public Event DoubleClick()
Public Event UpdateUI()
Public Event MarginClick()
Public Event Paint()
Public Event UserListSelection()

Private Owner As Form

Public lHighlighterNum As Long  'This is to work with the highlighter module

'====================================================================
'====================================================================
Private Function ISubclass_WindowProc(ByVal hwnd As Long, ByVal iMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
    
    Dim scMsg As SCNotification
    Dim tHdr As NMHDR
    
    Select Case iMsg
      Case WM_NOTIFY
        CopyMemory scMsg, ByVal lParam, Len(scMsg)
        tHdr = scMsg.NotifyHeader
        If (tHdr.hwndFrom = Sci) Then
          'Scintilla has given some information.  Let's see what it is
          'and route it to the proper place.
          ' Any commented with TODO have not been implimented yet.
          Select Case tHdr.code
'            Case SCN_MODIFIED
'              RaiseEvent OnModified
'
'            Case SCN_STYLENEEDED
'              RaiseEvent StyleNeeded
'
'            Case SCN_CHARADDED
'              If bAutoIndent = True Then
'                MaintainIndentation
'              End If
'              If AutoShowAutoComplete Then
'                StartAutoComplete scMsg.ch
'              End If
'              If bShowCallTips Then
'                StartCallTip scMsg.ch
'              End If
'
'              RaiseEvent CharAdded
'            Case SCN_SAVEPOINTREACHED
'              RaiseEvent SavePointReached
'            Case SCN_SAVEPOINTLEFT
'              RaiseEvent SavePointLeft
'            Case SCN_MODIFYATTEMPTRO
'              'TODO
'            Case SCN_DOUBLECLICK
'              RaiseEvent DoubleClick
'            Case SCN_UPDATEUI
'              If m_matchBraces Then
'                  Dim pos As Long, pos2 As Long
'                  pos2 = INVALID_POSITION
'                  If IsBrace(CharAtPos(GetCurPos)) Then
'                      pos2 = GetCurPos
'                  ElseIf IsBrace(CharAtPos(GetCurPos - 1)) Then
'                      pos2 = GetCurPos - 1
'                  End If
'                  If pos2 <> INVALID_POSITION Then
'                      pos = SendMessage(sci, SCI_BRACEMATCH, pos2, CLng(0))
'                      If pos = INVALID_POSITION Then
'                          Call SendEditor(SCI_BRACEBADLIGHT, pos2)
'                      Else
'                          Call SendEditor(SCI_BRACEHIGHLIGHT, pos, pos2)
'                          'If m_IndGuides Then
'                              Call SendEditor(SCI_SETHIGHLIGHTGUIDE, GetColumn)
'                          'End If
'                      End If
'                  Else
'                      Call SendEditor(SCI_BRACEHIGHLIGHT, INVALID_POSITION, INVALID_POSITION)
'                  End If
'              End If
'              RaiseEvent UpdateUI
'            Case SCN_MACRORECORD
'              'TODO
'            Case SCN_MARGINCLICK
'              Dim lLine As Long, lMargin As Long, lPosition As Long
'              lPosition = scMsg.position
'              lLine = SendEditor(SCI_LINEFROMPOSITION, lPosition)
'              lMargin = scMsg.margin
'              If lMargin = MARGIN_SCRIPT_FOLD_INDEX Then
'                Call SendEditor(SCI_TOGGLEFOLD, lLine, 0)
'              End If
'              RaiseEvent MarginClick
'            Case SCN_NEEDSHOWN
'              'TODO
'            Case SCN_PAINTED
'              RaiseEvent Paint
'            Case SCN_USERLISTSELECTION
'              RaiseEvent UserListSelection
'            Case SCN_DWELLSTART
'              'TODO
'            Case SCN_DWELLEND
'              'TODO
          End Select
      End If
    End Select
End Function

Private Property Let ISubclass_MsgResponse(ByVal RHS As EMsgResponse)
End Property

Private Property Get ISubclass_MsgResponse() As EMsgResponse

End Property
  
Public Sub Detach(frm As Long)
  DetachMessage Me, frm, WM_NOTIFY
End Sub
  
Public Sub Attach(frm As Long)
  Detach frm
  AttachMessage Me, frm, WM_NOTIFY
End Sub

Public Sub CreateEditor(frm As Long)

  LoadLibrary ("SciLexer.DLL")
'  If MDIApp = False Then
'    Set Owner = frm
'  Else
'    Set Owner = MDIParent
'  End If
  Sci = CreateWindowEx(WS_EX_CLIENTEDGE, "Scintilla", "SourceEditor", WS_CHILD Or WS_VISIBLE, 0, 0, 200, 200, frm, 0, App.hInstance, 0)
  
  'RemoveHotKeys
  SetFocus
End Sub

Public Sub SizeScintilla(Left As Long, top As Long, width As Long, height As Long)
  SetWindowPos Sci, 0, Left, top, width, height, 0
End Sub

Public Sub SetFocus()
  ' Set focus to the Scintilla handle
  SetFocusAPI Sci
End Sub


'====================================================================
'====================================================================
'====================================================================
'====================================================================


