VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportPreview"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
#Region " Windows Form Designer generated code "

  Public Sub New()
      MyBase.New()

      'This call is required by the Windows Form Designer.
      InitializeComponent()

      'Add any initialization after the InitializeComponent() call
      Form_Initialize_renamed()
  End Sub

  'UserControl1 overrides dispose to clean up the component list.
  Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
      If disposing Then
          If Not (components Is Nothing) Then
              components.Dispose()
          End If
      End If
      MyBase.Dispose (disposing)
  End Sub
Friend WithEvents imgToolBar As System.Windows.Forms.ImageList
Friend WithEvents comdDialog As System.Windows.Forms.PrintDialog
Friend WithEvents picBack As System.Windows.Forms.PictureBox
Public WithEvents PicRule As System.Windows.Forms.Panel
Attribute PicRule.VB_VarHelpID = -1
Public WithEvents Line1 As System.Windows.Forms.Label
Attribute Line1.VB_VarHelpID = -1
Public WithEvents ScrHorizontal As System.Windows.Forms.HScrollBar
Attribute ScrHorizontal.VB_VarHelpID = -1
Public WithEvents PicBody As System.Windows.Forms.PictureBox
Attribute PicBody.VB_VarHelpID = -1
Friend WithEvents picToolBar As System.Windows.Forms.PictureBox
Public WithEvents ScrVertical As System.Windows.Forms.VScrollBar
Attribute ScrVertical.VB_VarHelpID = -1
Public WithEvents PicRightCorner As System.Windows.Forms.PictureBox
Attribute PicRightCorner.VB_VarHelpID = -1
Friend WithEvents sep2 As System.Windows.Forms.ToolBarButton
Friend WithEvents PRINT As System.Windows.Forms.ToolBarButton
Friend WithEvents MOVE_LAST As System.Windows.Forms.ToolBarButton
Friend WithEvents TbPrint As System.Windows.Forms.ToolBar
Friend WithEvents MOVE_FIRST As System.Windows.Forms.ToolBarButton
Friend WithEvents MOVE_PREVIOUS As System.Windows.Forms.ToolBarButton
Friend WithEvents MOVE_NEXT As System.Windows.Forms.ToolBarButton
Friend WithEvents sep1 As System.Windows.Forms.ToolBarButton
Friend WithEvents txCurPage As System.Windows.Forms.TextBox
Friend WithEvents txTotalPages As System.Windows.Forms.TextBox
Friend WithEvents SAVE As System.Windows.Forms.ToolBarButton
Friend WithEvents sep3 As System.Windows.Forms.ToolBarButton
Friend WithEvents cmFileSave As System.Windows.Forms.SaveFileDialog
  Private components As System.ComponentModel.IContainer

  'Required by the Windows Form Designer
  
  'NOTE: The following procedure is required by the Windows Form Designer
  'It can be modified using the Windows Form Designer.
  'Do not modify it using the code editor.
  <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
