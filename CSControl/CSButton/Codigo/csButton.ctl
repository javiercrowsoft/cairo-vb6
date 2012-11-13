VERSION 5.00
Begin VB.UserControl cButton 
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   DefaultCancel   =   -1  'True
   ScaleHeight     =   3600
   ScaleWidth      =   4800
   ToolboxBitmap   =   "csButton.ctx":0000
   Begin VB.PictureBox PicUser2 
      BorderStyle     =   0  'None
      Height          =   375
      Left            =   3780
      ScaleHeight     =   375
      ScaleWidth      =   375
      TabIndex        =   1
      Top             =   2760
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.Image PicUser 
      Height          =   315
      Left            =   4380
      Top             =   2820
      Width           =   315
   End
   Begin VB.Label lbShortCut 
      Height          =   420
      Left            =   1170
      TabIndex        =   0
      Top             =   2205
      Width           =   2220
   End
End
Attribute VB_Name = "cButton"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Const C_Module = "cButton"

Private Const c_Style = "Style"
Private Const c_TabButton = "TabButton"
Private Const c_TabSelected = "TabSelected"

Private Enum STATUS_BUTTON
  PRESSED = 1
  UNPRESSED = 2
  MOUSE_MOVE = 3
End Enum

Private m_FlagInside            As Boolean
Private m_CaptionToPrint        As String
Private m_Status                As STATUS_BUTTON
Private m_FocusInMe             As Boolean
Private m_IndiceKeyStrock       As Integer

Public Enum csButtonStyle
  csSimple = 0
  csDelete = 1
  csOk = 2
  csSave = 3
  csNew = 4
  csCopy = 5
End Enum

Public Enum csBorderStyle
  csBorderNone = 0
  csBorderSingle = 1
End Enum

Public Enum csCtrlAlign
  csCtrlAlgCenter = 0
  csCtrlAlgLeft = 1
  csCtrlAlgRigth = 2
End Enum

' Contenedores de propiedades
Private m_Caption                 As String
Private m_Style                   As csButtonStyle
Private m_BorderStyle             As csBorderStyle
Private m_BackColorPressed        As OLE_COLOR
Private m_BackColorUnpressed      As OLE_COLOR
Private m_Align                   As csCtrlAlign
Private m_TabButton               As Boolean
Private m_TabSelected             As Boolean
Private m_TabGroup                As Integer

'--------------------------------
' Eventos
Public Event Click()

'--------------------------------
' Propiedades
Public Property Get hwnd() As Long
  hwnd = UserControl.hwnd
End Property

Public Property Get TabGroup() As Integer
  TabGroup = m_TabGroup
End Property

Public Property Let TabGroup(ByVal rhs As Integer)
  m_TabGroup = rhs
End Property

Public Property Get BackColor() As OLE_COLOR
  BackColor = UserControl.BackColor
End Property

Public Property Let BackColor(ByVal New_BackColor As OLE_COLOR)
  UserControl.BackColor = New_BackColor
  PropertyChanged c_BackColor
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get Picture() As Picture
  Set Picture = PicUser.Picture
End Property

Public Property Set Picture(ByVal rhs As Picture)
  Set PicUser.Picture = rhs
  UserControl.Cls
  DrawSelectionBox m_Status
  PropertyChanged c_Picture
End Property

Public Property Get Enabled() As Boolean
  Enabled = UserControl.Enabled
End Property

Public Property Let Enabled(ByVal rhs As Boolean)
  UserControl.Enabled = rhs
  UserControl.Cls
  DrawSelectionBox m_Status
  PropertyChanged c_Enabled
End Property

Public Property Get Font() As Font
  Set Font = Ambient.Font
End Property

Public Property Set Font(ByVal New_Font As Font)
  Set UserControl.Font = New_Font
  PropertyChanged c_Font
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get FontBold() As Boolean
  FontBold = UserControl.FontBold
End Property

Public Property Let FontBold(ByVal New_FontBold As Boolean)
  UserControl.FontBold = New_FontBold
  PropertyChanged c_FontBold
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get FontItalic() As Boolean
  FontItalic = UserControl.FontItalic
End Property

