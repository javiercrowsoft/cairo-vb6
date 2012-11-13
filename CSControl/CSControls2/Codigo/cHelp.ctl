VERSION 5.00
Begin VB.UserControl cHelp 
   BackColor       =   &H008080FF&
   ClientHeight    =   480
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   2430
   ScaleHeight     =   480
   ScaleWidth      =   2430
   Begin VB.PictureBox picInfo 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   285
      Left            =   1260
      ScaleHeight     =   285
      ScaleWidth      =   255
      TabIndex        =   3
      TabStop         =   0   'False
      Top             =   120
      Width           =   250
      Begin VB.Image imgInfo 
         Height          =   240
         Left            =   0
         Picture         =   "cHelp.ctx":0000
         Top             =   15
         Width           =   240
      End
   End
   Begin VB.PictureBox picFolder 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   285
      Left            =   45
      ScaleHeight     =   285
      ScaleWidth      =   405
      TabIndex        =   2
      Top             =   90
      Width           =   400
      Begin VB.Image imgFolder 
         Height          =   240
         Left            =   90
         Picture         =   "cHelp.ctx":058A
         Top             =   0
         Width           =   240
      End
   End
   Begin VB.PictureBox PicButton 
      AutoRedraw      =   -1  'True
      BorderStyle     =   0  'None
      Height          =   255
      Left            =   1440
      ScaleHeight     =   255
      ScaleWidth      =   735
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   120
      Width           =   735
   End
   Begin VB.TextBox TxValue 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   120
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   90
      Width           =   1215
   End
End
Attribute VB_Name = "cHelp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' csHelp
' 23-12-00

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    Private Enum STATUS_BUTTON
        PRESSED = 1
        UNPRESSED = 2
        MOUSE_MOVE = 3
    End Enum
    ' estructuras
    ' funciones
    Private Declare Function ReleaseCapture Lib "user32" () As Long
    Private Declare Function SetCapture Lib "user32" (ByVal hWnd As Long) As Long

'--------------------------------------------------------------------------------
' constantes
Private Const C_Module = "cHelp"

Private Const c_ButtonColor = "ButtonColor"
Private Const c_BorderColor = "BorderColor"
Private Const c_BackColor = "BackColor"
Private Const c_BorderType = "BorderType"
Private Const c_ForeColorIn = "ForeColorIn"
Private Const c_ForeColorOut = "ForeColorOut"
Private Const c_ErrorColor = "ErrorColor"
Private Const c_ToolTipText = "ToolTipText"
Private Const c_Table = "Table"
Private Const c_Filter = "Filter"
Private Const c_HelpType = "HelpType"
Private Const c_ColumnValueProcess = "ColumnValueProcess"
Private Const c_Font = "Font"
Private Const c_FontBold = "FontBold"
Private Const c_FontItalic = "FontItalic"
Private Const c_FontName = "FontName"
Private Const c_FontSize = "FontSize"
Private Const c_FontStrikethru = "FontStrikethru"
Private Const c_FontUnderline = "FontUnderline"
Private Const c_ForeColor = "ForeColor"
Private Const c_Enabled = "Enabled"
Private Const c_ButtonStyle = "ButtonStyle"

Private Const C_ButtonWidth As Integer = 200

Private Const KEY_NODO = "N"

Public Enum csHelpButtonStyle
  cHelpButtonNone = 0
  cHelpButtonSingle = 1
End Enum
' estructuras
' variables privadas

' manejo del boton
Private m_FlagInside    As Boolean
Private m_Status        As STATUS_BUTTON

Private m_Editing       As Boolean
Private m_ValueValid    As Boolean
Private m_NoLostFocus   As Boolean

Private m_NoClick       As Boolean

' propiedades
Private m_Text          As String
Private m_Id            As String
Private m_ToolTipText   As String

Private m_Tag           As String
Private m_TagVariant    As Variant

Private m_FormatIn      As String
Private m_FormatOut     As String