Me.components = New System.ComponentModel.Container()
Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(cReportPreview))
Me.MOVE_FIRST = New System.Windows.Forms.ToolBarButton()
Me.imgToolBar = New System.Windows.Forms.ImageList(Me.components)
Me.PRINT = New System.Windows.Forms.ToolBarButton()
Me.PicBody = New System.Windows.Forms.PictureBox()
Me.sep1 = New System.Windows.Forms.ToolBarButton()
Me.sep2 = New System.Windows.Forms.ToolBarButton()
Me.sep3 = New System.Windows.Forms.ToolBarButton()
Me.PicRule = New System.Windows.Forms.Panel()
Me.Line1 = New System.Windows.Forms.Label()
Me.MOVE_NEXT = New System.Windows.Forms.ToolBarButton()
Me.picBack = New System.Windows.Forms.PictureBox()
Me.SAVE = New System.Windows.Forms.ToolBarButton()
Me.MOVE_PREVIOUS = New System.Windows.Forms.ToolBarButton()
Me.ScrVertical = New System.Windows.Forms.VScrollBar()
Me.ScrHorizontal = New System.Windows.Forms.HScrollBar()
Me.txTotalPages = New System.Windows.Forms.TextBox()
Me.PicRightCorner = New System.Windows.Forms.PictureBox()
Me.txCurPage = New System.Windows.Forms.TextBox()
Me.comdDialog = New System.Windows.Forms.PrintDialog()
Me.picToolBar = New System.Windows.Forms.PictureBox()
Me.MOVE_LAST = New System.Windows.Forms.ToolBarButton()
Me.TbPrint = New System.Windows.Forms.ToolBar()
Me.cmFileSave = New System.Windows.Forms.SaveFileDialog()
Me.PicRule.SuspendLayout()
Me.SuspendLayout()
'
'MOVE_FIRST
'
Me.MOVE_FIRST.ImageIndex = 0
Me.MOVE_FIRST.ItemData = "MOVE_FIRST"
Me.MOVE_FIRST.Tag = "MOVE_FIRST"
'
'imgToolBar
'
Me.imgToolBar.ColorDepth = System.Windows.Forms.ColorDepth.Depth8Bit
Me.imgToolBar.ImageSize = New System.Drawing.Size(16, 16)
Me.imgToolBar.ImageStream = CType(resources.GetObject("imgToolBar.ImageStream"), System.Windows.Forms.ImageListStreamer)
Me.imgToolBar.TransparentColor = System.Drawing.Color.Transparent
'
'PRINT
'
Me.Print .ImageIndex = 4
Me.Print .ItemData = "PRINT"
Me.Print .Tag = "PRINT"
'
'PicBody
'
Me.PicBody.BackColor = System.Drawing.Color.White
Me.PicBody.Cursor = System.Windows.Forms.Cursors.Default
Me.PicBody.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
Me.PicBody.ForeColor = System.Drawing.SystemColors.ControlText
Me.PicBody.Location = New System.Drawing.Point(112, 76)
Me.PicBody.Name = "PicBody"
Me.PicBody.RightToLeft = System.Windows.Forms.RightToLeft.No
Me.PicBody.Size = New System.Drawing.Size(79, 213)
Me.PicBody.TabIndex = 8
Me.PicBody.TabStop = False
'
'sep1
'
Me.sep1.Style = System.Windows.Forms.ToolBarButtonStyle.Separator
'
'sep2
'
Me.sep2.Style = System.Windows.Forms.ToolBarButtonStyle.Separator
'
'sep3
'
Me.sep3.Style = System.Windows.Forms.ToolBarButtonStyle.Separator
'
'PicRule
'
Me.PicRule.BackColor = System.Drawing.SystemColors.Control
Me.PicRule.Controls.AddRange(New System.Windows.Forms.Control() {Me.Line1})
Me.PicRule.Cursor = System.Windows.Forms.Cursors.Default
Me.PicRule.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
Me.PicRule.ForeColor = System.Drawing.SystemColors.ControlText
Me.PicRule.Location = New System.Drawing.Point(32, 76)
Me.PicRule.Name = "PicRule"
Me.PicRule.RightToLeft = System.Windows.Forms.RightToLeft.No
Me.PicRule.Size = New System.Drawing.Size(64, 213)
Me.PicRule.TabIndex = 4
Me.PicRule.TabStop = True
'
'Line1
'
Me.Line1.BackColor = System.Drawing.SystemColors.WindowFrame
Me.Line1.Location = New System.Drawing.Point(48, 24)
Me.Line1.Name = "Line1"
Me.Line1.Size = New System.Drawing.Size(1, 171)
Me.Line1.TabIndex = 0
'
'MOVE_NEXT
'
Me.MOVE_NEXT.ImageIndex = 2
Me.MOVE_NEXT.ItemData = "MOVE_NEXT"
Me.MOVE_NEXT.Tag = "MOVE_NEXT"
'
'picBack
'
Me.picBack.BackColor = System.Drawing.SystemColors.ControlDark
Me.picBack.Location = New System.Drawing.Point(360, 132)
Me.picBack.Name = "picBack"
Me.picBack.Size = New System.Drawing.Size(112, 40)
Me.picBack.TabIndex = 10
Me.picBack.TabStop = False
'
'SAVE
'
Me.SAVE.ImageIndex = 5
Me.SAVE.ItemData = "SAVE"
Me.SAVE.Tag = "SAVE"
'
'MOVE_PREVIOUS
'
Me.MOVE_PREVIOUS.ImageIndex = 3
Me.MOVE_PREVIOUS.ItemData = "MOVE_PREVIOUS"
Me.MOVE_PREVIOUS.Tag = "MOVE_PREVIOUS"
'
'ScrVertical
'
Me.ScrVertical.Cursor = System.Windows.Forms.Cursors.Default
Me.ScrVertical.LargeChange = 1
Me.ScrVertical.Location = New System.Drawing.Point(208, 196)
Me.ScrVertical.Maximum = 5
Me.ScrVertical.Name = "ScrVertical"
Me.ScrVertical.Size = New System.Drawing.Size(13, 52)
Me.ScrVertical.TabIndex = 7
'
'ScrHorizontal
'
Me.ScrHorizontal.Cursor = System.Windows.Forms.Cursors.Default
Me.ScrHorizontal.LargeChange = 1
Me.ScrHorizontal.Location = New System.Drawing.Point(252, 144)
Me.ScrHorizontal.Maximum = 32767
Me.ScrHorizontal.Name = "ScrHorizontal"
Me.ScrHorizontal.RightToLeft = System.Windows.Forms.RightToLeft.No
Me.ScrHorizontal.Size = New System.Drawing.Size(67, 13)
Me.ScrHorizontal.TabIndex = 6
'
'txTotalPages
'
Me.txTotalPages.BackColor = System.Drawing.SystemColors.ControlDark
Me.txTotalPages.Location = New System.Drawing.Point(220, 4)
Me.txTotalPages.Name = "txTotalPages"
Me.txTotalPages.Size = New System.Drawing.Size(52, 20)
Me.txTotalPages.TabIndex = 11
Me.txTotalPages.Text = ""
Me.txTotalPages.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
'
'PicRightCorner
'
Me.PicRightCorner.BackColor = System.Drawing.SystemColors.Control
Me.PicRightCorner.Cursor = System.Windows.Forms.Cursors.Default
Me.PicRightCorner.Font = New System.Drawing.Font("Arial", 8!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
Me.PicRightCorner.ForeColor = System.Drawing.SystemColors.ControlText
Me.PicRightCorner.Location = New System.Drawing.Point(272, 244)
Me.PicRightCorner.Name = "PicRightCorner"
Me.PicRightCorner.RightToLeft = System.Windows.Forms.RightToLeft.No
Me.PicRightCorner.Size = New System.Drawing.Size(16, 19)
Me.PicRightCorner.TabIndex = 5
Me.PicRightCorner.TabStop = False
'
'txCurPage
'
Me.txCurPage.BackColor = System.Drawing.SystemColors.ControlLightLight
Me.txCurPage.Location = New System.Drawing.Point(160, 4)
Me.txCurPage.Name = "txCurPage"
Me.txCurPage.Size = New System.Drawing.Size(56, 20)
Me.txCurPage.TabIndex = 11
Me.txCurPage.Text = ""
Me.txCurPage.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
'
'picToolBar
'
Me.picToolBar.BackColor = System.Drawing.SystemColors.Control
Me.picToolBar.Location = New System.Drawing.Point(356, 60)
Me.picToolBar.Name = "picToolBar"
Me.picToolBar.Size = New System.Drawing.Size(112, 40)
Me.picToolBar.TabIndex = 10
Me.picToolBar.TabStop = False
'
'MOVE_LAST
'
Me.MOVE_LAST.ImageIndex = 1
Me.MOVE_LAST.ItemData = "MOVE_LAST"
Me.MOVE_LAST.Tag = "MOVE_LAST"
'
'TbPrint
'
Me.TbPrint.Appearance = System.Windows.Forms.ToolBarAppearance.Flat
Me.TbPrint.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
Me.TbPrint.Buttons.AddRange(New System.Windows.Forms.ToolBarButton() {Me.MOVE_FIRST, Me.MOVE_PREVIOUS, Me.MOVE_NEXT, Me.MOVE_LAST, Me.sep1, Me.PRINT, Me.sep2, Me.SAVE, Me.sep3})
Me.TbPrint.DropDownArrows = True
Me.TbPrint.ImageList = Me.imgToolBar
Me.TbPrint.Name = "TbPrint"
Me.TbPrint.ShowToolTips = True
Me.TbPrint.Size = New System.Drawing.Size(504, 26)
Me.TbPrint.TabIndex = 9
'
'cmFileSave
'
Me.cmFileSave.FileName = "doc1"
'
'cReportPreview
'
Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.txCurPage, Me.txTotalPages, Me.picBack, Me.PicRule, Me.ScrHorizontal, Me.PicBody, Me.picToolBar, Me.ScrVertical, Me.PicRightCorner, Me.TbPrint})
Me.Name = "cReportPreview"
Me.Size = New System.Drawing.Size(504, 300)
Me.PicRule.ResumeLayout (False)
Me.ResumeLayout (False)

  End Sub

