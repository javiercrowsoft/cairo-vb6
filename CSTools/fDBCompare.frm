VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form fDBCompare 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Comparar bases de datos"
   ClientHeight    =   9435
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   11940
   Icon            =   "fDBCompare.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   9435
   ScaleWidth      =   11940
   StartUpPosition =   3  'Windows Default
   Begin VB.CheckBox chkIndex 
      BackColor       =   &H80000010&
      Caption         =   "Indices"
      ForeColor       =   &H8000000E&
      Height          =   195
      Left            =   2700
      TabIndex        =   20
      Top             =   840
      Value           =   1  'Checked
      Width           =   825
   End
   Begin VB.CommandButton cmdExpandColapse 
      Caption         =   "Expandir"
      Height          =   315
      Left            =   5040
      TabIndex        =   19
      Top             =   780
      Width           =   855
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "Aplicar"
      Height          =   315
      Left            =   6300
      TabIndex        =   18
      Top             =   780
      Width           =   735
   End
   Begin VB.TextBox txFileCompare 
      Height          =   315
      Left            =   7080
      TabIndex        =   17
      Text            =   "c:\compare.txt"
      Top             =   780
      Width           =   3135
   End
   Begin VB.CommandButton cmdOpenCompare 
      Caption         =   "..."
      Height          =   315
      Left            =   10260
      TabIndex        =   16
      Top             =   780
      Width           =   255
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Guardar"
      Height          =   315
      Left            =   10680
      TabIndex        =   15
      Top             =   780
      Width           =   975
   End
   Begin MSComDlg.CommonDialog CDialog 
      Left            =   6120
      Top             =   5340
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CheckBox chkOnlyMismatch 
      BackColor       =   &H80000010&
      Caption         =   "Solo diferentes"
      ForeColor       =   &H8000000E&
      Height          =   195
      Left            =   1140
      TabIndex        =   14
      Top             =   840
      Value           =   1  'Checked
      Width           =   1365
   End
   Begin VB.CheckBox ChkCrearFile 
      Alignment       =   1  'Right Justify
      Caption         =   "Archivo Nuevo"
      Height          =   195
      Left            =   0
      TabIndex        =   13
      Top             =   8820
      Value           =   1  'Checked
      Width           =   1725
   End
   Begin MSComctlLib.ImageList imlTree 
      Left            =   5280
      Top             =   5160
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   1
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fDBCompare.frx":058A
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.StatusBar sbMessages 
      Align           =   2  'Align Bottom
      Height          =   255
      Left            =   0
      TabIndex        =   12
      Top             =   9180
      Width           =   11940
      _ExtentX        =   21061
      _ExtentY        =   450
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   1
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
         EndProperty
      EndProperty
   End
   Begin VB.CommandButton cmdCompare 
      Caption         =   "Comparar"
      Height          =   315
      Left            =   0
      TabIndex        =   11
      Top             =   780
      Width           =   975
   End
   Begin VB.CommandButton cmdOpenFile 
      Caption         =   "..."
      Height          =   315
      Left            =   9720
      TabIndex        =   10
      Top             =   8760
      Width           =   255
   End
   Begin VB.TextBox txFile 
      Height          =   315
      Left            =   1920
      TabIndex        =   9
      Text            =   "c:\tables.sql"
      Top             =   8760
      Width           =   7695
   End
   Begin VB.CommandButton cmdGenerate 
      Caption         =   "Generar Script"
      Height          =   315
      Left            =   10320
      TabIndex        =   8
      Top             =   8760
      Width           =   1575
   End
   Begin VB.CommandButton cmdServerB 
      Caption         =   "..."
      Height          =   315
      Left            =   11700
      TabIndex        =   7
      Top             =   0
      Width           =   255
   End
   Begin VB.CommandButton cmdServerA 
      Caption         =   "..."
      Height          =   315
      Left            =   5700
      TabIndex        =   6
      Top             =   0
      Width           =   255
   End
   Begin VB.ComboBox cbDBB 
      Height          =   315
      Left            =   6000
      Style           =   2  'Dropdown List
      TabIndex        =   3
      Top             =   360
      Width           =   5955
   End
   Begin VB.ComboBox cbDBA 
      Height          =   315
      Left            =   0
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   360
      Width           =   5955
   End
   Begin MSComctlLib.TreeView tvB 
      Height          =   7455
      Left            =   6000
      TabIndex        =   1
      Top             =   1200
      Width           =   5940
      _ExtentX        =   10478
      _ExtentY        =   13150
      _Version        =   393217
      Indentation     =   353
      LineStyle       =   1
      Style           =   7
      Checkboxes      =   -1  'True
      FullRowSelect   =   -1  'True
      Appearance      =   1
   End
   Begin MSComctlLib.TreeView tvA 
      Height          =   7455
      Left            =   0
      TabIndex        =   0
      Top             =   1200
      Width           =   5940
      _ExtentX        =   10478
      _ExtentY        =   13150
      _Version        =   393217
      Indentation     =   353
      LineStyle       =   1
      Style           =   7
      Checkboxes      =   -1  'True
      FullRowSelect   =   -1  'True
      Appearance      =   1
   End
   Begin VB.Shape Shape3 
      BackColor       =   &H80000010&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      BorderStyle     =   0  'Transparent
      Height          =   390
      Left            =   -6120
      Top             =   755
      Width           =   12075
   End
   Begin VB.Shape Shape2 
      BackColor       =   &H80000010&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      BorderStyle     =   0  'Transparent
      Height          =   385
      Left            =   6000
      Top             =   745
      Width           =   12075
   End
   Begin VB.Line Line8 
      BorderColor     =   &H80000014&
      X1              =   -60
      X2              =   11955
      Y1              =   9135
      Y2              =   9135
   End
   Begin VB.Line Line7 
      X1              =   -60
      X2              =   11955
      Y1              =   9120
      Y2              =   9120
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000014&
      X1              =   -60
      X2              =   11955
      Y1              =   8715
      Y2              =   8715
   End
   Begin VB.Line Line5 
      X1              =   -60
      X2              =   11955
      Y1              =   8700
      Y2              =   8700
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000014&
      X1              =   -60
      X2              =   11955
      Y1              =   1155
      Y2              =   1155
   End
   Begin VB.Line Line3 
      X1              =   -60
      X2              =   11955
      Y1              =   1140
      Y2              =   1140
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   -60
      X2              =   11955
      Y1              =   735
      Y2              =   735
   End
   Begin VB.Line Line1 
      X1              =   -60
      X2              =   11955
      Y1              =   720
      Y2              =   720
   End
   Begin VB.Label lbServerB 
      BackColor       =   &H80000010&
      Caption         =   "Server B"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   195
      Left            =   6060
      TabIndex        =   5
      Top             =   60
      Width           =   5355
   End
   Begin VB.Label lbServerA 
      BackColor       =   &H8000000C&
      Caption         =   "Server A"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   195
      Left            =   60
      TabIndex        =   4
      Top             =   60
      Width           =   5355
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H80000010&
      BackStyle       =   1  'Opaque
      BorderColor     =   &H80000010&
      BorderStyle     =   0  'Transparent
      Height          =   375
      Left            =   -60
      Top             =   -60
      Width           =   12075
   End
