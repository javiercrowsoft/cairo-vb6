VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form fTask 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Configuración de Tarea de Backup"
   ClientHeight    =   8235
   ClientLeft      =   45
   ClientTop       =   345
   ClientWidth     =   7485
   Icon            =   "fTask.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8235
   ScaleWidth      =   7485
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txZips 
      Height          =   315
      Left            =   6120
      TabIndex        =   26
      Top             =   1380
      Width           =   615
   End
   Begin VB.TextBox txFtpPort 
      Height          =   315
      Left            =   6660
      TabIndex        =   22
      Text            =   "21"
      Top             =   3240
      Width           =   435
   End
   Begin VB.TextBox txFtpPwd 
      Height          =   315
      IMEMode         =   3  'DISABLE
      Left            =   5040
      PasswordChar    =   "*"
      TabIndex        =   21
      Top             =   3240
      Width           =   1575
   End
   Begin VB.TextBox txFtpUser 
      Height          =   315
      Left            =   3420
      TabIndex        =   20
      Text            =   "anonymous"
      Top             =   3240
      Width           =   1575
   End
   Begin VB.TextBox txFtpAddress 
      Height          =   315
      Left            =   60
      TabIndex        =   19
      Top             =   3240
      Width           =   3315
   End
   Begin VB.PictureBox picLoadingFolder 
      BorderStyle     =   0  'None
      Height          =   1675
      Left            =   900
      ScaleHeight     =   1680
      ScaleWidth      =   5340
      TabIndex        =   16
      Top             =   4860
      Visible         =   0   'False
      Width           =   5335
      Begin VB.Label Label5 
         Caption         =   "Cargando las carpetas ..."
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   495
         Left            =   480
         TabIndex        =   17
         Top             =   540
         Width           =   4335
      End
      Begin VB.Shape Shape2 
         BorderColor     =   &H80000003&
         BorderWidth     =   2
         Height          =   1635
         Left            =   30
         Top             =   30
         Width           =   5295
      End
   End
   Begin VB.CommandButton cmdEdit 
      Caption         =   "..."
      Height          =   315
      Left            =   6840
      TabIndex        =   5
      Top             =   4140
      Width           =   375
   End
   Begin VB.TextBox txCode 
      Height          =   315
      Left            =   1800
      TabIndex        =   1
      Top             =   1380
      Width           =   1695
   End
   Begin VB.CommandButton cmdSaveAs 
      Caption         =   "G&uardar Como"
      Height          =   315
      Left            =   120
      TabIndex        =   7
      Top             =   7740
      Width           =   1575
   End
   Begin VB.CommandButton cmdOpenFile 
      Caption         =   "..."
      Height          =   315
      Left            =   6840
      TabIndex        =   3
      Top             =   1740
      Width           =   375
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "&Guardar"
      Height          =   315
      Left            =   3780
      TabIndex        =   8
      Top             =   7740
      Width           =   1575
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cerrar"
      Height          =   315
      Left            =   5460
      TabIndex        =   9
      Top             =   7740
      Width           =   1575
   End
   Begin VB.TextBox txDescrip 
      Height          =   615
      Left            =   1800
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   4
      Top             =   2100
      Width           =   4935
   End
   Begin VB.TextBox txFile 
      Height          =   315
      Left            =   1800
      TabIndex        =   2
      Top             =   1740
      Width           =   4935
   End
   Begin VB.TextBox txName 
      Height          =   315
      Left            =   1800
      TabIndex        =   0
      Top             =   1020
      Width           =   4935
   End
   Begin MSComDlg.CommonDialog dlg 
      Left            =   6900
      Top             =   2280
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComctlLib.ImageList ilDir 
      Left            =   6900
      Top             =   1020
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   3
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTask.frx":058A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTask.frx":0B26
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fTask.frx":10C2
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.TreeView tvDir 
      Height          =   3375
      Left            =   120
      TabIndex        =   6
      Top             =   4140
      Width           =   6645
      _ExtentX        =   11721
      _ExtentY        =   5953
      _Version        =   393217
      Indentation     =   353
      LabelEdit       =   1
      LineStyle       =   1
      Style           =   7
      Appearance      =   1
   End
   Begin VB.Label Label6 
      Caption         =   "Cantidad de Zips:"
      Height          =   255
      Left            =   4740
      TabIndex        =   27
      Top             =   1440
      Width           =   1335
   End
   Begin VB.Label Label10 
      Caption         =   "Puerto"
      Height          =   255
      Left            =   6660
      TabIndex        =   25
      Top             =   2940
      Width           =   1395
   End
   Begin VB.Label Label9 
      Caption         =   "Clave"
      Height          =   255
      Left            =   5040
      TabIndex        =   24
      Top             =   2940
      Width           =   1395
   End
   Begin VB.Label Label8 
      Caption         =   "Usuario"
      Height          =   255
      Left            =   3480
      TabIndex        =   23
      Top             =   2940
      Width           =   1395
   End
   Begin VB.Label Label7 
      Caption         =   "Dirección FTP"
      Height          =   255
      Left            =   60
      TabIndex        =   18
      Top             =   2940
      Width           =   1395
   End
   Begin VB.Line Line6 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   11000
      Y1              =   2820
      Y2              =   2820
   End
   Begin VB.Line Line5 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   11000
      Y1              =   2835
      Y2              =   2835
   End
   Begin VB.Line Line4 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   11000
      Y1              =   3660
      Y2              =   3660
   End
   Begin VB.Line Line3 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   11000
      Y1              =   3675
      Y2              =   3675
   End
   Begin VB.Label Label4 
      Caption         =   "Archivos a incluir en la copia de resguardo"
      Height          =   255
      Left            =   60
      TabIndex        =   15
      Top             =   3840
      Width           =   3135
   End
   Begin VB.Label lbCode 
      Caption         =   "Código:"
      Height          =   255
      Left            =   120
      TabIndex        =   14
      Top             =   1440
      Width           =   735
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   0
      X2              =   8000
      Y1              =   7620
      Y2              =   7620
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   0
      X2              =   8000
      Y1              =   7635
      Y2              =   7635
   End
   Begin VB.Label Label3 
      Caption         =   "Nombre del Archivo:"
      Height          =   255
      Left            =   120
      TabIndex        =   13
      Top             =   1800
      Width           =   1695
   End
   Begin VB.Label Label2 
      Caption         =   "Descripción:"
      Height          =   255
      Left            =   120
      TabIndex        =   12
      Top             =   2160
      Width           =   1095
   End
   Begin VB.Label lb 
      Caption         =   "Titulo:"
      Height          =   255
      Left            =   120
      TabIndex        =   11
      Top             =   1080
      Width           =   735
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Configuración de Tareas de Backup"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   1800
      TabIndex        =   10
      Top             =   120
      UseMnemonic     =   0   'False
      Width           =   4935
   End
   Begin VB.Image Image1 
      Height          =   720
      Left            =   360
      Picture         =   "fTask.frx":121C
      Top             =   120
      Width           =   720
   End
   Begin VB.Shape Shape1 
      BackColor       =   &H00FFFFFF&
      BackStyle       =   1  'Opaque
      BorderStyle     =   0  'Transparent
      Height          =   975
      Left            =   0
      Top             =   0
      Width           =   7480
   End
