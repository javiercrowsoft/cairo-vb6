VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportGroup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportGroup
' 30-06-01

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const c_Header As String = "H"
Private Const c_Footer As String = "F"
' estructuras
' variables privadas
Private m_Header As cReportSection
Private m_Footer As cReportSection
Private m_Indice As Integer

Private m_Name As String

Private m_OderType          As csRptGrpOrderType
Private m_ComparisonType    As csRptGrpComparisonType
Private m_PrintInNewPage    As Boolean ' cuando cambia el grupo lo imprime en una nueva pagina
Private m_RePrintInNewPage  As Boolean ' cuando cambia la pagina reimprime los grupos
Private m_GrandTotalGroup   As Boolean
Private m_FieldName         As String
Private m_Key               As String

' eventos
' propiedades publicas
Public Property Get Header() As cReportSection
  Set Header = m_Header
End Property

Public Property Set Header(ByRef rhs As cReportSection)
  Set m_Header = rhs
End Property

Public Property Get Footer() As cReportSection
  Set Footer = m_Footer
End Property

Public Property Set Footer(ByRef rhs As cReportSection)
  Set m_Footer = rhs
End Property

Public Property Get Indice() As Integer
  Indice = m_Indice
End Property

Public Property Let Indice(ByVal rhs As Integer)
   m_Indice = rhs
End Property

Public Property Get OderType() As csRptGrpOrderType
  OderType = m_OderType
End Property

Public Property Let OderType(ByRef rhs As csRptGrpOrderType)
  m_OderType = rhs
End Property

Public Property Get ComparisonType() As csRptGrpComparisonType
  ComparisonType = m_ComparisonType
End Property

Public Property Let ComparisonType(ByRef rhs As csRptGrpComparisonType)
  m_ComparisonType = rhs
End Property

Public Property Get PrintInNewPage() As Boolean
  PrintInNewPage = m_PrintInNewPage
End Property

Public Property Let PrintInNewPage(ByVal rhs As Boolean)
   m_PrintInNewPage = rhs
End Property

Public Property Get RePrintInNewPage() As Boolean
  RePrintInNewPage = m_RePrintInNewPage
End Property

Public Property Let RePrintInNewPage(ByVal rhs As Boolean)
   m_RePrintInNewPage = rhs
End Property

Public Property Get GrandTotalGroup() As Boolean
  GrandTotalGroup = m_GrandTotalGroup
End Property

Public Property Let GrandTotalGroup(ByVal rhs As Boolean)
   m_GrandTotalGroup = rhs
End Property

Public Property Get FieldName() As String
  FieldName = m_FieldName
End Property

Public Property Let FieldName(ByVal rhs As String)
   m_FieldName = rhs
End Property

Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get Key() As String
   Key = m_Key
End Property

Public Property Let Key(ByVal rhs As String)
    m_Key = rhs
End Property
' propiedades privadas

' funciones friend

Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  m_Name = xDoc.GetNodeProperty(NodObj, "Name").Value(csText)
  m_Indice = xDoc.GetNodeProperty(NodObj, "Indice").Value(csInteger)
  m_ComparisonType = xDoc.GetNodeProperty(NodObj, "ComparisonType").Value(csInteger)
  m_FieldName = xDoc.GetNodeProperty(NodObj, "FieldName").Value(csText)
  m_OderType = xDoc.GetNodeProperty(NodObj, "OderType").Value(csInteger)
  m_PrintInNewPage = xDoc.GetNodeProperty(NodObj, "PrintInNewPage").Value(csBoolean)
  m_RePrintInNewPage = xDoc.GetNodeProperty(NodObj, "RePrintInNewPage").Value(csBoolean)
  m_GrandTotalGroup = xDoc.GetNodeProperty(NodObj, "GrandTotalGroup").Value(csBoolean)
  
  pSetName
  
  Dim NodObjAux As Object
  
  Set NodObjAux = NodObj
  Set NodObjAux = xDoc.GetNodeFromNode(NodObj, c_Header)
  Set NodObjAux = xDoc.GetNodeChild(NodObjAux)
  If Not m_Header.Load(xDoc, NodObjAux) Then Exit Function
  
  m_Header.Name = m_Name
  
  Set NodObjAux = NodObj
  Set NodObjAux = xDoc.GetNodeFromNode(NodObj, c_Footer)
  Set NodObjAux = xDoc.GetNodeChild(NodObjAux)
  If Not m_Footer.Load(xDoc, NodObjAux) Then Exit Function
  
  m_Footer.Name = m_Name
  
  Load = True
End Function

Private Sub pSetName()
  If Left$(LCase$(m_Name), 5) = "group" _
  Or Left$(LCase$(m_Name), 5) = "grupo" _
  Or Left$(LCase$(m_Name), 3) = "gh_" _
  Or Left$(LCase$(m_Name), 3) = "gf_" _
  Or Left$(LCase$(m_Name), 2) = "g_" _
  Or LenB(m_Name) = 0 Then
    m_Name = "G_" & m_Indice
  End If

End Sub

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    
    Set xProperty = New CSXml2.cXmlProperty
    
    xProperty.Name = m_Name
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
    
    xProperty.Name = "Key"
    xProperty.Value(csText) = m_Key
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Name"
    xProperty.Value(csText) = m_Name
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Indice"
    xProperty.Value(csInteger) = m_Indice
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "ComparisonType"
    xProperty.Value(csInteger) = m_ComparisonType
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "FieldName"
    xProperty.Value(csText) = m_FieldName
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "OderType"
    xProperty.Value(csInteger) = m_OderType
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "PrintInNewPage"
    xProperty.Value(csBoolean) = m_PrintInNewPage
    xDoc.AddPropertyToNode NodObj, xProperty
        
    xProperty.Name = "RePrintInNewPage"
    xProperty.Value(csBoolean) = m_RePrintInNewPage
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "GrandTotalGroup"
    xProperty.Value(csBoolean) = m_GrandTotalGroup
    xDoc.AddPropertyToNode NodObj, xProperty
    
    Dim NodObjAux As Object
    Set NodObjAux = NodObj
    xProperty.Name = c_Header
    Set NodObjAux = xDoc.AddNodeToNode(NodObjAux, xProperty)
    m_Header.Save xDoc, NodObjAux
    
    Set NodObjAux = NodObj
    xProperty.Name = c_Footer
    Set NodObjAux = xDoc.AddNodeToNode(NodObjAux, xProperty)
    m_Footer.Save xDoc, NodObjAux
    
    Save = True
    
  End Function
#End If

' funciones publicas
' funciones privadas
' construccion - destruccion

Private Sub Class_Terminate()
  Set m_Header = Nothing
  Set m_Footer = Nothing
End Sub
