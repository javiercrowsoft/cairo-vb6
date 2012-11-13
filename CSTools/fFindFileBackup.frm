VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form fFindFileBackup 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Ubicar archivo de backup"
   ClientHeight    =   5445
   ClientLeft      =   45
   ClientTop       =   360
   ClientWidth     =   3795
   Icon            =   "fFindFileBackup.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5445
   ScaleWidth      =   3795
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin MSComctlLib.ImageList ilDir 
      Left            =   45
      Top             =   5085
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
            Picture         =   "fFindFileBackup.frx":000C
            Key             =   ""
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fFindFileBackup.frx":05A8
            Key             =   ""
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "fFindFileBackup.frx":0B44
            Key             =   ""
         EndProperty
      EndProperty
   End
   Begin VB.TextBox txBackupFile 
      Height          =   375
      Left            =   45
      TabIndex        =   3
      Top             =   4590
      Width           =   3705
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancelar"
      Height          =   330
      Left            =   2475
      TabIndex        =   2
      Top             =   5085
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "&Aceptar"
      Height          =   330
      Left            =   990
      TabIndex        =   1
      Top             =   5085
      Width           =   1275
   End
   Begin MSComctlLib.TreeView tvDir 
      Height          =   3975
      Left            =   45
      TabIndex        =   0
      Top             =   45
      Width           =   3705
      _ExtentX        =   6535
      _ExtentY        =   7011
      _Version        =   393217
      Indentation     =   353
      LineStyle       =   1
      Style           =   7
      Appearance      =   1
   End
   Begin VB.Label lbSelectedPath 
      BorderStyle     =   1  'Fixed Single
      Height          =   375
      Left            =   45
      TabIndex        =   4
      Top             =   4095
      Width           =   3705
   End
End
Attribute VB_Name = "fFindFileBackup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
'--------------------------------------------------------------------------------
' fFindFileBackup
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
Private Const C_Module = "fFindFileBackup."
Private Const c_close_folder = 1
Private Const c_open_folder = 2
Private Const c_file = 3
' estructuras
' variables privadas
Private m_NextKey       As Long
Private m_Leave         As Boolean
Private m_Ok            As Boolean
Private m_srv           As SQLDMO.SQLServer
' eventos
' propiedadades publicas
Public Property Get Ok() As Boolean
  Ok = m_Ok
End Property

Public Property Get PathAndFileName() As String
  PathAndFileName = FileGetValidPath(lbSelectedPath) & txBackupFile.Text
End Property

Public Property Set Server(ByRef rhs As SQLDMO.SQLServer)
  Set m_srv = rhs
End Property

' propiedadades friend
' propiedades privadas
' funciones publicas
Public Function LoadDrives() As Boolean
  On Error GoTo ControlError
  
  Dim qrslt     As SQLDMO.QueryResults
  Dim i         As Integer
  Dim Drive     As String
  Dim fso       As FileSystemObject
  Dim fsoDrives As Drives
  Dim fsoDrive  As Drive
  Dim sKey      As String
  
  If LCase(m_srv.Name) = LCase(GetComputerName()) Then
    Set fso = New FileSystemObject
    
    Set fsoDrives = fso.Drives
    
    For Each fsoDrive In fsoDrives
      Select Case fsoDrive.DriveType
        
        '0 Unknown 1 Removable Drive 3 Remote Disk 4 CDRom Drive 5 RAM Disk
        Case 0, 1, 3, 4, 5
          ' Estos no sirven
        
        ' 2 Fixed Disk
        Case 2
        
          Drive = fsoDrive.RootFolder
          Drive = Left(Drive, Len(Drive) - 1)
          sKey = AddNode("", Drive)
          tvDir_NodeClick tvDir.Nodes(sKey)
          
      End Select
    Next
    
    Set fsoDrives = Nothing
  
  Else
    With m_srv
    
      Set qrslt = .EnumAvailableMedia(SQLDMOMedia_FixedDisk)
      
      For i = 1 To qrslt.Rows
      
        Drive = qrslt.GetColumnString(i, 1)
        Drive = Left(Drive, Len(Drive) - 1)
        sKey = AddNode("", Drive)
        tvDir_NodeClick tvDir.Nodes(sKey)
        
      Next i
    End With
  End If
  
  LoadDrives = True
  GoTo ExitProc
ControlError:
  MngError Err, "LoadDrives", C_Module, ""
  If Err.Number <> 0 Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Function

' funciones friend
' funciones privadas

