VERSION 5.00
Begin VB.UserControl cTextBox 
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   4545
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   5055
   KeyPreview      =   -1  'True
   ScaleHeight     =   4545
   ScaleWidth      =   5055
   Begin VB.PictureBox BBuffer 
      Appearance      =   0  'Flat
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      FillColor       =   &H00400000&
      FillStyle       =   0  'Solid
      ForeColor       =   &H00800000&
      Height          =   2175
      Left            =   1080
      ScaleHeight     =   145
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   145
      TabIndex        =   4
      TabStop         =   0   'False
      Top             =   1320
      Visible         =   0   'False
      Width           =   2175
   End
   Begin VB.HScrollBar HScroll1 
      Height          =   210
      Left            =   0
      Max             =   255
      TabIndex        =   2
      TabStop         =   0   'False
      Top             =   4245
      Width           =   4750
   End
   Begin VB.VScrollBar VScroll1 
      Height          =   4250
      Left            =   4845
      Max             =   20
      Min             =   1
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   0
      Value           =   1
      Width           =   210
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   400
      Left            =   960
      Top             =   360
   End
   Begin VB.PictureBox Canvas 
      Appearance      =   0  'Flat
      BackColor       =   &H00808080&
      BorderStyle     =   0  'None
      FillColor       =   &H00400000&
      FillStyle       =   0  'Solid
      BeginProperty Font 
         Name            =   "Fixedsys"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H0080FFFF&
      Height          =   4140
      Left            =   0
      MousePointer    =   3  'I-Beam
      ScaleHeight     =   276
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   301
      TabIndex        =   0
      TabStop         =   0   'False
      Top             =   0
      Width           =   4515
   End
   Begin VB.PictureBox Filler 
      Appearance      =   0  'Flat
      BackColor       =   &H00C0C0C0&
      BorderStyle     =   0  'None
      ForeColor       =   &H80000008&
      Height          =   375
      Left            =   4680
      ScaleHeight     =   375
      ScaleWidth      =   375
      TabIndex        =   3
      Top             =   4080
      Width           =   375
   End
End
Attribute VB_Name = "cTextBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' csTextBox
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    Private Declare Function TextOut Lib "gdi32" Alias "TextOutA" (ByVal hdc As Long, ByVal X As Long, ByVal y As Long, ByVal lpString As String, ByVal nCount As Long) As Long
    Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long
    Private Declare Function MoveToEx Lib "gdi32" (ByVal hdc As Long, ByVal X As Long, ByVal y As Long, lpPoint As POINTAPI) As Long
    Private Declare Function SetTextColor Lib "gdi32" (ByVal hdc As Long, ByVal crColor As Long) As Long
    Private Declare Function FillRect Lib "user32" (ByVal hdc As Long, lpRect As RECT, ByVal hBrush As Long) As Long
    Private Declare Function TabbedTextOut Lib "user32" Alias "TabbedTextOutA" (ByVal hdc As Long, ByVal X As Long, ByVal y As Long, ByVal lpString As String, ByVal nCount As Long, ByVal nTabPositions As Long, lpnTabStopPositions As Long, ByVal nTabOrigin As Long) As Long
    Private Declare Function GetTabbedTextExtent Lib "user32" Alias "GetTabbedTextExtentA" (ByVal hdc As Long, ByVal lpString As String, ByVal nCount As Long, ByVal nTabPositions As Long, lpnTabStopPositions As Long) As Long
    Private Declare Function SetTextAlign Lib "gdi32" (ByVal hdc As Long, ByVal wFlags As Long) As Long
    Private Declare Function GetCurrentPositionEx Lib "gdi32" (ByVal hdc As Long, lpPoint As POINTAPI) As Long
    
    Private Const TA_UPDATECP = 1
    Private Const TabSize = 30
    Private Type RECT
       Left As Long
       Top As Long
       Right As Long
       Bottom As Long
    End Type
    Dim WithEvents line As TextLine
Attribute line.VB_VarHelpID = -1
    Private Type POINTAPI
       X As Long
       y As Long
    End Type
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "csTextBox"
' estructuras
' variables privadas
Private Content As Collection
Private CarretX As Long
Private CarretY As Long
Private FirstVis As Long
Private LastVis As Long
Private LastPossibleY As Long
Private LastPossibleX As Long
Private CarretMode As Long
Private Sellstartx As Long
Private Sellstarty As Long
Private Sellendx As Long
Private Sellendy As Long

