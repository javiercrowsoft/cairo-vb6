VERSION 5.00
Begin VB.UserControl cMaskEdit 
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   ScaleHeight     =   3600
   ScaleWidth      =   4800
   ToolboxBitmap   =   "csMaskEdit.ctx":0000
   Begin VB.PictureBox PicBoton 
      AutoRedraw      =   -1  'True
      BorderStyle     =   0  'None
      Height          =   255
      Left            =   2385
      ScaleHeight     =   255
      ScaleWidth      =   735
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   1395
      Width           =   735
   End
   Begin VB.TextBox TxControl 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   450
      TabIndex        =   0
      Top             =   1350
      Width           =   1680
   End
End
Attribute VB_Name = "cMaskEdit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
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
    Private Enum STATUS_BUTTON
        PRESSED = 1
        UNPRESSED = 2
        MOUSE_MOVE = 3
    End Enum
    ' estructuras
    Private Type RECT
            Left As Long
            Top As Long
            Right As Long
            Bottom As Long
    End Type
    ' funciones
    Private Declare Function ReleaseCapture Lib "user32" () As Long
    Private Declare Function SetCapture Lib "user32" (ByVal hWnd As Long) As Long
    Private Declare Function GetWindowRect Lib "user32" (ByVal hWnd As Long, lpRect As RECT) As Long
'--------------------------------------------------------------------------------

' constantes
Private Const C_BotonWidth As Integer = 200
Private Const m_def_csValue = 0 'Default Property Values:
' estructuras
' variables privadas


Private m_flagInside        As Boolean
Private m_FocusInMe         As Boolean
Private m_Editando          As Boolean
Private m_NoLostFocus       As Boolean
Private m_status            As STATUS_BUTTON

Private m_BorderType    As csBorderType
Private m_ButtonColor   As Long
Private m_BorderColor   As Long

'Property Variables:
Private m_csType As csTextMascara

Private mSepDecimal As String

Private mNoRaiseError As Boolean
Private mNoSel        As Boolean

Private m_NotRaiseError As Boolean
Private m_WithOutCalc   As Boolean

' Eventos
Public Event Change()
Public Event KeyPress(KeyAscii As Integer)
Public Event KeyDown(KeyCode As Integer, Shift As Integer)
Public Event KeyUp(KeyCode As Integer, Shift As Integer)
Public Event ButtonClick()

' propiedades publicas
Public Property Get BorderStyle() As csBorderType
    BorderStyle = TxControl.BorderStyle
End Property

Public Property Let BorderStyle(ByVal New_BorderStyle As csBorderType)
    TxControl.BorderStyle() = New_BorderStyle
    UserControl_Resize
    PropertyChanged "BorderStyle"
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
    Text = SetFormatText()
End Property

Public Property Let Text(ByVal New_Text As String)
    Dim color As Long
    If Not ValidValue(New_Text) Then Exit Property
    TxControl.Text() = New_Text
    TxControl.Text = SetFormatText(color)
    TxControl.ForeColor = color
    PropertyChanged "Text"
End Property

Public Property Get Alignment() As AlignmentConstants
    Alignment = TxControl.Alignment
End Property

Public Property Let Alignment(ByVal New_Alignment As AlignmentConstants)
    TxControl.Alignment() = New_Alignment
    PropertyChanged "Alignment"
End Property

Public Property Get BackColor() As OLE_COLOR
    BackColor = TxControl.BackColor
End Property

Public Property Let BackColor(ByVal New_BackColor As OLE_COLOR)
    TxControl.BackColor() = New_BackColor
    PropertyChanged "BackColor"
End Property

Public Property Get Enabled() As Boolean
    Enabled = TxControl.Enabled
End Property

Public Property Let Enabled(ByVal New_Enabled As Boolean)
    TxControl.Enabled() = New_Enabled
    PropertyChanged "Enabled"
    If New_Enabled Then
        BackColor = &H80000005
    Else
        BackColor = &H80000004
    End If
End Property

Public Property Get Font() As Font
    Set Font = Ambient.Font
End Property

Public Property Set Font(ByVal New_Font As Font)
    Set TxControl.Font = New_Font
    PropertyChanged "Font"
End Property

Public Property Get FontBold() As Boolean
    FontBold = TxControl.FontBold
