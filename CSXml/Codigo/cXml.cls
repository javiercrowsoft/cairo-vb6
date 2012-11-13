VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cXml"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cXml
' 15-09-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cXml"
' estructuras
' variables privadas
Private m_Name                          As String
Private m_Path                          As String
Private m_DomDoc                        As DOMDocument
Private m_CommDialog                    As Object
Private m_Filter                        As String

' eventos
' propiedades publicas
Public Property Get Name() As String
   Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get Path() As String
  If Right(m_Path, 1) = "\" Then
    Path = m_Path
  Else
    Path = m_Path & "\"
  End If
End Property

Public Property Let Path(ByVal rhs As String)
   m_Path = rhs
End Property

Public Property Get Filter() As String
   Filter = m_Filter
End Property

Public Property Let Filter(ByVal rhs As String)
   m_Filter = rhs
End Property

' propiedades privadas
' funciones publicas
Public Sub Init(ByRef CommDialog As Object)
  Set m_CommDialog = CommDialog
End Sub

Public Function OpenXmlWithDialog() As Boolean
  On Error GoTo ControlError

  Dim File As cFile
  Dim msg  As String
  
  Set File = New cFile
    
  File.Filter = m_Filter
    
  File.Init "OpenXmlWithDialog", C_Module, m_CommDialog
    
  Dim bExiste       As Boolean
  Dim bReadonly     As Boolean
    
  If Not File.FOpen(m_Name, csRead, False, False, csLockReadWrite, True, True) Then Exit Function

  m_Name = File.Name
  m_Path = File.Path

  Set File = Nothing
  
  OpenXmlWithDialog = OpenXml()
  
  GoTo ExitProc
ControlError:
  MngError Err, "OpenXmlWithDialog", C_Module, "Error al abrir el archivo " & m_Name
ExitProc:
End Function

Public Function OpenXml() As Boolean
  On Error GoTo ControlError

  Set m_DomDoc = Nothing
  Set m_DomDoc = New DOMDocument
  
  Dim File As String
  
  m_DomDoc.async = False
  
  File = Path & m_Name
  
  CSKernelClient2.Title = "Abrir archivo"
  
  Dim FileEx As cFileEx
  Set FileEx = New cFileEx
  
  If FileEx.FileExists(File) Then
    If Not m_DomDoc.Load(File) Then
      MsgWarning "No se pudo cargar el archivo.;;" & File & ";;Error: " & m_DomDoc.parseError.reason
      Exit Function
    End If
  Else
    MsgWarning "El archivo;;" & File & ";;no existe."
    Exit Function
  End If
  
  OpenXml = True

  GoTo ExitProc
ControlError:
  MngError Err, "OpenXml", C_Module, "Error al cargar el archivo " & m_Name
ExitProc:
End Function

Public Function NewXmlWithDialog() As Boolean
  On Error GoTo ControlError

  Dim File As cFile
  Dim msg  As String
  
  Set File = New cFile
    
  File.Init "NewXmlWithDialog", C_Module, m_CommDialog
  File.Filter = m_Filter
  
  Dim bExiste       As Boolean
  Dim bReadonly     As Boolean
    
  If Not File.FSave(m_Name, bExiste, bReadonly) Then Exit Function
  
  If bExiste And bReadonly Then
    msg = "El archivo ya existe y es de solo lectura. ¿Desea reemplazarlo?"
  ElseIf bExiste Then
    If m_Name <> File.Name Then
      msg = "El archivo ya existe. ¿Desea reemplazarlo?"
    End If
  End If
  
  If msg <> "" Then
    If Not Ask(msg, vbNo, "Guardando") Then Exit Function
  End If
  
  m_Name = File.Name
  m_Path = File.Path
  
  Set File = Nothing
  
  NewXmlWithDialog = NewXml()
  
  GoTo ExitProc
ControlError:
  MngError Err, "NewXmlWithDialog", C_Module, "Error al crear el archivo " & m_Name
ExitProc:
End Function

Public Function NewXml() As Boolean
  On Error GoTo ControlError

  Set m_DomDoc = Nothing
  Set m_DomDoc = New DOMDocument
  
  Dim Node As IXMLDOMElement
  
  Set Node = m_DomDoc.createNode(NODE_ELEMENT, "Root", "")
  
  m_DomDoc.appendChild Node
  
  NewXml = True

  GoTo ExitProc
ControlError:
  MngError Err, "NewXml", C_Module, "Error al crear el archivo " & m_Name
ExitProc:
End Function

Public Function SaveWithDialog() As Boolean
  On Error GoTo ControlError

  Dim File As cFile
  
  Set File = New cFile
  
  If Not File.FOpen(m_Name, csWrite, False, False, csLockWrite) Then Exit Function
  
  m_Name = File.Name
  m_Path = File.Path
  
  Set File = Nothing
  
  SaveWithDialog = Save()
  
  GoTo ExitProc
ControlError:
  MngError Err, "SaveWithDialog", C_Module, "Error al guardar el archivo " & m_Name
ExitProc:
End Function

Public Sub SetNodeText(ByRef Node As IXMLDOMElement, ByVal Text As String)
  Node.nodeValue = Text
End Sub

Public Function Save() As Boolean
  On Error GoTo ControlError

  m_DomDoc.async = False
  m_DomDoc.Save Path & m_Name
  
  Save = True

  GoTo ExitProc
ControlError:
  MngError Err, "Save", C_Module, "Error al guardar el archivo " & m_Name
