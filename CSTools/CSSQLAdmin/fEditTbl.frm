VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{CDE57A40-8B86-11D0-B3C6-00A0C90AEA82}#1.0#0"; "MSDATGRD.OCX"
Begin VB.Form fEditTbl 
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.PictureBox picBar 
      BackColor       =   &H8000000D&
      BorderStyle     =   0  'None
      Height          =   105
      Left            =   180
      ScaleHeight     =   105
      ScaleWidth      =   3930
      TabIndex        =   5
      Top             =   1350
      Visible         =   0   'False
      Width           =   3930
   End
   Begin VB.PictureBox picSplitter 
      BorderStyle     =   0  'None
      Height          =   105
      Left            =   225
      MousePointer    =   7  'Size N S
      ScaleHeight     =   105
      ScaleWidth      =   3840
      TabIndex        =   4
      Top             =   1485
      Width           =   3840
   End
   Begin VB.TextBox txSqlstmt 
      Height          =   690
      Left            =   630
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   3
      Top             =   540
      Width           =   1995
   End
   Begin MSDataGridLib.DataGrid dg 
      Height          =   1170
      Left            =   315
      TabIndex        =   0
      Top             =   1755
      Width           =   3420
      _ExtentX        =   6033
      _ExtentY        =   2064
      _Version        =   393216
      HeadLines       =   1
      RowHeight       =   15
      BeginProperty HeadFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ColumnCount     =   2
      BeginProperty Column00 
         DataField       =   ""
         Caption         =   ""
         BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
            Type            =   0
            Format          =   ""
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   11274
            SubFormatType   =   0
         EndProperty
      EndProperty
      BeginProperty Column01 
         DataField       =   ""
         Caption         =   ""
         BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
            Type            =   0
            Format          =   ""
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   11274
            SubFormatType   =   0
         EndProperty
      EndProperty
      SplitCount      =   1
      BeginProperty Split0 
         BeginProperty Column00 
         EndProperty
         BeginProperty Column01 
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.StatusBar sbEdit 
      Align           =   2  'Align Bottom
      Height          =   285
      Left            =   0
      TabIndex        =   1
      Top             =   2910
      Width           =   4680
      _ExtentX        =   8255
      _ExtentY        =   503
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.Toolbar tbTools 
      Height          =   390
      Left            =   0
      TabIndex        =   2
      Top             =   0
      Width           =   4680
      _ExtentX        =   8255
      _ExtentY        =   688
      ButtonWidth     =   609
      ButtonHeight    =   582
      Appearance      =   1
      _Version        =   393216
   End
   Begin MSComctlLib.ImageList ilToolBar 
      Left            =   3960
      Top             =   2070
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   2
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditTbl.frx":0000
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fEditTbl.frx":015A
            Key             =   ""
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "fEditTbl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' fEditTbl
' 26-07-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fEditTbl"

Private Const c_panel_message = "m"
Private Const c_panel_upper = "u"
Private Const c_panel_insert = "i"
Private Const c_panel_numlock = "n"

Private Const c_ktlb_sql = "sql"
Private Const c_ktlb_go = "go"

Private Enum c_img_tlb
  c_img_tlb_sql = 1
  c_img_tbl_go
End Enum

Private Const sglSplitLimit = 500

' estructuras
' variables privadas
Private m_Table                         As String
Private m_Server                        As String
Private m_Database                      As String
Private m_User                          As String
Private m_Password                      As String
Private m_UseNTSecurity                 As Boolean

Private m_DataSource                    As cDataSource

Private m_moving    As Boolean

' eventos
' propiedadades publicas

Public Property Get Server() As String
   Server = m_Server
End Property

Public Property Let Server(ByVal rhs As String)
   m_Server = rhs
End Property

Public Property Get Database() As String
   Database = m_Database
End Property

Public Property Let Database(ByVal rhs As String)
   m_Database = rhs
End Property

Public Property Get User() As String
   User = m_User
End Property

Public Property Let User(ByVal rhs As String)
   m_User = rhs
End Property

Public Property Get Password() As String
   Password = m_Password
End Property

Public Property Let Password(ByVal rhs As String)
   m_Password = rhs
End Property

Public Property Get UseNTSecurity() As Boolean
   UseNTSecurity = m_UseNTSecurity
End Property

Public Property Let UseNTSecurity(ByVal rhs As Boolean)
   m_UseNTSecurity = rhs
End Property

Public Property Get Table() As String
   Table = m_Table
End Property