End Property

Public Property Let FontBold(ByVal New_FontBold As Boolean)
    TxControl.FontBold() = New_FontBold
    PropertyChanged "FontBold"
End Property

Public Property Get FontItalic() As Boolean
    FontItalic = TxControl.FontItalic
End Property

Public Property Let FontItalic(ByVal New_FontItalic As Boolean)
    TxControl.FontItalic() = New_FontItalic
    PropertyChanged "FontItalic"
End Property

Public Property Get FontName() As String
    FontName = TxControl.FontName
End Property

Public Property Let FontName(ByVal New_FontName As String)
    TxControl.FontName() = New_FontName
    PropertyChanged "FontName"
End Property

Public Property Get FontSize() As Single
    FontSize = TxControl.FontSize
End Property

Public Property Let FontSize(ByVal New_FontSize As Single)
    TxControl.FontSize() = New_FontSize
    PropertyChanged "FontSize"
End Property

Public Property Get FontStrikethru() As Boolean
    FontStrikethru = TxControl.FontStrikethru
End Property

Public Property Let FontStrikethru(ByVal New_FontStrikethru As Boolean)
    TxControl.FontStrikethru() = New_FontStrikethru
    PropertyChanged "FontStrikethru"
End Property

Public Property Get FontUnderline() As Boolean
    FontUnderline = TxControl.FontUnderline
End Property

Public Property Let FontUnderline(ByVal New_FontUnderline As Boolean)
    TxControl.FontUnderline() = New_FontUnderline
    PropertyChanged "FontUnderline"
End Property

Public Property Get ForeColor() As OLE_COLOR
    ForeColor = TxControl.ForeColor
End Property

Public Property Let ForeColor(ByVal New_ForeColor As OLE_COLOR)
    TxControl.ForeColor() = New_ForeColor
    PropertyChanged "ForeColor"
End Property

Public Property Get csType() As csTextMascara
    csType = m_csType
End Property

Public Property Let csType(ByVal New_csType As csTextMascara)
    m_csType = New_csType
    PropertyChanged "csType"
    
    Select Case m_csType
        Case csMkDouble, csMkMoneda, csMkEntero, csMkPorcentaje
          Alignment = vbRightJustify
          TxControl.Text = ""
        Case csMkFecha
          Alignment = vbRightJustify
          TxControl.Text = #1/1/1900#
        Case csMkTexto
          Alignment = vbLeftJustify
    End Select
End Property

Public Property Get csValue() As String
    If TxControl.Text = "" Then
      If csType = csMkTexto Then
        csValue = ""
        Exit Property
      ElseIf csType = csMkFecha Then
        csValue = #1/1/1900#
        Exit Property
      Else
        csValue = "0"
        Exit Property
      End If
    End If
    
    ' si solo tipeo el signo, tengo un cero
    If (TxControl.Text = "-" Or TxControl.Text = "+") And csType <> csMkTexto Then TxControl.Text = "0"

    Select Case m_csType
        Case csMkDouble
            csValue = Trim(CDbl(TxControl.Text))
        Case csMkEntero
            csValue = Trim(CLng(TxControl.Text))
        Case csMkMoneda
            csValue = Trim(CCur(TxControl.Text))
        Case csMkPorcentaje
            csValue = Trim(CDbl(Left(TxControl.Text, Len(TxControl.Text) - 2)) / 100)
        Case csMkTexto
            csValue = TxControl.Text
        Case csMkFecha
            If IsDate(TxControl.Text) Then
              csValue = DateValue(TxControl.Text)
            Else
              csValue = #1/1/1900#
            End If
    End Select
End Property

Public Property Let csValue(ByVal New_csValue As String)
    Text = New_csValue
End Property

Public Property Let csValueFromGrilla(ByVal New_csValue As String)
    mNoRaiseError = True
    mNoSel = True
    Text = New_csValue
End Property

Public Property Get ButtonColor() As OLE_COLOR
    ButtonColor = m_ButtonColor
End Property
Public Property Let ButtonColor(ByVal rhs As OLE_COLOR)
    m_ButtonColor = rhs
    PicBoton.BackColor = rhs
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
Public Property Get BorderType() As csBorderType
    BorderType = m_BorderType
