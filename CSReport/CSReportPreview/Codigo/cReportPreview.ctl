VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.UserControl cReportPreview 
   BackColor       =   &H80000010&
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   10170
   ScaleHeight     =   3600
   ScaleWidth      =   10170
   ToolboxBitmap   =   "cReportPreview.ctx":0000
   Begin MSComctlLib.ImageList ImgToolbar3 
      Left            =   5700
      Top             =   2460
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   32
      ImageHeight     =   32
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   9
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":0312
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":0BEC
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":14C6
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":1DA0
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":267A
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":3354
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":3C2E
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":4508
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":4DE2
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox picTop 
      BackColor       =   &H80000010&
      BorderStyle     =   0  'None
      Height          =   915
      Left            =   4980
      ScaleHeight     =   915
      ScaleWidth      =   960
      TabIndex        =   5
      Top             =   540
      Width           =   960
   End
   Begin VB.PictureBox PicRule 
      BorderStyle     =   0  'None
      Height          =   3195
      Left            =   90
      ScaleHeight     =   3195
      ScaleWidth      =   960
      TabIndex        =   4
      Top             =   450
      Width           =   960
      Begin VB.Line Line1 
         BorderColor     =   &H80000010&
         BorderWidth     =   10
         X1              =   360
         X2              =   360
         Y1              =   45
         Y2              =   2610
      End
   End
   Begin VB.PictureBox PicRightCorner 
      BackColor       =   &H80000010&
      BorderStyle     =   0  'None
      Height          =   285
      Left            =   3915
      ScaleHeight     =   285
      ScaleWidth      =   240
      TabIndex        =   0
      Top             =   3105
      Width           =   240
   End
   Begin VB.HScrollBar ScrHorizontal 
      Height          =   255
      Left            =   2835
      TabIndex        =   1
      TabStop         =   0   'False
      Top             =   2475
      Width           =   1005
   End
   Begin VB.VScrollBar ScrVertical 
      Height          =   780
      Left            =   1980
      Max             =   5
      TabIndex        =   2
      TabStop         =   0   'False
      Top             =   1440
      Width           =   255
   End
   Begin MSComctlLib.ImageList ImgToolbar 
      Left            =   2790
      Top             =   1170
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   24
      ImageHeight     =   24
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   9
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":5ABC
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":6236
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":69B0
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":712A
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":78A4
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":801E
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":8718
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":8E12
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "cReportPreview.ctx":950C
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox PicBody 
      BackColor       =   &H00FFFFFF&
      BorderStyle     =   0  'None
      Height          =   3195
      Left            =   1440
      ScaleHeight     =   3195
      ScaleWidth      =   1185
      TabIndex        =   3
      Top             =   585
      Width           =   1185
   End
   Begin MSComDlg.CommonDialog comdDialog 
      Left            =   3510
      Top             =   1035
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComctlLib.Toolbar TbPrint 
      Align           =   1  'Align Top
      Height          =   480
      Left            =   0
      TabIndex        =   6
      Top             =   0
      Width           =   10170
      _ExtentX        =   17939
      _ExtentY        =   847
      ButtonWidth     =   820
      ButtonHeight    =   794
      Appearance      =   1
      Style           =   1
      ImageList       =   "ImgToolbar"
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   17
         BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "MOVE_FIRST"
            Object.ToolTipText     =   "Ir al primero"
            ImageIndex      =   1
         EndProperty
         BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "MOVE_PREVIOUS"
            Object.ToolTipText     =   "Ir al anterior"
            ImageIndex      =   2
         EndProperty
         BeginProperty Button3 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   4
         EndProperty
         BeginProperty Button4 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Enabled         =   0   'False
            Key             =   "PAGE_NUMBER"
            Object.ToolTipText     =   "Número de página"
            Style           =   4
            Object.Width           =   2000
         EndProperty
         BeginProperty Button5 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   4
         EndProperty
         BeginProperty Button6 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "MOVE_NEXT"
            Object.ToolTipText     =   "Ir al siguiente"
            ImageIndex      =   3
         EndProperty
         BeginProperty Button7 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "MOVE_LAST"
            Object.ToolTipText     =   "Ir al ultimo"
            ImageIndex      =   4
         EndProperty
         BeginProperty Button8 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button9 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "PRINT"
            Object.ToolTipText     =   "Imprimir"
            ImageIndex      =   5
         EndProperty
         BeginProperty Button10 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button11 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "PDF"
            Object.ToolTipText     =   "Exportar a PDF"
            ImageIndex      =   8
         EndProperty
         BeginProperty Button12 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "WORD"
            Object.ToolTipText     =   "Exportar a Word"
            ImageIndex      =   6
         EndProperty
         BeginProperty Button13 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "EXCEL"
            Object.ToolTipText     =   "Exportar a Excel"
            ImageIndex      =   7
         EndProperty
         BeginProperty Button14 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button15 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "SEARCH"
            Object.ToolTipText     =   "Buscar"
            ImageIndex      =   9
         EndProperty
         BeginProperty Button16 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Style           =   3
         EndProperty
         BeginProperty Button17 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "ZOOM"
            Object.ToolTipText     =   "Zoom"
            Style           =   4
            Object.Width           =   5000
         EndProperty
      EndProperty
      BorderStyle     =   1
      Begin VB.TextBox TxPageNumber 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000014&
         Height          =   345
         Left            =   1200
         TabIndex        =   9
         Top             =   60
         Width           =   660
      End
      Begin VB.TextBox TxPages 
         Alignment       =   1  'Right Justify
         BackColor       =   &H80000010&
         Enabled         =   0   'False
         Height          =   345
         Left            =   2220
         TabIndex        =   8
         Top             =   60
         Width           =   660
      End
      Begin VB.ComboBox cbZoom 
         Appearance      =   0  'Flat
         Height          =   315
         Left            =   7200
         Style           =   2  'Dropdown List
         TabIndex        =   7
         Top             =   60
         Width           =   1680
      End
   End
