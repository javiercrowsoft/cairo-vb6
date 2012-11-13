VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportFont"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportFont
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
Private m_ForeColor As Long
Private m_Size As Single
Private m_Name As String
Private m_UnderLine As Boolean
Private m_Bold As Boolean
Private m_Italic As Boolean
Private m_Strike As Boolean

' eventos
' propiedades publicas
Public Property Get ForeColor() As Long
  ForeColor = m_ForeColor
End Property

Public Property Let ForeColor(ByVal rhs As Long)
  m_ForeColor = rhs
End Property

Public Property Get Size() As Single
  Size = m_Size
End Property

Public Property Let Size(ByVal rhs As Single)
  m_Size = rhs
End Property

Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get UnderLine() As Boolean
  UnderLine = m_UnderLine
End Property

Public Property Let UnderLine(ByVal rhs As Boolean)
  m_UnderLine = rhs
End Property

Public Property Get Bold() As Boolean
  Bold = m_Bold
End Property

Public Property Let Bold(ByVal rhs As Boolean)
  m_Bold = rhs
End Property

Public Property Get Italic() As Boolean
  Italic = m_Italic
End Property

Public Property Let Italic(ByVal rhs As Boolean)
  m_Italic = rhs
End Property

Public Property Get Strike() As Boolean
  Strike = m_Strike
End Property

Public Property Let Strike(ByVal rhs As Boolean)
  m_Strike = rhs
End Property

' propiedades privadas
' funciones friend
#If CSReport Then
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  Set NodObj = xDoc.GetNodeFromNode(NodObj, "Font")
  m_Bold = xDoc.GetNodeProperty(NodObj, "Bold").Value(csBoolean)
  m_ForeColor = xDoc.GetNodeProperty(NodObj, "ForeColor").Value(csLong)
  m_Italic = xDoc.GetNodeProperty(NodObj, "Italic").Value(csBoolean)
  m_Name = xDoc.GetNodeProperty(NodObj, "Name").Value(csText)
  m_Size = xDoc.GetNodeProperty(NodObj, "Size").Value(csInteger)
  m_UnderLine = xDoc.GetNodeProperty(NodObj, "UnderLine").Value(csBoolean)
  m_Strike = xDoc.GetNodeProperty(NodObj, "Strike").Value(csBoolean)
  
  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    Set xProperty = New CSXml2.cXmlProperty
    
    xProperty.Name = "Font"
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
    
    xProperty.Name = "ForeColor"
    xProperty.Value(csLong) = m_ForeColor
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Bold"
    xProperty.Value(csBoolean) = m_Bold
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Italic"
    xProperty.Value(csBoolean) = m_Italic
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Name"
    xProperty.Value(csText) = m_Name
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Size"
    xProperty.Value(csInteger) = m_Size
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "UnderLine"
    xProperty.Value(csBoolean) = m_UnderLine
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Strike"
    xProperty.Value(csBoolean) = m_Strike
    xDoc.AddPropertyToNode NodObj, xProperty
    
    Save = True
  End Function
#End If
#End If
' funciones publicas
' funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
  m_Name = "Tahoma"
  m_ForeColor = vbBlack
  m_Size = 8
End Sub