' eventos
Public Event Word(Word As TextWord, NewLine As Boolean)
Public Event MoveCarret()
Public Event Draw(Canvas As Object, Word As TextWord, X As Long, y As Long)
' propiedades publicas
Public Property Get BackColor() As Long
  BackColor = BBuffer.BackColor
End Property

Public Property Let BackColor(ByVal rhs As Long)
  BBuffer.BackColor = rhs
End Property

Public Property Get Text() As String
  Dim s As String
  Dim i As Integer
  
  For i = 1 To Content.Count
    s = s & Content(i) & vbCrLf
  Next
  
  Text = s
End Property
' propiedades privadas
' funciones publicas
Public Property Get CarretPixelX() As Long
   CarretPixelX = (CarretX - HScroll1.Value) * 8
End Property

Public Property Get CarretPixelY() As Long
   CarretPixelY = (CarretY - VScroll1.Value) * 16
End Property

Public Property Let SelText(Text As String)
  On Error Resume Next
  UserControl.SetFocus
  SendKeys Text
End Property

Public Sub AddLines(Text As String)
   Dim rows() As String
   Dim id As Long
   Dim data As String
   Dim i As Long
   data = Text
   data = Replace(data, Chr(10), "")
   rows = Split(data, Chr(13))
   For i = 0 To UBound(rows)
      Set line = New TextLine
      line.Text = rows(i)
      Content.Add line
      If (i / 30) And 1 Then DoEvents
   Next
   SetScroll
   Render
End Sub

Public Function InserText(ByVal sText As String)
  Dim orgstr As String
  Dim Word As String
  
  If sText = "" Then Exit Function
  
  orgstr = Content(CarretY)
  Insert orgstr, sText, CarretX
  
  CarretX = CarretX + 1
  Set line = Content(CarretY)
  line.Text = orgstr
  RenderLine
  CarretX = CarretX + Len(sText) - 1
End Function

Public Sub Clear()
   Set line = New TextLine
   Set Content = New Collection
   Content.Add line
   SetScroll
   Canvas_MouseDown 1, 0, 0, 0
   Render
End Sub

Public Sub Load(File As String)
   Dim rows() As String
   Dim id As Long
   Dim data As String
   Dim i As Long
   id = FreeFile
   Open File For Input As id
      data = Input(LOF(id), id)
   Close id
   data = Replace(data, Chr(10), "")
   rows = Split(data, Chr(13))
   For i = 0 To UBound(rows)
      Set line = New TextLine
      line.Text = rows(i)
      Content.Add line
   Next
   SetScroll
   Render
End Sub

' funciones friend
' funciones privadas
Private Sub Canvas_GotFocus()
   UserControl.SetFocus
End Sub

Private Sub Canvas_MouseDown(Button As Integer, Shift As Integer, X As Single, y As Single)
   Dim i As Long
   Dim str As String
   Dim tstr As String
   Dim s As Long
   CarretY = Int(y / 16) + VScroll1.Value
   If CarretY > Content.Count Then CarretY = Content.Count
   If CarretY > LastPossibleY Then CarretY = LastPossibleY
   X = X + (8 * HScroll1.Value)
   str = Content(CarretY).Text
   CarretX = Len(str)
   For i = 0 To Len(str)
      tstr = Left(str, i)
      s = GetTabbedTextExtent(BBuffer.hdc, tstr, Len(tstr), 1, TabSize) And 65535
      If s > X Then
         CarretX = i - 1
         Exit For
      End If
   Next
   Sellstartx = CarretX
   Sellstarty = CarretY
   Sellendx = CarretX
   Sellendy = CarretY
   Render
   RaiseEvent MoveCarret
End Sub

Private Sub Canvas_Paint()
   BitBlt Canvas.hdc, 0, 0, Canvas.ScaleWidth, Canvas.ScaleHeight, BBuffer.hdc, 0, 0, vbSrcCopy
End Sub

Private Sub HScroll1_Change()
   Render
End Sub
Private Sub HScroll1_Scroll()
   Render
End Sub

Private Sub Line_Word(Word As TextWord, NewLine As Boolean)
   RaiseEvent Word(Word, NewLine)
End Sub

Private Sub Timer1_Timer()
   RenderCarret
End Sub

