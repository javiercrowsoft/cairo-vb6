VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSort"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'Updates
''''''''
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'15Aug2004      UMG
'
'Changed all Asc to AscB
'Changed all Params to ByVal
'This gave an overall timing improvement by about 10 percent (tnx to ...)
'
'Modified Property Let Alphabet and Property Let KeyTranslation
'Got rid of some superfluous variables and moved others into the appropriate modules
'Added TranslateKey by Array rather then by ASC(Mid$...
'
'Did a little code cosmetic and added notes and comments
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

'Enumerations
Public Enum SortDirection
    Ascending = 1
    Descending = -1
End Enum

Public Enum PartialKeys
    LessFullKeys = 1
    GreaterFullKeys = 2
    NotAllowed = 3
End Enum

#If False Then
'Preserve Capitalization
Private Ascending, Descending, LessFullKeys, GreaterFullKeys, NotAllowed
#End If

'Event Declarations
Public Event QueryKey(ByVal SortId As Long, ByVal Pointer As Long, ByRef Key As String)
Public Event NextPointer(ByVal SortId As Long, ByVal Pointer As Long, ByRef Cancel As Boolean)
Attribute NextPointer.VB_MemberFlags = "200"

'Property Variables
Private myLowBound          As Long
Private myHighBound         As Long
Private myKeySize           As Long 'the actual keysize is one more
Private myKeyPosition       As Long
Private mySortId            As Long
Private myAlphabet          As String
Private myKeyTranslation    As String
Private myRightToLeft       As Boolean
Private mySortDirection     As SortDirection
Private myPartialKeys       As PartialKeys

'Working Variables
Private Anchor()            As Long
Private Chain()             As Long
Private TranslateKey(1 To 256)      As Long
Private KeyAscB             As Long
Private Idx                 As Long
Private CntUniq             As Long
Private Busy                As Boolean
Private Cancel              As Boolean
Private XlatKey             As Boolean
Private Indirect            As Boolean
Private QueriedKey          As String
Private DummyTable()        As String

Public Property Get Alphabet() As String

    Alphabet = myAlphabet

End Property

Public Property Let Alphabet(ByVal nuAlphabet As String)

  Dim Pos       As Long
  Dim Char      As Long
  Dim HiChar    As String

    CheckBusy
    HiChar = Chr$(255)
    XlatKey = False
    myAlphabet = vbNullString
    myKeyTranslation = vbNullString
    Select Case Len(nuAlphabet)
      Case Is > 256
        ShowError 380, "Sort", "Alphabet is too long."
      Case Is > 0
        myAlphabet = nuAlphabet
        myKeyTranslation = String$(256, HiChar)
        For Pos = 1 To Len(myAlphabet)
            If InStr(Pos + 1, myAlphabet, Mid$(myAlphabet, Pos, 1)) Then
                ShowError 380, "Sort", "Alphabet character '" + Mid$(myAlphabet, Pos, 1) & "' is not unique."
              Else 'NOT INSTR(Pos...
                Mid$(myKeyTranslation, AscB(Mid$(myAlphabet, Pos, 1)) + 1, 1) = Chr$(Char)
                Char = Char + 1
            End If
        Next Pos
        Pos = 0
        Do Until Char > AscB(HiChar)
            Pos = Pos + 1
            If Mid$(myKeyTranslation, Pos, 1) = HiChar Then 'not yet replaced
                Mid$(myKeyTranslation, Pos, 1) = Chr$(Char)
                Char = Char + 1
            End If
        Loop
        XlatKey = True
    End Select

End Property