End
Attribute VB_Name = "fTask"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_Changed As Boolean

Private WithEvents m_fExplorer As fExplorer
Attribute m_fExplorer.VB_VarHelpID = -1

Public Function Edit(ByVal TaskFile As String) As Boolean
  
  If TaskFile <> vbNullString Then
    
    Dim Task As cTask
    
    Set Task = New cTask
    
    If Not Task.Load(TaskFile, False) Then
      Exit Function
    End If
    
    With Me
      .txCode.Text = Task.Code
      .txDescrip.Text = Task.Descrip
      .txFile.Text = Task.File
      .txName.Text = Task.Name
      .txZips.Text = Task.ZipFiles
      
      .txFtpAddress.Text = Task.FtpAddress
      .txFtpUser.Text = Task.FtpUser
      .txFtpPwd.Text = Task.FtpPwd
      .txFtpPort.Text = Task.FtpPort
      
      .txCode.Enabled = False
    End With
    
    pLoadFolders Task
  
  End If
  
  m_Changed = False
  
  fTask.Show vbModal
  
End Function

Private Sub cmdCancel_Click()
  Unload Me
End Sub

Private Sub cmdEdit_Click()
  Dim mouse As cMouseWait
  Set mouse = New cMouseWait
  picLoadingFolder.Visible = True
  DoEvents
  Set m_fExplorer = fExplorer
  fExplorer.LoadDrives
  pLoadTaskItems fExplorer
  picLoadingFolder.Visible = False
  Set mouse = Nothing
  fExplorer.Show vbModal
  If fExplorer.Ok Then
    pSetFiles
  End If
  Unload fExplorer
  Set m_fExplorer = Nothing
End Sub

