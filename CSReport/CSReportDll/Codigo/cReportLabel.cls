VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportLabel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportLabel
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
Private m_Aspect As cReportAspect
Private m_Text As String
Private m_CanGrow As Boolean
' eventos
' propiedades publicas
Public Property Get Aspect() As cReportAspect
  Set Aspect = m_Aspect
End Property

Public Property Set Aspect(ByRef rhs As cReportAspect)
  Set m_Aspect = rhs
End Property

Public Property Get Text() As String
  Text = m_Text
End Property

Public Property Let Text(ByVal rhs As String)
   m_Text = rhs
End Property

Public Property Get CanGrow() As Boolean
  CanGrow = m_CanGrow
End Property

Public Property Let CanGrow(ByVal rhs As Boolean)
   m_CanGrow = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
' funciones friend
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  Set NodObj = xDoc.GetNodeFromNode(NodObj, "Label")
  
  m_Text = xDoc.GetNodeProperty(NodObj, "Text").Value(csText)
  
  If Not m_Aspect.Load(xDoc, NodObj) Then Exit Function
  
  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    Set xProperty = New CSXml2.cXmlProperty
    
    xProperty.Name = "Label"
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
    
    xProperty.Name = "Text"
    xProperty.Value(csText) = m_Text
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "CanGrow"
    xProperty.Value(csBoolean) = m_CanGrow
    xDoc.AddPropertyToNode NodObj, xProperty
    
    If Not m_Aspect.Save(xDoc, NodObj) Then Exit Function
    Save = True
  End Function
#End If

' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Aspect = New cReportAspect
End Sub

Private Sub Class_Terminate()
  Set m_Aspect = Nothing
End Sub