End Property
Public Property Let BorderType(ByVal rhs As csBorderType)
    m_BorderType = rhs
    UserControl_Paint
End Property

Public Property Get MaxLength() As Integer
   MaxLength = TxControl.MaxLength
End Property

Public Property Let MaxLength(ByVal rhs As Integer)
   TxControl.MaxLength = rhs
   PropertyChanged "MaxLength"
End Property


'//////////////////////////////////////////////////////////////////
' carga
Private Sub UserControl_Initialize()
   mSepDecimal = GetSepDecimal
End Sub

Private Sub UserControl_KeyDown(KeyCode As Integer, Shift As Integer)
    If csType <> csMkTexto Then
      If (KeyCode = vbKeyF4 Or UCase(Chr(KeyCode))) = "C" And Shift = 0 Then
        ShowHelp
        ' El foco debe quedar en el control
        TxControl.SetFocus
      End If
    End If
End Sub

Private Sub UserControl_Resize()
    Dim MarcoInterno As Single
    
    If m_BorderType = cNone Then
        MarcoInterno = 0
    Else
        MarcoInterno = 15
    End If
    
    PicBoton.Move ScaleWidth - C_BotonWidth, MarcoInterno, C_BotonWidth, ScaleHeight - MarcoInterno * 2
    TxControl.Move MarcoInterno, MarcoInterno, ScaleWidth - C_BotonWidth - MarcoInterno, ScaleHeight - MarcoInterno * 2
    DrawSelectionBox UNPRESSED
End Sub

Private Sub UserControl_InitProperties()
    TxControl.Text = ""
    csType = csMkMoneda
    mSepDecimal = GetSepDecimal
    ButtonColor = &H8000000F
    BorderColor = vbButtonShadow
    BackColor = vbWindowBackground
    m_BorderType = cNone
    m_NotRaiseError = True
    m_WithOutCalc = False
End Sub

Private Sub UserControl_Terminate()
  On Error Resume Next
  Unload FrmCalcu
  Set FrmCalcu = Nothing
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    PropBag.WriteProperty "Text", Text, Extender.Name
    PropBag.WriteProperty "Text", TxControl.Text, ""
    PropBag.WriteProperty "Alignment", TxControl.Alignment, 0
    PropBag.WriteProperty "BackColor", TxControl.BackColor, &H80000005
    PropBag.WriteProperty "Enabled", TxControl.Enabled, True
    PropBag.WriteProperty "Font", TxControl.Font, Ambient.Font
    PropBag.WriteProperty "FontBold", TxControl.FontBold, 0
    PropBag.WriteProperty "FontItalic", TxControl.FontItalic, 0
    PropBag.WriteProperty "FontName", TxControl.FontName, ""
    PropBag.WriteProperty "FontSize", TxControl.FontSize, 0
    PropBag.WriteProperty "FontStrikethru", TxControl.FontStrikethru, 0
    PropBag.WriteProperty "FontUnderline", TxControl.FontUnderline, 0
    PropBag.WriteProperty "ForeColor", TxControl.ForeColor, &H80000008
    PropBag.WriteProperty "MaxLength", TxControl.MaxLength, 0
    
    PropBag.WriteProperty "csType", m_csType, csMkMoneda
    PropBag.WriteProperty "ButtonColor", m_ButtonColor, &H8000000F
    PropBag.WriteProperty "BorderColor", m_BorderColor, vbButtonShadow
    PropBag.WriteProperty "BorderType", m_BorderType, cNone
    PropBag.WriteProperty "csNotRaiseError", m_NotRaiseError, 0
    PropBag.WriteProperty "csWithOutCalc", m_WithOutCalc, 0
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    Text = PropBag.ReadProperty("Text", Extender.Name)
    TxControl.Text = PropBag.ReadProperty("Text", "")
    TxControl.Alignment = PropBag.ReadProperty("Alignment", 0)
    TxControl.BackColor = PropBag.ReadProperty("BackColor", &H80000005)
    TxControl.Enabled = PropBag.ReadProperty("Enabled", True)
    Set TxControl.Font = PropBag.ReadProperty("Font", Ambient.Font)
    TxControl.FontBold = PropBag.ReadProperty("FontBold", 0)
    TxControl.FontItalic = PropBag.ReadProperty("FontItalic", 0)
    TxControl.FontName = PropBag.ReadProperty("FontName", "MS Sans Serif")
    TxControl.FontSize = PropBag.ReadProperty("FontSize", 10)
    TxControl.FontStrikethru = PropBag.ReadProperty("FontStrikethru", 0)
    TxControl.FontUnderline = PropBag.ReadProperty("FontUnderline", 0)
    TxControl.ForeColor = PropBag.ReadProperty("ForeColor", &H80000008)
    TxControl.MaxLength = PropBag.ReadProperty("MaxLength", 0)
    
    m_csType = PropBag.ReadProperty("csType", csMkMoneda)
    ButtonColor = PropBag.ReadProperty("ButtonColor", &H8000000F)
    BorderColor = PropBag.ReadProperty("BorderColor", vbButtonShadow)
    BorderType = PropBag.ReadProperty("BorderType", cNone)
    m_NotRaiseError = PropBag.ReadProperty("csNotRaiseError", True)
    m_WithOutCalc = PropBag.ReadProperty("csWithOutCalc", False)