#End Region

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
Private Const C_Module As String = "cReportPreview"
Private Const C_Min_Height_Section As Short = 280
Private Const C_Height_Bar_Section As Short = 100
Private Const C_Control_Name As String = "Control"
' estructuras
' variables privadas
Private C_TopBody As Single
Private m_offX As Single
Private m_offY As Single
Private m_KeyFocus As String
Private m_NameRpt As String

Private m_Pages As Short
Private m_CurrPage As Short

' Nombres
Private m_NextNameCtrl As Short

' eventos
Public Event SaveDocument()
Public Event BodyMouseDown(ByRef Button As Short, ByRef Shift As Short, ByRef x As Single, ByRef Y As Single)
Public Event BodyPaint(ByVal e As System.Windows.Forms.PaintEventArgs)
Public Event DoPrint()

Public Event MoveLast()
Public Event MoveNext()
Public Event MovePrevious()
Public Event MoveFirst()
Public Event MoveToPage(ByVal Page As Short)

' propiedades publicas
Public Property Get CommDialog() As Object
  Set CommDialog = comdDialog
End Property

Public Property Get cmFileSaveDialog() As Object
  Set cmFileSaveDialog = cmFileSave
End Property

Public Property Get Body() As Object
  Set Body = PicBody
End Property

Public Property Get Pages() As Short
  Pages = m_Pages
