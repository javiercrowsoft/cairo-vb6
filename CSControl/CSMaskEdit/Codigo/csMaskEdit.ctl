VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.UserControl cMaskEdit 
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   ScaleHeight     =   3600
   ScaleWidth      =   4800
   ToolboxBitmap   =   "csMaskEdit.ctx":0000
   Begin VB.TextBox txSingleLine 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   600
      TabIndex        =   1
      Top             =   660
      Width           =   1680
   End
   Begin VB.PictureBox picButton 
      AutoRedraw      =   -1  'True
      BorderStyle     =   0  'None
      Height          =   255
      Left            =   2535
      ScaleHeight     =   255
      ScaleWidth      =   735
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   1725
      Width           =   735
   End
   Begin MSComDlg.CommonDialog cmOpenFile 
      Left            =   2310
      Top             =   870
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Menu popDates 
      Caption         =   "popDates"
      Visible         =   0   'False
      Begin VB.Menu popDate 
         Caption         =   "popDate"
         Index           =   0
      End
   End
End
Attribute VB_Name = "cMaskEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'////////
' api
'--------------------------------------------------------------------------------
' csHelp
' 23-12-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
  ' constantes
  Private Const PS_SOLID = 0
  Private Const CLR_INVALID = -1

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cMaskEdit"

Private Const C_ButtonWidth As Integer = 200
Private Const m_def_csValue = 0 'Default Property Values:
' estructuras
' variables privadas

Private m_ShowingHelp     As Boolean

Private m_FlagInside      As Boolean
Private m_Editing         As Boolean
Private m_NoLostFocus     As Boolean
Private m_Status          As STATUS_BUTTON

Private m_Mask            As String
Private m_BorderType      As csBorderType
Private m_ButtonColor     As Long
Private m_BorderColor     As Long

Private m_FormatNumber    As String

Private m_FileFilter  As String

Private m_InputDisabled As Boolean

'Property Variables:
Private m_csType As csTextMascara

Private m_SepDecimal As String

Private m_NoRaiseError As Boolean
Private m_NoSel        As Boolean

Private m_NotRaiseError As Boolean
Private m_WithOutCalc   As Boolean

Private m_ButtonStyle   As csButtonStyle
Private m_NoFormat      As Boolean

Private m_ForeColor     As Long

#If Not PREPROC_SFS2 Then
Private WithEvents m_Calendar  As fCalendar
Attribute m_Calendar.VB_VarHelpID = -1
#End If

Private m_ValidKeys   As String

Private m_EnabledNoChngBkColor  As Boolean

Private m_FormatDate      As String

Private m_bCtrlPressed    As Boolean

Private m_bNegative       As Boolean

' Eventos
Public Event Change()
Public Event KeyPress(KeyAscii As Integer)
Public Event KeyDown(KeyCode As Integer, Shift As Integer)
Public Event KeyUp(KeyCode As Integer, Shift As Integer)
Public Event ButtonClick(ByRef Cancel As Boolean)
Public Event ReturnFromHelp()

' propiedades publicas

Public Property Get InputDisabled() As Boolean
  InputDisabled = m_InputDisabled
End Property

Public Property Let InputDisabled(ByVal rhs As Boolean)
  m_InputDisabled = rhs
End Property

Public Property Get FileFilter() As String
  FileFilter = m_FileFilter
End Property

Public Property Let FileFilter(ByVal rhs As String)
  m_FileFilter = rhs
End Property

Public Property Get PasswordChar() As String
  PasswordChar = txSingleLine.PasswordChar
End Property

Public Property Let PasswordChar(ByVal rhs As String)
  txSingleLine.PasswordChar = rhs
End Property

Public Property Get csNotRaiseError() As Boolean
  csNotRaiseError = m_NotRaiseError
End Property

Public Property Let csNotRaiseError(ByVal rhs As Boolean)
  m_NotRaiseError = rhs
End Property

Public Property Get csWithOutCalc() As Boolean
  csWithOutCalc = m_WithOutCalc
End Property

Public Property Let csWithOutCalc(ByVal rhs As Boolean)
  m_WithOutCalc = rhs
End Property

Public Property Get Text() As String
  ' Tratamiento especial para fechas
  If m_csType = csMkDate Then
    If txSingleLine.Text = "" Then
      Text = pSetFormatText(, csNoDate)
    Else
      Text = txSingleLine.Text
    End If
  Else
    Text = pSetFormatText()
  End If
End Property

Public Property Get ShowingHelp() As Boolean
  ShowingHelp = m_ShowingHelp
End Property

Public Property Let Text(ByVal rhs As String)
  Dim Color As Long
  
  m_bNegative = False
  
  If Not pValidValue(rhs) Then
    
    If rhs = "-" And (m_csType = csMkDouble Or m_csType = csMkInteger Or m_csType = csMkMoney Or m_csType = csMkPercent) Then
      
      m_bNegative = True
      
      If LenB(txSingleLine.Text) = 0 Then
        txSingleLine.Text = "0"
      End If
    
    End If
    
    Exit Property
      
  End If
  
  If m_csType = csMkDate Then
    
    pValidDate rhs
  
  Else

    With txSingleLine
      .Text = pSetFormatText(Color, rhs)
      .ForeColor = Color
    End With
  End If
End Property

Public Property Get Alignment() As AlignmentConstants
  Alignment = txSingleLine.Alignment
End Property

Public Property Let Alignment(ByVal rhs As AlignmentConstants)
  txSingleLine.Alignment = rhs
End Property

Public Property Get BackColor() As OLE_COLOR
  BackColor = txSingleLine.BackColor
End Property

Public Property Let BackColor(ByVal rhs As OLE_COLOR)
  txSingleLine.BackColor = rhs
End Property

Public Property Get Enabled() As Boolean
  Enabled = UserControl.Enabled
End Property

Public Property Let EnabledNoChngBkColor(ByVal rhs As Boolean)
  m_EnabledNoChngBkColor = rhs
End Property

Public Property Get EnabledNoChngBkColor() As Boolean
  EnabledNoChngBkColor = m_EnabledNoChngBkColor
End Property

Public Property Let Enabled(ByVal rhs As Boolean)
  UserControl.Enabled = rhs
  
  If m_EnabledNoChngBkColor Then Exit Property
  If rhs Then
    BackColor = &H80000005
  Else
    BackColor = &H80000004
  End If
  pDrawBorder
End Property

Public Property Get Font() As Font
  Set Font = Ambient.Font
End Property

Public Property Set Font(ByVal rhs As Font)
  Set txSingleLine.Font = rhs
End Property

Public Property Get FontBold() As Boolean
  FontBold = txSingleLine.FontBold
End Property

Public Property Let FontBold(ByVal rhs As Boolean)
  txSingleLine.FontBold = rhs
End Property

Public Property Get FontItalic() As Boolean
  FontItalic = txSingleLine.FontItalic
End Property

Public Property Let FontItalic(ByVal rhs As Boolean)
  txSingleLine.FontItalic = rhs
End Property

Public Property Get FontName() As String
  FontName = txSingleLine.FontName
End Property

Public Property Let FontName(ByVal rhs As String)
  txSingleLine.FontName = rhs
End Property

