VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportPageField"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportPageField
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
Private Const C_Module As String = "cReportPageField"
' estructuras
' variables privadas
Private m_Value     As String
Private m_Info      As cReportPageInfo
Private m_Visible   As Boolean
Private m_ObjectID  As cReportPageID
Private m_IndexLine As Long
Private m_Top       As Single
Private m_Height    As Single
Private m_Width     As Single
Private m_hImage    As Long
' eventos
' propiedades publicas
Public Property Get Value() As String
  Value = m_Value
End Property

Public Property Let Value(ByVal rhs As String)
  m_Value = rhs
End Property

Public Property Get Info() As cReportPageInfo
  Set Info = m_Info
End Property

Public Property Set Info(ByRef rhs As cReportPageInfo)
  Set m_Info = rhs
End Property

Public Property Get Visible() As Boolean
  Visible = m_Visible
End Property

Public Property Let Visible(ByVal rhs As Boolean)
   m_Visible = rhs
End Property

Public Property Get ObjectID() As cReportPageID
   Set ObjectID = m_ObjectID
End Property

Public Property Set ObjectID(ByRef rhs As cReportPageID)
  Set m_ObjectID = rhs
End Property

Public Property Get Top() As Single
  Top = m_Top
End Property

Public Property Let Top(ByVal rhs As Single)
  m_Top = rhs
End Property

Public Property Get Height() As Single
  Height = m_Height
End Property

Public Property Let Height(ByVal rhs As Single)
   m_Height = rhs
End Property

Public Property Get Width() As Single
  Width = m_Width
End Property

Public Property Let Width(ByVal rhs As Single)
   m_Width = rhs
End Property

Public Property Get hImage() As Long
   hImage = m_hImage
End Property

Public Property Let hImage(ByVal rhs As Long)
   m_hImage = rhs
End Property

Public Property Get IndexLine() As Long
  IndexLine = m_IndexLine
End Property

Friend Property Let IndexLine(ByVal rhs As Long)
  m_IndexLine = rhs
End Property
' propiedades privadas
' funciones publicas
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean

  Set m_ObjectID = New cReportPageID
  Set m_Info = New cReportPageInfo

  m_Value = xDoc.GetNodeProperty(NodObj, "Value").Value(csText)
  m_Visible = xDoc.GetNodeProperty(NodObj, "Visible").Value(csBoolean)
  m_Top = xDoc.GetNodeProperty(NodObj, "Top").Value(csLong)
  m_Height = xDoc.GetNodeProperty(NodObj, "Height").Value(csLong)
  m_Width = xDoc.GetNodeProperty(NodObj, "Width").Value(csLong)

  Dim NodObjAux As Object
  Set NodObjAux = NodObj
  If Not m_ObjectID.Load(xDoc, NodObjAux) Then Exit Function
  Set NodObjAux = NodObj
  If Not m_Info.Load(xDoc, NodObjAux) Then Exit Function

  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    Set xProperty = New CSXml2.cXmlProperty
  
    xProperty.Name = "Field"
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
  
    xProperty.Name = "Value"
    xProperty.Value(csText) = m_Value
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Visible"
    xProperty.Value(csBoolean) = m_Visible
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Top"
    xProperty.Value(csLong) = m_Top
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Height"
    xProperty.Value(csLong) = m_Height
    xDoc.AddPropertyToNode NodObj, xProperty
  
    xProperty.Name = "Width"
    xProperty.Value(csLong) = m_Width
    xDoc.AddPropertyToNode NodObj, xProperty
  
    If Not m_ObjectID Is Nothing Then
      If Not m_ObjectID.Save(xDoc, NodObj) Then Exit Function
    End If
    If Not m_Info.Save(xDoc, NodObj) Then Exit Function
  
    Save = True
  End Function
#End If

Friend Function SaveForWeb(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
  Dim xProperty As CSXml2.cXmlProperty
  Dim NodObj As Object
  Set xProperty = New CSXml2.cXmlProperty

  xProperty.Name = "Field"
  Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)

  xProperty.Name = "Value"
  xProperty.Value(csText) = m_Value
  Set NodObj = xDoc.AddNodeToNode(NodObj, xProperty)
  xDoc.SetNodeText NodObj, m_Value

  SaveForWeb = True
End Function

' funciones privadas
' construccion - destruccion
Private Sub Class_Terminate()
  Set m_ObjectID = Nothing
  Set m_Info = Nothing
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

