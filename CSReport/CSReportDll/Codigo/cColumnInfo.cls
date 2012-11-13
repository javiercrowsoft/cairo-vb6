VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cColumnInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cColumnInfo
' 30-10-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cColumnInfo"
' estructuras
' variables privadas
Private m_Name As String
#If CSReport Then
Private m_TypeColumn As CSDataBaseClient2.csDataType

#Else
Private m_TypeColumn                    As DataTypeEnum
#End If
Private m_Value As String
Private m_Position As Integer
Private m_Key As String

' eventos
' propiedades publicas
Public Property Get Key() As String
  Key = m_Key
End Property

Public Property Let Key(ByVal rhs As String)
  m_Key = rhs
End Property

Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get TypeColumn() As CSDataBaseClient2.csDataType
  TypeColumn = m_TypeColumn
End Property

Public Property Let TypeColumn(ByVal rhs As CSDataBaseClient2.csDataType)
  m_TypeColumn = rhs
End Property

Public Property Get Value() As String
  Value = m_Value
End Property

Public Property Let Value(ByVal rhs As String)
  m_Value = rhs
End Property

Public Property Get Position() As Integer
  Position = m_Position
End Property

Public Property Let Position(ByVal rhs As Integer)
  m_Position = rhs
End Property

#If CSReport Then

#Else
Public Property Get TypeColumn() As DataTypeEnum
  TypeColumn = m_TypeColumn
End Property

Public Property Let TypeColumn(ByVal rhs As DataTypeEnum)
  m_TypeColumn = rhs
End Property
#End If

' propiedades privadas
' funciones publicas
' funciones friend
#If CSReport Then

Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  m_TypeColumn = xDoc.GetNodeProperty(NodObj, "TypeColumn").Value(csInteger)
  m_Value = xDoc.GetNodeProperty(NodObj, "Value").Value(csText)
  m_Position = xDoc.GetNodeProperty(NodObj, "Position").Value(csInteger)
  m_Name = xDoc.GetNodeProperty(NodObj, "Name").Value(csText)
  m_Key = xDoc.GetNodeProperty(NodObj, "Key").Value(csText)
  
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
    
    xProperty.Name = "Position"
    xProperty.Value(csInteger) = m_Position
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "TypeColumn"
    xProperty.Value(csInteger) = m_TypeColumn
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "Value"
    xProperty.Value(csText) = m_Value
    xDoc.AddPropertyToNode NodObj, xProperty
  
    Save = True
  End Function
#End If

#End If
' funciones privadas
' construccion - destruccion

'//////////////////////////////
'  Codigo estandar de errores
'  On Error GoTo ControlError
'
'  GoTo ExitProc
'ControlError:
'  MngError err,"", C_Module, ""
'ExitProc:

