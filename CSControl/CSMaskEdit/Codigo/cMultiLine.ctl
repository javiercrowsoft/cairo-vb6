VERSION 5.00
Begin VB.UserControl cMultiLine 
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   ScaleHeight     =   3600
   ScaleWidth      =   4800
   Begin VB.TextBox txMultiLine 
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   360
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   840
      Width           =   1680
   End
End
Attribute VB_Name = "cMultiLine"
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

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cMaskEdit"

' estructuras
' variables privadas
Private m_BorderType      As csBorderType
Private m_BorderColor     As Long
Private m_InputDisabled   As Boolean
Private m_bCtrlPressed    As Boolean

'Property Variables:
Private m_NoSel        As Boolean

Private m_EnabledNoChngBkColor  As Boolean

' Eventos
Public Event Change()
Public Event KeyPress(KeyAscii As Integer)
Public Event KeyDown(KeyCode As Integer, Shift As Integer)
Public Event KeyUp(KeyCode As Integer, Shift As Integer)

' propiedades publicas
Public Property Get InputDisabled() As Boolean
  InputDisabled = m_InputDisabled
End Property

Public Property Let InputDisabled(ByVal rhs As Boolean)
  m_InputDisabled = rhs
End Property

Public Sub SetText(ByVal Value As String)
  txMultiLine.Text = Value
End Sub

Public Property Get Text() As String
  Text = txMultiLine.Text
End Property

Public Property Let Text(ByVal rhs As String)
  txMultiLine.Text = rhs
End Property

Public Property Get Alignment() As AlignmentConstants
  Alignment = txMultiLine.Alignment
End Property

Public Property Let Alignment(ByVal rhs As AlignmentConstants)
  txMultiLine.Alignment = rhs
End Property

Public Property Get BackColor() As OLE_COLOR
  BackColor = txMultiLine.BackColor
End Property

Public Property Let BackColor(ByVal rhs As OLE_COLOR)
  txMultiLine.BackColor = rhs
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
  Set txMultiLine.Font = rhs
End Property

Public Property Get FontBold() As Boolean
  FontBold = txMultiLine.FontBold
End Property

Public Property Let FontBold(ByVal rhs As Boolean)
  txMultiLine.FontBold = rhs
End Property

Public Property Get FontItalic() As Boolean
  FontItalic = txMultiLine.FontItalic
End Property

Public Property Let FontItalic(ByVal rhs As Boolean)
  txMultiLine.FontItalic = rhs
End Property

Public Property Get FontName() As String
  FontName = txMultiLine.FontName
End Property

Public Property Let FontName(ByVal rhs As String)
  txMultiLine.FontName = rhs
End Property

Public Property Get FontSize() As Single
  FontSize = txMultiLine.FontSize
End Property

Public Property Let FontSize(ByVal rhs As Single)
  txMultiLine.FontSize = rhs
End Property

Public Property Get FontStrikethru() As Boolean
  FontStrikethru = txMultiLine.FontStrikethru
End Property

Public Property Let FontStrikethru(ByVal rhs As Boolean)
  txMultiLine.FontStrikethru = rhs
End Property

Public Property Get FontUnderline() As Boolean
  FontUnderline = txMultiLine.FontUnderline
End Property

Public Property Let FontUnderline(ByVal rhs As Boolean)
  txMultiLine.FontUnderline = rhs
End Property

Public Property Get ForeColor() As OLE_COLOR
  ForeColor = txMultiLine.ForeColor
End Property

Public Property Let ForeColor(ByVal rhs As OLE_COLOR)
  txMultiLine.ForeColor = rhs
End Property

Public Property Get BorderColor() As OLE_COLOR
  BorderColor = m_BorderColor
End Property

Public Property Let BorderColor(ByVal rhs As OLE_COLOR)
  m_BorderColor = rhs
  pDrawBorder
End Property

Public Property Get BorderType() As csBorderType
  BorderType = m_BorderType
End Property

Public Property Let BorderType(ByVal rhs As csBorderType)
  m_BorderType = rhs
  UserControl_Paint
End Property

Public Property Get MaxLength() As Integer
  MaxLength = txMultiLine.MaxLength
End Property

Public Property Let MaxLength(ByVal rhs As Integer)
  txMultiLine.MaxLength = rhs
End Property

Public Property Get SelStart() As Integer
  SelStart = txMultiLine.SelStart
End Property

Public Property Let SelStart(ByVal position As Integer)
  txMultiLine.SelStart = position
End Property

Public Property Get SelLength() As Integer
  SelLength = txMultiLine.SelLength
End Property