Private Sub cmdOpenFile_Click()

  With dlg
    .Filter = "Archivos de Backup de CrowSoft|*.cszip"
    .ShowOpen
    If .FileName <> vbNullString Then
      txFile.Text = .FileName
    End If
  End With
End Sub

Private Sub cmdSave_Click()
  pSave
End Sub

Private Sub cmdSaveAs_Click()
  Dim TaskName As String
  TaskName = InputBox("Ingrese el nombre", "Guardar Como", "Nueva Tarea")
  If LenB(TaskName) Then
    txCode.Text = TaskName
    pSave
  End If
End Sub

Private Sub Form_Load()
  FormLoad Me, False
  Set tvDir.ImageList = ilDir
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  Dim Rslt As VbMsgBoxResult
  
  If m_Changed Then
    Rslt = MsgBox("Desea guardar los cambios?", vbQuestion + vbYesNoCancel)
    If Rslt = vbCancel Then
      Cancel = True
    ElseIf Rslt = vbYes Then
      If Not pSave Then
        Cancel = True
      End If
    End If
  End If

End Sub

Private Sub Form_Unload(Cancel As Integer)
  Set m_fExplorer = Nothing
  FormUnload Me, False
End Sub

Private Sub m_fExplorer_UpdateNode(Node As MSComctlLib.Node)
  pUpdateNode Node
End Sub

Private Sub txCode_Change()
  m_Changed = True
End Sub

Private Sub txDescrip_Change()
  m_Changed = True
End Sub

Private Sub txFile_Change()
  m_Changed = True
End Sub

Private Sub txName_Change()
  m_Changed = True
End Sub

Private Function Validate() As Boolean
  
  If txName.Text = "" Then
    Info "Debe indicar un nombre para la tarea"
    SetFocusControl txName
    Exit Function
  End If
  
  If txFile.Text = "" Then
    Info "Debe indicar el nombre del archivo de backup que sera generado por la tarea"
    SetFocusControl txFile
    Exit Function
  End If
  
  If txCode.Text = "" Then
    Info "Debe indicar un codigo para la tarea"
    SetFocusControl txCode
    Exit Function
  End If
  
  Validate = True
End Function

Private Function pSave() As Boolean
  
  If Not Validate() Then Exit Function
  
  Dim Task As cTask
  
  Set Task = New cTask
  
  With Me
    Task.Code = .txCode.Text
    Task.Descrip = .txDescrip.Text
    Task.File = .txFile.Text
    Task.Name = .txName.Text
    Task.ZipFiles = Val(txZips.Text)
    
    Task.FtpAddress = .txFtpAddress.Text
    Task.FtpUser = .txFtpUser.Text
    Task.FtpPwd = .txFtpPwd.Text
    Task.FtpPort = Val(.txFtpPort.Text)
  End With
  
  pAddFolders Task
  
  If Task.Save Then
    m_Changed = False
    pSave = True
  End If
End Function

Private Sub pSetFiles()
  Dim Node   As Node
  Dim Parent As Node
  
  tvDir.Nodes.Clear
  
  For Each Node In fExplorer.tvDir.Nodes
    If Node.Checked Then
      Node.Tag = 1
    Else
      Node.Tag = 0
    End If
  Next
  
  For Each Node In fExplorer.tvDir.Nodes
    If Node.Checked Then
      Set Parent = Node.Parent
      While Not Parent Is Nothing
        Parent.Checked = True
        Set Parent = Parent.Parent
      Wend
    End If
  Next

  Set Node = fExplorer.tvDir.Nodes.Item(1)

  pSetFilesAux Node, Nothing
End Sub

Private Sub pSetFilesAux(ByRef NodeAux As Node, _
                         ByRef Parent As Node)

  Dim Node    As Node
  Dim NewNode As Node
  
  Set Node = NodeAux

  If Node.Checked Then
    If Parent Is Nothing Then
      Set NewNode = tvDir.Nodes.Add(, , , Node.Text, _
                                          IIf(Node.Image > 3, Node.Image - 3, Node.Image))
    Else
      Set NewNode = tvDir.Nodes.Add(Parent, _
                                    tvwChild, , _
                                    Node.Text, _
                                    IIf(Node.Image > 3, Node.Image - 3, Node.Image))
    End If
    NewNode.Tag = Node.Tag
    
    If Node.Children Then
      pSetFilesAux Node.Child, NewNode
    End If
  End If
  
  Set Node = Node.Next
  If Not Node Is Nothing Then
    pSetFilesAux Node, Parent
  End If
End Sub