Public Property Get FontSize() As Single
  FontSize = txSingleLine.FontSize
End Property

Public Property Let FontSize(ByVal rhs As Single)
  txSingleLine.FontSize = rhs
End Property

Public Property Get FontStrikethru() As Boolean
  FontStrikethru = txSingleLine.FontStrikethru
End Property

Public Property Let FontStrikethru(ByVal rhs As Boolean)
  txSingleLine.FontStrikethru = rhs
End Property

Public Property Get FontUnderline() As Boolean
  FontUnderline = txSingleLine.FontUnderline
End Property

Public Property Let FontUnderline(ByVal rhs As Boolean)
  txSingleLine.FontUnderline = rhs
End Property

Public Property Get ForeColor() As OLE_COLOR
  ForeColor = m_ForeColor
End Property

Public Property Let ForeColor(ByVal rhs As OLE_COLOR)
  m_ForeColor = rhs
  txSingleLine.ForeColor = rhs
End Property

Public Property Get ButtonStyle() As csButtonStyle
  ButtonStyle = m_ButtonStyle
End Property

Public Property Let ButtonStyle(ByVal rhs As csButtonStyle)
  m_ButtonStyle = rhs
  UserControl_Resize
End Property

Public Property Get NoFormat() As Boolean
  NoFormat = m_NoFormat
End Property

Public Property Let NoFormat(ByVal rhs As Boolean)
  m_NoFormat = rhs
  UserControl_Resize
End Property

Public Property Get csType() As csTextMascara
  csType = m_csType
End Property