End Property

Public Property Let Pages(ByVal rhs As Short)
   m_Pages = rhs
   txTotalPages.Text = rhs
End Property

Public Property Get CurrPage() As Short
  CurrPage = m_CurrPage
End Property

Public Property Let CurrPage(ByVal rhs As Short)
  txCurPage.Text = rhs
  m_CurrPage = rhs
End Property

' propiedades privadas
' funciones publicas
Public Sub RptRefresh()
  PicBody.Invalidate
End Sub
' funciones privadas

' construccion - destruccion
Private Sub form_Initialize_Renamed()
  C_TopBody = TbPrint.Height + 10

  Dim Printer As System.Drawing.Printing.PageSettings
  Printer = New System.Drawing.Printing.PageSettings

  picToolBar.Top = 0
  picToolBar.Left = 0
  picToolBar.Height = C_TopBody

  picBack.Left = 0
  picBack.Top = 0

  PicBody.Top = C_TopBody
  PicBody.Height = Printer.Bounds.Height + C_TopBody
  PicBody.Width = Printer.Bounds.Width

  PicRule.Top = C_TopBody
  PicRule.Height = Printer.Bounds.Height + C_TopBody * 2 + ScrVertical.Height
  PicRule.Left = 0

  Line1.Left = PicRule.ClientRectangle.Width - 10
  Line1.Width = PicRule.ClientRectangle.Width - 10 - Line1.Left
  Line1.Top = 0

  m_KeyFocus = ""

  PicBody.Left = PicRule.Width
  PicBody.BringToFront
  PicRule.BringToFront
  ScrHorizontal.BringToFront
  ScrVertical.BringToFront
  PicRightCorner.BringToFront
  picToolBar.BringToFront
  TbPrint.BringToFront
  txCurPage.BringToFront
  txTotalPages.BringToFront

  ScrHorizontal.Minimum = -4
  ScrVertical.Minimum = -4
  SizeControls
  ScrVertical_Change (ScrVertical.Minimum)
  ScrHorizontal_Change (ScrHorizontal.Minimum)
