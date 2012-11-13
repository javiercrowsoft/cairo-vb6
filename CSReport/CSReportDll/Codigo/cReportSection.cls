VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportSection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportSection
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
Private Const c_NodeRptSectionLines As String = "RptSectionLines"
' estructuras
' variables privadas
Private m_SectionLines    As cReportSectionLines
Private m_Aspect          As cReportAspect
Private m_Indice          As Integer
Private m_RealIndice      As Integer
Private m_Key             As String
Private m_Name            As String
Private m_KeyPaint        As String
Private m_FormulaHide     As cReportFormula
Private m_HasFormulaHide  As Boolean
' eventos
' propiedades publicas
Public Property Get SectionLines() As cReportSectionLines
  Set SectionLines = m_SectionLines
End Property

Public Property Set SectionLines(ByRef rhs As cReportSectionLines)
  Set m_SectionLines = rhs
End Property

Public Property Get Aspect() As cReportAspect
  Set Aspect = m_Aspect
End Property

Public Property Set Aspect(ByRef rhs As cReportAspect)
  Set m_Aspect = rhs
End Property

Public Property Get Indice() As Integer
  Indice = m_Indice
End Property

Public Property Let Indice(ByVal rhs As Integer)
   m_Indice = rhs
End Property

Public Property Get RealIndice() As Integer
  RealIndice = m_RealIndice
End Property

Public Property Let RealIndice(ByVal rhs As Integer)
   m_RealIndice = rhs
End Property

Public Property Get Key() As String
  Key = m_Key
End Property

Public Property Let Key(ByVal rhs As String)
   m_Key = rhs
End Property

Public Property Get TypeSection() As csRptTypeSection
  TypeSection = m_SectionLines.TypeSection
End Property

Public Property Let TypeSection(ByRef rhs As csRptTypeSection)
  m_SectionLines.TypeSection = rhs
End Property

Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Friend Property Set CopyColl(ByRef rhs As cReportControls2)
  If m_SectionLines Is Nothing Then Exit Property
  Set m_SectionLines.CopyColl = rhs
End Property

Public Property Get KeyPaint() As String
  KeyPaint = m_KeyPaint
End Property

Public Property Let KeyPaint(ByVal rhs As String)
  m_KeyPaint = rhs
End Property

Public Property Get HasFormulaHide() As Boolean
  HasFormulaHide = m_HasFormulaHide
End Property

Public Property Let HasFormulaHide(ByVal rhs As Boolean)
  m_HasFormulaHide = rhs
End Property

Public Property Get FormulaHide() As cReportFormula
  Set FormulaHide = m_FormulaHide
End Property

' propiedades privadas
' funciones publicas
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  Dim NodObjSecLn As Object
  Dim NodObjAspect As Object
  
  Dim SecLn As cReportSectionLine
  
  On Error Resume Next
  m_Name = xDoc.GetNodeProperty(NodObj, "Name").Value(csText)
  m_Indice = xDoc.GetNodeProperty(NodObj, "Indice").Value(csInteger)
  TypeSection = xDoc.GetNodeProperty(NodObj, "TypeSection").Value(csInteger)
  m_HasFormulaHide = xDoc.GetNodeProperty(NodObj, "HasFormulaHide").Value(csBoolean)
  
  Set NodObjAspect = NodObj
  If Not m_Aspect.Load(xDoc, NodObjAspect) Then Exit Function
  
  Dim NodObjAux As Object
  Set NodObjAux = NodObj
  If Not m_FormulaHide.Load(xDoc, NodObjAux) Then Exit Function
  
  m_SectionLines.Clear
  
  Set NodObj = xDoc.GetNodeFromNode(NodObj, c_NodeRptSectionLines)
  If xDoc.NodeHasChild(NodObj) Then
    Set NodObjSecLn = xDoc.GetNodeChild(NodObj)
    While Not NodObjSecLn Is Nothing
      Set SecLn = m_SectionLines.Add(, xDoc.GetNodeProperty(NodObjSecLn, "Key").Value(csText))
      If Not SecLn.Load(xDoc, NodObjSecLn) Then Exit Function
      SecLn.SectionName = m_Name
      Set NodObjSecLn = xDoc.GetNextNode(NodObjSecLn)
    Wend
  End If

  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    
    Set xProperty = New CSXml2.cXmlProperty
    
    xProperty.Name = m_Key
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
    
    xProperty.Name = "Name"
    xProperty.Value(csText) = m_Name
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Key"
    xProperty.Value(csText) = m_Key
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Indice"
    xProperty.Value(csInteger) = m_Indice
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "TypeSection"
    xProperty.Value(csInteger) = TypeSection
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "HasFormulaHide"
    xProperty.Value(csBoolean) = m_HasFormulaHide
    xDoc.AddPropertyToNode NodObj, xProperty
    
    If Not m_Aspect.Save(xDoc, NodObj) Then Exit Function
    If Not m_FormulaHide.Save(xDoc, NodObj) Then Exit Function
    
    xProperty.Name = c_NodeRptSectionLines
    xProperty.Value(csText) = vbNullString
    Set NodObj = xDoc.AddNodeToNode(NodObj, xProperty)
    
    Dim SeccLn As cReportSectionLine
    For Each SeccLn In m_SectionLines
      SeccLn.Save xDoc, NodObj
    Next SeccLn
    
    Save = True
  End Function
#End If
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_SectionLines = New cReportSectionLines
  Set m_Aspect = New cReportAspect
  
  Set m_FormulaHide = New cReportFormula
  m_FormulaHide.Name = "H"
  
  ' Cuando se crea una nueva seccion automaticamente la seccion
  ' agrega un sectionline
  m_SectionLines.Add
End Sub

Private Sub Class_Terminate()
  
  If Not m_SectionLines Is Nothing Then
    If Not m_SectionLines.CopyColl Is Nothing Then
      m_SectionLines.CopyColl.Clear
      Set m_SectionLines.CopyColl = Nothing
    End If
    Set m_SectionLines = Nothing
  End If
  
  Set m_Aspect = Nothing
  Set m_FormulaHide = Nothing
End Sub
