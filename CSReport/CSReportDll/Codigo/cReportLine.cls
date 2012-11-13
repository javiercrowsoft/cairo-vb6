VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportLine"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportLine
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
' eventos
' propiedades publicas
Public Property Get Aspect() As cReportAspect
  Set Aspect = m_Aspect
End Property

Public Property Set Aspect(ByRef rhs As cReportAspect)
  Set m_Aspect = rhs
End Property

' propiedades privadas
' funciones publicas
' funciones privadas
' funciones friend
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  Set NodObj = xDoc.GetNodeFromNode(NodObj, "Line")
  
  If Not m_Aspect.Load(xDoc, NodObj) Then Exit Function
  
  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    
    Set xProperty = New CSXml2.cXmlProperty
    
    xProperty.Name = "Line"
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
    
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
