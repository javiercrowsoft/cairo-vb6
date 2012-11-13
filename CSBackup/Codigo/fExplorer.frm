VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fExplorer 
   Caption         =   "Ubicar archivo de backup"
   ClientHeight    =   5910
   ClientLeft      =   60
   ClientTop       =   375
   ClientWidth     =   5055
   Icon            =   "fExplorer.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5910
   ScaleWidth      =   5055
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Default         =   -1  'True
      Height          =   375
      Left            =   1740
      TabIndex        =   2
      Top             =   5400
      Width           =   1575
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancelar"
      Height          =   375
      Left            =   3420
      TabIndex        =   1
      Top             =   5400
      Width           =   1575
   End
   Begin MSComctlLib.ImageList ilDir 
      Left            =   3780
      Top             =   2160
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   5
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fExplorer.frx":038A
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fExplorer.frx":0926
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fExplorer.frx":0EC2
            Key             =   ""
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fExplorer.frx":101C
            Key             =   ""
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fExplorer.frx":13B6
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.TreeView tvDir 
      Height          =   5055
      Left            =   45
      TabIndex        =   0
      Top             =   45
      Width           =   4965
      _ExtentX        =   8758
      _ExtentY        =   8916
      _Version        =   393217
      Indentation     =   353
      LabelEdit       =   1
      LineStyle       =   1
      Style           =   7
      Checkboxes      =   -1  'True
      Appearance      =   1
   End
   Begin VB.Line Line1 
      BorderColor     =   &H80000010&
      X1              =   -1800
      X2              =   5220
      Y1              =   5220
      Y2              =   5220
   End
   Begin VB.Line Line2 
      BorderColor     =   &H80000014&
      X1              =   -1800
      X2              =   5220
      Y1              =   5235
      Y2              =   5235
   End
End
Attribute VB_Name = "fExplorer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fExplorer
' 15-05-2002

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "fExplorer."
' estructuras
' variables privadas
Private m_NextKey       As Long
Private m_Leaf         As Boolean
Private m_ok            As Boolean
' eventos
Public Event UpdateNode(ByRef Node As Node)
' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_ok
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function LoadDrives() As Boolean
  On Error GoTo ControlError
  
  Dim i         As Integer
  Dim Drive     As String
  Dim fso       As FileSystemObject
  Dim fsoDrives As Drives
  Dim fsoDrive  As Drive
  Dim sKey      As String
  
  tvDir.Nodes.Clear
  
  Set fso = New FileSystemObject
  Set fsoDrives = fso.Drives
  
  For Each fsoDrive In fsoDrives
    Select Case fsoDrive.DriveType
      
      '0 Unknown 1 Removable Drive 3 Remote Disk 4 CDRom Drive 5 RAM Disk
      Case 0, 1, 4, 5
        ' Estos no sirven
      
      ' 2 Fixed Disk
      Case 2, 3
      
        Drive = fsoDrive.RootFolder
        Drive = Left(Drive, Len(Drive) - 1)
        sKey = AddNode("", Drive)
        tvDir_NodeClick tvDir.Nodes(sKey)
        
    End Select
  Next
  
  Set fsoDrives = Nothing
  
  LoadDrives = True
  GoTo ExitProc
ControlError:
  MngError Err, "LoadDrives", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Public Sub ExpandNode(ByVal Node As MSComctlLib.Node)
  tvDir_NodeClick Node
End Sub

' funciones friend
' funciones privadas

Private Function LoadFolders(ByVal FolderPath As String, ByVal NodeFather As String) As Boolean
  On Error GoTo ControlError
  
  Dim i             As Integer
  Dim File          As String
  Dim Path2         As String
  Dim Folder        As String
  Dim vFolders()   As String
  
  ReDim vFolders(0)
     
  Path2 = FileGetValidPath(FolderPath)
  
  ' Obtengo el path del siguiente hijo
  Folder = Dir(Path2, vbDirectory)

  While Folder <> ""
    
    If Folder <> "." And Folder <> ".." And Folder <> "?" And Folder <> "pagefile.sys" Then
      
      If (GetAttr(FileGetValidPath(Path2) & Folder) And vbDirectory) = vbDirectory Then
      
        ReDim Preserve vFolders(UBound(vFolders) + 1)
        vFolders(UBound(vFolders)) = Folder
        
      End If
    End If
    
    Folder = Dir()
  Wend
  
  Sort vFolders()
  
  For i = 1 To UBound(vFolders)
    AddNode NodeFather, vFolders(i)
  Next
    
  LoadFolders = True
  GoTo ExitProc
ControlError:
  MngError Err, "LoadFolders", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

