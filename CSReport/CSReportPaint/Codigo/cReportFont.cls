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

Public Property Let ForeColor(ByVal RHS As Long)
  m_ForeColor = RHS
End Property

Public Property Get Size() As Single
   Size = m_Size
End Property

Public Property Let Size(ByVal RHS As Single)
   m_Size = RHS
End Property

Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal RHS As String)
  m_Name = RHS
End Property

Public Property Get UnderLine() As Boolean
  UnderLine = m_UnderLine
End Property

Public Property Let UnderLine(ByVal RHS As Boolean)
  m_UnderLine = RHS
End Property

Public Property Get Bold() As Boolean
  Bold = m_Bold
End Property

Public Property Let Bold(ByVal RHS As Boolean)
  m_Bold = RHS
End Property

Public Property Get Italic() As Boolean
  Italic = m_Italic
End Property

Public Property Let Italic(ByVal RHS As Boolean)
  m_Italic = RHS
End Property

Public Property Get Strike() As Boolean
  Strike = m_Strike
End Property

Public Property Let Strike(ByVal RHS As Boolean)
  m_Strike = RHS
End Property

' propiedades privadas
' funciones friend

#If CSReport Then
Friend Function Load(ByRef xDoc As cXml, ByRef NodObj As Object) As Boolean
  Set NodObj = xDoc.GetNodeFromNode(NodObj, "Font")
  
  m_Bold = xDoc.GetNodeProperty(NodObj, "Bold").Value
  m_ForeColor = xDoc.GetNodeProperty(NodObj, "ForeColor").Value
  m_Italic = xDoc.GetNodeProperty(NodObj, "Italic").Value
  m_Name = xDoc.GetNodeProperty(NodObj, "Name").Value
  m_Size = xDoc.GetNodeProperty(NodObj, "Size").Value
  m_UnderLine = xDoc.GetNodeProperty(NodObj, "UnderLine").Value
  m_Strike = xDoc.GetNodeProperty(NodObj, "Strike").Value
  
  Load = True
End Function

Friend Function Save(ByRef xDoc As cXml, ByRef NodeFather As Object) As Boolean
  Dim xProperty As cXmlProperty
  Dim NodObj    As Object
  Set xProperty = New cXmlProperty
  
  xProperty.Name = "Font"
  Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
  
  xProperty.Name = "ForeColor"
  xProperty.Value = m_ForeColor
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "Bold"
  xProperty.Value = m_Bold
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "Italic"
  xProperty.Value = m_Italic
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "Name"
  xProperty.Value = m_Name
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "Size"
  xProperty.Value = m_Size
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "UnderLine"
  xProperty.Value = m_UnderLine
  xDoc.AddPropertyToNode NodObj, xProperty
  
  xProperty.Name = "Strike"
  xProperty.Value = m_Strike
  xDoc.AddPropertyToNode NodObj, xProperty
  
  Save = True
End Function
#End If
' funciones publicas
' funciones privadas
' construccion - destruccion

Private Sub Class_Initialize()
  m_Name = "Tahoma"
  m_ForeColor = vbBlack
  m_Size = 8
End Sub