End
Attribute VB_Name = "cReportPreview"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cReportPreview
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cReportPreview"
Private Const C_Min_Height_Section = 280
Private Const C_Height_Bar_Section = 100
Private Const C_Control_Name = "Control"
' estructuras
' variables privadas
Private C_TopBody           As Single
Private C_LeftBody          As Single
Private m_offX              As Single
Private m_offY              As Single
Private m_KeyFocus          As String
Private m_NameRpt           As String

Private m_Pages                         As Integer
Private m_CurrPage                      As Integer

Private m_OnlyShowPage                  As Boolean

' Nombres
Private m_NextNameCtrl As Integer

' eventos
Public Event SaveDocument()
Public Event BodyMouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event BodyPaint()
Public Event DoPrint()

Public Event MoveLast()
Public Event MoveNext()
Public Event MovePrevious()
Public Event MoveFirst()
Public Event MoveToPage(ByVal Page As Integer)
Public Event BodyMouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)

Public Event BodyDblClick()
Public Event ChangeZoom(ByVal Zoom As Long)

Public Event ExportWord()
Public Event ExportExcel()
Public Event ExportPDF()
Public Event Search()

Public Enum csEZoom
  csEZoomCustom = -1
  csEZoomAllPage = -2
  csEZoomWidth = -3
End Enum

' propiedades publicas

Public Property Get OnlyShowPage() As Boolean
   OnlyShowPage = m_OnlyShowPage
End Property

Public Property Let OnlyShowPage(ByVal rhs As Boolean)
   m_OnlyShowPage = rhs
   pSetVisibleControls
End Property

Public Property Get CommDialog() As Object
  Set CommDialog = comdDialog
End Property

Public Property Get Body() As Object
  Set Body = PicBody
End Property

Public Property Get Pages() As Integer
   Pages = m_Pages
End Property

Public Property Let Pages(ByVal rhs As Integer)
   m_Pages = rhs
   TxPages.Text = rhs
End Property

Public Property Get CurrPage() As Integer
   CurrPage = m_CurrPage
End Property

Public Property Let CurrPage(ByVal rhs As Integer)
  TxPageNumber.Text = rhs
  m_CurrPage = rhs
End Property

Public Property Get MousePointer() As Long
   MousePointer = PicBody.MousePointer
End Property

Public Property Let MousePointer(ByVal rhs As Long)
   PicBody.MousePointer = rhs
End Property

Public Property Get MouseIcon() As IPictureDisp
   Set MouseIcon = PicBody.MouseIcon
End Property

Public Property Set MouseIcon(ByVal rhs As IPictureDisp)
   Set PicBody.MouseIcon = rhs
End Property

Public Property Get ScaleHeight() As Long
   ScaleHeight = UserControl.ScaleHeight - TbPrint.Height - 440
End Property

Public Property Get ScaleWidth() As Long
   ScaleWidth = UserControl.ScaleWidth - PicRule.Width - ScrVertical.Width - 200
End Property

' propiedades privadas
' funciones publicas
Public Sub Refresh()
  ' La primera vez que me llaman
  ' no refrezco por que se dispara un
  ' evento Paint automticamente por windows
  ' y si ejecuto este se produce un efecto de
  ' parpadeo
  Static bFirstCall As Boolean
  If Not bFirstCall Then
    bFirstCall = True
    Exit Sub
  End If
  PicBody_Paint