ExitProc:
End Function

Public Function AddProperty(ByRef xProperty As cXmlProperty) As Boolean
  AddPropertyToNodeByTag "Root", xProperty
End Function

Public Function AddPropertyToNodeByTag(ByVal NodeTag As String, ByRef xProperty As cXmlProperty) As Boolean
  With m_DomDoc.getElementsByTagName(NodeTag)
    AddPropertyToNodeByTag = AddPropertyToNode(.Item(0), xProperty)
  End With
End Function

Public Function AddPropertyToNode(ByRef Node As IXMLDOMElement, ByRef xProperty As cXmlProperty) As Boolean
  Dim Attr As IXMLDOMAttribute
  
  Set Attr = m_DomDoc.createAttribute(xProperty.Name)
  Attr.Value = xProperty.Value(csVariant)
  
  Node.setAttributeNode Attr
  
  AddPropertyToNode = True
End Function

Public Function AddBinaryPropertyToNode(ByRef Node As IXMLDOMElement, ByRef xProperty As cXmlProperty) As Boolean
  Dim Attr As IXMLDOMAttribute
  
  Set Attr = m_DomDoc.createAttribute(xProperty.Name)
  
  Attr.dataType = "bin.base64"
  Attr.nodeTypedValue = xProperty.BinaryValue
  
  Node.setAttributeNode Attr
  
  AddBinaryPropertyToNode = True
End Function

Public Function AddNode(ByRef xProperty As cXmlProperty) As IXMLDOMElement
  Set AddNode = AddNodeToNodeByTag("Root", xProperty)
End Function

Public Function AddNodeToNodeByTag(ByVal NodeTag As String, ByRef xProperty As cXmlProperty) As IXMLDOMElement
  With m_DomDoc.getElementsByTagName(NodeTag)
    Set AddNodeToNodeByTag = AddNodeToNode(.Item(0), xProperty)
  End With
  
End Function

Public Function AddNodeToNode(ByRef NodeFather As IXMLDOMElement, ByRef xProperty As cXmlProperty) As IXMLDOMElement
  Dim Node As IXMLDOMElement
  
  Set Node = m_DomDoc.createNode(NODE_ELEMENT, xProperty.Name, "")

  NodeFather.appendChild Node
  
  Set AddNodeToNode = Node
End Function

Public Function GetRootNode() As IXMLDOMElement
  If m_DomDoc.getElementsByTagName("Root").length > 0 Then
    Set GetRootNode = m_DomDoc.getElementsByTagName("Root").Item(0)
  End If
End Function

Public Function GetNode(ByVal NodeTag As String) As IXMLDOMElement
  If m_DomDoc.getElementsByTagName(NodeTag).length > 0 Then
    Set GetNode = m_DomDoc.getElementsByTagName(NodeTag).Item(0)
  End If
End Function

Public Function GetNodeFromNode(ByRef Node As IXMLDOMElement, ByVal NodeTag As String) As IXMLDOMElement
  If Node.getElementsByTagName(NodeTag).length > 0 Then
    Set GetNodeFromNode = Node.getElementsByTagName(NodeTag).Item(0)
  End If
End Function

Public Function GetNodeChild(ByRef Node As IXMLDOMElement) As IXMLDOMElement
  If NodeHasChild(Node) Then
    Set GetNodeChild = Node.childNodes(0)
  Else
    Set GetNodeChild = Nothing
  End If
End Function

Public Function GetNextNode(ByRef Node As IXMLDOMElement) As IXMLDOMElement
  Set GetNextNode = Node.nextSibling
End Function

Public Function GetNodeValue(ByRef Node As IXMLDOMElement) As cXmlProperty
  Dim o As cXmlProperty
  Set o = New cXmlProperty
  o.Value(csText) = Node.tagName
  GetNodeValue = o
End Function

Public Function GetNodeProperty(ByRef Node As IXMLDOMElement, ByVal PropertyName As String) As cXmlProperty
  Dim o As cXmlProperty
  Set o = New cXmlProperty
  Dim txt As String
  
  If Not IsNull(Node.getAttribute(PropertyName)) Then
    txt = Node.getAttribute(PropertyName)
  End If
  
  txt = Replace(txt, vbLf, vbCrLf)
  o.Value(csVariant) = txt
  Set GetNodeProperty = o
End Function

Public Function GetBinaryNodeProperty(ByRef Node As IXMLDOMElement, ByVal PropertyName As String) As cXmlProperty
  Dim Attr As IXMLDOMAttribute
  Dim o As cXmlProperty
  Dim vBuffer() As Byte
  
  Set o = New cXmlProperty
  Set Attr = Node.getAttributeNode(PropertyName)
  If Not Attr Is Nothing Then
    Attr.dataType = "bin.base64"
    vBuffer = Attr.nodeTypedValue
  Else
    ReDim vBuffer(0)
  End If
  
  o.BinaryValue = vBuffer
  Set GetBinaryNodeProperty = o
End Function

Public Function NodeHasChild(ByRef Node As IXMLDOMElement) As Boolean
  NodeHasChild = Node.childNodes.length > 0
End Function
' funciones privadas
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError "", C_Module, ""
'ExitProc:

Private Sub Class_Initialize()
  Set m_DomDoc = New DOMDocument
End Sub

Private Sub Class_Terminate()
  Set m_DomDoc = Nothing
  Set m_CommDialog = Nothing
End Sub