Private m_ForeColorIn   As Long
Private m_ForeColorOut  As Long
Private m_ErrorColor    As Long

Private m_BackColor     As Long
Private m_BorderType    As csBorderType
Private m_ButtonColor   As Long
Private m_BorderColor   As Long

Private m_ValueUser     As String
Private m_ValueHelp     As String
Private m_ValueProcess  As String
Private m_ColumnValueProcess As String

Private m_Table         As csTables
Private m_Filter        As String

Private m_CurrentValue  As String ' Para el evento change

Private m_Enabled       As Long
Private m_Shift         As String
Private m_ShowingHelp   As Boolean

Private m_RealButtonStyle As csHelpButtonStyle
Private m_ButtonStyle     As csHelpButtonStyle

Private m_HelpType       As csHelpType
Private m_HaveInfo       As Boolean

' eventos
Public Event Click(ByRef Cancel As Boolean)
Public Event Change()
Public Event ReturnFromHelp()
Public Event KeyPress(KeyAscii As Integer)
Public Event KeyDown(KeyCode As Integer, Shift As Integer)
Public Event KeyUp(KeyCode As Integer, Shift As Integer)

' propiedades publicas
Public Property Get ButtonStyle() As csHelpButtonStyle
  ButtonStyle = m_RealButtonStyle
End Property

Public Property Let ButtonStyle(ByVal rhs As csHelpButtonStyle)
  m_RealButtonStyle = rhs
  m_ButtonStyle = rhs
  UserControl_Resize
End Property

Public Property Get Font() As Font
  Set Font = TxValue.Font
End Property

Public Property Set Font(ByVal rhs As Font)
  Set TxValue.Font = rhs
End Property

Public Property Get FontBold() As Boolean
  FontBold = TxValue.FontBold
End Property

Public Property Let FontBold(ByVal rhs As Boolean)
  TxValue.FontBold() = rhs
End Property

Public Property Get FontItalic() As Boolean
  FontItalic = TxValue.FontItalic
End Property

Public Property Let FontItalic(ByVal rhs As Boolean)
  TxValue.FontItalic() = rhs
End Property

Public Property Get FontName() As String
  FontName = TxValue.FontName
End Property

Public Property Let FontName(ByVal rhs As String)
  TxValue.FontName() = rhs
End Property

Public Property Get FontSize() As Single
  FontSize = TxValue.FontSize
End Property

Public Property Let FontSize(ByVal rhs As Single)
  TxValue.FontSize() = rhs
End Property

Public Property Get FontStrikethru() As Boolean
  FontStrikethru = TxValue.FontStrikethru
End Property

Public Property Let FontStrikethru(ByVal rhs As Boolean)
  TxValue.FontStrikethru() = rhs
End Property

Public Property Get FontUnderline() As Boolean
  FontUnderline = TxValue.FontUnderline
End Property

Public Property Let FontUnderline(ByVal rhs As Boolean)
  TxValue.FontUnderline() = rhs
End Property

Public Property Get ForeColor() As OLE_COLOR
  ForeColor = TxValue.ForeColor
End Property

Public Property Let ForeColor(ByVal rhs As OLE_COLOR)
  TxValue.ForeColor() = rhs
End Property

Public Property Get BorderType() As csBorderType
  BorderType = m_BorderType
End Property
Public Property Let BorderType(ByVal rhs As csBorderType)
  m_BorderType = rhs
  UserControl_Paint
End Property

Public Property Get Text() As String
  Text = TxValue.Text
End Property
Public Property Let Text(ByVal rhs As String)
  TxValue.Text = rhs
End Property

Public Property Get SelStart() As Integer
  SelStart = TxValue.SelStart
End Property

Public Property Let SelStart(ByVal position As Integer)
  TxValue.SelStart = position
End Property

Public Property Get SelLength() As Integer
  SelLength = TxValue.SelLength
End Property

Public Property Let SelLength(ByVal length As Integer)
  TxValue.SelLength = length
