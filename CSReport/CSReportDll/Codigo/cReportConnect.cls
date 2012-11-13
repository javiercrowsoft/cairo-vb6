VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cReportConnect"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
'--------------------------------------------------------------------------------
' cReportConnect
' 01-11-2001

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
' constantes
' estructuras
' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module As String = "cReportConnect"

Private Const c_RptConnect As String = "RptConnect"
Private Const c_RptColumns As String = "Columns"
Private Const c_RptParameters As String = "Parameters"
' estructuras
' variables privadas
Private m_StrConnect As String
Private m_DataSource As String
Private m_DataSourceType As csDataSourceType

Private m_Parameters As cParameters
Private m_Columns As cColumnsInfo

Private m_ConnectionTimeout As Long
Private m_CommandTimeout As Long

' eventos
' propiedades publicas
Public Property Get ConnectionTimeout() As Long
   ConnectionTimeout = m_ConnectionTimeout
End Property

Public Property Let ConnectionTimeout(ByVal rhs As Long)
   m_ConnectionTimeout = rhs
End Property

Public Property Get CommandTimeout() As Long
   CommandTimeout = m_CommandTimeout
End Property

Public Property Let CommandTimeout(ByVal rhs As Long)
   m_CommandTimeout = rhs
End Property

Public Property Get StrConnect() As String
  StrConnect = m_StrConnect
End Property

Public Property Let StrConnect(ByVal rhs As String)
  m_StrConnect = rhs
End Property

Public Property Get DataBase() As String
  DataBase = GetXFromStrConnect(m_StrConnect, "Initial Catalog=")
End Property

Public Property Get Server() As String
  Server = GetXFromStrConnect(m_StrConnect, "Data Source=")
End Property

Public Property Get User() As String
  User = GetXFromStrConnect(m_StrConnect, "User ID=")
End Property

Public Property Get Password() As String
  Password = GetXFromStrConnect(m_StrConnect, "Password=")
End Property

Public Property Get DataSource() As String
  DataSource = m_DataSource
End Property

Public Property Let DataSource(ByVal rhs As String)
  m_DataSource = rhs
End Property

Public Property Get DataSourceType() As csDataSourceType
  DataSourceType = m_DataSourceType
End Property

Public Property Let DataSourceType(ByVal rhs As csDataSourceType)
   m_DataSourceType = rhs
End Property

Public Property Get Parameters() As cParameters
  Set Parameters = m_Parameters
End Property

Public Property Let Parameters(ByVal rhs As cParameters)
  Set m_Parameters = rhs
End Property

Public Property Get Columns() As cColumnsInfo
  Set Columns = m_Columns
End Property

Public Property Let Columns(ByVal rhs As cColumnsInfo)
  Set m_Columns = rhs
End Property

' funciones privadas
Public Property Get sqlParameters() As String
    Dim s As String
    Dim Param As cParameter
    For Each Param In m_Parameters
      With Param
        Select Case .TypeColumn
          Case CSDataBaseClient2.csDataType.csTDWChar, CSDataBaseClient2.csDataType.csTDVarWChar, CSDataBaseClient2.csDataType.csTDVarChar, CSDataBaseClient2.csDataType.csTDLongVarWChar, CSDataBaseClient2.csDataType.csTDLongVarChar, CSDataBaseClient2.csDataType.csTDChar
            s = s & "'" & Replace(.Value, "'", "''") & "',"
          Case CSDataBaseClient2.csDataType.csTDTinyInt, CSDataBaseClient2.csDataType.csTDUnsignedTinyInt, CSDataBaseClient2.csDataType.csTDSmallInt, CSDataBaseClient2.csDataType.csTDSingle, CSDataBaseClient2.csDataType.csTDNumeric, CSDataBaseClient2.csDataType.csTDInteger, CSDataBaseClient2.csDataType.csTDDouble, CSDataBaseClient2.csDataType.csTDDecimal, CSDataBaseClient2.csDataType.csTDCurrency, CSDataBaseClient2.csDataType.csTDBoolean, CSDataBaseClient2.csDataType.csTDBigInt
            s = s & GetNumberSql(.Value) & ","
          Case CSDataBaseClient2.csDataType.csTDDBTimeStamp, CSDataBaseClient2.csDataType.csTDDBTime, CSDataBaseClient2.csDataType.csTDDBDate, CSDataBaseClient2.csDataType.csTDDate
            s = s & Format(.Value, csSqlDateString) & ","
          Case Else
            MsgWarning "El tipo ado no esta codificado " & .TypeColumn & " del parametro " & .Name & ". debe ser agregado al case de la funcion sqlParameters."
        End Select
      End With
    Next Param
    
    If Right$(s, 1) = "," Then s = Left$(s, Len(s) - 1)
    
    sqlParameters = s