Private Sub BuildAndOutputChains(Table() As String, ByVal Level As Long, ByVal Start As Long)

  Dim Ptr       As Long 'recursive variables, have to be here
  Dim NextPtr   As Long
  Dim LoKey     As Long
  Dim HiKey     As Long

    If myRightToLeft Then
        Idx = myKeyPosition - Level
      Else 'MYRIGHTTOLEFT = FALSE/0
        Idx = myKeyPosition + Level
    End If
    LoKey = 257
    HiKey = 0
    Ptr = Start 'initial pointer into chain

    'cut and re-link chain(s)
    Do
        'get key value for this level
        KeyAscB = 0 'reset first
        If Indirect Then 'get key from client
            RaiseEvent QueryKey(mySortId, Ptr, QueriedKey)
            If Idx >= 1 And Idx <= Len(QueriedKey) Then
                KeyAscB = AscB(Mid$(QueriedKey, Idx, 1)) + 1
            End If
          Else 'take key from table 'INDIRECT = FALSE/0
            If Idx >= 1 And Idx <= Len(Table(Ptr)) Then
                KeyAscB = AscB(Mid$(Table(Ptr), Idx, 1)) + 1
            End If
        End If
        If KeyAscB Then 'we have a key value (ie the key is long enough to be examined at this level)
            If XlatKey Then 'need translation
                KeyAscB = TranslateKey(KeyAscB)
            End If
          Else 'key is too short 'KEYASCB = FALSE/0
            Select Case myPartialKeys
              Case GreaterFullKeys
                KeyAscB = 257
              Case NotAllowed
                ShowError 5, "Sort", "Incomplete key in element(" & Ptr & ")."
            End Select
        End If

        'save range of keys for this level
        If KeyAscB < LoKey Then
            LoKey = KeyAscB
        End If
        If KeyAscB > HiKey Then
            HiKey = KeyAscB
        End If

        'extend chain on this anchor, the anchor being selected by the recursion level and
        'the sort key byte value of the current element in the table at this level (which
        'in turn corresponds to the byte position within the key)

        NextPtr = Chain(Ptr) 'save pointer to next chain member temporarily

        'put current anchor value in chain - this is either zero when this anchor did not yet
        'point to a chain (this zero now indicating end of chain), or it is the pointer to
        'the previous start of a chain, this pointer now becomes a member of the chain
        Chain(Ptr) = Anchor(Level, KeyAscB)

        'put current pointer into anchor as new pointer to the start of a chain
        Anchor(Level, KeyAscB) = Ptr

        Ptr = NextPtr 'continue with next chain member (pointed to by this chain member)...
    Loop While Ptr '...if any

    If mySortDirection = Descending Then
        'exchange LoKey and HiKey because we will scan the chains in the opposite direction
        LoKey = LoKey Xor HiKey
        HiKey = HiKey Xor LoKey
        LoKey = LoKey Xor HiKey
    End If

    'now that the chains have been re-linked let's have a look at each one of them
    '
    'a  - if there are any chains with one member only then output that member; it has a
    '     unique sort key.
    '
    'b  - chains with more than one member require further examination:
    '
    'b1 - if we are at the end of the key we can safely assume that nothing more will
    '     happen so output all members of those chains; they all have an identical sort key.
    '
    'b2 - if we are not at the end of the key then chains with more than one member
    '     may need to be further subdivided by recursion; call myself pointing to the
    '     start of the chains in question and advance to the next byte in the sort key.
    '
    For NextPtr = LoKey To HiKey Step mySortDirection 'scan chains in saved key range
        Ptr = Anchor(Level, NextPtr)
        If Ptr Then 'the anchor points to a chain start
            Anchor(Level, NextPtr) = 0 'clear this anchor (it may possibly come up again)
            If Chain(Ptr) Then 'there is a chain with at least two members on this anchor
                If Level = myKeySize Then 'all members of the chain have identical keys
                    Do 'so output them one after t'other
                        RaiseEvent NextPointer(mySortId, Ptr, Cancel)
                        Ptr = Chain(Ptr) 'follow chain...
                    Loop While Ptr And Cancel = False '...to it's end
                    CntUniq = CntUniq + 1
                  Else 'keys of chain members may still be different, recursion to next level 'NOT LEVEL...
                    BuildAndOutputChains Table(), Level + 1, Ptr
                End If
              Else 'chain start is chain end, so one member only, key is unique 'CHAIN(PTR) = FALSE/0
                RaiseEvent NextPointer(mySortId, Ptr, Cancel) 'so out with it
                CntUniq = CntUniq + 1
            End If
        End If
        If Cancel Then
            Exit For 'loop varying nextptr
        End If
    Next NextPtr

End Sub

Private Sub CheckBusy()

    If Busy Then
        ShowError 5, "Sort", "You cannot alter properties or perform a sort while a sort is busy."
    End If

End Sub

Private Sub Class_Initialize()

  'set defaults

    myKeySize = 0 'the actual keysize is one more
    myKeyPosition = 1
    mySortDirection = Ascending
    myPartialKeys = NotAllowed
    myRightToLeft = False

End Sub

Public Property Get HighBound() As Long

    HighBound = myHighBound

End Property

Public Property Let HighBound(ByVal nuHighBound As Long)

    CheckBusy
    myHighBound = nuHighBound

End Property

Public Property Get KeyPosition() As Long

    KeyPosition = myKeyPosition

End Property

Public Property Let KeyPosition(ByVal nuKeyPosition As Long)

    CheckBusy
    If nuKeyPosition < 1 Or nuKeyPosition > 65535 Then
        ShowError 380, "Sort", "KeyPosition must be below 64k."
      Else 'NOT NUKEYPOSITION...
        myKeyPosition = nuKeyPosition
    End If

End Property

Public Property Get KeySize() As Long

    KeySize = myKeySize + 1

End Property

Public Property Let KeySize(ByVal nuKeySize As Long)

    CheckBusy
    If nuKeySize < 1 Or nuKeySize > 256 Then
        ShowError 380, "Sort", "KeySize must be from 1 thru 256."
      Else 'NOT NUKEYSIZE...
        myKeySize = nuKeySize - 1
    End If

End Property

Public Property Get KeyTranslation() As String

    KeyTranslation = myKeyTranslation

End Property

Public Property Let KeyTranslation(ByVal nuKeyTranslation As String)

    CheckBusy
    XlatKey = False
    myKeyTranslation = vbNullString
    Select Case Len(nuKeyTranslation)
      Case 256
        myKeyTranslation = nuKeyTranslation
        XlatKey = True
      Case 0
        'do nothing
      Case Else
        ShowError 380, "Sort", "KeyTranslation must be 256 characters long."
    End Select