Private Sub UserControl_EnterFocus()
   Timer1.Enabled = True
End Sub

Private Sub UserControl_ExitFocus()
   Timer1.Enabled = False
End Sub

Private Sub UserControl_Initialize()
   Set Content = New Collection
   Dim tmp As New TextLine
   Content.Add tmp
   CarretX = 0
   CarretY = 1
   SetScroll
   Render
End Sub

Private Sub UserControl_KeyDown(KeyCode As Integer, Shift As Integer)
   On Error Resume Next
   
   Dim orgstr As String
   orgstr = Content(CarretY)
   Select Case KeyCode
      Case vbKeyDown
         CarretY = CarretY + 1
         If CarretY > Content.Count Then CarretY = Content.Count
         If CarretY > LastPossibleY Then VScroll1.Value = VScroll1.Value + 1
         If CarretX > Len(Content(CarretY)) Then CarretX = Len(Content(CarretY))
         RenderCarret
         RaiseEvent MoveCarret
      Case vbKeyUp
         CarretY = CarretY - 1
         If CarretY < 1 Then CarretY = 1
         If CarretY < FirstVis Then VScroll1.Value = VScroll1.Value - 1
         If CarretX > Len(Content(CarretY)) Then CarretX = Len(Content(CarretY))
         RenderCarret
         RaiseEvent MoveCarret
      Case vbKeyRight
         CarretX = CarretX + 1
         If CarretX > Len(Content(CarretY)) Then CarretX = 0: UserControl_KeyDown vbKeyDown, 0
         RenderCarret
         RaiseEvent MoveCarret
      Case vbKeyLeft
         CarretX = CarretX - 1
         If CarretX < 0 And CarretY > 1 Then
            UserControl_KeyDown vbKeyUp, 0
            CarretX = Len(Content(CarretY))
         ElseIf CarretX < 0 Then
            CarretX = 0
         End If
         RenderCarret
         RaiseEvent MoveCarret
      Case vbKeyEnd
         CarretX = Len(Content(CarretY))
         Render
         RaiseEvent MoveCarret
      Case vbKeyHome
         CarretX = 0
         HScroll1.Value = 0
         Render
         RaiseEvent MoveCarret
      Case vbKeyInsert
         CarretMode = 1 - CarretMode
         Render
         RaiseEvent MoveCarret
      Case vbKeyDelete
         If CarretX < Len(orgstr) Then
            DelChar orgstr, CarretX + 1
            Set line = Content(CarretY)
            line.Text = orgstr
            Render
            RaiseEvent MoveCarret
         ElseIf CarretY < Content.Count Then
            orgstr = orgstr + Content(CarretY + 1)
            Content.Remove (CarretY + 1)
            Set line = Content(CarretY)
            line.Text = orgstr
            Render
            RaiseEvent MoveCarret
         End If
   End Select

  On Error Resume Next
  Filler.SetFocus

End Sub

Private Sub UserControl_KeyPress(KeyAscii As Integer)
   On Error Resume Next
   Dim orgstr As String
   Dim Word As String
   orgstr = Content(CarretY)
   Select Case KeyAscii
      Case 8
         If CarretX = 0 And CarretY > 1 Then
            Content.Remove CarretY
            UserControl_KeyDown vbKeyUp, 0
            UserControl_KeyDown vbKeyEnd, 0
            Set line = Content(CarretY)
            line.Text = line.Text + orgstr
            Word = Left(orgstr, CarretX)
            Word = Mid(Word, InStrRev(Word, " "))
            'RaiseEvent Word(Word)
            SetScroll
            Render
         Else
            DelChar orgstr, CarretX
            Set line = Content(CarretY)
            line.Text = orgstr
            UserControl_KeyDown vbKeyLeft, 0
            RenderLine
         End If
      Case 13
         Set line = Content(CarretY)
         line.Text = Left(orgstr, CarretX)
         Set line = New TextLine
         line.Text = Mid(orgstr, CarretX + 1)
         Content.Add line, , , CarretY
         SetScroll
         CarretX = 0
         UserControl_KeyDown vbKeyDown, 0
         Render
      Case Else
         orgstr = Content(CarretY)
         Insert orgstr, Chr(KeyAscii), CarretX
         CarretX = CarretX + 1
         Set line = Content(CarretY)
         line.Text = orgstr
         RenderLine
   End Select
