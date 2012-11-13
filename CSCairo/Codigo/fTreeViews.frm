VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fTreeViews 
   Caption         =   "Vistas"
   ClientHeight    =   3090
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   4680
   Icon            =   "fTreeViews.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   3090
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ListView lvViews 
      Height          =   615
      Left            =   420
      TabIndex        =   0
      Top             =   1560
      Width           =   1095
      _ExtentX        =   1931
      _ExtentY        =   1085
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      Appearance      =   0
      NumItems        =   0
   End
   Begin MSComctlLib.Toolbar tbrTool 
      Align           =   1  'Align Top
      Height          =   630
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   4680
      _ExtentX        =   8255
      _ExtentY        =   1111
      ButtonWidth     =   609
      ButtonHeight    =   953
      Appearance      =   1
      _Version        =   393216
   End
End
Attribute VB_Name = "fTreeViews"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const C_Module As String = "fTreeViews"
Private Const c_name As String = "treeviews"

Private Const K_ARBV_ID = "ARBV_ID"

Private m_TblId     As Long
Private m_Name      As String
Private m_arb_id    As Long

' Preferencias del Usuario
'
Private m_UserCfg           As cUsuarioConfig

Public Property Let TblId(ByVal rhs As Long)
  m_TblId = rhs
End Property

Public Property Let AbmName(ByVal rhs)
  m_Name = rhs
End Property

Public Property Let ArbId(ByVal rhs As Long)
  m_arb_id = rhs
End Property

Public Function LoadViews(ByVal arb_id As Long) As Boolean
  On Error GoTo ControlError

  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  Dim db      As cDataBase
  
  lvViews.ListItems.Clear
  
  Set db = OAPI.Database
  sqlstmt = "sp_ArbGetVistas " & arb_id
  If Not db.OpenRs(sqlstmt, rs) Then Exit Function
  
  While Not rs.EOF
  
    With lvViews.ListItems.Add(, , db.ValField(rs.Fields, "arbv_nombre"))
      .SubItems(1) = db.ValField(rs.Fields, "arbv_descrip")
      .Tag = db.ValField(rs.Fields, "arbv_id")
    End With
  
    rs.MoveNext
  Wend
  
  LoadViews = True

  GoTo ExitProc
ControlError:
  MngError Err, "LoadViews", C_Module, ""
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Sub Edit()
  On Error Resume Next
  pEdit pGetViewId()
End Sub

Public Sub NewObj()
  pEdit csNO_ID
End Sub

Public Sub Delete()
  Dim sqlstmt As String
  Dim arbv_id As Long
  
  arbv_id = pGetViewId()
  If arbv_id Then
    sqlstmt = "sp_ArbVistaDelete " & arbv_id
    If Not OAPI.Database.Execute(sqlstmt) Then Exit Sub
    lvViews.ListItems.Remove lvViews.SelectedItem.Index
  End If
End Sub

Public Sub CloseForm()
  Unload Me
End Sub

Private Sub pEdit(ByVal view_id As Long)
  On Error Resume Next
  Dim f As fTreeViewEdit
  Set f = New fTreeViewEdit
  f.AbmName = m_Name
  f.TblId = m_TblId
  f.ArbId = m_arb_id
  f.ArbvId = view_id
  If Not f.Init() Then Exit Sub
  f.Show vbModal
  LoadViews m_arb_id
End Sub

Private Function pGetViewId() As Long
  On Error Resume Next
  pGetViewId = Val(lvViews.SelectedItem.Tag)
End Function

Private Sub Form_Load()
  On Error Resume Next
  
  CSKernelClient2.LoadForm Me, c_name
  
  DoEvents
  
  lvViews.Top = tbrTool.Height
  lvViews.Left = 0
    
  lvViews.AllowColumnReorder = False
  lvViews.BorderStyle = ccNone
  lvViews.FullRowSelect = True
  lvViews.HideColumnHeaders = False
  lvViews.View = lvwReport
  lvViews.LabelEdit = lvwManual
  lvViews.MultiSelect = True
  lvViews.GridLines = True
  
  lvViews.ColumnHeaders.Add , , "Nombre", 2000
  lvViews.ColumnHeaders.Add , , "Descripcion", 4000
  
  ' Preferencias del Usuario
  '
  Set m_UserCfg = New cUsuarioConfig
  m_UserCfg.Load
  
  CSKernelClient2.SetToolBar24 tbrTool, BUTTON_DELETE + BUTTON_EDIT + BUTTON_NEW + BUTTON_EXIT, 0, 0, m_UserCfg.ViewNamesInToolbar
End Sub

Private Sub Form_Resize()
  On Error Resume Next
  lvViews.Height = Me.ScaleHeight - lvViews.Top
  lvViews.Width = Me.ScaleWidth
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error Resume Next
  CSKernelClient2.UnloadForm Me, c_name, False

  ' Preferencias del Usuario
  '
  Set m_UserCfg = Nothing
End Sub

Private Sub tbrTool_ButtonClick(ByVal Button As MSComctlLib.Button)
  CSKernelClient2.PresButtonToolbar Button.key, Me
End Sub