Public Property Let FontItalic(ByVal New_FontItalic As Boolean)
  UserControl.FontItalic = New_FontItalic
  PropertyChanged c_FontItalic
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get FontName() As String
  FontName = UserControl.FontName
End Property

Public Property Let FontName(ByVal New_FontName As String)
  UserControl.FontName = New_FontName
  PropertyChanged c_FontName
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get FontSize() As Single
  FontSize = UserControl.FontSize
End Property

Public Property Let FontSize(ByVal New_FontSize As Single)
  UserControl.FontSize = New_FontSize
  PropertyChanged c_FontSize
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get FontStrikethru() As Boolean
  FontStrikethru = UserControl.FontStrikethru
End Property

Public Property Get TabButton() As Boolean
  TabButton = m_TabButton
End Property

Public Property Let TabButton(ByVal rhs As Boolean)
  m_TabButton = rhs
  PropertyChanged c_TabButton
End Property

Public Property Get TabSelected() As Boolean
  TabSelected = m_TabSelected
End Property

Public Property Let TabSelected(ByVal rhs As Boolean)
  m_TabSelected = rhs
  PropertyChanged c_TabSelected
  pSetOthersTabs
  DrawSelectionBox m_Status
End Property

Public Property Let FontStrikethru(ByVal rhs As Boolean)
  UserControl.FontStrikethru = rhs
  PropertyChanged c_FontStrikethru
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get FontUnderline() As Boolean
  FontUnderline = UserControl.FontUnderline
End Property

Public Property Let FontUnderline(ByVal rhs As Boolean)
  UserControl.FontUnderline = rhs
  PropertyChanged c_FontUnderline
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get ForeColor() As OLE_COLOR
  ForeColor = UserControl.ForeColor
End Property

Public Property Let ForeColor(ByVal rhs As OLE_COLOR)
  UserControl.ForeColor = rhs
  PropertyChanged c_ForeColor
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get Caption() As String
  Caption = m_Caption
End Property

Public Property Let Caption(ByVal sCaption As String)
  m_Caption = sCaption

  m_IndiceKeyStrock = InStr(1, sCaption, "&")
  If m_IndiceKeyStrock > 0 Then
    m_CaptionToPrint = Mid(sCaption, 1, m_IndiceKeyStrock - 1)
    m_CaptionToPrint = m_CaptionToPrint + Mid(sCaption, m_IndiceKeyStrock + 1)
  Else
    m_CaptionToPrint = sCaption
  End If

  ' Uso esta etiqueta para darle un keystroke al boton
  lbShortCut.Caption = sCaption

  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get Align() As csCtrlAlign
   Align = m_Align
End Property

Public Property Let Align(ByVal rhs As csCtrlAlign)
   m_Align = rhs
   DrawSelectionBox m_Status
   PropertyChanged c_Align
End Property

Public Property Get BackColorPressed() As OLE_COLOR
  BackColorPressed = m_BackColorPressed
End Property

Public Property Let BackColorPressed(ByVal rhs As OLE_COLOR)
  m_BackColorPressed = rhs
  PropertyChanged c_BackColorPressed
End Property

Public Property Get BackColorUnpressed() As OLE_COLOR
  BackColorUnpressed = m_BackColorUnpressed
End Property

Public Property Let BackColorUnpressed(ByVal rhs As OLE_COLOR)
  m_BackColorUnpressed = rhs
  PropertyChanged c_BackColorUnpressed
End Property

Public Property Get Style() As csButtonStyle
  Style = m_Style
End Property

Public Property Let Style(ByVal csStyle As csButtonStyle)
  m_Style = csStyle
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get BorderStyle() As csBorderStyle
  BorderStyle = m_BorderStyle
End Property

Public Property Let BorderStyle(ByVal rhs As csBorderStyle)
  m_BorderStyle = rhs
End Property

Public Sub Push()
  On Error Resume Next
  UserControl_GotFocus
  UserControl_MouseMove 0, 0, 10, 10
  UserControl_Click
End Sub

Public Sub VirtualPush()
  On Error Resume Next

  gbNoShowError = True

  UserControl_GotFocus
  UserControl_MouseMove 0, 0, 10, 10
  pButtonClick False
  
  gbNoShowError = False
End Sub

