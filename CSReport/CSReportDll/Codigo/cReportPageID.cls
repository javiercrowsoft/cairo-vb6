VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportPageID"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportPageID
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
Private Const C_Module As String = "cReportPageID"
' estructuras
' variables privadas
Private m_Value As String
' eventos
' propiedades publicas
Public Property Get Value() As String
  Value = m_Value
End Property

Public Property Let Value(ByVal rhs As String)
  m_Value = rhs
End Property
' propiedades privadas
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  On Error Resume Next
  ' Puede no existir
  m_Value = xDoc.GetNodeProperty(NodObj, "Value").Value(csText)

  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    Set xProperty = New CSXml2.cXmlProperty
  
    xProperty.Name = "PageID"
    Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
  
    xProperty.Name = "Value"
    xProperty.Value(csText) = m_Value
    xDoc.AddPropertyToNode NodObj, xProperty
  
    Save = True
  End Function
#End If
' funciones publicas
' funciones friend
' funciones privadas
' construccion - destruccion

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