End Sub

Private Sub UserControl_Resize()
   On Error Resume Next
   Canvas.Width = UserControl.Width
   Canvas.Height = UserControl.Height
   VScroll1.Left = ((Canvas.ScaleWidth - 4) * Screen.TwipsPerPixelX - VScroll1.Width)
   VScroll1.Height = ((Canvas.ScaleHeight - 4) * Screen.TwipsPerPixelY - HScroll1.Height)
   HScroll1.Width = ((Canvas.ScaleWidth - 4) * Screen.TwipsPerPixelX - VScroll1.Width)
   HScroll1.Top = ((Canvas.ScaleHeight - 4) * Screen.TwipsPerPixelY - HScroll1.Height)
   Filler.Top = VScroll1.Height
   Filler.Left = HScroll1.Width
   BBuffer.Width = Canvas.Width
   BBuffer.Height = Canvas.Height
   Render
End Sub

Private Sub Render()
   Dim i As Long
   Dim j As Long
   Dim Pos As Long
   Dim pt As POINTAPI
   Dim xpos As Long
   Dim orgxPos As Long
   Dim rc As RECT
   Dim str As String
   Dim totstr As String
   BBuffer.Cls
   SetTextColor BBuffer.hdc, vbBlack
   
   ' Por cada line desde la primera visible
   For i = VScroll1.Value To Content.Count
      Set line = Content(i)
      xpos = -HScroll1.Value * 8
      orgxPos = xpos
      totstr = ""
      
      ' Por cada palabra de la linea
      For j = 1 To line.Count
         str = line.Word(j).Word
         totstr = totstr + str
         SetTextColor BBuffer.hdc, line.Word(j).Color
         TabbedTextOut BBuffer.hdc, xpos, Pos, str, Len(str), 1, TabSize, orgxPos
         If line.Word(j).KeyWord = True Then
            RaiseEvent Draw(BBuffer, line.Word(j), xpos, Pos)
         End If
         xpos = (GetTabbedTextExtent(BBuffer.hdc, totstr, Len(totstr), 1, TabSize) And 65535) - HScroll1.Value * 8
         If xpos > BBuffer.ScaleWidth Then Exit For
      Next
      '    SetTextColor BBuffer.hdc, vbWhite
      '    str = line.Text
      '    xpos = -HScroll1.Value * 8
      '    TabbedTextOut BBuffer.hdc, xpos, Pos, str, Len(str), 1, TabSize, xpos
      Pos = Pos + 16
      If Pos > BBuffer.ScaleHeight - (HScroll1.Height / Screen.TwipsPerPixelY) Then Exit For
   Next
   FirstVis = VScroll1.Value
   LastVis = i - 1
   LastPossibleY = Int((BBuffer.ScaleHeight - (HScroll1.Height / Screen.TwipsPerPixelY)) / 16) + VScroll1.Value - 1
   RenderCarret
End Sub

Private Sub RenderCarret()
   Dim xpos As Long
   Dim str As String
   Static Draw As Boolean
   Draw = Not Draw
   str = Content(CarretY).Text
   If CarretX < 0 Then CarretX = 0
   xpos = GetTabbedTextExtent(BBuffer.hdc, Left(str, CarretX), Len(Left(str, CarretX)), 1, TabSize)
   xpos = xpos - (HScroll1.Value * 8)
   xpos = xpos And 65535
   BitBlt Canvas.hdc, 0, 0, Canvas.ScaleWidth, Canvas.ScaleHeight, BBuffer.hdc, 0, 0, vbSrcCopy
   RenderSelection
   If Sellstartx <> Sellendx Then Exit Sub
   Canvas.CurrentX = xpos
   Canvas.CurrentY = (CarretY - VScroll1.Value) * 16
   Canvas.ForeColor = vbBlack
   If Draw = True Then
      If CarretMode = 1 Then
         Canvas.Line -(Canvas.CurrentX + 7, Canvas.CurrentY + 13), , B
      Else
         Canvas.Line -(Canvas.CurrentX, Canvas.CurrentY + 13)
      End If
   End If
End Sub

Private Sub UserControl_Show()
   Render
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
  PropBag.WriteProperty "BackColor", BBuffer.BackColor, vbWhite
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
  BBuffer.BackColor = PropBag.ReadProperty("BackColor", vbWhite)
End Sub

