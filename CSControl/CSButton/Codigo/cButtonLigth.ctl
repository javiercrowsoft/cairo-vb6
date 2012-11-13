VERSION 5.00
Begin VB.UserControl cButtonLigth 
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   DefaultCancel   =   -1  'True
   ScaleHeight     =   3600
   ScaleWidth      =   4800
   ToolboxBitmap   =   "cButtonLigth.ctx":0000
   Begin VB.PictureBox PicUser2 
      BorderStyle     =   0  'None
      Height          =   375
      Left            =   1890
      ScaleHeight     =   375
      ScaleWidth      =   375
      TabIndex        =   1
      Top             =   585
      Visible         =   0   'False
      Width           =   375
   End
   Begin VB.Image PicUser 
      Height          =   465
      Left            =   2565
      Top             =   450
      Width           =   690
   End
   Begin VB.Label lbShortCut 
      Height          =   420
      Left            =   630
      TabIndex        =   0
      Top             =   1755
      Width           =   2220
   End
End
Attribute VB_Name = "cButtonLigth"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private Const C_Module = "cButtonLigth"

Private Enum STATUS_BUTTON
  PRESSED = 1
  UNPRESSED = 2
  MOUSE_MOVE = 3
End Enum

Public Enum csBorderStyleLigth
  csBorderNone = 0
  csBorderSingle = 1
End Enum

Public Enum csCtrlAlignLigth
  csCtrlAlgCenter = 0
  csCtrlAlgLeft = 1
  csCtrlAlgRigth = 2
End Enum

Private m_FlagInside        As Boolean
Private m_CaptionToPrint    As String
Private m_Status            As STATUS_BUTTON
Private m_FocusInMe         As Boolean
Private m_IndiceKeyStrock   As Integer

' Contenedores de propiedades
Private m_ForeColor           As Long
Private m_BorderColor         As Long
Private m_Caption             As String
Private m_BorderStyle         As csBorderStyleLigth
Private m_BackColorPressed    As OLE_COLOR
Private m_BackColorUnpressed  As OLE_COLOR
Private m_Align               As csCtrlAlignLigth

'--------------------------------
' Eventos
Public Event Click()

'--------------------------------
' Propiedades
Public Property Get hwnd() As Long
  hwnd = UserControl.hwnd
End Property

Public Property Get BackColor() As OLE_COLOR
  BackColor = UserControl.BackColor
End Property

Public Property Let BackColor(ByVal rhs As OLE_COLOR)
  UserControl.BackColor() = rhs
  PropertyChanged c_BackColor
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
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

Public Property Get Picture() As Picture
  Set Picture = PicUser.Picture
End Property

Public Property Set Picture(ByVal rhs As Picture)
  Set PicUser.Picture = rhs
  UserControl.Cls
  DrawSelectionBox m_Status
  PropertyChanged c_Picture
End Property

Public Property Get Font() As Font
  Set Font = Ambient.Font
End Property

Public Property Set Font(ByVal rhs As Font)
  Set UserControl.Font = rhs
  PropertyChanged c_Font
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get FontBold() As Boolean
  FontBold = UserControl.FontBold
End Property

Public Property Let FontBold(ByVal rhs As Boolean)
  UserControl.FontBold() = rhs
  PropertyChanged c_FontBold
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get FontItalic() As Boolean
  FontItalic = UserControl.FontItalic
End Property

Public Property Let FontItalic(ByVal rhs As Boolean)
  UserControl.FontItalic() = rhs
  PropertyChanged c_FontItalic
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get FontName() As String
  FontName = UserControl.FontName
End Property

Public Property Let FontName(ByVal rhs As String)
  UserControl.FontName() = rhs
  PropertyChanged c_FontName
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get FontSize() As Single
  FontSize = UserControl.FontSize
End Property

Public Property Let FontSize(ByVal rhs As Single)
  UserControl.FontSize() = rhs
  PropertyChanged c_FontSize
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get FontStrikethru() As Boolean
  FontStrikethru = UserControl.FontStrikethru
End Property

Public Property Let FontStrikethru(ByVal rhs As Boolean)
  UserControl.FontStrikethru() = rhs
  PropertyChanged c_FontStrikethru
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get FontUnderline() As Boolean
  FontUnderline = UserControl.FontUnderline
End Property

Public Property Let FontUnderline(ByVal rhs As Boolean)
  UserControl.FontUnderline() = rhs
  PropertyChanged c_FontUnderline
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get BorderColor() As OLE_COLOR
  BorderColor = m_BorderColor
End Property