End
Attribute VB_Name = "fDBCompare"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fDBCompare
' 12-04-2004

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fDBCompare"
' estructuras
' variables privadas
Private m_ObjCompare    As cDBCompare
Private m_bNoNodeClick  As Boolean
Private m_bNoNodeCheck  As Boolean
' eventos
Public Event Save()
Public Event ConnectA()
Public Event ConnectB()
Public Event Compare()
Public Event Cancel(ByRef bCancel As Boolean)
Public Event Generate()
Public Event ShowNodes(ByVal bOnlyMismatch As Boolean, ByVal bIndex As Boolean)
Public Event LoadApply()
' propiedades publicas
' propiedades friend
Friend Property Set ObjCompare(ByRef rhs As cDBCompare)
  Set m_ObjCompare = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Sub chkIndex_Click()
  RaiseEvent ShowNodes(chkOnlyMismatch.Value = vbChecked, chkIndex.Value = vbChecked)
End Sub

Private Sub chkOnlyMismatch_Click()
  RaiseEvent ShowNodes(chkOnlyMismatch.Value = vbChecked, chkIndex.Value = vbChecked)
End Sub

Private Sub cmdApply_Click()
  RaiseEvent LoadApply
End Sub

Private Sub cmdExpandColapse_Click()
  On Error GoTo ControlError
  
  Dim bExpand As Boolean
  
  tvA.Visible = False
  tvB.Visible = False
  
  With cmdExpandColapse
  
    If .Tag = "" Then
      .Caption = "Colapsar"
      .Tag = "1"
      bExpand = True
    Else
      .Caption = "Expandir"
      .Tag = ""
      bExpand = False
    End If
  
  End With
  
  pExpandColapse bExpand, tvA
  pExpandColapse bExpand, tvB
  
  GoTo ExitProc