End Sub

Private Sub PicBody_MouseDown(ByVal eventSender As System.Object, ByVal eventArgs As System.Windows.Forms.MouseEventArgs)
  Dim Button As Short = eventArgs.Button \ &H100000
  Dim Shift As Short = System.Windows.Forms.Control.ModifierKeys \ &H10000
  Dim x As Single = eventArgs.X
  Dim Y As Single = eventArgs.Y
  RaiseEvent BodyMouseDown(Button, Shift, x, Y)
End Sub


Private Sub ScrHorizontal_Change(ByVal newScrollValue As Integer)
  On Error Resume Next
  PicBody.Left = PicRule.Width - newScrollValue * 2
End Sub

Private Sub ScrHorizontal_Scroll_Renamed(ByVal newScrollValue As Integer)
  On Error Resume Next
  PicBody.Left = PicRule.Width - newScrollValue * 2
End Sub

Private Sub ScrVertical_Change(ByVal newScrollValue As Integer)
  Dim TbPrint As Object
  On Error Resume Next
  PicBody.Top = newScrollValue * -2 + C_TopBody
  PicRule.Top = newScrollValue * -2
End Sub

Private Sub ScrVertical_Scroll_Renamed(ByVal newScrollValue As Integer)
  Dim TbPrint As Object
  On Error Resume Next
  PicBody.Top = newScrollValue * -2 + C_TopBody
  PicRule.Top = newScrollValue * -2
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
Private Sub ScrHorizontal_Scroll(ByVal eventSender As System.Object, ByVal eventArgs As System.Windows.Forms.ScrollEventArgs)
  Select Case eventArgs.Type
    Case System.Windows.Forms.ScrollEventType.ThumbTrack
      ScrHorizontal_Scroll_Renamed (eventArgs.NewValue)
    Case System.Windows.Forms.ScrollEventType.EndScroll
      ScrHorizontal_Change (eventArgs.NewValue)
  End Select
End Sub
Private Sub ScrVertical_Scroll(ByVal eventSender As System.Object, ByVal eventArgs As System.Windows.Forms.ScrollEventArgs)
  Select Case eventArgs.Type
    Case System.Windows.Forms.ScrollEventType.ThumbTrack
      ScrVertical_Scroll_Renamed (eventArgs.NewValue)
    Case System.Windows.Forms.ScrollEventType.EndScroll
      ScrVertical_Change (eventArgs.NewValue)
  End Select
End Sub

Protected Overrides Sub OnResize(ByVal e As System.EventArgs)
  SizeControls
End Sub

