VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportField"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportField
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
' estructuras
' variables privadas
Private m_Name As String
Private m_Index As Integer
Private m_FieldType As Integer
' eventos
' propiedades publicas
Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get Index() As Integer
  Index = m_Index
End Property

Public Property Let Index(ByVal rhs As Integer)
  m_Index = rhs
End Property

Public Property Get FieldType() As Integer
  FieldType = m_FieldType
End Property

Public Property Let FieldType(ByVal rhs As Integer)
  m_FieldType = rhs
End Property
' propiedades privadas
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  Set NodObj = xDoc.GetNodeFromNode(NodObj, "Field")
  m_Index = xDoc.GetNodeProperty(NodObj, "Index").Value(csInteger)
  m_Name = xDoc.GetNodeProperty(NodObj, "Name").Value(csText)
  m_FieldType = xDoc.GetNodeProperty(NodObj, "FieldType").Value(csInteger)
  
  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    
    Set xProperty = New CSXml2.cXmlProperty
    
    xProperty.Name = "Field"
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
    
    xProperty.Name = "Index"
    xProperty.Value(csInteger) = m_Index
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Name"
    xProperty.Value(csText) = m_Name
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "FieldType"
    xProperty.Value(csInteger) = m_FieldType
    xDoc.AddPropertyToNode NodObj, xProperty
    
    Save = True
  End Function
#End If
' funciones publicas
' funciones privadas
' construccion - destruccion