Public Property Let BorderColor(ByVal rhs As OLE_COLOR)
  m_BorderColor = rhs
  PropertyChanged c_BorderColor
  ' Fuerzo el repaint del control
  DrawSelectionBox m_Status
End Property

Public Property Get ForeColor() As OLE_COLOR
  ForeColor = m_ForeColor
End Property

Public Property Let ForeColor(ByVal rhs As OLE_COLOR)
  m_ForeColor = rhs
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

Public Property Get Align() As csCtrlAlignLigth
   Align = m_Align
End Property

Public Property Let Align(ByVal rhs As csCtrlAlignLigth)
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

Public Property Get BorderStyle() As csBorderStyleLigth
  BorderStyle = m_BorderStyle
End Property

Public Property Let BorderStyle(ByVal rhs As csBorderStyleLigth)
  m_BorderStyle = rhs
End Property

Public Sub Push()
  UserControl_GotFocus
  UserControl_MouseMove 0, 0, 10, 10
  UserControl_Click
End Sub

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
  UserControl_Paint
End Sub

Private Sub UserControl_InitProperties()
  On Error GoTo ControlError
  
  Caption = c_Button
  m_BorderStyle = csBorderSingle
  m_BackColorPressed = m_def_BackColorPressed
  m_BackColorUnpressed = m_def_BackColorUnpressed
  m_Align = csCtrlAlgCenter
  m_BorderColor = -1

  GoTo ExitProc
ControlError:
  MngError Err, "UserControl_InitProperties", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub UserControl_Paint()
  On Error Resume Next
  DrawSelectionBox UNPRESSED
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
  On Error GoTo ControlError
  
  With PropBag
    .WriteProperty c_Caption, m_Caption, c_Button
    .WriteProperty c_Font, UserControl.Font, Ambient.Font
    .WriteProperty c_FontBold, UserControl.FontBold, 0
    .WriteProperty c_FontItalic, UserControl.FontItalic, 0
    .WriteProperty c_FontName, UserControl.FontName, vbNullString
    .WriteProperty c_FontSize, UserControl.FontSize, 0
    .WriteProperty c_FontStrikethru, UserControl.FontStrikethru, 0
    .WriteProperty c_FontUnderline, UserControl.FontUnderline, 0
    .WriteProperty c_ForeColor, ForeColor, &H80000008
    .WriteProperty c_BorderColor, BorderColor, -1
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
    Set UserControl.Font = .ReadProperty(c_Font, Ambient.Font)
    UserControl.FontBold = .ReadProperty(c_FontBold, 0)
    UserControl.FontItalic = .ReadProperty(c_FontItalic, 0)
    UserControl.FontName = .ReadProperty(c_FontName, "MS Sans Serif")
    UserControl.FontSize = .ReadProperty(c_FontSize, 10)
    UserControl.FontStrikethru = .ReadProperty(c_FontStrikethru, 0)
    UserControl.FontUnderline = .ReadProperty(c_FontUnderline, 0)
    ForeColor = .ReadProperty(c_ForeColor, &H80000008)
    UserControl.BackColor = .ReadProperty(c_BackColor, &H8000000F)
    m_BorderStyle = .ReadProperty(c_BorderStyle, csBorderSingle)
    BorderColor = .ReadProperty(c_BorderColor, -1)
    Set Picture = .ReadProperty(c_Picture, Nothing)
    m_BackColorPressed = .ReadProperty(c_BackColorPressed, m_def_BackColorPressed)
    m_BackColorUnpressed = .ReadProperty(c_BackColorUnpressed, m_def_BackColorUnpressed)
    m_Align = .ReadProperty(c_Align, csCtrlAlgCenter)
    Enabled = .ReadProperty(c_Enabled, -1)
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
  lbShortCut.Left = lbShortCut.Width * -1
End Sub

Private Sub UserControl_Click()
  On Error GoTo ControlError
  
  ' Para que se ejecute el lostfocus de los demas controles
  DoEvents
  DrawSelectionBox PRESSED
  DoEvents
  RaiseEvent Click
  ' Como el foco esta en el control, el control se levanta
  Sleep 200
  DrawSelectionBox MOUSE_MOVE
  m_FlagInside = False

  GoTo ExitProc
ControlError:
  MngError Err, "UserControl_Click", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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
      
      ' el punto esta fuera del control
      m_FlagInside = False
      ret = ReleaseCapture()
      DrawSelectionBox UNPRESSED
    Else
      ' el punto esta dentro del control
      If m_FlagInside = False Then
        m_FlagInside = True
        ret = SetCapture(.hwnd)
        DrawSelectionBox MOUSE_MOVE
      End If
    End If
  End With
