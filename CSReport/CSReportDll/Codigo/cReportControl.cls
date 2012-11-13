VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportControl
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
' estructuras
' variables privadas
Private m_Label                 As cReportLabel
Private m_Image                 As cReportImage
Private m_Line                  As cReportLine
Private m_Field                 As cReportField
Private m_TypeSection           As csRptTypeSection
Private m_Key                   As String
Private m_KeyPaint              As String
Private m_Name                  As String
Private m_HasFormulaHide        As Boolean
Private m_HasFormulaValue       As Boolean
Private m_ControlType           As csRptControlType
Private m_FormulaHide           As cReportFormula
Private m_FormulaValue          As cReportFormula
Private m_Chart                 As cReportChart
Private m_Tag                   As String
Private m_ExportColIdx          As Long
Private m_IsFreeCtrl            As Boolean

' Este puntero redundante es para poder saber cual es la
' coleccion en la que esta un control
Private m_SectionLine As cReportSectionLine
' eventos
' propiedades publicas

Public Property Get Label() As cReportLabel
  Set Label = m_Label
End Property

Public Property Set Label(ByRef rhs As cReportLabel)
  Set m_Label = rhs
End Property

Public Property Get Image() As cReportImage
  Set Image = m_Image
End Property

Public Property Set Image(ByRef rhs As cReportImage)
  m_Image = rhs
End Property

Public Property Get FormulaHide() As cReportFormula
  Set FormulaHide = m_FormulaHide
End Property

Public Property Get FormulaValue() As cReportFormula
  Set FormulaValue = m_FormulaValue
End Property

Public Property Get HasFormulaValue() As Boolean
  HasFormulaValue = m_HasFormulaValue
End Property

Public Property Let HasFormulaValue(ByVal rhs As Boolean)
  m_HasFormulaValue = rhs
End Property

Public Property Get Line() As cReportLine
  Set Line = m_Line
End Property

Public Property Set Line(ByRef rhs As cReportLine)
  Set m_Line = rhs
End Property

Public Property Get Field() As cReportField
  Set Field = m_Field
End Property

Public Property Set Field(ByRef rhs As cReportField)
   Set m_Field = rhs
End Property

Public Property Get Key() As String
  Key = m_Key
End Property

Public Property Let Key(ByVal rhs As String)
  m_Key = rhs
End Property

Public Property Get KeyPaint() As String
  KeyPaint = m_KeyPaint
End Property

Public Property Let KeyPaint(ByVal rhs As String)
  m_KeyPaint = rhs
End Property

Public Property Get Chart() As cReportChart
  Set Chart = m_Chart
End Property

Public Property Get Tag() As String
  Tag = m_Tag
End Property

Public Property Let Tag(ByVal rhs As String)
  m_Tag = rhs
End Property

' propiedades friend
Public Property Get TypeSection() As csRptTypeSection
  TypeSection = m_TypeSection
End Property

Public Property Let TypeSection(ByRef rhs As csRptTypeSection)
  m_TypeSection = rhs
End Property

Public Property Get SectionLine() As cReportSectionLine
  Set SectionLine = m_SectionLine
End Property

Public Property Set SectionLine(ByRef rhs As cReportSectionLine)
  Set m_SectionLine = rhs
End Property

Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get HasFormulaHide() As Boolean
  HasFormulaHide = m_HasFormulaHide
End Property

Public Property Let HasFormulaHide(ByVal rhs As Boolean)
  m_HasFormulaHide = rhs
End Property

Public Property Get ControlType() As csRptControlType
  ControlType = m_ControlType
End Property

Public Property Let ControlType(ByRef rhs As csRptControlType)
  m_ControlType = rhs
End Property

Public Property Let ExportColIdx(ByVal rhs As Long)
  m_ExportColIdx = rhs
End Property

Public Property Get ExportColIdx() As Long
  ExportColIdx = m_ExportColIdx
End Property

Public Property Let IsFreeCtrl(ByVal rhs As Boolean)
  m_IsFreeCtrl = rhs
End Property

Public Property Get IsFreeCtrl() As Boolean
  IsFreeCtrl = m_IsFreeCtrl
End Property

