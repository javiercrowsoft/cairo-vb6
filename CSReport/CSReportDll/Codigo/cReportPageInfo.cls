VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportPageInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportPageInfo
' 05-11-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cReportPageInfo"
' estructuras
' variables privadas
Private m_Aspect          As cReportAspect
Private m_SectionLine     As cReportSectionLine
Private m_Name            As String
Private m_Tag             As String
Private m_FieldType       As Integer
' eventos
' propiedades publicas
Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
   m_Name = rhs
End Property

Public Property Get Tag() As String
  Tag = m_Tag
End Property

Public Property Let Tag(ByVal rhs As String)
   m_Tag = rhs
End Property

Public Property Get Aspect() As cReportAspect
  Set Aspect = m_Aspect
End Property

Public Property Set Aspect(ByRef rhs As cReportAspect)
  Set m_Aspect = rhs
End Property

Public Property Get SectionLine() As cReportSectionLine
  Set SectionLine = m_SectionLine
End Property

Public Property Set SectionLine(ByRef rhs As cReportSectionLine)
  Set m_SectionLine = rhs
End Property

Public Property Get FieldType() As Integer
  FieldType = m_FieldType
End Property

Public Property Let FieldType(ByVal rhs As Integer)
  m_FieldType = rhs
End Property
' propiedades privadas
' funciones publicas
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  Dim NodObjAspect As Object

  On Error Resume Next

  m_Name = xDoc.GetNodeProperty(NodObj, "Name").Value(csText)
  m_FieldType = xDoc.GetNodeProperty(NodObj, "FieldType").Value(csInteger)

  Set NodObjAspect = NodObj
  If Not m_Aspect.Load(xDoc, NodObjAspect) Then Exit Function

  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
  
    Set xProperty = New CSXml2.cXmlProperty
  
    xProperty.Name = "PageInfo"
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
  
    xProperty.Name = "Name"
    xProperty.Value(csText) = m_Name
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "FieldType"
    xProperty.Value(csInteger) = m_FieldType
    xDoc.AddPropertyToNode NodObj, xProperty
    
    If Not m_Aspect.Save(xDoc, NodObj) Then Exit Function
  
    Save = True
  End Function
#End If

' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Aspect = New cReportAspect
End Sub

Private Sub Class_Terminate()
  Set m_Aspect = Nothing
  Set m_SectionLine = Nothing
End Sub
'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'  If Err.Number Then Resume ExitProc
'ExitProc:
'  On Error Resume Next