End Sub

Private Sub UserControl_Paint()
    UserControl_Resize
    DrawBorder
End Sub


'//////////////////////////////////////////////////////////////////
' eventos
Private Sub PicBoton_Click()
    Dim Cancel As Boolean
    ' Para que se ejecute el lostfocus de los demas controles
    DoEvents
    DrawSelectionBox PRESSED
    DoEvents
    
    RaiseEvent ButtonClick
    
    If Not Cancel And csType <> csMkTexto Then
        TxControl.SetFocus
        ShowHelp
    End If
    
    ' Como el foco esta en el control, el control se levanta
    Wait 0.2
    DrawSelectionBox MOUSE_MOVE
    m_flagInside = False
End Sub

Private Sub PicBoton_GotFocus()
    m_Editando = True
    m_FocusInMe = True
    DrawSelectionBox MOUSE_MOVE
    
    m_NoLostFocus = True
End Sub

Private Sub PicBoton_LostFocus()
    m_FocusInMe = False
    DrawSelectionBox UNPRESSED
    
    m_NoLostFocus = False
    DoEvents: DoEvents: DoEvents: DoEvents: DoEvents
    
    If m_NoLostFocus Then
        m_NoLostFocus = False
        Exit Sub
    End If
End Sub

Private Sub PicBoton_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
    Dim ret As Long
    
    If m_FocusInMe Then Exit Sub
        
    If x < 0 Or x > PicBoton.Width Or y < 0 Or y > PicBoton.Height Then
        
        ' el punto esta fuera del control
        m_flagInside = False
        ret = ReleaseCapture()
        DrawSelectionBox UNPRESSED
    Else
        ' el punto esta dentro del control
        If m_flagInside = False Then
            m_flagInside = True
            ret = SetCapture(PicBoton.hWnd)
            DrawSelectionBox MOUSE_MOVE
        End If
    End If
End Sub

Private Sub TxControl_Change()
    RaiseEvent Change
End Sub

Private Sub TxControl_KeyDown(KeyCode As Integer, Shift As Integer)
  If csType <> csMkTexto Then
    If UCase(Chr(KeyCode)) = "C" And Shift = 0 Then ShowHelp
    If KeyCode = vbKeyF4 And Shift = 0 Then ShowHelp
  End If
  RaiseEvent KeyDown(KeyCode, Shift)
End Sub

Private Sub TxControl_KeyUp(KeyCode As Integer, Shift As Integer)
    RaiseEvent KeyUp(KeyCode, Shift)
End Sub

Private Sub TxControl_KeyPress(KeyAscii As Integer)
    Dim iAscii As Integer
    
    RaiseEvent KeyPress(KeyAscii)
    
    ' Si es texto no hago nada
    If csType = csMkTexto Then Exit Sub
    
    iAscii = KeyAscii
    
    ' Si es BackSpace no hago nada
    If iAscii = vbKeyBack Then
        Exit Sub
    End If
    
    If csType = csMkFecha Then
      Select Case Chr(iAscii)
        Case ".", "-", "\", ","
          iAscii = Asc("/")
        
        Case "/", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
          ' Todo bien
          
          ' Este no sirve
        Case Else
          iAscii = 0
      End Select
    Else
      If Chr(iAscii) = "." Or Chr(iAscii) = "," Then
          If mSepDecimal = "." Then
              iAscii = Asc(".")
          Else
              iAscii = Asc(",")
          End If
      End If
      
      With TxControl
      Select Case m_csType
          Case csMkDouble, csMkMoneda, csMkPorcentaje, csMkEntero
              iAscii = ValidKeySign(.Text, iAscii)
      End Select
      End With
    End If
    KeyAscii = iAscii