End Property

Public Property Get LowBound() As Long

    LowBound = myLowBound

End Property

Public Property Let LowBound(ByVal nuLowBound As Long)

    CheckBusy
    myLowBound = nuLowBound

End Property

Public Property Get PartialKeys() As PartialKeys

    PartialKeys = myPartialKeys

End Property

Public Property Let PartialKeys(ByVal nuPartialKeys As PartialKeys)

    CheckBusy
    If nuPartialKeys <> LessFullKeys And nuPartialKeys <> GreaterFullKeys And nuPartialKeys <> NotAllowed Then
        ShowError 380, "Sort", "Value for PartialKeys is incorrect."
      Else 'NOT NUPARTIALKEYS...
        myPartialKeys = nuPartialKeys
    End If

End Property

Public Property Get RightToLeft() As Boolean

    RightToLeft = myRightToLeft

End Property

Public Property Let RightToLeft(ByVal nuRightToLeft As Boolean)

    CheckBusy
    myRightToLeft = CBool(nuRightToLeft)

End Property

Private Sub ShowError(Number As Long, Source As String, Optional Description As String)

  Dim MP As Long

    MP = Screen.MousePointer
    Screen.MousePointer = vbDefault
    If Len(Description) Then
        Err.Raise Number, Source, Description
      Else 'LEN(DESCRIPTION) = FALSE/0
        Err.Raise Number, Source
    End If
    Screen.MousePointer = MP

End Sub

Public Property Get SortDirection() As SortDirection

    SortDirection = mySortDirection

End Property

Public Property Let SortDirection(ByVal nuSortDirection As SortDirection)

    CheckBusy
    If nuSortDirection <> Ascending And nuSortDirection <> Descending Then
        ShowError 380, "Sort", "Value for sort direction is incorrect."
      Else 'NOT NUSORTDIRECTION...
        mySortDirection = nuSortDirection
    End If

End Property

Public Function SortIndirect(Optional ByVal SortId As Long = 0) As Long

    Indirect = True
    SortIndirect = SortIt(DummyTable(), SortId)

End Function

Private Function SortIt(Table() As String, ByVal SortId As Long) As Long

  Dim Reverse   As Boolean

    CheckBusy
    If myLowBound <= myHighBound And Sgn(myLowBound) = Sgn(myHighBound) Then

        'prepare
        Busy = True
        Cancel = False
        CntUniq = 0
        mySortId = SortId
        If XlatKey Then
            'translation array
            For Idx = 1 To 256
                TranslateKey(Idx) = AscB(Mid$(myKeyTranslation, Idx, 1))
            Next Idx
        End If

        'anchor array
        ReDim Anchor(0 To myKeySize, 0 To 257) 'myKeySize is one less than the key length

        'create initial chain

        'there is a positional(!) relationship between the chain members and
        'the elements in the table, however the chain is a linked list with each
        'member pointing to the next in sequence, so therefore we can (later on)
        'indirectly re-arrange the sequence of the elements in the table, by cutting
        'and re-linking the chain(s).
        '
        'the last member in a chain of course does not point to the next and therefore
        'it has a zero indicating end of chain; though the positional relationship
        'to the corresponding element in the table still exists.
        '
        'the array of anchors has pointers that point to the beginning of each chain.

        If myKeySize And 1 Then 'odd keysize
            Reverse = (mySortDirection = Ascending)
          Else 'NOT MYKEYSIZE...
            Reverse = (mySortDirection = Descending)
        End If
        If Reverse Then 'initial links must point downward in order to make the sort stable
            ReDim Chain(myLowBound To myHighBound + 1)
            'build chain
            For Idx = myLowBound To myHighBound
                Chain(Idx + 1) = Idx
            Next Idx
            Idx = myHighBound 'set to start of chain
          Else 'initial links must point upward in order to make the sort stable 'REVERSE = FALSE/0
            ReDim Chain(myLowBound - 1 To myHighBound)
            'build chain
            For Idx = myLowBound To myHighBound
                Chain(Idx - 1) = Idx
            Next Idx
            Idx = myLowBound 'set to start of chain
        End If

        BuildAndOutputChains Table(), 0, Idx 'this is the sort proper

        SortIt = CntUniq
        Erase Anchor, Chain 'release memory
        Busy = False
      Else 'NOT MYLOWBOUND...
        ShowError 17, "Sort", "Illegal sort bounds (" & Format$(myLowBound) & " To " & Format$(myHighBound) & ")."
    End If

End Function

Public Function SortTable(Table() As String, Optional ByVal SortId As Long = 0) As Long

    Indirect = False
    If myLowBound >= LBound(Table) And myHighBound <= UBound(Table) Then
        SortTable = SortIt(Table(), SortId)
      Else 'NOT MYLOWBOUND...
        ShowError 9, "Sort", "Sort bounds (" & myLowBound & " To " & myHighBound & ") outside table bounds."
    End If

End Function

':) Ulli's VB Code Formatter V2.17.4 (2004-Aug-15 13:25) 65 + 412 = 477 Lines
