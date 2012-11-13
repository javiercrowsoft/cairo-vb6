VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cRptDefLink"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cRptDefLink
' 14-04-2005

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cRptDefLink"

Private Const c_object = "object"
Private Const c_id = "id"
Private Const c_doct_id = "doct_id"
Private Const c_param_info = "param_info"
Private Const c_descrip = "descrip"
Private Const c_table = "table"

' estructuras
' variables privadas
Private m_Name                          As String
Private m_ObjectName                    As String
Private m_Id                            As String
Private m_Doct_id                       As String
Private m_ParamInfo                     As String
Private m_Descrip                       As String
Private m_Table                         As String
Private m_ObjManager                    As Object
Private m_CollDef                       As cRptDefLinks

' eventos
' propiedades publicas
Public Property Get Name() As String
  Name = m_Name
End Property

Public Property Let Name(ByVal rhs As String)
  m_Name = rhs
End Property

Public Property Get ObjectName() As String
  ObjectName = m_ObjectName
End Property

Public Property Let ObjectName(ByVal rhs As String)
  m_ObjectName = rhs
End Property

Public Property Get Id() As String
  Id = m_Id
End Property

Public Property Let Id(ByVal rhs As String)
  m_Id = rhs
End Property

Public Property Get Doct_id() As String
  Doct_id = m_Doct_id
End Property

Public Property Let Doct_id(ByVal rhs As String)
  m_Doct_id = rhs
End Property

Public Property Get ParamInfo() As String
  ParamInfo = m_ParamInfo
End Property

Public Property Let ParamInfo(ByVal rhs As String)
  m_ParamInfo = rhs
End Property

Public Property Get Descrip() As String
  Descrip = m_Descrip
End Property

Public Property Let Descrip(ByVal rhs As String)
  m_Descrip = rhs
End Property

Public Property Get Table() As String
  Table = m_Table
End Property

Public Property Let Table(ByVal rhs As String)
  m_Table = rhs
End Property

Public Property Get ObjManager() As Object
  If m_ObjManager Is Nothing Then
    Set m_ObjManager = GetObjManager(m_ObjectName)
  End If
  Set ObjManager = m_ObjManager
End Property

Public Property Get DefLinks() As cRptDefLinks
  Set DefLinks = m_CollDef
End Property

' propiedades friend
' propiedades privadas
' funciones publicas
Friend Function LoadChild(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  m_CollDef.Add().Load xDoc, NodObj
End Function

Friend Function Load(ByRef xDoc As CSXml2.cXml, ByRef NodObj As Object) As Boolean
  m_Name = NodObj.nodename
  m_ObjectName = xDoc.GetNodeProperty(NodObj, c_object).Value(csText)
  m_ParamInfo = xDoc.GetNodeProperty(NodObj, c_param_info).Value(csText)
  m_Doct_id = xDoc.GetNodeProperty(NodObj, c_doct_id).Value(csText)
  m_Id = xDoc.GetNodeProperty(NodObj, c_id).Value(csText)
  m_Descrip = xDoc.GetNodeProperty(NodObj, c_descrip).Value(csText)
  m_Table = xDoc.GetNodeProperty(NodObj, c_table).Value(csText)
  
  Load = True
End Function

' funciones friend
' funciones privadas
' construccion - destruccion
Private Sub Class_Initialize()
  On Error GoTo ControlError
  
  Set m_CollDef = New cRptDefLinks
  
  GoTo ExitProc
ControlError:
  MngError Err, "Class_Initialize", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
End Sub

Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_CollDef = Nothing
  Set m_ObjManager = Nothing
  DestroyObjManager m_ObjectName

  GoTo ExitProc
ControlError:
  MngError Err, "Class_Terminate", C_Module, vbNullString
  If Err.Number Then Resume ExitProc
ExitProc:
  On Error Resume Next
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