End Property

Public Property Get Id() As String
Attribute Id.VB_Description = "Test"
  Id = m_Id
End Property
Public Property Let Id(ByVal rhs As String)
  m_Id = rhs
End Property

Public Property Get Tag() As String
  Tag = m_Tag
End Property
Public Property Let Tag(ByVal rhs As String)
  m_Tag = rhs
End Property

Public Property Get TagVariant() As Variant
  TagVariant = m_TagVariant
End Property
Public Property Let TagVariant(ByVal rhs As Variant)
  m_TagVariant = rhs
End Property

Public Property Get FormatIn() As String
  FormatIn = m_FormatIn
End Property
Public Property Let FormatIn(ByVal rhs As String)
  m_FormatIn = rhs
End Property

Public Property Get FormatOut() As String
  FormatOut = m_FormatOut
End Property
Public Property Let FormatOut(ByVal rhs As String)
  m_FormatOut = rhs
End Property

Public Property Get ShowingHelp() As Boolean
ShowingHelp = m_ShowingHelp
End Property

Public Property Get ToolTipText() As String
  ToolTipText = m_ToolTipText
End Property
Public Property Let ToolTipText(ByVal rhs As String)
  m_ToolTipText = rhs
  TxValue.ToolTipText = rhs
End Property

Public Property Get ForeColorIn() As OLE_COLOR
  ForeColorIn = m_ForeColorIn
End Property
Public Property Let ForeColorIn(ByVal rhs As OLE_COLOR)
  m_ForeColorIn = rhs
  SetColor
End Property

Public Property Get ForeColorOut() As OLE_COLOR
  ForeColorOut = m_ForeColorOut
End Property
Public Property Let ForeColorOut(ByVal rhs As OLE_COLOR)
  m_ForeColorOut = rhs
  SetColor
End Property
Public Property Get ButtonColor() As OLE_COLOR
  ButtonColor = m_ButtonColor
End Property
Public Property Let ButtonColor(ByVal rhs As OLE_COLOR)
  m_ButtonColor = rhs
  PicButton.BackColor = rhs
  SetCaptionButton
End Property
Public Property Get BorderColor() As OLE_COLOR
  BorderColor = m_BorderColor
End Property
Public Property Let BorderColor(ByVal rhs As OLE_COLOR)
  m_BorderColor = rhs
  DrawSelectionBox UNPRESSED
  DrawBorder
End Property
Public Property Get Enabled() As Boolean
  Enabled = m_Enabled
End Property
Public Property Let Enabled(ByVal rhs As Boolean)
  m_Enabled = rhs
  
  With PicButton
    .Enabled = m_Enabled
    .TabStop = False
  End With
  
  With TxValue
    .Enabled = m_Enabled
    .BackColor = IIf(m_Enabled, m_BackColor, PicButton.BackColor)
  End With
  DrawBorder
End Property

Public Property Get BackColor() As OLE_COLOR
  BackColor = m_BackColor
End Property
Public Property Let BackColor(ByVal rhs As OLE_COLOR)
  m_BackColor = rhs
  TxValue.BackColor = rhs
End Property

Public Property Get ErrorColor() As OLE_COLOR
  ErrorColor = m_ErrorColor
End Property
Public Property Let ErrorColor(ByVal rhs As OLE_COLOR)
  m_ErrorColor = rhs
  SetColor
End Property

Public Property Get ValueUser() As String
  ValueUser = m_ValueUser
End Property
Public Property Let ValueUser(ByVal rhs As String)
  m_ValueUser = rhs
  TxValue.Text = rhs
End Property

Public Property Get ValueProcess() As String
  ValueProcess = m_ValueProcess
End Property
Public Property Let ValueProcess(ByVal rhs As String)
  m_ValueProcess = rhs
End Property

Public Property Get ValueHelp() As String
  ValueHelp = m_ValueHelp
