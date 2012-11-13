VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportSectionLine"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportSectionLine
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
Private Const c_NodeRptControls As String = "RptControls"

' estructuras
' variables privadas
Private m_Controls        As cReportControls
Private m_Aspect          As cReportAspect
Private m_Indice          As Integer
Private m_RealIndice      As Integer
Private m_Key             As String
Private m_KeyPaint        As String
Private m_FormulaHide     As cReportFormula
Private m_HasFormulaHide  As Boolean

' Es el nombre del campo que tiene el id que identifica al renglon
' cuando el usuario hace doble click en el renglon se llama a la
' funcion ShowDetails del objeto m_Link que dispara el evento
' ShowDetails de la interfaz Cliente de cReportLinkServer
Private m_IdField As String

' Para Debug
'
Private m_SectionName As String

' eventos

' propiedades publicas
Public Property Get KeyPaint() As String
   KeyPaint = m_KeyPaint
End Property

Public Property Let KeyPaint(ByVal rhs As String)
   m_KeyPaint = rhs
End Property

Public Property Get Controls() As cReportControls
  Set Controls = m_Controls
End Property

Public Property Set Controls(ByRef rhs As cReportControls)
  Set m_Controls = rhs
End Property

Public Property Get IdField() As String
  IdField = m_IdField
End Property

Public Property Let IdField(ByVal rhs As String)
   m_IdField = rhs
End Property

Public Property Get Key() As String
  Key = m_Key
End Property

Public Property Let Key(ByVal rhs As String)
  m_Key = rhs
End Property

Public Property Get Aspect() As cReportAspect
  Set Aspect = m_Aspect
End Property

Public Property Let Aspect(ByRef rhs As cReportAspect)
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

Public Property Get HasFormulaHide() As Boolean
  HasFormulaHide = m_HasFormulaHide
End Property

Public Property Let HasFormulaHide(ByVal rhs As Boolean)
  m_HasFormulaHide = rhs
End Property

Public Property Get FormulaHide() As cReportFormula
  Set FormulaHide = m_FormulaHide
End Property

' propiedades friend
Public Property Get TypeSection() As csRptTypeSection
  TypeSection = m_Controls.TypeSection
End Property

Public Property Let TypeSection(ByRef rhs As csRptTypeSection)
  m_Controls.TypeSection = rhs
End Property

Public Property Get SectionName() As String
 SectionName = m_SectionName
End Property

Public Property Let SectionName(ByVal rhs As String)
  m_SectionName = rhs
End Property

Friend Property Set CopyColl(ByRef rhs As cReportControls2)
  If m_Controls Is Nothing Then Exit Property
  Set m_Controls.CopyColl = rhs
End Property
' propiedades privadas
' funciones publicas
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  Dim NodObjCtrls  As Object
  Dim NodObjCtrl   As Object
  Dim NodObjAspect As Object
  
  Dim Ctrl As cReportControl

  m_Indice = xDoc.GetNodeProperty(NodObj, "Indice").Value(csInteger)
  m_IdField = xDoc.GetNodeProperty(NodObj, "IdField").Value(csText)
  m_HasFormulaHide = xDoc.GetNodeProperty(NodObj, "HasFormulaHide").Value(csBoolean)
  
  Set NodObjAspect = NodObj

  Dim NodObjAux As Object
  Set NodObjAux = NodObj
  If Not m_FormulaHide.Load(xDoc, NodObjAux) Then Exit Function
  
  If Not m_Aspect.Load(xDoc, NodObjAspect) Then Exit Function

  Set NodObjCtrls = xDoc.GetNodeFromNode(NodObj, c_NodeRptControls)

  If xDoc.NodeHasChild(NodObjCtrls) Then
    Set NodObjCtrl = xDoc.GetNodeChild(NodObjCtrls)

    While Not NodObjCtrl Is Nothing
      Set Ctrl = m_Controls.Add(, xDoc.GetNodeProperty(NodObjCtrl, "Key").Value(csText))
      If Not Ctrl.Load(xDoc, NodObjCtrl) Then Exit Function
      Set NodObjCtrl = xDoc.GetNextNode(NodObjCtrl)

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
    
    xProperty.Name = "Key"
    xProperty.Value(csText) = m_Key
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Indice"
    xProperty.Value(csInteger) = m_Indice
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "IdField"
    xProperty.Value(csText) = m_IdField
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "HasFormulaHide"
    xProperty.Value(csBoolean) = m_HasFormulaHide
    xDoc.AddPropertyToNode NodObj, xProperty
    
    If Not m_Aspect.Save(xDoc, NodObj) Then Exit Function
    If Not m_FormulaHide.Save(xDoc, NodObj) Then Exit Function
    
    xProperty.Name = c_NodeRptControls
    Set NodObj = xDoc.AddNodeToNode(NodObj, xProperty)
    
    Dim Ctrl As cReportControl
    For Each Ctrl In m_Controls
      Ctrl.Save xDoc, NodObj
    Next Ctrl
    
    Save = True
  End Function
#End If
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Controls = New cReportControls
  Set m_Controls.SectionLine = Me
  Set m_Aspect = New cReportAspect
  Set m_FormulaHide = New cReportFormula
  m_FormulaHide.Name = "H"
End Sub

Private Sub Class_Terminate()
  Set CopyColl = Nothing
  
  If Not m_Controls Is Nothing Then
    If Not m_Controls.CopyColl Is Nothing Then
      m_Controls.CopyColl.Clear
      Set m_Controls.CopyColl = Nothing
    End If
    m_Controls.Clear
    Set m_Controls = Nothing
  End If
  
  Set m_Aspect = Nothing
  Set m_FormulaHide = Nothing
End Sub