End Sub

Private Sub cbZoom_Click()
  On Error Resume Next
  RaiseEvent ChangeZoom(cbZoom.ItemData(cbZoom.ListIndex))
End Sub

Private Sub PicBody_DblClick()
  RaiseEvent BodyDblClick
End Sub

Private Sub PicBody_Resize()
  UserControl_Resize
End Sub

' funciones privadas
Private Sub TbPrint_ButtonClick(ByVal Button As MSComctlLib.Button)
  Select Case Button.Key
    Case "MOVE_LAST"
      RaiseEvent MoveLast
    Case "MOVE_NEXT"
      RaiseEvent MoveNext
    Case "MOVE_PREVIOUS"
      RaiseEvent MovePrevious
    Case "MOVE_FIRST"
      RaiseEvent MoveFirst
    Case "PRINT"
      RaiseEvent DoPrint
    Case "WORD"
      RaiseEvent ExportWord
    Case "EXCEL"
      RaiseEvent ExportExcel
    Case "PDF"
      RaiseEvent ExportPDF
    Case "SEARCH"
      RaiseEvent Search
  End Select
End Sub

Private Sub TxPageNumber_GotFocus()
  With TxPageNumber
    .SelStart = 0
    .SelLength = Len(.Text)
  End With
End Sub

Private Sub TxPageNumber_KeyPress(KeyAscii As Integer)
  ' Solo acepta numeros
  Select Case KeyAscii
    Case vbKey0, vbKey1, vbKey2, vbKey3, vbKey4, vbKey5, vbKey6, vbKey7, vbKey8, vbKey9
    Case vbKeyReturn
      Dim NumberPage As Long
      
      NumberPage = Val(TxPageNumber.Text)
      If NumberPage > m_Pages Or NumberPage < 1 Then
        TxPageNumber.Text = m_CurrPage
      Else
        RaiseEvent MoveToPage(NumberPage)
        TxPageNumber.SetFocus
      End If
    Case Else
      KeyAscii = 0
  End Select
End Sub

Private Sub pFillZoom()
  On Error Resume Next
  With cbZoom
    .Clear
    .AddItem "200%"
    .ItemData(.NewIndex) = 200
    .AddItem "150%"
    .ItemData(.NewIndex) = 150
    .AddItem "100%"
    .ItemData(.NewIndex) = 100
    .AddItem "85%"
    .ItemData(.NewIndex) = 85
    .AddItem "75%"
    .ItemData(.NewIndex) = 75
    .AddItem "60%"
    .ItemData(.NewIndex) = 60
    .AddItem "50%"
    .ItemData(.NewIndex) = 50
    .AddItem "35%"
    .ItemData(.NewIndex) = 35
    .AddItem "15%"
    .ItemData(.NewIndex) = 15
    .AddItem "Ancho%"
    .ItemData(.NewIndex) = csEZoom.csEZoomWidth
    .AddItem "Toda la pagina"
    .ItemData(.NewIndex) = csEZoom.csEZoomAllPage
    .AddItem "Personalizado"
    .ItemData(.NewIndex) = csEZoom.csEZoomCustom
    
    .ListIndex = 2
  End With
End Sub

' construccion - destruccion
Private Sub UserControl_Initialize()
#If PREPROC_DEBUG Then
  gdbInitInstance C_Module
#End If
  
  C_TopBody = TbPrint.Height + 200
  C_LeftBody = PicRule.Width
  
  PicBody.Top = C_TopBody
  PicBody.Left = C_LeftBody
  picTop.Top = TbPrint.Height
  picTop.Left = 0
  picTop.Height = C_TopBody - TbPrint.Height

  PicBody.Height = Printer.Height + C_TopBody
  PicBody.Width = Printer.Width
  
  PicRule.Height = Printer.Height + C_TopBody * 2 + ScrVertical.Height
  PicRule.Left = 0
  PicRule.Top = TbPrint.Height
  
  Line1.X1 = PicRule.ScaleWidth - 80
  Line1.X2 = PicRule.ScaleWidth - 80
  Line1.Y1 = 0
  
  PicRule.ZOrder
  TbPrint.ZOrder
  m_KeyFocus = ""
  
  pFillZoom
End Sub

#If PREPROC_DEBUG Then
Private Sub UserControl_Terminate()
  gdbTerminateInstance C_Module
End Sub
#End If