' propiedades privadas
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  m_KeyPaint = xDoc.GetNodeProperty(NodObj, "KeyPaint").Value(csText)
  m_Name = xDoc.GetNodeProperty(NodObj, "Name").Value(csText)
  
  On Error Resume Next
  
  m_HasFormulaHide = xDoc.GetNodeProperty(NodObj, "HasFormulaHide").Value(csBoolean)
  m_HasFormulaValue = xDoc.GetNodeProperty(NodObj, "HasFormulaValue").Value(csBoolean)
  m_ControlType = xDoc.GetNodeProperty(NodObj, "ControlType").Value(csInteger)
  m_Tag = xDoc.GetNodeProperty(NodObj, "Tag").Value(csText)
  
  m_ExportColIdx = xDoc.GetNodeProperty(NodObj, "ExportColIdx").Value(csLong)
  m_IsFreeCtrl = xDoc.GetNodeProperty(NodObj, "IsFreeCtrl").Value(csBoolean)
  
  On Error GoTo 0
  
  Dim NodObjAux As Object
  Set NodObjAux = NodObj
  If Not m_Field.Load(xDoc, NodObjAux) Then Exit Function
  Set NodObjAux = NodObj
  If Not m_Image.Load(xDoc, NodObjAux) Then Exit Function
  Set NodObjAux = NodObj
  If Not m_Label.Load(xDoc, NodObjAux) Then Exit Function
  Set NodObjAux = NodObj
  If Not m_Line.Load(xDoc, NodObjAux) Then Exit Function
  Set NodObjAux = NodObj
  If Not m_FormulaHide.Load(xDoc, NodObjAux) Then Exit Function
  Set NodObjAux = NodObj
  If Not m_FormulaValue.Load(xDoc, NodObjAux) Then Exit Function
  Set NodObjAux = NodObj
  If Not m_Chart.Load(xDoc, NodObjAux) Then Exit Function
  
  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    Set xProperty = New CSXml2.cXmlProperty
    
    xProperty.Name = m_Key
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
    
    xProperty.Name = "Key"
    xProperty.Value(csText) = m_Key
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Name"
    xProperty.Value(csText) = m_Name
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "KeyPaint"
    xProperty.Value(csText) = m_KeyPaint
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "HasFormulaHide"
    xProperty.Value(csBoolean) = m_HasFormulaHide
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "HasFormulaValue"
    xProperty.Value(csBoolean) = m_HasFormulaValue
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "ControlType"
    xProperty.Value(csInteger) = m_ControlType
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Tag"
    xProperty.Value(csText) = m_Tag
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "ExportColIdx"
    xProperty.Value(csLong) = m_ExportColIdx
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "IsFreeCtrl"
    xProperty.Value(csBoolean) = m_IsFreeCtrl
    xDoc.AddPropertyToNode NodObj, xProperty
    
    If Not m_Field.Save(xDoc, NodObj) Then Exit Function
    If Not m_Image.Save(xDoc, NodObj) Then Exit Function
    If Not m_Label.Save(xDoc, NodObj) Then Exit Function
    If Not m_Line.Save(xDoc, NodObj) Then Exit Function
    If Not m_FormulaHide.Save(xDoc, NodObj) Then Exit Function
    If Not m_FormulaValue.Save(xDoc, NodObj) Then Exit Function
    If Not m_Chart.Save(xDoc, NodObj) Then Exit Function
    Save = True
  End Function
#End If
' funciones publicas
' funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
  Set m_Field = New cReportField
  Set m_Image = New cReportImage
  Set m_Label = New cReportLabel
  Set m_Line = New cReportLine
  Set m_Chart = New cReportChart
  Set m_FormulaHide = New cReportFormula
  Set m_FormulaValue = New cReportFormula
  m_FormulaHide.Name = "H"
  m_FormulaValue.Name = "V"
End Sub

Private Sub Class_Terminate()
  Set m_Field = Nothing
  Set m_Image = Nothing
  Set m_Label = Nothing
  Set m_Line = Nothing
  Set m_SectionLine = Nothing
  Set m_FormulaHide = Nothing
  Set m_FormulaValue = Nothing
  Set m_Chart = Nothing
End Sub