End Sub

Public Property Get SelStart() As Integer
    SelStart = TxControl.SelStart
End Property

Public Property Let SelStart(ByVal position As Integer)
    TxControl.SelStart = position
End Property

Public Property Get SelLength() As Integer
    SelLength = TxControl.SelLength
End Property

Public Property Let SelLength(ByVal length As Integer)
    TxControl.SelLength = length
End Property

'//////////////////////////////////////////////////////////////////
' funciones privadas
Private Sub TxControl_GotFocus()
    
    ' Si es texto no hago nada
    If csType = csMkTexto Then Exit Sub
    
    TxControl.ForeColor = &H80000008
    
    If TxControl.Text = "" Then Exit Sub
    
    Select Case m_csType
        Case csMkDouble
            TxControl.Text = Trim(CDbl(TxControl.Text))
        Case csMkEntero
            TxControl.Text = Trim(CLng(TxControl.Text))
        Case csMkMoneda
            TxControl.Text = Trim(CCur(TxControl.Text))
        Case csMkPorcentaje
            TxControl.Text = Trim(CDbl(Left(TxControl.Text, Len(TxControl.Text) - 2)))
    End Select
    
    TxControl.SelStart = Len(TxControl.Text)
    If mNoSel Then
        mNoSel = False
    Else
        TxControl.SelStart = 0
        TxControl.SelLength = Len(TxControl.Text)
    End If
End Sub

Private Sub TxControl_LostFocus()
    Dim color As Long
    If csType <> csMkTexto And csType <> csMkFecha Then
      TxControl.Text = SetFormatText(color)
      TxControl.ForeColor = color
    ElseIf csType = csMkFecha Then
      ValidFecha
    End If
End Sub

