VERSION 5.00
Begin VB.UserControl Editawy 
   CanGetFocus     =   0   'False
   ClientHeight    =   1545
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   2070
   ForwardFocus    =   -1  'True
   InvisibleAtRuntime=   -1  'True
   Picture         =   "Editawy.ctx":0000
   ScaleHeight     =   824
   ScaleMode       =   0  'User
   ScaleWidth      =   3044.116
   ToolboxBitmap   =   "Editawy.ctx":0404
End
Attribute VB_Name = "Editawy"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'==========================================================
'           Copyright Information
'==========================================================
'Program Name: Mewsoft Editawy
'Program Author   : Elsheshtawy, A. A.
'Home Page        : http://www.mewsoft.com
'Copyrights © 2006 Mewsoft Corporation. All rights reserved.
'==========================================================
'==========================================================
Option Explicit

'====================================================================
Private WithEvents Editor As clsEditor
Attribute Editor.VB_VarHelpID = -1
Private Sci As Long
'====================================================================
'====================================================================
'--------------------------------------------------------------------
Private m_sFileName As String
'--------------------------------------------------------------------
Public Type Styler
    Lexer As Long
    Filter As String
    Name As String
    File As String
    Comment As String
    
    Keywords(7) As String
    
    StyleBack(127) As Long
    StyleFore(127) As Long
    
    StyleFont(127) As String
    StyleSize(127) As Long
    
    StyleBold(127) As Long
    StyleItalic(127) As Long
    StyleUnderline(127) As Long
    
    StyleVisible(127) As Long
    StyleEOLFilled(127) As Long
    StyleCase(127) As Long
        
    StyleCharsSet(127) As Long
    
    StyleName(127) As String
    
    Properties(20) As String
    Tag(20) As String
End Type

Public Type RECT
   Left As Long
   Top As Long
   Right As Long
   Bottom As Long
End Type

Public Type POINTAPI
    X As Long
    Y As Long
End Type

Public Type PageSetupDlg
        lStructSize As Long
        hWndOwner As Long
        hDevMode As Long
        hDevNames As Long
        flags As Long
        ptPaperSize As POINTAPI
        rtMinMargin As RECT
        rtMargin As RECT
        hInstance As Long
        lCustData As Long
        lpfnPageSetupHook As Long
        lpfnPagePaintHook As Long
        lpPageSetupTemplateName As String
        hPageSetupTemplate As Long
End Type

Public Type CharacterRange
    cpMin As Long
    cpMax As Long
End Type

Public Type TextRange
    chrg As CharacterRange
    lpstrText As String 'char *
End Type

Public Type TextToFind
    chrg As CharacterRange
    lpstrText As String 'char *
    chrgText As CharacterRange
End Type

Public Type RangeToFormat
  hdc As Long               ' Actual DC to draw on
  hdcTarget As Long         ' Target DC for determining text formatting
  rc As RECT                ' Region of the DC to draw to (in twips)
  rcPage As RECT            ' Region of the entire DC (page size) (in twips)
  chrg As CharacterRange    ' Range of text to draw (see above declaration)
End Type

Enum EOL                            ' Different end from line
    EolCRLF = 0                     ' CR + LF
    EolCR = 1                       ' CR
    EolLF = 2                       ' LF
End Enum

Enum WhiteSpace                               ' Visualization of invisible characters
    Invisible = 0                  ' They are not seen
    VisibleAlways = 1              ' They are always seen
    VisibleAfterIndent = 2         ' They are seen after the indention
End Enum

Enum SelectionMode
    StreamMode = 1
    RectangleMode = 2
    LinesMode = 3
End Enum

Enum EdgeMode
    EDGE_NONE = 0           'Long lines are not marked. This is the default state.
    EDGE_LINE = 1           'A vertical line is drawn at the column number set by SCI_SETEDGECOLUMN. This works well for monospaced fonts. The line is drawn at a position based on the width of a space character in STYLE_DEFAULT, so it may not work very well if your styles use proportional fonts or if your style have varied font sizes or you use a mixture of bold, italic and normal text. .
    EDGE_BACKGROUND = 2     'The background colour of characters after the column limit is changed to the colour set by SCI_SETEDGECOLOUR. This is recommended for proportional fonts.
End Enum

'Set wrapMode to SC_WRAP_WORD (1) to enable wrapping on word boundaries,
'SC_WRAP_CHAR (2) to enable wrapping between any characters, and to
'SC_WRAP_NONE (0) to disable line wrapping. SC_WRAP_CHAR is preferred to
'SC_WRAP_WORD for Asian languages where there is no white space between words.
Enum WrapMode
    WrapNone = 0        'disable line wrapping
    WrapWord = 1        'wrapping on word boundaries
    WrapChar = 2        'wrapping between any characters
End Enum

Enum PrintColourMode
    Normal = 0
    InvertLight = 1
    BlackOnWhite = 2
    ColourOnWhite = 3
    ColourOnWhiteDefaultBG = 4
End Enum

'Style struct
Public Type Style
    Back As Long
    Fore As Long
    FontName As String
    FontSize As Long
    Bold As Boolean
    Italic As Boolean
    Underline As Boolean
    Visible As Boolean
    eolFiled As Boolean
    Case As CaseMode
End Type

Enum CharSet
   ANSI = 0
   default = 1
   BALTIC = 186
   CHINESEBIG5 = 136
   EASTEUROPE = 238
   GB2312 = 134
   GREEK = 161
   HANGUL = 129
   Mac = 77
   OEM = 255
   RUSSIAN = 204
   SHIFTJIS = 128
   Symbol = 2
   TURKISH = 162
   JOHAB = 130
   HEBREW = 177
   ARABIC = 178
   VIETNAMESE = 163
   THAI = 222
End Enum

Enum CaseMode
    MIXED = 0
    Upper = 1
    Lower = 2
End Enum

Enum LexerCode
    Container = 0
    Nu11 = 1
    PYTHON = 2
    CPP = 3
    HTML = 4
    xml = 5
    PERL = 6
    SQL = 7
    VB = 8
    Properties = 9
    ERRORLIST = 10
    MAKEFILE = 11
    BATCH = 12
    XCODE = 13
    LATEX = 14
    LUA = 15
    DIFF = 16
    CONF = 17
    PASCAL = 18
    AVE = 19
    ADA = 20
    LISP = 21
    RUBY = 22
    EIFFEL = 23
    EIFFELKW = 24
    TCL = 25
    NNCRONTAB = 26
    BULLANT = 27
    VBSCRIPT = 28
    ASP = 29
    PHP = 30
    BAAN = 31
    MATLAB = 32
    SCRIPTOL = 33
    ASM = 34
    CPPNOCASE = 35
    FORTRAN = 36
    F77 = 37
    CSS = 38
    POV = 39
    LOUT = 40
    ESCRIPT = 41
    PS = 42
    NSIS = 43
    MMIXAL = 44
    CLW = 45
    CLWNOCASE = 46
    LOT = 47
    YAML = 48
    TEX = 49
    METAPOST = 50
    POWERBASIC = 51
    FORTH = 52
    ERLANG = 53
    OCTAVE = 54
    MSSQL = 55
    VERILOG = 56
    KIX = 57
    GUI4CLI = 58
    SPECMAN = 59
    AU3 = 60
    APDL = 61
    BASH = 62
    ASN1 = 63
    VHDL = 64
    CAML = 65
    BLITZBASIC = 66
    PUREBASIC = 67
    HASKELL = 68
    PHPSCRIPT = 69
    TADS3 = 70
    REBOL = 71
    SMALLTALK = 72
    FLAGSHIP = 73
    CSOUND = 74
    AUTOMATIC = 1000
End Enum

Enum SearchFlags
    FindNormal = 0
    FindWholeWord = 2        'A match only occurs if the characters before and after are not word characters.
    FindMatchCase = 4        ' A match only occurs with text that matches the case of the search string.
    FindWordStart = &H100000 'A match only occurs if the character before is not a word character.
    FindRegExp = &H200000    'The search string should be interpreted as a regular expression.
    FindPosIX = &H400000     'Treat regular expression in a more POSIX compatible manner by interpreting bare ( and ) for tagged sections rather than \( and \).
End Enum

Enum modificationType
    MOD_INSERTTEXT = &H1 'Text has been inserted into the document. position, length, text, linesAdded
    MOD_DELETETEXT = &H2 'Text has been removed from the document. position, length, text, linesAdded
    MOD_CHANGESTYLE = &H4 'A style change has occurred. position, length
    MOD_CHANGEFOLD = &H8 'A folding change has occurred. line, foldLevelNow, foldLevelPrev
    PERFORMED_USER = &H10 'Information: the operation was done by the user. None
    PERFORMED_UNDO = &H20 'Information: this was the result of an Undo. None
    PERFORMED_REDO = &H40 'Information: this was the result of a Redo. None
    MULTISTEPUNDOREDO = &H80 'This is part of a multi-step Undo or Redo. None
    LASTSTEPINUNDOREDO = &H100 'This is the final step in an Undo or Redo. None
    MOD_CHANGEMARKER = &H200 'One or more markers has changed in a line. line
    MOD_BEFOREINSERT = &H400 'Text is about to be inserted into the document. position, if performed by user then text in cells, length in cells
    MOD_BEFOREDELETE = &H800 'Text is about to be deleted from the document. position, length
    MULTILINEUNDOREDO = &H1000 'This is part of an Undo or Redo with multi-line changes. None
    MODEVENTMASKALL = &H1FFF 'This is a mask for all valid flags. This is the default mask state set by SCI_SETMODEVENTMASK. None
End Enum

'Shell execute
Public Enum WindowState
    START_HIDDEN = 0
    START_NORMAL = 4
    START_MINIMIZED = 2
    START_MAXIMIZED = 3
End Enum


Private lastTotal As Long               ' Temporary storage of the line number

' default Properties
Private Const m_def_LineNumbers = False
Private Const m_def_Language = "Perl"
Private Const m_def_EOL = SC_EOL_CRLF
Private Const m_def_SCWS = SCWS_INVISIBLE
Private Const m_def_SepChar = " "
Private Const m_def_Text = ""

' Properties
Private m_LineNumbers As Boolean        ' To show or to not line numbers and their margin them
Private m_Text As String                ' The text that shows Scintilla
Private m_Language As String            ' The effective language
Private m_EOL As EOL                    ' The end of effective line
Private EOfL As Integer                 ' End of line given back by Scintilla
Private m_SCWS As WhiteSpace                  'Visible spaces or no
Private m_ViewEOL As Boolean            ' Visible end of line or no
Private m_SepChar As String             ' The character of separation for the automatic lists
Private m_MatchBraces As Boolean        ' The parentheses are heightened or no
Private m_bHScrollBar As Boolean         ' Visualization of the horizontal bar of displacement
Private m_bIndGuides As Boolean          ' Visualization of the indentaci?n guides

Private m_bReadOnly As Boolean
Private m_bFolding As Boolean
Private m_SymbolMargin As Boolean
Private m_SelForeColor As OLE_COLOR
Private m_SelBackColor As OLE_COLOR
Private m_DefaultForeColor As OLE_COLOR
Private m_DefaultBackColor As OLE_COLOR
Private m_DefaultFont As StdFont
Private m_strFindNextLastSearch As String
Private m_lCaretForeColor As OLE_COLOR
Private m_lCaretLineBackColor As OLE_COLOR
Private m_bCaretLineVisible As Boolean
Private m_lCaretWidth As Long
Private m_lTabWidth As Long
Private m_lWrapMode As WrapMode
Private m_lEdgeMode As EdgeMode
Private m_lEdgeColumn As Long
Private m_lEdgeColor As OLE_COLOR
Private m_lMarginForeColor As OLE_COLOR
Private m_lMarginBackColor As OLE_COLOR
Private m_lMarkerForeColor As OLE_COLOR
Private m_lMarkerBackColor As OLE_COLOR
Private m_lFoldMarginColor As OLE_COLOR
Private m_lFoldMarginHiColor As OLE_COLOR
Private m_bAutoIndent As Boolean
Private m_lLexer As LexerCode

Private bRegEx As Boolean
Private bWholeWord As Boolean
Private bWrap As Boolean
Private bWordStart As Boolean
Private bCase As Boolean
Private strFind As String
Private bFindEvent As Boolean
Private bFindInRange As Boolean
Private bFindReverse As Boolean

Private bSearchRegEx As Boolean
Private bSearchWholeWord As Boolean
Private bSearchWrap As Boolean
Private bSearchWordStart As Boolean
Private bSearchCase As Boolean
Private strSearchFind As String
Private bSearchEvent As Boolean
Private bSearchInRange As Boolean
Private bSearchReverse As Boolean

Private m_bShowCallTips As Boolean
Private m_sCallTipStrings() As String
Private m_lActiveCallTip As Long
Private m_sCallTipWordCharacters As String
Private m_CallTipBackColor As Long
Private m_CallTipForeColor As Long
Private m_CallTipHltColor As Long

Private CBT As CBTACTIVATESTRUCT
Private hHookKeyboard As Long

Private m_bTerminateProcess As Boolean
Private m_lProcessHandle As Long

Private m_bRecordingMacroNow As Boolean
Private m_lCurrentMacro As Long
Private m_sMacros(0 To 100) As String

Private bMacroLParam(0 To 1000) As Byte

' Events
Public Event CharAdded(Character As String, Word As String)
Public Event Modified(ByVal modificationType As Long, ByVal Position As Long, ByVal length As Long, ByVal linesAdded As Long, ByVal Text As Long, ByVal Line As Long, ByVal foldLevelNow As Long, ByVal foldLevelPrev As Long)
Public Event LastStepUndoRedo()

Public Event UpdateUI(ByVal Line As Long, ByVal Column As Long, ByVal Position As Long, ByVal TotalLines As Long)

Public Event MarginClick(ByVal Modifiers As Long, ByVal Position As Long, ByVal Margin As Long)
Public Event SavePointReached()
Public Event SavePointLeft()
Public Event ModifyAttemptReadonly()
Public Event DoubleClick()
Public Event StyleNeeded(ByVal Position As Long)
Public Event NeedShown()
Public Event Painted()
Public Event DwellStart(ByVal X As Long, ByVal Y As Long)
Public Event DwellEnd(ByVal X As Long, ByVal Y As Long)
Public Event Zoom()
Public Event HotSpotClick(ByVal Position As Long, ByVal Modifiers As Long)
Public Event HotSpotDoubleClick(ByVal Position As Long, ByVal Modifiers As Long)
Public Event CallTipClick(ByVal Position As Long)
Public Event AutoCSelection(ByVal wordStartPosition As Long, ByVal Text As Long)
Public Event UserListSelection(ByVal wordStartPosition As Long, ByVal Text As Long)
Public Event Resize()
Public Event GotTheFocus()
Public Event LostTheFocus()
Public Event EnterTheFocus()
Public Event MacroRecord(ByVal Message As Long, wParam As Long, lParam As Long, strParam As String)

'Public Event GotFocus()
'Public Event LostFocus()

Public Event ProcessOutput(ByVal sText As String, ByVal lBytesRead As Long, ByVal lpExitCode As Long, ByRef Terminate As Boolean)

Event KeyUp(ByVal KeyCode As Long, ByVal Shift As Long)
Event KeyDown(ByVal KeyCode As Long, ByVal Shift As Long)
Event KeyPress(ByVal KeyAscii As Long)
Event MouseMove(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
Event MouseDown(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
Event MouseUp(ByVal Button As Integer, ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
Event DblClick(ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)
Event MouseWheel(ByVal Shift As Integer, ByVal X As Single, ByVal Y As Single)

Event FoundText(ByVal count As Long)
Event ReplacedText(ByVal count As Long)

Event PagePreview(ByVal StartCharPos As Long, ByVal NextCharPos As Long, ByVal PageNum As Long, ByVal Measuring As Boolean, ByRef Cancel As Boolean)
Event PagePrint(ByVal StartCharPos As Long, ByVal NextCharPos As Long, ByVal PageNum As Long, ByRef Cancel As Boolean)

'WARNING! DO NOT REMOVE OR MODIFY THE FOLLOWING COMMENTED LINES!
'MemberInfo=14
Public Sub Initialize()
  
    Dim frm As Object
    
    Set Editor = New clsEditor
    Set frm = UserControl.Parent
    'frm.KeyPreview = False
    Sci = Editor.CreateEditor(frm.hwnd)
    Editor.Attach frm.hwnd
  
    'Notification to choose
    SendEditor SCI_SETMODEVENTMASK, SC_MODEVENTMASKALL
    '----------------------------------------------------------------
    Set m_DefaultFont = New StdFont
    
    LoadDefaults
    LoadDefaultMarkers
    ChangeDefault
End Sub

Private Sub UserControl_Terminate()
  On Error Resume Next
  Dim frm As Object
  Set frm = UserControl.Parent
  Editor.Detach frm.hwnd
  Set Editor = Nothing
End Sub

Private Sub LoadDefaults()

    '------------------------------------------------------
    m_sCallTipWordCharacters = "_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    '------------------------------------------------------

End Sub

Private Sub UserControl_Initialize()
    'Set the default values
    'Initialize
End Sub

'====================================================================
Private Sub UserControl_InitProperties()

    Set UserControl.Font = Ambient.Font
    
    m_Text = m_def_Text
    m_LineNumbers = m_def_LineNumbers
    m_Language = m_def_Language
    m_SCWS = m_def_SCWS
    m_SepChar = m_def_SepChar
    
    m_SelForeColor = &HFFFFFF
    m_SelBackColor = &H800000
    
    m_DefaultForeColor = &H0
    m_DefaultBackColor = &HFFFFFF
    m_lCaretWidth = 1
    
    m_lMarginForeColor = &H0
    m_lMarginBackColor = &HC0C0C0
    
    m_lMarkerForeColor = &HFFFFFF
    m_lMarkerBackColor = &HFF0000
    m_lFoldMarginColor = &HC0C0C0
    m_lFoldMarginHiColor = &HC0C0C0
    m_lCaretLineBackColor = &HCCFFFF
    m_bAutoIndent = True
    m_lEdgeColumn = 120
    m_lLexer = Container
    
    bFindEvent = False
    bSearchEvent = False
        
    m_CallTipBackColor = &HCCFFFF
    m_CallTipForeColor = &H0
    m_CallTipHltColor = &HFF
    
    Set m_DefaultFont = Ambient.Font
    
    m_bRecordingMacroNow = False
    m_lCurrentMacro = 0

    Call ChangeDefault
    '------------------------------------------------------
    
End Sub

' To load values of property from the warehouse
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    
    On Error Resume Next
    
    m_Text = PropBag.ReadProperty("Text", m_def_Text)
    m_LineNumbers = PropBag.ReadProperty("LineNumbers", m_def_LineNumbers)
    m_SymbolMargin = PropBag.ReadProperty("SymbolMargin", True)
    
    m_EOL = PropBag.ReadProperty("EndOfLine", m_def_EOL)
    m_SCWS = PropBag.ReadProperty("WhiteSpcVisible", m_def_EOL)
    m_SepChar = PropBag.ReadProperty("AutoCSeparator", " ")
    m_ViewEOL = PropBag.ReadProperty("EOLVisible", False)
    m_MatchBraces = PropBag.ReadProperty("MatchBraces", False)
    m_bHScrollBar = PropBag.ReadProperty("HScrollBar", False)
    m_bIndGuides = PropBag.ReadProperty("IndGuides", False)
    
    m_bReadOnly = PropBag.ReadProperty("ReadOnly", False)
    m_bFolding = PropBag.ReadProperty("Folding", True)
    
    m_SelForeColor = PropBag.ReadProperty("SelForeColor", &HFFFFFF)
    m_SelBackColor = PropBag.ReadProperty("SelBackColor", &H800000)
    
    m_DefaultForeColor = PropBag.ReadProperty("DefaultForeColor", &H0)
    m_DefaultBackColor = PropBag.ReadProperty("DefaultBackColor", &HFFFFFF)
    
    Set m_DefaultFont = PropBag.ReadProperty("DefaultFont", Ambient.Font)
        
    m_lCaretForeColor = PropBag.ReadProperty("CaretForeColor", &H0)
    m_lCaretLineBackColor = PropBag.ReadProperty("CaretLineBackColor", &HCCFFFF)
    m_bCaretLineVisible = PropBag.ReadProperty("CaretLineVisible", True)
    m_lCaretWidth = PropBag.ReadProperty("CaretWidth", 1)
    m_lTabWidth = PropBag.ReadProperty("TabWidth", 8)
    m_lWrapMode = PropBag.ReadProperty("WrapMode", 0)
    m_lEdgeMode = PropBag.ReadProperty("EdgeMode", 0)
    m_lEdgeColumn = PropBag.ReadProperty("EdgeColumn", 160)
    m_lEdgeColor = PropBag.ReadProperty("EdgeColor", &HC0C0C0)
    m_lMarginForeColor = PropBag.ReadProperty("MarginForeColor", &H0)
    m_lMarginBackColor = PropBag.ReadProperty("MarginBackColor", &HC0C0C0)
    m_lMarkerForeColor = PropBag.ReadProperty("MarkerForeColor", &HFFFFFF)
    m_lMarkerBackColor = PropBag.ReadProperty("MarkerBackColor", &HFF0000)
    m_lFoldMarginColor = PropBag.ReadProperty("FoldMarginColor", &HC0C0C0)
    m_lFoldMarginHiColor = PropBag.ReadProperty("FoldMarginHiColor", &HC0C0C0)
    m_bAutoIndent = PropBag.ReadProperty("AutoIndent", True)
    m_lLexer = PropBag.ReadProperty("Lexer", 0)
    m_CallTipBackColor = PropBag.ReadProperty("CallTipBackColor ", &HCCFFFF)
    m_CallTipForeColor = PropBag.ReadProperty("CallTipForeColor ", &H0)
    m_CallTipHltColor = PropBag.ReadProperty("CallTipForeColor ", &HFF)
                
    Select Case m_EOL
        Case SC_EOL_CRLF
            EOfL = 13
        Case SC_EOL_CR
            EOfL = 13
        Case SC_EOL_LF
            EOfL = 10
    End Select
    
    On Error GoTo 0

    ChangeDefault
    
    'Ambient.UserMode is True when the control is being used at runtime.
    'False means that the control is being used at design time.
    'Debug.Print "UserMode: "; Me.GetUserMode
    
End Sub

' To write values of property in the warehouse
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)

    Call PropBag.WriteProperty("Text", m_Text, m_def_Text)
    Call PropBag.WriteProperty("LineNumbers", m_LineNumbers, m_def_LineNumbers)
    Call PropBag.WriteProperty("SymbolMargin", m_SymbolMargin, True)
    
    Call PropBag.WriteProperty("EndOfLine", m_EOL, m_def_EOL)
    
    Call PropBag.WriteProperty("WhiteSpcVisible", m_SCWS, m_def_SCWS)
    Call PropBag.WriteProperty("EOLVisible", m_ViewEOL, False)
    Call PropBag.WriteProperty("AutoCSeparator", m_SepChar, " ")
    Call PropBag.WriteProperty("MatchBraces", m_MatchBraces, False)
    Call PropBag.WriteProperty("HScrollBar", m_bHScrollBar, False)
    Call PropBag.WriteProperty("IndGuides", m_bIndGuides, False)
    Call PropBag.WriteProperty("ReadOnly", m_bReadOnly, False)
    Call PropBag.WriteProperty("Folding", m_bFolding, True)
    
    Call PropBag.WriteProperty("SelForeColor", m_SelForeColor, &HFFFFFF)
    Call PropBag.WriteProperty("SelBackColor", m_SelBackColor, &H800000)
    
    Call PropBag.WriteProperty("DefaultForeColor", m_DefaultForeColor, &H0)
    Call PropBag.WriteProperty("DefaultBackColor", m_DefaultBackColor, &HFFFFFF)
    
    Call PropBag.WriteProperty("DefaultFont", m_DefaultFont, Ambient.Font)
    Call PropBag.WriteProperty("CaretForeColor", m_lCaretForeColor, &H0)
    Call PropBag.WriteProperty("CaretLineBackColor", m_lCaretLineBackColor, &HCCFFFF)
    Call PropBag.WriteProperty("CaretLineVisible", m_bCaretLineVisible, True)
    Call PropBag.WriteProperty("CaretWidth", m_lCaretWidth, 1)
    Call PropBag.WriteProperty("TabWidth", m_lTabWidth, 8)
    Call PropBag.WriteProperty("WrapMode", m_lWrapMode, 0)
    Call PropBag.WriteProperty("EdgeMode", m_lEdgeMode, 0)
    Call PropBag.WriteProperty("EdgeColumn", m_lEdgeColumn, 160)
    Call PropBag.WriteProperty("EdgeColor", m_lEdgeColor, &HC0C0C0)
    Call PropBag.WriteProperty("MarginForeColor", m_lMarginForeColor, &H0)
    Call PropBag.WriteProperty("MarginBackColor", m_lMarginBackColor, &HC0C0C0)
    Call PropBag.WriteProperty("MarkerForeColor", m_lMarkerForeColor, &HFFFFFF)
    Call PropBag.WriteProperty("MarkerBackColor", m_lMarkerBackColor, &HFF0000)
    Call PropBag.WriteProperty("FoldMarginColor", m_lFoldMarginColor, &HC0C0C0)
    Call PropBag.WriteProperty("FoldMarginHiColor", m_lFoldMarginHiColor, &HC0C0C0)
    Call PropBag.WriteProperty("AutoIndent", m_bAutoIndent, True)
    Call PropBag.WriteProperty("Lexer", m_lLexer, 0)
    Call PropBag.WriteProperty("CallTipBackColor", m_CallTipBackColor, &HCCFFFF)
    Call PropBag.WriteProperty("CallTipForeColor", m_CallTipForeColor, &H0)
    Call PropBag.WriteProperty("CallTipHltColor", m_CallTipHltColor, &HFF)
    
End Sub

' To change the properties of the control
Public Sub ChangeDefault()
    
    Dim X As Long
    
    Me.Text = m_Text
    Me.LineNumbers = m_LineNumbers
    Me.EOLVisible = m_ViewEOL
    Me.WhiteSpaceVisible = m_SCWS
    Me.AutoCSeparator = m_SepChar
    Me.HScrollBar = m_bHScrollBar
    Me.ReadOnly = m_bReadOnly
    Me.SymbolMargin = m_SymbolMargin
    
    Me.Folding = m_bFolding
    
    Me.SetSelFore True, m_SelForeColor
    Me.SetSelBack True, m_SelBackColor
    
    SendEditor SCI_STYLESETFORE, STYLE_DEFAULT, m_DefaultForeColor
    SendEditor SCI_STYLESETBACK, STYLE_DEFAULT, m_DefaultBackColor
    
    If Not m_DefaultFont Is Nothing Then
        SendEditor SCI_STYLESETSIZE, STYLE_DEFAULT, m_DefaultFont.Size
        SendEditor SCI_STYLESETFONT, STYLE_DEFAULT, m_DefaultFont.Name
        SendEditor SCI_STYLESETBOLD, STYLE_DEFAULT, m_DefaultFont.Bold
        SendEditor SCI_STYLESETITALIC, STYLE_DEFAULT, m_DefaultFont.Italic
        SendEditor SCI_STYLESETUNDERLINE, STYLE_DEFAULT, m_DefaultFont.Underline
    End If
    
    SendEditor SCI_SETCARETFORE, MakeColor(m_lCaretForeColor), CLng(0)
    SendEditor SCI_SETCARETLINEBACK, MakeColor(m_lCaretLineBackColor), CLng(0)
    SendEditor SCI_SETCARETLINEVISIBLE, SciBool(m_bCaretLineVisible), CLng(0)
    SendEditor SCI_SETCARETWIDTH, m_lCaretWidth, CLng(0)
    SendEditor SCI_SETTABWIDTH, m_lTabWidth, CLng(0)
        
    SendEditor SCI_SETINDENTATIONGUIDES, SciBool(m_bIndGuides)
    SendEditor SCI_SETWRAPMODE, m_lWrapMode, CLng(0)
    SendEditor SCI_SETEDGEMODE, m_lEdgeMode, CLng(0)
    SendEditor SCI_SETEDGECOLUMN, m_lEdgeColumn, CLng(0)
    SendEditor SCI_SETEDGECOLOUR, m_lEdgeColor, CLng(0)
    
    SendEditor SCI_STYLESETFORE, STYLE_LINENUMBER, m_lMarginForeColor
    SendEditor SCI_STYLESETBACK, STYLE_LINENUMBER, m_lMarginBackColor
    
    For X = 0 To 31
        SendEditor SCI_MARKERSETFORE, X, m_lMarkerForeColor
        SendEditor SCI_MARKERSETBACK, X, m_lMarkerBackColor
    Next X

    SendEditor SCI_SETFOLDMARGINCOLOUR, CLng(1), m_lFoldMarginColor
    SendEditor SCI_SETFOLDMARGINHICOLOUR, CLng(1), m_lFoldMarginHiColor
    
    Me.CallTipBackColor = m_CallTipBackColor
    Me.CallTipForeColor = m_CallTipForeColor
    Me.CallTipHltColor = m_CallTipHltColor
    
    Me.Lexer = m_lLexer

    'Set default mouse dwell time
    SendEditor SCI_SETMOUSEDWELLTIME, 1000, CLng(0)
    
    'Call ChangeDefaultStyle
End Sub

Private Sub UserControl_Resize()
  
  On Error Resume Next
  
  SetWindowPos Sci, 0, 0, 0, UserControl.Width / Screen.TwipsPerPixelX, UserControl.Height / Screen.TwipsPerPixelY, 0
  
  UserControl.Width = 32 * Screen.TwipsPerPixelX
  UserControl.Height = 32 * Screen.TwipsPerPixelY
  
End Sub

Public Sub Resize(lLeft As Long, lTop As Long, lWidth As Long, lHeight As Long)
  'SetWindowPos Sci, 0, lLeft, lTop, lWidth \ Screen.TwipsPerPixelX, lHeight \ Screen.TwipsPerPixelY, 0
  SetWindowPos Sci, 0, lLeft, lTop, lWidth, lHeight, 0
End Sub

'====================================================================
Public Function Message(ByVal Msg As Long, Optional ByVal wParam As Long = 0, Optional ByVal lParam = 0) As Variant
    If VarType(lParam) = vbString Then
        Message = SendMessageString(Sci, Msg, IIf(wParam = 0, CLng(wParam), wParam), CStr(lParam))
    Else
        Message = SendMessage(Sci, Msg, IIf(wParam = 0, CLng(wParam), wParam), IIf(lParam = 0, CLng(lParam), lParam))
    End If
End Function

Public Function SendEditor(ByVal Msg As Long, Optional ByVal wParam As Long = 0, Optional ByVal lParam = 0) As Variant
    If VarType(lParam) = vbString Then
        SendEditor = SendMessageString(Sci, Msg, IIf(wParam = 0, CLng(wParam), wParam), CStr(lParam))
    Else
        SendEditor = SendMessage(Sci, Msg, IIf(wParam = 0, CLng(wParam), wParam), IIf(lParam = 0, CLng(lParam), lParam))
    End If
End Function

Friend Sub RaiseSizeEvent(ByVal wParam As Long, ByVal lParam As Long)
    RaiseEvent Resize
End Sub
'====================================================================
'           Events Manager
'====================================================================
Private Sub Editor_RaiseWindowsEvents(ByVal hwnd As Long, ByVal iMsg As Long, ByVal wParam As Long, ByVal lParam As Long)
    
    'Debug.Print "RaiseWindowsEvents: "; hwnd, iMsg, wParam, lParam
    
    Dim Shift  As Long, X As Long, Y As Long
    Dim Button As Integer
    
    Shift = 0
'    If GetKeyState(vbKeyShift) Then Shift = Shift + vbKeyShift
'    If GetKeyState(vbKeyControl) Then Shift = Shift + vbKeyControl
'    If GetKeyState(vbKeyMenu) Then Shift = Shift + vbKeyMenu
    
    'vbShiftMask 1 SHIFT key bit mask
    'vbCtrlMask 2 CTRL key bit mask
    'vbAltMask 4 ALT key bit mask
    Button = 0
    If (wParam And MK_LBUTTON) = MK_LBUTTON Then
       Button = Button Or vbLeftButton
    End If
    If (wParam And MK_RBUTTON) = MK_RBUTTON Then
       Button = Button Or vbRightButton
    End If
    If (wParam And MK_MBUTTON) = MK_MBUTTON Then
       Button = Button Or vbMiddleButton
    End If
    If (wParam And MK_CONTROL) = MK_CONTROL Then
       Shift = Shift Or vbCtrlMask
    End If
    If (wParam And MK_SHIFT) = MK_SHIFT Then
       Shift = Shift Or vbShiftMask
    End If
    X = lParam And &HFFFF&
    Y = lParam \ &H10000
    
    Select Case iMsg
        Case WM_CHAR:
            RaiseEvent KeyPress(wParam)
            
        Case WM_KEYDOWN:
            'vbKeyShift 16 SHIFT key
            'vbKeyControl 17 CTRL key
            'vbKeyMenu 18 MENU key
            RaiseEvent KeyDown(wParam, Shift)
            
        Case WM_KEYUP:
            RaiseEvent KeyUp(wParam, Shift)
        
        Case WM_MOUSEMOVE:
            'lParam
            'The low-order word specifies the x-coordinate of the cursor. The coordinate is relative to the upper-left corner of the client area.
            'The high-order word specifies the y-coordinate of the cursor. The coordinate is relative to the upper-left corner of the client area.
            RaiseEvent MouseMove(Button, Shift, X, Y)
            
        Case WM_LBUTTONDOWN, WM_RBUTTONDOWN, WM_MBUTTONDOWN:
            RaiseEvent MouseDown(Button, Shift, X, Y)
            
        Case WM_LBUTTONUP, WM_RBUTTONUP, WM_MBUTTONUP:
            RaiseEvent MouseUp(Button, Shift, X, Y)
            
        Case WM_LBUTTONDBLCLK, WM_RBUTTONDBLCLK, WM_MBUTTONDBLCLK:
            RaiseEvent DblClick(Shift, X, Y)
            
        Case WM_MOUSEWHEEL:
            RaiseEvent MouseWheel(Shift, X, Y)
        
        Case SCEN_SETFOCUS:
            Debug.Print "SCEN_SETFOCUS"
        
        Case WM_SETFOCUS:
            RaiseEvent GotTheFocus
        
        Case SCEN_KILLFOCUS:
            Debug.Print "SCEN_KILLFOCUS"
            
        Case WM_KILLFOCUS:
            RaiseEvent LostTheFocus
        
'        Case &H2000000:
'            RaiseEvent GotTheFocus
'            'SetFocus UserControl.hwnd
'
'        Case &H1000000:
'            RaiseEvent LostTheFocus
        
    End Select
    
End Sub

Private Sub Editor_RaiseEvents(ByVal hwnd As Long, ByVal iMsg As Long, ByVal wParam As Long, ByVal lParam As Long)
    
    'Debug.Print "Editor_RaiseEvents: "; lParam
    
    Select Case iMsg
        Case WM_NOTIFY:

            Dim Notif As SCNotification
            Call CopyMemory(Notif, ByVal lParam, Len(Notif))
            
            'Debug.Print "Notif.NotifyHeader.code: "; Notif.NotifyHeader.code
            'Debug.Print "Notif.NotifyHeader.idFrom: "; Hex$(Notif.NotifyHeader.hwndFrom)
            
            Select Case Notif.NotifyHeader.code
                
                Case SCN_STYLENEEDED:
                    RaiseEvent StyleNeeded(Notif.Position)
                
                Case SCN_CHARADDED:
                    'This is sent when the user types an ordinary text character (as opposed to a command character) that is entered into the text.
                    If m_bAutoIndent = True And (Notif.ch = 13 Or Notif.ch = 10) Then
                        AutoIndentation
                    End If
                    
                    If m_bShowCallTips Then
                        StartCallTip Notif.ch
                    End If
                    'Debug.Print "Notif.ch: "; Notif.ch
                    RaiseEvent CharAdded(Chr(Notif.ch), GetWord())
                    
                Case SCN_SAVEPOINTREACHED:
                    'Sent to the container when the save point is entered or left, allowing the container to display a "document dirty" indicator and change its menus.
                    RaiseEvent SavePointReached
                
                Case SCN_SAVEPOINTLEFT:
                    RaiseEvent SavePointLeft
                
                Case SCN_MODIFYATTEMPTRO:
                    'When in read-only mode, this notification is sent to the container if the user tries to change the text.
                    RaiseEvent ModifyAttemptReadonly
                
                Case SCN_DOUBLECLICK:
                    'The mouse button was double clicked in editor. There is no additional information.
                    RaiseEvent DoubleClick
                
                Case SCN_UPDATEUI:
                    'Debug.Print "&H"; Hex(Notif.modifiers)
                    
                    'Either the text or styling of the document has changed or the selection range has changed.
                    If m_MatchBraces Then
                                Dim Pos As Long, Pos2 As Long
                                Pos2 = INVALID_POSITION
                                ' We watched the present position
                                If IsBrace(CharAtPos(Me.GetCurrentPos)) Then
                                    Pos2 = Me.GetCurrentPos
                                ' And also the previous one
                                ElseIf IsBrace(CharAtPos(Me.GetCurrentPos - 1)) Then
                                    Pos2 = Me.GetCurrentPos - 1
                                End If
                                If Pos2 <> INVALID_POSITION Then
                                    Pos = SendMessage(Sci, SCI_BRACEMATCH, Pos2, CLng(0))
                                    If Pos = INVALID_POSITION Then
                                        'There is no corresponding parenthesis
                                        Call Message(SCI_BRACEBADLIGHT, Pos2)
                                    Else
                                        ' We heightened the corresponding parenthesis
                                        SendEditor SCI_BRACEHIGHLIGHT, Pos, Pos2
                                        'Also the guide if it is necessary
                                        If m_bIndGuides Then
                                            SendEditor SCI_SETHIGHLIGHTGUIDE, Me.Column
                                        End If
                                    End If
                                Else
                                    ' This acquittal any enhancement of parenthesis
                                    SendEditor SCI_BRACEHIGHLIGHT, INVALID_POSITION, INVALID_POSITION
                                End If
                    End If 'If m_MatchBraces Then
                    
                    ' We changed the wide one of the margin of numbers if it is necessary
                    'If (Len(CStr(lastTotal)) <> Len(CStr(Me.TotalLines))) And m_LineNumbers Then
                        'AdjustLineNumberMarginWidth 0
                    'End If
                    
                    lastTotal = Me.TotalLines
                    
                    RaiseEvent UpdateUI(Me.GetCurrentLineNumber, Me.Column + 1, Me.GetCurrentPos, Me.TotalLines)
                    
                Case SCN_MODIFIED:
                    'int position, int modificationType, string text, int length, int linesAdded, int line, int foldLevelNow, int foldLevelPrev
                    RaiseEvent Modified(Notif.modificationType, _
                                Notif.Position, Notif.length, Notif.linesAdded, _
                                Notif.Text, Notif.Line, Notif.foldLevelNow, _
                                Notif.foldLevelPrev)
                    
                    If (Notif.modificationType And SC_LASTSTEPINUNDOREDO) = SC_LASTSTEPINUNDOREDO Then
                        RaiseEvent LastStepUndoRedo
                    End If
                    'Set the line numbers margin width
                    If (Len(CStr(lastTotal)) <> Len(CStr(Me.TotalLines))) And m_LineNumbers Then
                        AdjustLineNumberMarginWidth 0
                    End If
                    lastTotal = Me.TotalLines
                        
                    If ((Notif.modificationType And SC_MOD_CHANGEFOLD) <> 0) Then
                        FoldChanged Notif.Line, Notif.foldLevelNow, Notif.foldLevelPrev
                    End If
                            
                Case SCEN_CHANGE:
                    'SCEN_CHANGE (768) is fired when the text (not the style) of the document changes.
                    'Debug.Print "SCEN_CHANGE"
                    
                Case SCN_MACRORECORD:
                    RecordMacroCommand Notif.Message, Notif.wParam, Notif.lParam
                    
                Case SCN_MARGINCLICK:
                    MarginClicked Notif.Position, Notif.Modifiers, Notif.Margin
                
                Case SCN_NEEDSHOWN:
                    'Scintilla has determined that a range of lines that is currently invisible should be made visible.
                    RaiseEvent NeedShown
                    
                Case SCN_PAINTED:
                    'Painting has just been done.
                    RaiseEvent Painted
                    
                Case SCN_USERLISTSELECTION:
                    'The user has selected an item in a user list. The SCNotification fields used are:
                    'Field Usage
                    'wParam This is set to the listType parameter from the SCI_USERLISTSHOW message that initiated the list.
                    'text The text of the selection.
                    RaiseEvent UserListSelection(Notif.lParam, Notif.Text)
                    
                Case SCN_DWELLSTART:
                    'SCN_DWELLSTART is generated when the user keeps the mouse in one position for the dwell period (see SCI_SETMOUSEDWELLTIME). SCN_DWELLEND is generated after a SCN_DWELLSTART and the mouse is moved or other activity such as key press indicates the dwell is over. Both notifications set the same fields in SCNotification:
                    'Field Usage
                    'position This is the nearest position in the document to the position where the mouse pointer was lingering.
                    'x, y Where the pointer lingered. The position field is set to SCI_POSITIONFROMPOINTCLOSE(x, y).
                    RaiseEvent DwellStart(Notif.X, Notif.Y)
                    
                Case SCN_DWELLEND:
                    RaiseEvent DwellEnd(Notif.X, Notif.Y)
                    'SendEditor SCI_CALLTIPCANCEL, 0, 0
                
                Case SCN_ZOOM:
                    'This notification is generated when the user zooms the display using the keyboard or the SCI_SETZOOM method is called. This notification can be used to recalculate positions, such as the width of the line number margin to maintain sizes in terms of characters rather than pixels. SCNotification has no additional information.
                    
                    'Set the line numbers margin width
                    If m_LineNumbers Then
                        AdjustLineNumberMarginWidth 0
                    End If
                    
                    RaiseEvent Zoom
                    
                Case SCN_KEY:
                    Debug.Print "SCN_KEY"
                
                Case SCN_HOTSPOTCLICK:
                    'These notifications are generated when the user clicks or double clicks on text that is in a style with the hotspot attribute set. This notification can be used to link to variable definitions or web pages. The position field is set the text position of the click or double click and the modifiers field set to the key modifiers held down in a similar manner to SCN_KEY.
                    RaiseEvent HotSpotClick(Notif.Position, Notif.Modifiers)
                
                Case SCN_HOTSPOTDOUBLECLICK:
                    RaiseEvent HotSpotDoubleClick(Notif.Position, Notif.Modifiers)
                    
                Case SCN_CALLTIPCLICK:
                    'This notification is generated when the user clicks on a calltip. This notification can be used to display the next function prototype when a function name is overloaded with different arguments. The position field is set to 1 if the click is in an up arrow, 2 if in a down arrow, and 0 if elsewhere.
                    RaiseEvent CallTipClick(Notif.Position)
        
                Case SCN_AUTOCSELECTION:
                    'The user has selected an item in an autocompletion list. The notification is sent before the selection is inserted. Automatic insertion can be cancelled by sending a SCI_AUTOCCANCEL message before returning from the notification. The SCNotification fields used are:
                    'Field Usage
                    'lParam The start position of the word being completed.
                    'text The text of the selection.
                    RaiseEvent AutoCSelection(Notif.lParam, Notif.Text)
                
            End Select
            '========================================================
        'Case WM_COMMAND:
            'Debug.Print ": &H"; Hex(lParam)
            'If lParam = SciHandle Then
         '  RaiseFocusEvent wParam, lParam
            '========================================================
    Case Else:
            'Debug.Print "else"
            '========================================================
    End Select
    
End Sub

'====================================================================
'               Macro Recording and Playing
'====================================================================
Private Sub RecordMacroCommand(Message As Long, wParam As Long, lParam As Long)
    
    Dim strPar As String
    If lParam <> 0 Then
        'The lparam is the pointer to the character typed, so you need to store a copy of the character pointed to
        'CopyMemory ByVal StrPtr(lPar), ByVal lParam, 60
        CopyMemory ByVal VarPtr(bMacroLParam(0)), ByVal lParam, 60
        strPar = Byte2Str(bMacroLParam())
        strPar = TrimNull(strPar)
        'lPar = StrConv(lPar, vbFromUnicode)
    Else
        strPar = ""
    End If
    
    If m_bRecordingMacroNow = True Then
        If m_sMacros(m_lCurrentMacro) = "" Then
            m_sMacros(m_lCurrentMacro) = Message & ":" & wParam & ":" & strPar
        Else
            m_sMacros(m_lCurrentMacro) = m_sMacros(m_lCurrentMacro) & "|" & Message & ":" & wParam & ":" & strPar
        End If
    End If
    
    RaiseEvent MacroRecord(Message, wParam, lParam, strPar)
End Sub

Public Function RecordMacro(ByVal macroNumber As Long) As Boolean
    
    If macroNumber < 0 Or macroNumber > 100 Then
        RecordMacro = False
        Exit Function
    End If
    
    Me.StopRecord
    m_lCurrentMacro = macroNumber
    Me.StartRecord
    m_bRecordingMacroNow = True
    
    RecordMacro = True
End Function

Public Function PlayMacro(ByVal macroNumber As Long) As Boolean

    If macroNumber < 0 Or macroNumber > 100 Then
        PlayMacro = False
        Exit Function
    End If

    If m_sMacros(macroNumber) = "" Then
        PlayMacro = False
        Exit Function
    End If
    
    Dim Cmds() As String, Msgs() As String, Macro As Long
    
    Cmds = Split(m_sMacros(macroNumber), "|")
    
    For Macro = LBound(Cmds) To UBound(Cmds)
        If Cmds(Macro) <> "" Then
            Msgs = Split(Cmds(Macro), ":")
            If UBound(Msgs) >= 2 Then
                SendEditor Msgs(0), Msgs(1), Msgs(2)
            End If
        End If
    Next Macro
    
    PlayMacro = True
End Function

Public Sub ClearMacro(ByVal macroNumber As Long)
    If macroNumber < 0 Or macroNumber > 100 Then
        Exit Sub
    End If

    m_sMacros(macroNumber) = ""
End Sub

Public Sub ClearAllMacros()
    Dim X As Long
    For X = LBound(m_sMacros) To UBound(m_sMacros)
        m_sMacros(X) = ""
    Next X
End Sub

Public Function GetMacro(ByVal macroNumber As Long) As String
    GetMacro = m_sMacros(macroNumber)
End Function

Public Function IsMacro(ByVal macroNumber As Long) As Boolean
    IsMacro = m_sMacros(macroNumber) <> ""
End Function

'====================================================================
'               Macro recording
'====================================================================
'Macro recording
'Start and stop macro recording mode. In macro recording mode, actions are reported to the container through SCN_MACRORECORD notifications. It is then up to the container to record these actions for future replay.
'
'SCI_STARTRECORD
'SCI_STOPRECORD
'These two messages turn macro recording on and off.
Public Sub StartRecord()
    SendEditor SCI_STARTRECORD, CLng(0), CLng(0)
End Sub

Public Sub StopRecord()
    SendEditor SCI_STOPRECORD, CLng(0), CLng(0)
    m_bRecordingMacroNow = False
End Sub

'====================================================================

'====================================================================
'====================================================================
Public Sub FoldChanged(Line As Long, levelNow As Long, levelPrev As Long)
    
    'SC_FOLDLEVELHEADERFLAG=&H2000
    If (levelNow And SC_FOLDLEVELHEADERFLAG) = SC_FOLDLEVELHEADERFLAG Then
        If (Not ((levelPrev And SC_FOLDLEVELHEADERFLAG) = SC_FOLDLEVELHEADERFLAG)) Then
            SendEditor SCI_SETFOLDEXPANDED, Line, 1
        End If
    ElseIf (levelPrev And SC_FOLDLEVELHEADERFLAG) = SC_FOLDLEVELHEADERFLAG Then
        If (Not MakeBool(SendEditor(SCI_GETFOLDEXPANDED, Line))) Then
            'Removing the fold from one that has been contracted so should expand
            'otherwise lines are left invisible with no way to make them visible
            Expand Line, True, False, 0, levelPrev
        End If
    End If
End Sub

Public Sub Expand(ByRef Line As Long, doExpand As Boolean, force As Boolean, visLevels As Long, level As Long)
    
    Dim lineMaxSubord As Long
    Dim levelLine As Long
    
    lineMaxSubord = SendEditor(SCI_GETLASTCHILD, Line, (level And SC_FOLDLEVELNUMBERMASK))
    Line = Line + 1
    
    While (Line <= lineMaxSubord)
        If force Then
            If (visLevels > 0) Then
                SendEditor SCI_SHOWLINES, Line, Line
            Else
                SendEditor SCI_HIDELINES, Line, Line
            End If
         Else
            If (doExpand) Then
                SendEditor SCI_SHOWLINES, Line, Line
            End If
        End If
        
        levelLine = level
        
        If (levelLine = -1) Then
            levelLine = SendEditor(SCI_GETFOLDLEVEL, Line)
        End If
        
        If (levelLine And SC_FOLDLEVELHEADERFLAG) = SC_FOLDLEVELHEADERFLAG Then
            If (force) Then
                If (visLevels > 1) Then
                    SendEditor SCI_SETFOLDEXPANDED, Line, 1
                Else
                    SendEditor SCI_SETFOLDEXPANDED, Line, 0
                End If
                'Expand(line , doExpand , force , visLevels , level )
                Expand Line, doExpand, force, visLevels - 1, level
            Else
                If (doExpand) Then
                    If (Not MakeBool(SendEditor(SCI_GETFOLDEXPANDED, Line))) Then
                        SendEditor SCI_SETFOLDEXPANDED, Line, 1
                    End If
                    Expand Line, True, force, visLevels - 1, level
                Else
                    Expand Line, False, force, visLevels - 1, level
                End If
            End If ' force
         Else
            Line = Line + 1
        End If
    Wend

End Sub

Public Sub ExpandAll()

    Dim maxLine As Long
    Dim Expanding As Boolean
    Dim lineSeek As Long
    Dim Line  As Long
    Dim level  As Long
    Dim lineMaxSubord  As Long
    
    SendEditor SCI_COLOURISE, 0, -1
    maxLine = SendEditor(SCI_GETLINECOUNT)
    Expanding = True
   
    For Line = 0 To maxLine
        level = SendEditor(SCI_GETFOLDLEVEL, Line)
        If ((level And SC_FOLDLEVELHEADERFLAG) = SC_FOLDLEVELHEADERFLAG And _
                (SC_FOLDLEVELBASE = (level And SC_FOLDLEVELNUMBERMASK))) Then
            If (Expanding) Then
                SendEditor SCI_SETFOLDEXPANDED, Line, 1
                Expand Line, True, False, 0, level
                Line = Line - 1
            Else
                lineMaxSubord = SendEditor(SCI_GETLASTCHILD, Line, -1)
                SendEditor SCI_SETFOLDEXPANDED, Line, 0
                If (lineMaxSubord > Line) Then
                    SendEditor SCI_HIDELINES, Line + 1, lineMaxSubord
                End If
            End If
        End If
    Next Line
    
End Sub

Public Sub CollapseAll()

    Dim maxLine As Long
    Dim Expanding As Boolean
    Dim lineSeek As Long
    Dim Line  As Long
    Dim level  As Long
    Dim lineMaxSubord  As Long
    
    SendEditor SCI_COLOURISE, 0, -1
    maxLine = SendEditor(SCI_GETLINECOUNT)
    Expanding = False
    
    For Line = 0 To maxLine
        level = SendEditor(SCI_GETFOLDLEVEL, Line)
        If ((level And SC_FOLDLEVELHEADERFLAG) = SC_FOLDLEVELHEADERFLAG And _
                (SC_FOLDLEVELBASE = (level And SC_FOLDLEVELNUMBERMASK))) Then
            If (Expanding) Then
                SendEditor SCI_SETFOLDEXPANDED, Line, 1
                Expand Line, True, False, 0, level
                Line = Line - 1
            Else
                lineMaxSubord = SendEditor(SCI_GETLASTCHILD, Line, -1)
                SendEditor SCI_SETFOLDEXPANDED, Line, 0
                If (lineMaxSubord > Line) Then
                    SendEditor SCI_HIDELINES, Line + 1, lineMaxSubord
                End If
            End If
        End If
    Next Line
    
End Sub

Public Sub FoldAll()

    Dim maxLine As Long
    Dim Expanding As Boolean
    Dim lineSeek As Long
    Dim Line  As Long
    Dim level  As Long
    Dim lineMaxSubord  As Long
    
    SendEditor SCI_COLOURISE, 0, -1
    maxLine = SendEditor(SCI_GETLINECOUNT)
    Expanding = True
    
    For lineSeek = 0 To maxLine
        If (SendEditor(SCI_GETFOLDLEVEL, lineSeek) And SC_FOLDLEVELHEADERFLAG) Then
            Expanding = Not (MakeBool(SendEditor(SCI_GETFOLDEXPANDED, lineSeek)))
            Exit For
        End If
    Next lineSeek
    
    For Line = 0 To maxLine
        level = SendEditor(SCI_GETFOLDLEVEL, Line)
        If ((level And SC_FOLDLEVELHEADERFLAG) = SC_FOLDLEVELHEADERFLAG And _
                (SC_FOLDLEVELBASE = (level And SC_FOLDLEVELNUMBERMASK))) Then
            If (Expanding) Then
                SendEditor SCI_SETFOLDEXPANDED, Line, 1
                Expand Line, True, False, 0, level
                Line = Line - 1
            Else
                lineMaxSubord = SendEditor(SCI_GETLASTCHILD, Line, -1)
                SendEditor SCI_SETFOLDEXPANDED, Line, 0
                If (lineMaxSubord > Line) Then
                    SendEditor SCI_HIDELINES, Line + 1, lineMaxSubord
                End If
            End If
        End If
    Next Line
    
End Sub

Public Sub GotoLineEnsureVisible(Line As Long)
    SendEditor SCI_ENSUREVISIBLEENFORCEPOLICY, Line
    SendEditor SCI_GOTOLINE, Line
End Sub

Public Sub EnsureRangeVisible(ByVal posStart As Long, ByVal posEnd As Long, ByVal enforcePolicy As Boolean)
    
    Dim lineStart As Long, lineEnd As Long
    Dim lLine As Long
    
    lineStart = SendEditor(SCI_LINEFROMPOSITION, Min(posStart, posEnd))
    lineEnd = SendEditor(SCI_LINEFROMPOSITION, Max(posStart, posEnd))
    
    For lLine = lineStart To lineEnd
        If enforcePolicy = True Then
            SendEditor SCI_ENSUREVISIBLEENFORCEPOLICY, lLine, CLng(0)
        Else
            SendEditor SCI_ENSUREVISIBLE, lLine, CLng(0)
        End If
    Next lLine
End Sub

Public Sub MarginClicked(Position As Long, Modifiers As Long, Margin As Long)
    
    Dim lineClick As Long
    Dim levelClick As Long
    
    lineClick = SendEditor(SCI_LINEFROMPOSITION, Position)
        
    'Shift+Ctrl
    If ((Modifiers And SCMOD_SHIFT) = SCMOD_SHIFT And (Modifiers And SCMOD_CTRL) = SCMOD_CTRL) Then
        FoldAll
    Else
        levelClick = SendEditor(SCI_GETFOLDLEVEL, lineClick)
        If (levelClick And SC_FOLDLEVELHEADERFLAG) = SC_FOLDLEVELHEADERFLAG Then
            If (Modifiers And SCMOD_SHIFT) Then
                EnsureAllChildrenVisible lineClick, levelClick
            ElseIf (Modifiers And SCMOD_CTRL) = SCMOD_CTRL Then
                ToggleFoldRecursive lineClick, levelClick
            Else
                'Toggle this line
                SendEditor SCI_TOGGLEFOLD, lineClick
            End If
        End If
    End If

    RaiseEvent MarginClick(Modifiers, Position, Margin)
    'Call SetFocus
End Sub

Public Sub ToggleFoldRecursive(Line As Long, level As Long)
    If MakeBool(SendEditor(SCI_GETFOLDEXPANDED, Line)) Then
        'Contract this line and all children
        SendEditor SCI_SETFOLDEXPANDED, Line, 0
        Expand Line, False, True, 0, level
    Else
        'Expand this line and all children
        SendEditor SCI_SETFOLDEXPANDED, Line, 1
        Expand Line, True, True, 100, level
    End If
End Sub

Public Sub ToggleFoldRecursively()
    Dim Line As Long
    Dim level As Long
    Line = SendEditor(SCI_LINEFROMPOSITION, Me.GetCurrentPos, CLng(0))
    level = SendEditor(SCI_GETFOLDLEVEL, Line, CLng(0))
    ToggleFoldRecursive Line, level
End Sub

Public Sub ExpanedEnsureChildrenVisible()
    Dim Line As Long
    Dim level As Long
    Line = SendEditor(SCI_LINEFROMPOSITION, Me.GetCurrentPos, CLng(0))
    level = SendEditor(SCI_GETFOLDLEVEL, Line, CLng(0))
    EnsureAllChildrenVisible Line, level
End Sub

Public Sub EnsureAllChildrenVisible(Line As Long, level As Long)
    'Ensure all children visible
    SendEditor SCI_SETFOLDEXPANDED, Line, 1
    Expand Line, True, True, 100, level
End Sub

'====================================================================
'====================================================================
'====================================================================
Public Sub About()
Attribute About.VB_UserMemId = -552
Attribute About.VB_MemberFlags = "40"
    frmAbout.Show vbModal
    Unload frmAbout
    Set frmAbout = Nothing
End Sub

Public Sub FindBox(frmOwner As Variant)
    Dim frm As frmFind
    Set frm = New frmFind
    Set frm.Editawy1 = Me
    frm.Show , frmOwner
End Sub

Public Sub ReplaceBox(frmOwner As Variant)
    Dim frm As frmReplace
    Set frm = New frmReplace
    Set frm.Editawy1 = Me
    frm.Show , frmOwner
End Sub

Public Sub GoToBox(frmOwner As Variant)
    Dim frm As frmGoto
    Set frm = New frmGoto
    Set frm.Editawy1 = Me
    frm.Show , frmOwner
End Sub

Friend Sub RaiseFindEvent(ByVal count As Long)
    
    RaiseEvent FoundText(count)
    
End Sub

Friend Sub RaiseReplaceEvent(ByVal count As Long)
    RaiseEvent ReplacedText(count)
End Sub
'====================================================================
' It changes the characteristics of a style
Public Sub Style(ByVal sty As Long, _
                Optional ByVal ForeColor As Long = BLACK, _
                Optional ByVal BackColor As Long = WHITE, _
                Optional fnt As StdFont = Nothing, _
                Optional ByVal eolFilled As Boolean, _
                Optional ByVal SetVisible As Boolean = True, _
                Optional ByVal SetCase As CaseMode = MIXED, _
                Optional ByVal SetCharset As CharSet = ANSI)
    
    SendEditor SCI_STYLESETFORE, sty, ForeColor
    SendEditor SCI_STYLESETBACK, sty, BackColor
    
    If Not fnt Is Nothing Then
        SendEditor SCI_STYLESETSIZE, sty, fnt.Size
        SendEditor SCI_STYLESETFONT, sty, fnt.Name
        SendEditor SCI_STYLESETBOLD, sty, fnt.Bold
        SendEditor SCI_STYLESETITALIC, sty, fnt.Italic
        SendEditor SCI_STYLESETUNDERLINE, sty, fnt.Underline
    End If
    
    SendEditor SCI_STYLESETEOLFILLED, sty, eolFilled
    SendEditor SCI_STYLESETVISIBLE, sty, SetVisible
    SendEditor SCI_STYLESETCASE, sty, CLng(SetCase)
    SendEditor SCI_STYLESETCHARACTERSET, sty, CLng(SetCharset)
End Sub
    
Public Function MakeBool(ByVal SciBool As Long) As Boolean
    If SciBool = 1 Then
        MakeBool = True
    Else
        MakeBool = False
    End If
End Function

Public Function SciBool(ByVal bValue As Boolean) As Long
    If bValue = True Then
        SciBool = CLng(1)
    Else
        SciBool = CLng(0)
    End If
End Function

Public Property Get SymbolMargin() As Boolean
    SymbolMargin = m_SymbolMargin
End Property

Public Property Let SymbolMargin(ByVal bValue As Boolean)
    m_SymbolMargin = bValue
    If bValue Then
        'Margin 1
        SendEditor SCI_SETMARGINTYPEN, 1&, SC_MARGIN_SYMBOL
        SendEditor SCI_SETMARGINWIDTHN, 1&, 20&
        SendEditor SCI_SETMARGINSENSITIVEN, 1&, 0&
        
        'SCI_SETMARGINMASKN(int margin, int mask)
        'Call Message(SCI_SETMARGINMASKN, 1, SC_MASK_FOLDERS)
        'SCI_SETFOLDMARGINCOLOUR(bool useSetting, int colour)
        'SCI_SETFOLDMARGINHICOLOUR(bool useSetting, int colour)
        'Call Message(SCI_SETFOLDMARGINCOLOUR, 1, vbRed)
        'Call Message(SCI_SETFOLDMARGINHICOLOUR, 1, vbYellow)
        
' SC_MARK_CIRCLE = 0
' SC_MARK_ROUNDRECT = 1
' SC_MARK_ARROW = 2
' SC_MARK_SMALLRECT = 3
' SC_MARK_SHORTARROW = 4
' SC_MARK_EMPTY = 5
' SC_MARK_ARROWDOWN = 6
' SC_MARK_MINUS = 7
' SC_MARK_PLUS = 8
' SC_MARK_VLINE = 9
' SC_MARK_LCORNER = 10
' SC_MARK_TCORNER = 11
' SC_MARK_BOXPLUS = 12
' SC_MARK_BOXPLUSCONNECTED = 13
' SC_MARK_BOXMINUS = 14
' SC_MARK_BOXMINUSCONNECTED = 15
' SC_MARK_LCORNERCURVE = 16
' SC_MARK_TCORNERCURVE = 17
' SC_MARK_CIRCLEPLUS = 18
' SC_MARK_CIRCLEPLUSCONNECTED = 19
' SC_MARK_CIRCLEMINUS = 20
' SC_MARK_CIRCLEMINUSCONNECTED = 21
' SC_MARK_BACKGROUND = 22
' SC_MARK_DOTDOTDOT = 23
' SC_MARK_ARROWS = 24
' SC_MARK_PIXMAP = 25
' SC_MARK_FULLRECT = 26
        Dim Fore As Long, Back As Long
        Fore = vbWhite
        Back = vbBlack
        DefineMarker SC_MARKNUM_FOLDER, SC_MARK_BOXPLUS, Fore, Back
    Else
        SendEditor SCI_SETMARGINWIDTHN, 1, 0     ' To put the wide one of the margin to zero eliminates it
    End If
    PropertyChanged "SymbolMargin"
    
End Property

Public Property Get LineNumbers() As Boolean
    LineNumbers = m_LineNumbers
End Property

Public Property Let LineNumbers(ByVal bValue As Boolean)
'The margin argument should be 0, 1 or 2. You can use the predefined
'constants SC_MARGIN_SYMBOL (0) and SC_MARGIN_NUMBER (1) to set a margin
'as either a line number or a symbol margin. By convention, margin 0 is
'used for line numbers and the other two are used for symbols.

'SCI_SETMARGINTYPEN(int margin, int iType)
'SCI_SETMARGINWIDTHN(int margin, int pixelWidth)
'SCI_SETMARGINSENSITIVEN(int margin, bool sensitive)

    m_LineNumbers = bValue
    If bValue Then
        'Margin 0
        Call AdjustLineNumberMarginWidth(0)
        SendEditor SCI_SETMARGINTYPEN, 0, SC_MARGIN_NUMBER
        'SendEditor SCI_SETMARGINSENSITIVEN, 0, 1
        SendEditor SCI_SETMARGINSENSITIVEN, 0, 0
        
        'Margin 1
        'Call Message(SCI_SETMARGINTYPEN, 1, SC_MARGIN_SYMBOL)
        'Call Message(SCI_SETMARGINWIDTHN, 1, 30)
        'Call Message(SCI_SETMARGINSENSITIVEN, 1, 1)
        
        'Margin 2
        'Call Message(SCI_SETMARGINTYPEN, 2, SC_MARGIN_SYMBOL)
        'Call Message(SCI_SETMARGINWIDTHN, 2, 60)
        'Call Message(SCI_SETMARGINSENSITIVEN, 2, 1)
        
        'SCI_SETMARGINMASKN(int margin, int mask)
        'Call Message(SCI_SETMARGINMASKN, 1, SC_MASK_FOLDERS)
        
'SCI_SETFOLDMARGINCOLOUR(bool useSetting, int colour)
'SCI_SETFOLDMARGINHICOLOUR(bool useSetting, int colour)
        'Call Message(SCI_SETFOLDMARGINCOLOUR, 1, vbRed)
        'Call Message(SCI_SETFOLDMARGINHICOLOUR, 1, vbYellow)
        
'// Tell scintilla to draw folding lines UNDER the folded line
'   SendMessage(SCI_SETFOLDFLAGS, 16,0);
'// Set margin 2 = folding margin to display folding symbols
'    SendMessage(SCI_SETMARGINMASKN, 2, SC_MASK_FOLDERS);
'// allow notifications for folding actions
'   SendMessage(SCI_SETMODEVENTMASK, SC_MOD_INSERTTEXT|SC_MOD_DELETETEXT, 0);
'//   SendMessage(SCI_SETMODEVENTMASK, SC_MOD_CHANGEFOLD|SC_MOD_INSERTTEXT|SC_MOD_DELETETEXT, 0);
'// make the folding margin sensitive to folding events = if you click into the margin you get a notification event
'    SendMessage(SCI_SETMARGINSENSITIVEN, 2, TRUE);
'// define a set of markers to displa folding symbols
'   SendMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDEROPEN, SC_MARK_MINUS);
'   SendMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDER, SC_MARK_PLUS);
'   SendMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDERSUB, SC_MARK_EMPTY);
'   SendMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDERTAIL, SC_MARK_EMPTY);
'   SendMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDEREND, SC_MARK_EMPTY);
'   SendMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDEROPENMID, SC_MARK_EMPTY);
'   SendMessage(SCI_MARKERDEFINE, SC_MARKNUM_FOLDERMIDTAIL, SC_MARK_EMPTY);
        
    Else
        SendEditor SCI_SETMARGINWIDTHN, 0, 0    ' To put the wide one of the margin to zero eliminates it
    End If
    PropertyChanged "LineNumbers"
    
End Property

Public Property Get Folding() As Boolean
    Folding = m_bFolding
End Property

Public Property Let Folding(ByVal bValue As Boolean)
    
    m_bFolding = bValue
    
    If m_bFolding Then 'Enable folding
        
        'SendMessage(SCI_SETPROPERTY, (WPARAM)_T("fold"), (LPARAM)_T("1"))
        
        ' Enable folding of the procedures and functions
        
        SendEditor SCI_SETSTYLEBITS, 7, 0
        
'        SetProperty "fold", "1"
'        SetProperty "fold.comment", "1"
'        SetProperty "fold.compact", "0"
'        SetProperty "fold.perl.pod", "1"
'        SetProperty "fold.perl.package", "1"
'        SetProperty "fold.preprocessor", "1"
'        SetProperty "fold.symbols", "1"
        
        'Reset the folder margin
        SendEditor SCI_SETMARGINWIDTHN, 2, 0
        
        'SC_MARGIN_SYMBOL , SC_MARGIN_NUMBER
        SendEditor SCI_SETMARGINTYPEN, CLng(2), SC_MARGIN_SYMBOL
        SendEditor SCI_SETMARGINWIDTHN, CLng(2), CLng(20)
        SendEditor SCI_SETMARGINMASKN, CLng(2), SC_MASK_FOLDERS
        
        SendEditor SCI_SETMARGINSENSITIVEN, CLng(2), CLng(1)
        
        'Call SendMessage(Sci, SCI_SETMARGINSENSITIVEN, CLng(0), CLng(0))
        'Call SendMessage(Sci, SCI_SETMARGINSENSITIVEN, CLng(1), CLng(0))
        
        'Call Message(SCI_SETMODEVENTMASK, SC_MOD_INSERTTEXT Or SC_MOD_DELETETEXT, 0)
        'The general-purpose marker symbols currently available are:
        'SC_MARK_CIRCLE, SC_MARK_ROUNDRECT, SC_MARK_ARROW, SC_MARK_SMALLRECT, SC_MARK_SHORTARROW, SC_MARK_EMPTY, SC_MARK_ARROWDOWN, SC_MARK_MINUS, SC_MARK_PLUS, SC_MARK_ARROWS, SC_MARK_DOTDOTDOT, SC_MARK_EMPTY, SC_MARK_BACKGROUND and SC_MARK_FULLRECT.
        
' SC_MARK_CIRCLE = 0
' SC_MARK_ROUNDRECT = 1
' SC_MARK_ARROW = 2
' SC_MARK_SMALLRECT = 3
' SC_MARK_SHORTARROW = 4
' SC_MARK_EMPTY = 5
' SC_MARK_ARROWDOWN = 6
' SC_MARK_MINUS = 7
' SC_MARK_PLUS = 8
' SC_MARK_VLINE = 9
' SC_MARK_LCORNER = 10
' SC_MARK_TCORNER = 11
' SC_MARK_BOXPLUS = 12
' SC_MARK_BOXPLUSCONNECTED = 13
' SC_MARK_BOXMINUS = 14
' SC_MARK_BOXMINUSCONNECTED = 15
' SC_MARK_LCORNERCURVE = 16
' SC_MARK_TCORNERCURVE = 17
' SC_MARK_CIRCLEPLUS = 18
' SC_MARK_CIRCLEPLUSCONNECTED = 19
' SC_MARK_CIRCLEMINUS = 20
' SC_MARK_CIRCLEMINUSCONNECTED = 21
' SC_MARK_BACKGROUND = 22
' SC_MARK_DOTDOTDOT = 23
' SC_MARK_ARROWS = 24
' SC_MARK_PIXMAP = 25
' SC_MARK_FULLRECT = 26
        DefineMarker SC_MARKNUM_FOLDER, SC_MARK_BOXPLUS, m_lMarkerForeColor, m_lMarkerBackColor
        DefineMarker SC_MARKNUM_FOLDEROPEN, SC_MARK_BOXMINUS, m_lMarkerForeColor, m_lMarkerBackColor
        
        DefineMarker SC_MARKNUM_FOLDEREND, SC_MARK_BOXPLUSCONNECTED, m_lMarkerForeColor, m_lMarkerBackColor
        
        DefineMarker SC_MARKNUM_FOLDERSUB, SC_MARK_VLINE, m_lMarkerForeColor, m_lMarkerBackColor
        DefineMarker SC_MARKNUM_FOLDERTAIL, SC_MARK_LCORNER, m_lMarkerForeColor, m_lMarkerBackColor
        
        'Start and end of {...}.
        DefineMarker SC_MARKNUM_FOLDEROPENMID, SC_MARK_BOXMINUSCONNECTED, m_lMarkerForeColor, m_lMarkerBackColor
        DefineMarker SC_MARKNUM_FOLDERMIDTAIL, SC_MARK_TCORNER, m_lMarkerForeColor, m_lMarkerBackColor
        
        SendEditor SCI_SETFOLDFLAGS, CLng(16), 0
        
    Else    'Disable folding
        SendEditor SCI_SETMARGINWIDTHN, 2, 0
        SetProperty "fold", "0"
    End If
    
    PropertyChanged "Folding"
    
End Property

Public Sub DefineMarker(ByVal marker As Long, ByVal markerType As Long, _
    ByVal Fore As Long, Back As Long)
    
    SendEditor SCI_MARKERDEFINE, marker, markerType
    SendEditor SCI_MARKERSETFORE, marker, (Fore)
    SendEditor SCI_MARKERSETBACK, marker, (Back)

End Sub

'====================================================================
'====================================================================
Public Sub ColorToRGB(ByVal lngColor As Long, intRed As Integer, _
            intGreen As Integer, intBlue As Integer)
    
    Dim lColor As Long
    
    lColor = lngColor
    
    If lColor > 0 Then
        intRed = lColor Mod &H100
    
        lColor = lColor \ &H100
        intGreen = lColor Mod &H100
    
        lColor = lColor \ &H100
        intBlue = lColor Mod &H100
    End If
End Sub

'====================================================================
Public Function MakeColor(ByVal lColor As Long) As Long
    
    Dim r As Integer, G As Integer, b As Integer
    Dim c As Long
    
    ColorToRGB lColor, r, G, b
    
    c = r
    c = c + G * 256&
    c = c + b * 65536
    
    'MakeColor = val(Hex(B * 256 * 256& + G * 256 & R))
    MakeColor = c
    'Debug.Print "MakeColor: "; Hex(MakeColor)
    
End Function
 
' Visible end of line or not - *
Public Property Get EOLVisible() As Boolean
    EOLVisible = m_ViewEOL
End Property

Public Property Let EOLVisible(vNewValue As Boolean)
    m_ViewEOL = vNewValue
    SendEditor SCI_SETVIEWEOL, m_ViewEOL
    PropertyChanged "EOLVisible"
End Property

'====================================================================
'           Focus and windows messags manager
'====================================================================
Private Sub RaiseFocusEvent(ByVal wParam As Long, ByVal lParam As Long)
    
    Select Case wParam
    
        Case &H2000000:
            RaiseEvent GotTheFocus
            
        Case &H1000000:
            RaiseEvent LostTheFocus
                        
    End Select
    
End Sub

Public Function Byte2Str(bVal() As Byte) As String
    Dim i As Long
    For i = 0 To UBound(bVal())
        Byte2Str = Byte2Str & Chr(bVal(i))
    Next i
End Function

Public Function hwnd() As Long
    hwnd = UserControl.hwnd
End Function

Public Function HwndWin() As Long
    HwndWin = Sci
End Function

Public Sub SetFocusWin(ByVal hwnd As Long)
    Call SetFocusAPI(hwnd)
End Sub

Public Sub SetFocus()
    'Set focus to the Scintilla handle
    'Call SendMessage(Sci, SCI_SETFOCUS, CLng(1), CLng(0))
    SendEditor SCI_SETFOCUS, CLng(1), CLng(0)
    Call SetFocusAPI(Sci)
End Sub

Private Sub UserControl_EnterFocus()
    RaiseEvent EnterTheFocus
End Sub

Private Sub UserControl_ExitFocus()
    RaiseEvent LostTheFocus
End Sub

Private Sub UserControl_GotFocus()
    RaiseEvent GotTheFocus
End Sub

Public Sub LoadDefaultMarkers()
    
    Dim X As Long
    Dim Fore As Long, Back As Long
    
    Fore = vbWhite
    Back = vbBlue
    
    For X = 0 To 31
        Me.DefineMarker X, X, Fore, Back
    Next X
    
' SC_MARK_CIRCLE = 0
' SC_MARK_ROUNDRECT = 1
' SC_MARK_ARROW = 2
' SC_MARK_SMALLRECT = 3
' SC_MARK_SHORTARROW = 4
' SC_MARK_EMPTY = 5
' SC_MARK_ARROWDOWN = 6
' SC_MARK_MINUS = 7
' SC_MARK_PLUS = 8
' SC_MARK_VLINE = 9
' SC_MARK_LCORNER = 10
' SC_MARK_TCORNER = 11
' SC_MARK_BOXPLUS = 12
' SC_MARK_BOXPLUSCONNECTED = 13
' SC_MARK_BOXMINUS = 14
' SC_MARK_BOXMINUSCONNECTED = 15
' SC_MARK_LCORNERCURVE = 16
' SC_MARK_TCORNERCURVE = 17
' SC_MARK_CIRCLEPLUS = 18
' SC_MARK_CIRCLEPLUSCONNECTED = 19
' SC_MARK_CIRCLEMINUS = 20
' SC_MARK_CIRCLEMINUSCONNECTED = 21
' SC_MARK_BACKGROUND = 22
' SC_MARK_DOTDOTDOT = 23
' SC_MARK_ARROWS = 24
' SC_MARK_PIXMAP = 25
' SC_MARK_FULLRECT = 26

End Sub

Public Function GetUserMode() As Boolean
    'Ambient.UserMode is True when the control is being used at runtime.
    'False means that the control is being used at design time.
    GetUserMode = Ambient.UserMode
End Function

Private Sub AdjustLineNumberMarginWidth(ByVal lMargin As Long)
    
    Dim strText As String
    Dim lMarginWidth As Long
    Dim TxtWidth As Long
    
    strText = CStr(SendEditor(SCI_GETLINECOUNT, 0, 0))
    TxtWidth = SendMessageString(Sci, SCI_TEXTWIDTH, STYLE_LINENUMBER, "9")
    
    'The 4 here allows for spacing: 1 pixel on left and 3 on right.
    lMarginWidth = 4 + (Len(strText) * TxtWidth)
    
    If lMarginWidth < 10 Then lMarginWidth = 10
    SendEditor SCI_SETMARGINWIDTHN, lMargin, lMarginWidth
    
End Sub

Public Function TotalLines() As Long
    TotalLines = SendEditor(SCI_GETLINECOUNT, 0, 0)
End Function

Public Function Lines() As Long
    Lines = SendEditor(SCI_GETLINECOUNT, 0, 0)
End Function

Property Get EndOfLine() As EOL
    EndOfLine = m_EOL
End Property

Property Let EndOfLine(vNewValue As EOL)
    SendEditor SCI_SETEOLMODE, vNewValue
    m_EOL = vNewValue
    PropertyChanged "EndOfLine"
End Property

Private Function GetWord() As String
    
    Dim linebuf As String, str As String * 1000, c As String
    Dim current As Long, startWord As Long
    
    current = SendMessageString(Sci, SCI_GETCURLINE, Len(str), str)
    startWord = current
    linebuf = Left(str, startWord)
    
    Do While (startWord > 0)
        c = Mid$(linebuf, startWord, 1)
        If Not isAlpha(c) Or startWord = 1 Then Exit Do
        startWord = startWord - 1
    Loop
    
    GetWord = Trim(Mid$(linebuf, IIf(startWord = 0, 1, startWord), current))
End Function

Private Function isAlpha(ch As String) As Boolean
    isAlpha = ((ch Like "[a-z]") Or (ch Like "[A-Z]") Or (ch Like "[0-9]")) And (ch <> " ")
End Function

'====================================================================
'====================================================================
'           Text retrieval And modification
'====================================================================
'Each character in a Scintilla document is followed by an associated byte of styling information. The combination of a character byte and a style byte is called a cell. Style bytes are interpreted as a style index in the low 5 bits and as 3 individual bits of indicators. This allows 32 fundamental styles, which is enough for most languages, and three independent indicators so that, for example, syntax errors, deprecated names and bad indentation could all be displayed at once. The number of bits used for styles can be altered with SCI_SETSTYLEBITS up to a maximum of 7 bits. The remaining bits can be used for indicators.
'Positions within the Scintilla document refer to a character or the gap before that character. The first character in a document is 0, the second 1 and so on. If a document contains nLen characters, the last character is numbered nLen-1. The caret exists between character positions and can be located from before the first character (0) to after the last character (nLen).
'There are places where the caret can not go where two character bytes make up one character. This occurs when a DBCS character from a language like Japanese is included in the document or when line ends are marked with the CP/M standard of a carriage return followed by a line feed. The INVALID_POSITION constant (-1) represents an invalid position within the document.
'All lines of text in Scintilla are the same height, and this height is calculated from the largest font in any current style. This restriction is for performance; if lines differed in height then calculations involving positioning of text would require the text to be styled first.
'

'SCI_GETTEXT(int length, char *text)
'This returns length-1 characters of text from the start of the document plus one terminating 0 character. To collect all the text in a document, use SCI_GETLENGTH to get the number of characters in the document (nLen), allocate a character buffer of length nLen+1 bytes, then call SCI_GETTEXT(nLen+1, char *text). If the text argument is 0 then the length that should be allocated to store the entire document is returned. If you then save the text, you should use SCI_SETSAVEPOINT to mark the text as unmodified.
'See also: SCI_GETSELTEXT , SCI_GETCURLINE, SCI_GETLINE, SCI_GETSTYLEDTEXT, SCI_GETTEXTRANGE

'SCI_SETTEXT(<unused>, const char *text)
'This replaces all the text in the document with the zero terminated text string you pass in.
' The text that shows Scintilla -*
Public Property Get Text() As String
    Dim numChar As Long
    Dim Txt As String
    numChar = SendEditor(SCI_GETLENGTH, 0, 0) + 1
    Txt = String(numChar, "0")
    SendMessageString Sci, SCI_GETTEXT, numChar, Txt
    Text = Left(Txt, numChar - 1)
End Property

Public Property Let Text(ByVal sText As String)
    Dim zText As String
    zText = sText & Chr(0)
    SendEditor SCI_SETTEXT, 0, zText
    m_Text = sText
    PropertyChanged "Text"
End Property

'See also: SCI_EMPTYUNDOBUFFER , SCI_GETMODIFY
'
'SCI_GETLINE(int line, char *text)
'This fills the buffer defined by text with the contents of the nominated line (lines start at 0). The buffer is not terminated by a 0 character. It is up to you to make sure that the buffer is long enough for the text, use SCI_LINELENGTH(int line). The returned value is the number of characters copied to the buffer. The returned text includes any end of line characters. If you ask for a line number outside the range of lines in the document, 0 characters are copied. If the text argument is 0 then the length that should be allocated to store the entire line is returned.
Public Function GetLineX(ByVal lineNumber As Long) As String
     
    Dim length As Long
    Dim str As String
    
    length = Me.LineLength(lineNumber)
    str = String(length, Chr(0))
    SendMessageString Sci, SCI_GETLINE, lineNumber, str
    GetLineX = str

End Function

Public Function GetLine(lineNumber As Long) As String
    Dim Txt As String
    Dim lLength As Long
    Dim bByte() As Byte
    lLength = SendMessage(Sci, SCI_LINELENGTH, lineNumber, 0)
    ReDim bByte(0 To lLength)
    SendMessage Sci, SCI_GETLINE, lineNumber, VarPtr(bByte(0))
    Txt = Byte2Str(bByte())
    GetLine = Txt
End Function

'See also: SCI_GETCURLINE , SCI_GETSELTEXT, SCI_GETTEXTRANGE, SCI_GETSTYLEDTEXT, SCI_GETTEXT
'
'SCI_REPLACESEL(<unused>, const char *text)
'The currently selected text between the anchor and the current position is replaced by the 0 terminated text string. If the anchor and current position are the same, the text is inserted at the caret position. The caret is positioned after the inserted text and the caret is scrolled into view.
Public Sub ReplaceSel(ByVal strText As String)
    Dim str As String
    str = strText & Chr(0)
    Call SendMessageString(Sci, SCI_REPLACESEL, CLng(0), strText)
End Sub

'SCI_SETREADONLY(bool readOnly)
'SCI_GETREADONLY
'These messages set and get the read-only flag for the document.
'If you mark a document as read only, attempts to modify the text cause
'the SCN_MODIFYATTEMPTRO notification.
Public Property Get ReadOnly() As Boolean
    'm_bReadOnly = MakeBool(SendEditor(SCI_GETREADONLY, CLng(0), CLng(0)))
    ReadOnly = m_bReadOnly
End Property

Public Property Let ReadOnly(ByVal bReadOnly As Boolean)
    SendEditor SCI_SETREADONLY, SciBool(bReadOnly)
    m_bReadOnly = bReadOnly
    PropertyChanged "ReadOnly"
End Property

'SCI_GETTEXTRANGE(<unused>, TextRange *tr)
'This collects the text between the positions cpMin and cpMax and copies it to lpstrText (see struct TextRange in Scintilla.h). If cpMax is -1, text is returned to the end of the document. The text is 0 terminated, so you must supply a buffer that is at least 1 character longer than the number of characters you wish to read. The return value is the length of the returned text not including the terminating 0.
'SCI_GETTEXTRANGE(<unused>, TextRange *tr)
'This collects the text between the positions cpMin and cpMax and copies it to
'lpstrText (see struct TextRange in Scintilla.h). If cpMax is -1, text is
'returned to the end of the document. The text is 0 terminated, so you must
'supply a buffer that is at least 1 character longer than the number of
'characters you wish to read. The return value is the length of the returned
'text not including the terminating 0.
'Public Type CharacterRange
'    cpMin As Long
'    cpMax As Long
'End Type
'
'Public Type TextRange
'    chrg As CharacterRange
'    lpstrText As String
'End Type

Public Function GetTextRange(ByVal lRangeStart As Long, ByVal lRangeEnd As Long) As String
     
    Dim length As Long
    Dim txtRange As TextRange
    Dim lEnd As Long
    Dim lStart As Long
    Dim sText As String
    Dim DocLen As Long
    
    DocLen = Me.GetTextLength()
    
    lStart = lRangeStart
    lEnd = lRangeEnd
    
    If lStart < 0 Then lStart = 0
    
    If lEnd < 0 Then
        lEnd = DocLen
    End If
    If lEnd > DocLen Then lEnd = DocLen
    
    txtRange.chrg.cpMin = lStart
    txtRange.chrg.cpMax = lEnd
    txtRange.lpstrText = String(Abs(lEnd - lStart) + 1, Chr(0))
    
    'length = SendMessageString(sci, SCI_GETTEXTRANGE, CLng(0), ByVal VarPtr(txtRange))
    length = SendMessageStruct(Sci, SCI_GETTEXTRANGE, CLng(0), ByVal txtRange)
    sText = Mid(txtRange.lpstrText, 1, length)
    GetTextRange = StrConv(sText, vbUnicode)
End Function

'SCI_GETSTYLEDTEXT(<unused>, TextRange *tr)
'This collects styled text into a buffer using two bytes for each cell, with the character at the lower address of each pair and the style byte at the upper address. Characters between the positions cpMin and cpMax are copied to lpstrText (see struct TextRange in Scintilla.h). Two 0 bytes are added to the end of the text, so the buffer that lpstrText points at must be at least 2*(cpMax-cpMin)+2 bytes long. No check is made for sensible values of cpMin or cpMax. Positions outside the document return character codes and style bytes of 0.
Public Function GetStyledText(ByVal startPos As Long, ByVal endPos As Long) As String
    
    Dim TLen As Long, TRange As TextRange
   
    TLen = Me.GetTextLength()
    
    If startPos < 0 Then startPos = 0
    If endPos > TLen Then endPos = TLen
    
    TLen = Abs((endPos - startPos) * 2) + 2
    
    TRange.chrg.cpMin = startPos
    TRange.chrg.cpMax = endPos
    TRange.lpstrText = Space(TLen)
    
    SendMessageStruct Sci, SCI_GETSTYLEDTEXT, CLng(0), ByVal TRange
    
    GetStyledText = StrConv(Left(TRange.lpstrText, TLen \ 2 - 2), vbUnicode)
End Function

'SCI_ALLOCATE(int bytes, <unused>)
'Allocate a document buffer large enough to store a given number of bytes. The document will not be made smaller than its current contents.
Public Sub Allocate(ByVal lBytes As Long)
    SendEditor SCI_ALLOCATE, lBytes, CLng(0)
End Sub

'SCI_ADDTEXT(int length, const char *s)
'This inserts the first length characters from the string s at the current position. This will include any 0's in the string that you might have expected to stop the insert operation. The current position is set at the end of the inserted text, but it is not scrolled into view.
Public Sub AddText(sText As String)
    Call SendMessageString(Sci, SCI_ADDTEXT, Len(sText), sText)
End Sub

'SCI_ADDSTYLEDTEXT(int length, cell *s)
'This behaves just like SCI_ADDTEXT, but inserts styled text.
Public Sub AddStyledText(sText As String)
    Call SendMessageString(Sci, SCI_ADDSTYLEDTEXT, Len(sText), sText)
End Sub

'SCI_APPENDTEXT(int length, const char *s)
'This adds the first length characters from the string s to the end of the document. This will include any 0's in the string that you might have expected to stop the operation. The current selection is not changed and the new text is not scrolled into view.

Public Sub AppendText(sText As String)
    Call SendMessageString(Sci, SCI_APPENDTEXT, Len(sText), sText)
End Sub

'SCI_INSERTTEXT(int pos, const char *text)
'This inserts the zero terminated text string at position pos or at the current position if pos is -1. If the current position is after the insertion point then it is moved along with its surrounding text but no scrolling is performed.
Public Sub InsertText(ByVal Pos As Long, sText As String)
    If Pos < -1 Then Pos = -1
    'SciMsgString DPtr, SCI_INSERTTEXT, Pos, Text & vbNullChar
    Call SendMessageString(Sci, SCI_INSERTTEXT, Pos, sText & vbNullChar)
End Sub

'SCI_CLEARALL
'Unless the document is read-only, this deletes all the text.
Public Sub ClearAll()
    SendEditor SCI_CLEARALL, CLng(0), CLng(0)
End Sub

'SCI_CLEARDOCUMENTSTYLE
'When wanting to completely restyle the document, for example after choosing a lexer, the SCI_CLEARDOCUMENTSTYLE can be used to clear all styling information and reset the folding state.
Public Sub ClearDocumentStyle()
    SendEditor SCI_CLEARDOCUMENTSTYLE, CLng(0), CLng(0)
End Sub

'SCI_GETCHARAT(int pos)
'This returns the character at pos in the document or 0 if pos is negative or past the end of the document.
Public Function GetCharAt(ByVal Pos As Long) As String
    GetCharAt = Chr(SendEditor(SCI_GETCHARAT, Pos, CLng(0)))
End Function

Public Function GetCharAtAsc(ByVal Pos As Long) As String
    GetCharAtAsc = SendEditor(SCI_GETCHARAT, Pos, CLng(0))
End Function

'SCI_GETSTYLEAT(int pos)
'This returns the style at pos in the document, or 0 if pos is negative or past the end of the document.
Public Function GetStyleAt(ByVal Pos As Long) As Long
    GetStyleAt = SendEditor(SCI_GETSTYLEAT, Pos, CLng(0))
End Function

'SCI_SETSTYLEBITS(int bits)
'SCI_GETSTYLEBITS
'This pair of routines sets and reads back the number of bits in each cell to use for styling, to a maximum of 7 style bits. The remaining bits can be used as indicators. The standard setting is SCI_SETSTYLEBITS(5). The number of styling bits needed by the current lexer can be found with SCI_GETSTYLEBITSNEEDED.
Public Sub SetStyleBits(Bits As Long)
    SendEditor SCI_SETSTYLEBITS, Bits, CLng(0)
End Sub

Public Function GetStyleBits() As Long
    GetStyleBits = SendEditor(SCI_GETSTYLEBITS, CLng(0), CLng(0))
End Function

'TextRange and CharacterRange
'These structures are defined to be exactly the same shape as the Win32 TEXTRANGE and CHARRANGE, so that older code that treats Scintilla as a RichEdit will work.
'
'struct CharacterRange {
'    long cpMin;
'    long cpMax;
'};
'
'struct TextRange {
'    struct CharacterRange chrg;
'    char *lpstrText;
'};


'====================================================================
'           Searching
'====================================================================
'SCI_FINDTEXT(int flags, TextToFind *ttf)
'SCI_SEARCHANCHOR
'SCI_SEARCHNEXT(int searchFlags, const char *text)
'SCI_SEARCHPREV(int searchFlags, const char *text)
Public Function FindText(ByVal SearchFlags As SearchFlags, _
        ByVal startPos As Long, ByVal endPos As Long, Text As String, _
        Optional ByRef SearchEndPos As Long, Optional ByVal Backward As Boolean = False) _
        As Long
        
    Dim TTF As TextToFind
    Dim targetstart As Long, targetend As Long
    
    ' Reverse the positions for reverse searching (not supported by SCFIND_REGEXP).
    If Not Backward And startPos <= endPos Or Backward And startPos > endPos Then
        TTF.chrg.cpMin = startPos
        TTF.chrg.cpMax = endPos
    Else
        TTF.chrg.cpMin = endPos
        TTF.chrg.cpMax = startPos
    End If
    
    TTF.lpstrText = Text & vbNullChar  ' Add a null terminator.
    
    FindText = SendMessageStruct(Sci, SCI_FINDTEXT, SearchFlags, TTF)
    
    ' Set the end position of the search.
    If FindText >= 0 Then SearchEndPos = TTF.chrgText.cpMax
    
    If FindText > -1 Then
        'targetStart = SendMessage(Sci, SCI_GETTARGETSTART, CLng(0), CLng(0))
        'targetEnd = SendMessage(Sci, SCI_GETTARGETEND, CLng(0), CLng(0))
        targetstart = TTF.chrgText.cpMin
        targetend = TTF.chrgText.cpMax
        SendEditor SCI_SETSEL, targetstart, targetend
        'SendMessage sci, SCI_SETSELECTIONSTART, targetStart, CLng(0)
        'SendMessage sci, SCI_SETSELECTIONEND, targetEnd, CLng(0)
        'Me.EnsureRangeVisible targetStart, targetEnd, True
    End If
    
'    m_lFindSearchFlags = SearchFlags
'    m_lFindstartPos
'    m_lFindendPos
'    m_sFindText
'    m_lFindSearchEndPos
'    m_bFindBackward = Backward
'SearchFlags As SearchFlags, _
        ByVal startPos As Long, ByVal endPos As Long, Text As String, _
        Optional ByRef SearchEndPos As Long, Optional ByVal Backward As Boolean = False) _
        As Long
End Function

Public Function Find( _
                TxtToFind As String, _
                Optional FindReverse As Boolean = False, _
                Optional ByVal FindinRng As Boolean, _
                Optional WrapDocument As Boolean = True, _
                Optional CaseSensative As Boolean = False, _
                Optional WordStart As Boolean = False, _
                Optional WholeWord As Boolean = False, _
                Optional RegExp As Boolean = False) As Long
  
    Dim lval As Long, Found As Long
    Dim targetstart As Long, targetend As Long, Pos As Long
    
    ' Sending a null string to scintilla for the find text willc ause errors!
    If TxtToFind = "" Then Exit Function
    lval = 0
    If CaseSensative Then
      lval = lval Or SCFIND_MATCHCASE
    End If
    If WordStart Then
      lval = lval Or SCFIND_WORDSTART
    End If
    If WholeWord Then
      lval = lval Or SCFIND_WHOLEWORD
    End If
    If RegExp Then
      lval = lval Or SCFIND_REGEXP
    End If
    
    SendEditor SCI_SETSEARCHFLAGS, lval
    
    If FindinRng Then
        targetstart = SendEditor(SCI_GETSELECTIONSTART, CLng(0), CLng(0))
        targetend = SendEditor(SCI_GETSELECTIONEND, CLng(0), CLng(0))
    Else
      If FindReverse = False Then
        targetstart = SendEditor(SCI_GETSELECTIONEND, 0, 0)
        targetend = Len(Text)
      Else
        targetstart = SendEditor(SCI_GETSELECTIONSTART, 0, 0)
        targetend = 0
      End If
    End If
    
    SendEditor SCI_SETTARGETSTART, targetstart
    SendEditor SCI_SETTARGETEND, targetend
    
    Found = SendMessageString(Sci, SCI_SEARCHINTARGET, Len(TxtToFind), TxtToFind)
    
    If Found > -1 Then
        targetstart = SendEditor(SCI_GETTARGETSTART, CLng(0), CLng(0))
        targetend = SendEditor(SCI_GETTARGETEND, CLng(0), CLng(0))
        SetSel targetstart, targetend
    Else
        If WrapDocument Then
            If FindReverse = False Then
                targetstart = 0
                targetend = Len(Text)
            Else
                targetstart = Len(Text)
                targetend = 0
            End If
            
            SendEditor SCI_SETTARGETSTART, targetstart
            SendEditor SCI_SETTARGETEND, targetend
            Found = SendMessageString(Sci, SCI_SEARCHINTARGET, Len(TxtToFind), TxtToFind)
            
            If Found > -1 Then
                targetstart = SendEditor(SCI_GETTARGETSTART, CLng(0), CLng(0))
                targetend = SendEditor(SCI_GETTARGETEND, CLng(0), CLng(0))
                SetSel targetstart, targetend
            End If
        End If
    End If
    
    ' A find has been performed so now FindNext will work.
    bFindEvent = True
    Find = Found
      
    ' Set the info that we've used so we findnext can send the same thing
    ' out if called.
  
    bWrap = WrapDocument
    bCase = CaseSensative
    bWholeWord = WholeWord
    bRegEx = RegExp
    bWordStart = WordStart
    bFindInRange = FindinRng
    bFindReverse = FindReverse
    strFind = TxtToFind
  
End Function

Public Function FindNext() As Long
  'If no find events have occurred exit this sub or it may cause errors.
  If bFindEvent = False Then Exit Function
  FindNext = Find(strFind, False, bFindInRange, bWrap, bCase, bWordStart, bWholeWord, bRegEx)
End Function

Public Function FindPrev() As Long
  If bFindEvent = False Then Exit Function
  FindPrev = Find(strFind, True, bFindInRange, bWrap, bCase, bWordStart, bWholeWord, bRegEx)
End Function

Public Function Search( _
                TxtToFind As String, _
                Optional FindReverse As Boolean = False, _
                Optional ByVal FindinRng As Boolean, _
                Optional WrapDocument As Boolean = True, _
                Optional CaseSensative As Boolean = False, _
                Optional WordStart As Boolean = False, _
                Optional WholeWord As Boolean = False, _
                Optional RegExp As Boolean = False) As Long
  
    Dim lval As Long, Found As Long
    Dim targetstart As Long, targetend As Long, Pos As Long
    
    ' Sending a null string to scintilla for the find text willc ause errors!
    If TxtToFind = "" Then Exit Function
    lval = 0
    If CaseSensative Then
      lval = lval Or SCFIND_MATCHCASE
    End If
    If WordStart Then
      lval = lval Or SCFIND_WORDSTART
    End If
    If WholeWord Then
      lval = lval Or SCFIND_WHOLEWORD
    End If
    If RegExp Then
      lval = lval Or SCFIND_REGEXP
    End If
    
    SendEditor SCI_SETSEARCHFLAGS, lval
    
    If FindinRng Then
        targetstart = SendEditor(SCI_GETSELECTIONSTART, CLng(0), CLng(0))
        targetend = SendEditor(SCI_GETSELECTIONEND, CLng(0), CLng(0))
    Else
      If FindReverse = False Then
        targetstart = SendEditor(SCI_GETSELECTIONEND, 0, 0)
        targetend = Len(Text)
      Else
        targetstart = SendEditor(SCI_GETSELECTIONSTART, 0, 0)
        targetend = 0
      End If
    End If
    
    SendEditor SCI_SETTARGETSTART, targetstart
    SendEditor SCI_SETTARGETEND, targetend
    
    Found = SendMessageString(Sci, SCI_SEARCHINTARGET, Len(TxtToFind), TxtToFind)
    
    If Found > -1 Then
        targetstart = SendEditor(SCI_GETTARGETSTART, CLng(0), CLng(0))
        targetend = SendEditor(SCI_GETTARGETEND, CLng(0), CLng(0))
        'SetSel targetstart, targetend
    Else
        If WrapDocument Then
            If FindReverse = False Then
                targetstart = 0
                targetend = Len(Text)
            Else
                targetstart = Len(Text)
                targetend = 0
            End If
            
            SendEditor SCI_SETTARGETSTART, targetstart
            SendEditor SCI_SETTARGETEND, targetend
            Found = SendMessageString(Sci, SCI_SEARCHINTARGET, Len(TxtToFind), TxtToFind)
            
            If Found > -1 Then
                targetstart = SendEditor(SCI_GETTARGETSTART, CLng(0), CLng(0))
                targetend = SendEditor(SCI_GETTARGETEND, CLng(0), CLng(0))
                'SetSel targetstart, targetend
            End If
        End If
    End If
    
    ' A find has been performed so now FindNext will work.
    bSearchEvent = True
    Search = Found
      
    ' Set the info that we've used so we findnext can send the same thing
    ' out if called.
  
    bSearchWrap = WrapDocument
    bSearchCase = CaseSensative
    bSearchWholeWord = WholeWord
    bSearchRegEx = RegExp
    bSearchWordStart = WordStart
    bSearchInRange = FindinRng
    bSearchReverse = FindReverse
    strSearchFind = TxtToFind
  
End Function

Public Function SearchNext() As Long
  'If no find events have occurred exit this sub or it may cause errors.
  If bSearchEvent = False Then Exit Function
  SearchNext = Search(strSearchFind, False, bSearchInRange, bSearchWrap, bSearchCase, bSearchWordStart, bSearchWholeWord, bSearchRegEx)
End Function

Public Function SearchPrev() As Long
  If bSearchEvent = False Then Exit Function
  SearchPrev = Search(strSearchFind, True, bSearchInRange, bSearchWrap, bSearchCase, bSearchWordStart, bSearchWholeWord, bSearchRegEx)
End Function

Public Function ReplaceText( _
                strSearchFor As String, _
                strReplaceWith As String, _
                Optional ReplaceAll As Boolean = False, _
                Optional FindReverse As Boolean = False, _
                Optional ByVal FindinRng As Boolean, _
                Optional WrapDocument As Boolean = True, _
                Optional CaseSensative As Boolean = False, _
                Optional WordStart As Boolean = False, _
                Optional WholeWord As Boolean = False, _
                Optional RegExp As Boolean = False) As Long
  
    Dim Replaced As Long
    
    Replaced = 0
    If Find(strSearchFor, FindReverse, FindinRng, WrapDocument, CaseSensative, WordStart, WholeWord, RegExp) <> -1 Then
        Replaced = Replaced + 1
        ReplaceSel strReplaceWith
        If ReplaceAll Then
            While Find(strSearchFor, FindReverse, FindinRng, WrapDocument, CaseSensative, WordStart, WholeWord, RegExp) <> -1
                ReplaceSel strReplaceWith
                Replaced = Replaced + 1
            Wend
        End If
    End If
    
    ReplaceText = Replaced
End Function

Public Function MarkAll( _
                TxtToFind As String, _
                Optional FindReverse As Boolean = False, _
                Optional ByVal FindinRng As Boolean, _
                Optional WrapDocument As Boolean = True, _
                Optional CaseSensative As Boolean = False, _
                Optional WordStart As Boolean = False, _
                Optional WholeWord As Boolean = False, _
                Optional RegExp As Boolean = False, _
                Optional markerNumner As Long = 2) As Long
    
    Dim posCurrent As Long, Marked As Long, posFirstFound As Long
    Dim posFound  As Long, lLine As Long
    
    posCurrent = SendEditor(SCI_GETCURRENTPOS)
    Marked = 0
    
    posFirstFound = Me.Find(TxtToFind, FindReverse, FindinRng, _
        WrapDocument, CaseSensative, WordStart, WholeWord, RegExp)
    
    If posFirstFound <> -1 Then
        posFound = posFirstFound
        Do
            Marked = Marked + 1
            lLine = SendEditor(SCI_LINEFROMPOSITION, posFound)
            Me.MarkerAdd lLine, markerNumner
            posFound = Me.FindNext
        Loop While ((posFound <> -1) And (posFound <> posFirstFound))
    End If
    
    SendEditor SCI_SETCURRENTPOS, posCurrent
    SetSel posCurrent, posCurrent
    MarkAll = Marked
    
End Function

Public Sub SearchAnchor()
    SendEditor SCI_SEARCHANCHOR, CLng(0), CLng(0)
End Sub

Public Function SearchN(SearchFlags As SearchFlags, sText As String) As Long
    Dim Terms As String
    Terms = sText & Chr(0)
    Me.SearchAnchor
    SearchN = SendMessageString(Sci, SCI_SEARCHNEXT, SearchFlags, Terms)
End Function

Public Function SearchP(SearchFlags As SearchFlags, sText As String) As Long
    Dim Terms As String
    Terms = sText & Chr(0)
    Me.SearchAnchor
    SearchP = SendMessageString(Sci, SCI_SEARCHPREV, SearchFlags, Terms)
End Function

'====================================================================
'           Search and replace using the target
'====================================================================
'Using SCI_REPLACESEL, modifications cause scrolling and other visible changes, which may take some time and cause unwanted display updates. If performing many changes, such as a replace all command, the target can be used instead. First, set the target, ie. the range to be replaced. Then call SCI_REPLACETARGET or SCI_REPLACETARGETRE.
'Searching can be performed within the target range with SCI_SEARCHINTARGET, which uses a counted string to allow searching for null characters. It returns the length of range or -1 for failure, in which case the target is not moved. The flags used by SCI_SEARCHINTARGET such as SCFIND_MATCHCASE, SCFIND_WHOLEWORD, SCFIND_WORDSTART, and SCFIND_REGEXP can be set with SCI_SETSEARCHFLAGS. SCI_SEARCHINTARGET may be simpler for some clients to use than SCI_FINDTEXT, as that requires using a pointer to a structure.

'SCI_SETTARGETSTART(int pos)
'SCI_GETTARGETSTART
'SCI_SETTARGETEND(int pos)
'SCI_GETTARGETEND
'These functions set and return the start and end of the target. When searching in non-regular expression mode, you can set start greater than end to find the last matching text in the target rather than the first matching text. The target is also set by a successful SCI_SEARCHINTARGET.
Public Sub SetTargetStart(ByVal Pos As Long)
    SendEditor SCI_SETTARGETSTART, Pos, CLng(0)
End Sub

Public Function GetTargetStart() As Long
    GetTargetStart = SendEditor(SCI_GETTARGETSTART, CLng(0), CLng(0))
End Function

Public Sub SetTargetEnd(ByVal Pos As Long)
    SendEditor SCI_SETTARGETEND, Pos, CLng(0)
End Sub

Public Function GetTargetEnd() As Long
    GetTargetEnd = SendEditor(SCI_GETTARGETEND, CLng(0), CLng(0))
End Function

'SCI_TARGETFROMSELECTION
'Set the target start and end to the start and end positions of the selection.
Public Sub TargetFromSelection()
    SendEditor SCI_TARGETFROMSELECTION, CLng(0), CLng(0)
End Sub

'SCI_SETSEARCHFLAGS(int searchFlags)
'SCI_GETSEARCHFLAGS
'These get and set the searchFlags used by SCI_SEARCHINTARGET. There are several option flags including a simple regular expression search.
' Flags:
'SCFIND_MATCHCASE A match only occurs with text that matches the case of the search string.
'SCFIND_WHOLEWORD A match only occurs if the characters before and after are not word characters.
'SCFIND_WORDSTART A match only occurs if the character before is not a word character.
'SCFIND_REGEXP The search string should be interpreted as a regular expression.
'SCFIND_POSIX Treat regular expression in a more POSIX compatible manner by interpreting bare ( and ) for tagged sections rather than \( and \).
Public Sub SetSearchFlagsAll(ByVal SearchFlags As SearchFlags)
    SendEditor SCI_SETSEARCHFLAGS, SearchFlags, CLng(0)
End Sub

Public Function GetSearchFlagsAll() As SearchFlags
    GetSearchFlagsAll = SendEditor(SCI_GETSEARCHFLAGS, CLng(0), CLng(0))
End Function

Public Sub SetSearchFlags(ByVal WholeWord As Boolean, _
            ByVal MatchCase As Boolean, ByVal WordStart As Boolean, _
            ByVal RegExp As Boolean, ByVal PosIX As Boolean)
    
    Dim flags As Long
    
    flags = 0
    
    If WholeWord Then flags = flags Or 2
    If MatchCase Then flags = flags Or 4
    If WordStart Then flags = flags Or &H100000
    If RegExp Then flags = flags Or &H200000
    If PosIX Then flags = flags Or &H400000
    
    SendEditor SCI_SETSEARCHFLAGS, flags, CLng(0)
    
End Sub

Public Function GetSearchFlags(ByRef WholeWord As Boolean, _
            ByRef MatchCase As Boolean, ByRef WordStart As Boolean, _
            ByRef RegExp As Boolean, ByRef PosIX As Boolean) As Long
    
    Dim flags As Long
    
    flags = SendEditor(SCI_GETSEARCHFLAGS, CLng(0), CLng(0))
    
    If (flags And 2) Then WholeWord = True Else WholeWord = False
    If (flags And 4) Then MatchCase = True Else MatchCase = False
    If (flags And &H100000) Then WordStart = True Else WordStart = False
    If (flags And &H200000) Then RegExp = True Else RegExp = False
    If (flags And &H400000) Then PosIX = True Else PosIX = False
    
    GetSearchFlags = flags
    
End Function

'SCI_SEARCHINTARGET(int length, const char *text)
'This searches for the first occurrence of a text string in the target defined by SCI_SETTARGETSTART and SCI_SETTARGETEND. The text string is not zero terminated; the size is set by length. The search is modified by the search flags set by SCI_SETSEARCHFLAGS. If the search succeeds, the target is set to the found text and the return value is the position of the start of the matching text. If the search fails, the result is -1.
Public Function SearchInTarget(TextToFind As String) As Long
    'The text string is not zero terminated; the size is set by length.
    SearchInTarget = SendMessageString(Sci, SCI_SEARCHINTARGET, Len(TextToFind), TextToFind)
End Function

'SCI_REPLACETARGET(int length, const char *text)
'If length is -1, text is a zero terminated string, otherwise length sets the number of character to replace the target with. The return value is the length of the replacement string.
'Note that the recommanded way to delete text in the document is to set the target to the text to be removed, and to perform a replace target with an empty string.
Public Function ReplaceTarget(TextToReplace As String) As Long
    'The text string is not zero terminated; the size is set by length.
    ReplaceTarget = SendMessageString(Sci, SCI_REPLACETARGET, Len(TextToReplace), TextToReplace)
End Function

'SCI_REPLACETARGETRE(int length, const char *text)
'This replaces the target using regular expressions. If length is -1, text is a zero terminated string, otherwise length is the number of characters to use. The replacement string is formed from the text string with any sequences of \1 through \9 replaced by tagged matches from the most recent regular expression search. The return value is the length of the replacement string.
'See also: SCI_FINDTEXT
Public Function ReplaceTargetRE(TextToReplace As String) As Long
    'The text string is not zero terminated; the size is set by length.
    ReplaceTargetRE = SendMessageString(Sci, SCI_REPLACETARGETRE, Len(TextToReplace), TextToReplace)
End Function

'====================================================================
'           Overtype
'====================================================================
'SCI_SETOVERTYPE(bool overType)
'SCI_GETOVERTYPE
'When overtype is enabled, each typed character replaces the character to the right of the text caret. When overtype is disabled, characters are inserted at the caret. SCI_GETOVERTYPE returns TRUE (1) if overtyping is active, otherwise FALSE (0) will be returned. Use SCI_SETOVERTYPE to set the overtype mode.
Public Sub SetOverType(ByVal overType As Boolean)
    SendEditor SCI_SETOVERTYPE, SciBool(overType), CLng(0)
End Sub

Public Function GetOverType() As Boolean
    GetOverType = MakeBool(SendEditor(SCI_GETOVERTYPE, CLng(0), CLng(0)))
End Function

'====================================================================
'           Cut, copy and paste
'====================================================================
Public Sub Cut()
    SendEditor SCI_CUT, CLng(0), CLng(0)
End Sub

Public Sub Copy()
    SendEditor SCI_COPY, CLng(0), CLng(0)
End Sub

Public Sub Paste()
    SendEditor SCI_PASTE, CLng(0), CLng(0)
End Sub

Public Sub Clear()
    SendEditor SCI_CLEAR, CLng(0), CLng(0)
End Sub

Public Sub Delete()
    
    Dim SelStart As Long, SelEnd As Long
    SelStart = SendEditor(SCI_GETSELECTIONSTART, CLng(0), CLng(0))
    SelEnd = SendEditor(SCI_GETSELECTIONEND, CLng(0), CLng(0))
    If (SelStart - SelEnd) <> 0 Then
        SendEditor SCI_SETSEL, SelStart, SelEnd
        SendEditor SCI_CLEAR
    End If
    
End Sub

Public Function CanPaste() As Boolean
    CanPaste = MakeBool(SendEditor(SCI_CANPASTE, CLng(0), CLng(0)))
End Function

'If you need a "can copy" or "can cut", use SCI_GETSELECTIONSTART()-SCI_GETSELECTIONEND(),
'which will be non-zero if you can copy or cut to the clipboard.
Public Function CanCut() As Boolean
    Dim SelStart As Long, SelEnd As Long
    SelStart = SendEditor(SCI_GETSELECTIONSTART, CLng(0), CLng(0))
    SelEnd = SendEditor(SCI_GETSELECTIONEND, CLng(0), CLng(0))
    If SelStart - SelEnd <> 0 Then
        CanCut = True
    Else
        CanCut = False
    End If
End Function

Public Function CanCopy() As Boolean
    Dim SelStart As Long, SelEnd As Long
    SelStart = SendEditor(SCI_GETSELECTIONSTART, CLng(0), CLng(0))
    SelEnd = SendEditor(SCI_GETSELECTIONEND, CLng(0), CLng(0))
    If SelStart - SelEnd <> 0 Then
        CanCopy = True
    Else
        CanCopy = False
    End If
End Function

'SCI_COPYRANGE(int start, int end)
'SCI_COPYTEXT(int length, const char *text)
'SCI_COPYRANGE copies a range of text from the document to the system clipboard and SCI_COPYTEXT copies a supplied piece of text to the system clipboard.
Public Sub CopyRange(ByVal lStart As Long, ByVal lEnd As Long)
    SendEditor SCI_COPYRANGE, lStart, lEnd
End Sub

Public Sub CopyText(sText As String)

    Dim sStr As String
    sStr = StrConv(sText, vbFromUnicode)
    Call SendMessageString(Sci, SCI_COPYTEXT, CLng(Len(sText)), ByVal StrPtr(sStr))
    Exit Sub
        
    Dim bText() As Byte
    bText = StrConv(sText, vbFromUnicode)
    ReDim Preserve bText(0 To UBound(bText) + 1) As Byte
    SendEditor SCI_COPYTEXT, ByVal UBound(bText), ByVal VarPtr(bText(0))
    
End Sub

Public Sub SetClipboard(sText As String)
    Clipboard.SetText sText, vbCFText ' Put text on Clipboard.
End Sub

Public Function GetClipboard() As String
    If Clipboard.GetFormat(vbCFText) Then
        GetClipboard = Clipboard.GetText(vbCFText)
    Else
        GetClipboard = ""
    End If
    'vbCFText, vbCFRTF, vbCFLink
End Function

Public Sub ClearClipboard()
    Clipboard.Clear
End Sub

'====================================================================
'           Error handling
'====================================================================
'SCI_SETSTATUS(int status)
'SCI_GETSTATUS
'If an error occurs, Scintilla may set an internal error number that can be retrieved with SCI_GETSTATUS. Not currently used but will be in the future. To clear the error status call SCI_SETSTATUS(0).
Public Sub SetStatus(ByVal lStatus As Long)
    SendEditor SCI_SETSTATUS, lStatus, CLng(0)
End Sub

Public Function GetStatus() As Long
    GetStatus = SendEditor(SCI_GETSTATUS, CLng(0), CLng(0))
End Function

'====================================================================
'           Undo and Redo
'====================================================================
'Scintilla has multiple level undo and redo. It will continue to collect undoable actions until memory runs out. Scintilla saves actions that change the document. Scintilla does not save caret and selection movements, view scrolling and the like. Sequences of typing or deleting are compressed into single actions to make it easier to undo and redo at a sensible level of detail. Sequences of actions can be combined into actions that are undone as a unit. These sequences occur between SCI_BEGINUNDOACTION and SCI_ENDUNDOACTION messages. These sequences can be nested and only the top-level sequences are undone as units.

'SCI_UNDO
'SCI_CANUNDO
'SCI_UNDO undoes one action, or if the undo buffer has reached a SCI_ENDUNDOACTION point, all the actions back to the corresponding SCI_BEGINUNDOACTION.
'SCI_CANUNDO returns 0 if there is nothing to undo, and 1 if there is. You would typically use the result of this message to enable/disable the Edit menu Undo command.
Public Sub Undo()
    SendEditor SCI_UNDO, CLng(0), CLng(0)
End Sub

Public Function CanUndo() As Boolean
    CanUndo = MakeBool(SendEditor(SCI_CANUNDO, CLng(0), CLng(0)))
End Function

'SCI_REDO
'SCI_CANREDO
'SCI_REDO undoes the effect of the last SCI_UNDO operation.
'SCI_CANREDO returns 0 if there is no action to redo and 1 if there are undo actions to redo. You could typically use the result of this message to enable/disable the Edit menu Redo command.
Public Sub Redo()
    SendEditor SCI_REDO, CLng(0), CLng(0)
End Sub

Public Function CanRedo() As Boolean
    CanRedo = MakeBool(SendEditor(SCI_CANREDO, CLng(0), CLng(0)))
End Function

'SCI_EMPTYUNDOBUFFER
'This command tells Scintilla to forget any saved undo or redo history. It also sets the save point to the start of the undo buffer, so the document will appear to be unmodified. This does not cause the SCN_SAVEPOINTREACHED notification to be sent to the container.
Public Sub EmptyUndoBuffer()
    SendEditor SCI_EMPTYUNDOBUFFER, CLng(0), CLng(0)
End Sub

'SCI_SETUNDOCOLLECTION(bool collectUndo)
'SCI_GETUNDOCOLLECTION
'You can control whether Scintilla collects undo information with SCI_SETUNDOCOLLECTION. Pass in true (1) to collect information and false (0) to stop collecting. If you stop collection, you should also use SCI_EMPTYUNDOBUFFER to avoid the undo buffer being unsynchronized with the data in the buffer.
'You might wish to turn off saving undo information if you use the Scintilla to store text generated by a program (a Log view) or in a display window where text is often deleted and regenerated.
Public Sub SetUndoCollection(ByVal bValue As Boolean)
    SendEditor SCI_SETUNDOCOLLECTION, SciBool(bValue), CLng(0)
End Sub

Public Function GetUndoCollection() As Boolean
    GetUndoCollection = MakeBool(SendEditor(SCI_GETUNDOCOLLECTION, CLng(0), CLng(0)))
End Function

'SCI_BEGINUNDOACTION
'SCI_ENDUNDOACTION
'Send these two messages to Scintilla to mark the beginning and end of a set of operations that you want to undo all as one operation but that you have to generate as several operations. Alternatively, you can use these to mark a set of operations that you do not want to have combined with the preceding or following operations if they are undone.
Public Sub BeginUndoAction()
    SendEditor SCI_BEGINUNDOACTION, CLng(0), CLng(0)
End Sub

Public Sub EndUndoAction()
    SendEditor SCI_ENDUNDOACTION, CLng(0), CLng(0)
End Sub

'====================================================================
'           Selection and information
'====================================================================
'====================================================================
'SCI_GETTEXTLENGTH
'SCI_GETLENGTH
'Both these messages return the length of the document in characters.
Public Function GetTextLength() As Long
    GetTextLength = SendEditor(SCI_GETTEXTLENGTH, CLng(0), CLng(0))
End Function

'SCI_GETLINECOUNT
'This returns the number of lines in the document. An empty document contains 1 line. A document holding only an end of line sequence has 2 lines.
Public Function GetLineCount() As Long
    GetLineCount = SendEditor(SCI_GETLINECOUNT, CLng(0), CLng(0))
End Function

Public Function length() As Long
    length = SendEditor(SCI_GETLINECOUNT, CLng(0), CLng(0))
End Function

'SCI_GETFIRSTVISIBLELINE
'This returns the line number of the first visible line in the Scintilla view. The first line in the document is numbered 0.
Public Function GetFirstVisibleLine() As Long
    GetFirstVisibleLine = SendEditor(SCI_GETFIRSTVISIBLELINE, CLng(0), CLng(0))
End Function

'SCI_LINESONSCREEN
'This returns the number of complete lines visible on the screen. With a constant line height, this is the vertical space available divided by the line separation. Unless you arrange to size your window to an integral number of lines, there may be a partial line visible at the bottom of the view.
Public Function LinesOnScreen() As Long
    LinesOnScreen = SendEditor(SCI_LINESONSCREEN, CLng(0), CLng(0))
End Function

'SCI_GETMODIFY
'This returns non-zero if the document is modified and 0 if it is unmodified. The modified status of a document is determined by the undo position relative to the save point. The save point is set by SCI_SETSAVEPOINT, usually when you have saved data to a file.
'If you need to be notified when the document becomes modified, Scintilla notifies the container that it has entered or left the save point with the SCN_SAVEPOINTREACHED and SCN_SAVEPOINTLEFT notification messages.
Public Function GetModify() As Boolean
    GetModify = MakeBool(SendEditor(SCI_GETMODIFY, CLng(0), CLng(0)))
End Function

Public Function Modified() As Boolean
    Modified = MakeBool(SendEditor(SCI_GETMODIFY, CLng(0), CLng(0)))
End Function

'SCI_SETSEL(int anchorPos, int currentPos)
'This message sets both the anchor and the current position. If currentPos is negative, it means the end of the document. If anchorPos is negative, it means remove any selection (i.e. set the anchor to the same position as currentPos). The caret is scrolled into view after this operation.
Public Sub SetSel(targetstart As Long, targetend As Long)
    SendEditor SCI_SETSEL, targetstart, targetend
End Sub

'SCI_GOTOPOS(int pos)
'This removes any selection, sets the caret at pos and scrolls the view to make the caret visible, if necessary. It is equivalent to SCI_SETSEL(pos, pos). The anchor position is set the same as the current position.
Public Sub GoToPos(lPosition As Long)
    SendEditor SCI_GOTOPOS, lPosition, CLng(0)
End Sub

'SCI_GOTOLINE(int line)
'This removes any selection and sets the caret at the start of line number line and scrolls the view (if needed) to make it visible. The anchor position is set the same as the current position. If line is outside the lines in the document (first line is 0), the line set is the first or last.
Public Sub GoToLine(lLineNmber As Long)
    SendEditor SCI_GOTOLINE, lLineNmber, CLng(0)
End Sub

'SCI_SETCURRENTPOS(int pos)
'This sets the current position and creates a selection between the anchor and the current position. The caret is not scrolled into view.
'See also: SCI_SCROLLCARET
Public Sub SetCurrentPos(lPosition As Long)
    SendEditor SCI_SETCURRENTPOS, lPosition, CLng(0)
End Sub

'SCI_GETCURRENTPOS
'This returns the current position.
Public Function GetCurrentPos() As Long
    GetCurrentPos = SendEditor(SCI_GETCURRENTPOS, CLng(0), CLng(0))
End Function

'SCI_SETANCHOR(int pos)
'This sets the anchor position and creates a selection between the anchor position and the current position. The caret is not scrolled into view.
'See also: SCI_SCROLLCARET
Public Sub SetAnchor(lPosition As Long)
    SendEditor SCI_SETANCHOR, lPosition, CLng(0)
End Sub

'SCI_GETANCHOR
'This returns the current anchor position.
Public Function GetAnchor() As Long
    GetAnchor = SendEditor(SCI_GETANCHOR, CLng(0), CLng(0))
End Function

'SCI_SETSELECTIONSTART(int pos)
'SCI_SETSELECTIONEND(int pos)
'These set the selection based on the assumption that the anchor position is
'less than the current position. They do not make the caret visible.
'The table shows the positions of the anchor and the current position after
'using these messages.

'--------------------------------------------------------------------
'                        |   anchor            |  current
'--------------------------------------------------------------------
'SCI_SETSELECTIONSTART   |   pos               |  Max(pos, current)
'SCI_SETSELECTIONEND     |   Min(anchor, pos)  |  pos
'--------------------------------------------------------------------

Public Sub SetSelectionStart(lPosition As Long)
    SendEditor SCI_SETSELECTIONSTART, lPosition, CLng(0)
End Sub

Public Sub SetSelectionEnd(lPosition As Long)
    SendEditor SCI_SETSELECTIONEND, lPosition, CLng(0)
End Sub

'====================================================================
'SCI_GETSELECTIONSTART
'SCI_GETSELECTIONEND
'These return the start and end of the selection without regard to which
'end is the current position and which is the anchor. SCI_GETSELECTIONSTART
'returns the smaller of the current position or the anchor position.
'SCI_GETSELECTIONEND returns the larger of the two values.

Public Function GetSelectionStart() As Long
    GetSelectionStart = SendEditor(SCI_GETSELECTIONSTART, CLng(0), CLng(0))
End Function

Public Function GetSelectionEnd() As Long
    GetSelectionEnd = SendEditor(SCI_GETSELECTIONEND, CLng(0), CLng(0))
End Function

Public Function GetSelectionLength() As Long
    GetSelectionLength = Me.GetSelectionEnd - Me.GetSelectionStart
End Function

'====================================================================
'SCI_SELECTALL
'This selects all the text in the document. The current position is not scrolled into view.
Public Sub SelectAll()
    SendEditor SCI_SELECTALL, CLng(0), CLng(0)
End Sub

'SCI_LINEFROMPOSITION(int pos)
'This message returns the line that contains the position pos in the document. The return value is 0 if pos <= 0. The return value is the last line if pos is beyond the end of the document.
Public Function LineFromPosition(ByVal lPosition As Long) As Long
    LineFromPosition = SendEditor(SCI_LINEFROMPOSITION, lPosition, CLng(0))
End Function

'SCI_POSITIONFROMLINE(int line)
'This returns the document position that corresponds with the start of the line. If line is negative, the position of the line holding the start of the selection is returned. If line is greater than the lines in the document, the return value is -1. If line is equal to the number of lines in the document (i.e. 1 line past the last line), the return value is the end of the document.
Public Function PositionFromLine(ByVal lLineNumber As Long) As Long
    PositionFromLine = SendEditor(SCI_POSITIONFROMLINE, lLineNumber, CLng(0))
End Function

Public Function GetCurrentLineNumber() As Long
    GetCurrentLineNumber = SendEditor(SCI_LINEFROMPOSITION, Me.GetCurrentPos, CLng(0)) + 1
End Function

Public Function Line() As Long
    Line = SendEditor(SCI_LINEFROMPOSITION, Me.GetCurrentPos, CLng(0))
End Function

'SCI_GETLINEENDPOSITION(int line)
'This returns the position at the end of the line, before any line end characters. If line is the last line in the document (which does not have any end of line characters), the result is the size of the document. If line is negative or line >= SCI_GETLINECOUNT(), the result is undefined.
Public Function GetLineEndPosition(ByVal lLineNumber As Long) As Long
    GetLineEndPosition = SendEditor(SCI_GETLINEENDPOSITION, lLineNumber, CLng(0))
End Function

'SCI_LINELENGTH(int line)
'This returns the length of the line, including any line end characters. If line is negative or beyond the last line in the document, the result is 0. If you want the length of the line not including any end of line characters, use SCI_GETLINEENDPOSITION(line) - SCI_POSITIONFROMLINE(line).
Public Function LineLength(ByVal lineNumber As Long) As Long
    LineLength = SendEditor(SCI_LINELENGTH, lineNumber, CLng(0))
End Function


'SCI_GETSELTEXT(<unused>, char *text)
'This copies the currently selected text and a terminating 0 byte to the text buffer. The buffer must be at least SCI_GETSELECTIONEND()-SCI_GETSELECTIONSTART()+1 bytes long.
'If the text argument is 0 then the length that should be allocated to store the entire selection is returned.
'See also: SCI_GETCURLINE , SCI_GETLINE, SCI_GETTEXT, SCI_GETSTYLEDTEXT, SCI_GETTEXTRANGE
Public Function GetSelText() As String
    
    Dim lLength As Long
    Dim sText As String
    
    lLength = Me.GetSelectionLength()
    If lLength < 1 Then
        GetSelText = ""
        Exit Function
    End If

    sText = String(lLength + 1, Chr(0))
    Call SendMessageString(Sci, SCI_GETSELTEXT, CLng(0), sText)
    sText = Mid(sText, 1, Len(sText) - 1)
    GetSelText = sText
    
End Function

'SCI_GETCURLINE(int textLen, char *text)
'This retrieves the text of the line containing the caret and returns the position within the line of the caret. Pass in char* text pointing at a buffer large enough to hold the text you wish to retrieve and a terminating 0 character. Set textLen to the length of the buffer which must be at least 1 to hold the terminating 0 character. If the text argument is 0 then the length that should be allocated to store the entire current line is returned.
'See also: SCI_GETSELTEXT , SCI_GETLINE, SCI_GETTEXT, SCI_GETSTYLEDTEXT, SCI_GETTEXTRANGE
Public Function GetCurLine(ByRef sText As String) As Long
    
    Dim lLength As Long
    Dim lCurPosition As Long
    Dim sBuffer As String
    
    lLength = Me.GetCurrentLineLength()
    sBuffer = String(lLength + 1, Chr(0))
    lCurPosition = SendMessageString(Sci, SCI_GETCURLINE, Len(sBuffer), sBuffer)
    sText = Mid(sBuffer, 1, lLength)
    GetCurLine = lCurPosition
    
End Function

'SCI_SELECTIONISRECTANGLE
'This returns 1 if the current selection is in rectangle mode, 0 if not.
Public Function SelectionRectangle() As Boolean
    SelectionRectangle = MakeBool(SendEditor(SCI_SELECTIONISRECTANGLE, CLng(0), CLng(0)))
End Function

'SCI_SETSELECTIONMODE(int mode)
'SCI_GETSELECTIONMODE
'The two functions set and get the selection mode, which can be stream (SC_SEL_STREAM=0) or rectangular (SC_SEL_RECTANGLE=1) or by lines (SC_SEL_LINES=2). When set in these modes, regular caret moves will extend or reduce the selection, until the mode is cancelled by a call with same value or with SCI_CANCEL. The get function returns the current mode even if the selection was made by mouse or with regular extended moves.
Public Sub SetSelectionMode(ByVal lMode As SelectionMode)
    SendEditor SCI_SETSELECTIONMODE, lMode, CLng(0)
End Sub

Public Function GetSelectionMode() As Long
    GetSelectionMode = SendEditor(SCI_GETSELECTIONMODE, CLng(0), CLng(0))
End Function

'SCI_GETLINESELSTARTPOSITION(int line)
'SCI_GETLINESELENDPOSITION(int line)
'Retrieve the position of the start and end of the selection at the given line with INVALID_POSITION returned if no selection on this line.
Public Function GetLineSelectionStartPosition(ByVal lLineNumber As Long) As Long
    GetLineSelectionStartPosition = SendEditor(SCI_GETLINESELSTARTPOSITION, lLineNumber, CLng(0))
End Function

Public Function GetLineSelectionEndPosition(ByVal lLineNumber As Long) As Long
    GetLineSelectionEndPosition = SendEditor(SCI_GETLINESELSTARTPOSITION, lLineNumber, CLng(0))
End Function

'SCI_MOVECARETINSIDEVIEW
'If the caret is off the top or bottom of the view, it is moved to the nearest line that is visible to its current position. Any selection is lost.
Public Sub MoveCaretInsideView()
    SendEditor SCI_MOVECARETINSIDEVIEW, CLng(0), CLng(0)
End Sub

'SCI_WORDENDPOSITION(int position, bool onlyWordCharacters)
'SCI_WORDSTARTPOSITION(int position, bool onlyWordCharacters)
'These messages return the start and end of words using the same definition of words as used internally within Scintilla. You can set your own list of characters that count as words with SCI_SETWORDCHARS. The position sets the start or the search, which is forwards when searching for the end and backwards when searching for the start.
'
'Set onlyWordCharacters to true (1) to stop searching at the first non-word character in the search direction. If onlyWordCharacters is false (0), the first character in the search direction sets the type of the search as word or non-word and the search stops at the first non-matching character. Searches are also terminated by the start or end of the document.
'
'If "w" represents word characters and "." represents non-word characters and "|" represents the position and true or false is the state of onlyWordCharacters:
'
'Initial state end, true end, false start, true start, false
'..ww..|..ww.. ..ww..|..ww.. ..ww....|ww.. ..ww..|..ww.. ..ww|....ww..
'....ww|ww.... ....wwww|.... ....wwww|.... ....|wwww.... ....|wwww....
'..ww|....ww.. ..ww|....ww.. ..ww....|ww.. ..|ww....ww.. ..|ww....ww..
'..ww....|ww.. ..ww....ww|.. ..ww....ww|.. ..ww....|ww.. ..ww|....ww..

Public Function WordEndPosition(ByVal Position As Long, ByVal onlyWordCharacters As Boolean) As Long
    WordEndPosition = SendEditor(SCI_WORDENDPOSITION, Position, SciBool(onlyWordCharacters))
End Function

Public Function wordStartPosition(ByVal Position As Long, ByVal onlyWordCharacters As Boolean) As Long
    wordStartPosition = SendEditor(SCI_WORDSTARTPOSITION, Position, SciBool(onlyWordCharacters))
End Function

'SCI_POSITIONBEFORE(int position)
'SCI_POSITIONAFTER(int position)
'These messages return the position before and after another position in the document taking into account the current code page. The minimum position returned is 0 and the maximum is the last position in the document. If called with a position within a multi byte character will return the position of the start/end of that character.
Public Function PositionBefore(ByVal Position As Long) As Long
    PositionBefore = SendEditor(SCI_POSITIONBEFORE, Position, CLng(0))
End Function

Public Function PositionAfter(ByVal Position As Long) As Long
    PositionAfter = SendEditor(SCI_POSITIONAFTER, Position, CLng(0))
End Function

'SCI_TEXTWIDTH(int styleNumber, const char *text)
'This returns the pixel width of a string drawn in the given styleNumber which can be used, for example, to decide how wide to make the line number margin in order to display a given number of numerals.
Public Function TextWidth(ByVal styleNumber As Long, sText As String) As Long
    TextWidth = SendMessageString(Sci, SCI_TEXTWIDTH, styleNumber, sText)
End Function

'SCI_TEXTHEIGHT(int line)
'This returns the height in pixels of a particular line. Currently all lines are the same height.
Public Function TextHeight(ByVal lLineNumber As Long) As Long
    TextHeight = SendEditor(SCI_TEXTHEIGHT, lLineNumber, CLng(0))
End Function

'SCI_GETCOLUMN(int pos)
'This message returns the column number of a position pos within the document taking the width of tabs into account. This returns the column number of the last tab on the line before pos, plus the number of characters between the last tab and pos. If there are no tab characters on the line, the return value is the number of characters up to the position on the line. In both cases, double byte characters count as a single character. This is probably only useful with monospaced fonts.
Public Function GetColumn(ByVal lPosition As Long) As Long
    GetColumn = SendEditor(SCI_GETCOLUMN, lPosition, CLng(0))
End Function

'SCI_FINDCOLUMN(int line, int column)
'This message returns the position of a column on a line taking the width of tabs into account. It treats a multi-byte character as a single column. Column numbers, like lines start at 0.
Public Function FindColumn(ByVal lLineNumber As Long, lColumn As Long) As Long
    FindColumn = SendEditor(SCI_FINDCOLUMN, lLineNumber, lColumn)
End Function

'SCI_POSITIONFROMPOINT(int x, int y)
'SCI_POSITIONFROMPOINTCLOSE(int x, int y)
'SCI_POSITIONFROMPOINT finds the closest character position to a point and SCI_POSITIONFROMPOINTCLOSE is similar but returns -1 if the point is outside the window or not close to any characters.
Public Function PositionFromPoint(ByVal X As Long, Y As Long) As Long
    PositionFromPoint = SendEditor(SCI_POSITIONFROMPOINT, X, Y)
End Function

Public Function PositionFromPointClose(ByVal X As Long, Y As Long) As Long
    PositionFromPointClose = SendEditor(SCI_POSITIONFROMPOINT, X, Y)
End Function


'SCI_POINTXFROMPOSITION(<unused>, int pos)
'SCI_POINTYFROMPOSITION(<unused>, int pos)
'These messages return the x and y display pixel location of text at position pos in the document.
Public Function PointXFromPosition(ByVal lPos As Long) As Long
    PointXFromPosition = SendEditor(SCI_POINTXFROMPOSITION, CLng(0), lPos)
End Function

Public Function PointYFromPosition(ByVal lPos As Long) As Long
    PointYFromPosition = SendEditor(SCI_POINTYFROMPOSITION, CLng(0), lPos)
End Function

'SCI_HIDESELECTION(bool hide)
'The normal state is to make the selection visible by drawing it as set by SCI_SETSELFORE and SCI_SETSELBACK. However, if you hide the selection, it is drawn as normal text.
Public Sub HideSelection(ByVal bValue As Boolean)
    SendEditor SCI_HIDESELECTION, SciBool(bValue), CLng(0)
End Sub

'SCI_CHOOSECARETX
'Scintilla remembers the x value of the last position horizontally moved to explicitly by the user and this value is then used when moving vertically such as by using the up and down keys. This message sets the current x position of the caret as the remembered value.
Public Sub ChooseCaretX()
    SendEditor SCI_CHOOSECARETX, CLng(0), CLng(0)
End Sub

'====================================================================
'                       Scrolling and automatic scrolling
'====================================================================

'SCI_LINESCROLL(int column, int line)
'This will attempt to scroll the display by the number of columns and lines that you specify. Positive line values increase the line number at the top of the screen (i.e. they move the text upwards as far as the user is concerned), Negative line values do the reverse.
'The column measure is the width of a space in the default style. Positive values increase the column at the left edge of the view (i.e. they move the text leftwards as far as the user is concerned). Negative values do the reverse.
'See also: SCI_SETXOFFSET
Public Sub LineScroll(ByVal lColumn As Long, ByVal lLine As Long)
    SendEditor SCI_LINESCROLL, lColumn, lLine
End Sub

'SCI_SCROLLCARET
'If the current position (this is the caret if there is no selection) is not visible, the view is scrolled to make it visible according to the current caret policy.
Public Sub ScrollCaret()
    SendEditor SCI_SCROLLCARET, CLng(0), CLng(0)
End Sub

'SCI_SETXCARETPOLICY(int caretPolicy, int caretSlop)
'SCI_SETYCARETPOLICY(int caretPolicy, int caretSlop)
'These set the caret policy. The value of caretPolicy is a combination of CARET_SLOP, CARET_STRICT, CARET_JUMPS and CARET_EVEN.
'
'CARET_SLOP     If set, we can define a slop value: caretSlop. This value defines an unwanted zone (UZ) where the caret is... unwanted. This zone is defined as a number of pixels near the vertical margins, and as a number of lines near the horizontal margins. By keeping the caret away from the edges, it is seen within its context. This makes it likely that the identifier that the caret is on can be completely seen, and that the current line is seen with some of the lines following it, which are often dependent on that line.
'CARET_STRICT   If set, the policy set by CARET_SLOP is enforced... strictly. The caret is centred on the display if caretSlop is not set, and cannot go in the UZ if caretSlop is set.
'CARET_JUMPS    If set, the display is moved more energetically so the caret can move in the same direction longer before the policy is applied again. '3UZ' notation is used to indicate three time the size of the UZ as a distance to the margin.
'CARET_EVEN     If not set, instead of having symmetrical UZs, the left and bottom UZs are extended up to right and top UZs respectively. This way, we favour the displaying of useful information: the beginning of lines, where most code reside, and the lines after the caret, for example, the body of a function.

Public Sub SetXCaretPolicy(ByVal caretPolicy As Long, ByVal caretSlop As Long)
    SendEditor SCI_SETXCARETPOLICY, caretPolicy, caretSlop
End Sub

Public Sub SetYCaretPolicy(ByVal caretPolicy As Long, ByVal caretSlop As Long)
    SendEditor SCI_SETYCARETPOLICY, caretPolicy, caretSlop
End Sub

'SCI_SETVISIBLEPOLICY(int caretPolicy, int caretSlop)
'This determines how the vertical positioning is determined when SCI_ENSUREVISIBLEENFORCEPOLICY is called. It takes VISIBLE_SLOP and VISIBLE_STRICT flags for the policy parameter. It is similar in operation to SCI_SETYCARETPOLICY(int caretPolicy, int caretSlop).
Public Sub SetVisiblePolicy(ByVal caretPolicy As Long, ByVal caretSlop As Long)
    SendEditor SCI_SETVISIBLEPOLICY, caretPolicy, caretSlop
End Sub

'SCI_SETHSCROLLBAR(bool visible)
'SCI_GETHSCROLLBAR
'The horizontal scroll bar is only displayed if it is needed for the assumed width. If you never wish to see it, call SCI_SETHSCROLLBAR(0). Use SCI_SETHSCROLLBAR(1) to enable it again. SCI_GETHSCROLLBAR returns the current state. The default state is to display it when needed. See also: SCI_SETSCROLLWIDTH.
Public Sub SetHScrollBar(ByVal bVisible As Boolean)
    SendEditor SCI_SETHSCROLLBAR, SciBool(bVisible), CLng(0)
End Sub

Public Function GetHorScrollBar() As Boolean
    GetHorScrollBar = MakeBool(SendEditor(SCI_GETHSCROLLBAR, CLng(0), CLng(0)))
End Function

'SCI_SETVSCROLLBAR(bool visible)
'SCI_GETVSCROLLBAR
'By default, the vertical scroll bar is always displayed when required. You can choose to hide or show it with SCI_SETVSCROLLBAR and get the current state with SCI_GETVSCROLLBAR.
Public Sub SetVScrollBar(ByVal bVisible As Boolean)
    SendEditor SCI_SETVSCROLLBAR, SciBool(bVisible), CLng(0)
End Sub

Public Function GetVerScrollBar() As Boolean
    GetVerScrollBar = MakeBool(SendEditor(SCI_GETVSCROLLBAR, CLng(0), CLng(0)))
End Function

'SCI_SETXOFFSET(int xOffset)
'SCI_GETXOFFSET
'The xOffset is the horizontal scroll position in pixels of the start of the text view. A value of 0 is the normal position with the first text column visible at the left of the view.
Public Sub SetXOffset(ByVal lPxiels As Long)
    SendEditor SCI_SETXOFFSET, lPxiels, CLng(0)
End Sub

Public Function GetXOffset() As Long
    GetXOffset = SendEditor(SCI_GETXOFFSET, CLng(0), CLng(0))
End Function

'SCI_SETSCROLLWIDTH(int pixelWidth)
'SCI_GETSCROLLWIDTH
'For performance, Scintilla does not measure the display width of the document to determine the properties of the horizontal scroll bar. Instead, an assumed width is used. These messages set and get the document width in pixels assumed by Scintilla. The default value is 2000.
Public Sub SetScrollWidth(ByVal PixelWidth As Long)
    SendEditor SCI_SETSCROLLWIDTH, PixelWidth, CLng(0)
End Sub

Public Function GetScrollWidth() As Long
    GetScrollWidth = SendEditor(SCI_GETSCROLLWIDTH, CLng(0), CLng(0))
    
End Function

'SCI_SETENDATLASTLINE(bool endAtLastLine)
'SCI_GETENDATLASTLINE
'SCI_SETENDATLASTLINE sets the scroll range so that maximum scroll position has the last line at the bottom of the view (default). Setting this to false allows scrolling one page below the last line.
Public Sub SetEndAtLastLine(ByVal endAtLastLine As Boolean)
    SendEditor SCI_SETENDATLASTLINE, SciBool(endAtLastLine), CLng(0)
End Sub

Public Function GetEndAtLastLine() As Boolean
    GetEndAtLastLine = MakeBool(SendEditor(SCI_GETENDATLASTLINE, CLng(0), CLng(0)))
End Function

'====================================================================
'               White space
'====================================================================
'SCI_SETVIEWWS(int wsMode)
'SCI_GETVIEWWS
'White space can be made visible which may useful for languages in which white space is significant, such as Python. Space characters appear as small centred dots and tab characters as light arrows pointing to the right. There are also ways to control the display of end of line characters. The two messages set and get the white space display mode. The wsMode argument can be one of:
'SCWS_INVISIBLE 0   The normal display mode with white space displayed as an empty background colour.
'SCWS_VISIBLEALWAYS 1   White space characters are drawn as dots and arrows,
'SCWS_VISIBLEAFTERINDENT 2  White space used for indentation is displayed normally but after the first visible character, it is shown as dots and arrows.
'The effect of using any other wsMode value is undefined.
Public Sub SetViewWWS(ByVal wsMode As Long)
    SendEditor SCI_SETVIEWWS, wsMode, CLng(0)
End Sub

Public Function GetViewWWS() As Long
    GetViewWWS = SendEditor(SCI_GETVIEWWS, CLng(0), CLng(0))
End Function

Public Property Get WhiteSpaceVisible() As WhiteSpace
    WhiteSpaceVisible = m_SCWS
End Property

Public Property Let WhiteSpaceVisible(vNewValue As WhiteSpace)
    m_SCWS = vNewValue
    SendEditor SCI_SETVIEWWS, m_SCWS
    PropertyChanged "WhiteSpcVisible"
End Property

'SCI_SETWHITESPACEFORE(bool useWhitespaceForeColour, int colour)
'SCI_SETWHITESPACEBACK(bool useWhitespaceBackColour, int colour)
'By default, the colour of visible white space is determined by the lexer in use. The foreground and/or background colour of all visible white space can be set globally, overriding the lexer's colours with SCI_SETWHITESPACEFORE and SCI_SETWHITESPACEBACK.
Public Sub SetWhiteSpaceFore(ByVal useWhitespaceForeColour As Boolean, ByVal Colour As Long)
    SendEditor SCI_SETWHITESPACEFORE, SciBool(useWhitespaceForeColour), Colour
End Sub

Public Sub SetWhiteSpaceBack(ByVal useWhitespaceBackColour As Boolean, ByVal Colour As Long)
    SendEditor SCI_SETWHITESPACEBACK, SciBool(useWhitespaceBackColour), Colour
End Sub


'====================================================================
'           Cursor
'====================================================================
'SCI_SETCURSOR(int curType)
'SCI_GETCURSOR
'The cursor is normally chosen in a context sensitive way, so it will be
'different over the margin than when over the text. When performing a slow
'action, you may wish to change to a wait cursor. You set the cursor type
'with SCI_SETCURSOR. The curType argument can be:
'
'SC_CURSORNORMAL -1 The normal cursor is displayed.
'SC_CURSORWAIT  4 The wait cursor is displayed when the mouse is over or owned
'by the Scintilla window.
'
'Cursor values 1 through 7 have defined cursors, but only SC_CURSORWAIT is usefully controllable. Other values of curType cause a pointer to be displayed. The SCI_GETCURSOR message returns the last cursor type you set, or SC_CURSORNORMAL (-1) if you have not set a cursor type.
Public Sub SetCursor(ByVal lCurType As Long)
    SendEditor SCI_SETCURSOR, lCurType, CLng(0)
End Sub

Public Function GetCursor() As Long
    GetCursor = SendEditor(SCI_GETCURSOR, CLng(0), CLng(0))
End Function

'====================================================================
'           mouse Capture
'====================================================================
'SCI_SETMOUSEDOWNCAPTURES(bool captures)
'SCI_GETMOUSEDOWNCAPTURES
'When the mouse is pressed inside Scintilla, it is captured so future mouse movement events are sent to Scintilla. This behavior may be turned off with SCI_SETMOUSEDOWNCAPTURES(0).
Public Sub SetMouseDownCaptures(ByVal bValue As Boolean)
    SendEditor SCI_SETMOUSEDOWNCAPTURES, SciBool(bValue), CLng(0)
End Sub

Public Function GetMouseDownCaptures() As Boolean
    GetMouseDownCaptures = MakeBool(SendEditor(SCI_GETMOUSEDOWNCAPTURES, CLng(0), CLng(0)))
End Function

'====================================================================
'               Line endings
'====================================================================
'SCI_SETEOLMODE(int eolMode)
'SCI_GETEOLMODE
'SCI_SETEOLMODE sets the characters that are added into the document when the user presses the Enter key. You can set eolMode to one of SC_EOL_CRLF (0), SC_EOL_CR (1), or SC_EOL_LF (2). The SCI_GETEOLMODE message retrieves the current state.
Public Sub SetEOLMode(ByVal eolMode As Long)
    SendEditor SCI_SETEOLMODE, eolMode, CLng(0)
End Sub

Public Function GetEOLMode() As Long
    GetEOLMode = MakeBool(SendEditor(SCI_GETEOLMODE, CLng(0), CLng(0)))
End Function

'SCI_CONVERTEOLS(int eolMode)
'This message changes all the end of line characters in the document to match eolMode. Valid values are: SC_EOL_CRLF (0), SC_EOL_CR (1), or SC_EOL_LF (2).
Public Sub ConvertEOLs(ByVal eolMode As EOL)
    SendEditor SCI_CONVERTEOLS, eolMode, CLng(0)
End Sub

'SCI_SETVIEWEOL(bool visible)
'SCI_GETVIEWEOL
'Normally, the end of line characters are hidden, but SCI_SETVIEWEOL allows you to display (or hide) them by setting visible true (or false). The visible rendering of the end of line characters is similar to (CR), (LF), or (CR)(LF). SCI_GETVIEWEOL returns the current state.
Public Sub SetViewEOL(ByVal bVisible As Boolean)
    SendEditor SCI_SETVIEWEOL, SciBool(bVisible), CLng(0)
End Sub

Public Function GetViewEOL() As Boolean
    GetViewEOL = MakeBool(SendEditor(SCI_GETVIEWEOL, CLng(0), CLng(0)))
End Function

'====================================================================
'           Styling
'====================================================================
'The styling messages allow you to assign styles to text. The standard Scintilla settings divide the 8 style bits available for each character into 5 bits (0 to 4 = styles 0 to 31) that set a style and three bits (5 to 7) that define indicators. You can change the balance between styles and indicators with SCI_SETSTYLEBITS. If your styling needs can be met by one of the standard lexers, or if you can write your own, then a lexer is probably the easiest way to style your document. If you choose to use the container to do the styling you can use the SCI_SETLEXER command to select SCLEX_CONTAINER, in which case the container is sent a SCN_STYLENEEDED notification each time text needs styling for display. As another alternative, you might use idle time to style the document. Even if you use a lexer, you might use the styling commands to mark errors detected by a compiler. The following commands can be used.

'SCI_GETENDSTYLED
'Scintilla keeps a record of the last character that is likely to be styled correctly. This is moved forwards when characters after it are styled and moved backwards if changes are made to the text of the document before it. Before drawing text, this position is checked to see if any styling is needed and, if so, a SCN_STYLENEEDED notification message is sent to the container. The container can send SCI_GETENDSTYLED to work out where it needs to start styling. Scintilla will always ask to style whole lines.
Public Function GetEndStyled() As Long
    GetEndStyled = SendEditor(SCI_GETENDSTYLED, CLng(0), CLng(0))
End Function

'SCI_STARTSTYLING(int pos, int mask)
'This prepares for styling by setting the styling position pos to start at and a mask indicating which bits of the style bytes can be set. The mask allows styling to occur over several passes, with, for example, basic styling done on an initial pass to ensure that the text of the code is seen quickly and correctly, and then a second slower pass, detecting syntax errors and using indicators to show where these are. For example, with the standard settings of 5 style bits and 3 indicator bits, you would use a mask value of 31 (0x1f) if you were setting text styles and did not want to change the indicators. After SCI_STARTSTYLING, send multiple SCI_SETSTYLING messages for each lexical entity to style.
Public Sub StartStyling(ByVal Pos As Long, Mask As Long)
    SendEditor SCI_STARTSTYLING, Pos, Mask
End Sub


'SCI_SETSTYLING(int length, int style)
'This message sets the style of length characters starting at the styling position and then increases the styling position by length, ready for the next call. If sCell is the style byte, the operation is:
'if ((sCell & mask) != style) sCell = (sCell & ~mask) | (style & mask);
Public Sub SetStyling(ByVal lLength As Long, lStyle As Long)
    SendEditor SCI_SETSTYLING, lLength, lStyle
End Sub

'SCI_SETSTYLINGEX(int length, const char *styles)
'As an alternative to SCI_SETSTYLING, which applies the same style to each byte, you can use this message which specifies the styles for each of length bytes from the styling position and then increases the styling position by length, ready for the next call. The length styling bytes pointed at by styles should not contain any bits not set in mask.
Public Sub SetStylingEX(ByVal lLength As Long, sStyles As Long)
    SendMessageString Sci, SCI_SETSTYLINGEX, lLength, sStyles
End Sub

'SCI_SETLINESTATE(int line, int value)
'SCI_GETLINESTATE(int line)
'As well as the 8 bits of lexical state stored for each character there is also an integer stored for each line. This can be used for longer lived parse states such as what the current scripting language is in an ASP page. Use SCI_SETLINESTATE to set the integer value and SCI_GETLINESTATE to get the value.
Public Sub SetLineState(ByVal lLine As Long, lValue As Long)
    SendEditor SCI_SETLINESTATE, lLine, lValue
End Sub

Public Function GetLineState(ByVal lLine As Long) As Long
    GetLineState = SendEditor(SCI_GETLINESTATE, lLine, CLng(0))
End Function

'SCI_GETMAXLINESTATE
'This returns the last line that has any line state.
Public Function GetMaxLineState() As Long
    GetMaxLineState = SendEditor(SCI_GETMAXLINESTATE, CLng(0), CLng(0))
End Function


'====================================================================
'           Style definition
'====================================================================
'SCI_STYLERESETDEFAULT
'This message resets STYLE_DEFAULT to its state when Scintilla was initialised.
Public Sub StyleResetDefault()
    SendEditor SCI_STYLERESETDEFAULT, CLng(0), CLng(0)
End Sub

'SCI_STYLECLEARALL
'This message sets all styles to have the same attributes as STYLE_DEFAULT. If you are setting up Scintilla for syntax colouring, it is likely that the lexical styles you set will be very similar. One way to set the styles is to:
'1. Set STYLE_DEFAULT to the common features of all styles.
'2. Use SCI_STYLECLEARALL to copy this to all styles.
'3. Set the style attributes that make your lexical styles different.
Public Sub StyleClearAll()
    SendEditor SCI_STYLECLEARALL, CLng(0), CLng(0)
End Sub

'SCI_STYLESETFONT(int styleNumber, const char *fontName)
'SCI_STYLESETSIZE(int styleNumber, int sizeInPoints)
'SCI_STYLESETBOLD(int styleNumber, bool bold)
'SCI_STYLESETITALIC(int styleNumber, bool italic)
'These messages (plus SCI_STYLESETCHARACTERSET) set the font attributes that are used to match the fonts you request to those available. The fontName is a zero terminated string holding the name of a font. Under Windows, only the first 32 characters of the name are used and the name is not case sensitive. For internal caching, Scintilla tracks fonts by name and does care about the casing of font names, so please be consistent. On GTK+ 2.x, either GDK or Pango can be used to display text. Pango antialiases text and works well with Unicode but GDK is faster. Prepend a '!' character to the font name to use Pango.

Public Sub StyleSetFont(ByVal styleNumber As Long, sFontName As String)
    SendEditor SCI_STYLESETFONT, styleNumber, sFontName
End Sub

Public Sub StyleSetSize(ByVal styleNumber As Long, ByVal sizeInPoints As Long)
    SendEditor SCI_STYLESETSIZE, styleNumber, sizeInPoints
End Sub

Public Sub StyleSetBold(ByVal styleNumber As Long, ByVal bBold As Boolean)
    SendEditor SCI_STYLESETBOLD, styleNumber, SciBool(bBold)
End Sub

Public Sub StyleSetItalic(ByVal styleNumber As Long, ByVal bItalic As Boolean)
    SendEditor SCI_STYLESETITALIC, styleNumber, SciBool(bItalic)
End Sub

'SCI_STYLESETUNDERLINE(int styleNumber, bool underline)
'You can set a style to be underlined. The underline is drawn in the foreground colour. All characters with a style that includes the underline attribute are underlined, even if they are white space.
Public Sub StyleSetUnderline(ByVal styleNumber As Long, ByVal bUnderline As Boolean)
    SendEditor SCI_STYLESETUNDERLINE, styleNumber, SciBool(bUnderline)
End Sub

'SCI_STYLESETFORE(int styleNumber, int colour)
'SCI_STYLESETBACK(int styleNumber, int colour)
'Text is drawn in the foreground colour. The space in each character cell that is not occupied by the character is drawn in the background colour.
Public Sub StyleSetFore(ByVal styleNumber As Long, ByVal Colour As Long)
    SendEditor SCI_STYLESETFORE, styleNumber, Colour
End Sub

Public Sub StyleSetBack(ByVal styleNumber As Long, ByVal Colour As Long)
    SendEditor SCI_STYLESETBACK, styleNumber, Colour
End Sub

'SCI_STYLESETEOLFILLED(int styleNumber, bool eolFilled)
'If the last character in the line has a style with this attribute set, the remainder of the line up to the right edge of the window is filled with the background colour set for the last character. This is useful when a document contains embedded sections in another language such as HTML pages with embedded JavaScript. By setting eolFilled to true and a consistent background colour (different from the background colour set for the HTML styles) to all JavaScript styles then JavaScript sections will be easily distinguished from HTML.
Public Sub StyleSetEOLFilled(ByVal styleNumber As Long, ByVal eolFilled As Boolean)
    SendEditor SCI_STYLESETEOLFILLED, styleNumber, SciBool(eolFilled)
End Sub

'SCI_STYLESETCHARACTERSET(int styleNumber, int charSet)
'You can set a style to use a different character set than the default. The places where such characters sets are likely to be useful are comments and literal strings. For example, SCI_STYLESETCHARACTERSET(SCE_C_STRING, SC_CHARSET_RUSSIAN) would ensure that strings in Russian would display correctly in C and C++ (SCE_C_STRING is the style number used by the C and C++ lexer to display literal strings; it has the value 6). This feature works differently on Windows and GTK+.
'
'The character sets supported on Windows are:
'SC_CHARSET_ANSI, SC_CHARSET_ARABIC, SC_CHARSET_BALTIC, SC_CHARSET_CHINESEBIG5,
'SC_CHARSET_DEFAULT, SC_CHARSET_EASTEUROPE, SC_CHARSET_GB2312, SC_CHARSET_GREEK,
'SC_CHARSET_HANGUL, SC_CHARSET_HEBREW, SC_CHARSET_JOHAB, SC_CHARSET_MAC,
'SC_CHARSET_OEM, SC_CHARSET_RUSSIAN (code page 1251), SC_CHARSET_SHIFTJIS,
'SC_CHARSET_SYMBOL, SC_CHARSET_THAI, SC_CHARSET_TURKISH, and SC_CHARSET_VIETNAMESE.
'
'The character sets supported on GTK+ are:
'SC_CHARSET_ANSI, SC_CHARSET_CYRILLIC (code page 1251), SC_CHARSET_EASTEUROPE, SC_CHARSET_GB2312, SC_CHARSET_HANGUL, SC_CHARSET_RUSSIAN (KOI8-R), SC_CHARSET_SHIFTJIS, and SC_CHARSET_8859_15.
Public Sub StyleSetCharacterSet(ByVal styleNumber As Long, ByVal CharSet As CharSet)
    SendEditor SCI_STYLESETCHARACTERSET, styleNumber, CharSet
End Sub

'SCI_STYLESETCASE(int styleNumber, int caseMode)
'The value of caseMode determines how text is displayed. You can set upper case (SC_CASE_UPPER, 1) or lower case (SC_CASE_LOWER, 2) or display normally (SC_CASE_MIXED, 0). This does not change the stored text, only how it is displayed.
Public Sub StyleSetCase(ByVal styleNumber As Long, ByVal lCaseMode As CaseMode)
    SendEditor SCI_STYLESETCASE, styleNumber, lCaseMode
End Sub

'SCI_STYLESETVISIBLE(int styleNumber, bool visible)
'Text is normally visible. However, you can completely hide it by giving it a style with the visible set to 0. This could be used to hide embedded formatting instructions or hypertext keywords in HTML or XML.
Public Sub StyleSetVisible(ByVal styleNumber As Long, ByVal bVisible As Boolean)
    SendEditor SCI_STYLESETVISIBLE, styleNumber, SciBool(bVisible)
End Sub

'SCI_STYLESETCHANGEABLE(int styleNumber, bool changeable)
'This is an experimental and incompletely implemented style attribute. The default setting is changeable set true but when set false it makes text read-only. Currently it only stops the caret from being within not-changeable text and does not yet stop deleting a range that contains not-changeable text.
Public Sub StyleSetChangeable(ByVal styleNumber As Long, ByVal changeable As Boolean)
    SendEditor SCI_STYLESETCHANGEABLE, styleNumber, SciBool(changeable)
End Sub

'SCI_STYLESETHOTSPOT(int styleNumber, bool hotspot)
'This style is used to mark ranges of text that can detect mouse clicks. The cursor changes to a hand over hotspots, and the foreground, and background colours may change and an underline appear to indicate that these areas are sensitive to clicking. This may be used to allow hyperlinks to other documents.
Public Sub StyleSetHotSpot(ByVal styleNumber As Long, ByVal hotspot As Boolean)
    SendEditor SCI_STYLESETHOTSPOT, styleNumber, SciBool(hotspot)
End Sub

'====================================================================
'           Caret, selection, and hotspot styles
'====================================================================
'SCI_SETSELFORE(bool useSelectionForeColour, int colour)
'SCI_SETSELBACK(bool useSelectionBackColour, int colour)
'You can choose to override the default selection colouring with these two messages. The colour you provide is used if you set useSelection*Colour to true. If it is set to false, the default colour colouring is used and the colour argument has no effect.
Public Sub SetSelFore(ByVal useSelectionForeColour As Boolean, ByVal Colour As Long)
    SendEditor SCI_SETSELFORE, SciBool(useSelectionForeColour), Colour
End Sub

Public Sub SetSelBack(ByVal useSelectionBackColour As Boolean, ByVal Colour As Long)
    SendEditor SCI_SETSELBACK, SciBool(useSelectionBackColour), Colour
End Sub

'SCI_SETCARETFORE(int colour)
'SCI_GETCARETFORE
'The colour of the caret can be set with SCI_SETCARETFORE and retrieved with SCI_CETCARETFORE.
Public Sub SetCaretFore(ByVal Colour As Long)
    SendEditor SCI_SETCARETFORE, Colour, CLng(0)
End Sub

Public Function GetCaretFore() As Long
    GetCaretFore = SendEditor(SCI_GETCARETFORE, CLng(0), CLng(0))
End Function

Public Property Get CaretForeColor() As OLE_COLOR
    'CaretForeColor = SendMessage(Sci, SCI_GETCARETFORE, CLng(0), CLng(0))
    CaretForeColor = m_lCaretForeColor
End Property

Public Property Let CaretForeColor(ByVal Colour As OLE_COLOR)
    SendEditor SCI_SETCARETFORE, MakeColor(Colour), CLng(0)
    m_lCaretForeColor = MakeColor(Colour)
    PropertyChanged "CaretForeColor"
End Property

'SCI_SETCARETLINEVISIBLE(bool show)
'SCI_GETCARETLINEVISIBLE
'SCI_SETCARETLINEBACK(int colour)
'SCI_GETCARETLINEBACK
'You can choose to make the background colour of the line containing the caret different with these messages. To do this, set the desired background colour with SCI_SETCARETLINEBACK, then use SCI_SETCARETLINEVISIBLE(true) to enable the effect. You can cancel the effect with SCI_SETCARETLINEVISIBLE(false). The two SCI_GETCARET* functions return the state and the colour. This form of background colouring has highest priority when a line has markers that would otherwise change the background colour.

Public Property Get CaretLineVisible() As Boolean
    'CaretLineVisible = MakeBool(SendEditor(SCI_GETCARETLINEVISIBLE, CLng(0), CLng(0)))
    CaretLineVisible = m_bCaretLineVisible
End Property

Public Property Let CaretLineVisible(ByVal bShow As Boolean)
    SendEditor SCI_SETCARETLINEVISIBLE, SciBool(bShow), CLng(0)
    m_bCaretLineVisible = bShow
    PropertyChanged "CaretLineVisible"
End Property

Public Sub SetCaretLineVisible(ByVal bShow As Boolean)
    SendEditor SCI_SETCARETLINEVISIBLE, bShow, CLng(0)
End Sub

Public Function GetCaretLineVisible() As Long
    GetCaretLineVisible = SendEditor(SCI_GETCARETLINEVISIBLE, CLng(0), CLng(0))
End Function

Public Property Get CaretLineBackColor() As OLE_COLOR
    'CaretLineBackColor = SendMessage(Sci, SCI_GETCARETLINEBACK, CLng(0), CLng(0))
    CaretLineBackColor = m_lCaretLineBackColor
End Property

Public Property Let CaretLineBackColor(ByVal Colour As OLE_COLOR)
    SendEditor SCI_SETCARETLINEBACK, MakeColor(Colour), CLng(0)
    'm_lCaretLineBackColor = MakeColor(Colour)
    m_lCaretLineBackColor = Colour
    PropertyChanged "CaretLineBackColor"
End Property

Public Sub SetCaretLineBack(ByVal Colour As Long)
    SendEditor SCI_SETCARETLINEBACK, Colour, CLng(0)
End Sub

Public Function GetCaretLineBack() As Long
    GetCaretLineBack = SendEditor(SCI_GETCARETLINEBACK, CLng(0), CLng(0))
End Function

'SCI_SETCARETPERIOD(int milliseconds)
'SCI_GETCARETPERIOD
'The rate at which the caret blinks can be set with SCI_SETCARETPERIOD which determines the time in milliseconds that the caret is visible or invisible before changing state. Setting the period to 0 stops the caret blinking. The default value is 500 milliseconds. SCI_GETCARETPERIOD returns the current setting.
Public Sub SetCaretPeriod(ByVal milliseconds As Long)
    SendEditor SCI_SETCARETPERIOD, milliseconds, CLng(0)
End Sub

Public Function GetCaretPeriod() As Long
    GetCaretPeriod = SendEditor(SCI_GETCARETPERIOD, CLng(0), CLng(0))
End Function

'SCI_SETCARETWIDTH(int pixels)
'SCI_GETCARETWIDTH
'The width of the caret can be set with SCI_SETCARETWIDTH to a value of 0, 1, 2 or 3 pixels. The default width is 1 pixel. You can read back the current width with SCI_GETCARETWIDTH. A width of 0 makes the caret invisible (added at version 1.50).
Public Sub SetCaretWidth(ByVal widthPixels As Long)
    SendEditor SCI_SETCARETWIDTH, widthPixels, CLng(0)
End Sub

Public Function GetCaretWidth() As Long
    GetCaretWidth = SendEditor(SCI_GETCARETWIDTH, CLng(0), CLng(0))
End Function

Public Property Get CaretWidth() As Long
    'm_lCaretWidth = SendEditor(SCI_GETCARETWIDTH, CLng(0), CLng(0))
    CaretWidth = m_lCaretWidth
End Property

Public Property Let CaretWidth(ByVal widthPixels As Long)
    SendEditor SCI_SETCARETWIDTH, widthPixels, CLng(0)
    'm_lCaretWidth = SendEditor(SCI_GETCARETWIDTH, CLng(0), CLng(0))
    m_lCaretWidth = widthPixels
    PropertyChanged "CaretWidth"
End Property

'SCI_SETHOTSPOTACTIVEFORE(bool useHotSpotForeColour, int colour)
'SCI_SETHOTSPOTACTIVEBACK(bool useHotSpotBackColour, int colour)
'SCI_SETHOTSPOTACTIVEUNDERLINE(bool underline,)
'SCI_SETHOTSPOTSINGLELINE(bool singleLine,)
'While the cursor hovers over text in a style with the hotspot attribute set, the default colouring can be modified and an underline drawn with these settings. Single line mode stops a hotspot from wrapping onto next line.

Public Sub SetHotSpotActiveFore(ByVal useHotSpotForeColour As Boolean, ByVal Colour As Long)
    SendEditor SCI_SETHOTSPOTACTIVEFORE, SciBool(useHotSpotForeColour), Colour
End Sub

Public Sub SetHotSpotActiveBack(ByVal useHotSpotBackColour As Boolean, ByVal Colour As Long)
    SendEditor SCI_SETHOTSPOTACTIVEBACK, SciBool(useHotSpotBackColour), Colour
End Sub

Public Sub SetHotSpotActiveUnderline(ByVal bUnderline As Boolean, ByVal Colour As Long)
    SendEditor SCI_SETHOTSPOTACTIVEUNDERLINE, SciBool(bUnderline), CLng(0)
End Sub

Public Sub SetHotSpotSingleLine(ByVal singleLine As Boolean)
    SendEditor SCI_SETHOTSPOTACTIVEUNDERLINE, SciBool(singleLine), CLng(0)
End Sub

'SCI_SETCONTROLCHARSYMBOL(int symbol)
'SCI_GETCONTROLCHARSYMBOL
'By default, Scintilla displays control characters (characters with codes less than 32) in a rounded rectangle as ASCII mnemonics: "NUL", "SOH", "STX", "ETX", "EOT", "ENQ", "ACK", "BEL", "BS", "HT", "LF", "VT", "FF", "CR", "SO", "SI", "DLE", "DC1", "DC2", "DC3", "DC4", "NAK", "SYN", "ETB", "CAN", "EM", "SUB", "ESC", "FS", "GS", "RS", "US". These mnemonics come from the early days of signaling, though some are still used (LF = Line Feed, BS = Back Space, CR = Carriage Return, for example).
'You can choose to replace these mnemonics by a nominated symbol with an ASCII code in the range 32 to 255. If you set a symbol value less than 32, all control characters are displayed as mnemonics. The symbol you set is rendered in the font of the style set for the character. You can read back the current symbol with the SCI_GETCONTROLCHARSYMBOL message. The default symbol value is 0.
Public Sub SetControlCharSymbol(ByVal Symbol As Long)
    SendEditor SCI_SETCONTROLCHARSYMBOL, Symbol, CLng(0)
End Sub

Public Function GetControlCharSymbol() As Long
    GetControlCharSymbol = SendEditor(SCI_GETCONTROLCHARSYMBOL, CLng(0), CLng(0))
End Function

'SCI_SETCARETSTICKY(bool useCaretStickyBehaviour)
'SCI_GETCARETSTICKY
'SCI_TOGGLECARETSTICKY
'These messages set, get or toggle the caretSticky flag which controls when the last position of the caret on the line is saved. When set to true, the position is not saved when you type a character, a tab, paste the clipboard content or press backspace.

Public Sub SetCaretSticky(ByVal useCaretStickyBehaviour As Boolean)
    SendEditor SCI_SETCARETSTICKY, SciBool(useCaretStickyBehaviour), CLng(0)
End Sub

Public Function GetCaretSticky() As Long
    GetCaretSticky = SendEditor(SCI_GETCARETSTICKY, CLng(0), CLng(0))
End Function

Public Sub ToggleCaretSticky()
    SendEditor SCI_TOGGLECARETSTICKY, CLng(0), CLng(0)
End Sub

'====================================================================
'           Margins
'====================================================================
'There may be up to three margins to the left of the text display, plus a gap either side of the text. Each margin can be set to display either symbols or line numbers with SCI_SETMARGINTYPEN. The markers that can be displayed in each margin are set with SCI_SETMARGINMASKN. Any markers not associated with a visible margin will be displayed as changes in background colour in the text. A width in pixels can be set for each margin. Margins with a zero width are ignored completely. You can choose if a mouse click in a margin sends a SCN_MARGINCLICK notification to the container or selects a line of text.

'The margins are numbered 0 to 2. Using a margin number outside the valid range has no effect. By default, margin 0 is set to display line numbers, but is given a width of 0, so it is hidden. Margin 1 is set to display non-folding symbols and is given a width of 16 pixels, so it is visible. Margin 2 is set to display the folding symbols, but is given a width of 0, so it is hidden. Of course, you can set the margins to be whatever you wish.

'SCI_SETMARGINTYPEN(int margin, int iType)
'SCI_GETMARGINTYPEN(int margin)
'These two routines set and get the type of a margin. The margin argument should be 0, 1 or 2. You can use the predefined constants SC_MARGIN_SYMBOL (0) and SC_MARGIN_NUMBER (1) to set a margin as either a line number or a symbol margin. By convention, margin 0 is used for line numbers and the other two are used for symbols.
Public Sub SetMarginTypeN(ByVal Margin As Long, ByVal iType As Long)
    SendEditor SCI_SETMARGINTYPEN, Margin, iType
End Sub

Public Function GetMarginTypeN(ByVal Margin As Long) As Long
    GetMarginTypeN = SendEditor(SCI_GETMARGINTYPEN, CLng(0), CLng(0))
End Function

'SCI_SETMARGINWIDTHN(int margin, int pixelWidth)
'SCI_GETMARGINWIDTHN(int margin)
'These routines set and get the width of a margin in pixels. A margin with zero width is invisible. By default, Scintilla sets margin 1 for symbols with a width of 16 pixels, so this is a reasonable guess if you are not sure what would be appropriate. Line number margins widths should take into account the number of lines in the document and the line number style. You could use something like SCI_TEXTWIDTH(STYLE_LINENUMBER, "_99999") to get a suitable width.

Public Sub SetMarginWidthN(ByVal Margin As Long, ByVal PixelWidth As Long)
    SendEditor SCI_SETMARGINWIDTHN, Margin, PixelWidth
End Sub

Public Function GetMarginWidthN(ByVal Margin As Long) As Long
    GetMarginWidthN = SendEditor(SCI_GETMARGINWIDTHN, CLng(0), CLng(0))
End Function

'SCI_SETMARGINMASKN(int margin, int mask)
'SCI_GETMARGINMASKN(int margin)
'The mask is a 32-bit value. Each bit corresponds to one of 32 logical symbols that can be displayed in a margin that is enabled for symbols. There is a useful constant, SC_MASK_FOLDERS (0xFE000000 or -33554432), that is a mask for the 7 logical symbols used to denote folding. You can assign a wide range of symbols and colours to each of the 32 logical symbols, see Markers for more information. If (mask & SC_MASK_FOLDERS)==0, the margin background colour is controlled by style 33 (STYLE_LINENUMBER).
'You add logical markers to a line with SCI_MARKERADD. If a line has an associated marker that does not appear in the mask of any margin with a non-zero width, the marker changes the background colour of the line. For example, suppose you decide to use logical marker 10 to mark lines with a syntax error and you want to show such lines by changing the background colour. The mask for this marker is 1 shifted left 10 times (1<<10) which is 0x400. If you make sure that no symbol margin includes 0x400 in its mask, any line with the marker gets the background colour changed.
'To set a non-folding margin 1 use SCI_SETMARGINMASKN(1, ~SC_MASK_FOLDERS); to set a folding margin 2 use SCI_SETMARGINMASKN(2, SC_MASK_FOLDERS). This is the default set by Scintilla. ~SC_MASK_FOLDERS is 0x1FFFFFF in hexadecimal or 33554431 decimal. Of course, you may need to display all 32 symbols in a margin, in which case use SCI_SETMARGINMASKN(margin, -1).
Public Sub SetMarginMaskN(ByVal Margin As Long, ByVal Mask As Long)
    SendEditor SCI_SETMARGINMASKN, Margin, Mask
End Sub

Public Function GetMarginMaskN(ByVal Margin As Long) As Long
    GetMarginMaskN = SendEditor(SCI_GETMARGINMASKN, CLng(0), CLng(0))
End Function


'SCI_SETMARGINSENSITIVEN(int margin, bool sensitive)
'SCI_GETMARGINSENSITIVEN(int margin)
'Each of the three margins can be set sensitive or insensitive to mouse clicks. A click in a sensitive margin sends a SCN_MARGINCLICK notification to the container. Margins that are not sensitive act as selection margins which make it easy to select ranges of lines. By default, all margins are insensitive.
Public Sub SetMarginSensitiveN(ByVal Margin As Long, ByVal Sensitive As Boolean)
    SendEditor SCI_SETMARGINSENSITIVEN, Margin, SciBool(Sensitive)
End Sub

Public Function GetMarginSensitiveN(ByVal Margin As Long) As Long
    GetMarginSensitiveN = SendEditor(SCI_GETMARGINSENSITIVEN, CLng(0), CLng(0))
End Function

'SCI_SETMARGINLEFT(<unused>, int pixels)
'SCI_GETMARGINLEFT
'SCI_SETMARGINRIGHT(<unused>, int pixels)
'SCI_GETMARGINRIGHT
'These messages set and get the width of the blank margin on both sides of the text in pixels. The default is to one pixel on each side.

Public Sub SetMarginLeft(ByVal lPixels As Long)
    SendEditor SCI_SETMARGINLEFT, CLng(0), lPixels
End Sub

Public Function GetMarginLeft() As Long
    GetMarginLeft = SendEditor(SCI_GETMARGINLEFT, CLng(0), CLng(0))
End Function

Public Sub SetMarginRight(ByVal lPixels As Long)
    SendEditor SCI_SETMARGINRIGHT, CLng(0), lPixels
End Sub

Public Function GetMarginRight() As Long
    GetMarginRight = SendEditor(SCI_GETMARGINRIGHT, CLng(0), CLng(0))
End Function

'SCI_SETFOLDMARGINCOLOUR(bool useSetting, int colour)
'SCI_SETFOLDMARGINHICOLOUR(bool useSetting, int colour)
'These messages allow changing the colour of the fold margin and fold margin highlight. On Windows the fold margin colour defaults to ::GetSysColor(COLOR_3DFACE) and the fold margin highlight colour to ::GetSysColor(COLOR_3DHIGHLIGHT).
Public Sub SetFoldMarginColour(ByVal useSetting As Boolean, ByVal Colour As Long)
    SendEditor SCI_SETFOLDMARGINCOLOUR, SciBool(useSetting), Colour
End Sub

Public Sub SetFoldMarginHiColour(ByVal useSetting As Boolean, ByVal Colour As Long)
    SendEditor SCI_SETFOLDMARGINHICOLOUR, SciBool(useSetting), Colour
End Sub


'====================================================================
'           Other settings
'====================================================================
'SCI_SETUSEPALETTE(bool allowPaletteUse)
'SCI_GETUSEPALETTE
'On 8 bit displays, which can only display a maximum of 256 colours, the graphics environment mediates between the colour needs of applications through the use of palettes. On GTK+, Scintilla always uses a palette.
'
'On Windows, there are some problems with visual flashing when switching between applications with palettes and it is also necessary for the application containing the Scintilla control to forward some messages to Scintilla for its palette code to work. Because of this, by default, the palette is not used and the application must tell Scintilla to use one. If Scintilla is not using a palette, it will only display in those colours already available, which are often the 20 Windows system colours.
'
'To see an example of how to enable palette support in Scintilla, search the text of SciTE for WM_PALETTECHANGED, WM_QUERYNEWPALETTE and SCI_SETUSEPALETTE. The Windows messages to forward are:
'WM_SYSCOLORCHANGE, WM_PALETTECHANGED, WM_QUERYNEWPALETTE (should return TRUE).
'
'To forward a message (WM_XXXX, WPARAM, LPARAM) to Scintilla, you can use SendMessage(hScintilla, WM_XXXX, WPARAM, LPARAM) where hScintilla is the handle to the Scintilla window you created as your editor.
'
'While we are on the subject of forwarding messages in Windows, the top level window should forward any WM_SETTINGCHANGE messages to Scintilla (this is currently used to collect changes to mouse settings, but could be used for other user interface items in the future).
Public Sub SetUsePalette(ByVal allowPaletteUse As Boolean)
    SendEditor SCI_SETUSEPALETTE, SciBool(allowPaletteUse), CLng(0)
End Sub

Public Function GetUsePalette() As Boolean
    GetUsePalette = MakeBool(SendEditor(SCI_GETUSEPALETTE, CLng(0), CLng(0)))
End Function

'SCI_SETBUFFEREDDRAW(bool isBuffered)
'SCI_GETBUFFEREDDRAW
'These messages turn buffered drawing on or off and report the buffered drawing state. Buffered drawing draws each line into a bitmap rather than directly to the screen and then copies the bitmap to the screen. This avoids flickering although it does take longer. The default is for drawing to be buffered.
Public Sub SetBufferedDraw(ByVal isBuffered As Boolean)
    SendEditor SCI_SETBUFFEREDDRAW, SciBool(isBuffered), CLng(0)
End Sub

Public Function GetBufferedDraw() As Boolean
    GetBufferedDraw = MakeBool(SendEditor(SCI_GETBUFFEREDDRAW, CLng(0), CLng(0)))
End Function

'SCI_SETTWOPHASEDRAW(bool twoPhase)
'SCI_GETTWOPHASEDRAW
'Two phase drawing is a better but slower way of drawing text. In single phase drawing each run of characters in one style is drawn along with its background. If a character overhangs the end of a run, such as in "V_" where the "V" is in a different style from the "_", then this can cause the right hand side of the "V" to be overdrawn by the background of the "_" which cuts it off. Two phase drawing fixes this by drawing all the backgrounds first and then drawing the text in transparent mode. Two phase drawing may flicker more than single phase unless buffered drawing is on. The default is for drawing to be two phase.
Public Sub SetTwoPhaseDraw(ByVal twoPhase As Boolean)
    SendEditor SCI_SETTWOPHASEDRAW, SciBool(twoPhase), CLng(0)
End Sub

Public Function GetTwoPhaseDraw() As Boolean
    GetTwoPhaseDraw = MakeBool(SendEditor(SCI_GETTWOPHASEDRAW, CLng(0), CLng(0)))
End Function

'SCI_SETCODEPAGE(int codePage)
'SCI_GETCODEPAGE
'Scintilla has some support for Japanese, Chinese and Korean DBCS. Use this message with codePage set to the code page number to set Scintilla to use code page information to ensure double byte characters are treated as one character rather than two. This also stops the caret from moving between the two bytes in a double byte character. Call with codePage set to zero to disable DBCS support. The default is SCI_SETCODEPAGE(0).
'
'Code page SC_CP_UTF8 (65001) sets Scintilla into Unicode mode with the document treated as a sequence of characters expressed in UTF-8. The text is converted to the platform's normal Unicode encoding before being drawn by the OS and thus can display Hebrew, Arabic, Cyrillic, and Han characters. Languages which can use two characters stacked vertically in one horizontal space, such as Thai, will mostly work but there are some issues where the characters are drawn separately leading to visual glitches. Bi-directional text is not supported.
'
'On Windows, code page can be set to 932 (Japanese Shift-JIS), 936 (Simplified Chinese GBK), 949 (Korean), and 950 (Traditional Chinese Big5) although these may require installation of language specific support.
'
'On GTK+, code page SC_CP_DBCS (1) sets Scintilla into multi byte character mode as is required for Japanese language processing with the EUC encoding.
'
'For GTK+, the locale should be set to a Unicode locale with a call similar to setlocale(LC_CTYPE, "en_US.UTF-8"). Fonts with an "iso10646" registry should be used in a font set. Font sets are a comma separated list of partial font specifications where each partial font specification can be in the form: foundry-fontface-charsetregistry-encoding or fontface-charsetregistry-encoding or foundry-fontface or fontface. An example is "misc-fixed-iso10646-1,*".
'
'Setting codePage to a non-zero value that is not SC_CP_UTF8 is operating system dependent.
Public Sub SetCodePage(ByVal codePage As Long)
    SendEditor SCI_SETCODEPAGE, codePage, CLng(0)
End Sub

Public Function GetCodePage() As Long
    GetCodePage = SendEditor(SCI_GETCODEPAGE, CLng(0), CLng(0))
End Function

'SCI_SETWORDCHARS(<unused>, const char *chars)
'Scintilla has several functions that operate on words, which are defined to be contiguous sequences of characters from a particular set of characters. This message defines which characters are members of that set. The character sets are set to default values before processing this function. For example, if you don't allow '_' in your set of characters use:
'SCI_SETWORDCHARS(0, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
Public Sub SetWordChars(ByVal wordChars As String)
    Dim sStr As String
    sStr = StrConv(wordChars, vbFromUnicode) & Chr(0)
    SendMessageString Sci, SCI_SETWORDCHARS, CLng(0), ByVal StrPtr(sStr)
End Sub

'SCI_SETWHITESPACECHARS(<unused>, const char *chars)
'Similar to SCI_SETWORDCHARS, this message allows the user to define which chars Scintilla considers as whitespace. Setting the whitespace chars allows the user to fine-tune Scintilla's behaviour doing such things as moving the cursor to the start or end of a word; for example, by defining punctuation chars as whitespace, they will be skipped over when the user presses ctrl+left or ctrl+right. This function should be called after SCI_SETWORDCHARS as it will reset the whitespace characters to the default set.
Public Sub SetWhiteSpaceChars(ByVal whitespaceChars As String)
    Dim sStr As String
    sStr = StrConv(whitespaceChars, vbFromUnicode) & Chr(0)
    Call SendMessageString(Sci, SCI_SETWHITESPACECHARS, CLng(0), ByVal StrPtr(sStr))
End Sub

'SCI_SETCHARSDEFAULT
'Use the default sets of word and whitespace characters. This sets whitespace to space, tab and other characters with codes less than 0x20, with word characters set to alphanumeric and '_'.
Public Sub SetCharsDefault()
    SendEditor SCI_SETCHARSDEFAULT, CLng(0), CLng(0)
End Sub

'SCI_GRABFOCUS
'SCI_SETFOCUS(bool focus)
'SCI_GETFOCUS
'On GTK+, focus handling is more complicated than on Windows, so Scintilla can be told with this message to grab the focus.
'The internal focus flag can be set with SCI_SETFOCUS. This is used by clients that have complex focus requirements such as having their own window that gets the real focus but with the need to indicate that Scintilla has the logical focus.
Public Sub GrabFocus()
    SendEditor SCI_GRABFOCUS, CLng(0), CLng(0)
End Sub

Public Sub SetFocusFlag(ByVal bFocus As Boolean)
    SendEditor SCI_SETFOCUS, SciBool(bFocus), CLng(0)
End Sub

Public Function GetFocusFlag() As Boolean
    GetFocusFlag = MakeBool(SendEditor(SCI_GETFOCUS, CLng(0), CLng(0)))
End Function


'====================================================================
'           Brace highlighting
'====================================================================
'SCI_BRACEHIGHLIGHT(int pos1, int pos2)
'Up to two characters can be highlighted in a 'brace highlighting style', which is defined as style number STYLE_BRACELIGHT (34). If you have enabled indent guides, you may also wish to highlight the indent that corresponds with the brace. You can locate the column with SCI_GETCOLUMN and highlight the indent with SCI_SETHIGHLIGHTGUIDE.
Public Sub BraceHighLight(ByVal Pos1 As Long, ByVal Pos2 As Long)
    SendEditor SCI_BRACEHIGHLIGHT, Pos1, Pos2
End Sub

'SCI_BRACEBADLIGHT(int pos1)
'If there is no matching brace then the brace badlighting style, style BRACE_BADLIGHT (35), can be used to show the brace that is unmatched. Using a position of INVALID_POSITION (-1) removes the highlight.
Public Sub BraceBadLight(ByVal Pos1 As Long)
    SendEditor SCI_BRACEBADLIGHT, Pos1, CLng(0)
End Sub

'SCI_BRACEMATCH(int pos, int maxReStyle)
'The SCI_BRACEMATCH message finds a corresponding matching brace given pos, the position of one brace. The brace characters handled are '(', ')', '[', ']', '{', '}', '<', and '>'. The search is forwards from an opening brace and backwards from a closing brace. If the character at position is not a brace character, or a matching brace cannot be found, the return value is -1. Otherwise, the return value is the position of the matching brace.
'A match only occurs if the style of the matching brace is the same as the starting brace or the matching brace is beyond the end of styling. Nested braces are handled correctly. The maxReStyle parameter must currently be 0 - it may be used in the future to limit the length of brace searches.
Public Function BraceMatch(ByVal Pos As Long) As Long
    BraceMatch = SendEditor(SCI_BRACEMATCH, Pos, CLng(0))
End Function

'====================================================================
'           Tabs and Indentation Guides
'====================================================================

'====================================================================
'====================================================================
'               Tabs and Indentation Guides
'====================================================================
'SCI_SETTABWIDTH(int widthInChars)
'SCI_GETTABWIDTH

'SCI_SETUSETABS(bool useTabs)
'SCI_GETUSETABS
'SCI_SETINDENT(int widthInChars)
'SCI_GETINDENT
'SCI_SETTABINDENTS(bool tabIndents)
'SCI_GETTABINDENTS
'SCI_SETBACKSPACEUNINDENTS(bool bsUnIndents)
'SCI_GETBACKSPACEUNINDENTS
'SCI_SETLINEINDENTATION(int line, int indentation)
'SCI_GETLINEINDENTATION(int line)
'SCI_GETLINEINDENTPOSITION(int line)
'SCI_SETINDENTATIONGUIDES(bool view)
'SCI_GETINDENTATIONGUIDES
'SCI_SETHIGHLIGHTGUIDE(int column)
'SCI_GETHIGHLIGHTGUIDE

'SCI_SETTABWIDTH(int widthInChars)
'SCI_GETTABWIDTH
'SCI_SETTABWIDTH sets the size of a tab as a multiple of the size of a space character in STYLE_DEFAULT. The default tab width is 8 characters. There are no limits on tab sizes, but values less than 1 or large values may have undesirable effects.
Public Sub SetTabWidth(ByVal lValue As Long)
    If lValue < 0 Then Exit Sub
    SendEditor SCI_SETTABWIDTH, lValue, CLng(0)
End Sub

Public Function GetTabWidth() As Long
    GetTabWidth = SendEditor(SCI_GETTABWIDTH, CLng(0), CLng(0))
End Function

Public Property Get TabWidth() As Long
    'TabWidth = SendEditor(SCI_GETTABWIDTH, CLng(0), CLng(0))
    TabWidth = m_lTabWidth
End Property

Public Property Let TabWidth(ByVal lWidth As Long)
    
    If lWidth > 0 Then
        SendEditor SCI_SETTABWIDTH, lWidth, CLng(0)
        m_lTabWidth = lWidth
        PropertyChanged "TabWidth"
    End If
    
End Property

'SCI_SETUSETABS(bool useTabs)
'SCI_GETUSETABS
'SCI_SETUSETABS determines whether indentation should be created out of a mixture of tabs and spaces or be based purely on spaces. Set useTabs to false (0) to create all tabs and indents out of spaces. The default is true. You can use SCI_GETCOLUMN to get the column of a position taking the width of a tab into account.
Public Sub SetUseTabs(ByVal bValue As Boolean)
    SendEditor SCI_SETUSETABS, SciBool(bValue), CLng(0)
End Sub

Public Function GetUseTabs() As Boolean
    GetUseTabs = MakeBool(SendEditor(SCI_GETUSETABS, CLng(0), CLng(0)))
End Function

'SCI_SETINDENT(int widthInChars)
'SCI_GETINDENT
'SCI_SETINDENT sets the size of indentation in terms of the width of a space in STYLE_DEFAULT. If you set a width of 0, the indent size is the same as the tab size. There are no limits on indent sizes, but values less than 0 or large values may have undesirable effects.
Public Sub SetIndent(ByVal lValue As Long)
    If lValue < 0 Then Exit Sub
    SendEditor SCI_SETINDENT, lValue, CLng(0)
End Sub

Public Function GetIndent() As Long
    GetIndent = SendEditor(SCI_GETINDENT, CLng(0), CLng(0))
End Function

'SCI_SETTABINDENTS(bool tabIndents)
'SCI_GETTABINDENTS
'SCI_SETBACKSPACEUNINDENTS(bool bsUnIndents)
'SCI_GETBACKSPACEUNINDENTS
'Inside indentation white space, the tab and backspace keys can be made to indent and unindent rather than insert a tab character or delete a character with the SCI_SETTABINDENTS and SCI_SETBACKSPACEUNINDENTS functions.
Public Sub SetTabIndents(ByVal bValue As Boolean)
    SendEditor SCI_SETTABINDENTS, SciBool(bValue), CLng(0)
End Sub

Public Function GetTabIndents() As Boolean
    GetTabIndents = MakeBool(SendEditor(SCI_GETTABINDENTS, CLng(0), CLng(0)))
End Function

Public Sub SetBackspaceUnIndents(ByVal bValue As Boolean)
    SendEditor SCI_SETBACKSPACEUNINDENTS, SciBool(bValue), CLng(0)
End Sub

Public Function GetBackspaceUnIndents() As Boolean
    GetBackspaceUnIndents = MakeBool(SendEditor(SCI_GETBACKSPACEUNINDENTS, CLng(0), CLng(0)))
End Function

'SCI_SETLINEINDENTATION(int line, int indentation)
'SCI_GETLINEINDENTATION(int line)
'The amount of indentation on a line can be discovered and set with SCI_GETLINEINDENTATION and SCI_SETLINEINDENTATION. The indentation is measured in character columns, which correspond to the width of space characters.
Public Sub SetLineIndentation(ByVal lLine As Long, ByVal lIndentation As Long)
    SendEditor SCI_SETLINEINDENTATION, lLine, lIndentation
End Sub

Public Function GetLineIndentation(ByVal lLine As Long) As Long
    GetLineIndentation = SendEditor(SCI_GETLINEINDENTATION, lLine, CLng(0))
End Function

'SCI_GETLINEINDENTPOSITION(int line)
'This returns the position at the end of indentation of a line.
Public Function GetLineIndentPosition(ByVal lLine As Long) As Long
    GetLineIndentPosition = SendEditor(SCI_GETLINEINDENTPOSITION, lLine, CLng(0))
End Function

'SCI_SETINDENTATIONGUIDES(bool view)
'SCI_GETINDENTATIONGUIDES
'Indentation guides are dotted vertical lines that appear within indentation white space every indent size columns. They make it easy to see which constructs line up especially when they extend over multiple pages. Style STYLE_INDENTGUIDE (37) is used to specify the foreground and background colour of the indentation guides.
Public Sub SetIndentationGuides(ByVal bValue As Boolean)
    SendEditor SCI_SETINDENTATIONGUIDES, SciBool(bValue), CLng(0)
End Sub

Public Function GetIndentationGuides() As Boolean
    GetIndentationGuides = MakeBool(SendEditor(SCI_GETINDENTATIONGUIDES, CLng(0), CLng(0)))
End Function

'SCI_SETHIGHLIGHTGUIDE(int column)
'SCI_GETHIGHLIGHTGUIDE
'When brace highlighting occurs, the indentation guide corresponding to the braces may be highlighted with the brace highlighting style, STYLE_BRACELIGHT (34). Set column to 0 to cancel this highlight.
Public Sub SetHighlightGuide(ByVal lColumn As Long)
    If lColumn < 0 Then Exit Sub
    SendEditor SCI_SETHIGHLIGHTGUIDE, lColumn, CLng(0)
End Sub

Public Function GetHighlightGuide() As Long
    GetHighlightGuide = SendEditor(SCI_GETHIGHLIGHTGUIDE, CLng(0), CLng(0))
End Function

'====================================================================
'               Markers
'====================================================================
'There are 32 markers, numbered 0 to 31, and you can assign any combination of them to each line in the document. Markers appear in the selection margin to the left of the text. If the selection margin is set to zero width, the background colour of the whole line is changed instead. Marker numbers 25 to 31 are used by Scintilla in folding margins, and have symbolic names of the form SC_MARKNUM_*, for example SC_MARKNUM_FOLDEROPEN.
'
'Marker numbers 0 to 24 have no pre-defined function; you can use them to mark syntax errors or the current point of execution, break points, or whatever you need marking. If you do not need folding, you can use all 32 for any purpose you wish.
'
'Each marker number has a symbol associated with it. You can also set the foreground and background colour for each marker number, so you can use the same symbol more than once with different colouring for different uses. Scintilla has a set of symbols you can assign (SC_MARK_*) or you can use characters. By default, all 32 markers are set to SC_MARK_CIRCLE with a black foreground and a white background.
'
'The markers are drawn in the order of their numbers, so higher numbered markers appear on top of lower numbered ones. Markers try to move with their text by tracking where the start of their line moves. When a line is deleted, its markers are combined, by an OR operation, with the markers of the previous line.

'SCI_MARKERDEFINE(int markerNumber, int markerSymbols)
'This message associates a marker number in the range 0 to 31 with one of the marker symbols or an ASCII character. The general-purpose marker symbols currently available are:
'SC_MARK_CIRCLE, SC_MARK_ROUNDRECT, SC_MARK_ARROW, SC_MARK_SMALLRECT, SC_MARK_SHORTARROW, SC_MARK_EMPTY, SC_MARK_ARROWDOWN, SC_MARK_MINUS, SC_MARK_PLUS, SC_MARK_ARROWS, SC_MARK_DOTDOTDOT, SC_MARK_EMPTY, SC_MARK_BACKGROUND and SC_MARK_FULLRECT.
Public Sub MarkerDefine(ByVal markerNumber As Long, ByVal markerSymbols As Long)
    SendEditor SCI_MARKERDEFINE, markerNumber, markerSymbols
End Sub

'SCI_MARKERDEFINEPIXMAP(int markerNumber, const char *xpm)
'ToDo

'SCI_MARKERSETFORE(int markerNumber, int colour)
'SCI_MARKERSETBACK(int markerNumber, int colour)
'These two messages set the foreground and background colour of a marker number.

Public Sub MarkerSetFore(ByVal markerNumber As Long, ByVal markerColor As Long)
    SendEditor SCI_MARKERSETFORE, markerNumber, markerColor
End Sub

Public Sub MarkerSetBack(ByVal markerNumber As Long, ByVal markerColor As Long)
    SendEditor SCI_MARKERSETBACK, markerNumber, markerColor
End Sub

'SCI_MARKERADD(int line, int markerNumber)
'This message adds marker number markerNumber to a line. The message returns -1 if this fails (illegal line number, out of memory) or it returns a marker handle number that identifies the added marker. You can use this returned handle with SCI_MARKERLINEFROMHANDLE to find where a marker is after moving or combining lines and with SCI_MARKERDELETEHANDLE to delete the marker based on its handle. The message does not check the value of markerNumber, nor does it check if the line already contains the marker.
Public Function MarkerAdd(ByVal lineNumber As Long, ByVal markerNumber As Long) As Long
    MarkerAdd = SendEditor(SCI_MARKERADD, lineNumber, markerNumber)
End Function

'SCI_MARKERDELETE(int line, int markerNumber)
'This searches the given line number for the given marker number and deletes it if it is present. If you added the same marker more than once to the line, this will delete one copy each time it is used. If you pass in a marker number of -1, all markers are deleted from the line.
Public Sub MarkerDelete(ByVal lineNumber As Long, ByVal markerNumber As Long)
    SendEditor SCI_MARKERDELETE, lineNumber, markerNumber
End Sub

'SCI_MARKERDELETEALL(int markerNumber)
'This removes markers of the given number from all lines. If markerNumber is -1, it deletes all markers from all lines.
Public Sub MarkerDeleteAll(ByVal markerNumber As Long)
    SendEditor SCI_MARKERDELETEALL, markerNumber, CLng(0)
End Sub

'SCI_MARKERGET(int line)
'This returns a 32-bit integer that indicates which markers were present on the line. Bit 0 is set if marker 0 is present, bit 1 for marker 1 and so on.
Public Function MarkerGet(ByVal lineNumber As Long) As Long
    MarkerGet = SendEditor(SCI_MARKERGET, lineNumber, CLng(0))
End Function


'SCI_MARKERNEXT(int lineStart, int markerMask)
'SCI_MARKERPREVIOUS(int lineStart, int markerMask)
'These messages search efficiently for lines that include a given set of markers. The search starts at line number lineStart and continues forwards to the end of the file (SCI_MARKERNEXT) or backwards to the start of the file (SCI_MARKERPREVIOUS). The markerMask argument should have one bit set for each marker you wish to find. Set bit 0 to find marker 0, bit 1 for marker 1 and so on. The message returns the line number of the first line that contains one of the markers in markerMask or -1 if no marker is found.
Public Function MarkerNext(ByVal lineStart As Long, ByVal markerMask As Long) As Long
    MarkerNext = SendEditor(SCI_MARKERNEXT, lineStart, markerMask)
End Function

Public Function MarkerPrevious(ByVal lineStart As Long, ByVal markerMask As Long) As Long
    MarkerPrevious = SendEditor(SCI_MARKERPREVIOUS, lineStart, markerMask)
End Function

'SCI_MARKERLINEFROMHANDLE(int markerHandle)
'The markerHandle argument is an identifier for a marker returned by SCI_MARKERADD. This function searches the document for the marker with this handle and returns the line number that contains it or -1 if it is not found.
Public Function MarkerLineFromHandle(ByVal markerHandle As Long) As Long
    MarkerLineFromHandle = SendEditor(SCI_MARKERLINEFROMHANDLE, markerHandle, CLng(0))
End Function

'SCI_MARKERDELETEHANDLE(int markerHandle)
'The markerHandle argument is an identifier for a marker returned by SCI_MARKERADD. This function searches the document for the marker with this handle and deletes the marker if it is found.
Public Sub MarkerDeleteHandle(ByVal markerHandle As Long)
    SendEditor SCI_MARKERDELETEHANDLE, markerHandle, CLng(0)
End Sub

'====================================================================
'           Indicators
'====================================================================
'By default, Scintilla organizes the style byte associated with each text byte as 5 bits of style information (for 32 styles) and 3 bits of indicator information for 3 independent indicators so that, for example, syntax errors, deprecated names and bad indentation could all be displayed at once. Indicators may be displayed as simple underlines, squiggly underlines, a line of small 'T' shapes, a line of diagonal hatching, a strike-out or a rectangle around the text.
'The indicators are set using SCI_STARTSTYLING with a INDICS_MASK mask and SCI_SETSTYLING with the values INDIC0_MASK, INDIC1_MASK and INDIC2_MASK.
'If you are using indicators in a buffer that has a lexer active (see SCI_SETLEXER), you must save lexing state information before setting any indicators and restore it afterwards. Use SCI_GETENDSTYLED to retrieve the current "styled to" position and SCI_STARTSTYLING to reset the styling position and mask (0x1f in the default layout of 5 style bits and 3 indicator bits) when you are done.
'The number of bits used for styles can be altered with SCI_SETSTYLEBITS from 0 to 7 bits. The remaining bits can be used for indicators, so there can be from 1 to 8 indicators. However, the INDIC*_MASK constants defined in Scintilla.h all assume 5 bits of styling information and 3 indicators. If you use a different arrangement, you must define your own constants.
'The SCI_INDIC* messages allow you to get and set the visual appearance of the indicators. They all use an indicatorNumber argument in the range 0 to 7 to set the indicator to style. With the default settings, only indicators 0, 1 and 2 will have any visible effect.

'SCI_INDICSETSTYLE(int indicatorNumber, int indicatorStyle)
'SCI_INDICGETSTYLE(int indicatorNumber)
'These two messages set and get the style for a particular indicator. The indicator styles currently available are:
'
'Symbol Value Visual effect
'INDIC_PLAIN 0 Underlined with a single, straight line.
'INDIC_SQUIGGLE 1 A squiggly underline.
'INDIC_TT 2 A line of small T shapes.
'INDIC_DIAGONAL 3 Diagonal hatching.
'INDIC_STRIKE 4 Strike out.
'INDIC_HIDDEN 5 An indicator with no visual effect.
'INDIC_BOX 6 A rectangle around the text.
'
'The default indicator styles are equivalent to:
'SCI_INDICSETSTYLE(0, INDIC_SQUIGGLE);
'SCI_INDICSETSTYLE(1, INDIC_TT);
'SCI_INDICSETSTYLE(2, INDIC_PLAIN);

Public Sub IndicSetStyle(ByVal indicatorNumber As Long, ByVal indicatorStyle As Long)
    SendEditor SCI_INDICSETSTYLE, indicatorNumber, indicatorStyle
End Sub

Public Function IndicGetStyle(ByVal indicatorNumber As Long) As Long
    IndicGetStyle = SendEditor(SCI_INDICGETSTYLE, indicatorNumber, CLng(0))
End Function

'SCI_INDICSETFORE(int indicatorNumber, int colour)
'SCI_INDICGETFORE(int indicatorNumber)
'These two messages set and get the colour used to draw an indicator. The default indicator colours are equivalent to:
'SCI_INDICSETFORE(0, 0x007f00); (dark green)
'SCI_INDICSETFORE(1, 0xff0000); (light blue)
'SCI_INDICSETFORE(2, 0x0000ff); (light red)

Public Sub IndicSetFore(ByVal indicatorNumber As Long, ByVal indicatorColor As Long)
    SendEditor SCI_INDICSETFORE, indicatorNumber, indicatorColor
End Sub

Public Function IndicGetFore(ByVal indicatorNumber As Long) As Long
    IndicGetFore = SendEditor(SCI_INDICGETFORE, indicatorNumber, CLng(0))
End Function

'====================================================================
'           Call tips
'====================================================================
'SCI_CALLTIPSHOW(int posStart, const char *definition)
'This message starts the process by displaying the call tip window. If a call tip is already active, this has no effect.
'posStart is the position in the document at which to align the call tip. The call tip text is aligned to start 1 line below this character.
'definition is the call tip text. This can contain multiple lines separated by '\n' (Line Feed, ASCII code 10) characters.
'
Public Sub CallTipShow(tip As String, Optional hltstart As Long, Optional hltend As Long)
    Dim Pos As Long
    Pos = SendEditor(SCI_GETCURRENTPOS, 0, 0)   'We obtain the position of the cursor
    SendEditor SCI_CALLTIPSHOW, Pos, tip
    If hltstart >= 0 And hltend > hltstart Then
        SendEditor SCI_CALLTIPSETHLT, hltstart, hltend
    End If
End Sub

Public Sub ShowCallTip(sTip As String)
    Dim bByte() As Byte
    Str2Byte sTip, bByte
    SendEditor SCI_CALLTIPSHOW, Me.GetCurrentPos, VarPtr(bByte(0))
End Sub

'SCI_CALLTIPCANCEL
'This message cancels any displayed call tip. Scintilla will also cancel call tips for you if you use any keyboard commands that are not compatible with editing the argument list of a function.
Public Sub CallTipCancel()
    SendEditor SCI_CALLTIPCANCEL, CLng(0), CLng(0)
End Sub

'SCI_CALLTIPACTIVE
'This returns 1 if a call tip is active and 0 if it is not active.
Public Function CallTipActive() As Boolean
    CallTipActive = MakeBool(SendEditor(SCI_CALLTIPACTIVE, CLng(0), CLng(0)))
End Function

'SCI_CALLTIPPOSSTART
'This message returns the value of the current position when SCI_CALLTIPSHOW started to display the tip.
Public Function CallTipPosStart() As Long
    CallTipPosStart = SendEditor(SCI_CALLTIPPOSSTART, CLng(0), CLng(0))
End Function

'SCI_CALLTIPSETHLT(int hlStart, int hlEnd)
'This sets the region of the call tips text to display in a highlighted style. hlStart is the zero-based index into the string of the first character to highlight and hlEnd is the index of the first character after the highlight. hlEnd must be greater than hlStart; hlEnd-hlStart is the number of characters to highlight. Highlights can extend over line ends if this is required.
'Unhighlighted text is drawn in a mid gray. Selected text is drawn in a dark blue. The background is white. These can be changed with SCI_CALLTIPSETBACK, SCI_CALLTIPSETFORE, and SCI_CALLTIPSETFOREHLT.
Public Sub CallTipSetHlt(ByVal hlStart As Long, ByVal hlEnd As Long)
    SendEditor SCI_CALLTIPSETHLT, hlStart, hlEnd
End Sub


'SCI_CALLTIPSETBACK(int colour)
'The background colour of call tips can be set with this message; the default colour is white. It is not a good idea to set a dark colour as the background as the unselected text is drawn in mid gray and the selected text in a dark blue.
Public Sub CallTipSetBack(ByVal Colour As Long)
    SendEditor SCI_CALLTIPSETBACK, Colour, CLng(0)
End Sub

Public Property Get CallTipBackColor() As OLE_COLOR
    CallTipBackColor = m_CallTipBackColor
End Property

Public Property Let CallTipBackColor(ByVal Colour As OLE_COLOR)
    m_CallTipBackColor = MakeColor(Colour)
    SendEditor SCI_CALLTIPSETBACK, m_CallTipBackColor, CLng(0)
    PropertyChanged "CallTipBackColor"
End Property

'SCI_CALLTIPSETFORE(int colour)
'The colour of call tip text can be set with this message; the default colour is mid gray.
Public Sub CallTipSetFore(ByVal Colour As Long)
    SendEditor SCI_CALLTIPSETFORE, Colour, CLng(0)
End Sub

Public Property Get CallTipForeColor() As OLE_COLOR
    CallTipForeColor = m_CallTipForeColor
End Property

Public Property Let CallTipForeColor(ByVal Colour As OLE_COLOR)
    m_CallTipForeColor = MakeColor(Colour)
    SendEditor SCI_CALLTIPSETFORE, m_CallTipForeColor, CLng(0)
    PropertyChanged "CallTipForeColor"
End Property

'SCI_CALLTIPSETFOREHLT(int colour)
'The colour of highlighted call tip text can be set with this message; the default colour is dark blue.
Public Sub CallTipSetForeHlt(ByVal Colour As Long)
    SendEditor SCI_CALLTIPSETFOREHLT, Colour, CLng(0)
End Sub

Public Property Get CallTipHltColor() As OLE_COLOR
    CallTipHltColor = m_CallTipHltColor
End Property

Public Property Let CallTipHltColor(ByVal Colour As OLE_COLOR)
    m_CallTipHltColor = MakeColor(Colour)
    SendEditor SCI_CALLTIPSETFOREHLT, m_CallTipHltColor, CLng(0)
    PropertyChanged "CallTipHltColor"
End Property


'====================================================================
'====================================================================
'====================================================================
'               Keyboard commands
'====================================================================
'To allow the container application to perform any of the actions available
'to the user with keyboard, all the keyboard actions are messages.
'They do not take any parameters. These commands are also used when redefining
'the key bindings with the SCI_ASSIGNCMDKEY message.

Public Sub KeyCmd(ByVal Command As Long)
    SendEditor Command, CLng(0), CLng(0)
End Sub

'====================================================================
'               Start Keyboard commands
'====================================================================
Public Sub KeyLineDown()
    SendEditor SCI_LINEDOWN, CLng(0), CLng(0)
End Sub

Public Sub KeyLineDownExtend()
    SendEditor SCI_LINEDOWNEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyLineDownRectExtend()
    SendEditor SCI_LINEDOWNRECTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyLineScrollDown()
    SendEditor SCI_LINESCROLLDOWN, CLng(0), CLng(0)
End Sub

Public Sub KeyLineUp()
    SendEditor SCI_LINEUP, CLng(0), CLng(0)
End Sub

Public Sub KeyLineUpExtend()
    SendEditor SCI_LINEUPEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyLineUpRectExtend()
    SendEditor SCI_LINEUPRECTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyLineScrollUp()
    SendEditor SCI_LINESCROLLUP, CLng(0), CLng(0)
End Sub

Public Sub KeyParaDown()
    SendEditor SCI_PARADOWN, CLng(0), CLng(0)
End Sub

Public Sub KeyParaDownExtend()
    SendEditor SCI_PARADOWNEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyParaUp()
    SendEditor SCI_PARAUP, CLng(0), CLng(0)
End Sub

Public Sub KeyParaUpExtend()
    SendEditor SCI_PARAUPEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyCharLeft()
    SendEditor SCI_CHARLEFT, CLng(0), CLng(0)
End Sub

Public Sub KeyCharLeftExtend()
    SendEditor SCI_CHARLEFTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyCharLeftRectExtend()
    SendEditor SCI_CHARLEFTRECTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyCharRight()
    SendEditor SCI_CHARRIGHT, CLng(0), CLng(0)
End Sub

Public Sub KeyCharRightExtend()
    SendEditor SCI_CHARRIGHTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyCharRightRectExtend()
    SendEditor SCI_CHARRIGHTRECTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyWordLeft()
    SendEditor SCI_WORDLEFT, CLng(0), CLng(0)
End Sub

Public Sub KeyWordLeftExtend()
    SendEditor SCI_WORDLEFTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyWordRight()
    SendEditor SCI_WORDRIGHT, CLng(0), CLng(0)
End Sub

Public Sub KeyWordRightExtend()
    SendEditor SCI_WORDRIGHTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyWordLeftEnd()
    SendEditor SCI_WORDLEFTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyWordLeftEndExtend()
    SendEditor SCI_WORDLEFTENDEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyWordRightEnd()
    SendEditor SCI_WORDRIGHTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyWordRightEndExtend()
    SendEditor SCI_WORDRIGHTENDEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyWordPartLeft()
    SendEditor SCI_WORDPARTLEFT, CLng(0), CLng(0)
End Sub

Public Sub KeyWordPartLeftExtend()
    SendEditor SCI_WORDPARTLEFTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyWordPartRight()
    SendEditor SCI_WORDPARTRIGHT, CLng(0), CLng(0)
End Sub

Public Sub KeyWordPartRightExtend()
    SendEditor SCI_WORDPARTRIGHTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyHome()
    SendEditor SCI_HOME, CLng(0), CLng(0)
End Sub

Public Sub KeyHomeExtend()
    SendEditor SCI_HOMEEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyHomeRectExtend()
    SendEditor SCI_HOMERECTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyHomeDisplay()
    SendEditor SCI_HOMEDISPLAY, CLng(0), CLng(0)
End Sub

Public Sub KeyHomeDisplayExtend()
    SendEditor SCI_HOMEDISPLAYEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyHomeWrap()
    SendEditor SCI_HOMEWRAP, CLng(0), CLng(0)
End Sub

Public Sub KeyHomeWrapExtend()
    SendEditor SCI_HOMEWRAPEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyVCHome()
    SendEditor SCI_VCHOME, CLng(0), CLng(0)
End Sub

Public Sub KeyVCHomeExtend()
    SendEditor SCI_VCHOMEEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyVCHomeRectExtend()
    SendEditor SCI_VCHOMERECTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyVCHomeWrap()
    SendEditor SCI_VCHOMEWRAP, CLng(0), CLng(0)
End Sub

Public Sub KeyVCHomeWrapExtend()
    SendEditor SCI_VCHOMEWRAPEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyLineEnd()
    SendEditor SCI_LINEEND, CLng(0), CLng(0)
End Sub

Public Sub KeyLineEndExtend()
    SendEditor SCI_LINEENDEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyLineEndRectExtend()
    SendEditor SCI_LINEENDRECTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyLineEndDisplay()
    SendEditor SCI_LINEENDDISPLAY, CLng(0), CLng(0)
End Sub

Public Sub KeyLineEndDisplayExtend()
    SendEditor SCI_LINEENDDISPLAYEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyLineEndWrap()
    SendEditor SCI_LINEENDWRAP, CLng(0), CLng(0)
End Sub

Public Sub KeyLineEndWrapExtend()
    SendEditor SCI_LINEENDWRAPEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyDocumentStart()
    SendEditor SCI_DOCUMENTSTART, CLng(0), CLng(0)
End Sub

Public Sub KeyDocumentStartExtend()
    SendEditor SCI_DOCUMENTSTARTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyDocumentEnd()
    SendEditor SCI_DOCUMENTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyDocumentEndExtend()
    SendEditor SCI_DOCUMENTENDEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyPageUp()
    SendEditor SCI_PAGEUP, CLng(0), CLng(0)
End Sub

Public Sub KeyPageUpExtend()
    SendEditor SCI_PAGEUPEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyPageUpRectExtend()
    SendEditor SCI_PAGEUPRECTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyPageDown()
    SendEditor SCI_PAGEDOWN, CLng(0), CLng(0)
End Sub

Public Sub KeyPageDownExtend()
    SendEditor SCI_PAGEDOWNEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyPageDownRectExtend()
    SendEditor SCI_PAGEDOWNRECTEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyStutteredPageUp()
    SendEditor SCI_STUTTEREDPAGEUP, CLng(0), CLng(0)
End Sub

Public Sub KeyStutteredPageUpExtend()
    SendEditor SCI_STUTTEREDPAGEUPEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyStutteredPageDown()
    SendEditor SCI_STUTTEREDPAGEDOWN, CLng(0), CLng(0)
End Sub

Public Sub KeyStutteredPageDownExtend()
    SendEditor SCI_STUTTEREDPAGEDOWNEXTEND, CLng(0), CLng(0)
End Sub

Public Sub KeyDeleteBack()
    SendEditor SCI_DELETEBACK, CLng(0), CLng(0)
End Sub

Public Sub KeyDeleteBackNotLine()
    SendEditor SCI_DELETEBACKNOTLINE, CLng(0), CLng(0)
End Sub

Public Sub KeyDelWordLeft()
    SendEditor SCI_DELWORDLEFT, CLng(0), CLng(0)
End Sub

Public Sub KeyDelWordRight()
    SendEditor SCI_DELWORDRIGHT, CLng(0), CLng(0)
End Sub

Public Sub KeyDelLineLeft()
    SendEditor SCI_DELLINELEFT, CLng(0), CLng(0)
End Sub

Public Sub KeyDelLineRight()
    SendEditor SCI_DELLINERIGHT, CLng(0), CLng(0)
End Sub

Public Sub KeyLineDelete()
    SendEditor SCI_LINEDELETE, CLng(0), CLng(0)
End Sub

Public Sub KeyLineCut()
    SendEditor SCI_LINECUT, CLng(0), CLng(0)
End Sub

Public Sub KeyLineCopy()
    SendEditor SCI_LINECOPY, CLng(0), CLng(0)
End Sub

Public Sub KeyLineTranspose()
    SendEditor SCI_LINETRANSPOSE, CLng(0), CLng(0)
End Sub

Public Sub KeyLineDuplicate()
    SendEditor SCI_LINEDUPLICATE, CLng(0), CLng(0)
End Sub

Public Sub KeyLowerCase()
    SendEditor SCI_LOWERCASE, CLng(0), CLng(0)
End Sub

Public Sub KeyUpperCase()
    SendEditor SCI_UPPERCASE, CLng(0), CLng(0)
End Sub

Public Sub KeyCancel()
    SendEditor SCI_CANCEL, CLng(0), CLng(0)
End Sub

Public Sub KeyEditToggleOverType()
    SendEditor SCI_EDITTOGGLEOVERTYPE, CLng(0), CLng(0)
End Sub

Public Sub KeyNewLine()
    SendEditor SCI_NEWLINE, CLng(0), CLng(0)
End Sub

Public Sub KeyFormFeed()
    SendEditor SCI_FORMFEED, CLng(0), CLng(0)
End Sub

Public Sub KeyTab()
    SendEditor SCI_TAB, CLng(0), CLng(0)
End Sub

Public Sub KeyBackTab()
    SendEditor SCI_BACKTAB, CLng(0), CLng(0)
End Sub
'====================================================================
'               End Keyboard commands
'====================================================================
'====================================================================
'               Key bindings
'====================================================================

'SCI_ASSIGNCMDKEY(int keyDefinition, int sciCommand)
'This assigns the given key definition to a Scintilla command identified by sciCommand. sciCommand can be any SCI_* command that has no arguments.
Public Sub AssignCmdKey(ByVal keyDefinition As Long, ByVal Command As Long)
    SendEditor SCI_ASSIGNCMDKEY, keyDefinition, Command
End Sub

'SCI_CLEARCMDKEY(int keyDefinition)
'This makes the given key definition do nothing by assigning the action SCI_NULL to it.
Public Sub ClearCmdKey(ByVal keyDefinition As Long)
    SendEditor SCI_CLEARCMDKEY, keyDefinition, CLng(0)
End Sub

'SCI_CLEARALLCMDKEYS
'This command removes all keyboard command mapping by setting an empty mapping table.
Public Sub CearAllCmdKeys()
    SendEditor SCI_CLEARALLCMDKEYS, CLng(0), CLng(0)
End Sub

'SCI_NULL
'The SCI_NULL does nothing and is the value assigned to keys that perform no action.
Public Sub NullCmd()
    SendEditor SCI_NULL, CLng(0), CLng(0)
End Sub

'====================================================================
'               Popup edit menu
'====================================================================
'SCI_USEPOPUP(bool bEnablePopup)
'Clicking the wrong button on the mouse pops up a short default editing menu. This may be turned off with SCI_USEPOPUP(0). If you turn it off, context menu commands (in Windows, WM_CONTEXTMENU) will not be handled by Scintilla, so the parent of the Scintilla window will have the opportunity to handle the message.
Public Sub UsePopUp(ByVal bValue As Boolean)
    SendEditor SCI_USEPOPUP, SciBool(bValue), CLng(0)
End Sub

' It heightens the parenthesis arms... -*
Public Property Get MatchBraces() As Boolean
    MatchBraces = m_MatchBraces
End Property

Public Property Let MatchBraces(vNewValue As Boolean)
    m_MatchBraces = vNewValue
    PropertyChanged "MatchBraces"
End Property

' It gives back the character located in ' position' -*
Public Function CharAtPos(Position As Long) As Long
    CharAtPos = SendEditor(SCI_GETCHARAT, Position, CLng(0))
End Function

'It gives back true if the code ' ch' corresponds a ( or ) or [ or ] or < or >
Private Function IsBrace(ch As Long) As Boolean
    IsBrace = (ch = 40 Or ch = 41 Or ch = 60 Or ch = 62 Or ch = 91 Or ch = 93 Or ch = 123 Or ch = 125)
End Function

' Visualization of the horizontal bar of displacement -*
Public Property Get HScrollBar() As Boolean
    HScrollBar = m_bHScrollBar
End Property

Public Property Let HScrollBar(ByVal bHScrollBar As Boolean)
    m_bHScrollBar = bHScrollBar
    SendEditor SCI_SETHSCROLLBAR, SciBool(bHScrollBar)
    PropertyChanged "HScrollBar"
End Property

Public Property Get IndGuides() As Boolean
    IndGuides = m_bIndGuides
End Property

Public Property Let IndGuides(ByVal bIndGuides As Boolean)
    m_bIndGuides = bIndGuides
    SendEditor SCI_SETINDENTATIONGUIDES, SciBool(bIndGuides)
    PropertyChanged "IndGuides"
End Property

' It gives back the column of the present position -*
Public Function Column() As Long
    Column = SendEditor(SCI_GETCOLUMN, Me.GetCurrentPos, CLng(0))
End Function

Public Function GetCurColumn() As Long
    GetCurColumn = SendEditor(SCI_GETCOLUMN, Me.GetCurrentPos, CLng(0)) + 1
End Function

'====================================================================
'====================================================================
'SCN_SAVEPOINTREACHED
'SCN_SAVEPOINTLEFT
'Sent to the container when the save point is entered or left, allowing
'the container to display a "document dirty" indicator and change its menus.
'See also: SCI_SETSAVEPOINT , SCI_GETMODIFY

'SCI_SETSAVEPOINT
'This message tells Scintilla that the current state of the document is unmodified. This is usually done when the file is saved or loaded, hence the name "save point". As Scintilla performs undo and redo operations, it notifies the container that it has entered or left the save point with SCN_SAVEPOINTREACHED and SCN_SAVEPOINTLEFT notification messages, allowing the container to know if the file should be considered dirty or not.
Public Sub SetSavePoint()
    SendEditor SCI_SETSAVEPOINT, CLng(0), CLng(0)
End Sub

Public Function GetCurrentLineLength() As Long
    GetCurrentLineLength = Me.LineLength(Me.GetCurrentLineNumber())
End Function

Public Function GetCurrentLineCartPosition() As Long
    
    Dim lLength As Long
    Dim lCurPosition As Long
    Dim sBuffer As String
    
    lLength = Me.GetCurrentLineLength()
    sBuffer = String(lLength + 1, Chr(0))
    lCurPosition = SendMessageString(Sci, SCI_GETCURLINE, Len(sBuffer), sBuffer)
    GetCurrentLineCartPosition = lCurPosition
 
End Function

Public Function GetCurrentLineText() As String
    
    Dim lLength As Long
    Dim lCurPosition As Long
    Dim sBuffer As String
    Dim sText As String
    
    lLength = Me.GetCurrentLineLength()
    sBuffer = String(lLength + 1, Chr(0))
    lCurPosition = SendMessageString(Sci, SCI_GETCURLINE, Len(sBuffer), sBuffer)
    sText = Mid(sBuffer, 1, lLength)
    GetCurrentLineText = sText
 
End Function

'====================================================================
'               Folding
'====================================================================
'SCI_VISIBLEFROMDOCLINE(int docLine)
'When some lines are folded, then a particular line in the document may be displayed at a different position to its document position. If no lines are folded, this message returns docLine. Otherwise, this returns the display line (counting the very first visible line as 0). The display line of an invisible line is the same as the previous visible line. The display line number of the first line in the document is 0. If there is folding and docLine is outside the range of lines in the document, the return value is -1. Lines can occupy more than one display line if they wrap.
Public Function VisibleFromDocLine(ByVal docLine As Long) As Long
    VisibleFromDocLine = SendEditor(SCI_VISIBLEFROMDOCLINE, docLine, CLng(0))
End Function

'SCI_DOCLINEFROMVISIBLE(int displayLine)
'When some lines are hidden, then a particular line in the document may be displayed at a different position to its document position. This message returns the document line number that corresponds to a display line (counting the display line of the first line in the document as 0). If displayLine is less than or equal to 0, the result is 0. If displayLine is greater than or equal to the number of displayed lines, the result is the number of lines in the document.
Public Function DocLineFromVisible(ByVal displayLine As Long) As Long
    DocLineFromVisible = SendEditor(SCI_DOCLINEFROMVISIBLE, displayLine, CLng(0))
End Function

'SCI_SHOWLINES(int lineStart, int lineEnd)
'SCI_HIDELINES(int lineStart, int lineEnd)
'SCI_GETLINEVISIBLE(int line)
'The first two messages mark a range of lines as visible or invisible and then redraw the display. The third message reports on the visible state of a line and returns 1 if it is visible and 0 if it is not visible. These messages have no effect on fold levels or fold flags.
Public Sub ShowLines(ByVal lineStart As Long, ByVal lineEnd As Long)
    SendEditor SCI_SHOWLINES, lineStart, lineEnd
End Sub

Public Sub HideLines(ByVal lineStart As Long, ByVal lineEnd As Long)
    SendEditor SCI_HIDELINES, lineStart, lineEnd
End Sub

Public Function GetLineVisible(ByVal lineNumber As Long) As Boolean
    GetLineVisible = MakeBool(SendEditor(SCI_GETLINEVISIBLE, lineNumber, CLng(0)))
End Function

'SCI_SETFOLDLEVEL(int line, int level)
'SCI_GETFOLDLEVEL(int line)
'These two messages set and get a 32-bit value that contains the fold level of a line and some flags associated with folding. The fold level is a number in the range 0 to SC_FOLDLEVELNUMBERMASK (4095). However, the initial fold level is set to SC_FOLDLEVELBASE (1024) to allow unsigned arithmetic on folding levels. There are two addition flag bits. SC_FOLDLEVELWHITEFLAG indicates that the line is blank and allows it to be treated slightly different then its level may indicate. For example, blank lines should generally not be fold points. SC_FOLDLEVELHEADERFLAG indicates that the line is a header (fold point).
'Use SCI_GETFOLDLEVEL(line) & SC_FOLDLEVELNUMBERMASK to get the fold level of a line. Likewise, use SCI_GETFOLDLEVEL(line) & SC_FOLDLEVEL*FLAG to get the state of the flags. To set the fold level you must or in the associated flags. For instance, to set the level to thisLevel and mark a line as being a fold point use: SCI_SETFOLDLEVEL(line, thisLevel | SC_FOLDLEVELHEADERFLAG).
'If you use a lexer, you should not need to use SCI_SETFOLDLEVEL as this is far better handled by the lexer. You will need to use SCI_GETFOLDLEVEL to decide how to handle user folding requests. If you do change the fold levels, the folding margin will update to match your changes.
Public Sub SetFoldLevel(ByVal lLine As Long, ByVal lLevel As Long)
    SendEditor SCI_SETFOLDLEVEL, lLine, lLevel
End Sub

Public Function GetFoldLevel(ByVal lLine As Long) As Long
    GetFoldLevel = SendEditor(SCI_GETFOLDLEVEL, lLine, CLng(0))
End Function

'SCI_SETFOLDFLAGS(int flags)
'In addition to showing markers in the folding margin, you can indicate folds to the user by drawing lines in the text area. The lines are drawn in the foreground colour set for STYLE_DEFAULT. Bits set in flags determine where folding lines are drawn:
'value Effect
'1 Experimental - draw boxes if expanded
'2 Draw above if expanded
'4 Draw above if not expanded
'8 Draw below if expanded
'16 Draw below if not expanded
'64 display hexadecimal fold levels in line margin to aid debugging of folding. This feature needs to be redesigned to be sensible.
'This message causes the display to redraw.
Public Sub SetFoldFlags(ByVal flags As Long)
    SendEditor SCI_SETFOLDFLAGS, flags, CLng(0)
End Sub

'SCI_GETLASTCHILD(int startLine, int level)
'This message searches for the next line after startLine, that has a folding level that is less than or equal to level and then returns the previous line number. If you set level to -1, level is set to the folding level of line startLine. If from is a fold point, SCI_GETLASTCHILD(from, -1) returns the last line that would be in made visible or hidden by toggling the fold state.
Public Function GetLastChild(ByVal startLine As Long, ByVal lLevel As Long) As Long
    GetLastChild = SendEditor(SCI_GETLASTCHILD, startLine, lLevel)
End Function


'SCI_GETFOLDPARENT(int startLine)
'This message returns the line number of the first line before startLine that is marked as a fold point with SC_FOLDLEVELHEADERFLAG and has a fold level less than the startLine. If no line is found, or if the header flags and fold levels are inconsistent, the return value is -1.
Public Function GetFoldParent(ByVal startLine As Long) As Long
    GetFoldParent = SendEditor(SCI_GETFOLDPARENT, startLine, CLng(0))
End Function

'SCI_TOGGLEFOLD(int line)
'Each fold point may be either expanded, displaying all its child lines, or contracted, hiding all the child lines. This message toggles the folding state of the given line as long as it has the SC_FOLDLEVELHEADERFLAG set. This message takes care of folding or expanding all the lines that depend on the line. The display updates after this message.
Public Sub ToggleFold(ByVal lLine As Long)
    SendEditor SCI_TOGGLEFOLD, lLine, CLng(0)
End Sub

'SCI_SETFOLDEXPANDED(int line, bool expanded)
'SCI_GETFOLDEXPANDED(int line)
'These messages set and get the expanded state of a single line. The set message has no effect on the visible state of the line or any lines that depend on it. It does change the markers in the folding margin. If you ask for the expansion state of a line that is outside the document, the result is false (0).
'If you just want to toggle the fold state of one line and handle all the lines that are dependent on it, it is much easier to use SCI_TOGGLEFOLD. You would use the SCI_SETFOLDEXPANDED message to process many folds without updating the display until you had finished. See SciTEBase::FoldAll() and SciTEBase::Expand() for examples of the use of these messages.
Public Sub SetFoldExpanded(ByVal lLine As Long, ByVal bExpaned As Boolean)
    SendEditor SCI_SETFOLDEXPANDED, lLine, bExpaned
End Sub

Public Function GetFoldExpanded(ByVal lLine As Long) As Long
    GetFoldExpanded = SendEditor(SCI_GETFOLDEXPANDED, lLine, CLng(0))
End Function

'SCI_ENSUREVISIBLE(int line)
'SCI_ENSUREVISIBLEENFORCEPOLICY(int line)
'A line may be hidden because more than one of its parent lines is contracted. Both these message travels up the fold hierarchy, expanding any contracted folds until they reach the top level. The line will then be visible. If you use SCI_ENSUREVISIBLEENFORCEPOLICY, the vertical caret policy set by SCI_SETVISIBLEPOLICY is then applied.
Public Sub EnsureVisible(ByVal lLine As Long)
    SendEditor SCI_ENSUREVISIBLE, lLine, CLng(0)
End Sub

Public Sub EnsureVisibleEnforcePolicy(ByVal lLine As Long)
    SendEditor SCI_ENSUREVISIBLEENFORCEPOLICY, lLine, CLng(0)
End Sub


'====================================================================
'               Line wrapping
'====================================================================
'SCI_SETWRAPMODE(int wrapMode)
'SCI_GETWRAPMODE
'Set wrapMode to SC_WRAP_WORD (1) to enable wrapping on word boundaries, SC_WRAP_CHAR (2) to enable wrapping between any characters, and to SC_WRAP_NONE (0) to disable line wrapping. SC_WRAP_CHAR is preferred to SC_WRAP_WORD for Asian languages where there is no white space between words.
Public Sub SetWrapMode(ByVal WrapMode As Long)
    SendEditor SCI_SETWRAPMODE, WrapMode, CLng(0)
End Sub

Public Function GetWrapMode() As Long
    GetWrapMode = SendEditor(SCI_GETWRAPMODE, CLng(0), CLng(0))
End Function

Public Property Get WrapMode() As WrapMode
    'WrapMode = SendEditor(SCI_GETWRAPMODE, CLng(0), CLng(0))
    WrapMode = m_lWrapMode
End Property

Public Property Let WrapMode(ByVal lWrapMode As WrapMode)
    SendEditor SCI_SETWRAPMODE, lWrapMode, CLng(0)
    m_lWrapMode = lWrapMode
    PropertyChanged "WrapMode"
End Property

'SCI_SETWRAPVISUALFLAGS(int wrapVisualFlags)
'SCI_GETWRAPVISUALFLAGS
'You can enable the drawing of visual flags to indicate a line is wrapped. Bits set in wrapVisualFlags determine which visual flags are drawn. Symbol Value Effect
'SC_WRAPVISUALFLAG_NONE 0 No visual flags
'SC_WRAPVISUALFLAG_END 1 Visual flag at end of subline of a wrapped line.
'SC_WRAPVISUALFLAG_START 2 Visual flag at begin of subline of a wrapped line.
'Subline is indented by at least 1 to make room for the flag.
Public Sub SetWrapVisualFlags(ByVal wrapVisualFlags As Long)
    SendEditor SCI_SETWRAPVISUALFLAGS, wrapVisualFlags, CLng(0)
End Sub

Public Function GetWrapVisualFlags() As Long
    GetWrapVisualFlags = SendEditor(SCI_GETWRAPVISUALFLAGS, CLng(0), CLng(0))
End Function
 
'SCI_SETWRAPVISUALFLAGSLOCATION(int wrapVisualFlagsLocation)
'SCI_GETWRAPVISUALFLAGSLOCATION
'You can set wether the visual flags to indicate a line is wrapped are drawn near the border or near the text. Bits set in wrapVisualFlagsLocation set the location to near the text for the corresponding visual flag. Symbol Value Effect
'SC_WRAPVISUALFLAGLOC_DEFAULT 0 Visual flags drawn near border
'SC_WRAPVISUALFLAGLOC_END_BY_TEXT 1 Visual flag at end of subline drawn near text
'SC_WRAPVISUALFLAGLOC_START_BY_TEXT 2 Visual flag at begin of subline drawn near text
Public Sub SetWrapVisualFlagsLocation(ByVal wrapVisualFlagsLocation As Long)
    SendEditor SCI_SETWRAPVISUALFLAGSLOCATION, wrapVisualFlagsLocation, CLng(0)
End Sub

Public Function GetWrapVisualFlagsLocation() As Long
    GetWrapVisualFlagsLocation = SendEditor(SCI_GETWRAPVISUALFLAGSLOCATION, CLng(0), CLng(0))
End Function

'SCI_SETWRAPSTARTINDENT(int indent)
'SCI_GETWRAPSTARTINDENT
'SCI_SETWRAPSTARTINDENT sets the size of indentation of sublines for wrapped lines in terms of the width of a space in STYLE_DEFAULT. There are no limits on indent sizes, but values less than 0 or large values may have undesirable effects.
'The indention of sublines is independent of visual flags, but if SC_WRAPVISUALFLAG_START is set an indent of at least 1 is used.
Public Sub SetWrapStartIndent(ByVal indent As Long)
    SendEditor SCI_SETWRAPSTARTINDENT, indent, CLng(0)
End Sub

Public Function GetWrapStartIndent() As Long
    GetWrapStartIndent = SendEditor(SCI_GETWRAPSTARTINDENT, CLng(0), CLng(0))
End Function

'SCI_SETLAYOUTCACHE(int cacheMode)
'SCI_GETLAYOUTCACHE
'You can set cacheMode to one of the symbols in the table:
'
'Symbol Value Layout cached for these lines
'SC_CACHE_NONE 0 No lines are cached.
'SC_CACHE_CARET 1 The line containing the text caret. This is the default.
'SC_CACHE_PAGE 2 Visible lines plus the line containing the caret.
'SC_CACHE_DOCUMENT 3 All lines in the document.
Public Sub SetLayoutCache(ByVal cacheMode As Long)
    SendEditor SCI_SETLAYOUTCACHE, cacheMode, CLng(0)
End Sub

Public Function GetLayoutCache() As Long
    GetLayoutCache = SendEditor(SCI_GETLAYOUTCACHE, CLng(0), CLng(0))
End Function

'SCI_LINESSPLIT(int pixelWidth)
'Split a range of lines indicated by the target into lines that are at most pixelWidth wide. Splitting occurs on word boundaries wherever possible in a similar manner to line wrapping. When pixelWidth is 0 then the width of the window is used.
Public Sub LinesSplit()
    SendEditor SCI_TARGETFROMSELECTION, CLng(0), CLng(0)
    SendEditor SCI_LINESSPLIT, CLng(0), CLng(0)
End Sub

Public Sub LinesSplitWidth(ByVal PixelWidth As Long)
    SendEditor SCI_TARGETFROMSELECTION, CLng(0), CLng(0)
    SendEditor SCI_LINESSPLIT, PixelWidth, CLng(0)
End Sub

'SCI_LINESJOIN
'Join a range of lines indicated by the target into one line by removing line end characters. Where this would lead to no space between words, an extra space is inserted.
Public Sub LinesJoin()
    SendEditor SCI_TARGETFROMSELECTION, CLng(0), CLng(0)
    SendEditor SCI_LINESJOIN, CLng(0), CLng(0)
End Sub

'SCI_WRAPCOUNT(int docLine)
'Document lines can occupy more than one display line if they wrap and this returns the number of display lines needed to wrap a document line.
Public Function WrapCount(ByVal docLine As Long) As Long
    WrapCount = SendEditor(SCI_WRAPCOUNT, docLine, CLng(0))
End Function

'====================================================================
'               Zooming
'====================================================================
'Scintilla incorporates a "zoom factor" that lets you make all the text in the document larger or smaller in steps of one point. The displayed point size never goes below 2, whatever zoom factor you set. You can set zoom factors in the range -10 to +20 points.

'SCI_ZOOMIN
'SCI_ZOOMOUT
'SCI_ZOOMIN increases the zoom factor by one point if the current zoom factor is less than 20 points. SCI_ZOOMOUT decreases the zoom factor by one point if the current zoom factor is greater than -10 points.
Public Sub ZoomIn()
    SendEditor SCI_ZOOMIN, CLng(0), CLng(0)
End Sub

Public Sub ZoomOut()
    SendEditor SCI_ZOOMOUT, CLng(0), CLng(0)
End Sub

'SCI_SETZOOM(int zoomInPoints)
'SCI_GETZOOM
'These messages let you set and get the zoom factor directly. There is no limit set on the factors you can set, so limiting yourself to -10 to +20 to match the incremental zoom functions is a good idea.
Public Sub SetZoom(ByVal zoomInPoints As Long)
    SendEditor SCI_SETZOOM, zoomInPoints, CLng(0)
End Sub

Public Function GetZoom() As Long
    GetZoom = SendEditor(SCI_GETZOOM, CLng(0), CLng(0))
End Function

'====================================================================
'           Long lines
'====================================================================
'You can choose to mark lines that exceed a given length by drawing a vertical line or by colouring the background of characters that exceed the set length.

'SCI_SETEDGEMODE(int edgeMode)
'SCI_GETEDGEMODE
'These two messages set and get the mode used to display long lines. You can set one of the values in the table:
'
'Symbol Value Long line display mode
'EDGE_NONE 0 Long lines are not marked. This is the default state.
'EDGE_LINE 1 A vertical line is drawn at the column number set by SCI_SETEDGECOLUMN. This works well for monospaced fonts. The line is drawn at a position based on the width of a space character in STYLE_DEFAULT, so it may not work very well if your styles use proportional fonts or if your style have varied font sizes or you use a mixture of bold, italic and normal text. .
'EDGE_BACKGROUND 2 The background colour of characters after the column limit is changed to the colour set by SCI_SETEDGECOLOUR. This is recommended for proportional fonts.
Public Sub SetEdgeMode(ByVal EdgeMode As EdgeMode)
    SendEditor SCI_SETEDGEMODE, EdgeMode, CLng(0)
End Sub

Public Function GetEdgeMode() As Long
    GetEdgeMode = SendEditor(SCI_GETEDGEMODE, CLng(0), CLng(0))
End Function

'SCI_SETEDGECOLUMN(int column)
'SCI_GETEDGECOLUMN
'These messages set and get the column number at which to display the long line marker. When drawing lines, the column sets a position in units of the width of a space character in STYLE_DEFAULT. When setting the background colour, the column is a character count (allowing for tabs) into the line.
Public Sub SetEdgeColumn(ByVal columnNumber As Long)
    SendEditor SCI_SETEDGECOLUMN, columnNumber, CLng(0)
End Sub

Public Function GetEdgeColumn() As Long
    GetEdgeColumn = SendEditor(SCI_GETEDGECOLUMN, CLng(0), CLng(0))
End Function

'SCI_SETEDGECOLOUR(int colour)
'SCI_GETEDGECOLOUR
'These messages set and get the colour of the marker used to show that a line has exceeded the length set by SCI_SETEDGECOLUMN.

Public Sub SetEdgeColour(ByVal Colour As Long)
    SendEditor SCI_SETEDGECOLOUR, Colour, CLng(0)
End Sub

Public Function GetEdgeColour() As Long
    GetEdgeColour = SendEditor(SCI_GETEDGECOLOUR, CLng(0), CLng(0))
End Function

'====================================================================
'               Lexer
'====================================================================
'SCI_SETLEXER(int lexer)
'SCI_GETLEXER
'You can select the lexer to use with an integer code from the SCLEX_* enumeration in Scintilla.h. There are two codes in this sequence that do not use lexers: SCLEX_NULL to select no lexing action and SCLEX_CONTAINER which sends the SCN_STYLENEEDED notification to the container whenever a range of text needs to be styled. You cannot use the SCLEX_AUTOMATIC value; this identifies additional external lexers that Scintilla assigns unused lexer numbers to.
Public Sub SetLexer(ByVal Lexer As LexerCode)
    SendEditor SCI_SETLEXER, Lexer, CLng(0)
End Sub

Public Function GetLexer() As LexerCode
    GetLexer = SendEditor(SCI_GETLEXER, CLng(0), CLng(0))
End Function

Public Property Get Lexer() As LexerCode
    'Lexer = SendEditor(SCI_GETLEXER, CLng(0), CLng(0))
    Lexer = m_lLexer
End Property

Public Property Let Lexer(ByVal lLexer As LexerCode)
    SendEditor SCI_SETLEXER, lLexer, CLng(0)
    'm_lLexer = SendEditor(SCI_GETLEXER, CLng(0), CLng(0))
    m_lLexer = lLexer
    PropertyChanged "Lexer"
End Property

'SCI_SETLEXERLANGUAGE(<unused>, const char *name)
'This message lets you select a lexer by name, and is the only method if you are using an external lexer or if you have written a lexer module for a language of your own and do not wish to assign it an explicit lexer number. To select an existing lexer, set name to match the (case sensitive) name given to the module, for example "ada" or "python", not "Ada" or "Python". To locate the name for the built-in lexers, open the relevant Lex*.cxx file and search for LexerModule. The third argument in the LexerModule constructor is the name to use.
'To test if your lexer assignment worked, use SCI_GETLEXER before and after setting the new lexer to see if the lexer number changed.
Public Sub SetLexerLanguage(ByVal LexerName As String)
    SendMessageAny Sci, SCI_SETLEXERLANGUAGE, CLng(0), ByVal LexerName
End Sub

'SCI_LOADLEXERLIBRARY(<unused>, const char *path)
'Load a lexer implemented in a shared library. This is a .so file on GTK+/Linux or a .DLL file on Windows.
Public Sub LoadLexarLibrary(ByVal LexerPath As String)
    SendMessageAny Sci, SCI_LOADLEXERLIBRARY, CLng(0), ByVal LexerPath
End Sub

'SCI_COLOURISE(int startPos, int endPos)
'This requests the current lexer or the container (if the lexer is set to SCLEX_CONTAINER) to style the document between startPos and endPos. If endPos is -1, the document is styled from startPos to the end. If the "fold" property is set to "1" and your lexer or container supports folding, fold levels are also set. This message causes a redraw.
Public Sub Colourise(ByVal startPos As Long, ByVal endPos As Long)
    SendEditor SCI_COLOURISE, startPos, endPos
End Sub

'SCI_SETPROPERTY(const char *key, const char *value)
'You can communicate settings to lexers with keyword:value string pairs. There is no limit to the number of keyword pairs you can set, other than available memory. key is a case sensitive keyword, value is a string that is associated with the keyword. If there is already a value string associated with the keyword, it is replaced. If you pass a zero length string, the message does nothing. Both key and value are used without modification; extra spaces at the beginning or end of key are significant.
'The value string can refer to other keywords. For example, SCI_SETPROPERTY("foldTimes10", "$(fold)0") stores the string "$(fold)0", but when this is accessed, the $(fold) is replaced by the value of the "fold" keyword (or by nothing if this keyword does not exist).
'Currently the "fold" property is defined for most of the lexers to set the fold structure if set to "1". SCLEX_PYTHON understands "tab.timmy.whinge.level" as a setting that determines how to indicate bad indentation. Most keywords have values that are interpreted as integers. Search the lexer sources for GetPropertyInt to see how properties are used.
Public Sub SetProperty(sKey As String, sValue As String)
        
    SendMessageAny Sci, SCI_SETPROPERTY, ByVal sKey, ByVal sValue
    
'    Dim bKey() As Byte
'    Dim bValue() As Byte
'    bKey = StrConv(sKey, vbFromUnicode)
'    ReDim Preserve bKey(0 To UBound(bKey) + 1) As Byte
'    bValue = StrConv(sValue, vbFromUnicode)
'    ReDim Preserve bValue(0 To UBound(bValue) + 1) As Byte
'    SendMessage sci, SCI_SETPROPERTY, ByVal VarPtr(bKey(0)), ByVal VarPtr(bValue(0))
    
End Sub

Public Sub SetPropertyB(key As String, value As String)
  Dim l1 As Long, l2 As Long
  Dim bKey() As Byte
  bKey = StrConv(key, vbFromUnicode)
  ReDim Preserve bKey(0 To UBound(bKey) + 1) As Byte
  Dim bValue() As Byte
  bValue = StrConv(value, vbFromUnicode)
  ReDim Preserve bValue(0 To UBound(bValue) + 1) As Byte
  SendMessage Sci, SCI_SETPROPERTY, ByVal VarPtr(bKey(0)), ByVal VarPtr(bValue(0))
End Sub

'SCI_GETPROPERTY(const char *key, char *value)
'Lookup a keyword:value pair using the specified key; if found, copy the value to the user-supplied buffer and return the length (not including the terminating 0). If not found, copy an empty string to the buffer and return 0.
'
'Note that "keyword replacement" as described in SCI_SETPROPERTY will not be performed.
'
'If the value argument is 0 then the length that should be allocated to store the value is returned; again, the terminating 0 is not included.
Public Function GetProperty(sKey As String) As String

'    Dim bKey() As Byte
'
'    bKey = StrConv(sKey, vbFromUnicode)
'    ReDim Preserve bKey(0 To UBound(bKey) + 1) As Byte
'
'    Dim bValue() As Byte
'    Dim Value As String
'
'    Value = String(2000, Chr(0))
'    bValue = StrConv(Value, vbFromUnicode)
'
'    ReDim Preserve bValue(0 To UBound(bValue) + 1) As Byte
'
'    Dim lLength As Long
'
'    lLength = SendMessage(sci, SCI_GETPROPERTY, ByVal VarPtr(bKey(0)), ByVal VarPtr(bValue(0)))
    
    'Debug.Print "lLength: "; lLength; "["; Value; "]"
          
    'Value = StrConv(bValue, vbUnicode)
    'GetProperty = Value
    'Debug.Print "Value: "; Value
    
    Dim sValue As String
    Dim lLength As Long
    sValue = String(20, Chr(0))
    
    lLength = SendMessageAny(Sci, SCI_GETPROPERTY, ByVal sKey, ByVal sValue)
    
    'Debug.Print "lLength: "; lLength; "["; sValue; "]"
    If lLength > 0 Then
        GetProperty = Mid(sValue, 1, lLength)
    Else
        GetProperty = ""
    End If
    
'    If lLength > 0 Then
'          Value = StrConv(bValue, vbUnicode)
'          Value = Mid(Value, 1, lLength)
'          GetProperty = Value
'    Else
'          GetProperty = ""
'    End If
  
End Function


'SCI_GETPROPERTYINT(const char *key, int default)
'Lookup a keyword:value pair using the specified key; if found, interpret the value as an integer and return it. If not found (or the value is an empty string) then return the supplied default. If the keyword:value pair is found but is not a number, then return 0.
'Note that "keyword replacement" as described in SCI_SETPROPERTY will be performed before any numeric interpretation.
Public Function GetPropertyInt(sKey As String, default As Long) As Long

    GetPropertyInt = SendMessageAny(Sci, SCI_GETPROPERTYINT, ByVal sKey, ByVal default)
    Exit Function
    
    Dim bKey() As Byte
    bKey = StrConv(sKey, vbFromUnicode)
    ReDim Preserve bKey(0 To UBound(bKey) + 1) As Byte
    GetPropertyInt = SendEditor(SCI_GETPROPERTYINT, ByVal VarPtr(bKey(0)), default)
    
End Function


'SCI_SETKEYWORDS(int keyWordSet, const char *keyWordList)
'You can set up to 9 lists of keywords for use by the current lexer. This was increased from 6 at revision 1.50. keyWordSet can be 0 to 8 (actually 0 to KEYWORDSET_MAX) and selects which keyword list to replace. keyWordList is a list of keywords separated by spaces, tabs, "\n" or "\r" or any combination of these. It is expected that the keywords will be composed of standard ASCII printing characters, but there is nothing to stop you using any non-separator character codes from 1 to 255 (except common sense).
'How these keywords are used is entirely up to the lexer. Some languages, such as HTML may contain embedded languages, VBScript and JavaScript are common for HTML. For HTML, key word set 0 is for HTML, 1 is for JavaScript and 2 is for VBScript, 3 is for Python, 4 is for PHP and 5 is for SGML and DTD keywords. Review the lexer code to see examples of keyword list. A fully conforming lexer sets the fourth argument of the LexerModule constructor to be a list of strings that describe the uses of the keyword lists.
'Alternatively, you might use set 0 for general keywords, set 1 for keywords that cause indentation and set 2 for keywords that cause unindentation. Yet again, you might have a simple lexer that colours keywords and you could change languages by changing the keywords in set 0. There is nothing to stop you building your own keyword lists into the lexer, but this means that the lexer must be rebuilt if more keywords are added.
Public Sub SetKeywords(keyWordSet As Long, keyWordList As String)
    SendEditor SCI_SETKEYWORDS, keyWordSet, keyWordList
End Sub

'SCI_GETSTYLEBITSNEEDED
'Retrieve the number of bits the current lexer needs for styling. This should normally be the argument to SCI_SETSTYLEBITS.
Public Function GetStyleBitsNeeded() As Long
    GetStyleBitsNeeded = SendEditor(SCI_GETSTYLEBITSNEEDED, CLng(0), CLng(0))
End Function


'STYLE_DEFAULT 32
'This style defines the attributes that all styles receive when the SCI_STYLECLEARALL message is used.
Public Sub StyleDefault( _
                Optional ByVal ForeColor As Long = BLACK, _
                Optional ByVal BackColor As Long = WHITE, _
                Optional fnt As StdFont = Nothing, _
                Optional ByVal eolFilled As Boolean, _
                Optional ByVal SetVisible As Boolean = True, _
                Optional ByVal SetCase As CaseMode = MIXED, _
                Optional ByVal SetCharset As CharSet = ANSI)
        
    Style STYLE_DEFAULT, ForeColor, BackColor, fnt, eolFilled, SetVisible, SetCase, SetCharset
    
End Sub

'STYLE_LINENUMBER 33
'This style sets the attributes of the text used to display line numbers in a
'line number margin. The background colour set for this style also sets the
'background colour for all margins that do not have any folding mask bits set.
'That is, any margin for which mask & SC_MASK_FOLDERS is 0.
'See SCI_SETMARGINMASKN for more about masks.
Public Sub StyleLineNumber( _
                Optional ByVal ForeColor As Long = BLACK, _
                Optional ByVal BackColor As Long = WHITE, _
                Optional fnt As StdFont = Nothing, _
                Optional ByVal eolFilled As Boolean, _
                Optional ByVal SetVisible As Boolean = True, _
                Optional ByVal SetCase As CaseMode = MIXED, _
                Optional ByVal SetCharset As CharSet = ANSI)
        
    Style STYLE_LINENUMBER, ForeColor, BackColor, fnt, eolFilled, SetVisible, SetCase, SetCharset
    
End Sub

'STYLE_BRACELIGHT 34
'This style sets the attributes used when highlighting braces with the SCI_BRACEHIGHLIGHT message and when highlighting the corresponding indentation with SCI_SETHIGHLIGHTGUIDE.
Public Sub StyleBraceLight( _
                Optional ByVal ForeColor As Long = BLACK, _
                Optional ByVal BackColor As Long = WHITE, _
                Optional fnt As StdFont = Nothing, _
                Optional ByVal eolFilled As Boolean, _
                Optional ByVal SetVisible As Boolean = True, _
                Optional ByVal SetCase As CaseMode = MIXED, _
                Optional ByVal SetCharset As CharSet = ANSI)
        
    Style STYLE_BRACELIGHT, ForeColor, BackColor, fnt, eolFilled, SetVisible, SetCase, SetCharset
    
End Sub

'STYLE_BRACEBAD 35
'This style sets the display attributes used when marking an unmatched brace with the SCI_BRACEBADLIGHT message.
Public Sub StyleBraceBad( _
                Optional ByVal ForeColor As Long = BLACK, _
                Optional ByVal BackColor As Long = WHITE, _
                Optional fnt As StdFont = Nothing, _
                Optional ByVal eolFilled As Boolean, _
                Optional ByVal SetVisible As Boolean = True, _
                Optional ByVal SetCase As CaseMode = MIXED, _
                Optional ByVal SetCharset As CharSet = ANSI)
        
    Style STYLE_BRACEBAD, ForeColor, BackColor, fnt, eolFilled, SetVisible, SetCase, SetCharset
    
End Sub

'STYLE_CONTROLCHAR 36
'This style sets the font used when drawing control characters. Only the font, size, bold, italics, and character set attributes are used and not the colour attributes. See also: SCI_SETCONTROLCHARSYMBOL.
Public Sub StyleControlChar( _
                Optional ByVal ForeColor As Long = BLACK, _
                Optional ByVal BackColor As Long = WHITE, _
                Optional fnt As StdFont = Nothing, _
                Optional ByVal eolFilled As Boolean, _
                Optional ByVal SetVisible As Boolean = True, _
                Optional ByVal SetCase As CaseMode = MIXED, _
                Optional ByVal SetCharset As CharSet = ANSI)
        
    Style STYLE_CONTROLCHAR, ForeColor, BackColor, fnt, eolFilled, SetVisible, SetCase, SetCharset
    
End Sub

'STYLE_INDENTGUIDE 37 This style sets the foreground and background colours used when drawing the indentation guides.
Public Sub StyleIndentGuide( _
                Optional ByVal ForeColor As Long = BLACK, _
                Optional ByVal BackColor As Long = WHITE, _
                Optional fnt As StdFont = Nothing, _
                Optional ByVal eolFilled As Boolean, _
                Optional ByVal SetVisible As Boolean = True, _
                Optional ByVal SetCase As CaseMode = MIXED, _
                Optional ByVal SetCharset As CharSet = ANSI)
        
    Style STYLE_INDENTGUIDE, ForeColor, BackColor, fnt, eolFilled, SetVisible, SetCase, SetCharset
    
End Sub

'SCI_SETMOUSEDWELLTIME
'SCI_GETMOUSEDWELLTIME
'These two messages set and get the time the mouse must sit still, in milliseconds, to generate a SCN_DWELLSTART notification. If set to SC_TIME_FOREVER, the default, no dwell events are generated.
Public Sub SetMouseDwellTime(ByVal msTime As Long)
    SendEditor SCI_SETMOUSEDWELLTIME, msTime, CLng(0)
End Sub

'====================================================================
'                       Autocompletion
'====================================================================
'Autocompletion displays a list box showing likely identifiers based upon the user's typing. The user chooses the currently selected item by pressing the tab character or another character that is a member of the fillup character set defined with SCI_AUTOCSETFILLUPS. Autocompletion is triggered by your application. For example, in C if you detect that the user has just typed fred. you could look up fred, and if it has a known list of members, you could offer them in an autocompletion list. Alternatively, you could monitor the user's typing and offer a list of likely items once their typing has narrowed down the choice to a reasonable list. As yet another alternative, you could define a key code to activate the list.
'
'When the user makes a selection from the list the container is sent a SCN_AUTOCSELECTION notification message. On return from the notification Scintilla will insert the selected text unless the autocompletion list has been cancelled, for example by the container sending SCI_AUTOCCANCEL.
'
'To make use of autocompletion you must monitor each character added to the document. See SciTEBase::CharAdded() in SciTEBase.cxx for an example of autocompletion.

'SCI_AUTOCSHOW(int lenEntered, const char *list)
'This message causes a list to be displayed. lenEntered is the number of characters of the word already entered and list is the list of words separated by separator characters. The initial separator character is a space but this can be set or got with SCI_AUTOCSETSEPARATOR and SCI_AUTOCGETSEPARATOR.
'The list of words should be in sorted order. If set to ignore case mode with SCI_AUTOCSETIGNORECASE, then strings are matched after being converted to upper case. One result of this is that the list should be sorted with the punctuation characters '[', '\', ']', '^', '_', and '`' sorted after letters.
Public Sub AutoCShow(ByVal lenEntered As Long, autoList As String)
    SendEditor SCI_AUTOCSHOW, lenEntered, autoList
End Sub

Public Sub ShowAutoComplete(autoList As String)
    Dim i As Long
    i = Me.ToLastSpaceCount
    SendMessageString Sci, SCI_AUTOCSHOW, i, autoList
End Sub

Public Function ToLastSpaceCount() As Long
    ' This function will figure out how many characters there are in the currently
    ' selected word.  It gets the line text, finds the position of the caret in
    ' the line text, then converts the line to a byte array to do a faster compare
    ' till it reaches something not interpreted as a letter IE a space or a
    ' line break.  This is kind of overly complex but seems to be faster overall
    
    Dim l As Long, i As Long, current As Long, Pos As Long
    Dim startWord As Long, iHold As Long
    Dim str As String, bByte() As Byte, strTmp As String
    Dim strLine As String
    
    strLine = Me.GetLine(Me.Line)
    current = Me.Column
    startWord = current
     
    Str2Byte strLine, bByte()
    
    iHold = 0
    While (startWord > 0) And InStr(1, m_sCallTipWordCharacters, strTmp) > 0
        startWord = startWord - 1
        iHold = iHold + 1
        If startWord >= 0 Then
          strTmp = Chr(bByte(startWord))
        End If
    Wend
    If strTmp = " " Then iHold = iHold - 1
    ToLastSpaceCount = iHold
End Function

'SCI_AUTOCCANCEL
'This message cancels any displayed autocompletion list. When in autocompletion mode, the list should disappear when the user types a character that can not be part of the autocompletion, such as '.', '(' or '[' when typing an identifier. A set of characters that will cancel autocompletion can be specified with SCI_AUTOCSTOPS.
Public Sub AutoCCancel()
    SendEditor SCI_AUTOCCANCEL, CLng(0), CLng(0)
End Sub

'SCI_AUTOCACTIVE
'This message returns non-zero if there is an active autocompletion list and zero if there is not.
Public Function AutoCActive() As Long
    AutoCActive = SendEditor(SCI_AUTOCACTIVE, CLng(0), CLng(0))
End Function

'SCI_AUTOCPOSSTART
'This returns the value of the current position when SCI_AUTOCSHOW started display of the list.
Public Function AutoCPosStart() As Long
    AutoCPosStart = SendEditor(SCI_AUTOCPOSSTART, CLng(0), CLng(0))
End Function

'SCI_AUTOCCOMPLETE
'This message triggers autocompletion. This has the same effect as the tab key.
Public Sub AutoCComplete()
    SendEditor SCI_AUTOCCOMPLETE, CLng(0), CLng(0)
End Sub

'SCI_AUTOCSTOPS(<unused>, const char *chars)
'The chars argument is a string containing a list of characters that will automatically cancel the autocompletion list. When you start the editor, this list is empty.
Public Sub AutoCStops(autoList As String)
    SendEditor SCI_AUTOCSTOPS, CLng(0), autoList
End Sub

'SCI_AUTOCSETSEPARATOR(char separator)
'SCI_AUTOCGETSEPARATOR
'These two messages set and get the separator character used to separate words in the SCI_AUTOCSHOW list. The default is the space character.
Public Property Get AutoCSeparator() As String
    AutoCSeparator = m_SepChar
    'AutoCSeparator = SendEditor(SCI_AUTOCGETSEPARATOR, CLng(0), CLng(0))
End Property

Public Property Let AutoCSeparator(ByVal chrSeparator As String)
    m_SepChar = Left(chrSeparator, 1)
    'By security, we remained with the first character
    SendEditor SCI_AUTOCSETSEPARATOR, Asc(m_SepChar)
    PropertyChanged "AutoCSeparator"
End Property

'SCI_AUTOCSELECT(<unused>, const char *select)
'SCI_AUTOCGETCURRENT
'This message selects an item in the autocompletion list. It searches the list of words for the first that matches select. By default, comparisons are case sensitive, but you can change this with SCI_AUTOCSETIGNORECASE. The match is character by character for the length of the select string. That is, if select is "Fred" it will match "Frederick" if this is the first item in the list that begins with "Fred". If an item is found, it is selected. If the item is not found, the autocompletion list closes if auto-hide is true (see SCI_AUTOCSETAUTOHIDE).
'The current selection can be retrieved with SCI_AUTOCGETCURRENT
Public Sub AutoCSelect(selectItem As String)
    SendEditor SCI_AUTOCSELECT, CLng(0), selectItem
End Sub

Public Function AutoCGetCurrent() As String
    AutoCGetCurrent = SendEditor(SCI_AUTOCGETCURRENT, CLng(0), CLng(0))
End Function

'SCI_AUTOCSETCANCELATSTART(bool cancel)
'SCI_AUTOCGETCANCELATSTART
'The default behavior is for the list to be cancelled if the caret moves before the location it was at when the list was displayed. By calling this message with a false argument, the list is not cancelled until the caret moves before the first character of the word being completed.
Public Sub AutoCSetCancelAtStart(ByVal bCancel As Boolean)
    SendEditor SCI_AUTOCSETCANCELATSTART, SciBool(bCancel), CLng(0)
End Sub

Public Function AutoCGetCancelAtStart() As Boolean
    AutoCGetCancelAtStart = SendEditor(SCI_AUTOCGETCANCELATSTART, CLng(0), CLng(0))
End Function

'SCI_AUTOCSETFILLUPS(<unused>, const char *chars)
'If a fillup character is typed with an autocompletion list active, the currently selected item in the list is added into the document, then the fillup character is added. Common fillup characters are '(', '[' and '.' but others are possible depending on the language. By default, no fillup characters are set.
Public Sub AutoCSetFillUps(ByVal Chars As String)
    SendMessageAny Sci, SCI_AUTOCSETFILLUPS, CLng(0), ByVal Chars
End Sub

'SCI_AUTOCSETCHOOSESINGLE(bool chooseSingle)
'SCI_AUTOCGETCHOOSESINGLE
'If you use SCI_AUTOCSETCHOOSESINGLE(1) and a list has only one item, it is automatically added and no list is displayed. The default is to display the list even if there is only a single item.
Public Sub AutoCSetChooseSingle(ByVal chooseSingle As Boolean)
    SendEditor SCI_AUTOCSETCHOOSESINGLE, SciBool(chooseSingle), CLng(0)
End Sub

Public Function AutoCGetChooseSingle() As Boolean
    AutoCGetChooseSingle = MakeBool(SendEditor(SCI_AUTOCGETCHOOSESINGLE, CLng(0), CLng(0)))
End Function

'SCI_AUTOCSETIGNORECASE(bool ignoreCase)
'SCI_AUTOCGETIGNORECASE
'By default, matching of characters to list members is case sensitive. These messages let you set and get case sensitivity.
Public Sub AutoCSetIgnoreCase(ByVal ignoreCase As Boolean)
    SendEditor SCI_AUTOCSETIGNORECASE, SciBool(ignoreCase), CLng(0)
End Sub

Public Function AutoCGetIgnoreCase() As Boolean
    AutoCGetIgnoreCase = MakeBool(SendEditor(SCI_AUTOCGETIGNORECASE, CLng(0), CLng(0)))
End Function

'SCI_AUTOCSETAUTOHIDE(bool autoHide)
'SCI_AUTOCGETAUTOHIDE
'By default, the list is cancelled if there are no viable matches (the user has typed characters that no longer match a list entry). If you want to keep displaying the original list, set autoHide to false. This also effects SCI_AUTOCSELECT.
Public Sub AutoCSetAutoHide(ByVal autoHide As Boolean)
    SendEditor SCI_AUTOCSETAUTOHIDE, SciBool(autoHide), CLng(0)
End Sub

Public Function AutoCGetAutoHide() As Boolean
    AutoCGetAutoHide = MakeBool(SendEditor(SCI_AUTOCGETAUTOHIDE, CLng(0), CLng(0)))
End Function

'SCI_AUTOCSETDROPRESTOFWORD(bool dropRestOfWord)
'SCI_AUTOCGETDROPRESTOFWORD
'When an item is selected, any word characters following the caret are first erased if dropRestOfWord is set true. The default is false.
Public Sub AutoCSetDropRestOfWord(ByVal dropRestOfWord As Boolean)
    SendEditor SCI_AUTOCSETDROPRESTOFWORD, SciBool(dropRestOfWord), CLng(0)
End Sub

Public Function AutoCGetDropRestOfWord() As Boolean
    AutoCGetDropRestOfWord = MakeBool(SendEditor(SCI_AUTOCGETDROPRESTOFWORD, CLng(0), CLng(0)))
End Function

'SCI_REGISTERIMAGE(int type, const char *xpmData)
'SCI_CLEARREGISTEREDIMAGES
'SCI_AUTOCSETTYPESEPARATOR(char separatorCharacter)
'SCI_AUTOCGETTYPESEPARATOR
'Autocompletion list items may display an image as well as text. Each image is first registered with an integer type. Then this integer is included in the text of the list separated by a '?' from the text. For example, "fclose?2 fopen" displays image 2 before the string "fclose" and no image before "fopen". The images are in XPM format as is described for SCI_MARKERDEFINEPIXMAP The set of registered images can be cleared with SCI_CLEARREGISTEREDIMAGES and the '?' separator changed with SCI_AUTOCSETTYPESEPARATOR.
Public Sub RegisterImage(ByVal listType As Long, ByVal xpmData As String)
    SendMessageAny Sci, SCI_REGISTERIMAGE, listType, ByVal xpmData
End Sub

Public Sub ClearRegisteredImages()
    SendEditor SCI_CLEARREGISTEREDIMAGES, CLng(0), CLng(0)
End Sub

Public Sub AutoCSetTypeSeparator(ByVal separatorCharacter As Long)
    SendEditor SCI_AUTOCSETTYPESEPARATOR, separatorCharacter, CLng(0)
End Sub

Public Function AutoCGetTypeSeparator() As Boolean
    AutoCGetTypeSeparator = SendEditor(SCI_AUTOCGETTYPESEPARATOR, CLng(0), CLng(0))
End Function

'SCI_AUTOCSETMAXHEIGHT(int rowCount)
'SCI_AUTOCGETMAXHEIGHT
'Get or set the maximum number of rows that will be visible in an autocompletion list. If there are more rows in the list, then a vertical scrollbar is shown. The default is 5.
Public Sub AutoCSetMaxHeight(ByVal rowCount As Long)
    SendEditor SCI_AUTOCSETMAXHEIGHT, rowCount, CLng(0)
End Sub

Public Function AutoCGetMaxHeight() As Long
    AutoCGetMaxHeight = SendEditor(SCI_AUTOCGETMAXHEIGHT, CLng(0), CLng(0))
End Function

'SCI_AUTOCSETMAXWIDTH(int characterCount)
'SCI_AUTOCGETMAXWIDTH
'Get or set the maximum width of an autocompletion list expressed as the number of characters in the longest item that will be totally visible. If zero (the default) then the list's width is calculated to fit the item with the most characters. Any items that cannot be fully displayed within the available width are indicated by the presence of ellipsis.
Public Sub AutoCSetMaxWidth(ByVal rowCount As Long)
    SendEditor SCI_AUTOCSETMAXWIDTH, rowCount, CLng(0)
End Sub

Public Function AutoCGetMaxWidth() As Long
    AutoCGetMaxWidth = SendEditor(SCI_AUTOCGETMAXWIDTH, CLng(0), CLng(0))
End Function

'====================================================================
'           User lists
'====================================================================
'User lists use the same internal mechanisms as autocompletion lists, and all the calls listed for autocompletion work on them; you cannot display a user list at the same time as an autocompletion list is active. They differ in the following respects:
'o The SCI_AUTOCSETCHOOSESINGLE message has no effect.
'o When the user makes a selection you are sent a SCN_USERLISTSELECTION notification message rather than SCN_AUTOCSELECTION.
'BEWARE: if you have set fillup characters or stop characters, these will still be active with the user list, and may result in items being selected or the user list cancelled due to the user typing into the editor.
'====================================================================
'SCI_USERLISTSHOW(int listType, const char *list)
'The listType parameter is returned to the container as the wParam field of the SCNotification structure. It must be greater than 0 as this is how Scintilla tells the difference between an autocompletion list and a user list. If you have different types of list, for example a list of buffers and a list of macros, you can use listType to tell which one has returned a selection.
Public Sub UserListShow(ByVal listType As Long, ByVal List As String)
    SendMessageAny Sci, SCI_USERLISTSHOW, listType, ByVal List
End Sub

'====================================================================
'====================================================================

'====================================================================
'   Default Style settings
'====================================================================
Public Property Get SelForeColor() As OLE_COLOR
    SelForeColor = m_SelForeColor
End Property

Public Property Let SelForeColor(ByVal Colour As OLE_COLOR)
    m_SelForeColor = MakeColor(Colour)
    Me.SetSelFore True, MakeColor(Colour)
    PropertyChanged "SelForeColor"
End Property

Public Property Get SelBackColor() As OLE_COLOR
    SelBackColor = m_SelBackColor
End Property

Public Property Let SelBackColor(ByVal Colour As OLE_COLOR)
    m_SelBackColor = MakeColor(Colour)
    Me.SetSelBack True, MakeColor(Colour)
    PropertyChanged "SelBackColor"
End Property

Public Property Get DefaultForeColor() As OLE_COLOR
    DefaultForeColor = m_DefaultForeColor
End Property

Public Property Let DefaultForeColor(ByVal Colour As OLE_COLOR)
    m_DefaultForeColor = MakeColor(Colour)
    SendEditor SCI_STYLESETFORE, STYLE_DEFAULT, MakeColor(Colour)
    PropertyChanged "DefaultForeColor"
End Property

Public Property Get DefaultBackColor() As OLE_COLOR
    DefaultBackColor = m_DefaultBackColor
End Property

Public Property Let DefaultBackColor(ByVal Colour As OLE_COLOR)
    m_DefaultBackColor = MakeColor(Colour)
    SendEditor SCI_STYLESETBACK, STYLE_DEFAULT, MakeColor(Colour)
    PropertyChanged "DefaultBackColor"
End Property

Public Property Get DefaultFont() As StdFont
    Set DefaultFont = New StdFont
    With DefaultFont
        .Name = m_DefaultFont.Name
        .Size = m_DefaultFont.Size
        .Bold = m_DefaultFont.Bold
        .Italic = m_DefaultFont.Italic
        .Underline = m_DefaultFont.Underline
    End With
End Property

Public Property Set DefaultFont(ByVal NewFont As StdFont)
    
    Set m_DefaultFont = New StdFont
    
    With m_DefaultFont
        .Name = NewFont.Name
        .Size = NewFont.Size
        .Bold = NewFont.Bold
        .Italic = NewFont.Italic
        .Underline = NewFont.Underline
    End With
    
    If Not NewFont Is Nothing Then
        SendEditor SCI_STYLESETSIZE, STYLE_DEFAULT, NewFont.Size
        SendEditor SCI_STYLESETFONT, STYLE_DEFAULT, NewFont.Name
        SendEditor SCI_STYLESETBOLD, STYLE_DEFAULT, NewFont.Bold
        SendEditor SCI_STYLESETITALIC, STYLE_DEFAULT, NewFont.Italic
        SendEditor SCI_STYLESETUNDERLINE, STYLE_DEFAULT, NewFont.Underline
    End If
    'PropertyChanged "DefaultFont"
End Property

Public Sub ClearDocument()
    Me.ClearAll
    Me.EmptyUndoBuffer
    Me.SetSavePoint
End Sub

Public Sub NewDocument()
    Me.ClearDocument
End Sub

Public Function Max(a As Long, b As Long) As Long
  If a > b Then
    Max = a
  Else
    Max = b
  End If
End Function

Public Function Min(a As Long, b As Long) As Long
  If a < b Then
    Min = a
  Else
    Min = b
  End If
End Function

'With the single threaded component, there is only one STA for all components. For the apartment threaded component, objects are each run in a different STA.

'Single Threaded
'Single threaded means there is only one thread within the process and it is doing all of the work for the process. The process must wait for the current execution of the thread to complete before it can perform another action.

'Single threaded results in system idle time and user frustration. For example, assume we are saving a file to a remote network using a single threaded application. Since there is only a single thread in the application, the application will not be able to do anything else while the file is being stored in the remote location. Thus the user waits and begins to wonder if the application is ever going to resume.

'Apartment Threading (Single Threaded Apartment)
'Apartment threaded means there are multiple threads within the application. In single threaded apartment (STA) each thread is isolated in a separate apartment underneath the process. The process can have any number of apartments that share data through a proxy. The application defines when and for how long the thread in each apartment should execute.
'All requests are serialized through the Windows message queue such that only a single apartment is accessed at a time and thus only a single thread will be executing at any one time. STA is the threading model that most Visual Basic developers are familiar with because this is the threading model available to VB applications prior to VB.NET. You can think of it like an apartment building full of a row of one room apartments that are accessible one at a time through a single hallway. The advantage this provides over single threaded is that multiple commands can be issued at one time instead of just a single command, but the commands are still sequentially executed.

'Free Threading (Multi Threaded Apartment)
'Free threaded applications were limited to programming languages such as C++ until the release of Microsoft .NET. The free threaded/Multi Threaded Apartment (MTA) model has a single apartment created underneath the process rather than multiple apartments. This single apartment holds multiple threads rather than just a single thread. No message queue is required because all of the threads are a part of the same apartment and can share data without a proxy. You can think of it like a building with multiple rooms that are all accessible once you are inside the building. These applications typically execute faster than single threaded and STA because there is less system overhead and can be optimized to eliminate system idle time.

'These types of applications are more complex to program. The developer must provide thread synchronization as part of the code to ensure that threads do not simultaneously access the same resources. A condition known as a race condition can occur when a thread accesses a shared resource and modifies the resource to an invalid state and then another thread accesses the shared resource and uses it in the invalid state before the other thread can return the resource to a valid state. Therefore it is necessary to place a lock on a resource to prevent other threads
'from accessing the resource until the lock has been removed. However, this can lead to a deadlock situation where two threads are competing for resources and neither can proceed. For example, thread #1 has a resource locked and is waiting for another resource that is currently locked by thread #2. Thread #2 happens to be waiting for the resource locked by thread #1. Thus, both threads are waiting on the other and neither will be allowed to proceed. The
' only way to avoid situations like these is through good design and testing.


Public Function ReadINI(sSection As String, sKeyName As String, sFileName As String) As String
    'Tutorial: http://www.vbexplorer.com/VBExplorer/focus/ini_tutorial.asp
    Dim sRet As String
    sRet = String(5000, Chr(0))
    ReadINI = Left(sRet, GetPrivateProfileString(sSection, ByVal sKeyName, "", sRet, Len(sRet), sFileName))
End Function

Public Function WriteINI(sSection As String, sKeyName As String, ByVal sNewString As String, sFileName) As Long
    'Returns non-zero on success; zero on failure.
    WriteINI = WritePrivateProfileString(sSection, sKeyName, sNewString, sFileName)
End Function

Public Sub GetSectionsINI(sSections() As String, sFileName As String)
    'Notice that lReturn contains the value 19 instead of the expected 18.
    'Normally, lReturn indexes the next-to-last character.  However,
    'when retrieving the section names using GetPrivateProfileString or
    'GetProfileString, lReturn indexes the last character.
    'http://www.vbexplorer.com/VBExplorer/focus/ini_tutorial_2.asp
    Dim sRet As String, X As Long
    sRet = String(250, Chr(0))
    X = GetPrivateProfileString(vbNullString, "", "", sRet, Len(sRet), sFileName)
    If X > 0 Then
        sRet = Left(sRet, X - 1)
    Else
        sRet = ""
    End If
    sSections = Split(sRet, Chr$(0))
    
End Sub

Public Sub GetKeysINI(sSection As String, sKeys() As String, sFileName As String)
    Dim sRet As String
    sRet = Me.ReadINI(sSection, vbNullString, sFileName)
    sKeys = Split(sRet, Chr$(0))
End Sub

Public Function DeleteKeyINI(sSection As String, sKeyName As String, sFileName) As Long
    'Returns non-zero on success; zero on failure.
    DeleteKeyINI = WritePrivateProfileString(sSection, sKeyName, vbNullString, sFileName)
End Function

Public Function DeleteSectionINI(sSection As String, sFileName) As Long
    'Returns non-zero on success; zero on failure.
    DeleteSectionINI = WritePrivateProfileString(sSection, vbNullString, "", sFileName)
End Function

Public Function ReadStyleINI(sLang As String, lStyle As Long, sFile As String, _
        Back As Long, Fore As Long, fntName As String, fntSize As Long, _
        Bold As Boolean, Italic As Boolean, Underline As Boolean, _
        Visible As Boolean, eolFilled As Boolean, chCase As CaseMode, _
        CharsSet As Long, sName As String) As Boolean
    
    Dim sKey As String
    Dim sLine As String
    Dim Parts() As String
    
    sKey = "Style." & CStr(lStyle)
    sLine = Me.ReadINI(sLang, sKey, sFile)
    
    If sLine = "" Then
        ReadStyleINI = False
        Exit Function
    End If
    
    Parts = Split(sLine, ",")
    
    ReDim Preserve Parts(12)
    
    Back = CLng(Parts(0))
    Fore = CLng(Parts(1))
    fntName = Parts(2)
    fntSize = CLng(Parts(3))
    Bold = CBool(Parts(4))
    Italic = CBool(Parts(5))
    Underline = CBool(Parts(6))
    Visible = CBool(Parts(7))
    eolFilled = CBool(Parts(8))
    chCase = CLng(Parts(9))
    CharsSet = CLng(Parts(10))
    sName = Parts(11)
            
    ReadStyleINI = True
    
End Function

Public Function WriteStyleINI(sLang As String, lStyle As Long, sFile As String, _
        Back As Long, Fore As Long, fntName As String, fntSize As Long, _
        Bold As Boolean, Italic As Boolean, Underline As Boolean, _
        Visible As Boolean, eolFilled As Boolean, chCase As CaseMode, _
        CharsSet As Long, sName As String) As Long
    
    Dim sKey As String
    Dim sLine As String
    
    sKey = "Style." & CStr(lStyle)
    
    'Back, Fore, fntName, fntSize, Bold, Italic, Underline,
    'Visible, eolFilled, chCase, chSet, sName
    
    sLine = "&H" & Hex(Back) & _
            ",&H" & Hex(Fore) & _
            "," & fntName & _
            "," & CStr(fntSize) & _
            "," & CStr(Bold) & _
            "," & CStr(Italic) & _
            "," & CStr(Underline) & _
            "," & CStr(Visible) & _
            "," & CStr(eolFilled) & _
            "," & CStr(chCase) & _
            "," & CStr(CharsSet) & _
            "," & sName

    WriteStyleINI = WriteINI(sLang, sKey, sLine, sFile)
    
End Function

Public Function WritePropertyINI(sLang As String, lProperty As Long, sValue As String, sFile As String) As Long
    WritePropertyINI = Me.WriteINI(sLang, "Properties." & CStr(lProperty), sValue, sFile)
End Function

Public Function WriteKeywordINI(sLang As String, lKeywordSet As Long, sValue As String, sFile As String) As Long
    WriteKeywordINI = Me.WriteINI(sLang, "Keywords." & CStr(lKeywordSet), sValue, sFile)
End Function

Public Function WriteTagINI(sLang As String, lTag As Long, sValue As String, sFile As String) As Long
    WriteTagINI = Me.WriteINI(sLang, "Tag." & CStr(lTag), sValue, sFile)
End Function

Public Function SetStyleINI(sLang As String, lStyle As Long, sFile As String) As Boolean

    Dim sKey As String
    Dim sLine As String
    Dim Parts() As String
    
    sKey = "Style." & CStr(lStyle)
    sLine = Me.ReadINI(sLang, sKey, sFile)
    
    If sLine = "" Then
        SetStyleINI = False
        Exit Function
    End If
    
    Parts = Split(sLine, ",")
    
    ReDim Preserve Parts(12)
    
    SendEditor SCI_STYLESETBACK, lStyle, CLng(Parts(0))
    SendEditor SCI_STYLESETFORE, lStyle, CLng(Parts(1))
    
    SendEditor SCI_STYLESETSIZE, lStyle, CLng(Parts(3))
    
    If Parts(2) <> "" Then 'Font name
        SendEditor SCI_STYLESETFONT, lStyle, Parts(2)
    End If
    
    SendEditor SCI_STYLESETBOLD, lStyle, CBool(Parts(4))
    SendEditor SCI_STYLESETITALIC, lStyle, CBool(Parts(5))
    SendEditor SCI_STYLESETUNDERLINE, lStyle, CBool(Parts(6))
    
    SendEditor SCI_STYLESETEOLFILLED, lStyle, CBool(Parts(8))
    SendEditor SCI_STYLESETVISIBLE, lStyle, CBool(Parts(7))
    SendEditor SCI_STYLESETCASE, lStyle, CLng(Parts(9))
    
    SendEditor SCI_STYLESETCHARACTERSET, lStyle, CLng(Parts(10))
            
    SetStyleINI = True
    
End Function

Public Function LanguageINI(sLang As String, sFile As String) As Boolean

    Dim sKey As String
    Dim sLine As String
    Dim Parts() As String
    Dim X As Long
    
    '--------------------------------------------
    'Lexer
    '--------------------------------------------
    sKey = "Lexer"
    sLine = Me.ReadINI(sLang, sKey, sFile)
    If sLine <> "" Then
        SendEditor SCI_SETLEXER, CLng(sLine), CLng(0)
    End If
    '--------------------------------------------
    'Keywords
    '--------------------------------------------
    For X = 0 To 7
        sKey = "Keywords." & CStr(X)
        sLine = Me.ReadINI(sLang, sKey, sFile)
        If sLine <> "" Then
            SendMessageString Sci, SCI_SETKEYWORDS, X, sLine
        End If
    Next X
    '--------------------------------------------
    'Styles
    '--------------------------------------------
    For X = 0 To 127
        sKey = "Style." & CStr(X)
        sLine = Me.ReadINI(sLang, sKey, sFile)
        
        If sLine <> "" Then
            Parts = Split(sLine, ",")
            ReDim Preserve Parts(12)
            
            If Parts(0) <> "" Then
                SendEditor SCI_STYLESETBACK, X, CLng(Parts(0))
            End If
            If Parts(1) <> "" Then
                SendEditor SCI_STYLESETFORE, X, CLng(Parts(1))
            End If
            
            If Parts(2) <> "" Then 'Font name
                Call SendMessageString(Sci, SCI_STYLESETFONT, X, Parts(2))
            End If
            
            If Parts(3) <> "" Then
                SendEditor SCI_STYLESETSIZE, X, CLng(Parts(3))
            End If
            
            If Parts(4) <> "" Then
                SendEditor SCI_STYLESETBOLD, X, CBool(Parts(4))
            End If
            
            If Parts(5) <> "" Then
                SendEditor SCI_STYLESETITALIC, X, CBool(Parts(5))
            End If
            
            If Parts(6) <> "" Then
                SendEditor SCI_STYLESETUNDERLINE, X, CBool(Parts(6))
            End If
            
            If Parts(7) <> "" Then
                SendEditor SCI_STYLESETVISIBLE, X, CBool(Parts(7))
            End If
            If Parts(8) <> "" Then
                SendEditor SCI_STYLESETEOLFILLED, X, CBool(Parts(8))
            End If
            If Parts(9) <> "" Then
                SendEditor SCI_STYLESETCASE, X, CLng(Parts(9))
            End If
            
            If Parts(10) <> "" Then
                SendEditor SCI_STYLESETCHARACTERSET, X, CLng(Parts(10))
            End If
        End If
    Next X
    '--------------------------------------------
    '   Properties
    '--------------------------------------------
    For X = 0 To 20
        sKey = "Properties." & CStr(X)
        sLine = Me.ReadINI(sLang, sKey, sFile)
        If sLine <> "" Then
            Parts = Split(sLine, ":")
            ReDim Preserve Parts(2)
            If Parts(0) <> "" Then
                Me.SetProperty Parts(0), Parts(1)
                'Debug.Print "SetProperty : "; Parts(0), CStr(Parts(1))
            End If
        End If
    Next X
    '--------------------------------------------
End Function

Public Function ReadLanguageStyler(sLang As String, sFile As String) As Styler

    Dim sKey As String
    Dim sLine As String
    Dim Parts() As String
    Dim X As Long
    
    Dim LangStyler As Styler
    '--------------------------------------------
    'Lexer
    '--------------------------------------------
    With LangStyler
        .Name = sLang
        
        sKey = "Lexer"
        sLine = Me.ReadINI(sLang, sKey, sFile)
        If sLine <> "" Then
            .Lexer = CLng(sLine)
        End If
        '--------------------------------------------
        'Keywords
        '--------------------------------------------
        For X = 0 To 7
            sKey = "Keywords." & CStr(X)
            .Keywords(X) = Me.ReadINI(sLang, sKey, sFile)
        Next X
        '--------------------------------------------
        'Styles
        '--------------------------------------------
        For X = 0 To 127
            sKey = "Style." & CStr(X)
            sLine = Me.ReadINI(sLang, sKey, sFile)
        
            Parts = Split(sLine, ",")
            ReDim Preserve Parts(12)
            
            If Parts(0) <> "" Then
                    .StyleBack(X) = CLng(Parts(0))
                Else
                    .StyleBack(X) = CLng(&HFFFFFF)
            End If
            
            If Parts(1) <> "" Then
                    .StyleFore(X) = CLng(Parts(1))
                Else
                    .StyleFore(X) = CLng(&H0)
            End If
            
            If Parts(2) <> "" Then 'Font name
                    .StyleFont(X) = Parts(2)
                Else
                    .StyleFont(X) = "Tahoma"
            End If
            
            If Parts(3) <> "" Then  'Fot size
                    .StyleSize(X) = CLng(Parts(3))
                Else
                    .StyleSize(X) = CLng(12)
            End If
            
            If Parts(4) <> "" Then  'Bold
                    .StyleBold(X) = CBool(Parts(4))
                Else
                    .StyleBold(X) = False
            End If
            
            If Parts(5) <> "" Then  'Italic
                    .StyleItalic(X) = CBool(Parts(5))
                Else
                    .StyleItalic(X) = False
            End If
            
            If Parts(6) <> "" Then  'Underline
                    .StyleUnderline(X) = CBool(Parts(6))
                Else
                    .StyleUnderline(X) = False
            End If
            
            If Parts(7) <> "" Then  'Visible
                    .StyleVisible(X) = CBool(Parts(7))
                Else
                    .StyleVisible(X) = True
            End If
            
            If Parts(8) <> "" Then  'EOL filled
                    .StyleEOLFilled(X) = CBool(Parts(8))
                Else
                    .StyleEOLFilled(X) = False
            End If
            
            If Parts(9) <> "" Then  'Case mode
                    .StyleCase(X) = CLng(Parts(9))
                Else
                    .StyleCase(X) = 0
            End If
            
            If Parts(10) <> "" Then     'CHARACTERSET
                    .StyleCharsSet(X) = CLng(Parts(10))
                Else
                    .StyleCharsSet(X) = 1 'default = 1
            End If
        Next X
        '--------------------------------------------
        '   Properties
        '--------------------------------------------
        For X = 0 To 20
            sKey = "Properties." & CStr(X)
            .Properties(X) = Me.ReadINI(sLang, sKey, sFile)
        Next X
        '--------------------------------------------
        '--------------------------------------------
        '   User defined
        '--------------------------------------------
        For X = 0 To 20
            sKey = "Tag." & CStr(X)
            .Tag(X) = Me.ReadINI(sLang, sKey, sFile)
        Next X
    End With
    
    ReadLanguageStyler = LangStyler
    
End Function

Public Sub WriteLanguageStyler(LangStyler As Styler)

    Dim sKey As String, sLang As String
    Dim X As Long, sFile As String
    
    With LangStyler
         
        sFile = .File
        sLang = .Name
        'Lexer
        sKey = "Lexer"
        Me.WriteINI sLang, sKey, CStr(.Lexer), sFile
        
        sKey = "Filter"
        Me.WriteINI sLang, sKey, .Filter, sFile
        '--------------------------------------------
        'Keywords
        '--------------------------------------------
        For X = 0 To 7
            sKey = "Keywords." & CStr(X)
            If .Keywords(X) <> "" Then
                Me.WriteINI sLang, sKey, .Keywords(X), sFile
            End If
        Next X
        '--------------------------------------------
        'Styles
        '--------------------------------------------
        For X = 0 To 127
            Me.WriteStyleINI sLang, X, sFile, _
                CLng(.StyleBack(X)), CLng(.StyleFore(X)), .StyleFont(X), _
                CLng(.StyleSize(X)), CBool(.StyleBold(X)), _
                CBool(.StyleItalic(X)), CBool(.StyleUnderline(X)), _
                CBool(.StyleVisible(X)), CBool(.StyleEOLFilled(X)), _
                CLng(.StyleCase(X)), CLng(.StyleCharsSet(X)), .StyleName(X)
        Next X
        '--------------------------------------------
        '   Properties
        '--------------------------------------------
        For X = 0 To 20
            sKey = "Properties." & CStr(X)
            If .Properties(X) <> "" Then
                Me.WriteINI sLang, sKey, .Properties(X), sFile
            End If
        Next X
        '--------------------------------------------
        '--------------------------------------------
        '   User defined
        '--------------------------------------------
        For X = 0 To 20
            sKey = "Tag." & CStr(X)
            If .Tag(X) <> "" Then
                Me.WriteINI sLang, sKey, .Tag(X), sFile
            End If
        Next X
    End With
    
End Sub

Public Sub SetLanguageStyler(LangStyler As Styler)

    Dim Parts() As String
    Dim X As Long
    
    With LangStyler
        '--------------------------------------------
        'Lexer
        '--------------------------------------------
        SendEditor SCI_SETLEXER, CLng(.Lexer), CLng(0)
        '--------------------------------------------
        'Keywords
        '--------------------------------------------
        For X = 0 To 7
            If .Keywords(X) <> "" Then
                SendMessageString Sci, SCI_SETKEYWORDS, X, .Keywords(X)
            End If
        Next X
        '--------------------------------------------
        'Styles
        '--------------------------------------------
        For X = 0 To 127
            SendEditor SCI_STYLESETBACK, X, .StyleBack(X)
            SendEditor SCI_STYLESETFORE, X, .StyleFore(X)
        
            SendMessageString Sci, SCI_STYLESETFONT, X, .StyleFont(X)
        
            SendEditor SCI_STYLESETSIZE, X, .StyleSize(X)
        
            SendEditor SCI_STYLESETBOLD, X, SciBool(.StyleBold(X))
        
            SendEditor SCI_STYLESETITALIC, X, SciBool(.StyleItalic(X))
            SendEditor SCI_STYLESETUNDERLINE, X, SciBool(.StyleUnderline(X))
        
            SendEditor SCI_STYLESETVISIBLE, X, SciBool(.StyleVisible(X))
            SendEditor SCI_STYLESETEOLFILLED, X, SciBool(.StyleEOLFilled(X))
        
            SendEditor SCI_STYLESETCASE, X, .StyleCase(X)
            SendEditor SCI_STYLESETCHARACTERSET, X, .StyleCharsSet(X)
        Next X
        '--------------------------------------------
        '   Properties
        '--------------------------------------------
        For X = 0 To 20
            If .Properties(X) <> "" Then
                Parts = Split(.Properties(X), ":")
                ReDim Preserve Parts(2)
                If Parts(0) <> "" Then
                    Me.SetProperty Parts(0), Parts(1)
                End If
            End If
        Next X
        '--------------------------------------------
    End With
    
End Sub

'====================================================================
Public Function SetFixedFont(ByVal strFont As String, lSize As Long)
  Dim i As Long
  For i = 0 To 127
    SendEditor SCI_STYLESETFONT, i, strFont
    SendEditor SCI_STYLESETSIZE, i, lSize
  Next i
End Function

Public Sub Remove(posStart As Long, posEnd As Long)
    SendEditor SCI_SETSEL, posStart, posEnd
    SendEditor SCI_CLEAR
End Sub

'====================================================================
'====================================================================
Public Property Get EdgeMode() As EdgeMode
    'EdgeMode = SendEditor(SCI_GETEDGEMODE, CLng(0), CLng(0))
    EdgeMode = m_lEdgeMode
End Property

Public Property Let EdgeMode(ByVal lMode As EdgeMode)
    m_lEdgeMode = lMode
    SendEditor SCI_SETEDGEMODE, m_lEdgeMode, CLng(0)
    PropertyChanged "EdgeMode"
End Property

Public Property Get EdgeColumn() As Long
    'EdgeColumn = SendEditor(SCI_GETEDGECOLUMN, CLng(0), CLng(0))
    EdgeColumn = m_lEdgeColumn
End Property

Public Property Let EdgeColumn(ByVal lColumn As Long)
    m_lEdgeColumn = lColumn
    SendEditor SCI_SETEDGECOLUMN, m_lEdgeColumn, CLng(0)
    PropertyChanged "EdgeColumn"
End Property

Public Property Get EdgeColor() As OLE_COLOR
    'SendMessage(Sci, SCI_GETEDGECOLOUR, CLng(0), CLng(0))
    EdgeColor = m_lEdgeColor
End Property

Public Property Let EdgeColor(ByVal Colour As OLE_COLOR)
    m_lEdgeColor = MakeColor(Colour)
    SendEditor SCI_SETEDGECOLOUR, m_lEdgeColor, CLng(0)
    PropertyChanged "EdgeColor"
End Property

'====================================================================
Public Property Get MarginForeColor() As OLE_COLOR
    MarginForeColor = m_lMarginForeColor
End Property

Public Property Let MarginForeColor(ByVal Colour As OLE_COLOR)
    m_lMarginForeColor = MakeColor(Colour)
    SendEditor SCI_STYLESETFORE, STYLE_LINENUMBER, m_lMarginForeColor
    PropertyChanged "MarginForeColor"
End Property

Public Property Get MarginBackColor() As OLE_COLOR
    MarginBackColor = m_lMarginBackColor
End Property

Public Property Let MarginBackColor(ByVal Colour As OLE_COLOR)
    m_lMarginBackColor = MakeColor(Colour)
    SendEditor SCI_STYLESETBACK, STYLE_LINENUMBER, m_lMarginBackColor
    PropertyChanged "MarginBackColor"
End Property

'====================================================================
'    Call SendMessage(Sci, SCI_MARKERSETFORE, marker, (Fore))
'    Call SendMessage(Sci, SCI_MARKERSETBACK, marker, (Back))
Public Property Get MarkerForeColor() As OLE_COLOR
    MarkerForeColor = m_lMarkerForeColor
End Property

Public Property Let MarkerForeColor(ByVal Colour As OLE_COLOR)
    m_lMarkerForeColor = MakeColor(Colour)
    Dim Maker As Long
    For Maker = 0 To 31
        SendEditor SCI_MARKERSETFORE, Maker, m_lMarkerForeColor
    Next Maker
    PropertyChanged "MarkerForeColor"
End Property

Public Property Get MarkerBackColor() As OLE_COLOR
    MarkerBackColor = m_lMarkerBackColor
End Property

Public Property Let MarkerBackColor(ByVal Colour As OLE_COLOR)
    m_lMarkerBackColor = MakeColor(Colour)
    Dim Maker As Long
    For Maker = 0 To 31
        SendEditor SCI_MARKERSETBACK, Maker, m_lMarkerBackColor
    Next Maker
    PropertyChanged "MarkerBackColor"
End Property

'====================================================================
'    Call SendMessage(Sci, SCI_SETFOLDMARGINCOLOUR, SciBool(useSetting), Colour)
'    Call SendMessage(Sci, SCI_SETFOLDMARGINHICOLOUR, SciBool(useSetting), Colour)
Public Property Get FoldMarginColor() As OLE_COLOR
    FoldMarginColor = m_lFoldMarginColor
End Property

Public Property Let FoldMarginColor(ByVal Colour As OLE_COLOR)
    m_lFoldMarginColor = MakeColor(Colour)
    SendEditor SCI_SETFOLDMARGINCOLOUR, CLng(1), m_lFoldMarginColor
    PropertyChanged "FoldMarginColor"
End Property

Public Property Get FoldMarginHiColor() As OLE_COLOR
    FoldMarginHiColor = m_lFoldMarginHiColor
End Property

Public Property Let FoldMarginHiColor(ByVal Colour As OLE_COLOR)
    m_lFoldMarginHiColor = MakeColor(Colour)
    SendEditor SCI_SETFOLDMARGINHICOLOUR, CLng(1), m_lFoldMarginHiColor
    PropertyChanged "FoldMarginHiColor"
End Property
'====================================================================
'====================================================================


'====================================================================
'http://scintilla.sourceforge.net/ScintillaDoc.html
'====================================================================
'====================================================================
'====================================================================
'====================================================================


' Shell a DOS program and return its stdout if any
Public Function DosExec(strAppName As String, strParams As String, Optional lShowWindow As Long = SW_HIDE, Optional lBufferSize As Long = 100) As String
  
  Dim strCmd As String
  ' make sure the AppName() property has been set
  ' if it hasn't, fail
  If Len(strAppName) = 0 Then
    DosExec = "AppName() property not set."
    Exit Function
  End If
  
  ' check what OS we are running on so we can use the
  ' correct method of creating the process
  '
  ' From Mattias Sjögren's source - reason we use a 32-bit console for Win9x
  '
  ' If we are running Windows 9x, we have to launch the command using an
  ' intermediate Win32 console application (RedirStub.exe in this case),
  ' since Command.com is a 16-bit program. See KB article Q150956.
  Select Case CheckOS
    Case VER_PLATFORM_WIN32s
      'Windows 3.x (FAIL FAIL FAIL - Get with the times)
      DosExec = "Ancient OS detected. It's time to upgrade."
      Exit Function
    Case VER_PLATFORM_WIN32_WINDOWS
      ' Windows 9x
      strCmd = "RedirStub " & strCmd
    Case VER_PLATFORM_WIN32_NT
      ' Windows NT/2000/XP
      strCmd = Environ$("COMSPEC") & " /c " & strAppName & " " & strParams
  End Select
  
  ' shell it and return it
  DosExec = GetCommandOutput(strCmd, True, True, , lShowWindow, lBufferSize)
End Function

' Shell a Windows program and return its stdout if any
Public Function WinExec(strAppName As String, strParams As String, Optional lShowWindow As Long = SW_HIDE, Optional lBufferSize As Long = 100) As String
    Dim strCmd As String
    ' make sure the AppName() property has been set
    ' if it hasn't, fail
    If Len(strAppName) = 0 Then
      WinExec = "AppName not set."
      Exit Function
    End If
    ' Build the shell string
    strCmd = strAppName & " " & strParams
    ' shell it and return it
    WinExec = GetCommandOutput(strCmd, True, True, , lShowWindow, lBufferSize)
End Function

'==================================================================
'================================================================
''''''''''''''''''''''''''
'''   Public methods   '''
''''''''''''''''''''''''''
' Function GetCommandOutput
' sCommandLine:  [in] Command line to launch
' fStdOut        [in,opt] True (defualt) to capture output to STDOUT
' fStdErr        [in,opt] True to capture output to STDERR. False is default.
' fOEMConvert:   [in,opt] True (default) to convert DOS characters to Windows, False to skip conversion
'
' Returns:       String with STDOUT and/or STDERR output

Private Function GetCommandOutput( _
            sCommandLine As String, Optional fStdOut As Boolean = True, _
            Optional fStdErr As Boolean = False, Optional fOEMConvert As Boolean = True, _
            Optional lShowWindow As Long = SW_HIDE, _
            Optional lBufferSize As Long = 100 _
            ) As String

  Dim hPipeRead As Long, hPipeWrite1 As Long, hPipeWrite2 As Long
  Dim hCurProcess As Long
  Dim sa As SECURITY_ATTRIBUTES
  Dim si As STARTUPINFO
  Dim pi As PROCESS_INFORMATION
  Dim baOutput() As Byte
  Dim sNewOutput As String
  Dim lBytesRead As Long
  Dim fTwoHandles As Boolean
  Dim BUFSIZE As Long
  Dim lpExitCode As Long
  Dim Terminate As Boolean
  Dim lRet As Long
    
  Terminate = False
  m_bTerminateProcess = False
  
  'Const BUFSIZE = 1024      ' pipe buffer size
  BUFSIZE = lBufferSize      ' pipe buffer size
  
  ' At least one of them should be True, otherwise there's no point in calling the function
  If (Not fStdOut) And (Not fStdErr) Then Err.Raise 5         ' Invalid Procedure call or Argument
  
  ' If both are true, we need two write handles. If not, one is enough.
  fTwoHandles = fStdOut And fStdErr
  
  ReDim baOutput(BUFSIZE) As Byte

  With sa
    .nLength = Len(sa)
    .bInheritHandle = 1    ' get inheritable pipe handles
  End With
  
  If CreatePipe(hPipeRead, hPipeWrite1, sa, BUFSIZE) = 0 Then Exit Function
  
  hCurProcess = GetCurrentProcess()
  
  ' Replace our inheritable read handle with an non-inheritable. Not that it
  ' seems to be necessary in this case, but the docs say we should.
  Call DuplicateHandle(hCurProcess, hPipeRead, hCurProcess, hPipeRead, 0&, _
                       0&, DUPLICATE_SAME_ACCESS Or DUPLICATE_CLOSE_SOURCE)
  
  ' If both STDOUT and STDERR should be redirected, get an extra handle.
  If fTwoHandles Then
    Call DuplicateHandle(hCurProcess, hPipeWrite1, hCurProcess, hPipeWrite2, 0&, _
                         1&, DUPLICATE_SAME_ACCESS)
  End If
  
  With si
    .cb = Len(si)
    .dwFlags = STARTF_USESHOWWINDOW Or STARTF_USESTDHANDLES
    .wShowWindow = lShowWindow          ' hide or show the window
    
    If fTwoHandles Then
      .hStdOutput = hPipeWrite1
      .hStdError = hPipeWrite2
    ElseIf fStdOut Then
      .hStdOutput = hPipeWrite1
    Else
      .hStdError = hPipeWrite1
    End If
  End With
    
  If CreateProcess(vbNullString, sCommandLine, ByVal 0&, ByVal 0&, 1, 0&, _
                   ByVal 0&, vbNullString, si, pi) Then
    
    m_lProcessHandle = pi.hProcess
    
    ' Close thread handle - we don't need it
    Call CloseHandle(pi.hThread)
    
    ' Also close our handle(s) to the write end of the pipe. This is important, since
    ' ReadFile will *not* return until all write handles are closed or the buffer is full.
    Call CloseHandle(hPipeWrite1)
    hPipeWrite1 = 0
    If hPipeWrite2 Then
      Call CloseHandle(hPipeWrite2)
      hPipeWrite2 = 0
    End If

    Do
        ' Add a DoEvents to allow more data to be written to the buffer for each call.
        ' This results in fewer, larger chunks to be read.
        
        DoEvents
        
        ' See if our child process is still alive
        GetExitCodeProcess pi.hProcess, lpExitCode
              
        If ReadFile(hPipeRead, baOutput(0), BUFSIZE, lBytesRead, ByVal 0&) = 0 Then
          'RaiseEvent ProcessOutput("", 0&, lpExitCode)
          Exit Do
        End If
        
        If fOEMConvert Then
          ' convert from "DOS" to "Windows" characters
          sNewOutput = String$(lBytesRead, 0)
          Call OemToCharBuff(baOutput(0), sNewOutput, lBytesRead)
        Else
          ' perform no conversion (except to Unicode)
          sNewOutput = Left$(StrConv(baOutput(), vbUnicode), lBytesRead)
        End If
             
        GetCommandOutput = GetCommandOutput & sNewOutput
        
        ' If you are executing an application that outputs data during a long time,
        ' and don't want to lock up your application, it might be a better idea to
        ' wrap this code in a class module in an ActiveX EXE and execute it asynchronously.
        ' Then you can raise an event here each time more data is available.
        'RaiseEvent OutputAvailabele(sNewOutput)
        
        RaiseEvent ProcessOutput(ByVal sNewOutput, ByVal lBytesRead, ByVal lpExitCode, Terminate)
        
        If (Terminate) Or (m_bTerminateProcess) Then
            lRet = TerminateProcess(pi.hProcess, lpExitCode)
            Exit Do
        End If
        
    Loop
    
    ' When the process terminates successfully, Err.LastDllError will be
    ' ERROR_BROKEN_PIPE (109). Other values indicates an error.
    
    Call CloseHandle(pi.hProcess)
    
    RaiseEvent ProcessOutput(ByVal "", ByVal 0&, ByVal 0&, Terminate)
    
  End If
  
  ' clean up
  Call CloseHandle(hPipeRead)
  If hPipeWrite1 Then Call CloseHandle(hPipeWrite1)
  If hPipeWrite2 Then Call CloseHandle(hPipeWrite2)
  
End Function

Public Function GetProcessHandle() As Long
  GetProcessHandle = m_lProcessHandle
End Function

Public Sub TerminateCurrentProcess()
    m_bTerminateProcess = True
End Sub

Public Function ShellRun(sDocName As String, _
                    Optional ByVal Action As String = "Open", _
                    Optional ByVal Parameters As String = vbNullString, _
                    Optional ByVal Directory As String = vbNullString, _
                    Optional ByVal WindowState As WindowState) As Boolean
    Dim Response
    Response = ShellExecute(&O0, Action, sDocName, Parameters, Directory, WindowState)
    Select Case Response
        Case Is < 33
            ShellRun = False
        Case Else
            ShellRun = True
    End Select
End Function

'====================================================================
'                           AutoIndent
'====================================================================
Private Sub AutoIndentation()
  
    Dim curLine As Long, indentAmount As Long
        
    curLine = Me.Line
    indentAmount = 0
    
    If curLine > 0 And Me.LineLength(curLine) Then
        indentAmount = Me.GetLineIndentation(curLine - 1)
        If indentAmount > 0 Then
            Me.SetLineIndentation curLine, indentAmount
            Me.SetCurrentPos Me.GetLineIndentPosition(curLine)
            SendEditor SCI_SETSEL, Me.GetCurrentPos, Me.GetCurrentPos
        End If
    End If
    
End Sub

Public Property Get AutoIndent() As Boolean
    AutoIndent = m_bAutoIndent
End Property

Public Property Let AutoIndent(ByVal bAutoIndent As Boolean)
    m_bAutoIndent = bAutoIndent
    PropertyChanged "AutoIndent"
End Property
'====================================================================
'====================================================================

Public Property Get ShowCallTips() As Boolean
  ShowCallTips = m_bShowCallTips
End Property

Public Property Let ShowCallTips(ByVal bValue As Boolean)
  m_bShowCallTips = bValue
End Property

Private Sub StartCallTip(ch As Long)
    
    Dim Line As String, str As String, i As Long, X As Long
    Dim newstr As String, iPos As Long, iPos2 As Long, iStart As Long, iEnd As Long
    Dim iPos3 As Long, iPos4 As Long, str2 As String
    
    If UBound(m_sCallTipStrings) = 0 Then Exit Sub
  
    If Me.CallTipActive = False Then
        If ch = Asc("(") Then
            Line = Me.GetLine(Me.Line)
            'Debug.Print "Line: "; Line
            X = Me.Column
            str = Mid(Line, 1, X)
            'Debug.Print "str: "; str
            newstr = ""
            For i = X - 1 To 1 Step -1
                If InStr(1, m_sCallTipWordCharacters, Mid(str, i, 1)) > 0 Then
                    newstr = Mid(str, i, 1) & newstr
                Else
                    Exit For
                End If
            Next i
            'Debug.Print "newstr: "; newstr
            If Len(newstr) = 0 Then
                CallTipCancel
                Exit Sub
            End If
            
            For i = 0 To UBound(m_sCallTipStrings) - 1
                iPos2 = InStr(1, m_sCallTipStrings(i), newstr)
                'Debug.Print " m_sCallTipStrings(i): "; m_sCallTipStrings(i), i
                If iPos2 > 0 Then
                        'Debug.Print "newstr: "; newstr, iPos2
                      'if instr(1, m_sCallTipWordCharacters, mid(line,
                      'If InStr(1, m_sCallTipWordCharacters, Mid(m_sCallTipStrings(i), iPos2 - 1, 1)) > 0 Then Exit Sub
                      'If InStr(1, m_sCallTipWordCharacters, Mid(m_sCallTipStrings(i), iPos2 + Len(newstr), 1)) > 0 Then Exit Sub
                      m_lActiveCallTip = i
                      'ShowCallTip Mid(m_sCallTipStrings(i),  1, Len(m_sCallTipStrings(i)) - 1)
                      Dim sTip  As String
                      sTip = m_sCallTipStrings(i)
                      sTip = Replace(sTip, vbCrLf, "", 1)
                      'sTip = Replace(sTip, "\n", vbLf, 1)
                      'Debug.Print "sTip: "; sTip
                      ShowCallTip sTip
                      
                      iPos = InStr(1, m_sCallTipStrings(i), ",")
                      If iPos > 0 Then
                          iStart = Len(newstr) + 1
                          iEnd = iPos - 1
                          CallTipSetHlt iStart, iEnd
                          Exit Sub
                      End If
                      Exit Sub
                End If
            Next
        End If ' If ch = Asc("(") Then
    
    ElseIf ch = Asc(")") Then
        CallTipCancel
    
    Else
        If ch = Asc("(") Then
            CallTipCancel
            Exit Sub
        End If
        
        'ch = Asc(",") Then
        ' First determine where we are at within the ( and )
        Dim UA() As String
        Line = Me.GetLine(Me.Line)
        X = Me.Column
        iPos = InStrRev(Line, "(", X)
        'Get the chunk of the string were in
        str = Mid(Line, iPos + 1, X - iPos)
        UA = Split(str, ",")
        iPos2 = UBound(UA)
        
        iPos3 = InStr(1, m_sCallTipStrings(m_lActiveCallTip), "(")
        iPos4 = InStrRev(m_sCallTipStrings(m_lActiveCallTip), ")")
        str2 = Mid$(m_sCallTipStrings(m_lActiveCallTip), iPos3 + 1, iPos4 - iPos3 - 1)
        
        Erase UA
        UA = Split(str2, ",")
            
        iStart = 0
        iEnd = 0
        X = 0
        iPos3 = iPos3 + 1
        If iPos2 = 0 Then
            iStart = iPos3 - 2
            iEnd = Len(UA(0)) + iStart
        ElseIf iPos2 <= UBound(UA) Then
            For i = 1 To iPos2
              X = X + Len(UA(i))
            Next i
            iStart = X + iPos3 + (iPos2)
            iEnd = iStart + Len(UA(iPos2)) + (iPos2)
        Else
            ' In this case we have more commas than the function needs
            ' So we will just keep highlighting the last part of the
            ' tip.
            X = 0
            For i = 0 To UBound(UA) - 1
              X = X + Len(UA(i))
            Next
            iStart = X + iPos3 + UBound(UA) - 1
            iEnd = X + Len(UA(UBound(UA))) + iPos3 + (UBound(UA) - 1)
        End If
        CallTipSetHlt iStart, iEnd
  End If
  
End Sub

Public Function LoadCallTipFile(strFile As String)
  
    Dim iFile As Integer, str As String, i As Long
    
    iFile = FreeFile
    
    Erase m_sCallTipStrings  'Clear the old array
    ReDim m_sCallTipStrings(0)
    i = 0
    
    Open strFile For Input As #iFile
    Do While Not EOF(iFile)
        Line Input #iFile, str
        i = UBound(m_sCallTipStrings)
        ReDim Preserve m_sCallTipStrings(0 To i + 1)
        str = Replace(str, vbCrLf, "", 1)
        str = Replace(str, vbCr, "", 1)
        str = Replace(str, vbLf, "", 1)
        m_sCallTipStrings(i) = str
    Loop
    ReDim Preserve m_sCallTipStrings(0 To i)
    Close #iFile
    
End Function

Public Sub SetCallTips(sTips() As String)
    m_sCallTipStrings() = sTips()
End Sub

Public Sub GetCallTips(sTips() As String)
    sTips() = m_sCallTipStrings()
End Sub

'====================================================================
'               Printing
'====================================================================
'====================================================================
'On Windows SCI_FORMATRANGE can be used to draw the text onto a display context which can include a printer display context. Printed output shows text styling as on the screen, but it hides all margins except a line number margin. All special marker effects are removed and the selection and caret are hidden.
'
'SCI_FORMATRANGE(bool bDraw, RangeToFormat *pfr)
'SCI_SETPRINTMAGNIFICATION(int magnification)
'SCI_GETPRINTMAGNIFICATION
'SCI_SETPRINTCOLOURMODE(int mode)
'SCI_GETPRINTCOLOURMODE
'SCI_SETPRINTWRAPMODE
'SCI_GETPRINTWRAPMODE
'====================================================================
'SCI_FORMATRANGE(bool bDraw, RangeToFormat *pfr)
Public Sub FormatRange(ByVal bDraw As Boolean, pfr As RangeToFormat)
    SendMessageStruct Sci, SCI_FORMATRANGE, SciBool(bDraw), ByVal pfr
End Sub

'SCI_SETPRINTMAGNIFICATION(int magnification)
'SCI_GETPRINTMAGNIFICATION
'SCI_GETPRINTMAGNIFICATION lets you to print at a different size than the screen font. magnification is the number of points to add to the size of each screen font. A value of -3 or -4 gives reasonably small print. You can get this value with SCI_GETPRINTMAGNIFICATION.
Public Property Get PrintMagnification() As Long
Attribute PrintMagnification.VB_MemberFlags = "40"
    PrintMagnification = SendEditor(SCI_GETPRINTMAGNIFICATION)
End Property

Public Property Let PrintMagnification(ByVal Magnification As Long)
    SendEditor SCI_SETPRINTMAGNIFICATION, Magnification
End Property

'====================================================================
'SCI_SETPRINTCOLOURMODE(int mode)
'SCI_GETPRINTCOLOURMODE
'These two messages set and get the method used to render coloured text on a printer that is probably using white paper. It is especially important to consider the treatment of colour if you use a dark or black screen background. Printing white on black uses up toner and ink very many times faster than the other way around. You can set the mode to one of:
'
'Symbol Value Purpose
'SC_PRINT_NORMAL 0                  Print using the current screen colours. This is the default.
'SC_PRINT_INVERTLIGHT   1           If you use a dark screen background this saves ink by inverting the light value of all colours and printing on a white background.
'SC_PRINT_BLACKONWHITE 2            Print all text as black on a white background.
'SC_PRINT_COLOURONWHITE 3           Everything prints in its own colour on a white background.
'SC_PRINT_COLOURONWHITEDEFAULTBG 4  Everything prints in its own colour on a white background except that line numbers use their own background colour.

Public Property Get PrintColourMode() As PrintColourMode
Attribute PrintColourMode.VB_MemberFlags = "40"
    PrintColourMode = SendEditor(SCI_GETPRINTCOLOURMODE)
End Property

Public Property Let PrintColourMode(ByVal lMode As PrintColourMode)
    SendEditor SCI_SETPRINTCOLOURMODE, lMode
End Property

Private Sub Str2Byte(sInput As String, bOutput() As Byte)
    ' This function is used to convert strings to bytes
    ' This comes in handy for saving the file.  It's also
    ' useful when dealing with certain things related to
    ' sending info to Scintilla
    Dim i As Long
    ReDim bOutput(Len(sInput) - 1)
    For i = 0 To Len(sInput) - 1
      bOutput(i) = Asc(Mid(sInput, i + 1, 1))
    Next i
End Sub

'====================================================================
'====================================================================
'           Multiple views
'====================================================================
'SCI_GETDOCPOINTER
'This returns a pointer to the document currently in use by the window. It has no other effect.
Public Function GetDocPointer() As Long
    GetDocPointer = SendEditor(SCI_GETDOCPOINTER)
End Function

'SCI_SETDOCPOINTER(<unused>, document *pDoc)
'This message does the following:
'1. It removes the current window from the list held by the current document.
'2. It reduces the reference count of the current document by 1.
'3. If the reference count reaches 0, the document is deleted.
'4. pDoc is set as the new document for the window.
'5. If pDoc was 0, a new, empty document is created and attached to the window.
Public Sub SetDocPointer(pDoc As Long)
    SendEditor SCI_SETDOCPOINTER, 0, pDoc
End Sub

'SCI_CREATEDOCUMENT
'This message creates a new, empty document and returns a pointer to it.
'This document is not selected into the editor and starts with a reference count of 1. This means that you have ownership of it and must either reduce its reference count by 1 after using SCI_SETDOCPOINTER so that the Scintilla window owns it or you must make sure that you reduce the reference count by 1 with SCI_RELEASEDOCUMENT before you close the application to avoid memory leaks.
Public Function CreateDocument() As Long
    CreateDocument = SendEditor(SCI_CREATEDOCUMENT)
End Function

'SCI_ADDREFDOCUMENT(<unused>, document *pDoc)
'This increases the reference count of a document by 1. If you want to replace the current document in the Scintilla window and take ownership of the current document, for example if you are editing many documents in one window, do the following:
'1. Use SCI_GETDOCPOINTER to get a pointer to the document, pDoc.
'2. Use SCI_ADDREFDOCUMENT(0, pDoc) to increment the reference count.
'3. Use SCI_SETDOCPOINTER(0, pNewDoc) to set a different document or SCI_SETDOCPOINTER(0, 0) to set a new, empty document.
Public Sub AddRefDocument(pDoc As Long)
    SendEditor SCI_ADDREFDOCUMENT, 0, pDoc
End Sub

'SCI_RELEASEDOCUMENT(<unused>, document *pDoc)
'This message reduces the reference count of the document identified by pDoc. pDoc must be the result of SCI_GETDOCPOINTER or SCI_CREATEDOCUMENT and must point at a document that still exists. If you call this on a document with a reference count of 1 that is still attached to a Scintilla window, bad things will happen. To keep the world spinning in its orbit you must balance each call to SCI_CREATEDOCUMENT or SCI_ADDREFDOCUMENT with a call to SCI_RELEASEDOCUMENT.
Public Sub ReleaseDocument(pDoc As Long)
    SendEditor SCI_RELEASEDOCUMENT, 0, pDoc
End Sub

'====================================================================
'       General Mouse and Keyboard functions
'====================================================================
Public Function MouseX() As Long
    MouseX = MousePosX
End Function

Public Function MouseY() As Long
    MouseY = MousePosY
End Function

Public Function KeyState(ByVal KeyCode As Long) As Long
    Dim keys(0 To 255) As Byte
    ' Gets the states for all 255 virtual keys, I use this to
    ' determine the on off states of caps lock, scroll lock
    ' and num lock.
    GetKeyboardState keys(0)
    KeyState = keys(KeyCode)
    
End Function

' Returns true or false if the key is pressed or not
Public Function GetKeyState(ByVal KeyCode As Long) As Boolean
    'GetKeyState = GetAsyncKeyState(aKey)
    'vbKeyShift 16 SHIFT key
    'vbKeyControl 17 CTRL key
    'vbKeyMenu 18 MENU key
    'vbKeyInsert
    'vbKeyNumlock
    'vbKeyMenu
    'vbKeyLeft, vbKeyUp, vbKeyRight, vbKeyDown
    'vbKeyLButton 1 Left mouse button
    'vbKeyRButton 2 Right mouse button
    If GetAsyncKeyState(KeyCode) = -32767 Or GetAsyncKeyState(KeyCode) = -32768 Then
        GetKeyState = True
    Else
        GetKeyState = False
    End If
End Function
'====================================================================
'               Printing
'====================================================================
'void SciTEWin::Print(, Line 461
'C:\VBmyProjects\Scintilla\SciTE-1.64\scite\win32\SciTEWinDlg.cxx
'====================================================================
'====================================================================
' Print all document pages
Public Sub PrintAll()
    If Me.GetMeasure = 0 Then  '   '0' Metric system
        PrintPages 0, Me.GetTextLength, 2540, 2540, 2540, 2540
    Else
        PrintPages 0, Me.GetTextLength, 1000, 1000, 1000, 1000
    End If
End Sub

Public Function PrintPages(ByVal startPos As Long, ByVal endPos As Long, _
                ByVal LeftMarginWidth As Long, ByVal TopMarginHeight As Long, _
                ByVal RightMarginWidth As Long, ByVal BottomMarginHeight As Long) As Long
    
    Dim NextCharPos As Long
    Dim PagesInfo() As String
    
    PrintPages = ProcessPrintPages(startPos, endPos, _
                        LeftMarginWidth, TopMarginHeight, _
                        RightMarginWidth, BottomMarginHeight, _
                        NextCharPos, PagesInfo(), _
                        False)
End Function

Public Function PrintPagesMeasure(ByVal startPos As Long, ByVal endPos As Long, _
                ByVal LeftMarginWidth As Long, ByVal TopMarginHeight As Long, _
                ByVal RightMarginWidth As Long, ByVal BottomMarginHeight As Long, _
                ByRef NextCharPos As Long, _
                ByRef PagesInfo() As String) As Long

    PrintPagesMeasure = Me.ProcessPrintPages(startPos, endPos, _
                        LeftMarginWidth, TopMarginHeight, _
                        RightMarginWidth, BottomMarginHeight, _
                        NextCharPos, PagesInfo(), _
                        True)
End Function

Public Function ProcessPrintPages(startPos As Long, endPos As Long, _
                LeftMarginWidth As Long, TopMarginHeight As Long, _
                RightMarginWidth As Long, BottomMarginHeight As Long, _
                ByRef PrintNextCharPos As Long, _
                ByRef PagesInfo() As String, _
                Optional ByVal bMeasureOnly As Boolean = False) As Long
            
     Dim LeftOffset As Long, TopOffset As Long
     Dim LeftMargin As Long, TopMargin As Long
     Dim RightMargin As Long, BottomMargin As Long
     Dim fr As RangeToFormat, rcPage As RECT
     Dim TextLength As Long, r As Long
     Dim PhysWidth As Long, PhysHeight As Long
     Dim PrintWidth As Long, PrintHeight As Long
     Dim ptDPI As POINTAPI, ptPage As POINTAPI
     Dim rectPhysMargins As RECT, rectMargins As RECT, rectSetup As RECT
     Dim StartCharPos As Long, EndCharPos As Long, NextCharPos As Long
     Dim PageNum As Long, bCancel As Boolean
     Dim bDraw  As Long
          
     If startPos < endPos Then
        StartCharPos = startPos
        EndCharPos = endPos
    Else
        StartCharPos = endPos
        EndCharPos = startPos
    End If
    
    bDraw = SciBool(Not (bMeasureOnly))
    
    'http://support.microsoft.com/?id=kb;en-us;Q146022
    ' Start a print job to get a valid Printer.hDC
    Printer.Print Space(1)
    'Printer.ScaleMode = vbPixels
        
'    DOCINFO di = {sizeof(DOCINFO), 0, 0, 0, 0};
'    di.lpszDocName = windowName.c_str();
'    di.lpszOutput = 0;
'    di.lpszDatatype = 0;
'    di.fwType = 0;
'    if (::StartDoc(hdc, &di) < 0) {
'        SString msg = LocaliseMessage("Can not start printer document.");
'        WindowMessageBox(wSciTE, msg, MB_OK);
'        return;
'    }
    
    'hdc:           Device to render to.
    'hdcTarget:     Target device to format for.
    'rc:            Area to render to. Units are measured in twips.
    'rcPage:        Entire area of rendering device. Units are measured in twips.
    'chrg:          CHARRANGE structure that specifies the range of text to format.
        
     ' Get the offsett to the printable area on the page in twips
     'Get printer resolution
     ptDPI.X = GetDeviceCaps(Printer.hdc, LOGPIXELSX)   'dpi in X direction
     ptDPI.Y = GetDeviceCaps(Printer.hdc, LOGPIXELSY)   'dpi in Y direction
     
     'Start by getting the physical page size (in device units).
     ptPage.X = GetDeviceCaps(Printer.hdc, PHYSICALWIDTH)   'device units
     ptPage.Y = GetDeviceCaps(Printer.hdc, PHYSICALHEIGHT)  'device units
     
     'Get the dimensions of the unprintable
     'part of the page (in device units).
     rectPhysMargins.Left = GetDeviceCaps(Printer.hdc, PHYSICALOFFSETX)
     rectPhysMargins.Top = GetDeviceCaps(Printer.hdc, PHYSICALOFFSETY)
     
    'To get the right and lower unprintable area,
    'we take the entire width and height of the paper and
    'subtract everything else.
    'total paper width - printable width - left unprintable margin
     rectPhysMargins.Right = ptPage.X - GetDeviceCaps(Printer.hdc, HORZRES) _
                    - rectPhysMargins.Left
    'total paper height - printable height - right unprintable margin
    rectPhysMargins.Bottom = ptPage.Y - GetDeviceCaps(Printer.hdc, VERTRES) _
                    - rectPhysMargins.Top
     
    ' At this point, rectPhysMargins contains the widths of the
    ' unprintable regions on all four sides of the page in device units.
         
    ' Convert the hundredths of millimeters (HiMetric) or
    ' thousandths of inches (HiEnglish) margin values
    ' from the Page Setup dialog to device units.
    ' (There are 2540 hundredths of a mm in an inch.)
    
    'The MulDiv function multiplies two 32-bit values and then divides
    'the 64-bit result by a third 32-bit value. The return value is
    'rounded up or down to the nearest integer.
    
    '  0 = metric, 1 = US
    If Me.GetMeasure = 0 Then  '   '0' Metric system
        '(LeftMarginWidth * ptDPI.X)\ 2540
        rectSetup.Left = MulDiv(LeftMarginWidth, ptDPI.X, 2540)
        rectSetup.Top = MulDiv(TopMarginHeight, ptDPI.Y, 2540)
        rectSetup.Right = MulDiv(RightMarginWidth, ptDPI.X, 2540)
        rectSetup.Bottom = MulDiv(BottomMarginHeight, ptDPI.Y, 2540)
    Else                    '   '1' is US System
        rectSetup.Left = MulDiv(LeftMarginWidth, ptDPI.X, 1000)
        rectSetup.Top = MulDiv(TopMarginHeight, ptDPI.Y, 1000)
        rectSetup.Right = MulDiv(RightMarginWidth, ptDPI.X, 1000)
        rectSetup.Bottom = MulDiv(BottomMarginHeight, ptDPI.Y, 1000)
    End If
      
    'Dont reduce margins below the minimum printable area
    rectMargins.Left = Max(rectPhysMargins.Left, rectSetup.Left)
    rectMargins.Top = Max(rectPhysMargins.Top, rectSetup.Top)
    rectMargins.Right = Max(rectPhysMargins.Right, rectSetup.Right)
    rectMargins.Bottom = Max(rectPhysMargins.Bottom, rectSetup.Bottom)
      
    ' rectMargins now contains the values used to shrink the printable
    ' area of the page.
    
    ' Convert device coordinates into logical coordinates
    DPtoLP Printer.hdc, rectMargins, 2
    DPtoLP Printer.hdc, rectPhysMargins, 2
    ' Convert page size to logical units and we're done!
    DPtoLP Printer.hdc, ptPage, 1
      
    'Calculate the Left, Top, Right, and Bottom margins
    'LeftMargin = (LeftMarginWidth - LeftOffset) \ Printer.TwipsPerPixelX
    'TopMargin = (TopMarginHeight - TopOffset) \ Printer.TwipsPerPixelY
    'RightMargin = (((Printer.Width - RightMarginWidth) - LeftOffset) \ Printer.TwipsPerPixelX) + (LeftMargin + LeftOffset)
    'BottomMargin = (((Printer.Height - BottomMarginHeight) - TopOffset) \ Printer.TwipsPerPixelY) + (TopMargin + TopOffset)
    
    'Set printable area rect
    'rcPage.Left = 0
    'rcPage.Top = 0
    'rcPage.Right = Printer.ScaleWidth
    'rcPage.Bottom = Printer.ScaleHeight
    
    'Set rect in which to print (relative to printable area)
    'rcDrawTo.Left = LeftMargin
    'rcDrawTo.Top = TopMargin
    'rcDrawTo.Right = RightMargin
    'rcDrawTo.Bottom = BottomMargin
    
    'rcPage = rcDrawTo
    'Set up the print instructions
     
    'We must substract the physical margins from the printable area
    fr.rc.Left = rectMargins.Left - rectPhysMargins.Left
    fr.rc.Top = rectMargins.Top - rectPhysMargins.Top
    fr.rc.Right = ptPage.X - rectMargins.Right - rectPhysMargins.Left
    fr.rc.Bottom = ptPage.Y - rectMargins.Bottom - rectPhysMargins.Top
    
    fr.rcPage.Left = 0
    fr.rcPage.Top = 0
    fr.rcPage.Right = ptPage.X - rectPhysMargins.Left - rectPhysMargins.Right - 1
    fr.rcPage.Bottom = ptPage.Y - rectPhysMargins.Top - rectPhysMargins.Bottom - 1
    
    PageNum = 0
    Do While (StartCharPos < EndCharPos)
        'FromPage As Long, ToPage
        'Printer.NewPage                  ' Move on to next page
        Printer.Print Space(1) ' Re-initialize hDC
        'StartPage(hdc)
        
        fr.hdc = Printer.hdc
        fr.hdcTarget = Printer.hdc
        
        fr.chrg.cpMin = StartCharPos ' Starting position for next page
        fr.chrg.cpMax = EndCharPos
        
        'SCI_FORMATRANGE(bool bDraw, RangeToFormat *pfr)
        'bDraw controls if any output is done. Set this to false if you are paginating
        NextCharPos = SendMessageStruct(Sci, SCI_FORMATRANGE, bDraw, fr)
         
        PageNum = PageNum + 1
        
        If bMeasureOnly = True Then
            ReDim Preserve PagesInfo(UBound(PagesInfo) + 1)
            PagesInfo(UBound(PagesInfo)) = CStr(PageNum) & ":" & CStr(StartCharPos) & ":" & CStr(NextCharPos)
        End If
        
        Printer.NewPage
        'Printer.Page   ' Print page number.
        'EndPage(hdc)
        
        PrintNextCharPos = NextCharPos
        
        'Debug.Print "PageNum, StartCharPos, NextCharPos: "; PageNum, StartCharPos, NextCharPos
        
        If StartCharPos >= EndCharPos Then Exit Do
        
        bCancel = False
        RaiseEvent PagePrint(StartCharPos, NextCharPos, PageNum, bCancel)
        If bCancel = True Then Exit Do
        
        StartCharPos = NextCharPos
    Loop
    
    ProcessPrintPages = PageNum
    
    If bMeasureOnly = True Then
        Printer.KillDoc
    End If
    
    'Commit the print job
    Printer.EndDoc
    'EndDoc(hdc)
    
    'Allow the RTF to free up memory
    r = SendMessageStruct(Sci, SCI_FORMATRANGE, False, ByVal CLng(0))
End Function

Public Function PrintPreview(ByVal TargetDC As Long, _
                ByVal startPos As Long, ByVal endPos As Long, _
                ByVal LeftMarginWidth As Long, ByVal TopMarginHeight As Long, _
                ByVal RightMarginWidth As Long, ByVal BottomMarginHeight As Long, _
                ByRef PreviewNextCharPos As Long) As Long
    
    Dim PagesInfo() As String
    ReDim PagesInfo(0) As String
    
    PrintPreview = ProcessPrintPreview(TargetDC, _
                    startPos, endPos, _
                    LeftMarginWidth, TopMarginHeight, _
                    RightMarginWidth, BottomMarginHeight, _
                    PreviewNextCharPos, _
                    PagesInfo(), _
                    False)
End Function

Private Function ProcessPrintPreview(ByVal TargetDC As Long, _
                ByVal startPos As Long, ByVal endPos As Long, _
                ByVal LeftMarginWidth As Long, ByVal TopMarginHeight As Long, _
                ByVal RightMarginWidth As Long, ByVal BottomMarginHeight As Long, _
                ByRef PreviewNextCharPos As Long, _
                ByRef PagesInfo() As String, _
                Optional ByVal bMeasureOnly As Boolean = False) As Long
            
     Dim LeftOffset As Long, TopOffset As Long
     Dim LeftMargin As Long, TopMargin As Long
     Dim RightMargin As Long, BottomMargin As Long
     Dim fr As RangeToFormat
     Dim rcDrawTo As RECT, rcPage As RECT
     Dim TextLength As Long, lengthPrinted As Long, r As Long
     Dim PhysWidth As Long, PhysHeight As Long
     Dim PrintWidth As Long, PrintHeight As Long
     Dim ptDPI As POINTAPI, ptPage As POINTAPI
     Dim rectPhysMargins As RECT, rectMargins As RECT, rectSetup As RECT
     Dim StartCharPos As Long, EndCharPos As Long, NextCharPos As Long
     Dim bDraw As Long, bCancel As Boolean
     Dim PageNum As Long
     
     If startPos < endPos Then
        StartCharPos = startPos
        EndCharPos = endPos
    Else
        StartCharPos = endPos
        EndCharPos = startPos
    End If
     
    bDraw = SciBool(Not (bMeasureOnly))
    
    'Simply initialize the printer:
    Printer.Print ""
    'Printer.ScaleMode = vbTwips
    'Printer.ScaleMode = vbPixels
    
    'hdc:           Device to render to.
    'hdcTarget:     Target device to format for.
    'rc:            Area to render to. Units are measured in twips.
    'rcPage:        Entire area of rendering device. Units are measured in twips.
    'chrg:          CHARRANGE structure that specifies the range of text to format.
        
     ' Get the offsett to the printable area on the page in twips
     'Get printer resolution
     Dim Printerhdc As Long
     Printerhdc = Printer.hdc
     
     ptDPI.X = GetDeviceCaps(Printerhdc, LOGPIXELSX)
     ptDPI.Y = GetDeviceCaps(Printerhdc, LOGPIXELSY)
     'Debug.Print "ptDPI.X,ptDPI.X: "; ptDPI.X, ptDPI.Y
     
     'Start by getting the physical page size (in device units).
     ptPage.X = GetDeviceCaps(Printerhdc, PHYSICALWIDTH)
     ptPage.Y = GetDeviceCaps(Printerhdc, PHYSICALHEIGHT)
     
     'Get the dimensions of the unprintable
     'part of the page (in device units).
     rectPhysMargins.Left = GetDeviceCaps(Printerhdc, PHYSICALOFFSETX)
     rectPhysMargins.Top = GetDeviceCaps(Printerhdc, PHYSICALOFFSETY)
     
    'To get the right and lower unprintable area,
    'we take the entire width and height of the paper and
    'subtract everything else.
     rectPhysMargins.Right = ptPage.X - GetDeviceCaps(Printerhdc, HORZRES) - rectPhysMargins.Left
     rectPhysMargins.Bottom = ptPage.Y - GetDeviceCaps(Printerhdc, VERTRES) - rectPhysMargins.Top
     
    ' At this point, rectPhysMargins contains the widths of the
    ' unprintable regions on all four sides of the page in device units.
         
    ' Convert the hundredths of millimeters (HiMetric) or
    ' thousandths of inches (HiEnglish) margin values
    ' from the Page Setup dialog to device units.
    ' (There are 2540 hundredths of a mm in an inch.)
    '  0 = metric, 1 = US
    If Me.GetMeasure = 0 Then  '   '0' Metric system
        rectSetup.Left = MulDiv(LeftMarginWidth, ptDPI.X, 2540)
        rectSetup.Top = MulDiv(TopMarginHeight, ptDPI.Y, 2540)
        rectSetup.Right = MulDiv(RightMarginWidth, ptDPI.X, 2540)
        rectSetup.Bottom = MulDiv(BottomMarginHeight, ptDPI.Y, 2540)
    Else                    '   '1' is US System
        rectSetup.Left = MulDiv(LeftMarginWidth, ptDPI.X, 1000)
        rectSetup.Top = MulDiv(TopMarginHeight, ptDPI.Y, 1000)
        rectSetup.Right = MulDiv(RightMarginWidth, ptDPI.X, 1000)
        rectSetup.Bottom = MulDiv(BottomMarginHeight, ptDPI.Y, 1000)
    End If
      
    rectMargins.Left = Max(rectPhysMargins.Left, rectSetup.Left)
    rectMargins.Top = Max(rectPhysMargins.Top, rectSetup.Top)
    rectMargins.Right = Max(rectPhysMargins.Right, rectSetup.Right)
    rectMargins.Bottom = Max(rectPhysMargins.Bottom, rectSetup.Bottom)
      
    ' rectMargins now contains the values used to shrink the printable
    ' area of the page.

    ' Convert device coordinates into logical coordinates
    'DPtoLP Printer.hdc, rectMargins, 2
    'DPtoLP Printer.hdc, rectPhysMargins, 2
    ' Convert page size to logical units and we're done!
    'DPtoLP Printer.hdc, ptPage, 1
      
    'Calculate the Left, Top, Right, and Bottom margins
    'LeftMargin = (LeftMarginWidth - LeftOffset) \ Printer.TwipsPerPixelX
    'TopMargin = (TopMarginHeight - TopOffset) \ Printer.TwipsPerPixelY
    'RightMargin = (((Printer.Width - RightMarginWidth) - LeftOffset) \ Printer.TwipsPerPixelX) + (LeftMargin + LeftOffset)
    'BottomMargin = (((Printer.Height - BottomMarginHeight) - TopOffset) \ Printer.TwipsPerPixelY) + (TopMargin + TopOffset)
    
    'Set printable area rect
'    rcPage.Left = 0
'    rcPage.Top = 0
'    rcPage.Right = Printer.ScaleWidth
'    rcPage.Bottom = Printer.ScaleHeight
    
    'Set rect in which to print (relative to printable area)
    'rcDrawTo.Left = LeftMargin
    'rcDrawTo.Top = TopMargin
    'rcDrawTo.Right = RightMargin
    'rcDrawTo.Bottom = BottomMargin
    
    'rcPage = rcDrawTo
    'Set up the print instructions
     
    'We must substract the physical margins from the printable area
    fr.rc.Left = (rectMargins.Left - rectPhysMargins.Left)
    fr.rc.Top = (rectMargins.Top - rectPhysMargins.Top)
    fr.rc.Right = (ptPage.X - rectMargins.Right - rectPhysMargins.Left)
    fr.rc.Bottom = (ptPage.Y - rectMargins.Bottom - rectPhysMargins.Top)
    
    fr.rcPage.Left = 0
    fr.rcPage.Top = 0
    fr.rcPage.Right = (ptPage.X - rectPhysMargins.Left - rectPhysMargins.Right - 1)
    fr.rcPage.Bottom = (ptPage.Y - rectPhysMargins.Top - rectPhysMargins.Bottom - 1)
    
    'Debug.Print "PrintPreview: "; fr.rcPage.Left, fr.rcPage.Top, fr.rcPage.Right, fr.rcPage.Bottom
    
    PageNum = 0
    Do While (StartCharPos < EndCharPos)
        PageNum = PageNum + 1
        fr.hdc = TargetDC           'Device to render to.
        fr.hdcTarget = TargetDC      'Target device to format for.
        
        'hdc:           Device to render to.
        'hdcTarget:     Target device to format for.
        'Debug.Print Printer.ScaleMode
        
        'struct RangeToFormat {
        '    SurfaceID hdc;        // The HDC (device context) we print to
        '    SurfaceID hdcTarget;  // The HDC we use for measuring (may be same as hdc)
        '    PRectangle rc;        // Rectangle in which to print
        '    PRectangle rcPage;    // Physically printable page size
        '    CharacterRange chrg;  // Range of characters to print
        '};
        '
        
        fr.chrg.cpMin = StartCharPos ' Starting position for next page
        fr.chrg.cpMax = EndCharPos
        
        'SCI_FORMATRANGE(bool bDraw, RangeToFormat *pfr)
        NextCharPos = SendMessageStruct(Sci, SCI_FORMATRANGE, bDraw, fr)
        
        If bMeasureOnly = True Then
            ReDim Preserve PagesInfo(UBound(PagesInfo) + 1)
            PagesInfo(UBound(PagesInfo)) = CStr(PageNum) & ":" & CStr(StartCharPos) & ":" & CStr(NextCharPos)
        End If
        
        RaiseEvent PagePreview(StartCharPos, NextCharPos, PageNum, bMeasureOnly, bCancel)
        If bCancel = True Then Exit Do
        
        'If we are not measuring, then just do one page
        If bMeasureOnly = False Then Exit Do
        
        StartCharPos = NextCharPos
    Loop
    
Done:
    ProcessPrintPreview = PageNum
    PreviewNextCharPos = NextCharPos
    
    Printer.KillDoc
    'Commit the print job
    Printer.EndDoc
    
    'Allow the RTF to free up memory
    r = SendMessageStruct(Sci, SCI_FORMATRANGE, False, ByVal CLng(0))
End Function

'returns the page size in device units (in Dots per inch)
Public Sub PrintPageSize(LeftMarginWidth As Long, TopMarginHeight As Long, _
                RightMarginWidth As Long, BottomMarginHeight As Long, rtRC As RECT, rtPage As RECT)
            
     Dim LeftOffset As Long, TopOffset As Long
     Dim LeftMargin As Long, TopMargin As Long
     Dim RightMargin As Long, BottomMargin As Long
     Dim fr As RangeToFormat
     Dim rcDrawTo As RECT, rcPage As RECT
     Dim TextLength As Long, lengthPrinted As Long, r As Long
     Dim PhysWidth As Long, PhysHeight As Long
     Dim PrintWidth As Long, PrintHeight As Long
     Dim ptDPI As POINTAPI, ptPage As POINTAPI
     Dim rectPhysMargins As RECT, rectMargins As RECT, rectSetup As RECT
     Dim PageNum As Long, printPage As Boolean
     Dim lengthDoc  As Long
     
    'Simply initialize the printer:
    'Printer.Print
    Printer.Print
    'Printer.ScaleMode = vbTwips
    'Printer.ScaleMode = vbMillimeters
    
    'hdc:           Device to render to.
    'hdcTarget:     Target device to format for.
    'rc:            Area to render to. Units are measured in twips.
    'rcPage:        Entire area of rendering device. Units are measured in twips.
    'chrg:          CHARRANGE structure that specifies the range of text to format.
        
     ' Get the offsett to the printable area on the page in twips
     'Get printer resolution
     ptDPI.X = GetDeviceCaps(Printer.hdc, LOGPIXELSX)
     ptDPI.Y = GetDeviceCaps(Printer.hdc, LOGPIXELSY)
     
     'Start by getting the physical page size (in device units).
     ptPage.X = GetDeviceCaps(Printer.hdc, PHYSICALWIDTH)
     ptPage.Y = GetDeviceCaps(Printer.hdc, PHYSICALHEIGHT)
     
     'Debug.Print "ptPage.X, ptPage.Y: "; ptPage.X, ptPage.Y
     'ptPage.X\ptDPI.X = Paper width in inch
     'ptPage.Y\ptDPI.Y = paper height in inch
     
     'Get the dimensions of the unprintable
     'part of the page (in device units).
     rectPhysMargins.Left = GetDeviceCaps(Printer.hdc, PHYSICALOFFSETX)
     rectPhysMargins.Top = GetDeviceCaps(Printer.hdc, PHYSICALOFFSETY)
     
    'To get the right and lower unprintable area,
    'we take the entire width and height of the paper and
    'subtract everything else.
     rectPhysMargins.Right = ptPage.X - GetDeviceCaps(Printer.hdc, HORZRES) - rectPhysMargins.Left
     rectPhysMargins.Bottom = ptPage.Y - GetDeviceCaps(Printer.hdc, VERTRES) - rectPhysMargins.Top
     
    ' At this point, rectPhysMargins contains the widths of the
    ' unprintable regions on all four sides of the page in device units.
         
    ' Convert the hundredths of millimeters (HiMetric) (1/1000 cm) or
    ' thousandths of inches (HiEnglish) margin values
    ' from the Page Setup dialog to device units.
    ' (There are 2540 hundredths of a mm in an inch.)
    '  0 = metric, 1 = US
    If Me.GetMeasure = 0 Then  '   '0' Metric system
        rectSetup.Left = MulDiv(LeftMarginWidth, ptDPI.X, 2540)
        rectSetup.Top = MulDiv(TopMarginHeight, ptDPI.Y, 2540)
        rectSetup.Right = MulDiv(RightMarginWidth, ptDPI.X, 2540)
        rectSetup.Bottom = MulDiv(BottomMarginHeight, ptDPI.Y, 2540)
    Else                    '   '1' is US System
        rectSetup.Left = MulDiv(LeftMarginWidth, ptDPI.X, 1000)
        rectSetup.Top = MulDiv(TopMarginHeight, ptDPI.Y, 1000)
        rectSetup.Right = MulDiv(RightMarginWidth, ptDPI.X, 1000)
        rectSetup.Bottom = MulDiv(BottomMarginHeight, ptDPI.Y, 1000)
    End If
    
    'Debug.Print "ptDPI.X, ptDPI.Y: "; ptDPI.X, ptDPI.Y
      
    rectMargins.Left = Max(rectPhysMargins.Left, rectSetup.Left)
    rectMargins.Top = Max(rectPhysMargins.Top, rectSetup.Top)
    rectMargins.Right = Max(rectPhysMargins.Right, rectSetup.Right)
    rectMargins.Bottom = Max(rectPhysMargins.Bottom, rectSetup.Bottom)
      
    ' rectMargins now contains the values used to shrink the printable
    ' area of the page.

    ' Convert device coordinates into logical coordinates
    DPtoLP Printer.hdc, rectMargins, 2
    DPtoLP Printer.hdc, rectPhysMargins, 2
    ' Convert page size to logical units and we're done!
    DPtoLP Printer.hdc, ptPage, 1
          
    'Calculate the Left, Top, Right, and Bottom margins
    'LeftMargin = (LeftMarginWidth - LeftOffset) \ Printer.TwipsPerPixelX
    'TopMargin = (TopMarginHeight - TopOffset) \ Printer.TwipsPerPixelY
    'RightMargin = (((Printer.Width - RightMarginWidth) - LeftOffset) \ Printer.TwipsPerPixelX) + (LeftMargin + LeftOffset)
    'BottomMargin = (((Printer.Height - BottomMarginHeight) - TopOffset) \ Printer.TwipsPerPixelY) + (TopMargin + TopOffset)
    
    'Set printable area rect
'    rcPage.Left = 0
'    rcPage.Top = 0
'    rcPage.Right = Printer.ScaleWidth
'    rcPage.Bottom = Printer.ScaleHeight
    
    'Set rect in which to print (relative to printable area)
    'rcDrawTo.Left = LeftMargin
    'rcDrawTo.Top = TopMargin
    'rcDrawTo.Right = RightMargin
    'rcDrawTo.Bottom = BottomMargin
    
    'rcPage = rcDrawTo
    'Set up the print instructions
     
    'We must substract the physical margins from the printable area
    fr.rc.Left = (rectMargins.Left - rectPhysMargins.Left)
    fr.rc.Top = (rectMargins.Top - rectPhysMargins.Top)
    fr.rc.Right = (ptPage.X - rectMargins.Right - rectPhysMargins.Left)
    fr.rc.Bottom = (ptPage.Y - rectMargins.Bottom - rectPhysMargins.Top)
    
    fr.rcPage.Left = 0
    fr.rcPage.Top = 0
    fr.rcPage.Right = (ptPage.X - rectPhysMargins.Left - rectPhysMargins.Right - 1)
    fr.rcPage.Bottom = (ptPage.Y - rectPhysMargins.Top - rectPhysMargins.Bottom - 1)
    
    rtRC = fr.rc
    rtPage = fr.rcPage
    
    'Delete the doc from the printer
    Printer.KillDoc
    Printer.EndDoc
    
End Sub

'Returns the local default units system, 0 = metric, 1 = US
Public Function GetMeasure() As Long
    '0 = metric, 1 = US
    GetMeasure = CLng(GetLanguageInfo(LOCALE_IMEASURE))
End Function

Public Function GetLanguageInfo(ByVal dwLCType As Long) As String
    Dim sReturn As String, nRet As Long
    sReturn = String$(128, vbNullChar)
    nRet = GetLocaleInfo(LOCALE_USER_DEFAULT, dwLCType, sReturn, Len(sReturn))
    If nRet <> 0 Then
        GetLanguageInfo = Left$(sReturn, nRet - 1)
    Else
        GetLanguageInfo = 0
    End If
End Function

Public Function PageSetupDialog(hWndOwner As Long, ByRef Margins As RECT, MinMargins As RECT) As Boolean
    
    Dim tPageSetupDlg As PageSetupDlg
    
    With tPageSetupDlg
        ' Set the owner
        .hWndOwner = hWndOwner
        
        ' Set to Null (0&)
        .hInstance = App.hInstance ' 0&
        
        ' Set the flags so that there are minimum margins
        ' and the last margins selected were used.
        .flags = PSD_MINMARGINS + PSD_MARGINS
        
        ' Set the margins from previous select
        .rtMargin.Bottom = Margins.Bottom
        .rtMargin.Top = Margins.Top
        .rtMargin.Left = Margins.Left
        .rtMargin.Right = Margins.Right
        
        ' Set the minimum margins the user can select
        .rtMinMargin.Bottom = MinMargins.Bottom
        .rtMinMargin.Top = MinMargins.Top
        .rtMinMargin.Left = MinMargins.Left
        .rtMinMargin.Right = MinMargins.Right
        
        ' Set the size of the type structure
        .lStructSize = Len(tPageSetupDlg)
    End With
    
    
    ' Call the API function and if 0 is returned then the
    ' user select the cancel button or an error has occurred.
    ' The error might be that the minimum margins are
    ' larger than the default values
    If PageSetupDlg(tPageSetupDlg) = 0 Then
        PageSetupDialog = False
        Exit Function
    End If
    
    ' Return the paper size.
    With Margins
        .Bottom = tPageSetupDlg.rtMargin.Bottom
        .Top = tPageSetupDlg.rtMargin.Top
        .Right = tPageSetupDlg.rtMargin.Right
        .Left = tPageSetupDlg.rtMargin.Left
    End With
    
    PageSetupDialog = True
End Function

'====================================================================
'====================================================================
Public Function LoadFile(ByVal sFileName As String) As Boolean
    
    On Error GoTo ErrHandle
    
    Dim FileNumber As Long
    Dim sText As String
    
    If Dir(sFileName) = "" Then
        LoadFile = False
        Exit Function
    End If
    
    FileNumber = FreeFile   ' Get unused file
    Open sFileName For Input As #FileNumber
    sText = Input$(LOF(FileNumber), #FileNumber)
    Close #FileNumber
    
    Me.ClearAll
    Me.Text = sText
    Me.EmptyUndoBuffer
    Me.SetSavePoint
        
    Me.FileName = sFileName
    LoadFile = True
    Exit Function
    
ErrHandle:
    LoadFile = False
    Err.Raise Err.Number, UserControl.Name, Err.Description
End Function

Public Function SaveFile(ByVal sFileName As String) As Boolean
    
    Dim FileNumber As Long
    
    On Error GoTo ErrHandle
    
    FileNumber = FreeFile   ' Get unused file
    Open sFileName For Output As #FileNumber
    Print #FileNumber, Me.Text;
    Close #FileNumber
    
    Me.SetSavePoint
    
    Me.FileName = sFileName
    SaveFile = True
    Exit Function
    
ErrHandle:
    SaveFile = False
    Err.Raise Err.Number, UserControl.Name, Err.Description
End Function

Public Property Get FileName() As String
Attribute FileName.VB_MemberFlags = "400"
    FileName = m_sFileName
End Property

Public Property Let FileName(ByVal sFileName As String)
    m_sFileName = sFileName
End Property

Public Sub SplitFilePath(ByVal sFileName As String, ByRef sFile As String, ByRef sPath As String)
    
    Dim X As Long
   
    X = InStrRev(sFileName, "\")
    
    If X > 0 Then
        sPath = sFileName
        sPath = Mid(sFileName, 1, X - 1)
        sFile = Mid(sFileName, X + 1, Len(sFileName) - X)
    Else
        sFile = sFileName
        sPath = ""
    End If
End Sub

Public Function GetExtension(sFileName As String) As String
    Dim lPos As Long
    lPos = InStrRev(sFileName, ".")
    If lPos = 0 Then
        GetExtension = " "
    Else
        GetExtension = LCase$(Right$(sFileName, Len(sFileName) - lPos))
    End If
End Function

Public Function CreatePictureDC(Optional ByVal PixelWidth As Long = 1024, Optional ByVal PixelHeight As Long = 768, Optional ByVal BackColour As Long = &HFFFFFF) As Long
    On Error GoTo ErrHandler
    
    Dim hParentDC As Long
    Dim hDCMemory       As Long
    Dim hBmp            As Long
    Dim hPalPrev        As Long
    Dim RasterCapsScrn  As Long
    Dim HasPaletteScrn  As Long
    Dim PaletteSizeScrn As Long
    Dim LogPal          As LOGPALETTE
    Dim r As Long
    Dim hBmpPrev        As Long
    Dim hPal            As Long
    
    ' Create a bitmap and select it into an DC
    'hParentDC = GetDC(GetDesktopWindow())
    'Get the screen's device context.
    hParentDC = GetDC(&H0&)
    If hParentDC = 0 Then
        CreatePictureDC = 0
        Exit Function
    End If
    
    'hParentDC = CreateDC("DISPLAY", 0&, 0&, 0&)
    'hDCMemory = CreateDC(Printer.DriverName, Printer.DriverName, 0&, 0&)
    ' Create a memory device context to use
    
    'hDC: [in] Handle to an existing DC. If this handle is NULL, the function creates a memory DC compatible with the application's current screen.
    
    hDCMemory = CreateCompatibleDC(hParentDC)
    
    ' Tell'em it's a picture (so drawings can be done on the DC)
    ' Create a bitmap and place it in the memory DC.
    'Debug.Print "PixelWidth, PixelHeight: "; PixelWidth, PixelHeight
    hBmp = CreateCompatibleBitmap(hParentDC, PixelWidth, PixelHeight)
    hBmpPrev = SelectObject(hDCMemory, hBmp)
    
    'set the background color for the image and the DC to white
    Me.ClsDC hDCMemory, BackColour, PixelWidth, PixelHeight
    
    'Call SetBkColor(hDCMemory, vbWhite)
    ' Get the screen properties.
    '
    RasterCapsScrn = GetDeviceCaps(hParentDC, RASTERCAPS)   'Raster capabilities
    '&H100
    HasPaletteScrn = RasterCapsScrn And RC_PALETTE       'Palette support
    PaletteSizeScrn = GetDeviceCaps(hParentDC, SIZEPALETTE) 'Palette size
    
    ' If the screen has a palette make a copy and realize it.
    '
    If HasPaletteScrn And (PaletteSizeScrn = 256) Then
        ' Create a copy of the system palette.
        LogPal.palVersion = &H300
        LogPal.palNumEntries = 256
        r = GetSystemPaletteEntries(hParentDC, 0, 256, LogPal.palPalEntry(0))
        hPal = CreatePalette(LogPal)
        ' Select the new palette into the memory DC and realize it.
        hPalPrev = SelectPalette(hDCMemory, hPal, 0)
        r = RealizePalette(hDCMemory)
    End If
    
    'Call SetBkColor(hDCMemory, GetBkColor(hParentDC))
    'Call SetBkColor(hDCMemory, &HFFFFFF)
    'Call SetBkMode(hDCMemory, GetBkMode(hParentDC))
    
    CreatePictureDC = hDCMemory
    Call SelectObject(hdc, hBmpPrev)
    Call DeleteObject(hBmp)
    Call DeleteObject(hBmpPrev)
    Exit Function
ErrHandler:
    CreatePictureDC = 0
    Debug.Print "Error: "; Err.Description
End Function

Public Sub DeletePictureDC(hdc As Long)
    
    'Call SelectObject(hdc, hBmpPrev)
    'Call DeleteObject(hBmpPrev)
    Call DeleteDC(hdc)
    
End Sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' CreateBitmapPicture
'    - Creates a bitmap type Picture object from a bitmap and palette.
'
' hBmp
'    - Handle to a bitmap
'
' hPal
'    - Handle to a Palette
'    - Can be null if the bitmap doesn't use a palette
'
' Returns
'    - Returns a Picture object containing the bitmap
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Public Function CreatePictureFromDC(SrcDC As Long, PixelWidth As Long, PixelHeight As Long) As Picture

    Dim r As Long, hPal As Long
    Dim Pic As PicBmp
    Dim hBmp As Long
    
    'Dim tBM As Bitmap
    'GetObjectAPI hBmp, Len(tBM), tBM
    'Debug.Print "tBM: "; tBM.bmWidth, tBM.bmHeight
        
    hBmp = HBitmapFromDC(SrcDC, PixelWidth, PixelHeight)
    
    ' IPicture requires a reference to "Standard OLE Types"
    Dim IPic          As IPicture
    Dim IID_IDispatch As GUID
    '
    ' Fill in with IDispatch Interface ID
    With IID_IDispatch
        .Data1 = &H20400
        .Data4(0) = &HC0
        .Data4(7) = &H46
    End With
    '
    ' Fill Pic with the necessary parts.
    '
    hPal = &H0&
    With Pic
        .Size = Len(Pic)          ' Length of structure
        .Type = vbPicTypeBitmap   ' Type of Picture (bitmap)
        .hBmp = hBmp              ' Handle to bitmap
        .hPal = hPal              ' Handle to palette (may be null)
    End With
    
    ' Create the Picture object.
    r = OleCreatePictureIndirect(Pic, IID_IDispatch, 1, IPic)
        
    ' Return the new Picture object.
    Set CreatePictureFromDC = IPic
    'DeleteObject hBmp
    
End Function

Public Function HBitmapFromDC(ByVal lhDC As Long, _
                               ByVal lWidth As Long, _
                               ByVal lHeight As Long _
                            ) As Long

    ' Copy the bitmap in lHDC:
    Dim lhDCCopy As Long
    Dim lhBmpCopy As Long
    Dim lhBmpCopyOld As Long
    Dim lhDCC As Long
    Dim tBM As Bitmap
    
    lhDCC = CreateDC("DISPLAY" & Chr(0), ByVal 0&, ByVal 0&, ByVal 0&)
    lhDCCopy = CreateCompatibleDC(lhDCC)
    lhBmpCopy = CreateCompatibleBitmap(lhDCC, lWidth, lHeight)
    lhBmpCopyOld = SelectObject(lhDCCopy, lhBmpCopy)
    
    BitBlt lhDCCopy, 0, 0, lWidth, lHeight, lhDC, 0, 0, vbSrcCopy
    
    'lhBmpCopy = SelectObject(lhDCCopy, lhBmpCopyOld)
    
    If Not (lhDCC = 0) Then
      DeleteDC lhDCC
    End If
    If Not (lhBmpCopyOld = 0) Then
      SelectObject lhDCCopy, lhBmpCopyOld
    End If
    If Not (lhDCCopy = 0) Then
      DeleteDC lhDCCopy
    End If
    
    HBitmapFromDC = lhBmpCopy

End Function
    
Public Sub PrintTextDC(hdc As Long, ByVal Text As String, ByVal LeftX As Long, ByVal TopY As Long, ByVal rightX As Long, ByVal bottomY As Long, ByVal dtFlags As Long)
    Dim wTextParams As DRAWTEXTPARAMS
    Dim RCT As RECT

    With RCT
        .Left = LeftX
        .Top = TopY
        .Right = rightX
        .Bottom = bottomY
    End With
    wTextParams.cbSize = Len(wTextParams)

    DrawTextEx hdc, Text, Len(Text), RCT, dtFlags, wTextParams
End Sub

Public Sub SetBkColorDC(hdc As Long, Colour As Long)

    Call SetBkColor(hdc, Colour)

End Sub

Public Sub ClsDC(hdc As Long, Colour As Long, PixelWidth As Long, PixelHeight As Long)
    
    Dim hBrush As Long
    Dim RCT As RECT
    
    hBrush = CreateSolidBrush(Colour)
    With RCT
        .Left = 0
        .Top = 0
        .Right = PixelWidth
        .Bottom = PixelHeight
    End With

    Call FillRect(hdc, RCT, hBrush)
    Call DeleteObject(hBrush)
End Sub