End Property
Public Property Let ValueHelp(ByVal rhs As String)
  m_ValueHelp = rhs
  m_Id = rhs
End Property
Public Property Get ColumnValueProcess() As String
  ColumnValueProcess = m_ColumnValueProcess
End Property
Public Property Let ColumnValueProcess(ByVal rhs As String)
  m_ColumnValueProcess = rhs
End Property
Public Property Get Table() As csTables
  Table = m_Table
End Property
Public Property Let Table(ByVal rhs As csTables)
  On Error GoTo ControlError
  
  m_Table = rhs
  Dim Hlp As CSOAPI.cHelp
  Set Hlp = New CSOAPI.cHelp
  
  m_HaveInfo = Hlp.HaveInfo(m_Table)

  GoTo ExitProc
ControlError:
  MngError Err, c_Table, C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Property
Public Property Get Filter() As String
  Filter = m_Filter
End Property
Public Property Let Filter(ByVal rhs As String)
  m_Filter = rhs
End Property

Public Property Get HelpType() As csHelpType
  HelpType = m_HelpType
End Property
Public Property Let HelpType(ByVal rhs As csHelpType)
  m_HelpType = rhs
End Property
' propiedades privadas
' funciones publicas
Public Sub ShowHelp()
  Dim bCancel As Boolean
  Dim hr      As cHelpResult
  Dim Help    As CSOAPI.cHelp
  
  ' Para que se ejecute el lostfocus de los demas controles
  DoEvents
  DrawSelectionBox PRESSED
  DoEvents
  
  RaiseEvent Click(bCancel)
  
  If Not bCancel Then
  
    Set Help = New CSOAPI.cHelp
    
    m_CurrentValue = TxValue.Text
    
    m_ShowingHelp = True
    
    Set hr = Help.Show(TxValue, m_Table, m_ValueHelp, m_ValueUser, m_ValueProcess, m_HelpType, m_Filter)
    
    RaiseEvent ReturnFromHelp
    
    m_ShowingHelp = False
    
    Dim oldValueHelp As String
    oldValueHelp = m_ValueHelp
    
    With hr
      ValueHelp = .Id
      ValueUser = .Value
      ValueProcess = .Value2
    End With
    
    With TxValue
      If LCase(m_CurrentValue) <> LCase(.Text) Or ValueHelp <> oldValueHelp Then
        RaiseEvent Change
        UserControl_Resize
      End If
      
      m_CurrentValue = .Text
    End With
    
    SetFocusControl TxValue
  End If
  
  ' Como el foco esta en el control, el control se levanta
  Sleep 200
  m_FlagInside = False
  ReleaseCapture
  UserControl_Paint
End Sub

Private Sub imgInfo_Click()
  On Error GoTo ControlError
  If Not Val(m_Id) <> csNO_ID Then Exit Sub
  
  On Error Resume Next
  Dim c As CSOAPI.cHelp
  
  Set c = New CSOAPI.cHelp
  c.ShowInfo m_Table, Val(m_Id)

  GoTo ExitProc
ControlError:
  MngError Err, "imgInfo_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

' Eventos de controles
Private Sub PicButton_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
  On Error Resume Next
  DrawSelectionBox PRESSED
End Sub

Private Sub PicButton_Click()
  On Error Resume Next
  
  If m_NoClick Then
    m_NoClick = False
    Exit Sub
  End If
  
  ShowHelp
End Sub

Private Sub PicButton_GotFocus()
  On Error Resume Next
  
  m_Editing = True
  DrawSelectionBox MOUSE_MOVE
  
  m_NoLostFocus = True
End Sub

Private Sub PicButton_LostFocus()
  On Error Resume Next
  
  DrawSelectionBox UNPRESSED
  
  m_NoLostFocus = False
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
  
  If m_NoLostFocus Then
    m_NoLostFocus = False
    Exit Sub
  End If
  
  Validate
End Sub