Private Sub UserControl_Resize()
  On Error Resume Next
  
  picTop.Width = UserControl.ScaleWidth
  
  If Not m_OnlyShowPage Then
  
    ' Se llaman dos veces para que se
    ' determine que hay una necesidad
    ' real de mostrar las scrolbars
    pSetScrVertical
    pSetScrHorizontal
  
    pSetScrVertical
    pSetScrHorizontal
  
  End If
  
  PicRule.Height = IIf(PicBody.Height > UserControl.ScaleHeight, PicBody.Height + 1000, UserControl.Height)

  Line1.Y2 = PicRule.ScaleHeight
  PicRightCorner.Left = UserControl.ScaleWidth - ScrVertical.Width
  PicRightCorner.Top = UserControl.ScaleHeight - ScrHorizontal.Height
End Sub

Private Sub pSetScrHorizontal()
  On Error Resume Next
  Dim bVisible As Boolean
  
  bVisible = Not m_OnlyShowPage
  
  ScrHorizontal.Left = C_LeftBody
  ScrHorizontal.Top = UserControl.ScaleHeight - ScrHorizontal.Height
  ScrHorizontal.Width = UserControl.ScaleWidth - ScrHorizontal.Left - ScrVertical.Width
  
  If UserControl.ScaleWidth > 20 Then
    If ScrVertical.Max > 0 Then
      ScrHorizontal.Max = PicBody.Width - UserControl.ScaleWidth + PicRule.Width + ScrVertical.Width + 140
    Else
      ScrHorizontal.Max = PicBody.Width - UserControl.ScaleWidth + PicRule.Width + 140
    End If
  End If

  If ScrHorizontal.Max < 0 Then
    ScrHorizontal.Max = 0
    ScrHorizontal.Visible = False
    ScrVertical.Height = UserControl.ScaleHeight - ScrVertical.Top
    PicRightCorner.Visible = False
  Else
    ScrHorizontal.Visible = bVisible
    PicRightCorner.Visible = bVisible
  End If

  ScrHorizontal.LargeChange = ScrHorizontal.Max / 2
  ScrHorizontal.SmallChange = ScrHorizontal.Max / 100
End Sub

Private Sub pSetScrVertical()
  On Error Resume Next
  Dim bVisible As Boolean
  
  bVisible = Not m_OnlyShowPage
  
  ScrVertical.Top = C_TopBody
  ScrVertical.Left = UserControl.ScaleWidth - ScrVertical.Width
  ScrVertical.Height = UserControl.ScaleHeight - ScrHorizontal.Height - ScrVertical.Top
  
  If UserControl.ScaleHeight > 20 Then
    If ScrHorizontal.Max > 0 Then
      ScrVertical.Max = PicBody.Height - UserControl.ScaleHeight + ScrHorizontal.Height + C_TopBody + 140
    Else
      ScrVertical.Max = PicBody.Height - UserControl.ScaleHeight + C_TopBody + 140
    End If
  End If

  If ScrVertical.Max < 0 Then
    ScrVertical.Max = 0
    ScrVertical.Visible = False
    ScrHorizontal.Width = UserControl.ScaleWidth - ScrHorizontal.Left
  Else
    ScrVertical.Visible = bVisible
  End If

  ScrVertical.LargeChange = ScrVertical.Max / 2
  ScrVertical.SmallChange = ScrVertical.Max / 100
End Sub

Private Sub PicBody_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
  RaiseEvent BodyMouseDown(Button, Shift, X, Y)
End Sub

Private Sub PicBody_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  RaiseEvent BodyMouseMove(Button, Shift, X, Y)
End Sub

Private Sub PicBody_Paint()
  RaiseEvent BodyPaint
End Sub

Private Sub ScrHorizontal_Change()
  On Error Resume Next
  PicBody.Left = PicRule.Width - ScrHorizontal.Value
End Sub

Private Sub ScrHorizontal_Scroll()
  On Error Resume Next
  PicBody.Left = PicRule.Width - ScrHorizontal.Value
End Sub

Private Sub ScrVertical_Change()
  On Error Resume Next
  PicBody.Top = (ScrVertical.Value * -1) + C_TopBody
  PicRule.Top = ScrVertical.Value * -1 + TbPrint.Height
End Sub

Private Sub ScrVertical_Scroll()
  On Error Resume Next
  PicBody.Top = (ScrVertical.Value * -1) + C_TopBody
  PicRule.Top = ScrVertical.Value * -1 + TbPrint.Height
End Sub

Private Sub pSetVisibleControls()
  If m_OnlyShowPage Then
    ScrVertical.Visible = False
    ScrHorizontal.Visible = False
    PicRule.Visible = False
    PicRightCorner.Visible = False
    TbPrint.Visible = False
    UserControl.BackColor = PicBody.BackColor
    picTop.Visible = False
    PicBody.Top = 100
  End If
End Sub

'----------------------------------------------------------------------------------

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