End Property
' propiedades privadas
' funciones publicas
' funciones friend
Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  Dim NodObjAux As Object
  Dim NodObjAux2 As Object

  m_DataSource = xDoc.GetNodeProperty(NodObj, "DataSource").Value(csText)
  m_DataSourceType = xDoc.GetNodeProperty(NodObj, "DataSourceType").Value(csInteger)
  m_StrConnect = xDoc.GetNodeProperty(NodObj, "StrConnect").Value(csText)
  
  Set NodObjAux2 = xDoc.GetNodeFromNode(NodObj, c_RptColumns)

  If xDoc.NodeHasChild(NodObjAux2) Then
    Set NodObjAux = xDoc.GetNodeChild(NodObjAux2)
    While Not NodObjAux Is Nothing
      If Not m_Columns.Add(, xDoc.GetNodeProperty(NodObjAux, "Key").Value(csText)).Load(xDoc, NodObjAux) Then Exit Function
      Set NodObjAux = xDoc.GetNextNode(NodObjAux)
    Wend
  End If

  Set NodObjAux2 = xDoc.GetNodeFromNode(NodObj, c_RptParameters)

  If xDoc.NodeHasChild(NodObjAux2) Then
    Set NodObjAux = xDoc.GetNodeChild(NodObjAux2)
    While Not NodObjAux Is Nothing
      If Not m_Parameters.Add(, xDoc.GetNodeProperty(NodObjAux, "Key").Value(csText)).Load(xDoc, NodObjAux) Then Exit Function
      Set NodObjAux = xDoc.GetNextNode(NodObjAux)
    Wend
  End If
  
  Load = True
End Function

#If Not PREPROC_SFS Then
  Friend Function Save(ByRef xDoc As CSXml2.cXml, ByRef NodeFather As Object) As Boolean
    Dim xProperty As CSXml2.cXmlProperty
    Dim NodObj As Object
    Dim NodObjAux As Object
    Set xProperty = New CSXml2.cXmlProperty
    
    xProperty.Name = c_RptConnect
    
    If Not NodeFather Is Nothing Then
      Set NodObj = xDoc.AddNodeToNode(NodeFather, xProperty)
    Else
      Set NodObj = xDoc.AddNode(xProperty)
    End If
    
    xProperty.Name = "DataSource"
    xProperty.Value(csText) = m_DataSource
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "DataSourceType"
    xProperty.Value(csInteger) = m_DataSourceType
    xDoc.AddPropertyToNode NodObj, xProperty
    
    xProperty.Name = "StrConnect"
    xProperty.Value(csText) = m_StrConnect
    xDoc.AddPropertyToNode NodObj, xProperty
    
    Set NodObjAux = NodObj
    
    xProperty.Name = c_RptColumns
    Set NodObj = xDoc.AddNodeToNode(NodObj, xProperty)
    
    Dim Col As cColumnInfo
    For Each Col In m_Columns
      If Not Col.Save(xDoc, NodObj) Then Exit Function
    Next Col
    
    Set NodObj = NodObjAux
    
    xProperty.Name = c_RptParameters
    Set NodObj = xDoc.AddNodeToNode(NodObj, xProperty)
    
    Dim Param As cParameter
    For Each Param In m_Parameters
      If Not Param.Save(xDoc, NodObj) Then Exit Function
    Next Param
    
    Save = True
  End Function
#End If

Private Function GetNumberSql(ByVal sNumber As String) As String
  If Not IsNumeric(sNumber) Then
    GetNumberSql = "0"
  Else
    sNumber = Format(sNumber, String$(27, "#") & "0." & String$(28, "#"))
    sNumber = Replace(sNumber, ",", ".")
    If Right$(sNumber, 1) = "." Then sNumber = Left$(sNumber, Len(sNumber) - 1)
    GetNumberSql = sNumber
  End If
End Function

Private Function GetXFromStrConnect(ByVal StrConnect As String, ByVal X As String) As String
  Dim i As Integer
  Dim p As Integer
  
  If Right$(X, 1) <> "=" Then X = X & "="
  i = InStr(1, StrConnect, X)
  If i > 0 Then
    p = InStr(i, StrConnect, ";")
    If p = 0 Then p = Len(StrConnect) + 1
    i = i + Len(X)
    GetXFromStrConnect = Mid$(StrConnect, i, p - i)
  End If
End Function

' construccion - destruccion
Private Sub Class_Initialize()
  Set m_Parameters = New cParameters
  Set m_Columns = New cColumnsInfo
End Sub

Private Sub Class_Terminate()
  Set m_Parameters = Nothing
  Set m_Columns = Nothing
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

