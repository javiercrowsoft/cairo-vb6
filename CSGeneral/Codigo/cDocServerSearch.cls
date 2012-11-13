VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cDocServerSearch"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'--------------------------------------------------------------------------------
' cDocServerSearch
' 19-04-2005

'--------------------------------------------------------------------------------
' notas:

'--------------------------------------------------------------------------------
' api win32
    ' constantes
    ' estructuras
    ' funciones

'--------------------------------------------------------------------------------

' constantes
Private Const C_Module = "cDocServerSearch"
' estructuras
' variables privadas
Private m_DoctId              As Long
Private m_bClientDoSearch     As Boolean
Private m_ObjectClient        As Object
' eventos
' propiedades publicas
Public Function Search(ByRef Filters As cIABMProperties, _
                       ByRef Fields As Collection, _
                       ByVal DoctId As Long, _
                       ByVal bClientDoSearch As Boolean, _
                       ByRef ObjectClient As Object) As cSearchResult
                       
  Dim DialogSearch As cDialogSearch
  
  Set DialogSearch = New cDialogSearch
  Set DialogSearch.ObjAbm = New CSABMInterface2.cABMGeneric
  
  m_DoctId = DoctId
  m_bClientDoSearch = bClientDoSearch
  Set m_ObjectClient = ObjectClient
  
  Set Search = DialogSearch.Search(Filters, Fields, Me)
End Function

Public Function GetRows(ByVal ToSearch As String, _
                        ByVal SearchType As csESearchType, _
                        ByRef Filters As cIABMProperties, _
                        ByRef Fields As Collection) As ADODB.Recordset
  If m_bClientDoSearch Then
    Set GetRows = m_ObjectClient.GetRows(ToSearch, SearchType, Filters, Fields)
  Else
    Set GetRows = pGetRows(ToSearch, SearchType, Filters, Fields)
  End If
End Function

Public Sub SetResult(ByRef rslt As cSearchResult, _
                     ByRef iProp As cIABMProperty)
  Dim Row As cIABMGridRow
  Set Row = iProp.Grid.Rows.Item(iProp.SelectedIndex)
  rslt.Id = Val(pCell(Row, c_compId).Value)
  rslt.DoctId = Val(pCell(Row, c_doctId).Value)
End Sub
' propiedades friend
' propiedades privadas
' funciones publicas
' funciones friend
' funciones privadas
Private Function pGetRows(ByVal ToSearch As String, _
                          ByVal SearchType As csESearchType, _
                          ByRef Filters As cIABMProperties, _
                          ByRef Fields As Collection) As ADODB.Recordset
  Dim sqlstmt As String
  Dim rs      As ADODB.Recordset
  
  sqlstmt = "sp_DocSearch " & pGetParams(ToSearch, SearchType, Filters, Fields)
  If Not gDB.OpenRs(sqlstmt, rs) Then Exit Function
  
  Set pGetRows = rs
End Function

Private Function pGetParams(ByVal ToSearch As String, _
                            ByVal SearchType As csESearchType, _
                            ByRef Filters As cIABMProperties, _
                            ByRef Fields As Collection) As String
  Dim params          As String
  Dim fieldsToSearch  As Long
  
  params = gDB.sqlString(ToSearch) & "," & SearchType & ","
  
  If ExistsStandarTypeInColl(Fields, c_FieldNumero) Then
    fieldsToSearch = fieldsToSearch + csEDocFieldNumero
  End If
  If ExistsStandarTypeInColl(Fields, c_FieldComprobante) Then
    fieldsToSearch = fieldsToSearch + csEDocFieldComprobante
  End If
  If ExistsStandarTypeInColl(Fields, c_FieldTotal) Then
    fieldsToSearch = fieldsToSearch + csEDocFieldTotal
  End If
  If ExistsStandarTypeInColl(Fields, c_FieldObservaciones) Then
    fieldsToSearch = fieldsToSearch + csEDocFieldObservaciones
  End If
  
  If ExistsStandarTypeInColl(Fields, c_FieldCodigo) Then
    fieldsToSearch = fieldsToSearch + csEDocFieldCodigo
  End If
  If ExistsStandarTypeInColl(Fields, c_FieldCodigo2) Then
    fieldsToSearch = fieldsToSearch + csEDocFieldCodigo2
  End If
  If ExistsStandarTypeInColl(Fields, c_FieldCodigo3) Then
    fieldsToSearch = fieldsToSearch + csEDocFieldCodigo3
  End If
  If ExistsStandarTypeInColl(Fields, c_FieldCodigo4) Then
    fieldsToSearch = fieldsToSearch + csEDocFieldCodigo4
  End If
  If ExistsStandarTypeInColl(Fields, c_FieldContacto) Then
    fieldsToSearch = fieldsToSearch + csEDocFieldContacto
  End If
  
  Dim fDesde As Date
  Dim fHasta As Date
  
  If IsDate(Filters.Item(c_FechaIni).Value) Then
    fDesde = Filters.Item(c_FechaIni).Value
  Else
    fDesde = VDGetDateById(csYear_FirstDay)
  End If
  If IsDate(Filters.Item(c_FechaFin).Value) Then
    fHasta = Filters.Item(c_FechaFin).Value
  Else
    fHasta = VDGetDateById(csToday)
  End If
  
  params = params & fieldsToSearch & ","
  
  ' propiedades
  '
  params = params & pGetHelpId(cscDoctId, Filters)
  params = params & gDB.sqlDate(fDesde) & ","
  params = params & gDB.sqlDate(fHasta) & ","
  params = params & pGetHelpId(cscCliId, Filters)
  params = params & pGetHelpId(cscProvId, Filters)
  params = params & pGetHelpId(cscEstId, Filters)
  params = params & pGetHelpId(cscSucId, Filters)
  params = params & pGetHelpId(cscVenId, Filters)
  params = params & pGetHelpId(cscCueId, Filters)
  params = params & pGetHelpId(cscBcoId, Filters)
  params = params & pGetHelpId(cscBarcId, Filters)
  params = params & pGetHelpId(cscDocId, Filters)
  params = params & pGetHelpId(cscEmpId, Filters)
  
  pGetParams = RemoveLastColon(params)
End Function

Private Function pGetHelpId(ByVal Key As String, _
                            ByVal Properties As cIABMProperties) As String
  On Error Resume Next
  Dim rtn As Long
  
  rtn = Properties.Item(Key).HelpId
  pGetHelpId = rtn & ","
End Function

' construccion - destruccion
Private Sub Class_Terminate()
  On Error GoTo ControlError

  Set m_ObjectClient = Nothing

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