Private Sub UserControl_InitProperties()
  On Error GoTo ControlError
  
  Caption = c_Button
  Style = csSimple
  m_BorderStyle = csBorderSingle
  m_BackColorPressed = m_def_BackColorPressed
  m_BackColorUnpressed = m_def_BackColorUnpressed
  m_Align = csCtrlAlgCenter
  
  GoTo ExitProc
ControlError:
  MngError Err, "UserControl_InitProperties", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
  On Error GoTo ControlError
  
  With PropBag
  
    .WriteProperty c_Caption, m_Caption, c_Button
    .WriteProperty c_Style, m_Style, csButtonStyle.csSimple
    .WriteProperty c_Font, UserControl.Font, Ambient.Font
    .WriteProperty c_FontBold, UserControl.FontBold, 0
    .WriteProperty c_FontItalic, UserControl.FontItalic, 0
    .WriteProperty c_FontName, UserControl.FontName, vbNullString
    .WriteProperty c_FontSize, UserControl.FontSize, 0
    .WriteProperty c_FontStrikethru, UserControl.FontStrikethru, 0
    .WriteProperty c_TabButton, m_TabButton, 0
    .WriteProperty c_TabSelected, m_TabSelected, 0
    .WriteProperty c_FontUnderline, UserControl.FontUnderline, 0
    .WriteProperty c_ForeColor, UserControl.ForeColor, &H80000008
    .WriteProperty c_BackColor, UserControl.BackColor, &H8000000F
    .WriteProperty c_BorderStyle, m_BorderStyle, csBorderSingle
    .WriteProperty c_Picture, Picture, Nothing
    .WriteProperty c_BackColorPressed, m_BackColorPressed, m_def_BackColorPressed
    .WriteProperty c_BackColorUnpressed, m_BackColorUnpressed, m_def_BackColorUnpressed
    .WriteProperty c_Align, m_Align, csCtrlAlgCenter
    .WriteProperty c_Enabled, UserControl.Enabled, -1
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "UserControl_WriteProperties", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
  On Error GoTo ControlError
  
  With PropBag
    Caption = .ReadProperty(c_Caption, c_Button)
    Style = .ReadProperty(c_Style, csButtonStyle.csSimple)
    m_BorderStyle = .ReadProperty(c_BorderStyle, csBorderSingle)
    Set Picture = .ReadProperty(c_Picture, Nothing)
    m_BackColorPressed = .ReadProperty(c_BackColorPressed, m_def_BackColorPressed)
    m_BackColorUnpressed = .ReadProperty(c_BackColorUnpressed, m_def_BackColorUnpressed)
    m_Align = .ReadProperty(c_Align, csCtrlAlgCenter)
    TabButton = .ReadProperty(c_TabButton, False)
    TabSelected = .ReadProperty(c_TabSelected, False)
    Enabled = .ReadProperty(c_Enabled, -1)
  End With

  With UserControl
    Set .Font = PropBag.ReadProperty(c_Font, Ambient.Font)
    .FontBold = PropBag.ReadProperty(c_FontBold, 0)
    .FontItalic = PropBag.ReadProperty(c_FontItalic, 0)
    .FontName = PropBag.ReadProperty(c_FontName, "MS Sans Serif")
    .FontSize = PropBag.ReadProperty(c_FontSize, 10)
    .FontStrikethru = PropBag.ReadProperty(c_FontStrikethru, 0)
    .FontUnderline = PropBag.ReadProperty(c_FontUnderline, 0)
    .ForeColor = PropBag.ReadProperty(c_ForeColor, &H80000008)
    .BackColor = PropBag.ReadProperty(c_BackColor, &H8000000F)
  End With

  GoTo ExitProc
ControlError:
  
  ' No vamos a mostrar info por que resulta mas
  ' molesto que otra cosa, asi que nos comemos
  ' el error
  '
  ' MngError Err, "UserControl_ReadProperties", C_Module, vbNullString
  '
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub UserControl_Resize()
  On Error Resume Next
  
  DrawSelectionBox m_Status
End Sub

Private Sub UserControl_Click()
  pButtonClick True
End Sub