Private Sub PicButton_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  On Error Resume Next
  Dim Ret As Long
  Dim iWidth As Integer
  
  With PicButton
    If X < 0 Or X > .Width Or Y < 0 Or Y > .Height Then
      m_FlagInside = False
      ReleaseCapture
      UserControl_Paint
    Else
      ' el punto esta dentro del control
      If m_FlagInside = False Then
        m_FlagInside = True
        Ret = SetCapture(.hWnd)
        DrawSelectionBox MOUSE_MOVE
      End If
    End If
  End With
End Sub

Private Sub TxValue_GotFocus()
  On Error Resume Next
  m_CurrentValue = TxValue.Text
  m_NoLostFocus = True
  m_Editing = True
  SetColor
End Sub

Private Sub TxValue_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  If KeyCode = vbKeyF4 And Shift = 0 Then ShowHelp
  RaiseEvent KeyDown(KeyCode, Shift)
End Sub

Private Sub TxValue_KeyPress(KeyAscii As Integer)
  On Error Resume Next
  RaiseEvent KeyPress(KeyAscii)
End Sub

Private Sub TxValue_KeyUp(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  RaiseEvent KeyUp(KeyCode, Shift)
End Sub

Private Sub TxValue_LostFocus()
  On Error Resume Next
  m_NoLostFocus = False
  DoEvents: DoEvents: DoEvents: DoEvents: DoEvents

  If m_NoLostFocus Then
    m_NoLostFocus = False
    Exit Sub
  End If

  Validate

  If Not LCase(m_CurrentValue) = LCase(TxValue.Text) Then
    RaiseEvent Change
  End If
End Sub

Private Sub TxValue_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  On Error Resume Next
  
  Dim offset            As Long
  Dim buttonInfoWidth   As Long
  
  If Left$(ValueHelp, 1) = KEY_NODO Then
    With picFolder
      offset = .Left + .Width + 40
    End With
  End If
  
  With picInfo
    If .Visible Then buttonInfoWidth = .Width
  End With
  
  If X > UserControl.ScaleWidth - PicButton.Width - offset - buttonInfoWidth Then
    UserControl_Paint
  End If
End Sub

Private Sub UserControl_GotFocus()
  On Error Resume Next
  TxValue.SetFocus
End Sub

Private Sub UserControl_Paint()
  On Error Resume Next
  UserControl_Resize
  DrawBorder
End Sub

Private Sub UserControl_Resize()
  On Error Resume Next
  
  Dim InternalFrame As Single
  Dim ButtonWidth   As Integer
  Dim ButtonWidth2  As Integer
  Dim ButtonHeight  As Long
  Dim offset        As Long

  If m_BorderType = cNone Then
    InternalFrame = 0
  Else
    InternalFrame = 30
  End If
  
  ButtonHeight = UserControl.ScaleHeight - InternalFrame * 2
  
  With PicButton
    If m_ButtonStyle = cHelpButtonNone Then
      ButtonWidth = 0
      .Visible = False
    Else
      ButtonWidth = C_ButtonWidth
      .Visible = True
      .Move ScaleWidth - ButtonWidth, _
            InternalFrame, _
            ButtonWidth, _
            ButtonHeight
    End If
  End With
  
  With picInfo
    If Val(m_Id) <> csNO_ID And m_HaveInfo Then
      ButtonWidth2 = picInfo.Width
      .Move UserControl.ScaleWidth - ButtonWidth - ButtonWidth2 - InternalFrame, _
            InternalFrame, _
            .Width, _
            ButtonHeight
      .Visible = True
    Else
      .Visible = False
      ButtonWidth2 = 0
    End If
  End With
  
  With TxValue
    If Left$(ValueHelp, 1) = KEY_NODO Then
      With picFolder
        .Left = InternalFrame
        .Height = ButtonHeight
        .Top = InternalFrame
        .Visible = True
        offset = .Left + .Width
      End With
      .Move offset, _
            InternalFrame, _
            ScaleWidth - ButtonWidth - InternalFrame - offset - ButtonWidth2, _
            ButtonHeight
    Else
      picFolder.Visible = False
      .Move InternalFrame, _
            InternalFrame, _
            ScaleWidth - ButtonWidth - (InternalFrame * 2) - ButtonWidth2, _
            ButtonHeight
    End If
  End With
  DrawSelectionBox UNPRESSED
End Sub

Public Sub Validate()
  Dim Help    As CSOAPI.cHelp
  Dim hr      As CSOAPI.cHelpResult
  
  Set Help = New CSOAPI.cHelp
  
  Set hr = Help.ValidateEx(m_Table, TxValue.Text, ValueHelp, m_Filter)
  
  With hr
    m_ValueValid = Not .Cancel
    ValueHelp = .Id
    ValueUser = .Value
    ValueProcess = .Value2
  End With
  m_Editing = False
  
  SetColor
  UserControl_Resize
End Sub

' funciones privadas
Private Sub SetColor()
  With TxValue
    If m_Editing Then
      .ForeColor = m_ForeColorIn
    Else
      If m_ValueValid Then
          .ForeColor = m_ForeColorOut
      Else
          .ForeColor = m_ErrorColor
      End If
    End If
  End With
End Sub

Private Sub DrawSelectionBox(ByVal bStatus As STATUS_BUTTON)
  Dim clrTop    As Long
  Dim clrLeft     As Long
  Dim clrBottom   As Long
  Dim clrRight    As Long

  PicButton.Cls
  m_Status = bStatus
  'Exit Sub
  
  'Set highlight and shadow colors
  Select Case bStatus
  
    Case PRESSED
      clrTop = vbButtonShadow
      clrLeft = vbButtonShadow
      clrBottom = vb3DHighlight
      clrRight = vb3DHighlight
    Case UNPRESSED
      clrTop = PicButton.BackColor
      clrLeft = m_BorderColor
      clrBottom = PicButton.BackColor
      clrRight = m_BorderColor
    Case MOUSE_MOVE
      clrLeft = vb3DHighlight
      clrTop = vb3DHighlight
      clrRight = vbButtonShadow
      clrBottom = vbButtonShadow
  End Select
  
  ' Arriba
  PicButton.Line (0, 0)-Step(PicButton.ScaleWidth, 0), clrTop
  
  ' Izquierda
  PicButton.Line (0, 0)-Step(0, PicButton.ScaleHeight), clrLeft
  
  ' Derecha
  PicButton.Line (PicButton.ScaleWidth - 15, 0)-Step(0, PicButton.ScaleHeight), clrRight
  
  ' Abajo
  PicButton.Line (15, PicButton.ScaleHeight - 15)-Step(PicButton.ScaleWidth - 30, 0), clrBottom
  
  SetCaptionButton
End Sub

Private Sub DrawBorder()
  With UserControl
    If m_BorderType = cNone Then
      .BackColor = TxValue.BackColor
    Else
      If Enabled Then
        .BackColor = m_BorderColor
      Else
        .BackColor = vbButtonShadow
      End If
    End If
  End With
End Sub

Private Sub SetCaptionButton()
  With PicButton
    .CurrentX = (C_ButtonWidth - .TextWidth("...")) / 2 + 5
    .CurrentY = (ScaleHeight - .TextHeight("...")) / 2 - 5
  End With
  PicButton.Print "..."
End Sub

' construccion - destruccion
Private Sub UserControl_Initialize()
  On Error Resume Next
  picFolder.TabStop = False
  m_NoLostFocus = False
  TxValue.CausesValidation = True
End Sub

Private Sub UserControl_InitProperties()
  On Error Resume Next
  ButtonColor = &H8000000F
  BorderColor = vbButtonShadow
  BackColor = vbWindowBackground
  Enabled = True
  m_BorderType = cNone
  m_ForeColorIn = vbWindowText
  m_ForeColorOut = vbWindowText
  m_ErrorColor = vbRed
  m_BackColor = vbWindowBackground
  m_ToolTipText = ""
  m_Table = csPrestacion
  m_Filter = ""
  m_HelpType = csNormal
  m_ColumnValueProcess = ""
  ButtonStyle = cHelpButtonSingle
End Sub

Private Sub UserControl_Show()
  On Error Resume Next
  DrawSelectionBox UNPRESSED
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
  On Error Resume Next
  With PropBag
    .WriteProperty c_ButtonColor, m_ButtonColor, &H8000000F
    .WriteProperty c_BorderColor, m_BorderColor, vbButtonShadow
    .WriteProperty c_BackColor, m_BackColor, vbWindowBackground
    .WriteProperty c_BorderType, m_BorderType, cNone
    .WriteProperty c_ForeColorIn, m_ForeColorIn, vbWindowText
    .WriteProperty c_ForeColorOut, m_ForeColorOut, vbWindowText
    .WriteProperty c_ErrorColor, m_ErrorColor, vbRed
    .WriteProperty c_ToolTipText, m_ToolTipText, ""
    .WriteProperty c_Table, m_Table, csPrestacion
    .WriteProperty c_Filter, m_Filter, ""
    .WriteProperty c_HelpType, m_HelpType, csNormal
    .WriteProperty c_ColumnValueProcess, m_ColumnValueProcess, ""
    .WriteProperty c_Font, TxValue.Font, Ambient.Font
    .WriteProperty c_FontBold, TxValue.FontBold, 0
    .WriteProperty c_FontItalic, TxValue.FontItalic, 0
    .WriteProperty c_FontName, TxValue.FontName, ""
    .WriteProperty c_FontSize, TxValue.FontSize, 0
    .WriteProperty c_FontStrikethru, TxValue.FontStrikethru, 0
    .WriteProperty c_FontUnderline, TxValue.FontUnderline, 0
    .WriteProperty c_ForeColor, TxValue.ForeColor, &H80000008
    .WriteProperty c_Enabled, m_Enabled, True
    .WriteProperty c_ButtonStyle, m_RealButtonStyle, cHelpButtonSingle
  End With
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
  On Error Resume Next
  With PropBag
    ButtonColor = .ReadProperty(c_ButtonColor, &H8000000F)
    BorderColor = .ReadProperty(c_BorderColor, vbButtonShadow)
    BackColor = .ReadProperty(c_BackColor, vbWindowBackground)
    BorderType = .ReadProperty(c_BorderType, cNone)
    ForeColorIn = .ReadProperty(c_ForeColorIn, vbWindowText)
    ForeColorOut = .ReadProperty(c_ForeColorOut, vbWindowText)
    ErrorColor = .ReadProperty(c_ErrorColor, vbRed)
    ToolTipText = .ReadProperty(c_ToolTipText, "")
    Table = .ReadProperty(c_Table, csPrestacion)
    Filter = .ReadProperty(c_Filter, "")
    HelpType = .ReadProperty(c_HelpType, csNormal)
    ColumnValueProcess = .ReadProperty(c_ColumnValueProcess, "")
    Set TxValue.Font = .ReadProperty(c_Font, Ambient.Font)
    TxValue.FontBold = .ReadProperty(c_FontBold, 0)
    TxValue.FontItalic = .ReadProperty(c_FontItalic, 0)
    TxValue.FontName = .ReadProperty(c_FontName, "MS Sans Serif")
    TxValue.FontSize = .ReadProperty(c_FontSize, 10)
    TxValue.FontStrikethru = .ReadProperty(c_FontStrikethru, 0)
    TxValue.FontUnderline = .ReadProperty(c_FontUnderline, 0)
    TxValue.ForeColor = .ReadProperty(c_ForeColor, &H80000008)
    Enabled = .ReadProperty(c_Enabled, True)
    ButtonStyle = .ReadProperty(c_ButtonStyle, cHelpButtonSingle)
  End With
End Sub
