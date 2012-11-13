VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cTask"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cTask
' 29-01-2006
'--------------------------------------------------------------------------------

Private m_Name     As String
Private m_File     As String
Private m_Descrip  As String
Private m_Code     As String
Private m_ZipFiles As Long

Private m_FtpAddress As String
Private m_FtpUser    As String
Private m_FtpPwd     As String
Private m_FtpPort    As Long

Private m_Folders  As Collection

Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get File() As String
  File = m_File
End Property

Public Property Let File(ByVal rhs As String)
  m_File = rhs
End Property

Public Property Get Descrip() As String
  Descrip = m_Descrip
End Property

Public Property Let Descrip(ByVal rhs As String)
  m_Descrip = rhs
End Property

Public Property Get Code() As String
  Code = m_Code
End Property

Public Property Let Code(ByVal rhs As String)
  m_Code = rhs
End Property

Public Property Get ZipFiles() As String
  ZipFiles = m_ZipFiles
End Property

Public Property Let ZipFiles(ByVal rhs As String)
  m_ZipFiles = rhs
End Property

Public Property Get FtpAddress() As String
  FtpAddress = m_FtpAddress
End Property

Public Property Let FtpAddress(ByVal rhs As String)
  m_FtpAddress = rhs
End Property

Public Property Get FtpUser() As String
  FtpUser = m_FtpUser
End Property

Public Property Let FtpUser(ByVal rhs As String)
  m_FtpUser = rhs
End Property

Public Property Get FtpPwd() As String
  FtpPwd = m_FtpPwd
End Property

Public Property Let FtpPwd(ByVal rhs As String)
  m_FtpPwd = rhs
End Property

Public Property Get FtpPort() As Long
  FtpPort = m_FtpPort
End Property

Public Property Let FtpPort(ByVal rhs As Long)
  m_FtpPort = rhs
End Property

Public Property Get Folders() As Collection
  Set Folders = m_Folders
End Property

Public Function Load(ByVal TaskFile As String, _
                     ByVal bSilent As Boolean, _
                     Optional ByRef strError As String) As Boolean
  Dim DocXml As cXml
  Set DocXml = New cXml
  
  DocXml.Init Nothing
  DocXml.Name = GetFileName_(TaskFile)
  DocXml.Path = GetPath_(TaskFile)
  
  If Not DocXml.OpenXml(bSilent, strError) Then Exit Function
  
  m_Name = ""
  m_Code = ""
  m_File = ""
  m_Descrip = ""
  
  Dim Root  As Object
  Dim Node  As Object
  Dim Prop  As Object
  
  Set Root = DocXml.GetRootNode()

  m_Name = pGetChildNodeProperty(Root, DocXml, "Name", "Value")
  m_Code = pGetChildNodeProperty(Root, DocXml, "Code", "Value")
  m_File = pGetChildNodeProperty(Root, DocXml, "File", "Value")
  m_ZipFiles = Val(pGetChildNodeProperty(Root, DocXml, "ZipFiles", "Value"))
  m_Descrip = pGetChildNodeProperty(Root, DocXml, "Descrip", "Value")
   
  m_FtpAddress = pGetChildNodeProperty(Root, DocXml, "FtpAddress", "Value")
  m_FtpUser = pGetChildNodeProperty(Root, DocXml, "FtpUser", "Value")
  m_FtpPwd = pGetChildNodeProperty(Root, DocXml, "FtpPwd", "Value")
  m_FtpPwd = DecryptData(m_FtpPwd, GetProgramPassword())
  m_FtpPort = Val(pGetChildNodeProperty(Root, DocXml, "FtpPort", "Value"))
   
  pLoadFolders DocXml, DocXml.GetNodeFromNode(Root, "Folders")
   
  Load = True
End Function

Public Function Save() As Boolean
  Dim DocXml    As cXml
  Dim dbPath    As String
  Dim Root      As Object
  
  Set DocXml = New cXml
  
  dbPath = GetIniValue(csSecConfig, _
                       csDbPath, _
                       vbNullString, _
                       GetIniFullFile(csIniFile))
  
  DocXml.Init Nothing
  DocXml.Name = m_Code & "_def.xml"
  DocXml.Path = dbPath

  If Not DocXml.NewXml() Then Exit Function
  
  Set Root = DocXml.GetRootNode()
  
  pAddTag DocXml, Root, "Name", m_Name
  pAddTag DocXml, Root, "Code", m_Code
  pAddTag DocXml, Root, "File", m_File
  pAddTag DocXml, Root, "ZipFiles", m_ZipFiles
  pAddTag DocXml, Root, "Descrip", m_Descrip
  pAddTag DocXml, Root, "TaskType", c_TaskTypeBackupFile

  Dim Password As String
  Password = GetProgramPassword()

  pAddTag DocXml, Root, "FtpAddress", m_FtpAddress
  pAddTag DocXml, Root, "FtpUser", m_FtpUser
  pAddTag DocXml, Root, "FtpPwd", EncryptData(m_FtpPwd, Password)
  pAddTag DocXml, Root, "FtpPort", m_FtpPort

  pSaveFolders pAddTag(DocXml, Root, "Folders", ""), _
               DocXml
  
  Save = DocXml.Save(False)
End Function