Private Sub LoadFiles(ByVal Folder As String)
  On Error GoTo ControlError

  Dim i         As Integer
  Dim Path2     As String
  Dim File      As String
  Dim vFiles()  As String
  
  ReDim vFiles(0)
  
  Path2 = tvDir.Nodes(Folder).FullPath
     
  ' Obtengo el path del siguiente hijo
  File = Dir(FileGetValidPath(Path2) & "*.*", vbArchive)

  While File <> ""
      
    ReDim Preserve vFiles(UBound(vFiles) + 1)
    vFiles(UBound(vFiles)) = File
    
    File = Dir
  Wend
   
  Sort vFiles()
  
  For i = 1 To UBound(vFiles)
    AddNode Folder, vFiles(i), True
  Next

  
ControlError:
End Sub

Private Function AddNode(ByVal KeyFather As String, ByVal Text As String, Optional IsFile As Boolean = False) As String
  Dim Node As Node
  Dim KEY As String
  
  With tvDir
  
    ' Incremento la clave
    m_NextKey = m_NextKey + 1
    KEY = "KEY " + Trim(m_NextKey)
    
    ' Agrego el Node al arbol
    If Not KeyFather = "" Then
        Set Node = .Nodes.Add(KeyFather, tvwChild, KEY, Text, c_close_folder)
    Else
        Set Node = .Nodes.Add(, , KEY, Text, c_close_folder)
    End If
            
    ' Seteo su imagen cuando esta colapsada
    Node.ExpandedImage = c_open_folder
    
    If IsFile Then
      Node.ExpandedImage = c_file
      Node.Image = c_file
      Node.Tag = "Leaf"
    End If
  End With
  
  AddNode = KEY
End Function

Private Sub Form_Resize()
  On Error Resume Next
  Line1.Y1 = Me.ScaleHeight - 540
  Line1.Y2 = Line1.Y1
  
  Line2.Y1 = Me.ScaleHeight - 520
  Line2.Y2 = Line2.Y1
  
  Line1.X2 = Me.ScaleWidth
  Line2.X2 = Line1.X2
  
  cmdCancel.Top = Me.ScaleHeight - 440
  cmdCancel.Left = Me.ScaleWidth - cmdCancel.Width - 100
  cmdOk.Top = cmdCancel.Top
  cmdOk.Left = cmdCancel.Left - cmdOk.Width - 100
  
  tvDir.Height = Me.ScaleHeight - tvDir.Top - 600
  tvDir.Width = Me.ScaleWidth - tvDir.Left * 2
End Sub

Private Sub Form_Unload(Cancel As Integer)
  FormUnload Me, False
End Sub

Private Sub tvDir_NodeClick(ByVal Node As MSComctlLib.Node)
  On Error GoTo ControlError
  
  Dim Node2 As Node
  m_Leaf = False
  
  With Node
    
    If .Tag = "" Or .Tag = "preloaded" Then
    
      If .Tag = "preloaded" Then
        Set Node2 = .Child
        
        Do While Not Node2 Is Nothing
        
          If Node2.Text = "Vacio%%%@@@!!!" Then
          
            tvDir.Nodes.Remove Node2.Index
            Exit Do
          End If
          Set Node2 = Node2.Next
        Loop
        
      End If
    
      LoadFolders .FullPath, .KEY
      
      Set Node2 = .Child
      
      While Not Node2 Is Nothing
      
        If Node2.Tag = "" Then
          AddNode Node2.KEY, "Vacio%%%@@@!!!", True
          Node2.Tag = "preloaded"
        End If
        Set Node2 = Node2.Next
      Wend

      LoadFiles .KEY
      
      RaiseEvent UpdateNode(Node)
      
      .Tag = "loaded"
    
    ElseIf .Tag = "Leaf" Then
      
      m_Leaf = True
     
    End If
  End With
  
  Exit Sub
  GoTo ExitProc
ControlError:
  MngError Err, "tvDir_NodeClick", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub tvDir_Expand(ByVal Node As MSComctlLib.Node)
  tvDir_NodeClick Node
End Sub

Private Sub Sort(ByRef vString() As String)
  Dim i As Integer
  Dim j As Integer
  Dim s As String
  
  vString(0) = ""
  
  For i = 2 To UBound(vString)
    j = i
    While LCase(vString(j)) < LCase(vString(j - 1))
      s = vString(j)
      vString(j) = vString(j - 1)
      vString(j - 1) = s
      j = j - 1
    Wend
  Next
  
End Sub

Private Sub cmdCancel_Click()
  m_ok = False
  Hide
End Sub

Private Sub cmdOk_Click()
  m_ok = True
  Hide
End Sub
' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  
  Set tvDir.ImageList = ilDir
  m_NextKey = 0
  m_ok = False
  
  FormLoad Me, False

  GoTo ExitProc
ControlError:
  MngError Err, "Form_Load", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  On Error GoTo ControlError

  If UnloadMode <> vbFormCode Then
    Cancel = True
    cmdCancel_Click
  End If

  GoTo ExitProc
ControlError:
  MngError Err, "Form_QueryUnload", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number <> 0 Then Resume ExitProc
'ExitProc:
'  On Error Resume Next