Private Function LoadFolders(ByVal FolderPath As String, ByVal NodeFather As String) As Boolean
  On Error GoTo ControlError
  
  Dim qrslt         As SQLDMO.QueryResults
  Dim i             As Integer
  Dim File          As String
  Dim Path2         As String
  Dim Folder        As String
  Dim vFolders()   As String
  
  ReDim vFolders(0)
  
  If LCase(m_srv.Name) = LCase(GetComputerName()) Then
    
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
    
  Else
    With m_srv
        
      Set qrslt = .EnumDirectories(FolderPath)
      
      For i = 1 To qrslt.Rows
        
        ' Obtengo la carpeta
        Folder = qrslt.GetColumnString(i, 1)
        ReDim Preserve vFolders(UBound(vFolders) + 1)
        vFolders(UBound(vFolders)) = Folder
        
      Next i
    End With
  End If
  
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

  Dim qrslt     As SQLDMO.QueryResults
  Dim i         As Integer
  Dim Path2     As String
  Dim File      As String
  Dim vFiles()  As String
  
  ReDim vFiles(0)
  
  Path2 = tvDir.Nodes(Folder).FullPath
  
  If UCase(m_srv.Name) = UCase(GetComputerName()) Then
    
    ' Obtengo el path del siguiente hijo
    File = Dir(FileGetValidPath(Path2) & "*.*", vbArchive)
  
    While File <> ""
        
      ReDim Preserve vFiles(UBound(vFiles) + 1)
      vFiles(UBound(vFiles)) = File
      
      File = Dir
    Wend
  
  Else
  
    Set qrslt = m_srv.CommandShellWithResults("dir /b/aa-d " & Path2)
    
    For i = 1 To qrslt.Rows
            
      ' Obtengo el path del siguiente hijo
      File = qrslt.GetColumnString(i, 1)
      If LCase(Trim(File)) <> "file not found" And _
         LCase(Trim(File)) <> "the system cannot find the path especified." And _
         LCase(Trim(File)) <> "no se encuentra el archivo" And _
         LCase(Trim(File)) <> "el sistema no puede hallar la ruta especificada." And _
         LCase(Trim(File)) <> "el sistema no puede hallar el archivo especificado." And _
         Trim(File) <> "" Then
      
        ReDim Preserve vFiles(UBound(vFiles) + 1)
        vFiles(UBound(vFiles)) = File
        
      End If
    Next i
  End If
  
  Sort vFiles()
  
  For i = 1 To UBound(vFiles)
    AddNode Folder, vFiles(i), True
  Next

  
ControlError:
End Sub

Private Function AddNode(ByVal KeyFather As String, ByVal Text As String, Optional IsFile As Boolean = False) As String
  Dim Node As Node
  Dim Key As String
  
  With tvDir
  
    ' Incremento la clave
    m_NextKey = m_NextKey + 1
    Key = "KEY " + Trim(m_NextKey)
    
    ' Agrego el Node al arbol
    If Not KeyFather = "" Then
        Set Node = .Nodes.Add(KeyFather, tvwChild, Key, Text, c_close_folder)
    Else
        Set Node = .Nodes.Add(, , Key, Text, c_close_folder)
    End If
            
    ' Seteo su imagen cuando esta colapsada
    Node.ExpandedImage = c_open_folder
    
    If IsFile Then
      Node.ExpandedImage = c_file
      Node.Image = c_file
      Node.Tag = "Leave"
    End If
  End With
  
  AddNode = Key
End Function

Private Sub tvDir_NodeClick(ByVal Node As MSComctlLib.Node)
  On Error GoTo ControlError
  
  Dim Node2 As Node
  m_Leave = False
  
  With Node
  
    lbSelectedPath.Caption = .FullPath
    
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
    
      LoadFolders .FullPath, .Key
      
      Set Node2 = .Child
      
      While Not Node2 Is Nothing
      
        If Node2.Tag = "" Then
          AddNode Node2.Key, "Vacio%%%@@@!!!", True
          Node2.Tag = "preloaded"
        End If
        Set Node2 = Node2.Next
      Wend

      LoadFiles .Key
      
      .Tag = "loaded"
      lbSelectedPath.Caption = .FullPath
  
    ElseIf .Tag = "Leave" Then
      
      m_Leave = True
      lbSelectedPath.Caption = FileGetPath(.FullPath)
      txBackupFile.Text = FileGetName(.FullPath)
    
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

Private Sub tvDir_Collapse(ByVal Node As MSComctlLib.Node)
    lbSelectedPath.Caption = Node.FullPath
End Sub

Private Sub tvDir_Expand(ByVal Node As MSComctlLib.Node)
  tvDir_NodeClick Node
End Sub

Private Sub tvDir_KeyUp(KeyCode As Integer, Shift As Integer)
  lbSelectedPath.Caption = tvDir.SelectedItem.FullPath
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
  m_Ok = False
  Hide
End Sub

Private Sub cmdOk_Click()
  m_Ok = True
  Hide
End Sub
' construccion - destruccion
Private Sub Form_Load()
  On Error GoTo ControlError
  
  Set tvDir.ImageList = ilDir
  m_NextKey = 0
  m_Ok = False
  
  FormCenter Me

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