ControlError:
  MngError Err, "cmdExpandColapse_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next

  tvA.Visible = True
  tvB.Visible = True
End Sub

Private Sub pExpandColapse(ByVal bExpand As Boolean, ByRef Tree As TreeView)
  Dim Node    As Node
  Dim v       As Variant
  
  For Each Node In Tree.Nodes
  
    v = Split(Node.FullPath, "\")
    If UBound(v) < 3 Then
      Node.Expanded = bExpand
    End If
  Next
  
  If Tree.Nodes.Count = 0 Then Exit Sub
  
  Tree.Nodes.Item(1).EnsureVisible
End Sub

Private Sub cmdOpenCompare_Click()
  CDialog.Filter = "Archivos txt (*.txt)|*.txt|Todos los archivos (*.*)|*.*|"
  CDialog.FilterIndex = 2
  CDialog.ShowSave
  txFileCompare.Text = CDialog.FileName
End Sub

Private Sub cmdOpenFile_Click()
  CDialog.Filter = "Todos los archivos (*.*)|*.*|Archivos SQL (*.sql)|*.sql|"
  CDialog.FilterIndex = 2
  CDialog.ShowSave
  txFile.Text = CDialog.FileName
End Sub

Private Sub cmdSave_Click()
  RaiseEvent Save
End Sub

Private Sub cmdServerA_Click()
  RaiseEvent ConnectA
End Sub

Private Sub cmdServerB_Click()
  RaiseEvent ConnectB
End Sub

Private Sub cmdCompare_Click()
  On Error GoTo ControlError
  
  Dim bCancel As Boolean
  
  tvA.Visible = False
  tvB.Visible = False
  
  If cmdCompare.Tag = "" Then
    cmdCompare.Tag = "1"
    cmdCompare.Caption = "Cancelar"
    RaiseEvent Compare
  Else
    RaiseEvent Cancel(bCancel)
    If bCancel Then Exit Sub
  End If
  cmdCompare.Tag = ""
  cmdCompare.Caption = "Comparar"

  GoTo ExitProc
ControlError:
  MngError Err, "cmdCompare_Click", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  tvA.Visible = True
  tvB.Visible = True
End Sub

Private Sub cmdGenerate_Click()
  RaiseEvent Generate
End Sub

Private Sub tvA_NodeCheck(ByVal Node As MSComctlLib.Node)
  On Error GoTo ControlError

  If m_bNoNodeCheck Then Exit Sub
  m_bNoNodeCheck = True
  
  If Node.Checked Then
    tvB.Nodes.Item(GetLcaseKey(Node.Key)).Checked = False
  End If
  pSelectNode Node, Node.Checked, tvB
  If Node.Checked Then
    pSelectNodePhater Node
  Else
    pDesSelectNodePhater Node
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "tvA_NodeCheck", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  m_bNoNodeCheck = False
End Sub

Private Sub tvB_NodeCheck(ByVal Node As MSComctlLib.Node)
  On Error GoTo ControlError

  If m_bNoNodeCheck Then Exit Sub
  m_bNoNodeCheck = True
  
  If Node.Checked Then
    tvA.Nodes.Item(GetLcaseKey(Node.Key)).Checked = False
  End If
  pSelectNode Node, Node.Checked, tvA
  If Node.Checked Then
    pSelectNodePhater Node
  Else
    pDesSelectNodePhater Node
  End If
  
  GoTo ExitProc
ControlError:
  MngError Err, "tvB_NodeCheck", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  m_bNoNodeCheck = False
End Sub

Private Sub pSelectNodePhater(ByRef Child As Node)
  Dim Node As Node
  
  If Child Is Nothing Then Exit Sub
  
  Set Node = Child.Parent
  
  pSelectNodePhater Node
  
  If Node Is Nothing Then Exit Sub
  
  Node.Checked = True
End Sub

Private Sub pDesSelectNodePhater(ByRef Child As Node)
  Dim Node As Node
  
  If Child Is Nothing Then Exit Sub
  
  Set Node = Child.Parent
  
  If Node Is Nothing Then Exit Sub
  
  If Not pDesSelectNodePhaterAux(Node) Then
    Node.Checked = False
  End If
  
  pDesSelectNodePhater Node
End Sub

Private Function pDesSelectNodePhaterAux(ByRef Node As Node) As Boolean
  Dim Child As Node
  
  If Node Is Nothing Then Exit Function
  
  Set Child = Node.Child
  
  If pDesSelectNodePhaterAux(Child) Then
    pDesSelectNodePhaterAux = True
    Exit Function
  End If
  
  If Child Is Nothing Then Exit Function
  
  If Child.Checked Then
    pDesSelectNodePhaterAux = True
    Exit Function
  End If
  
  Do While Not Child Is Nothing
    Set Child = Child.Next
    
    If Child Is Nothing Then Exit Do

    If Child.Checked Then
      pDesSelectNodePhaterAux = True
      Exit Function
    End If
    
    If pDesSelectNodePhaterAux(Child) Then
      pDesSelectNodePhaterAux = True
      Exit Function
    End If
    
    If Child Is Child.LastSibling Then Exit Do
  Loop
End Function

Private Sub pSelectNode(ByRef Root As MSComctlLib.Node, ByVal bState As Boolean, ByRef Tree As TreeView)
  Dim Node As Node
  
  pSelectNodeAux Root, bState, Tree
  
  Set Node = Root.Child
  
  If Node Is Nothing Then Exit Sub
  
  pSelectNode Node, bState, Tree
  
  Do While Not Node Is Nothing
    
    pSelectNodeAux Node, bState, Tree
    
    If Node Is Node.LastSibling Then Exit Do
    
    Set Node = Node.Next
    
    If Node Is Nothing Then Exit Do
    
    pSelectNode Node, bState, Tree
  Loop
End Sub

Private Sub pSelectNodeAux(ByRef Node As MSComctlLib.Node, ByVal bState As Boolean, ByRef Tree As TreeView)
  Node.Checked = bState

  If bState Then
    With Tree.Nodes.Item(GetLcaseKey(Node.Key))
      .Checked = False
      .BackColor = vbWindowBackground
    End With
    Node.BackColor = vbYellow
  Else
    Node.BackColor = vbWindowBackground
  End If
End Sub

Private Sub tvA_NodeClick(ByVal Node As MSComctlLib.Node)
  On Error GoTo ControlError

  If m_bNoNodeClick Then Exit Sub
  m_bNoNodeClick = True
  
  With tvB.Nodes.Item(GetLcaseKey(Node.Key))
    .Selected = True
    .EnsureVisible
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "tvA_NodeClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  m_bNoNodeClick = False
End Sub

Private Sub tvB_NodeClick(ByVal Node As MSComctlLib.Node)
  On Error GoTo ControlError

  If m_bNoNodeClick Then Exit Sub
  m_bNoNodeClick = True
  
  With tvA.Nodes.Item(GetLcaseKey(Node.Key))
    .Selected = True
    .EnsureVisible
  End With
  
  GoTo ExitProc
ControlError:
  MngError Err, "tvA_NodeClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
  m_bNoNodeClick = False
End Sub
' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError

  sbMessages.Panels.Clear
  sbMessages.Panels.Add().AutoSize = sbrSpring
  With sbMessages.Panels.Add()
    .AutoSize = sbrNoAutoSize
    .Width = 400
  End With
  With sbMessages.Panels.Add()
    .AutoSize = sbrNoAutoSize
    .Width = 400
  End With
  sbMessages.Panels.Add().Style = sbrDate
  sbMessages.Panels.Add().Style = sbrTime

  tvA.HideSelection = False
  tvB.HideSelection = False
  
  tvA.ImageList = imlTree
  tvB.ImageList = imlTree
  
  FormCenter Me

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_Unload(Cancel As Integer)
  On Error GoTo ControlError
  Set m_ObjCompare = Nothing
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