End Sub

Private Sub DrawSelectionBox(Optional ByVal bStatus As STATUS_BUTTON)
  Dim clrTopLeft As Long, clrBottomRight As Long
  Dim Margen   As Long
  
  With UserControl
    .Cls
    m_Status = bStatus

    If Enabled Then
      .ForeColor = m_ForeColor
    Else
      .ForeColor = vbGrayText
    End If

    'Set highlight and shadow colors
    If m_BorderColor = -1 Then
  
      Select Case bStatus
        Case PRESSED
          .BackColor = BackColorPressed
          clrTopLeft = vbButtonShadow
          clrBottomRight = vb3DHighlight
        Case UNPRESSED
          .BackColor = BackColorUnpressed
          clrTopLeft = vbButtonShadow
          clrBottomRight = vbButtonShadow
        Case MOUSE_MOVE
          clrTopLeft = vb3DHighlight
          clrBottomRight = vbButtonShadow
      End Select
    Else
      clrTopLeft = m_BorderColor
      clrBottomRight = m_BorderColor
    End If
  
    On Error Resume Next
    
    If Ambient.DisplayAsDefault Then
'      .DrawWidth = 2
'      Margen = 30
    
      If m_Status <> MOUSE_MOVE And m_Status <> PRESSED Then
        DrawObjBox UserControl.hDC, 10, 20, ScaleWidth - 20, ScaleHeight - 10, False, _
                   0, 0, 1, vb3DHighlight, vb3DHighlight, csEBS3d, True
      End If
    End If
    
'      If m_BorderStyle Or bStatus = MOUSE_MOVE Or bStatus = PRESSED Then
'
'        ' Izquierda
'        UserControl.Line (0, 0)-Step(Margen / 2, ScaleHeight), clrTopLeft
'
'        ' Arriba
'        UserControl.Line (0, 0)-Step(ScaleWidth, Margen / 2), clrTopLeft
'
'        ' Derecha
'        UserControl.Line (ScaleWidth - Margen / 2, 0)-Step(0, ScaleHeight), clrBottomRight
'
'        ' Abajo
'        UserControl.Line (Margen / 2, ScaleHeight - Margen / 2)-Step(ScaleWidth - Margen * 2, 0), clrBottomRight
'      End If
'    Else
'      .DrawWidth = 1
'      Margen = 15
'
'      If m_BorderStyle Or bStatus = MOUSE_MOVE Or bStatus = PRESSED Then
'
'        ' Izquierda
'        UserControl.Line (0, 0)-Step(0, ScaleHeight), clrTopLeft
'
'        ' Arriba
'        UserControl.Line (0, 0)-Step(ScaleWidth, 0), clrTopLeft
'
'        ' Derecha
'        UserControl.Line (ScaleWidth - Margen, 0)-Step(0, ScaleHeight), clrBottomRight
'
'        ' Abajo
'        UserControl.Line (Margen, ScaleHeight - Margen)-Step(ScaleWidth - Margen * 2, 0), clrBottomRight
'      End If
  
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
                 0, 0, 1, clrTopLeft, clrBottomRight, csEBS3d, True
  
  End If
  
  
    Dim offset As Integer
    offset = DrawOk
    
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
    
    Dim lCapStrockWidth As Long
    lCapStrockWidth = .TextWidth(Mid(m_Caption, 1, m_IndiceKeyStrock - 1))
    
    ' si hay una tecla con keystroke tengo que dibujar la rayita debajo
    If m_IndiceKeyStrock > 0 Then
      ' tengo que obtener la x e y
      Select Case m_Align
        Case csCtrlAlgCenter
          .CurrentX = offset + ((ScaleWidth - offset - lCaptionWidth) / 2 + 5) + lCapStrockWidth
        Case csCtrlAlgLeft
          .CurrentX = offset + lCapStrockWidth
        Case csCtrlAlgRigth
          .CurrentX = ScaleWidth - lCaptionWidth + lCapStrockWidth
      End Select
      .CurrentY = ((ScaleHeight - lCaptionHeight) / 2) + 10
      
      UserControl.Print "_"
    End If
  End With
End Sub

Private Function DrawOk() As Integer
  Dim y As Integer
  
  On Error Resume Next
  
  With UserControl
  
    y = ((.ScaleHeight - PicUser.Picture.Height) / 2) + 90
    If y < 0 Then y = 0
    .PaintPicture PicUser.Picture, 45, y
    
  End With
  
  With PicUser.Picture
    If .Handle <> 0 Then DrawOk = (.Width / 1.5) + 90
  End With
End Function