Private Sub VScroll1_Change()
   Static oldVal As Long
   If VScroll1.Value = oldVal + 1 Then
      ScrollUp
   ElseIf VScroll1.Value = oldVal - 1 Then
      ScrollDown
   Else
      Render
   End If
   oldVal = VScroll1.Value
End Sub

Private Sub VScroll1_Scroll()
   Render
End Sub

Private Sub Insert(ByRef orgstr As String, NewStr As String, Pos As Long)
   On Error Resume Next
   Dim lstr As String
   Dim rstr As String
   lstr = Left(orgstr, Pos)
   rstr = Mid(orgstr, Pos + 1)
   orgstr = lstr + NewStr + rstr
End Sub

Private Sub DelChar(ByRef orgstr As String, Pos As Long)
   On Error Resume Next
   Dim lstr As String
   Dim rstr As String
   lstr = Left(orgstr, Pos - 1)
   rstr = Mid(orgstr, Pos + 1)
   orgstr = lstr + rstr
End Sub

Private Sub SetScroll()
   If VScroll1.Value > Content.Count Then VScroll1.Value = Content.Count: CarretY = VScroll1.Value
   VScroll1.Max = Content.Count
End Sub

Private Sub RenderSelection()
   If Sellendx = Sellstartx Then Exit Sub
   Canvas.CurrentX = (Sellstartx - HScroll1.Value) * 8
   Canvas.CurrentY = (Sellstarty - VScroll1.Value) * 16
   Canvas.ForeColor = RGB(0, 0, 255)
   Canvas.FillColor = RGB(0, 0, 255)
   Canvas.DrawMode = vbMergePen
   Canvas.Line -((Sellendx - HScroll1.Value) * 8, (Sellendy + 1 - VScroll1.Value) * 16), , B
   Canvas.DrawMode = vbCopyPen
End Sub

Private Sub ScrollUp()
   Dim y As Long
   BitBlt BBuffer.hdc, 0, 0, BBuffer.ScaleWidth, BBuffer.ScaleHeight, BBuffer.hdc, 0, 16, vbSrcCopy
   y = LastPossibleY + 1
   RenderLine y
End Sub

Private Sub ScrollDown()
   Dim y As Long
   BitBlt BBuffer.hdc, 0, 16, BBuffer.ScaleWidth, BBuffer.ScaleHeight, BBuffer.hdc, 0, 0, vbSrcCopy
   y = FirstVis - 1
   RenderLine y
End Sub

Private Sub RenderLine(Optional lineID As Long)
   Dim i As Long
   Dim j As Long
   Dim Pos As Long
   Dim line As String
   Dim tmp As TextLine
   Dim pt As POINTAPI
   Dim xpos As Long
   Dim orgxPos As Long
   Dim rc As RECT
   Dim str As String
   Dim totstr As String
   SetTextColor BBuffer.hdc, vbBlack
   If lineID = 0 Then lineID = CarretY
   i = lineID
   Pos = (i - VScroll1.Value) * 16
   BBuffer.ForeColor = BBuffer.BackColor
   BBuffer.FillColor = BBuffer.BackColor
   BBuffer.Line (0, Pos)-(BBuffer.ScaleWidth, Pos + 15), , B
   
   If i <= Content.Count Then

   
   
   Set tmp = Content(i)
   xpos = -HScroll1.Value * 8
   orgxPos = xpos
   totstr = ""
   For j = 1 To tmp.Count
      str = tmp.Word(j).Word
      totstr = totstr + str
      SetTextColor BBuffer.hdc, tmp.Word(j).Color
      TabbedTextOut BBuffer.hdc, xpos, Pos, str, Len(str), 1, TabSize, orgxPos
      If tmp.Word(j).KeyWord = True Then
         RaiseEvent Draw(BBuffer, tmp.Word(j), xpos, Pos)
      End If
      xpos = (GetTabbedTextExtent(BBuffer.hdc, totstr, Len(totstr), 1, TabSize) And 65535) - HScroll1.Value * 8
      If xpos > BBuffer.ScaleWidth Then Exit For
   Next
End If
   FirstVis = VScroll1.Value
   LastVis = i - 1
   LastPossibleY = Int((BBuffer.ScaleHeight - (HScroll1.Height / Screen.TwipsPerPixelY)) / 16) + VScroll1.Value - 1
   RenderCarret
End Sub
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next
 
