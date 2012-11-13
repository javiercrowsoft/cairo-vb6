VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cSQLServerTask"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

'--------------------------------------------------------------------------------
' cSQLServerTask
' 07-10-2007
'--------------------------------------------------------------------------------

Private m_Name     As String
Private m_File     As String
Private m_Descrip  As String
Private m_Code     As String

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
  m_Descrip = pGetChildNodeProperty(Root, DocXml, "Descrip", "Value")
      
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
  pAddTag DocXml, Root, "Descrip", m_Descrip
  
  Save = DocXml.Save(False)
End Function
