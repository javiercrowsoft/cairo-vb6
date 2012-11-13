VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fClients 
   Caption         =   "Clientes"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   Icon            =   "fClients.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.Toolbar tbMain 
      Align           =   1  'Align Top
      Height          =   360
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   4680
      _ExtentX        =   8255
      _ExtentY        =   635
      ButtonWidth     =   609
      ButtonHeight    =   582
      Appearance      =   1
      Style           =   1
      ImageList       =   "imToolbar"
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   1
         BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Key             =   "REFRESH"
            ImageIndex      =   2
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ListView lvInfo 
      Height          =   1965
      Left            =   0
      TabIndex        =   0
      Top             =   720
      Width           =   4560
      _ExtentX        =   8043
      _ExtentY        =   3466
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.ImageList imToolbar 
      Left            =   0
      Top             =   2580
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   21
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":000C
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":03A6
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":0740
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":0F52
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":12EC
            Key             =   ""
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":1686
            Key             =   ""
         EndProperty
         BeginProperty ListImage7 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":1A20
            Key             =   ""
         EndProperty
         BeginProperty ListImage8 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":1DBA
            Key             =   ""
         EndProperty
         BeginProperty ListImage9 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":2154
            Key             =   ""
         EndProperty
         BeginProperty ListImage10 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":24EE
            Key             =   ""
         EndProperty
         BeginProperty ListImage11 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":2888
            Key             =   ""
         EndProperty
         BeginProperty ListImage12 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":2C22
            Key             =   ""
         EndProperty
         BeginProperty ListImage13 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":2FBC
            Key             =   ""
         EndProperty
         BeginProperty ListImage14 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":3356
            Key             =   ""
         EndProperty
         BeginProperty ListImage15 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":36F0
            Key             =   ""
         EndProperty
         BeginProperty ListImage16 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":3C8A
            Key             =   ""
         EndProperty
         BeginProperty ListImage17 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":4024
            Key             =   ""
         EndProperty
         BeginProperty ListImage18 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":43BE
            Key             =   ""
         EndProperty
         BeginProperty ListImage19 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":4758
            Key             =   ""
         EndProperty
         BeginProperty ListImage20 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":4AF2
            Key             =   ""
         EndProperty
         BeginProperty ListImage21 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fClients.frx":4E8C
            Key             =   ""
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "fClients"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const C_Module = "fClients"

Private Sub Form_Load()
  On Error GoTo ControlError
  
  LoadForm Me, Me.name
  
  With lvInfo
  
    .View = lvwReport
    .LabelEdit = lvwManual
    .FullRowSelect = True
    .HideSelection = False
  
    With .ColumnHeaders
      .Add , , "Computadoras", 3000
      .Add , , "Bolqueos", 1000
    End With
  End With
  
  fDataBases.Show vbModal
  
  If Not fDataBases.Ok Then Exit Sub
  
  pShowClients
  
  GoTo ExitProc
ControlError:
  MngError Err, "ShowStep", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  lvInfo.Move 0, tbMain.Height, Me.ScaleWidth, Me.ScaleHeight - tbMain.Height
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  UnloadForm Me, Me.name
End Sub

Private Sub tbMain_ButtonClick(ByVal Button As MSComctlLib.Button)
  On Error Resume Next
  Select Case Button.key
    Case "REFRESH"
      pShowClients
  End Select
End Sub

Private Sub pShowClients()
  Dim sqlstmt As String
  Dim db      As cDataBase
  Dim rs      As ADODB.Recordset
  
  Set db = New cDataBase
  
  If Not db.OpenConnection(g_db.server, _
                           g_db.DataBase, _
                           g_db.User, _
                           g_db.Pwd, _
                           g_db.UseNT) Then Exit Sub
                           
  sqlstmt = "dc_csc_sys_0010 1"
                           
  If Not db.OpenRs(sqlstmt, rs) Then Exit Sub
  
  lvInfo.ListItems.Clear
  
  While Not rs.EOF
  
    With lvInfo.ListItems.Add(, , Trim(rs.fields.Item("Computadora").Value))
      .SubItems(1) = rs.fields.Item("Bloqueos").Value
    End With
  
    rs.MoveNext
  Wend
  
End Sub