Private Sub pButtonClick(ByVal bRaiseEvent As Boolean)
  On Error GoTo ControlError

  pSetOthersTabs
  ' Para que se ejecute el lostfocus de los demas controles
  DoEvents
  DrawSelectionBox PRESSED
  DoEvents
  
  If bRaiseEvent Then
    RaiseEvent Click
  End If
  
  ' Como el foco esta en el control, el control se levanta
  Sleep 200
  
  DrawSelectionBox MOUSE_MOVE
  m_FlagInside = False

  GoTo ExitProc
ControlError:
  MngError Err, "pButtonClick", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub pSetOthersTabs()
  Dim Ctl As Control
  
  If Not m_TabButton Then Exit Sub
  If UserControl.Parent Is Nothing Then Exit Sub
  
  For Each Ctl In UserControl.Parent.Controls
    
    With Ctl
  
      If .Name = Left$(UserControl.Ambient.DisplayName, Len(.Name)) Then
        If .TabGroup = m_TabGroup Then
          .TabUnSelect
        End If
      End If
    End With
  Next
  
  m_TabSelected = True
End Sub

Public Sub TabUnSelect()
  m_TabSelected = False
  DrawSelectionBox UNPRESSED
End Sub

Private Sub UserControl_GotFocus()
  On Error Resume Next

  m_FocusInMe = True
  DrawSelectionBox MOUSE_MOVE
End Sub

Private Sub UserControl_LostFocus()
  On Error Resume Next

  m_FocusInMe = False
  DrawSelectionBox UNPRESSED
End Sub

Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  On Error Resume Next
  
  Dim ret As Long
  
  If m_FocusInMe Then Exit Sub
    
  With UserControl
  
    If x < 0 Or x > .Width Or y < 0 Or y > .Height Then
    
      ' El punto esta fuera del control
      m_FlagInside = False
      ret = ReleaseCapture()
      DrawSelectionBox UNPRESSED
    
    Else
      ' El punto esta dentro del control
      If m_FlagInside = False Then
        m_FlagInside = True
        ret = SetCapture(.hwnd)
        DrawSelectionBox MOUSE_MOVE
      End If
    End If
  End With
End Sub

Private Sub DrawSelectionBox(Optional ByVal bStatus As STATUS_BUTTON)
  Dim clrTopLeft As Long, clrRight As Long, clrBottom As Long

  m_Status = bStatus
  If m_Status = 0 Then m_Status = UNPRESSED
  
  With UserControl
    .Cls
  
    If m_TabSelected Then m_Status = PRESSED
    
    If Enabled Then
      .ForeColor = vbWindowText
    Else
      .ForeColor = vbGrayText
    End If
  
    'Set highlight and shadow colors
    Select Case m_Status
    
    Case PRESSED
      
      If m_TabButton Then
        .BackColor = BackColorPressed
        clrTopLeft = vbButtonShadow
        clrBottom = BackColorPressed
        clrRight = clrTopLeft
      Else
        .BackColor = BackColorPressed
        clrTopLeft = vbButtonShadow
        clrBottom = vb3DHighlight
        clrRight = vb3DHighlight
      End If
    Case UNPRESSED
      .BackColor = BackColorUnpressed
      clrTopLeft = vbButtonShadow
      clrBottom = vbButtonShadow
      clrRight = vbButtonShadow
    Case MOUSE_MOVE
      If m_TabButton Then
        clrTopLeft = vbButtonShadow
        clrRight = clrTopLeft
        If m_TabSelected Then
          clrBottom = clrTopLeft
        Else
          clrBottom = clrTopLeft
        End If
      Else
        clrTopLeft = vb3DHighlight
        clrBottom = vbButtonShadow
        clrRight = vbButtonShadow
      End If
    End Select
  End With
  
  On Error Resume Next
  
  If pGetAmbientDefault And Not m_TabSelected Then
  
    If m_Status <> MOUSE_MOVE And m_Status <> PRESSED Then
      DrawObjBox UserControl.hDC, 10, 20, ScaleWidth - 20, ScaleHeight - 10, False, _
                 0, 0, 1, vb3DHighlight, vb3DHighlight, csEBS3d, True
    End If
  End If
  
  If m_BorderStyle Or m_Status = MOUSE_MOVE Or m_Status = PRESSED Then
  