Private Sub pAddFolders(ByRef Task As cTask)
  
  If tvDir.Nodes.Count Then
    
    Dim TaskItem As cTaskItem
    Dim Node     As Node
    
    Set Node = tvDir.Nodes.Item(1)
    
    While Not Node Is Nothing
       
      If Node.Parent Is Nothing Then
        Set TaskItem = New cTaskItem
        Task.Folders.Add TaskItem
      End If
      
      TaskItem.Name = Node.Text
      TaskItem.ItemType = IIf(Node.Image = 1 Or Node.Image = 2, _
                              csEIT_Folder, _
                              csEIT_File)
      TaskItem.Checked = Val(Node.Tag)
      
      If Node.Children Then
        pAddFolderAux Node.Child, TaskItem
      End If
      
      Set Node = Node.Next
      
    Wend
    
  End If

End Sub

Private Sub pAddFolderAux(ByRef NodeAux As Node, _
                          ByRef Parent As cTaskItem)
  Dim Node     As Node
  Dim TaskItem As cTaskItem
  
  Set Node = NodeAux
  
  While Not Node Is Nothing
    
    Set TaskItem = New cTaskItem
    Parent.Children.Add TaskItem
    TaskItem.Name = Node.Text
    TaskItem.ItemType = IIf(Node.Image = 1 Or Node.Image = 2, _
                            csEIT_Folder, _
                            csEIT_File)
    TaskItem.Checked = Val(Node.Tag)
    
    If Node.Children Then
      pAddFolderAux Node.Child, TaskItem
    End If
    
    Set Node = Node.Next
  Wend
  
End Sub

Private Sub pLoadFolders(ByRef Task As cTask)
  Dim TaskItem As cTaskItem
  Dim Node     As Node
  
  For Each TaskItem In Task.Folders
    Set Node = pAddNode(TaskItem.Name, c_close_folder, Nothing, TaskItem.Checked)
    If TaskItem.Children.Count Then
      pLoadFoldersAux TaskItem.Children, Node
    End If
  Next
End Sub

Private Sub pLoadFoldersAux(ByRef TaskItems As Collection, _
                            ByRef NodeFather As Node)
  Dim TaskItem As cTaskItem
  Dim Node     As Node
  
  For Each TaskItem In TaskItems
    If TaskItem.ItemType = csEIT_File Then
      
      pAddNode TaskItem.Name, c_file, NodeFather, TaskItem.Checked
    
    Else
      
      Set Node = pAddNode(TaskItem.Name, _
                          c_close_folder, _
                          NodeFather, _
                          TaskItem.Checked)
                          
      If TaskItem.Children.Count Then
        pLoadFoldersAux TaskItem.Children, Node
      End If
    End If
  Next
End Sub

Private Function pAddNode(ByVal Text As String, _
                          ByVal Image As Integer, _
                          ByRef NodeFather As Node, _
                          ByVal Checked As Boolean) As Node
  Dim Node As Node
  If NodeFather Is Nothing Then
    Set Node = tvDir.Nodes.Add(, , , Text, Image)
    
  Else
    Set Node = tvDir.Nodes.Add(NodeFather, _
                                   tvwChild, , _
                                   Text, Image)
  End If
  
  Node.Tag = IIf(Checked, 1, 0)
  
  Set pAddNode = Node
End Function

Private Sub pUpdateNode(ByRef Node As Node)
  Dim Child As Node
  Set Child = Node.Child
  
  While Not Child Is Nothing
  
    pSetChecked Child
  
    Set Child = Child.Next
  Wend
End Sub

Private Sub pSetChecked(ByRef Node As Node)
  Dim taskNode As Node
  
  For Each taskNode In Me.tvDir.Nodes
    If Node.FullPath = taskNode.FullPath Then
      Node.Checked = Val(taskNode.Tag)
      Exit For
    End If
  Next
End Sub

Private Sub pLoadTaskItems(ByRef fExplorer As fExplorer)
  Dim taskNode    As Node
  Dim folderNode  As Node
  
  For Each taskNode In Me.tvDir.Nodes
    For Each folderNode In fExplorer.tvDir.Nodes
      If folderNode.FullPath = taskNode.FullPath Then
        If folderNode.Parent Is Nothing Then
          folderNode.Checked = Val(taskNode.Tag)
        End If
        If folderNode.Image <> c_file Then
          folderNode.Image = c_close_folder_selected
          folderNode.ExpandedImage = c_open_folder_selected
        End If
        fExplorer.ExpandNode folderNode
        Exit For
      End If
    Next
  Next

End Sub