Private Sub ValidFecha()
  If Not IsDate(TxControl.Text) Then
    TxControl.Text = Format(#1/1/1900#, "dd/mm/yyyy")
    TxControl.ForeColor = vbRed
  Else
    TxControl.Text = Format(TxControl.Text, "dd/mm/yyyy")
    TxControl.ForeColor = vbWindowText
  End If
End Sub

Private Function SetFormatText(Optional ByRef color As Long) As String
    
    color = &H80000008
    
    SetFormatText = TxControl.Text
    
    ' Si es texto no hago nada
    If csType = csMkTexto Or csType = csMkFecha Then Exit Function
    
    ' si solo tipeo un signo lo reemplazo por un cero
    If SetFormatText = "-" Or SetFormatText = "+" Or SetFormatText = "" Then
        SetFormatText = "0"
    End If
    
    If CDbl(SetFormatText) < -1 Then
        color = vbRed
    End If
    
    Select Case m_csType
        Case csMkDouble
            SetFormatText = Format(SetFormatText, "#,###,##0.00##")
        Case csMkEntero
            SetFormatText = Format(SetFormatText, "#,###,##0")
        Case csMkMoneda
            SetFormatText = Format(SetFormatText, "$ #,###,##0.00##;($ #,###,##0.00##)")
        Case csMkPorcentaje
            SetFormatText = Format(SetFormatText / 100, "#,###,##0.00## %")
    End Select
End Function

Private Function ValidKeySign(ByVal sText As String, ByVal iAscii As Integer, Optional bEntero As Boolean = False) As Integer
    Dim i As Integer
    
    ' Si es texto no hago nada
    If csType = csMkTexto Then
      ValidKeySign = iAscii
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
        
        If TxControl.SelLength = Len(TxControl.Text) Then
        ' si todo el texto esta sombreado, entonces el signo reemplaza el
        ' texto

        ' sino coloco el cursor al principio
        Else
        
            ' si habia otro signo en el numero lo saco
            If Left(TxControl.Text, 1) = "-" Or Left(TxControl.Text, 1) = "+" Then TxControl.Text = Mid(TxControl.Text, 2)
            TxControl.SelStart = 0
            TxControl.SelLength = 0
        End If
        
    ' sino, compruebo que sea un numero si es entero
    ElseIf bEntero Then
        iAscii = ValidKeyNumber(iAscii)
        
    ' o un signo si es double o moneda
    Else
        iAscii = ValidKeyDecimal(sText, iAscii)
    End If
    
    ValidKeySign = iAscii

End Function

Private Function ValidKeyDecimal(ByVal sText As String, ByVal iAscii As Integer) As Integer
    Dim i As Integer
    
    ' Si es texto no hago nada
    If csType = csMkTexto Then
      ValidKeyDecimal = iAscii
      Exit Function
    End If
    
    ' No puede haber mas de un punto decimal
    i = InStr(1, sText, mSepDecimal)
    If i > 0 Then
        
        ' un segundo punto es un caracter invalido
        If Chr(iAscii) = mSepDecimal Then
            iAscii = 0
        End If
    End If
    
    ' Si es un punto decimal es valido
    If Chr(iAscii) = mSepDecimal Then

    ' sino, compruebo que sea un numero
    Else
        iAscii = ValidKeyNumber(iAscii)
    End If
    
    ValidKeyDecimal = iAscii
End Function

Private Function ValidKeyNumber(ByVal iAscii As Integer) As Integer
    ' Si es texto no hago nada
    If csType = csMkTexto Then
      ValidKeyNumber = iAscii
      Exit Function
    End If
    
    Select Case iAscii
        ' si es numero todo bien
        Case vbKey1, vbKey2, vbKey3, vbKey4, vbKey5, vbKey6, vbKey7, vbKey8, vbKey9, vbKey0
        Case Else
            iAscii = 0
    End Select
    
    ValidKeyNumber = iAscii
End Function

Private Function ValidValue(ByRef svalue As String) As Boolean

    ' Permito limpiar la caja
    If svalue <> "" And csType <> csMkTexto Then
    
        Select Case m_csType
            Case csMkDouble, csMkMoneda
                If Not IsNumeric(svalue) Then GoTo InvalidValue
            Case csMkEntero
                If Not IsNumeric(svalue) Then GoTo InvalidValue
                
                If CLng(svalue) <> svalue Then GoTo InvalidValue
            Case csMkPorcentaje
                If Not IsNumeric(svalue) Then GoTo InvalidValue
        
                svalue = Trim(CDbl(svalue) * 100)
            Case csMkFecha
                ValidFecha
        End Select
    
    End If
    
    ValidValue = True
    mNoRaiseError = False
    Exit Function

InvalidValue:
    If m_NotRaiseError Then Exit Function
    
    If mNoRaiseError Then
        mNoRaiseError = False
    Else
        mNoRaiseError = False
        Err.Raise 380
    End If
End Function

Private Sub ShowHelp()
    Dim offsetLeft As Integer
    
    If m_WithOutCalc Then Exit Sub
    
    ' El left se calcula con prioridad derecha.
    ' si la calculadora no cabe en la pantalla se alinea a la izquierda
    
    ' Obtengo el desplazamiento izquierdo
    offsetLeft = LeftControlToLeftForm(hWnd)
    
    If m_csType = csMkFecha Then
      
      ' Uso la propiedad como almacenamiento temporal
      FrmCalendario.Left = offsetLeft
      
      ' Obtengo la posicion de la esquina derecha del control
      offsetLeft = offsetLeft + Width
      
      ' Obtengo el nuevo left
      offsetLeft = offsetLeft - FrmCalendario.Width
      
      ' Si esta dentro de la pantalla lo uso
      If offsetLeft >= 0 Then FrmCalendario.Left = offsetLeft
      
      FrmCalendario.Top = TopControlToTopForm(hWnd, Height)
      With FrmCalendario.clCalend
        .Day = DatePart("d", csValue)
        .Month = DatePart("m", csValue)
        .Year = DatePart("yyyy", csValue)
        FrmCalendario.Show vbModal
      
        If FrmCalendario.Ok Then
          TxControl.Text = Format(.Day & "/" & .Month & "/" & .Year, "dd/mm/yyyy")
        End If
      End With
      Unload FrmCalendario
      Set FrmCalendario = Nothing
    Else
      
      ' Uso la propiedad como almacenamiento temporal
      FrmCalcu.Left = offsetLeft
      
      ' Obtengo la posicion de la esquina derecha del control
      offsetLeft = offsetLeft + Width
      
      ' Obtengo el nuevo left
      offsetLeft = offsetLeft - FrmCalcu.Width
      
      ' Si esta dentro de la pantalla lo uso
      If offsetLeft >= 0 Then FrmCalcu.Left = offsetLeft
      
      FrmCalcu.Top = TopControlToTopForm(hWnd, Height)
      FrmCalcu.LbDisplay.Caption = csValue
      FrmCalcu.Show vbModal
  
      If Not FrmCalcu.Cancel Then
          Text = FrmCalcu.LbDisplay
      End If
      
      Unload FrmCalcu
      Set FrmCalcu = Nothing
    End If
End Sub

Private Function LeftControlToLeftForm(ByVal lhwnd As Long) As Long
    Dim lpRect As RECT
    Dim iRet As Long
    
    iRet = GetWindowRect(lhwnd, lpRect)
    
    LeftControlToLeftForm = 0
    
    ' Hubo un error devuelvo cero
    If iRet = 0 Then Exit Function
    
    LeftControlToLeftForm = lpRect.Left * Screen.TwipsPerPixelX
End Function

Private Function TopControlToTopForm(ByVal lhwnd As Long, ByVal lHeight As Long) As Long
    Dim lpRect As RECT
    Dim iRet As Long
    
    iRet = GetWindowRect(lhwnd, lpRect)
    
    TopControlToTopForm = 0
    
    ' Hubo un error devuelvo cero
    If iRet = 0 Then Exit Function
    
    TopControlToTopForm = lpRect.Top * Screen.TwipsPerPixelY + lHeight
End Function

Private Sub DrawSelectionBox(ByVal bStatus As STATUS_BUTTON)
    Dim clrTopLeft      As Long
    Dim clrBottomRight  As Long

    PicBoton.Cls
    m_status = bStatus

    'Set highlight and shadow colors
    Select Case bStatus
    
        Case PRESSED
            clrTopLeft = vbButtonShadow
            clrBottomRight = vb3DHighlight
        Case UNPRESSED
            clrTopLeft = m_BorderColor
            clrBottomRight = m_BorderColor
        Case MOUSE_MOVE
            clrTopLeft = vb3DHighlight
            clrBottomRight = vbButtonShadow
    End Select
    
    'Draw box around date
    PicBoton.Line (0, PicBoton.ScaleHeight - 15)-Step(0, -PicBoton.ScaleHeight + 15), clrTopLeft
    PicBoton.Line -Step(C_BotonWidth - 15, 0), clrTopLeft
    PicBoton.Line -Step(0, PicBoton.ScaleHeight - 15), clrBottomRight
    PicBoton.Line -Step(-C_BotonWidth + 15, 0), clrBottomRight
    SetCaptionButton
End Sub

Private Sub DrawBorder()
    Dim clrTopLeft      As Long
    Dim clrBottomRight  As Long

    clrTopLeft = m_BorderColor
    clrBottomRight = m_BorderColor
    
    If m_BorderType = cNone Then
        UserControl.Cls
    Else
        UserControl.Line (0, ScaleHeight - 15)-Step(0, -ScaleHeight + 15), clrTopLeft
        UserControl.Line -Step(ScaleWidth - 15, 0 + 0), clrTopLeft
        UserControl.Line -Step(0 + 0, ScaleHeight - 15), clrBottomRight
        UserControl.Line -Step(-ScaleWidth + 15, 0), clrBottomRight
    End If
End Sub

Private Sub Wait(ByVal t As Single)
    Dim init As Single
    
    init = Timer
    Do While Timer - init < t
    Loop
End Sub

Private Sub SetCaptionButton()
    PicBoton.CurrentX = (C_BotonWidth - PicBoton.TextWidth("...")) / 2 + 5
    PicBoton.CurrentY = (ScaleHeight - PicBoton.TextHeight("...")) / 2 - 5
    PicBoton.Print "..."
End Sub