'    ' Izquierda
'    UserControl.Line (0, 0)-Step(0, ScaleHeight), clrTopLeft
'
'    ' Arriba
'    UserControl.Line (0, 0)-Step(ScaleWidth, 0), clrTopLeft
'
'    ' Derecha
'    UserControl.Line (ScaleWidth - 15, 0)-Step(0, ScaleHeight), clrRight
'
'    ' Abajo
'    UserControl.Line (15, ScaleHeight - 15)-Step(ScaleWidth - 30, 0), clrBottom
  
    DrawObjBox UserControl.hDC, 0, 0, ScaleWidth, ScaleHeight, False, _
                 0, 0, 1, clrTopLeft, clrBottom, csEBS3d, True, clrRight
  
  End If
  
  Dim offset As Integer
  offset = DrawOk
  
  With UserControl
  
    Dim lCaptionWidth As Long
    lCaptionWidth = .TextWidth(m_CaptionToPrint)
  
    Select Case m_Align
      Case csCtrlAlgCenter
        .CurrentX = offset + ((ScaleWidth - offset - lCaptionWidth) / 2 + 5)
      Case csCtrlAlgLeft
        .CurrentX = offset
      Case csCtrlAlgRigth
        .CurrentX = ScaleWidth - lCaptionWidth
    End Select
  
    Dim lCaptionHeight As Long
    lCaptionHeight = .TextHeight(m_CaptionToPrint)
  
    .CurrentY = (ScaleHeight - lCaptionHeight) / 2 - 5
    UserControl.Print m_CaptionToPrint
  
    Dim lCaptionStockWidth As Long
    lCaptionStockWidth = .TextWidth(Mid(m_Caption, 1, m_IndiceKeyStrock - 1))
    
    ' si hay una tecla con keystroke tengo que dibujar la rayita debajo
    If m_IndiceKeyStrock > 0 Then
      ' tengo que obtener la x e y
      Select Case m_Align
        Case csCtrlAlgCenter
          .CurrentX = offset + ((ScaleWidth - offset - lCaptionWidth) / 2 + 5) + lCaptionStockWidth
        Case csCtrlAlgLeft
          .CurrentX = offset + lCaptionStockWidth
        Case csCtrlAlgRigth
          .CurrentX = ScaleWidth - lCaptionWidth + lCaptionStockWidth
      End Select
      .CurrentY = ((ScaleHeight - lCaptionHeight) / 2) + 10
      
      UserControl.Print "_"
    End If
  End With
End Sub

Private Function pGetAmbientDefault() As Boolean
  On Error Resume Next
  pGetAmbientDefault = Ambient.DisplayAsDefault
End Function

Private Function DrawOk() As Integer
  Dim y As Integer
  Dim p As IPictureDisp
  
  Select Case m_Style
  
    Case csSimple
      Set p = PicUser.Picture
    Case csOk
      Set p = CreateImage2(105) 'PicOk
    Case csDelete
      Set p = CreateImage2(102) 'PicDelete
    Case csSave
      Set p = CreateImage2(101) 'PicSave
    Case csCopy
      Set p = CreateImage2(104) 'picCopy
    Case csNew
      Set p = CreateImage2(103) 'picNew
  End Select
  
  On Error Resume Next
  
  With UserControl
  
    y = (.ScaleHeight - .ScaleY(p.Height, vbHimetric, vbTwips)) / 2
    .PaintPicture p, 45, y
    
    If p.Handle <> 0 Then DrawOk = .ScaleX(p.Width, vbHimetric, vbTwips) + 45
  End With
End Function

Private Sub UserControl_AccessKeyPress(KeyAscii As Integer)
  On Error Resume Next
  
  If KeyAscii = vbKeyReturn Then
    UserControl_Click
  ElseIf KeyAscii = vbKeyEscape Then
    UserControl_Click
  End If
End Sub

Private Sub UserControl_AmbientChanged(PropertyName As String)
  On Error Resume Next
  UserControl_Resize
End Sub

Private Sub UserControl_Paint()
  On Error Resume Next
  DrawSelectionBox UNPRESSED
End Sub
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,vbnullstring, C_Module, vbNullString
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