Public Property Let csType(ByVal rhs As csTextMascara)
  m_csType = rhs
  
  txSingleLine.MaxLength = 0
  
  Select Case m_csType
    Case csMkDouble, csMkMoney, csMkInteger, csMkPercent
      Alignment = vbRightJustify
      txSingleLine.Text = ""
    
    Case csMkDate
      pCreateMenu
      pFillValidKeys
      Alignment = vbRightJustify
      txSingleLine.Text = ""
    
    Case csMkTime
      Alignment = vbRightJustify
      txSingleLine.Text = pFormatTime(#12:00:00 AM#)
      ButtonStyle = cButtonNone
      txSingleLine.MaxLength = 5
    
    Case csMkText, csMkFolder, csMkFile
      Alignment = vbLeftJustify
  End Select
End Property

Public Property Get csDateName() As String
  Dim dn As cDateName
  Dim txt As String
  
  txt = txSingleLine.Text

  If pIsDateName(txt, dn) Then
    csDateName = dn.Code
  Else
    csDateName = ""
  End If
End Property

Public Sub SetText(ByVal Value As String)
  txSingleLine.Text = Value
End Sub

Public Property Get csValue() As String
  Dim Value As String
  Dim txt   As String
  
  txt = txSingleLine.Text
  
  If csType = csMkText Or csType = csMkFolder Or csType = csMkFile Then
    csValue = txt
    Exit Property
  End If
  
  If txt = "" Then
    If csType = csMkDate Then
      csValue = csNoDate
      Exit Property
    ElseIf csType = csMkTime Then
      csValue = pFormatTime(#12:00:00 AM#)
      Exit Property
    Else
      csValue = "0"
      Exit Property
    End If
  End If
  
  Value = Trim(txt)
  Value = Replace(Value, "%", "")
  Value = Replace(Value, "$", "")
  
  ' si solo tipeo el signo, tengo un cero
  If (Value = "-" Or Value = "+") And pIsNumericOrDateType Then Value = "0"
  
  If Not (IsNumeric(Value) Or IsDate(Value) Or pIsDateName(Value, Nothing) Or InStr(1, Value, "%") > 0) Then
    Value = "0"
  End If
  
  Select Case m_csType
    Case csMkDouble
      csValue = Trim(CDbl(Value))
    Case csMkInteger
      csValue = Trim(CLng(Value))
    Case csMkMoney
      csValue = Trim(CDbl(Value))
    Case csMkPercent
      csValue = CDbl(Value)
    Case csMkTime
      csValue = pFormatTime(Value)
    Case csMkDate
      Dim dn As cDateName
      If pIsDateName(Value, dn) Then
        csValue = dn.Value
      ElseIf IsDate(Value) Then
        csValue = DateValue(Value)
      Else
        csValue = csNoDate
      End If
  End Select
End Property

Public Property Let csValue(ByVal New_csValue As String)
  Text = New_csValue
End Property

Public Property Let csValueFromGrilla(ByVal New_csValue As String)
  m_NoRaiseError = True
  m_NoSel = True
  Text = New_csValue
End Property

Public Property Get ButtonColor() As OLE_COLOR
  ButtonColor = m_ButtonColor
End Property
Public Property Let ButtonColor(ByVal rhs As OLE_COLOR)
  m_ButtonColor = rhs
  picButton.BackColor = rhs
  pSetCaptionButton
End Property
Public Property Get BorderColor() As OLE_COLOR
  BorderColor = m_BorderColor
End Property
Public Property Let BorderColor(ByVal rhs As OLE_COLOR)
  m_BorderColor = rhs
  pDrawSelectionBox UNPRESSED
  pDrawBorder
End Property

Public Property Get BorderType() As csBorderType
  BorderType = m_BorderType
End Property
Public Property Let BorderType(ByVal rhs As csBorderType)
  m_BorderType = rhs
  UserControl_Paint
End Property

Public Property Get FormatNumber() As String
  FormatNumber = m_FormatNumber
End Property

Public Property Let FormatNumber(ByVal rhs As String)
  m_FormatNumber = rhs
End Property

Public Property Get Mask() As String
  Mask = m_Mask
End Property

Public Property Let Mask(ByVal rhs As String)
  m_Mask = rhs
  txSingleLine.MaxLength = Len(rhs)
End Property

Public Property Get MaxLength() As Integer
  MaxLength = txSingleLine.MaxLength
End Property

Public Property Let MaxLength(ByVal rhs As Integer)
  txSingleLine.MaxLength = rhs
End Property

Public Property Get SelStart() As Integer
  SelStart = txSingleLine.SelStart
End Property

Public Property Let SelStart(ByVal position As Integer)
  txSingleLine.SelStart = position
End Property

Public Property Get SelLength() As Integer
  SelLength = txSingleLine.SelLength
End Property

Public Property Let SelLength(ByVal rhs As Integer)
  txSingleLine.SelLength = rhs
End Property

' funciones publicas

Public Sub Edit()
  txSingleLine_GotFocus
End Sub

Public Sub ShowHelp()
#If Not PREPROC_SFS2 Then
  Dim offsetLeft As Integer
  
  If m_WithOutCalc Then Exit Sub
    
  ' El left se calcula con prioridad derecha.
  ' si la calculadora no cabe en la pantalla se alinea a la izquierda
  
  ' Obtengo el desplazamiento izquierdo
  offsetLeft = pLeftControlToLeftForm(hWnd)
  
  If m_csType = csMkDate Then
    
    Set m_Calendar = fCalendar
    
    With fCalendar
      .BorderColor = m_BorderColor
      .Top = pTopControlToTopForm(hWnd, Height) - 10
      If .Top + .Height > Screen.Height Then
        .Top = .Top - .Height - UserControl.Height + 20
      End If
      .Left = offsetLeft
      If .Left + .Width > Screen.Width Then
        .Left = Screen.Width - .Width - 20
      End If
      
      If Screen.Height < .Top + .Height Or .Top < 0 Then
      
        If Screen.Height < .Top + .Height Then
          .Top = Screen.Height - .Height / 2
        End If
        
        If .Top < 0 Then .Top = 0
      End If
    End With
    
    With fCalendar.clCalendar
      .GetDate csValue
      
      m_ShowingHelp = True
        
      fCalendar.Show vbModal
      
      m_ShowingHelp = False
    
      If fCalendar.Ok Then
        txSingleLine.Text = pFormatDateSerial(.vDay, .vMonth, .vYear)
      End If

    End With
    
    Unload fCalendar
    Set fCalendar = Nothing
    Set m_Calendar = Nothing
    
    SetFocusControl txSingleLine
  
  ElseIf m_csType = csMkFolder Then
  
    Dim Fld   As cFolder
    Dim sPath As String
    
    Set Fld = New cFolder
    
    sPath = Fld.SelectFolder(UserControl.hWnd)
    
    If sPath <> "" Then
      txSingleLine.Text = sPath
    End If
    
    Set Fld = Nothing
    
    SetFocusControl txSingleLine
    
  ElseIf m_csType = csMkFile Then
    
    Dim File As CSKernelFile.cFile
    Set File = New CSKernelFile.cFile
    
    File.Init "ShowHelp", C_Module, cmOpenFile
    File.Filter = m_FileFilter
    If Not File.FOpen("", CSKernelFile.csFile.csRead, , False, , True, True) Then Exit Sub
    
    txSingleLine.Text = File.FullName
    
    Set File = Nothing
    
    SetFocusControl txSingleLine
  
  Else
  
    With fCalc
      .Top = pTopControlToTopForm(hWnd, Height) - 10
      If .Top + .Height > Screen.Height Then
        .Top = .Top - .Height - UserControl.Height + 20
      End If
      .Left = offsetLeft
      If .Left + .Width > Screen.Width Then
        .Left = Screen.Width - .Width - 20
      End If
      .LbDisplay.Caption = csValue
    End With
    
    m_ShowingHelp = True
    
    fCalc.Show vbModal
    
    m_ShowingHelp = False
  
    If Not fCalc.Cancel Then
      Text = fCalc.LbDisplay
    End If
    
    Unload fCalc
    Set fCalc = Nothing
    
    SetFocusControl txSingleLine
  End If
  
  RaiseEvent ReturnFromHelp
#End If
End Sub

' funciones privadas
#If Not PREPROC_SFS2 Then
Private Sub m_Calendar_ShowPopMenuDates()
  On Error Resume Next
  PopupMenu popDates
End Sub

Private Sub popDate_Click(Index As Integer)
  On Error Resume Next
  Text = popDate.Item(Index).Tag
  
  fCalendar.Hide
  
  pValidDate txSingleLine.Text
End Sub
#End If

'//////////////////////////////////////////////////////////////////
' carga
Private Sub UserControl_Initialize()
  On Error Resume Next
  VerInitialise
  txSingleLine.BorderStyle = 0
  Me.BorderType = cSingle
  m_SepDecimal = GetSepDecimal
  m_FormatDate = pGetStrFormatDate
  With UserControl
    .Width = 2000
    .Height = 315
  End With
End Sub

Private Function pGetStrFormatDate() As String
  Dim strDate As String
  strDate = #12/31/2000#
  
  If IsNumeric(Left$(strDate, 2)) Then
    If CDbl(Left$(strDate, 2)) = 20 Then
      pGetStrFormatDate = "yyyy/mm/dd"
    ElseIf CDbl(Left$(strDate, 2)) = 12 Then
      pGetStrFormatDate = "mm/dd/yyyy"
    Else
      pGetStrFormatDate = "dd/mm/yyyy"
    End If
  End If
End Function

Private Sub UserControl_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  
  If pIsNumericOrDateType Then
    If (KeyCode = vbKeyF4 Or KeyCode = vbKeyC) And Shift = 0 Then
      ShowHelp
    End If
  End If
End Sub

Private Function pIsNumericType() As Boolean
  Select Case m_csType
    Case csMkMoney, csMkInteger, csMkDouble, csMkPercent
      pIsNumericType = True
    Case Else
      pIsNumericType = False
  End Select
End Function

Private Function pIsNumericOrDateType() As Boolean
  Select Case csType
  Case csMkMoney, csMkInteger, csMkDouble, csMkPercent, csMkDate, csMkTime
    pIsNumericOrDateType = True
  Case Else
    pIsNumericOrDateType = False
  End Select
End Function

Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  On Error Resume Next
  If X > UserControl.ScaleWidth - picButton.Width Then
    UserControl_Paint
  End If
End Sub

Private Sub UserControl_Resize()
  On Error Resume Next
  Dim InternalFrame As Single
  Dim buttonWidth   As Integer
  
  If m_BorderType = cNone Then
    InternalFrame = 0
  Else
    InternalFrame = 15
  End If
  
  If m_ButtonStyle = cButtonNone Then
    buttonWidth = 0
  Else
    buttonWidth = C_ButtonWidth
  End If
  
  If m_ButtonStyle = cButtonNone Then
    buttonWidth = InternalFrame
    picButton.Visible = False
  Else
    picButton.Visible = True
    picButton.Move ScaleWidth - buttonWidth, InternalFrame, buttonWidth, ScaleHeight - InternalFrame * 2
  End If
    
  txSingleLine.Move InternalFrame, InternalFrame, _
                    ScaleWidth - buttonWidth - InternalFrame, _
                    ScaleHeight - InternalFrame * 2
           
  pDrawSelectionBox UNPRESSED
End Sub

Private Sub UserControl_InitProperties()
  On Error Resume Next
  txSingleLine.Text = ""
  csType = csMkMoney
  m_SepDecimal = GetSepDecimal
  ButtonColor = &H8000000F
  BorderColor = vbButtonShadow
  BackColor = vbWindowBackground
  m_BorderType = cNone
  m_FormatNumber = ""
  m_NotRaiseError = True
  m_WithOutCalc = False
  ButtonStyle = cButtonSingle
  NoFormat = False
End Sub

#If Not PREPROC_SFS2 Then
Private Sub UserControl_Terminate()
  On Error Resume Next
  Unload fCalendar
  Set fCalendar = Nothing
  Unload fCalc
  Set fCalc = Nothing
  Set m_Calendar = Nothing
End Sub
#End If

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
  On Error Resume Next
    
  PropBag.WriteProperty "Text", txSingleLine.Text, ""
  PropBag.WriteProperty "Alignment", txSingleLine.Alignment, 0
  PropBag.WriteProperty "BackColor", txSingleLine.BackColor, &H80000005
  PropBag.WriteProperty "Font", txSingleLine.Font, Ambient.Font
  PropBag.WriteProperty "FontBold", txSingleLine.FontBold, 0
  PropBag.WriteProperty "FontItalic", txSingleLine.FontItalic, 0
  PropBag.WriteProperty "FontName", txSingleLine.FontName, ""
  PropBag.WriteProperty "FontSize", txSingleLine.FontSize, 0
  PropBag.WriteProperty "FontStrikethru", txSingleLine.FontStrikethru, 0
  PropBag.WriteProperty "FontUnderline", txSingleLine.FontUnderline, 0
  PropBag.WriteProperty "ForeColor", m_ForeColor, vbWindowText
  PropBag.WriteProperty "MaxLength", txSingleLine.MaxLength, 0
  PropBag.WriteProperty "PasswordChar", txSingleLine.PasswordChar, ""
  PropBag.WriteProperty "MultiLine", txSingleLine.MultiLine, False
  
  PropBag.WriteProperty "Enabled", UserControl.Enabled, True
  PropBag.WriteProperty "EnabledNoChngBkColor", m_EnabledNoChngBkColor, True
  PropBag.WriteProperty "Text", Text, Extender.Name
  PropBag.WriteProperty "csType", m_csType, csMkMoney
  PropBag.WriteProperty "ButtonColor", m_ButtonColor, &H8000000F
  PropBag.WriteProperty "BorderColor", m_BorderColor, vbButtonShadow
  PropBag.WriteProperty "BorderType", m_BorderType, cNone
  PropBag.WriteProperty "FormatNumber", m_FormatNumber, ""
  PropBag.WriteProperty "csNotRaiseError", m_NotRaiseError, 0
  PropBag.WriteProperty "csWithOutCalc", m_WithOutCalc, 0
  PropBag.WriteProperty "ButtonStyle", m_ButtonStyle, cButtonSingle
  PropBag.WriteProperty "NoFormat", m_NoFormat, 0
  PropBag.WriteProperty "Mask", m_Mask, ""
  PropBag.WriteProperty "InputDisabled", m_InputDisabled, False

End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
  On Error Resume Next
  Text = PropBag.ReadProperty("Text", "")
  BackColor = PropBag.ReadProperty("BackColor", &H80000005)
  Enabled = PropBag.ReadProperty("Enabled", True)
  Set Font = PropBag.ReadProperty("Font", Ambient.Font)
  FontBold = PropBag.ReadProperty("FontBold", 0)
  FontItalic = PropBag.ReadProperty("FontItalic", 0)
  FontName = PropBag.ReadProperty("FontName", "MS Sans Serif")
  FontSize = PropBag.ReadProperty("FontSize", 10)
  FontStrikethru = PropBag.ReadProperty("FontStrikethru", 0)
  FontUnderline = PropBag.ReadProperty("FontUnderline", 0)
  ForeColor = PropBag.ReadProperty("ForeColor", vbWindowText)
  MaxLength = PropBag.ReadProperty("MaxLength", 0)
  PasswordChar = PropBag.ReadProperty("PasswordChar", "")
  ButtonColor = PropBag.ReadProperty("ButtonColor", &H8000000F)
  BorderColor = PropBag.ReadProperty("BorderColor", vbButtonShadow)
  
  If IsXp Then
    BorderColor = &HB99D7F
  End If
  
  BorderType = PropBag.ReadProperty("BorderType", cNone)
  m_NotRaiseError = PropBag.ReadProperty("csNotRaiseError", True)
  m_WithOutCalc = PropBag.ReadProperty("csWithOutCalc", False)
  ButtonStyle = PropBag.ReadProperty("ButtonStyle", cButtonSingle)
  EnabledNoChngBkColor = PropBag.ReadProperty("EnabledNoChngBkColor", False)
  NoFormat = PropBag.ReadProperty("NoFormat", 0)
  Mask = PropBag.ReadProperty("Mask", "")
  FormatNumber = PropBag.ReadProperty("FormatNumber", "")
  csType = PropBag.ReadProperty("csType", csMkMoney)
  Alignment = PropBag.ReadProperty("Alignment", 0)
  InputDisabled = PropBag.ReadProperty("InputDisabled", False)
End Sub

Private Sub UserControl_Paint()
  On Error Resume Next
  UserControl_Resize
  pDrawBorder
End Sub


'//////////////////////////////////////////////////////////////////
' eventos
Private Sub picButton_Click()
  On Error GoTo ControlError
  
  Dim Cancel As Boolean
  
  If Not Me.Enabled Then Exit Sub
  
  ' Para que se ejecute el lostfocus de los demas controles
  DoEvents
  pDrawSelectionBox PRESSED
  DoEvents
  
  RaiseEvent ButtonClick(Cancel)
  
  If Not Cancel And csType <> csMkText Then
    SetFocusControl txSingleLine
    ShowHelp
  End If
  
  ' Como el foco esta en el control, el control se levanta
  Sleep 200
  pDrawSelectionBox MOUSE_MOVE
  m_FlagInside = False
  pHideButton
  
  
  GoTo ExitProc
ControlError:
  MngError Err, "picButton_Click", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub picButton_GotFocus()
  On Error Resume Next
  m_Editing = True
  pDrawSelectionBox MOUSE_MOVE
  
  m_NoLostFocus = True
End Sub

Private Sub picButton_LostFocus()
  On Error Resume Next
  pDrawSelectionBox UNPRESSED
  
  m_NoLostFocus = False
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  If m_NoLostFocus Then
    m_NoLostFocus = False
    Exit Sub
  End If
End Sub

Private Sub picButton_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  On Error Resume Next
  Dim ret As Long
  Dim iWidth As Integer
  
  If X < 0 Or X > picButton.Width Or Y < 0 Or Y > picButton.Height Then
  
    pHideButton
  
  Else
    ' el punto esta dentro del control
    If m_FlagInside = False Then
      m_FlagInside = True
      ret = SetCapture(picButton.hWnd)
      pDrawSelectionBox MOUSE_MOVE
    End If
  End If
End Sub

Private Sub pHideButton()
  m_FlagInside = False
  ReleaseCapture
  UserControl_Paint
End Sub

Private Sub pValidTime(ByVal txt As String)
  With txSingleLine
    If txt = "24" Then
      .Text = "23:59"
    ElseIf InStr(1, txt, ":") = 0 Then
      .Text = txt & ":0"
    ElseIf Right$(txt, 1) = ":" Then
      .Text = txt & "0"
    ElseIf Left$(txt, 1) = ":" Then
      .Text = "0" & txt
    ElseIf Len(txt) > 0 Then
      If Mid(txt, Len(txt) - 1, 1) = ":" Then
        .Text = Left$(txt, Len(txt) - 2) & ":" & Right$(txt, 1) & "0"
      End If
    End If
    If Not IsDate(.Text) Then
      .Text = pFormatTime(#12:00:00 AM#)
      .ForeColor = vbRed
    Else
      .Text = pFormatTime(.Text)
      .ForeColor = m_ForeColor
    End If
  End With
End Sub

Private Sub pValidDate(ByVal txt As String)
  Dim dn As cDateName
  Dim Color As Long

  If pIsDateName(txt, dn) Then
    txt = dn.Code & " (" & dn.Value & ")"
    Color = vbBlue
  ElseIf pIsDate(txt) Then
    txt = pFormatDate(txt)
    Color = m_ForeColor
  ElseIf pIsDateFormula(txt) Then
    txt = pProcessDateFormula(txt)
  Else
    txt = pFormatDate(csNoDate)
    Color = vbRed
  End If
  
  If IsDate(txt) Then
    If txt = csNoDate Then txt = ""
  End If

  txSingleLine.Text = txt
  txSingleLine.ForeColor = Color
End Sub

Private Function pIsDate(ByRef Value As Variant) As Boolean
  If Not IsDate(Value) Then
    
    Dim i As Long
    For i = 1 To Len(Value)
      Select Case Mid$(Trim$(Value), i, 1)
        Case "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
        Case Else
          Exit Function
      End Select
      
    Next
    
    Dim sDate As String
    Dim nAux  As Long
    
    Select Case Len(Value)
      Case 2
        nAux = Val(Value)
        If nAux > 0 And nAux < 32 Then
          sDate = nAux & "/" & Month(Date) & "/" & Year(Date)
        Else
          Exit Function
        End If
        If Not IsDate(sDate) Then Exit Function
      
      Case 4
        nAux = Val(Left$(Value, 2))
        If nAux > 0 And nAux < 32 Then
          sDate = nAux
        Else
          Exit Function
        End If
        nAux = Val(Right$(Value, 2))
        If nAux > 0 And nAux < 13 Then
          sDate = sDate & "/" & nAux & "/" & Year(Date)
        Else
          Exit Function
        End If
        If Not IsDate(sDate) Then Exit Function
      
      Case 6, 8
        nAux = Val(Left$(Value, 2))
        If nAux > 0 And nAux < 32 Then
          sDate = nAux
        Else
          Exit Function
        End If
        nAux = Val(Mid$(Value, 3, 2))
        If nAux > 0 And nAux < 13 Then
          sDate = sDate & "/" & nAux
        Else
          Exit Function
        End If
        
        nAux = Val(Mid$(Value, 5))
        sDate = sDate & "/" & nAux
        If Not IsDate(sDate) Then Exit Function
      
    End Select
    
    Value = sDate
    
  End If

  pIsDate = True

End Function

Private Function pIsDateFormula(ByVal strDate As String) As Boolean
  Dim n As Long
  
  n = InStr(1, strDate, "*")
  
  ' Si no tiene un * no es una fecha por formula
  '
  If n = 0 Then
    Dim s As String
    s = Left$(strDate, 1)
    If s <> "-" And s <> "+" Then
      Exit Function
    End If
  End If
  
  Dim sFormula  As String
  
  sFormula = Mid$(strDate, n + 1)
  
  Dim i As Long
  
  For i = 0 To 9
    sFormula = Replace(sFormula, i, vbNullString)
  Next
  
  Select Case sFormula
    Case "+a", "+d", "+m", "+s", _
         "a", "d", "m", "s", _
         "-a", "-d", "-m", "-s", _
         "", "+", "-"
      
      pIsDateFormula = True
  End Select
  
End Function

Private Function pProcessDateFormula(ByVal strDate As String) As Date
  Dim n As Long
  
  n = InStr(1, strDate, "*")
  
  ' Si no tiene un * no es una fecha por formula
  '
  If n = 0 Then
    Dim s As String
    s = Left$(strDate, 1)
    If s <> "-" And s <> "+" Then
      Exit Function
    End If
  End If
  
  Dim sDate     As String
  Dim sFormula  As String
  
  If n > 0 Then
  
    sDate = Left$(strDate, n - 1)
    sFormula = Mid$(strDate, n + 1)
    
  Else
  
    sDate = "H"
    sFormula = strDate
    
  End If
  
  Dim i         As Long
  Dim c         As String
  Dim toAdd     As Long
  Dim interval  As String
  Dim sign      As Long
  
  For i = 1 To Len(sFormula)
    c = Mid$(sFormula, i, 1)
    If IsNumeric(c) Then
      toAdd = toAdd & c
    End If
  Next
  
  For i = 0 To 9
    sFormula = Replace(sFormula, i, vbNullString)
  Next
  
  Select Case sFormula
    Case "", "+"
      interval = "d"
      sign = 1
    Case "-"
      interval = "d"
      sign = -1
    Case "+a", "a"
      interval = "yyyy"
      sign = 1
    Case "+d", "d"
      interval = "d"
      sign = 1
    Case "+m", "m"
      interval = "m"
      sign = 1
    Case "+s", "s"
      interval = "w"
      sign = 1
      
    Case "-a"
      interval = "yy"
      sign = -1
    Case "-d"
      interval = "d"
      sign = -1
    Case "-m"
      interval = "m"
      sign = -1
    Case "-s"
      interval = "w"
      sign = -1
  End Select
  
  Dim dn As cDateName

  If pIsDateName(sDate, dn) Then
    sDate = dn.Value
  ElseIf Not pIsDate(sDate) Then
    sDate = Date
  Else
    sDate = pFormatDate(sDate)
  End If
  
  If IsDate(sDate) Then
    pProcessDateFormula = DateAdd(interval, toAdd * sign, sDate)
  Else
    pProcessDateFormula = csNoDate
  End If
  
End Function

Private Function pSetFormatText(Optional ByRef Color As Long, Optional ByVal Text As Variant) As String
  Dim rtn As String
  
  Color = m_ForeColor
  
  rtn = txSingleLine.Text
  
  If Not IsMissing(Text) Then
    rtn = Text
  End If
  
  pSetFormatText = rtn
  
  If csType = 0 Then Exit Function
  
  ' Si es texto no hago nada
  If csType = csMkText And Mask = "" Then Exit Function
  If csType = csMkFolder Then Exit Function
  If csType = csMkFile Then Exit Function
  If m_NoFormat Then Exit Function

  rtn = Trim(rtn)
  
  If csType = csMkText Then
    
    pSetFormatText = pSetMask(rtn)
  
  ElseIf csType = csMkDate Then
  
    rtn = pFormatDate(rtn)
    pSetFormatText = rtn
  
  ElseIf csType = csMkTime Then
  
    rtn = pFormatTime(rtn)
    pSetFormatText = rtn
  
  Else
    
    ' Elimino formateos
    If InStr(1, rtn, "%") Then
      rtn = Trim(Replace(rtn, "%", ""))
    End If
    
    ' si solo tipeo un signo lo reemplazo por un cero
    If rtn = "-" Or rtn = "+" Or rtn = "" Then
      rtn = "0"
    End If
    
    If IsNumeric(rtn) Then
      If CDbl(rtn) < -1 Then Color = vbRed
    Else
      rtn = "0"
    End If
    
    If m_FormatNumber <> "" Then
      Select Case m_csType
        Case csMkDouble, csMkInteger, csMkMoney, csMkPercent
          pSetFormatText = Format(rtn, m_FormatNumber)
      End Select
    
    Else
      Select Case m_csType
        Case csMkDouble
          pSetFormatText = Format(rtn, "#,###,##0.00##")
        Case csMkInteger
          pSetFormatText = Format(rtn, "#,###,##0")
        Case csMkMoney
          pSetFormatText = Format(rtn, "$ #,###,##0.00##;($ #,###,##0.00##)")
        Case csMkPercent
          pSetFormatText = Format(rtn / 100, "#,###,##0.00## %")
      End Select
    End If
  End If
End Function

Private Function pSetMask(ByVal Text As String) As String
  Dim c       As String
  Dim i       As Long
  Dim j       As Long
  Dim rtn     As String
  Dim s       As String
  Dim s2      As String
  Dim vMask   As Variant
  Dim vText   As Variant
  Dim aux     As String
  
  vMask = Split(Mask, "-")
  vText = Split(Text, "-")
  
  If UBound(vText) <> UBound(vMask) Then
    If UBound(vText) > UBound(vMask) Then
      For i = UBound(vMask) + 1 To UBound(vText)
        vText(UBound(vMask)) = vText(UBound(vMask)) & vText(i)
      Next
      ReDim Preserve vText(UBound(vMask))
    End If
    If UBound(vText) < UBound(vMask) Then
      j = UBound(vText)
      ReDim Preserve vText(UBound(vMask))
      For i = UBound(vText) To 0 Step -1
        If j > -1 Then
          If Len(vMask(i)) < Len(vText(j) & aux) Then
            vText(i) = Right$(vText(j) & aux, Len(vMask(i)))
            aux = Left$(vText(j) & aux, Len(vText(j) & aux) - Len(vMask(i)))
          Else
            vText(i) = vText(j) & aux
            aux = vbNullString
          End If
        Else
          If Len(vMask(i)) < Len(aux) Then
            vText(i) = Right$(aux, Len(vMask(i)))
            aux = Left$(aux, Len(aux) - Len(vMask(i)))
          Else
            vText(i) = aux
            aux = vbNullString
          End If
        End If
        j = j - 1
      Next
    End If
  End If
  
  For j = UBound(vMask) To 0 Step -1
    
    If Len(vMask(j)) - Len(vText(j)) > 0 Then
      vText(j) = String(Len(vMask(j)) - Len(vText(j)), " ") & vText(j)
    End If
    
    For i = Len(vMask(j)) To 1 Step -1
    
      s = Mid$(vMask(j), i, 1)
      s2 = Mid$(vText(j), i, 1)
      
      Select Case s
        Case "0"
          If Not IsNumeric(s2) Then
            s2 = "0"
          End If
        
        Case "-"
          If IsNumeric(s2) Then
            vText(j) = Mid$(vText(j), 2)
          End If
          s2 = "-"
        
        Case "#"
          ' Lo que ponga el usuario
          ' siempre que no sea vacio
          '
          If Trim$(s2) = vbNullString Then
            s2 = "#"
          End If
          
        Case "%"
          ' Lo que ponga el usuario
          ' siempre que no sea vacio
          '
          If Trim$(s2) = vbNullString Then
            s2 = "%"
          Else
            s2 = UCase$(s2)
          End If
          
        Case "*"
          ' Lo que ponga el usuario
          ' aunque sea vacio
          
        Case Else
          s2 = s
      End Select
      
      rtn = s2 & rtn
    Next
    If j > 0 Then rtn = "-" & rtn
  Next
  
  pSetMask = rtn
End Function

Private Function pValidKeySign(ByVal sText As String, ByVal iAscii As Integer, Optional bEntero As Boolean = False) As Integer
  Dim i As Integer
  
  ' Si es texto no hago nada
  If csType = csMkText Or csType = csMkFolder Or csType = csMkFile Then
    pValidKeySign = iAscii
    Exit Function
  End If

  ' No puede haber mas de un signo +
  i = InStr(1, sText, "+")
  If i > 0 Then
    
    ' un segundo punto es un caracter invalido
    If Chr(iAscii) = "+" Then
      iAscii = 0
    End If
  End If
  
  ' No puede haber mas de un signo -
  i = InStr(1, sText, "-")
  If i > 0 Then
    
    ' un segundo punto es un caracter invalido
    If Chr(iAscii) = "-" Then
      iAscii = 0
    End If
  End If
  
  ' Si es un signo + o - es valido
  If Chr(iAscii) = "+" Or Chr(iAscii) = "-" Then
    'el signo menos o mas solo puede estar al principio del numero
    
    If txSingleLine.SelLength = Len(txSingleLine.Text) Then
    ' si todo el texto esta sombreado, entonces el signo reemplaza el
    ' texto

    ' sino coloco el cursor al principio
    Else
    
      ' si habia otro signo en el numero lo saco
      If Left(txSingleLine.Text, 1) = "-" Or Left(txSingleLine.Text, 1) = "+" Then
        txSingleLine.Text = Mid(txSingleLine.Text, 2)
      End If
      txSingleLine.SelStart = 0
      txSingleLine.SelLength = 0
    End If
    
  ' sino, compruebo que sea un numero si es entero
  ElseIf bEntero Then
    iAscii = pValidKeyNumber(iAscii)
    
  ' o un signo si es double o moneda
  Else
    iAscii = pValidKeyDecimal(sText, iAscii)
  End If
  
  pValidKeySign = iAscii

End Function

Private Function pValidKeyDecimal(ByVal sText As String, ByVal iAscii As Integer) As Integer
  Dim i As Integer
  
  ' Si es texto no hago nada
  If csType = csMkText Or csType = csMkFolder Or csType = csMkFile Then
    pValidKeyDecimal = iAscii
    Exit Function
  End If
  
  ' No puede haber mas de un punto decimal
  i = InStr(1, sText, m_SepDecimal)
  If i > 0 Then
    
    ' un segundo punto es un caracter invalido
    If Chr(iAscii) = m_SepDecimal Then
      iAscii = 0
    End If
  End If
  
  ' Si es un punto decimal es valido
  If Chr(iAscii) = m_SepDecimal Then

  ' sino, compruebo que sea un numero
  Else
    iAscii = pValidKeyNumber(iAscii)
  End If
  
  pValidKeyDecimal = iAscii
End Function

Private Function pValidKeyNumber(ByVal iAscii As Integer) As Integer
  ' Si es texto no hago nada
  If csType = csMkText Or csType = csMkFolder Or csType = csMkFile Then
    pValidKeyNumber = iAscii
    Exit Function
  End If
  
  Select Case iAscii
    ' si es numero todo bien
    Case vbKey1, vbKey2, vbKey3, vbKey4, vbKey5, vbKey6, vbKey7, vbKey8, vbKey9, vbKey0
    Case Else
      iAscii = 0
  End Select
  
  pValidKeyNumber = iAscii
End Function

Private Function pValidValue(ByRef svalue As String) As Boolean

  ' Permito limpiar la caja
  If svalue <> "" And pIsNumericOrDateType Then
  
    Select Case m_csType
      Case csMkDouble, csMkMoney
        If Not IsNumeric(svalue) Then GoTo InpValidValue
      Case csMkInteger
        If Not IsNumeric(svalue) Then GoTo InpValidValue
        
        If CLng(svalue) <> svalue Then GoTo InpValidValue
      Case csMkPercent
        svalue = Trim(Replace(svalue, "%", ""))
        If Not IsNumeric(svalue) Then GoTo InpValidValue
    
        'svalue = Trim(CDbl(svalue) * 100)
      Case csMkDate
        pValidDate svalue
      Case csMkTime
        pValidTime svalue
    End Select
  
  End If
  
  pValidValue = True
  m_NoRaiseError = False
  Exit Function

InpValidValue:
  If m_NotRaiseError Then Exit Function
  
  If m_NoRaiseError Then
    m_NoRaiseError = False
  Else
    m_NoRaiseError = False
    
    ' JAV- No disparamos mas errores
    '      por que sospechamos que es
    '      motivo de cuelgue
    '
    'Err.Raise 380
  End If
End Function

Private Function pLeftControlToLeftForm(ByVal lhwnd As Long) As Long
  Dim lpRect As RECT
  Dim iRet As Long
  
  iRet = GetWindowRect(lhwnd, lpRect)
  
  pLeftControlToLeftForm = 0
  
  ' Hubo un error devuelvo cero
  If iRet = 0 Then Exit Function
  
  pLeftControlToLeftForm = lpRect.Left * Screen.TwipsPerPixelX
End Function

Private Function pTopControlToTopForm(ByVal lhwnd As Long, ByVal lHeight As Long) As Long
  Dim lpRect As RECT
  Dim iRet As Long
  
  iRet = GetWindowRect(lhwnd, lpRect)
  
  pTopControlToTopForm = 0
  
  ' Hubo un error devuelvo cero
  If iRet = 0 Then Exit Function
  
  pTopControlToTopForm = lpRect.Top * Screen.TwipsPerPixelY + lHeight
End Function

Private Sub pDrawSelectionBox(ByVal bStatus As STATUS_BUTTON)
  Dim clrTop    As Long
  Dim clrLeft     As Long
  Dim clrBottom   As Long
  Dim clrRight    As Long

  picButton.Cls
  m_Status = bStatus

  'Set highlight and shadow colors
  Select Case bStatus
  
    Case PRESSED
      clrTop = vbButtonShadow
      clrLeft = vbButtonShadow
      clrBottom = vb3DHighlight
      clrRight = vb3DHighlight
    Case UNPRESSED
      If UserControl.Enabled Then
        clrTop = picButton.BackColor
        clrLeft = m_BorderColor
        clrBottom = picButton.BackColor
        clrRight = m_BorderColor
      Else
        clrTop = vbButtonShadow
        clrLeft = vbButtonShadow
        clrRight = vbButtonShadow
        clrBottom = vbButtonShadow
      End If
    Case MOUSE_MOVE
      clrLeft = vb3DHighlight
      clrTop = vb3DHighlight
      clrRight = vbButtonShadow
      clrBottom = vbButtonShadow
  End Select
  
  ' Arriba
  picButton.Line (0, 0)-Step(picButton.ScaleWidth, 0), clrTop
  
  ' Izquierda
  picButton.Line (0, 0)-Step(0, picButton.ScaleHeight), clrLeft
  
  ' Derecha
  picButton.Line (picButton.ScaleWidth - 15, 0)-Step(0, picButton.ScaleHeight), clrRight
  
  ' Abajo
  picButton.Line (15, picButton.ScaleHeight - 15)-Step(picButton.ScaleWidth - 30, 0), clrBottom
  
  pSetCaptionButton
End Sub

Private Sub pDrawBorder()
  If m_BorderType = cNone Then
    UserControl.BackColor = txSingleLine.BackColor
  Else
    If m_EnabledNoChngBkColor Then
      UserControl.BackColor = m_BorderColor
    Else
      If Enabled Then
        UserControl.BackColor = m_BorderColor
      Else
        UserControl.BackColor = vbButtonShadow
      End If
    End If
  End If
  
  If m_ButtonStyle = cButtonNone Then Exit Sub

  Dim hBr  As Long
  Dim tR   As RECT
  Dim lptR As RECT
  
  If picButton.Visible Then
    hBr = CreateSolidBrush(pTranslateColor(UserControl.BackColor))
  Else
    hBr = CreateSolidBrush(pTranslateColor(pGetParentColor))
  End If
  
  With lptR
    .Top = 0
    .Right = UserControl.Width / Screen.TwipsPerPixelX
    .Left = .Right - C_ButtonWidth / Screen.TwipsPerPixelX
    .Bottom = UserControl.Height / Screen.TwipsPerPixelY
  End With
  
  FillRect UserControl.hDC, lptR, hBr
  
  DeleteObject hBr
End Sub

Private Function pGetParentColor() As Long
  On Error Resume Next
  Err.Clear
  If UserControl.Parent Is Nothing Then
    pGetParentColor = vbButtonFace
  Else
    pGetParentColor = UserControl.Parent.BackColor
  End If
  If Err.Number <> 0 Then pGetParentColor = vbButtonFace
  
  pGetParentColor = &H80000005
End Function

Private Sub pSetCaptionButton()
  picButton.CurrentX = (C_ButtonWidth - picButton.TextWidth("...")) / 2 + 5
  picButton.CurrentY = (ScaleHeight - picButton.TextHeight("...")) / 2 - 5
  picButton.Print "..."
End Sub

Private Sub pCreateMenu()
  Dim dn  As cDateName
  Dim i   As Integer
  Dim Group As String
  
  If Not Ambient.UserMode Then Exit Sub
  
  pDestroyMenu
  
  For Each dn In DateNames
    i = i + 1
    If Group <> dn.Group Then
      If Group <> "" Then
      Load popDate(i)
      popDate(i).Caption = "-"
      i = i + 1
      End If
      Group = dn.Group
    End If
    Load popDate(i)
    popDate(i).Caption = dn.Name & "  (" & dn.Code & ")"
    popDate(i).Tag = dn.Code
    popDate(i).Visible = True
  Next
  
  popDate(0).Visible = False
End Sub

Private Sub pDestroyMenu()
  On Error Resume Next
  
  Dim i As Integer
  
  popDate(0).Visible = True
  
  For i = 1 To popDate.UBound
  Unload popDate(i)
  Next
End Sub

Private Function pIsDateName(ByVal DateName As String, ByRef dn As cDateName) As Boolean
  Dim n As Integer
  
  n = InStr(1, DateName, "(")
  If n > 0 Then DateName = Trim(Mid(DateName, 1, n - 1))

  Set dn = DateNames.Item(DateName)
  
  If dn Is Nothing Then
  For Each dn In DateNames
    If dn.Name = DateName Then Exit For
  Next
  End If
  
  pIsDateName = Not dn Is Nothing
End Function

Private Sub pFillValidKeys()
  Dim dn As cDateName
  Dim i  As Integer
  For Each dn In DateNames
  For i = 1 To Len(dn.Name)
    If InStr(1, m_ValidKeys, Mid(dn.Name, i, 1), vbTextCompare) = 0 Then
    m_ValidKeys = m_ValidKeys & Mid(dn.Name, i, 1)
    End If
  Next
  For i = 1 To Len(dn.Code)
    If InStr(1, m_ValidKeys, Mid(dn.Code, i, 1), vbTextCompare) = 0 Then
    m_ValidKeys = m_ValidKeys & Mid(dn.Code, i, 1)
    End If
  Next
  Next
End Sub

Private Function pFormatDateSerial(ByVal Day As Integer, ByVal Month As Integer, ByVal Year As Long) As String
  pFormatDateSerial = pFormatDate(DateSerial(Year, Month, Day))
End Function

Private Function pFormatDate(ByVal vDate As Variant)
  Dim dn As cDateName
  
  If pIsDateName(vDate, dn) Then
    vDate = dn.Code & " (" & dn.Value & ")"
  ElseIf Not IsDate(vDate) Then
    vDate = csNoDate
  End If
  
  pFormatDate = Format(vDate, m_FormatDate)
End Function

Private Function pFormatTime(ByVal vTime As Variant)
  If Not IsDate(vTime) Then
    vTime = #12:00:00 AM#
  End If
  pFormatTime = Format(vTime, "HH:nn")
End Function

'-----------------------------------------------
Private Sub txSingleLine_Change()
  On Error Resume Next
  RaiseEvent Change
End Sub

Private Sub txSingleLine_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  
  If pIsNumericOrDateType Then
    If KeyCode = vbKeyC And Shift = 0 Then ShowHelp
    If KeyCode = vbKeyF4 And Shift = 0 Then ShowHelp
  End If
  
  If (KeyCode = vbKeyDelete _
      Or ((KeyCode = vbKeyX _
           Or KeyCode = vbKeyV) _
      And (Shift And vbCtrlMask) _
         ) _
     ) And m_InputDisabled Then
    
    KeyCode = 0
    
  ElseIf (((KeyCode = vbKeyInsert) _
      And (Shift And vbShiftMask) _
         ) _
     ) And m_InputDisabled Then
    
    KeyCode = 0
  
  End If
  
  m_bCtrlPressed = Shift And vbCtrlMask
      
  RaiseEvent KeyDown(KeyCode, Shift)
End Sub

Private Sub txSingleLine_KeyUp(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  RaiseEvent KeyUp(KeyCode, Shift)
End Sub

Private Sub txSingleLine_KeyPress(KeyAscii As Integer)
  On Error Resume Next
  
  '////////////////////////////////////////
  ' Para evitar el ctrl-v cuando InputDisabled = True
  '
  If KeyAscii = 22 And m_InputDisabled Then
    KeyAscii = 0
  End If
  
  pTxKeyPress KeyAscii
End Sub

Private Sub pTxKeyPress(ByRef KeyAscii As Integer)
  Dim iAscii As Integer
  
  RaiseEvent KeyPress(KeyAscii)
  
  If m_bCtrlPressed Then Exit Sub
  
  If m_InputDisabled Then
    KeyAscii = 0
    Exit Sub
  End If
  
  ' Si es texto no hago nada
  If csType = csMkText Or csType = csMkFolder Or csType = csMkFile Then Exit Sub
  
  iAscii = KeyAscii
  
  ' Si es BackSpace no hago nada
  If iAscii = vbKeyBack Then
    Exit Sub
  End If
  
  If csType = csMkDate Then
    Select Case Chr(iAscii)
      Case ".", "\", ","
        iAscii = Asc("/")
      
      Case "/", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "+", "-", "*"
        ' Todo bien
      
      
      Case Else
        ' Si no esta dentro de las letras del nombre de alguna DateName
        If InStr(1, m_ValidKeys, Chr(iAscii), vbTextCompare) = 0 Then
          ' Este no sirve
          iAscii = 0
        End If
    End Select
  
  ElseIf csType = csMkTime Then
  
    Select Case Chr(iAscii)
      Case ".", "-", ":", ","
        iAscii = Asc(":")
      
      Case "/", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
        ' Todo bien
      
      
      Case Else
        ' Este no sirve
        iAscii = 0
    End Select
    
  Else
    If Chr(iAscii) = "." Or Chr(iAscii) = "," Then
      If m_SepDecimal = "." Then
        iAscii = Asc(".")
      Else
        iAscii = Asc(",")
      End If
    End If
    
    Dim sText As String
    
    Select Case m_csType
      Case csMkDouble, csMkMoney, csMkPercent, csMkInteger
        sText = Replace(txSingleLine.Text, txSingleLine.SelText, "")
        iAscii = pValidKeySign(sText, iAscii)
    End Select
  End If
  KeyAscii = iAscii
End Sub

Private Sub txSingleLine_GotFocus()
  On Error Resume Next
  pTxGotFocus
End Sub

Private Sub pTxGotFocus()
  ForeColor = m_ForeColor
  
  If m_NoFormat Then Exit Sub
  
  If txSingleLine.Text = "" Then Exit Sub
  
  If Not (csType = csMkText Or csType = csMkFolder Or csType = csMkFile) Then
    Select Case m_csType
      Case csMkDouble
        txSingleLine.Text = Trim(CDbl(txSingleLine.Text))
      Case csMkInteger
        txSingleLine.Text = Trim(CLng(txSingleLine.Text))
      Case csMkMoney
        Dim txt As String
        txt = Replace(txSingleLine.Text, "$", "")
        txSingleLine.Text = Trim(CCur(txt))
      Case csMkPercent
        txSingleLine.Text = Trim(CDbl(Left(txSingleLine.Text, Len(txSingleLine.Text) - 2)))
    End Select
  End If
  
  txSingleLine.SelStart = Len(txSingleLine.Text)
  
  If m_bNegative Then
    
    m_bNegative = False
    
    txSingleLine.Text = "-" & Abs(Val(txSingleLine.Text))
    
    txSingleLine.SelStart = 1
    txSingleLine.SelLength = Len(txSingleLine.Text)
  
  ElseIf Not m_NoSel Then
    
    txSingleLine.SelStart = 0
    txSingleLine.SelLength = Len(txSingleLine.Text)
  
  End If
  
  If m_NoSel Then m_NoSel = False
End Sub

Private Sub txSingleLine_LostFocus()
  On Error Resume Next
  pTxLostFocus
End Sub

Private Sub pTxLostFocus()
  Dim Color As Long
  
  If pIsNumericType Then
    txSingleLine.Text = pSetFormatText(Color)
    txSingleLine.ForeColor = Color
  ElseIf csType = csMkDate Then
    pValidDate txSingleLine.Text
  ElseIf csType = csMkTime Then
    pValidTime txSingleLine.Text
  ElseIf csType = csMkText And Mask <> "" Then
    txSingleLine.Text = pSetFormatText(Color)
  End If
End Sub

'-----------------------------------------------
Private Sub txMultiLine_Change()
  On Error Resume Next
  RaiseEvent Change
End Sub

Private Sub txMultiLine_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If pIsNumericOrDateType Then
  If KeyCode = vbKeyC And Shift = 0 Then ShowHelp
  If KeyCode = vbKeyF4 And Shift = 0 Then ShowHelp
  End If
  RaiseEvent KeyDown(KeyCode, Shift)
End Sub

Private Sub txMultiLine_KeyUp(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  RaiseEvent KeyUp(KeyCode, Shift)
End Sub

Private Sub txMultiLine_KeyPress(KeyAscii As Integer)
  On Error Resume Next
  pTxKeyPress KeyAscii
End Sub

Private Sub txMultiLine_GotFocus()
  On Error Resume Next
  pTxGotFocus
End Sub

Private Sub txMultiLine_LostFocus()
  On Error Resume Next
  pTxLostFocus
End Sub

Private Function pTranslateColor(ByVal oClr As OLE_COLOR, Optional hPal As Long = 0) As Long
  ' Convert Automation color to Windows color
  If OleTranslateColor(oClr, hPal, pTranslateColor) Then
    pTranslateColor = CLR_INVALID
  End If
End Function