Public Property Let Table(ByVal rhs As String)
   m_Table = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub FormatStatusBar()
  Dim Panel As Panel
  sbEdit.Panels.Clear
  Set Panel = sbEdit.Panels.Add(, c_panel_message)
  Panel.Style = sbrText
  Panel.AutoSize = sbrSpring
  Set Panel = sbEdit.Panels.Add(, c_panel_upper)
  Panel.Style = sbrCaps
  Panel.Width = 600
  Set Panel = sbEdit.Panels.Add(, c_panel_insert)
  Panel.Style = sbrIns
  Panel.Width = 600
  Set Panel = sbEdit.Panels.Add(, c_panel_numlock)
  Panel.Style = sbrNum
  Panel.Width = 600
End Sub

Private Sub dg_Error(ByVal DataError As Integer, Response As Integer)
  Response = 0
End Sub

Private Sub picSplitter_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
  With picSplitter
    picBar.Move .Left, .Top, .Width, .Height - 40
  End With
  picBar.Visible = True
  m_moving = True
End Sub

Private Sub picSplitter_MouseMove(Button As Integer, Shift As Integer, x As Single, Y As Single)
  Dim sglPos As Single
  
  If m_moving Then
    sglPos = Y + picSplitter.Top
    If sglPos < sglSplitLimit Then
      picBar.Top = sglSplitLimit
    ElseIf sglPos > Width - sglSplitLimit Then
      picBar.Top = Width - sglSplitLimit
    Else
      picBar.Top = sglPos
    End If
  End If
End Sub

Private Sub picSplitter_MouseUp(Button As Integer, Shift As Integer, x As Single, Y As Single)
  SizeControls
  picBar.Visible = False
  m_moving = False
End Sub

Private Sub Form_Resize()
  SizeControls
End Sub

Private Sub SizeControls()
  On Error Resume Next
  
  picSplitter.Left = 0
  picSplitter.Width = ScaleWidth
  picSplitter.Top = picBar.Top
  
  If picSplitter.Visible Then
    Dim Top As Integer
    Top = picSplitter.Top + picSplitter.Height
    dg.Move 0, Top, ScaleWidth, ScaleHeight - sbEdit.Height - Top
    txSqlstmt.Move 0, tbTools.Height, ScaleWidth, picSplitter.Top - tbTools.Height
  Else
    dg.Move 0, tbTools.Height, ScaleWidth, ScaleHeight - sbEdit.Height - tbTools.Height
  End If
End Sub

Private Sub LoadToolBar()
  tbTools.Style = tbrFlat
  tbTools.BorderStyle = ccNone
  tbTools.Appearance = ccFlat
  tbTools.Align = 1
  Set tbTools.ImageList = ilToolBar
  With tbTools.Buttons
    .Clear
    .Add , , , tbrSeparator
    .Add , c_ktlb_sql, , , c_img_tlb_sql
    .Add , c_ktlb_go, , , c_img_tbl_go
  End With
End Sub

Private Sub tbTools_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error GoTo ControlError

  Select Case Button.Key
    Case c_ktlb_sql
      ShowSqlstmt Not picSplitter.Visible
    Case c_ktlb_go
      Execute
  End Select
  
  GoTo ExitProc
ControlError:
  MngError Err, "tbTools_ButtonClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub ShowSqlstmt(ByVal Show As Boolean)
  picSplitter.Visible = Show
  txSqlstmt.Visible = Show
  SizeControls
End Sub

Private Function Execute() As Boolean
  Dim rs        As Recordset
  Dim sqlstmt   As String
  
  With txSqlstmt
    If .SelLength Then
      sqlstmt = Mid$(.Text, IIf(.SelStart > 0, .SelStart, 1), .SelLength)
    Else
      sqlstmt = .Text
    End If
  End With
  
  Execute = m_DataSource.OpenRs(rs, sqlstmt)
  Set dg.DataSource = rs
End Function

' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  
  FormatStatusBar
  
#If PREPROC_IMPSQL Then
  CSKernelClient2.LoadForm Me, Me.Name
#Else
  FormCenter Me
#End If
  Height = 7000
  Width = 9000
  
  Set m_DataSource = New cDataSource
  
  If Not m_DataSource.OpenConnection(m_Server, m_Database, m_User, m_Password, m_UseNTSecurity) Then Exit Sub
  
  Dim sqlstmt As String
  
  sqlstmt = "select top 1000 * from " & m_Table
  txSqlstmt.Text = sqlstmt
  
  If Not Execute() Then Exit Sub
  
  dg.AllowAddNew = True
  dg.AllowDelete = True
  dg.AllowUpdate = True
  dg.AllowArrows = True
  
  Caption = m_Table
  
  ShowSqlstmt False
  LoadToolBar

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError

  Set dg.DataSource = Nothing
  Set m_DataSource = Nothing

#If PREPROC_IMPSQL Then
  CSKernelClient2.UnloadForm Me, Me.Name
#End If

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Unload", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

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
Private Sub txSqlstmt_Change()

End Sub