Public Property Let SelLength(ByVal rhs As Integer)
  txMultiLine.SelLength = rhs
End Property

' funciones publicas

Public Sub Edit()
  txMultiLine_GotFocus
End Sub

Private Sub txMultiLine_KeyPress(KeyAscii As Integer)
  On Error Resume Next
  
  '////////////////////////////////////////
  ' Para evitar el ctrl-v cuando InputDisabled = True
  '
  If m_InputDisabled Then
    If Not (m_bCtrlPressed And KeyAscii = 3) Then
      KeyAscii = 0
    End If
  End If
End Sub

' funciones privadas

'//////////////////////////////////////////////////////////////////
' carga
Private Sub UserControl_Initialize()
  On Error Resume Next
  VerInitialise
  txMultiLine.BorderStyle = 0
  Me.BorderType = cSingle
  With UserControl
    .Width = 2000
    .Height = 315
  End With
End Sub

Private Sub UserControl_Resize()
  On Error Resume Next
  Dim InternalFrame As Single
  
  If m_BorderType = cNone Then
    InternalFrame = 0
  Else
    InternalFrame = 15
  End If
  
  txMultiLine.Move InternalFrame, InternalFrame, _
                    ScaleWidth - InternalFrame * 2, _
                    ScaleHeight - InternalFrame * 2
End Sub

Private Sub UserControl_InitProperties()
  On Error Resume Next
  txMultiLine.Text = ""
  BorderColor = vbButtonShadow
  BackColor = vbWindowBackground
  m_BorderType = cNone
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
  On Error Resume Next
    
  PropBag.WriteProperty "Text", txMultiLine.Text, ""
  PropBag.WriteProperty "Alignment", txMultiLine.Alignment, 0
  PropBag.WriteProperty "BackColor", txMultiLine.BackColor, &H80000005
  PropBag.WriteProperty "Font", txMultiLine.Font, Ambient.Font
  PropBag.WriteProperty "FontBold", txMultiLine.FontBold, 0
  PropBag.WriteProperty "FontItalic", txMultiLine.FontItalic, 0
  PropBag.WriteProperty "FontName", txMultiLine.FontName, ""
  PropBag.WriteProperty "FontSize", txMultiLine.FontSize, 0
  PropBag.WriteProperty "FontStrikethru", txMultiLine.FontStrikethru, 0
  PropBag.WriteProperty "FontUnderline", txMultiLine.FontUnderline, 0
  PropBag.WriteProperty "ForeColor", txMultiLine.ForeColor, &H80000008
  PropBag.WriteProperty "MaxLength", txMultiLine.MaxLength, 0
  PropBag.WriteProperty "MultiLine", txMultiLine.MultiLine, False
  
  PropBag.WriteProperty "Enabled", UserControl.Enabled, True
  PropBag.WriteProperty "EnabledNoChngBkColor", m_EnabledNoChngBkColor, True
  PropBag.WriteProperty "Text", Text, Extender.Name
  PropBag.WriteProperty "BorderColor", m_BorderColor, vbButtonShadow
  PropBag.WriteProperty "BorderType", m_BorderType, cNone
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
  ForeColor = PropBag.ReadProperty("ForeColor", &H80000008)
  MaxLength = PropBag.ReadProperty("MaxLength", 0)
  BorderColor = PropBag.ReadProperty("BorderColor", vbButtonShadow)
  
  If IsXp Then
    BorderColor = &HB99D7F
  End If
  
  BorderType = PropBag.ReadProperty("BorderType", cNone)
  EnabledNoChngBkColor = PropBag.ReadProperty("EnabledNoChngBkColor", False)
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

Private Sub pDrawBorder()
  If m_BorderType = cNone Then
    UserControl.BackColor = txMultiLine.BackColor
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

'-----------------------------------------------
Private Sub pTxGotFocus()
  If txMultiLine.Text = "" Then Exit Sub
  
  txMultiLine.SelStart = Len(txMultiLine.Text)
  If m_NoSel Then
    m_NoSel = False
  Else
    txMultiLine.SelStart = 0
    txMultiLine.SelLength = Len(txMultiLine.Text)
  End If
End Sub

'-----------------------------------------------
Private Sub txMultiLine_Change()
  On Error Resume Next
  RaiseEvent Change
End Sub

Private Sub txMultiLine_KeyDown(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  
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

Private Sub txMultiLine_KeyUp(KeyCode As Integer, Shift As Integer)
  On Error Resume Next
  RaiseEvent KeyUp(KeyCode, Shift)
End Sub

Private Sub txMultiLine_GotFocus()
  On Error Resume Next
  pTxGotFocus
End Sub
