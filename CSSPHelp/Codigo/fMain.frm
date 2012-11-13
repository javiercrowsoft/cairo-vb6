VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fMain 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "SP Help"
   ClientHeight    =   5745
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   9015
   Icon            =   "fMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5745
   ScaleWidth      =   9015
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txFilter 
      Height          =   345
      Left            =   4560
      TabIndex        =   12
      Top             =   60
      Width           =   1875
   End
   Begin VB.TextBox txNivel 
      Alignment       =   1  'Right Justify
      Height          =   285
      Left            =   5550
      TabIndex        =   10
      Text            =   "2"
      Top             =   5325
      Width           =   840
   End
   Begin VB.CommandButton cmdShowDep 
      Caption         =   "Ver dependencias"
      Height          =   315
      Left            =   6525
      TabIndex        =   9
      Top             =   5325
      Width           =   1815
   End
   Begin VB.CommandButton cmdExit 
      Caption         =   "Salir"
      Height          =   315
      Left            =   7875
      TabIndex        =   8
      Top             =   75
      Width           =   1065
   End
   Begin VB.CommandButton cmdLoad 
      Caption         =   "Cargar SPs"
      Height          =   315
      Left            =   6510
      TabIndex        =   7
      Top             =   75
      Width           =   1275
   End
   Begin VB.ComboBox cbDatabase 
      Height          =   315
      Left            =   600
      Sorted          =   -1  'True
      Style           =   2  'Dropdown List
      TabIndex        =   6
      Top             =   75
      Width           =   3915
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "4"
      BeginProperty Font 
         Name            =   "Marlett"
         Size            =   14.25
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   390
      Left            =   4350
      TabIndex        =   4
      Top             =   1725
      Width           =   315
   End
   Begin VB.CommandButton cmdQuit 
      Caption         =   "3"
      BeginProperty Font 
         Name            =   "Marlett"
         Size            =   14.25
         Charset         =   2
         Weight          =   500
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   390
      Left            =   4350
      TabIndex        =   3
      Top             =   2175
      Width           =   315
   End
   Begin MSComctlLib.ListView lvSP 
      Height          =   4065
      Left            =   75
      TabIndex        =   0
      Top             =   975
      Width           =   4140
      _ExtentX        =   7303
      _ExtentY        =   7170
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.ListView lvSPSel 
      Height          =   4065
      Left            =   4800
      TabIndex        =   2
      Top             =   975
      Width           =   4140
      _ExtentX        =   7303
      _ExtentY        =   7170
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.Label Label3 
      Caption         =   "Niveles"
      Height          =   315
      Left            =   4875
      TabIndex        =   11
      Top             =   5325
      Width           =   690
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   9000
      Y1              =   5175
      Y2              =   5175
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   9000
      Y1              =   525
      Y2              =   525
   End
   Begin VB.Label Label2 
      Caption         =   "Base"
      Height          =   315
      Left            =   150
      TabIndex        =   5
      Top             =   150
      Width           =   465
   End
   Begin VB.Label Label1 
      Caption         =   "Stored Procedures"
      Height          =   315
      Left            =   150
      TabIndex        =   1
      Top             =   675
      Width           =   2040
   End
End
Attribute VB_Name = "fMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private WithEvents m_flogin As fLogin
Attribute m_flogin.VB_VarHelpID = -1

Private Const c_filter As String = "Indique un filtro"

Private m_server As SQLDMO.SQLServer
Private m_cancel As Boolean

Private Sub cmdAdd_Click()
    MoveToList lvSP, lvSPSel
End Sub

Private Sub cmdExit_Click()
    Unload Me
End Sub

Private Sub cmdLoad_Click()
    pLoadSps
End Sub

Private Sub cmdQuit_Click()
    MoveToList lvSPSel, lvSP
End Sub

Private Sub cmdShowDep_Click()
    Dim i           As Integer
    Dim j           As Integer
    Dim n           As Integer
    Dim db          As SQLDMO.Database
    Dim qr          As SQLDMO.QueryResults
    Dim f           As fTree
    Dim Node        As Node
    Dim nodeRoot    As Node
    Dim nodeChild   As Node
    Dim nodeParent  As Node
    Dim icon        As Integer
    
    m_cancel = False
    
    Set f = fTree
    
    Load f
    
    If cbDatabase.ListIndex < 0 Then Exit Sub
    
    Set db = m_server.Databases(cbDatabase.ListIndex + 1)
    
    Set nodeRoot = f.tvSp.Nodes.Add(, , , "SPs", 3)
    
    With Me.lvSPSel.ListItems
        n = .Count
        For i = 1 To .Count
            
            DoEvents
            
            If m_cancel Then Exit For
            
            With .Item(i)
                Me.Caption = n & " " & i & " Cargando " & .Text
                With db.StoredProcedures.Item(.Text)
                    
                    Set Node = f.tvSp.Nodes.Add(nodeRoot, tvwChild, , .name, 1)
                    
                    Set nodeChild = f.tvSp.Nodes.Add(Node, tvwChild, , "Usado por", 5)
                    
                    Set qr = .EnumDependencies(SQLDMODep_Children + SQLDMODep_FirstLevelOnly)
                    For j = 1 To qr.Rows
                        f.tvSp.Nodes.Add nodeChild, tvwChild, , qr.GetColumnString(j, 2), 7
                    Next
                    
                    Set nodeParent = f.tvSp.Nodes.Add(Node, tvwChild, , "Depende de", 5)
                    
                    Set qr = .EnumDependencies(SQLDMODep_Parents + SQLDMODep_FirstLevelOnly)
                    For j = 1 To qr.Rows
                        If qr.GetColumnString(j, 1) = 16 Then
                          icon = 7
                        Else
                          icon = 6
                        End If
                        f.tvSp.Nodes.Add nodeParent, tvwChild, , qr.GetColumnString(j, 2), icon
                    Next
                End With
            End With
        Next
    End With
    
    Me.Caption = "SP Help"
    
    f.Show vbModal
    Unload f