Private Sub pAddProp(ByRef xml As cXml, _
                     ByRef Node As Object, _
                     ByVal TagName As String, _
                     ByVal Value As Variant)
                    
  
  Dim Prop As cXmlProperty
 
  Set Prop = New cXmlProperty
  Prop.Name = TagName
  Prop.Value(csBoolean) = Value
  xml.AddPropertyToNode Node, Prop
End Sub

Private Sub pSaveFolders(ByVal NodeFolders As Object, _
                         ByRef DocXml As cXml)
  Dim TaskItem As cTaskItem
  Dim Node     As Object
  
  For Each TaskItem In m_Folders
  
    Set Node = pAddTag(DocXml, NodeFolders, "Folder", TaskItem.Name)
    pAddProp DocXml, Node, "Checked", TaskItem.Checked
  
    If TaskItem.Children.Count Then
      pSaveFoldersAux TaskItem.Children, _
                      pAddTag(DocXml, Node, "Folders", ""), _
                      pAddTag(DocXml, Node, "Files", ""), _
                      DocXml
    End If
  Next
End Sub

Private Sub pSaveFoldersAux(ByVal TaskItems As Collection, _
                            ByRef NodeFolders As Object, _
                            ByRef NodeFiles As Object, _
                            ByRef DocXml As cXml)
  Dim TaskItem As cTaskItem
  Dim Node     As Object
  
  For Each TaskItem In TaskItems
  
    If TaskItem.ItemType = csEIT_File Then
      Set Node = pAddTag(DocXml, NodeFiles, "File", TaskItem.Name)
    Else
      Set Node = pAddTag(DocXml, NodeFolders, "Folder", TaskItem.Name)
    End If
    
    pAddProp DocXml, Node, "Checked", TaskItem.Checked
    
    If TaskItem.Children.Count Then
      pSaveFoldersAux TaskItem.Children, _
                      pAddTag(DocXml, Node, "Folders", ""), _
                      pAddTag(DocXml, Node, "Files", ""), _
                      DocXml
    End If
  Next
End Sub

Private Sub pLoadFolders(ByRef DocXml As cXml, _
                         ByRef NodeFolders As Object)
  Dim Node As Object
  Dim TaskItem As cTaskItem
  
  If NodeFolders Is Nothing Then Exit Sub
  
  Set Node = DocXml.GetNodeChild(NodeFolders)
  
  While Not Node Is Nothing
  
    Set TaskItem = New cTaskItem
    m_Folders.Add TaskItem
    TaskItem.ItemType = csEIT_Folder
    TaskItem.Name = DocXml.GetNodeProperty(Node, "Value").Value(csText)
    TaskItem.Checked = DocXml.GetNodeProperty(Node, "Checked").Value(csBoolean)
    TaskItem.FullPath = TaskItem.Name
  
    If DocXml.NodeHasChild(Node) Then
      pLoadFoldersAux TaskItem.Children, _
                      DocXml, _
                      DocXml.GetNodeFromNode2(Node, "Folders"), _
                      DocXml.GetNodeFromNode2(Node, "Files"), _
                      TaskItem.Name
    End If
  
    Set Node = DocXml.GetNextNode(Node)
  Wend
End Sub

Private Sub pLoadFoldersAux(ByRef TaskItems As Collection, _
                            ByRef DocXml As cXml, _
                            ByRef NodeFolders As Object, _
                            ByRef NodeFiles As Object, _
                            ByVal FullPath As String)
  Dim Node     As Object
  Dim TaskItem As cTaskItem
  
  If LenB(FullPath) Then FullPath = FullPath & "\"
  
  If Not NodeFolders Is Nothing Then
  
    Set Node = DocXml.GetNodeChild(NodeFolders)
    
    While Not Node Is Nothing
      Set TaskItem = New cTaskItem
      TaskItems.Add TaskItem
      TaskItem.ItemType = csEIT_Folder
      TaskItem.Name = DocXml.GetNodeProperty(Node, "Value").Value(csText)
      TaskItem.Checked = DocXml.GetNodeProperty(Node, "Checked").Value(csBoolean)
      TaskItem.FullPath = FullPath & TaskItem.Name
      
      If DocXml.NodeHasChild(Node) Then
        pLoadFoldersAux TaskItem.Children, _
                        DocXml, _
                        DocXml.GetNodeFromNode2(Node, "Folders"), _
                        DocXml.GetNodeFromNode2(Node, "Files"), _
                        TaskItem.FullPath
      End If
      
      Set Node = DocXml.GetNextNode(Node)
    Wend
  
  End If
  
  If Not NodeFiles Is Nothing Then
  
    Set Node = DocXml.GetNodeChild(NodeFiles)
    
    While Not Node Is Nothing
      Set TaskItem = New cTaskItem
      TaskItems.Add TaskItem
      TaskItem.ItemType = csEIT_File
      TaskItem.Name = DocXml.GetNodeProperty(Node, "Value").Value(csText)
      TaskItem.Checked = DocXml.GetNodeProperty(Node, "Checked").Value(csBoolean)
      TaskItem.FullPath = FullPath & TaskItem.Name
      Set Node = DocXml.GetNextNode(Node)
    Wend
  End If
End Sub

Private Sub Class_Initialize()
  Set m_Folders = New Collection
End Sub

Private Sub Class_Terminate()
  Set m_Folders = Nothing
End Sub
