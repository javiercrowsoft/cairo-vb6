VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportFormula"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cReportFormula
' 11-11-01

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
Private m_Text As String
Private m_FormulasInt As cReportFormulasInt
Private m_NotSave As Boolean
' Cuando compilo una funcion, parseo el texto y voy retirando
' del script las funciones internas. Cada funcion interna que
' encuentro en el script es agregada a la coleccion m_FormulasInt
' y reemplazada en el texto por una cadena $$$n donde n es el indice
' del item en m_FormulasInt que tiene la funcion. Luego cuando estoy
' ejecutando el codigo obtengo el resultado de todas las funciones que
' estan en m_FormulasInt y reemplazo en el script las cadenas $$$n con
' los valores correspondientes. Luego si hay script lo evaluo con
' el ScriptControl.
Private m_TextC       As String ' Texto compilado de una funcion
Private m_idxGroup    As Long
Private m_idxGroup2   As Long
Private m_WhenEval    As csRptWhenEval
Private m_HaveToEval  As Boolean
Private m_LastResult  As Variant

' Para Debug
'
Private m_ControlName       As String
Private m_SectionLineIndex  As Long
Private m_SectionName       As String

' eventos
' propiedades publicas
Public Property Get idxGroup() As Long
  idxGroup = m_idxGroup
End Property

Public Property Let idxGroup(ByVal rhs As Long)
  m_idxGroup = rhs
End Property

Public Property Get idxGroup2() As Long
  idxGroup2 = m_idxGroup2
End Property

Public Property Let idxGroup2(ByVal rhs As Long)
  m_idxGroup2 = rhs
End Property

Public Property Get WhenEval() As csRptWhenEval
  WhenEval = m_WhenEval
End Property

Public Property Let WhenEval(ByVal rhs As csRptWhenEval)
  m_WhenEval = rhs
End Property

Public Property Get Name() As String
 Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get Text() As String
  Text = m_Text
End Property

Public Property Let Text(ByVal rhs As String)
  m_Text = rhs
End Property

Public Property Get ControlName() As String
 ControlName = m_ControlName
End Property

Public Property Let ControlName(ByVal rhs As String)
  m_ControlName = rhs
End Property

Public Property Get SectionName() As String
 SectionName = m_SectionName
End Property

Public Property Let SectionName(ByVal rhs As String)
  m_SectionName = rhs
End Property

Public Property Get SectionLineIndex() As Long
 SectionLineIndex = m_SectionLineIndex
End Property

Public Property Let SectionLineIndex(ByVal rhs As Long)
  m_SectionLineIndex = rhs
End Property

' propiedades privadas
' propiedades Friend
Friend Property Get FormulasInt() As cReportFormulasInt
  Set FormulasInt = m_FormulasInt
End Property

Friend Property Get TextC() As String
  TextC = m_TextC
End Property

Friend Property Let TextC(ByVal rhs As String)
  m_TextC = rhs
End Property

Friend Property Get NotSave() As Boolean
  NotSave = m_NotSave
End Property

Friend Property Let NotSave(ByVal rhs As Boolean)
  m_NotSave = rhs
End Property

Friend Property Get HaveToEval() As Boolean
  HaveToEval = m_HaveToEval
End Property

Friend Property Let HaveToEval(ByVal rhs As Boolean)
  m_HaveToEval = rhs
End Property

Friend Property Get LastResult() As Variant
  LastResult = m_LastResult
End Property

Friend Property Let LastResult(ByVal rhs As Variant)
  m_LastResult = rhs
End Property

' funciones publicas
' funciones privadas
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean

  Set NodObj = xDoc.GetNodeFromNode(NodObj, m_Name)
  
  If Not NodObj Is Nothing Then
    m_Name = xDoc.GetNodeProperty(NodObj, "Name").Value(csText)
    m_Text = xDoc.GetNodeProperty(NodObj, "Text").Value(csText)
    m_idxGroup = xDoc.GetNodeProperty(NodObj, "idxGroup").Value(csLong)
    m_WhenEval = xDoc.GetNodeProperty(NodObj, "WhenEval").Value(csInteger)
  End If
  
  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    Set xProperty = New CSXml2.cXmlProperty
    
    xProperty.Name = m_Name
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
    
    xProperty.Name = "Name"
    xProperty.Value(csText) = m_Name
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Text"
    xProperty.Value(csText) = m_Text
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "idxGroup"
    xProperty.Value(csLong) = m_idxGroup
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "WhenEval"
    xProperty.Value(csInteger) = m_WhenEval
    xDoc.AddPropertyToNode NodObj, xProperty
    
    Save = True
  End Function
#End If

' construccion - destruccion
Private Sub Class_Initialize()
  Set m_FormulasInt = New cReportFormulasInt
  m_idxGroup2 = -9999
End Sub

Private Sub Class_Terminate()
  Set m_FormulasInt = Nothing
End Sub