End Sub

Private Sub Form_Initialize()
    Set m_server = New SQLDMO.SQLServer
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
  If KeyAscii = vbKeyEscape Then
    m_cancel = MsgBox("Desea cancelar?", vbQuestion + vbYesNo) = vbYes
  End If
End Sub

Private Sub Form_Terminate()
    Set m_server = Nothing
End Sub

Private Sub Form_Load()
    
    Center Me
    
    Me.Show
    
    Set m_flogin = fLogin
    
    fLogin.Show vbModal
    
    If fLogin.Ok Then
    
        Me.KeyPreview = True
        txFilter.Text = c_filter
    
        pFormatGrids lvSP
        pFormatGrids lvSPSel
    
    Else
        Unload Me
    End If
End Sub

Private Sub pFormatGrids(ByRef ctl As ListView)
    With ctl
        .View = lvwReport
        .FullRowSelect = True
        .MultiSelect = True
        .LabelEdit = lvwManual
        With .ColumnHeaders
            .Add , , "Nombre", 2800
            .Add , , "Tipo", 1000
        End With
        .GridLines = True
    End With
End Sub

Private Sub lvSP_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
    On Error Resume Next
    lvSP.SortKey = ColumnHeader.Index - 1
    lvSP.Sorted = True
End Sub

Private Sub lvSPSel_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
    On Error Resume Next
    lvSPSel.SortKey = ColumnHeader.Index - 1
    lvSPSel.Sorted = True
End Sub

Private Sub m_flogin_Connect(Cancel As Boolean)
    On Error GoTo ControlError
    With m_flogin
        If .opSQL Then
            m_server.LoginSecure = False
            m_server.Connect .txServer.Text, .txUser.Text, .txPassword.Text
        Else
            m_server.LoginSecure = True
            m_server.Connect .txServer.Text
        End If
        pLoadDbs
    End With
    
    Cancel = False
    Exit Sub
ControlError:
    If Err.Number = -2147221504 Then
        MsgBox "No fue posible encontrar el servidor"
    
    ElseIf Err.Number = -2147203048 Then
        MsgBox "Fallo el login para el usuario" & pGetErrorSQL(Err.Description)
        
    Else
        MngError Err, "m_flogin_Connect"
    End If
    Cancel = True
End Sub

Private Function pGetErrorSQL(ByVal errDescript As String) As String
    pGetErrorSQL = vbCrLf & vbCrLf & Replace(errDescript, "[Microsoft][ODBC SQL Server Driver][SQL Server]", "")
End Function

Private Sub pLoadDbs()
    Dim db As SQLDMO.Database
    
    For Each db In m_server.Databases
        Me.cbDatabase.AddItem db.name
    Next
End Sub

Private Sub pLoadSps()
    Dim sp As SQLDMO.StoredProcedure
    
    Me.lvSP.ListItems.Clear
    Me.lvSPSel.ListItems.Clear
    
    If Me.cbDatabase.ListIndex < 0 Then Exit Sub
    
    For Each sp In m_server.Databases(Me.cbDatabase.ListIndex + 1).StoredProcedures
      If txFilter.Text <> vbNullString Then
        If InStr(1, sp.name, txFilter.Text, vbTextCompare) Then
          pAddSp Me.lvSP, sp.name, sp.SystemObject
        End If
      Else
        pAddSp Me.lvSP, sp.name, sp.SystemObject
      End If
    Next

End Sub

Private Sub pAddSp(ByRef lv As ListView, ByVal name As String, ByVal sysObject As Boolean)
    With lv.ListItems
            
        With .Add(, , name)
            .SubItems(1) = IIf(sysObject, "Sistema", "Usuario")
        End With
    End With
End Sub

Private Sub MoveToList(ByRef lvFrom As ListView, ByRef lvTo As ListView)
    Dim i As Integer
    
    With lvFrom.ListItems
        
        i = 1
        While i <= .Count
            With .Item(i)
                If .Selected Then
                    pAddSp lvTo, .Text, .SubItems(1) = "Sistema"
                    lvFrom.ListItems.Remove i
                Else
                    i = i + 1
                End If
            End With
        Wend
    End With
End Sub

Private Sub txFilter_GotFocus()
  If txFilter.Text = c_filter Then
    txFilter.Text = ""
  End If
End Sub

Private Sub txFilter_LostFocus()
  If txFilter.Text = "" Then
    txFilter.Text = c_filter
  End If
End Sub

Private Sub txNivel_KeyPress(KeyAscii As Integer)
    If InStr(1, "1234567890", Chr(KeyAscii), vbBinaryCompare) = 0 Then
        If KeyAscii <> vbKeyBack Then
            KeyAscii = 0
        End If
    End If
End Sub