Private Sub SizeControls()
  On Error Resume Next

  picToolBar.Width = Me.ClientSize.Width
  picBack.Width = Me.ClientSize.Width
  picBack.Height = Me.ClientSize.Height

  ScrHorizontal.Left = PicRule.Width
  ScrHorizontal.Top = ClientRectangle.Height - ScrHorizontal.Height
  ScrHorizontal.Width = ClientRectangle.Width - ScrHorizontal.Left - ScrVertical.Width
  ScrVertical.Top = C_TopBody
  ScrVertical.Left = ClientRectangle.Width - ScrVertical.Width
  ScrVertical.Height = ClientRectangle.Height - ScrHorizontal.Height - ScrVertical.Top

  If ClientRectangle.Height > 1 Then ScrVertical.Maximum = PicBody.Height - (Me.ClientSize.Height - ScrHorizontal.Height - C_TopBody - 10)
  If ClientRectangle.Width > 1 Then ScrHorizontal.Maximum = PicBody.Width - (Me.ClientSize.Width - PicRule.Width - ScrVertical.Width - 10)

  If (ScrVertical.Maximum - ScrVertical.LargeChange + 1) < 0 Then
    ScrVertical.Maximum = ScrVertical.LargeChange - 1
    ScrVertical.Visible = False
    ScrHorizontal.Width = ClientRectangle.Width - ScrHorizontal.Left
  Else
    ScrVertical.Visible = True
  End If

  If (ScrHorizontal.Maximum - ScrHorizontal.LargeChange + 1) < 0 Then
    ScrHorizontal.Maximum = ScrHorizontal.LargeChange - 1
    ScrHorizontal.Visible = False
    ScrVertical.Height = ClientRectangle.Height - ScrVertical.Top
    PicRightCorner.Visible = False
  Else
    ScrHorizontal.Visible = True
    PicRightCorner.Visible = True
  End If

  ScrVertical.LargeChange = ScrVertical.Maximum / 2
  ScrVertical.SmallChange = ScrVertical.Maximum / 100

  ScrHorizontal.LargeChange = ScrHorizontal.Maximum / 2
  ScrHorizontal.SmallChange = ScrHorizontal.Maximum / 100

  Line1.Height = PicRule.ClientRectangle.Height
  PicRightCorner.Left = ClientRectangle.Width - ScrVertical.Width
  PicRightCorner.Top = ClientRectangle.Height - ScrHorizontal.Height
End Sub

Private Sub txCurPage_Leave(ByVal sender As Object, ByVal e As System.eventArgs)
  txCurPage.SelectionStart = 0
  txCurPage.SelectionLength = Len(txCurPage.Text)
End Sub

Private Sub txCurPage_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs)

  ' Solo acepta numeros
  Dim NumberPage As Integer
  Select Case Asc(e.KeyChar)
    Case System.Windows.Forms.Keys.D0, System.Windows.Forms.Keys.D1, System.Windows.Forms.Keys.D2, System.Windows.Forms.Keys.D3, System.Windows.Forms.Keys.D4, System.Windows.Forms.Keys.D5, System.Windows.Forms.Keys.D6, System.Windows.Forms.Keys.D7, System.Windows.Forms.Keys.D8, System.Windows.Forms.Keys.D9
    Case System.Windows.Forms.Keys.Return

      NumberPage = Val(txCurPage.Text)
      If NumberPage > m_Pages Or NumberPage < 1 Then
        txCurPage.Text = m_CurrPage
      Else
        RaiseEvent MoveToPage(NumberPage)
        txCurPage.Focus
      End If
      e.Handled = True
    Case Else
      e.Handled = True
  End Select
End Sub

Private Sub TbPrint_ButtonClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ToolBarButtonClickEventArgs)
  Select Case e.Button.Tag
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
    Case "SAVE"
      RaiseEvent SaveDocument
  End Select
End Sub

Private Sub PicBody_Paint(ByVal sender As Object, ByVal e As System.Windows.Forms.PaintEventArgs)
  RaiseEvent BodyPaint(e)
End Sub

